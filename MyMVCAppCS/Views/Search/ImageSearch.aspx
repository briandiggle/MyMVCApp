<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCAppCS.ViewModels.ImageSearchViewModel>" %>
<%@ Import Namespace="MyMVCApp.DAL" %>
<%@ Import namespace="MyMVCAppCS.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Search Walking Database for Images
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Image Search</h2>
    
<% 
        if ( Model.ImageResultsAvailable && Model.ImagesFound.Count == 0)
        {
            Response.Write("<p><strong>No images found to match your search criteria" + "</strong></p>");
        }
        else if (Model.ImageResultsAvailable && Model.ImagesFound.Count > 0)
        {
            Response.Write(Model.SearchSummary);
            Response.Write("<p><strong>" + Model.ImagesFound.Count.ToString() + " images found" + "</strong></p>");
%>
       <table>
        <tr>
            <th>No</th>
            <th>Image</th>
            <th>Caption</th>
            <th>Walk</th>
            <th>Date</th>
        </tr>           
      <%
             int iResultCounter = 0;
             foreach (Walk_AssociatedFile imageFile in Model.ImagesFound)
             {
                 iResultCounter++;
%>        
        <tr>
             <td><%: iResultCounter.ToString() %></td>            
             <td><%= ImageHelper.BuildImgTag(imageFile.Walk_AssociatedFile_Name) %></td>
            <td><span class="verysmall"><%: imageFile.Walk_AssociatedFile_Name %>:</span><br/>&nbsp;<br/>
                 <em><%: imageFile.Walk_AssociatedFile_Caption %></em>
             </td>
       
             <td> <%:Html.ActionLink(imageFile.Walk.WalkTitle, "Details", "Walks", new { id = imageFile.Walk.WalkID }, new { dummy = 1 })%></td>
             <td><%: imageFile.Walk.WalkDate.ToString("dd MMMM yyyy") %></td>
        </tr>
 
<%
             }
%>
      </table>
      <p><strong>Amend your search terms below</strong></p>
<%            
        }

    using (Html.BeginForm())
    {
%>
     <%: Html.ValidationSummary(true) %>
    
        <table>
            <tr>
                <td class="searchform">Image Caption</td> 
                <td class="searchform"><%: Html.TextBoxFor(model => model.SearchImageCaption, new { style = "width:300px" }) %>
                    <%: Html.ValidationMessageFor(model => model.SearchImageCaption) %></td>               
                <td class="searchform">multiple terms use AND</td> 
            </tr>
          <tr>
                <td class="searchform">Image Name</td> 
                <td class="searchform"><%: Html.TextBoxFor(model => model.SearchImageName, new { style = "width:300px" }) %></td>               
                <td class="searchform"></td> 
            </tr>
          <tr>
                <td class="searchform">Marker Name</td> 
                <td class="searchform"> <%: Html.TextBoxFor(model => model.SearchMarkerName, new { style = "width:300px" }) %></td>               
                <td class="searchform"></td> 
            </tr>
         <tr>
               <td colspan="3" class="searchform, aligncenter">
                    <input type="submit" value="Search for Matching Images" />
               </td>
           </tr>
         </table>   
<%
    }
%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
</asp:Content>
