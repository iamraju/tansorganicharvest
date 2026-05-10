using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public class DatabaseHelper
{
    private static readonly string _connStr =
        ConfigurationManager.ConnectionStrings["TansDBContext"].ConnectionString;

    public static DataTable ExecuteQuery(string sql, SqlParameter[] p = null)
    {
        try
        {
            var dt = new DataTable();
            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.CommandTimeout = 10; // fail after 10 seconds, not 30
                if (p != null) cmd.Parameters.AddRange(p);
                conn.Open();
                new SqlDataAdapter(cmd).Fill(dt);
            }
            return dt;
        }
        catch (SqlException ex)
        {
            throw new Exception("Database error in ExecuteQuery: " + ex.Message, ex);
        }
    }

    public static int ExecuteNonQuery(string sql, SqlParameter[] p = null)
    {
        try
        {
            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.CommandTimeout = 10;
                if (p != null) cmd.Parameters.AddRange(p);
                conn.Open();
                return cmd.ExecuteNonQuery();
            }
        }
        catch (SqlException ex)
        {
            throw new Exception("Database error in ExecuteNonQuery: " + ex.Message, ex);
        }
    }

    public static object ExecuteScalar(string sql, SqlParameter[] p = null)
    {
        try
        {
            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.CommandTimeout = 10;
                if (p != null) cmd.Parameters.AddRange(p);
                conn.Open();
                return cmd.ExecuteScalar();
            }
        }
        catch (SqlException ex)
        {
            throw new Exception("Database error in ExecuteScalar: " + ex.Message, ex);
        }
    }

    // Test connection — call this to diagnose issues
    public static string TestConnection()
    {
        try
        {
            using (var conn = new SqlConnection(_connStr))
            {
                conn.Open();
                return "SUCCESS: Connected to " + conn.DataSource +
                       " | Database: " + conn.Database;
            }
        }
        catch (Exception ex)
        {
            return "FAILED: " + ex.Message;
        }
    }
}