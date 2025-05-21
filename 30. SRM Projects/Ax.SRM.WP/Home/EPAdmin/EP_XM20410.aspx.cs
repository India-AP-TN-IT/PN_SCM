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
using System.ServiceModel;


namespace Ax.EP.WP.Home.EPAdmin
{
    public partial class EP_XM20410 : BasePage
    {
        private string PAKAGE_NAME = "APG_EP_XM20410";
        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM20410
        /// </summary>
        public EP_XM20410()
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
                    string groupid = Request.QueryString["GROUPID"];
                    string category = Request.QueryString["CATEGORY"];
                    string title = Request.QueryString["TITLE"];
                    string afterSave = Request.QueryString["AFTERSAVE"]==null?"":Request.QueryString["AFTERSAVE"];


                    this.SetCombo(); //콤보상자 바인딩//임시저장
                    SetCategory();
                    //Library.GetBIZCD(this.cbo02_BIZCD, this.UserInfo.CorporationCode, false);
                    //Library.ComboDataBind(this.cbo02_PLANT_DIV, Library.GetTypeCode("U9").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true, "");//공장구분 콤보상자 바인딩
                    //Reset(); --> STROE REMOVE ALL시에 초기에 조회가 되지 않는 현상이 생겼음
                    InputInit();
                    txt01_TITLE.SetValue(string.Empty);
                    cbo01_GROUPID.SelectedItem.Value = "";
                    cbo01_GROUPID.UpdateSelectedItems();

                    cbo01_CATEGORY.SelectedItem.Value = "";
                    cbo01_CATEGORY.UpdateSelectedItems();                    
                    
                    txt01_TITLE.SetValue(title);        

                    cbo01_GROUPID.SelectedItem.Value = groupid;
                    cbo01_GROUPID.SetValue(groupid);
                    cbo01_GROUPID.UpdateSelectedItems();

                    cbo01_CATEGORY.SelectedItem.Value = category;
                    cbo01_CATEGORY.SetValue(category);
                    cbo01_CATEGORY.UpdateSelectedItems();
                    if (afterSave.Equals("Y")) Search();
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
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid02.getRowsValues({selectedOnly: false})", Mode = ParameterMode.Raw, Encode = true });
            }
            else if (id.Equals(ButtonID.Delete)) // 삭제시 선택된 데이터만 삭제한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw, Encode = true });
            }
            if (id == ButtonID.Search || id == ButtonID.M_Search)
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "Grid01";
                ibtn.DirectEvents.Click.EventMask.Msg = "Loading Data...";
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
                case ButtonID.Reset:
                    Reset();
                    break;
                case ButtonID.Search:
                    Search();
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

        #endregion

        #region [ 기능 ]
        /// <summary>
        /// Search
        /// </summary>
        public void Search()
        {
            try
            {
                InputInit();

                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();
                SetCategory();
                //cbo02_CATEGORY.SelectedItem.Index = 0;
                //cbo02_CATEGORY.UpdateSelectedItems();
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
            HEParameterSet paramSet = new HEParameterSet();
            paramSet.Add("TITLE", this.txt01_TITLE.Value);
            paramSet.Add("GROUPID", this.cbo01_GROUPID.Value);
            paramSet.Add("CATEGORY", this.cbo01_CATEGORY.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", PAKAGE_NAME, "INQUERY"), paramSet);
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

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            SearchInit();
            InputInit();
        }

        private void InputInit()
        {
            txt01_DOC_NO.SetValue(string.Empty);
            txt01_QUERY.SetValue(string.Empty);
            txt02_QUERY.SetValue(string.Empty);
            txt01_LINK_COLUMN.SetValue(string.Empty);
            txt02_TITLE.SetValue(string.Empty);
            cbo01_S_GROUPID.SelectedItem.Value = "";
            cbo01_S_GROUPID.UpdateSelectedItems();

            cbo02_CATEGORY.SelectedItem.Value = "";
            cbo02_CATEGORY.UpdateSelectedItems();
            Store2.RemoveAll();
        }

        private void SearchInit()
        {
            txt01_TITLE.SetValue(string.Empty);
            cbo01_GROUPID.SelectedItem.Value = "";
            cbo01_GROUPID.UpdateSelectedItems();

            cbo01_CATEGORY.SelectedItem.Value = "";
            cbo01_CATEGORY.UpdateSelectedItems();
            Store1.RemoveAll();
        }

        /// <summary>
        /// Save
        /// 저장
        /// </summary>
        /// <param name="actionType"></param>
        /// <summary>
        /// SaveAndDelete
        /// 저장(업데이트)
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {

            try
            {
                string doc_no = string.Empty;
                if (string.IsNullOrEmpty(txt01_DOC_NO.Value.ToString()))
                {
                    HEParameterSet paramSet = new HEParameterSet();
                    DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", PAKAGE_NAME, "INQUERY_DOC_NO"), paramSet);
                    doc_no = source.Tables[0].Rows[0]["DOC_NO"].ToString();
                }
                else doc_no = txt01_DOC_NO.Value.ToString();

                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                //if (parameters.Length == 0)
                //{
                //    this.MsgCodeAlert("COM-00020");
                //    return;
                //}
                DataSet removeParam = Util.GetDataSourceSchema
                (
                  "CORCD", "DOC_NO", "PARAM_NM"
                );

                removeParam.Tables[0].Rows.Add
                (
                        Util.UserInfo.CorporationCode,doc_no,""
                );

                DataSet saveParam_M = Util.GetDataSourceSchema
                (
                  "CORCD", "DOC_NO", "S_GROUPID", "TITLE", "CLOB$SCRIPT_QUERY", "CLOB$SUB_QUERY", "LINK_COLUMN", "USER_ID", "APPLY_LANGUAGE", "CATEGORY"
                );

                if (string.IsNullOrEmpty(txt02_TITLE.Value.ToString()))
                {
                    this.MsgCodeAlert_ShowFormat("CD00-0079", "txt02_TITLE", lbl02_SUBJECT.Text);
                    return;
                }

                saveParam_M.Tables[0].Rows.Add
                (
                        Util.UserInfo.CorporationCode
                        , doc_no
                        , cbo01_S_GROUPID.Value
                        , txt02_TITLE.Value
                        , txt01_QUERY.Value
                        , txt02_QUERY.Value
                        , txt01_LINK_COLUMN.Value
                        , this.UserInfo.UserID
                        , (chk02_APPLY_LANGUAGE.Value.ToString()).Equals("true") ? "Y" : "N"
                        , cbo02_CATEGORY.Value
                );

                DataSet saveParam_S = Util.GetDataSourceSchema
                (
                   "CORCD", "DOC_NO", "PARAM_NM", "LANG_CODE", "IS_VALIDATION"
                    , "PARAM_TYPE", "COMM_CODE", "DEFAULT_DATA", "SORT_SEQ", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    saveParam_S.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , doc_no
                        , parameters[i]["PARAM_NM"]
                        , parameters[i]["LANG_CODE"]
                        , parameters[i]["IS_VALIDATION"] == "true" || parameters[i]["IS_VALIDATION"].Equals("Y") ? "Y" : "N"
                        , parameters[i]["PARAM_TYPE"]
                        , parameters[i]["COMM_CODE"]                        
                        , parameters[i]["DEFAULT_DATA"]
                        , parameters[i]["SORT_SEQ"]                        
                        , this.UserInfo.UserID
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!Validation(saveParam_S.Tables[0].Rows[i], Library.ActionType.Save, Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }
                // 전체 삭제후 다시 넣음
                string[] procedure = new string[] { string.Format("{0}.{1}", PAKAGE_NAME, "REMOVE_PARAM"),
                                                    string.Format("{0}.{1}", PAKAGE_NAME, "SAVE_AXD9110"),
                                                    string.Format("{0}.{1}", PAKAGE_NAME, "SAVE_AXD9120")};
                DataSet[] param = new DataSet[] { removeParam, saveParam_M, saveParam_S };

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.MultipleExecuteNonQueryTx(procedure, param);                    
                    this.MsgCodeAlert("COM-00902");
                }
                Search();
                //string category = (cbo01_CATEGORY.Value == cbo02_CATEGORY.Value) ? cbo01_CATEGORY.Value.ToString() : cbo02_CATEGORY.Value.ToString();
                //X.Redirect("./EP_XM20410.aspx?TITLE=" + txt01_TITLE.Value + "&GROUPID=" + cbo01_GROUPID.Value + "&CATEGORY=" + category + "&AFTERSAVE=Y"); // combobox의 refresh가 되지 않아서 다시 재 접근                
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

                if (parameters.Count() == 0)
                {
                    this.MsgCodeAlert("COM-00100");
                    return;
                }

                DataSet save_query = Util.GetDataSourceSchema
                (
                   "CORCD", "DOC_NO"
                );
                save_query.Tables[0].Rows.Add(UserInfo.CorporationCode, parameters[0]["DOC_NO"].ToString());

                ////유효성 검사
                //if (!Validation(save_query.Tables[0].Rows[0], Library.ActionType.Delete))
                //{
                //    return;
                //}

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", PAKAGE_NAME, "REMOVE"), save_query);
                    this.MsgCodeAlert("COM-00903");                    
                }
                Search();
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
                InputInit();

                string json = e.ExtraParams["Values"];
                Dictionary<string, object>[] parameters = JSON.Deserialize<Dictionary<string, object>[]>(json);

                if (parameters.Length > 0)
                {
                    this.Inquery_Detail(parameters[0]["CORCD"].ToString(), parameters[0]["DOC_NO"].ToString(), parameters[0]["GROUPID"].ToString());
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

        private void Inquery_Detail(string CORCD, string DOC_NO, string GROUPID)
        {
            try
            {
                InputInit();

                HEParameterSet paramSet = new HEParameterSet();
                paramSet.Add("CORCD", CORCD);
                paramSet.Add("DOC_NO", DOC_NO);
                DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", PAKAGE_NAME, "INQUERY_DETAIL"), paramSet);

                if (source != null)
                {
                    txt02_TITLE.SetValue(source.Tables[0].Rows[0]["TITLE"].ToString());
                    txt01_QUERY.SetValue(source.Tables[0].Rows[0]["SCRIPT_QUERY"].ToString());
                    txt02_QUERY.SetValue(source.Tables[0].Rows[0]["SUB_QUERY"].ToString());
                    txt01_LINK_COLUMN.SetValue(source.Tables[0].Rows[0]["LINK_COLUMN"].ToString());
                    if (source.Tables[0].Rows[0]["APPLY_LANGUAGE"].ToString().Equals("Y")) chk02_APPLY_LANGUAGE.Checked = true; else chk02_APPLY_LANGUAGE.Checked = false;
                    txt01_DOC_NO.SetValue(DOC_NO);
                    cbo01_S_GROUPID.SelectedItem.Value = GROUPID;
                    cbo01_S_GROUPID.UpdateSelectedItems();

                    cbo02_CATEGORY.SelectedItem.Value = source.Tables[0].Rows[0]["CATEGORY"].ToString();
                    cbo02_CATEGORY.UpdateSelectedItems();
                }

                if (!string.IsNullOrEmpty(source.Tables[0].Rows[0]["PARAM_NM"].ToString()))
                {                    
                    this.Store2.DataSource = source.Tables[0];
                    this.Store2.DataBind();
                }
            }
            catch (FaultException<ExceptionDetail> ex)
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
            HEParameterSet paramSet_Menu = new HEParameterSet();
            paramSet_Menu.Add("LANG_SET", UserInfo.LanguageShort);
            DataSet source_Menu = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", PAKAGE_NAME, "INQUERY_MENU"), paramSet_Menu);
            Library.ComboDataBind(this.cbo01_S_GROUPID, source_Menu.Tables[0], false, "NAME", "ID", true, "");
            Library.ComboDataBind(this.cbo01_GROUPID, source_Menu.Tables[0], true, "NAME", "ID", true, "ALL");

            HEParameterSet paramSet = new HEParameterSet();
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", PAKAGE_NAME, "INQUERY_TYPE"), paramSet);
            Library.ComboDataBind(this.cbo01_PARAM_TYPE, source.Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);
            this.cbo01_PARAM_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.                        
        }

        private void SetCategory()
        {
            //this.cbo01_CATEGORY.Store[0].clear
            //this.cbo02_CATEGORY.Store[0].RemoveAll();
            
            HEParameterSet paramSet_Category = new HEParameterSet();
            DataSet source_Category = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", PAKAGE_NAME, "INQUERY_CATEGORY"), paramSet_Category);
            Library.ComboDataBind(this.cbo01_CATEGORY, source_Category.Tables[0], true, "NAME", "ID", true, "ALL");

            //Store15.DataSource = source_Category.Tables[0];
            //Store15.DataBind();
            //Store15.Reload();
            //X.Js.Call("refresh");
            Library.ComboDataBind(this.cbo02_CATEGORY, source_Category.Tables[0], true, "NAME", "ID", true, "");
            //this.cbo02_CATEGORY.Render();
        }

        #endregion

        #region [코드박스 이벤트 핸들러]

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
                string SORT_SEQ = Convert.ToString(parameter["SORT_SEQ"]);
                string PARAM_TYPE = Convert.ToString(parameter["PARAM_TYPE"]);
                string IS_VALIDATION = Convert.ToString(parameter["IS_VALIDATION"]);
                string PARAM_NM = Convert.ToString(parameter["PARAM_NM"]);

                if (System.Text.Encoding.UTF8.GetByteCount(PARAM_NM) == 0)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid02, "PARAM_NM"));
                    return false;
                }
                if (System.Text.Encoding.UTF8.GetByteCount(IS_VALIDATION) == 0)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid02, "IS_VALIDATION"));
                    return false;
                }
                if (System.Text.Encoding.UTF8.GetByteCount(PARAM_TYPE) == 0)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid02, "PARAM_TYPE"));
                    return false;
                }
                if (System.Text.Encoding.UTF8.GetByteCount(SORT_SEQ) == 0)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid02, "SORT_SEQ"));
                    return false;
                }
   
                    result = true;

            }
            // 삭제용 Validation
            else if (actionType == Library.ActionType.Delete)
            {
                if (String.IsNullOrEmpty(parameter["DOC_NO"].ToString()) || parameter["DOC_NO"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert("COM-00023");

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
