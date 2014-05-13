﻿
using System.Web.Mvc;
using System.Linq;

namespace MyMVCAppCS.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.Configuration;

    using MyMVCApp.DAL;

    using MyMVCAppCS.Models;

    public class WalksController : Controller
    {
   
        private IWalkingRepository repository;

        public WalksController()
        {
            this.repository = new SqlWalkingRepository();
        }

        //
        // GET: /Walks/
        public ActionResult Index()
        {
            ViewData["MVCVersion"] = typeof(Controller).Assembly.CodeBase;
            return View();
        }

        public ActionResult WalkingAreasByCountry(string strCountryCode, string strAreaType = "")
        {
            string strCountryName = WalkingStick.CountryNameFromCountryCode(strCountryCode);
            string strAreaTypeName = "";
            ViewData["CountryName"] = strCountryName;

            IQueryable<Area> IQWalkingAreas;

            if ( strAreaType.Equals(""))
            {
                IQWalkingAreas = this.repository.GetAllWalkingAreas(strCountryCode);
            }
            else
            {
                IQWalkingAreas = this.repository.GetAllWalkingAreas(strCountryCode, strAreaType);
                strAreaTypeName = repository.GetWalkAreaTypeNameFromType(strAreaType);
            }
            ViewData["AreaTypeName"] = strAreaTypeName;

            return this.View(IQWalkingAreas);

        }


        public ActionResult HillClasses()
        {
            var IQHillClasses =
                this.repository.GetAllHillClassifications().OrderBy(classification => classification.Classname);

            return this.View(IQHillClasses);
        }

        /// <summary>
        /// HillsByARea
        /// </summary>
        /// <param name="id"></param>
        /// <param name="OrderBy"></param>
        /// <param name="page"></param>
        /// <returns></returns>
        public ActionResult HillsByArea(string id, string OrderBy = "NameAsc", int page = 1)
        {
           // var IQHillsInWalkingArea = this.repository.FindHillsByArea(id);

            IQueryable<Hill> IQHillsInWalkingArea;

            if ((OrderBy == "NameAsc"))
            {
                IQHillsInWalkingArea = repository.FindHillsByArea(id).OrderBy(hill => hill.Hillname);
                ViewData["OrderBy"] = "Name";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "NameDesc"))
            {
                IQHillsInWalkingArea = repository.FindHillsByArea(id).OrderByDescending(hill => hill.Hillname);
                ViewData["OrderBy"] = "Name";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "MetresAsc"))
            {
                IQHillsInWalkingArea = repository.FindHillsByArea(id).OrderBy(hill => hill.Metres);
                ViewData["OrderBy"] = "Metres";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "MetresDesc"))
            {
                IQHillsInWalkingArea = repository.FindHillsByArea(id).OrderByDescending(hill => hill.Metres);
                ViewData["OrderBy"] = "Metres";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "FirstAscentDesc"))
            {
                IQHillsInWalkingArea = repository.FindHillsByArea(id).OrderByDescending(hill => hill.FirstClimbedDate);
                ViewData["OrderBy"] = "FirstAscent";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "FirstAscentAsc"))
            {
                IQHillsInWalkingArea = repository.FindHillsByArea(id).OrderBy(hill => hill.FirstClimbedDate);
                ViewData["OrderBy"] = "FirstAscent";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "NumberAscentDesc"))
            {
                IQHillsInWalkingArea = repository.FindHillsByArea(id).OrderByDescending(hill => hill.NumberOfAscents);
                ViewData["OrderBy"] = "NumberAscent";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "NumberAscentAsc"))
            {
                IQHillsInWalkingArea = repository.FindHillsByArea(id).OrderBy(hill => hill.NumberOfAscents);
                ViewData["OrderBy"] = "NumberAscent";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else
            {
                IQHillsInWalkingArea = repository.FindHillsByArea(id);
                ViewData["OrderBy"] = "Name";
                ViewData["OrderAscDesc"] = "Asc";
            }

            int pageSize = Int32.Parse(WebConfigurationManager.AppSettings["PAGINATION_PAGE_SIZE"]);
            int maxPageLinks = Int32.Parse(WebConfigurationManager.AppSettings["PAGINATION_MAX_PAGE_LINKS"]);
            string strAreaName = this.repository.GetWalkAreaNameFromAreaRef(id);

            ViewData["AreaName"] = strAreaName;

            // ----Create a paginated list of hills----------------
            PaginatedListMVC<Hill> iqPaginatedHills = new PaginatedListMVC<Hill>(IQHillsInWalkingArea,
                                                                                page,
                                                                                pageSize,
                                                                                Url.RouteUrl("Default", new { action="HillsByArea", controller="Walks"}),
                                                                                maxPageLinks,
                                                                                "?OrderBy" + OrderBy);

            // -----Pass the paginated list of hills to the view. The view expects a paginated list as its model-----
            return View(iqPaginatedHills);
        }

        public ActionResult HillDetails(int id)
        {
            var oHillDetails = this.repository.GetHillDetails(id);

            var oHillAscents = this.repository.GetHillAscents(id).OrderBy(hill => hill.AscentDate);

            ViewData["HillAscents"] = oHillAscents.AsEnumerable();
            return this.View(oHillDetails);

        }

   // -------------------------------------------------------------------------------------
    //  Function: HillInClassification
    //  URL     : /Walks/HillsInClassification/Classref/[Pagenumber]
    //  Descr   : Return a list of hills with classification as specified by id parameter
    //            optional page parameter provides pagination.
    // --------------------------------------------------------------------------------------
    public ActionResult HillsInClassification(string id, string OrderBy="NameAsc", int page=1) 
    {
    
        if ((id == null)) 
        {
            ViewData["HillClassName"] = "All Hill Classes";
        }
        else 
        {
            ViewData["HillClassName"] = repository.GetHillClassificationName(id);
        }
        // -----Get the full hill classification name and pass it to the view---------------
        // ---Use the walking repository to get a list of all the hills in the specified classification----
        IQueryable<Hill> IQHillsInClassificaton;
      
        if ((OrderBy == "NameAsc")) {
            IQHillsInClassificaton = repository.GetHillsByClassification(id).OrderBy(hill =>hill.Hillname);
            ViewData["OrderBy"] = "Name";
            ViewData["OrderAscDesc"] = "Asc";
        }
        else if ((OrderBy == "NameDesc")) {
            IQHillsInClassificaton = repository.GetHillsByClassification(id).OrderByDescending(hill => hill.Hillname);
            ViewData["OrderBy"] = "Name";
            ViewData["OrderAscDesc"] = "Desc";
        }
        else if ((OrderBy == "MetresAsc")) {
            IQHillsInClassificaton = repository.GetHillsByClassification(id).OrderBy(hill => hill.Metres);
            ViewData["OrderBy"] = "Metres";
            ViewData["OrderAscDesc"] = "Asc";
        }
        else if ((OrderBy == "MetresDesc")) {
            IQHillsInClassificaton = repository.GetHillsByClassification(id).OrderByDescending(hill => hill.Metres);
            ViewData["OrderBy"] = "Metres";
            ViewData["OrderAscDesc"] = "Desc";
        }
        else if ((OrderBy == "FirstAscentDesc")) {
            IQHillsInClassificaton = repository.GetHillsByClassification(id).OrderByDescending(hill => hill.FirstClimbedDate);
            ViewData["OrderBy"] = "FirstAscent";
            ViewData["OrderAscDesc"] = "Desc";
        }
        else if ((OrderBy == "FirstAscentAsc")) {
            IQHillsInClassificaton = repository.GetHillsByClassification(id).OrderBy(hill => hill.FirstClimbedDate);
            ViewData["OrderBy"] = "FirstAscent";
            ViewData["OrderAscDesc"] = "Asc";
        }
        else if ((OrderBy == "NumberAscentDesc")) {
            IQHillsInClassificaton = repository.GetHillsByClassification(id).OrderByDescending(hill => hill.NumberOfAscents);
            ViewData["OrderBy"] = "NumberAscent";
            ViewData["OrderAscDesc"] = "Desc";
        }
        else if ((OrderBy == "NumberAscentAsc")) {
            IQHillsInClassificaton = repository.GetHillsByClassification(id).OrderBy(hill => hill.NumberOfAscents);
            ViewData["OrderBy"] = "NumberAscent";
            ViewData["OrderAscDesc"] = "Asc";
        }
        else {
            IQHillsInClassificaton = repository.GetHillsByClassification(id);
            ViewData["OrderBy"] = "Name";
            ViewData["OrderAscDesc"] = "Asc";
        }
        object iNumClimbed = IQHillsInClassificaton.Count(hill => hill.NumberOfAscents > 0);

        ViewData["NumberClimbed"] = iNumClimbed;

        int pageSize = Int32.Parse(WebConfigurationManager.AppSettings["PAGINATION_PAGE_SIZE"]);
        int maxPageLinks = Int32.Parse(WebConfigurationManager.AppSettings["PAGINATION_MAX_PAGE_LINKS"]);

        // ----Create a paginated list of hills----------------
        PaginatedListMVC<Hill> iqPaginatedHills = new PaginatedListMVC<Hill>(IQHillsInClassificaton, 
                                                                            page, 
                                                                            pageSize,
                                                                            Url.RouteUrl("Default", new { action="HillsInClassification", controller="Walks"}),
                                                                            maxPageLinks,
                                                                            "?OrderBy" + OrderBy); 
     
     
        // -----Pass the paginated list of hills to the view. The view expects a paginated list as its model-----
        return View(iqPaginatedHills);
    }


        // -------------------------------------------------------------------------------------
        //  Function: WalksByDate
        //  URL     : /Walks/WalksByDate/OrderBy/{page}
        //  Descr   : Return a list of walks by date, order as per the OrderBy parameter
        // --------------------------------------------------------------------------------------
        public ActionResult WalksByDate(string OrderBy, int page=1) {
            
            IOrderedQueryable<Walk> IQWalks;
   
            // ---Use the walking repository to get a list of all the walks----
            // ---Set up the ordering of the walks------
            if ((OrderBy == "DateAsc")) {
                IQWalks = repository.FindAllWalks().OrderBy(walk =>walk.WalkDate);
                ViewData["OrderBy"] = "Date";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "DateDesc")) {
                IQWalks = repository.FindAllWalks().OrderByDescending(walk =>walk.WalkDate);
                ViewData["OrderBy"] = "Date";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "TitleAsc")) {
                IQWalks = repository.FindAllWalks().OrderBy(walk =>walk.WalkTitle);
                ViewData["OrderBy"] = "Title";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "TitleDesc")) {
                IQWalks = repository.FindAllWalks().OrderByDescending(walk =>walk.WalkTitle);
                ViewData["OrderBy"] = "Title";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "AreaAsc")) {
                IQWalks = repository.FindAllWalks().OrderBy(walk =>walk.WalkAreaName);
                ViewData["OrderBy"] = "Area";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "AreaDesc")) {
                IQWalks = repository.FindAllWalks().OrderByDescending(walk =>walk.WalkAreaName);
                ViewData["OrderBy"] = "Area";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "LengthAsc")) {
                IQWalks = repository.FindAllWalks().OrderBy(walk =>walk.CartographicLength);
                ViewData["OrderBy"] = "Length";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "LengthDesc")) {
                IQWalks = repository.FindAllWalks().OrderByDescending(walk =>walk.CartographicLength);
                ViewData["OrderBy"] = "Length";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "AscentAsc")) {
                IQWalks = repository.FindAllWalks().OrderBy(walk =>walk.MetresOfAscent);
                ViewData["OrderBy"] = "Ascent";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "AscentDesc")) {
                IQWalks = repository.FindAllWalks().OrderByDescending(walk =>walk.MetresOfAscent);
                ViewData["OrderBy"] = "Ascent";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "TotalTimeAsc")) {
                IQWalks = repository.FindAllWalks().OrderBy(walk =>walk.WalkTotalTime);
                ViewData["OrderBy"] = "TotalTime";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "TotalTimeDesc")) {
                IQWalks = repository.FindAllWalks().OrderByDescending(walk =>walk.WalkTotalTime);
                ViewData["OrderBy"] = "TotalTime";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "MovAvgAsc")) {
                IQWalks = repository.FindAllWalks().OrderBy(walk =>walk.MovingAverageKmh);
                ViewData["OrderBy"] = "MovAvg";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "MovAvgDesc")) {
                IQWalks = repository.FindAllWalks().OrderByDescending(walk =>walk.MovingAverageKmh);
                ViewData["OrderBy"] = "MovAvg";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "OvlAvgAsc")) {
                IQWalks = repository.FindAllWalks().OrderBy(walk =>walk.WalkAverageSpeedKmh);
                ViewData["OrderBy"] = "OvlAvg";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "OvlAvgDesc")) {
                IQWalks = repository.FindAllWalks().OrderByDescending(walk =>walk.WalkAverageSpeedKmh);
                ViewData["OrderBy"] = "OvlAvg";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else {
                IQWalks = repository.FindAllWalks().OrderBy(walk =>walk.WalkDate);
                ViewData["OrderBy"] = "Date";
                ViewData["OrderAscDesc"] = "Desc";
            }

            int pageSize = Int32.Parse(WebConfigurationManager.AppSettings["PAGINATION_PAGE_SIZE"]);
            int maxPageLinks = Int32.Parse(WebConfigurationManager.AppSettings["PAGINATION_MAX_PAGE_LINKS"]);

            // ----Create a paginated list of the walks----------------
            PaginatedListMVC<Walk> IQPaginatedWalks = new PaginatedListMVC<Walk>(IQWalks, page, pageSize, Url.Action("WalksByDate", "Walks", new {OrderBy = ViewData["OrderBy"].ToString() + ViewData["OrderAscDesc"].ToString()}), maxPageLinks, "");

            // -----Pass the paginated list of walks to the view. The view expects a paginated list as its model-----
            return View(IQPaginatedWalks);
        }


        public ActionResult Details(int id)
        {
            Walk oWalk = this.repository.GetWalkDetails(id);
            string strTotalTime = WalkingStick.ConvertTotalTimeToString(oWalk.WalkTotalTime, false);

            ViewData["TotalTime"] = strTotalTime;
            ViewData["AT_WORK"] = WebConfigurationManager.AppSettings["atwork"];

            return this.View(oWalk);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Edit(int id)
        {
            Walk oWalk = this.repository.GetWalkDetails(id);
            var oAssociated_File_Types = this.repository.GetAssociatedFileTypes();
            var oAuxilliaryFiles = this.repository.GetWalkAuxilliaryFiles(id);

            var oWalkTypes = this.repository.GetWalkTypes();
            var oWalkMarkers = this.repository.GetMarkersCreatedOnWalk(id);

            ViewData["WalkTypes"] = new SelectList(oWalkTypes, "WalkTypeString", "WalkTypeString");
            ViewData["Associated_File_Types"] = new SelectList(oAssociated_File_Types, "Walk_AssociatedFile_Type1", "Walk_AssociatedFile_Type1");
            ViewData["Model"] = oWalk;
            ViewData["Auxilliary_Files"] = oAuxilliaryFiles.AsEnumerable();
            ViewData["WalkMarkersAlreadyCreated"] = oWalkMarkers;
            ViewData["AT_WORK"] = WebConfigurationManager.AppSettings["atwork"];

            return this.View(oWalk);
        }

        public ActionResult Create()
        {
            Walk oWalk = new Walk();
            var oAssociated_File_Types = this.repository.GetAssociatedFileTypes();
            var oWalkTypes = this.repository.GetWalkTypes();

            ViewData["WalkTypes"] = new SelectList(oWalkTypes, "WalkTypeString", "WalkTypeString");
            ViewData["Associated_File_Types"] = new SelectList(oAssociated_File_Types, "Walk_AssociatedFile_Type1", "Walk_AssociatedFile_Type1");
            ViewData["Model"] = oWalk;

            return this.View();

        }


        // -------------------------------------------------------------------------------------
        //  Function: Create  (POST)
        //  URL     : /Walks/Create
        //  Descr   : Create Walk form
        // --------------------------------------------------------------------------------------
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(Walk walk) 
        {

            //string strViewData = "";
            //var strKeys = Request.Form.AllKeys;

            int iWalkID;
            int iRetval = 0;

            List<HillAscent> arHillAscents;
            List<Walk_AssociatedFile> arAssociatedFiles;
           
            // ----This should really be done by a customised Model Binder-----------
            Walk oWalk = new Walk();
            WalkingStick.FillWalkFromFormVariables(ref oWalk, Request.Form);
            iWalkID = repository.AddWalk(oWalk);
            
            // ---Add hill ascents-----------------
            arHillAscents = WalkingStick.FillHillAscentsFromFormVariables(iWalkID, Request.Form);
            iRetval = repository.AddWalkSummitsVisited(arHillAscents);
          
            // ---Add the associated files-----
            arAssociatedFiles = WalkingStick.FillHillAssociatedFilesFromFormVariables(iWalkID, Request.Form, Server.MapPath("/"));
            iRetval = repository.AddWalkAssociatedFiles(arAssociatedFiles);
           
            // ---update any markers created by ajax call with walk id, and add any marker observations----------------
            iRetval = repository.AssociateMarkersWithWalk(Request.Form, iWalkID);
            if ((walk.HillAscents.Count > 0))
            {
                return RedirectToAction("HillsByArea", new { id = oWalk.Area.Arearef.Trim(), page = 1 });
            }

            return RedirectToAction("WalksByDate", new { OrderBy = "DateDesc" });
            
            // ---For dev to display form details-------
            // For Each item In strKeys
            //     strViewData = strViewData + "Key:" + item.ToString + " Value:" + Request.Form(item.ToString) + "<Br/>"
            // Next
            // ViewData("allthekeys") = strViewData
            // Return View("DisplayFormDetails")
        }


        // -----------------------------------------------------------------------------------------------------
        //  CreateMarker
        //  Server side of AJAX call, using JSON as data format, to insert a new marker.
        // -------------------------------------
        public JsonResult CreateMarker(string mtitle, string mdesc, string mdate, int mhillid=0, string mgps="" , int mwalkid=0)
        {
      
            var oNewMarker = new Marker();
            oNewMarker.MarkerTitle = mtitle;
            oNewMarker.Location_Description = mdesc;
            try
            {
                oNewMarker.DateLeft = DateTime.Parse((mdate + " 00:00:00"));
            }
            catch (Exception)
            {
                oNewMarker.DateLeft = DateTime.Now;
            }

            oNewMarker.GPS_Reference = mgps;
            if ((mhillid != 0))
            {
                oNewMarker.Hillnumber = (short)mhillid;
            }

            if ((mwalkid != 0))
            {
                oNewMarker.WalkID = mwalkid;
            }

            oNewMarker.Status = "Left - Not yet found again";
            repository.CreateMarker(oNewMarker);
            // ----Have to explicitly allow GET requests otherwise there is no callback------------------------

            return Json(new { markerid = oNewMarker.MarkerID }, JsonRequestBehavior.AllowGet);
        }


        // ------------------------------------------------------------------------------------------------
        //  MarkerSuggestions
        //  Used as the AJAX server side for an autocomplete function on a client side textbox
        // -----------------------
        public ActionResult MarkerSuggestions(string q, string imagenumber="") {
            
            var oSB = new StringBuilder();
        
            var IQMarkers = repository.FindMarkersByNameLike(q);
            
            foreach (Marker item in IQMarkers) {
                oSB.AppendLine((WalkingStick.FormatMarkerAsLine(item) + ("|" 
                                + (item.MarkerID.ToString().Trim() + ("|" + imagenumber)))));
            }
            ViewData["markernamesuggestions"] = oSB.ToString();
            return PartialView();
        }

        // ------------------------------------------------------------------------------------------------
        //  WalkSuggestions
        //  Used as the AJAX server side for an autocomplete function on a client side textbox
        // -----------------------
        public ActionResult WalkSuggestions(string q) 
        {
            var oSB = new StringBuilder();
            var IQWalks = repository.FindWalksByTitleLike(q);

            foreach (Walk item in IQWalks) 
            {
                oSB.AppendLine((WalkingStick.FormatWalkAsLine(item) + ("|" + item.WalkID.ToString().Trim())));
            }
            ViewData["walksuggestions"] = oSB.ToString();
            return PartialView();
        }

        // -------------------------------------------------------------------------------------
        //  Function: Edit  (POST)
        //  URL     : /Walks/Edit/Id
        //  Descr   : 1. Get the existing id into a walk object
        //            2. Based on the form variables, update the walk object and submit chnages
        // --------------------------------------------------------------------------------------
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Edit(int id, FormCollection formValues)
        {
            Walk oWalk = this.repository.GetWalkDetails(id);
            repository.UpdateWalkDetails(oWalk, Request.Form, Server.MapPath("/"));

            // ---update any markers created by ajax call with walk id, and add any marker observations----------------
            // iRetval = _repository.AssociateMarkersWithWalk(Request.Form, iWalkID)

            if ((oWalk.HillAscents.Count > 0))
            {
                return RedirectToAction("HillsByArea", new { id = oWalk.Area.Arearef.Trim(), page = 1 });
            }

            return RedirectToAction("WalksByDate", new { OrderBy = "DateDesc" });
        }


        public JsonResult CheckFileInWebrootJSON(string imagepath)
        {
            bool bIsInPath = imagepath.StartsWith(this.Server.MapPath("/"));

            var oRes = new { isinpath = bIsInPath.ToString() };

            return Json(oRes, JsonRequestBehavior.AllowGet);
        }

        public ActionResult WalkAreaSuggestions(string q, string options="")
        {
            var oSB = new StringBuilder();

            var IQWalkAreas = this.repository.FindWalkAreasByNameLike(q);

            foreach (Area item in IQWalkAreas)
            {
                oSB.AppendLine(WalkingStick.FormatWalkAreaAsLine(item) + "|" + item.Arearef);
            }

            ViewData["areanamesuggestions"] = oSB.ToString();

            return this.PartialView();
        }


        // ------------------------------------------------------------------------------------------------
        //  CheckImages
        //  Used as the AJAX server side to check that images are present in specified directory
        // -----------------------
        public JsonResult CheckImages(string imagepath, string options="") 
        {
       
            string strAtWork;
       
            strAtWork = WebConfigurationManager.AppSettings["atwork"];
            imagepath = imagepath.Replace("\\", "/");
            int iLoc;
            try {
                iLoc = imagepath.LastIndexOf("/");
            }
            catch (Exception) {
                iLoc = 0;
            }

            string strPath = "";
            try {
                strPath = imagepath.Substring(0, (iLoc - 0));
            }
                catch (Exception) {
            }

     
            string strRootPath = Server.MapPath("/").Replace("\\", "/");

            // -----Check that the path specified is valid------------------------
            if (!WalkingStick.DetermineIfDirectoryExists(strPath)) 
            {
                ViewData["checkresults"] = "{\"Error\" | \"Directory Not Found.\"}";
                return Json(new { Error = "Directory Not Found." },JsonRequestBehavior.AllowGet);
            }
            // ----Now check that images are found in this directory------------------
            var oResults = WalkingStick.CheckFilesInDirectory(strPath, imagepath.Substring((iLoc + 1), ((imagepath.Length - iLoc) 
                                - 1)), ref strRootPath, bool.Parse(strAtWork));
       
            return Json(oResults, JsonRequestBehavior.AllowGet);
        }


        public ActionResult HillSuggestions(string q, string areaid="")
        {
            StringBuilder oSB = new StringBuilder();

            IQueryable<Hill> IQHillsAboveHeight;

            if (areaid.Equals("") && areaid.Length <2)
            {
                IQHillsAboveHeight = this.repository.FindHillsByNameLike(q);
            }
            else
            {
                IQHillsAboveHeight = this.repository.FindHillsInAreaByNameLike(q, areaid);
            }

            foreach (Hill item in IQHillsAboveHeight)
            {
                oSB.AppendLine(WalkingStick.FormatHillSummaryAsLine(item) + "|" + item.Hillnumber.ToString());
            }

            ViewData["suggestions"] = oSB.ToString();

            return this.PartialView();
        }


    }
}
