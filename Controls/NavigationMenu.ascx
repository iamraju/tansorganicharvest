<%@ Control Language="C#" AutoEventWireup="true"
    CodeBehind="NavigationMenu.ascx.cs"
    Inherits="TansOrganicHarvest.Controls.NavigationMenu" %>

<nav class="hidden md:flex items-center gap-1">
    <% string current = System.IO.Path.GetFileNameWithoutExtension(
           Request.AppRelativeCurrentExecutionFilePath ?? ""); %>

    <a href="/Default.aspx"
       class='nav-link-pub px-3 py-2 text-sm font-medium transition-colors
              <%=current=="Default" ? "text-forest active" : "text-gray-600 hover:text-forest"%>'>
        Home
    </a>
    <a href="/Shop.aspx"
       class='nav-link-pub px-3 py-2 text-sm font-medium transition-colors
              <%=current=="Shop" ? "text-forest active" : "text-gray-600 hover:text-forest"%>'>
        Shop
    </a>
    <a href="/ProduceBoxes.aspx"
       class='nav-link-pub px-3 py-2 text-sm font-medium transition-colors
              <%=current=="ProduceBoxes" ? "text-forest active" : "text-gray-600 hover:text-forest"%>'>
        Weekly Boxes
    </a>
    <a href="/About.aspx"
       class='nav-link-pub px-3 py-2 text-sm font-medium transition-colors
              <%=current=="About" ? "text-forest active" : "text-gray-600 hover:text-forest"%>'>
        Our Farm
    </a>
    <a href="/FAQ.aspx"
       class='nav-link-pub px-3 py-2 text-sm font-medium transition-colors
              <%=current=="FAQ" ? "text-forest active" : "text-gray-600 hover:text-forest"%>'>
        FAQ
    </a>
    <a href="/Contact.aspx"
       class='nav-link-pub px-3 py-2 text-sm font-medium transition-colors
              <%=current=="Contact" ? "text-forest active" : "text-gray-600 hover:text-forest"%>'>
        Contact
    </a>
</nav>