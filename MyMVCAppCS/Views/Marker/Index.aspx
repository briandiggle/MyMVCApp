<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCAppCS.Models.PaginatedListMVC<MyMVCApp.DAL.Marker>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Browse Markers
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Browse Markers</h2>

    <p>
        <%: Html.ActionLink("Create New Marker", "Create") %>
    </p>
    
    <table class="datatable">
        <tr>
            <td colspan="6"><%= Model.PageNavigationLinks %></td>
            <td colspan="2">Showing <%: Model.RecordsShowing %> Markers</td>
        </tr>        
        <tr>
            <th>No.</th>
            
            <th>Action</th>
  
            <th>
                 <% if (ViewData["OrderBy"] == ("Title"))
                    {
                        Response.Write("<strong>");

                        if (ViewData["OrderAscDesc"] == ("Asc"))
                        {
                            Response.Write(Html.ActionLink("Title <Asc>", "Index", new { OrderBy = "TitleDesc" }));
                        }
                        else
                        {
                            Response.Write(Html.ActionLink("Title <Desc>", "Index", new { OrderBy = "TitleAsc" }));
                        }
                        Response.Write("</strong>");
                    }
                    else
                    {
                        Response.Write(Html.ActionLink("Title", "Index", new { OrderBy = "TitleDesc" }));
                    }
                 %>                
            </th>
            <th width="30%">
                Description
            </th>
            <th>
                <% if (ViewData["OrderBy"] == "Walk")
                   {
                       Response.Write("<strong>");
                       if (ViewData["OrderAscDesc"] == "Asc")
                       {
                           Response.Write(Html.ActionLink("Associated Walk <Asc>", "Index", new { OrderBy = "WalkDesc" }));
                       }
                       else
                       {
                           Response.Write(Html.ActionLink("Associated Walk <Desc>", "Index", new { OrderBy = "WalkAsc" }));
                       }
                       Response.Write("</strong>");
                   }
                   else
                   {
                       Response.Write(Html.ActionLink("Walk", "Index", new { OrderBy = "WalkAsc" }));
                   }
                %>
            </th>
             <th>
                <% if (ViewData["OrderBy"] == "WalkArea")
                   {
                       Response.Write("<strong>");
                       if (ViewData["OrderAscDesc"] == "Asc")
                       {
                           Response.Write(Html.ActionLink("Walk Area<Asc>", "Index", new { OrderBy = "WalkAreaDesc" }));
                       }
                       else
                       {
                           Response.Write(Html.ActionLink("Walk Area<Desc>", "Index", new { OrderBy = "WalkAreaAsc" }));
                       }
                       Response.Write("</strong>");
                   }
                   else
                   {
                       Response.Write(Html.ActionLink("Walk Area", "Index", new { OrderBy = "WalkAreaAsc" }));
                   }
                %>
            </th>
                     

            <th><% if (ViewData["OrderBy"] == "Date")
                   {
                       Response.Write("<strong>");
                       if (ViewData["OrderAscDesc"] == "Asc")
                       {
                           Response.Write(Html.ActionLink("Date Left <Asc>", "Index", new { OrderBy = "DateDesc" }));
                       }
                       else
                       {
                           Response.Write(Html.ActionLink("Date Left <Desc>", "Index", new { OrderBy = "DateAsc" }));
                       }
                       Response.Write("</strong>");
                   }
                   else
                   {
                       Response.Write(Html.ActionLink("Date", "Index", new { OrderBy = "DateAsc" }));
                   }
                %>
            </th>
            <th>
                 <% if (ViewData["OrderBy"] == "Status")
                    {
                        Response.Write("<strong>");
                        if (ViewData["OrderAscDesc"] == "Asc")
                        {
                            Response.Write(Html.ActionLink("Status <Asc>", "Index", new { OrderBy = "StatusDesc" }));
                        }
                        else
                        {
                            Response.Write(Html.ActionLink("Status <Desc>", "Index", new { OrderBy = "StatusAsc" }));
                        }
                        Response.Write("</strong>");
                    }
                    else
                    {
                        Response.Write(Html.ActionLink("Status", "Index", new { OrderBy = "StatusDesc" }));
                    }
                 %>
            </th>
        </tr>

      <% int itemNumber = ((Model.PageIndex - 1) * Model.PageSize);
         foreach (var item in Model) 
         {
             itemNumber = itemNumber + 1;
      %>
    
        <tr>
             <td><%: itemNumber.ToString() %></td>          
            <td>
                <%: Html.ActionLink("Edit", "Edit", new { id = item.MarkerID }) %>
            </td>
            <td>
               <%: Html.ActionLink(item.MarkerTitle, "Details", new { id = item.MarkerID }) %>
            </td>

            <td>
                <% if (item.Location_Description.Length > 200)
                   { %>
                    <%: item.Location_Description.Substring(0, 200) %>...
                <% }
                   else
                   {
                    %>
                 <%: item.Location_Description %>
                <% }

                %>
            </td>
            <td>
                <%
                if (item.Walk != null)
                {
                     Response.Write(item.Walk.WalkTitle);
                }
                %>
            </td>
            <td>
                <%
                if (item.Walk !=null)
                {
                       Response.Write(item.Walk.Area.Areaname);
                }
                %>
            </td>
            <td>
                <%:String.Format ("{0:D}", item.DateLeft ) %>
            </td>
            <td>
                <%:item.Status %>
            </td>
        </tr>
    
    <% }  %>

    </table>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
</asp:Content>

