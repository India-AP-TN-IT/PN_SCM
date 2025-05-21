#region ▶ Description & History
/* 
 * 프로그램명 : 관리자 > 권한관리 > 메뉴관리
 * 설      명 : 
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-30
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
    public partial class EP_XM20005 : BasePage
    {
        private string pakageName = "APG_EP_XM20005";        

        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM20005
        /// </summary>
        public EP_XM20005()
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
                case "btn01_CPOY":
                    //간편 메뉴 복사 버튼
                    copyMENU();
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
            Library.ComboDataBind(this.cbo02_SYSTEMCODE, source.Tables[0], false, "SYSTENAME", "SYSTEMCODE", true);

            this.cbo01_SYSTEMCODE.SelectedItem.Value = Util.UserInfo.SystemCode;
            this.cbo01_SYSTEMCODE.UpdateSelectedItems();
            this.cbo01_SYSTEMCODE.ReadOnly = true;

            //모듈 콤보 세팅
            HEParameterSet param = new HEParameterSet();
            param.Add("DIVISION", "A");
            param.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.SelectedItem.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CODE"), param);
            Library.ComboDataBind(this.cbo01_MODULE, source.Tables[0], true, "MENUNAME", "MENUID", true);

            this.cbo01_MODULE.SelectedItem.Value = "";
            this.cbo01_MODULE.UpdateSelectedItems();

            DataTable dt = new DataTable();
            source = new DataSet();
            dt = new DataTable();
            dt.Columns.Add("CODE");
            dt.Columns.Add("NAME");

            dt.Rows.Add("0", "NONE");
            dt.Rows.Add("1", "NAVIGATE");
            dt.Rows.Add("2", "OPENUI");
            dt.Rows.Add("3", "EXPAND");

            source.Tables.Add(dt);
            Library.ComboDataBind(this.cbo02_MENUACTION, dt, false, "NAME", "CODE", true);
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
            //this.cbo01_SYSTEMCODE.SelectedItem.Value = "SRM";
            //this.cbo01_SYSTEMCODE.UpdateSelectedItems();
            this.cbo01_SYSTEMCODE.ReadOnly = true;

            //this.cbo01_MODULE.SelectedItem.Value = string.Empty;
            //this.cbo01_MODULE.UpdateSelectedItems();

            //Store1.RemoveAll();

            this.txt02_MENUID.SetValue(string.Empty);
            this.txt02_MENUID.ReadOnly = false;
            this.hidMODE.SetValue("Regist");
            this.txt02_MENUNAME.SetValue(string.Empty);

            this.cbo02_SYSTEMCODE.SelectedItem.Value = Util.UserInfo.SystemCode;
            this.cbo02_SYSTEMCODE.UpdateSelectedItems();
            this.cbo02_SYSTEMCODE.ReadOnly = true;

            this.cbo02_MENUACTION.SelectedItem.Value = string.Empty;
            this.cbo02_MENUACTION.UpdateSelectedItems();

            this.chk02_MENUHIDE3.SetValue(false);
            this.chk02_FORCEENABLED3.SetValue(false);
            this.chk02_EXPANDED3.SetValue(false);
            this.chk02_USEYN2.SetValue(true);

            this.txt02_MENUDLLURL.SetValue(string.Empty);
            this.txt02_MENUCLASS.SetValue(string.Empty);
            this.txt02_PARENTID.SetValue(string.Empty);
            this.txt02_MENUORDER.SetValue("0");
            this.txt02_EXTRAINFO.SetValue(string.Empty);

            HEParameterSet param = new HEParameterSet();
            param.Add("DIVISION", "B");
            param.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CODE"), param);
            this.Store2.DataSource = source.Tables[0];
            this.Store2.DataBind();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);
            param.Add("PARENTID", this.cbo01_MODULE.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        private void Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (this.txt02_MENUID.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt02_MENUID", lbl02_MENUID.Text);
                    return;
                }
                if (this.txt02_MENUNAME.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt02_MENUNAME", lbl02_MENUNAME.Text);
                    return;
                }
                if (this.cbo02_SYSTEMCODE.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo02_SYSTEMCODE", lbl02_SYSTEMCODE.Text);
                    return;
                }
                if (this.cbo02_MENUACTION.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo02_MENUACTION", lbl02_MENUACTION.Text);
                    return;
                }
                if (this.txt02_MENUORDER.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt02_MENUORDER", lbl02_SORT_SEQ.Text);
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "LANG_SET", "MENUID", "SYSTEMCODE", "MENUNAME", "MENUACTION", "MENUHIDE", "FORCEENABLED",
                    "EXPANDED", "MENUDLLURL", "MENUCLASS", "PARENTID", "EXTRAINFO", "MENUORDER", "USEYN", "MANAGERNO",
                    "GROUPID", "BASICACLC", "BASICACLR", "BASICACLU", "BASICACLD", "EXTACL1", "EXTACL2", "EXTACL3", "EXTACL4", "EXTACL5"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        this.UserInfo.LanguageShort
                        , this.txt02_MENUID.Value
                        , this.cbo02_SYSTEMCODE.Value
                        , this.txt02_MENUNAME.Value
                        , this.cbo02_MENUACTION.Value
                        , this.chk02_MENUHIDE3.Checked ? "1" : "0"
                        , this.chk02_FORCEENABLED3.Checked ? "1" : "0"
                        , this.chk02_EXPANDED3.Checked ? "1" : "0"
                        , this.txt02_MENUDLLURL.Value
                        , this.txt02_MENUCLASS.Value
                        , this.txt02_PARENTID.Value
                        , this.txt02_EXTRAINFO.Value
                        , this.txt02_MENUORDER.Value
                        , this.chk02_USEYN2.Checked ? "1" : "0"
                        , this.UserInfo.UserID
                        , parameters[i]["GROUPID"]
                        , parameters[i]["BASICACLC3"].ToString() == "true" || parameters[i]["BASICACLC3"].ToString() == "1" ? "1" : "0"
                        , parameters[i]["BASICACLR3"].ToString() == "true" || parameters[i]["BASICACLR3"].ToString() == "1" ? "1" : "0"
                        , parameters[i]["BASICACLU2"].ToString() == "true" || parameters[i]["BASICACLU2"].ToString() == "1" ? "1" : "0"
                        , parameters[i]["BASICACLD2"].ToString() == "true" || parameters[i]["BASICACLD2"].ToString() == "1" ? "1" : "0"
                        , parameters[i]["EXTACL1_2"].ToString() == "true" || parameters[i]["EXTACL1_2"].ToString() == "1" ? "1" : "0"
                        , parameters[i]["EXTACL2_2"].ToString() == "true" || parameters[i]["EXTACL2_2"].ToString() == "1" ? "1" : "0"
                        , parameters[i]["EXTACL3_2"].ToString() == "true" || parameters[i]["EXTACL3_2"].ToString() == "1" ? "1" : "0"
                        , parameters[i]["EXTACL4_2"].ToString() == "true" || parameters[i]["EXTACL4_2"].ToString() == "1" ? "1" : "0"
                        , parameters[i]["EXTACL5_2"].ToString() == "true" || parameters[i]["EXTACL5_2"].ToString() == "1" ? "1" : "0"
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
        /// Delete
        /// 삭제
        /// </summary>
        public void Delete()
        {
            try
            {
                if (this.hidMODE.Value.Equals("Regist"))
                {
                    this.MsgCodeAlert("COM-00023"); //삭제할 대상 Data가 없습니다.
                    return;
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    HEParameterSet param = new HEParameterSet();
                    param.Add("MENUID", this.txt02_MENUID.Value);
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE"), param);

                    this.MsgCodeAlert("COM-00903");
                    Search();
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
        /// 간편 메뉴 복사
        /// </summary>
        private void copyMENU()
        {
            if (this.hidMODE.Value.Equals("Regist"))
            {
                this.MsgCodeAlert("SRMXM-0001"); //복사할 메뉴를 선택하세요.
                return;
            }

            this.txt02_MENUID.SetValue(string.Empty);
            this.txt02_MENUID.ReadOnly = false;
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
        public void Cell_DoubleClick(string menuID)
        {
            // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
            HEParameterSet set1 = new HEParameterSet();
            set1.Add("DIVISION", "C");
            set1.Add("MENUID", menuID);
            set1.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);
            set1.Add("LANG_SET", this.UserInfo.LanguageShort);

            HEParameterSet set2 = new HEParameterSet();
            set2.Add("DIVISION", "D");
            set2.Add("MENUID", menuID);
            set2.Add("SYSTEMCODE", this.cbo01_SYSTEMCODE.Value);
            set2.Add("LANG_SET", this.UserInfo.LanguageShort);

            DataSet source1 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CODE"), set1);

            DataSet source2 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CODE"), set2);

            if (source1.Tables[0].Rows.Count > 0)
            {
                DataRow r = source1.Tables[0].Rows[0];

                this.txt02_MENUID.SetValue(r["MENUID"]);
                this.txt02_MENUID.ReadOnly = true;
                this.hidMODE.SetValue("Modify");

                this.txt02_MENUNAME.SetValue(r["MENUNAME"]);
                this.cbo02_SYSTEMCODE.SelectedItem.Value = r["SYSTEMCODE"].ToString();
                this.cbo02_SYSTEMCODE.UpdateSelectedItems();
                this.cbo02_MENUACTION.SelectedItem.Value = r["MENUACTION"].ToString();
                this.cbo02_MENUACTION.UpdateSelectedItems();

                this.chk02_MENUHIDE3.SetValue(r["MENUHIDE"].ToString().Equals("1") ? "true" : "false");
                this.chk02_FORCEENABLED3.SetValue(r["FORCEENABLED"].ToString().Equals("1") ? "true" : "false");
                this.chk02_EXPANDED3.SetValue(r["EXPANDED"].ToString().Equals("1") ? "true" : "false");
                this.chk02_USEYN2.SetValue(r["USEYN"].ToString().Equals("1") ? "true" : "false");

                this.txt02_MENUDLLURL.SetValue(r["MENUDLLURL"]);
                this.txt02_MENUCLASS.SetValue(r["MENUCLASS"]);
                this.txt02_PARENTID.SetValue(r["PARENTID"]);
                this.txt02_EXTRAINFO.SetValue(r["EXTRAINFO"]);
                this.txt02_MENUORDER.SetValue(r["MENUORDER"]);
            }

            this.Store2.DataSource = source2.Tables[0];
            this.Store2.DataBind();
        }

        #endregion

    }
}
