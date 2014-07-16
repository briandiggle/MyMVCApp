using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MyMVCAppCS.Controllers
{
    using MyMVCApp.DAL;

    using MyMVCAppCS.Models;

    public class HillAscentController : Controller
    {
        private IWalkingRepository repository;

        private const int HILLASCENTS_PAGE_SIZE = 50;

        private const int MAX_PAGINATION_LINKS = 10;

        public HillAscentController()
        {
            this.repository = new SqlWalkingRepository();
        }

        //
        // GET: /HillAscent/

        public ActionResult Index(string OrderBy, int page= 1) 
        {
            IQueryable<HillAscent> iqHillAscents;

            // ---Use the walking repository to get a list of all the hill ascents----
            // ---Set up the ordering of the hill ascents------
            if ((OrderBy == "DateAsc")) 
            {
                iqHillAscents = repository.GetAllHillAscents().OrderBy(ascent =>ascent.AscentDate).ThenBy(ascent =>ascent.AscentID);
                ViewData["OrderAscDesc"] = "Asc";
                ViewData["OrderBy"] = "Date";
            }
            else if ((OrderBy == "DateDesc")) {
                iqHillAscents = repository.GetAllHillAscents().OrderByDescending(ascent =>ascent.AscentDate).ThenByDescending(ascent =>ascent.AscentID);
                ViewData["OrderBy"] = "Date";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "HillAsc")) {
                iqHillAscents = repository.GetAllHillAscents().OrderBy(ascent =>ascent.Hill.Hillname);
                ViewData["OrderBy"] = "Hill";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "HillDesc")) {
                iqHillAscents = repository.GetAllHillAscents().OrderByDescending(ascent =>ascent.Hill.Hillname);
                ViewData["OrderBy"] = "Hill";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "MetresAsc")) {
                iqHillAscents = repository.GetAllHillAscents().OrderBy(ascent =>ascent.Hill.Metres);
                ViewData["OrderBy"] = "Metres";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "MetresDesc")) {
                iqHillAscents = repository.GetAllHillAscents().OrderByDescending(ascent =>ascent.Hill.Metres);
                ViewData["OrderBy"] = "Metres";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else if ((OrderBy == "WalkAsc")) {
                iqHillAscents = repository.GetAllHillAscents().OrderBy(ascent =>ascent.Walk.WalkTitle);
                ViewData["OrderBy"] = "Walk";
                ViewData["OrderAscDesc"] = "Asc";
            }
            else if ((OrderBy == "WalkDesc")) {
                iqHillAscents = repository.GetAllHillAscents().OrderByDescending(ascent =>ascent.Walk.WalkTitle);
                ViewData["OrderBy"] = "Walk";
                ViewData["OrderAscDesc"] = "Desc";
            }
            else {
                // ----Default to order by date ascending----
                ViewData["OrderBy"] = "Date";
                ViewData["OrderAscDesc"] = "Asc";
                iqHillAscents = repository.GetAllHillAscents().OrderBy(ascent =>ascent.AscentDate).ThenBy(ascent =>ascent.AscentID);
            }
            // ----Create a paginated list of the walks----------------

            PaginatedListMVC<HillAscent> IQPaginatedAscents = new PaginatedListMVC<HillAscent>(iqHillAscents,page, HILLASCENTS_PAGE_SIZE, Url.Action("Index","HillAscent", new {OrderBy = ViewData["OrderBy"] + ViewData["OrderAscDesc"].ToString()}),MAX_PAGINATION_LINKS,"");
      
            return View(IQPaginatedAscents);
        }
    }
}
