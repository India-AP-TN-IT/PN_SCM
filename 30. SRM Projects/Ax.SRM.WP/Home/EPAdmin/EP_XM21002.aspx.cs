#region ▶ Description & History
/* 
 * 프로그램명 : 관리자 > 다국어관리 > 다국어 메뉴별 설정
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-11-04
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
    public partial class EP_XM21002 : BasePage
    {
        private string pakageName = "APG_EP_XM21002";        

        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM21002
        /// </summary>
        public EP_XM21002()
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
                string msg = Library.getMessage("SRMXM-0011", Util.UserInfo.LanguageShort);
                ibtn.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                ibtn.DirectEvents.Click.Confirmation.Title = "Confirm";
                ibtn.DirectEvents.Click.Confirmation.Message = msg;
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid02.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            }

            if (id.Equals(ButtonID.Delete))
            {
                string msg = Library.getMessage("SRMXM-0016", Util.UserInfo.LanguageShort);
                ibtn.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                ibtn.DirectEvents.Click.Confirmation.Title = "Confirm";
                ibtn.DirectEvents.Click.Confirmation.Message = msg;
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid02.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
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
                case "btn01_QUERY":
                    //조회
                    getDataSet02_Query();
                    break;

                default:
                    break;
            }
        }

        #endregion

        #region [ 기능 ]

        /// <summary>
        /// COMBO BINDING
        /// </summary>
        private void SetCombo()
        {
            // 시스템 코드 콤보상자 바인딩
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", Util.UserInfo.CorporationCode);
            set.Add("BIZCD", Util.UserInfo.BusinessCode);
            set.Add("LANG_SET", Util.UserInfo.LanguageShort);
            set.Add("USER_ID", Util.UserInfo.UserID);
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SYSTEMCODE"), set);
            Library.ComboDataBind(this.cbo01_SYSTEMCODE, source.Tables[0], false, "SYSTENAME", "SYSTEMCODE", true);

            this.cbo01_SYSTEMCODE.SelectedItem.Value = Util.UserInfo.SystemCode.ToString();
            this.cbo01_SYSTEMCODE.UpdateSelectedItems();
            this.cbo01_SYSTEMCODE.ReadOnly = true;

            //모듈 콤보 세팅
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.SelectedItem.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);

            DataSet source02 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "AXD1300_INQUERY_MODULE"), param);
            Library.ComboDataBind(this.cbo01_MODULE, source02.Tables[0], true, "MENUNAME", "MENUID", true);

            this.cbo01_MODULE.SelectedItem.Value = "";
            this.cbo01_MODULE.UpdateSelectedItems();

            //언어 콤보 세팅
            HEParameterSet set02 = new HEParameterSet();
            set02.Add("CORCD", Util.UserInfo.CorporationCode);
            set02.Add("BIZCD", Util.UserInfo.BusinessCode);
            set02.Add("LANG_SET", Util.UserInfo.LanguageShort);
            set02.Add("USER_ID", Util.UserInfo.UserID);
            DataSet source03 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_LANG_SET"), set02);
            Library.ComboDataBind(this.cbo02_LANGUAGE, source03.Tables[0], false, "OBJECT_NM", "TYPECD", true);
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
            this.txt02_MENUID.SetValue(string.Empty);
            this.txt02_MENUNAME.SetValue(string.Empty);

            this.cbo02_LANGUAGE.SelectedItem.Value = "KO";
            this.cbo02_LANGUAGE.UpdateSelectedItems();

            this.chk02_INCLUDE_MSG.Checked = true;

            this.txt02_CODE.SetValue(string.Empty);
            this.txt02_CODENAME.SetValue(string.Empty);

            this.Store1.RemoveAll();
            this.Store2.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);
            param.Add("PARENTID", this.cbo01_MODULE.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet02()
        {
            string MENUID = this.txt02_MENUID.Text;
            string CODE = this.txt02_CODE.Text;
            string CODENAME = this.txt02_CODENAME.Text;
            string LANGUAGE = this.cbo02_LANGUAGE.Value.ToString();
            string INCLUDE_YN = this.chk02_INCLUDE_MSG.Checked ? "Y" : "N";

            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", Util.UserInfo.CorporationCode);
            set.Add("BIZCD", Util.UserInfo.BusinessCode);
            set.Add("MENUID", MENUID);
            set.Add("CODE", CODE);
            set.Add("CODENAME", CODENAME);
            set.Add("LANGUAGE", LANGUAGE);
            set.Add("INCLUDE_YN", INCLUDE_YN);
            set.Add("LANG_SET", Util.UserInfo.LanguageShort);
            set.Add("USER_ID", Util.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "AXD1420_INQUERY"), set);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private void getDataSet02_Query()
        {
            DataSet ds = getDataSet02();
            Store2.DataSource = ds.Tables[0];
            Store2.DataBind();
        }

        private void Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    this.MsgCodeAlert("SRMXM-0010");
                    return;
                }

                if (this.txt02_MENUID.Text.Equals(""))
                {
                    this.MsgCodeAlert("SRMXM-0013");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "MENUID", "CODE", "LANG_SET", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode,
                        Util.UserInfo.BusinessCode,
                        this.txt02_MENUID.Text,
                        parameters[i]["CODE"],
                        Util.UserInfo.LanguageShort,
                        Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "AXD1420_SAVE"), param);
                    this.chk02_INCLUDE_MSG.Checked = true;
                    getDataSet02_Query();
                    this.MsgCodeAlert("SRMXM-0012");
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
        /// Delete
        /// 삭제
        /// </summary>
        public void Delete(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    this.MsgCodeAlert("SRMXM-0015");
                    return;
                }

                if (this.txt02_MENUID.Text.Equals(""))
                {
                    this.MsgCodeAlert("SRMXM-0013");
                    return;
                }
                DataSet param = Util.GetDataSourceSchema
               (
                   "CORCD", "BIZCD", "MENUID", "CODE", "LANG_SET", "USER_ID"
               );

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode,
                        Util.UserInfo.BusinessCode,
                        this.txt02_MENUID.Text,
                        parameters[i]["CODE"],
                        Util.UserInfo.LanguageShort,
                        Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "AXD1420_REMOVE"), param);
                    this.chk02_INCLUDE_MSG.Checked = true;
                    getDataSet02_Query();
                    this.MsgCodeAlert("SRMXM-0014");
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
                DataSet result = getDataSet02();

                if (result == null) return;

                if (result.Tables[0].Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid02);
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

        #endregion

        #region [ 이벤트 ]

        [DirectMethod]
        public void Cell_DoubleClick(string menuID, string menuNAME)
        {
            try
            {
                this.txt02_MENUID.SetValue(menuID);
                this.txt02_MENUNAME.SetValue(menuNAME.Replace(".", "").Replace("┖", ""));

                if (this.txt02_MENUID.IsEmpty)
                {
                    Reset();
                    return;
                }

                getDataSet02_Query();
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

    }
}
