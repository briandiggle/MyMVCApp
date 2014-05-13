<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of IEnumerable (Of MyMVCApp.DAL.Hill))" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	HillsAboveHeight
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>HillsAboveHeight</h2>

    <p>
        <%= Html.ActionLink("Create New", "Create")%>
    </p>
    
    <table>
        <tr>
            <th></th>
            <th>
                Hillnumber
            </th>
            <th>
                Hillname
            </th>
            <th>
                _Section
            </th>
            <th>
                Classification
            </th>
            <th>
                Metres
            </th>
            <th>
                Feet
            </th>
            <th>
                Gridref
            </th>
            <th>
                Gridref10
            </th>
            <th>
                Colgridref
            </th>
            <th>
                Colheight
            </th>
            <th>
                Drop
            </th>
            <th>
                Feature
            </th>
            <th>
                Observations
            </th>
            <th>
                Survey
            </th>
            <th>
                Revision
            </th>
            <th>
                Comments
            </th>
            <th>
                Map
            </th>
            <th>
                Map25
            </th>
            <th>
                Xcoord
            </th>
            <th>
                Ycoord
            </th>
            <th>
                Latitude
            </th>
            <th>
                Longitude
            </th>
            <th>
                HillClimbed
            </th>
            <th>
                HillClimbedDate
            </th>
        </tr>

    <% For Each item In Model%>
    
        <tr>
            <td>
                <%= Html.ActionLink("Edit", "Edit", New With {.id = item.Hillnumber})%> |
                <%= Html.ActionLink("Details", "Details", New With {.id = item.Hillnumber})%>
             
            </td>
            <td>
                <%= Html.Encode(item.Hillnumber) %>
            </td>
            <td>
                <%= Html.Encode(item.Hillname) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", item._Section)) %>
            </td>
            <td>
                <%= Html.Encode(item.Classification) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", item.Metres)) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", item.Feet)) %>
            </td>
            <td>
                <%= Html.Encode(item.Gridref) %>
            </td>
            <td>
                <%= Html.Encode(item.Gridref10) %>
            </td>
            <td>
                <%= Html.Encode(item.Colgridref) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", item.Colheight)) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", item.Drop)) %>
            </td>
            <td>
                <%= Html.Encode(item.Feature) %>
            </td>
            <td>
                <%= Html.Encode(item.Observations) %>
            </td>
            <td>
                <%= Html.Encode(item.Survey) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:g}", item.Revision)) %>
            </td>
            <td>
                <%= Html.Encode(item.Comments) %>
            </td>
            <td>
                <%= Html.Encode(item.Map) %>
            </td>
            <td>
                <%= Html.Encode(item.Map25) %>
            </td>
            <td>
                <%= Html.Encode(item.Xcoord) %>
            </td>
            <td>
                <%= Html.Encode(item.Ycoord) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", item.Latitude)) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", item.Longitude)) %>
            </td>
            <td>
                <%= Html.Encode(item.HillClimbed) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:g}", item.HillClimbedDate)) %>
            </td>
        </tr>
    
    <% Next%>

    </table>

</asp:Content>

