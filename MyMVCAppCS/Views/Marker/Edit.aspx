﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCApp.DAL.Marker>" %>
<%@ Import Namespace="MyMVCAppCS.Models" %>
<%@ Import Namespace="MyMVCApp.DAL" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit Marker
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ViewSpecificHead" runat="server">
<link type="text/css" href="../../Content/themes/base/jquery.ui.all.css" rel="Stylesheet" />
<script type="text/javascript" src="../../Scripts/jquery-2.1.1.js"></script>
<script type="text/javascript" src="../../Scripts/jquery-ui-1.10.4.js"></script>
<script type="text/javascript" src="../../Scripts/jquery.validate.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">

    $().ready(function () {

        function extractid(elementname) {
            if (elementname.indexOf("|") > 0) {
                var myloc = elementname.indexOf("|");
                return elementname.substring(myloc + 1).trim();
            }
            return "";
        }

        /*----Associate an autocomplete AJAX based widget with the left on hill textbox------*/
        $("#LeftOnHillName").autocomplete({
            source: "/Walks/HillSuggestions",
            minLength: 2,
            select: function (event, ui) {
                var hillid = extractid(ui.item.value);
                $("#Hillnumber").val(hillid);
            }
        });

        /*----Associate an autocomplete AJAX based widget with the walk name textbox------*/
        $("#MarkerLeftOnWalkName").autocomplete({
            source: "/Walks/WalkSuggestions",
            minLength: 2,
            select: function (event, ui) {
                var walkid = extractid(ui.item.value);
                $("#WalkID").val(walkid);
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

    <%  using (Html.BeginForm("Edit", "Marker", FormMethod.Post, new { id = "editmarkerform", name = "editmarkerform"}))
        {
        %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
          
            
            <div class="editor-field">
                <%: Html.HiddenFor(marker => marker.MarkerID)%>
            </div>&nbsp;
            
            <div class="editor-label">
                <strong>Marker Title</strong>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(marker => marker.MarkerTitle, new { size = 80})%>
                <%: Html.ValidationMessageFor(marker => marker.MarkerTitle) %>
            </div>&nbsp;
            
            <div class="editor-label">
                <strong>Left on Hill</strong>
            </div>
            <div class="editor-field">
                <%: Html.HiddenFor(marker => marker.Hillnumber)%>
                <input type="text" name="LeftOnHillName" id="LeftOnHillName" size="80" value="<%= MyMVCApp.DAL.WalkingStick.FormatHillSummaryAsLine(Model.Hill)%>" />
            </div>&nbsp;
            
            <div class="editor-label">
                <strong><%: Html.LabelFor(marker => marker.GPS_Reference) %></strong>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(marker => marker.GPS_Reference) %>
            </div>&nbsp;
            
            <div class="editor-label">
                <strong>Description</strong>
            </div>
            <div class="editor-field">
                <%: Html.TextAreaFor(marker => marker.Location_Description, 8, 90, new { dummy = 0})%>
            </div>&nbsp;
            
            <div class="editor-label">
                <strong>Left on Walk</strong>
            </div>
            <div class="editor-field">
                <%: Html.HiddenFor(marker => marker.WalkID)%>
                <input type="text" name="MarkerLeftOnWalkName" id="MarkerLeftOnWalkName" value="<%= MyMVCApp.DAL.WalkingStick.FormatWalkAsLine(Model.Walk)%>"size="80"/>
            </div>&nbsp;
            
            <div class="editor-label">
                <strong><%: Html.LabelFor(marker => marker.DateLeft) %></strong>
            </div>
            <div class="editor-field">
                <input type="text" name="DateLeft" id="DateLeft"  size="40" maxlength="40" value="<%= String.Format("{0:D}", Model.DateLeft)%>" />
            </div>&nbsp;
            <% var selectlistMarkerStatusOptions  = ViewData["Marker_Statii"]%>

            <div class="editor-label">
                <strong><%: Html.LabelFor(marker => marker.Status) %></strong>
            </div>
            <div class="editor-field">
                <select name="Status">
                <% foreach ( Marker_Status oStatus in (IEnumerable)this.ViewData["Marker_Status"]) { %>
                      <option value="<%= oStatus.Marker_Status1%>" <% if (oStatus.Marker_Status1.Equals(Model.Status)) { Response.Write(" selected"); } %>><%= oStatus.Marker_Status1%></option>
                <%  } %>
                </select>
               
            </div>&nbsp;
            
     <div id="walksubmit">
           <br />
                <input type="button" id="editmarkerbutton" value=" Update Marker " />
          </div>
        </fieldset>

    <% } %>

    <div>
        <%: Html.ActionLink("Back to Markers List", "Index") %>
    </div>

</asp:Content>
