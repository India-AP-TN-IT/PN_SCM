using System;
using System.Data;
using System.Web;
using Ax.EP.Utility;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM26001P1 : BasePage
    {
        /// <summary>
        /// <b>자재관리>사급관리>확정수량 정보(Popup)</b>
        /// - 작 성 자 : 손창현<br />
        /// - 작 성 일 : 2017-08-28<br />
        /// </summary>
        public SRM_MM26001P1()
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
                    string CUSTCD = HttpUtility.ParseQueryString(sQuery).Get("CUSTCD");
                    string REQ_DATE = HttpUtility.ParseQueryString(sQuery).Get("REQ_DATE");
                    string DIV = HttpUtility.ParseQueryString(sQuery).Get("DIV");
                    string PARTNO = HttpUtility.ParseQueryString(sQuery).Get("PARTNO");
                    string PARTNM = HttpUtility.ParseQueryString(sQuery).Get("PARTNM");
                    string UNIT = HttpUtility.ParseQueryString(sQuery).Get("UNIT");                    

                    this.txt01_PARTNO.Text = PARTNO;
                    this.txt01_PARTNM.Text = PARTNM;
                    this.txt01_UNIT.Text = UNIT;

                    DataSet ds = null;

                    HEParameterSet param = new HEParameterSet();
                    param.Add("CORCD", CORCD);
                    param.Add("BIZCD", BIZCD);
                    param.Add("CUSTCD", CUSTCD);                    
                    param.Add("REQ_DATE", REQ_DATE);
                    param.Add("DIV", DIV);
                    param.Add("PARTNO", PARTNO);
                    param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                    ds = EPClientHelper.ExecuteDataSet("APG_SRM_MM26000.INQUERY_POP1", param, "OUT_CURSOR");

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