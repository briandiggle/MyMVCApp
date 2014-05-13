
Imports WalkingMVC.WalkingMVC
Imports System.IO

Namespace WalkingMVC.Helpers

    ''' <summary>
    ''' Class containing various shared helper methods 
    '''</summary>

    Public Class WalkingStick

        Public Shared Function HillClassToLink(ByVal strHillClass As String, Optional ByVal strLinkText As String = "") As String

            If strLinkText = "" Then
                strLinkText = strHillClass
            End If

            Return "<a href=""/Walks/HillsInClassification/" + strHillClass + """>" + strLinkText + "</a>"

        End Function

        Public Shared Function HillClassesToLinks(ByVal strHillClasses As String) As String

            Dim oSB As New StringBuilder
            Dim bFirst As Boolean = True

            If strHillClasses Is Nothing Then
                Return ""
            End If

            For Each strClass As String In strHillClasses.Split(",")

                If strClass.Trim.Length > 0 Then

                    If bFirst Then
                        bFirst = False
                    Else
                        oSB.Append(", ")
                    End If
                    oSB.Append("<a href=""/Walks/HillsInClassification/" + strClass + """>" + strClass + "</a>")
                End If
            Next

            Return oSB.ToString

        End Function

        Public Shared Function NumberOfAscentsAsColour(ByVal iNumAscents) As String


            If iNumAscents = 0 Then
                Return "#FFFFFF"
            End If

            ' From CCCCFF to 666699 i.e. 
            Dim iMaxR = 240
            Dim iMaxG = 240
            Dim iMaxB = 255

            Dim iMinR = 122
            Dim iMinG = 122
            Dim iMinB = 173

            Dim iRVal = CInt(iMaxR - (((iMaxR - iMinR) / 20) * iNumAscents))
            Dim iGVal = CInt(iMaxG - (((iMaxG - iMinG) / 20) * iNumAscents))
            Dim iBVal = CInt(iMaxB - (((iMaxB - iMinB) / 20) * iNumAscents))

            Return "#" + Hex(iRVal) + Hex(iGVal) + Hex(iBVal)

        End Function

        Public Shared Function FormatHillSummaryAsLine(ByVal oHill As Hill) As String
            Dim strLine As String = ""

            If IsNothing(oHill) Then
                Return strLine
            End If

            strLine = oHill.Hillname + ", " + oHill.Metres.ToString + "m, " + oHill.Feet.ToString + "ft, "

            If IsDBNull(oHill.Gridref10) AndAlso oHill.Gridref10.Length > 0 Then
                If Not IsDBNull(oHill.Gridref) AndAlso oHill.Gridref.Length > 0 Then
                    strLine = strLine + oHill.Gridref
                End If
            Else
                strLine = strLine + oHill.Gridref10
            End If

            If Not IsNothing(oHill.Classification) Then
                strLine = strLine + ", " + oHill.Classification.Replace(",", " ")
            End If

            Return strLine

        End Function

        Public Shared Function FormatWalkAreaAsLine(ByVal oArea As Area) As String

            Dim strLine As String = ""

            If IsNothing(oArea) Then
                Return strLine
            End If

            strLine = oArea.Areaname + ", Type:" + oArea.AreaType.ToString() + ", Ref:" + oArea.Arearef

            Return strLine

        End Function

        Public Shared Function FormatMarkerAsLine(ByVal oMarker As Marker) As String

            Dim strLine As String = ""

            If IsNothing(oMarker) Then
                Return strLine
            End If

            strLine = oMarker.MarkerTitle.Trim + ", " + oMarker.DateLeft.ToString("dd MMM yyyy").Trim + " " + oMarker.GPS_Reference.Trim

            Return strLine

        End Function

        Public Shared Function FormatWalkAsLine(ByVal oWalk As Walk) As String

            Dim strLine As String = ""

            If IsNothing(oWalk) Then
                Return strLine
            End If

            strLine = oWalk.WalkTitle.Trim + ", " + oWalk.WalkDate.ToString("dd MMM yyyy").Trim
            If Not IsNothing(oWalk.CartographicLength) Then
                strLine &= ", " + CStr(oWalk.CartographicLength) + "Km"
            End If
            If Not IsNothing(oWalk.MetresOfAscent) Then
                strLine &= ", " + CStr(oWalk.MetresOfAscent) + "m Ascent"
            End If

            Return strLine

        End Function

        Public Shared Function DetermineIfDirectoryExists(ByVal strDirName As String) As Boolean

            Try
                Dim dDir As New DirectoryInfo(strDirName)

                If Not dDir.Exists Then
                    Return False
                Else
                    Return True
                End If
            Catch ex As Exception
                Return False
            End Try

        End Function

        Public Shared Function CheckFilesInDirectory(ByVal strDirName As String, ByVal strFilenamePrefix As String, ByRef strRootPath As String, ByVal bAtWork As Boolean) As Object

            Dim oDirInfo As New DirectoryInfo(strDirName)
            Dim oRegex As Regex = New Regex("^" + strFilenamePrefix + "[0-9]+")
            Dim oSB As New StringBuilder
            Dim iNumPicturesFound As Integer = 0
            Dim iLoc As Integer = 0
            Dim strRelativePath As String = ""

            Dim oFiles = oDirInfo.GetFiles(strFilenamePrefix + "*")
            For Each oFI In oFiles
                If oRegex.IsMatch(oFI.Name) Then
                    iNumPicturesFound = iNumPicturesFound + 1
                End If

            Next

            oSB.AppendLine("{")

            iLoc = strDirName.IndexOf(strRootPath)
            If iLoc < 0 Then
                oSB.AppendLine("""errors"": " + """Path invalid"",")
            Else
                strRelativePath = strDirName.Substring(strRootPath.Length - 1, strDirName.Length - strRootPath.Length + 1)
            End If

            Dim oResults As Object
            oResults = New With {.imagesfound = iNumPicturesFound, .path = strRelativePath + "/" + strFilenamePrefix, .atwork = bAtWork.ToString, .filenameprefix = strFilenamePrefix}


            Return oResults
        End Function

        Public Shared Sub FillWalkFromFormVariables(ByRef oWalk As Walk, ByVal oForm As System.Collections.Specialized.NameValueCollection)

            Dim iLoc As Integer = 0
            Dim iWalkTotalTime As Integer = 0

            Try
                oWalk.WalkDate = DateTime.Parse(oForm("WalkDate"))
            Catch ex As Exception
                oWalk.WalkDate = Nothing
            End Try

            oWalk.WalkDescription = oForm("WalkDescription")
            oWalk.WalkTitle = oForm("WalkTitle")
            oWalk.WalkSummary = oForm("WalkSummary")
            oWalk.WalkStartPoint = oForm("WalkStartPoint")
            oWalk.WalkEndPoint = oForm("WalkEndPoint")
            oWalk.WalkType = oForm("WalkTypes")

            iLoc = oForm("WalkAreaName").IndexOf(", Type:")
            If iLoc > 0 Then
                oWalk.WalkAreaName = oForm("WalkAreaName").Substring(0, iLoc)
            Else
                oWalk.WalkAreaName = oForm("WalkAreaName").Trim
            End If

            Try
                oWalk.CartographicLength = Double.Parse(oForm("CartographicLength"))
            Catch ex As Exception
                oWalk.CartographicLength = Nothing
            End Try

            Try
                oWalk.MetresOfAscent = CInt(oForm("MetresOfAscent"))
            Catch ex As Exception
                oWalk.MetresOfAscent = Nothing
            End Try

            Try
                oWalk.WalkAverageSpeedKmh = Double.Parse(oForm("WalkAverageSpeedKmh"))
            Catch ex As Exception
                oWalk.WalkAverageSpeedKmh = Nothing
            End Try

            Try
                oWalk.MovingAverageKmh = Double.Parse(oForm("MovingAverageKmh"))
            Catch ex As Exception
                oWalk.MovingAverageKmh = Nothing
            End Try

            oWalk.WalkCompanions = oForm("WalkCompanions")

            Try
                If Not IsNothing(oForm("total_time_hours")) AndAlso oForm("total_time_hours").Length > 0 Then
                    iWalkTotalTime = CInt(oForm("total_time_hours")) * 60
                End If
            Catch ex As Exception
                iWalkTotalTime = 0
            End Try

            Try
                If Not IsNothing(oForm("total_time_mins")) AndAlso oForm("total_time_mins").Length > 0 Then
                    iWalkTotalTime = iWalkTotalTime + CInt(oForm("total_time_mins"))
                End If
            Catch ex As Exception

            End Try

            If iWalkTotalTime > 0 Then
                oWalk.WalkTotalTime = iWalkTotalTime
            End If

            If Not IsNothing(oForm("summary_auto")) Then

                Dim oSB As StringBuilder = New StringBuilder

                oSB.Append(oForm("WalkStartPoint"))

                Dim iCounter As Integer = 1
                Dim bContinue As Boolean = True
                Dim iFirstLocation As Integer = 0
                Dim iLastLocation As Integer = 0

                While bContinue
                    If Not IsNothing(oForm("VisitedSummit" + iCounter.ToString)) AndAlso oForm("VisitedSummit" + iCounter.ToString).Length > 0 Then

                        '----Append {hillname}(classifications) -> -----------

                        If oSB.ToString.Length > 0 Then
                            oSB.Append(" -> ")
                        End If

                        iFirstLocation = oForm("VisitedSummit" + iCounter.ToString).IndexOf(",")
                        iLastLocation = oForm("VisitedSummit" + iCounter.ToString).LastIndexOf(",")
                        If iFirstLocation < 0 Or iLastLocation < 0 Then
                            oSB.Append(oForm("VisitedSummit" + iCounter.ToString))
                        Else
                            oSB.Append(oForm("VisitedSummit" + iCounter.ToString).Substring(0, iFirstLocation) + "(")
                            oSB.Append(oForm("VisitedSummit" + iCounter.ToString).Substring(iLastLocation + 1, oForm("VisitedSummit" + iCounter.ToString).Length - (iLastLocation + 1)).Trim + ")")
                        End If
                        iCounter = iCounter + 1
                    Else
                        bContinue = False
                    End If
                End While

                If Not IsNothing(oForm("WalkEndPoint")) AndAlso oForm("WalkEndPoint").Length > 0 Then
                    oSB.Append(" -> " + oForm("WalkEndPoint"))
                End If
                oWalk.WalkSummary = oSB.ToString

            Else
                oWalk.WalkSummary = oForm("WalkSummary")
            End If

            If Not IsNothing(oForm("WalkConditions")) Then
                oWalk.WalkConditions = oForm("WalkConditions")
            End If



        End Sub


        Public Shared Function FillHillAscentsFromFormVariables(ByVal iWalkID As Integer, ByVal oForm As System.Collections.Specialized.NameValueCollection) As System.Collections.Generic.List(Of HillAscent)

            Dim collHillAscents As New System.Collections.Generic.List(Of HillAscent)
            Dim iCounter As Integer = 1
            Dim bContinue As Boolean = True
            Dim dAscentDate As Date

            Try
                dAscentDate = DateTime.Parse(oForm("WalkDate"))
            Catch ex As Exception
                dAscentDate = Nothing
            End Try


            While bContinue
                If Not IsNothing(oForm("VisitedSummit" + iCounter.ToString + "HillID")) AndAlso oForm("VisitedSummit" + iCounter.ToString + "HillID").Length > 0 AndAlso oForm("VisitedSummit" + iCounter.ToString).Trim.Length > 0 Then
                    Dim oHillAscent As HillAscent = New HillAscent

                    oHillAscent.AscentDate = dAscentDate
                    Try
                        oHillAscent.Hillnumber = CInt(oForm("VisitedSummit" + iCounter.ToString + "HillID"))
                        oHillAscent.WalkID = iWalkID
                        collHillAscents.Add(oHillAscent)
                    Catch ex As Exception

                    End Try

                    iCounter = iCounter + 1
                Else
                    bContinue = False
                End If
            End While

            Return collHillAscents

        End Function

        Public Shared Function FillHillAssociatedFilesFromFormVariables(ByVal iWalkID As Integer, ByVal oForm As System.Collections.Specialized.NameValueCollection, ByVal strRootpath As String) As System.Collections.Generic.List(Of Walk_AssociatedFile)

            Dim collHillAssociatedFiles As New System.Collections.Generic.List(Of Walk_AssociatedFile)

            Dim iCounter As Integer = 1
            Dim iNumImages As Integer = 0
            Dim bContinue As Boolean = True

            '----Deal with the images first----------------------

            While bContinue
                If Not IsNothing(oForm("imagerelpath" + iCounter.ToString)) AndAlso oForm("imagerelpath" + iCounter.ToString).Length > 0 Then
                    Dim oHillAssociateFile As Walk_AssociatedFile = New Walk_AssociatedFile
                    oHillAssociateFile.WalkID = iWalkID
                    oHillAssociateFile.Walk_AssociatedFile_Name = oForm("imagerelpath" + iCounter.ToString)
                    oHillAssociateFile.Walk_AssociatedFile_Type = "Image"
                    oHillAssociateFile.Walk_AssociatedFile_Caption = oForm("imagecaption" + iCounter.ToString)
                    oHillAssociateFile.Walk_AssociatedFile_Sequence = iCounter
                    If Not IsNothing(oForm("imageismarker" + iCounter.ToString)) AndAlso oForm("imageismarker" + iCounter.ToString).Length > 0 Then
                        oHillAssociateFile.Walk_AssociatedFile_MarkerID = oForm("imagemarkerid" + iCounter.ToString)
                    End If

                    collHillAssociatedFiles.Add(oHillAssociateFile)

                    iCounter = iCounter + 1
                Else
                    bContinue = False
                End If
            End While

            iNumImages = iCounter - 1
            iCounter = 1
            bContinue = True

            '----Deal with the others ----------------------

            While bContinue
                If Not IsNothing(oForm("auxilliary_file" + iCounter.ToString)) AndAlso oForm("auxilliary_file" + iCounter.ToString).Length > 0 Then
                    Dim oHillAssociateFile As Walk_AssociatedFile = New Walk_AssociatedFile
                    oHillAssociateFile.WalkID = iWalkID
                    oHillAssociateFile.Walk_AssociatedFile_Name = ConvertPathToRelativeURL(oForm("auxilliary_file" + iCounter.ToString), strRootpath)
                    oHillAssociateFile.Walk_AssociatedFile_Type = oForm("auxilliary_filetype" + iCounter.ToString)
                    oHillAssociateFile.Walk_AssociatedFile_Sequence = iCounter + iNumImages
                    oHillAssociateFile.Walk_AssociatedFile_Caption = oForm("auxilliary_caption" + iCounter.ToString)
                    collHillAssociatedFiles.Add(oHillAssociateFile)

                    iCounter = iCounter + 1
                Else
                    bContinue = False
                End If
            End While

            Return collHillAssociatedFiles
        End Function

        Public Shared Function FillExistingAssociatedFilesFromFormVariables(ByVal iWalkID As Integer, ByVal oForm As System.Collections.Specialized.NameValueCollection, ByVal strRootpath As String) As System.Collections.Generic.List(Of Walk_AssociatedFile)

            Dim collHillAssociatedFiles As New System.Collections.Generic.List(Of Walk_AssociatedFile)

            Dim iCounter As Integer = 1
            Dim iNumExistingImages As Integer = 0
            Dim iSequenceCounter As Integer = 1
            Dim bContinue As Boolean = True

            '----Deal with the images first----------------------
            Try
                iNumExistingImages = CInt(oForm("NumExistingImages"))
            Catch ex As Exception

            End Try


            For iExistingImagesCount As Integer = 1 To iNumExistingImages
                If Not IsNothing(oForm("existingimagename" + iExistingImagesCount.ToString)) AndAlso oForm("existingimagename" + iExistingImagesCount.ToString).Length > 0 AndAlso oForm("deletexistingimage" + iExistingImagesCount.ToString) <> "on" Then
                    Dim oHillAssociateFile As Walk_AssociatedFile = New Walk_AssociatedFile
                    oHillAssociateFile.WalkID = iWalkID
                    oHillAssociateFile.Walk_AssociatedFile_Name = oForm("existingimagename" + iExistingImagesCount.ToString)
                    oHillAssociateFile.Walk_AssociatedFile_Type = "Image"
                    oHillAssociateFile.Walk_AssociatedFile_Caption = oForm("existingimagecaption" + iExistingImagesCount.ToString)
                    oHillAssociateFile.Walk_AssociatedFile_Sequence = iSequenceCounter
                    If Not IsNothing(oForm("existingimageismarker" + iExistingImagesCount.ToString)) AndAlso oForm("existingimageismarker" + iExistingImagesCount.ToString).Length > 0 Then
                        oHillAssociateFile.Walk_AssociatedFile_MarkerID = oForm("existingimagemarkerid" + iExistingImagesCount.ToString)
                    End If
                    iSequenceCounter = iSequenceCounter + 1
                    collHillAssociatedFiles.Add(oHillAssociateFile)
                End If
            Next

            iCounter = 1
            bContinue = True

            '----Deal with the others ----------------------

            While bContinue
                If Not IsNothing(oForm("existingauxfilename" + iCounter.ToString)) AndAlso oForm("existingauxfilename" + iCounter.ToString).Length > 0 AndAlso oForm("delexisting_auxilliary_file" + iCounter.ToString) <> "on" Then
                    Dim oHillAssociateFile As Walk_AssociatedFile = New Walk_AssociatedFile
                    oHillAssociateFile.WalkID = iWalkID
                    oHillAssociateFile.Walk_AssociatedFile_Name = oForm("existingauxfilename" + iCounter.ToString)
                    oHillAssociateFile.Walk_AssociatedFile_Type = oForm("existingauxfiletype" + iCounter.ToString)
                    oHillAssociateFile.Walk_AssociatedFile_Sequence = iCounter + iSequenceCounter

                    collHillAssociatedFiles.Add(oHillAssociateFile)

                    iCounter = iCounter + 1
                Else
                    bContinue = False
                End If
            End While

            Return collHillAssociatedFiles
        End Function


        Public Shared Function ConvertPathToRelativeURL(ByVal strPath As String, ByVal strRootPath As String) As String

            Dim iLoc As Integer = 0

            iLoc = strPath.IndexOf(strRootPath)
            If iLoc = 0 Then
                Return strPath.Substring(strRootPath.Length - 1, (strPath.Length - strRootPath.Length) + 1).Replace("\", "/")
            Else
                Return strPath
            End If


        End Function

        Public Shared Function ConvertTotalTimeToString(ByVal iTotalTime As Integer?, ByVal shortForm As Boolean) As String

            If iTotalTime = 0 Then
                Return ""
            End If

            Dim strHour As String = "hour"
            Dim strMinute As String = "min"

            If shortForm Then
                strHour = "hr"
                strMinute = "m"
            End If

            Dim strRet As String = ""

            Dim iNumHours = iTotalTime \ 60
            Dim iNumMins = iTotalTime Mod 60

            If iNumHours > 0 Then
                strRet = iNumHours.ToString
                If iNumHours > 1 Then
                    strRet += " " + strHour + "s "
                Else
                    strRet += " " + strHour + " "
                End If
            End If

            If iNumMins > 0 Then
                strRet = strRet + iNumMins.ToString
                If iNumMins > 1 Then
                    strRet += " " + strMinute + "s"
                Else
                    strRet += " " + strMinute
                End If
            End If

            Return strRet

        End Function

        Public Shared Function CountryNameFromCountryCode(ByVal strCountryCode As String) As String

            Dim strCountryname As String = ""

            If strCountryCode.Equals("EN") Then
                strCountryname = "England"
            ElseIf strCountryCode.Equals("IM") Then
                strCountryname = "Isle Of Man"
            ElseIf strCountryCode.Equals("IR") Then
                strCountryname = "Ireland"
            ElseIf strCountryCode.Equals("SC") Then
                strCountryname = "Scotland"
            ElseIf strCountryCode.Equals("WA") Then
                strCountryname = "Wales"
            ElseIf strCountryCode.Equals("EW") Then
                strCountryname = "England and Wales County Tops"
            End If


            Return strCountryname

        End Function

        Public Shared Function ExtractFileNameFromPath(ByVal strFullPath As String) As String

            Dim iLoc As Integer = 0

            iLoc = strFullPath.LastIndexOf("/")


            Return strFullPath.Substring(iLoc + 1, (strFullPath.Length - iLoc) - 1)



        End Function

        Public Shared Function WhiteListFormInput(ByVal strFormInput As String) As Boolean

            Dim oRegex As New Regex("^[a-zA-Z'.]{1,40}$")
            Return oRegex.IsMatch(strFormInput)

        End Function

    End Class
End Namespace


