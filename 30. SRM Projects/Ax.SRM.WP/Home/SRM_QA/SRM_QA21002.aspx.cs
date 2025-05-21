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

    public partial class SRM_QA21002 : BasePage
    {
        private string pakageName = "APG_SRM_QA21002";
        

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA21002
        /// </summary>
        public SRM_QA21002()
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
            MakeButton(ButtonID.TakeException, ButtonImage.TakeException, "TakeException", this.ButtonPanel);
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

            if (id.Equals(ButtonID.TakeException)) //저장시 수정된 데이터만 저장한다.
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
                case ButtonID.TakeException:
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
            set02.Add("COLUMN_ID", "FORMOBJ_TYPE");
            set02.Add("LANG_SET", this.UserInfo.LanguageShort);
            set02.Add("USER_ID", this.UserInfo.UserID);

            //그리드 의뢰유형 콤보상자 바인딩 처리
            source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_FORMOBJ_TYPE"), set02);
            Library.ComboDataBind(this.cbo02_FORMOBJ_TYPE, source.Tables[0], false, false);
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

            this.df01_OCCUR_MONTH.SetValue(DateTime.Now.ToString("yyyy-MM"));

            this.cbo01_OCCUR_DIV.SelectedItem.Value = "FUFD";
            this.cbo01_OCCUR_DIV.UpdateSelectedItems(); //꼭 해줘야한다.

            if (cbo02_OCCUR_DIV.Items.Count > 0)
            {
                this.cbo02_OCCUR_DIV.SelectedItem.Value = "INMIP";
                this.cbo02_OCCUR_DIV.UpdateSelectedItems(); //꼭 해줘야한다.
            }

            this.cbo02_OCCUR_DIV.Hide();
            this.lbl02_OCCUR_DIV.Hide();

            this.cbo02_FORMOBJ_TYPE.SelectedItem.Index = 0;
            this.cbo02_FORMOBJ_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cdx01_DOCRPTNO.SetValue(string.Empty);

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
        /// SaveAndDelete
        /// 저장
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                string json02 = e.ExtraParams["Values02"];
                Dictionary<string, string>[] grid01Param = JSON.Deserialize<Dictionary<string, string>[]>(json);
                Dictionary<string, string>[] grid02Param = JSON.Deserialize<Dictionary<string, string>[]>(json02);

                //이의제기 번호
                string[] tmpFormobjNo = null;
                if (grid01Param.Count() > 0 && grid02Param.Count() <= 0)
                {
                    //필드크레임
                    tmpFormobjNo = formobjNo(grid01Param[0]["VENDCD"].ToString(), ((DateTime)this.df01_OCCUR_MONTH.Value).ToString("yyyyMM"));
                    //이의제기번호 가져오지 못할경우
                    if (tmpFormobjNo == null) return;

                    if (grid01Param.Length == 0)
                    {
                        this.MsgCodeAlert("COM-00020");
                        return;
                    }

                    //저장
                    formobjSave(json, tmpFormobjNo);
                }
                else if (grid02Param.Count() > 0 && grid01Param.Count() <= 0)
                {
                    //자체크레임
                    tmpFormobjNo = formobjNo(grid02Param[0]["VENDCD"].ToString(), ((DateTime)this.df01_OCCUR_MONTH.Value).ToString("yyyyMM"));
                    //이의제기번호 가져오지 못할경우
                    if (tmpFormobjNo == null) return;

                    if (grid02Param.Length == 0)
                    {
                        this.MsgCodeAlert("COM-00020");
                        return;
                    }

                    //저장
                    formobjSave(json02, tmpFormobjNo);
                }
                else
                {
                    //X.Msg.Alert("경고","이의제기할 데이터가 없습니다.").Show();
                    this.MsgCodeAlert("SRMQA00-0014");
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

        // 이의제기 헤더 및 상세 저장 및 수정
        public void formobjSave(string grid, string[] formobjNo)
        {
            //이의제기 헤더 저장공간
            DataSet param01 = Util.GetDataSourceSchema
            (
               "CORCD", "BIZCD", "DOCRPTNO",
               "FORMOBJNO", "OFFDOC_DIV", "RROG_DIV",
               "COM_YN", "CLAIM_OCCUR_DIV", "FORMOBJ_TYPE", "USER_ID", "LANG_SET"
            );

            //이의제기 상세 저장공간
            DataSet param02 = Util.GetDataSourceSchema
            (
               "CORCD", "BIZCD", "DOCRPTNO",
               "DOCRPT_SEQ", "FORMOBJNO", "USER_ID", "LANG_SET"
            );

            Dictionary<string, object>[] parameter = JSON.Deserialize<Dictionary<string, object>[]>(grid);
            for (int i = 0; i < parameter.Length; i++)
            {
                if (parameter[i]["NO02"].ToString().Equals("N"))
                {

                    string tmpFormobjNo = "";
                    switch (parameter[i]["FORMOBJ_TYPE"].ToString())
                    {
                        case "F2A":
                            tmpFormobjNo = formobjNo[0];
                            break;
                        case "F2B":
                            tmpFormobjNo = formobjNo[1];
                            break;
                        case "F2C":
                            tmpFormobjNo = formobjNo[2];
                            break;
                    }

                    if (formobjHearderCheck(param01, parameter[i]["FORMOBJ_TYPE"].ToString()))
                    {
                        param01.Tables[0].Rows.Add(
                            parameter[i]["CORCD"], parameter[i]["BIZCD"], parameter[i]["DOCRPTNO"],
                            tmpFormobjNo, parameter[i]["OFFDOC_DIV"], parameter[i]["RROG_DIV"],
                            parameter[i]["COM_YN"], parameter[i]["CLAIM_OCCUR_DIV"], parameter[i]["FORMOBJ_TYPE"], Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                        );
                    }

                    param02.Tables[0].Rows.Add(
                            parameter[i]["CORCD"], parameter[i]["BIZCD"], parameter[i]["DOCRPTNO"],
                            parameter[i]["DOCRPT_SEQ02"], tmpFormobjNo
                    );
                }
                else if (parameter[i]["NO02"].ToString().Equals("U"))
                {
                    param01.Tables[0].Rows.Add(
                        parameter[i]["CORCD"], parameter[i]["BIZCD"], parameter[i]["DOCRPTNO"],
                        parameter[i]["FORMOBJNO"], parameter[i]["OFFDOC_DIV"], parameter[i]["RROG_DIV"],
                        parameter[i]["COM_YN"], parameter[i]["CLAIM_OCCUR_DIV"], parameter[i]["FORMOBJ_TYPE"], Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                    );
                }
            }

            using (EPClientProxy proxy = new EPClientProxy())
            {
                if (param01.Tables[0].Rows.Count > 0)
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_QA4030"), param01);
                }

                if (param02.Tables[0].Rows.Count > 0)
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_QA4031"), param02);
                }
                //X.Msg.Alert("확인", "이의제기 등록 및 수정되었습니다.").Show();
                this.MsgCodeAlert("SRMQA00-0015");
                Search();
            }
        }

        //이의제기 헤더 데이터 체크 중복방지
        public bool formobjHearderCheck(DataSet ds, string formobjType)
        {
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (ds.Tables[0].Rows[i]["FORMOBJ_TYPE"].Equals(formobjType))
                    {
                        return false;
                    }
                }
            }
            return true;
        }

        //이의제기번호 가져오기
        public string[] formobjNo(string vendcd, string yyyymm)
        {
            //각 유형별 이의제기 번호 담을 변수 생성
            string[] formobjNo = null;
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("FORMOBJNO", vendcd + yyyymm);
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            DataSet result = EPClientHelper.ExecuteDataSet("APG_SRM_QA21002.INQUERY_FORMOBJNO", param);
            if (result.Tables[0].Rows.Count > 0)
            {
                formobjNo = new string[3];
                int cnt = Convert.ToInt32(result.Tables[0].Rows[0][0]);
                for (int i = 0; i < formobjNo.Length; i++)
                {
                    cnt++;
                    formobjNo[i] = vendcd + yyyymm + string.Format("{0:00}", cnt);
                }
            }
            return formobjNo;
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
            param.Add("PROC_DATE", ((DateTime)this.df01_OCCUR_MONTH.Value).ToString("yyyy-MM"));  
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
            param.Add("PROC_DATE", ((DateTime)this.df01_OCCUR_MONTH.Value).ToString("yyyy-MM"));
            param.Add("CLAIM_OCCUR_DIV", this.cbo01_OCCUR_DIV.Value);
            param.Add("OCCUR_DIV", this.cbo02_OCCUR_DIV.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_JCLAIM"), param);
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
            if (this.cbo01_BIZCD.Value == null)
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
            else
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.Value);

            cdx.UserParamSet.Add("VENDCD", this.cdx01_VENDCD.Value);
            cdx.UserParamSet.Add("PROC_DATE", ((DateTime)this.df01_OCCUR_MONTH.Value).ToString("yyyy-MM"));
            if (this.cbo01_OCCUR_DIV.Value == null)
                cdx.UserParamSet.Add("CLAIM_OCCUR_DIV", this.cbo01_OCCUR_DIV.SelectedItem.Value);
            else
                cdx.UserParamSet.Add("CLAIM_OCCUR_DIV", this.cbo01_OCCUR_DIV.Value);
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
            param.Add("VENDCD", cdx01_VENDCD.Value);
            param.Add("PROC_DATE", ((DateTime)this.df01_OCCUR_MONTH.Value).ToString("yyyy-MM"));
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

        #endregion
    }
}
