
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace MyMVCAppCS
{
    using System;

    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

     
            routes.MapRoute(
                "HillsInclassification",
                "Walks/HillsInClassification/{id}/{page}",
                new { controller = "Walks", action = "HillsInclassification", page = UrlParameter.Optional });

            routes.MapRoute(
                "HillsByArea",
                "Walks/HillsByArea/{id}/{page}",
                new { controller = "Walks", action = "HillsByArea", page = UrlParameter.Optional });

            routes.MapRoute(
                "ProgressByClass",
                "Progress/Index/{classtype}",
                new { controller = "Progress", action = "Index", classtype = UrlParameter.Optional });

            routes.MapRoute(
                     "Default",
                     "{controller}/{action}/{id}",
                     new { controller = "Walks", action = "Edit", id = 319 });

        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);

        }

        protected void Session_Start(object sender, EventArgs e)
        {
            // event is raised each time a new session is created     
      //      SessionSingleton.Current.UsageLocation = "At Home";

        }

    }
}