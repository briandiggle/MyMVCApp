<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of WalkingMVC.WalkingMVC.Hill)" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	 <%= Html.Encode(Model.Hillname) %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <table class="optionstable">
    <tr>
        <td colspan="4"><h2><%= Html.Encode(Model.Hillname) %></h2></td>
    </tr>

    <tr>
        <td class="hilldetailstat"><%  If Not IsNothing(Model.Gridref10) Then
                             Response.Write(Model.Gridref10)
                         Else
                             Response.Write(Model.Gridref)
                         End If%>
        </td>
        <td class="hilldetailstat"><% If Not IsNothing(Model.Drop) Then Response.Write(Html.Encode(String.Format("{0}", Model.Drop)) + "m drop")%></td>
        <td class="hilldetailstat"><%= Html.Encode(String.Format("{0}", Model.Feet)) %>ft, <%= Html.Encode(String.Format("{0}", Model.Metres)) %>m</td>
        <td class="hilldetailstat"><%= Html.Encode(Model.Classification) %></td>

    </tr>
    <%  If Not IsDBNull(Model.Feature) Or Not IsDBNull(Model.FirstClimbedDate) Then%>
    <tr>
        <% If Not IsDBNull(Model.Feature) Then %> <td colspan="2">Feature: <%  Response.Write(Html.Encode(Model.Feature))%></td><% End If%>
       <% If Not IsDBNull(Model.FirstClimbedDate) Then%> <td colspan="2">First Climbed: <% Response.Write(Html.Encode(String.Format("{0:D}", Model.FirstClimbedDate)))%></td><% End If%>
    </tr>    
    <%  End If%>
     <%  If Not IsNothing(Model.Observations) Then%>
    <tr>
        <td colspan="4">Observations: <%= Html.Encode(Model.Observations)%></td>
    </tr>    
    <%  End If%>   
    <%  If Not IsNothing(Model.Comments) Then%>
    <tr>
        <td colspan="4">Comments: <%= Html.Encode(Model.Comments)%></td>
    </tr>    
    <%  End If%>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4"><h3>Ascents</h3></td></tr>
    <tr><td colspan="4"><%= Html.ActionLink("Log ascent", "Create", "Walks")%></td></tr>
    </table>
    <table class="optionstable">
<%  Dim iAscentCounter As Integer = 1

    Dim oAscents As IEnumerable(Of WalkingMVC.WalkingMVC.HillAscent) = ViewData("HillAscents")
    
    For Each oAscent As WalkingMVC.WalkingMVC.HillAscent In oAscents %>
    <tr>
        <td class="ascentnumber"><%=iAscentCounter.ToString %> </td>
        <td class="walkdate"><%= Html.Encode(String.Format("{0:D}", oAscent.AscentDate))%> </td>
        <td class="walktitle"><a href="/Walks/Details/<%= oAscent.Walk.WalkID %>"><%= oAscent.Walk.WalkTitle %></a></td>
        <td><a href="/Walks/Details/<%= oAscent.Walk.WalkID %>"><%= oAscent.Walk.WalkSummary %></a></td>
    </tr>     
        
 <%   
        iAscentCounter = iAscentCounter + 1  
 Next%>
    </table>
         

</asp:Content>

