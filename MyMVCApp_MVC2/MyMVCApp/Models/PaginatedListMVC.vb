'================================================================================================
'
' Class: PaginatedListMVC
'
' This class derives from the PaginatedList<T> class in and adds pagination links
' functionality to the base class
'
' Constructor: New(source list, page index to return to include from source list, page size, request context)
'
' Author: Brian Diggle, 14 April 2010
'
'=================================================================

Imports System.Web.Mvc

Public Class PaginatedListMVC(Of T)
    Inherits PaginatedList(Of T)

    '----Will hold the html for the page navigation links------
    Private _PageNavigationLinks As String

    Private _RecordsShowing As String

    '----Holds the maximum number of pagination links to display----
    Private _MaxPaginationLinks As Integer

    '----Public Property which will hold the html for the page navigation links-----
    Public ReadOnly Property PageNavigationLinks()
        Get
            Return _PageNavigationLinks
        End Get
    End Property

    Public Property MaxPaginationLinks()
        Get
            Return _MaxPaginationLinks
        End Get
        Set(ByVal value)
            _MaxPaginationLinks = value
        End Set
    End Property

    Public Property RecordsShowing()
        Get
            Return _RecordsShowing
        End Get
        Set(ByVal value)
            _RecordsShowing = value
        End Set

    End Property

    '------------------------------------------------------------------------
    '
    ' New - Constructor
    '
    '--------------------------

    Sub New(ByVal source As IQueryable(Of T), ByVal iPageIndex As Integer, ByVal iPageSize As Integer, ByVal urlbase As String, ByVal iMaxPageLinks As Integer, ByVal strOrderBy As String)

        '---Call the base class constructor to initialise a few values supplied as parameters-----------
        MyBase.New(source, iPageIndex, iPageSize)

        _MaxPaginationLinks = iMaxPageLinks
        _PageNavigationLinks = GeneratePaginationLinks(urlbase, strOrderBy)
        _RecordsShowing = GenerateRecordsShowing(iPageIndex, iPageSize)

    End Sub


    '--------------------------------------------------------------------------------------------------------
    ' Function:     GenerateRecordsShowing
    ' Decription:   Returns string with "showing x-y of z"
    '---------------------------------------------------------------

    Private Function GenerateRecordsShowing(ByVal iPageIndex As Integer, ByVal iPageSize As Integer) As String

        Dim strRecsShowing As String = ""

        Dim iFrom As Integer
        Dim iTo As Integer

        iFrom = ((iPageIndex - 1) * PageSize) + 1
        iTo = iFrom + PageSize - 1

        If iTo > TotalCount Then
            iTo = TotalCount
        End If

        Try
            strRecsShowing = strRecsShowing + CStr(iFrom) + " - " + CStr(iTo) + " of " + CStr(TotalCount)
        Catch ex As Exception

        End Try

        Return strRecsShowing

    End Function


    '------------------------------------------------------------------------------------------
    ' Function:     GeneratePaginationLinks
    ' Description:  Generate html for pagination links
    '---------------------------------------------

    Private Function GeneratePaginationLinks(ByVal myUrlBase As String, ByVal strOrderBy As String)

        Dim strNavlinks As String = ""
        Dim iStartLinkPage As Integer
        Dim iEndLinkPage As Integer
        Dim strPageLink As String

        If myUrlBase.Contains("?") Then
            strPageLink = "&page="
        Else
            strPageLink = "/"
        End If


        If PageIndex >= MaxPaginationLinks Then
            iStartLinkPage = (PageIndex - MaxPaginationLinks) + 1
            If iStartLinkPage < 1 Then
                iStartLinkPage = 1
            End If
        Else
            iStartLinkPage = 1
        End If

        If (iStartLinkPage + MaxPaginationLinks) > (TotalPages) Then
            iEndLinkPage = TotalPages
        Else
            iEndLinkPage = iStartLinkPage + (MaxPaginationLinks - 1)
        End If

        '----If the calculated start page for the numbered links is greater than 1, display a "first" link----------------

        If iStartLinkPage > 1 Then
            strNavlinks = strNavlinks + "<a href=""" + myUrlBase + strPageLink + "1" + strOrderBy + """>First</a> "
        End If

        If HasPreviousPage Then
            strNavlinks = strNavlinks + "<a href=""" + myUrlBase + strPageLink + (PageIndex - 1).ToString + strOrderBy + """>Previous</a> "
        End If

        For iPageCount As Integer = iStartLinkPage To iEndLinkPage
            If iPageCount = PageIndex Then
                strNavlinks = strNavlinks + "<b>" + iPageCount.ToString + "</b> "
            Else
                strNavlinks = strNavlinks + "<a href=""" + myUrlBase + strPageLink + iPageCount.ToString + strOrderBy + """>" + iPageCount.ToString + "</a> "
            End If
        Next

        If HasNextPage Then
            strNavlinks = strNavlinks + "<a href=""" + myUrlBase + strPageLink + (PageIndex + 1).ToString + strOrderBy + """>Next</a> "
        End If

        '----If the calculated end page for the numbered links is less than the total number of pages, then display a "Last" link----
        If iEndLinkPage < TotalPages Then
            strNavlinks = strNavlinks + " <a href=""" + myUrlBase + strPageLink + TotalPages.ToString + strOrderBy + """>Last</a>"
        End If

        Return strNavlinks

    End Function

End Class
