namespace MyMVCApp.DAL
{
    using System;
    using System.Collections.Generic;
    using System.Collections.Specialized;
    using System.IO;
    using System.Text;
    using System.Text.RegularExpressions;

    public class WalkingStick
    {

    
        public static string HillClassToLink(string strHillClass, string strLinkText) 
        {
            if ((strLinkText == "")) 
            {
                strLinkText = strHillClass;
                // Warning!!! Optional parameters not supported
            }
            return ("<a href=\"/Walks/HillsInClassification/" 
                        + (strHillClass + ("\">" 
                        + (strLinkText + "</a>"))));
        }

 
        public static string HillClassesToLinks(string strHillClasses) 
        {
            var oSb = new StringBuilder();
            bool bFirst = true;
            if ((strHillClasses == null)) 
            {
                return "";
            }

            foreach (string strClass in strHillClasses.Split(',')) 
            {
                if ((strClass.Trim().Length > 0)) 
                {
                    if (bFirst) 
                    {
                        bFirst = false;
                    }
                    else 
                    {
                        oSb.Append(", ");
                    }
                    oSb.Append(("<a href=\"/Walks/HillsInClassification/" 
                                    + (strClass + ("\">" 
                                    + (strClass + "</a>")))));
                }
            }
            return oSb.ToString();
        }

    
        public static string NumberOfAscentsAsColour(int iNumAscents) 
        {
            if ((iNumAscents == 0))
            {
                return "#FFFFFF";
            }
            //  From CCCCFF to 666699 i.e. 
            int iMaxR = 240;
            int iMaxG = 240;
            int iMaxB = 255;
            int iMinR = 122;
            int iMinG = 122;
            int iMinB = 173;
            int iRVal = ((iMaxR 
                            - (((iMaxR - iMinR) 
                            / 20) 
                            * iNumAscents)));
            int iGVal = ((iMaxG 
                            - (((iMaxG - iMinG) 
                            / 20) 
                            * iNumAscents)));
            int iBVal = ((iMaxB 
                            - (((iMaxB - iMinB) 
                            / 20) 
                            * iNumAscents)));
            return ("#" 
                        + (iRVal.ToString("X")) 
                        + (iGVal.ToString("X"))
                        + (iBVal.ToString("X")));
        }

    
        public static string FormatHillSummaryAsLine(Hill oHill)
        {
            string strLine = "";
            if ((oHill == null)) 
            {
                return strLine;
            }

            strLine = oHill.Hillname + (", " 
                        + (oHill.Metres.ToString() + ("m, " 
                        + (oHill.Feet.ToString() + "ft, "))));

            if (!string.IsNullOrEmpty(oHill.Gridref10)  && (oHill.Gridref10.Length > 0)) 
            {
                if ((!string.IsNullOrEmpty(oHill.Gridref)) && (oHill.Gridref.Length > 0)) 
                {
                    strLine = (strLine + oHill.Gridref);
                }
            }
            else 
            {
                strLine = (strLine + oHill.Gridref10);
            }
            if (!(oHill.Classification == null)) 
            {
                strLine = (strLine + (", " + oHill.Classification.Replace(",", " ")));
            }
            return strLine;
        }


        public static string FormatWalkAreaAsLine(Area oArea) {
            string strLine = "";
            if ((oArea == null)) {
                return strLine;
            }
            strLine = (oArea.Areaname + (", Type:" 
                        + (oArea.AreaType.ToString() + (", Ref:" + oArea.Arearef))));
            return strLine;
        }
    
        public static string FormatMarkerAsLine(Marker oMarker) {
            string strLine = "";
            if ((oMarker == null)) {
                return strLine;
            }
            strLine = (oMarker.MarkerTitle.Trim() + (", " 
                        + (oMarker.DateLeft.ToString("dd MMM yyyy").Trim() + (" " + oMarker.GPS_Reference.Trim()))));
            return strLine;
        }
    
        public static string FormatWalkAsLine(Walk oWalk) {
            string strLine = "";
            if ((oWalk == null)) {
                return strLine;
            }
            strLine = (oWalk.WalkTitle.Trim() + (", " + oWalk.WalkDate.ToString("dd MMM yyyy").Trim()));
            if (!(oWalk.CartographicLength == null)) {
                strLine = strLine + ", " 
                            + oWalk.CartographicLength.ToString() + "Km";
            }

            if (!(oWalk.MetresOfAscent == null)) {
                strLine = strLine + ", " 
                            + (oWalk.MetresOfAscent.ToString() + "m Ascent");
            }
            return strLine;
        }

  
        public static bool DetermineIfDirectoryExists(string strDirName) 
        {
            try 
            {
                var dDir = new DirectoryInfo(strDirName);
                if (!dDir.Exists) 
                {
                    return false;
                }
                return true;
            }
            catch (Exception) 
            {
                return false;
            }
        }
    
        public static object CheckFilesInDirectory(string strDirName, string strFilenamePrefix, ref string strRootPath, bool bAtWork) {
            DirectoryInfo oDirInfo = new DirectoryInfo(strDirName);
            Regex oRegex = new Regex(("^" 
                            + (strFilenamePrefix + "[0-9]+")));
            StringBuilder oSB = new StringBuilder();
            int iNumPicturesFound = 0;
            int iLoc = 0;
            string strRelativePath = "";
            var oFiles = oDirInfo.GetFiles((strFilenamePrefix + "*"));
            foreach (var oFI in oFiles) {
                if (oRegex.IsMatch(oFI.Name)) {
                    iNumPicturesFound = (iNumPicturesFound + 1);
                }
            }
            oSB.AppendLine("{");
            iLoc = strDirName.IndexOf(strRootPath);
            if ((iLoc < 0)) {
                oSB.AppendLine(("\"errors\": " + "\"Path invalid\","));
            }
            else {
                strRelativePath = strDirName.Substring((strRootPath.Length - 1), ((strDirName.Length - strRootPath.Length) 
                                + 1));
            }

            var oResults = new{imagesfound = iNumPicturesFound, path = (strRelativePath + "/" + strFilenamePrefix), atwork = bAtWork.ToString(), filenameprefix = strFilenamePrefix};

        
            return oResults;
        }


    
        public static void FillWalkFromFormVariables(ref Walk oWalk, System.Collections.Specialized.NameValueCollection oForm) {
            int iLoc = 0;
            int iWalkTotalTime = 0;
            try {
                oWalk.WalkDate = DateTime.Parse(oForm["WalkDate"]);
            }
            catch (Exception) 
            {
                oWalk.WalkDate = DateTime.MinValue;
            }
            oWalk.WalkDescription = oForm["WalkDescription"];
            oWalk.WalkTitle = oForm["WalkTitle"];
            oWalk.WalkSummary = oForm["WalkSummary"];
            oWalk.WalkStartPoint = oForm["WalkStartPoint"];
            oWalk.WalkEndPoint = oForm["WalkEndPoint"];
            oWalk.WalkType = oForm["WalkTypes"];
            iLoc = oForm["WalkAreaName"].IndexOf(", Type:");

            if ((iLoc > 0)) {
                oWalk.WalkAreaName = oForm["WalkAreaName"].Substring(0, iLoc);
            }
            else {
                oWalk.WalkAreaName = oForm["WalkAreaName"].Trim();
            }

            try 
            {
                oWalk.CartographicLength = double.Parse(oForm["CartographicLength"]);
            }
            catch (Exception) 
            {
                oWalk.CartographicLength = null;
            }

            try 
            {
                oWalk.MetresOfAscent = Int16.Parse(oForm["MetresOfAscent"]);
            }
            catch (Exception) 
            {
                oWalk.MetresOfAscent = null;
            }

            try 
            {
                oWalk.WalkAverageSpeedKmh = double.Parse(oForm["WalkAverageSpeedKmh"]);
            }
            catch (Exception) 
            {
                oWalk.WalkAverageSpeedKmh = null;
            }

            try 
            {
                oWalk.MovingAverageKmh = double.Parse(oForm["MovingAverageKmh"]);
            }
            catch (Exception) 
            {
                oWalk.MovingAverageKmh = null;
            }

            oWalk.WalkCompanions = oForm["WalkCompanions"];
            
            try 
            {
                if ((!(oForm["total_time_hours"] == null) && (oForm["total_time_hours"].Length > 0))) 
                {
                    iWalkTotalTime = (int.Parse(oForm["total_time_hours"]) * 60);
                }
            }
            catch (Exception) 
            {
                iWalkTotalTime = 0;
            }

            try {
                if ((!(oForm["total_time_mins"] == null) && (oForm["total_time_mins"].Length > 0))) 
                {
                    iWalkTotalTime = (iWalkTotalTime + int.Parse(oForm["total_time_mins"]));
                }
            }
            catch (Exception) 
            {
            }

            if ((iWalkTotalTime > 0)) {
                oWalk.WalkTotalTime = iWalkTotalTime;
            }

            if (!(oForm["summary_auto"] == null)) 
            {
                StringBuilder oSB = new StringBuilder();
                oSB.Append(oForm["WalkStartPoint"]);
                int iCounter = 1;
                bool bContinue = true;
                int iFirstLocation = 0;
                int iLastLocation = 0;
                while (bContinue) {
                    if ((!(oForm[("VisitedSummit" + iCounter.ToString())] == null) 
                                && (oForm[("VisitedSummit" + iCounter.ToString())]).Length > 0)) {
                        // ----Append {hillname}(classifications) -> -----------
                        if ((oSB.ToString().Length > 0)) {
                            oSB.Append(" -> ");
                        }
                        iFirstLocation = oForm[("VisitedSummit" + iCounter.ToString())].IndexOf(",");
                        iLastLocation = oForm[("VisitedSummit" + iCounter.ToString())].LastIndexOf(",");
                        if (((iFirstLocation < 0) 
                                    || (iLastLocation < 0))) {
                            oSB.Append(oForm[("VisitedSummit" + iCounter.ToString())]);
                        }
                        else {
                            oSB.Append((oForm[("VisitedSummit" + iCounter.ToString())]).Substring(0, iFirstLocation) + "(");
                       //     oSB.Append((oForm[("VisitedSummit" + iCounter.ToString())]).Substring((iLastLocation + 1), (oForm[("VisitedSummit" + iCounter.ToString())]).Length() - (iLastLocation + 1))) + ")";
                        }
                        iCounter = (iCounter + 1);
                    }
                    else {
                        bContinue = false;
                    }
                }
                if ((!(oForm["WalkEndPoint"] == null) 
                            && (oForm["WalkEndPoint"].Length > 0))) {
                    oSB.Append((" -> " + oForm["WalkEndPoint"]));
                }
                oWalk.WalkSummary = oSB.ToString();
            }
            else {
                oWalk.WalkSummary = oForm["WalkSummary"];
            }
            if (!(oForm["WalkConditions"] == null)) {
                oWalk.WalkConditions = oForm["WalkConditions"];
            }
        }

        public static Marker FillMarkerFromFormVariables(Marker oMarker, NameValueCollection oForm)
        {
            Marker oNewMarker = new Marker();

            oNewMarker.MarkerTitle = oMarker.MarkerTitle;
            oNewMarker.DateLeft = oMarker.DateLeft;
            oNewMarker.GPS_Reference = oMarker.GPS_Reference;
            oNewMarker.Hillnumber = Int16.Parse(oForm["HillID"]);
            
            oNewMarker.Location_Description = oMarker.Location_Description;

            oNewMarker.Status = oForm["MarkerStatusii"];

            oNewMarker.WalkID = Int32.Parse(oForm["WalkID"]);

            return oNewMarker;
        }

    
        public static List<HillAscent> FillHillAscentsFromFormVariables(int iWalkID, NameValueCollection oForm) 
        {
        
            List<HillAscent> collHillAscents = new List<HillAscent>();
            int iCounter = 1;
            bool bContinue = true;
            DateTime dAscentDate;
            try {
                dAscentDate = DateTime.Parse(oForm["WalkDate"]);
            }
            catch (Exception) 
            {
                dAscentDate = DateTime.MinValue;
            }

            while (bContinue) {
                if ((!(oForm[("VisitedSummit" 
                                + (iCounter.ToString() + "HillID"))] == null) 
                            && ((oForm[("VisitedSummit" 
                                + (iCounter.ToString() + "HillID"))].Length > 0) 
                            && (oForm[("VisitedSummit" + iCounter.ToString())].Trim().Length > 0)))) {
                    HillAscent oHillAscent = new HillAscent();
                    oHillAscent.AscentDate = dAscentDate;
                    try {
                        oHillAscent.Hillnumber = Int16.Parse(oForm[("VisitedSummit" + iCounter.ToString() + "HillID")]);
                        oHillAscent.WalkID = iWalkID;
                        collHillAscents.Add(oHillAscent);
                    }
                    catch (Exception) 
                    {
                    }
                    iCounter = (iCounter + 1);
                }
                else {
                    bContinue = false;
                }
            }
            return collHillAscents;
        }


    
        public static List<Walk_AssociatedFile> FillHillAssociatedFilesFromFormVariables(int iWalkID, NameValueCollection oForm, string strRootpath) 
        {
    
            List<Walk_AssociatedFile> collHillAssociatedFiles = new List<Walk_AssociatedFile>();

            int iCounter = 1;
            int iNumImages = 0;
            bool bContinue = true;
            while (bContinue) 
            {
                if ((!(oForm[("imagerelpath" + iCounter.ToString())] == null) 
                            && (oForm[("imagerelpath" + iCounter.ToString())]).Length > 0)) {
                    Walk_AssociatedFile oHillAssociateFile = new Walk_AssociatedFile();
                    oHillAssociateFile.WalkID = iWalkID;
                    oHillAssociateFile.Walk_AssociatedFile_Name = oForm[("imagerelpath" + iCounter.ToString())];
                    oHillAssociateFile.Walk_AssociatedFile_Type = "Image";
                    oHillAssociateFile.Walk_AssociatedFile_Caption = oForm[("imagecaption" + iCounter.ToString())];
                    oHillAssociateFile.Walk_AssociatedFile_Sequence = (short)(iCounter);
                    if ((!(oForm[("imageismarker" + iCounter.ToString())] == null) 
                                && (oForm[("imageismarker" + iCounter.ToString())].Length > 0))) {
                        oHillAssociateFile.Walk_AssociatedFile_MarkerID = Int32.Parse(oForm[("imagemarkerid" + iCounter.ToString())]);
                    }
                    collHillAssociatedFiles.Add(oHillAssociateFile);
                    iCounter = (iCounter + 1);
                }
                else {
                    bContinue = false;
                }
            }
            iNumImages = (iCounter - 1);
            iCounter = 1;
            bContinue = true;
            while (bContinue) {
                if ((!(oForm[("auxilliary_file" + iCounter.ToString())] == null) 
                            && (oForm[("auxilliary_file" + iCounter.ToString())].Length > 0))) 
                {
                    Walk_AssociatedFile oHillAssociateFile = new Walk_AssociatedFile();
                    oHillAssociateFile.WalkID = iWalkID;
                    oHillAssociateFile.Walk_AssociatedFile_Name = ConvertPathToRelativeURL(oForm[("auxilliary_file" + iCounter.ToString())], strRootpath);
                    oHillAssociateFile.Walk_AssociatedFile_Type = oForm[("auxilliary_filetype" + iCounter.ToString())];
                    oHillAssociateFile.Walk_AssociatedFile_Sequence = (short)(iCounter + iNumImages);
                    oHillAssociateFile.Walk_AssociatedFile_Caption = oForm[("auxilliary_caption" + iCounter.ToString())];
                    collHillAssociatedFiles.Add(oHillAssociateFile);
                    iCounter = (iCounter + 1);
                }
                else {
                    bContinue = false;
                }
            }
            return collHillAssociatedFiles;
        }



    
        public static List<Walk_AssociatedFile> FillExistingAssociatedFilesFromFormVariables(int iWalkID, NameValueCollection oForm, string strRootpath) 
        {
            List<Walk_AssociatedFile> collHillAssociatedFiles = new List<Walk_AssociatedFile>();

            int iCounter = 1;
            int iNumExistingImages = 0;
            int iSequenceCounter = 1;
            bool bContinue = true;
            try 
            {
                iNumExistingImages = int.Parse(oForm["NumExistingImages"]);
            }
            catch (Exception) 
            {
            }

            for (int iExistingImagesCount = 1; (iExistingImagesCount <= iNumExistingImages); iExistingImagesCount++) {
                if ((!(oForm[("existingimagename" + iExistingImagesCount.ToString())] == null) 
                            && ((oForm[("existingimagename" + iExistingImagesCount.ToString())].Length > 0) 
                            && (oForm[("deletexistingimage" + iExistingImagesCount.ToString())] != "on")))) {
                    Walk_AssociatedFile oHillAssociateFile = new Walk_AssociatedFile();
                    oHillAssociateFile.WalkID = iWalkID;
                    oHillAssociateFile.Walk_AssociatedFile_Name = oForm[("existingimagename" + iExistingImagesCount.ToString())];
                    oHillAssociateFile.Walk_AssociatedFile_Type = "Image";
                    oHillAssociateFile.Walk_AssociatedFile_Caption = oForm[("existingimagecaption" + iExistingImagesCount.ToString())];
                    oHillAssociateFile.Walk_AssociatedFile_Sequence = (short)iSequenceCounter;
                    if ((!(oForm[("existingimageismarker" + iExistingImagesCount.ToString())] == null) 
                                && (oForm[("existingimageismarker" + iExistingImagesCount.ToString())].Length > 0))) {
                        oHillAssociateFile.Walk_AssociatedFile_MarkerID = int.Parse(oForm[("existingimagemarkerid" + iExistingImagesCount.ToString())]);
                    }
                    iSequenceCounter = (iSequenceCounter + 1);
                    collHillAssociatedFiles.Add(oHillAssociateFile);
                }
            }

            iCounter = 1;
            bContinue = true;
            while (bContinue) {
                if ((!(oForm[("existingauxfilename" + iCounter.ToString())] == null) 
                            && ((oForm[("existingauxfilename" + iCounter.ToString())].Length > 0) 
                            && (oForm[("delexisting_auxilliary_file" + iCounter.ToString())] != "on")))) {
                    var oHillAssociateFile = new Walk_AssociatedFile();
                    oHillAssociateFile.WalkID = iWalkID;
                    oHillAssociateFile.Walk_AssociatedFile_Name = oForm[("existingauxfilename" + iCounter.ToString())];
                    oHillAssociateFile.Walk_AssociatedFile_Type = oForm[("existingauxfiletype" + iCounter.ToString())];
                    oHillAssociateFile.Walk_AssociatedFile_Sequence = (short)(iCounter + iSequenceCounter);
                    collHillAssociatedFiles.Add(oHillAssociateFile);
                    iCounter = (iCounter + 1);
                }
                else {
                    bContinue = false;
                }
            }
            return collHillAssociatedFiles;
        }
    
        public static string ConvertPathToRelativeURL(string strPath, string strRootPath) {
            int iLoc = 0;
            iLoc = strPath.IndexOf(strRootPath);
            if ((iLoc == 0)) {
                return strPath.Substring((strRootPath.Length - 1), ((strPath.Length - strRootPath.Length) 
                                + 1)).Replace("\\", "/");
            }
            else {
                return strPath;
            }
        }

        public static string CountryNameFromCountryCode(string strCountryCode) 
        {

            string strCountryname = "";
            if (strCountryCode.Equals("EN")) 
            {
                strCountryname = "England";
            }
            else if (strCountryCode.Equals("IM")) 
            {
                strCountryname = "Isle Of Man";
            }
            else if (strCountryCode.Equals("IR")) 
            {
                strCountryname = "Ireland";
            }
            else if (strCountryCode.Equals("SC")) 
            {
                strCountryname = "Scotland";
            }
            else if (strCountryCode.Equals("WA")) 
            {
                strCountryname = "Wales";
            }
            else if (strCountryCode.Equals("EW")) 
            {
                strCountryname = "England and Wales County Tops";
            }

            return strCountryname;
        }


        public static string ConvertTotalTimeToString(int? iTotalTime, bool shortForm) 
        {


            if (!iTotalTime.HasValue)
            {
                return "";
            }
            else
            {
                
            }

            if ((iTotalTime == 0)) {
                return "";
            }
            string strHour = "hour";
            string strMinute = "min";
            if (shortForm) {
                strHour = "hr";
                strMinute = "m";
            }
            string strRet = "";
            int iNumHours = iTotalTime.Value / 60;
           
            int iNumMins = (iTotalTime.Value % 60);
            if ((iNumHours > 0)) 
            {
                strRet = iNumHours.ToString();
                if ((iNumHours > 1)) {
                    strRet = (strRet + (" " 
                                + (strHour + "s ")));
                }
                else {
                    strRet = (strRet + (" " 
                                + (strHour + " ")));
                }
            }
            if ((iNumMins > 0)) {
                strRet = (strRet + iNumMins.ToString());
                if ((iNumMins > 1)) {
                    strRet = (strRet + (" " 
                                + (strMinute + "s")));
                }
                else {
                    strRet = (strRet + (" " + strMinute));
                }
            }
            return strRet;
        }


 


        public static Boolean WhiteListFormInput(string strFormInput)
        {
            var oRegex = new Regex("^[a-zA-Z'.]{1,40}$");

            return oRegex.IsMatch(strFormInput);
        }

        public static string ExtractFileNameFromPath(string strFullPath)
        {
            int iLoc = strFullPath.LastIndexOf("/");

            return strFullPath.Substring(iLoc + 1, (strFullPath.Length - iLoc) - 1);
        }
    }
}