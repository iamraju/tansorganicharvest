using System.Web;
using System.Data.SqlClient;

public class AdminAuth
{
    private const string SessionKey = "AdminUser";

    // Call this on Admin Login to store session
    public static void SetAdminSession(string username, string fullName)
    {
        HttpContext.Current.Session[SessionKey] = username;
        HttpContext.Current.Session["AdminFullName"] = fullName;
    }

    // Check if admin is logged in
    public static bool IsLoggedIn()
    {
        return HttpContext.Current.Session[SessionKey] != null;
    }

    // Get logged-in admin username
    public static string GetUsername()
    {
        return HttpContext.Current.Session[SessionKey]?.ToString() ?? "";
    }

    // Get logged-in admin full name
    public static string GetFullName()
    {
        return HttpContext.Current.Session["AdminFullName"]?.ToString() ?? "";
    }

    public static void RedirectToLogin()
    {
        HttpContext.Current.Response.Redirect("~/Admin/AdminLogin.aspx");
    }

    // Validate credentials against DB
    public static bool ValidateLogin(string username, string password)
    {
        // In real app use proper hashing — for demo comparing directly
        string sql = @"SELECT COUNT(1) FROM AdminUsers 
                       WHERE Username = @u AND PasswordHash = @p AND IsActive = 1";
        var result = DatabaseHelper.ExecuteScalar(sql, new[]
        {
            new SqlParameter("@u", username),
            new SqlParameter("@p", password)
        });
        return result != null && (int)result > 0;
    }

    // Clear session on logout
    public static void Logout()
    {
        HttpContext.Current.Session.Clear();
        HttpContext.Current.Session.Abandon();
    }
}