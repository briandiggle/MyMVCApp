using System.Linq;
using System.Web.Mvc;

namespace MyMVCAppCS.Controllers
{
    using System;

    using MyMVCApp.DAL;

    using MyMVCAppCS.Models;

    public class MarkerController : Controller
    {
        private const int MARKERS_PAGE_SIZE = 50;

        private const int MAX_PAGINATION_LINKS = 10;

        private IWalkingRepository repository;

        public MarkerController()
        {
            this.repository = new SqlWalkingRepository();
        }

        //
        // GET: /Marker/

        public ActionResult Index(string OrderBy, int page=1) 
        {
            IQueryable<Marker> IQMarkers;
       
            // ---Use the walking repository to get a list of all the markers----
            // ---Set up the ordering of the markers------
            // -----Date Ordering-----------
            if ((OrderBy == "DateAsc")) {
                IQMarkers = repository.FindAllMarkers().OrderBy(marker =>marker.DateLeft).ThenBy(marker =>marker.MarkerTitle);
                ViewData["OrderBy"] = "Date";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "DateDesc")) {
                IQMarkers = repository.FindAllMarkers().OrderByDescending(marker =>marker.DateLeft).ThenByDescending(marker =>marker.MarkerTitle);
                ViewData["OrderBy"] = "Date";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "TitleAsc")) {
                IQMarkers = repository.FindAllMarkers().OrderBy(marker =>marker.MarkerTitle).ThenBy(marker =>marker.DateLeft);
                ViewData["OrderBy"] = "Title";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "TitleDesc")) {
                IQMarkers = repository.FindAllMarkers().OrderByDescending(marker =>marker.MarkerTitle).ThenByDescending(marker =>marker.DateLeft);
                ViewData["OrderBy"] = "Title";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "StatusAsc")) {
                IQMarkers = repository.FindAllMarkers().OrderBy(marker =>marker.Status).ThenBy(marker =>marker.DateLeft);
                ViewData["OrderBy"] = "Status";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "StatusDesc")) {
                IQMarkers = repository.FindAllMarkers().OrderByDescending(marker =>marker.Status).ThenByDescending(marker =>marker.DateLeft);
                ViewData["OrderBy"] = "Status";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "WalkAsc")) {
                IQMarkers = repository.FindAllMarkers().OrderBy(marker =>marker.Walk.WalkTitle).ThenBy(marker =>marker.DateLeft);
                ViewData["OrderBy"] = "Walk";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "WalkDesc")) {
                IQMarkers = repository.FindAllMarkers().OrderByDescending(marker =>marker.Walk.WalkTitle).ThenByDescending(marker =>marker.DateLeft);
                ViewData["OrderBy"] = "Walk";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "WalkAreaAsc"))
            {
                IQMarkers = repository.FindAllMarkers().OrderBy(marker => marker.Walk.Area.Areaname).ThenBy(marker => marker.DateLeft);
                ViewData["OrderBy"] = "WalkArea";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "WalkAreaDesc"))
            {
                IQMarkers = repository.FindAllMarkers().OrderByDescending(marker => marker.Walk.Area.Areaname).ThenByDescending(marker => marker.DateLeft);
                ViewData["OrderBy"] = "WalkArea";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else {
                // ----Default to order by date ascending----
                ViewData["OrderBy"] = "Date";
                ViewData["OrderAscDesc"] = "Desc";
                IQMarkers = repository.FindAllMarkers().OrderByDescending(marker =>marker.DateLeft).ThenByDescending(marker =>marker.MarkerTitle);
            }
            // ----Create a paginated list of the walks----------------
            PaginatedListMVC<Marker> IQPaginatedMarkers;

            IQPaginatedMarkers = new PaginatedListMVC<Marker>(IQMarkers, page, MARKERS_PAGE_SIZE, Url.Action("Index", "Marker", new {OrderBy= ViewData["OrderBy"].ToString() + ViewData["OrderAscDesc"].ToString()}), MAX_PAGINATION_LINKS, "");

            return View(IQPaginatedMarkers);
        }

        public ActionResult Create()
        {
            return this.View();
        } 

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            return this.View();
        }

        public ActionResult Details(int id)
        {
            ViewData["AT_WORK"] = System.Web.Configuration.WebConfigurationManager.AppSettings["atwork"];

            var oMarker = this.repository.GetMarkerDetails(id);

            return this.View(oMarker);
        }

        public ActionResult Edit(int id)
        {
            Marker oMarker;

            oMarker = this.repository.GetMarkerDetails(id);

            var markerStatii = this.repository.GetAllMarkerStatusOptions();

            ViewData["Marker_Status"] = markerStatii;

            return this.View(oMarker);
        }

        [HttpPost]
        public ActionResult Edit(int id, FormCollection formCollection)
        {
            try
            {
                Marker oMarker;
                oMarker = this.repository.GetMarkerDetails(id);
                this.repository.UpdateMarkerDetails(oMarker, Request.Form);

                return RedirectToAction("Index");
            }
            catch (Exception)
            {
                return this.View();
            }
        }

    }
}
