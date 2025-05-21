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
using System.Data;
using System.Web;
using Ax.EP.Utility;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MM
{
    /// <summary>
    /// <b>자재관리>사급관리>월별/일별 유상사급 상세조회(Popup)</b>
    /// - 작 성 자 : 이명희<br />
    /// - 작 성 일 : 2014-10-02<br />
    /// </summary>
    public partial class SRM_MM32002P1 : BasePage
    {
        /// <summary>
        /// SRM_MM32001P1 생성자
        /// </summary>
        public SRM_MM32002P1()
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
                    string CORCD = HttpUtility.ParseQueryString(sQuery).Get("CORCD");
                    string BIZCD = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    string VENDCD = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");
                    string PURC_ORG = HttpUtility.ParseQueryString(sQuery).Get("PURC_ORG");
                    string PURC_PO_TYPE = HttpUtility.ParseQueryString(sQuery).Get("PURC_PO_TYPE");
                    string VINCD = HttpUtility.ParseQueryString(sQuery).Get("VINCD");
                    string PARTNO = HttpUtility.ParseQueryString(sQuery).Get("PARTNO");
                    string PARTNM = HttpUtility.ParseQueryString(sQuery).Get("PARTNM");
                    string DATE_FROM = HttpUtility.ParseQueryString(sQuery).Get("DATE_FROM");
                    string DATE_TO = HttpUtility.ParseQueryString(sQuery).Get("DATE_TO");
                    string UNIT = HttpUtility.ParseQueryString(sQuery).Get("UNIT");
                    
                    this.PARTNO.Text = PARTNO;
                    this.PARTNM.Text = PARTNM;
                    this.UNIT.Text = UNIT;

                    DataSet ds = null;

                    HEParameterSet param = new HEParameterSet();
                    param.Add("CORCD", CORCD);
                    param.Add("BIZCD", BIZCD);
                    param.Add("PURC_ORG", PURC_ORG);
                    param.Add("PURC_PO_TYPE", PURC_PO_TYPE);
                    param.Add("VENDCD", VENDCD);
                    param.Add("VINCD", VINCD);
                    param.Add("PARTNO", PARTNO);
                    param.Add("DATE_FROM", DATE_FROM);
                    param.Add("DATE_TO", DATE_TO);
                    param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                    ds = EPClientHelper.ExecuteDataSet("APG_SRM_MM32002.INQUERY_POP1", param, "OUT_CURSOR");

                    this.Store1.DataSource = ds.Tables[0];
                    this.Store1.DataBind();
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