#region ▶ Description & History
/* 
 * 프로그램명 : 납품서 등록
 * 설      명 : 자재관리 > 납품관리 > 납품서수정 및 재발행
 * 최초작성자 : 이재우
 * 최초작성일 : 2017-07-26
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
    public partial class SRM_MM22002 : BasePage
    {
        private string pakageName = "SIS.APG_SRM_MM22002";
        private bool isUseSAPPO = true;
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM22002
        /// </summary>
        public SRM_MM22002()
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
                    // Ajax Timeout 설정
                    this.ResourceManager1.AjaxTimeout = Util.GetSendTimeOut(Server.MapPath("/"));

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
                    Reset();

                    //발주구분ask인경우의 [납품일자] 레이블 대신에 [납품일자 <=] 이 표시되도록 하기 위해
                    //this.lbl01_DELI_DATE2.Text = this.lbl01_DELI_DATE2.Text + " <=";
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
                case "btn01_PRINT_REPORT":
                    //납품전표 출력 버튼
                    //[SRM]printReport(this.cbo01_DELI_CNT.SelectedItem.Value.ToString());
                    //printReport("0");
                    PrintCheck(sender, e);
                    break;

                case "btn01_BLANK_REPORT":
                    //백지전표 출력 버튼
                    printBlankReport();
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

                //CHANGE_4M필드 사용 안함. 2019.09.19 김도연차장 요청.
                // 4M변경내역. 구매조직 = '수출' 일때만 보이도록 할 것.
                /*
                if (cbo01_PURC_ORG.Value.Equals("1A1110"))
                {
                    Util.SetHeaderColumnHidden(Grid02, "CHANGE_4M", false);
                }
                else
                {
                    Util.SetHeaderColumnHidden(Grid02, "CHANGE_4M", true);
                }
                */
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

            //this.cbo01_PURC_PO_TYPE.SelectedItem.Value = "";
            //this.cbo01_PURC_PO_TYPE.UpdateSelectedItems();

            //this.cbo01_PURC_ORG.SelectedItem.Value = "";
            //this.cbo01_PURC_ORG.UpdateSelectedItems();

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
            txt01_TRUCK_NO.Value = string.Empty;

            txt01_INVOICE.Value = string.Empty;

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
            param.Add("PURC_PO_TYPE", this.cbo01_PURC_PO_TYPE.Value);
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
            param.Add("STR_LOC", this.cdx01_STR_LOC.Value);
            param.Add("DELI_NOTE", this.txt01_DELI_NOTE2.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            string procedure = "INQUERY_2";

            //상품매출 입고검사표는 별도의 조회쿼리를 이용한다.
            if (this.cbo01_PURC_PO_TYPE.Value.Equals("1K10"))
            {
                procedure = "INQUERY_GOODS";
            }

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

            //상품매출 입고검사표는 별도의 조회쿼리를 이용한다.
            if (this.cbo01_PURC_PO_TYPE.Value.Equals("1K10"))
            {
                procedure = "INQUERY_DETAIL_GOODS";
            }

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
                string sourcingDiv = grid01SelectedValues[0]["SOURCING_DIV"];
                string purcOrg = grid01SelectedValues[0]["PURC_ORG"];
                string purcPoType = grid01SelectedValues[0]["PURC_PO_TYPE"];
                string zgrtyp = grid01SelectedValues[0]["ZGRTYP"];
                string invoice_no = grid01SelectedValues[0]["INVOICE_NO"];

                printReport(deliDate, deliNote, sourcingDiv, purcOrg, purcPoType, zgrtyp, invoice_no);

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
                        string[] msg = Library.getMessageWithTitle("SRMMM-0032");

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
                        decimal deliQty = Convert.ToDecimal(grid02AllValues[i]["DELI_QTY"]);
                        string cancelDeliNote = grid02AllValues[i]["DELI_NOTE"];
                        string cancelDeliNoteSeq = grid02AllValues[i]["DELI_NOTE_SEQ"];

                        //상품매출 입고검사표는 잔량확인을 하지 않는다.
                        if (!this.cbo01_PURC_PO_TYPE.Value.Equals("1K10"))
                        {
                            if (!IsSaveValidRemainQty(pono, ponoSeq, vendCd, deliDate, deliQty, cancelDeliNote, cancelDeliNoteSeq)) return;
                        }
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
            //상품매출 입고검사표는 SAP I/F를 하지 않고 바로 저장한다..
            if (this.cbo01_PURC_PO_TYPE.Value.Equals("1K10"))
            {
                Save_DeliType_GOODS(json);
                return;
            }


            Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

            DataSet param = Util.GetDataSourceSchema("DELI_NOTE", "UDID");
            int length = parameters.Length;
            int count = 0;
            string udid = "";
            string udids = "";
            for (int i = 0; i < length; i++)
            {
                if (parameters[i]["DELI_TYPE"].ToString().Equals("true"))
                {
                    udid = DateTime.Now.Ticks.ToString("X") + Guid.NewGuid().ToString().GetHashCode().ToString("X");
                    udids += (udids.Length == 0 ? "" : ",") + udid;

                    param.Tables[0].Rows.Add(
                        parameters[i]["DELI_NOTE"].ToString()
                        , udid);
                    count++;
                }
            }

            if (count > 100)
            {
                //한번에 최대 100개의 납품전표를 취소할 수 있습니다.
                this.MsgCodeAlert("SRMMM-0034");
                return;
            }

            using (EPClientProxy proxy = new EPClientProxy())
            {
                //[취소] 웹서비스 호출 전 IF 테이블에 저장
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_SAPIF_CANCEL_3"), param);
            }

            string result = Inquery_SAPIF_Cancel_3(udids);

            if (result.Equals("S"))
            {
                //수정되었습니다.
                this.MsgCodeAlert("COM-00003");
                this.Search();
            }
        }

        /// <summary>
        /// OEM 직납상품 취소
        /// </summary>
        /// <param name="json"></param>
        public void Save_DeliType_GOODS(string json)
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
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_CANCEL_GOODS"), param);
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
        public void  CheckSaveValidation(string json)
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
                    "UNIT_PACK_QTY", "DELI_QTY", "VEND_LOTNO", "PRDT_DATE", "CHANGE_4M"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    //if ((parameters[i]["DELI_QTY"] == null || parameters[i]["DELI_QTY"] == string.Empty) &&
                    //    (parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty))
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
                        parameters[i]["UNIT_PACK_QTY"]
                        , parameters[i]["DELI_QTY"]
                        , parameters[i]["VEND_LOTNO"]
                        , ((parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty) ? string.Empty : DateTime.Parse(parameters[i]["PRDT_DATE"].ToString()).ToString("yyyy-MM-dd"))
                        , parameters[i]["CHANGE_4M"].ToString()
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid_2(param.Tables[0].Rows[param.Tables[0].Rows.Count - 1], parameters[i]["CORCD"], Convert.ToInt32(parameters[i]["NO"])))
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

                    //20190801 LYZ Vendor Invoice 필수 입력 추가
                    //AMM9010.INVOICE_NO 
                    if (this.txt01_INVOICE.IsEmpty)
                    {
                        //{0}를(을) 입력해주세요.
                        this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_INVOICE", lbl01_INVOICE.Text);
                        return;
                    }

                    //저장 후 전표를 출력 하시겠습니까?
                    string[] msg = Library.getMessageWithTitle("SRMMM-0012");

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
                //상품매출 입고검사표는 SAP I/F를 하지 않고 바로 저장한다..
                if (this.cbo01_PURC_PO_TYPE.Value.Equals("1K10"))
                {
                    Save_GOODS(json, printYN);
                    return;
                }

                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                //IF_DATE, IF_TIME 설정
                DataTable dt = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "GET_IF_DATE_TIME"), new HEParameterSet()).Tables[0];
                string ifDate = dt.Rows[0]["IF_DATE"].ToString();
                string ifTime = dt.Rows[0]["IF_TIME"].ToString();

                string deliNote = "";
                string udid = "";
                string udids = "";

                DataSet param = Util.GetDataSourceSchema
                (
                    "BIZCD", "DELI_NOTE", "DELI_NOTE_SEQ",
                    "UNIT_PACK_QTY", "DELI_QTY", "VEND_LOTNO", "PRDT_DATE", "CHANGE_4M",
                    "DELI_DATE", "ARRIV_DATE", "ARRIV_TIME", "USER_ID",
                    "UDID", "IF_DATE", "IF_TIME", "INVOICE_NO"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    //if ((parameters[i]["DELI_QTY"] == null || parameters[i]["DELI_QTY"] == string.Empty) &&
                    //    (parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty))
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

                    udid = DateTime.Now.Ticks.ToString("X") + Guid.NewGuid().ToString().GetHashCode().ToString("X");
                    udids += (udids.Length == 0 ? "" : ",") + udid;
                    

                    param.Tables[0].Rows.Add
                    (
                        this.cbo01_BIZCD.Value
                        , parameters[i]["DELI_NOTE"].ToString()
                        , parameters[i]["DELI_NOTE_SEQ"].ToString()
                        , parameters[i]["UNIT_PACK_QTY"]
                        , parameters[i]["DELI_QTY"]
                        , parameters[i]["VEND_LOTNO"]
                        , ((parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty) ? string.Empty : DateTime.Parse(parameters[i]["PRDT_DATE"].ToString()).ToString("yyyy-MM-dd"))
                        , parameters[i]["CHANGE_4M"].ToString()
                        , ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd")
                        , ((DateTime)this.df01_ARRIV_DATE.Value).ToString("yyyy-MM-dd")
                        , this.txt01_ARRIV_TIME.Value
                        , this.UserInfo.UserID
                        , udid
                        , ifDate
                        , ifTime
                        , this.txt01_INVOICE.Value
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
                string udidCancel = DateTime.Now.Ticks.ToString("X") + Guid.NewGuid().ToString().GetHashCode().ToString("X");
                HEParameterSet param2 = new HEParameterSet();
                param2.Add("DELI_NOTE", deliNote);
                param2.Add("UDID", udidCancel);
                EPClientHelper.ExecuteNonQuery(string.Format("{0}.{1}", pakageName, "SAVE_SAPIF_CANCEL_3"), param2);

                //수정된 데이터만 신규로 재발행
                if (param.Tables[0].Rows.Count > 0)
                {
                    //신규 전표번호 발행
                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_SAPIF_4"), param);
                    }
                }

                // SAP IF 테이블에서 데이터를 읽어와 웹서비스 호출 후 응답받음
                string result = Inquery_SAPIF_2(udids, udidCancel, deliNote);


                //저장 후 전표출력을 하겠다고 했으면 출력루틴
                if (result.Equals("S") && printYN.Equals("YES"))
                {
                    this.Search();

                    HEParameterSet param3 = new HEParameterSet();
                    param3.Add("CANCEL_DELI_NOTE", deliNote);
                    string procedure = "GET_DELI_NOTE";
                    dt = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param3).Tables[0];

                    string deliDate = dt.Rows[0]["DELI_DATE"].ToString();
                    string newDeliNote = dt.Rows[0]["DELI_NOTE"].ToString();
                    string sourcingDiv = dt.Rows[0]["SOURCING_DIV"].ToString();
                    string purcOrg = dt.Rows[0]["PURC_ORG"].ToString();
                    string purcPoType = dt.Rows[0]["PURC_PO_TYPE"].ToString();
                    string zgrtyp = dt.Rows[0]["ZGRTYP"].ToString();
                    string invoice_no = dt.Rows[0]["INVOICE_NO"].ToString();

                    printReport(deliDate, newDeliNote, sourcingDiv, purcOrg, purcPoType, zgrtyp, invoice_no);

                    //Grid01_Cell_DoubleClick(newDeliNote);
                    //X.Call("btn01_PRINT_REPORT.click");
                }
                else if (result.Equals("S"))
                {
                    //저장되었습니다.
                    this.MsgCodeAlert("COM-00001");
                }

                if (result.Equals("S"))
                {
                    //저장이후 도착예정시간 초기화
                    txt01_ARRIV_TIME.Value = string.Empty;
                    txt01_TRUCK_NO.Value = string.Empty;
                    //현재 차수로 조회
                    this.Search();
                    txt01_INVOICE.Value = string.Empty;
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
        /// OEM 직납상품 저장
        /// </summary>
        /// <param name="json"></param>
        /// <param name="printYN"></param>
        public void Save_GOODS(string json, string printYN)
        {
            try
            {
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                string deliNote = "";

                DataSet param = Util.GetDataSourceSchema
                (
                    "BIZCD", "DELI_NOTE", "DELI_NOTE_SEQ",
                    "DELI_QTY", "PRDT_DATE", "VEND_LOTNO", 
                    "DELI_DATE", "ARRIV_DATE", "ARRIV_TIME", "USER_ID", "INVOICE_NO"
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
                        , parameters[i]["DELI_NOTE"].ToString()
                        , parameters[i]["DELI_NOTE_SEQ"].ToString()
                        , parameters[i]["DELI_QTY"]
                        , ((parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty) ? string.Empty : DateTime.Parse(parameters[i]["PRDT_DATE"].ToString()).ToString("yyyy-MM-dd"))
                        , parameters[i]["VEND_LOTNO"]
                        , ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd")
                        , ((DateTime)this.df01_ARRIV_DATE.Value).ToString("yyyy-MM-dd")
                        , this.txt01_ARRIV_TIME.Value
                        , this.UserInfo.UserID
                        , this.txt01_INVOICE.Value
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
                EPClientHelper.ExecuteNonQuery(string.Format("{0}.{1}", pakageName, "SAVE_CANCEL_GOODS"), param2);

                //수정된 데이터만 신규로 재발행
                if (param.Tables[0].Rows.Count > 0)
                {
                    //신규 전표번호 발행
                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_GOODS"), param);
                    }
                }

                //저장 후 전표출력을 하겠다고 했으면 출력루틴
                if (printYN.Equals("YES"))
                {
                    this.Search();

                    HEParameterSet param3 = new HEParameterSet();
                    param3.Add("CANCEL_DELI_NOTE", deliNote);
                    string procedure = "GET_DELI_NOTE_GOODS";
                    DataTable dt = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param3).Tables[0];

                    string deliDate = dt.Rows[0]["DELI_DATE"].ToString();
                    string newDeliNote = dt.Rows[0]["DELI_NOTE"].ToString();
                    string invoice_no = dt.Rows[0]["INVOICE_NO"].ToString();

                    printReport(deliDate, newDeliNote, "", "", "1K10", "", invoice_no);

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
                txt01_TRUCK_NO.Value = string.Empty;
                //현재 차수로 조회
                this.Search();
                txt01_INVOICE.Value = string.Empty;

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
        /// SAP I/F 납품서 취소 및 SAP PO 웹서비스 호출
        /// </summary>
        /// <param name="deliCnt"></param>
        private string Inquery_SAPIF_Cancel_3(string udids)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("UDIDS", udids);

            string procedure = "INQUERY_SAPIF_CANCEL_3";

            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);

            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM pomm0030 = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM();

            // 납품서 정보
            DataTable dt = ds.Tables[0];
            int count = dt.Rows.Count;

            pomm0030.ZMMS0200 = new SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200[count];
            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200 data;

            for (int i = 0; i < count; i++)
            {
                data = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200();

                data.BUKRS = dt.Rows[i]["BUKRS"].ToString();
                data.WERKS = dt.Rows[i]["WERKS"].ToString();
                data.DELI_NOTE = dt.Rows[i]["DELI_NOTE"].ToString();
                data.DELI_NOTE_CNT = dt.Rows[i]["DELI_NOTE_CNT"].ToString();
                data.IF_DATE = dt.Rows[i]["IF_DATE"].ToString();
                data.IF_TIME = dt.Rows[i]["IF_TIME"].ToString();
                data.LFDAT = dt.Rows[i]["LFDAT"].ToString();
                data.CRDAT = dt.Rows[i]["CRDAT"].ToString();
                data.LIFNR = dt.Rows[i]["LIFNR"].ToString();
                data.EKORG = dt.Rows[i]["EKORG"].ToString();
                data.DELI_TYPE = dt.Rows[i]["DELI_TYPE"].ToString();
                data.EBELN = dt.Rows[i]["EBELN"].ToString();
                data.EBELP = dt.Rows[i]["EBELP"].ToString();
                data.MATNR = dt.Rows[i]["MATNR"].ToString();
                data.LGORT = dt.Rows[i]["LGORT"].ToString();
                data.LFIMG = dt.Rows[i]["LFIMG"].ToString();
                data.MEINS = dt.Rows[i]["MEINS"].ToString();
                data.BARCODE = dt.Rows[i]["BARCODE"].ToString();
                data.NATION_CD = dt.Rows[i]["NATION_CD"].ToString();
                data.LOT_NO = dt.Rows[i]["LOT_NO"].ToString();
                data.VEND_LOTNO = dt.Rows[i]["VEND_LOTNO"].ToString();
                data.CHANGE_NOTE = dt.Rows[i]["CHANGE_NOTE"].ToString();

                pomm0030.ZMMS0200.SetValue(data, i);
            }

            Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SORequest request = new Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SORequest();
            request.MT_POMM0030_SCM = pomm0030;

            Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SOClient soap = new Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SOClient();
            soap.ClientCredentials.UserName.UserName = TheOne.Configuration.AppSectionFactory.AppSection["UserName"].ToString();
            soap.ClientCredentials.UserName.Password = TheOne.Configuration.AppSectionFactory.AppSection["Password"].ToString();

            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_response response = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_response();

            if (isUseSAPPO)
            {
                try
                {
                    // SAP PO를 사용하면 웹서비스 실행
                    response = soap.POMM0030_SCM_SO(request.MT_POMM0030_SCM);
                }
                catch (Exception e)
                {
                    Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);

                    DataSet param4 = Util.GetDataSourceSchema
                    (
                       "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME", "MESSAGE"

                    );

                    int cnt = ds.Tables[0].Rows.Count;

                    for (int i = 0; i < count; i++)
                    {
                        param4.Tables[0].Rows.Add
                        (
                            ds.Tables[0].Rows[i]["BUKRS"].ToString()
                            , ds.Tables[0].Rows[i]["WERKS"].ToString()
                            , ds.Tables[0].Rows[i]["DELI_NOTE"].ToString()
                            , ds.Tables[0].Rows[i]["DELI_NOTE_CNT"].ToString()
                            , ds.Tables[0].Rows[i]["IF_DATE"].ToString()
                            , ds.Tables[0].Rows[i]["IF_TIME"].ToString()
                            , e.Message
                        );
                    }

                    try
                    {
                        using (EPClientProxy proxy = new EPClientProxy())
                        {
                            proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_SERVER_ERROR"), param4);
                        }
                    }
                    catch (Exception e2)
                    {
                        Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e2);
                        //SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.관리자에게 문의하십시오.
                        this.MsgCodeAlert("SRMMM-0042");

                        return "E";
                    }

                    //SAP IF 중 Server Error가 발생하였습니다. 관리자에게 문의하십시오.
                    this.MsgCodeAlert("SRMMM-0040");
                    return "E";
                }
            }
            else
            {
                // SAP PO를 사용안할시 웹서비스가 성공했다는 가정으로 진행
                response.ZMMS0200 = new POMM0030_Service.DT_POMM0030_SCM_responseZMMS0200[count];
                response.ResHeader = new POMM0030_Service.ResHeader();
                response.ResHeader.zResultCd = "S";
                Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_responseZMMS0200 data3;

                for (int i = 0; i < count; i++)
                {
                    data3 = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_responseZMMS0200();

                    data3.BUKRS = dt.Rows[i]["BUKRS"].ToString();
                    data3.WERKS = dt.Rows[i]["WERKS"].ToString();
                    data3.DELI_NOTE = dt.Rows[i]["DELI_NOTE"].ToString();
                    data3.DELI_NOTE_CNT = dt.Rows[i]["DELI_NOTE_CNT"].ToString();
                    data3.IF_DATE = dt.Rows[i]["IF_DATE"].ToString();
                    data3.IF_TIME = dt.Rows[i]["IF_TIME"].ToString();
                    data3.ZRSLT_SAP = "M";  // 웹서비스를 이용안한 데이터는 Manual로 저장
                    data3.ZMSG_SAP = "";
                    data3.ZDATE_SAP = "";
                    data3.ZTIME_SAP = "";
                    data3.ZDATE_PO = "";

                    response.ZMMS0200.SetValue(data3, i);
                }
            }

            try
            {
                count = response.ZMMS0200.Length;
            }
            catch (NullReferenceException e)
            {
                Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);

                // ZMMS0200가 NULL 이더라도 헤더정보의 ZRESULTCD가 존재한다면 E인 경우에만 DB에 저장
                if (response != null && response.ResHeader != null && response.ResHeader.zResultCd != null && !response.ResHeader.zResultCd.Equals("S"))
                {
                    DataSet param4 = Util.GetDataSourceSchema
                    (
                       "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME", "MESSAGE"

                    );

                    int cnt = ds.Tables[0].Rows.Count;

                    for (int i = 0; i < count; i++)
                    {
                        param4.Tables[0].Rows.Add
                        (
                            ds.Tables[0].Rows[i]["BUKRS"].ToString()
                            , ds.Tables[0].Rows[i]["WERKS"].ToString()
                            , ds.Tables[0].Rows[i]["DELI_NOTE"].ToString()
                            , ds.Tables[0].Rows[i]["DELI_NOTE_CNT"].ToString()
                            , ds.Tables[0].Rows[i]["IF_DATE"].ToString()
                            , ds.Tables[0].Rows[i]["IF_TIME"].ToString()
                            , e.Message
                        );
                    }

                    try
                    {
                        using (EPClientProxy proxy = new EPClientProxy())
                        {
                            proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_NULL_ERROR"), param4);
                        }
                    }
                    catch (Exception e2)
                    {
                        Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e2);
                        //SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.관리자에게 문의하십시오.
                        this.MsgCodeAlert("SRMMM-0042");

                        return "E";
                    }
                }

                //SAP에서 응답이 NULL로 왔습니다. 관리자에게 문의하시기바랍니다.
                this.MsgCodeAlert("SRMMM-0059");

                return "E";
            }

            DataSet param2 = Util.GetDataSourceSchema
                (
                   "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME",
                   "ZRSLT_SAP", "ZMSG_SAP", "ZDATE_SAP", "ZTIME_SAP", "ZDATE_PO"
                );

            for (int i = 0; i < count; i++)
            {
                param2.Tables[0].Rows.Add
                    (
                        response.ZMMS0200[i].BUKRS
                        , response.ZMMS0200[i].WERKS
                        , response.ZMMS0200[i].DELI_NOTE
                        , response.ZMMS0200[i].DELI_NOTE_CNT
                        , response.ZMMS0200[i].IF_DATE
                        , response.ZMMS0200[i].IF_TIME
                        , response.ZMMS0200[i].ZRSLT_SAP
                        , response.ZMMS0200[i].ZMSG_SAP
                        , response.ZMMS0200[i].ZDATE_SAP
                        , response.ZMMS0200[i].ZTIME_SAP
                        , response.ZMMS0200[i].ZDATE_PO
                    );
            }

            try
            {
                using (EPClientProxy proxy = new EPClientProxy())
                {
                    // 웹서비스 호출 후 응답값 저장
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "UPDATE_SAPIF"), param2);
                }
            }
            catch (Exception e)
            {
                Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);
                //SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.관리자에게 문의하십시오.
                this.MsgCodeAlert("SRMMM-0042");

                return "E";
            }

            if (!response.ResHeader.zResultCd.Equals("S"))
            {
                //SAP IF 중 오류가 발생하였습니다. {0}
                this.MsgCodeAlert_ShowFormat("SRMMM-0033", "", "\n[CANCEL]\n" + response.ResHeader.zResultMsg);
                return "E";
            }
            else
            {
                DataSet param3 = Util.GetDataSourceSchema
                (
                   "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME",
                   "USER_ID"
                );

                for (int i = 0; i < count; i++)
                {
                    param3.Tables[0].Rows.Add
                        (
                            response.ZMMS0200[i].BUKRS
                            , response.ZMMS0200[i].WERKS
                            , response.ZMMS0200[i].DELI_NOTE
                            , response.ZMMS0200[i].DELI_NOTE_CNT
                            , response.ZMMS0200[i].IF_DATE
                            , response.ZMMS0200[i].IF_TIME
                            , this.UserInfo.UserID
                        );
                }

                try
                {
                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        //웹서비스 호출 후 응답이 'S'로 오면 SRM에 저장함
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_SUCCESS_CANCEL_3"), param3);
                    }
                    return "S";
                }

                catch (Exception e)
                {
                    Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);
                    //SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.SAP IF 미처리현황에서 확인하십시오.
                    this.MsgCodeAlert("SRMMM-0041");

                    return "E";
                }
            }
        }

        /// <summary>
        /// SAP PO 웹서비스 호출 및 성공시 저장, 실패시 메시지 처리
        /// </summary>
        /// <param name="ponos"></param>
        /// <param name="ponoSeqs"></param>
        /// <param name="deliCnt"></param>
        private string Inquery_SAPIF_2(string udids, string udidCancel, string cancelDeliNote)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("UDIDS", udids);
            param.Add("UDID_CANCEL", udidCancel);

            string procedure = "INQUERY_SAPIF_3";
            string[] cursorNames = new string[] { "OUT_CURSOR_H", "OUT_CURSOR_D" };

            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param, cursorNames);

            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM pomm0030 = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM();

            // 납품서 정보
            DataTable dt = ds.Tables[0];
            int count = dt.Rows.Count;

            pomm0030.ZMMS0200 = new SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200[count];
            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200 data;

            for (int i = 0; i < count; i++)
            {
                data = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200();

                data.BUKRS = dt.Rows[i]["BUKRS"].ToString();
                data.WERKS = dt.Rows[i]["WERKS"].ToString();
                data.DELI_NOTE = dt.Rows[i]["DELI_NOTE"].ToString();
                data.DELI_NOTE_CNT = dt.Rows[i]["DELI_NOTE_CNT"].ToString();
                data.IF_DATE = dt.Rows[i]["IF_DATE"].ToString();
                data.IF_TIME = dt.Rows[i]["IF_TIME"].ToString();
                data.LFDAT = dt.Rows[i]["LFDAT"].ToString();
                data.CRDAT = dt.Rows[i]["CRDAT"].ToString();
                data.LIFNR = dt.Rows[i]["LIFNR"].ToString();
                data.EKORG = dt.Rows[i]["EKORG"].ToString();
                data.DELI_TYPE = dt.Rows[i]["DELI_TYPE"].ToString();
                data.EBELN = dt.Rows[i]["EBELN"].ToString();
                data.EBELP = dt.Rows[i]["EBELP"].ToString();
                data.MATNR = dt.Rows[i]["MATNR"].ToString();
                data.LGORT = dt.Rows[i]["LGORT"].ToString();
                data.LFIMG = dt.Rows[i]["LFIMG"].ToString();
                data.MEINS = dt.Rows[i]["MEINS"].ToString();
                data.BARCODE = dt.Rows[i]["BARCODE"].ToString();
                data.NATION_CD = dt.Rows[i]["NATION_CD"].ToString();
                data.LOT_NO = dt.Rows[i]["LOT_NO"].ToString();
                data.VEND_LOTNO = dt.Rows[i]["VEND_LOTNO"].ToString();
                data.CHANGE_NOTE = dt.Rows[i]["CHANGE_NOTE"].ToString();

                pomm0030.ZMMS0200.SetValue(data, i);
            }

            // 부품식별표 정보
            dt = ds.Tables[1];
            count = dt.Rows.Count;

            pomm0030.ZMMS0202 = new SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0202[count];
            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0202 data2;

            for (int i = 0; i < count; i++)
            {
                data2 = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0202();

                data2.BUKRS = dt.Rows[i]["BUKRS"].ToString();
                data2.WERKS = dt.Rows[i]["WERKS"].ToString();
                data2.DELI_NOTE = dt.Rows[i]["DELI_NOTE"].ToString();
                data2.DELI_NOTE_CNT = dt.Rows[i]["DELI_NOTE_CNT"].ToString();
                data2.BOX_BARCODE = dt.Rows[i]["BOX_BARCODE"].ToString();
                data2.EBELN = dt.Rows[i]["EBELN"].ToString();
                data2.EBELP = dt.Rows[i]["EBELP"].ToString();
                data2.MATNR = dt.Rows[i]["MATNR"].ToString();
                data2.BARCODE = dt.Rows[i]["BARCODE"].ToString();
                data2.SEQ_NO = dt.Rows[i]["SEQ_NO"].ToString();
                data2.IDENTI_NO = dt.Rows[i]["IDENTI_NO"].ToString();
                data2.MENGE = dt.Rows[i]["MENGE"].ToString();
                data2.MEINS = dt.Rows[i]["MEINS"].ToString();

                pomm0030.ZMMS0202.SetValue(data2, i);
            }

            Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SORequest request = new Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SORequest();
            request.MT_POMM0030_SCM = pomm0030;

            Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SOClient soap = new Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SOClient();
            soap.ClientCredentials.UserName.UserName = TheOne.Configuration.AppSectionFactory.AppSection["UserName"].ToString();
            soap.ClientCredentials.UserName.Password = TheOne.Configuration.AppSectionFactory.AppSection["Password"].ToString();

            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_response response = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_response();

            if (isUseSAPPO)
            {
                try
                {
                    // SAP PO를 사용하면 웹서비스 실행
                    response = soap.POMM0030_SCM_SO(request.MT_POMM0030_SCM);
                }
                catch (Exception e)
                {
                    Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);

                    HEParameterSet param4 = new HEParameterSet();
                    param4.Add("BUKRS", ds.Tables[0].Rows[0]["BUKRS"].ToString());
                    param4.Add("WERKS", ds.Tables[0].Rows[0]["WERKS"].ToString());
                    param4.Add("DELI_NOTE", ds.Tables[0].Rows[0]["DELI_NOTE"].ToString());
                    param4.Add("DELI_NOTE_CNT", ds.Tables[0].Rows[0]["DELI_NOTE_CNT"].ToString());
                    param4.Add("IF_DATE", ds.Tables[0].Rows[0]["IF_DATE"].ToString());
                    param4.Add("IF_TIME", ds.Tables[0].Rows[0]["IF_TIME"].ToString());
                    param4.Add("MESSAGE", e.Message);

                    try
                    {
                        EPClientHelper.ExecuteNonQuery(string.Format("{0}.{1}", pakageName, "SAVE_SERVER_ERROR"), param4);
                    }
                    catch (Exception e2)
                    {
                        Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e2);
                    }

                    //SAP IF 중 Server Error가 발생하였습니다. 관리자에게 문의하십시오.
                    this.MsgCodeAlert("SRMMM-0040");
                    return "E";
                }
            }
            else
            {
                // SAP PO를 사용안할시 웹서비스가 성공했다는 가정으로 진행
                dt = ds.Tables[0];
                count = dt.Rows.Count;

                response.ZMMS0200 = new POMM0030_Service.DT_POMM0030_SCM_responseZMMS0200[count];
                response.ResHeader = new POMM0030_Service.ResHeader();
                response.ResHeader.zResultCd = "S";
                Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_responseZMMS0200 data3;

                for (int i = 0; i < count; i++)
                {
                    data3 = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_responseZMMS0200();

                    data3.BUKRS = dt.Rows[i]["BUKRS"].ToString();
                    data3.WERKS = dt.Rows[i]["WERKS"].ToString();
                    data3.DELI_NOTE = dt.Rows[i]["DELI_NOTE"].ToString();
                    data3.DELI_NOTE_CNT = dt.Rows[i]["DELI_NOTE_CNT"].ToString();
                    data3.IF_DATE = dt.Rows[i]["IF_DATE"].ToString();
                    data3.IF_TIME = dt.Rows[i]["IF_TIME"].ToString();
                    data3.ZRSLT_SAP = "M";  // 웹서비스를 이용안한 데이터는 Manual로 저장
                    data3.ZMSG_SAP = "";
                    data3.ZDATE_SAP = "";
                    data3.ZTIME_SAP = "";
                    data3.ZDATE_PO = "";

                    response.ZMMS0200.SetValue(data3, i);
                }
            }

            try
            {
                count = response.ZMMS0200.Length;
            }
            catch (NullReferenceException e)
            {
                Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);

                // ZMMS0200가 NULL 이더라도 헤더정보의 ZRESULTCD가 존재한다면 E인 경우에만 DB에 저장
                if (response != null && response.ResHeader != null && response.ResHeader.zResultCd != null && !response.ResHeader.zResultCd.Equals("S"))
                {
                    HEParameterSet param4 = new HEParameterSet();
                    param4.Add("BUKRS", ds.Tables[0].Rows[0]["BUKRS"].ToString());
                    param4.Add("WERKS", ds.Tables[0].Rows[0]["WERKS"].ToString());
                    param4.Add("DELI_NOTE", ds.Tables[0].Rows[0]["DELI_NOTE"].ToString());
                    param4.Add("DELI_NOTE_CNT", ds.Tables[0].Rows[0]["DELI_NOTE_CNT"].ToString());
                    param4.Add("IF_DATE", ds.Tables[0].Rows[0]["IF_DATE"].ToString());
                    param4.Add("IF_TIME", ds.Tables[0].Rows[0]["IF_TIME"].ToString());
                    param4.Add("MESSAGE", e.Message);

                    try
                    {
                        EPClientHelper.ExecuteNonQuery(string.Format("{0}.{1}", pakageName, "SAVE_NULL_ERROR"), param4);
                    }
                    catch (Exception e2)
                    {
                        Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e2);
                        //SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.관리자에게 문의하십시오.
                        this.MsgCodeAlert("SRMMM-0042");

                        return "E";
                    }
                }

                //SAP에서 응답이 NULL로 왔습니다. 관리자에게 문의하시기바랍니다.
                this.MsgCodeAlert("SRMMM-0059");

                return "E";
            }

            DataSet param2 = Util.GetDataSourceSchema
                (
                   "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME",
                   "ZRSLT_SAP", "ZMSG_SAP", "ZDATE_SAP", "ZTIME_SAP", "ZDATE_PO"
                );

            for (int i = 0; i < count; i++)
            {
                param2.Tables[0].Rows.Add
                    (
                        response.ZMMS0200[i].BUKRS
                        , response.ZMMS0200[i].WERKS
                        , response.ZMMS0200[i].DELI_NOTE
                        , response.ZMMS0200[i].DELI_NOTE_CNT
                        , response.ZMMS0200[i].IF_DATE
                        , response.ZMMS0200[i].IF_TIME
                        , response.ZMMS0200[i].ZRSLT_SAP
                        , response.ZMMS0200[i].ZMSG_SAP
                        , response.ZMMS0200[i].ZDATE_SAP
                        , response.ZMMS0200[i].ZTIME_SAP
                        , response.ZMMS0200[i].ZDATE_PO
                    );
            }

            try
            {
                using (EPClientProxy proxy = new EPClientProxy())
                {
                    // 웹서비스 호출 후 응답값 저장
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "UPDATE_SAPIF"), param2);
                }
            }
            catch (Exception e)
            {
                Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);
                //SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.관리자에게 문의하십시오.
                this.MsgCodeAlert("SRMMM-0042");

                return "E";
            }

            // 실패면 메시지 처리, 성공이면 AMM9010 데이터 저장
            if (!response.ResHeader.zResultCd.Equals("S"))
            {
                //SAP IF 중 오류가 발생하였습니다. {0}
                this.MsgCodeAlert_ShowFormat("SRMMM-0033", "", "\r\n" + response.ResHeader.zResultMsg);

                return "E";
            }
            else
            {
                DataSet param3 = Util.GetDataSourceSchema
                (
                   "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME",
                   "CALCEL_DELI_NOTE", "USER_ID", "TRUCK_NO", "INVOICE_NO"
                );

                for (int i = 0; i < count; i++)
                {
                    param3.Tables[0].Rows.Add
                        (
                            response.ZMMS0200[i].BUKRS
                            , response.ZMMS0200[i].WERKS
                            , response.ZMMS0200[i].DELI_NOTE
                            , response.ZMMS0200[i].DELI_NOTE_CNT
                            , response.ZMMS0200[i].IF_DATE
                            , response.ZMMS0200[i].IF_TIME
                            , cancelDeliNote
                            , this.UserInfo.UserID
                            , this.txt01_TRUCK_NO.Value
                            , this.txt01_INVOICE.Value
                        );
                }

                try
                {
                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        //웹서비스 호출 후 응답이 'S'로 오면 SRM에 저장함
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_SUCCESS_3"), param3);

                        return "S";
                    }
                }
                catch(Exception e)
                {
                    Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);
                    //SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.SAP IF 미처리현황에서 확인하십시오.
                    this.MsgCodeAlert("SRMMM-0041");

                    return "E";
                }
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

        private void printReport(string deliDate, string deliNote, string sourcingDiv, string purcOrg, string purcPoType, string zgrtyp, string invoice_no)
        {
            //출력 가능여부 체크
            if (IsPrintable(deliDate, deliNote))
            {
                //1A1100:내수, 1A1110:수출
                if (purcOrg.Equals("1A1110"))
                {
                    //CKD 리포트 호출
                    printReportCKD(deliDate, deliNote);
                }
                else if (purcPoType.Equals("1K10"))
                {
                    //상품매출 입고검사표 리포트 호출 (EYG)
                    printReportEYG(deliDate, deliNote);
                }
                else if (purcPoType.Equals("1KMA"))
                {
                    //AS/SP/KD
                    //입고정산구분, 10:검수기준, NULL:입고기준
                    if (zgrtyp.Equals("10"))
                    {
                        //납품명세서 호출 (E2C) (고객사 라벨 포함)
                        //리포트 2장 : 제출용, 회수용
                        printReportE2C(deliDate, deliNote);
                    }
                    else
                    {
                        //거래명세표 리포트 호출 (E2A)
                        //리포트 3장 : 제출용, 수부용, 회수용
                        printReportE2A(deliDate, deliNote, "ASK", invoice_no);
                    }
                }
                else if (sourcingDiv.Equals("1I120") || sourcingDiv.Equals("1I200"))
                {
                    //1I120:비서열-실적, 1I200:직서열-실적
                    //납품명세표 리포트 호출 (E2B) (고객사 라벨 없음)
                    printReportE2B(deliDate, deliNote);
                }
                else// if (sourcingDiv.Equals("1I100"))
                {
                    //1I100:입고
                    //거래명세표 리포트 호출 (E2A)
                    printReportE2A(deliDate, deliNote, "", invoice_no);
                }
            }
            
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

            if (reportType.Equals("CKD"))
            {
                string[] cursorNames = new string[] { "OUT_CURSOR_H", "OUT_CURSOR_D", "OUT_CURSOR_C" };
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT_" + reportType), param, cursorNames);
            }
            else
            {
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT_" + reportType), param);
            }
        }

        /// <summary>
        /// 출력가능여부 체크
        /// </summary>
        /// <returns></returns>
        private bool IsPrintable(string deliDate, string deliNote)
        {
            bool isprintable = true;

            //2018.01.23 글로벌표준 검사성적서 입력여부 체크하지 않음.
            ////검사성적서 입력 건 체크          
            //HEParameterSet param = new HEParameterSet();
            //param.Add("DELI_DATE", deliDate);
            //param.Add("DELI_NOTE", deliNote);

            //DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PRINT_YN"), param);
           
            //for (int i = 0; i < source.Tables[0].Rows.Count; i++)
            //{
            //    //한건이라도 출력불가 레코드가 있으면 출력 불가능.
            //    if (source.Tables[0].Rows[i]["PRINTABLE"].ToString().Equals("NO"))
            //        isprintable = false;
            //}

            //if (isprintable == false)
            //{
            //    //검사성적서가 입력되지 않은 건이 있어 출력할 수 없습니다.
            //    this.MsgCodeAlert("SRMQA00-0048");
            //}

            return isprintable;
        }

        /// <summary>
        /// 거래명세표 출력
        /// </summary>
        private void printReportE2A(string deliDate, string deliNote, string ZGRTYP, string invoice_no)
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM22001_E2A";

                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                mainSection.ReportParameter.Add("DELI_DATE", deliDate);
                mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
                mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);
                mainSection.ReportParameter.Add("INVOICE_NO", invoice_no);

                report.Sections.Add("MAIN", mainSection);

                DataSet ds;

                if (ZGRTYP.Equals("ASK"))
                {
                    ds = getDataSetReport(deliDate, deliNote, "E2A_ASK");
                    // 리포트는 E2C(납품서)와 공유 (리포트 타이틀은 쿼리에서 '거래명세서'로 고정)
                    report.ReportName = "1000/SRM_MM/SRM_MM22001_E2C";
                }
                else
                {
                    ds = getDataSetReport(deliDate, deliNote, "E2A");
                }

                DataSet sealImage = getDataSetSealImage();
                if (ds.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00022"); //출력할 대상 Data가 없습니다.
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

        /// <summary>
        /// 납품명세표 출력
        /// </summary>
        private void printReportE2B(string deliDate, string deliNote)
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM22001_E2B";

                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                mainSection.ReportParameter.Add("DELI_DATE", deliDate);
                mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
                mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);

                report.Sections.Add("MAIN", mainSection);

                DataSet ds = getDataSetReport(deliDate, deliNote, "E2B");
                DataSet sealImage = getDataSetSealImage();
                if (ds.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00022"); //출력할 대상 Data가 없습니다.
                    return;
                }
                HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                HERexSection xmlSection2 = new HERexSection(sealImage, new HEParameterSet());
                report.Sections.Add("XML", xmlSection);
                report.Sections.Add("XML2", xmlSection2);

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

        /// <summary>
        /// 거래명세표 출력 (고객사 표기)
        /// </summary>
        private void printReportE2C(string deliDate, string deliNote)
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM22001_E2C";

                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                mainSection.ReportParameter.Add("DELI_DATE", deliDate);
                mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
                mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);

                report.Sections.Add("MAIN", mainSection);

                DataSet ds = getDataSetReport(deliDate, deliNote, "E2C");
                DataSet sealImage = getDataSetSealImage();
                if (ds.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00022"); //출력할 대상 Data가 없습니다.
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

        /// <summary>
        /// 상품매출 입고검사표(OEM상품)
        /// </summary>
        private void printReportEYG(string deliDate, string deliNote)
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM22001_EYG";  

                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                //mainSection.ReportParameter.Add("DELI_DATE", this.df01_DELI_DATE.Value);
                mainSection.ReportParameter.Add("DELI_DATE", deliDate);
                mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
                mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);

                report.Sections.Add("MAIN", mainSection);

                DataSet ds = getDataSetReport(deliDate, deliNote, "EYG");
                DataSet sealImage = getDataSetSealImage();
                if (ds.Tables[0].Rows.Count == 0)
                {
                    //출력할 대상 Data가 없습니다.
                    this.MsgCodeAlert_ShowFormat("COM-00022");
                    return;
                }
                HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                HERexSection xmlSection2 = new HERexSection(sealImage, new HEParameterSet()); 
                report.Sections.Add("XML", xmlSection);
                report.Sections.Add("XML2", xmlSection2);

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

        /// <summary>
        /// 거래명세서(CKD)
        /// </summary>
        private void printReportCKD(string deliDate, string deliNote)
        {
            try
            {
                DataSet ds = getDataSetReport(deliDate, deliNote, "CKD");
                if (ds.Tables[0].Rows.Count == 0)
                {
                    //출력할 대상 Data가 없습니다.
                    this.MsgCodeAlert_ShowFormat("COM-00022");
                    return;
                }

                string freeCharge = "N";
                if (ds.Tables[0].Rows.Count > 0)
                {
                    freeCharge = ds.Tables[0].Rows[0]["FREE_CHARGE_YN"].ToString();
                }
                string[] Charge = new string[12] { "", "", "", "", "", "", "", "", "", "", "", "" };
                if (ds.Tables[2].Rows.Count > 0)
                {
                    int i = 0;
                    foreach (DataRow row in ds.Tables[2].Rows)
                    {
                        for (int j = 0; j < ds.Tables[2].Columns.Count; j++)
                        {
                            Charge[i] = String.IsNullOrEmpty(row[j].ToString()) ? "" : row[j].ToString();
                            i++;
                        }
                    }
                }

                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM22001_CKD";

                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("TransNo", deliNote);
                mainSection.ReportParameter.Add("FreeCharge", freeCharge);
                mainSection.ReportParameter.Add("ChargeNo1", Charge[0]);
                mainSection.ReportParameter.Add("ChargeName1", Charge[1]);
                mainSection.ReportParameter.Add("ChargeJob1", Charge[2]);
                mainSection.ReportParameter.Add("ChargePhone1", Charge[3]);
                mainSection.ReportParameter.Add("ChargeNo2", Charge[4]);
                mainSection.ReportParameter.Add("ChargeName2", Charge[5]);
                mainSection.ReportParameter.Add("ChargeJob2", Charge[6]);
                mainSection.ReportParameter.Add("ChargePhone2", Charge[7]);
                mainSection.ReportParameter.Add("ChargeNo3", Charge[8]);
                mainSection.ReportParameter.Add("ChargeName3", Charge[9]);
                mainSection.ReportParameter.Add("ChargeJob3", Charge[10]);
                mainSection.ReportParameter.Add("ChargePhone3", Charge[11]);

                report.Sections.Add("MAIN", mainSection);

                DataSet ds1 = new DataSet();
                ds1.Tables.Add(ds.Tables[0].Copy());
                ds1.Tables[0].TableName = "DATA";
                DataSet ds2 = new DataSet();
                ds2.Tables.Add(ds.Tables[1].Copy());
                ds2.Tables[0].TableName = "DATA";

                HERexSection xmlSection = new HERexSection(ds1, new HEParameterSet());
                HERexSection xmlSection2 = new HERexSection(ds2, new HEParameterSet());
                report.Sections.Add("XML1", xmlSection);
                report.Sections.Add("XML2", xmlSection2);

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

        /// <summary>
        /// 백지전표 출력
        /// </summary>
        private void printBlankReport()
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM22002_BLANK"; 

                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                mainSection.ReportParameter.Add("DELI_DATE", this.df01_DELI_DATE.Value);
                mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);

                report.Sections.Add("MAIN", mainSection);

                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.Value);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);

                DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT_BLANK"), param);
                HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                report.Sections.Add("XML", xmlSection); 

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
        public bool IsSaveValid_2(DataRow parameter, string corcd, int actionRow = -1)
        {
            decimal deliQty;
            decimal unitPackQty;

            if (System.Text.Encoding.UTF8.GetByteCount(parameter["VEND_LOTNO"].ToString()) > 30)
            {
                //{0}번째 행에 {1}는 {2}bytes이상 입력할 수 없습니다.
                this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "VEND_LOTNO"), 30);
                return false;
            }
            if (System.Text.Encoding.UTF8.GetByteCount(parameter["CHANGE_4M"].ToString()) > 4000)
            {
                //{0}번째 행에 {1}는 {2}bytes이상 입력할 수 없습니다.
                this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "CHANGE_4M"), 4000);
                return false;
            }

            if (this.df01_ARRIV_DATE.IsEmpty)
            {
                //도착일자를 확인 바랍니다.
                this.MsgCodeAlert_ShowFormat("SRMMM-0021");
                return false;
            }

            // 적입량 필수 입력값
            if (parameter["UNIT_PACK_QTY"].ToString().Equals(""))
            {
                //{0}번째 행의 {1}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "UNIT_PACK_QTY"));
                return false;
            }

            // 적입량은 0이 될 수 없다.
            if (parameter["UNIT_PACK_QTY"].ToString().Equals("0"))
            {
                //{0}번째 행의 {1} 값은 0보다 커야 합니다.
                this.MsgCodeAlert_ShowFormat("SRMMM-0038", actionRow, Util.GetHeaderColumnName(Grid01, "UNIT_PACK_QTY"));
                return false;
            }

            // 제조일자 필수 입력값
            if (parameter["PRDT_DATE"].ToString().Equals(""))
            {
                //{0}번째 행의 {1}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "PRDT_DATE"));
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

            unitPackQty = Convert.ToDecimal(parameter["UNIT_PACK_QTY"].ToString());
            deliQty = Convert.ToDecimal(parameter["DELI_QTY"].ToString());

            // 국내&내수는 납품량=적입량. 그 외는 납품량/적입량 = 최대 1,000
            if (!(corcd.Equals("1000") && cbo01_PURC_ORG.Value.Equals("1A1100")))
            {
                if (deliQty / unitPackQty > 1000)
                {
                    //{0}행의 박스수량은 1000보다 작아야 합니다.
                    this.MsgCodeAlert_ShowFormat("SRMMM-0037", actionRow);
                    return false;
                }
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
        public bool IsSaveValidRemainQty(string pono, string ponoSeq, string vendcd, string deliDate, decimal deliQty, string cancelDeliNote, string cancelDeliNoteSeq)
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

            decimal remainQty = Convert.ToDecimal(source.Tables[0].Rows[0]["REMAIN_QTY"]);

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
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_DELI_DATE", lbl01_DELI_DATE.Text);
                return  false;
            }
            if (this.df01_ARRIV_DATE.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_ARRIV_DATE", lbl01_ARRIV_DATE.Text);
                return false;
            }
            //if (this.cbo01_PURC_PO_TYPE.IsEmpty)
            //{
            //    //{0}를(을) 입력해주세요.
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
        public void Grid01_Cell_DoubleClick(string deliNote, string invoice_no)
        {
            DataSet resultDetail = getDataSetDetail(deliNote);

            if (resultDetail.Tables[0].Rows.Count > 0)
            {
                this.df01_DELI_DATE.SetValue(resultDetail.Tables[0].Rows[0]["DELI_DATE"]);
                this.df01_ARRIV_DATE.SetValue(resultDetail.Tables[0].Rows[0]["ARRIV_DATE"]);
                this.txt01_ARRIV_TIME.SetValue(resultDetail.Tables[0].Rows[0]["ARRIV_TIME"].ToString().Replace(":", ""));
                this.txt01_TRUCK_NO.SetValue(resultDetail.Tables[0].Rows[0]["TRUCK_NO"]);
                this.txt01_INVOICE.SetValue(invoice_no);
            }
            else
            {
                this.df01_DELI_DATE.SetValue(DateTime.Now);
                this.df01_ARRIV_DATE.SetValue(DateTime.Now);
                this.txt01_ARRIV_TIME.SetValue(string.Empty);
                this.txt01_TRUCK_NO.SetValue(string.Empty);
            }

            this.Store7.DataSource = resultDetail.Tables[0];
            this.Store7.DataBind();
        }

        //2018.01.23 글로벌표준 검사성적서 입력 팝업 사용하지 않음.
        ///// <summary>
        ///// 더블클릭시 검사성적서 등록 팝업 표시한다.
        ///// </summary>
        ///// <param name="qty"></param>
        ///// <param name="partno"></param>
        ///// <param name="barcode"></param>
        //[DirectMethod]
        //public void Grid02_Cell_DoubleClick(string qty, string partno, string barcode, string delicnt)
        //{
        //    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
        //    HEParameterSet set = new HEParameterSet();
        //    set.Add("BIZCD", this.cbo01_BIZCD.Value);
        //    set.Add("BARCODE", barcode);
        //    set.Add("PARTNO", partno);
        //    set.Add("VENDCD", this.cdx01_VENDCD.Value);
        //    set.Add("QTY", qty);            
        //    set.Add("DELI_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
        //    set.Add("DELI_CNT", delicnt);
        //    set.Add("NOTE_TYPE", "T");           
        //    set.Add("VINNM", "");

        //    Util.UserPopup(this, this.UserHelpURL.Text, set, "HELP_QA23001P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
        //}

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
            this.txt01_ARRIV_TIME.Value = string.Empty;
            this.txt01_TRUCK_NO.Value = string.Empty;
            this.df01_ARRIV_DATE.SetValue(DateTime.Now);

            this.Store1.RemoveAll();
            this.Store7.RemoveAll();
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
