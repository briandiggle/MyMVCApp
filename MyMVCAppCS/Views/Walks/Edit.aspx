<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of MyMVCApp.DAL.Walk)" %>

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
 
    <h2>Edit <em><%=Model.WalkTitle()%></em></h2>

    <%-- The following line works around an ASP.NET compiler warning --%>
    <%: ""%>
    <% Using Html.BeginForm("Edit", "Walks", FormMethod.Post, New With {.id = "walkform", .name = "walkform"})%>
        <%: Html.ValidationSummary(True) %>
        <fieldset>
            
            <div class="editor-label">
              <%: Html.LabelFor(Function(walk) walk.WalkDate)%>
            </div>
            <div class="editor-field">
               <%: Html.TextBoxFor(Function(walk) walk.WalkDate, "{0:dd MMMM yyyy}", New With {.size = 40})%>                
            </div>
            &nbsp;
          <div class="editor-label">
                  <%: Html.LabelFor(Function(walk) walk.WalkTitle)%>
           </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.WalkTitle, New With {.size = 80})%>
            </div>&nbsp;
<!---Section: Walk Area-------------------------------------------------------------------------------->
          <div class="editor-label">
                    <%: Html.LabelFor(Function(walk) walk.WalkAreaName)%>

            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.WalkAreaName, New With {.size = 80})%> <%: Html.Hidden("WalkAreaID", Model.Area.Arearef)%>
             </div>&nbsp;                  
           <div class="editor-label">
                   <%: Html.LabelFor(Function(walk) walk.WalkSummary)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.WalkSummary, New With {.size = 80})%> Auto: <input type="checkbox" name="summary_auto" id="summary_auto" checked />
            </div>&nbsp;      
          <div class="editor-label">
                   <%: Html.LabelFor(Function(walk) walk.WalkConditions)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.WalkConditions, New With {.size = 80})%>
            </div>&nbsp;   
             
<!--Section: Summits Visited----------------------------------------------------------------------------------------->

           <div class="editor-label">
                <strong><%: Html.Label("Summits Visited")%></strong>
            </div>     
            <% For iHillAscentsCounter = 1 To Model.HillAscents.Count%>
             <div class="editor-field" id="DivVisitedSummit<%= iHillAscentsCounter.ToString%>">
                <%: Html.TextBox("VisitedSummit" + iHillAscentsCounter.ToString, MyMVCApp.DAL.WalkingStick.FormatHillSummaryAsLine(Model.HillAscents(iHillAscentsCounter - 1).Hill) + " ", New With {.size = 80})%> <%: Html.Hidden("VisitedSummit" + iHillAscentsCounter.ToString + "HillID", Model.HillAscents(iHillAscentsCounter - 1).Hillnumber.ToString)%>
            </div>
            <% Next%>      
             <% For iHillVisitedCounter As Integer = Model.HillAscents.Count + 1 To 15%>   
            <div class="editor-field" id="DivVisitedSummit<%= iHillVisitedCounter.ToString %>">
                <%: Html.TextBox("VisitedSummit" + iHillVisitedCounter.ToString, "", New With {.size = 80})%> <%: Html.Hidden("VisitedSummit" + iHillVisitedCounter.ToString + "HillID")%>
            </div>
            <% Next%>

<!-- Section: Markers Created---------------------------------------------------------------------------------------------------->            

            <%  Dim oWalkMarkersAlreadyCreated As List(Of MyMVCApp.DAL.Marker) = ViewData("WalkMarkersAlreadyCreated")
                If oWalkMarkersAlreadyCreated.Count > 0 Then %>&nbsp;
            <div class="editor-label"><strong>Markers created for this walk</strong></div>    
            <div class="editor-field">
            <table>
            <tr>
                <th>Name</th>
                <th>GPS Reference</th>
                <th>Description</th>
            </tr>
            <% For Each oWalkMarker As MyMVCApp.DAL.Marker In oWalkMarkersAlreadyCreated%>
            <tr>
                <td><%= oWalkMarker.MarkerTitle%></td>
                <td><%= oWalkMarker.GPS_Reference%></td>
                <td><%= oWalkMarker.Location_Description.Replace(ControlChars.Lf, "<br />")%></td>
            </tr>
            <% Next %>
            </table>
           
            </div>    
           <%   End If  %>
            
<!--- Section: Create New Marker ----------------------------------------------------------------------------------------->            

          &nbsp;<div class="editor-field" id="WalkMarkers">
            <button id="CreateMarkerButton" type="button">Create New Marker</button><input type="hidden" id="markers_added" name="markers_added" value=""/>
          </div>  &nbsp;                                                      
            <div class="editor-label">
                  <%: Html.LabelFor(Function(walk) walk.WalkDescription)%>
            </div>
            <div class="editor-field">
                <%: Html.TextAreaFor(Function(walk) walk.WalkDescription, 8, 100, New With {.class = "formtextarea"})%>
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
               Dim iExistingImageCount As Integer = 1
               For Each oWalkImage In Model.Walk_AssociatedFiles.Where(Function(af) af.Walk_AssociatedFile_Type.Equals("Image"))
                   
                   If iExistingImageCount = 1 Then
                       Response.Write("<strong>Existing Images</strong><br />")
                   End If%>

            <br/>Image <%= iExistingImageCount.ToString%> Delete? <input type="checkbox" id="deletexistingimage<%= iExistingImageCount.ToString %>" name="deletexistingimage<%= iExistingImageCount.ToString %>" /><br/>
                <input type="text" name="existingimagecaption<%=iExistingImageCount.ToString %>" value="<%= oWalkImage.Walk_AssociatedFile_Caption %>" size="100" />              
            <input type="hidden" name="existingimagename<%= iExistingImageCount.ToString %>" value="<%= oWalkImage.Walk_AssociatedFile_Name %>" />&nbsp;
                
            Marker? 
            <% If Not IsNothing(oWalkImage.Walk_AssociatedFile_MarkerID) Then%>           
            <input type="checkbox" id="existingimageismarker<%=iExistingImageCount.ToString %>" name="existingimageismarker<%=iExistingImageCount.ToString %>" checked class="imageismarker"/>
            <% Else%>
             <input type="checkbox" id="existingimageismarker<%=iExistingImageCount.ToString %>" name="existingimageismarker<%=iExistingImageCount.ToString %>"  class="imageismarker"/>
            <% End If %>
              <span id="existingimagemarkerdetails<%=iExistingImageCount.ToString %>" class="existingimagemarkerdetails">        
    
               <br/>Marker name: 
               <input type="text" size="50" name="existingimagemarkername<%=iExistingImageCount.ToString %>" id="existingimagemarkername<%=iExistingImageCount.ToString %>" value="<%= MyMVCApp.DAL.WalkingStick.FormatMarkerAsLine(oWalkImage.Marker) %>" class="markersuggestions"/>
                Not Found? <input type="checkbox" id="existingimagemarkernotfound<%=iExistingImageCount.ToString %>" name="existingimagemarkernotfound<%=iExistingImageCount.ToString %>" />
           <input type="hidden" id="existingimagemarkerid<%=iExistingImageCount.ToString %>" name="existingimagemarkerid<%=iExistingImageCount.ToString %>" value="<%=oWalkImage.Walk_AssociatedFile_MarkerID.Tostring %>"/>
            </span>
            <% If ViewData("AT_WORK") = "True" Then%>       
                   &nbsp;<%= MyMVCApp.DAL.WalkingStick.ExtractFileNameFromPath(oWalkImage.Walk_AssociatedFile_Name)%><br />
            <% Else %>
                   <br/><img src="<%= oWalkImage.Walk_AssociatedFile_Name %>" class="walkimage" alt="existing image"/>
            <%  End If
                iExistingImageCount = iExistingImageCount + 1
            Next            
            %>
            <input id="numexistingimages" type="hidden" name="numexistingimages" value="<%= iExistingImageCount-1 %>" />
           </div>
           <br />
            
<!--- Edit Existing Additional files------------------------------------------------------------------------------------------>

           <div class="editor-label">
             <strong>Edit Existing Additional Files</strong>
           </div>
           <% Dim selectlist As IEnumerable(Of SelectListItem) = ViewData("Associated_File_Types")%>

           <% 
               Dim IQAuxilliaryFiles As IEnumerable(Of MyMVCApp.DAL.Walk_AssociatedFile) = ViewData("Auxilliary_Files")

               For iAuxCounter = 1 To IQAuxilliaryFiles.Count%>
           <div class="editor-field" id="existing_auxilliary_filesdiv<%=iAuxCounter %>"> 
               <%= IQAuxilliaryFiles(iAuxCounter - 1).Walk_AssociatedFile_Name%> ( <%: IQAuxilliaryFiles(iAuxCounter - 1).Walk_AssociatedFile_Type%> ) <em><%: IQAuxilliaryFiles(iAuxCounter-1).Walk_AssociatedFile_Caption %></em>
               Delete? <input type="checkbox" name="delexisting_auxilliary_file<%=iAuxCounter %>" /> <input type="hidden" name="existingauxfilename<%= iAuxCounter.ToString %>" value="<%=IQAuxilliaryFiles(iAuxCounter - 1).Walk_AssociatedFile_Name  %>" />
               <input type="hidden" name="existingauxfiletype<%= iAuxCounter.ToString %>" value="<%= IQAuxilliaryFiles(iAuxCounter - 1).Walk_AssociatedFile_Type %>" />
           </div>
           <% 
                          
           Next
      
           %>
            
<!---- Add new additional files------------------------------------------------------------------------------------------>            

           <div class="editor-label">
               <strong>Add New Additional Files</strong><br />
               <br />Full path and name prefix of additional file E.g. <pre>C:\Dev\MyMVCApp\MyMVCAppCS\Content\images\dalespennines\70\dd_map.jpg</pre>
           </div>

           <% For iAuxCounter = 1 To 6%>
            
           <div class="editor-field" id="auxilliary_filesdiv<%=iAuxCounter %>">
               <strong><%: iAuxCounter%></strong>  
                <input type="text" id="auxilliary_file<%=iAuxCounter %>" name="auxilliary_file<%=iAuxCounter %>" size="80"/> 
               <%: Html.DropDownList("auxilliary_filetype" + iAuxCounter.ToString, selectlist)%>
                <input type="text" id="auxilliary_caption<%=iAuxCounter %>" name="auxilliary_caption<%=iAuxCounter%>" size="40" /><br />
           </div>
           <% Next%>
           &nbsp;
            
<!--- Section: Other walk statistics--------------------------------------------------------------------------------->

            <div class="editor-label">
                <%: Html.LabelFor(Function(walk) walk.WalkStartPoint)%>
             </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.WalkStartPoint, New With {.size = 80, .maxlength = 100})%>
            </div>&nbsp;
            <div class="editor-label">
                <%: Html.LabelFor(Function(walk) walk.WalkEndPoint)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.WalkEndPoint, New With {.size = 80, .maxlength = 100})%>
            </div>  &nbsp;       
           <div class="editor-label">
                <%: Html.LabelFor(Function(walk) walk.WalkCompanions)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.WalkCompanions, New With {.size = 50, .maxlength = 50})%>
            </div>  &nbsp;             
            <div class="editor-label">
                <%: Html.LabelFor(Function(walk) walk.WalkType)%>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("WalkTypes")%>
            </div>&nbsp;
            <div class="editor-label">
                <%: Html.LabelFor(Function(walk) walk.CartographicLength)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.CartographicLength)%>
            </div>&nbsp;
            <div class="editor-label">
                <%: Html.LabelFor(Function(walk) walk.MetresOfAscent)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.MetresOfAscent)%>
            </div>&nbsp;
            <div class="editor-label">
                <%: Html.LabelFor(Function(walk) walk.WalkTotalTime)%>
            </div>
            <div class="editor-field">
                Hours: <input type="text" name="total_time_hours" size="3" maxlength="3" value="<%= (model.WalkTotalTime \ 60).ToString %>" id="total_time_hours"/> Mins:<input type="text" name="total_time_mins" size="3" maxlength="2" value="<%= (Model.WalkTotalTime Mod 60).ToString %>" id="total_time_mins"/>
            </div>&nbsp;
            
            <div class="editor-label">
                <%: Html.LabelFor(Function(walk) walk.WalkAverageSpeedKmh)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.WalkAverageSpeedKmh)%>
            </div>&nbsp;
            <div class="editor-label">
                <%: Html.LabelFor(Function(walk) walk.MovingAverageKmh)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(walk) walk.MovingAverageKmh)%>
            </div>
           <div id="walksubmit">
           <br />
                <input type="button" id="submitwalkbutton" value=" Update Walk " />
          </div>
        </fieldset>

 
    <% End Using %>

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
                <input type="hidden" name="NewMarkerWalkID" id="NewMarkerWalkID" value="<%= model.WalkID %>"/>
             </fieldset>
        </form>  
 
    </div>

    <div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>
