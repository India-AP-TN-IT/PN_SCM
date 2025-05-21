#region ▶ Description & History
/* 
 * 프로그램명 : 월별/일별 유상사급 상세조회(Popup) (구.VM3160 월 사급실적 상세 조회)
 * 설      명 : 
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-02
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
using Ext.Net;
using Ax.EP.Utility;
using HE.Framework.Core;
using System.Data;

namespace HE.EP.WP.Home.SCM_MM
{
    /// <summary>
    /// <b>자재관리>사급관리>월별/일별 유상사급 상세조회(Popup)</b>
    /// - 작 성 자 : 이명희<br />
    /// - 작 성 일 : 2014-10-02<br />
    /// </summary>
    public partial class SRM_MM36005P1 : BasePage
    {
        /// <summary>
        /// SRM_MM36005P1 생성자
        /// </summary>
        public SRM_MM36005P1()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = false;
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
                if (!IsPostBack)
                {
                    string sQuery = Request.Url.Query;

                    string BIZCD = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    string CUSTCD = HttpUtility.ParseQueryString(sQuery).Get("CUSTCD");
                    string SETTLE_DATE = HttpUtility.ParseQueryString(sQuery).Get("SETTLE_DATE");
                    string PARTNO = HttpUtility.ParseQueryString(sQuery).Get("PARTNO");
                    string MAT_TYPE = HttpUtility.ParseQueryString(sQuery).Get("MAT_TYPE");
                    decimal SUM_QTY = Convert.ToDecimal(HttpUtility.ParseQueryString(sQuery).Get("SUM_QTY"));
                    decimal SUM_AMT = Convert.ToDecimal(HttpUtility.ParseQueryString(sQuery).Get("SUM_AMT"));

                    DataSet ds = null;

                    HEParameterSet param = new HEParameterSet();
                    param.Add("CORCD", Util.UserInfo.CorporationCode);
                    param.Add("BIZCD", BIZCD);
                    param.Add("CUSTCD", CUSTCD);
                    param.Add("SETTLE_DATE", SETTLE_DATE);
                    param.Add("PARTNO", PARTNO);
                    param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                    param.Add("USER_ID", Util.UserInfo.UserID);

                    ds = EPClientHelper.ExecuteDataSet("APG_SRM_MM36005.INQUERY_POPUP", param, "OUT_CURSOR", "OUT_CURSOR2");

                    this.Store1.DataSource = ds.Tables[0];
                    this.Store1.DataBind();

                    if (ds.Tables[1].Rows.Count <= 0)
                        return;

                    DataRow dr = ds.Tables[1].Rows[0];
                    this.PARTNO.Text = dr["PARTNO"].ToString();
                    this.PARTNM.Text = dr["PARTNM"].ToString();
                    this.UNITNM.Text = dr["UNIT"].ToString();
                    this.UCOST.Text = string.Format("{0:#,#}", dr["UCOST"]);
                    this.STANDARD.Text = dr["STANDARD"].ToString();

                    this.QTY_AMT.Text = string.Format("[ Q'ty : {0:#,#} Amount : {1:#,#} ]", SUM_QTY, SUM_AMT);
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

    }
}