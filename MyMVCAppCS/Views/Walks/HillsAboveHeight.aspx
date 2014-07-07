<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<MyMVCApp.DAL.Hill>>" %>

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
                Number of Ascents
            </th>
            <th>
                HillClimbedDate
            </th>
        </tr>

    <% foreach (MyMVCApp.DAL.Hill hill in Model)
       {%>
    
        <tr>
            <td>
                <%= Html.ActionLink("Edit", "Edit", new {id = hill.Hillnumber})%> |
                <%= Html.ActionLink("Details", "Details", new {id = hill.Hillnumber})%>
             
            </td>
            <td>
                <%= Html.Encode(hill.Hillnumber) %>
            </td>
            <td>
                <%= Html.Encode(hill.Hillname) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", hill._Section)) %>
            </td>
            <td>
                <%= Html.Encode(hill.Classification) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", hill.Metres)) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", hill.Feet)) %>
            </td>
            <td>
                <%= Html.Encode(hill.Gridref) %>
            </td>
            <td>
                <%= Html.Encode(hill.Gridref10) %>
            </td>
            <td>
                <%= Html.Encode(hill.Colgridref) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", hill.Colheight)) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", hill.Drop)) %>
            </td>
            <td>
                <%= Html.Encode(hill.Feature) %>
            </td>
            <td>
                <%= Html.Encode(hill.Observations) %>
            </td>
            <td>
                <%= Html.Encode(hill.Survey) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:g}", hill.Revision)) %>
            </td>
            <td>
                <%= Html.Encode(hill.Comments) %>
            </td>
            <td>
                <%= Html.Encode(hill.Map) %>
            </td>
            <td>
                <%= Html.Encode(hill.Map25) %>
            </td>
            <td>
                <%= Html.Encode(hill.Xcoord) %>
            </td>
            <td>
                <%= Html.Encode(hill.Ycoord) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", hill.Latitude)) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:F}", hill.Longitude)) %>
            </td>
            <td>
                <%= Html.Encode(hill.NumberOfAscents) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:g}", hill.FirstClimbedDate)) %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

