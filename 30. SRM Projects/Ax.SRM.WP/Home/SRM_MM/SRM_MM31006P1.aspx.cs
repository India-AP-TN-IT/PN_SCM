using System;
using System.Data;
using System.Web;
using Ax.EP.Utility;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM31006P1 : BasePage
    {
        /// <summary>
        /// <b>자재관리>계획관리>입고수량-입고상세 정보(Popup)</b>
        /// - 작 성 자 : 손창현<br />
        /// - 작 성 일 : 2017-08-09<br />
        /// </summary>
        public SRM_MM31006P1()
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
                    string DIV = HttpUtility.ParseQueryString(sQuery).Get("DIV"); //I - AMM2010, D - AMM9015 기준
                    string CORCD = HttpUtility.ParseQueryString(sQuery).Get("CORCD");
                    string BIZCD = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    string VENDCD = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");
                    string PURC_ORG = HttpUtility.ParseQueryString(sQuery).Get("PURC_ORG");
                    string PURC_PO_TYPE = HttpUtility.ParseQueryString(sQuery).Get("PURC_PO_TYPE");
                    string PURC_GRP = HttpUtility.ParseQueryString(sQuery).Get("PURC_GRP");
                    string PARTNO = HttpUtility.ParseQueryString(sQuery).Get("PARTNO");
                    string PARTNM = HttpUtility.ParseQueryString(sQuery).Get("PARTNM");
                    string UNIT = HttpUtility.ParseQueryString(sQuery).Get("UNIT");
                    string GRN_NO = HttpUtility.ParseQueryString(sQuery).Get("GRN_NO");
                    string DATE_FROM = HttpUtility.ParseQueryString(sQuery).Get("DATE_FROM");
                    string DATE_TO = HttpUtility.ParseQueryString(sQuery).Get("DATE_TO");
                    string DATE_TYPE = HttpUtility.ParseQueryString(sQuery).Get("DATE_TYPE");
                    string CUSTCD = HttpUtility.ParseQueryString(sQuery).Get("CUSTCD");

                    this.txt01_PARTNO.Text = PARTNO;
                    this.txt01_PARTNM.Text = PARTNM;
                    this.txt01_UNIT.Text = UNIT;

                    DataTable source = Library.GetTypeCode("1K").Tables[0];
                    source.DefaultView.RowFilter = "TYPECD NOT IN ('NI')";
                    Library.ComboDataBind(this.cbo01_PURC_PO_TYPE, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    //this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.
                    this.cbo01_PURC_PO_TYPE.SelectedItem.Value = PURC_PO_TYPE;
                    this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

                    source = Library.GetTypeCode("1A").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    //this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.
                    this.cbo01_PURC_ORG.SelectedItem.Value = PURC_ORG;
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.
                    
                    source = Library.GetTypeCode("1B").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_GRP, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    //this.cbo01_PURC_GRP.UpdateSelectedItems(); //꼭 해줘야한다.
                    this.cbo01_PURC_GRP.SelectedItem.Value = PURC_GRP;
                    this.cbo01_PURC_GRP.UpdateSelectedItems(); //꼭 해줘야한다.

                    string V_GRN_NO = "";
                    string V_GRN_SEQ = "";

                    if (GRN_NO.Trim().Length > 0)
                    {
                        V_GRN_NO = GRN_NO.Split('-')[0];
                        V_GRN_SEQ = GRN_NO.Split('-')[1];
                    }

                    DataSet ds = null;

                    HEParameterSet param = new HEParameterSet();
                    param.Add("CORCD", CORCD);
                    param.Add("BIZCD", BIZCD);
                    param.Add("VENDCD", VENDCD);
                    param.Add("PURC_ORG", PURC_ORG);
                    param.Add("PURC_PO_TYPE", PURC_PO_TYPE);
                    param.Add("PURC_GRP", PURC_GRP);
                    param.Add("PARTNO", PARTNO);
                    param.Add("DATE_TYPE", DATE_TYPE);
                    param.Add("DATE_FROM", DATE_FROM);
                    param.Add("DATE_TO", DATE_TO);
                    param.Add("GRN_NO", V_GRN_NO);
                    param.Add("GRN_SEQ", V_GRN_SEQ);
                    param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                    param.Add("DIV", DIV);
                    param.Add("CUSTCD", CUSTCD);

                    ds = EPClientHelper.ExecuteDataSet("APG_SRM_MM31006.INQUERY_POP", param, "OUT_CURSOR", "OUT_CURSOR2");

                    this.Store1.DataSource = ds.Tables[0];
                    this.Store1.DataBind();

                    if (ds.Tables[1].Rows.Count <= 0)
                        return;

                    DataRow dr = ds.Tables[1].Rows[0];
                    this.txt01_VENDCD.Text = dr["VENDCD"].ToString();
                    this.txt01_VENDNM.Text = dr["VENDNM"].ToString();
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