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

namespace Ax.EP.WP.Home.SRM_ALC
{
    public partial class SRM_VM20008 : BasePage
    {
        private string pakageName = "APG_SRM_VM20008";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_VM20008
        /// </summary>
        public SRM_VM20008()
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
                    DataTable dt1 = Library.GetTypeCode("1A").Tables[0]; //구매조직
                    DataTable dt2 = Library.GetTypeCode("VD").Tables[0]; //담당업무
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);

                    Library.ComboDataBind(this.cbo01_PURC_ORG, dt1, true, "OBJECT_NM", "OBJECT_ID", true);
                    Library.ComboDataBind(this.cbo02_PURC_ORG, dt1, false, "OBJECT_NM", "OBJECT_ID", true);
                    Library.ComboDataBind(this.cbo01_WORK_DIV, dt2, true, "OBJECT_NM", "OBJECT_ID", true);
                    Library.ComboDataBind(this.cbo02_WORK_DIV, dt2, false, "OBJECT_NM", "OBJECT_ID", true);
                    if (dt1.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
                    {
                        this.cbo01_PURC_ORG.SelectedItem.Value = dt1.Rows[0]["OBJECT_ID"].ToString();
                        this.cbo02_PURC_ORG.SelectedItem.Value = dt1.Rows[0]["OBJECT_ID"].ToString();
                    }
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.
                    this.cbo02_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.
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
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            if (this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10"))
            {
                MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
                MakeButton(ButtonID.Delete, ButtonImage.Delete, "Delete", this.ButtonPanel);
            }
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
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
            param.Add("WORK_DIV", this.cbo01_WORK_DIV.Value);
            param.Add("MGRNM", this.txt01_MGRNM.Text);
            param.Add("LANG_SET", UserInfo.LanguageShort);       
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
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cbo01_PURC_ORG.SelectedItem.Value = "";
            this.cbo01_PURC_ORG.UpdateSelectedItems();

            this.cbo01_WORK_DIV.SelectedItem.Value = "";
            this.cbo01_WORK_DIV.UpdateSelectedItems();

            this.txt01_MGRNM.SetValue(string.Empty);

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
                   "SERIAL", "BIZCD", "PURC_ORG", "MGRNM", "MGR_GRADE", "DEPART", "TELNO", "CELLNO", "EMAIL", "WORK_DIV", "WORK_DETAIL", "SORT_SEQ", "USER_ID"
                   , "MANAGER_YN", "RESALE_YN"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        parameters[i]["SERIAL"], this.cbo01_BIZCD.Value
                        , parameters[i]["PURC_ORG"], parameters[i]["MGRNM"], parameters[i]["MGR_GRADE"]
                        , parameters[i]["DEPART"], parameters[i]["TELNO"]
                        , parameters[i]["CELLNO"], parameters[i]["EMAIL"]
                        , parameters[i]["WORK_DIV"], parameters[i]["WORK_DETAIL"]
                        , parameters[i]["SORT_SEQ"], this.UserInfo.UserID
                        , parameters[i]["MANAGER_YN"].Equals("true") || parameters[i]["MANAGER_YN"].Equals("1") ? "Y" : "N"
                        , parameters[i]["RESALE_YN"].Equals("true") || parameters[i]["RESALE_YN"].Equals("1") ? "Y" : "N"
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
                   "SERIAL"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (bool.Parse(parameters[i]["CHECK_VALUE"]))
                    {
                        param.Tables[0].Rows.Add
                        (
                            parameters[i]["SERIAL"]
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
                if (String.IsNullOrEmpty(parameter["MGRNM"].ToString()) || parameter["MGRNM"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMALC00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "MGRNM"));
                else if (String.IsNullOrEmpty(parameter["PURC_ORG"].ToString()) || parameter["PURC_ORG"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMALC00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "PURC_ORG"));
                else if (String.IsNullOrEmpty(parameter["WORK_DIV"].ToString()) || parameter["WORK_DIV"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMALC00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "WORK_DIV"));
                else
                result = true;

            }
            // 삭제용 Validation
            else if (actionType == Library.ActionType.Delete)
            {
                if (String.IsNullOrEmpty(parameter["SERIAL"].ToString()) || parameter["SERIAL"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMALC00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "SERIAL"));
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
                //if (this.cdx01_CUSTCD.IsEmpty)
                //    this.MsgCodeAlert_ShowFormat("SRMALC00-0004", "CDX01_VENDCD", lbl01_CUST.Text);

                result = true;
            }

            return result;
        }

        #endregion


        //검색조건을 바꾸면 자동으로 차수 콤보 세팅 및 그리드 초기화
        public void changeCondition(object sender, DirectEventArgs e)
        {
            this.Search();
        }
    }
}
