using System.Web.Mvc;

namespace MyMVCAppCS.Controllers
{
    using MyMVCAppCS.ViewModels;

    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "None")]
    [HandleError]
    public class ConfigController : Controller
    {

        public ActionResult Index()
        {
            var configViewModel = new ConfigViewModel();
            return View(configViewModel);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Index(ConfigViewModel configModel)
        {
            SessionSingleton.Current.UsageLocation = configModel.AtWorkSetting;

            configModel.ConfigUpdateMessage = "Usage Location has been updated to [" + configModel.AtWorkSetting + "]";

            return View(configModel);
        }
    }
}
