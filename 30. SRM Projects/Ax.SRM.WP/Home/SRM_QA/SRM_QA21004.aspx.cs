#region ▶ Description & History
/* 
 * 프로그램명 : Claim 이의제기 처리
 * 설      명 : 품질관리 > 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-07
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

    public partial class SRM_QA21004 : BasePage
    {
        private string pakageName = "APG_SRM_QA21004";
        

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA21004
        /// </summary>
        public SRM_QA21004()
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
            MakeButton(ButtonID.Receive, ButtonImage.Receive, "Receive", this.ButtonPanel);
            MakeButton(ButtonID.DeadLetter, ButtonImage.DeadLetter, "DeadLetter", this.ButtonPanel);
            MakeButton(ButtonID.Conduct, ButtonImage.Conduct, "Conduct", this.ButtonPanel);
            MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
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
            
            if (id.Equals(ButtonID.Receive)) 
            {
                string msg = Library.getMessage("SRMQA00-0032", Util.UserInfo.LanguageShort);
                ibtn.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                ibtn.DirectEvents.Click.Confirmation.Title = "Confirm";
                ibtn.DirectEvents.Click.Confirmation.Message = msg;

                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues()", Mode = ParameterMode.Raw, Encode = true });

                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values02", Value = "App.Grid02.getRowsValues()", Mode = ParameterMode.Raw, Encode = true });
            }
            else if (id == ButtonID.DeadLetter)
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues()", Mode = ParameterMode.Raw, Encode = true });

                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values02", Value = "App.Grid02.getRowsValues()", Mode = ParameterMode.Raw, Encode = true });
            }
            else if (id == ButtonID.Conduct) // 처리 시 수정된 데이터만 저장
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });

                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values02", Value = "App.Grid02.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
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
                case ButtonID.Receive:
                    Receive(sender, e);
                    break;
                case ButtonID.DeadLetter:
                    deadLetter(sender, e);
                    break;
                case ButtonID.Conduct:
                    Conduct(sender, e);
                    break;
                case ButtonID.Print:
                    Print();
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

        #endregion

        #region [ 기능 ]

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

            HEParameterSet set02 = new HEParameterSet();
            set02.Add("CORCD", this.UserInfo.CorporationCode);
            set02.Add("BIZCD", bizcd);
            set02.Add("COLUMN_ID", "PROG_DIV");
            set02.Add("LANG_SET", this.UserInfo.LanguageShort);
            set02.Add("USER_ID", this.UserInfo.UserID);

            //그리드 의뢰유형 콤보상자 바인딩 처리
            source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PROG_DIV"), set02);
            Library.ComboDataBind(this.cbo02_PROG_DIV, source.Tables[0], false, false);
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
                this.Store4.RemoveAll();

                if (this.cbo01_OCCUR_DIV.Value.Equals("FUFD"))
                {
                    this.GridPanel.Show();
                    this.GridPanel02.Hide();
                    DataSet result = getDataSet();
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
                }
                else
                {
                    this.GridPanel.Hide();
                    this.GridPanel02.Show();
                    DataSet result = getDataSet02();
                    this.Store4.DataSource = result.Tables[0];
                    this.Store4.DataBind();
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

            this.df01_INQ_YYMM_BEG.SetValue(DateTime.Now);
            this.df01_INQ_YYMM_TO.SetValue(DateTime.Now);

            this.cdx01_DOCRPTNO.SetValue(string.Empty);
            this.txt01_FORMOBJNO.SetValue(string.Empty);

            this.cbo01_OCCUR_DIV.SelectedItem.Value = "FUFD";
            this.cbo01_OCCUR_DIV.UpdateSelectedItems(); //꼭 해줘야한다.

            if (cbo02_OCCUR_DIV.Items.Count > 0)
            {
                this.cbo02_OCCUR_DIV.SelectedItem.Value = "INMIP";
                this.cbo02_OCCUR_DIV.UpdateSelectedItems(); //꼭 해줘야한다.
            }

            this.GridPanel.Show();
            this.GridPanel02.Hide();

            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }
            Store1.RemoveAll();
            Store4.RemoveAll();
        }

        /// <summary>
        /// Receive
        /// 접수
        /// </summary>
        /// <param name="actionType"></param>
        public void Receive(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                string json02 = e.ExtraParams["Values02"];
                Dictionary<string, string>[] grid01Param = JSON.Deserialize<Dictionary<string, string>[]>(json);
                Dictionary<string, string>[] grid02Param = JSON.Deserialize<Dictionary<string, string>[]>(json02);

                if (grid01Param.Count() > 0 && grid02Param.Count() <= 0)
                {   //필드클레임
                    //유효성검사
                    for (int i = 0; i < grid01Param.Length; i++)
                    {
                        if (!receiveValidation(grid01Param[i])) return;
                    }
                    receiveConduct(grid01Param[0]);
                }
                else if (grid02Param.Count() > 0 && grid01Param.Count() <= 0)
                {   //자체클레임
                    //유효성검사
                    for (int i = 0; i < grid02Param.Length; i++)
                    {
                        if (!receiveValidation(grid02Param[i])) return;
                    }
                    receiveConduct(grid02Param[0]);
                }
                else
                {
                    //X.Msg.Alert("경고","접수할 데이터가 없습니다.").Show();
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0031");
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

        //접수
        public void receiveConduct(Dictionary<string, string> parameter)
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                //이의제기 헤더 저장공간
                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "DOCRPTNO",
                   "FORMOBJNO", "LANG_SET", "USER_ID"
                );

                param.Tables[0].Rows.Add(
                    parameter["CORCD"], parameter["BIZCD"], parameter["DOCRPTNO"],
                    parameter["FORMOBJNO"], Util.UserInfo.LanguageShort, Util.UserInfo.UserID
                );

                if (param.Tables[0].Rows.Count > 0)
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "RECEIVE"), param);
                    //X.Msg.Alert("확인", "이의제기 접수되었습니다.").Show();
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0027");
                    Search();
                }
            }
        }

        //공문(팝업창 열기)
        public void deadLetter(object sender, DirectEventArgs e)
        {
            string json = e.ExtraParams["Values"];
            string json02 = e.ExtraParams["Values02"];
            Dictionary<string, string>[] grid01Param = JSON.Deserialize<Dictionary<string, string>[]>(json);
            Dictionary<string, string>[] grid02Param = JSON.Deserialize<Dictionary<string, string>[]>(json02);

            if (grid01Param.Count() > 0 && grid02Param.Count() <= 0)
            {   //필드클레임
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", grid01Param[0]["CORCD"]);
                param.Add("BIZCD", grid01Param[0]["BIZCD"]);
                param.Add("DOCRPTNO", grid01Param[0]["DOCRPTNO"]);
                param.Add("FORMOBJNO", grid01Param[0]["FORMOBJNO"]);

                Util.UserPopup(this, this.UserHelpURL02.Text, param, "HELP_QA21004P2", "Popup", Convert.ToInt32(this.PopupWidth02.Text), Convert.ToInt32(this.PopupHeight02.Text));
            }
            else if (grid02Param.Count() > 0 && grid01Param.Count() <= 0)
            {   //자체클레임
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", grid01Param[0]["CORCD"]);
                param.Add("BIZCD", grid01Param[0]["BIZCD"]);
                param.Add("DOCRPTNO", grid01Param[0]["DOCRPTNO"]);
                param.Add("FORMOBJNO", grid01Param[0]["FORMOBJNO"]);

                Util.UserPopup(this, this.UserHelpURL02.Text, param, "HELP_QA21004P2", "Popup", Convert.ToInt32(this.PopupWidth02.Text), Convert.ToInt32(this.PopupHeight02.Text));
            }
            else
            {
                //X.Msg.Alert("경고", "공문작성 할 데이터가 없습니다.").Show();
                this.MsgCodeAlert("SRMQA00-0033");
                return;
            }
        }

        /// <summary>
        /// Conduct
        /// 처리
        /// </summary>
        /// <param name="actionType"></param>
        public void Conduct(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                string json02 = e.ExtraParams["Values02"];
                Dictionary<string, string>[] grid01Param = JSON.Deserialize<Dictionary<string, string>[]>(json);
                Dictionary<string, string>[] grid02Param = JSON.Deserialize<Dictionary<string, string>[]>(json02);

                if (grid01Param.Count() > 0 && grid02Param.Count() <= 0)
                {
                    //필드클레임
                    //유효성검사
                    for (int i = 0; i < grid01Param.Length; i++)
                    {
                        if (!conductValidation(grid01Param[i])) return;
                    }
                    conductSave(grid01Param);
                }
                else if (grid02Param.Count() > 0 && grid01Param.Count() <= 0)
                {
                    //자체클레임
                    //유효성검사
                    for (int i = 0; i < grid02Param.Length; i++)
                    {
                        if (!conductValidation(grid02Param[i])) return;
                    }
                    conductSave(grid02Param);
                }
                else
                {
                    //X.Msg.Alert("경고", "처리할 데이터가 없습니다.").Show();
                    this.MsgCodeAlert("SRMQA00-0037");
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

        //처리
        public void conductSave(Dictionary<string, string>[] parameter)
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                //이의제기 헤더 저장공간
                DataSet param = Util.GetDataSourceSchema
                (
                   "PROG_DIV", "CORCD", "BIZCD",
                   "DOCRPTNO", "DOCRPT_SEQ", "FORMOBJNO", "LANG_SET", "USER_ID" 
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    param.Tables[0].Rows.Add(
                        parameter[i]["PROG_DIV"], parameter[i]["CORCD"], parameter[i]["BIZCD"],
                        parameter[i]["DOCRPTNO"], parameter[i]["DOCRPT_SEQ"], parameter[i]["FORMOBJNO"], Util.UserInfo.LanguageShort, Util.UserInfo.UserID
                    );
                }

                if (param.Tables[0].Rows.Count > 0)
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "CONDUCT"), param);
                    //X.Msg.Alert("확인", "이의제기 처리되었습니다.").Show();
                    this.MsgCodeAlert("SRMQA00-0038");
                    Search();
                }
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
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("DOCRPTNO", this.cdx01_DOCRPTNO.Value);
            param.Add("FORMOBJNO", this.txt01_FORMOBJNO.Text);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_FCLAIM"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet02()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("DOCRPTNO", this.cdx01_DOCRPTNO.Value);
            param.Add("FORMOBJNO", this.txt01_FORMOBJNO.Text);
            param.Add("OCCUR_DIV", this.cbo02_OCCUR_DIV.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_JCLAIM"), param);
        }

        /// <summary>
        /// Print
        /// </summary>
        private void Print()
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("BIZCD", this.cbo01_BIZCD.Value);
            set.Add("YYMM", (DateTime)this.df01_INQ_YYMM_BEG.Value);
            set.Add("CLAIM_OCCUR_DIV", this.cbo01_OCCUR_DIV.Value);
            set.Add("OCCUR_DIV", this.cbo02_OCCUR_DIV.Value);

            Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_QA/SRM_QA21004P3.aspx", set, "HELP_QA21004P3", "Popup", 800, 200);
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

        #endregion

        #region [코드박스 이벤트 핸들러]
        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void CodeBox_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            // UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
            cdx.UserParamSet.Add("FYM", ((DateTime)this.df01_INQ_YYMM_BEG.Value).ToString("yyyy-MM"));
            cdx.UserParamSet.Add("TYM", ((DateTime)this.df01_INQ_YYMM_TO.Value).ToString("yyyy-MM"));
        }


        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 벨리데이션
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void CodeBox_CustomRemoteValidation(object sender, EP.UI.EPCodeBox_ValidationResult rsltSet)
        {
            // 커스텀시 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            /* DB 의 코드를 통한 검증 로직 작성 및 결과 값 리턴 - 여기부터 */
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("FYM", ((DateTime)this.df01_INQ_YYMM_BEG.Value).ToString("yyyy-MM"));
            param.Add("TYM", ((DateTime)this.df01_INQ_YYMM_TO.Value).ToString("yyyy-MM"));
            param.Add("DOCRPTNO", cdx.TypeCD);
            param.Add("CLAIM_OCCUR_DIV", this.cbo01_OCCUR_DIV.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);

            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_TNO_VALIDATION"), param);

            rsltSet.resultDataSet = ds;                                             //  결과 데이터셋
            rsltSet.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true; // 동일한 데이터가 있으면 true 없으면 false
            rsltSet.returnValueFieldName = "DOCRPTNO";
            rsltSet.returnTextFieldName = "DOCRPTNO";
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
            if (this.df01_INQ_YYMM_BEG.IsEmpty || this.df01_INQ_YYMM_TO.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0026");
                return false;
            }

            if (this.cdx01_DOCRPTNO.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0024");
                return false;
            }
            else if (this.txt01_FORMOBJNO.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0025");
                return false;
            }

            return true;
        }

        //접수
        public bool receiveValidation(Dictionary<string, string> parameter)
        {
            //공문진행 체크
            if (String.IsNullOrEmpty(Convert.ToString(parameter["RROG_DIV"])) || Convert.ToString(parameter["RROG_DIV"]).ToString().Trim().Equals(""))
            {
                //X.Msg.Alert("경고", "등록되지 않은 이의제기 자료입니다.").Show();
                this.MsgCodeAlert("SRMQA00-0028");
                return false;
            }
            if (Convert.ToString(parameter["RROG_DIV"]).ToString().Trim().Equals("FEA"))
            {
                //X.Msg.Alert("경고", "의뢰되지 않은 이의제기 자료입니다.").Show();
                this.MsgCodeAlert("SRMQA00-0029");
                return false;
            }
            if (Convert.ToString(parameter["RROG_DIV"]).ToString().Trim().Equals("FEC"))
            {
                //X.Msg.Alert("경고", "이미 접수 처리된 이의제기 의뢰자료 입니다.").Show();
                this.MsgCodeAlert("SRMQA00-0030");
                return false;
            }
            return true;
        }

        //처리
        public bool conductValidation(Dictionary<string, string> parameter)
        {
            //공문작성 체크
            if (String.IsNullOrEmpty(Convert.ToString(parameter["COM_YN"])) || Convert.ToString(parameter["COM_YN"]).ToString().Trim().Equals(""))
            {
                //X.Msg.Alert("경고", "공문 결과 작성이 되지 않은 이의제기 자료입니다.").Show();
                this.MsgCodeAlert("SRMQA00-0039");
                return false;
            }
            if (Convert.ToString(parameter["COM_YN"]).ToString().Trim().Equals("N"))
            {
                //X.Msg.Alert("경고", "공문 결과 작성이 완료되지 않은 이의제기 자료입니다.").Show();
                this.MsgCodeAlert("SRMQA00-0040");
                return false;
            }

            //처리구분 체크
            if (String.IsNullOrEmpty(Convert.ToString(parameter["PROG_DIV"])) || Convert.ToString(parameter["PROG_DIV"]).ToString().Trim().Equals(""))
            {
                //X.Msg.Alert("경고", "처리구분에 선택되지 않은 데이터가 있습니다.").Show();
                this.MsgCodeAlert("SRMQA00-0041");
                return false;
            }

            //처리일시 체크
            if (!String.IsNullOrEmpty(Convert.ToString(parameter["PROC_DATE"])) && !Convert.ToString(parameter["PROC_DATE"]).ToString().Trim().Equals(""))
            {
                //X.Msg.Alert("경고", "이미 처리된 데이터입니다.").Show();
                this.MsgCodeAlert("SRMQA00-0042");
                return false;
            }
            return true;
        }

        #endregion
    }
}
