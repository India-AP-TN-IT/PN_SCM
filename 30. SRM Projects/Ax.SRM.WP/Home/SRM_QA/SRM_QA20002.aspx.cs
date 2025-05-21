/* 
 * 프로그램명 : 입고불량 대책서 등록     [D2](구.VQ2010)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-06
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
 *				
 *
 * 
*/
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

namespace Ax.QA.WP.Home.SRM_MP
{
    public partial class SRM_QA20002 : BasePage
    {
        private string pakageName = "APG_SRM_QA20002";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA20002
        /// </summary>
        public SRM_QA20002()
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
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, true);

                    SetCombo();

                    Reset();
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

        #endregion

        #region [ 버튼설정 ]

        /// <summary>
        /// BuildButtons
        /// 기본 버튼생성
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
            MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
            MakeButton(ButtonID.Close, ButtonImage.Close, "Close", this.ButtonPanel);
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
            if (id.Equals(ButtonID.Save)) //저장시 수정된 데이터만 저장한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            }
            else if (id.Equals(ButtonID.Present)) // 제출 시 선택된 데이터만 제출한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly:true})", Mode = ParameterMode.Raw, Encode = true });
            }
            else if (id.Equals(ButtonID.PresentCancle)) // 제출 취소시 선택된 데이터만 취소한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly:true})", Mode = ParameterMode.Raw, Encode = true });
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
                case ButtonID.Save:
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
                case "btn01_POP_QA20002P1":
                    try
                    {
                        // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                        HEParameterSet param = new HEParameterSet();
                        param.Add("BIZCD", V_BIZCD.Value == null ? "" : V_BIZCD.Value);
                        param.Add("VENDCD", V_VENDCD.Value == null ? "" : V_VENDCD.Value);
                        param.Add("DOCNO", V_DOCNO.Value == null ? "" : V_DOCNO.Value);
                        param.Add("RCV_DATE", V_RCV_DATE.Value == null ? "" : ((DateTime)V_RCV_DATE.Value).ToString("yyyy-MM-dd"));
                        param.Add("INSPECT_DIV", V_INSPECT_DIV.Value == null ? "" : V_INSPECT_DIV.Value);
                        param.Add("DEFCD", V_DEFCD.Value == null ? "" : V_DEFCD.Value);
                        param.Add("DOCNO2", V_DOCNO2.Value == null ? "" : V_DOCNO2.Value);
                        param.Add("VENDCDSTATUSCD", V_VENDCDSTATUSCD.Value == null ? "" : V_VENDCDSTATUSCD.Value);
                        param.Add("FIRMSTATUSCD", V_FIRMSTATUSCD.Value == null ? "" : V_FIRMSTATUSCD.Value);
                        param.Add("CHKBTN", CHKBTN.Value == null ? "" : CHKBTN.Value);

                        //param.Add("ATT_FILENM", CHKBTN.Value == null || V_ATT_FILENM.Value.ToString() == "" ? "N" : "Y");

                        Util.UserPopup((BasePage)this.Form.Parent.Page, UserHelpURL.Text, param, "HELP_QA20002P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
                        break;
                    }
                    catch
                    {
                        return;
                    }
                case "btn01_POP_QA20002P2":
                    try
                    {
                        // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                        HEParameterSet param = new HEParameterSet();
                        param.Add("BIZCD", V_BIZCD.Value == null ? "" : V_BIZCD.Value);
                        param.Add("DEFNO", V_DEFNO.Value == null ? "" : V_DEFNO.Value);
                        param.Add("DOCNO", V_DOCNO.Value == null ? "" : V_DOCNO.Value);

                        Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_QA/SRM_QA20002P2.aspx", param, "HELP_QA20002P2", "Popup", 760, 200);
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

                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();
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
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("REV_DATE", ((DateTime)this.df01_REV_DATE.Value).ToString("yyyy-MM"));
            param.Add("DOCNO", this.cbo01_DOCNO.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet02()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SECOND"), param);
        }

        /// <summary>
        /// Excel_Export
        /// </summary>
        private void Excel_Export()
        {
            try
            {
                DataSet result = getDataSet();

                if (result == null) return;

                if (result.Tables[0].Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                {
                    result.Tables[0].Columns.Remove("VENDCDSTATUSCD");
                    result.Tables[0].Columns.Remove("FIRMSTATUSCD");
                    result.Tables[0].Columns.Remove("BIZCD");
                    result.Tables[0].Columns.Remove("VENDCD");
                    result.Tables[0].Columns.Remove("DEFNO");
                    result.Tables[0].Columns.Remove("INSPECT_DIV");
                    result.Tables[0].Columns.Remove("DEFCD");
                    result.Tables[0].Columns.Remove("INSPECT_EMPNO");
                    result.Tables[0].Columns.Remove("DOCNO2");
                    
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);
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

        //상세견적첨부 저장 후 로직
        [DirectMethod]
        public void FileNmUpdate()
        {
            Search();
        }

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cbo01_DOCNO.SelectedItem.Value = "";
            this.cbo01_DOCNO.UpdateSelectedItems(); //꼭 해줘야한다.
            this.df01_REV_DATE.SetValue(DateTime.Now.ToString("yyyy-MM"));

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

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "DOCDATE",
                    "VENDCD", "DEFNO", "USER_ID", "LANG_SET"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    param.Tables[0].Rows.Add(
                            Util.UserInfo.CorporationCode, this.cbo01_BIZCD.Value, DateTime.Now.ToString("yyyy-MM-dd"),
                            parameter[i]["VENDCD"], parameter[i]["DEFNO"], Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                    );
                }

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

        #endregion

        #region [ 이벤트 ]

        #endregion

        #region [함수]

        //전체선택 및 그리드 컬럼 수정방지 
        private void GridEvent()
        {

        }

        private void SetCombo()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_DOCNO"), param);

            Library.ComboDataBind(this.cbo01_DOCNO, source.Tables[0], true, "DOCNONM", "DOCNO", true);
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
            else if (this.df01_REV_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "df01_REV_DATE", lbl01_DEAD_STD.Text);
                return false;
            }

            return true;
        }

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 벨리데이션
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void CodeBox_AfterValidation(object sender, DirectEventArgs e)
        {
            // 커스텀시 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            SetCombo();
        }

        #endregion
    }
}
