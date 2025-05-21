#region ▶ Description & History
/* 
 * 프로그램명 : 납품서 등록
 * 설      명 : 자재관리 > 납품관리 > SAP IF 미처리 현황
 * 최초작성자 : 이재우
 * 최초작성일 : 2017-08-24
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
using System.Threading;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM22010 : BasePage
    {
        private string pakageName = "SIS.APG_SRM_MM22010";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM22010
        /// </summary>
        public SRM_MM22010()
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
                    DataTable source = Library.GetTypeCode("1K").Tables[0];
					source.DefaultView.RowFilter = "TYPECD NOT IN ('NI')";

                    //구매오더유형
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);
                    Library.ComboDataBind(this.cbo01_PURC_PO_TYPE, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

                    //구매조직
                    source = Library.GetTypeCode("1A").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "");
                    if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
                    {
                        this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                    }
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.
                    //SAP 처리상태
                    this.cbo01_ZRSLT_SAP.SelectedItem.Value = "S";
                    this.cbo01_ZRSLT_SAP.UpdateSelectedItems();

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
            //MakeButton(ButtonID.Print, ButtonImage.Print, "납품전표출력", this.ButtonPanel);
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            //MakeButton(ButtonID.Regist, ButtonImage.New, "New", this.ButtonPanel);
            //MakeButton(ButtonID.Modify, ButtonImage.Modify, "Modify", this.ButtonPanel);
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
                new Ext.Net.Parameter { Name = "Grid01DirtyValues", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
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
                //case ButtonID.Print:
                //    PrintCheck(sender, e);
                //    break;
                case ButtonID.Search:
                    Search();
                    break;
                case ButtonID.Reset:
                    Reset();
                    break;
                //case ButtonID.Regist:
                //    SetButton("ButtonRegist");
                //    break;
                //case ButtonID.Modify:
                //    SetButton("ButtonModify");
                //    break;
                case ButtonID.Save:
                    SaveCheck(sender, e);
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
        public void etc_Button_Click(object sender, DirectEventArgs e)
        {

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
                //유효성 검사
                if (!IsQueryValidation())
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
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            //this.cbo01_PURC_PO_TYPE.SelectedItem.Value = "";
            //this.cbo01_PURC_PO_TYPE.UpdateSelectedItems();

            //this.cbo01_PURC_ORG.SelectedItem.Value = "";
            //this.cbo01_PURC_ORG.UpdateSelectedItems();

            this.cbo01_ZRSLT_SAP.SelectedItem.Value = "S";
            this.cbo01_ZRSLT_SAP.UpdateSelectedItems();

            if (this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
                this.cdx01_VENDCD.ReadOnly = false;
            }
            else
            {
                this.cdx01_VENDCD.SetValue(this.UserInfo.VenderCD);
                this.cdx01_VENDCD.ReadOnly = true;
            }

            this.Store1.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            //param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("PURC_PO_TYPE", this.cbo01_PURC_PO_TYPE.Value);
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
            param.Add("STR_LOC", this.cdx01_STR_LOC.Value);
            param.Add("DELI_NOTE", this.txt01_DELI_NOTE2.Value);
            param.Add("ZRSLT_SAP", this.cbo01_ZRSLT_SAP.Value.ToString().Equals("S") ? "S" : "");
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            string procedure = "INQUERY";

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);
        }

        /// <summary>
        /// 변경된 데이터 체크
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void SaveCheck(object sender, DirectEventArgs e)
        {
            try
            {
                Dictionary<string, string>[] grid01DirtyValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid01DirtyValues"]);

                // 적용확정 찾기
                if (grid01DirtyValues.Length > 0)
                {
                    int length = grid01DirtyValues.Length;
                    int count = 0;
                    for (int i = 0; i < length; i++)
                    {
                        if (grid01DirtyValues[i]["DATA_APPLY"].ToString().Equals("true") || grid01DirtyValues[i]["DATA_CANCEL"].ToString().Equals("true"))
                        {
                            count++;
                        }
                    }

                    if (count > 100)
                    {
                        //한번에 최대 100개의 납품전표를 처리할 수 있습니다.
                        this.MsgCodeAlert("SRMMM-0060");
                        return;
                    }

                    if (count > 0)
                    {
                        //선택한 항목을 처리하시겠습니까? (반드시 SAP에서 처리여부를 확인하셔야 합니다.)
                        string[] msg = Library.getMessageWithTitle("SRMMM-0055");

                        //처리중
                        string processing = Library.getLabel("SRM_QA21003", "PROCESSING", UserInfo.LanguageShort);

                        string json = e.ExtraParams["Grid01DirtyValues"];

                        Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
                        {
                            Yes = new MessageBoxButtonConfig
                            {
                                Handler = "Ext.net.Mask.show({ msg: '" + processing + "' }); App.direct.Save('" + json.Replace("'", "\\'") + "', { success: function (result) { Ext.net.Mask.hide(); } })",
                                Text = "YES"
                            },
                            No = new MessageBoxButtonConfig
                            {
                                Handler = "",
                                Text = "NO"
                            }
                        }).Show();
                    }
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
        public void Save_A(string bukrs, string werks, string deliNote, string deliNoteSeq, string ifDate, string ifTime)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema
                (
                    "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME", "USER_ID"
                );

                param.Tables[0].Rows.Add(bukrs, werks, deliNote, deliNoteSeq, ifDate, ifTime, this.UserInfo.UserID);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param);
                }

                //저장되었습니다.
                this.MsgCodeAlert("COM-00001");

                this.Search();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
        }

        /// <summary>
        /// 납품전표 처리
        /// </summary>
        /// <param name="json"></param>
        [DirectMethod]
        public void Save(string json)
        {
            Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

            DataSet param = Util.GetDataSourceSchema
            (
                "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME", "PROCESS_TYPE", "USER_ID"
            );

            int length = parameters.Length;
            for (int i = 0; i < length; i++)
            {
                param.Tables[0].Rows.Add(
                    parameters[i]["BUKRS"].ToString()
                    , parameters[i]["WERKS"].ToString()
                    , parameters[i]["DELI_NOTE"].ToString().Split('-')[0]
                    , parameters[i]["DELI_NOTE"].ToString().Split('-')[1]
                    , parameters[i]["IF_DATE"].ToString()
                    , parameters[i]["IF_TIME"].ToString()
                    , parameters[i]["DATA_APPLY"].ToString().Equals("true") ? "Y" : "N"
                    , this.UserInfo.UserID
                );
            }

            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param);
            }

            //정상적으로 처리되었습니다.
            this.MsgCodeAlert("COM-00908");
            this.Search();
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
        
        #endregion

        #region [ 유효성 검사 ]
        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {            
            // 조회용 Validation
            if (this.cdx01_VENDCD.IsEmpty && !(this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10")))
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            //if (this.cbo01_PURC_PO_TYPE.IsEmpty)
            //{
            //    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_PO_TYPE", lbl01_PURC_PO_TYPE.Text);
            //    return false;
            //}
            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
                return false;
            }

            return true;
        }

        #endregion

        #region [ 이벤트 ]

        [DirectMethod]
        public void Grid01_Excute_Click(string bukrs, string werks, string deliNote, string deliNoteSeq, string ifDate, string ifTime)
        {
            //선택한 항목을 처리하시겠습니까?
            string[] msg = Library.getMessageWithTitle("SRMMM-0055");

            Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
            {
                Yes = new MessageBoxButtonConfig
                {
                    Handler = "App.direct.Save('" + bukrs + "','" + werks + "','" + deliNote + "','" + deliNoteSeq + "','" + ifDate + "','" +  ifTime + "')",
                    Text = "YES"
                },
                No = new MessageBoxButtonConfig
                {
                    Text = "NO"
                }
            }).Show();
        }
        #endregion

        #region [ 헬프,콤보상자 관련 처리 ]

        protected void cbo01_PURC_PO_TYPE_Change(object sender, DirectEventArgs e)
        {
            this.initGrid();
        }

        protected void cbo01_PURC_ORG_Change(object sender, DirectEventArgs e)
        {
            if (cbo01_PURC_ORG.SelectedItem.Value.Equals("1A1110"))
            {
                this.cbo01_PURC_PO_TYPE.SelectedItem.Value = "1KMA";
                this.cbo01_PURC_PO_TYPE.UpdateSelectedItems();
            }

            this.initGrid();
        }

        protected void cdx01_STR_LOC_Change(object sender, DirectEventArgs e)
        {
            //this.Search();
        }

        //검색조건을 바꾸면 자동으로 차수 콤보 세팅 및 그리드 초기화
        public void changeCondition(object sender, DirectEventArgs e)
        {
            this.initGrid();
        }

        private void initGrid()
        {
            this.Store1.RemoveAll();
        }

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_STR_LOC_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            // UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
            if (this.cbo01_BIZCD.Value == null)
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
            else
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.Value);
        }

        #endregion

    }
}
