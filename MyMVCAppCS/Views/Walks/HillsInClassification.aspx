<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCAppCS.Models.PaginatedListMVC<MyMVCApp.DAL.Hill>>" %>
<%@ Import Namespace="MyMVCApp.DAL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Hills In Classification <%= ViewData["HillClassName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 
    <h2><%= ViewData["HillClassName"] %>s <em>(<%=ViewData["NumberClimbed"]%> of <%= Model.TotalCount%> climbed)</em></h2>
    
    <table class="hiddentable">
    <tr> 
        <td>
            <%= Model.PageNavigationLinks%>
        </td>
        <td>Page Size: <input type="text" name="pagesize" size="3" /></td>
        <td align="right">Showing <%: Model.RecordsShowing%> Hills</td>
    </tr>
    </table>
      <table class="datatable">   
    <tr>
            <th>No.</th>
            <th>
            <%  if ( ViewData["OrderBy"].Equals("Name")) {
                    Response.Write("<strong>");
                    if ( ViewData["OrderAscDesc"].Equals("Asc")) {
                        Response.Write(Html.ActionLink("Name <Asc>", "HillsInClassification", new {OrderBy = "NameDesc"}));
                    } else {
                        Response.Write(Html.ActionLink("Name <Desc>", "HillsInClassification", new {OrderBy = "NameAsc"}));
                    }
                    Response.Write("</strong>");
                } else {
                    Response.Write(Html.ActionLink("Name", "HillsInClassification", new {OrderBy = "NameDesc"}));
                } 
                 %>
            </th>
            <th>
            Classes
            </th>
            <th class="heightcell">
            <%  if ( ViewData["OrderBy"].Equals("Metres")) {
                    Response.Write("<strong>");
                    if ( ViewData["OrderAscDesc"].Equals("Asc")) {
                        Response.Write(Html.ActionLink("Metres <Asc>", "HillsInClassification", new {OrderBy = "MetresDesc"}));
                    } else {
                        Response.Write(Html.ActionLink("Metres <Desc>", "HillsInClassification", new {OrderBy = "MetresAsc"}));
                    } 
                    Response.Write("</strong>");
                } else {
                    Response.Write(Html.ActionLink("Metres", "HillsInClassification", new {OrderBy = "MetresDesc"}));
                } 
             %>
            </th>
            <th class="heightcell">
            Feet
            </th>
            <th>
            Gridref
            </th>
            <th class="heightcell">
            Drop
            </th>
            <th class="heightcell">
               <%  if ( ViewData["OrderBy"].Equals("FirstAscent")) {
                       Response.Write("<strong>");
                       if ( ViewData["OrderAscDesc"].Equals("Asc")) {
                           Response.Write(Html.ActionLink("Date Climbed <Asc>", "HillsInClassification", new {OrderBy = "FirstAscentDesc"}));
                       } else {
                           Response.Write(Html.ActionLink("Date Climbed <Desc>", "HillsInClassification", new {OrderBy = "FirstAscentAsc"}));
                       }
                       Response.Write("</strong>");
                   } else {
                       Response.Write(Html.ActionLink("Date Climbed", "HillsInClassification", new {OrderBy = "FirstAscentDesc"}));
                   }
             %>
            </th>
          <th class="heightcell">
               <%  if ( ViewData["OrderBy"].Equals("NumberAscent")){
                       Response.Write("<strong>");
                       if ( ViewData["OrderAscDesc"].Equals("Asc")) {
                           Response.Write(Html.ActionLink("Ascents <Asc>", "HillsInClassification", new {OrderBy = "NumberAscentDesc"}));
                       } else {
                           Response.Write(Html.ActionLink("Ascents <Desc>", "HillsInClassification", new {OrderBy = "NumberAscentAsc"}));
                       }
                       Response.Write("</strong>");
                   } else {
                       Response.Write(Html.ActionLink("Ascents", "HillsInClassification", new {OrderBy = "NumberAscentDesc"}));
                   }
             %>
            </th>
        </tr>

    <%  int iHillNumberInClassification = ((Model.PageIndex - 1) * Model.PageSize) + 1;
        
        foreach(Hill item in Model)
        {
         %>
    
        <tr style="background-color:<%= WalkingStick.NumberOfAscentsAsColour(item.NumberOfAscents) %>">
            <td class="hilllistnumber">
                <%= Html.Encode(iHillNumberInClassification)%>
            </td>
            <td class="hillname">
                 <%=Html.ActionLink(item.Hillname, "HillDetails", new {id = item.Hillnumber})%>
            </td>
            <td class="hillclasses">
                <%= MyMVCApp.DAL.WalkingStick.HillClassesToLinks(item.Classification)%>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:#}", item.Metres))%>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:#}", item.Feet))%>
            </td>
            <td class="gridref">
                <%  if ( !string.IsNullOrEmpty(item.Gridref10)) {
                        Response.Write(Html.Encode(item.Gridref10));
                    } else {
                        Response.Write(Html.Encode(item.Gridref));
                    }
                %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:#}", item.Drop))%>
            </td>
            <td class="firstclimbeddate">
                <%= Html.Encode(String.Format("{0:D}", item.FirstClimbedDate))%>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:#}", item.NumberOfAscents))%>
            </td>
        </tr>
    
    <% 
        iHillNumberInClassification = iHillNumberInClassification + 1;
    }
    %>
    <tr>
        <td colspan="7">&nbsp;</td>    
    </tr>
   </table>
   <table class="hiddentable">
    <tr> 
        <td>
            <%= Model.PageNavigationLinks%>
        </td>
        <td>Page Size: <input type="text" name="pagesize" size="3" /></td>
        <td align="right">Showing <%: Model.RecordsShowing%> Hills</td>
    </tr>
    </table>
</asp:Content>

