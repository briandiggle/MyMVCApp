<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="MyMVCAppCS.Models" %>
<%@ Import Namespace="MyMVCApp.DAL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	My Progress
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <h2>My Progress</h2>

<p style="font-size: 0.8em;">
<%= Html.ActionLink("Favourite Classes", "Index", "Progress", New With {.classtype = "F"}, New With {.dummy = 0})%> |
<%= Html.ActionLink("Scottish Classes", "Index", "Progress", New With {.classtype = "S"}, New With {.dummy = 0})%> |
<%= Html.ActionLink("Administrative Classes", "Index", "Progress", New With {.classtype = "A"}, New With {.dummy = 0})%> |
<%= Html.ActionLink("Other Classes", "Index", "Progress", New With {.classtype = "E"}, New With {.dummy = 0})%> |
<%= Html.ActionLink("London Classes", "Index", "Progress", New With {.classtype = "L"}, New With {.dummy = 0})%> |
<%= Html.ActionLink("County Classes", "Index", "Progress", New With {.classtype = "C"}, New With {.dummy = 0})%>
</p>
<table class="datatable">
<th>ClassRef</th>
<th>Class Name</th>
<th>Hills Climbed</th>
<th>Total Hills</th>
<th>Percentage Complete</th>
<th>Progress Bar</th>
<% 
    Dim oProgressList As List(Of MyMVCApp.DAL.MyProgress) = ViewData("oProgress")
    Dim iProgressBarTotalPixels = 500
    Dim dPercentComplete As Double
    Dim iCompletePixels As Integer
    
    For Each oClassProgress As MyMVCApp.DAL.MyProgress In oProgressList
        
        If oClassProgress.TotalHills > 0 Then
            dPercentComplete = (oClassProgress.NumberClimbed / oClassProgress.TotalHills) * 100
            iCompletePixels = CInt((dPercentComplete / 100) * iProgressBarTotalPixels)
%>        
         
  <tr>
        <td><%= WalkingStick.HillClassToLink(oClassProgress.ClassRef, "")%></td>
        <td><%= WalkingStick.HillClassToLink(oClassProgress.ClassRef, oClassProgress.ClassName)%></td> 
        <td><%= oClassProgress.NumberClimbed.ToString%></td> 
        <td><%= oClassProgress.TotalHills.ToString%></td>
        <td><%= String.Format("{0:F}", dPercentComplete)%></td> 
        <td><% If oClassProgress.NumberClimbed > 0 Then%><img src="../../Content/images/bk_item_off_green_light.png" width="<%=iCompletePixels.ToString %>" height="31"/><% End If %><img src="../../Content/images/bk_item_off_red_light.png" width="<%= (iProgressBarTotalPixels-iCompletePixels).ToString %>" height="31"/>
        </td> 
  </tr>
  
        
<%        
End If
    Next
%>
</table>

<p style="font-size: 0.8em;">
<%= Html.ActionLink("Favourite Classes", "Index", "Progress", New With {.classtype = "F"}, New With {.dummy = 0})%> |
<%= Html.ActionLink("Scottish Classes", "Index", "Progress", New With {.classtype = "S"}, New With {.dummy = 0})%> |
<%= Html.ActionLink("Administrative Classes", "Index", "Progress", New With {.classtype = "A"}, New With {.dummy = 0})%> |
<%= Html.ActionLink("Other Classes", "Index", "Progress", New With {.classtype = "E"}, New With {.dummy = 0})%> |
<%= Html.ActionLink("London Classes", "Index", "Progress", New With {.classtype = "L"}, New With {.dummy = 0})%> |
<%= Html.ActionLink("County Classes", "Index", "Progress", New With {.classtype = "C"}, New With {.dummy = 0})%>
</p>

</asp:Content>
