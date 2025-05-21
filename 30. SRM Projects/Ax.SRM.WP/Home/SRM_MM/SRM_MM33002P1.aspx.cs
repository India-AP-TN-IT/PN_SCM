#region ▶ Description & History
/* 
 * 프로그램명 : 월별/일별 상세조회(Popup) (구.VM3130 월 검수실적 상세 조회)
 * 설      명 : 
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-09-25
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
using System.Data;
using System.Web;
using Ax.EP.Utility;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MM
{
    /// <summary>
    /// <b>자재관리>납품관리>월별/일별 상세조회(Popup)</b>
    /// - 작 성 자 : 이명희<br />
    /// - 작 성 일 : 2014-09-23<br />
    /// </summary>
    public partial class SRM_MM33002P1 : BasePage
    {
        /// <summary>
        /// SCM_MM33002P1 생성자
        /// </summary>
        public SRM_MM33002P1()
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
                    string VENDCD = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");
                    string RCV_DATE = HttpUtility.ParseQueryString(sQuery).Get("RCV_DATE");
                    string PARTNO = HttpUtility.ParseQueryString(sQuery).Get("PARTNO");
                    string GUBUN = HttpUtility.ParseQueryString(sQuery).Get("GUBUN");
                    decimal QTY = Convert.ToDecimal(HttpUtility.ParseQueryString(sQuery).Get("QTY"));
                    decimal COST = Convert.ToDecimal(HttpUtility.ParseQueryString(sQuery).Get("COST"));

                    DataSet ds = null;

                    HEParameterSet param = new HEParameterSet();
                    param.Add("CORCD", Util.UserInfo.CorporationCode);
                    param.Add("BIZCD", BIZCD);
                    param.Add("VENDCD", VENDCD);
                    param.Add("RCV_DATE", RCV_DATE);
                    param.Add("PARTNO", PARTNO);
                    param.Add("GUBUN", GUBUN);
                    param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                    param.Add("USER_ID", Util.UserInfo.UserID);

                    ds = EPClientHelper.ExecuteDataSet("APG_SRM_MM33002.INQUERY_POPUP", param, "OUT_CURSOR", "OUT_CURSOR2");

                    if (ds.Tables[0].Rows.Count <= 0)
                        return;

                    DataRow dr = ds.Tables[0].Rows[0];
                    this.MAT_TYPE.Text = dr["TYPENM"].ToString();
                    this.PARTNO.Text = dr["PARTNO"].ToString();
                    this.PARTNM.Text = dr["PARTNM"].ToString();
                    this.UNITNM.Text = dr["UNITNM"].ToString();
                    this.UCOST.Text = string.Format("{0:#,#}", dr["RCV_UCOST"]);
                    this.STANDARD.Text = dr["STANDARD"].ToString();

                    if (GUBUN.Equals("RTN"))
                    {
                        this.Grid01.Hide();
                        this.Grid02.Show();
                        this.Grid03.Hide();

                        this.Store2.DataSource = ds.Tables[1];
                        this.Store2.DataBind();
                    }
                    else if (GUBUN.Equals("SETTLE"))
                    {
                        this.Grid01.Hide();
                        this.Grid02.Hide();
                        this.Grid03.Show();

                        this.Store3.DataSource = ds.Tables[1];
                        this.Store3.DataBind();
                    }
                    else
                    {
                        this.Grid01.Show();
                        this.Grid02.Hide();
                        this.Grid03.Hide();

                        this.Store1.DataSource = ds.Tables[1];
                        this.Store1.DataBind();
                    }

                    //하단 합계 표시
                    this.QTY_AMT.Text = string.Format("[ Q'ty : {0:#,#} Amount : {1:#,#} ]", QTY, COST);
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