Imports WalkingMVC.WalkingDB

Namespace WalkingMVC

    Public Class WalksController
        Inherits System.Web.Mvc.Controller

        'Ensure that when the walking controller is instantiated, a data repository will be instantiated which will ----
        'persist for future method calls on the controller

        '====Define the repository as the interface. Seperated from the constructor to aid inversion of control=======
        Dim _repository As IWalkingRepository

        '=====Constructor for the repository object==============================
        Public Sub New()
            _repository = New SqlWalkingRepository

        End Sub
        '
        ' GET: /Walks

        Function Index() As ActionResult

            '---Use the walking repository to get a list of all the walking regions----
            '   Dim IQregions = _repository.GetAllWalkingAreas()
            '   Return View(IQregions)

            Return View()


        End Function

        '-------------------------------------------------------------------------------------
        ' Function: WalkingAreas()
        ' URL     : /Walks/WalkingAreas
        ' Descr   : Return a list of all walking areas
        '--------------------------------------------------------------------------------------
        Function WalkingAreas() As ActionResult

            '---Use the walking repository to get a list of all the walking regions----
            Dim IQWalkingAreas = _repository.GetAllWalkingAreas()

            Return View(IQWalkingAreas)

        End Function

        '-------------------------------------------------------------------------------------
        ' Function: WalkingAreas(Country, AreaType)
        ' URL     : /Walks/WalkingAreas/strCountryCode/strAreaType
        ' Descr   : Return a list walking areas in a given country and of a given type
        '--------------------------------------------------------------------------------------

        Function WalkingAreas(ByVal strCountryCode As String, ByVal strAreaType As String) As ActionResult

            '---Use the walking repository to get a list of all the walking regions----
            Dim IQWalkingAreas = _repository.GetAllWalkingAreas()

            Return View(IQWalkingAreas)

        End Function


        '-------------------------------------------------------------------------------------
        ' Function: WalkingAreasByCountry(Country, AreaType)
        ' URL     : /Walks/WalkingAreasByCountry/Country/AreaType
        ' Descr   : Return a list walking areas in a given country and area type
        '--------------------------------------------------------------------------------------

        Function WalkingAreasByCountry(ByVal strCountryCode As String, Optional ByVal strAreaType As String = Nothing) As ActionResult

            Dim strCountryName As String = WalkingMVC.Helpers.WalkingStick.CountryNameFromCountryCode(strCountryCode)
            Dim strAreaTypeName As String = ""
            ViewData("CountryName") = strCountryName

            '---Use the walking repository to get a list of all the walking regions---
            Dim IQWalkingAreas As IQueryable
            If IsNothing(strAreaType) Then
                IQWalkingAreas = _repository.GetAllWalkingAreas(strCountryCode)
            Else
                IQWalkingAreas = _repository.GetAllWalkingAreas(strCountryCode, strAreaType)
                strAreaTypeName = _repository.GetWalkAreaTypeNameFromType(strAreaType)
            End If
            ViewData("AreaTypeName") = strAreaTypeName

            Return View(IQWalkingAreas)

        End Function

        '-------------------------------------------------------------------------------------
        ' Function: HillClasses
        ' URL     : /Walks/HillClasses
        ' Descr   : Return a list of hill classifications
        '--------------------------------------------------------------------------------------

        Function HillClasses() As ActionResult

            '---Use the walking repository to get a list of all the walking regions----
            Dim IQHillClasses = _repository.GetAllHillClassifications().OrderBy(Function(classification) classification.Classname)

            Return View(IQHillClasses)

        End Function

        '-------------------------------------------------------------------------------------
        ' Function: HillInClassification
        ' URL     : /Walks/HillsInClassification/Classref/[Pagenumber]
        ' Descr   : Return a list of hills with classification as specified by id parameter
        '           optional page parameter provides pagination.
        '--------------------------------------------------------------------------------------

        Function HillsInClassification(ByVal id As String, Optional ByVal OrderBy As String = "NameAsc", Optional ByVal page As Integer = 1) As ActionResult

            '-----Enable provision of entire paginated hills list------
            If IsNothing(id) Then
                ViewData("HillClassName") = "All Hill Classes"
            Else
                ViewData("HillClassName") = _repository.GetHillClassificationName(id)
            End If

            '-----Get the full hill classification name and pass it to the view---------------



            '---Use the walking repository to get a list of all the hills in the specified classification----
            Dim IQHillsInClassificaton As System.Linq.IQueryable(Of WalkingMVC.Hill)

            If OrderBy = "NameAsc" Then
                IQHillsInClassificaton = _repository.GetHillsByClassification(id).OrderBy(Function(hill) hill.Hillname)
                ViewData("OrderBy") = "Name"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "NameDesc" Then
                IQHillsInClassificaton = _repository.GetHillsByClassification(id).OrderByDescending(Function(hill) hill.Hillname)
                ViewData("OrderBy") = "Name"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "MetresAsc" Then
                IQHillsInClassificaton = _repository.GetHillsByClassification(id).OrderBy(Function(hill) hill.Metres)
                ViewData("OrderBy") = "Metres"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "MetresDesc" Then
                IQHillsInClassificaton = _repository.GetHillsByClassification(id).OrderByDescending(Function(hill) hill.Metres)
                ViewData("OrderBy") = "Metres"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "FirstAscentDesc" Then
                IQHillsInClassificaton = _repository.GetHillsByClassification(id).OrderByDescending(Function(hill) hill.FirstClimbedDate)
                ViewData("OrderBy") = "FirstAscent"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "FirstAscentAsc" Then
                IQHillsInClassificaton = _repository.GetHillsByClassification(id).OrderBy(Function(hill) hill.FirstClimbedDate)
                ViewData("OrderBy") = "FirstAscent"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "NumberAscentDesc" Then
                IQHillsInClassificaton = _repository.GetHillsByClassification(id).OrderByDescending(Function(hill) hill.NumberOfAscents)
                ViewData("OrderBy") = "NumberAscent"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "NumberAscentAsc" Then
                IQHillsInClassificaton = _repository.GetHillsByClassification(id).OrderBy(Function(hill) hill.NumberOfAscents)
                ViewData("OrderBy") = "NumberAscent"
                ViewData("OrderAscDesc") = "Asc"
            Else
                IQHillsInClassificaton = _repository.GetHillsByClassification(id)
                ViewData("OrderBy") = "Name"
                ViewData("OrderAscDesc") = "Asc"
            End If

            Dim iNumClimbed = IQHillsInClassificaton.Where(Function(hill) hill.NumberOfAscents > 0).Count
            ViewData("NumberClimbed") = iNumClimbed

            '----Create a paginated list of hills----------------
            Dim IQPaginatedHills = New PaginatedListMVC(Of Hill)(IQHillsInClassificaton, page, System.Web.Configuration.WebConfigurationManager.AppSettings("PAGINATION_PAGE_SIZE"), Url.Action("HillsInClassification"), System.Web.Configuration.WebConfigurationManager.AppSettings("PAGINATION_MAX_PAGE_LINKS"), "?OrderBy=" + OrderBy)

            '-----Pass the paginated list of hills to the view. The view expects a paginated list as its model-----
            Return View(IQPaginatedHills)

        End Function


        '-------------------------------------------------------------------------------------
        ' Function: HillsByArea
        ' URL     : /Walks/HillsByArea/AreaReference
        ' Descr   : Return a list of hills in a given area
        '--------------------------------------------------------------------------------------

        Function HillsByArea(ByVal id As String, Optional ByVal page As Integer = 1) As ActionResult

            Dim IQHillsInWalkingArea = _repository.FindHillsByArea(id)
            Dim strAreaName As String = _repository.GetWalkAreaNameFromAreaRef(id)
            ViewData("AreaName") = strAreaName
            '----Create a paginated list of hills----------------
            Dim IQPaginatedHills = New PaginatedList(Of Hill)(IQHillsInWalkingArea, page, System.Web.Configuration.WebConfigurationManager.AppSettings("PAGINATION_PAGE_SIZE"))

            Return View(IQPaginatedHills)

        End Function

         '-------------------------------------------------------------------------------------
        ' Function: HillsAboveHeight
        ' URL     : /Walks/HillsByArea/AreaReference
        ' Descr   : Return a list of hills above a specified height (in feet)
        '--------------------------------------------------------------------------------------
        Function HillsAboveHeight(ByVal feet As Integer) As ActionResult

            Dim IQHillsAboveHeight = _repository.FindHillsAboveFeet(feet)

            Return View(IQHillsAboveHeight)

        End Function

        '-------------------------------------------------------------------------------------
        ' Function: HillsDetails
        ' URL     : /Walks/HillDetails
        ' Descr   : Return a list of hills above a specified height (in feet)
        '--------------------------------------------------------------------------------------
        Function HillDetails(ByVal id As Integer) As ActionResult

            Dim oHillDetails = _repository.GetHillDetails(id)

            Dim oHillAscents = _repository.GetHillAscents(id).OrderBy(Function(hill) hill.AscentDate)
            ViewData("HillAscents") = oHillAscents.AsEnumerable

            Return View(oHillDetails)

        End Function

        '-------------------------------------------------------------------------------------
        ' Function: Create  (POST)
        ' URL     : /Walks/Create
        ' Descr   : Create Walk form
        '--------------------------------------------------------------------------------------
        <AcceptVerbs(HttpVerbs.Post)>
        Function Create(ByVal walk As Walk) As ActionResult

            Dim strViewData As String = ""
            Dim strKeys = Request.Form.AllKeys
            Dim iWalkID As Integer = 0
            Dim iRetval As Integer = 0
            Dim arHillAscents As System.Collections.Generic.List(Of HillAscent)
            Dim arAssociatedFiles As System.Collections.Generic.List(Of Walk_AssociatedFile)

            '----This should really be done by a customised Model Binder-----------
            Dim oWalk As New Walk
            WalkingMVC.Helpers.WalkingStick.FillWalkFromFormVariables(oWalk, Request.Form)

            iWalkID = _repository.AddWalk(oWalk)

            '---Add hill ascents-----------------
            arHillAscents = WalkingMVC.Helpers.WalkingStick.FillHillAscentsFromFormVariables(iWalkID, Request.Form)
            iRetval = _repository.AddWalkSummitsVisited(arHillAscents)

            '---Add the associated files-----
            arAssociatedFiles = WalkingMVC.Helpers.WalkingStick.FillHillAssociatedFilesFromFormVariables(iWalkID, Request.Form, Server.MapPath("/"))
            iRetval = _repository.AddWalkAssociatedFiles(arAssociatedFiles)

            '---update any markers created by ajax call with walk id, and add any marker observations----------------
            iRetval = _repository.AssociateMarkersWithWalk(Request.Form, iWalkID)

            If walk.HillAscents.Count > 0 Then
                Return RedirectToAction("HillsByArea", New With {.id = oWalk.Area.Arearef.Trim, .page = 1})
            Else
                Return RedirectToAction("WalksByDate", New With {.OrderBy = "DateDesc"})
            End If

            '---For dev to display form details-------
            'For Each item In strKeys
            '    strViewData = strViewData + "Key:" + item.ToString + " Value:" + Request.Form(item.ToString) + "<Br/>"
            'Next

            'ViewData("allthekeys") = strViewData
            'Return View("DisplayFormDetails")

        End Function

        '-------------------------------------------------------------------------------------
        ' Function: Create
        ' URL     : /Walks/Create
        ' Descr   : Create Walk form
        '--------------------------------------------------------------------------------------
        Function Create() As ActionResult

            Dim oWalk As New Walk
            Dim oAssociated_File_Types = _repository.GetAssociatedFileTypes()
            Dim oWalkTypes = _repository.GetWalkTypes()

            ViewData("WalkTypes") = New SelectList(oWalkTypes, "WalkTypeString", "WalkTypeString")
            ViewData("Associated_File_Types") = New SelectList(oAssociated_File_Types, "Walk_AssociatedFile_Type", "Walk_AssociatedFile_Type")
            ViewData("Model") = oWalk

            Return View()

        End Function

  
        '------------------------------------------------------------------------------------------------
        ' HillSuggestions
        ' Used as the AJAX server side for an autocomplete function on a client side textbox
        '-----------------------
        Function HillSuggestions(ByVal q As String, Optional ByVal areaid As String = "") As ActionResult

            Dim oSB = New StringBuilder
            Dim IQHillsAboveHeight As System.Linq.IQueryable(Of Hill)
            If areaid = "" AndAlso areaid.Length < 2 Then
                IQHillsAboveHeight = _repository.FindsHillByNameLike(q)
            Else
                IQHillsAboveHeight = _repository.FindHillsInAreaByNameLike(q, areaid)
            End If

            For Each item As Hill In IQHillsAboveHeight
                oSB.AppendLine(WalkingMVC.Helpers.WalkingStick.FormatHillSummaryAsLine(item) + "|" + item.Hillnumber.ToString)
            Next

            ViewData("suggestions") = oSB.ToString

            Return PartialView()

        End Function

        '------------------------------------------------------------------------------------------------
        ' WalkAreaSuggestions
        ' Used as the AJAX server side for an autocomplete function on a client side textbox
        '-----------------------
        Function WalkAreaSuggestions(ByVal q As String, Optional ByVal options As String = "") As ActionResult

            Dim oSB = New StringBuilder
            Dim IQWalkAreas = _repository.FindWalkAreasByNameLike(q)
            For Each item As WalkingMVC.Area In IQWalkAreas
                oSB.AppendLine(WalkingMVC.Helpers.WalkingStick.FormatWalkAreaAsLine(item) + "|" + item.Arearef)
            Next

            ViewData("areanamesuggestions") = oSB.ToString

            Return PartialView()

        End Function


        '------------------------------------------------------------------------------------------------
        ' CheckImages
        ' Used as the AJAX server side to check that images are present in specified directory
        '-----------------------
        Function CheckImages(ByVal imagepath As String, Optional ByVal options As String = "") As JsonResult

            Dim strAtWork As String
            strAtWork = System.Web.Configuration.WebConfigurationManager.AppSettings("atwork")

            imagepath = imagepath.Replace("\", "/")
            Dim iLoc As Integer = 0

            Try
                iLoc = imagepath.LastIndexOf("/")
            Catch ex As Exception
                iLoc = 0
            End Try

            Dim strPath As String = ""

            Try
                strPath = imagepath.Substring(0, iLoc - 0)
            Catch ex As Exception

            End Try

            Dim iNumImagesFound As Integer = 0
            Dim strResults As String = ""
            Dim strRootPath As String = Server.MapPath("/").Replace("\", "/")

            '-----Check that the path specified is valid------------------------
            If Not WalkingMVC.Helpers.WalkingStick.DetermineIfDirectoryExists(strPath) Then
                ViewData("checkresults") = "{""Error"" | ""Directory Not Found.""}"
                Return Json(New With {.Error = "Directory Not Found."}, JsonRequestBehavior.AllowGet)
            End If

            '----Now check that images are found in this directory------------------
            Dim oResults = WalkingMVC.Helpers.WalkingStick.CheckFilesInDirectory(strPath, imagepath.Substring(iLoc + 1, (imagepath.Length - iLoc) - 1), strRootPath, strAtWork)
        
            'ViewData("checkresults") = strResults

            Return Json(oResults, JsonRequestBehavior.AllowGet)

        End Function

        '-----------------------------------------------------------------------------------------------------
        ' CheckFileInWebroot
        ' Server side of AJAX call, using JSON as data format, to check that specified file is in the webroot
        '-------------------------------------

        Function CheckFileInWebrootJSON(ByVal imagepath As String) As JsonResult

            Dim bIsInPath As Boolean = False
            If imagepath.StartsWith(Server.MapPath("/")) Then

                bIsInPath = True

            End If
            Dim oRes = New With {.isinpath = bIsInPath.ToString}


            '----Have to explicitly allow GET requests otherwise there is no callback------------------------
            Return Json(oRes, JsonRequestBehavior.AllowGet)

        End Function

        '-----------------------------------------------------------------------------------------------------
        ' CreateMarker
        ' Server side of AJAX call, using JSON as data format, to insert a new marker.
        '-------------------------------------

        Function CreateMarker(ByVal mtitle As String, ByVal mdesc As String, ByVal mdate As String, Optional ByVal mhillid As Integer = 0, Optional ByVal mgps As String = "", Optional ByVal mwalkid As Integer = 0) As JsonResult

            Dim bIsSuccess As Boolean = False
            Dim oNewMarker As New Marker

            oNewMarker.MarkerTitle = mtitle
            oNewMarker.Location_Description = mdesc
            Try
                oNewMarker.DateLeft = DateTime.Parse(mdate + " 00:00:00")
            Catch ex As Exception
                oNewMarker.DateLeft = Date.Now
            End Try
            oNewMarker.GPS_Reference = mgps
            If mhillid <> 0 Then
                oNewMarker.Hillnumber = mhillid
            End If

            If mwalkid <> 0 Then
                oNewMarker.WalkID = mwalkid
            End If

            oNewMarker.Status = "Left - Not yet found again"
            _repository.CreateMarker(oNewMarker)

            '----Have to explicitly allow GET requests otherwise there is no callback------------------------
            Return Json(New With {.markerid = oNewMarker.MarkerID}, JsonRequestBehavior.AllowGet)

        End Function

        '------------------------------------------------------------------------------------------------
        ' MarkerSuggestions
        ' Used as the AJAX server side for an autocomplete function on a client side textbox
        '-----------------------
        Function MarkerSuggestions(ByVal q As String, Optional ByVal imagenumber As String = "") As ActionResult

            Dim oSB = New StringBuilder
            Dim IQMarkers = _repository.FindMarkersByNameLike(q)
            For Each item As WalkingMVC.Marker In IQMarkers
                oSB.AppendLine(WalkingMVC.Helpers.WalkingStick.FormatMarkerAsLine(item) + "|" + item.MarkerID.ToString.Trim + "|" + imagenumber)
            Next

            ViewData("markernamesuggestions") = oSB.ToString

            Return PartialView()

        End Function

        '------------------------------------------------------------------------------------------------
        ' WalkSuggestions
        ' Used as the AJAX server side for an autocomplete function on a client side textbox
        '-----------------------
        Function WalkSuggestions(ByVal q As String) As ActionResult

            Dim oSB = New StringBuilder
            Dim IQWalks = _repository.FindWalksByTitleLike(q)
            For Each item As WalkingMVC.Walk In IQWalks
                oSB.AppendLine(WalkingMVC.Helpers.WalkingStick.FormatWalkAsLine(item) + "|" + item.WalkID.ToString.Trim)
            Next

            ViewData("walksuggestions") = oSB.ToString

            Return PartialView()

        End Function


        '------------------------------------------------------------------------------------------------
        ' Details
        ' /Walks/Details/id
        '-----------------------
        Function Details(ByVal id As Integer) As ActionResult

            Dim oWalk As Walk = _repository.GetWalkDetails(id)
            Dim strTotalTime = WalkingMVC.Helpers.WalkingStick.ConvertTotalTimeToString(oWalk.WalkTotalTime, False)

            ViewData("TotalTime") = strTotalTime
            ViewData("AT_WORK") = System.Web.Configuration.WebConfigurationManager.AppSettings("atwork")

            Return View(oWalk)

        End Function

        '-------------------------------------------------------------------------------------
        ' Function: Edit
        ' URL     : /Walks/Edit/Id
        ' Descr   : Edit Walk form
        '--------------------------------------------------------------------------------------

        <AcceptVerbs(HttpVerbs.Get)>
        Function Edit(ByVal id As Integer) As ActionResult

            Dim oWalk As Walk = _repository.GetWalkDetails(id)

            Dim oAssociated_File_Types = _repository.GetAssociatedFileTypes()
            Dim oAuxilliaryFiles = _repository.GetWalkAuxilliaryFiles(id)
            Dim oWalkTypes = _repository.GetWalkTypes()
            Dim oWalkMarkers = _repository.GetMarkersCreatedOnWalk(id)

            ViewData("WalkTypes") = New SelectList(oWalkTypes, "WalkTypeString", "WalkTypeString")
            ViewData("Associated_File_Types") = New SelectList(oAssociated_File_Types, "Walk_AssociatedFile_Type", "Walk_AssociatedFile_Type")
            ViewData("Model") = oWalk
            ViewData("Auxilliary_Files") = oAuxilliaryFiles.AsEnumerable
            ViewData("WalkMarkersAlreadyCreated") = oWalkMarkers
            ViewData("AT_WORK") = System.Web.Configuration.WebConfigurationManager.AppSettings("atwork")

            Return View(oWalk)

        End Function

        '-------------------------------------------------------------------------------------
        ' Function: Edit  (POST)
        ' URL     : /Walks/Edit/Id
        ' Descr   : 1. Get the existing id into a walk object
        '           2. Based on the form variables, update the walk object and submit chnages
        '--------------------------------------------------------------------------------------

        <AcceptVerbs(HttpVerbs.Post)>
        Function Edit(ByVal id As Integer, ByVal formValues As FormCollection) As ActionResult


            Dim strViewData As String = ""
            Dim strKeys = Request.Form.AllKeys
            Dim iWalkID As Integer = 0

            Dim oWalk As Walk
            oWalk = _repository.GetWalkDetails(id)
            _repository.UpdateWalkDetails(oWalk, Request.Form, Server.MapPath("/"))

            '---update any markers created by ajax call with walk id, and add any marker observations----------------
            'iRetval = _repository.AssociateMarkersWithWalk(Request.Form, iWalkID)


            If oWalk.HillAscents.Count > 0 Then
                Return RedirectToAction("HillsByArea", New With {.id = oWalk.Area.Arearef.Trim, .page = 1})
            Else
                Return RedirectToAction("WalksByDate", New With {.OrderBy = "DateDesc"})
            End If

            '---For dev to display form details-------
            'For Each item In strKeys
            '    strViewData = strViewData + "Key:" + item.ToString + " Value:" + Request.Form(item.ToString) + "<Br/>"
            'Next

            'ViewData("allthekeys") = strViewData
            'Return View("DisplayFormDetails")


        End Function


        '-------------------------------------------------------------------------------------
        ' Function: WalksByDate
        ' URL     : /Walks/WalksByDate/OrderBy/{page}
        ' Descr   : Return a list of walks by date, order as per the OrderBy parameter
        '--------------------------------------------------------------------------------------

        Function WalksByDate(ByVal OrderBy As String, Optional ByVal page As Integer = 1) As ActionResult

            Dim IQWalks As System.Linq.IOrderedQueryable(Of Walk)

            '---Use the walking repository to get a list of all the walks----
            '---Set up the ordering of the walks------
            If OrderBy = "DateAsc" Then
                IQWalks = _repository.FindAllWalks().OrderBy(Function(walk) walk.WalkDate)
                ViewData("OrderBy") = "Date"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "DateDesc" Then
                IQWalks = _repository.FindAllWalks().OrderByDescending(Function(walk) walk.WalkDate)
                ViewData("OrderBy") = "Date"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "TitleAsc" Then
                IQWalks = _repository.FindAllWalks().OrderBy(Function(walk) walk.WalkTitle)
                ViewData("OrderBy") = "Title"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "TitleDesc" Then
                IQWalks = _repository.FindAllWalks().OrderByDescending(Function(walk) walk.WalkTitle)
                ViewData("OrderBy") = "Title"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "AreaAsc" Then
                IQWalks = _repository.FindAllWalks().OrderBy(Function(walk) walk.WalkAreaName)
                ViewData("OrderBy") = "Area"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "AreaDesc" Then
                IQWalks = _repository.FindAllWalks().OrderByDescending(Function(walk) walk.WalkAreaName)
                ViewData("OrderBy") = "Area"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "LengthAsc" Then
                IQWalks = _repository.FindAllWalks().OrderBy(Function(walk) walk.CartographicLength)
                ViewData("OrderBy") = "Length"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "LengthDesc" Then
                IQWalks = _repository.FindAllWalks().OrderByDescending(Function(walk) walk.CartographicLength)
                ViewData("OrderBy") = "Length"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "AscentAsc" Then
                IQWalks = _repository.FindAllWalks().OrderBy(Function(walk) walk.MetresOfAscent)
                ViewData("OrderBy") = "Ascent"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "AscentDesc" Then
                IQWalks = _repository.FindAllWalks().OrderByDescending(Function(walk) walk.MetresOfAscent)
                ViewData("OrderBy") = "Ascent"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "TotalTimeAsc" Then
                IQWalks = _repository.FindAllWalks().OrderBy(Function(walk) walk.WalkTotalTime)
                ViewData("OrderBy") = "TotalTime"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "TotalTimeDesc" Then
                IQWalks = _repository.FindAllWalks().OrderByDescending(Function(walk) walk.WalkTotalTime)
                ViewData("OrderBy") = "TotalTime"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "MovAvgAsc" Then
                IQWalks = _repository.FindAllWalks().OrderBy(Function(walk) walk.MovingAverageKmh)
                ViewData("OrderBy") = "MovAvg"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "MovAvgDesc" Then
                IQWalks = _repository.FindAllWalks().OrderByDescending(Function(walk) walk.MovingAverageKmh)
                ViewData("OrderBy") = "MovAvg"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "OvlAvgAsc" Then
                IQWalks = _repository.FindAllWalks().OrderBy(Function(walk) walk.WalkAverageSpeedKmh)
                ViewData("OrderBy") = "OvlAvg"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "OvlAvgDesc" Then
                IQWalks = _repository.FindAllWalks().OrderByDescending(Function(walk) walk.WalkAverageSpeedKmh)
                ViewData("OrderBy") = "OvlAvg"
                ViewData("OrderAscDesc") = "Desc"
            Else
                IQWalks = _repository.FindAllWalks().OrderBy(Function(walk) walk.WalkDate)
                ViewData("OrderBy") = "Date"
                ViewData("OrderAscDesc") = "Desc"
            End If

            '----Create a paginated list of the walks----------------
            Dim IQPaginatedWalks = New PaginatedListMVC(Of Walk)(IQWalks, page, System.Web.Configuration.WebConfigurationManager.AppSettings("PAGINATION_PAGE_SIZE"), Url.Action("WalksByDate", "Walks", New With {.OrderBy = ViewData("OrderBy") + ViewData("OrderAscDesc")}), System.Web.Configuration.WebConfigurationManager.AppSettings("PAGINATION_MAX_PAGE_LINKS"), "")

            '-----Pass the paginated list of walks to the view. The view expects a paginated list as its model-----
            Return View(IQPaginatedWalks)

        End Function

    End Class

 
End Namespace