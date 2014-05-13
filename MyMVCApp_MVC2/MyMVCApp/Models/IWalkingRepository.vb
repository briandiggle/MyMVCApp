'======================================================================================
'
' Name: IWalkingRepository
'
' Type: Interface
'
' Desc: Define the methods which must be implemented by a walking repository
'
' Author: Brian Diggle
'
'=======================================================================================
Imports System
Imports System.Linq

Namespace WalkingMVC

    Public Interface IWalkingRepository

        '-----walk related methods-----------

        Function AddWalk(ByVal walk As Walk) As Integer
        Function AddWalkSummitsVisited(ByVal summits As System.Collections.Generic.List(Of HillAscent)) As Integer
        Function AddWalkAssociatedFiles(ByVal assocfiles As System.Collections.Generic.List(Of Walk_AssociatedFile)) As Integer
        Function GetWalkAssociatedFiles(ByVal walkid As Integer) As System.Collections.Generic.List(Of Walk_AssociatedFile)
        Function GetWalkAuxilliaryFiles(ByVal walkid As Integer) As IQueryable(Of Walk_AssociatedFile)

        Function FindAllWalks() As IQueryable(Of Walk)
        Function FindWalksByArea(ByVal strAreaName As String) As IQueryable(Of Walk)

        Function GetWalkDetails(ByVal id As Integer) As Walk

        Sub UpdateWalkDetails(ByVal walk As Walk, ByVal oForm As System.Collections.Specialized.NameValueCollection, ByVal strRootPath As String)
        Sub DeleteWalk(ByVal walk As Walk)

        Function SearchForWalks(ByVal searchTerms As String) As IQueryable(Of Walk)

        '-----Hill related methods-------------

        Function FindAllHills() As IQueryable(Of Hill)
        Function FindHillsByArea(ByVal strAreaRef As String) As IQueryable(Of Hill)
        Function GetHillDetails(ByVal id As Integer) As Hill
        Function FindHillsAboveFeet(ByVal iFeet As Integer) As IQueryable(Of Hill)
        Function GetHillsByClassification(ByVal strHillClass As String) As IQueryable(Of Hill)
        Function FindsHillByNameLike(ByVal strHillNamePortion As String) As IQueryable(Of Hill)
        Function FindHillsInAreaByNameLike(ByVal strHillNamePortion As String, ByVal strAreaRef As String) As IQueryable(Of Hill)

        Sub UpdateHillDetails(ByVal walk As Walk)
        Sub DeleteHill(ByVal walk As Walk)

        Function GetHillAscents(ByVal iHillID As Integer) As IQueryable(Of HillAscent)
        Function GetNumberOfHillAscentsByHillID(ByVal iHillID As Integer) As Integer
        Function DeleteHillAscentsForWalk(ByVal iWalkID As Integer) As Integer
        Function DeleteAssociateFilesForWalk(ByVal iWalkID As Integer) As Integer
        Function GetAllHillAscents() As IQueryable(Of HillAscent)

        '------Hill Classifications------------------------
        Function GetAllHillClassifications() As IQueryable(Of [Class])
        Function GetHillClassificationName(ByVal strClassificationCode As String) As String

        '-----Marker related methods------------------

        Function FindAllMarkers() As IQueryable(Of Marker)
        Function GetMarkerDetails(ByVal id As Integer) As Marker
        Function FindMarkersByNameLike(ByVal strNamePortion As String) As IQueryable(Of Marker)

        Function UpdateMarkerDetails(ByVal marker As Marker, ByVal oForm As System.Collections.Specialized.NameValueCollection) As Integer
        Sub DeleteMarker(ByVal marker As Marker)
        Function CreateMarker(ByVal marker As Marker) As Integer
        Function AssociateMarkersWithWalk(ByVal oForm As System.Collections.Specialized.NameValueCollection, ByVal iWalkID As Integer) As Integer
        Function GetMarkersCreatedOnWalk(ByVal iWalkID As Integer) As List(Of Marker)
        Function FindMarkerObservationLike(ByVal oMarkerObs As Marker_Observation) As Boolean
        Function GetAllMarkerStatusOptions() As IQueryable(Of Marker_Status)

        '------Walking Areas-----------------------------------
        Function GetAllWalkingAreas() As IQueryable(Of Area)
        Function GetAllWalkingAreas(ByVal strCountryCode As String) As IQueryable(Of Area)
        Function GetAllWalkingAreas(ByVal strCountryCode As String, ByVal strAreaType As String) As IQueryable(Of Area)
        Function FindWalkAreasByNameLike(ByVal strNamePortion As String) As IQueryable(Of Area)
        Function FindWalksByTitleLike(ByVal strTitlePortion As String) As IQueryable(Of Walk)
        Function GetWalkAreaNameFromAreaRef(ByVal strAreaRef As String) As String
        Function GetWalkAreaTypeNameFromType(ByVal strAreaType) As String

        '------Walk Types------------------------------------
        Function GetWalkTypes() As IQueryable(Of WalkType)

        '------Associated File types--------------------------
        Function GetAssociatedFileTypes() As IQueryable(Of Walk_AssociatedFile_Type)

        '----Progress---------------------------------
        Function GetMyProgress() As List(Of MyProgress)
        Function GetMyProgressByClassType(ByVal cClassType As Char) As List(Of MyProgress)


    End Interface
End Namespace


