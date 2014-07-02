<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCApp.DAL.Marker>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Marker: <%: Model.MarkerTitle %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Marker: <em><%: Model.MarkerTitle %></em></h2>

    <fieldset>
        <legend>Details</legend>
        <table class="datatable">
        <tr>
            <td>MarkerID</td>
            <td><%: Model.MarkerID %></td>
        </tr>
        <tr>
            <td>Current Status</td>
            <td><%: Model.Status %></td>
        </tr>
       <tr>
            <td>Left on Hill</td>
            <td><% if (Model.Hill != null) { Response.Write(Model.Hill.Hillname); } %></td>
        </tr>
        <tr>
            <td>Left on walk</td>
            <td><% if ( Model.WalkID != null) {
                      Response.Write(Html.ActionLink(Model.Walk.WalkTitle, "Details", "Walks", new{ id = Model.WalkID}, null));
                    } else {
                        Response.Write("No walk associated with marker");
                    }
                 %></td>
        </tr>
        <tr>
            <td>GPS_Reference</td>
            <td><%: Model.GPS_Reference %></td>
        </tr>
        <tr>
            <td>Date Left</td>
            <td><%: String.Format("{0:D}", Model.DateLeft) %></td>
        </tr>

        <tr>
            <td>Description</td>
            <td><%: Model.Location_Description.Replace(Environment.NewLine, "<br />")%></td>
        </tr>        
        </table>       
        <h2>Observations</h2>
        <table class="datatable">
        <tr>
           <th>Date</th>
           <th>Found?</th>
           <th>Walk</th>
           <th>Description</th>
        </tr>
        <%  foreach (MyMVCApp.DAL.Marker_Observation oMarkerObs in Model.Marker_Observations)  {%>
        <tr>
            <td><%: String.Format("{0:D}", oMarkerObs.DateOfObservation)%></td>
            <td><% if (oMarkerObs.FoundFlag ) {
                        Response.Write(" Found ");
                    } else {
                        Response.Write("Not yet re-found");
                        
                    }%></td>
            <td><%: Html.ActionLink(oMarkerObs.Walk.WalkTitle, "Details", "Walks", new{ id = oMarkerObs.WalkID}, null)%></td>
            <td><%: oMarkerObs.ObservationText %></td>
        </tr>        
        <% } %>
        </table>
        <h2>Images</h2>
        <table class="datatable">
        <% if (Model.Walk_AssociatedFiles.Count == 0)
           {
        %>
            <tr><td>There are no images of the marker</td></tr>    
        <%
           }
           else
           {


               foreach (MyMVCApp.DAL.Walk_AssociatedFile oAssocFile in Model.Walk_AssociatedFiles)
               { %>
        <tr>
            <td><%: oAssocFile.Walk.WalkDate.Day.ToString() %> <%: oAssocFile.Walk.WalkDate.ToString("MMMM") %> <%: oAssocFile.Walk.WalkDate.Year.ToString() %> : <em><%: oAssocFile.Walk_AssociatedFile_Caption %></em></td>
        </tr>
        <tr>
            <td><% if (SessionSingleton.Current.UsageLocation.Equals("At Work"))
                   {
                       Response.Write(oAssocFile.Walk_AssociatedFile_Name);
                   }
                   else
                   { %>
                   <img src="<%: oAssocFile.Walk_AssociatedFile_Name %>" alt="<%: oAssocFile.Walk_AssociatedFile_Caption %>" width="400"/>
                  <% } %>
             
             </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>        
        <%      }
           } %>
    </table>
    </fieldset>
    <p>

        <%: Html.ActionLink("Edit", "Edit", new { id = Model.MarkerID})%> |
        <%: Html.ActionLink("Back to List", "Index") %>
    </p>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
</asp:Content>

