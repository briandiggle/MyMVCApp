'======================================================================================
'
' Name: SqlWalkingRepository
'
' Type: Walking repository implementing IWalkingRepository interface
'
' Desc: Implementation of Data access layer for walking application
'
' Author: Brian Diggle
'
'=======================================================================================

Namespace WalkingMVC

    Public Class SqlWalkingRepository
        Implements IWalkingRepository

        Dim myWalkingDB As WalkingDB

        '----Declare our constructor - 

        Public Sub New()
            myWalkingDB = New WalkingDB
           
        End Sub

        Public Function AddWalk(ByVal walk As Walk) As Integer Implements IWalkingRepository.AddWalk
            myWalkingDB.Log = Console.Out
            myWalkingDB.Walks.InsertOnSubmit(walk)
            myWalkingDB.SubmitChanges()
            Return walk.WalkID

        End Function

        '--------------------------------------------------------------------------------------------------
        ' Function: SearchForWalks
        '           Search for walks based upon keywords
        '
        ' NOTE: This only works for one keyword at present, and there is no whitelisting.
        '--------------------------------------------------------------
        Public Function SearchForWalks(ByVal searchTerms As String) As IQueryable(Of Walk) Implements IWalkingRepository.SearchForWalks

            If Not WalkingMVC.Helpers.WalkingStick.WhiteListFormInput(searchTerms) Then
                Return Nothing
            End If

            Dim results = From walk In myWalkingDB.Walks
                          Where walk.WalkDescription.Contains(searchTerms)
                          Select walk

            'results = myWalkingDB.Walks.Where(WalkSearchKeywords)

            Return results

        End Function

        '----------------------------------------------------------------------------------------------
        ' Function AddWalkSummitsVisited
        ' Add visited summits to a walk
        '----------------------------------------------------
        Function AddWalkSummitsVisited(ByVal summits As System.Collections.Generic.List(Of HillAscent)) As Integer Implements IWalkingRepository.AddWalkSummitsVisited

            Dim iResult As Integer = 0

            myWalkingDB.HillAscents.InsertAllOnSubmit(summits.AsEnumerable)

            For Each oHillAscent As HillAscent In summits
                Dim iHillNumber As Integer = oHillAscent.Hillnumber
                Dim oHill As Hill
                oHill = myWalkingDB.Hills.SingleOrDefault(Function(h) h.Hillnumber = iHillNumber)

                If oHill.NumberOfAscents = 0 Then
                    oHill.FirstClimbedDate = oHillAscent.AscentDate
                Else
                    '---Its not the first time an ascent has been logged for this hill, but the ascent may still be the first---
                    If oHill.FirstClimbedDate > oHillAscent.AscentDate Then
                        oHill.FirstClimbedDate = oHillAscent.AscentDate
                    End If
                End If

                Dim iNumAscents = Me.GetNumberOfHillAscentsByHillID(iHillNumber)
                'TODO Change this so that the number of ascents is calculated from the number of ascents in hillascents-----
                oHill.NumberOfAscents = iNumAscents + 1

            Next

            myWalkingDB.SubmitChanges()

            Return iResult

        End Function

        Function GetHillAscents(ByVal iHillID As Integer) As IQueryable(Of HillAscent) Implements IWalkingRepository.GetHillAscents

            Dim oAscents = From ascent In myWalkingDB.HillAscents Where ascent.Hillnumber = iHillID Select ascent

            Return oAscents

        End Function

        Function GetNumberOfHillAscentsByHillID(ByVal iHillID As Integer) As Integer Implements IWalkingRepository.GetNumberOfHillAscentsByHillID

            Dim oAscents = From ascent In myWalkingDB.HillAscents Where ascent.Hillnumber = iHillID Select ascent

            Return oAscents.Count


        End Function
        Function GetWalkAssociatedFiles(ByVal walkid As Integer) As System.Collections.Generic.List(Of Walk_AssociatedFile) Implements IWalkingRepository.GetWalkAssociatedFiles

            Dim oWalkAssociatedFiles = From associatedfile In myWalkingDB.Walk_AssociatedFiles Where associatedfile.WalkID = walkid Select associatedfile

            Return oWalkAssociatedFiles

        End Function

        Function GetWalkAuxilliaryFiles(ByVal walkid As Integer) As IQueryable(Of Walk_AssociatedFile) Implements IWalkingRepository.GetWalkAuxilliaryFiles

            Dim oWalkAssociatedFiles = From associatedfile In myWalkingDB.Walk_AssociatedFiles
                                       Where associatedfile.WalkID = walkid And associatedfile.Walk_AssociatedFile_Type IsNot "Image"
                                       Select associatedfile

            Return oWalkAssociatedFiles
        End Function


        '----------------------------------------------------------------------------------------------
        ' Function AddWalkAssociatedFiles
        ' Add assoicated files to a walk
        '----------------------------------------------------
        Function AddWalkAssociatedFiles(ByVal collAssociatedFiles As System.Collections.Generic.List(Of Walk_AssociatedFile)) As Integer Implements IWalkingRepository.AddWalkAssociatedFiles

            Dim iResult As Integer = 0

            myWalkingDB.Walk_AssociatedFiles.InsertAllOnSubmit(collAssociatedFiles.AsEnumerable)

            myWalkingDB.SubmitChanges()

            Return iResult

        End Function


        Public Sub DeleteHill(ByVal walk As Walk) Implements IWalkingRepository.DeleteHill

        End Sub

        Function DeleteHillAscentsForWalk(ByVal iWalkID As Integer) As Integer Implements IWalkingRepository.DeleteHillAscentsForWalk

            Dim iRetval As Integer = 0
            Dim existingHillAscents As System.Collections.Generic.IEnumerable(Of HillAscent)

            existingHillAscents = From HillAscent In myWalkingDB.HillAscents
                                 Where HillAscent.WalkID = iWalkID
                                 Select HillAscent


            myWalkingDB.HillAscents.DeleteAllOnSubmit(existingHillAscents.AsEnumerable)

            myWalkingDB.SubmitChanges()

            Return iRetval

        End Function


        Function DeleteAssociateFilesForWalk(ByVal iWalkID As Integer) As Integer Implements IWalkingRepository.DeleteAssociateFilesForWalk

            Dim iRetval As Integer = 0
            Dim existingAssociatedFiles As System.Collections.Generic.IEnumerable(Of Walk_AssociatedFile)

            existingAssociatedFiles = From AssociatedFile In myWalkingDB.Walk_AssociatedFiles
                                 Where AssociatedFile.WalkID = iWalkID
                                 Select AssociatedFile

            myWalkingDB.Walk_AssociatedFiles.DeleteAllOnSubmit(existingAssociatedFiles.AsEnumerable)

            myWalkingDB.SubmitChanges()

            Return iRetval




        End Function


        Public Sub DeleteMarker(ByVal marker As Marker) Implements IWalkingRepository.DeleteMarker

        End Sub

        Public Sub DeleteWalk(ByVal walk As Walk) Implements IWalkingRepository.DeleteWalk

        End Sub

        Public Function FindHillsByArea(ByVal strAreaReference As String) As System.Linq.IQueryable(Of Hill) Implements IWalkingRepository.FindHillsByArea
            '---A little awkward due to the arealink table--------

            '----Does this get all hills above 2500 feet? Note h. includes associated information link arealink - how to use?
            '----Example of using a linq language integrated query rather than a lambda expression to get the records

            Dim hills = From hillarealink In myWalkingDB.Arealinks _
                       Where hillarealink.Arearef = strAreaReference _
                        Join hill In myWalkingDB.Hills On hillarealink.Hillnumber Equals hill.Hillnumber _
                        Order By hill.Hillname _
                        Select hill

            Return hills

        End Function


        Public Function FindHillsAboveFeet(ByVal iFeet As Integer) As System.Linq.IQueryable(Of Hill) Implements IWalkingRepository.FindHillsAboveFeet
            '---A little awkward due to the arealink table--------

            '----Does this get all hills above 2500 feet? Note h. includes associated information link arealink - how to use?
            '----Example of using a linq language integrated query rather than a lambda expression to get the records

            Dim q = From h In myWalkingDB.Hills Where h.Feet > iFeet Select h

            Return q

        End Function
        '------------------------------------------------------------------------------------------------------------
        '
        ' Function: FindWalksByArea
        '
        ' Returns a list of walks selected by walking area. IQueryable enables further downstream processing
        '
        '-------------------------------------------------------------

        Public Function FindWalksByArea(ByVal strAreaName As String) As System.Linq.IQueryable(Of Walk) Implements IWalkingRepository.FindWalksByArea

            Return myWalkingDB.Walks.Where(Function(w) w.WalkAreaName = strAreaName)

        End Function

        Public Function FindAllHills() As System.Linq.IQueryable(Of Hill) Implements IWalkingRepository.FindAllHills
            Return myWalkingDB.Hills
        End Function


        '------------------------------------------------------------------------------------------------------------
        ' Function: GetAllWalkingAreas
        ' Returns a list of walks selected by walking area. IQueryable enables further downstream processing
        '-------------------------------------------------------------

        Public Function GetAllWalkingAreas() As System.Linq.IQueryable(Of Area) Implements IWalkingRepository.GetAllWalkingAreas
            Return myWalkingDB.Areas
        End Function

        '------------------------------------------------------------------------------------------------------------
        ' Function: GetAllWalkingArea(strCoutry)
        ' Overloaded method for getting all walking areas with specified country code. Returns a listing of all walking areas
        '-----------------------------------------------------------

        Public Function GetAllWalkingAreas(ByVal strCountryCode As String) As System.Linq.IQueryable(Of Area) Implements IWalkingRepository.GetAllWalkingAreas

            Return myWalkingDB.Areas.Where(Function(area) area.Country = strCountryCode).OrderBy(Function(area) area.Shortname)

        End Function

        Function GetWalkAreaTypeNameFromType(ByVal strAreaType) As String Implements IWalkingRepository.GetWalkAreaTypeNameFromType

            Dim oAreaType As AreaType

            oAreaType = myWalkingDB.AreaTypes.SingleOrDefault(Function(at) at.AreaType.Equals(strAreaType))
            Return oAreaType.AreaTypeName

        End Function

        '------------------------------------------------------------------------------------------------------------
        ' Function: GetAllWalkingArea(strCoutry)
        ' Overloaded method for getting all walking areas with specified country code and area type. Returns a listing of all walking areas
        '-----------------------------------------------------------

        Public Function GetAllWalkingAreas(ByVal strCountryCode As String, ByVal strAreaType As String) As System.Linq.IQueryable(Of Area) Implements IWalkingRepository.GetAllWalkingAreas

            Return myWalkingDB.Areas.Where(Function(area) area.Country = strCountryCode And area.AreaType = strAreaType).OrderBy(Function(area) area.Shortname)

        End Function


        Function FindWalkAreasByNameLike(ByVal strNamePortion As String) As IQueryable(Of Area) Implements IWalkingRepository.FindWalkAreasByNameLike

            Dim q = From h In myWalkingDB.Areas Where h.Areaname.Contains(strNamePortion)
            Return q

        End Function

        '---------------------------------------------------------------------------------------------
        ' Function: FindWalksByTitle
        ' Used by edit marker for AJAX walk name suggestions
        '--------------------------------------------------------
        Function FindWalksByTitleLike(ByVal strTitlePortion As String) As IQueryable(Of Walk) Implements IWalkingRepository.FindWalksByTitleLike

            Dim q = From w In myWalkingDB.Walks Where w.WalkTitle.Contains(strTitlePortion)
            Return q

        End Function



        Function GetWalkAreaNameFromAreaRef(ByVal strAreaRef As String) As String Implements IWalkingRepository.GetWalkAreaNameFromAreaRef

            If strAreaRef Is Nothing Then
                Return ""
            End If
            Dim oArea As Area

            Try
                oArea = myWalkingDB.Areas.FirstOrDefault(Function(a) a.Arearef = strAreaRef)
            Catch ex As Exception
                oArea = New Area

            End Try

            Return oArea.Areaname.Trim + " (" + oArea.AreaType1.AreaTypeName + " region)"

        End Function


        Public Function FindAllMarkers() As System.Linq.IQueryable(Of Marker) Implements IWalkingRepository.FindAllMarkers
            Return myWalkingDB.Markers

        End Function

        '------------------------------------------------------------------------------------------------------------
        '
        ' Function: FindAllWalks
        '
        ' Returns an IQueryable list of all the walks (further processing can be accomplished down the line)
        '
        '-------------------------------------------------------------

        Public Function FindAllWalks() As System.Linq.IQueryable(Of Walk) Implements IWalkingRepository.FindAllWalks
            Return myWalkingDB.Walks
        End Function

        Function GetMarkersCreatedOnWalk(ByVal iWalkID As Integer) As List(Of Marker) Implements IWalkingRepository.GetMarkersCreatedOnWalk

            Dim oMarkers As New List(Of Marker)

            Dim q = From m In myWalkingDB.Markers Where m.WalkID = iWalkID

            For Each oMarker As Marker In q.AsEnumerable
                oMarkers.Add(oMarker)
            Next

            Return oMarkers

        End Function


        '------------------------------------------------------------------------------------------------------------
        '
        ' Function: GetHillDetails
        '
        ' Returns single Hill 
        '
        '-------------------------------------------------------------

        Public Function GetHillDetails(ByVal siHillnumber As Integer) As Hill Implements IWalkingRepository.GetHillDetails

            Return myWalkingDB.Hills.SingleOrDefault(Function(h) h.Hillnumber = siHillnumber)

        End Function

        '------------------------------------------------------------------------------------------------------------
        '
        ' Function: GetHillsByClassification
        '
        ' Returns an iQueryable list of all the hills which are of a certain classification
        '
        '-------------------------------------------------------------
        Public Function GetHillsByClassification(ByVal strHillClassification As String) As System.Linq.IQueryable(Of Hill) Implements IWalkingRepository.GetHillsByClassification

            '---Not as simple as that - the text in hill table given comma separated list of classifications-----

            If Not IsNothing(strHillClassification) Then
                Return From hillclass In myWalkingDB.Classlinks _
                        Where hillclass.Classref = strHillClassification _
                        Join hill In myWalkingDB.Hills On hillclass.Hillnumber Equals hill.Hillnumber _
                        Order By hill.Hillname _
                        Select hill
            Else
                Return From hill In myWalkingDB.Hills
                       Order By hill.Hillname
                       Select hill
            End If



        End Function

        '------------------------------------------------------------------------------------------------------------
        ' Function:GetAllHillClassifications
        ' Returns an iQueryable list of all the HillClassifications
        '-------------------------------------------------------------

        Public Function GetAllHillClassifications() As System.Linq.IQueryable(Of [Class]) Implements IWalkingRepository.GetAllHillClassifications

            Return myWalkingDB.Classes

        End Function

        '------------------------------------------------------------------------------------------------------------
        ' Function: FindHillByNameLike
        ' Returns an iQueryable list of all the Hills which contain specified substring
        '-------------------------------------------------------------

        Function FindHillsByNameLike(ByVal strHillNamePortion As String) As IQueryable(Of Hill) Implements IWalkingRepository.FindsHillByNameLike

            Dim q = From h In myWalkingDB.Hills Where h.Hillname.Contains(strHillNamePortion)
            Return q

        End Function


        '------------------------------------------------------------------------------------------------------------
        ' Function: FindHillByNameLike
        ' Returns an iQueryable list of all the Hills which contain specified substring
        '-------------------------------------------------------------

        Function FindHillsInAreaByNameLike(ByVal strHillNamePortion As String, ByVal strAreaRef As String) As IQueryable(Of Hill) Implements IWalkingRepository.FindHillsInAreaByNameLike

            Dim hills = From hillarealink In myWalkingDB.Arealinks _
                         Where hillarealink.Arearef.Contains(strAreaRef) _
                          Join hill In myWalkingDB.Hills On hillarealink.Hillnumber Equals hill.Hillnumber _
                          Order By hill.Hillname _
                          Select hill

            Dim q = From h In hills Where h.Hillname.Contains(strHillNamePortion)
            Return q

        End Function


        Function CreateMarker(ByVal marker As Marker) As Integer Implements IWalkingRepository.CreateMarker

            myWalkingDB.Markers.InsertOnSubmit(marker)
            myWalkingDB.SubmitChanges()
            Return marker.MarkerID

        End Function

        Function AssociateMarkersWithWalk(ByVal oForm As System.Collections.Specialized.NameValueCollection, ByVal iWalkID As Integer) As Integer Implements IWalkingRepository.AssociateMarkersWithWalk

            Dim iRetval As Integer = 0
            Dim arrMarkerIDs = oForm("markers_added").Split(":")


            '----First associate any newly created markers (created with ajax) with the newly created walk----------------

            For iCounter As Integer = 0 To arrMarkerIDs.Count - 1
                If Not IsNothing(arrMarkerIDs(iCounter)) AndAlso arrMarkerIDs(iCounter).Length > 0 Then
                    Try
                        Dim iMarkerID As Integer = CInt(arrMarkerIDs(iCounter))
                        Dim oMarker As Marker

                        '----Update marker with walk ID------
                        oMarker = myWalkingDB.Markers.SingleOrDefault(Function(m) m.MarkerID = iMarkerID)
                        oMarker.WalkID = iWalkID

                        '----Write a "created" marker observation--------
                        Dim oMarkerObs As New Marker_Observation
                        oMarkerObs.MarkerID = iMarkerID
                        oMarkerObs.FoundFlag = False
                        oMarkerObs.WalkID = iWalkID
                        oMarkerObs.ObservationText = "Set in place"
                        Try
                            oMarkerObs.DateOfObservation = DateTime.Parse(oForm("WalkDate"))
                        Catch ex As Exception
                            oMarkerObs.DateOfObservation = Nothing
                        End Try

                        myWalkingDB.Marker_Observations.InsertOnSubmit(oMarkerObs)


                    Catch ex As Exception
                        iRetval = 1
                    End Try


                End If

            Next


            Dim iImageCounter As Integer = 1

            '----Now write any marker observations necessary for newly added images either in create or edit-----------------------------
            Do While Not IsNothing(oForm("imagerelpath" + iImageCounter.ToString)) AndAlso oForm("imagerelpath" + iImageCounter.ToString).Length > 0

                If oForm("imageismarker" + iImageCounter.ToString) = "on" AndAlso Not arrMarkerIDs.Contains(oForm("imagemarkerid" + iImageCounter.ToString)) Then
                    Dim iMarkerID As Integer = 0

                    Try

                        iMarkerID = CInt(oForm("imagemarkerid" + iImageCounter.ToString))
                        '----Update marker with walk ID------
                        Dim oMarker = myWalkingDB.Markers.SingleOrDefault(Function(m) m.MarkerID = iMarkerID)

                        '----Write any found/not found observation. Only do so if the walk is not the walk on which the marker was created--------
                        If oMarker.WalkID <> iWalkID Then

                            Dim oMarkerObs As New Marker_Observation

                            '---If the marker is not yet associated with a walk then associate it with this walk
                            If IsNothing(oMarker.WalkID) Then
                                oMarker.WalkID = iWalkID

                            End If

                            oMarkerObs.MarkerID = iMarkerID
                            oMarkerObs.WalkID = iWalkID

                            If oForm("imagemarkernotfound" + iImageCounter.ToString) = "on" Then
                                oMarker.Status = "Marker Left - Revisited, not found      "
                                oMarkerObs.ObservationText = "Revisited but not found"
                                oMarkerObs.FoundFlag = False
                            Else
                                oMarkerObs.ObservationText = "Revisited and found"
                                oMarker.Status = "Marker Left - Found again               "
                                oMarkerObs.FoundFlag = True
                            End If

                            Try
                                oMarkerObs.DateOfObservation = DateTime.Parse(oForm("WalkDate"))
                            Catch ex As Exception
                                oMarkerObs.DateOfObservation = Nothing
                            End Try
                            '----Need to test that this observation has not already been inserted------
                            Dim bAlreadyAdded = Me.FindMarkerObservationLike(oMarkerObs)

                            If Not bAlreadyAdded Then
                                myWalkingDB.Marker_Observations.InsertOnSubmit(oMarkerObs)
                            End If

                        End If

                    Catch ex As Exception

                    End Try

                End If
                iImageCounter = iImageCounter + 1
            Loop


            Dim iNumExistingImages As Integer = 0

            Try
                iNumExistingImages = CInt(oForm("numexistingimages"))
            Catch ex As Exception

            End Try

            '----Now write any marker observations necessary for existing images in edit walk-----------------------------
            For iExistingImageCount As Integer = 1 To iNumExistingImages


                If oForm("existingimageismarker" + iExistingImageCount.ToString) = "on" AndAlso Not arrMarkerIDs.Contains(oForm("existingimagemarkerid" + iExistingImageCount.ToString)) Then

                    Dim iMarkerID As Integer = 0

                    Try

                        iMarkerID = CInt(oForm("existingimagemarkerid" + iExistingImageCount.ToString))
                        '----Update marker with walk ID------
                        Dim oMarker = myWalkingDB.Markers.SingleOrDefault(Function(m) m.MarkerID = iMarkerID)
                        '----Write any found/not found observation. Only do so if the walk is not the walk on which the marker was created--------


                        If oMarker.WalkID <> iWalkID OrElse IsNothing(oMarker.WalkID) Then

                            '---If the marker is not yet associated with a walk then associate it with this walk
                            If IsNothing(oMarker.WalkID) Then
                                oMarker.WalkID = iWalkID
                            End If

                            Dim oMarkerObs As New Marker_Observation
                            oMarkerObs.MarkerID = iMarkerID

                            oMarkerObs.WalkID = iWalkID

                            If oForm("existingimagemarkernotfound" + iExistingImageCount.ToString) = "on" Then
                                oMarker.Status = "Marker Left - Revisited, not found      "
                                oMarkerObs.ObservationText = "Revisited but not found"
                                oMarkerObs.FoundFlag = False
                            Else
                                oMarkerObs.ObservationText = "Revisited and found"
                                oMarker.Status = "Marker Left - Found again               "
                                oMarkerObs.FoundFlag = True
                            End If

                            Try
                                oMarkerObs.DateOfObservation = DateTime.Parse(oForm("WalkDate"))
                            Catch ex As Exception
                                oMarkerObs.DateOfObservation = Nothing
                            End Try

                            '----Need to test that this observation has not already been inserted------
                            Dim bAlreadyAdded = Me.FindMarkerObservationLike(oMarkerObs)
                            If Not bAlreadyAdded Then
                                myWalkingDB.Marker_Observations.InsertOnSubmit(oMarkerObs)
                            End If


                        End If

                    Catch ex As Exception

                    End Try

                End If

            Next


            myWalkingDB.SubmitChanges()

            Return iRetval

        End Function


        '------------------------------------------------------------------------------------------------------------
        ' Function: GetMarkerDetails
        ' Returns a single marker object
        '-------------------------------------------------------------

        Public Function GetMarkerDetails(ByVal iMarkerID As Integer) As Marker Implements IWalkingRepository.GetMarkerDetails

            Return myWalkingDB.Markers.SingleOrDefault(Function(m) m.MarkerID = iMarkerID)

        End Function

        Function GetAllMarkerStatusOptions() As IQueryable(Of Marker_Status) Implements IWalkingRepository.GetAllMarkerStatusOptions

            Dim q = From Marker_Status In myWalkingDB.Marker_Status _
            Select Marker_Status

            Return q

        End Function

        Function FindMarkersByNameLike(ByVal strNamePortion As String) As IQueryable(Of Marker) Implements IWalkingRepository.FindMarkersByNameLike

            Dim q = From m In myWalkingDB.Markers Where m.MarkerTitle.Contains(strNamePortion)
            Return q

        End Function

        Function FindMarkerObservationLike(ByVal oMarkerObs As Marker_Observation) As Boolean Implements IWalkingRepository.FindMarkerObservationLike

            Dim bFoundSameObs As Boolean = False

            Dim q = From mo In myWalkingDB.Marker_Observations Where mo.MarkerID = oMarkerObs.MarkerID _
                                                                AndAlso mo.WalkID = oMarkerObs.MarkerID _
                                                                AndAlso mo.DateOfObservation = oMarkerObs.DateOfObservation

            If q.Count > 0 Then
                bFoundSameObs = True
            End If

            Return bFoundSameObs

        End Function

        '------------------------------------------------------------------------------------------------------------
        ' Function: GetWalkDetails
        ' Returns single walk
        '-------------------------------------------------------------

        Public Function GetWalkDetails(ByVal iWalkID As Integer) As Walk Implements IWalkingRepository.GetWalkDetails
            Return myWalkingDB.Walks.SingleOrDefault(Function(w) w.WalkID = iWalkID)

        End Function

        Public Sub UpdateHillDetails(ByVal walk As Walk) Implements IWalkingRepository.UpdateHillDetails

        End Sub

        Function GetAllHillAscents() As IQueryable(Of HillAscent) Implements IWalkingRepository.GetAllHillAscents
            Return myWalkingDB.HillAscents



        End Function



        Public Function UpdateMarkerDetails(ByVal marker As Marker, ByVal oForm As System.Collections.Specialized.NameValueCollection) As Integer Implements IWalkingRepository.UpdateMarkerDetails

            marker.MarkerTitle = oForm("MarkerTitle")
            marker.DateLeft = oForm("DateLeft")
            marker.GPS_Reference = oForm("GPS_Reference")

            Try
                marker.Hillnumber = CInt(oForm("Hillnumber"))
            Catch ex As Exception
                marker.Hillnumber = marker.Hillnumber
            End Try

            marker.Location_Description = oForm("Location_Description")
            marker.Status = oForm("Status")

            Try
                marker.WalkID = CInt(oForm("WalkID"))
            Catch ex As Exception
                marker.WalkID = marker.WalkID

            End Try

            myWalkingDB.SubmitChanges()

        End Function

        Public Sub UpdateWalkDetails(ByVal walk As Walk, ByVal oForm As System.Collections.Specialized.NameValueCollection, ByVal strRootPath As String) Implements IWalkingRepository.UpdateWalkDetails

            Dim iRetval As Integer = 0
            Dim arHillAscents As System.Collections.Generic.List(Of HillAscent)
            Dim arAssociatedFiles As System.Collections.Generic.List(Of Walk_AssociatedFile)

            '----Update the walk object. Unit of work pattern ensures the changes made are committed below-----
            Helpers.WalkingStick.FillWalkFromFormVariables(walk, oForm)

            '-----Delete existing hill ascents. Do this better in future-----------------
            Me.DeleteHillAscentsForWalk(walk.WalkID)

            '---Add hill ascents as per updated form-----------------
            arHillAscents = WalkingMVC.Helpers.WalkingStick.FillHillAscentsFromFormVariables(walk.WalkID, oForm)
            iRetval = Me.AddWalkSummitsVisited(arHillAscents)

            '---Delete the existing associated files---------
            iRetval = Me.DeleteAssociateFilesForWalk(walk.WalkID)

            '----Add updated existing associated files--------
            arAssociatedFiles = WalkingMVC.Helpers.WalkingStick.FillExistingAssociatedFilesFromFormVariables(walk.WalkID, oForm, strRootPath)
            iRetval = Me.AddWalkAssociatedFiles(arAssociatedFiles)

            '---Add the any new associated files-----
            arAssociatedFiles = WalkingMVC.Helpers.WalkingStick.FillHillAssociatedFilesFromFormVariables(walk.WalkID, oForm, strRootPath)
            iRetval = Me.AddWalkAssociatedFiles(arAssociatedFiles)

            '---update any markers created by ajax call with walk id, and add any marker observations----------------
            iRetval = Me.AssociateMarkersWithWalk(oForm, walk.WalkID)


            myWalkingDB.SubmitChanges()

        End Sub

        '------------------------------------------------------------------------------------------------------------
        ' Function: GetHillClassificationName
        ' Given a single classification code, return the classification name
        '-------------------------------------------------------------


        Public Function GetHillClassificationName(ByVal strClassificationCode As String) As String Implements IWalkingRepository.GetHillClassificationName

            Dim strClassificationName = From ClassificationName In myWalkingDB.Classes _
                                        Where ClassificationName.Classref = strClassificationCode _
                                        Select ClassificationName.Classname
            Dim hillclass = myWalkingDB.Classes.SingleOrDefault(Function(hc) hc.Classref = strClassificationCode)

            Return hillclass.Classname
        End Function

        Function GetWalkTypes() As IQueryable(Of WalkType) Implements IWalkingRepository.GetWalkTypes

            Dim q = From WalkType In myWalkingDB.WalkTypes _
                    Select WalkType

            Return q

        End Function

        Function GetAssociatedFileTypes() As IQueryable(Of Walk_AssociatedFile_Type) Implements IWalkingRepository.GetAssociatedFileTypes

            Dim q = From Walk_AssociatedFile_Type In myWalkingDB.Walk_AssociatedFile_Types _
                    Select Walk_AssociatedFile_Type
            Return q

        End Function

        Function GetMyProgress() As List(Of MyProgress) Implements IWalkingRepository.GetMyProgress

            Dim q = myWalkingDB.sp_GetMyProgress()

            Return q.ToList

        End Function



        Function GetMyProgressByClassType(ByVal cClassType As Char) As List(Of MyProgress) Implements IWalkingRepository.GetMyProgressByClassType

            Dim q = myWalkingDB.sp_GetMyProgressByClassType(cClassType)

            Return q.ToList

        End Function

    End Class
End Namespace


