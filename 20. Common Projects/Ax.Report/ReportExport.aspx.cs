using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Principal;
using System.Diagnostics;
using System.Windows.Forms;

namespace Ax.Report
{
    public partial class ReportExport : System.Web.UI.Page
    {
        string exportType = string.Empty;
        string exportData = string.Empty;
        string exportLocale = string.Empty;
        string exportName = string.Empty;
        string exportPath = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            // rdy 가 없거나 0 이면 리포트 생성
            if (string.IsNullOrEmpty(Request["rdy"]) || Request["rdy"].ToString().Equals("0"))
            {
                exportType = (string.IsNullOrEmpty(Request.Params["expottype"]) ? "pdf" : Request.Params["expottype"]);
                exportLocale = (string.IsNullOrEmpty(Request.Params["exportLocale"]) ? "ko-KR" : Request.Params["exportLocale"]);
                exportPath = Server.MapPath("./") + "rptFormFiles\\Temp\\Export\\";
                exportName = (string.IsNullOrEmpty(Request.Params["exportname"]) ? Guid.NewGuid().ToString() : Request.Params["exportname"]);
                exportName = exportName.Substring(exportName.LastIndexOf("/") + 1) + "." + exportType;
                exportData = (string.IsNullOrEmpty(Request.Params["exportdata"]) ? string.Empty : Request.Params["exportdata"]);

                System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(exportLocale);
                System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(exportLocale);

                // 이전 날짜 파일 삭제
                if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(exportPath)))
                    System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(exportPath));

                foreach (string files in System.IO.Directory.GetFiles(exportPath))
                {
                    if (!System.IO.File.GetCreationTime(files).ToString("yyyy-MM-dd").Equals(DateTime.Now.ToString("yyyy-MM-dd")))
                        System.IO.File.Delete(files);
                }

                byte[] encodeByte = System.Convert.FromBase64String(exportData);
                exportData = Server.UrlDecode(System.Text.Encoding.UTF8.GetString(encodeByte));

                if (string.IsNullOrEmpty(exportData))
                {
                    this.Page.ClientScript.RegisterStartupScript(this.GetType(), "FailReport", "<script type=\"text/javascript\">\r\nalert('Error : Not Exists OOF Data!\\n\\n- Ax.ReportServer -');\r\n</script>");
                }
                else
                {
                    Response.Flush();

                    Process p = new Process();
                    p.StartInfo.FileName = Server.MapPath("./") + "bin\\Ax.ReportExporter.exe";

                    p.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    p.StartInfo.CreateNoWindow = true;

                    string args1 = System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(exportType), Base64FormattingOptions.None);
                    string args2 = System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(exportLocale), Base64FormattingOptions.None);
                    string args3 = System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(exportName), Base64FormattingOptions.None);
                    string args4 = System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(exportPath), Base64FormattingOptions.None);
                    string args5 = System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(exportData), Base64FormattingOptions.None);

                    //p.StartInfo.Arguments = String.Format("{0} {1} {2} {3} {4}", args1, args2, args3, args4, args5);

                    // 파라메터 처리 방식을 파일로 변경   by 2018.11.15 김건우
                    string argsFile = exportPath + exportName.Replace(".pdf", "") + "_args.txt";
                    string argsData = String.Format("{0}\t{1}\t{2}\t{3}\t{4}", args1, args2, args3, args4, args5);
                    System.IO.File.WriteAllText(argsFile, argsData);
                    p.StartInfo.Arguments = System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(argsFile), Base64FormattingOptions.None);

                    if (p.Start())
                    {
                        p.WaitForExit();

                        //System.IO.FileInfo fi = new System.IO.FileInfo(exportPath + exportName);
                        //string fileLenth = fi.Length.ToString().Trim();

                        //Response.Clear();
                        //Response.ContentType = "application/pdf";
                        //Response.AddHeader("Content-Disposition", "filename=\"" + Server.UrlPathEncode(exportName) + "\"");
                        //Response.AddHeader("Content-Length", fileLenth);
                        //Response.WriteFile(exportPath + exportName);

                        string filePath = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(exportPath));
                        string fileName = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(exportName));
                        string fileUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("./ReportExport.aspx?Path=" + filePath + "&Name="+ fileName + "&Rdy=1"));
                        //Response.Write("<script language='text/script'>PDFShow('" + fileUrl + "');</script>");
                        this.Page.ClientScript.RegisterStartupScript(this.GetType(), "GoReport", "<script type='text/javascript'>PDFShow('" + fileUrl + "');</script>");
                        //scriptBlock.Text = "<script type='text/javascript'>PDFShow('" + fileUrl + "');</script>";
                        Response.Flush();
                    }
                }
            }
            else
            {
                exportPath = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(Request.Params["Path"].ToString()));
                exportName = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(Request.Params["Name"].ToString()));

                System.IO.FileInfo fi = new System.IO.FileInfo(exportPath + exportName);
                string fileLenth = fi.Length.ToString().Trim();

                // rdy 값이 1이라면 export 실시
                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", "filename=\"" + Server.UrlPathEncode(exportName) + "\"");
                Response.AddHeader("Content-Length", fileLenth);
                Response.WriteFile(exportPath + exportName);
                Response.Flush();
            }
        }
    }
}

