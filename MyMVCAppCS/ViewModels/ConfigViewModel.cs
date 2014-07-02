
namespace MyMVCAppCS.ViewModels
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Web.Mvc;

    using MyMVCApp.Model;

    public class ConfigViewModel
    {
        private readonly List<AtHomeOption> atWorkOptions;
 
        public ConfigViewModel()
        {
            atWorkOptions = new List<AtHomeOption>
                            {
                                new AtHomeOption { Id = WalkingConstants.AT_HOME, Name = WalkingConstants.AT_HOME },
                                new AtHomeOption { Id = WalkingConstants.AT_WORK, Name = WalkingConstants.AT_WORK }
                            };
            ConfigUpdateMessage = "";
        }

        [Display(Name = "At Home/ At Work")]
        public string AtWorkSetting { get; set; }

        public IEnumerable<SelectListItem> UsageLocationOptions
        {
            get
            {
                return new SelectList(atWorkOptions, "Id", "Name", SessionSingleton.Current.UsageLocation);
            }
        }

        public string ConfigUpdateMessage { get; set; }

    }

    public class AtHomeOption
    {
        public string Id {get; set;}
        public string Name { get; set; }
    }
}