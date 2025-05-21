using System;
using System.Collections.Generic;
using System.IO.Compression;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.IO;
using HE.Framework.Core.Report;
using TheOne.Configuration;

namespace Ax.EP.Utility
{
    /// <summary>
    /// AxReportForm
    /// </summary>
    public class AxReportForm
    {
        /// <summary>
        /// ShowReport ( RexPert 용 )
        /// </summary>
        /// <param name="report"></param>
        public static void ShowReport(HERexReport report)
        {
            ShowReport(report, false);
        }

        public static void ShowReport(HERexReport report, bool directPDF)
        {
            if (report.ReportFileTransfer && (report.ReportFileData == null || report.ReportFileData.Length == 0))
            {
                string rptFileFullPath = System.Web.HttpContext.Current.Server.MapPath("/") + "/Report/" + report.ReportName + ".reb";
                byte[] buffer = null;

                if (System.IO.File.Exists(rptFileFullPath))
                {
                    // 리포트파일 서버 전송모드일 경우 파일을 읽어서 Binary 에 담는다.
                    using (FileStream rptFormFile = new FileStream(rptFileFullPath, FileMode.Open, FileAccess.Read))
                    {
                        buffer = new byte[rptFormFile.Length];
                        rptFormFile.Read(buffer, 0, buffer.Length);
                        rptFormFile.Close();
                    }

                    report.ReportFileData = buffer;
                }
            }

            BasePage page = System.Web.HttpContext.Current.Handler as BasePage;
            string locale = (page != null ? page.GlobalLocale : "ko-KR");
            string mode = ((page != null ? page.IsMobilePage : false) ? "PDF" : "REX");
            if (directPDF) mode = "PDF";

            string key = HERexReport.Key;
            string value = HERexReport.SerializeToString(report);

            string reportUrl = AppSectionFactory.AppSection["REPORT_URL"];// +"?type=PDF&locale=" + locale;
            string header = "Content-Type: application/x-www-form-urlencoded\r\n";

            Ext.Net.X.Js.Call("ShowReport", TheOne.Security.UserInfoContext.Current.UserID, reportUrl, header, key, value, locale, mode);
        }
    }
}
