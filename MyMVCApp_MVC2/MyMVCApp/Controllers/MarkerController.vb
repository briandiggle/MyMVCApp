Namespace WalkingMVC
    Public Class MarkerController
        Inherits System.Web.Mvc.Controller

        Private Const MARKERS_PAGE_SIZE = 50
        Private Const MAX_PAGINATION_LINKS = 10

        '====Define the repository as the interface. Seperated from the constructor to aid inversion of control=======
        Dim _repository As IWalkingRepository

        '=====Constructor for the repository object==============================
        Public Sub New()
            _repository = New SqlWalkingRepository

        End Sub

        '
        ' GET: /Marker

        Function Index(ByVal OrderBy As String, Optional ByVal page As Integer = 1) As ActionResult

            Dim IQMarkers As IQueryable(Of Marker)

            '---Use the walking repository to get a list of all the markers----
            '---Set up the ordering of the markers------

            '-----Date Ordering-----------
            If OrderBy = "DateAsc" Then
                IQMarkers = _repository.FindAllMarkers().OrderBy(Function(marker) marker.DateLeft).ThenBy(Function(marker) marker.MarkerTitle)
                ViewData("OrderBy") = "Date"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "DateDesc" Then
                IQMarkers = _repository.FindAllMarkers().OrderByDescending(Function(marker) marker.DateLeft).ThenByDescending(Function(marker) marker.MarkerTitle)
                ViewData("OrderBy") = "Date"
                ViewData("OrderAscDesc") = "Desc"

                '-----Title Ordering--------------

            ElseIf OrderBy = "TitleAsc" Then
                IQMarkers = _repository.FindAllMarkers().OrderBy(Function(marker) marker.MarkerTitle).ThenBy(Function(marker) marker.DateLeft)
                ViewData("OrderBy") = "Title"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "TitleDesc" Then
                IQMarkers = _repository.FindAllMarkers().OrderByDescending(Function(marker) marker.MarkerTitle).ThenByDescending(Function(marker) marker.DateLeft)
                ViewData("OrderBy") = "Title"
                ViewData("OrderAscDesc") = "Desc"

                '-----Status Ordering-----------
            ElseIf OrderBy = "StatusAsc" Then
                IQMarkers = _repository.FindAllMarkers().OrderBy(Function(marker) marker.Status).ThenBy(Function(marker) marker.DateLeft)
                ViewData("OrderBy") = "Status"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "StatusDesc" Then
                IQMarkers = _repository.FindAllMarkers().OrderByDescending(Function(marker) marker.Status).ThenByDescending(Function(marker) marker.DateLeft)
                ViewData("OrderBy") = "Status"
                ViewData("OrderAscDesc") = "Desc"

                '-----Walk Title Ordering-------------
            ElseIf OrderBy = "WalkAsc" Then
                IQMarkers = _repository.FindAllMarkers().OrderBy(Function(marker) marker.Walk.WalkTitle).ThenBy(Function(marker) marker.DateLeft)
                ViewData("OrderBy") = "Walk"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "WalkDesc" Then
                IQMarkers = _repository.FindAllMarkers().OrderByDescending(Function(marker) marker.Walk.WalkTitle).ThenByDescending(Function(marker) marker.DateLeft)
                ViewData("OrderBy") = "Walk"
                ViewData("OrderAscDesc") = "Desc"
            Else
                '----Default to order by date ascending----
                ViewData("OrderBy") = "Date"
                ViewData("OrderAscDesc") = "Desc"
                IQMarkers = _repository.FindAllMarkers().OrderByDescending(Function(marker) marker.DateLeft).ThenByDescending(Function(marker) marker.MarkerTitle)

            End If

            '----Create a paginated list of the walks----------------
            Dim IQPaginatedMarkers = New PaginatedListMVC(Of Marker)(IQMarkers, page, MARKERS_PAGE_SIZE, Url.Action("Index", "Marker", New With {.OrderBy = ViewData("OrderBy") + ViewData("OrderAscDesc")}), MAX_PAGINATION_LINKS, "")

            Return View(IQPaginatedMarkers)

        End Function

        '
        ' GET: /Marker/Details/5

        Function Details(ByVal id As Integer) As ActionResult
            ViewData("AT_WORK") = System.Web.Configuration.WebConfigurationManager.AppSettings("atwork")

            Dim oMarker = _repository.GetMarkerDetails(id)
            Return View(oMarker)
        End Function

        '
        ' GET: /Marker/Create

        Function Create() As ActionResult
            Return View()
        End Function

        '
        ' POST: /Marker/Create

        <HttpPost> _
        Function Create(ByVal collection As FormCollection) As ActionResult
            Try
                ' TODO: Create Marker: Add insert logic here
                Return RedirectToAction("Index")
            Catch
                Return View()
            End Try
        End Function
        
        '
        ' GET: /Marker/Edit/5

        Function Edit(ByVal id As Integer) As ActionResult

            Dim oMarker As Marker
            oMarker = _repository.GetMarkerDetails(id)

            Dim oMarker_Statii = _repository.GetAllMarkerStatusOptions()
            '----It seems if you have a strongly typed view you need to change the ID of the dropdown so that it is NOT the name of a property on the inherrited class. So I'll DIY it------
            ' ViewData("Marker_Statii") = New SelectList(oMarker_Statii, "Marker_Status", "Marker_Status", oMarker.Status)

            ViewData("Marker_Status") = oMarker_Statii

            Return View(oMarker)
        End Function

        '
        ' POST: /Marker/Edit/5

        <HttpPost> _
        Function Edit(ByVal id As Integer, ByVal collection As FormCollection) As ActionResult
            Try

                Dim oMarker As Marker
                oMarker = _repository.GetMarkerDetails(id)
                _repository.UpdateMarkerDetails(oMarker, Request.Form)

                Return RedirectToAction("Index")
            Catch ex As Exception
                Return View()
            End Try
        End Function

   
    End Class
End Namespace