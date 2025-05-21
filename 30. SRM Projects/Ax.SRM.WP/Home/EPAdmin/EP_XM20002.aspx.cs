#region ▶ Description & History
/* 
 * 프로그램명 : 관리자 > 권한관리 > 권한그룹메뉴설정
 * 설      명 : 
 * 최초작성자 : 이명희
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
    public partial class EP_XM20002 : BasePage
    {
        private string pakageName = "APG_EP_XM20002";        

        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM20002
        /// </summary>
        public EP_XM20002()
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
            //MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
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
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid02.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            }
            else if (id.Equals(ButtonID.Delete)) //삭제시 수정된 데이터만 저장한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid02.getRowsValues(false)", Mode = ParameterMode.Raw, Encode = true });
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
                case "btn01_MENUADD":
                    //메뉴 추가 버튼
                    menuADD();
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

                if (result.Tables[0].Rows.Count > 0)
                {
                    Cell_DoubleClick(result.Tables[0].Rows[0]["GROUPID"].ToString());
                    this.txt02_GROUPNAME.SetValue(result.Tables[0].Rows[0]["GROUPNAME"].ToString());
                }
                else
                {
                    this.txt02_GROUPNAME.SetValue(string.Empty);
                    Store2.RemoveAll();
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
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.cbo01_SYSTEMCODE.ReadOnly = true;
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_GROUP"), param);
        }

        /// <summary>
        /// getDataSetDetail
        /// </summary>
        /// <param name="groupID"></param>
        /// <returns></returns>
        private DataSet getDataSetDetail(string groupID)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("GROUPID", groupID);
            param.Add("LANGUAGE", this.UserInfo.LanguageShort);
            param.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_GROUP_MENU_AUTHORITY"), param);
        }

        private void Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                

                DataSet param = Util.GetDataSourceSchema
                (
                    "GROUPID", "MENUID", "SYSTEMCODE",
                    "BASICACLC", "BASICACLR", "BASICACLU", "BASICACLD",
                    "EXTACL1", "EXTACL2", "EXTACL3", "EXTACL4", "EXTACL5",
                    "EXTACL6", "EXTACL7", "EXTACL8", "EXTACL9", "EXTACL10",
                    "EXTACL11", "EXTACL12", "EXTACL13", "EXTACL14", "EXTACL15",
                    "EXTACL16", "EXTACL17", "EXTACL18", "EXTACL19", "EXTACL20",
                    "EXTACL21", "EXTACL22", "EXTACL23", "EXTACL24", "EXTACL25",
                    "EXTACL26", "EXTACL27", "EXTACL28", "EXTACL29", "EXTACL30",
                    "EXTACL31", "EXTACL32"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        this.hidGROUPID.Value
                        , parameters[i]["MENUID"]
                        , this.cbo01_SYSTEMCODE.Value
                        , parameters[i]["BASICACLC"].Equals("true") || parameters[i]["BASICACLC"].Equals("1") ? "1" : "0"
                        , parameters[i]["BASICACLR"].Equals("true") || parameters[i]["BASICACLR"].Equals("1") ? "1" : "0"
                        , parameters[i]["BASICACLU"].Equals("true") || parameters[i]["BASICACLU"].Equals("1") ? "1" : "0"
                        , parameters[i]["BASICACLD"].Equals("true") || parameters[i]["BASICACLD"].Equals("1") ? "1" : "0"
                        , parameters[i]["EXTACL1"].Equals("true") || parameters[i]["EXTACL1"].Equals("1") ? "1" : "0"
                        , parameters[i]["EXTACL2"].Equals("true") || parameters[i]["EXTACL2"].Equals("1") ? "1" : "0"
                        , parameters[i]["EXTACL3"].Equals("true") || parameters[i]["EXTACL3"].Equals("1") ? "1" : "0"
                        , parameters[i]["EXTACL4"].Equals("true") || parameters[i]["EXTACL4"].Equals("1") ? "1" : "0"
                        , parameters[i]["EXTACL5"].Equals("true") || parameters[i]["EXTACL5"].Equals("1") ? "1" : "0"
                        , null, null, null, null, null, null, null, null, null, null
                        , null, null, null, null, null, null, null, null, null, null
                        , null, null, null, null, null, null, null
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

                DataSet param = Util.GetDataSourceSchema("GROUPID", "MENUID", "SYSTEMCODE");

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (bool.Parse(parameters[i]["CHECK_VALUE"]))
                    {
                        param.Tables[0].Rows.Add(parameters[i]["GROUPID"], parameters[i]["MENUID"], this.cbo01_SYSTEMCODE.Value);
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

        /// <summary>
        /// Excel_Export
        /// </summary>
        private void Excel_Export()
        {
            try
            {
                DataSet result = getDataSetDetail(this.hidGROUPID.Value.ToString());

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

        /// <summary>
        /// 메뉴추가
        /// </summary>
        private void menuADD()
        {
            if (this.txt02_GROUPNAME.IsEmpty)
            {
                //권한을 선택하신 후 메뉴를 추가하세요.
                this.MsgCodeAlert_ShowFormat("SRMXM-0002");
                return;
            }

            HEParameterSet set = new HEParameterSet();
            set.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);

            Util.UserPopup(this, this.UserHelpURL.Text, set, "HELP_XM20002P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
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
        public void Cell_DoubleClick(string groupID)
        {
            this.hidGROUPID.SetValue(groupID);

            DataSet result = getDataSetDetail(groupID);

            this.Store2.DataSource = result.Tables[0];
            this.Store2.DataBind();
        }

        #endregion

    }
}
