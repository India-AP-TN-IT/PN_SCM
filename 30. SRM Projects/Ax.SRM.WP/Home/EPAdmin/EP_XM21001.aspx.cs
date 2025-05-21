#region ▶ Description & History
/* 
 * 프로그램명 : 관리자 > 다국어관리 > 다국어관리
 * 설      명 : 
 * 최초작성자 : 배명희
 * 최초작성일 : 2014-11-03
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
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
using HE.Framework.Core.Report;

namespace Ax.EP.WP.Home.EP_XM
{
    public partial class EP_XM21001 : BasePage
    {
        private string pakageName = "APG_EP_XM21001";        

        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM21001
        /// </summary>
        public EP_XM21001()
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
                    //콤보 바인딩
                    SetCombo();
                    //초기 조회
                    Reset();

                    cbo01_LANG_Change(null, null);
                    cbo02_LANG3_Change(null, null);
                    cbo02_LANG4_Change(null, null);
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
                    new Ext.Net.Parameter { Name = "Values", Value = "ExtraParamAdd()", Mode = ParameterMode.Raw, Encode = true });
                //new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues(dirtyRowsOnly:true)", Mode = ParameterMode.Raw, Encode = true });
            }
            else if (id.Equals(ButtonID.Delete)) //삭제시 체크박스 체크된 데이터만 
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                    new Ext.Net.Parameter { Name = "Values", Value = "ExtraParamAdd()", Mode = ParameterMode.Raw, Encode = true });
                //new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues(selectedOnly:true)", Mode = ParameterMode.Raw, Encode = true });
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
                    Remove(sender, e);
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
            
        }

        #endregion

        #region [ 기능 ]

        /// <summary>
        /// COMBO BINDING
        /// </summary>
        private void SetCombo()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_LANG_SET"), param);

            Library.ComboDataBind(this.cbo01_LANG, source.Tables[0], false, "TYPECD2", "TYPECD", true);
            Library.ComboDataBind(this.cbo02_LANG1, source.Tables[0], false, "TYPECD2", "TYPECD", true);
            Library.ComboDataBind(this.cbo02_LANG2, source.Tables[0], false, "TYPECD2", "TYPECD", true);
            Library.ComboDataBind(this.cbo02_LANG3, source.Tables[0], false, "TYPECD2", "TYPECD", true);
            Library.ComboDataBind(this.cbo02_LANG4, source.Tables[0], false, "TYPECD2", "TYPECD", true);

            // 시스템 코드 콤보상자 바인딩
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", Util.UserInfo.CorporationCode);
            set.Add("BIZCD", Util.UserInfo.BusinessCode);
            set.Add("LANG_SET", Util.UserInfo.LanguageShort);
            set.Add("USER_ID", Util.UserInfo.UserID);
            DataSet source02 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SYSTEMCODE"), set);
            Library.ComboDataBind(this.cbo01_SYSTEMCODE, source02.Tables[0], false, "SYSTENAME", "SYSTEMCODE", true);
            Library.ComboDataBind(this.cbo02_SYSTEMCODE2, source02.Tables[0], false, "SYSTENAME", "SYSTEMCODE", true);
        }

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.cbo01_SYSTEMCODE.SelectedItem.Value = Util.UserInfo.SystemCode;
            this.cbo01_SYSTEMCODE.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_SYSTEMCODE.ReadOnly = true;

            this.cbo01_LANG.SelectedItem.Value = "KO";
            this.cbo01_LANG.UpdateSelectedItems(); //꼭 해줘야한다.

            this.Store1.RemoveAll();
            this.Store2.RemoveAll();
            this.cbo02_LANG3.SelectedItem.Value = "ZH";
            this.cbo02_LANG3.UpdateSelectedItems(); //꼭 해줘야한다.

            this.Store3.RemoveAll();
            this.cbo02_LANG4.SelectedItem.Value = "ZH";
            this.cbo02_LANG4.UpdateSelectedItems(); //꼭 해줘야한다.

            this.Store4.RemoveAll();
        }

        #region [ 조회 ]
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

                if (this.TabPanel1.ActiveTab.ID.Equals("Tab1"))
                {
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
                }
                else if (this.TabPanel1.ActiveTab.ID.Equals("Tab2"))
                {
                    this.Store2.DataSource = result.Tables[0];
                    this.Store2.DataBind();
                }
                else if (this.TabPanel1.ActiveTab.ID.Equals("Tab3"))
                {
                    this.Store3.DataSource = result.Tables[0];
                    this.Store3.DataBind();
                }
                else if (this.TabPanel1.ActiveTab.ID.Equals("Tab4"))
                {
                    this.Store4.DataSource = result.Tables[0];
                    this.Store4.DataBind();
                }
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
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            if (this.TabPanel1.ActiveTab.ID.Equals("Tab1"))
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CODE", this.txt01_CODE.Value);
                param.Add("CODENAME", this.txt01_CODENAME.Value);
                param.Add("LANGUAGE", this.cbo01_LANG.Value);

                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "AXD1400_INQUERY"), param);
            }
            else if (this.TabPanel1.ActiveTab.ID.Equals("Tab2"))
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CODE", this.txt01_CODE.Value);
                param.Add("MESSAGE", this.txt01_CODENAME.Value);
                param.Add("LANGUAGE", this.cbo01_LANG.Value);
                param.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "AXD1500_INQUERY"), param);
            }
            else if (this.TabPanel1.ActiveTab.ID.Equals("Tab3"))
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CODE", this.txt01_CODE.Value);
                param.Add("CODENAME", this.txt01_CODENAME.Value);
                param.Add("LANGUAGE", this.cbo01_LANG.Value);
                param.Add("TARGET_LANG", this.cbo02_LANG3.Value);
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "AXD1400_MULT_INQUERY"), param);
            }
            else if (this.TabPanel1.ActiveTab.ID.Equals("Tab4"))
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CODE", this.txt01_CODE.Value);
                param.Add("MESSAGE", this.txt01_CODENAME.Value);
                param.Add("LANGUAGE", this.cbo01_LANG.Value);
                param.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);
                param.Add("TARGET_LANG", this.cbo02_LANG4.Value);
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "AXD1500_MULTI_INQUERY"), param);
            }
            else
            {
                return null;
            }
        }

        #endregion

        #region [ 저장 ]

        private void Save(object sender, DirectEventArgs e)
        {            
            if (this.TabPanel1.ActiveTab.ID.Equals("Tab1"))
                Save_AXD1400(sender, e, "TAB1");
            else if (this.TabPanel1.ActiveTab.ID.Equals("Tab2"))
                Save_AXD1500(sender, e, "TAB2");
            else if (this.TabPanel1.ActiveTab.ID.Equals("Tab3"))
                Save_AXD1400(sender, e, "TAB3");
            else if (this.TabPanel1.ActiveTab.ID.Equals("Tab4"))
                Save_AXD1500(sender, e, "TAB4");
        }

        private void Save_AXD1400(object sender, DirectEventArgs e, string tabIndex)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                DataSet param = Util.GetDataSourceSchema
                (                
                    "CODE", "LANGUAGE", "CODENAME", "TYPE", "DESCRIPTION", "UPDATE_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (tabIndex.Equals("TAB1"))
                    {
                        param.Tables[0].Rows.Add
                        (
                            parameters[i]["CODE"]
                            , parameters[i]["LANGUAGE"]
                            , parameters[i]["CODENAME"]
                            , parameters[i]["TYPENM2"]
                            , parameters[i]["DESCRIPTION"]
                            , this.UserInfo.UserID
                        );
                    }
                    else
                    {
                        param.Tables[0].Rows.Add
                        (
                            parameters[i]["CODE"]
                            , this.cbo02_LANG3.Value
                            , parameters[i]["TARGET_CODENAME"]
                            , parameters[i]["TYPE"]
                            , parameters[i]["DESCRIPTION"]
                            , this.UserInfo.UserID
                        );
                    }
                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid_AXD1400(param.Tables[0].Rows[i], Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "AXD1400_SAVE"), param);
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

        private void Save_AXD1500(object sender, DirectEventArgs e, string tabIndex)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                DataSet param = Util.GetDataSourceSchema
                (
                    "CODE", "LANGUAGE", "MESSAGE", "TITLE", "SYSTEMCODE"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (tabIndex.Equals("TAB2"))
                    {
                        param.Tables[0].Rows.Add
                        (
                            parameters[i]["CODE"]
                            , parameters[i]["LANGUAGE"]
                            , parameters[i]["MESSAGE"]
                            , parameters[i]["TITLE"]
                            , parameters[i]["SYSTEMCODE"]
                        );
                    }
                    else
                    {
                        param.Tables[0].Rows.Add
                        (
                            parameters[i]["CODE"]
                            , this.cbo02_LANG4.Value
                            , parameters[i]["TARGET_MESSAGE"]
                            , parameters[i]["TARGET_TITLE"]
                            , parameters[i]["SYSTEMCODE"]
                        );
                    }
                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid_AXD1500(param.Tables[0].Rows[i], Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "AXD1500_SAVE"), param);
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

        #region [ 삭제 ]

        private void Remove(object sender, DirectEventArgs e)
        {
            if (this.TabPanel1.ActiveTab.ID.Equals("Tab1"))
                Remove_AXD1400(sender, e, "TAB1");
            else if (this.TabPanel1.ActiveTab.ID.Equals("Tab2"))
                Remove_AXD1500(sender, e, "TAB2");
            else if (this.TabPanel1.ActiveTab.ID.Equals("Tab3"))
                Remove_AXD1400(sender, e, "TAB2");
            else if (this.TabPanel1.ActiveTab.ID.Equals("Tab4"))
                Remove_AXD1500(sender, e, "TAB4");
        }

        private void Remove_AXD1400(object sender, DirectEventArgs e, string tabIndex)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);


                DataSet param = Util.GetDataSourceSchema("CODE", "LANGUAGE");

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (tabIndex.Equals("TAB1"))
                        param.Tables[0].Rows.Add(parameters[i]["CODE"], parameters[i]["LANGUAGE"]);
                    else
                        param.Tables[0].Rows.Add(parameters[i]["CODE"], this.cbo02_LANG3.Value);
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "AXD1400_REMOVE"), param);
                    this.MsgCodeAlert("COM-00002");
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

        private void Remove_AXD1500(object sender, DirectEventArgs e, string tabIndex)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);


                DataSet param = Util.GetDataSourceSchema("CODE", "LANGUAGE", "SYSTEMCODE");

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (tabIndex.Equals("TAB2"))
                        param.Tables[0].Rows.Add(parameters[i]["CODE"], parameters[i]["LANGUAGE"], parameters[i]["SYSTEMCODE"]);
                    else
                        param.Tables[0].Rows.Add(parameters[i]["CODE"], this.cbo02_LANG4.Value, parameters[i]["SYSTEMCODE"]);
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "AXD1500_REMOVE"), param);
                    this.MsgCodeAlert("COM-00002");
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
                    if (this.TabPanel1.ActiveTab.ID.Equals("Tab1"))
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);
                    else if (this.TabPanel1.ActiveTab.ID.Equals("Tab2"))
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid02);
                    else if (this.TabPanel1.ActiveTab.ID.Equals("Tab3"))
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid03);
                    else if (this.TabPanel1.ActiveTab.ID.Equals("Tab3"))
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid04);
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

        #region [ 유효성 검사 ]

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {            
            // 조회용 Validation            
            return true;
        }

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsSaveValid_AXD1400(DataRow parameter, int actionRow)
        {
            bool result = false;

            //COM-00904 : {0}번째 행의 {1}를(을) 입력해주세요.
            if (String.IsNullOrEmpty(parameter["CODE"].ToString()) || parameter["CODE"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "CODE"));
            else if (String.IsNullOrEmpty(parameter["LANGUAGE"].ToString()) || parameter["LANGUAGE"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "LANGUAGE"));
            else if (String.IsNullOrEmpty(parameter["CODENAME"].ToString()) || parameter["CODENAME"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "CODENAME"));
            else
                result = true;

            return result;
        }

        public bool IsSaveValid_AXD1500(DataRow parameter, int actionRow)
        {
            bool result = false;

            //COM-00904 : {0}번째 행의 {1}를(을) 입력해주세요.
            if (String.IsNullOrEmpty(parameter["SYSTEMCODE"].ToString()) || parameter["SYSTEMCODE"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "SYSTEMCODE"));
            else if (String.IsNullOrEmpty(parameter["CODE"].ToString()) || parameter["CODE"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "CODE"));
            else if (String.IsNullOrEmpty(parameter["MESSAGE"].ToString()) || parameter["MESSAGE"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "MESSAGE"));
            else if (String.IsNullOrEmpty(parameter["TITLE"].ToString()) || parameter["TITLE"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "TITLE"));
            else
                result = true;

            return result;
        }

        #endregion       

        #region [ 이벤트 ]

        protected void cbo01_LANG_Change(object sender, DirectEventArgs e)
        {
            this.S_SOURCE_CODENAME.Text = this.S_SOURCE_CODENAME.Text.IndexOf("(") > 0 ?
                string.Format("{0} ({1})", this.S_SOURCE_CODENAME.Text.Substring(0, this.S_SOURCE_CODENAME.Text.IndexOf("(")), cbo01_LANG.Value) :
                string.Format("{0} (KO)", this.S_SOURCE_CODENAME.Text);

            this.T_SOURCE_MESSAGE.Text = this.T_SOURCE_MESSAGE.Text.IndexOf("(") > 0 ?
                string.Format("{0} ({1})", this.T_SOURCE_MESSAGE.Text.Substring(0, this.T_SOURCE_MESSAGE.Text.IndexOf("(")), cbo01_LANG.Value) :
                string.Format("{0} (KO)", this.T_SOURCE_MESSAGE.Text);

            this.T_SOURCE_TITLE.Text = this.T_SOURCE_TITLE.Text.IndexOf("(") > 0 ?
                string.Format("{0} ({1})", this.T_SOURCE_TITLE.Text.Substring(0, this.T_SOURCE_TITLE.Text.IndexOf("(")), cbo01_LANG.Value) :
                string.Format("{0} (KO)", this.T_SOURCE_TITLE.Text);
        }

        protected void cbo02_LANG3_Change(object sender, DirectEventArgs e)
        {
            this.S_TARGET_CODENAME.Text = this.S_TARGET_CODENAME.Text.IndexOf("(") > 0 ?
                string.Format("{0} ({1})", this.S_TARGET_CODENAME.Text.Substring(0, this.S_TARGET_CODENAME.Text.IndexOf("(")), cbo02_LANG3.Value) :
                string.Format("{0} (ZH)", this.S_TARGET_CODENAME.Text);
        }

        protected void cbo02_LANG4_Change(object sender, DirectEventArgs e)
        {
            this.T_TARGET_MESSAGE.Text = this.T_TARGET_MESSAGE.Text.IndexOf("(") > 0 ?
               string.Format("{0} ({1})", this.T_TARGET_MESSAGE.Text.Substring(0, this.T_TARGET_MESSAGE.Text.IndexOf("(")), cbo02_LANG4.Value) :
               string.Format("{0} (ZH)", this.T_TARGET_MESSAGE.Text);

            this.T_TARGET_TITLE.Text = this.T_TARGET_TITLE.Text.IndexOf("(") > 0 ?
                string.Format("{0} ({1})", this.T_TARGET_TITLE.Text.Substring(0, this.T_TARGET_TITLE.Text.IndexOf("(")), cbo02_LANG4.Value) :
                string.Format("{0} (ZH)", this.T_TARGET_TITLE.Text);
        }

        #endregion
    }
}
