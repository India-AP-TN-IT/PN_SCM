#region ▶ Description & History
/* 
 * 프로그램명 : ALC관리 > 품목 차수량 등록
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-17
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

namespace Ax.EP.WP.Home.SRM_VM
{
    public partial class SRM_VM20007 : BasePage
    {
        private string pakageName = "APG_SRM_VM20007";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_VM20007
        /// </summary>
        public SRM_VM20007()
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
                    Library.GetBIZCD(this.SelectBox_Bizcd, this.UserInfo.CorporationCode, false, false, "BIZNM", "BIZCD");

                    DataTable source = Library.GetTypeCode("VD").Tables[0];
                    Library.ComboDataBind(this.cbo01_WORK_DIV, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_WORK_DIV.UpdateSelectedItems(); //꼭 해줘야한다.                        
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
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
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
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({selectedOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            }
            else if (id.Equals(ButtonID.Delete)) // 삭제시 선택된 데이터만 삭제한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly:true})", Mode = ParameterMode.Raw, Encode = true });
            }
            if (id == ButtonID.Search || id == ButtonID.M_Search)
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "Grid_Main";
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
                case "btn01_VENDCD":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    Util.HelpPopup(this, "HELP_VENDCD", PopupHelper.HelpType.Search, "GRID_VENDCD_HELP01", this.CodeValue.Text, this.NameValue.Text, "");
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
                if (!Validation(null, Library.ActionType.Search, 0))
                {
                    return;
                }

                DataSet result = getDataSet(Util.UserInfo.CorporationCode,this.cdx01_VENDCD.Value.ToString(), UserInfo.LanguageShort, "INQUERY");
                this.Store2.DataSource = result.Tables[0];
                this.Store2.DataBind();
                this.Store1.RemoveAll();
                this.TextField_H_Vendcd.SetValue(string.Empty);

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
        private DataSet getDataSet(string corcd, string vendcd, string lang_set, string procedure)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", corcd);
            param.Add("VENDCD", vendcd);
            param.Add("LANG_SET", lang_set);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);
        }

        /// <summary>
        /// Excel_Export
        /// </summary>
        private void Excel_Export()
        {
            try
            {
                DataSet result = getDataSet(Util.UserInfo.CorporationCode, this.cdx01_VENDCD.Value.ToString(), UserInfo.LanguageShort, "INQUERY");

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
            this.cdx01_VENDCD.SetValue(string.Empty);
            this.Store1.RemoveAll();
            this.Store2.RemoveAll();
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
                   "CORCD", "VENDCD", "VEND_SEQ", "MGRNM", "DEPART", "TELNO", "CELLNO", "NOTE_DISP_YN", "SMS_YN", "OEM_SMS_YN", "FAXNO", "EMAIL", "EMAIL_YN", "WORK_DIV", "BIZCD", "EMPNO", "TAX_YN", "USE_YN", "REMARK", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , parameters[i]["VENDCD"]
                        , parameters[i]["VEND_SEQ"]
                        , parameters[i]["MGRNM"]
                        , parameters[i]["DEPART"]
                        , parameters[i]["TELNO"]
                        , parameters[i]["CELLNO"]
                        , parameters[i]["NOTE_DISP_YN"] == "true" || parameters[i]["NOTE_DISP_YN"].Equals("Y") ? "Y" : "N"
                        , parameters[i]["SMS_YN"] == "true" || parameters[i]["SMS_YN"].Equals("Y") ? "Y" : "N"
                        , parameters[i]["OEM_SMS_YN"] == "true" || parameters[i]["OEM_SMS_YN"].Equals("Y") ? "Y" : "N"
                        , parameters[i]["FAXNO"]
                        , parameters[i]["EMAIL"]
                        , parameters[i]["EMAIL_YN"] == "true" || parameters[i]["EMAIL_YN"].Equals("Y") ? "Y" : "N"
                        , parameters[i]["WORK_DIV"]
                        , parameters[i]["BIZCD"]
                        , parameters[i]["EMPNO"]
                        , parameters[i]["TAX_YN"] == "true" || parameters[i]["TAX_YN"].Equals("Y") ? "Y" : "N"
                        , parameters[i]["USE_YN"] == "true" || parameters[i]["USE_YN"].Equals("Y") ? "Y" : "N"
                        , parameters[i]["REMARK"]                        
                        , this.UserInfo.UserID
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!Validation(param.Tables[0].Rows[i], Library.ActionType.Save, Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param);
                    this.MsgCodeAlert("COM-00902");

                    Set_DetailGrid(Util.UserInfo.CorporationCode, parameters[0]["VENDCD"].ToString(), UserInfo.LanguageShort, "INQUERY_DETAIL");

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

                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "VENDCD", "VEND_SEQ"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (bool.Parse(parameters[i]["CHECK_VALUE"]))
                    {
                        param.Tables[0].Rows.Add
                        (
                            Util.UserInfo.CorporationCode, parameters[i]["VENDCD"], parameters[i]["VEND_SEQ"]
                        );

                        //유효성 검사
                        if (!Validation(param.Tables[0].Rows[i], Library.ActionType.Delete, Convert.ToInt32(parameters[i]["NO"])))
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
                    Set_DetailGrid(Util.UserInfo.CorporationCode, parameters[0]["VENDCD"].ToString(), UserInfo.LanguageShort, "INQUERY_DETAIL");
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

        [DirectMethod]
        public void Cell_Click(string colname, int rowindex, int colindex)
        {
            //X.Js.Call("alert('" + colname + "'," + rowindex + "," + colindex + ")");
            X.Js.Call("alert", colname + "," + rowindex + "," + colindex);
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
                    DataSet result = getDataSet(Util.UserInfo.CorporationCode, parameters[0]["VENDCD"].ToString(), UserInfo.LanguageShort, "INQUERY_DETAIL");
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
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

        private void Set_DetailGrid(string corcd, string vendcd, string lang, string proc)
        {
            DataSet result = getDataSet(corcd, vendcd, lang, proc);
            this.Store1.DataSource = result.Tables[0];
            this.Store1.DataBind();
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
        public bool Validation(DataRow parameter, Library.ActionType actionType, int actionRow = -1)
        {
            bool result = false;

            // 저장용 Validation
            if (actionType == Library.ActionType.Save)
            {
                if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMALC00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "VENDCD"));
                else
                    result = true;

            }
            // 삭제용 Validation
            else if (actionType == Library.ActionType.Delete)
            {
                if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMALC00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "VENDCD"));
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
                //if (this.cdx01_VENDCD.IsEmpty)
                //    this.MsgCodeAlert_ShowFormat("SRMALC00-0004", "CDX01_VENDCD", lbl01_CUST.Text);

                result = true;
            }

            return result;
        }

        #endregion
    }
}
