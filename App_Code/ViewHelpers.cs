// App_Code/ViewHelpers.cs
// NO namespace — App_Code global class
// Static helpers callable from any .aspx binding expression

public static class ViewHelpers
{
    public static string GetImageUrl(object imageUrl)
    {
        string url = imageUrl != null ? imageUrl.ToString() : "";
        return string.IsNullOrEmpty(url)
            ? "/Images/placeholder.png"
            : "/" + url;
    }

    public static string GetCategoryIcon(object name)
    {
        if (name == null) return "🌿";
        string lower = name.ToString().ToLower();
        if (lower.Contains("fruit")) return "🍓";
        if (lower.Contains("veg")) return "🥦";
        if (lower.Contains("honey")) return "🍯";
        if (lower.Contains("box")) return "📦";
        if (lower.Contains("seasonal")) return "🌻";
        return "🌿";
    }

    public static string GetStockBadge(object stock)
    {
        if (stock == null) return "";
        int qty = (int)stock;
        if (qty <= 0)
            return "<span class=\"absolute top-3 right-3 bg-red-500 text-white " +
                   "text-xs font-semibold px-2.5 py-1 rounded-full\">Out of Stock</span>";
        return "";
    }

    public static string GetFeaturedBadge(object isFeatured)
    {
        if (isFeatured == null) return "";
        bool featured = (bool)isFeatured;
        if (!featured) return "";
        return "<span class=\"absolute top-3 left-3 bg-earth text-white " +
               "text-xs font-semibold px-2.5 py-1 rounded-full\">⭐ Featured</span>";
    }

    public static string GetStockCss(object stock)
    {
        if (stock == null) return "";
        int qty = (int)stock;
        if (qty <= 0)
            return "bg-red-100 text-red-700 text-xs px-2 py-1 rounded-full font-medium";
        if (qty <= 10)
            return "bg-yellow-100 text-yellow-700 text-xs px-2 py-1 rounded-full font-medium";
        return "bg-green-100 text-green-700 text-xs px-2 py-1 rounded-full font-medium";
    }

    public static string ActiveStatus(object isActive)
    {
        if (isActive == null) return "";
        bool active = (bool)isActive;
        return active
            ? "bg-green-100 text-green-700 text-xs px-2.5 py-1 rounded-full font-medium"
            : "bg-gray-100 text-gray-500 text-xs px-2.5 py-1 rounded-full font-medium";
    }

    public static string GetOrderStatusBadge(object status)
    {
        if (status == null) return "";
        string s = status.ToString();
        string css;
        string icon;
        switch (s)
        {
            case "Pending":
                css = "bg-amber-100 text-amber-700";
                icon = "⏳";
                break;
            case "Processing":
                css = "bg-blue-100 text-blue-700";
                icon = "⚙️";
                break;
            case "Shipped":
                css = "bg-purple-100 text-purple-700";
                icon = "🚚";
                break;
            case "Delivered":
                css = "bg-green-100 text-green-700";
                icon = "✅";
                break;
            case "Cancelled":
                css = "bg-red-100 text-red-700";
                icon = "❌";
                break;
            default:
                css = "bg-gray-100 text-gray-600";
                icon = "📋";
                break;
        }
        return string.Format(
            "<span class='{0} text-xs font-semibold px-2.5 py-1 rounded-full'>" +
            "{1} {2}</span>", css, icon, s);
    }

    public static string GetPaymentStatusBadge(object status)
    {
        if (status == null) return "";
        string s = status.ToString();
        bool paid = s == "Paid";
        string css = paid
            ? "bg-green-100 text-green-700"
            : "bg-amber-100 text-amber-700";
        string icon = paid ? "💳" : "⏳";
        return string.Format(
            "<span class='{0} text-xs font-semibold px-2.5 py-1 rounded-full'>" +
            "{1} {2}</span>", css, icon, s);
    }
}