using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using HE.Framework.Core.Report;
using HE.Framework.ServiceModel;
using HE.Framework.Core;
using HE.Framework.Core.Security;
using System.Windows.Forms;

namespace Ax.Report
{
    public partial class ReportViewer : System.Web.UI.Page
    {
        private string locale = "ko-KR";
        private string mode = "REX";
        private string open = "POPUP";
        private string fileID = string.Empty;
        HERexReport report = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            // HERexReport.Key = __REPORT_KEY;            // C#
            // HERexReport.Key = __REPORT_KEY_JAVA;       // JAVA
            try
            {
                if (Request.Params["locale"] != null) locale = Request.Params["locale"];
                if (Request.Params["mode"] != null) mode = Request.Params["mode"];
                if (Request.Params["open"] != null) open = Request.Params["open"];

                if (Request.Params[HERexReport.Key] == null && Request.Params[HERexReport.Key+"_JAVA"] == null) throw new Exception("Not Exists Request Data!");

                // 요청정보를 문자열로 부터 개체화 한다.
                if (Request.Params[HERexReport.Key] != null)
                {
                    string dataString = Request.Params[HERexReport.Key].Replace(" ", "+");
                    report = HERexReport.DeserializeFromString(dataString);
                }
                else
                {
                    // JAVA 용이라면 Json 값을 DeSeriables 하여 직접 Report 객체 생성
                    string dataString = Request.Params[HERexReport.Key+"_JAVA"].Replace(" ", "+");
                    report = ConvertJavaObject.GetReport(dataString);
                }

                if (report != null)
                {
                    // 페이지 인증처리를 수행한다.
                    HEUserInfoContext ctx = new HEUserInfoContext(report.ReportUserID, report.ReportUserName, "", "");
                    ctx.SetCallContext();
                    ctx.SetThreadPrincipal();

                    // 리포트 파일이 내장되어 전송될경우 임시파일을 생성한다.
                    if (report.ReportFileTransfer)
                    {
                        // 이전 날짜 파일 삭제
                        if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(Server.MapPath("./") + "/rptFormFiles/Temp/" + report.ReportName)))
                            System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(Server.MapPath("./") + "/rptFormFiles/Temp/" + report.ReportName));

                        foreach (string files in System.IO.Directory.GetFiles(System.IO.Path.GetDirectoryName(Server.MapPath("./") + "/rptFormFiles/Temp/" + report.ReportName)))
                        {
                            if (!System.IO.File.GetCreationTime(files).ToString("yyyy-MM-dd").Equals(DateTime.Now.ToString("yyyy-MM-dd")))
                                System.IO.File.Delete(files);
                        }

                        // 리포트 파일전송모드이나 실제 바이너리 파일이 없으면 오류 처리
                        if (report.ReportFileData == null || report.ReportFileData.Length == 0)
                            throw new Exception("Not Exists ReportFileData!\nBinary : " + report.ReportName);

                        // 파일이름 재설정
                        report.ReportName = "Temp/" + report.ReportName + "_" + report.ReportUserID + "_" + Guid.NewGuid();

                        // ReportFileData 를 가져와서 Stream 을 기록
                        FileStream rptFormFile = new FileStream(Server.MapPath("./") + "/rptFormFiles/" + report.ReportName + ".reb", FileMode.Create);
                        rptFormFile.Write(report.ReportFileData, 0, report.ReportFileData.Length);
                        rptFormFile.Close();
                    }

                    RenderViewer(report);
                }
            }
            catch (Exception ex)
            {
                this.Page.ClientScript.RegisterStartupScript(this.GetType(), "SystemError", "<script type=\"text/javascript\">\r\nalert('Error : " + ex.ToString().Replace("\\", "\\\\").Replace("\r", "\\r").Replace("\n", "\\n").Replace("'", "\\'").Replace("\t", "\\t") + "\\n\\n- Ax.ReportServer -');\r\n</script>");
            }
            finally
            { 
            }
        }

        private void RenderViewer(HERexReport report)
        {
            // 요청 URL 처리
            string callUrl = Page.Request.Url.ToString();
            if (callUrl.LastIndexOf('/') >= 0) callUrl = callUrl.Substring(0, callUrl.LastIndexOf('/'));

            // 뷰어 패치전 임시 처리 SSL 미적용 ( 2015.09.10)  -  409 버전에서 해결완료 됨
            //callUrl = callUrl.ToLower().Replace("https://", "http://");

            // 리포트 렌더 스크립트 생성
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.AppendLine("<script type=\"text/javascript\">");
            sb.AppendFormat("\tvar rptMode=\"{0}\"; \r\n", this.mode);
            sb.AppendFormat("\tvar rptLocale=\"{0}\"; \r\n", this.locale);
            sb.AppendFormat("\tvar rptOpen=\"{0}\"; \r\n", this.open);
            sb.AppendLine("function callFunc()\r\n{");
            sb.AppendLine("\tvar oReport = GetfnParamSet();");
            sb.AppendFormat("\toReport.param(\"{0}\").value = \"{1}\"; \r\n", "ReportUserID", report.ReportUserID);
            sb.AppendFormat("\toReport.param(\"{0}\").value = \"{1}\"; \r\n", "ReportUserName", report.ReportUserName);
            sb.AppendFormat("\toReport.rptname = \"{0}\"; \r\n", report.ReportName);
            sb.AppendLine("\toReport.type = \"file\";");
            sb.AppendLine("\toReport.datatype = \"xml\";");

            // 리포트 다중 섹션 처리
            foreach (KeyValuePair<string, HERexSection> item in report.Sections)
            {
                string division = (item.Key.ToUpper().Equals("MAIN") ? "" : ".sub(\"" + item.Key + "\")");

                // 리포트 타입 설정
                if (!item.Key.ToUpper().Equals("MAIN"))
                {
                    sb.AppendFormat("\r\n\toReport{0}.type = \"file\";\r\n", division);
                    sb.AppendFormat("\toReport{0}.datatype = \"xml\";\r\n", division);
                }

                // XML Url 파일이라면
                if (item.Value.ReportType == HERexReportType.XML)
                {
                    sb.AppendFormat("\toReport{0}.path = \"{1}\"; \r\n", division, item.Value.UserXmlUrl);
                }
                else
                {
                    // 이전 날짜 파일 삭제
                    if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(Server.MapPath("./") + "/rptXMLTemp/")))
                        System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(Server.MapPath("./") + "/rptXMLTemp/"));

                    foreach (string files in System.IO.Directory.GetFiles(Server.MapPath("./") + "/rptXMLTemp/"))
                    {
                        if (!System.IO.File.GetCreationTime(files).ToString("yyyy-MM-dd").Equals(DateTime.Now.ToString("yyyy-MM-dd")))
                            System.IO.File.Delete(files);
                    }

                    // 파일이름 설정
                    string rptName = report.ReportName + (item.Key.ToUpper().Equals("MAIN") ? "" : "_" + item.Key);
                    string xmlFile = rptName + "_" + report.ReportUserID + "_" + Guid.NewGuid() + ".xml";

                    if (xmlFile.LastIndexOf('/') >= 0) xmlFile = xmlFile.Substring(xmlFile.LastIndexOf('/') + 1);

                    // DB파라메터 또는 DataSet이 있을때만 처리하도록 한다.
                    if ((item.Value.ReportType == HERexReportType.DB && !string.IsNullOrEmpty(item.Value.DBProcedure)) || (item.Value.ReportType == HERexReportType.DataSet && item.Value.UserDataSet != null && item.Value.UserDataSet.Tables.Count > 0))
                    {
                        DataSet source = null;

                        if (item.Value.ReportType == HERexReportType.DB)
                        {
                            // DB Type 일때 DB Procedure 및 DB Parameter 을 이용하여 DB 웹서비스 호출 및 데이터 가져오기
                            HEParameterSet paramSet = new HEParameterSet();
                            if (item.Value.DBParameter != null)
                                foreach (string paramName in item.Value.DBParameter.Keys) paramSet.Add(paramName, item.Value.DBParameter[paramName]);

                            using (HEClientProxy _WSCOM = new HEClientProxy())
                            {
                                source = _WSCOM.ExecuteDataSet(item.Value.DBProcedure, paramSet);       // WCF 호출
                            }
                        }
                        else
                        {
                            // Dataset 모드일경우 요청받은 Dataset 을 가져오기
                            source = item.Value.UserDataSet;                                        // 사용자 DataSet 지정
                        }

                        // XML 파일 생성 및 Report Render 파라메터 생성
                        source.Tables[0].TableName = "DATA";
                        source.Tables[0].WriteXml(Server.MapPath("./") + "/rptXMLTemp/" + xmlFile, XmlWriteMode.WriteSchema);

                        sb.AppendFormat("\toReport{0}.path = \"{1}/rptXMLTemp/{2}\"; \r\n", division, callUrl, xmlFile);
                    }
                }

                // 리포트 Param 처리
                if (item.Value.ReportParameter != null)
                {
                    foreach (string paramName in item.Value.ReportParameter.Keys)
                    {
                        string str = item.Value.ReportParameter[paramName].ToString().Replace("\\r","\r").Replace("\\n","\n").Replace("\r","\\r").Replace("\n","\\n");

                        sb.AppendFormat("\toReport{0}.param(\"{1}\").value = \"{2}\"; \r\n", division, paramName, str);
                    }
                }
            }

            // Report Render 실행 스크립트
            if (this.open.ToUpper().Trim().Equals("SELF"))
                sb.AppendLine("\r\n\toReport.iframe(document.getElementById(\"rptViewer\"));");
            else
                sb.AppendLine("\r\n\toReport.open();");
            
            sb.AppendLine("}\r\n\r\n");
            sb.AppendLine("callFunc();");
            sb.AppendLine("</script>");

            // 리포트 파일 존재 유무에 따라서 Render 할지 또는 오류메세지 출력할지 체크
            if (System.IO.File.Exists(Server.MapPath("./") + "/rptFormFiles/" + report.ReportName + ".reb"))
                this.Page.ClientScript.RegisterStartupScript(this.GetType(), "CallReport", sb.ToString());
            else
                this.Page.ClientScript.RegisterStartupScript(this.GetType(), "FailReport", "<script type=\"text/javascript\">\r\nalert('Error : Not Exists ReportForm File!\\nFile : " + report.ReportName + "\\n\\n- Ax.ReportServer -');\r\n</script>");
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (open.ToUpper().Equals("SELF"))
            {
                // 이전 날짜 파일 삭제
                if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(Server.MapPath("./") + "/rptFormFiles/Viewer/" + report.ReportName.Replace("Temp/", string.Empty))))
                    System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(Server.MapPath("./") + "/rptFormFiles/Viewer/" + report.ReportName.Replace("Temp/", string.Empty)));

                foreach (string files in System.IO.Directory.GetFiles(System.IO.Path.GetDirectoryName(Server.MapPath("./") + "/rptFormFiles/Viewer/" + report.ReportName.Replace("Temp/", string.Empty))))
                {
                    if (!System.IO.File.GetCreationTime(files).ToString("yyyy-MM-dd").Equals(DateTime.Now.ToString("yyyy-MM-dd")))
                        System.IO.File.Delete(files);
                }

                string fileID = report.ReportName.Replace("Temp/", string.Empty);
		        StringWriter strWriter = new StringWriter();
		        HtmlTextWriter htmlWriter = new HtmlTextWriter( strWriter );
		        base.Render( htmlWriter );
		        string contents = htmlWriter.InnerWriter.ToString();

                System.IO.File.WriteAllText(Server.MapPath("./") + "/rptFormFiles/Viewer/" + fileID + ".html", contents, System.Text.Encoding.UTF8);
                writer.WriteEncodedUrl(fileID);
            }
            else
            {
                base.Render(writer);
            }
        }
    }
}