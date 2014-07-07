<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="MyMVCApp.DAL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	My Progress
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <h2>My Progress</h2>

<p style="font-size: 0.8em;">
<%= Html.ActionLink("Favourite Classes", "Index", "Progress", new {classtype = "F"}, new {dummy = 0})%> |
<%= Html.ActionLink("Scottish Classes", "Index", "Progress", new {classtype = "S"}, new {dummy = 0})%> |
<%= Html.ActionLink("Administrative Classes", "Index", "Progress", new {classtype = "A"}, new {dummy = 0})%> |
<%= Html.ActionLink("Other Classes", "Index", "Progress", new {classtype = "E"}, new {dummy = 0})%> |
<%= Html.ActionLink("London Classes", "Index", "Progress", new {classtype = "L"}, new {dummy = 0})%> |
<%= Html.ActionLink("County Classes", "Index", "Progress", new {classtype = "C"}, new {dummy = 0})%>
</p>
<table class="datatable">
<th>ClassRef</th>
<th>Class Name</th>
<th>Hills Climbed</th>
<th>Total Hills</th>
<th>Percentage Complete</th>
<th>Progress Bar</th>
<% 
    var oProgressList = (List<MyProgress>)this.ViewData["oProgress"];
    const int ProgressBarTotalPixels = 500;
    Double dPercentComplete;
    int iCompletePixels;
    
    foreach( MyProgress oClassProgress in oProgressList)
    {
        if( oClassProgress.TotalHills > 0 )
        {
            dPercentComplete = ((Double)oClassProgress.NumberClimbed / (Double)oClassProgress.TotalHills) * 100;
            iCompletePixels = Convert.ToInt32((dPercentComplete / 100) * ProgressBarTotalPixels);
%>        
         
  <tr>
        <td><%= WalkingStick.HillClassToLink(oClassProgress.ClassRef, "")%></td>
        <td><%= WalkingStick.HillClassToLink(oClassProgress.ClassRef, oClassProgress.ClassName)%></td> 
        <td><%= oClassProgress.NumberClimbed.ToString()%></td> 
        <td><%= oClassProgress.TotalHills.ToString()%></td>
        <td><%= String.Format("{0:F}", dPercentComplete)%></td> 
        <td><% if (oClassProgress.NumberClimbed > 0 ) { %>
            <img src="../../Content/images/bk_item_off_green_light.png" width="<%=iCompletePixels.ToString() %>" height="31"/><% } %><img src="../../Content/images/bk_item_off_red_light.png" width="<%= (ProgressBarTotalPixels-iCompletePixels).ToString() %>" height="31"/>
            <% } %>
        </td> 
  </tr>
<%       
    }
%>
</table>

<p style="font-size: 0.8em;">
<%= Html.ActionLink("Favourite Classes", "Index", "Progress", new {classtype = "F"}, new {dummy = 0})%> |
<%= Html.ActionLink("Scottish Classes", "Index", "Progress", new {classtype = "S"}, new {dummy = 0})%> |
<%= Html.ActionLink("Administrative Classes", "Index", "Progress", new {classtype = "A"}, new {dummy = 0})%> |
<%= Html.ActionLink("Other Classes", "Index", "Progress", new {classtype = "E"}, new {dummy = 0})%> |
<%= Html.ActionLink("London Classes", "Index", "Progress", new {classtype = "L"}, new {dummy = 0})%> |
<%= Html.ActionLink("County Classes", "Index", "Progress", new {classtype = "C"}, new {dummy = 0})%>
</p>

</asp:Content>
