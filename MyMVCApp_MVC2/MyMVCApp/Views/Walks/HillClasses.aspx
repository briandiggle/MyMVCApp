<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of IEnumerable (Of WalkingMVC.WalkingMVC.Class))" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Hill Classifications
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Hill Classifications</h2>
    
    <table>
        <tr>
            <th colspan="3">Hill Classification</th>
        </tr>

    <%  
        Dim iCounter As Integer = 1
        For Each item In Model
            If iCounter = 1 Then
                Response.Write("<tr>")
            End If
            %>
            <td>
                <%=Html.ActionLink(item.Classname, "HillsInClassification", New With {.id = item.Classref})%> 
            </td>
    <% 
        iCounter = iCounter + 1
        If iCounter = 4 Then
            Response.Write("</tr>")
            iCounter = 1
        End If
    Next%>

    </table>

</asp:Content>

