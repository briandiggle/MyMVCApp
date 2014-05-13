<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(Of WalkingMVC.WalkingMVC.ViewModels.SearchViewModel)" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Search walking database
</asp:Content>
<asp:Content ID="ViewSpecifiedHead1" ContentPlaceHolderID="ViewSpecificHead" runat="server">
<script src="../../Scripts/MicrosoftAjax.js" type="text/javascript"></script>
<script src="../../Scripts/MicrosoftMvcValidation.js" type="text/javascript"></script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<%  Html.EnableClientValidation()%>
    <h2>Search walking database</h2>

    <%-- The following line works around an ASP.NET compiler warning --%>
    <%: ""%>
    <% Using Html.BeginForm()%>
        <%: Html.ValidationSummary(True) %>
        <fieldset>
            <legend>Walk Search</legend>
            
            <div><span class="editor-label">
                <%: Html.LabelFor(Function(model) model.SearchText) %>
                </span>
                <span class="editor-field">
                <%: Html.TextBoxFor(Function(model) model.SearchText) %>
                <%: Html.ValidationMessageFor(Function(model) model.SearchText) %>
                </span>
            </div>
            <div>
                <span class="editor-label">
                <%: Html.LabelFor(Function(model) model.SearchImageCaptions)%>
                </span>
                <span class="editor-field">
                <%: Html.CheckBoxFor(Function(model) model.SearchImageCaptions)%>
                </span>
            </div>

           <div>
               <span class="editor-label">
                <%: Html.LabelFor(Function(model) model.SearchWalkDescriptions)%>
            </span>
                  
            <span class="editor-field">
                <%: Html.CheckBoxFor(Function(model) model.SearchWalkDescriptions)%>
            </span>
            </div>
            <p>
                <input type="submit" value="Search for Matching Walks" />
            </p>
        </fieldset>
        
      <fieldset>
            <legend>Image Search</legend>
      </fieldset>     
      
      <fieldset>
           <legend>Marker Search</legend>
      </fieldset>         
      
     <fieldset>
           <legend>Hill Search</legend>
      </fieldset>                   

        <% If Model.WalkResultsAvailable Then
             
                For Each walk In Model.walksFound
        %>
            <h1><%: walk.WalkTitle%></h1>
            <%: walk.WalkDescription %>
               <% Next%>

        <% End If
        End Using%>

</asp:Content>


