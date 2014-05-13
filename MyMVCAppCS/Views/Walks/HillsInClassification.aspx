<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of MyMVCAppCS.Models.PaginatedListMVC (Of MyMVCApp.DAL.Hill))" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Hills In Classification <%= ViewData("HillClassName") %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 
    <h2><%= ViewData("HillClassName") %>s <em>(<%=ViewData("NumberClimbed")%> of <%= Model.TotalCount%> climbed)</em></h2>
    
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
            <%  If ViewData("OrderBy") = "Name" Then
                    Response.Write("<strong>")
                    If ViewData("OrderAscDesc") = "Asc" Then
                        Response.Write(Html.ActionLink("Name <Asc>", "HillsInClassification", New With {.OrderBy = "NameDesc"}))
                    Else
                        Response.Write(Html.ActionLink("Name <Desc>", "HillsInClassification", New With {.OrderBy = "NameAsc"}))
                    End If
                    Response.Write("</strong>")
                Else
                    Response.Write(Html.ActionLink("Name", "HillsInClassification", New With {.OrderBy = "NameDesc"}))
                End If
                 %>
            </th>
            <th>
            Classes
            </th>
            <th class="heightcell">
            <%  If ViewData("OrderBy") = "Metres" Then
                    Response.Write("<strong>")
                    If ViewData("OrderAscDesc") = "Asc" Then
                        Response.Write(Html.ActionLink("Metres <Asc>", "HillsInClassification", New With {.OrderBy = "MetresDesc"}))
                    Else
                        Response.Write(Html.ActionLink("Metres <Desc>", "HillsInClassification", New With {.OrderBy = "MetresAsc"}))
                    End If
                    Response.Write("</strong>")
                Else
                    Response.Write(Html.ActionLink("Metres", "HillsInClassification", New With {.OrderBy = "MetresDesc"}))
                End If
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
               <%  If ViewData("OrderBy") = "FirstAscent" Then
                       Response.Write("<strong>")
                       If ViewData("OrderAscDesc") = "Asc" Then
                           Response.Write(Html.ActionLink("Date Climbed <Asc>", "HillsInClassification", New With {.OrderBy = "FirstAscentDesc"}))
                       Else
                           Response.Write(Html.ActionLink("Date Climbed <Desc>", "HillsInClassification", New With {.OrderBy = "FirstAscentAsc"}))
                       End If
                       Response.Write("</strong>")
                   Else
                       Response.Write(Html.ActionLink("Date Climbed", "HillsInClassification", New With {.OrderBy = "FirstAscentDesc"}))
                   End If
             %>
            </th>
          <th class="heightcell">
               <%  If ViewData("OrderBy") = "NumberAscent" Then
                       Response.Write("<strong>")
                       If ViewData("OrderAscDesc") = "Asc" Then
                           Response.Write(Html.ActionLink("Ascents <Asc>", "HillsInClassification", New With {.OrderBy = "NumberAscentDesc"}))
                       Else
                           Response.Write(Html.ActionLink("Ascents <Desc>", "HillsInClassification", New With {.OrderBy = "NumberAscentAsc"}))
                       End If
                       Response.Write("</strong>")
                   Else
                       Response.Write(Html.ActionLink("Ascents", "HillsInClassification", New With {.OrderBy = "NumberAscentDesc"}))
                   End If
             %>
            </th>
        </tr>

    <%  Dim iHillNumberInClassification = ((Model.PageIndex - 1) * Model.PageSize) + 1
        
        For Each item In Model%>
    
        <tr style="background-color: <%= MyMVCApp.DAL.WalkingStick.NumberOfAscentsAsColour(item.NumberOfAscents) %>">
            <td class="hilllistnumber">
                <%= Html.Encode(iHillNumberInClassification)%>
            </td>
            <td class="hillname">
                 <%=Html.ActionLink(item.Hillname, "HillDetails", New With {.id = item.Hillnumber})%>
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
                <%  If Not IsNothing(item.Gridref10) AndAlso item.Gridref10.Length > 0 Then
                        Response.Write(Html.Encode(item.Gridref10))
                    Else
                        Response.Write(Html.Encode(item.Gridref))
                    End If
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
        iHillNumberInClassification = iHillNumberInClassification + 1
    Next%>
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

