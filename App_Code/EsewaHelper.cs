using System;
using System.Configuration;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Script.Serialization;

/// <summary>
/// Handles eSewa ePay v2 payment integration.
/// Signature algorithm: HMAC-SHA256 of
/// "total_amount={amount},transaction_uuid={uuid},product_code={code}"
/// encoded as Base64.
/// </summary>
public static class EsewaHelper
{
    // ── Config ──────────────────────────────────────────────────
    public static string ProductCode =>
        ConfigurationManager.AppSettings["Esewa:ProductCode"] ?? "EPAYTEST";

    public static string SecretKey =>
        ConfigurationManager.AppSettings["Esewa:SecretKey"] ?? "8gBm/:&EnhH.1/q";

    public static string GatewayUrl =>
        ConfigurationManager.AppSettings["Esewa:GatewayUrl"]
        ?? "https://rc-epay.esewa.com.np/api/epay/main/v2/form";

    public static string VerifyUrl =>
        ConfigurationManager.AppSettings["Esewa:VerifyUrl"]
        ?? "https://rc-epay.esewa.com.np/api/epay/transaction/status/";

    public static bool IsSandbox =>
        bool.Parse(ConfigurationManager.AppSettings["Esewa:IsSandbox"] ?? "true");

    // ── Signature ────────────────────────────────────────────────
    /// <summary>
    /// Generates HMAC-SHA256 Base64 signature.
    /// Message format: total_amount={amount},transaction_uuid={uuid},product_code={code}
    /// </summary>
    public static string GenerateSignature(decimal totalAmount, string transactionUuid)
    {
        // eSewa requires exactly 2 decimal places
        string message = string.Format(
            "total_amount={0},transaction_uuid={1},product_code={2}",
            totalAmount.ToString("F2"),
            transactionUuid,
            ProductCode);

        using (var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(SecretKey)))
        {
            byte[] hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(message));
            return Convert.ToBase64String(hash);
        }
    }

    /// <summary>
    /// Verifies the signature returned in eSewa's callback response.
    /// </summary>
    public static bool VerifySignature(decimal totalAmount, string transactionUuid,
        string receivedSignature)
    {
        string expected = GenerateSignature(totalAmount, transactionUuid);
        // Timing-safe comparison
        return SlowEquals(
            Encoding.UTF8.GetBytes(expected),
            Encoding.UTF8.GetBytes(receivedSignature));
    }

    /// <summary>
    /// Generates a unique transaction UUID for each payment.
    /// Format: orderId-timestamp to make it traceable.
    /// </summary>
    public static string GenerateTransactionUuid(int orderId)
    {
        return string.Format("{0}-{1}", orderId,
            DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
    }

    /// <summary>
    /// Decodes the Base64-encoded JSON data returned by eSewa in the
    /// success callback query parameter ?data=...
    /// </summary>
    public static EsewaCallbackData DecodeCallbackData(string base64Data)
    {
        try
        {
            // eSewa sometimes pads differently — fix padding
            string padded = base64Data.PadRight(
                base64Data.Length + (4 - base64Data.Length % 4) % 4, '=');

            byte[] bytes = Convert.FromBase64String(padded);
            string json = Encoding.UTF8.GetString(bytes);

            var serializer = new JavaScriptSerializer();
            return serializer.Deserialize<EsewaCallbackData>(json);
        }
        catch
        {
            return null;
        }
    }

    /// <summary>
    /// Calls eSewa's server-side status API to verify a transaction
    /// independently of the client callback (prevents tampering).
    /// </summary>
    public static async Task<EsewaStatusResponse> VerifyTransactionAsync(
        string transactionUuid, decimal totalAmount)
    {
        try
        {
            string url = string.Format(
                "{0}?product_code={1}&total_amount={2}&transaction_uuid={3}",
                VerifyUrl,
                HttpUtility.UrlEncode(ProductCode),
                totalAmount.ToString("F2"),
                HttpUtility.UrlEncode(transactionUuid));

            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(15);
                client.DefaultRequestHeaders.Add("Accept", "application/json");

                HttpResponseMessage response = await client.GetAsync(url);
                string body = await response.Content.ReadAsStringAsync();

                var serializer = new JavaScriptSerializer();
                return serializer.Deserialize<EsewaStatusResponse>(body);
            }
        }
        catch (Exception ex)
        {
            return new EsewaStatusResponse
            {
                status = "ERROR",
                message = ex.Message
            };
        }
    }

    // ── Timing-safe byte comparison ──────────────────────────────
    private static bool SlowEquals(byte[] a, byte[] b)
    {
        uint diff = (uint)a.Length ^ (uint)b.Length;
        int len = Math.Min(a.Length, b.Length);
        for (int i = 0; i < len; i++)
            diff |= (uint)(a[i] ^ b[i]);
        return diff == 0;
    }
}

// ── eSewa callback data model ─────────────────────────────────────
public class EsewaCallbackData
{
    public string transaction_code { get; set; }
    public string status { get; set; }
    public string total_amount { get; set; }
    public string transaction_uuid { get; set; }
    public string product_code { get; set; }
    public string signed_field_names { get; set; }
    public string signature { get; set; }
}

// ── eSewa status API response model ──────────────────────────────
public class EsewaStatusResponse
{
    public string product_code { get; set; }
    public string transaction_uuid { get; set; }
    public string total_amount { get; set; }
    public string status { get; set; }   // COMPLETE / PENDING / FAILED
    public string ref_id { get; set; }
    public string message { get; set; }
}