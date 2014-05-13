﻿<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of WalkingMVC.PaginatedListMVC (Of WalkingMVC.WalkingMVC.Marker))" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Browse Markers
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Browse Markers</h2>

    <p>
        <%: Html.ActionLink("Create New Marker", "Create")%>
    </p>
    
    <table class="datatable">
        <tr><td colspan="5"><%= Model.PageNavigationLinks%></td></tr>        
        <tr>
            <th>No.</th>
            
            <th>Action</th>
  
            <th>
                 <%  If ViewData("OrderBy") = "Title" Then
                         Response.Write("<strong>")
                         If ViewData("OrderAscDesc") = "Asc" Then
                             Response.Write(Html.ActionLink("Title <Asc>", "Index", New With {.OrderBy = "TitleDesc"}))
                         Else
                             Response.Write(Html.ActionLink("Title <Desc>", "Index", New With {.OrderBy = "TitleAsc"}))
                         End If
                         Response.Write("</strong>")
                     Else
                         Response.Write(Html.ActionLink("Title", "Index", New With {.OrderBy = "TitleDesc"}))
                     End If
                 %>                
            </th>
            <th width="40%">
                Description
            </th>
            <th>
                <%  If ViewData("OrderBy") = "Walk" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("Associated Walk <Asc>", "Index", New With {.OrderBy = "WalkDesc"}))
                        Else
                            Response.Write(Html.ActionLink("Associated Walk <Desc>", "Index", New With {.OrderBy = "WalkAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                        Response.Write(Html.ActionLink("Walk", "Index", New With {.OrderBy = "WalkAsc"}))
                    End If
                 %>
            </th>
            <th><%  If ViewData("OrderBy") = "Date" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("Date Left <Asc>", "Index", New With {.OrderBy = "DateDesc"}))
                        Else
                            Response.Write(Html.ActionLink("Date Left <Desc>", "Index", New With {.OrderBy = "DateAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                        Response.Write(Html.ActionLink("Date", "Index", New With {.OrderBy = "DateAsc"}))
                    End If
                 %>
            </th>
            <th>
                 <%  If ViewData("OrderBy") = "Status" Then
                         Response.Write("<strong>")
                         If ViewData("OrderAscDesc") = "Asc" Then
                             Response.Write(Html.ActionLink("Status <Asc>", "Index", New With {.OrderBy = "StatusDesc"}))
                         Else
                             Response.Write(Html.ActionLink("Status <Desc>", "Index", New With {.OrderBy = "StatusAsc"}))
                         End If
                         Response.Write("</strong>")
                     Else
                         Response.Write(Html.ActionLink("Status", "Index", New With {.OrderBy = "StatusDesc"}))
                     End If
                 %>
            </th>
        </tr>

      <%  Dim itemNumber As Integer = ((Model.PageIndex - 1) * Model.PageSize)
        For Each item In Model
            itemNumber = itemNumber + 1
            %>
    
        <tr>
             <td><%: itemNumber.ToString %></td>          
            <td>
                <%: Html.ActionLink("Edit", "Edit", New With {.id = item.MarkerID})%>
            </td>
            <td>
               <%: Html.ActionLink(item.MarkerTitle, "Details", New With {.id = item.MarkerID})%>
            </td>

            <td>
                <%: item.Location_Description %>
            </td>
            <td>
                <%: item.Walk.WalkTitle %>
            </td>
            <td>
                <%: String.Format("{0:D}", item.DateLeft) %>
            </td>
            <td>
                <%: item.Status %>
            </td>
        </tr>
    
    <% Next%>

    </table>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
</asp:Content>

