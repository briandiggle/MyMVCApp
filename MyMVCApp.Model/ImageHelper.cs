
namespace MyMVCApp.Model
{
    using System.Drawing;
    using System.Text;
    using System.Web;

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
            oStringBuilder.Append(@"<img src=""" + imagePathFromAppRoot + @""" width=" + width + " height=" + height + " />");
            oStringBuilder.Append("</a>");

            return oStringBuilder.ToString();
        }
    }
}