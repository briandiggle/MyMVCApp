<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of MyMVCAppCS.Models.PaginatedListMVC (Of MyMVCApp.DAL.Walk))" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Walks By Date
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Browse Walks</h2>

    <table class="hiddentable">
        <tr>
            <td colspan="3"><%= Model.PageNavigationLinks%></td>
            <td></td>
            <td colspan="4" align="right">Showing <%: Model.RecordsShowing%> Walks</td>
        </tr>
    </table>
    <table class="datatable">
        <tr>
            <th></th>
            <th><%  If ViewData("OrderBy") = "Date" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("Date <Asc>", "WalksByDate", New With {.OrderBy = "DateDesc"}))
                        Else
                            Response.Write(Html.ActionLink("Date <Desc>", "WalksByDate", New With {.OrderBy = "DateAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                        Response.Write(Html.ActionLink("Date", "WalksByDate", New With {.OrderBy = "DateDesc"}))
                    End If
                 %>
            </th>
            <th>
               <%  If ViewData("OrderBy") = "Title" Then
                       Response.Write("<strong>")
                       If ViewData("OrderAscDesc") = "Asc" Then
                           Response.Write(Html.ActionLink("Title <Asc>", "WalksByDate", New With {.OrderBy = "TitleDesc"}))
                       Else
                           Response.Write(Html.ActionLink("Title <Desc>", "WalksByDate", New With {.OrderBy = "TitleAsc"}))
                       End If
                       Response.Write("</strong>")
                   Else
                       Response.Write(Html.ActionLink("Title", "WalksByDate", New With {.OrderBy = "TitleAsc"}))
                   End If
                 %>
            </th>

            <th>
               <%  If ViewData("OrderBy") = "Area" Then
                       Response.Write("<strong>")
                       If ViewData("OrderAscDesc") = "Asc" Then
                           Response.Write(Html.ActionLink("Area <Asc>", "WalksByDate", New With {.OrderBy = "AreaDesc"}))
                       Else
                           Response.Write(Html.ActionLink("Area <Desc>", "WalksByDate", New With {.OrderBy = "AreaAsc"}))
                       End If
                       Response.Write("</strong>")
                   Else
                       Response.Write(Html.ActionLink("Area", "WalksByDate", New With {.OrderBy = "AreaAsc"}))
                   End If
                 %>
            </th>
            <th>
                <%  If ViewData("OrderBy") = "Length" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("Length <Asc>", "WalksByDate", New With {.OrderBy = "LengthDesc"}))
                        Else
                            Response.Write(Html.ActionLink("Length <Desc>", "WalksByDate", New With {.OrderBy = "LengthAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                        Response.Write(Html.ActionLink("Length", "WalksByDate", New With {.OrderBy = "LengthDesc"}))
                    End If
                 %>
            </th>
           <th>
                <%  If ViewData("OrderBy") = "Ascent" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("Ascent <Asc>", "WalksByDate", New With {.OrderBy = "AscentDesc"}))
                        Else
                            Response.Write(Html.ActionLink("Ascent <Desc>", "WalksByDate", New With {.OrderBy = "AscentAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                        Response.Write(Html.ActionLink("Ascent", "WalksByDate", New With {.OrderBy = "AscentAsc"}))
                    End If
                 %>
            </th>
           <th>
                <%  If ViewData("OrderBy") = "TotalTime" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("TotalTime <Asc>", "WalksByDate", New With {.OrderBy = "TotalTimeDesc"}))
                        Else
                            Response.Write(Html.ActionLink("TotalTime <Desc>", "WalksByDate", New With {.OrderBy = "TotalTimeAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                        Response.Write(Html.ActionLink("TotalTime", "WalksByDate", New With {.OrderBy = "TotalTimeAsc"}))
                    End If
                 %>
            </th>
          <th>
                <%  If ViewData("OrderBy") = "OvlAvg" Then
                        Response.Write("<strong>")
                        If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("OvlAvg <Asc>", "WalksByDate", New With {.OrderBy = "OvlAvgDesc"}))
                        Else
                            Response.Write(Html.ActionLink("OvlAvg <Desc>", "WalksByDate", New With {.OrderBy = "OvlAvgAsc"}))
                        End If
                        Response.Write("</strong>")
                    Else
                        Response.Write(Html.ActionLink("OvlAvg", "WalksByDate", New With {.OrderBy = "OvlAvgAsc"}))
                    End If
                 %>
            </th>
        </tr>

    <% For Each item In Model%>
    
        <tr>
            <td>
                <%: Html.ActionLink("Edit", "Edit", New With {.id = item.WalkID})%>
             </td>
            <td>
                <%: String.Format("{0:D}", item.WalkDate)%>
            </td>
            <td>
                <%: Html.ActionLink(item.WalkTitle, "Details", New With {.id = item.WalkID})%>
            </td>
            <td>               
            <%: Html.ActionLink(item.WalkAreaName, "HillsByArea", New With {.id = item.Area.Arearef.Trim})%>
            </td>
            <td>
                <%: item.CartographicLength%>
            </td>
          <td>
                <%: item.MetresOfAscent%>
            </td>
         <td>
                <%: MyMVCApp.DAL.WalkingStick.ConvertTotalTimeToString(item.WalkTotalTime, True)%>
            </td>      
            <td>
                <%: item.WalkAverageSpeedKmh%>
            </td>                                 
        </tr>
    
    <% Next%>
       <tr>
            <td colspan="8"></td>
       </tr>
       <tr>
            <td colspan="8"><%= Model.PageNavigationLinks%></td>
        </tr>
    </table>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
</asp:Content>

