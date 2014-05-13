<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of MyMVCAppCS.Models.PaginatedListMVC (Of MyMVCApp.DAL.Hill))" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Hills in <%= ViewData("AreaName")%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Hills in <%= ViewData("AreaName")%></h2>

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
             <%  If ViewData("OrderBy") = "Name" Then
                    Response.Write("<strong>")
                    If ViewData("OrderAscDesc") = "Asc" Then
                         Response.Write(Html.ActionLink("Name <Asc>", "HillsByArea", New With {.OrderBy = "NameDesc"}))
                    Else
                         Response.Write(Html.ActionLink("Name <Desc>", "HillsByArea", New With {.OrderBy = "NameAsc"}))
                    End If
                    Response.Write("</strong>")
                Else
                     Response.Write(Html.ActionLink("Name", "HillsByArea", New With {.OrderBy = "NameDesc"}))
                End If
                 %>
            </th>
            <th>
                Classification
            </th>
            <th>
              <%  If ViewData("OrderBy") = "Metres" Then
                    Response.Write("<strong>")
                    If ViewData("OrderAscDesc") = "Asc" Then
                          Response.Write(Html.ActionLink("Metres <Asc>", "HillsByArea", New With {.OrderBy = "MetresDesc"}))
                    Else
                          Response.Write(Html.ActionLink("Metres <Desc>", "HillsByArea", New With {.OrderBy = "MetresAsc"}))
                    End If
                    Response.Write("</strong>")
                Else
                      Response.Write(Html.ActionLink("Metres", "HillsByArea", New With {.OrderBy = "MetresDesc"}))
                End If
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
                <%  If ViewData("OrderBy") = "FirstAscent" Then
                       Response.Write("<strong>")
                       If ViewData("OrderAscDesc") = "Asc" Then
                            Response.Write(Html.ActionLink("Date Climbed <Asc>", "HillsByArea", New With {.OrderBy = "FirstAscentDesc"}))
                       Else
                            Response.Write(Html.ActionLink("Date Climbed <Desc>", "HillsByArea", New With {.OrderBy = "FirstAscentAsc"}))
                       End If
                       Response.Write("</strong>")
                   Else
                        Response.Write(Html.ActionLink("Date Climbed", "HillsByArea", New With {.OrderBy = "FirstAscentDesc"}))
                   End If
             %>
            </th>
            <th>
                Number of Ascents
            </th>
        </tr>

   <%  Dim iHillNumberInClassification = ((Model.PageIndex - 1) * Model.PageSize) + 1
        
        For Each item In Model%>
    
        <tr style="background-color: <%= MyMVCApp.DAL.WalkingStick.NumberOfAscentsAsColour(item.NumberOfAscents) %>">
            <td>
                <%=Html.ActionLink(item.Hillname, "HillDetails", New With {.id = item.Hillnumber})%>
            </td>
  
            <td>
               <%= MyMVCApp.DAL.WalkingStick.HillClassesToLinks(item.Classification)%>
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
             <td>
                <%= Html.Encode(String.Format("{0:#}", item.NumberOfAscents))%>
             </td>
        </tr>
    
    <% Next%>

    </table>

</asp:Content>

