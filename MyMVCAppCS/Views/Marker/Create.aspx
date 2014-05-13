<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCApp.DAL.Marker>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
   Create Marker
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
    $().ready(function() {
        $("#Hillnumber").autocomplete("/Walks/HillSuggestions", {
            width: 500,
            max: 20,
            minChars: 2
        });


        $("#Hillnumber").result(function (event, data, formatted) {
            if (data) {  
                $("#HillID").val(data[1]);
               
            }
        });
        
        $("#Walk_WalkTitle").autocomplete("/Walks/WalkSuggestions", {
            width: 500,
            max: 20,
            minChars: 2
        });


        $("#Walk_WalkTitle").result(function (event, data, formatted) {
            if (data) {
                $("#WalkID").val(data[1]);

            }
        });
        
        /*----Associate a datepicker widget ( from jQuery/UI/DatePicker ) with the WalkDate text box----*/
        $(function () {
            $("#DateLeft").datepicker({ dateFormat: 'dd MM yy' });
        });
        
    });
</script>

<script src="<%: Url.Content("~/Scripts/jquery.validate.min.js") %>" type="text/javascript">
</script>
<script src="<%: Url.Content("~/Scripts/jquery.validate.unobtrusive.min.js") %>" type="text/javascript"></script>

<% using (Html.BeginForm()) { %>
    <%: Html.ValidationSummary(true) %>
    <fieldset>
        <legend>Marker</legend>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.MarkerTitle) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.MarkerTitle) %>
            <%: Html.ValidationMessageFor(model => model.MarkerTitle) %>
        </div>

        <div class="editor-label">
           <label for="Hillnumber"><strong>Hill name</strong></label>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.Hillnumber) %>
            <%: Html.ValidationMessageFor(model => model.Hillnumber) %><%: Html.Hidden("HillID")%>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.GPS_Reference) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.GPS_Reference) %>
            <%: Html.ValidationMessageFor(model => model.GPS_Reference) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.Location_Description) %>
        </div>
        <div class="editor-field">
            <%: Html.TextAreaFor(model => model.Location_Description, 5, 80, new {id = "createwalkform"}) %>
            <%: Html.ValidationMessageFor(model => model.Location_Description) %>
        </div>

        <div class="editor-label">
           <%: Html.LabelFor(model => model.Walk.WalkTitle) %>
        </div>
        <div class="editor-field">
            <%: Html.TextBoxFor(model => model.Walk.WalkTitle, new { size=80})%> <%: Html.Hidden("WalkID")%>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.DateLeft) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.DateLeft) %>
            <%: Html.ValidationMessageFor(model => model.DateLeft) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.Status) %>
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

