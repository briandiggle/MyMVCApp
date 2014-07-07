<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCApp.DAL.Hill>" %>
<%@ Import Namespace="MyMVCApp.DAL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	 <%= Html.Encode(Model.Hillname) %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <table class="optionstable">
    <tr>
        <td colspan="4"><h2><%= Html.Encode(Model.Hillname) %></h2></td>
    </tr>

    <tr>
        <td class="hilldetailstat"><% if (Model.Gridref10 != null) {Response.Write(Model.Gridref10);}
                                      else{ Response.Write(Model.Gridref);}  %>
        </td>
        <td class="hilldetailstat"><% if (Model.Drop != null) {Response.Write(Html.Encode(String.Format("{0}", Model.Drop)) + "m drop");}  %>
        </td>
        <td class="hilldetailstat"><%= Html.Encode(String.Format("{0}", Model.Feet)) %>ft, <%= Html.Encode(String.Format("{0}", Model.Metres)) %>m</td>
        <td class="hilldetailstat"><%= Html.Encode(Model.Classification) %></td>

    </tr>
    <% if (Model.Feature != String.Empty || Model.FirstClimbedDate != null)
       { %>
    <tr>
        <% if (Model.Feature != null)
           { %> <td colspan="2">Feature: <% Response.Write(Html.Encode(Model.Feature)); %></td><% } %>
        <% if (Model.FirstClimbedDate != null)
           { %> <td colspan="2">First Climbed: <% Response.Write(Html.Encode(String.Format("{0:D}", Model.FirstClimbedDate))); %></td><% } %>
    </tr>    
    <% } %>

     <% if (Model.Observations != null)
        { %>
    <tr>
        <td colspan="4">Observations: <%= Html.Encode(Model.Observations) %></td>
    </tr>    
    <% } %>   
    <% if (Model.Comments != null)
       { %>
    <tr>
        <td colspan="4">Comments: <%= Html.Encode(Model.Comments) %></td>
    </tr>    
    <% } %>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4"><h3>Ascents</h3></td></tr>
    <tr><td colspan="4"><%= Html.ActionLink("Log ascent", "Create", "Walks")%></td></tr>
    </table>
    <table class="optionstable">
<% int iAscentCounter = 1;

   List<MyMVCApp.DAL.HillAscent> oAscents = (List<HillAscent>)ViewData["HillAscents"];
    
    foreach ( HillAscent oAscent in oAscents)
    {
        %>
    <tr>
        <td class="ascentnumber"><%=iAscentCounter.ToString() %> </td>
        <td class="walkdate"><%= Html.Encode(String.Format("{0:D}", oAscent.AscentDate))%> </td>
        <td class="walktitle"><a href="/Walks/Details/<%= oAscent.Walk.WalkID %>"><%= oAscent.Walk.WalkTitle %></a></td>
        <td><a href="/Walks/Details/<%= oAscent.Walk.WalkID %>"><%= oAscent.Walk.WalkSummary %></a></td>
    </tr>     
        
 <%
     iAscentCounter = iAscentCounter + 1;
    }%>
    </table>
         

</asp:Content>

