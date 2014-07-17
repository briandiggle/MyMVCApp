
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace MyMVCAppCS
{
    using System;
    using MyMVCApp.Model;

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
                     new { controller = "Walks", action = "Index", id= UrlParameter.Optional });

        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);

        }

        protected void Session_Start(object sender, EventArgs e)
        {
            // event is raised each time a new session is created     
            SessionSingleton.Current.UsageLocation = WalkingConstants.AT_HOME;
        }

    }
}
