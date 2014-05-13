<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of WalkingMVC.WalkingMVC.Walk)" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%: Model.WalkTitle %>, <%: String.Format("{0:D}", Model.WalkDate)%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  
    <table class="datatable">
   <tr>
        <td colspan="2"> <div class="main_title"><%: Model.WalkTitle %>, <%: String.Format("{0:D}", Model.WalkDate)%></div></td>
   </tr>
 <tr><td colspan="2">&nbsp;</td></tr>
    <tr>
        <td colspan="2" class="big_title"><%: Model.WalkSummary %></td>
    </tr>
    <tr>
        <td>Type:</td><td><%: Model.WalkType %></td>
    </tr>
    <tr>
        <td>Walk Area:</td><td><%: Html.ActionLink(Model.WalkAreaName, "HillsByArea", New With {.id = Model.Area.Arearef.Trim})%></td>
    </tr>
 
  <%If Not IsNothing(Model.CartographicLength) Then%> 
   <tr>
      <td>Length:</td><td><%: String.Format("{0:F}", Model.CartographicLength) %>Km</td>
   </tr>    
   <% End If%>
     <%If Not IsNothing(Model.MetresOfAscent) Then%> 
  <tr>
      <td>Ascent:</td><td><%: Model.MetresOfAscent %>m</td>
   </tr> 
   <% End If %>
   <% If Not IsNothing(Model.WalkConditions) AndAlso Model.WalkConditions.Length > 0 Then%> 
   <tr>
      <td>Conditions:</td><td><%: Model.WalkConditions%></td>
   </tr>       
   <% End If %>
   <% If Not IsNothing(Model.WalkCompanions) AndAlso Model.WalkCompanions.Length > 0 Then%> 
   <tr>
      <td>With:</td><td><%: Model.WalkCompanions%></td>
   </tr>       
   <% End If %>
  <%If Not IsNothing(ViewData("TotalTime")) AndAlso ViewData("TotalTime").ToString.Length > 0 Then%>
   <tr>
      <td>Total Time:</td><td><%: ViewData("TotalTime")%></td>
   </tr>       
   <% End If%>
   <% If Not IsNothing(Model.WalkAverageSpeedKmh) Then%> 
   <tr>
      <td>Overall speed (km/h):</td><td><%: Model.WalkAverageSpeedKmh%>Km/h</td>
   </tr>       
   <% End If %>
   <% If Not IsNothing(Model.MovingAverageKmh) Then%> 
   <tr>
      <td>Moving average (km/h):</td><td><%: Model.MovingAverageKmh%>Km/h</td>
   </tr>       
   <% End If %>
   <tr><td colspan="2">&nbsp;</td></tr>
  <tr>
        <td colspan="2"><%= Model.WalkDescription.Replace(ControlChars.Lf, "<br />") %></td>
    </tr>
 <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
<tr>
    <td colspan="2"> 
    <% If Model.Marker_Observations.Count > 0 Then%>
    <table class="datatable">
    <tr><td><strong>Markers</strong></td></tr>  
    
<%  For Each oMarkerObs As WalkingMVC.WalkingMVC.Marker_Observation In Model.Marker_Observations%>
    <tr>
        <td><em><%= Html.ActionLink(oMarkerObs.Marker.MarkerTitle, "Details", "Marker", New With {.id = oMarkerObs.MarkerID}, Nothing)%></em> <%= oMarkerObs.ObservationText%></td>
    </tr>  
<%  Next%>  
   </table>
<% Else %>
No Markers
    
<%  End If%>
<%  If Model.HillAscents.Count > 0 Then%>
  <table>
    <tr><td colspan="3"><strong>Ascents on this walk</strong></td></tr>  
    <tr>
        <th>Name</th>
        <th>Height</th>
        <th>Classes</th>
        <th></th>
    </tr>
<%  For Each oHillAscent As WalkingMVC.WalkingMVC.HillAscent In Model.HillAscents%>
    <tr>
        <td><%= oHillAscent.Hill.Hillname %></td>
        <td><%= oHillAscent.Hill.Metres.ToString%>m, <%= oHillAscent.Hill.Feet.ToString%>ft</td>
        <td><%=oHillAscent.Hill.Classification %></td>
        <td><% If oHillAscent.Hill.HillAscents.Count = 1 Then Response.Write("<em>First Ascent</em>")%></td>
    </tr>
<% Next %>

  </table>
<% End If%>
      </td>
    </tr>
</table>
<%
    For Each oFile As WalkingMVC.WalkingMVC.Walk_AssociatedFile In Model.Walk_AssociatedFiles

        If oFile.Walk_AssociatedFile_Type = "Image - Altitude Profile" Then
            
            If ViewData("AT_WORK") = "False" Then%>
        <div>&nbsp;<br /><strong>Altitude Profile <em><%: oFile.Walk_AssociatedFile_Caption %></em></strong><br /><img src="<%= oFile.Walk_AssociatedFile_Name %>" border="1" alt="Altitude Profile" /></div>    
        <% Else%>
       <div>&nbsp;<br /><strong>Altitude Profile <em><%: oFile.Walk_AssociatedFile_Caption %></em></strong><br /><%= oFile.Walk_AssociatedFile_Name %></div>
        <% End If%>
   <% 
   ElseIf oFile.Walk_AssociatedFile_Type = "Image - Map" Then
       If ViewData("AT_WORK") = "False" Then%>
         <div>&nbsp;<br /><strong>Map of Walk Area <em><%: oFile.Walk_AssociatedFile_Caption %></em></strong><br /><img src="<%= oFile.Walk_AssociatedFile_Name %>" border="1" alt="Map of walk area" /></div>    
   <%  Else %>    
          <div>&nbsp;<br /><strong>Map of Walk Area <em><%: oFile.Walk_AssociatedFile_Caption %></em></strong><br /><%= oFile.Walk_AssociatedFile_Name %></div>    
   <%  End If
   ElseIf oFile.Walk_AssociatedFile_Type = "Image - Map with track" Then
       If ViewData("AT_WORK") = "False" Then%>
          <div>&nbsp;<br /><strong>Map with track overlay <em><%: oFile.Walk_AssociatedFile_Caption %></em></strong><br /><img src="<%= oFile.Walk_AssociatedFile_Name %>" border="1" alt="Map with track overlay" /></div>    
   <%  Else%>
          <div>&nbsp;<br /><strong>Map with track overlay <em><%: oFile.Walk_AssociatedFile_Caption %></em></strong><br /><%= oFile.Walk_AssociatedFile_Name %></div>    
    
   <% End If
   ElseIf oFile.Walk_AssociatedFile_Type = "GPX File" Then%>
          <div>&nbsp;<br /><br /><strong><a href="<%= oFile.Walk_AssociatedFile_Name %>"  title="GPX file" >GPX file of the walk <em><%: oFile.Walk_AssociatedFile_Caption %></em></strong></a></div>    
   <%  
   ElseIf oFile.Walk_AssociatedFile_Type = "GTM File for GPS Trackmaker" Then%>
           <div>&nbsp;<br /><br /><strong><a href="<%= oFile.Walk_AssociatedFile_Name %>"  title="GPX file" >GTM File for GPS Trackmaker <em><%: oFile.Walk_AssociatedFile_Caption %></em></strong></a></div>    
   <%  End If
       
Next    
    
   Dim iCounter As Integer = 1
   For Each oFile As WalkingMVC.WalkingMVC.Walk_AssociatedFile In Model.Walk_AssociatedFiles
       If oFile.Walk_AssociatedFile_Type = "Image" AndAlso ViewData("AT_WORK") = "True" Then%>
        <div><br /><em><%= iCounter.ToString%>. <%= oFile.Walk_AssociatedFile_Caption %></em><br /><%= oFile.Walk_AssociatedFile_Name %></div>    
    <%  ElseIf oFile.Walk_AssociatedFile_Type = "Image" AndAlso ViewData("AT_WORK") = "False" Then%>
       <div>&nbsp;<br /><%= iCounter.ToString%>. <em><%= oFile.Walk_AssociatedFile_Caption %></em><br /><img src="<%= oFile.Walk_AssociatedFile_Name %>" border="1" alt="<%= oFile.Walk_AssociatedFile_Caption %>" /></div>    
 <% 
 End If
 iCounter = iCounter + 1
 Next
 %>
    <p>

        <%: Html.ActionLink("Edit this walk", "Edit", New With {.id = Model.WalkID})%>
  
    </p>

</asp:Content>


