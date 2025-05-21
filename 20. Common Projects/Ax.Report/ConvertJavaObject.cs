using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Xml;
using HE.Framework.Core.Report;
using HE.Framework.Core;
using Newtonsoft.Json;
using System.Text;

namespace Ax.Report
{
    public static class ConvertJavaObject
    {
        // .NET 외 타 어플리케이션에서 사용시 호환용
        public static HERexReport GetReport(string dataString)
        {
            // base64 decoding 후 압축을 해제하여 json 으로 반환
            string jsonString = Encoding.UTF8.GetString(HEGZipCompress.Decompress(Convert.FromBase64String(dataString)));

            Dictionary<string, object> json = JsonConvert.DeserializeObject<Dictionary<string, object>>(jsonString);

            string userId = json.ContainsKey("ReportUserID") ? json["ReportUserID"].ToString() : string.Empty;
            string userName = json.ContainsKey("ReportUserName") ? json["ReportUserName"].ToString() : string.Empty;

            // 리포트 개체 생성
            HERexReport report = new HERexReport(userId, userName, true);
            report.ReportName = json.ContainsKey("ReportName") ? json["ReportName"].ToString() : string.Empty;

            // 리포트 파일 처리
            if (json.ContainsKey("ReportFile")) report.ReportFileData = Convert.FromBase64String(json["ReportFile"].ToString());
          

            // 리포트 섹션 처리
            if (json.ContainsKey("ReportSection"))
            {
                // 다중 세션 반복
                
                //Dictionary<string, object> sectionList = json["ReportSection"] as Dictionary<string, object>;
                Dictionary<string, object> sectionList = JsonConvert.DeserializeObject<Dictionary<string, object>>(json["ReportSection"].ToString());

                foreach (KeyValuePair<string, object> section in sectionList)
                {
                    // 개별 섹션 처리
                    HERexSection xmlSection = new HERexSection();

                    //Dictionary<string, object> sectionItem = (Dictionary<string, object>)section.Value;
                    Dictionary<string, object> sectionItem = JsonConvert.DeserializeObject<Dictionary<string, object>>(section.Value.ToString());

                    // 리포트 파라메터 처리
                    if (sectionItem.ContainsKey("ReportParameter"))
                    {
                        //Dictionary<string, string> paramList = (Dictionary<string, string>)sectionItem["ReportParameter"];
                        Dictionary<string, string> paramList = JsonConvert.DeserializeObject<Dictionary<string, string>>(sectionItem["ReportParameter"].ToString());

                        if (xmlSection.ReportParameter == null) xmlSection.ReportParameter = new HEParameterSet();

                        foreach (KeyValuePair<string, string> param in paramList)
                            xmlSection.ReportParameter.Add(param.Key, param.Value);
                    }

                    // 개별 섹션의 리포트 데이터 처리
                    if (sectionItem.ContainsKey("ReportData"))
                    {
                        DataSet ds = new DataSet();

                        XmlReader xr = XmlReader.Create(new System.IO.StringReader(sectionItem["ReportData"].ToString()));
                        ds.ReadXml(xr, XmlReadMode.Auto);
                        ds.Tables[0].TableName = "DATA";

                        xmlSection.ReportType = HERexReportType.DataSet;
                        xmlSection.UserDataSet = ds;
                    }

                    report.Sections.Add(section.Key, xmlSection);
                }
            }

            return report;
        }
    }
}