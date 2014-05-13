<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCAppCS.Models.PaginatedListMVC<MyMVCApp.DAL.HillAscent>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Browse Hill Ascents
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Browse Hill Ascents</h2>

    <table class="datatable">
       <tr><td colspan="5"><%= Model.PageNavigationLinks%></td></tr>
        
        <tr>
            <th>No.</th>
            <th><%  if (ViewData["OrderBy"] == "Date")
                    {
                        Response.Write("<strong>");
                        if (ViewData["OrderAscDesc"] == "Asc")
                        {
                            Response.Write(Html.ActionLink("Date <Asc>", "Index", new {OrderBy = "DateDesc"}));
                        }
                        else
                        {
                            Response.Write(Html.ActionLink("Date <Asc>", "Index", new {OrderBy = "DateAsc"}));                        
                        }
                        Response.Write("</strong>");
                    }
                    else
                    {
                         Response.Write(Html.ActionLink("Date", "Index", new {OrderBy = "DateAsc"}));         
                    }
                 %>
            </th>
            <th><%  if (ViewData["OrderBy"] == "Hill")
                    {
                        Response.Write("<strong>");
                        if (ViewData["OrderAscDesc"] == "Asc")
                        {
                            Response.Write(Html.ActionLink("Hill <Asc>", "Index", new {OrderBy = "HillDesc"}));
                        }
                        else
                        {
                            Response.Write(Html.ActionLink("Hill <Asc>", "Index", new {OrderBy = "HillAsc"}));                        
                        }
                        Response.Write("</strong>");
                    }
                    else
                    {
                         Response.Write(Html.ActionLink("Hill", "Index", new {OrderBy = "HillAsc"}));         
                    }
               
                 %>
            </th>
            <th><%  if (ViewData["OrderBy"] == "Metres")
                    {
                        Response.Write("<strong>");
                        if (ViewData["OrderAscDesc"] == "Asc")
                        {
                            Response.Write(Html.ActionLink("Metres <Asc>", "Index", new {OrderBy = "MetresDesc"}));
                        }
                        else
                        {
                            Response.Write(Html.ActionLink("Metres <Asc>", "Index", new {OrderBy = "MetresAsc"}));                        
                        }
                        Response.Write("</strong>");
                    }
                    else
                    {
                         Response.Write(Html.ActionLink("Metres", "Index", new {OrderBy = "MetresAsc"}));         
                    }
                 %>
            </th>
            <th><%  if (ViewData["OrderBy"] == "Walk")
                    {
                        Response.Write("<strong>");
                        if (ViewData["OrderAscDesc"] == "Asc")
                        {
                            Response.Write(Html.ActionLink("Walk <Asc>", "Index", new {OrderBy = "WalkDesc"}));
                        }
                        else
                        {
                            Response.Write(Html.ActionLink("Walk <Asc>", "Index", new {OrderBy = "WalkAsc"}));                        
                        }
                        Response.Write("</strong>");
                    }
                    else
                    {
                         Response.Write(Html.ActionLink("Walk", "Index", new {OrderBy = "WalkAsc"}));         
                    }
                 %>
            </th>
        </tr>

    <% var itemNumber = ((Model.PageIndex - 1) * Model.PageSize);
        foreach (var item in Model)
        {
            itemNumber++; %>
    
        <tr>
            <td><%: itemNumber.ToString() %></td>
            <td>
                <%: String.Format("{0:D}", item.AscentDate) %>
            </td>
            <td>
                <%: Html.ActionLink(item.Hill.Hillname, "HillDetails", "Walks", new {id = item.Hillnumber}, new {dummy=1}) %>
                 
            </td>
           <td>
               <%: item.Hill.Metres.ToString() %>
            </td>
            <td>
                 <%:Html.ActionLink(item.Walk.WalkTitle, "Details", "Walks", new {id = item.WalkID}, new {dummy=1}) %>
            </td>
        </tr>
    
    <% }%>

    </table>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
</asp:Content>

