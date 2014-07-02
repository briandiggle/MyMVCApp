<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MyMVCAppCS.ViewModels.ConfigViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Update session configuration
</asp:Content>
<asp:Content ID="ViewSpecifiedHead1" ContentPlaceHolderID="ViewSpecificHead" runat="server">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<% Html.EnableClientValidation();%>
    <h2>Configuration</h2>

    <%-- The following line works around an ASP.NET compiler warning --%>
    <%: ""%>
    
    
     
    
          <%
         
     using (Html.BeginForm()) 
       {
           %>
        <%: Html.ValidationSummary(true) %>
    
        <table>
 
          <tr>
                <td class="searchform"><%: Html.LabelFor(configmodel => configmodel.AtWorkSetting) %></td> 
                <td class="searchform">
                    <%: Html.DropDownListFor(config => config.AtWorkSetting, Model.UsageLocationOptions) %>
                </td>               
                <td class="searchform"></td> 
            </tr>
                                                                                   
           <tr>
               <td colspan="3" class="searchform, aligncenter">
                    <input type="submit" value="Update Session Config" />
               </td>
           </tr>
            
      <tr>
               <td colspan="3" class="searchform, aligncenter">
                    &nbsp;
               </td>
           </tr>
        <tr>
               <td colspan="3" class="searchform, aligncenter">
                   <%: Model.ConfigUpdateMessage %>
               </td>
           </tr>
    </table>   
        
     
 <%
       }
       %>
 
</asp:Content>


