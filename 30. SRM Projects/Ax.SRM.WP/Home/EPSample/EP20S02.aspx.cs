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

namespace Ax.EP.WP.Home.EPSample
{
    /// <summary>
    /// <b>샘플프로그램</b>
    /// - 작 성 자 : 박의곤<br />
    /// - 작 성 일 : 2010-07-25<br />
    /// </summary>
    public partial class EP20S02 : BasePage
    {
        private string pakageName = "APG_EP20S02";

        #region [ 초기설정 ]

        /// <summary>
        /// EP20S02
        /// </summary>
        public EP20S02()
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
                    TextField_UpdateId.Text = this.UserInfo.UserID;

                    Library.GetBIZCD(this.SelectBox01_BIZCD, this.UserInfo.CorporationCode, true);

                    //그리드에서 EMPNO
                    DataTable dt = new DataTable();
                    dt.Columns.Add("TYPENM");
                    dt.Columns.Add("OBJECT_ID");
                    dt.Rows.Add("박주현", "1");
                    dt.Rows.Add("홍길동", "061208");
                    Library.ComboDataBind(this.SelectBox_Empno, dt, false, false);

                    //그리드 사업장 콤보             
                    Library.GetBIZCD(this.SelectBox_Bizcd, this.UserInfo.CorporationCode, false, false, "BIZNM", "BIZCD");

                    Reset();

                    // 코드 팝업을 띄우기 위해서 text에서 enter를 입력할 경우 팝업을 띄움, 현재는 aspx단에서 keymap으로 코딩되어있음.
                    //Util.SettingEnterKeyEvent(this, this.cdx01_PARTNO, this.btn01_PARTNO);
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
                case "btn02_VENDCD":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    Util.HelpPopup(this, "HELP_VENDCD", PopupHelper.HelpType.Search, "GRID_VENDCD_HELP01", this.CodeValue.Text, this.NameValue.Text, "");
                    break;
                case "btn02_PARTNO":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    Util.HelpPopup(this, "HELP_PARTNO", PopupHelper.HelpType.Search, "GRID_PARTNO_HELP01", this.CodeValue.Text, this.NameValue.Text, "");
                    break;
                case "btn02_VINNM":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    Util.CodePopup(this, "GRID_VINCD_HELP02", this.CodeValue.Text, this.NameValue.Text, "A3", "input");
                    break;
                case "btn02_ITEMNM":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    Util.CodePopup(this, "GRID_ITEMCD_HELP02", this.CodeValue.Text, this.NameValue.Text, "A4", "input");
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
            param.Add("BIZCD", SelectBox01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("PARTNO", this.cdx01_PARTNO.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
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
            this.SelectBox01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.SelectBox01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            //this.cdx01_VENDCD.SetValue(string.Empty);
            this.cdx01_VINCD.SetValue(string.Empty);
            this.cdx01_PARTNO.SetValue(string.Empty);
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
                   "CORCD", "BIZCD", "VENDCD", "PARTNO", "PARTNM", "VINCD", "ITEMCD", "STANDARD", "WEIGHT", "PACK_QTY"
                   , "BEG_DATE", "END_DATE", "EMPNO", "UPDATE_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode, parameters[i]["BIZCD"], parameters[i]["VENDCD"], parameters[i]["PARTNO"], parameters[i]["PARTNM"]
                        , parameters[i]["VINCD"], parameters[i]["ITEMCD"], parameters[i]["STANDARD"]
                        , parameters[i]["WEIGHT"]
                        , parameters[i]["PACK_QTY"]
                        , DateTime.Parse(parameters[i]["BEG_DATE"]).ToString("yyyy-MM-dd")
                        , DateTime.Parse(parameters[i]["END_DATE"]).ToString("yyyy-MM-dd")
                        , parameters[i]["EMPNO"], this.UserInfo.UserID
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
                    this.MsgCodeAlert("EP20S01_001");
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

                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "VENDCD", "PARTNO"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (bool.Parse(parameters[i]["CHECK_VALUE"]))
                    {
                        param.Tables[0].Rows.Add
                        (
                            Util.UserInfo.CorporationCode, parameters[i]["BIZCD"], parameters[i]["VENDCD"], parameters[i]["PARTNO"]
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
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_GRID"), param);
                    this.MsgCodeAlert("EP20S01_002");
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

        [DirectMethod]
        public void Cell_Click(string colname, int rowindex, int colindex)
        {
            //X.Js.Call("alert('" + colname + "'," + rowindex + "," + colindex + ")");
            X.Js.Call("alert", colname + "," + rowindex + "," + colindex);
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
                if (String.IsNullOrEmpty(parameter["BEG_DATE"].ToString()))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "BEG_DATE"));

                else if (String.IsNullOrEmpty(parameter["END_DATE"].ToString()))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "END_DATE"));

                else if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "VENDCD"));

                else if (String.IsNullOrEmpty(parameter["PARTNO"].ToString()) || parameter["PARTNO"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "PARTNO"));

                else if (String.IsNullOrEmpty(parameter["VINCD"].ToString()) || parameter["VINCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "VINNM"));

                else if (String.IsNullOrEmpty(parameter["ITEMCD"].ToString()) || parameter["ITEMCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "ITEMNM"));

                else if (String.IsNullOrEmpty(parameter["STANDARD"].ToString()) || parameter["STANDARD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "STANDARD"));

                else if (String.IsNullOrEmpty(parameter["WEIGHT"].ToString()) || parameter["WEIGHT"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "WEIGHT"));

                else if (String.IsNullOrEmpty(parameter["PACK_QTY"].ToString()) || parameter["PACK_QTY"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "PACK_QTY"));

                else if (String.IsNullOrEmpty(parameter["EMPNO"].ToString()) || parameter["EMPNO"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "EMPNO"));

                else
                    result = true;

            }
            // 삭제용 Validation
            else if (actionType == Library.ActionType.Delete)
            {
                if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "VENDCD"));

                else if (String.IsNullOrEmpty(parameter["PARTNO"].ToString()) || parameter["PARTNO"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S02-004", actionRow, Util.GetHeaderColumnName(Grid01, "PARTNO"));

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
