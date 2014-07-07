<%@ Page Title="" Language="C#" ValidateRequest="False" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCAppCS.ViewModels.WalkSearchViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Search walking database
</asp:Content>

<asp:Content ID="ViewSpecifiedHead1" ContentPlaceHolderID="ViewSpecificHead" runat="server">
<script src="../../Scripts/MicrosoftAjax.js" type="text/javascript"></script>
<script src="../../Scripts/MicrosoftMvcValidation.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Search walking database</h2>

    <p><%= Html.ActionLink("Search for Walks", "WalkSearch", "Search")%></p>
    
    <p><%= Html.ActionLink("Search for Images", "ImageSearch", "Search")%></p>
    
    <p><%= Html.ActionLink("Search for Markers", "MarkerSearch", "Search")%></p>
    
    <p><%= Html.ActionLink("Search for Hills", "HillSearch", "Search")%></p>
    
    <p><%= Html.ActionLink("Search for Ascents", "AscentSearch", "Search")%></p>
</asp:Content>
