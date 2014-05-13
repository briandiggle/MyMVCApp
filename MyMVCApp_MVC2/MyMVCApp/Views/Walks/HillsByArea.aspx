<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of WalkingMVC.PaginatedList (Of WalkingMVC.WalkingMVC.Hill))" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Hills in <%= ViewData("AreaName")%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><%= ViewData("AreaName")%></h2>

     <table class="datatable">
        <tr>
        <td>
        <%
        If Model.HasPreviousPage Then
                Response.Write(Html.RouteLink("Prev Page", "HillsByArea", New With {.page = Model.PageIndex - 1}))
                Response.Write("&nbsp;&nbsp;")
            End If
            If Model.HasNextPage Then
                Response.Write(Html.RouteLink("Next Page", "HillsByArea", New With {.page = Model.PageIndex + 1}))
            End If
    %>
    </td>
    <td>
    </td>
    <td colspan="6" align="right">Page <%=Model.PageIndex + 1%> of <%=Model.TotalPages%></td>
    </tr>
    <tr>
            <th>
                Name
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
                Drop
            </th>
            <th>
                Date Climbed
            </th>
        </tr>

    <% For Each item In Model%>
    
        <tr<% If item.numberofascents>0 Then Response.Write(" class=""climbed_hill_colour""" )%>>
            <td>
                <%=Html.ActionLink(item.Hillname, "HillDetails", New With {.id = item.Hillnumber})%>
            </td>
  
            <td>
                <%= Html.Encode(item.Classification) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:#}", item.Metres))%>
            </td>
            <td>
                 <%= Html.Encode(String.Format("{0:#}", item.Feet))%>
           </td>
 
            <td>
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
            <td>
               <%= Html.Encode(String.Format("{0:D}", item.FirstClimbedDate))%>
             </td>
        </tr>
    
    <% Next%>

    </table>

</asp:Content>

