<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCAppCS.Models.PaginatedListMVC<MyMVCApp.DAL.Hill>>" %>
<%@ Import Namespace="MyMVCApp.DAL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Hills in <%= ViewData["AreaName"]%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Hills in <%= ViewData["AreaName"]%></h2>

     <table class="datatable">
     <tr>
        <td>
           <%= Model.PageNavigationLinks%>
        </td>
        <td>
        </td>
       <td colspan="7" align="right">Showing <%: Model.RecordsShowing%> Hills</td>
    </tr>
    <tr>
            <th>
             <%  if ( ViewData["OrderBy"].Equals("Name")) 
                 {
                    Response.Write("<strong>");
                    if ( ViewData["OrderAscDesc"].Equals("Asc"))
                    {
                        Response.Write(Html.ActionLink("Name <Asc>", "HillsByArea", new { OrderBy = "NameDesc" }));
                    } else
                    {
                        Response.Write(Html.ActionLink("Name <Desc>", "HillsByArea", new { OrderBy = "NameAsc" }));
                    }
                    Response.Write("</strong>");
                } else
                {
                     Response.Write(Html.ActionLink("Name", "HillsByArea", new { OrderBy = "NameDesc" }));
                }
                 %>
            </th>
            <th>
                Classif (ication
            </th>
            <th>
              <%  if ( ViewData["OrderBy"].Equals("Metres"))
                  {
                    Response.Write("<strong>");
                    if ( ViewData["OrderAscDesc"].Equals("Asc"))
                    {
                        Response.Write(Html.ActionLink("Metres <Asc>", "HillsByArea", new { OrderBy = "MetresDesc" }));
                    } else
                    {
                        Response.Write(Html.ActionLink("Metres <Desc>", "HillsByArea", new { OrderBy = "MetresAsc" }));
                    }
                    Response.Write("</strong>");
                  } else
                {
                      Response.Write(Html.ActionLink("Metres", "HillsByArea", new { OrderBy = "MetresDesc" }));
                }
             %>
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
                <%  if ( ViewData["OrderBy"].Equals("FirstAscent"))
                    {
                        Response.Write("<strong>");
                       if ( ViewData["OrderAscDesc"].Equals("Asc"))
                       {
                           Response.Write(Html.ActionLink("Date Climbed <Asc>", "HillsByArea", new { OrderBy = "FirstAscentDesc" }));
                       } else
                       {
                           Response.Write(Html.ActionLink("Date Climbed <Desc>", "HillsByArea", new { OrderBy = "FirstAscentAsc" }));
                       }
                       Response.Write("</strong>");
                    } else
                    {
                        Response.Write(Html.ActionLink("Date Climbed", "HillsByArea", new { OrderBy = "FirstAscentDesc" }));
                    }
             %>
            </th>
            <th>
                Number of Ascents
            </th>
        </tr>

   <%   int iHillNumberInClassification = ((Model.PageIndex - 1) * Model.PageSize) + 1;

        foreach (Hill item in Model)
        { %>
    
        <tr style="background-color: <%= WalkingStick.NumberOfAscentsAsColour(item.NumberOfAscents) %>">
            <td>
                <%= Html.ActionLink(item.Hillname, "HillDetails", new { id = item.Hillnumber }) %>
            </td>
  
            <td>
               <%= WalkingStick.HillClassesToLinks(item.Classification) %>
            </td>
            <td>
                <%= Html.Encode(String.Format("{0:#}", item.Metres)) %>
            </td>
            <td>
                 <%= Html.Encode(String.Format("{0:#}", item.Feet)) %>
           </td>
 
            <td>
                <% if (!string.IsNullOrEmpty(item.Gridref10))
                   {
                       Response.Write(Html.Encode(item.Gridref10));
                   }
                   else
                   {
                       Response.Write(Html.Encode(item.Gridref));
                   }
                %>
            </td>
  
            <td>
                <%= Html.Encode(String.Format("{0:#}", item.Drop)) %>
            </td>
            <td>
               <%= Html.Encode(String.Format("{0:D}", item.FirstClimbedDate)) %>
             </td>
             <td>
                <%= Html.Encode(String.Format("{0:#}", item.NumberOfAscents)) %>
             </td>
        </tr>
    
    <%  } %>

    </table>

</asp:Content>

