#region ▶ Description & History
/* 
 * 프로그램명 : 관리자 > 사용자 관리
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-11-03
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
using HE.Framework.Core.Report;

using System.IO;
using System.IO.Compression;


namespace Ax.EP.WP.Home.EPAdmin
{
    public partial class EP_XM22001 : BasePage
    {
        private string pakageName = "APG_EP_XM22001";

        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM22001
        /// </summary>
        public EP_XM22001()
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

                    this.SetCombo(); //콤보상자 바인딩//임시저장
                    Library.GetBIZCD(this.cbo02_BIZCD, this.UserInfo.CorporationCode, false);
                    Library.ComboDataBind(this.cbo02_PLANT_DIV, Library.GetTypeCode("U9").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true, "");//공장구분 콤보상자 바인딩
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
            MakeButton(ButtonID.Delete, ButtonImage.Delete, "Delete", this.ButtonPanel);
            MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
            MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
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

            if (id.Equals(ButtonID.Save))
            {
                string msg = Library.getMessage("SRMXM-0007", Util.UserInfo.LanguageShort);
                ibtn.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                ibtn.DirectEvents.Click.Confirmation.Title = "Confirm";
                ibtn.DirectEvents.Click.Confirmation.Message = msg;
            }

            if (id.Equals(ButtonID.Delete))
            {
                string msg = Library.getMessage("SRMXM-0008", Util.UserInfo.LanguageShort);
                ibtn.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                ibtn.DirectEvents.Click.Confirmation.Title = "Confirm";
                ibtn.DirectEvents.Click.Confirmation.Message = msg;
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
                    Save();
                    break;
                case ButtonID.Delete:
                    Delete();
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
                case "btn01_PWD_CHG":
                    Pwd_Chg();
                    break;

                case "btn01_ERROR_CLEAR":
                    Error_Clear();
                    break;

                default:
                    break;
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
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("USERID", this.txt01_USERID.Text);
            param.Add("USERNAME", this.txt01_USERNM.Text);
            param.Add("SYSCD", this.cbo01_SYSCD.Value);
            param.Add("USER_DIV", this.cbo01_USER_DIV.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);
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
                {
                    result.Tables[0].Columns.Remove("LINECD");
                    result.Tables[0].Columns.Remove("PLANT_DIV");
                    result.Tables[0].Columns.Remove("CERT_COURSE");
                    result.Tables[0].Columns.Remove("USER_DIV");
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

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.cbo01_SYSCD.SelectedItem.Value = Util.UserInfo.SystemCode;
            this.cbo01_SYSCD.UpdateSelectedItems(); //꼭 해줘야한다.;
            this.cbo01_SYSCD.ReadOnly = true;
            this.txt02_USERID.ReadOnly = false;
            this.txt02_USERID.SetValue(string.Empty);
            this.txt02_USERNAME.SetValue(string.Empty);
            //this.cbo02_USER_DIV.SelectedItem.Value = "T11";
            //this.cbo02_USER_DIV.UpdateSelectedItems(); //꼭 해줘야한다.;
            this.cdx02_VENDCD.SetValue(string.Empty);
            
            this.txt02_TELNO.SetValue(string.Empty);
            this.cbo02_CORCD.SelectedItem.Value = Util.UserInfo.CorporationCode;
            this.cbo02_CORCD.UpdateSelectedItems(); //꼭 해줘야한다.;
            this.cbo02_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo02_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.;
            this.df02_RETIRE_DATE.SetValue(DateTime.Parse("9999-12-31").Date.ToString("yyyy-MM-dd"));
            this.cbo02_PLANT_DIV.SelectedItem.Value = Util.UserInfo["PLANT_DIV"];
            this.cbo02_PLANT_DIV.UpdateSelectedItems(); //꼭 해줘야한다.;
            this.txt02_MOB_PHONE_NO.SetValue(string.Empty);
            this.cbo02_SYSCD.SelectedItem.Value = Util.UserInfo.SystemCode;
            this.cbo02_SYSCD.UpdateSelectedItems(); //꼭 해줘야한다.;
            this.cbo02_SYSCD.ReadOnly = true;
            this.cbo02_CERT_COURSE.SelectedItem.Value = "T4D";
            this.cbo02_CERT_COURSE.UpdateSelectedItems(); //꼭 해줘야한다.;
            this.txt02_EMAIL_ADDR.SetValue(string.Empty);
            this.chk02_ADMIN_FLAG.Checked = false;
            this.cdx02_EMPNO.SetValue(string.Empty);
            this.cdx01_VENDCD.SetValue(string.Empty);

            this.btn01_CLEAR_PWD.Disabled = true;
            this.btn02_ERROR_CLEAR.Disabled = true;
            this.txt01_CHECK_DIV.SetValue("false");
            this.txt01_MODE.SetValue("N");  //신규등록모드

            //권한그룹이 2000이 아닌 사람
            if (!this.txt01_GROUP_CD.Value.Equals("1"))
            {
                this.lbl02_ADMIN_FLAG.Visible = false;
                this.chk02_ADMIN_FLAG.Visible = false;
            }

            ((Ext.Net.Button)this.FindControl(ButtonID.Delete)).Visible = false;
            this.chk02_ADMIN_FLAG.ReadOnly = true;
            this.cbo02_CERT_COURSE.ReadOnly = true;

            this.Store1.RemoveAll();
        }

        /// <summary>
        /// Save
        /// 저장
        /// </summary>
        /// <param name="actionType"></param>
        public void Save()
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "USERID", "USER_ID", "LANG_SET", "USERNAME", "LINECD", "LINENAME", "SYSCD", 
                   "TELNO", "MOB_PHONE_NO", "EMAIL_ADDR", "RETIRE_DATE", 
                   "CORNAME", "SYSNAME", "BIZNAME", "PLANT_DIV", "CERT_COURSE", "USER_DIV",
                   "EMPNO",  "VENDCD", "ADMIN_FLAG"
                );

                string biznm = "";

                if (this.cbo02_BIZCD.SelectedItem.Text.Length > 0)
                {
                    int first = this.cbo02_BIZCD.SelectedItem.Text.LastIndexOf(":") + 2;
                    int second = this.cbo02_BIZCD.SelectedItem.Text.Length - first;
                    biznm = this.cbo02_BIZCD.SelectedItem.Text.Substring(first, second);
                }

                param.Tables[0].Rows.Add
                (
                    this.cbo02_CORCD.Value, this.cbo02_BIZCD.Value, this.txt02_USERID.Text, Util.UserInfo.UserID, Util.UserInfo.LanguageShort, this.txt02_USERNAME.Text, this.cdx01_VENDCD.Value, this.cdx01_VENDCD.Text, this.cbo02_SYSCD.Value
                    , this.txt02_TELNO.Text, this.txt02_MOB_PHONE_NO.Text, this.txt02_EMAIL_ADDR.Text, ((DateTime)this.df02_RETIRE_DATE.Value).ToString("yyyy-MM-dd")
                    , this.cbo02_CORCD.SelectedItem.Text, this.cbo02_SYSCD.Value, biznm, this.cbo02_PLANT_DIV.Value, this.cbo02_CERT_COURSE.Value, this.cbo02_USER_DIV.Value
                    , this.cdx02_EMPNO.Value, this.cdx02_VENDCD.Value, this.chk02_ADMIN_FLAG.Checked ? "1" : "0"                
                );

                //유효성 검사
                if (!Validation(param.Tables[0].Rows[0], Library.ActionType.Save))
                {
                    return;
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
        /// Delete
        /// 삭제
        /// </summary>
        /// <param name="actionType"></param>
        public void Delete()
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "USERID", "USER_ID", "LANG_SET"
                );

                param.Tables[0].Rows.Add
                (
                    this.cbo02_CORCD.Value, this.cbo02_BIZCD.Value, this.txt02_USERID.Text, Util.UserInfo.UserID
                );

                //유효성 검사
                if (!Validation(param.Tables[0].Rows[0], Library.ActionType.Delete))
                {
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

        /// <summary>
        /// RowSelect
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RowSelect(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, object>[] parameters = JSON.Deserialize<Dictionary<string, object>[]>(json);

                if (parameters.Length > 0)
                {
                    this.txt01_MODE.SetValue("U");  //기존데이터 수정
                    this.txt01_CHECK_DIV.SetValue("true");

                    this.txt02_USERID.SetValue(parameters[0]["USERID"]);
                    this.txt02_USERNAME.SetValue(parameters[0]["USERNAME"]);
                    this.cbo02_USER_DIV.SetValue(parameters[0]["USER_DIV"]);
                    this.cdx02_EMPNO.SetValue(parameters[0]["EMPNO"]);
                    this.txt02_TELNO.SetValue(parameters[0]["TELNO"]);
                    this.cdx02_VENDCD.SetValue(parameters[0]["VENDORCD"]);
                    
                    this.cbo02_CORCD.SetValue(parameters[0]["CORCD"]);
                    this.cbo02_CORCD.UpdateSelectedItems(); //꼭 해줘야한다.;
                    this.cbo02_BIZCD.SetValue(parameters[0]["BIZCD"]);
                    this.cbo02_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.;

                    //if (parameters[0]["USER_DIV"].ToString().Equals("T12"))
                    //    this.cdx02_LINECD.SetValue(parameters[0]["LINECD"]);
                    //else
                    //    this.cdx02_LINECD.SetValue(string.Empty);

                    this.cdx01_VENDCD.SetValue(parameters[0]["LINECD"]);

                    this.df02_RETIRE_DATE.SetValue(parameters[0]["RETIRE_DATE"]);
                    this.cbo02_PLANT_DIV.SetValue(parameters[0]["PLANT_DIV"]);
                    this.txt02_MOB_PHONE_NO.SetValue(parameters[0]["MOB_PHONE_NO"]);
                    this.cbo02_SYSCD.SetValue(parameters[0]["SYSCD"]);
                    this.cbo02_CERT_COURSE.SetValue(parameters[0]["CERT_COURSE"]);
                    this.txt02_EMAIL_ADDR.SetValue(parameters[0]["EMAIL_ADDR"]);
                    this.chk02_ADMIN_FLAG.SetValue(parameters[0]["ADMIN_FLAG"]);

                    this.txt02_USERID.ReadOnly = true;
                    this.btn01_CLEAR_PWD.Disabled = false;
                    this.btn02_ERROR_CLEAR.Disabled = false;
                }

                this.txt01_CHECK_DIV.SetValue("false");
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
        /// 콤보상자 바인딩(발생구분)
        /// </summary>
        private void SetCombo()
        {
            // 시스템 코드 콤보상자 바인딩
            HEParameterSet set03 = new HEParameterSet();
            set03.Add("CORCD", Util.UserInfo.CorporationCode);
            set03.Add("BIZCD", Util.UserInfo.BusinessCode);
            set03.Add("LANG_SET", Util.UserInfo.LanguageShort);
            set03.Add("USER_ID", Util.UserInfo.UserID);
            DataSet source03 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SYSTEMCODE"), set03);
            Library.ComboDataBind(this.cbo01_SYSCD, source03.Tables[0], true, "SYSTENAME", "SYSTEMCODE", true);
            Library.ComboDataBind(this.cbo02_SYSCD, source03.Tables[0], false, "SYSTENAME", "SYSTEMCODE", true);

            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", Util.UserInfo.CorporationCode);
            set.Add("BIZCD", Util.UserInfo.BusinessCode);
            set.Add("CLASS_ID", "T1");
            set.Add("LANG_SET", Util.UserInfo.LanguageShort);
            set.Add("USER_ID", Util.UserInfo.UserID);
            //사용자구분 콤보상자 바인딩
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_USER_DIV"), set, "OUT_CURSOR", "OUT_CURSOR2");
            Library.ComboDataBind(this.cbo01_USER_DIV, source.Tables[0], true, "TYPENM", "OBJECT_ID", false);
            Library.ComboDataBind(this.cbo02_USER_DIV, source.Tables[0], false, "TYPENM", "OBJECT_ID", false);

            this.txt01_GROUP_CD.SetValue(source.Tables[1].Rows[0]["GROUP_CD"].ToString());

            HEParameterSet set02 = new HEParameterSet();
            set02.Add("CORCD", Util.UserInfo.CorporationCode);
            set02.Add("BIZCD", Util.UserInfo.BusinessCode);
            set02.Add("LANG_SET", Util.UserInfo.LanguageShort);
            set02.Add("USER_ID", Util.UserInfo.UserID);
            //법인코드 콤보상자 바인딩
            DataSet source02 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CORCD"), set02);
            Library.ComboDataBind(this.cbo02_CORCD, source02.Tables[0], false, "TYPENM", "OBJECT_ID", true);

            //인증경로 인증경로
            DataTable dt02 = new DataTable();
            dt02.Columns.Add("TYPENM");
            dt02.Columns.Add("OBJECT_ID");
            dt02.Rows.Add("Active Directory", "T4A");
            dt02.Rows.Add("Database", "T4D");
            Library.ComboDataBind(this.cbo02_CERT_COURSE, dt02, false, false);
        }

        /// <summary>
        /// 비밀번호 초기화
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <param name="status"></param>
        public void Pwd_Chg()
        {
            try
            {
                //저장 후 전표를 출력 하시겠습니까?
                string[] msg = Library.getMessageWithTitle("SRMXM-0005");

                Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.Save_Password_Clear()",
                        Text = "YES"
                    },
                    No = new MessageBoxButtonConfig
                    {
                        Text = "NO"
                    }
                }).Show();
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
        /// 비밀번호 초기화
        /// </summary>
        /// <param name="v"></param>
        /// <param name="status"></param>
        [DirectMethod]
        public void Save_Password_Clear()
        {
            try
            {
                //패스워드 변경시 로그(axd1520) 등록 2018.10.18
                ActionHandle(this.GetMenuID(), "PWD_CHG");

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "USERID", "USER_ID", "LANG_SET"
                );

                param.Tables[0].Rows.Add
                (
                    this.cbo02_CORCD.Value, this.cbo02_BIZCD.Value, this.txt02_USERID.Text, Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_PASSWORD_CLEAR"), param);
                    this.MsgCodeAlert("SRMXM-0004");
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
        ///  오류 초기화
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <param name="status"></param>
        public void Error_Clear()
        {
            try
            {
                //저장 후 전표를 출력 하시겠습니까?
                string[] msg = Library.getMessageWithTitle("SRMXM-0009");

                Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.Save_Error_Cnt_Clear()",
                        Text = "YES"
                    },
                    No = new MessageBoxButtonConfig
                    {
                        Text = "NO"
                    }
                }).Show();
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
        /// 오류 초기화
        /// </summary>
        /// <param name="v"></param>
        /// <param name="status"></param>
        [DirectMethod]
        public void Save_Error_Cnt_Clear()
        {
            try
            {
                //오류 초기화시 로그(axd1520) 등록 2018.10.18
                ActionHandle(this.GetMenuID(), "ERROR_CLEAR");

                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "USERID", "USER_ID", "LANG_SET"
                );

                param.Tables[0].Rows.Add
                (
                    this.cbo02_CORCD.Value, this.cbo02_BIZCD.Value, this.txt02_USERID.Text, Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ERROR_CNT_CLEAR"), param);
                    this.MsgCodeAlert("SRMXM-0006");
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

        //사용자구분 변경 시
        [DirectMethod]
        public void SetUserDivComboChange()
        {
            if (this.txt01_CHECK_DIV.Text.Equals("false"))
            {
                string USER_DIV = this.cbo02_USER_DIV.Value.ToString();
                if (USER_DIV.Equals("T12"))
                {
                    this.cbo02_CERT_COURSE.SelectedItem.Value = "T4A";
                    this.cbo02_CERT_COURSE.UpdateSelectedItems(); //꼭 해줘야한다.;
                }
                else
                {
                    this.cbo02_CERT_COURSE.SelectedItem.Value = "T4D";
                    this.cbo02_CERT_COURSE.UpdateSelectedItems(); //꼭 해줘야한다.;
                }
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
        //public void CodeBox_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        //{
        //    //UserPopup 일 경우 넘어가는 파라메터 샘플코드 
        //    EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

        //    cdx.UserParamSet = new HEParameterSet();
        //    cdx.UserParamSet.Add("LINECD", this.cdx02_LINECD.Value);
        //    cdx.UserParamSet.Add("LINENM", this.cdx02_LINECD.Text);
        //}


        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 벨리데이션
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        //public void CodeBox_LinecdRemoteValidation(object sender, EP.UI.EPCodeBox_ValidationResult rsltSet)
        //{
        //    // 커스텀시 샘플코드 
        //    EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

        //    ///* DB 의 코드를 통한 검증 로직 작성 및 결과 값 리턴 - 여기부터 */
        //    HEParameterSet param = new HEParameterSet();
        //    param.Add("CORCD", Util.UserInfo.CorporationCode);
        //    param.Add("BIZCD", Util.UserInfo.BusinessCode);
        //    param.Add("LINECD", this.cdx01_VENDCD.Value);
        //    param.Add("PLANT_DIV", string.Empty);
        //    param.Add("LANG_SET", Util.UserInfo.LanguageShort);
        //    param.Add("USER_ID", Util.UserInfo.UserID);

        //    DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_LINECD_VALIDATION"), param);

        //    rsltSet.resultDataSet = ds;                                             //  결과 데이터셋
        //    rsltSet.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true; // 동일한 데이터가 있으면 true 없으면 false
        //    rsltSet.returnValueFieldName = "LINECD";
        //    rsltSet.returnTextFieldName = "LINENM";
        //}

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
        public bool Validation(DataRow parameter, Library.ActionType actionType, int actionRow = -1)
        {
            bool result = false;

           
            // 저장용 Validation
            if (actionType == Library.ActionType.Save)
            {

                if (this.txt02_USERID.Value.ToString().Length > 10)
                {
                    //사용자 아이디는 최대 10자리 입력 가능합니다.
                    this.MsgCodeAlert_ShowFormat("COM-00911", "txt02_USERID");
                    return false;
                }

                //string vendcd = "";
                
                string empno = "";
                string exist_yn = "";
                //사용자 구분에 따라 필수 입력해야할 필드가 있음.
                //[T11 고객    ]인 경우 "고객사코드" 필수
                //[T12 서연이화]인 경우 "사번" 필수
                //[T15 협력업체]인 경우 "협력업체코드" 필수
                //[T16 2차협력업체]인 경우 "협력업체코드" 필수
                if (this.cbo02_USER_DIV.Value.ToString().Equals("T15"))
                {
                    if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                    {
                        //vendcd = "false";
                    }
                }
                else if (this.cbo02_USER_DIV.Value.ToString().Equals("T16"))
                {
                    if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                    {
                       // vendcd = "false";
                    }
                }
                //else if (this.cbo02_USER_DIV.Value.ToString().Equals("T11"))
                //{
                //    if (String.IsNullOrEmpty(parameter["CUSTCD"].ToString()) || parameter["CUSTCD"].ToString().Trim().Equals(""))
                //    {
                        
                //    }
                //}
                else if (this.cbo02_USER_DIV.Value.ToString().Equals("T12"))
                {
                    if (String.IsNullOrEmpty(parameter["EMPNO"].ToString()) || parameter["EMPNO"].ToString().Trim().Equals(""))
                    {
                        empno = "false";
                    }
                }

                //if (!this.txt02_USERID.ReadOnly)  ==> 2014.11.18 요거 안먹힘.. 그래서 아래 txt01_MODE체크로직으로 변경(배명희)
                if(this.txt01_MODE.Value.Equals("N"))
                {
                    HEParameterSet set = new HEParameterSet();
                    set.Add("CORCD", Util.UserInfo.CorporationCode);
                    set.Add("BIZCD", Util.UserInfo.BusinessCode);
                    set.Add("USERID", this.txt02_USERID.Text);
                    set.Add("LANG_SET", Util.UserInfo.LanguageShort);
                    set.Add("USER_ID", Util.UserInfo.UserID);

                    exist_yn = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_EXIST"), set).Tables[0].Rows[0]["EXIST_YN"].ToString();
                }

                //if (vendcd.Equals("false"))
                //{
                //    this.MsgCodeAlert_ShowFormat("COM-00906", "cdx02_VENDCD", lbl02_VENDORCD.Text);
                //}


                if (empno.Equals("false"))
                {
                    this.MsgCodeAlert_ShowFormat("COM-00906", "cdx02_EMPNO", lbl02_EMPNO.Text);
                }

                else if (exist_yn.Equals("Y"))
                {
                    this.MsgCodeAlert_ShowFormat("SRMXM-0003", "cdx02_EMPNO", lbl02_EMPNO.Text);
                }

                else if (String.IsNullOrEmpty(parameter["USERNAME"].ToString()) || parameter["USERNAME"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("COM-00906", "txt02_USERNAME", lbl02_USERNAME.Text);

                //else if (this.cbo02_USER_DIV.Value.ToString().Equals("T12") && (String.IsNullOrEmpty(parameter["LINECD"].ToString()) || parameter["LINECD"].ToString().Trim().Equals("")))
                //    this.MsgCodeAlert_ShowFormat("COM-00906", "cdx02_LINECD", lbl02_LINECD.Text);

                //전화번호는 필수 아님 2015-03-06
                //else if (String.IsNullOrEmpty(parameter["TELNO"].ToString()) || parameter["TELNO"].ToString().Trim().Equals(""))
                //    this.MsgCodeAlert_ShowFormat("COM-00906", "txt02_TELNO", lbl02_TELNO.Text);
                //공장구분 필수
                else if (String.IsNullOrEmpty(parameter["PLANT_DIV"].ToString()) || parameter["PLANT_DIV"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("COM-00906", "cbo02_PLANT_DIV", lbl02_PLANT_DIV.Text);

                else if (String.IsNullOrEmpty(parameter["SYSCD"].ToString()) || parameter["SYSCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("COM-00906", "cbo02_SYSCD", lbl02_SYSCD.Text);

                else if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("COM-00906", "cdx02_VENDCD", lbl02_VENDORCD.Text);

                //else if (String.IsNullOrEmpty(parameter["MOB_PHONE_NO"].ToString()) || parameter["MOB_PHONE_NO"].ToString().Trim().Equals(""))
                //    this.MsgCodeAlert_ShowFormat("COM-00906", "txt02_MOB_PHONE_NO", lbl02_MOB_PHONE_NO.Text);

                //else if (String.IsNullOrEmpty(parameter["EMAIL_ADDR"].ToString()) || parameter["EMAIL_ADDR"].ToString().Trim().Equals(""))
                //    this.MsgCodeAlert_ShowFormat("COM-00906", "txt02_EMAIL_ADDR", lbl02_EMAIL_ADDR.Text);

                else if (String.IsNullOrEmpty(parameter["USER_DIV"].ToString()) || parameter["USER_DIV"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("COM-00906", "cbo02_USER_DIV", lbl02_USER_DIV.Text);

                else if (String.IsNullOrEmpty(parameter["CERT_COURSE"].ToString()) || parameter["CERT_COURSE"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("COM-00906", "cbo02_CERT_COURSE", lbl02_CERT_COURSE.Text);

                else
                    result = true;

            }
            // 삭제용 Validation
            else if (actionType == Library.ActionType.Delete)
            {
                if (String.IsNullOrEmpty(parameter["USERID"].ToString()) || parameter["USERID"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("COM-00023", "USERID", lbl02_USERID.Text);

                else
                    result = true;
            }
            // 처리용 Validation
            else if (actionType == Library.ActionType.Process)
            {
                result = true;
            }
            // 조회용 Validation
            else
            {
                result = true;
            }

            return result;
        }

        #endregion
    }
}
