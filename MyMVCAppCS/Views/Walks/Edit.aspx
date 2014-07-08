﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCApp.DAL.Walk>" %>
<%@ Import Namespace="MyMVCApp.Model" %>
<%@ Import Namespace="MyMVCApp.DAL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit <%= Model.WalkTitle%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
<link type="text/css" href="../../Content/themes/base/jquery.ui.all.css" rel="Stylesheet" />
<script type="text/javascript" src="../../Scripts/jquery-2.1.1.js"></script>
<script type="text/javascript" src="../../Scripts/jquery-ui-1.10.4.js"></script>
<script type="text/javascript" src="../../Scripts/jquery.validate.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="../../Scripts/CreateEditWalk.js"></script>
 
    <h2>Edit <em><%=Model.WalkTitle%></em></h2>

    <%-- The following line works around an ASP.NET compiler warning --%>
    <%: ""%>
    <% using (Html.BeginForm("Edit", "Walks", FormMethod.Post, new { id = "walkform", name = "walkform" }))
       { %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            
            <div class="editor-label">
              <%: Html.LabelFor(walk => walk.WalkDate) %>
            </div>
            <div class="editor-field">
               <%: Html.TextBoxFor(walk => walk.WalkDate, "{0:dd MMMM yyyy}", new { size = 40 }) %>                
            </div>
            &nbsp;
          <div class="editor-label">
                  <%: Html.LabelFor(walk => walk.WalkTitle) %>
           </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkTitle, new { size = 80 }) %>
            </div>&nbsp;
<!---Section: Walk Area-------------------------------------------------------------------------------->
          <div class="editor-label">
                    <%: Html.LabelFor(walk => walk.WalkAreaName) %>

            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkAreaName, new { size = 80 }) %> <%: Html.Hidden("WalkAreaID", Model.Area.Arearef) %>
             </div>&nbsp;                  
           <div class="editor-label">
                   <%: Html.LabelFor(walk => walk.WalkSummary) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkSummary, new { size = 80 }) %> Auto: <input type="checkbox" name="summary_auto" id="summary_auto" checked />
            </div>&nbsp;      
          <div class="editor-label">
                   <%: Html.LabelFor(walk => walk.WalkConditions) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkConditions, new { size = 80 }) %>
            </div>&nbsp;   
             
<!--Section: Summits Visited----------------------------------------------------------------------------------------->

           <div class="editor-label">
                <strong><%: Html.Label("Summits Visited") %></strong>
            </div>     
            <% for (int iHillAscentsCounter = 1; iHillAscentsCounter <= Model.HillAscents.Count; iHillAscentsCounter++)
               { %>
             <div class="editor-field" id="DivVisitedSummit<%= iHillAscentsCounter.ToString() %>">
                <%: Html.TextBox("VisitedSummit" + iHillAscentsCounter, WalkingStick.FormatHillSummaryAsLine(Model.HillAscents[iHillAscentsCounter - 1].Hill) + " ", new { size = 80 }) %> 
                <%: Html.Hidden("VisitedSummit" + iHillAscentsCounter + "HillID", Model.HillAscents[iHillAscentsCounter - 1].Hillnumber.ToString()) %>
            </div>
            <% } %>      
             <% for (int iHillVisitedCounter = Model.HillAscents.Count + 1; iHillVisitedCounter <= 15; iHillVisitedCounter++)
                {
             %>   
            <div class="editor-field" id="DivVisitedSummit<%= iHillVisitedCounter.ToString() %>">
                <%: Html.TextBox("VisitedSummit" + iHillVisitedCounter, "", new { size = 80 }) %> <%: Html.Hidden("VisitedSummit" + iHillVisitedCounter + "HillID") %>
            </div>
            <% } %>

<!-- Section: Markers Created---------------------------------------------------------------------------------------------------->            

            <% List<Marker> oWalkMarkersAlreadyCreated = (List<Marker>)ViewData["WalkMarkersAlreadyCreated"];
               if (oWalkMarkersAlreadyCreated.Count > 0)
               { %>&nbsp;
            <div class="editor-label"><strong>Markers created for this walk</strong></div>    
            <div class="editor-field">
            <table>
            <tr>
                <th>Name</th>
                <th>GPS Reference</th>
                <th>Description</th>
            </tr>
            <% foreach (Marker oWalkMarker in oWalkMarkersAlreadyCreated)
               {
            %>
            <tr>
                <td><%= oWalkMarker.MarkerTitle %></td>
                <td><%= oWalkMarker.GPS_Reference %></td>
                <td><%= oWalkMarker.Location_Description.Replace(Environment.NewLine, "<br />") %></td>
            </tr>
            <% } %>
            </table>
           
            </div>    
           <% } %>
            
<!--- Section: Create New Marker ----------------------------------------------------------------------------------------->            

          &nbsp;<div class="editor-field" id="WalkMarkers">
            <button id="CreateMarkerButton" type="button">Create New Marker</button><input type="hidden" id="markers_added" name="markers_added" value=""/>
          </div>  &nbsp;                                                      
            <div class="editor-label">
                  <%:Html.LabelFor(walk => walk.WalkDescription)%>
            </div>
            <div class="editor-field">
                <%: Html.TextAreaFor(walk => walk.WalkDescription, 8, 100, null) %>
            </div>&nbsp;
            
<!--- Section: New Images ------------------------------------------------------------------------------------------------->
            <div class="editor-label">
                <strong>New Images</strong>
               <label for="images_path">Full path and name prefix of images </label>E.g. <pre>C:\Dev\MyMVCApp\MyMVCAppCS\Content\images\lakes\212\BlackFell_22April2003_</pre>
           </div>
           <div class="editor-field">
                <input type="text" name="images_path" id="images_path" size="80" maxlength="160"  value="" />
                <input type="button" name="getimages" id="getimages" value="Get images" />
           </div>   &nbsp;    
            
<!--- Section: Existing Images --------------------------------------------------------------------------------------------->
           
            <div class="editor-field" id="walkimages">
           <%
               int iExistingImageCount = 1;
               foreach (Walk_AssociatedFile oWalkImage in Model.Walk_AssociatedFiles.Where(af => af.Walk_AssociatedFile_Type.Equals("Image")))
               {
                   if (iExistingImageCount == 1)
                   {
                       Response.Write("<strong>Existing Images</strong><br />");
                   } %>

            <br/>Image <%= iExistingImageCount.ToString() %> Delete? <input type="checkbox" id="deletexistingimage<%= iExistingImageCount.ToString() %>" name="deletexistingimage<%= iExistingImageCount.ToString() %>" /><br/>
            <input type="text" name="existingimagecaption<%= iExistingImageCount.ToString() %>" value="<%= oWalkImage.Walk_AssociatedFile_Caption %>" size="100" />              
            <input type="hidden" name="existingimagename<%= iExistingImageCount.ToString() %>" value="<%= oWalkImage.Walk_AssociatedFile_Name %>" />&nbsp;
                
            Marker? 
            <% if (oWalkImage.Walk_AssociatedFile_MarkerID != null)
               { %>           
            <input type="checkbox" id="existingimageismarker<%= iExistingImageCount.ToString() %>" name="existingimageismarker<%= iExistingImageCount.ToString() %>" checked class="imageismarker"/>
            <% }
               else
               { %>
             <input type="checkbox" id="existingimageismarker<%= iExistingImageCount.ToString() %>" name="existingimageismarker<%= iExistingImageCount.ToString() %>"  class="imageismarker"/>
            <% } %>
              <span id="existingimagemarkerdetails<%= iExistingImageCount.ToString() %>" class="existingimagemarkerdetails">        
    
               <br/>Marker name: 
               <input type="text" size="50" name="existingimagemarkername<%= iExistingImageCount.ToString() %>" id="existingimagemarkername<%= iExistingImageCount.ToString() %>" value="<%= WalkingStick.FormatMarkerAsLine(oWalkImage.Marker) %>" class="markersuggestions"/>
                Not Found? <input type="checkbox" id="existingimagemarkernotfound<%= iExistingImageCount.ToString()%>" name="existingimagemarkernotfound<%= iExistingImageCount.ToString() %>" />
           <input type="hidden" id="existingimagemarkerid<%= iExistingImageCount.ToString() %>" name="existingimagemarkerid<%= iExistingImageCount.ToString() %>" value="<%= oWalkImage.Walk_AssociatedFile_MarkerID.ToString() %>"/>
            </span>
            <% if (SessionSingleton.Current.UsageLocation.Equals(WalkingConstants.AT_WORK))
               { %>       
                   &nbsp;<%= MyMVCApp.DAL.WalkingStick.ExtractFileNameFromPath(oWalkImage.Walk_AssociatedFile_Name) %><br />
            <% }
               else
               { %>
                   <br/><img src="<%= oWalkImage.Walk_AssociatedFile_Name %>" class="walkimage" alt="existing image"/>
            <% }
               iExistingImageCount = iExistingImageCount + 1;
               }
            %>
            <input id="numexistingimages" type="hidden" name="numexistingimages" value="<%=iExistingImageCount - 1%>" />
           </div>
           <br />
            
<!--- Edit Existing Additional files------------------------------------------------------------------------------------------>

           <div class="editor-label">
             <strong>Edit Existing Additional Files</strong>
           </div>
           <% List<SelectListItem> selectlist = (List<SelectListItem>)ViewData["Associated_File_Types"];
              List<Walk_AssociatedFile> IQAuxilliaryFiles =(List<Walk_AssociatedFile>)ViewData["Auxilliary_Files"];

              for (int iAuxCounter = 1; iAuxCounter <= IQAuxilliaryFiles.Count; iAuxCounter++)
              { %>
           <div class="editor-field" id="existing_auxilliary_filesdiv<%= iAuxCounter %>"> 
               <%= IQAuxilliaryFiles[iAuxCounter - 1].Walk_AssociatedFile_Name %> ( <%: IQAuxilliaryFiles[iAuxCounter - 1].Walk_AssociatedFile_Type %> ) <em><%: IQAuxilliaryFiles[iAuxCounter - 1].Walk_AssociatedFile_Caption %></em>
               Delete? <input type="checkbox" name="delexisting_auxilliary_file<%= iAuxCounter %>" /> <input type="hidden" name="existingauxfilename<%= iAuxCounter.ToString() %>" value="<%= IQAuxilliaryFiles[iAuxCounter - 1].Walk_AssociatedFile_Name %>" />
               <input type="hidden" name="existingauxfiletype<%= iAuxCounter.ToString() %>" value="<%= IQAuxilliaryFiles[iAuxCounter - 1].Walk_AssociatedFile_Type %>" />
           </div>
           <%
              }
           %>
            
<!---- Add new additional files------------------------------------------------------------------------------------------>            

           <div class="editor-label">
               <strong>Add New Additional Files</strong><br />
               <br />Full path and name prefix of additional file E.g. <pre>C:\Dev\MyMVCApp\MyMVCAppCS\Content\images\dalespennines\70\dd_map.jpg</pre>
           </div>

           <% for (int iAuxCounter = 1; iAuxCounter <= 6; iAuxCounter++)
              {
           %>
            
           <div class="editor-field" id="auxilliary_filesdiv<%= iAuxCounter %>">
               <strong><%: iAuxCounter %></strong>  
                <input type="text" id="auxilliary_file<%= iAuxCounter %>" name="auxilliary_file<%= iAuxCounter %>" size="80"/> 
               <%: Html.DropDownList("auxilliary_filetype" + iAuxCounter.ToString(), selectlist) %>
                <input type="text" id="auxilliary_caption<%= iAuxCounter %>" name="auxilliary_caption<%= iAuxCounter %>" size="40" /><br />
           </div>
           <% } %>
           &nbsp;
            
<!--- Section: Other walk statistics--------------------------------------------------------------------------------->

            <div class="editor-label">
                <%:Html.LabelFor(walk => walk.WalkStartPoint)%>
             </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkStartPoint, new { size = 80, maxlength = 100 }) %>
            </div>&nbsp;
            <div class="editor-label">
                <%: Html.LabelFor(walk => walk.WalkEndPoint) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkEndPoint, new { size = 80, maxlength = 100 }) %>
            </div>  &nbsp;       
           <div class="editor-label">
                <%: Html.LabelFor(walk => walk.WalkCompanions) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkCompanions, new { size = 50, maxlength = 50 }) %>
            </div>  &nbsp;             
            <div class="editor-label">
                <%: Html.LabelFor(walk => walk.WalkType) %>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("WalkTypes") %>
            </div>&nbsp;
            <div class="editor-label">
                <%: Html.LabelFor(walk => walk.CartographicLength) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.CartographicLength) %>
            </div>&nbsp;
            <div class="editor-label">
                <%: Html.LabelFor(walk => walk.MetresOfAscent) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.MetresOfAscent) %>
            </div>&nbsp;
            <div class="editor-label">
                <%: Html.LabelFor(walk => walk.WalkTotalTime) %>
            </div>
            <div class="editor-field">
                Hours: <input type="text" name="total_time_hours" size="3" maxlength="3" value="<%= (Model.WalkTotalTime/60).ToString() %>" id="total_time_hours"/> 
                Mins:<input type="text" name="total_time_mins" size="3" maxlength="2" value="<%= Model.WalkTotalTime.ToString() %>" id="total_time_mins"/>
            </div>&nbsp;
            
            <div class="editor-label">
                <%: Html.LabelFor(walk => walk.WalkAverageSpeedKmh) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkAverageSpeedKmh) %>
            </div>&nbsp;
            <div class="editor-label">
                <%: Html.LabelFor(walk => walk.MovingAverageKmh) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.MovingAverageKmh) %>
            </div>
           <div id="walksubmit">
           <br />
                <input type="button" id="submitwalkbutton" value=" Update Walk " />
          </div>
        </fieldset>

 
    <% } %>

     <div id="MarkerModalDialogForm" title="Create New Marker">
        <p class="validateMarkerFormTips">*Required fields</p>
       <form>
             <fieldset>
                <label for="MarkerTitle">Title</label>*<br />
                <input type="text" name="MarkerTitle" id="MarkerTitle"  size="50" class="text-box ui-widget-content ui-corner-all" /><br />
                <label for="MarkerGPSReference">GPS Reference</label><br />
                <input type="text" name="MarkerGPSReference" id="MarkerGPSReference" size="14" maxlength="14" class="text-box ui-widget-content ui-corner-all" /><br />
                <label for="MarkerLeftOnHill">Hill</label><br />
                <input type="text" name="MarkerLeftOnHill" id="MarkerLeftOnHill" size="50" class="text-box ui-widget-content ui-corner-all" /><br />
                <input type="hidden" name="MarkerLeftOnHillId" id="MarkerLeftOnHillId" />
                <label for="MarkerDescription">Description</label><br />
                <textarea rows="4" cols="60" name="MarkerDescription" id="MarkerDescription" class="text-box ui-widget-content ui-corner-all"></textarea><br />
                <label for="MarkerDateLeft">Date Left</label>*<br />
                <input type="text" name="MarkerDateLeft" id="MarkerDateLeft" class="text-box ui-widget-content ui-corner-all" />
                <input type="hidden" name="NewMarkerWalkID" id="NewMarkerWalkID" value="<%= Model.WalkID %>"/>
             </fieldset>
        </form>  
 
    </div>

    <div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>
