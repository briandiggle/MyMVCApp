'================================================================================================
'
' Class: Paginated List
'
' This class derives from the List<T> class in System.Collections.Generic and adds pagination 
' functionality to the List
'
' Constructor: New(source list, page index to return to include from source list, page size)
'
' Author: Brian Diggle, 12 April 2010
'
'=================================================================

Imports System.Collections.Generic


Public Class PaginatedList(Of T)
    Inherits List(Of T)

    '----Private variables for use with the public properties---------
    Private _PageIndex As Integer
    Private _PageSize As Integer
    Private _TotalCount As Integer
    Private _TotalPages As Integer

    '-----Page index of the source list---------
    Public ReadOnly Property PageIndex()
        Get
            Return _PageIndex
        End Get
    End Property

    Public ReadOnly Property PageSize()
        Get
            Return _PageSize
        End Get
    End Property

    Public ReadOnly Property TotalCount()
        Get
            Return _TotalCount
        End Get
    End Property

    Public ReadOnly Property TotalPages()
        Get
            Return _TotalPages
        End Get
    End Property

    '----Constructor-------------------------------

    Public Sub New()


    End Sub


    Public Sub New(ByVal source As IQueryable(Of T), ByVal iPageIndex As Integer, ByVal iPageSize As Integer)

        '-----Set the private variables which as exposed publically as properties-----------
        _PageIndex = iPageIndex
        _PageSize = iPageSize
        _TotalCount = source.Count
        _TotalPages = Math.Ceiling(_TotalCount / iPageSize)

        If _PageIndex <= 0 Then
            _PageIndex = 1
        End If

        '----Take the specified page of results from the source list and add it to me------------
        Me.AddRange(source.Skip((_PageIndex - 1) * _PageSize).Take(_PageSize))

    End Sub

    Public ReadOnly Property HasPreviousPage() As Boolean
        Get
            Return (_PageIndex > 1)
        End Get
    End Property

    Public ReadOnly Property HasNextPage() As Boolean
        Get
            Return (_PageIndex < _TotalPages)
        End Get
    End Property

End Class
