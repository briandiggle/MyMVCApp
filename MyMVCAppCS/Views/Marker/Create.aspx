﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCApp.DAL.Marker>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
   Create Marker
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ViewSpecificHead" runat="server">
<link type="text/css" href="../../Content/themes/base/jquery.ui.all.css" rel="Stylesheet" />
<script type="text/javascript" src="../../Scripts/jquery-2.1.1.js"></script>
<script type="text/javascript" src="../../Scripts/jquery-ui-1.10.4.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
<script type="text/javascript">
    
    $(function () {
        $().ready(function() {
            $("#Hillnumber").autocomplete({
                source: "/Walks/HillSuggestions",
                minLength: 2,
                select: function(event, ui) {
                    var hillid = extractid(ui.item.value);
                    $("#HillID").val(hillid);
                } 
            });


            function extractid(elementname) {
                if (elementname.indexOf("|") > 0) {
                    var myloc = elementname.indexOf("|");
                    return elementname.substring(myloc + 1).trim();
                }
                return "";
            }
        
            $("#WalkTitle").autocomplete({
                source: "/Walks/WalkSuggestions",
                minLength: 2,
                select: function(event, ui) {
                    var walkid = extractid(ui.item.value);
                    $("#WalkID").val(walkid);
                } 
            });


    
        });
    
        /*----Associate a datepicker widget ( from jQuery/UI/DatePicker ) with the WalkDate text box----*/
        $(function () {
            $("#DateLeft").datepicker({ dateFormat: 'dd MM yy' });
        });
        
    });
</script>

<% using (Html.BeginForm()) { %>
    <%: Html.ValidationSummary(true) %>
    <fieldset>
        <legend>Marker</legend>

        <div class="editor-label">
            <%: Html.LabelFor(marker => marker.MarkerTitle) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(marker => marker.MarkerTitle) %>
            <%: Html.ValidationMessageFor(marker => marker.MarkerTitle) %>
        </div>

        <div class="editor-label">
           <label for="Hillnumber"><strong>Hill name</strong></label>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(marker => marker.Hillnumber) %>
            <%: Html.ValidationMessageFor(marker=> marker.Hillnumber) %><%: Html.Hidden("HillID")%>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(marker => marker.GPS_Reference) %>
        </div>
        <div class="editor-field">
            <%: Html.TextBoxFor(marker => marker.GPS_Reference) %>
            <%: Html.ValidationMessageFor(marker => marker.GPS_Reference) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(marker => marker.Location_Description) %>
        </div>
        <div class="editor-field">
            <%: Html.TextAreaFor(marker => marker.Location_Description, 5, 80, new {id = "createwalkform"}) %>
            <%: Html.ValidationMessageFor(marker =>marker.Location_Description) %>
        </div>

        <div class="editor-label">
           <%: Html.LabelFor(marker => marker.Walk.WalkTitle) %>
        </div>
        <div class="editor-field">
            <input type="text" name="WalkTitle" id="WalkTitle" size="80 "/>
        <%: Html.Hidden("WalkID")%>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(marker => marker.DateLeft) %>
        </div>
        <div class="editor-field">
            <%: Html.TextBoxFor(marker => marker.DateLeft, new { size=20 }) %>
            <%: Html.ValidationMessageFor(marker => marker.DateLeft) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(marker => marker.Status) %>
        </div>
        <div class="editor-field">
                   <%= Html.DropDownList("MarkerStatusii")%>
        </div>

        <p>
            <input type="submit" value="Create" />
        </p>
    </fieldset>
<% } %>

<div>
    <%: Html.ActionLink("Back to List", "Index") %>
</div>

</asp:Content>

