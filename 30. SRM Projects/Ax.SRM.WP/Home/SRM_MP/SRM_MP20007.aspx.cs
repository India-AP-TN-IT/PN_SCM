#region ▶ Description & History
/* 
 * 프로그램명 : 거래명세서 수정 및 재발행
 * 설      명 : 일반구매 > 납품관리 > 거래명세서 수정 및 재발행
 * 최초작성자 : 이재우
 * 최초작성일 : 2017-09-19
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
    public partial class SRM_MP20007 : BasePage
    {
        private string pakageName = "SIS.APG_SRM_MP20007";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MP20007
        /// </summary>
        public SRM_MP20007()
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
                    //사업장
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);

                    //일반구매유형
                    Library.ComboDataBind(this.cbo01_MRO_PO_TYPE, Library.GetTypeCode("1J").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);

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
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Grid02DirtyValues", Value = "App.Grid02.getRowsValues({dirtyRowsOnly:true})", Mode = ParameterMode.Raw, Encode = true });
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Grid02AllValues", Value = "App.Grid02.getRowsValues({selectedOnly : false})", Mode = ParameterMode.Raw, Encode = true });
            }

            if (id.Equals(ButtonID.Print)) //선택한 row를 가져온다.
            {

                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Grid01SelectedValues", Value = "App.Grid01.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw, Encode = true });
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Grid01DirtyValues", Value = "App.Grid01.getRowsValues({dirtyRowsOnly:true})", Mode = ParameterMode.Raw, Encode = true });
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Grid02DirtyValues", Value = "App.Grid02.getRowsValues({dirtyRowsOnly:true})", Mode = ParameterMode.Raw, Encode = true });
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
                case ButtonID.Print:
                    PrintCheck(sender, e);
                    break;
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
                    //Save(sender, e);
                    PrintConfirm(sender, e);
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
            Ext.Net.Button btn = (Ext.Net.Button)sender;

            switch (btn.ID)
            {
                case "btn01_PRINT_REPORT2":
                    //납품전표 출력 버튼
                    //[SRM]printReport(this.cbo01_DELI_CNT.SelectedItem.Value.ToString());
                    //printReport("0");
                    PrintCheck(sender, e);
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
                //유효성 검사
                if (!IsQueryValidation())
                {
                    return;
                }

                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                this.Store7.RemoveAll();
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

            this.df01_FROM_DATE.SetValue(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
            this.df01_TO_DATE.SetValue(DateTime.Now.ToString("yyyy-MM-dd"));

            this.cbo01_MRO_PO_TYPE.SelectedItem.Value = "";
            this.cbo01_MRO_PO_TYPE.UpdateSelectedItems();

            this.df01_ARRIV_DATE.SetValue(DateTime.Now);

            this.df01_DELI_DATE.SetValue(this.getCurrentDate());

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

            txt01_ARRIV_TIME.Value = string.Empty;

            this.Store1.RemoveAll();
            this.Store7.RemoveAll();
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
            param.Add("MRO_PO_TYPE", this.cbo01_MRO_PO_TYPE.Value);
            param.Add("DELI_NOTE", this.txt01_DELI_NOTE3.Value);
            param.Add("FROM_DATE", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("TO_DATE", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));

            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            string procedure = "INQUERY_2";

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);
        }

        /// <summary>
        /// getDataSetDetail
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSetDetail(string deliNote)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("DELI_NOTE", deliNote);
            param.Add("DELI_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            string procedure = "INQUERY_DETAIL_2";

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);
        }

        /// <summary>
        /// getCurrentDate
        /// </summary>
        /// <returns></returns>
        private string getCurrentDate()
        {
            HEParameterSet param = new HEParameterSet();
            string procedure = "GET_CURRENT_DATE";
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param).Tables[0].Rows[0][0].ToString();
        }

        /// <summary>
        /// 출력조건 확인
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void PrintCheck(object sender, DirectEventArgs e)
        {
            try
            {
                if (e.ExtraParams.Count.Equals(0))
                {
                    //선택된 Row가 없습니다. 확인 바랍니다.
                    this.MsgCodeAlert("COM-00100");
                    return;
                }

                Dictionary<string, string>[] grid01SelectedValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid01SelectedValues"]);
                Dictionary<string, string>[] grid01DirtyValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid01DirtyValues"]);
                Dictionary<string, string>[] grid02DirtyValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid02DirtyValues"]);

                if (grid01SelectedValues.Length.Equals(0))
                {
                    //선택된 Row가 없습니다. 확인 바랍니다.
                    this.MsgCodeAlert("COM-00100");
                    return;
                }
                if (!grid01DirtyValues.Length.Equals(0) || !grid02DirtyValues.Length.Equals(0))
                {
                    //저장되지 않은 정보가 있습니다.
                    this.MsgCodeAlert("SRMMM-0027");
                    return;
                }

                //JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Values"]).Length

                string deliDate = grid01SelectedValues[0]["DELI_DATE"];
                string deliNote = grid01SelectedValues[0]["DELI_NOTE"];

                printReport(deliDate, deliNote);

                //Save(json.Replace("'", "\\'"), "YES");
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
        /// 저장 후 출력 여부 묻기
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <param name="status"></param>
        public void PrintConfirm(object sender, DirectEventArgs e)
        {
            try
            {
                Dictionary<string, string>[] grid01DirtyValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid01DirtyValues"]);
                Dictionary<string, string>[] grid02DirtyValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid02DirtyValues"]);
                Dictionary<string, string>[] grid02AllValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid02AllValues"]);

                // 납품취소 항목을 찾기
                if (grid01DirtyValues.Length > 0)
                {
                    DataSet param = Util.GetDataSourceSchema("DELI_NOTE");
                    int length = grid01DirtyValues.Length;
                    for (int i = 0; i < length; i++)
                    {
                        if (grid01DirtyValues[i]["DELI_TYPE"].ToString().Equals("true"))
                        {
                            string deliNote = grid01DirtyValues[i]["DELI_NOTE"];

                            if (!IsSaveValidAMM2010(deliNote)) return;

                            param.Tables[0].Rows.Add(deliNote);
                        }
                    }

                    if (param.Tables[0].Rows.Count > 0)
                    {
                        //선택한 납품서를 취소하시겠습니까?
                        string[] msg = Library.getMessageWithTitle("SRMMP-0032");

                        //처리중
                        string processing = Library.getLabel("SRM_QA21003", "PROCESSING", UserInfo.LanguageShort);

                        string json = e.ExtraParams["Grid01DirtyValues"];

                        Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
                        {
                            Yes = new MessageBoxButtonConfig
                            {
                                Handler = "Ext.net.Mask.show({ msg: '" + processing + "' }); App.direct.Save_DeliType('" + json.Replace("'", "\\'") + "', { success: function (result) { Ext.net.Mask.hide(); } })",
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
                else if (grid02DirtyValues.Length > 0)
                {
                    string json = e.ExtraParams["Grid02AllValues"];
                    int length = grid02AllValues.Length;
                    for (int i = 0; i < length; i++)
                    {
                        string pono = grid02AllValues[i]["PONO"];
                        string ponoSeq = grid02AllValues[i]["PONO_SEQ"];
                        string vendCd = this.cdx01_VENDCD.Value;
                        string deliDate = ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd");
                        int deliQty = Convert.ToInt32(grid02AllValues[i]["DELI_QTY"]);
                        string cancelDeliNote = grid02AllValues[i]["DELI_NOTE"];
                        string cancelDeliNoteSeq = grid02AllValues[i]["DELI_NOTE_SEQ"];

                        if (!IsSaveValidRemainQty(pono, ponoSeq, vendCd, deliDate, deliQty, cancelDeliNote, cancelDeliNoteSeq)) return;
                    }

                    CheckSaveValidation(json.Replace("'", "\\'"));

                    /*
                    //저장 후 전표를 출력 하시겠습니까?
                    string[] msg = Library.getMessageWithTitle("SRMMM-0012");

                    Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
                    {
                        Yes = new MessageBoxButtonConfig
                        {
                            Handler = "App.direct.Save_SAPIF_2('" + json.Replace("'", "\\'") + "', 'YES')",
                            Text = "YES"
                        },
                        No = new MessageBoxButtonConfig
                        {
                            Handler = "App.direct.Save_SAPIF_2('" + json.Replace("'", "\\'") + "', 'NO')",
                            Text = "NO"
                        }
                    }).Show();
                    */
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
        /// 납품전표 취소
        /// </summary>
        /// <param name="json"></param>
        [DirectMethod]
        public void Save_DeliType(string json)
        {
            Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

            DataSet param = Util.GetDataSourceSchema("DELI_NOTE", "USER_ID");
            int length = parameters.Length;
            int count = 0;
            for (int i = 0; i < length; i++)
            {
                if (parameters[i]["DELI_TYPE"].ToString().Equals("true"))
                {
                    param.Tables[0].Rows.Add(
                        parameters[i]["DELI_NOTE"].ToString()
                        , UserInfo.UserID);
                    count++;
                }
            }

            if (count > 100)
            {
                //한번에 최대 100개의 납품전표를 취소할 수 있습니다.
                this.MsgCodeAlert("SRMMP-0033");
                return;
            }

            using (EPClientProxy proxy = new EPClientProxy())
            {
                //[취소] 웹서비스 호출 전 IF 테이블에 저장
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_CANCEL"), param);
            }

            //수정되었습니다.
            this.MsgCodeAlert("COM-00003");
            this.Search();

        }

        /// <summary>
        /// 저장 Validation 체크 및 출력 여부 묻기
        /// </summary>
        /// <param name="json"></param>
        [DirectMethod]
        public void CheckSaveValidation(string json)
        {
            try
            {
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    //저장할 대상 Data가 없습니다.
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "DELI_QTY"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if ((parameters[i]["DELI_QTY"] == null || parameters[i]["DELI_QTY"] == string.Empty))
                    {
                        continue;
                    }

                    // 디테일 납품취소 건 
                    if (parameters[i]["DELI_DETAIL_TYPE"].ToString().Equals("true") || parameters[i]["DELI_QTY"] == "0")
                    {
                        continue;
                    }
                    
                    param.Tables[0].Rows.Add
                    (
                        parameters[i]["DELI_QTY"]
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid_2(param.Tables[0].Rows[param.Tables[0].Rows.Count - 1], Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }

                // 저장할 데이터가 있는 경우만 출력여부 묻기
                if (param.Tables[0].Rows.Count > 0)
                {
                    //도착시간 한번 더 확인
                    if (!IsArriveTimeValid())
                    {
                        return;
                    }


                    //저장 후 전표를 출력 하시겠습니까?
                    string[] msg = Library.getMessageWithTitle("SRMMP-0031");

                    //처리중
                    string processing = Library.getLabel("SRM_QA21003", "PROCESSING", UserInfo.LanguageShort);

                    Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
                    {
                        Yes = new MessageBoxButtonConfig
                        {
                            Handler = "Ext.net.Mask.show({ msg: '" + processing + "' }); App.direct.Save('" + json + "', 'YES', { success: function (result) { Ext.net.Mask.hide(); } })",
                            Text = "YES"
                        },
                        No = new MessageBoxButtonConfig
                        {
                            Handler = "Ext.net.Mask.show({ msg: '" + processing + "' }); App.direct.Save('" + json + "', 'NO', { success: function (result) { Ext.net.Mask.hide(); } })",
                            Text = "NO"
                        },
                        Cancel = new MessageBoxButtonConfig
                        {
                            Text = "CANCEL"
                        }
                    }).Show();
                }
                else
                {
                    //처리중
                    string processing = Library.getLabel("SRM_QA21003", "PROCESSING", UserInfo.LanguageShort);
                    Save(json, "NO");
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
        /// 저장
        /// </summary>
        /// <param name="json"></param>
        /// <param name="printYN"></param>
        [DirectMethod]
        public void Save(string json, string printYN)
        {
            try
            {
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                string deliNote = "";

                DataSet param = Util.GetDataSourceSchema
                (
                    "BIZCD", "MRO_PO_TYPE", "DELI_NOTE", "DELI_NOTE_SEQ",
                    "DELI_QTY", "PRDT_DATE",
                    "DELI_DATE", "ARRIV_DATE", "ARRIV_TIME", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if ((parameters[i]["DELI_QTY"] == null || parameters[i]["DELI_QTY"] == string.Empty))
                    {
                        continue;
                    }

                    deliNote = parameters[i]["DELI_NOTE"].ToString();

                    // 디테일 납품취소 건 
                    if (parameters[i]["DELI_DETAIL_TYPE"].ToString().Equals("true") || parameters[i]["DELI_QTY"] == "0")
                    {
                        continue;
                    }

                    param.Tables[0].Rows.Add
                    (
                        this.cbo01_BIZCD.Value
                        , parameters[i]["MRO_PO_TYPE"]
                        , parameters[i]["DELI_NOTE"].ToString()
                        , parameters[i]["DELI_NOTE_SEQ"].ToString()
                        , parameters[i]["DELI_QTY"]
                        , parameters[i]["PRDT_DATE"]
                        , ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd")
                        , ((DateTime)this.df01_ARRIV_DATE.Value).ToString("yyyy-MM-dd")
                        , this.txt01_ARRIV_TIME.Value
                        , this.UserInfo.UserID
                    );
                }

                //납품수량, 제조일자가 모두 비거나 취소도 아닐때
                if (param.Tables[0].Rows.Count == 0 && deliNote.Length == 0)
                {
                    //저장할 대상 Data가 없습니다.
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                //기존 전표번호 취소 (I/F 테이블로 INSERT)
                HEParameterSet param2 = new HEParameterSet();
                param2.Add("DELI_NOTE", deliNote);
                param2.Add("USER_ID", this.UserInfo.UserID);
                EPClientHelper.ExecuteNonQuery(string.Format("{0}.{1}", pakageName, "SAVE_CANCEL"), param2);

                //수정된 데이터만 신규로 재발행
                if (param.Tables[0].Rows.Count > 0)
                {
                    //신규 전표번호 발행
                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_2"), param);
                    }
                }

                //저장 후 전표출력을 하겠다고 했으면 출력루틴
                if (printYN.Equals("YES"))
                {
                    this.Search();

                    HEParameterSet param3 = new HEParameterSet();
                    param3.Add("CANCEL_DELI_NOTE", deliNote);
                    string procedure = "GET_DELI_NOTE";
                    DataTable dt = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param3).Tables[0];

                    string deliDate = dt.Rows[0]["DELI_DATE"].ToString();
                    string newDeliNote = dt.Rows[0]["DELI_NOTE"].ToString();

                    printReport(deliDate, newDeliNote);

                    //Grid01_Cell_DoubleClick(newDeliNote);
                    //X.Call("btn01_PRINT_REPORT.click");
                }
                else
                {
                    //저장되었습니다.
                    this.MsgCodeAlert("COM-00001");
                }

                //저장이후 도착예정시간 초기화
                txt01_ARRIV_TIME.Value = string.Empty;

                //현재 차수로 조회
                this.Search();

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
                    // 출력 또는 내보낼 데이터가 없습니다. 
                    this.MsgCodeAlert("COM-00807");
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

        #region [ 전표 출력 ]

        private void printReport(string deliDate, string deliNote)
        {
            printReportE2A(deliDate, deliNote);
        }

        private DataSet getDataSetSealImage()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SEAL_IMAGE"), param);
        }


        /// <summary>
        /// 납품전표 출력용 DATASET
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSetReport(string deliDate, string deliNote, string reportType)
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("DELI_DATE", deliDate);
            param.Add("DELI_NOTE", deliNote);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT"), param);
        }

        /// <summary>
        /// 거래명세표 출력
        /// </summary>
        private void printReportE2A(string deliDate, string deliNote)
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MP/SRM_MP20006";

                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                mainSection.ReportParameter.Add("DELI_DATE", deliDate);
                mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
                mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);

                report.Sections.Add("MAIN", mainSection);

                DataSet ds = getDataSetReport(deliDate, deliNote, "E2A");
                DataSet sealImage = getDataSetSealImage();
                if (ds.Tables[0].Rows.Count == 0)
                {
                    //this.MsgCodeAlert_ShowFormat("COM-00022"); //출력할 대상 Data가 없습니다.
                    return;
                }
                HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                HERexSection xmlSection2 = new HERexSection(sealImage, new HEParameterSet());
                report.Sections.Add("XML", xmlSection);
                report.Sections.Add("XML2", xmlSection2);


                // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                //ds.Tables[0].TableName = "DATA";
                //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
                //sealImage.Tables[0].TableName = "DATA";
                //sealImage.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "_SEAL.xml", XmlWriteMode.WriteSchema);


                AxReportForm.ShowReport(report);
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
        public bool IsArriveTimeValid()
        {
            //도착시간 확인
            if (this.txt01_ARRIV_TIME.IsEmpty)
            {
                //도착시간 NULL 허용
                return true;

                //도착시간을 확인 바랍니다.
                //this.MsgCodeAlert_ShowFormat("SRMMM-0013");
                //return false;
            }

            if (this.txt01_ARRIV_TIME.Value.ToString().Trim() == string.Empty ||
                this.txt01_ARRIV_TIME.Value.ToString().Length < 4 ||
                this.txt01_ARRIV_TIME.Value.ToString().Length > 5)
            {
                //도착시간을 확인 바랍니다.
                this.MsgCodeAlert_ShowFormat("SRMMM-0013");
                return false;
            }


            if (Convert.ToInt16(this.txt01_ARRIV_TIME.Value.ToString()) < 0)
            {
                //도착시간을 확인 바랍니다.
                this.MsgCodeAlert_ShowFormat("SRMMM-0013");
                return false;
            }

            if (Convert.ToInt16(this.txt01_ARRIV_TIME.Value.ToString()) > 2400)
            {
                //도착시간을 확인 바랍니다.
                this.MsgCodeAlert_ShowFormat("SRMMM-0013");
                return false;
            }

            return true;
        }

        /// <summary>
        /// 저장 Validation
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="corcd"></param>
        /// <param name="actionRow"></param>
        /// <returns></returns>
        public bool IsSaveValid_2(DataRow parameter, int actionRow = -1)
        {
            if (this.df01_ARRIV_DATE.IsEmpty)
            {
                //도착일자를 확인 바랍니다.
                this.MsgCodeAlert_ShowFormat("SRMMM-0021");
                return false;
            }

            // 납품량 필수 입력값
            if (parameter["DELI_QTY"].ToString().Equals(""))
            {
                //{0}행의 납품 수량을 입력 하세요.
                this.MsgCodeAlert_ShowFormat("SRMMM-0014", actionRow);
                return false;
            }

            // 납품량은 0이 될 수 없다.
            if (parameter["DELI_QTY"].ToString().Equals("0"))
            {
                //{0}번째 행의 {1} 값은 0보다 커야 합니다.
                this.MsgCodeAlert_ShowFormat("SRMMM-0038", actionRow, Util.GetHeaderColumnName(Grid01, "DELI_QTY"));
                return false;
            }

            return true;
        }

        /// <summary>
        /// '저장' 이벤트 수행하기 전에 반드시 AMM2010에 입고정보가 없는지 체크 후 미입고된 것을 확인 후 저장한다.
        /// </summary>
        /// <returns></returns>
        public bool IsSaveValidAMM2010(string deliNote)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("DELI_NOTE", deliNote);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "SAVE_VALIDATION"), param);
            if (!source.Tables[0].Rows[0][0].ToString().Equals("0"))
            {
                //입고 처리된 납품서 입니다.
                this.MsgCodeAlert("SRMMM-0028");
                return false;
            }
            else return true;
        }

        /// <summary>
        /// 잔량정보 확인
        /// </summary>
        /// <param name="pono"></param>
        /// <param name="ponoSeq"></param>
        /// <param name="vendcd"></param>
        /// <param name="noteCrtDate"></param>
        /// <param name="deliQty"></param>
        /// <returns></returns>
        public bool IsSaveValidRemainQty(string pono, string ponoSeq, string vendcd, string deliDate, int deliQty, string cancelDeliNote, string cancelDeliNoteSeq)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("PONO", pono);
            param.Add("PONO_SEQ", ponoSeq);
            param.Add("VENDCD", vendcd);
            param.Add("DELI_DATE", deliDate);
            param.Add("CANCEL_DELI_NOTE", cancelDeliNote);
            param.Add("CANCEL_DELI_NOTE_SEQ", cancelDeliNoteSeq);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "GET_REMAIN_QTY_2"), param);

            if (source.Tables.Count == 0)
            {
                //선택한 발주번호에 대한 잔량정보가 존재하지 않습니다.
                this.MsgCodeAlert("SRMMM-0029");
                return false;
            }
            if (source.Tables[0].Rows.Count == 0)
            {
                //선택한 발주번호에 대한 잔량정보가 존재하지 않습니다.
                this.MsgCodeAlert("SRMMM-0029");
                return false;
            }

            int remainQty = Convert.ToInt32(source.Tables[0].Rows[0]["REMAIN_QTY"]);

            if (deliQty > remainQty)
            {
                //잔량이 부족합니다.
                this.MsgCodeAlert("SRMMM-0030");
                return false;
            }

            return true;
        }

        /// <summary>
        /// 조회 Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {
            // 조회용 Validation
            if (this.cdx01_VENDCD.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.df01_DELI_DATE.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_DELI_DATE", lbl01_DELIVERY_DATE.Text);
                return false;
            }
            if (this.df01_ARRIV_DATE.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_ARRIV_DATE", lbl01_ARRIV_DATE.Text);
                return false;
            }

            return true;
        }

        #endregion

        #region [ 이벤트 ]

        [DirectMethod]
        public void Grid01_Cell_DoubleClick(string deliNote)
        {
            DataSet resultDetail = getDataSetDetail(deliNote);

            if (resultDetail.Tables[0].Rows.Count > 0)
            {
                this.df01_ARRIV_DATE.SetValue(resultDetail.Tables[0].Rows[0]["ARRIV_DATE"]);
                this.txt01_ARRIV_TIME.SetValue(resultDetail.Tables[0].Rows[0]["ARRIV_TIME"].ToString().Replace(":", ""));
            }
            else
            {
                this.df01_ARRIV_DATE.SetValue(DateTime.Now);
                this.txt01_ARRIV_TIME.SetValue(string.Empty);
            }

            this.Store7.DataSource = resultDetail.Tables[0];
            this.Store7.DataBind();
        }

        #endregion

        #region [ 헬프,콤보상자 관련 처리 ]

        protected void cbo01_MRO_PO_TYPE_Change(object sender, DirectEventArgs e)
        {
            this.initGrid();
        }

        //검색조건을 바꾸면 자동으로 날짜 세팅 및 그리드 초기화
        public void changeCondition(object sender, DirectEventArgs e)
        {
            this.df01_FROM_DATE.SetValue(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
            this.df01_TO_DATE.SetValue(DateTime.Now);

            this.initGrid();
        }

        private void initGrid()
        {
            this.txt01_ARRIV_TIME.Value = string.Empty;

            this.df01_ARRIV_DATE.SetValue(DateTime.Now);

            this.Store1.RemoveAll();
            this.Store7.RemoveAll();
        }

        #endregion

    }
}
