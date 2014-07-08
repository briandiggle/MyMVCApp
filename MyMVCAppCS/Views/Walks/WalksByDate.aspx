<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCAppCS.Models.PaginatedListMVC<MyMVCApp.DAL.Walk>>" %>
<%@ Import Namespace="MyMVCApp.DAL" %>

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
            <th><%  if (ViewData["OrderBy"].Equals("Date"))
                    {
                        Response.Write("<strong>");
                        if (ViewData["OrderAscDesc"].Equals("Asc"))
                        {
                            Response.Write(Html.ActionLink("Date <Asc>", "WalksByDate", new { OrderBy = "DateDesc" }));
                        } else
                        {
                            Response.Write(Html.ActionLink("Date <Desc>", "WalksByDate", new { OrderBy = "DateAsc" }));
                        }
                        Response.Write("</strong>");
                    } else
                    {
                        Response.Write(Html.ActionLink("Date", "WalksByDate", new { OrderBy = "DateDesc" }));
                    }
                 %>
            </th>
            <th>
               <%  if (ViewData["OrderBy"].Equals("Title"))
                   {
                       Response.Write("<strong>");
                       if (ViewData["OrderAscDesc"].Equals("Asc"))
                       {
                           Response.Write(Html.ActionLink("Title <Asc>", "WalksByDate", new { OrderBy = "TitleDesc" }));
                       } else
                       {
                           Response.Write(Html.ActionLink("Title <Desc>", "WalksByDate", new { OrderBy = "TitleAsc" }));
                       }
                       Response.Write("</strong>");
                   } else
                   {
                       Response.Write(Html.ActionLink("Title", "WalksByDate", new { OrderBy = "TitleAsc" }));
                   }
                 %>
            </th>

            <th>
               <%  if (ViewData["OrderBy"].Equals("Area"))
                   {
                       Response.Write("<strong>");
                       if (ViewData["OrderAscDesc"].Equals("Asc"))
                       {
                           Response.Write(Html.ActionLink("Area <Asc>", "WalksByDate", new { OrderBy = "AreaDesc" }));
                       } else
                       {
                           Response.Write(Html.ActionLink("Area <Desc>", "WalksByDate", new { OrderBy = "AreaAsc" }));
                       }
                       Response.Write("</strong>");
                   } else
                   {
                       Response.Write(Html.ActionLink("Area", "WalksByDate", new { OrderBy = "AreaAsc" }));
                   }
                 %>
            </th>
            <th>
                <%  if (ViewData["OrderBy"].Equals("Length"))
                    {
                        Response.Write("<strong>");
                        if (ViewData["OrderAscDesc"].Equals("Asc"))
                        {
                            Response.Write(Html.ActionLink("Length <Asc>", "WalksByDate", new { OrderBy = "LengthDesc" }));
                        } else
                        {
                            Response.Write(Html.ActionLink("Length <Desc>", "WalksByDate", new { OrderBy = "LengthAsc" }));
                        }
                        Response.Write("</strong>");
                    } else
                    {
                        Response.Write(Html.ActionLink("Length", "WalksByDate", new { OrderBy = "LengthDesc" }));
                    }
                 %>
            </th>
           <th>
                <%  if (ViewData["OrderBy"].Equals("Ascent"))
                    {
                        Response.Write("<strong>");
                        if (ViewData["OrderAscDesc"].Equals("Asc"))
                        {
                            Response.Write(Html.ActionLink("Ascent <Asc>", "WalksByDate", new { OrderBy = "AscentDesc" }));
                        } else
                        {
                            Response.Write(Html.ActionLink("Ascent <Desc>", "WalksByDate", new { OrderBy = "AscentAsc" }));
                        }
                        Response.Write("</strong>");
                    } else
                    {
                        Response.Write(Html.ActionLink("Ascent", "WalksByDate", new { OrderBy = "AscentAsc" }));
                    }
                 %>
            </th>
           <th>
                <%  if (ViewData["OrderBy"].Equals("TotalTime"))
                    {
                        Response.Write("<strong>");
                        if (ViewData["OrderAscDesc"].Equals("Asc"))
                        {
                            Response.Write(Html.ActionLink("TotalTime <Asc>", "WalksByDate", new { OrderBy = "TotalTimeDesc" }));
                        } else
                        {
                            Response.Write(Html.ActionLink("TotalTime <Desc>", "WalksByDate", new { OrderBy = "TotalTimeAsc" }));
                        }
                        Response.Write("</strong>");
                    } else
                    {
                        Response.Write(Html.ActionLink("TotalTime", "WalksByDate", new { OrderBy = "TotalTimeAsc" }));
                    }
                 %>
            </th>
          <th>
                <%  if (ViewData["OrderBy"].Equals("OvlAvg"))
                    {
                        Response.Write("<strong>");
                        if (ViewData["OrderAscDesc"].Equals("Asc"))
                        {
                            Response.Write(Html.ActionLink("OvlAvg <Asc>", "WalksByDate", new { OrderBy = "OvlAvgDesc" }));
                        } else
                        {
                            Response.Write(Html.ActionLink("OvlAvg <Desc>", "WalksByDate", new { OrderBy = "OvlAvgAsc" }));
                        }
                        Response.Write("</strong>");
                    } else
                    {
                        Response.Write(Html.ActionLink("OvlAvg", "WalksByDate", new { OrderBy = "OvlAvgAsc" }));
                    }
                 %>
            </th>
        </tr>

    <% foreach (Walk item in Model)
       {
    %>
        <tr>
            <td>
                <%: Html.ActionLink("Edit", "Edit", new { id = item.WalkID }) %>
             </td>
            <td>
                <%: String.Format("{0:D}", item.WalkDate) %>
            </td>
            <td>
                <%: Html.ActionLink(item.WalkTitle, "Details", new { id = item.WalkID }) %>
            </td>
            <td>               
            <%: Html.ActionLink(item.WalkAreaName, "HillsByArea", new { id = item.Area.Arearef.Trim() }) %>
            </td>
            <td>
                <%: item.CartographicLength %>
            </td>
          <td>
                <%: item.MetresOfAscent %>
            </td>
         <td>
                <%: WalkingStick.ConvertTotalTimeToString(item.WalkTotalTime, true) %>
            </td>      
            <td>
                <%: item.WalkAverageSpeedKmh %>
            </td>                                 
        </tr>
    
    <% }  %>
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

