' Note: For instructions on enabling IIS6 or IIS7 classic mode, 
' visit http://go.microsoft.com/?LinkId=9394802

Public Class MvcApplication
    Inherits System.Web.HttpApplication

    Shared Sub RegisterRoutes(ByVal routes As RouteCollection)
        routes.IgnoreRoute("{resource}.axd/{*pathInfo}")

        ' MapRoute takes the following parameters, in order:
        ' (1) Route name
        ' (2) URL with parameters
        ' (3) Parameter defaults

        routes.MapRoute( _
            "Default", _
            "{controller}/{action}/{id}", _
            New With {.controller = "Walks", .action = "Index", .id = UrlParameter.Optional} _
        )

        routes.MapRoute( _
            "HillsInclassification", _
            "Walks/HillsInClassification/{id}/{page}", _
            New With {.controller = "Walks", .action = "HillsInclassification", .page = UrlParameter.Optional} _
        )

        routes.MapRoute( _
            "HillsByArea", _
            "Walks/HillsByArea/{id}/{page}", _
            New With {.controller = "Walks", .action = "HillsByArea", .page = UrlParameter.Optional} _
        )

        routes.MapRoute( _
            "ProgressByClass",
            "Progress/Index/{classtype}", _
            New With {.controller = "Progress", .action = "Index", .classtype = UrlParameter.Optional} _
        )

        ' ----Section below to be used to when running under IIS5.1------------
        'routes.MapRoute( _
        '    "Default", _
        '    "{controller}.mvc/{action}/{id}", _
        '    New With {.controller = "Walks", .action = "Index", .id = UrlParameter.Optional} _
        ')
        'routes.MapRoute( _
        '        "Root", _
        '        "", _
        '        New With {.controller = "Walks", .action = "Index", .id = ""} _
        '    )

    End Sub

    Sub Application_Start()
        AreaRegistration.RegisterAllAreas()

        RegisterRoutes(RouteTable.Routes)
    End Sub
End Class
