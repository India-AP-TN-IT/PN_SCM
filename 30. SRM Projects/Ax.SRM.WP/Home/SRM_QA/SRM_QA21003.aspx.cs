#region ▶ Description & History
/* 
 * 프로그램명 : Claim 이의제기 의뢰
 * 설      명 : 품질관리 > 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-13
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
using Ext.Net;
using HE.Framework.Core;
using System.Data;
using System.Collections;

namespace Ax.SRM.WP.Home.SRM_QA
{

    public partial class SRM_QA21003 : BasePage
    {
        private string pakageName = "APG_SRM_QA21003";
        

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA21003
        /// </summary>
        public SRM_QA21003()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = true;
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
                if (!X.IsAjaxRequest)
                {
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);
                    this.SetCombo(this.UserInfo.BusinessCode); //콤보상자 바인딩//임시저장

                    this.Reset();           //초기화
                }
            }
            catch //(Exception ex)
            {
                // excel 다운로드는 메시지 처리 하지 않음
                //this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        [DirectMethod]
        public void SetComboVisibleClaimOccurDiv()
        {
            string claim_occur_div = this.cbo01_OCCUR_DIV.Value.ToString();
            if (claim_occur_div.Equals("FUFD")) //필드클레임
            {
                this.lbl02_OCCUR_DIV.Hide();
                this.cbo02_OCCUR_DIV.Hide();
            }
            else  //자체클레임
            {
                this.lbl02_OCCUR_DIV.Show();
                this.cbo02_OCCUR_DIV.Show();

                this.cbo02_OCCUR_DIV.SelectedItem.Value = "INMIP";
                this.cbo02_OCCUR_DIV.UpdateSelectedItems(); //꼭 해줘야한다.
            }
           
        }

        #endregion

        #region [ 버튼설정 ]

        /// <summary>
        /// BuildButtons
        /// 기본 버튼생성
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Search,  ButtonImage.Search,  "Search",     this.ButtonPanel);
            MakeButton(ButtonID.Reset,   ButtonImage.Reset,   "Reset",      this.ButtonPanel);
            MakeButton(ButtonID.Request, ButtonImage.Request, "Request", this.ButtonPanel);
            MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
            MakeButton(ButtonID.Close,   ButtonImage.Close,   "Close",      this.ButtonPanel);
        }

        /// <summary>
        /// MakeButton
        /// </summary>
        /// <param name="id"></param>
        /// <param name="image"></param>
        /// <param name="alt"></param>
        /// <param name="container"></param>
        /// <param name="isUpload"></param>
        public void MakeButton(string id, string image, string alt, Ext.Net.Panel container, bool isUpload = false)
        {
            Ext.Net.ImageButton ibtn = CreateImageButton(id, image, alt, isUpload);

            if (id.Equals(ButtonID.Request)) //저장시 수정된 데이터만 저장한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            }

            container.Add(ibtn);
        }

        /// <summary>
        /// Button_Click
        /// 기본 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public override void Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.ImageButton ibtn = (Ext.Net.ImageButton)sender;

            switch (ibtn.ID)
            {
                case ButtonID.Search:
                    Search();
                    break;
                case ButtonID.Reset:
                    Reset();
                    break;
                case ButtonID.Request:
                    Save(sender, e);
                    break;
                case ButtonID.ExcelDL:
                    Excel_Export();
                    break;
                case ButtonID.Close:
                    X.Js.Call("closeTab");
                    break;
                default: break;
            }
        }

        /// <summary>
        /// etc_Button_Click
        /// 사용자 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void etc_Button_Click(object sender, EventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_POP_QA21003P1":
                    try
                    {
                        // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                        HEParameterSet param = new HEParameterSet();
                        param.Add("CORCD", V_CORCD.Value == null ? "" : V_CORCD.Value);
                        param.Add("BIZCD", V_BIZCD.Value == null ? "" : V_BIZCD.Value);
                        param.Add("DOCRPTNO", V_DOCRPTNO.Value == null ? "" : V_DOCRPTNO.Value);
                        param.Add("FORMOBJNO", V_FORMOBJNO.Value == null ? "" : V_FORMOBJNO.Value);
                        param.Add("RROG_DIV", V_RROG_DIV.Value == null ? "" : V_RROG_DIV.Value);

                        Util.UserPopup((BasePage)this.Form.Parent.Page, UserHelpURL.Text, param, "HELP_QA21003P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
                        break;
                    }
                    catch
                    {
                        return;
                    }
            }
        }

        #endregion

        #region [ 기능 ]
        [DirectMethod]
        public void SetQueryDiv(string gubun)
        {
        }


        /// <summary>
        /// 콤보상자 바인딩(발생구분)
        /// </summary>
        private void SetCombo(string bizcd)
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", this.UserInfo.CorporationCode);
            set.Add("BIZCD", bizcd);
            set.Add("LANG_SET", this.UserInfo.LanguageShort);
            set.Add("USER_ID", this.UserInfo.UserID);
            //발생구분 콤보상자 바인딩
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CLAIM_OCCUR_DIV1"), set);
            Library.ComboDataBind(this.cbo01_OCCUR_DIV, source.Tables[0], false, "TYPENM", "OBJECT_ID", true);

           //두번째 발생구분 콤보상자 바인딩 및 VISIBLE=FALSE 처리
            source  = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CLAIM_OCCUR_DIV2"), set);
            Library.ComboDataBind(this.cbo02_OCCUR_DIV, source.Tables[0], false, "DIVNM", "DIVCD", true);
        }

        /// <summary>
        /// Search
        /// </summary>
        public void Search()
        {
            try
            {
                //유효성 검사
                if (!IsQueryValidation())
                {
                    return;
                }

                this.Store1.RemoveAll();

                if (this.cbo01_OCCUR_DIV.Value.Equals("FUFD"))
                {
                    DataSet result = getDataSet();
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
                }
                else
                {
                    DataSet result = getDataSet02();
                    this.Store1.DataSource = result.Tables[0];
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
        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_OCCUR_MONTH.SetValue(DateTime.Now.ToString("yyyy-MM"));

            this.cbo01_OCCUR_DIV.SelectedItem.Value = "FUFD";
            this.cbo01_OCCUR_DIV.UpdateSelectedItems(); //꼭 해줘야한다.

            if (cbo02_OCCUR_DIV.Items.Count > 0)
            {
                this.cbo02_OCCUR_DIV.SelectedItem.Value = "INMIP";
                this.cbo02_OCCUR_DIV.UpdateSelectedItems(); //꼭 해줘야한다.
            }

            this.rdo01_ALLS.Checked = true;

            this.txt01_CNT.SetValue(string.Empty);
            this.txt01_TOT_AMT.SetValue(string.Empty);
            this.txt01_Y_CNT.SetValue(string.Empty);
            this.txt01_Y_TOT_AMT.SetValue(string.Empty);

            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }
            Store1.RemoveAll();
        }

        /// <summary>
        /// SaveAndDelete
        /// 저장
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                //이의제기 의뢰
                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "DOCRPTNO",
                   "FORMOBJNO", "OFFDOC_DIV", "RROG_DIV",
                   "USER_ID", "LANG_SET"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    param.Tables[0].Rows.Add(
                           parameter[i]["CORCD"], parameter[i]["BIZCD"], parameter[i]["DOCRPTNO"],
                           parameter[i]["FORMOBJNO"], parameter[i]["OFFDOC_DIV"], parameter[i]["RROG_DIV"],
                           Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                   );
                }

                //유효성 검사
                if (!Validation(param.Tables[0].Rows[0], Library.ActionType.Request))
                {
                    return;
                }

                param.Tables[0].Columns.Remove("OFFDOC_DIV");
                param.Tables[0].Columns.Remove("RROG_DIV");

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param);
                    this.MsgCodeAlert("COM-00902");
                    Search();
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

        /// <summary>
        /// getDataSet
        /// 필드 클레임일 경우
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            string ACHK1 = "";
            string ACHK2 = "";
            string rdo_vlaue = "";

            //전부, 미처리, 처리중, 기각, 숭인
            if (this.rdo01_ALLS.Value.ToString().Equals("true"))
            {
                rdo_vlaue = "1";
                ACHK1 = "";
                ACHK2 = "";
            }
            else if (this.rdo01_NONE_RECEIPT.Value.ToString().Equals("true"))
            {
                rdo_vlaue = "2";
                ACHK1 = "FEA";
                ACHK2 = "FEB";
            }
            else if (this.rdo01_PROCESSING.Value.ToString().Equals("true"))
            {
                rdo_vlaue = "3";
                ACHK1 = "FEC";
                ACHK2 = "FEC";
            }
            else if (this.rdo01_QM_APPLY.Value.ToString().Equals("true"))
            {
                rdo_vlaue = "4";
                ACHK1 = "FEB";
                ACHK2 = "FEB";
            }
            else if (this.rdo01_REJECT.Value.ToString().Equals("true"))
            {
                rdo_vlaue = "5";
                ACHK1 = "FEA";
                ACHK2 = "FEA";
            }

            HEParameterSet param = new HEParameterSet();

            if (rdo_vlaue.Equals("1") || rdo_vlaue.Equals("4") || rdo_vlaue.Equals("5"))
            {
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.Value);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("PROC_DATE", ((DateTime)this.df01_OCCUR_MONTH.Value).ToString("yyyy-MM"));
                param.Add("ACHK1", ACHK1);
                param.Add("ACHK2", ACHK2);
                param.Add("CLAIM_OCCUR_DIV", this.cbo01_OCCUR_DIV.Value);
                param.Add("RDO_VALUE", rdo_vlaue);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);
            }
            else
            {
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.Value);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("ACHK1", ACHK1);
                param.Add("ACHK2", ACHK2);
                param.Add("PROC_DATE", ((DateTime)this.df01_OCCUR_MONTH.Value).ToString("yyyy-MM"));
                param.Add("CLAIM_OCCUR_DIV", this.cbo01_OCCUR_DIV.Value);
                param.Add("RDO_VALUE", rdo_vlaue);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);
            }

            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param, "OUT_CURSOR", "OUT_CURSOR02");

            TextBind(ds.Tables[1]);

            return ds;
        }

        /// <summary>
        /// getDataSet
        /// 자체클레임인 경우
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet02()
        {
            string ACHK1 = "";
            string ACHK2 = "";
            string ACHK3 = "";
            string ACHK4 = "";

            //전부, 미처리, 처리중, 기각, 숭인
            if (this.rdo01_ALLS.Value.ToString().Equals("true"))
            {
                ACHK1 = "";
                ACHK2 = "";
                ACHK3 = "";
                ACHK4 = "";
            }
            else if (this.rdo01_NONE_RECEIPT.Value.ToString().Equals("true"))
            {
                ACHK1 = "FEA";
                ACHK2 = "FEA";
                ACHK3 = "FEB";
                ACHK4 = "FEA";
            }
            else if (this.rdo01_PROCESSING.Value.ToString().Equals("true"))
            {
                ACHK1 = "FEC";
                ACHK2 = "FEC";
                ACHK3 = "FEC";
                ACHK4 = "FEC";
            }
            else if (this.rdo01_QM_APPLY.Value.ToString().Equals("true"))
            {
                ACHK1 = "FEB";
                ACHK2 = "FEB";
                ACHK3 = "FEB";
                ACHK4 = "FEB";
            }
            else if (this.rdo01_REJECT.Value.ToString().Equals("true"))
            {
                ACHK1 = "FEA";
                ACHK2 = "FEA";
                ACHK3 = "FEA";
                ACHK4 = "FEA";
            }

            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("PROC_DATE", ((DateTime)this.df01_OCCUR_MONTH.Value).ToString("yyyy-MM"));
            param.Add("ACHK1", ACHK1);
            param.Add("ACHK2", ACHK2);
            param.Add("ACHK3", ACHK3);
            param.Add("ACHK4", ACHK4);
            param.Add("CLAIM_OCCUR_DIV", this.cbo01_OCCUR_DIV.Value);
            param.Add("OCCUR_DIV", this.cbo02_OCCUR_DIV.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);


            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SECOND"), param, "OUT_CURSOR", "OUT_CURSOR02");

            TextBind(ds.Tables[1]);

            return ds;
        }

        /// <summary>
        /// Excel_Export
        /// </summary>
        private void Excel_Export()
        {
            try
            {
                DataSet result = null;

                if (this.cbo01_OCCUR_DIV.Value.Equals("FUFD"))
                {
                    result = getDataSet();

                    if (result == null) return;
                }
                else
                {
                    result = getDataSet02();

                    if (result == null) return;
                }

                if (result.Tables[0].Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                {
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {

            }
        }

        //해당 건수, 금액 바인딩
        private void TextBind(DataTable dt)
        {
            this.txt01_CNT.Text = "";
            this.txt01_TOT_AMT.Text = "";
            this.txt01_Y_CNT.Text = "";
            this.txt01_Y_TOT_AMT.Text = "";

            if (dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];
                this.txt01_CNT.Text = dr["CNT"].ToString();
                this.txt01_TOT_AMT.Text = string.Format("{0:#,###}", dr["TOT_AMT"].ToString());
                this.txt01_Y_CNT.Text = dr["Y_CNT"].ToString();
                this.txt01_Y_TOT_AMT.Text = string.Format("{0:#,###}", dr["Y_TOT_AMT"].ToString());
            }

        }

        #endregion

        #region [ 유효성 검사 ]

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {
            
            // 조회용 Validation
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0046", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.df01_OCCUR_MONTH.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "df01_OCCUR_MONTH", lbl01_OCCUR_MONTH.Text);
                return false;
            }

            return true;
        }

        /// <summary>
        /// Validation
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="actionType"></param>
        /// <param name="actionRow"></param>
        /// <remarks>actionRow 는 Grid 타일경우에만 사용한다.</remarks>
        /// <returns>bool</returns>
        public bool Validation(DataRow parameter, Library.ActionType actionType, int actionRow = -1)
        {
            bool result = false;

            // 저장용 Validation
            if (actionType == Library.ActionType.Request)
            {
                if (String.IsNullOrEmpty(parameter["RROG_DIV"].ToString()) || parameter["RROG_DIV"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0020", actionRow);

                else if (String.IsNullOrEmpty(parameter["OFFDOC_DIV"].ToString()) || parameter["OFFDOC_DIV"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0021", actionRow);

                else
                    result = true;

            }

            return result;
        }

        #endregion
    }
}
