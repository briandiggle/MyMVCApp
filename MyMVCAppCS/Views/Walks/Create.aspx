<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of MyMVCApp.DAL.Walk)" %>

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

<script type="text/javascript">

  
    $(function () {
     
        /*----Associate an autocomplete with the marker left on hill box which will make an AJAX call-----*/
        $("#MarkerLeftOnHill").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: "/Walks/HillSuggestions",
                    dataType: "json",
                    data: {
                        term: request.term,
                        areaid: $("#WalkAreaID").val()
                    },
                    success: function (data) {
                        response(data);
                    }
                });
            },
            minLength: 2,
            appendTo: "#MarkerModalDialogForm",
            select: function (event, ui) {
                var hillid = extractid(ui.item.value);
                $("#MarkerLeftOnHillId").val(hillid);
            }
        });

        //---This function is used to populate the hidden html field WalkAreaID which is used by the summit autocomplete to narrow suggestions to the right area
        function extractareaid(walkareaname) {
     
            if (walkareaname.indexOf("|") > 0) {
                var myloc = walkareaname.indexOf("|");
                $("#WalkAreaID").val(walkareaname.substring(myloc + 1).trim());
            }
        }

        $("#WalkAreaName").autocomplete({
            source: "/Walks/WalkAreaSuggestions",
            minLength: 2,
            select: function(event, ui) {
                extractareaid(ui.item.value);
            }
        });

        /*----Associate an autocomplete widget with each of the hill visited text boxes. Each hill visited text box has an----*/
        /*----matching hidden field which will hold a selected hill id-------*/

        for (var iSummitVisitCount = 1; iSummitVisitCount <= 15; iSummitVisitCount = iSummitVisitCount + 1) {
            
            $("#VisitedSummit" + iSummitVisitCount).autocomplete({
                source: function(request, response) {
                    $.ajax({
                        url: "/Walks/HillSuggestions",
                        dataType: "json",
                        data: {
                            term: request.term,
                            areaid: $("#WalkAreaID").val()
                        },
                        success: function(data) {
                            response(data);
                        }
                    });

                },
                minLength: 2,
                select: function (event, ui) {
                    var summitnumber = extractnumber("VisitedSummit",event.target.id);
                    var hillid = extractid(ui.item.value);
                    $("#DivVisitedSummit" + (parseInt(summitnumber) + 1)).show();
                    $("#VisitedSummit" + (parseInt(summitnumber) + 1)).focus();
                    $("#VisitedSummit" + summitnumber + "HillID").val(hillid);
                }
            });
            
            if (iSummitVisitCount > 1) {
                $("#DivVisitedSummit" + iSummitVisitCount).hide();
            }
        }

        //*------Implementation of association of marker with image---------
        //*------Associate an autocomplete jQuery UI widget with all DOM elements with class "markersuggestions"---------
        $(document).on("keydown.autocomplete", ".markersuggestions", function (e) {

            $(this).autocomplete({
                source: "/Walks/MarkerSuggestions",
                minLength: 2,
                select: function (event, ui) {
                    var imagenumber = extractnumber("imagemarkername",event.target.id);
                    var markerid = extractid(ui.item.value);
                    $("#imagemarkerid" + imagenumber).val(markerid);
                }
            });

        });

  
        $(document).on("click", ".imageismarker:checked", function(e) {
            var markerimage = extractnumber("imageismarker", e.target.id);
            $("#imagemarkerdetails" + markerimage).show();
        });

        //*-----The Json results from the autocomplete remote source contain also the hill or marker ID. 
        //*-----This function extracts the ID from this and returns it

        function extractnumber(removestr, sourcestring) {
            return sourcestring.replace(removestr, "");
        }


        function extractid(elementname) {
            if (elementname.indexOf("|") > 0) {
                var myloc = elementname.indexOf("|");
                return elementname.substring(myloc + 1).trim();
            }
            return "";
        }

        /*----Associate a AJAX call (AJAJ in fact as it returns JSON) with the blur event of the auxilliary_file1 */
        /*----How to write a generic handler?------------------------------*/

        $('.auxilliaryfileclass').change(function (e) {

            var auxilliaryfilenumber = extractnumber("auxilliary_file",e.target.id);

            $.getJSON('/Walks/CheckFileInWebrootJSON', { imagepath: $('#auxilliary_file' + auxilliaryfilenumber).val() }, function (oResults, status) {
                if (oResults.isinpath == "False") {
                    alert('The file you chose is not in the web site root.');
                    // reset_html('auxilliary_filesdiv1');
                } else {
                    $('#auxilliary_filesdiv' + (parseInt(auxilliaryfilenumber) + 1)).show();
                }
            });

        });
    });

    $(document).ready(function () {

        /*---Calculate the overall speed where possible-------*/
        $("#CartographicLength").focusout(function () {
            calculateOverallSpeed();
        });
        $("#total_time_hours").focusout(function () {
            calculateOverallSpeed();
        });
        $("#total_time_mins").focusout(function () {
            calculateOverallSpeed();
        });

        /*---Empty the autocomplete text field on click----*/
        $('#WalkAreaName').click(function () {
            $('#WalkAreaName').val("");
        });

        /*----Hide the currently unused auxilliary file sections------*/
        for (var iAuxFileCount = 2; iAuxFileCount <= 6; iAuxFileCount = iAuxFileCount + 1) {
            $('#auxilliary_filesdiv' + iAuxFileCount).hide();
        }

        /*----Associate a datepicker widget ( from jQuery/UI/DatePicker ) with the WalkDate text box----*/
        $(function () {
            $("#WalkDate").datepicker({ dateFormat: 'dd MM yy' });
        });

        /*----When "check images" is clicked, make AJAX call to see how many matching images are found.----*/
        /*----Then insert the images together with ImageCaption text boxes into the DOM------*/
        $('#getimages').click(function () {

            $.get('/Walks/CheckImages', { imagepath: $("#images_path").val() }, function (oResults) {

                for (var iImageCount = 1; iImageCount <= oResults.imagesfound; iImageCount = iImageCount + 1) {
                    $("#walkimages").append('<br/><b>Image ' + iImageCount + '</b><br/><input type="text" id="imageImageCaption' + iImageCount + '" name="imageImageCaption' + iImageCount + '" size="100" />&nbsp;Marker? <input type="checkbox" class="imageismarker" id="imageismarker' + iImageCount + '" name="imageismarker' + iImageCount + '"/>');

                    if (oResults.atwork == "True") {
                        $("#walkimages").append("&nbsp;" + oResults.filenameprefix + iImageCount + '.jpg</br>');
                    } else {
                        $("#walkimages").append('<br/><img src="' + oResults.path + iImageCount + '.jpg" border="1" />');
                    }
                    $("#walkimages").append('<input type="hidden" id="imagerelpath' + iImageCount + '" name="imagerelpath' + iImageCount + '" value="' + oResults.path + iImageCount + '.jpg"/><br/>');

                    //----Add a hidden marker section, revealed when clicking the "imageismarker" checkbox-----------
                    var markermarkup = '<span id="imagemarkerdetails' + iImageCount + '">' +
                        '<br/>Marker name: ' + '<input type="text" size="50" name="imagemarkername' + iImageCount + '" id="imagemarkername' + iImageCount + '" class="markersuggestions" />' +
                        '<input type="hidden" id="imagemarkerid' + iImageCount + '" name="imagemarkerid' + iImageCount + '" />' +
                        'Not Found? <input type="checkbox" id="imagemarkernotfound' + iImageCount + '" name="imagemarkernotfound' + iImageCount + '" /></span>';

                    $("#walkimages").append(markermarkup);
                    $("#imagemarkerdetails" + iImageCount).hide();
                }
                $("#images_path").focus();
            });

        });

        /*----If the walk is circular, put the start location in the end location field */
        $('#WalkStartPoint').keyup(function () {
            if ($('#WalkTypes').val() == 'Mountain  - Circular' || $('#WalkTypes').val() == 'Valley - Circular') {
                $('#WalkEndPoint').val($('#WalkStartPoint').val());
            }

        });

        /*----Now follows...the modal form for marker creation------------------------*/
        var markertitle = $("#MarkerTitle"),
			markerdateleft = $("#MarkerDateLeft"),
			markerdescription = $("#MarkerDescription"),
            markerhill = $("#MarkerLeftOnHill"),
            markerhillid = $("#MarkerLeftOnHillId"),
            markergps = $("#MarkerGPSReference"),
			allFields = $([]).add(markertitle).add(markerdateleft).add(markerdescription).add(markerhillid).add(markergps).add(markerhill),
		    tips = $(".validateMarkerFormTips");

        function updateTips(t) {
            tips
				.text(t)
				.addClass('ui-state-highlight');
            setTimeout(function () {
                tips.removeClass('ui-state-highlight', 1500);
            }, 500);
        }

        function checkLength(o, n, min, max) {

            if (o.val().length > max || o.val().length < min) {
                o.addClass('ui-state-error');
                updateTips("Length of " + n + " must be between " + min + " and " + max + ".");
                return false;
            } else {
                return true;
            }

        }

        function calculateOverallSpeed() {
            if ($("#CartographicLength").val() != "" && ($("#total_time_hours").val() != "" || $("#total_time_mins").val() != "")) {

                var numhours = 0;
                if ($("#total_time_hours").val() != "") {
                    numhours += parseFloat($("#total_time_hours").val());
                }
                if ($("#total_time_mins").val() != "") {
                    numhours += parseFloat($("#total_time_mins").val()) / 60;
                }

                var overallspeed = parseFloat($("#CartographicLength").val()) / numhours;
                $("#WalkAverageSpeedKmh").val(overallspeed.toPrecision(2));
            }
        }

        /*----Add a modal form which is used to capture the data for a new marker. Using jQuery/UI/Dialog---------*/
        $("#MarkerModalDialogForm").dialog({
            autoOpen: false,
            height: 430,
            width: 500,
            zIndex: 10000000,  //To ensure that the drop-down of suggestions appears in front of everything else
            modal: false,
            buttons: {
                'Create Marker': function () {
                    allFields.removeClass('ui-state-error');
                    var bValid = true;
                    bValid = bValid && checkLength(markertitle, "marker title", 5, 80);
                    bValid = bValid && checkLength(markerdescription, "description", 6, 1000);
                    bValid = bValid && checkLength(markerdateleft, "date left", 5, 18);

                    if (bValid) {

                        /*-----Do AJAX call to add insert the new marker so that its available immediately for selection----*/
                        $.getJSON('/Walks/CreateMarker', { mtitle: markertitle.val(), mdesc: markerdescription.val(), mdate: markerdateleft.val(), mhillid: markerhillid.val(), mgps: markergps.val() },
                            function (oResults, status) {
                                if (status == "success") {
                                    $('#WalkMarkers').append('<br/><table class="markertable"><tr><td colspan="2"><strong>Marker Created</strong></td></tr>' +
							        '<tr><td><em>Title:</em></td><td>' + markertitle.val() + '</td></tr><tr><td><em>Date Left:</em></td><td>' +
							        markerdateleft.val() + '</td></tr><tr><td>Description:</td><td>' + markerdescription.val().replace(/(?:\r\n|\r|\n)/g, '<br />') + '</td></tr></table>');
                                    var mi = $("#markers_added").val();
                                    $("#markers_added").val(mi + ":" + oResults.markerid);
                                    $("#MarkerModalDialogForm").dialog('close');
                                } else {
                                    $(".validateMarkerFormTips").val = "An error occurred when inserting the new marker: " + status;
                                }
                                allFields.val('').removeClass('ui-state-error');
                            });
                    }
                },
                Cancel: function () {
                    $(this).dialog('close');
                }
            },
            close: function () {
                allFields.val('').removeClass('ui-state-error');
            }
        });

        /*----Add a Create Marker button to the form. Using jQuery/UI/Button -------*/
        $('#CreateMarkerButton')
			.button()
			.click(function () {
			    $('#MarkerDateLeft').val($('#WalkDate').val());
			    $('#MarkerModalDialogForm').dialog('open');
			});

        /*----Create event for main button click----*/
        $('#createwalkbutton').button().click(function () {
            $('#createwalkform').submit();
        });

        /*----Associate a date picker with the marker left date----*/
        $("#MarkerDateLeft").datepicker({ dateFormat: 'dd MM yy' });

        /*----Set up form validation with the jQuery Validation plugin-------*/
        $("#createwalkform").validate({
            rules: {
                WalkDescription: {
                    minlength: 10,
                    required: true
                },
                WalkAreaName: {
                    required: true
                },
                WalkTitle: {
                    required: true,
                    minlength: 5
                },
                WalkDate: {
                    required: true
                },
                WalkStartPoint: {
                    required: true,
                    minlength: 3
                },
                WalkEndPoint: {
                    required: true,
                    minlength: 3
                },
                CartographicLength: {
                    number: true,
                    range: [0.1, 60]
                },
                MetresOfAscent: {
                    number: true,
                    range: [0, 8848]
                },
                total_time_hours: {
                    number: true,
                    range: [0, 18]
                },
                total_time_mins: {
                    number: true,
                    range: [0, 59]
                },
                WalkAverageSpeedKmh: {
                    number: true,
                    range: [0, 8]
                },
                MovingAverageKmh: {
                    number: true,
                    range: [0, 8]
                }
            }
        });
    });

</script>
    <h2>Add Walk</h2>

    <%-- The following line works around an ASP.NET compiler warning --%>
    <%: ""%>

    <% Using Html.BeginForm("Create", "Walks", FormMethod.Post, New With {.id = "createwalkform", .name = "createwalkform"})%>
        <%: Html.ValidationSummary(True) %>
        <fieldset>
            
            <div class="editor-label">
                <label for="WalkDate"><strong>Walk Date</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkDate, New With {.size = 40})%>
            </div>&nbsp;

          <div class="editor-label">
                <label for="WalkTitle"><strong>Walk Title</strong></label>
           </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkTitle, New With {.size = 80})%>
            </div>&nbsp;

<!--- Section: Walk Area with jQuery Autocomplete ----------------------------------------------------------------------------->

          <div class="editor-label">
                <label for="WalkAreaName"><strong>Walk Area</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkAreaName, New With {.size = 80})%> <%: Html.Hidden("WalkAreaID")%>
             </div>&nbsp;                      
           <div class="editor-label">
                <label for="WalkSummary"><strong>Walk Summary</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkSummary, New With {.size = 80, .maxlength = 1000})%> Auto: <input type="checkbox" name="summary_auto" id="summary_auto" checked="checked" />
            </div>&nbsp;    
          <div class="editor-label">
                <label for="WalkConditions"><strong>Walk Conditions</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkConditions, New With {.size = 80})%>
            </div>&nbsp;
             
<!-- Section: Summits Visited --------------------------------------------------------------------------------------------------->            

           <div class="editor-label">
                <strong><%: Html.Label("Summits Visited")%></strong>
            </div>        
            <% For iHillVisitedCounter As Integer = 1 To 15%>   
           <div class="editor-field" id="DivVisitedSummit<%= iHillVisitedCounter.ToString %>">
                <%: Html.TextBox("VisitedSummit" + iHillVisitedCounter.ToString, "", New With {.size = 80})%> <%: Html.Hidden("VisitedSummit" + iHillVisitedCounter.ToString + "HillID")%>
            </div>
            <% Next%>
            &nbsp;
            
<!-- Section: Add New Marker ---------------------------------------------------------------------------------------------------->

          <div class="editor-field" id="WalkMarkers">
            <button id="CreateMarkerButton" type="button">Create New Marker</button><input type="hidden" id="markers_added" name="markers_added" value=""/>
          </div>&nbsp;                                                   
            <div class="editor-label">
                 <label for="WalkDescription"><strong>Walk Description</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextAreaFor(Function(model) model.WalkDescription, 8, 100, New With {.class = "formtextarea"})%>
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
               <br />Full path and name prefix of additional file E.g. <pre>C:\DEV\MyMVCApp\MyMVCApp\Content\images\lakes\202\SilverHow_8December2009_Track.gpx</pre>
           </div>
                         
           <% Dim selectlist As System.Collections.Generic.IEnumerable(Of System.Web.Mvc.SelectListItem) = ViewData("Associated_File_Types")%>
           <% For iAuxCounter = 1 To 6%>
           <div class="editor-field" id="auxilliary_filesdiv<%=iAuxCounter %>"> 
                <strong><%: iAuxCounter%></strong> 
                <input type="text" id="auxilliary_file<%=iAuxCounter %>" name="auxilliary_file<%=iAuxCounter %>" size="80" class="auxilliaryfileclass" /> 
                <%: Html.DropDownList("auxilliary_filetype" + iAuxCounter.ToString, selectlist)%>
                Caption: <input type="text" id="auxilliary_caption<%=iAuxCounter %>" name="auxilliary_caption<%=iAuxCounter%>" size="40" /><br />
           </div>
           <% Next%>

<!-- Section: Walk Type------------------------------------------------------------------------------>

           &nbsp;
          <div class="editor-label">
                <label for="WalkTypes"><strong>Walk Type</strong></label>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("WalkTypes")%>
            </div>&nbsp;

            <div class="editor-label">
                <%: Html.LabelFor(Function(model) model.WalkStartPoint)%>
             </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkStartPoint, New With {.size = 80, .maxlength = 100})%>
            </div>&nbsp;
            <div class="editor-label">
                   <%: Html.LabelFor(Function(model) model.WalkEndPoint)%>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkEndPoint, New With {.size = 80, .maxlength = 100})%>
            </div>&nbsp;     
           <div class="editor-label">
               <label for="WalkCompanions"><strong>With</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkCompanions, New With {.size = 50, .maxlength = 50})%>
            </div>&nbsp;          
            
            <div class="editor-label">
            <label for="CartographicLength"><strong>Cartographic Length</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.CartographicLength) %>
            </div>&nbsp;
            
            <div class="editor-label">
               <label for="MetresOfAscent"><strong>Metres of Ascent</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.MetresOfAscent)%>
            </div>&nbsp;
                      
            <div class="editor-label">
               <label for="WalkTotalTime"><strong>Total Time</strong></label>
            </div>
            <div class="editor-field">
                Hours: <input type="text" name="total_time_hours" size="3" maxlength="3" id="total_time_hours"/> Mins:<input type="text" name="total_time_mins" size="3" maxlength="2" id="total_time_mins"/>
            </div>&nbsp;
            
            <div class="editor-label">
               <label for="WalkAverageSpeedKmh"><strong>Overall Speed (Km/h)</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkAverageSpeedKmh) %>
            </div>&nbsp;
            
            <div class="editor-label">
              <label for="MovingAverageKmh"><strong>Moving Average (Km/h)</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.MovingAverageKmh) %>
            </div>&nbsp;
            
           <div id="walksubmit">
           <br />
                <input type="button" id="createwalkbutton" value=" Add New Walk " />
          </div>
        </fieldset>

 
    <% End Using %>
    
  <!--Section: New Marker Pop-up Form------------------------------------------------------------> 

     <div id="MarkerModalDialogForm" title="Create New Marker">
        <p class="validateMarkerFormTips">*Required fields</p>
       <form>
             <fieldset>
                <label for="MarkerTitle">Title</label>*<br />
                <input type="text" name="MarkerTitle" id="MarkerTitle"  size="50" class="text ui-widget-content ui-corner-all" /><br />
                <label for="GPSReference">GPS Reference</label><br />
                <input type="text" name="MarkerGPSReference" id="MarkerGPSReference" size="14" maxlength="14" class="text ui-widget-content ui-corner-all" /><br />
                <label for="MarkerLeftOnHill">Hill</label><br />
                <input type="text" name="MarkerLeftOnHill" id="MarkerLeftOnHill" size="50" class="text ui-widget-content ui-corner-all" /><br />
                <input type="hidden" name="MarkerLeftOnHillId" id="MarkerLeftOnHillId" />
                <label for="MarkerDescription">Description</label><br />
                <textarea rows="4" cols="60" name="MarkerDescription" id="MarkerDescription" class="text-box ui-widget-content ui-corner-all"></textarea><br />
                <label for="MarkerDateLeft">Date Left</label>*<br />
                <input type="text" name="MarkerDateLeft" id="MarkerDateLeft" class="text ui-widget-content ui-corner-all" />
             </fieldset>
        </form>  
 
    </div>

    <div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>

