using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MyMVCAppCS.Models
{
    using System.Drawing;
    using System.IO;
    using System.Text;
 
    public static class ImageHelper
    {
        public static string BuildImgTag(string imagePathFromAppRoot)
        {
           
            string imagePath = HttpRuntime.AppDomainAppPath + imagePathFromAppRoot.Substring(1, imagePathFromAppRoot.Length - 1).Replace(@"/",@"\");

            // Create image.
            Image image = Image.FromFile(imagePath);

            int width = image.Width/ 8;
            int height = image.Height/ 8;

            var oStringBuilder = new StringBuilder();

            oStringBuilder.Append(@"<a href=""" + imagePathFromAppRoot + @""">");
            oStringBuilder.Append(@"<img src=""" + imagePathFromAppRoot + @""" width=" + width.ToString() + " height=" + height.ToString() + " />");
            oStringBuilder.Append("</a>");

            return oStringBuilder.ToString();
        }
    }
}