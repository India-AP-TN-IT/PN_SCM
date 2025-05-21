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

namespace Ax.SRM.WP.Service
{
    public partial class WEBSRV_INQUERY_MM1060 : System.Web.UI.Page
    {
        private string pakageName = "APG_SRM_WEBSERVICE";

        /// <summary>
        /// SRM_WEBSERVICE
        /// </summary>
        public WEBSRV_INQUERY_MM1060()
        {
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
                string CORCD = Request.Params["CORCD"];
                string BIZCD = Request.Params["BIZCD"];
                string VENDCD = Request.Params["VENDCD"];
                string INPUT_DATE = Request.Params["INPUT_DATE"];
                string VINCD = Request.Params["VINCD"];
                string MAT_ITEM = Request.Params["MAT_ITEM"];
                string INSTALL_POS = Request.Params["INSTALL_POS"];

                if (string.IsNullOrEmpty(CORCD) || string.IsNullOrEmpty(CORCD) ||
                    string.IsNullOrEmpty(VENDCD) || string.IsNullOrEmpty(INPUT_DATE)) 
                    throw new Exception("CORCD or BIZCD or VENDCD or INPUT_DATE parameter is empty.");

                if (string.IsNullOrEmpty(CORCD)) CORCD = "";
                if (string.IsNullOrEmpty(BIZCD)) BIZCD = "";
                if (string.IsNullOrEmpty(VENDCD)) VENDCD = "";
                if (string.IsNullOrEmpty(INPUT_DATE)) INPUT_DATE = DateTime.Now.ToString("yyyy-MM-dd");
                if (string.IsNullOrEmpty(VINCD)) VINCD = "";
                if (string.IsNullOrEmpty(MAT_ITEM)) MAT_ITEM = "";
                if (string.IsNullOrEmpty(INSTALL_POS)) INSTALL_POS = "";

                HEParameterSet param = new HEParameterSet();

                param.Add("CORCD", CORCD);
                param.Add("BIZCD", BIZCD);
                param.Add("VENDCD", VENDCD);
                param.Add("INPUT_DATE", INPUT_DATE);
                param.Add("VINCD", VINCD);
                param.Add("MAT_ITEM", MAT_ITEM);
                param.Add("INSTALL_POS", INSTALL_POS);
                DataSet ds03 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_AMM1060"), param);

                string tmpFileName = DateTime.Now.Ticks.ToString();
                tmpFileName = "c:\\Temp\\" + tmpFileName + ".xml";

                ds03.DataSetName = "DATASET";
                ds03.Tables[0].TableName = "RECORD";
                ds03.Tables[0].WriteXml(tmpFileName, XmlWriteMode.WriteSchema);

                Response.Clear();
                Response.ContentType = "text/xml"; // "Application/Octet-Stream"
                Response.AddHeader("Content-Disposition", "filename=JIS_ORDER_" + INPUT_DATE.Replace("-","") + "_" + VENDCD + ".xml");
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
