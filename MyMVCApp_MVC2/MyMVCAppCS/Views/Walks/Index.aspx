<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Walking MVC Application - Home
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<table class="optionstable">
<tr>
<td class="aligntop">
    <h3>Marylyns</h3>
    <p><%= Html.ActionLink("Marlyn Areas in England", "WalkingAreasByCountry", New With {.strCountryCode = "EN", .strAreaType = "M"})%></p>
    <p><%= Html.ActionLink("Marlyn Areas in Scotland", "WalkingAreasByCountry", New With {.strCountryCode = "SC", .strAreaType = "M"})%></p>
    <p><%= Html.ActionLink("Marlyn Areas in Ireland", "WalkingAreasByCountry", New With {.strCountryCode = "IR", .strAreaType = "M"})%></p>
    <p><%= Html.ActionLink("Marlyn Areas in Wales", "WalkingAreasByCountry", New With {.strCountryCode = "WA", .strAreaType = "M"})%></p>
    <p><%= Html.ActionLink("Marlyn Areas on the Isle of Man", "WalkingAreasByCountry", New With {.strCountryCode = "IM", .strAreaType = "M"})%></p>

    <h3>Nuttals</h3>
    <p><%= Html.ActionLink("Nuttall Areas in England", "WalkingAreasByCountry", New With {.strCountryCode = "EN", .strAreaType = "N"})%></p>
    <p><%= Html.ActionLink("Nuttall Areas in Wales", "WalkingAreasByCountry", New With {.strCountryCode = "WA", .strAreaType = "N"})%></p>

    <h3>Walks</h3>
    <p><%= Html.ActionLink("Browse Walks", "WalksByDate", New With {.OrderBy = "DateAsc"})%></p>
    <p><%= Html.ActionLink("Progress", "Index", "Progress")%></p>
</td>
<td class="aligntop">
    <h3>Hewitts</h3>
    <p><%= Html.ActionLink("Nuttall Areas in England", "WalkingAreasByCountry", New With {.strCountryCode = "EN", .strAreaType = "H"})%></p>
    <p><%= Html.ActionLink("Nuttall Areas in Wales", "WalkingAreasByCountry", New With {.strCountryCode = "WA", .strAreaType = "H"})%></p>

    <h3>Administrative Areas</h3>
    <p><%= Html.ActionLink("Administrative Areas in England", "WalkingAreasByCountry", New With {.strCountryCode = "EN", .strAreaType = "A"})%></p>
    <p><%= Html.ActionLink("Administrative in Wales", "WalkingAreasByCountry", New With {.strCountryCode = "WA", .strAreaType = "A"})%></p>
    <p><%= Html.ActionLink("Administrative in Scotland", "WalkingAreasByCountry", New With {.strCountryCode = "SC", .strAreaType = "A"})%></p>

    <h3>Southern Uplands</h3>
    <p><%= Html.ActionLink("Southern Uplands", "WalkingAreasByCountry", New With {.strCountryCode = "SC", .strAreaType = "D"})%></p>

    <h3><em>All Hills</em></h3>
    <p><%= Html.ActionLink("All Hills", "HillsInClassification", "Walks", New With {.id = Nothing}, New With {.dummy = 0})%></p>

</td>
<td class="aligntop">
    <h3>Munros Areas</h3>
    <p><%= Html.ActionLink("The Munros Areas of Scotland", "WalkingAreasByCountry", New With {.strCountryCode = "SC", .strAreaType = "M"})%></p>

    <h3>County Tops</h3>
    <p><%= Html.ActionLink("County tops in England", "WalkingAreasByCountry", New With {.strCountryCode = "EN", .strAreaType = "C"})%></p>
    <p><%= Html.ActionLink("County tops in Wales", "WalkingAreasByCountry", New With {.strCountryCode = "WA", .strAreaType = "C"})%></p>
    <p><%= Html.ActionLink("County tops in Scotland", "WalkingAreasByCountry", New With {.strCountryCode = "SC", .strAreaType = "C"})%></p>

    <h3>Islands</h3>
    <p><%= Html.ActionLink("Islands of England", "WalkingAreasByCountry", New With {.strCountryCode = "EN", .strAreaType = "I"})%></p>
    <p><%= Html.ActionLink("Islands of  Wales", "WalkingAreasByCountry", New With {.strCountryCode = "WA", .strAreaType = "I"})%></p>
    <p><%= Html.ActionLink("Islands of Scotland", "WalkingAreasByCountry", New With {.strCountryCode = "SC", .strAreaType = "I"})%></p>
    <p><%= Html.ActionLink("Islands of Isle of Man", "WalkingAreasByCountry", New With {.strCountryCode = "IM", .strAreaType = "I"})%></p>
</td>
</tr>
</table>




</asp:Content>
