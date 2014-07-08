﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCApp.DAL.Walk>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Add New Walk
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
<link type="text/css" href="../../Content/themes/base/jquery.ui.all.css" rel="Stylesheet" />
<script type="text/javascript" src="../../Scripts/jquery-2.1.1.js"></script>
<script type="text/javascript" src="../../Scripts/jquery-ui-1.10.4.js"></script>
<script type="text/javascript" src="../../Scripts/jquery.validate.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="../../Scripts/CreateEditWalk.js"></script>

    <h2>Add Walk</h2>

    <%-- The following line works around an ASP.NET compiler warning --%>
    <%: ""%>

    <% using (Html.BeginForm("Create", "Walks", FormMethod.Post, new {id = "walkform", name = "walkform"}))
       {%>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            
            <div class="editor-label">
                 <%: Html.LabelFor(walk => walk.WalkDate)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkDate, new {size = 40})%>
            </div>&nbsp;

          <div class="editor-label">
                 <%: Html.LabelFor(walk => walk.WalkTitle)%>
           </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkTitle, new {size = 80})%>
            </div>&nbsp;

<!--- Section: Walk Area with jQuery Autocomplete ----------------------------------------------------------------------------->

          <div class="editor-label">
                  <%: Html.LabelFor(walk => walk.WalkAreaName)%>
           </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkAreaName, new {size = 80})%> <%: Html.Hidden("WalkAreaID")%>
             </div>&nbsp;                      
           <div class="editor-label">
                  <%: Html.LabelFor(walk => walk.WalkSummary)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkSummary, new {size = 80, maxlength = 1000})%> Auto: <input type="checkbox" name="summary_auto" id="summary_auto" checked="checked" />
            </div>&nbsp;    
            <div class="editor-label">
                  <%: Html.LabelFor(walk => walk.WalkConditions)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkConditions, new {size = 80})%>
            </div>&nbsp;
             
<!-- Section: Summits Visited --------------------------------------------------------------------------------------------------->            

           <div class="editor-label">
                  <%: Html.LabelFor(walk => walk.HillAscents)%>
            </div>        
            <% for (int iHillVisitedCounter = 1; iHillVisitedCounter <= 15; iHillVisitedCounter++)
            { 
                   %>   
           <div class="editor-field" id="DivVisitedSummit<%= iHillVisitedCounter.ToString() %>">
                <%: Html.TextBox("VisitedSummit" + iHillVisitedCounter.ToString(), "", new {size = 80})%> <%: Html.Hidden("VisitedSummit" + iHillVisitedCounter + "HillID")%>
            </div>
            <% }%>
            &nbsp;
            
<!-- Section: Add New Marker ---------------------------------------------------------------------------------------------------->

          <div class="editor-field" id="WalkMarkers">
            <button id="CreateMarkerButton" type="button">Create New Marker</button><input type="hidden" id="markers_added" name="markers_added" value=""/>
          </div>&nbsp;                                                   
            <div class="editor-label">
                  <%: Html.LabelFor(walk => walk.WalkDescription)%>
            </div>
            <div class="editor-field">
                <%: Html.TextAreaFor(walk => walk.WalkDescription, 8, 100, new {@class = "formtextarea"})%>
            </div>&nbsp;

<!-- Section: Add Walk Images---------------------------------------------------------------------->

            <div class="editor-label">
               <label for="images_path"><strong>Walk images</strong><br />Full path and name prefix of images </label>E.g. <pre>C:\DEV\MyMVCApp\MyMVCApp\Content\images\lakes\202\SilverHow_8December2009_</pre>
           </div>
           <div class="editor-field">
                <input type="text" name="images_path" id="images_path" size="80" maxlength="160" value="C:\Dev\MyMVCApp\MyMVCAppCS\Content\images\dalespennines\EccupRound\EccupRound_7January2010_"/>
                <input type="button" name="getimages" id="getimages" value="Get images" />
           </div>       
           <div class="editor-field" id="walkimages">
           </div>&nbsp;

<!-- Section: Add Additional (Auxilliary) Files----------------------------------------------------->

           <div class="editor-label">
             <strong>Additional Files</strong>
               <br />Full path and name prefix of additional file E.g. <pre>C:\Dev\MyMVCApp\MyMVCAppCS\Content\images\lakes\1\ScafellPike _23_March_2014.gpx</pre>
           </div>
                         
           <% List<SelectListItem> selectlist = (List<SelectListItem>)ViewData["Associated_File_Types"]%>
           <% for (int iAuxCounter = 1; iAuxCounter <= 6; iAuxCounter++)
              { %>
           <div class="editor-field" id="auxilliary_filesdiv<%= iAuxCounter %>"> 
                <strong><%: iAuxCounter %></strong> 
                <input type="text" id="auxilliary_file<%= iAuxCounter %>" name="auxilliary_file<%= iAuxCounter %>" size="80" class="auxilliaryfileclass" /> 
                <%: Html.DropDownList("auxilliary_filetype" + iAuxCounter, selectlist) %>
                Caption: <input type="text" id="auxilliary_caption<%= iAuxCounter %>" name="auxilliary_caption<%= iAuxCounter %>" size="40" /><br />
           </div>
           <% }  %>

<!-- Section: Walk Type------------------------------------------------------------------------------>

           &nbsp;
            <div class="editor-label">
                 <%: Html.LabelFor(walk => walk.WalkType)%>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("WalkTypes")%>
            </div>&nbsp;

            <div class="editor-label">
                <%: Html.LabelFor(walk => walk.WalkStartPoint)%>
             </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkStartPoint, new {size = 80, maxlength = 100})%>
            </div>&nbsp;
            <div class="editor-label">
                   <%: Html.LabelFor(walk => walk.WalkEndPoint)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkEndPoint, new {size = 80, maxlength = 100})%>
            </div>&nbsp;     
           <div class="editor-label">
                  <%: Html.LabelFor(walk => walk.WalkCompanions)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkCompanions, new {size = 50, maxlength = 50})%>
            </div>&nbsp;          
            
            <div class="editor-label">
                 <%: Html.LabelFor(walk => walk.CartographicLength)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.CartographicLength)%>
            </div>&nbsp;
            
            <div class="editor-label">
                 <%: Html.LabelFor(walk => walk.MetresOfAscent)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.MetresOfAscent)%>
            </div>&nbsp;
                      
            <div class="editor-label">
                 <%: Html.LabelFor(walk => walk.WalkTotalTime)%>
            </div>
            <div class="editor-field">
                Hours: <input type="text" name="total_time_hours" size="3" maxlength="3" id="total_time_hours"/> Mins:<input type="text" name="total_time_mins" size="3" maxlength="2" id="total_time_mins"/>
            </div>&nbsp;
            
            <div class="editor-label">
                <%: Html.LabelFor(walk => walk.WalkAverageSpeedKmh)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.WalkAverageSpeedKmh)%>
            </div>&nbsp;
            
            <div class="editor-label">
                 <%: Html.LabelFor(walk => walk.MovingAverageKmh)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(walk => walk.MovingAverageKmh)%>
            </div>&nbsp;
            
           <div id="walksubmit">
           <br />
                <input type="button" id="submitwalkbutton" value=" Add New Walk " />
          </div>
        </fieldset>

 
    <% } %>
    
  <!--Section: New Marker Pop-up Form------------------------------------------------------------> 

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
             </fieldset>
        </form>  
 
    </div>

    <div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>

