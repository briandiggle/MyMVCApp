<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of WalkingMVC.PaginatedListMVC (Of WalkingMVC.WalkingMVC.HillAscent))" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Browse Hill Ascents
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Browse Hill Ascents</h2>

    <table class="datatable">
       <tr><td colspan="5"><%= Model.PageNavigationLinks%></td></tr>
        
        <tr>
            <th>No.</th>
            <th><%  If ViewData("OrderBy") = "Date" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                                Response.Write(Html.ActionLink("Date <Asc>", "Index", New With {.OrderBy = "DateDesc"}))
                        Else
                                Response.Write(Html.ActionLink("Date <Desc>", "Index", New With {.OrderBy = "DateAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                            Response.Write(Html.ActionLink("Date", "Index", New With {.OrderBy = "DateDesc"}))
                    End If
                 %>
            </th>
            <th><%  If ViewData("OrderBy") = "Hill" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("Hill <Asc>", "Index", New With {.OrderBy = "HillDesc"}))
                        Else
                            Response.Write(Html.ActionLink("Hill <Desc>", "Index", New With {.OrderBy = "HillAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                        Response.Write(Html.ActionLink("Hill", "Index", New With {.OrderBy = "HillAsc"}))
                    End If
                 %>
            </th>
            <th><%  If ViewData("OrderBy") = "Metres" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("Metres <Asc>", "Index", New With {.OrderBy = "MetresDesc"}))
                        Else
                            Response.Write(Html.ActionLink("Metres <Desc>", "Index", New With {.OrderBy = "MetresAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                        Response.Write(Html.ActionLink("Metres", "Index", New With {.OrderBy = "MetresDesc"}))
                    End If
                 %>
            </th>
            <th><%  If ViewData("OrderBy") = "Walk" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("Walk <Asc>", "Index", New With {.OrderBy = "WalkDesc"}))
                        Else
                            Response.Write(Html.ActionLink("Walk <Desc>", "Index", New With {.OrderBy = "WalkAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                        Response.Write(Html.ActionLink("Walk", "Index", New With {.OrderBy = "WalkAsc"}))
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
                <%: String.Format("{0:D}", item.AscentDate)%>
            </td>
            <td>
                <%: Html.ActionLink(item.Hill.Hillname, "HillDetails", "Walks", New With {.id = item.Hillnumber}, New With {.dummy = 1})%>
            </td>
           <td>
               <%: item.Hill.Metres.ToString %>
            </td>
            <td>
                 <%: Html.ActionLink(item.Walk.WalkTitle, "Details", "Walks", New With {.id = item.WalkID}, New With {.dummy = 1})%>
            </td>
        </tr>
    
    <% Next%>

    </table>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
</asp:Content>

