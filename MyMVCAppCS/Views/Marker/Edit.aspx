<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of MyMVCApp.DAL.Marker)" %>
<%@ Import Namespace="MyMVCAppCS.Models" %>
<%@ Import Namespace="MyMVCApp.DAL" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit Marker
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ViewSpecificHead" runat="server">
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
        /*----Associate an autocomplete AJAX based widget with the left on hill textbox------*/
        $("#LeftOnHillName").autocomplete("/Walks/HillSuggestions", {
            width: 500,
            max: 20,
            minChars: 2
        });
        $("#LeftOnHillName").result(function (event, data, formatted) {
            if (data) {
                $("#Hillnumber").val(data[1]);
            }
        });

        /*----Associate an autocomplete AJAX based widget with the walk name textbox------*/
        $("#MarkerLeftOnWalkName").autocomplete("/Walks/WalkSuggestions", {
            width: 500,
            max: 20,
            minChars: 2
        });
        $("#MarkerLeftOnWalkName").result(function (event, data, formatted) {
            if (data) {
                $("#WalkID").val(data[1]);
            }
        });

        /*----Associate a datepicker widget ( from jQuery/UI/DatePicker ) with the DateLeft text box----*/
        $(function () {
            $("#DateLeft").datepicker({ dateFormat: 'dd MM yy' });
        });

        /*----Create event for main button click----*/
        $('#editmarkerbutton').button().click(function () {
            $('#editmarkerform').submit();
        });

        $('#LeftOnHillName').click(function () {
            $('#LeftOnHillName').val("");
        });

        $('#MarkerLeftOnWalkName').click(function () {
            $('#MarkerLeftOnWalkName').val("");
        });

        $("#editmarkerform").validate({
            rules: {
                MarkerTitle: {
                    minlength: 5,
                    required: true
                },
                GPS_Reference: {
                    minlength: 12
                },
                Location_Description: {
                    minlength: 10
                },
                Date_Left: {
                    required: true
                }
            }
        });
    });

</script>


    <h2>Edit Marker</h2>

    <%-- The following line works around an ASP.NET compiler warning --%>
    <%: ""%>

    <%  Using Html.BeginForm("Edit", "Marker", FormMethod.Post, New With {.id = "editmarkerform", .name = "editmarkerform"})%>
        <%: Html.ValidationSummary(True) %>
        <fieldset>
          
            
            <div class="editor-field">
                <%: Html.HiddenFor(Function(model) model.MarkerID)%>
            </div>&nbsp;
            
            <div class="editor-label">
                <strong>Marker Title</strong>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.MarkerTitle, New With {.size = 80})%>
                <%: Html.ValidationMessageFor(Function(model) model.MarkerTitle) %>
            </div>&nbsp;
            
            <div class="editor-label">
                <strong>Left on Hill</strong>
            </div>
            <div class="editor-field">
                <%: Html.HiddenFor(Function(model) model.Hillnumber)%>
                <input type="text" name="LeftOnHillName" id="LeftOnHillName" size="80" value="<%= MyMVCApp.DAL.WalkingStick.FormatHillSummaryAsLine(Model.Hill)%>" />
            </div>&nbsp;
            
            <div class="editor-label">
                <strong><%: Html.LabelFor(Function(model) model.GPS_Reference) %></strong>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.GPS_Reference) %>
            </div>&nbsp;
            
            <div class="editor-label">
                <strong>Description</strong>
            </div>
            <div class="editor-field">
                <%: Html.TextAreaFor(Function(model) model.Location_Description, 8, 90, New With {.dummy = 0})%>
            </div>&nbsp;
            
            <div class="editor-label">
                <strong>Left on Walk</strong>
            </div>
            <div class="editor-field">
                <%: Html.HiddenFor(Function(model) model.WalkID)%>
                <input type="text" name="MarkerLeftOnWalkName" id="MarkerLeftOnWalkName" value="<%= MyMVCApp.DAL.WalkingStick.FormatWalkAsLine(Model.Walk)%>"size="80"/>
            </div>&nbsp;
            
            <div class="editor-label">
                <strong><%: Html.LabelFor(Function(model) model.DateLeft) %></strong>
            </div>
            <div class="editor-field">
                <input type="text" name="DateLeft" id="DateLeft"  size="40" maxlength="40" value="<%= String.Format("{0:D}", Model.DateLeft)%>" />
            </div>&nbsp;
            <% Dim selectlistMarkerStatusOptions As System.Collections.Generic.IEnumerable(Of System.Web.Mvc.SelectListItem) = ViewData("Marker_Statii")%>

            <div class="editor-label">
                <strong><%: Html.LabelFor(Function(model) model.Status) %></strong>
            </div>
            <div class="editor-field">
                <select name="Status">
                <%  For Each oStatus As Marker_Status In ViewData("Marker_Status")%>
                      <option value="<%= oStatus.Marker_Status1%>" <% If oStatus.Marker_Status1.Equals(Model.Status) Then Response.Write(" selected") %>><%= oStatus.Marker_Status1%></option>
                <%    Next%>
                </select>
               
            </div>&nbsp;
            
     <div id="walksubmit">
           <br />
                <input type="button" id="editmarkerbutton" value=" Update Marker " />
          </div>
        </fieldset>

    <% End Using %>

    <div>
        <%: Html.ActionLink("Back to Markers List", "Index") %>
    </div>

</asp:Content>
