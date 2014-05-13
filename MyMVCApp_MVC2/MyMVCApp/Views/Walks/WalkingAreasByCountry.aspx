<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of IEnumerable (Of WalkingMVC.WalkingMVC.Area))" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Walking Areas in <%= ViewData("CountryName")%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><% If ViewData("AreaTypeName") <> "" Then Response.Write(ViewData("AreaTypeName"))%> Walking Areas In <%= ViewData("CountryName")%></h2>
    
    <table>
        <tr>
            <th>Area ref</th>
 
            <th>
                Area name
            </th>
            <th>
                Area Type
            </th>
   
        </tr>

    <% For Each item In Model%>
    
        <tr>
           <td>
                <%= Html.Encode(item.arearef) %>
            </td>        
            <td>
                <%=Html.ActionLink(item.Areaname, "HillsByArea", New With {.id = item.Arearef.Trim})%>
            </td>
            <td>
                <%= Html.Encode(item.AreaType) %>
            </td>
        </tr>
    
    <% Next%>

    </table>

</asp:Content>

