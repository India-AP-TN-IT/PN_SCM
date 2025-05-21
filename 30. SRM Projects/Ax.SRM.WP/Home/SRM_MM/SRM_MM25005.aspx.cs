#region ▶ Description & History
/* 
 * 프로그램명 : 서열납품관리(직서열) (구.VM3222)
 * 설      명 : 자재관리 > 서열투입현황 > 서열납품관리(직서열)
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-09-29
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
 *				2015-02-09      배명희     [삭제]버튼 추가. - 수정모드에서만 활성화.(입력한 조회조건에 해당하는 MM1061 데이터 삭제 기능)
 *
 * 
*/
#endregion
using System;
using System.Collections.Generic;
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM25005 : BasePage
    {
        private string pakageName = "APG_SRM_MM25005";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM25005
        /// </summary>
        public SRM_MM25005()
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
                    Library.ComboDataBind(this.cbo01_INSTALL_POS, Library.GetTypeCode("A7", "LR").Tables[0], false, "TYPECD", "OBJECT_ID", true);

                    SetCombo();
                    Reset();
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
            MakeButton(ButtonID.Regist, ButtonImage.New, "New", this.ButtonPanel);
            MakeButton(ButtonID.Modify, ButtonImage.Modify, "Modify", this.ButtonPanel);
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
            MakeButton(ButtonID.Delete, ButtonImage.Delete, "Delete", this.ButtonPanel);      
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
                if (this.hidMODE.Value.ToString().Equals("Regist"))
                {
                    ibtn.DirectEvents.Click.ExtraParams.Add(
                    new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues(false)", Mode = ParameterMode.Raw, Encode = true });
                }
                else
                {
                    ibtn.DirectEvents.Click.ExtraParams.Add(
                    new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
                }
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
                case ButtonID.Regist:
                    SetButton("ButtonRegist");
                    break;
                case ButtonID.Modify:
                    SetButton("ButtonModify");
                    break;
                case ButtonID.Save:
                    Save(sender, e);
                    break;
                case ButtonID.Delete:
                    Delete(sender);
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

        private void SetButton(string buttonID)
        {
            this.Store1.RemoveAll();

            txt01_FIRST.Value = string.Empty;
            txt01_SECOND.Value = string.Empty;
            txt01_THIRD.Value = string.Empty;

            if (buttonID == ButtonID.Regist) X.Js.Call("setButtonStatus", ButtonID.Regist);
            if (buttonID == ButtonID.Modify) X.Js.Call("setButtonStatus", ButtonID.Modify);
        }

        #endregion

        #region [ 기능 ]

        /// <summary>
        /// 콤보상자 바인딩(자재품목, 위치)
        /// </summary>
        private void SetCombo()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);

            string[] cursorNames = new string[] { "OUT_CURSOR_MI", "OUT_CURSOR_IP" };
            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_COMBO"), param, cursorNames);

            //위치
            //Library.ComboDataBind(this.SelectBox01_INSTALL_POS, ds.Tables[1], false, "TYPECD", "OBJECT_ID", true);
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

                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                //Reset();
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
            if (this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
                this.cdx01_VENDCD.ReadOnly = false;
            }
            else
            {
                this.cdx01_VENDCD.SetValue(this.UserInfo.VenderCD);
                this.cdx01_VENDCD.ReadOnly = true;
            }

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_INPUT_DATE.SetValue(DateTime.Now);

            this.cbo01_INSTALL_POS.SelectedItem.Value = "A7FL";
            this.cbo01_INSTALL_POS.UpdateSelectedItems();

            txt01_CHASU1.Value = string.Empty;
            txt01_CHASU2.Value = string.Empty;

            txt01_FIRST.Value = string.Empty;
            txt01_SECOND.Value = string.Empty;
            txt01_THIRD.Value = string.Empty;

            cdx01_LINECD.SetValue(string.Empty);
            cdx01_CONTCD.SetValue(string.Empty);

            //등록버튼 초기화
            SetButton("ButtonRegist");

            this.Store1.RemoveAll();
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
            param.Add("INPUT_DATE", ((DateTime)this.df01_INPUT_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("LINECD", this.cdx01_LINECD.Value);
            param.Add("CONTCD", this.cdx01_CONTCD.Value);
            param.Add("INSTALL_POS", this.cbo01_INSTALL_POS.Value);
            param.Add("CHASU1", this.txt01_CHASU1.Value);
            param.Add("CHASU2", this.txt01_CHASU2.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            string procedure = "";
            if (this.hidMODE.Value.ToString().Equals("Regist"))
            {
                procedure = "INQUERY_S01";
            }
            else
            {
                procedure = "INQUERY_S02";
            }

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);
        }

        /// <summary>
        /// SaveAndDelete
        /// 저장(업데이트)
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                   "UPDATE_ID", "QTY1", "QTY2", "QTY3", "ARRIV_TIME1", "ARRIV_TIME2", "ARRIV_TIME3", "CORCD", "BIZCD",
                   "VENDCD", "INPUT_DATE", "VINCD", "LINECD", "CONTCD", "INSTALL_POS", "CHASU1", "PARTNO", "PUTIN_SEQ",
                   "DN_DIV", "MAT_TYPE", "LANG_SET", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        this.UserInfo.UserID
                        , parameters[i]["VAN_DELI_QTY1"]
                        , parameters[i]["VAN_DELI_QTY2"]
                        , parameters[i]["VAN_DELI_QTY3"]
                        , this.txt01_FIRST.IsEmpty ? "":string.Format("{0}:{1}", this.txt01_FIRST.Value.ToString().Substring(0, 2), this.txt01_FIRST.Value.ToString().Substring(2))
                        , this.txt01_SECOND.IsEmpty ? "":string.Format("{0}:{1}", this.txt01_SECOND.Value.ToString().Substring(0, 2), this.txt01_SECOND.Value.ToString().Substring(2))
                        , this.txt01_THIRD.IsEmpty ? "":string.Format("{0}:{1}", this.txt01_THIRD.Value.ToString().Substring(0, 2), this.txt01_THIRD.Value.ToString().Substring(2))
                        , parameters[i]["CORCD"]
                        , parameters[i]["BIZCD"]
                        , parameters[i]["VENDCD"]
                        , (parameters[i]["INPUT_DATE"] == null ? string.Empty : DateTime.Parse(parameters[i]["INPUT_DATE"]).ToString("yyyy-MM-dd"))
                        , parameters[i]["VINCD"]
                        , parameters[i]["LINECD"]
                        , parameters[i]["CONTCD"]
                        , parameters[i]["INSTALL_POS"]
                        , parameters[i]["JIS_CNT"]
                        , parameters[i]["PARTNO"]
                        , parameters[i]["PUTIN_SEQ"]
                        , parameters[i]["DN_DIV"]
                        , parameters[i]["MAT_TYPE"]                       
                        , this.UserInfo.LanguageShort
                        , this.UserInfo.UserID
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid(param.Tables[0].Rows[i], parameters[i]["MAT_INPUT_QTY"], Convert.ToInt32(i.ToString())+1))
                    {
                        return;
                    }
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    if (this.hidMODE.Value.ToString().Equals("Regist"))
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param);
                        this.MsgCodeAlert("COM-00902");
                    }
                    else
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "MODIFY"), param);
                        this.MsgCodeAlert("COM-00003");
                    }

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
        /// SaveAndDelete
        /// 저장(업데이트)
        /// </summary>
        /// <param name="actionType"></param>
        public void Delete(object sender)
        {
            try
            {
                if (this.hidMODE.Value.ToString().Equals("Regist"))
                {
                    this.MsgCodeAlert("SCMMM-0019");//신규모드에서는 삭제할 수 없습니다.
                    return;
                }

                //유효성 검사
                if (!IsQueryValidation())
                {
                    return;
                }

                HEParameterSet param = new HEParameterSet();

                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.Value);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("INPUT_DATE", ((DateTime)this.df01_INPUT_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("LINECD", this.cdx01_LINECD.Value);
                param.Add("CONTCD", this.cdx01_CONTCD.Value);
                param.Add("INSTALL_POS", this.cbo01_INSTALL_POS.Value);
                param.Add("CHASU1", this.txt01_CHASU1.Value);
                param.Add("CHASU2", this.txt01_CHASU2.Value);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);
                                
                using (EPClientProxy proxy = new EPClientProxy())
                {

                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE"), param);
                    this.MsgCodeAlert("COM-00002"); //삭제되었습니다.                    

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

        #endregion

        #region [ 코드박스 이벤트 핸들러 ]

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_LINECD_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            // UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
            if (this.cbo01_BIZCD.Value == null)
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
            else
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.Value);

            cdx.UserParamSet.Add("VENDCD", this.cdx01_VENDCD.Value);
            cdx.UserParamSet.Add("INPUT_DATE", ((DateTime)this.df01_INPUT_DATE.Value).ToString("yyyy-MM-dd"));
        }

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_CONTCD_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            // UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
            if (this.cbo01_BIZCD.Value == null)
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
            else
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.Value);

            cdx.UserParamSet.Add("VENDCD", this.cdx01_VENDCD.Value);
            cdx.UserParamSet.Add("INPUT_DATE", ((DateTime)this.df01_INPUT_DATE.Value).ToString("yyyy-MM-dd"));
        }

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_VENDCD_AfterValidation(object sender, DirectEventArgs e)
        {
            //로그인한 사용자의 업체정보에 맞게 저장버튼 활성화
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "CHECK_ASN_YN"), param);
            Ext.Net.ImageButton btn;
            btn = (Ext.Net.ImageButton)this.ButtonPanel.FindControl("ButtonSave");

            if (ds.Tables[0].Rows.Count > 0)
            {
                if (!ds.Tables[0].Rows[0]["ASN_YN"].ToString().Equals("Y"))
                {
                    btn.Disabled = true;
                }
                else
                {
                    btn.Disabled = false;
                }
            }
            else
            {
                btn.Disabled = true;
            }
        }

        #endregion

        #region [ 유효성 검사 ]

        /// <summary>
        /// Validation
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="actionType"></param>
        /// <param name="actionRow"></param>
        /// <remarks>actionRow 는 Grid 타일경우에만 사용한다.</remarks>
        /// <returns>bool</returns>
        public bool IsSaveValid(DataRow parameter, string MATINPUTQTY, int actionRow = -1)
        {
            bool result = false;
            decimal MAT_INPUT_QTY = 0;
            decimal VAN_DELI_QTY1 = 0;
            decimal VAN_DELI_QTY2 = 0;
            decimal VAN_DELI_QTY3 = 0;

            if (!MATINPUTQTY.Equals(""))
                MAT_INPUT_QTY = Convert.ToDecimal(MATINPUTQTY);
            if (!parameter["QTY1"].ToString().Equals(""))
                VAN_DELI_QTY1 = Convert.ToDecimal(parameter["QTY1"].ToString());
            if (!parameter["QTY2"].ToString().Equals(""))
                VAN_DELI_QTY2 = Convert.ToDecimal(parameter["QTY2"].ToString());
            if (!parameter["QTY3"].ToString().Equals(""))
                VAN_DELI_QTY3 = Convert.ToDecimal(parameter["QTY3"].ToString());

            if (VAN_DELI_QTY1 > 0 && this.txt01_FIRST.IsEmpty)
                //{0} 도착예정시간을 입력하세요.
                this.MsgCodeAlert_ShowFormat("SCMMM-0002", "txt01_FIRST", DisplayField1.Text);
            else if (VAN_DELI_QTY2 > 0 && this.txt01_SECOND.IsEmpty)
                this.MsgCodeAlert_ShowFormat("SCMMM-0002", "txt01_SECOND", DisplayField3.Text);
            else if (VAN_DELI_QTY3 > 0 && this.txt01_THIRD.IsEmpty)
                this.MsgCodeAlert_ShowFormat("SCMMM-0002", "txt01_THIRD", DisplayField4.Text);
            else if (MAT_INPUT_QTY < VAN_DELI_QTY1 + VAN_DELI_QTY2 + VAN_DELI_QTY3)
                //{0}행의 납품수량의 합이 발주수량 보다 클 수 없습니다. 발주수량을 확인하세요.(EN)
                this.MsgCodeAlert_ShowFormat("SCMMM-0001", actionRow);
            else
                result = true;

            return result;
        }

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {            
            // 조회용 Validation
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.df01_INPUT_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_INPUT_DATE", lbl01_DELIVERYDATE.Text);
                return  false;
            }
            if (this.cdx01_LINECD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_LINECD", lbl01_LINECD.Text);
                return false;
            }
            if (this.cdx01_CONTCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_CONTCD", lbl01_CONTCD.Text);
                return false;
            }
            return true;
        }

        #endregion        
    }
}