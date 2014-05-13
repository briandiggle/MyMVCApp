<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of MyMVCApp.DAL.Walk)" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit <%= Model.WalkTitle%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ViewSpecificHead" runat="server">
<link type="text/css" href="../../Content/smoothness/jquery.ui.all.css" rel="Stylesheet" />
<link type="text/css" href="../../Content/jquery.autocomplete.css" rel="stylesheet" />
<link type="text/css" href="../../Content/autocomplete_thickbox.css" rel="stylesheet" />
<script type='text/javascript' src="../../Scripts/Autocomplete/lib/jquery.bgiframe.min.js"></script>
<script type='text/javascript' src="../../Scripts/Autocomplete/lib/jquery.ajaxQueue.js"></script>
<script type='text/javascript' src="../../Scripts/Autocomplete/thickbox-compressed.js"></script>
<script type='text/javascript' src="../../Scripts/Autocomplete/jquery.autocomplete.js"></script>
<script type="text/javascript" src="../../Scripts/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../../Scripts/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../../Scripts/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="../../Scripts/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="../../Scripts/ui/jquery.ui.button.js"></script>
<script type="text/javascript" src="../../Scripts/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="../../Scripts/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="../../Scripts/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="../../Scripts/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="../../Scripts/ui/jquery.effects.core.js"></script>
<script type="text/javascript" src="../../Scripts/jquery.validate.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">

    $().ready(function () {

        /*----Associate an autocomplete AJAX based widget with the walk area name textbox------*/
        $("#WalkAreaName").autocomplete("/Walks/WalkAreaSuggestions", {
            width: 500,
            max: 20,
            matchSubset: true,
            minChars: 2,
            selectFirst: false
        });

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

        /*----Define callback processing for the walk area name autocomplete AJAX widget------*/
        $("#WalkAreaName").result(function (event, data, formatted) {

            if (data) {
                iCountb = iCount + 1
                $("#WalkAreaID").val(data[1]);
            }

        });

        /*----Associate an autocomplete widget with each of the hill visited text boxes. Each hill visited text box has an----*/
        /*----matching hidden field which will hold a selected hill id-------*/
        for (iCount = 1; iCount <= 15; iCount = iCount + 1) {
            $("#VisitedSummit" + iCount).autocomplete("/Walks/HillSuggestions", {
                width: 500,
                max: 20,
                minChars: 2,
                extraParams: { areaid: function () { return $("#WalkAreaID").val(); } }
            });

            if (iCount > 1) {
                if ($("#DivVisitedSummit" + (iCount - 1)).val() == "") {
                    $("#DivVisitedSummit" + iCount).hide();
                }
            }
        }

        for (iCount = 1; iCount <= $('#numexistingimages').val(); iCount = iCount + 1) {
            /*---Inject an event handler, using .live, for the newly added imageismarker checkbox which will fire only when the checkbox is checked---------*/
            $('#existingimageismarker' + iCount + ":checked").live('click', { imagenumber: iCount }, function (e) {

                $(this).after('<span id="existingimageismarkerdetails' + e.data.imagenumber + '"></span>');
                $('#existingimageismarkerdetails' + e.data.imagenumber).append('<br/>Marker name: ');

                var input = $('<input type="text" size="50" name="existingimagemarkername' + e.data.imagenumber + '" id="existingimagemarkername' + e.data.imagenumber + '" /> Not Found? <input type="checkbox" id="existingimagemarkernotfound' + e.data.imagenumber + '" name="existingimagemarkernotfound' + e.data.imagenumber + '" /></span>');
                input.autocomplete("/Walks/MarkerSuggestions", {
                    width: 500,
                    max: 20,
                    minChars: 2,
                    selectFirst: false,
                    extraParams: { imagenumber: e.data.imagenumber }
                });
                /*----Define callback processing for the image of marker------*/
                input.result(function (event, data, formatted) {

                    if (data) {
                        $("#existingimagemarkerid" + data[2]).val(data[1]);
                    }

                });

                $('#existingimageismarkerdetails' + e.data.imagenumber).append(input);
                $('#existingimageismarkerdetails' + e.data.imagenumber).append('<input type="hidden" id="existingimagemarkerid' + e.data.imagenumber + '" name="existingimagemarkerid' + e.data.imagenumber + '" />');

            });


            $('#existingimageismarker' + iCount + ":not(:checked)").live('click', { imagenumber: iCount }, function (e) {
                $('#existingimageismarkerdetails' + e.data.imagenumber).remove();
            });

            /*---Associate an AJAX autocomplete with any marker associations already defined for existing images-----*/
            if ($('#existingimageismarkerdetails' + iCount).length > 0) {
                $('#existingimagemarkername' + iCount).autocomplete("/Walks/MarkerSuggestions", {
                    width: 500,
                    max: 20,
                    mustMatch: true,
                    matchSubset: true,
                    minChars: 2,
                    selectFirst: false
                });
            }
        }


        /*----Associate AJAX callback processing for each of the autocomplete widgets----------*/
        $("#VisitedSummit1").result(function (event, data, formatted) {
            if (data) {
                iCountb = iCount + 1
                $("#VisitedSummit1HillID").val(data[1]);
                $("#DivVisitedSummit2").show();
            }
        });

        $("#VisitedSummit2").result(function (event, data, formatted) {
            if (data) {
                iCountb = iCount + 1
                $("#VisitedSummit2HillID").val(data[1]);
                $("#DivVisitedSummit3").show();
            }
        });

        $("#VisitedSummit3").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit3HillID").val(data[1]);
                $("#DivVisitedSummit4").show();
            }
        });

        $("#VisitedSummit4").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit4HillID").val(data[1]);
                $("#DivVisitedSummit5").show();
            }
        });

        $("#VisitedSummit5").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit5HillID").val(data[1]);
                $("#DivVisitedSummit6").show();
            }
        });

        $("#VisitedSummit6").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit6HillID").val(data[1]);
                $("#DivVisitedSummit7").show();
            }
        });

        $("#VisitedSummit7").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit7HillID").val(data[1]);
                $("#DivVisitedSummit8").show();
            }
        });

        $("#VisitedSummit8").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit8HillID").val(data[1]);
                $("#DivVisitedSummit9").show();
            }
        });

        $("#VisitedSummit9").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit9HillID").val(data[1]);
                $("#DivVisitedSummit10").show();
            }
        });

        $("#VisitedSummit10").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit10HillID").val(data[1]);
                $("#DivVisitedSummit11").show();
            }
        });

        $("#VisitedSummit11").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit11HillID").val(data[1]);
                $("#DivVisitedSummit12").show();
            }
        });
        $("#VisitedSummit12").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit12HillID").val(data[1]);
                $("#DivVisitedSummit13").show();
            }
        });
        $("#VisitedSummit13").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit13HillID").val(data[1]);
                $("#DivVisitedSummit14").show();
            }
        });
        $("#VisitedSummit14").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit14HillID").val(data[1]);
                $("#DivVisitedSummit115").show();
            }
        });
        $("#VisitedSummit15").result(function (event, data, formatted) {
            if (data) {
                $("#VisitedSummit15HillID").val(data[1]);
            }
        });
        /*----Associate a datepicker widget ( from jQuery/UI/DatePicker ) with the WalkDate text box----*/
        $(function () {
            $("#WalkDate").datepicker({ dateFormat: 'dd MM yy' });
        });

        /*----When "check images" is clicked, make AJAX call to see how many matching images are found.----*/
        /*----Then insert the images together with ImageCaption text boxes into the DOM------*/
        $('#getimages').click(function () {

            $.get('/Walks/CheckImages', { imagepath: $("#images_path").val() }, function (oResults) {

                for (iCount = 1; iCount <= oResults.imagesfound; iCount = iCount + 1) {
                    $("#walkimages").append('<br/><b>New Image ' + iCount + '</b><br/><input type="text" name="imageImageCaption' + iCount + '" size="100" />');
                    $("#walkimages").append('&nbsp;<span id="spanimageismarker' + iCount + '">Marker? <input type="checkbox" id="imageismarker' + iCount + '" name="imageismarker' + iCount + '"/></span>');
                    if (oResults.atwork == "True") {
                        $("#walkimages").append("&nbsp;" + oResults.filenameprefix + iCount + '.jpg</br>');
                    } else {
                        $("#walkimages").append('<br/><img src="' + oResults.path + iCount + '.jpg" border="1" />');
                    }
                    $('#walkimages').append('<input type="hidden" name="imagerelpath' + iCount + '" value="' + oResults.path + iCount + '.jpg"/><br/>');

                    /*---Inject an event handler, using .live, for the newly added imageismarker checkbox which will fire only when the checkbox is checked---------*/
                    $('#imageismarker' + iCount + ":checked").live('click', { imagenumber: iCount }, function (e) {
                        $(this).after('<span id="imagemarkerdetails' + e.data.imagenumber + '"></span>');
                        $('#imagemarkerdetails' + e.data.imagenumber).append('<br/>Marker name: ');

                        /*----Insert the autocomplete for the newly added marker node------*/
                        var input = $('<input type="text" size="50" name="imagemarkername' + e.data.imagenumber + '" id="imagemarkername' + e.data.imagenumber + '" /> Not Found? <input type="checkbox" id="imagemarkernotfound' + e.data.imagenumber + '" name="imagemarkernotfound' + e.data.imagenumber + '" /></span>');
                        input.autocomplete("/Walks/MarkerSuggestions", {
                            width: 500,
                            max: 20,
                            mustMatch: true,
                            minChars: 2,
                            selectFirst: false,
                            extraParams: { imagenumber: e.data.imagenumber }
                        });
                        /*----Define callback processing for the image of marker------*/
                        input.result(function (event, data, formatted) {

                            if (data) {
                                $("#imagemarkerid" + data[2]).val(data[1]);
                            }

                        });

                        $('#imagemarkerdetails' + e.data.imagenumber).append(input);
                        $('#imagemarkerdetails' + e.data.imagenumber).append('<input type="hidden" id="imagemarkerid' + e.data.imagenumber + '" name="imagemarkerid' + e.data.imagenumber + '" />');

                    });

                    /*---Inject an event handler, using .live, for the newly added imageismarker checkbox which will fire only when the checkbox is un-checked---------*/

                    $('#imageismarker' + iCount + ":not(:checked)").live('click', { imagenumber: iCount }, function (e) {
                        $("#imagemarkerdetails" + e.data.imagenumber).remove();
                    });

                }
                $("#images_path").focus();
            });

        });

        /*----Associate a AJAX call (AJAJ in fact as it returns JSON) with the blur event of the auxilliary_file1 */
        /*----How to write a generic handler?------------------------------*/
        for (iCount = 2; iCount <= 6; iCount = iCount + 1) {
            $('#auxilliary_filesdiv' + iCount).hide();
        }

        $('#auxilliary_file1').change(function () {
            $.getJSON('/Walks/CheckFileInWebrootJSON', { imagepath: $('#auxilliary_file1').val() }, function (oResults, status) {

                if (oResults.isinpath == "False") {
                    alert('The file you chose is not in the web site root.');
                    /*      reset_html('auxilliary_filesdiv1'); */
                } else {
                    $('#auxilliary_filesdiv2').show();
                }
            });

        });


        $('#auxilliary_file2').change(function () {
            $.getJSON('/Walks/CheckFileInWebrootJSON', { imagepath: $('#auxilliary_file2').val() }, function (oResults, status) {

                if (oResults.isinpath == "False") {
                    alert('The file you chose is not in the web site root.');
                    /*      reset_html('auxilliary_filesdiv1'); */
                } else {
                    $('#auxilliary_filesdiv3').show();
                }
            });

        });

        $('#auxilliary_file3').change(function () {
            $.getJSON('/Walks/CheckFileInWebrootJSON', { imagepath: $('#auxilliary_file3').val() }, function (oResults, status) {

                if (oResults.isinpath == "False") {
                    alert('The file you chose is not in the web site root.');
                    /*      reset_html('auxilliary_filesdiv1'); */
                } else {
                    $('#auxilliary_filesdiv4').show();
                }
            });

        });

        $('#auxilliary_file4').change(function () {
            $.getJSON('/Walks/CheckFileInWebrootJSON', { imagepath: $('#auxilliary_file4').val() }, function (oResults, status) {

                if (oResults.isinpath == "False") {
                    alert('The file you chose is not in the web site root.');
                    /*      reset_html('auxilliary_filesdiv1'); */
                } else {
                    $('#auxilliary_filesdiv5').show();
                }
            });

        });

        $('#auxilliary_file5').change(function () {
            $.getJSON('/Walks/CheckFileInWebrootJSON', { imagepath: $('#auxilliary_file5').val() }, function (oResults, status) {

                if (oResults.isinpath == "False") {
                    alert('The file you chose is not in the web site root.');
                    /*      reset_html('auxilliary_filesdiv1'); */
                } else {
                    $('#auxilliary_filesdiv6').show();
                }
            });

        });

        $('#auxilliary_file6').change(function () {
            $.getJSON('/Walks/CheckFileInWebrootJSON', { imagepath: $('#auxilliary_file6').val() }, function (oResults, status) {

                if (oResults.isinpath == "False") {
                    alert('The file you chose is not in the web site root.');
                    /*      reset_html('auxilliary_filesdiv1'); */
                }
            });

        });

        /*----If the walk is circular, put the start location in the end location field */
        $('#WalkStartPoint').keyup(function () {
            if ($('#WalkTypes').val() == 'Mountain  - Circular' || $('#WalkTypes').val() == 'Valley - Circular') {
                $('#WalkEndPoint').val($('#WalkStartPoint').val());
            }

        });

        /*-----Clever gizmo needed to reset the contents of a form input field by resetting the html content of the encapsulating div-----*/
        function reset_html(id) {
            $('#' + id).html($('#' + id).html());
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

        /*----Now follows...the modal form for marker creation------------------------*/
        var markertitle = $("#MarkerTitle"),
			markerdateleft = $("#MarkerDateLeft"),
			markerdescription = $("#MarkerDescription"),
            markerhill = $("#MarkerLeftOnHill"),
            markerhillid = $("#MarkerLeftOnHillId"),
            markergps = $("#MarkerGPSReference"),
            markerwalkid = $('#NewMarkerWalkID'),
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

        function checkRegexp(o, regexp, n) {

            if (!(regexp.test(o.val()))) {
                o.addClass('ui-state-error');
                updateTips(n);
                return false;
            } else {
                return true;
            }

        }

        /*----Add a modal form which is used to capture the data for a new marker. Using jQuery/UI/Dialog---------*/
        $("#MarkerModalDialogForm").dialog({
            autoOpen: false,
            height: 400,
            width: 500,
            modal: true,
            buttons: {
                'Create Marker': function () {
                    var bValid = true;
                    allFields.removeClass('ui-state-error');

                    bValid = bValid && checkLength(markertitle, "marker title", 5, 80);
                    bValid = bValid && checkLength(markerdescription, "description", 6, 1000);
                    bValid = bValid && checkLength(markerdateleft, "date left", 5, 18);

                    if (bValid) {

                        /*-----Do AJAX call to add insert the new marker so that its available immediately for selection----*/
                        $.getJSON('/Walks/CreateMarker', { mtitle: markertitle.val(), mdesc: markerdescription.val(), mdate: markerdateleft.val(), mhillid: markerhillid.val(), mgps: markergps.val(), mwalkid: markerwalkid.val() },
                            function (oResults, status) {
                                if (status == "success") {
                                    $('#WalkMarkers').append('<br/><table class="markertable"><tr><td colspan="2"><strong>Marker Created</strong></td></tr>' +
							        '<tr><td><em>Title:</em></td><td>' + markertitle.val() + '</td></tr><tr><td><em>Date Left:</em></td><td>' +
							        markerdateleft.val() + '</td></tr><tr><td>Description:</td><td>' + nl2br(markerdescription.val()) + '</td></tr></table>');
                                    var mi = $("#markers_added").val();
                                    $("#markers_added").val(mi + ":" + oResults.markerid);
                                    $("#MarkerModalDialogForm").dialog('close');
                                } else {
                                    $(".validateMarkerFormTips") = "An error occurred when inserting the new marker: " + status;
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
        $('#editwalkbutton').button().click(function () {
            $('#editwalkform').submit();
        });

        /*----Associate a date picker with the marker left date----*/
        $("#MarkerDateLeft").datepicker({ dateFormat: 'dd MM yy' });

        /*----Associate an autocomplete with the marker left on hill box which will make an AJAX call-----*/
        $("#MarkerLeftOnHill").autocomplete("/Walks/HillSuggestions", {
            width: 500,
            max: 20,
            mustmatch: true,
            minchars: 2,
            selectfirst: false
        });
        /*----Deal with the AJAX call back which holds the Hill ID also----*/
        $("#MarkerLeftOnHill").result(function (event, data, formatted) {
            if (data) {
                $("#MarkerLeftOnHillId").val(data[1]);
            }
        });

        /*---Empty the autocomplete text field on click----*/
        $('#WalkAreaName').click(function () {
            $('#WalkAreaName').val("");
        });

        /*----Set up form validation with the jQuery Validation plugin-------*/
        $("#editwalkform").validate({
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

    function nl2br(text) {
        text = escape(text);
        if (text.indexOf('%0D%0A') > -1) {
            re_nlchar = /%0D%0A/g;
        } else if (text.indexOf('%0A') > -1) {
            re_nlchar = /%0A/g;
        } else if (text.indexOf('%0D') > -1) {
            re_nlchar = /%0D/g;
        } else {
        re_nlchar = '<br/>';
        }
        return unescape(text.replace(re_nlchar, '<br />'));
    }

    function injectareaid() {
        return $("#WalkAreaID").val();
    }
</script>
    <h2>Edit <em><%=Model.WalkTitle()%></em></h2>

    <%-- The following line works around an ASP.NET compiler warning --%>
    <%: ""%>
    <% Using Html.BeginForm("Edit", "Walks", FormMethod.Post, New With {.id = "editwalkform", .name = "editwalkform"})%>
        <%: Html.ValidationSummary(True) %>
        <fieldset>
           
            
            <div class="editor-label">
                <label for="WalkDate"><strong>Walk Date</strong></label>
            </div>
            <div class="editor-field">
                <input type="text" name="WalkDate" size="40" maxlength="40" value="<%= String.Format("{0:D}", Model.WalkDate)%>" />
            </div>
            &nbsp;
          <div class="editor-label">
                <label for="WalkTitle"><strong>Walk Title</strong></label>
           </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkTitle, New With {.size = 80})%>
            </div>&nbsp;
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
                <%: Html.TextBoxFor(Function(model) model.WalkSummary, New With {.size = 80})%> Auto: <input type="checkbox" name="summary_auto" id="summary_auto" checked />
            </div>&nbsp;      
          <div class="editor-label">
                <label for="WalkConditions"><strong>Walk Conditions</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkConditions, New With {.size = 80})%>
            </div>&nbsp;   
             
           <div class="editor-label">
                <strong><%: Html.Label("Summits Visited")%></strong>
            </div>     
            <% For iHillAscentsCounter = 1 To Model.HillAscents.Count%>
             <div class="editor-field" id="Div1">
                <%: Html.TextBox("VisitedSummit" + iHillAscentsCounter.ToString, MyMVCApp.DAL.WalkingStick.FormatHillSummaryAsLine(Model.HillAscents(iHillAscentsCounter - 1).Hill) + " ", New With {.size = 80})%> <%: Html.Hidden("VisitedSummit" + iHillAscentsCounter.ToString + "HillID", Model.HillAscents(iHillAscentsCounter - 1).Hillnumber.ToString)%>
            </div>
            <% Next%>      
             <% For iHillVisitedCounter As Integer = Model.HillAscents.Count + 1 To 15%>   
            <div class="editor-field" id="DivVisitedSummit<%= iHillVisitedCounter.ToString %>">
                <%: Html.TextBox("VisitedSummit" + iHillVisitedCounter.ToString, "", New With {.size = 80})%> <%: Html.Hidden("VisitedSummit" + iHillVisitedCounter.ToString + "HillID")%>
            </div>
            <% Next%>
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
          &nbsp;<div class="editor-field" id="WalkMarkers">
            <button id="CreateMarkerButton" type="button">Create New Marker</button><input type="hidden" id="markers_added" name="markers_added" value=""/>
          </div>  &nbsp;                                                      
            <div class="editor-label">
                 <label for="WalkDescription"><strong>Walk Description</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextAreaFor(Function(model) model.WalkDescription, 8, 100, New With {.class = "formtextarea"})%>
            </div>&nbsp;
            <div class="editor-label">
                <strong>New Images</strong>
               <label for="images_path">Full path and name prefix of images </label>E.g. <pre>C:\DEV\MyMVCApp\MyMVCApp\Content\images\lakes\202\SilverHow_8December2009_</pre>
           </div>
           <div class="editor-field">
                <input type="text" name="images_path" id="images_path" size="80" maxlength="160"  value="" />
                <input type="button" name="getimages" id="getimages" value="Get images" />
           </div>   &nbsp;    
           <div class="editor-field" id="walkimages">
           <% 
               Dim iExistingImageCount As Integer = 1
               For Each oWalkImage In Model.Walk_AssociatedFiles.Where(Function(af) af.Walk_AssociatedFile_Type.Equals("Image"))
                   
                   If iExistingImageCount = 1 Then
                       Response.Write("<strong>Existing Images</strong><br />")
                   End If%>
            <br/>Image <%= iExistingImageCount.ToString%> Delete? <input type="checkbox" id="deletexistingimage<%= iExistingImageCount.ToString %>" name="deletexistingimage<%= iExistingImageCount.ToString %>" /><br/><input type="text" name="existingimagecaption<%=iExistingImageCount.ToString %>" value="<%= oWalkImage.Walk_AssociatedFile_Caption %>" size="100" />              
            <input type="hidden" name="existingimagename<%= iExistingImageCount.ToString %>" value="<%= oWalkImage.Walk_AssociatedFile_Name %>" />&nbsp;<span id="spanexistingimageismarker<%=iExistingImageCount.ToString %>">Marker? 
            <% If Not IsNothing(oWalkImage.Walk_AssociatedFile_MarkerID) Then%>           
            <input type="checkbox" id="existingimageismarker<%=iExistingImageCount.ToString %>" name="existingimageismarker<%=iExistingImageCount.ToString %>" checked /></span>
            <span id="existingimageismarkerdetails<%=iExistingImageCount.ToString %>"><br/>Marker name: <input type="text" size="50" name="existingimagemarkername<%=iExistingImageCount.ToString %>" id="existingimagemarkername<%=iExistingImageCount.ToString %>" value="<%= MyMVCApp.DAL.WalkingStick.FormatMarkerAsLine(oWalkImage.Marker) %>"/> Not Found? <input type="checkbox" id="existingimagemarkernotfound<%=iExistingImageCount.ToString %>" name="existingimagemarkernotfound<%=iExistingImageCount.ToString %>" /></span>
            <input type="hidden" id="existingimagemarkerid<%=iExistingImageCount.ToString %>" name="existingimagemarkerid<%=iExistingImageCount.ToString %>" value="<%=oWalkImage.Walk_AssociatedFile_MarkerID.Tostring %>"/>
            <% Else%>
             <input type="checkbox" id="existingimageismarker<%=iExistingImageCount.ToString %>" name="existingimageismarker<%=iExistingImageCount.ToString %>" />

            <% End If %>
 
            <% If ViewData("AT_WORK") = "True" Then%>       
                   &nbsp;<%= MyMVCApp.DAL.WalkingStick.ExtractFileNameFromPath(oWalkImage.Walk_AssociatedFile_Name)%><br />
            <% Else %>
                   <br/><img src="<%= oWalkImage.Walk_AssociatedFile_Name %>" border="1" alt="existing image"/>
            <%  End If
                iExistingImageCount = iExistingImageCount + 1
            Next            
            %>
            <input id="numexistingimages" type="hidden" name="numexistingimages" value="<%= iExistingImageCount-1 %>" />
           </div>
           <br />
           <div class="editor-label">
             <strong>Additional Files</strong>
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
           <% For iAuxCounter = 1 To 6%>
           <div class="editor-field" id="auxilliary_filesdiv<%=iAuxCounter %>"> 
                <input type="file" id="auxilliary_file<%=iAuxCounter %>" name="auxilliary_file<%=iAuxCounter %>" size="80"/> <%: Html.DropDownList("auxilliary_filetype" + iAuxCounter.ToString, selectlist)%>
                <input type="text" id="auxilliary_caption<%=iAuxCounter %>" name="auxilliary_caption<%=iAuxCounter%>" size="40" /><br />
           </div>
           <% Next%>
           &nbsp;
            <div class="editor-label">
               <label for="Start Point"><strong>Start Point</strong></label>
             </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkStartPoint, New With {.size = 80, .maxlength = 100})%>
            </div>&nbsp;
            <div class="editor-label">
                <label for="WalkEndPoint"><strong>End Point</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkEndPoint, New With {.size = 80, .maxlength = 100})%>
            </div>  &nbsp;       
           <div class="editor-label">
               <label for="WalkCompanions"><strong>With</strong></label>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.WalkCompanions, New With {.size = 50, .maxlength = 50})%>
            </div>  &nbsp;             
            <div class="editor-label">
                <label for="WalkTypes"><strong>Walk Type</strong></label>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("WalkTypes")%>
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
                <%: Html.TextBoxFor(Function(model) model.MetresOfAscent) %>
            </div>&nbsp;
                      
            <div class="editor-label">
               <label for="WalkTotalTime"><strong>Total Time</strong></label>
            </div>
            <div class="editor-field">
                Hours: <input type="text" name="total_time_hours" size="3" maxlength="3" value="<%= (model.WalkTotalTime \ 60).ToString %>" id="total_time_hours"/> Mins:<input type="text" name="total_time_mins" size="3" maxlength="2" value="<%= (Model.WalkTotalTime Mod 60).ToString %>" id="total_time_mins"/>
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
            </div>
            
           <div id="walksubmit">
           <br />
                <input type="button" id="editwalkbutton" value=" Update Walk " />
          </div>
        </fieldset>

 
    <% End Using %>

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
                <input type="hidden" name="NewMarkerWalkID" id="NewMarkerWalkID" value="<%= model.WalkID %>"/>
             </fieldset>
        </form>  
 
    </div>

    <div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>
