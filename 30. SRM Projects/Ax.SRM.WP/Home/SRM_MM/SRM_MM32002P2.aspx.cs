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
    /// <b>자재관리>계획관리>납품수량-납품상세 정보(Popup)</b>
    /// - 작 성 자 : 손창현<br />
    /// - 작 성 일 : 2017-08-09<br />
    /// </summary>
    public partial class SRM_MM32002P2 : BasePage
    {
        /// <summary>
        /// SRM_MM32001P2 생성자
        /// </summary>
        public SRM_MM32002P2()
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
                    string PONO = HttpUtility.ParseQueryString(sQuery).Get("PONO");

                    DataTable source = Library.GetTypeCode("1K").Tables[0];
                    source.DefaultView.RowFilter = "TYPECD NOT IN ('NI')";
                    Library.ComboDataBind(this.cbo01_PURC_PO_TYPE, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

                    source = Library.GetTypeCode("1A").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
                    {
                        this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                    }
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

                    source = Library.GetTypeCode("1B").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_GRP, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_PURC_GRP.UpdateSelectedItems(); //꼭 해줘야한다.

                    DataSet ds = null;

                    HEParameterSet param = new HEParameterSet();
                    param.Add("PONO", PONO.Split('-')[0]);
                    param.Add("PONO_SEQ", PONO.Split('-')[1]);
                    param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                    ds = EPClientHelper.ExecuteDataSet("APG_SRM_MM32002.INQUERY_POP2", param, "OUT_CURSOR", "OUT_CURSOR2");

                    this.Store1.DataSource = ds.Tables[1];
                    this.Store1.DataBind();

                    if (ds.Tables[0].Rows.Count <= 0)
                        return;

                    DataRow dr = ds.Tables[0].Rows[0];
                    this.txt01_VENDCD.Text = dr["VENDCD"].ToString();
                    this.txt01_VENDNM.Text = dr["VENDNM"].ToString();
                    this.txt01_PONO.Text = dr["PONO"].ToString();
                    this.txt01_UNIT.Text = dr["UNIT"].ToString();
                    this.txt01_PARTNO.Text = dr["PARTNO"].ToString();
                    this.txt01_PARTNM.Text = dr["PARTNM"].ToString();

                    this.cbo01_PURC_PO_TYPE.SelectedItem.Value = dr["PURC_PO_TYPE"].ToString();
                    this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

                    this.cbo01_PURC_ORG.SelectedItem.Value = dr["PURC_ORG"].ToString();
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

                    this.cbo01_PURC_GRP.SelectedItem.Value = dr["PURC_GRP"].ToString();
                    this.cbo01_PURC_GRP.UpdateSelectedItems(); //꼭 해줘야한다.

                    this.df01_PO_DATE.SetValue(dr["PO_DATE"].ToString());
                    this.df01_PO_DELI_DATE.SetValue(dr["PO_DELI_DATE"].ToString());

                    this.txt01_PO_QTY.Text = dr["PO_QTY"].ToString();
                    this.txt01_DELIQTY.Text = dr["DELI_QTY"].ToString();
                    this.txt01_IN_QTY.Text = dr["GRN_QTY"].ToString(); 

                    //this.QTY_AMT.Text = string.Format("[ Q'ty : {0:#,#} Amount : {1:#,#} ]", SUM_QTY, SUM_AMT);
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