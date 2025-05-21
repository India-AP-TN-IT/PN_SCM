#region ▶ Description & History
/* 
 * 프로그램명 : ALC 투입실적    [D2](구.VA3010)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-27
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
 *				
 *
 * 
*/
#endregion
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ax.EP.Utility;
using HE.Framework.Core;
using System.Data;
using System.Collections;
using System.IO;
using System.Security.Principal;
using System.Xml;
using System.Diagnostics;

namespace Ax.SRM.WP
{
    public partial class ALC_Receiver : System.Web.UI.Page
    {
        private string pakageName = "APG_SRM_ALC30003";
        private int _DASICNT = 2;

        /// <summary>
        /// SRM_ALC30002
        /// </summary>
        public ALC_Receiver()
        {
            //// 협력업체 수신코드 샘플 (C# .Net 기준)
            //System.Net.WebClient client = new System.Net.WebClient();
            //client.Encoding = Encoding.UTF8;
            //string xmlResult = client.DownloadString(@"http://scm.seoyoneh.sk/alc_receiver.aspx?vendcd=100023&division=online&plant=7&line=1");

            //System.Xml.XmlDocument xml = new System.Xml.XmlDocument();
            //xml.LoadXml(xmlResult);

            //System.Xml.XmlNodeList xnList = xml.SelectNodes("/DATASET/RECORD");
            //foreach (System.Xml.XmlNode xn in xnList)
            //{
            //    string TSEQ = xn["TSEQ"].InnerText;
            //    string VID = xn["VID"].InnerText;
            //    string ORDNO = xn["ORDNO"].InnerText;
            //    string DRV = xn["DRV"].InnerText;
            //    string LINE = xn["LINE"].InnerText;
            //    string LSEQ = xn["LSEQ"].InnerText;
            //    string FIELD_NM1 = xn["FIELD_NM1"].InnerText;
            //    string FIELD_NM2 = xn["FIELD_NM2"].InnerText;
            //    string YMD = xn["YMD"].InnerText;
            //    string TIME = xn["TIME"].InnerText;
            //    string COUNT = xn["COUNT"].InnerText;

            //    Console.WriteLine(
            //            string.Format("TSEQ={0}  VID={1}  ORDNO={2}  DRV={3}  LINE={4}  LSEQ={5}  FIELD_NM1={6}  FIELD_NM2={7}  YMD={8}  TIME={9}  COUNT={10}",
            //                          TSEQ, VID, ORDNO, DRV, LINE, LSEQ, FIELD_NM1, FIELD_NM2, YMD, TIME, COUNT))
            //    ;
            //}
        }

        /// <summary>
        /// Page_Load
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string vendcd = Request.Params["VENDCD"];
                string division = Request.Params["DIVISION"];
                string plant = Request.Params["PLANT"];
                string line = Request.Params["LINE"];
                string ymd = Request.Params["YMD"];
                string chasu = Request.Params["CHASU"];

                if (string.IsNullOrEmpty(vendcd)) throw new Exception("Vendcd parameter is empty.");

                if (string.IsNullOrEmpty(division)) division = "ON-LINE";
                if (string.IsNullOrEmpty(plant)) plant = "1";
                if (string.IsNullOrEmpty(line)) line = "1";
                if (string.IsNullOrEmpty(ymd)) ymd = DateTime.Now.ToString("yyyyMMdd");

                division = division.ToUpper();
                if (division.Equals("ONLINE")) division = "ON-LINE";

                //if (division.Equals("ON-LINE")) ymd = (DateTime.Now.Hour < 6) ? DateTime.Now.AddDays(-1).ToString("yyyyMMdd") : DateTime.Now.ToString("yyyyMMdd");
                //03시~09시 사이에 오늘일자로 LSEQ = 1이 존재할때 까지 하루전 날짜로 표시
                if (division.Equals("ON-LINE"))
                {
                    int hour = 0;
                    hour = DateTime.Now.Hour;
                    if (hour > 3 && hour < 9)
                    {
                        DataSet ds2 = new DataSet();

                        HEParameterSet set2 = new HEParameterSet();
                        set2.Add("CORCD", Util.UserInfo.CorporationCode);
                        set2.Add("BIZCD", Util.UserInfo.BusinessCode);
                        set2.Add("YMD", DateTime.Now.ToString("yyyyMMdd"));
                        set2.Add("PLANT_GB", plant);
                        set2.Add("LINE_GB", line);
                        set2.Add("USER_ID", Util.UserInfo.UserID);
                        set2.Add("LANG_SET", Util.UserInfo.LanguageShort);

                        ds2 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_INIT_DATE"), set2);

                        if (ds2.Tables[0].Rows.Count > 0)
                        {
                            if (ds2.Tables[0].Rows[0]["CNT"].ToString().Equals("0"))
                            {
                                ymd = DateTime.Now.AddDays(-1).ToString("yyyyMMdd");
                            }
                            else
                            {
                                ymd = DateTime.Now.ToString("yyyyMMdd");
                            }
                        }
                    }
                    else if (hour <= 3)
                        ymd = DateTime.Now.AddDays(-1).ToString("yyyyMMdd");
                    else
                        ymd = DateTime.Now.ToString("yyyyMMdd");
                }

                if (division.Equals("BATCH") && string.IsNullOrEmpty(chasu)) chasu = "1";

                HEParameterSet set = new HEParameterSet();
                set.Add("CORCD", "8");
                set.Add("BIZCD", "8");
                set.Add("VEND_CD", vendcd);
                set.Add("PLANT_GB", plant);
                set.Add("LINE_GB", line);
                set.Add("USER_ID", vendcd);
                set.Add("LANG_SET", "KO");

                DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ITEMCHASU"), set);

                string filednm1 = "ITEM";
                string filednm2 = "ITEM";
                string chasu_qty = string.Empty;

                if (ds.Tables[0].Rows.Count > 0)
                {
                    filednm1 = ds.Tables[0].Rows[0]["FIELD_NM1"].ToString();
                    filednm2 = ds.Tables[0].Rows[0]["FIELD_NM2"].ToString();
                    chasu_qty = ds.Tables[0].Rows[0]["CHASU_QTY"].ToString();

                    filednm1 = string.IsNullOrEmpty(filednm1) ? "ITEM" : filednm1;
                    filednm2 = string.IsNullOrEmpty(filednm2) ? "ITEM" : filednm2;

                    string LASTLSEQ = "";

                    //최종 LSEQ를 알아냄.
                    if (division.Equals("ON-LINE")) //온라인일 경우 출력하기 위한 차수를 넣어놓는다.
                    {
                        HEParameterSet set02 = new HEParameterSet();
                        set02.Add("CORCD", "8");
                        set02.Add("BIZCD", "8");
                        set02.Add("PLANT", plant);
                        set02.Add("LINE", line);
                        set02.Add("YMD", ymd);
                        set02.Add("USER_ID", vendcd);
                        set02.Add("LANG_SET", "KO");

                        DataSet ds02 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_MAX_LSEQ"), set02);

                        if (ds02.Tables[0].Rows.Count > 0)
                        {
                            LASTLSEQ = ds02.Tables[0].Rows[0]["LSEQ"].ToString();

                            chasu = Math.Ceiling(Convert.ToDecimal(Convert.ToDecimal(LASTLSEQ) / (!plant.Equals("7") ? Convert.ToDecimal(chasu_qty) : Convert.ToDecimal(chasu_qty) * _DASICNT))).ToString();
                            if (Convert.ToInt64(LASTLSEQ) < Convert.ToInt64(chasu_qty))
                            {
                                chasu = "1";
                            }
                            else
                            {
                                if (chasu.IndexOf('.') >= 0)
                                    chasu = chasu.Substring(Convert.ToInt32(chasu), Convert.ToInt32(chasu.IndexOf('.') - 1)) + 1;
                            }
                        }
                    }
                }

                HEParameterSet param = new HEParameterSet();

                param.Add("CORCD", "8");
                param.Add("BIZCD", "8");
                param.Add("CHASU_QTY", chasu_qty);
                param.Add("CHASU", chasu);
                param.Add("DASICNT", _DASICNT);
                param.Add("FIELD_NM1", filednm1);
                param.Add("FIELD_NM2", filednm2);
                param.Add("PLANT_GB", plant);
                param.Add("LINE_GB", line);
                param.Add("YMD", ymd);
                param.Add("DIVISION", division);
                param.Add("USER_ID", vendcd);
                param.Add("LANG_SET", "KO");
                DataSet ds03 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_FILE"), param);

                string tmpFileName = DateTime.Now.Ticks.ToString();
                tmpFileName = "c:\\Temp\\" + tmpFileName + ".xml";

                ds03.DataSetName = "DATASET";
                ds03.Tables[0].TableName = "RECORD";
                ds03.Tables[0].WriteXml(tmpFileName, XmlWriteMode.WriteSchema);

                Response.Clear();
                Response.ContentType = "text/xml"; // "Application/Octet-Stream"
                Response.AddHeader("Content-Disposition", "filename=ALC.xml");
                Response.AddHeader("Content-Length", new System.IO.FileInfo(tmpFileName).Length.ToString());
                Response.Charset = "UTF-8";
                Response.WriteFile(tmpFileName);
                Response.Flush();

                if (File.Exists(tmpFileName)) File.Delete(tmpFileName);
            }
            catch(Exception ex)
            {
                Response.Write(ex.ToString().Replace("\r\n", "<br/>").Replace("\n\r", "<br/>").Replace("\r", "<br/>").Replace("\n", "<br/>"));
            }
            finally
            {
            }
        }
    }
}
