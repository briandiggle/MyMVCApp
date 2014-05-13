Namespace WalkingMVC
    Public Class HillAscentController
        Inherits System.Web.Mvc.Controller
        '====Define the repository as the interface. Seperated from the constructor to aid inversion of control=======
        Dim _repository As IWalkingRepository
        Private Const HILLASCENTS_PAGE_SIZE = 50
        Private Const MAX_PAGINATION_LINKS = 10


        '=====Constructor for the repository object==============================
        Public Sub New()
            _repository = New SqlWalkingRepository

        End Sub


        ' GET: /HillAscent

        Function Index(ByVal OrderBy As String, Optional ByVal page As Integer = 1) As ActionResult

            Dim IQHillAscents As IQueryable(Of HillAscent)

            '---Use the walking repository to get a list of all the hill ascents----
            '---Set up the ordering of the hill ascents------
            If OrderBy = "DateAsc" Then
                IQHillAscents = _repository.GetAllHillAscents().OrderBy(Function(ascent) ascent.AscentDate).ThenBy(Function(ascent) ascent.AscentID)
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "DateDesc" Then
                IQHillAscents = _repository.GetAllHillAscents().OrderByDescending(Function(ascent) ascent.AscentDate).ThenByDescending(Function(ascent) ascent.AscentID)
                ViewData("OrderBy") = "Date"
                ViewData("OrderBy") = "Date"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "HillAsc" Then
                IQHillAscents = _repository.GetAllHillAscents().OrderBy(Function(ascent) ascent.Hill.Hillname)
                ViewData("OrderBy") = "Hill"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "HillDesc" Then
                IQHillAscents = _repository.GetAllHillAscents().OrderByDescending(Function(ascent) ascent.Hill.Hillname)
                ViewData("OrderBy") = "Hill"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "MetresAsc" Then
                IQHillAscents = _repository.GetAllHillAscents().OrderBy(Function(ascent) ascent.Hill.Metres)
                ViewData("OrderBy") = "Metres"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "MetresDesc" Then
                IQHillAscents = _repository.GetAllHillAscents().OrderByDescending(Function(ascent) ascent.Hill.Metres)
                ViewData("OrderBy") = "Metres"
                ViewData("OrderAscDesc") = "Desc"
            ElseIf OrderBy = "WalkAsc" Then
                IQHillAscents = _repository.GetAllHillAscents().OrderBy(Function(ascent) ascent.Walk.WalkTitle)
                ViewData("OrderBy") = "Walk"
                ViewData("OrderAscDesc") = "Asc"
            ElseIf OrderBy = "WalkDesc" Then
                IQHillAscents = _repository.GetAllHillAscents().OrderByDescending(Function(ascent) ascent.Walk.WalkTitle)
                ViewData("OrderBy") = "Walk"
                ViewData("OrderAscDesc") = "Desc"
            Else
                '----Default to order by date ascending----
                ViewData("OrderBy") = "Date"
                ViewData("OrderAscDesc") = "Asc"
                IQHillAscents = _repository.GetAllHillAscents().OrderBy(Function(ascent) ascent.AscentDate).ThenBy(Function(ascent) ascent.AscentID)

            End If

            '----Create a paginated list of the walks----------------
            Dim IQPaginatedAscents = New PaginatedListMVC(Of HillAscent)(IQHillAscents, page, HILLASCENTS_PAGE_SIZE, Url.Action("Index", "HillAscent", New With {.OrderBy = ViewData("OrderBy") + ViewData("OrderAscDesc")}), MAX_PAGINATION_LINKS, "")

            Return View(IQPaginatedAscents)
        End Function

    End Class
End Namespace