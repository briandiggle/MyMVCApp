﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCAppCS.ViewModels.WalkSearchViewModel>" %>
<%@ Import Namespace="MyMVCApp.DAL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Search walking database for Walks
</asp:Content>
<asp:Content ID="ViewSpecifiedHead1" ContentPlaceHolderID="ViewSpecificHead" runat="server">
<script src="../../Scripts/MicrosoftAjax.js" type="text/javascript"></script>
<script src="../../Scripts/MicrosoftMvcValidation.js" type="text/javascript"></script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<% Html.EnableClientValidation();%>
    <h2>Walk Search</h2>

    <%-- The following line works around an ASP.NET compiler warning --%>
    <%: ""%>
    
       <% 
        if ( Model.WalkResultsAvailable)
        {
            Response.Write(Model.SearchSummary);
            Response.Write("<p><strong>" + Model.WalksFound.Count.ToString() + " walks found" + "</strong></p>");
        %>
        <table>
        <tr>
            <th>No.</th>
            <th>Walk Title</th>
            <th>Walk Area</th>
            <th>Length</th>
            <th>Ascent (m)</th>
            <th>Duration</th>
            <th>Overall Speed</th>
            <th>Date</th>
        </tr>   
      
        <%
             int iResultCounter = 0;
             foreach ( Walk walk in Model.WalksFound )
             {
                 iResultCounter++;
        %>
         <tr>
             <td><%: iResultCounter.ToString() %></td>
            <td>
                 <%:Html.ActionLink(walk.WalkTitle, "Details", "Walks", new {id = walk.WalkID}, new {dummy=1}) %>
            </td>
            <td>
                <%: Html.ActionLink(walk.WalkAreaName, "HillsByArea", "Walks", new { id = walk.Area.Arearef.Trim() }, new { dummy = 1 })%>               
            
            </td>
            <td>
                <%: walk.CartographicLength%>
            </td>
          <td>
                <%: walk.MetresOfAscent%>
            </td>
         <td>
                <%: WalkingStick.ConvertTotalTimeToString(walk.WalkTotalTime, true)%>
            </td>      
            <td>
                <%: walk.WalkAverageSpeedKmh%>
            </td>                           
            <td>
                <%: walk.WalkDate.ToString("dd MMMM yyyy") %>
            </td>
         </tr>
            
               <% 
               }
        %>
          </table>
      
    
          <%
         }
     using (Html.BeginForm()) 
       {
           %>
        <%: Html.ValidationSummary(true) %>
    
        <table>
            <tr>
                <td class="searchform">Title</td> 
                <td class="searchform"><%: Html.TextBoxFor(model => model.SearchTitle, new { style="width:300px"})%>
                    <%: Html.ValidationMessageFor(model => model.SearchTitle) %></td>               
                <td class="searchform">multiple terms use AND</td> 
            </tr>
          <tr>
                <td class="searchform">Description</td> 
                <td class="searchform"><%: Html.TextBoxFor(model => model.SearchWalkDescription, new { style = "width:300px" })%></td>               
                <td class="searchform"></td> 
            </tr>
          <tr>
                <td class="searchform">Image Captions</td> 
                <td class="searchform"> <%: Html.TextBoxFor(model => model.SearchImageCaptions, new { style = "width:300px" })%></td>               
                <td class="searchform"></td> 
            </tr>
          <tr>
                <td class="searchform">Hill Ascended</td> 
                <td class="searchform"><%: Html.TextBoxFor(model => model.SearchHillAscended, new { style = "width:300px" })%></td>               
                <td class="searchform"></td> 
            </tr>
          <tr>
                <td class="searchform">Length</td> 
                <td class="searchform">
                    <%: Html.DropDownListFor(model => model.LengthGtLt, Model.LengthGtLtList) %>
                    <%: Html.TextBoxFor(model => model.SearchLength, new { style = "width:100px" })%>
                </td>               
                <td class="searchform"></td> 
            </tr>
          <tr>
                <td class="searchform">Ascent</td> 
                <td class="searchform">
                      <%: Html.DropDownListFor(model => model.AscentGtLt, Model.AscentGtLtList) %>
                      <%: Html.TextBoxFor(model => model.SearchAscent, new { style = "width:100px" })%>
                </td>
                <td class="searchform"></td> 
            </tr>
          <tr>
                <td class="searchform">Overall Speed</td> 
                <td class="searchform">
                      <%: Html.DropDownListFor(model => model.OverallSpeedGtLt, Model.OverallSpeedGtLtList) %>
                      <%: Html.TextBoxFor(model => model.SearchOverallSpeed, new { style = "width:100px" })%> 
                </td> 
                <td class="searchform"></td> 
            </tr>
          <tr>
                <td class="searchform">Date from</td> 
                <td class="searchform">
                      <%: Html.TextBoxFor(model => model.DateFromDay, new { style = "width:50px" })%>  <%: Html.DropDownListFor(model => model.DateFromMonth, Model.DateFromMonthList)%>  <%: Html.TextBoxFor(model => model.DateFromYear, new { style = "width:50px" })%><br/>
                </td> 
                <td class="searchform"></td> 
            </tr>                                                                                         
         <tr>
                <td class="searchform">Date to</td> 
                <td class="searchform">
                       <%: Html.TextBoxFor(model => model.DateToDay, new { style = "width:50px" })%>    <%: Html.DropDownListFor(model => model.DateToMonth, Model.DateToMonthList)%>    <%: Html.TextBoxFor(model => model.DateToYear, new { style = "width:50px" })%> 
                </td> 
                <td class="searchform"></td> 
         </tr>                                                                                         
        <tr>
                <td class="searchform">Duration</td> 
                <td class="searchform">
                      <%: Html.DropDownListFor(model => model.DurationGtLt, Model.DurationGtLtList) %>
                      <%: Html.TextBoxFor(model => model.SearchDurationHours, new { style = "width:50px" })%>  hr  
                      <%: Html.TextBoxFor(model => model.SearchDurationMins, new { style = "width:50px" })%>  min  
                </td>                        
                <td class="searchform"></td> 
            </tr>          
        <tr>
                <td class="searchform">Field Combination</td> 
                <td class="searchform">
                       <%: Html.DropDownListFor(model => model.FieldCombination, Model.FieldCombinationList)%> 
                </td> 
                <td class="searchform"></td> 
         </tr>                      
          
           <tr>
               <td colspan="3" class="searchform, aligncenter">
                    <input type="submit" value="Search for Matching Walks" />
               </td>
           </tr>
    </table>   
        
     
 <%
       }
       %>
 
</asp:Content>


