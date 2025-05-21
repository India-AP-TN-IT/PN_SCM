/* 
 * 프로그램명 : 개선 대책서 품질확인 등록    [D2](구.VQ2020)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-06
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
 *				
 *
 * 
*/
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

namespace Ax.QA.WP.Home.SRM_MP
{
    public partial class SRM_QA20003 : BasePage
    {
        private string pakageName = "APG_SRM_QA20003";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA20003
        /// </summary>
        public SRM_QA20003()
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
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, true);

                    SetCombo();

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
            else if (id.Equals(ButtonID.Present)) // 제출 시 선택된 데이터만 제출한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly:true})", Mode = ParameterMode.Raw, Encode = true });
            }
            else if (id.Equals(ButtonID.PresentCancle)) // 제출 취소시 선택된 데이터만 취소한다.
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
                case "btn01_POP_QA20003P1":
                    try
                    {
                        // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                        HEParameterSet param = new HEParameterSet();
                        param.Add("BIZCD", V_BIZCD.Value == null ? "" : V_BIZCD.Value);
                        param.Add("VENDCD", V_VENDCD.Value == null ? "" : V_VENDCD.Value);
                        param.Add("DOCNO", V_DOCNO.Value == null ? "" : V_DOCNO.Value);
                        param.Add("RCV_DATE", V_RCV_DATE.Value == null ? "" : ((DateTime)V_RCV_DATE.Value).ToString("yyyy-MM-dd"));
                        param.Add("DEFNO", V_DEFNO.Value == null ? "" : V_DEFNO.Value);
                        param.Add("DOCNO2", V_RCV_DATE.Value == null ? "" : V_DOCNO2.Value);

                        Util.UserPopup((BasePage)this.Form.Parent.Page, UserHelpURL.Text, param, "HELP_QA20003P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
                        break;
                    }
                    catch
                    {
                        return;
                    }
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
                this.Store1.RemoveAll();
                this.Store2.RemoveAll();

                if (this.cbo01_INSPECT_DIV.Value.Equals("FUFD"))
                {
                    this.GridPanel.Hidden = false;
                    this.GridPanel02.Hidden = true;
                    DataSet result = getDataSet();
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
                }
                else
                {
                    this.GridPanel.Hidden = true;
                    this.GridPanel02.Hidden = false;
                    DataSet result = getDataSet();
                    this.Store2.DataSource = result.Tables[0];
                    this.Store2.DataBind();
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
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("RCV_DATE", ((DateTime)this.df01_RCV_DATE.Value).ToString("yyyy-MM"));
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("ITEMID", this.cdx01_ITEM.Value);
            param.Add("INSPECT_DIV", this.cbo01_INSPECT_DIV.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet02()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SECOND"), param);
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
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }
            Store1.RemoveAll();

            this.cdx01_VINCD.SetValue("");
            this.cdx01_ITEM.SetValue("");
            this.cbo01_INSPECT_DIV.SelectedItem.Value = "FNINS01";
            this.cbo01_INSPECT_DIV.UpdateSelectedItems(); //꼭 해줘야한다.
            this.df01_RCV_DATE.SetValue(DateTime.Now.AddMonths(-1).ToString("yyyy-MM"));

            this.GridPanel.Hidden = false;
            this.GridPanel02.Hidden = true;
        }

        /// <summary>
        /// SaveAndDelete
        /// 저장
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "DOCDATE",
                    "VENDCD", "DEFNO", "USER_ID", "LANG_SET"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    param.Tables[0].Rows.Add(
                            Util.UserInfo.CorporationCode, this.cbo01_BIZCD.Value, DateTime.Now.ToString("yyyy-MM-dd"),
                            parameter[i]["VENDCD"], parameter[i]["DEFNO"], Util.UserInfo.UserID, Util.UserInfo.LanguageShort
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

        #endregion

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 벨리데이션
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void CodeBox_AfterValidation(object sender, DirectEventArgs e)
        {
            // 커스텀시 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            SetCombo();
        }

        #region [ 이벤트 ]

        #endregion

        #region [함수]

        //전체선택 및 그리드 컬럼 수정방지 
        private void GridEvent()
        {

        }

        private void SetCombo()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_INSPECT_DIV"), param);

            Library.ComboDataBind(this.cbo01_INSPECT_DIV, source.Tables[0], false, "CDNM", "CD", true);
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
                if (String.IsNullOrEmpty(this.cdx01_VENDCD.Value.ToString()) || this.cdx01_VENDCD.Value.ToString().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0002");

                else if (String.IsNullOrEmpty(parameter["PARTNM"].ToString()) || parameter["PARTNM"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "PARTNM"));

                else if (String.IsNullOrEmpty(parameter["STANDARD"].ToString()) || parameter["STANDARD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "STANDARD"));

                else if (String.IsNullOrEmpty(parameter["UNIT"].ToString()) || parameter["UNIT"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "UNIT"));

                else if (String.IsNullOrEmpty(parameter["QUOT_QTY"].ToString()) || parameter["QUOT_QTY"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_QTY"));

                else if (Convert.ToInt64(parameter["QUOT_QTY"]) <= 0)
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_QTY"));

                else if (String.IsNullOrEmpty(parameter["QUOT_UCOST"].ToString()) || parameter["QUOT_UCOST"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_UCOST"));

                else if (Convert.ToInt64(parameter["QUOT_UCOST"]) <= 0)
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_UCOST"));

                else if (String.IsNullOrEmpty(parameter["QUOT_DUTY"].ToString()) || parameter["QUOT_DUTY"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_DUTY"));

                else if (String.IsNullOrEmpty(parameter["QUOT_TEL"].ToString()) || parameter["QUOT_TEL"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_TEL"));

                else if (String.IsNullOrEmpty(parameter["DELI_DATE"].ToString()) || parameter["DELI_DATE"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "DELI_DATE"));

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
                if (String.IsNullOrEmpty(this.cdx01_VENDCD.Value.ToString()) || this.cdx01_VENDCD.Value.ToString().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0002");
                result = true;
            }

            return result;
        }

        #endregion
    }
}
