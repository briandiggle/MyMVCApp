<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of WalkingMVC.WalkingMVC.Marker)" %>

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
            <td><% If Not IsNothing(Model.Hill) Then Response.Write(Model.Hill.Hillname)%></td>
        </tr>
        <tr>
            <td>Left on walk</td>
            <td><% If Not IsNothing(Model.WalkID) Then
                      Response.Write(Html.ActionLink(Model.Walk.WalkTitle, "Details", "Walks", New With {.id = Model.WalkID}))
                    Else
                        Response.Write("No walk associated with marker")
                    End If
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
            <td><%: Replace(Model.Location_Description, vbCrLf, "<br />")%></td>
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
        <%  For Each oMarkerObs As WalkingMVC.WalkingMVC.Marker_Observation In Model.Marker_Observations %>
        <tr>
            <td><%: String.Format("{0:D}", oMarkerObs.DateOfObservation)%></td>
            <td><%: oMarkerObs.FoundFlag.ToString %></td>
            <td><%: Html.ActionLink(oMarkerObs.Walk.WalkTitle, "Details", "Walks", New With {.id = oMarkerObs.WalkID}, Nothing)%></td>
            <td><%: oMarkerObs.ObservationText %></td>
        </tr>        
        <%  Next%>
        </table>
        <h2>Images</h2>
        <table class="datatable">
        <%  For Each oAssocFile As WalkingMVC.WalkingMVC.Walk_AssociatedFile In Model.Walk_AssociatedFiles%>
        <tr>
            <td><%: oAssocFile.Walk_AssociatedFile_Caption%></td>
        </tr>
        <tr>
            <td><%  If ViewData("AT_WORK") = "True" Then
                        Response.Write(oAssocFile.Walk_AssociatedFile_Name)
                    Else %>

                   <img src="<%: oAssocFile.Walk_AssociatedFile_Name %>" alt="<%: oAssocFile.Walk_AssociatedFile_Caption %>" width="400"/>
                  <%  End If %>
             
             </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>        
        <%  Next%>
    </table>
    </fieldset>
    <p>

        <%: Html.ActionLink("Edit", "Edit", New With {.id = Model.MarkerID})%> |
        <%: Html.ActionLink("Back to List", "Index") %>
    </p>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
</asp:Content>

