<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<MyMVCApp.DAL.Class>>" %>

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
        int iCounter = 1;
        foreach(MyMVCApp.DAL.Class hillclass in Model)
        {
            if (iCounter == 1)
            {
                Response.Write("<tr>");
            }
            %>
            <td>
                <%=Html.ActionLink(hillclass.Classname, "HillsInClassification", new {id = hillclass.Classref})%> 
            </td>
    <% 
        iCounter++;
        if (iCounter == 4) 
        {
            Response.Write("</tr>");
            iCounter = 1;
        }
    }%>

    </table>

</asp:Content>

