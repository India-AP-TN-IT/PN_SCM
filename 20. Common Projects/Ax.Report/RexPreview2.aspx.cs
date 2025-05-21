using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.OleDb;
using System.IO;

public partial class rexpreview2 : System.Web.UI.Page
{
    string fileID = string.Empty;
    string test;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Params["ID"] != null) fileID = Request.Params["ID"];

        if (!string.IsNullOrEmpty(fileID))
        {
            // 이전 날짜 파일 삭제
            foreach (string files in System.IO.Directory.GetFiles(Server.MapPath("./"), "RXT_*.html", SearchOption.TopDirectoryOnly))
            {
                if (!System.IO.File.GetCreationTime(files).ToString("yyyy-MM-dd").Equals(DateTime.Now.ToString("yyyy-MM-dd")))
                    System.IO.File.Delete(files);
            }

            fileID = Server.UrlDecode(fileID);
            string source = Server.MapPath("./") + "rptFormFiles\\Viewer\\" + Server.UrlDecode(fileID).Replace("/", "\\") + ".html";
            string target = Server.MapPath("./") + "\\RXT_" + Path.GetFileName(source);

            System.IO.File.Copy(source, target, true);

            Response.Redirect("./RXT_" + Path.GetFileName(source));
        }
        else
        {
            this.Page.ClientScript.RegisterStartupScript(this.GetType(), "SystemError", "<script type=\"text/javascript\">\r\nalert('Error : " + "FileID is undefined \\n\\n- Ax.ReportServer -');\r\n</script>");
        }
    }
}
