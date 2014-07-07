<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<MyMVCApp.DAL.Area>>" %>
<%@ Import Namespace="MyMVCApp.DAL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Walking Areas in <%= ViewData["CountryName"]%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><% if (ViewData["AreaTypeName"] != String.Empty) { Response.Write(ViewData["AreaTypeName"])%> Walking Areas In <%= ViewData["CountryName"]%></h2>
    
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

    <% foreach (Area hillArea in Model)
        {%>
    
        <tr>
           <td>
                <%= Html.Encode(hillArea.Arearef) %>
            </td>        
            <td>
                <%=Html.ActionLink(hillArea.Areaname, "HillsByArea", new {id = hillArea.Arearef.Trim()})%>
            </td>
            <td>
                <%= Html.Encode(hillArea.AreaType) %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

