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
    public partial class EP_XM20001 : BasePage
    {
        private string pakageName = "APG_EP_XM20001";
        
        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM20001
        /// </summary>
        public EP_XM20001()
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
                string msg = Library.getMessage("SRMXM-0028", Util.UserInfo.LanguageShort);
                ibtn.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                ibtn.DirectEvents.Click.Confirmation.Title = "Confirm";
                ibtn.DirectEvents.Click.Confirmation.Message = msg;
            }

            if (id.Equals(ButtonID.Delete))
            {
                string msg = Library.getMessage("SRMXM-0032", Util.UserInfo.LanguageShort);
                ibtn.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                ibtn.DirectEvents.Click.Confirmation.Title = "Confirm";
                ibtn.DirectEvents.Click.Confirmation.Message = msg;
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid02.getRowsValues(true)", Mode = ParameterMode.Raw, Encode = true });
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
            Library.ComboDataBind(this.cbo02_SYSTEMCODE, source.Tables[0], false, "SYSTENAME", "SYSTEMCODE", true);

            this.cbo01_SYSTEMCODE.SelectedItem.Value = Util.UserInfo.SystemCode;
            this.cbo01_SYSTEMCODE.UpdateSelectedItems();
            this.cbo01_SYSTEMCODE.ReadOnly = true;
            this.cbo02_SYSTEMCODE.SelectedItem.Value = Util.UserInfo.SystemCode;
            this.cbo02_SYSTEMCODE.UpdateSelectedItems();
            this.cbo02_SYSTEMCODE.ReadOnly = true;
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
            this.txt02_GROUPID.SetValue(string.Empty);
            this.txt02_GROUPID.ReadOnly = false;
            this.txt02_GROUPID_CHK.SetValue("false");
            this.txt02_GROUPNAME.SetValue(string.Empty);
            this.txt02_GROUPNOTE.SetValue(string.Empty);

            this.txt01_Check.SetValue("false");

            this.Store1.RemoveAll();
            this.Store2.RemoveAll();
            this.Store6.RemoveAll();
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
            param.Add("GROUPID", this.txt01_GROUPID.Text);
            param.Add("GROUPNAME", this.txt01_GROUPNAME.Text);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private void getDataSet02()
        {
            try
            {
                if (this.cdx02_EMPNO.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00906", "cdx02_EMPNO", this.lbl02_USERID.Text);
                    this.cdx02_EMPNO.Focus();
                    return;
                }

                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", Util.UserInfo.BusinessCode);
                param.Add("USERID", this.cdx02_EMPNO.Value);
                param.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                param.Add("USER_ID", Util.UserInfo.UserID);
                DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_AXD1110"), param);

                Store2.DataSource = ds.Tables[0];
                Store2.DataBind();

                this.txt01_Check.SetValue("true");
            }
            catch (Exception ex)
            {
                MsgCodeAlert(ex.ToString());
            }
            finally
            {
            }
        }

        /// <summary>
        /// excel
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSetExcel()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("USERID", this.cdx02_EMPNO.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_AXD1110"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private void getDataSet03()
        {
            string GROUPID = this.txt02_GROUPID.Text;

            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", Util.UserInfo.CorporationCode);
            set.Add("BIZCD", Util.UserInfo.BusinessCode);
            set.Add("GROUPID", GROUPID);
            set.Add("LANG_SET", Util.UserInfo.LanguageShort);
            set.Add("USER_ID", Util.UserInfo.LanguageShort);

            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_USERBYGROUPID"), set);
            Store6.DataSource = ds.Tables[0];
            Store6.DataBind();
        }

        private void Save(object sender, DirectEventArgs e)
        {
            try
            {
                #region validations...

                if (this.txt02_GROUPID.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00906", "txt02_GROUPID", this.lbl02_GROUPID.Text);
                    this.txt02_GROUPID.Focus();
                    return;
                }

                if (this.cbo02_SYSTEMCODE.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00906", "cbo02_SYSTEMCODE", this.lbl02_SYSTEMCODE.Text);
                    this.cbo02_SYSTEMCODE.Focus();
                    return;
                }

                if (this.txt02_GROUPNAME.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00906", "txt02_GROUPNAME", this.lbl02_GROUPNAME.Text);
                    this.txt02_GROUPNAME.Focus();
                    return;
                }

                #endregion


                DataSet param = Util.GetDataSourceSchema
               (
                   "CORCD", "BIZCD", "SYSTEMCODE", "GROUPID", "GROUPNAME", "GROUPNOTE", "LANG_SET", "USER_ID"
               );

                param.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode,
                    Util.UserInfo.BusinessCode,
                    this.cbo02_SYSTEMCODE.Value,
                    Convert.ToInt32(this.txt02_GROUPID.Text),
                    this.txt02_GROUPNAME.Text,
                    this.txt02_GROUPNOTE.Text,
                    Util.UserInfo.LanguageShort,
                    Util.UserInfo.UserID
                );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param);
                    this.txt02_GROUPID.ReadOnly = true;
                    this.txt02_GROUPID_CHK.SetValue("true");
                    DataSet ds = getDataSet();
                    Store1.DataSource = ds.Tables[0];
                    Store1.DataBind();
                    this.MsgCodeAlert("SRMXM-0029");//MsgBox.Show("입력하신 권한을 저장하였습니다.");
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
                if (!this.txt02_GROUPID_CHK.Text.Equals("true"))
                {
                    this.MsgCodeAlert("SRMXM-0030");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
               (
                   "CORCD", "BIZCD", "GROUPID", "LANG_SET", "USER_ID"
               );

                param.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode,
                    Util.UserInfo.BusinessCode,
                    Convert.ToInt32(this.txt02_GROUPID.Text),
                    Util.UserInfo.LanguageShort,
                    Util.UserInfo.UserID
                );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE"), param);
                    Reset();
                    DataSet ds = getDataSet();
                    Store1.DataSource = ds.Tables[0];
                    Store1.DataBind();
                    this.MsgCodeAlert("SRMXM-0031");
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
        
        // 사용자 권한그룹 확인 및 권한 복사 조회
        [DirectMethod]
        public void btn01_QueryId()
        {
            try
            {
                getDataSet02();
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
        /// 복사대상 사용자ID 입력 팝업
        /// </summary>
        private void CopyPop()
        {
            HEParameterSet set = new HEParameterSet();
            Util.UserPopup(this, this.UserHelpURL.Text, set, "HELP_XM20001P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
        }

        // 사용자 권한 복사
        [DirectMethod]
        public void btn01_CopyId()
        {
            try
            {
                if (!txt01_Check.Text.Equals("true"))
                {
                    this.MsgCodeAlert("SRMXM-0017");
                    this.cdx02_EMPNO.Focus();
                    return;
                }

                CopyPop();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        // 사용자 권한 복사
        [DirectMethod]
        public void CopyID(string userid, bool chk)
        {
            try
            {
                if (userid.Length == 0)
                {
                    this.MsgCodeAlert("SRMXM-0022");//MsgBox.Show("복사작업이 취소되었습니다.");
                    return;
                }

                ////if (MsgBox.Show("권한을 모두 복사하시겠습니까?", "주의",
                //if (MsgCodeBox.Show("SRMXM-0023",
                //    MessageBoxButtons.YesNo) != DialogResult.Yes)
                //    return;

                DataSet param = Util.GetDataSourceSchema
               (
                   "CORCD", "BIZCD", "TOUSERID", "USERID", "OPTION", "LANG_SET", "USER_ID"
               );

                param.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode,
                    Util.UserInfo.BusinessCode,
                    userid,
                    this.cdx02_EMPNO.Value,
                    chk == true ? "Y" : "N",
                    Util.UserInfo.LanguageShort,
                    Util.UserInfo.UserID
                );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "COPY_AXD1110"), param);
                    this.cdx02_EMPNO.SetValue(userid);
                    getDataSet02();
                    this.MsgCodeAlert("SRMXM-0021");//MsgBox.Show("조회된 권한을 모두 복사하였습니다.");
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

        // 사용자 권한그룹 확인 및 권한 복사 삭제
        [DirectMethod]
        public void btn01_DeleteId(string json)
        {
            try
            {
                if (!this.txt01_Check.Text.Equals("true"))
                {
                    this.MsgCodeAlert("SRMXM-0017");
                    this.cdx02_EMPNO.Focus();
                    return;
                }

                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    this.MsgCodeAlert("SRMXM-0018");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
               (
                   "CORCD", "BIZCD", "USERID", "GROUPID", "LANG_SET", "USER_ID"
               );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (parameters[i]["CHK"].Equals("true"))
                    {
                        param.Tables[0].Rows.Add
                        (
                            Util.UserInfo.CorporationCode,
                            Util.UserInfo.BusinessCode,
                            parameters[i]["USERID"],
                            parameters[i]["GROUPID"],
                            Util.UserInfo.LanguageShort,
                            Util.UserInfo.UserID
                        );
                    }
                }

                if (param.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert("SRMXM-0018");
                    return;
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_AXD1110"), param);
                    this.MsgCodeAlert("SRMXM-0020");
                    getDataSet02();
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

        // 권한그룹 상세 권한추가
        [DirectMethod]
        public void btn01_AddGroupId()
        {
            try
            {
                if (!this.txt02_GROUPID_CHK.Text.Equals("true"))
                {
                    this.MsgCodeAlert("SRMXM-0024");
                    return;
                }

                if (!this.txt01_Check.Text.Equals("true") || this.cdx02_EMPNO.Value.Equals(""))
                {
                    this.MsgCodeAlert("SRMXM-0025");
                    this.cdx02_EMPNO.Focus();
                    return;
                }

                ////if (MsgBox.Show("선택하신 권한을 해당 사용자의 권한그룹에 추가하시겠습니까?", "주의",
                //if (MsgCodeBox.Show("XM00-0015",
                //    MessageBoxButtons.OKCancel) != DialogResult.OK)
                //    return;

                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "USERID", "GROUPID", "LANG_SET", "USER_ID"
                );

                param.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode,
                    Util.UserInfo.BusinessCode,
                    this.cdx02_EMPNO.Value,
                    this.txt02_GROUPID.Text,
                    Util.UserInfo.LanguageShort,
                    Util.UserInfo.UserID
                );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "ADD_AXD1110"), param);
                    getDataSet02();
                    this.MsgCodeAlert("SRMXM-0027");
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
                if (this.cdx02_EMPNO.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00906", "cdx02_EMPNO", this.lbl02_USERID);
                    this.cdx02_EMPNO.Focus();
                    return;
                }

                DataSet result = getDataSetExcel();

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
            return true;
        }

        #endregion

        #region [ 이벤트 ]

        [DirectMethod]
        public void Cell_DoubleClick(string groupID, string groupNAME, string groupNOTE)
        {
            try
            {
                this.txt02_GROUPID.SetValue(groupID);
                this.txt02_GROUPNAME.SetValue(groupNAME);
                this.txt02_GROUPNOTE.SetValue(groupNOTE);

                this.cdx02_EMPNO.SetValue(string.Empty);
                this.txt02_GROUPID.ReadOnly = true;
                this.txt02_GROUPID_CHK.SetValue("true");

                if (this.txt02_GROUPID.IsEmpty)
                {
                    Reset();
                    return;
                }

                getDataSet03();
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
