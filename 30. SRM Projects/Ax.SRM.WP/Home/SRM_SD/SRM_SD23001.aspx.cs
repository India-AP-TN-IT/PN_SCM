#region ▶ Description & History
/* 
 * 프로그램명 : 생산협업 > 직납업체 모니터링 > 업체품목등록
 * 설      명 : 
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-15
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
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_SD
{
    public partial class SRM_SD23001 : BasePage
    {
        private string pakageName = "APG_SRM_SD23001";

        #region [ 초기설정 ]

        /// <summary>
        /// SCM_SD23001
        /// </summary>
        public SRM_SD23001()
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
                    Library.ComboDataBind(this.cbo02_WORK_DIR_DIV, Library.GetTypeCode("CA").Tables[0], false, "OBJECT_NM", "OBJECT_ID", false);
                    Library.ComboDataBind(this.cbo02_JIS_DIV, Library.GetTypeCode("D6").Tables[0], false, "OBJECT_NM", "OBJECT_ID", false);
                    this.StoreCombo.DataSource = Library.GetTypeCode("CA").Tables[0];
                    this.StoreCombo.DataBind();
                    Reset();

                    // 코드 팝업을 띄우기 위해서 text에서 enter를 입력할 경우 팝업을 띄움, 현재는 aspx단에서 keymap으로 코딩되어있음.
                    //Util.SettingEnterKeyEvent(this, this.cdx01_PARTNO, this.btn01_PARTNO);

                    //this.Search();                  
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
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            }
            else if (id.Equals(ButtonID.Delete)) // 삭제시 선택된 데이터만 삭제한다.
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
                case ButtonID.Delete:
                    Delete(sender, e);
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
                case "btn01_CUSTCD":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    Util.HelpPopup(this, "HELP_CUSTCD", PopupHelper.HelpType.Search, "GRID_CUSTCD_HELP01", this.CodeValue.Text, this.NameValue.Text, "");
                    break;
                case "btn01_VINCD":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    Util.CodePopup(this, "GRID_VINCD_HELP02", this.CodeValue.Text, this.NameValue.Text, "A3", "input");
                    break;
                case "btn01_PLANTCD":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    HEParameterSet set = new HEParameterSet();
                    set.Add("BIZCD", this.cbo01_BIZCD.Value);
                    set.Add("VENDORCD", this.CurrentRowCustCD.Text);
                    Util.HelpPopup(this, "HELP_CUST_PLANTCD", PopupHelper.HelpType.Search, "GRID_CUST_PLANT_HELP01", this.CodeValue.Text, this.NameValue.Text, "", 
                        PopupHelper.defaultPopupWidth, PopupHelper.defaultPopupHeight, set);
                    break;
                default:
                    break;
            }
        }

        #endregion

        #region [ 기능 ]
        /// <summary>
        /// 조회
        /// </summary>
        public void Search()
        {
            try
            {
                //유효성 검사
                if (!IsSearchValid())
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
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
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
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
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
            //업체코드는 서연이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cdx01_VENDCD.SetValue(string.Empty);
           
            this.Store1.RemoveAll();
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
                   "CORCD", "BIZCD", "VENDCD", "CUSTCD", "PLANTCD", "VINCD", "WORK_DIR_DIV", "CUST_ITEMCD", "CUST_ITEMNM", 
                   "JIS_DIV", "REMARK", "LANG_SET", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        this.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , this.cdx01_VENDCD.Value
                        , parameters[i]["CUSTCD"]
                        , parameters[i]["PLANTCD"]
                        , parameters[i]["VINCD"]
                        , parameters[i]["WORK_DIR_DIV"]
                        , parameters[i]["CUST_ITEMCD"]
                        , parameters[i]["CUST_ITEMNM"]
                        , parameters[i]["JIS_DIV"]
                        , parameters[i]["REMARK"]
                        , this.UserInfo.LanguageShort
                        , this.UserInfo.UserID
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid(param.Tables[0].Rows[i], Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
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

        /// <summary>
        /// 삭제
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void Delete(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                DataSet param = Util.GetDataSourceSchema(
                    "CORCD", "BIZCD", "VENDCD", "CUSTCD", "PLANTCD", "VINCD", "WORK_DIR_DIV", "CUST_ITEMCD", "LANG_SET", "USER_ID");
        
                for (int i = 0; i < parameters.Length; i++)
                {
                    if (bool.Parse(parameters[i]["CHECK_VALUE"]))
                    {
                        param.Tables[0].Rows.Add(
                            this.UserInfo.CorporationCode
                            , this.cbo01_BIZCD.Value
                            , this.cdx01_VENDCD.Value
                            , parameters[i]["CUSTCD"]
                            , parameters[i]["PLANTCD"]
                            , parameters[i]["VINCD"]
                            , parameters[i]["WORK_DIR_DIV"]
                            , parameters[i]["CUST_ITEMCD"]
                            , this.UserInfo.LanguageShort
                            , this.UserInfo.UserID
                        );

                        //유효성 검사
                        if (!IsDeleteValid(param.Tables[0].Rows[i], parameters[i]["ISNEW"].ToString(), Convert.ToInt32(parameters[i]["NO"])))
                        {
                            return;
                        }
                    }
                }

                // 선택된 데이터가 없을경우
                if (param.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert("COM-00100");
                    return;
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE"), param);
                    this.MsgCodeAlert("COM-00903");
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

        #region [ 유효성 검사 ]

        /// <summary>
        /// Validation
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="actionType"></param>
        /// <param name="actionRow"></param>
        /// <remarks>actionRow 는 Grid 타일경우에만 사용한다.</remarks>
        /// <returns>bool</returns>
        public bool IsSaveValid(DataRow parameter, int actionRow = -1)
        {
            bool result = false;
           
            //COM-00904 : {0}번째 행의 {1}를(을) 입력해주세요.
            if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "VENDCD"));

            else if (String.IsNullOrEmpty(parameter["CUSTCD"].ToString()) || parameter["CUSTCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "CUSTCD"));

            else if (String.IsNullOrEmpty(parameter["PLANTCD"].ToString()) || parameter["PLANTCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "PLANTCD"));

            else if (String.IsNullOrEmpty(parameter["VINCD"].ToString()) || parameter["VINCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "VINCD"));

            else if (String.IsNullOrEmpty(parameter["WORK_DIR_DIV"].ToString()) || parameter["WORK_DIR_DIV"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "WORK_DIR_DIV"));

            else if (String.IsNullOrEmpty(parameter["CUST_ITEMCD"].ToString()) || parameter["CUST_ITEMCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "CUST_ITEMCD"));

            else
                result = true;
           
            return result;
        }

        /// <summary>
        /// 삭제용 validation
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="actionRow"></param>
        /// <returns></returns>
        public bool IsDeleteValid(DataRow parameter, string isNew, int actionRow = -1)
        {
            bool result = false;
            
            // 삭제용 Validation           
            //COM-00905 : 해당 내역은 신규 데이터이므로 삭제할 수 없습니다.
            if (String.IsNullOrEmpty(isNew))
                this.MsgCodeAlert_ShowFormat("COM-00201");
            else
                result = true;

            return result;
        }

        /// <summary>
        /// 조회시 필수 입력 체크
        /// </summary>
        /// <returns></returns>
        public bool IsSearchValid()
        {
            bool result = false;

            //서연이화 내부 직원인 경우에는 필수 입력 체크 안함.
            //외부 협력업체인 경우에는 업체코드 필수 입력.
            if (this.UserInfo.UserDivision.Equals("T12")) 
                result = true;

            else
            {
                if (this.cdx01_VENDCD.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                    result = false;
                }
                else
                {
                    result = true;
                }
            }       
            return result;
        }

        #endregion

    }
}
