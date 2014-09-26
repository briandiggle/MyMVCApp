
namespace MyMVCApp.Model
{
    using System;
    using System.Drawing;
    using System.IO;
    using System.Text;
    using System.Web;

    public static class ImageHelper
    {
        public static string BuildImgTag(string imagePathFromAppRoot)
        {
           
            string imagePath = HttpRuntime.AppDomainAppPath + imagePathFromAppRoot.Substring(1, imagePathFromAppRoot.Length - 1).Replace(@"/",@"\");
            Image imageToResize;
            // Create image.
            try
            {
                 imageToResize = Image.FromFile(imagePath);
            }
            catch (FileNotFoundException)
            {
                return "Could not find image at [" + imagePath + "]";
            }
         

            int width = imageToResize.Width/ 8;
            int height = imageToResize.Height/ 8;

            var oStringBuilder = new StringBuilder();

            oStringBuilder.Append(@"<a href=""" + imagePathFromAppRoot + @""">");
            oStringBuilder.Append(@"<img src=""" + imagePathFromAppRoot + @""" width=" + width + " height=" + height + " />");
            oStringBuilder.Append("</a>");

            return oStringBuilder.ToString();
        }
    }
}