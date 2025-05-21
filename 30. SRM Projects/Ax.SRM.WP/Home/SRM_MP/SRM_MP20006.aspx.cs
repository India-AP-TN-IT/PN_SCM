#region ▶ Description & History
/* 
 * 프로그램명 : 거래명세서 등록
 * 설      명 : 일반구매 > 납품관리 > 거래명세서 등록
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

using System.Configuration;
using System.ServiceModel.Configuration;

namespace Ax.SRM.WP.Home.SRM_MP
{
    public partial class SRM_MP20006 : BasePage
    {
        private string pakageName = "SIS.APG_SRM_MP20006";
        //private bool isUseSAPPO = true;

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MP20006
        /// </summary>
        public SRM_MP20006()
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
                    Library.ComboDataBind(this.cbo01_MRO_PO_TYPE, Library.GetTypeCode("1J").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true, "");

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
                //if (this.hidMODE.Value.ToString().Equals("Regist"))
                //{
                //    ibtn.DirectEvents.Click.ExtraParams.Add(
                //        new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
                //    //new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues(false)", Mode = ParameterMode.Raw, Encode = true });
                //}
                //else
                //{
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
                //}
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

            // 버튼 이벤트가 발생할 때 마다 납품일자는 현재일을 업데이트 해야함
            this.df01_DELI_DATE.SetValue(this.getCurrentDate());

            switch (ibtn.ID)
            {
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
        public void etc_Button_Click(object sender, EventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_PRINT_REPORT":
                    //납품전표 출력 버튼
                    //printReport("0");
                    break;

                case "btn01_BLANK_REPORT":
                    //백지전표 출력 버튼
                    //printBlankReport();
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
        /// getDeliNote
        /// </summary>
        /// <returns></returns>
        private int getDeliCnt()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("NOTE_CRT_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));

            string procedure = "GET_DELI_CNT";
            return Convert.ToInt32(EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param).Tables[0].Rows[0]["DELI_CNT"].ToString());
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
            param.Add("DELI_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            string procedure = "INQUERY";

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);
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
                string json = e.ExtraParams["Values"];

                CheckSaveValidation(json.Replace("'", "\\'"));
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
        /// 저장 Validation 체크 및 출력 여부 묻기
        /// </summary>
        /// <param name="json"></param>
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
                    "PONO", "PONO_SEQ", "DELI_QTY"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if ((parameters[i]["DELI_QTY"] == null || parameters[i]["DELI_QTY"] == string.Empty))
                    {
                        continue;
                    }

                    param.Tables[0].Rows.Add
                    (
                        parameters[i]["PONO"]
                        , parameters[i]["PONO_SEQ"]
                        , parameters[i]["DELI_QTY"]
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid_2(
                            param.Tables[0].Rows[param.Tables[0].Rows.Count - 1],
                            Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }

                if (param.Tables[0].Rows.Count == 0)
                {
                    //저장할 대상 Data가 없습니다.
                    this.MsgCodeAlert("COM-00020");
                    return;
                }
                else
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
                            Handler = "Ext.net.Mask.show({ msg: '" + processing + "' }); App.direct.Save('" + json + "', 'YES', { success: function (result) { Ext.net.Mask.hide(); } });",
                            Text = "YES"
                        },
                        No = new MessageBoxButtonConfig
                        {
                            Handler = "Ext.net.Mask.show({ msg: '" + processing + "' }); App.direct.Save('" + json + "', 'NO', { success: function (result) { Ext.net.Mask.hide(); } }); ",
                            Text = "NO",
                        },
                        Cancel = new MessageBoxButtonConfig
                        {

                            Text = "CANCEL"
                        }
                    }).Show();
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

                if (parameters.Length == 0)
                {
                    //저장할 대상 Data가 없습니다.
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                // 납품차수 및 IF_DATE, IF_TIME 설정
                HEParameterSet param3 = new HEParameterSet();
                param3.Add("BIZCD", this.cbo01_BIZCD.Value);
                param3.Add("VENDCD", this.cdx01_VENDCD.Value);
                param3.Add("DELI_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
                string procedure = "GET_DELI_CNT_2";
                DataTable dt = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param3).Tables[0];
                int deliCnt = Convert.ToInt32(dt.Rows[0]["DELI_CNT"]);
                int deliCntSeq = Convert.ToInt32(dt.Rows[0]["DELI_CNT_SEQ"]);

                DataSet param = Util.GetDataSourceSchema
                (
                    "BIZCD", "MRO_PO_TYPE", "DELI_CNT", "DELI_CNT_SEQ", "PONO", "PONO_SEQ",
                    "DELI_QTY", "PRDT_DATE",
                    "DELI_DATE", "ARRIV_DATE", "ARRIV_TIME", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if ((parameters[i]["DELI_QTY"] == null || parameters[i]["DELI_QTY"] == string.Empty || parameters[i]["DELI_QTY"] == "0"))
                    {
                        continue;
                    }

                    param.Tables[0].Rows.Add
                    (
                        this.cbo01_BIZCD.Value
                        , parameters[i]["MRO_PO_TYPE"]
                        , deliCnt
                        , deliCntSeq
                        , parameters[i]["PONO"]
                        , parameters[i]["PONO_SEQ"]
                        , parameters[i]["DELI_QTY"]
                        , parameters[i]["PRDT_DATE"]
                        , ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd")
                        , ((DateTime)this.df01_ARRIV_DATE.Value).ToString("yyyy-MM-dd")
                        , this.txt01_ARRIV_TIME.Value
                        , this.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_2"), param);
                }

                //저장 후 전표출력을 하겠다고 했으면 출력루틴
                if (printYN.Equals("YES"))
                {
                    //출력여부 판단
                    bool isPrint = true;

                    // corcd, bizcd, delidate, delicnt
                    if (isPrint)
                    {
                        //저장되었습니다.
                        //this.MsgCodeAlert("COM-00001");

                        string deliDate = ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd");
                        printReport(deliDate, deliCnt);
                    }
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

        private void printReport(string deliDate, int deliCnt)
        {
            //거래명세표 리포트 호출 (E2A)
            printReportE2A(deliDate, deliCnt);
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
        private DataSet getDataSetReport(string deliDate, int deliCnt)
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("DELI_DATE", deliDate);
            param.Add("DELI_CNT", deliCnt);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("MRO_PO_TYPE", this.cbo01_MRO_PO_TYPE.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            //return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT_" + reportType + "_CALL"), param);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT_CALL"), param);
        }

        /// <summary>
        /// 거래명세표 출력
        /// </summary>
        private void printReportE2A(string deliDate, int deliCnt)
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

                DataSet ds = getDataSetReport(deliDate, deliCnt);
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

        #endregion

        #region [ 유효성 검사 ]
        public bool IsArriveTimeValid()
        {
            //도착시간 확인
            if (this.txt01_ARRIV_TIME.IsEmpty)
            {
                //도착시간은 NULL 혀용
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

            //등록모드일 경우 도착시간 확인
            //if (this.txt01_ARRIV_TIME.IsEmpty || this.txt01_ARRIV_TIME.Value.ToString().Length < 4 || this.txt01_ARRIV_TIME.Value.ToString().Length > 5)
            if (this.txt01_ARRIV_TIME.IsEmpty)
            {
                //도착시간  NULL 허용
            }
            else if (this.txt01_ARRIV_TIME.Value.ToString().Length < 4 || this.txt01_ARRIV_TIME.Value.ToString().Length > 5)
            {
                //도착시간을 확인 바랍니다.
                this.MsgCodeAlert_ShowFormat("SRMMM-0013");
                return false;
            }
            else
            {
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
            
            //2015-02-25 도착일자, 납품일자 체크로직 추가함. 도착일자는 납품일자와 같거나 늦어야 함.
            DateTime DELI_DATE = Convert.ToDateTime(this.df01_DELI_DATE.Value);
            DateTime ARRIV_DATE = Convert.ToDateTime(this.df01_ARRIV_DATE.Value);

            if (DateTime.Compare(ARRIV_DATE, DELI_DATE) < 0)
            {
                //도착일자는 납품일자보다 늦거나 같아야 합니다.
                this.MsgCodeAlert("SRMMM-0020");
                return false;
            }

            //잔량 확인
            string vendCd = this.cdx01_VENDCD.Value;
            string deliDate = ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd");
            string pono = parameter["PONO"].ToString();
            string ponoSeq = parameter["PONO_SEQ"].ToString();
            int deliQty = Convert.ToInt32(parameter["DELI_QTY"].ToString());
            if (!IsSaveValidRemainQty(pono, ponoSeq, vendCd, deliDate, deliQty)) return false;

            return true;
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
        public bool IsSaveValidRemainQty(string pono, string ponoSeq, string vendcd, string deliDate, int deliQty)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("PONO", pono);
            param.Add("PONO_SEQ", ponoSeq);
            param.Add("VENDCD", vendcd);
            param.Add("DELI_DATE", deliDate);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "GET_REMAIN_QTY"), param);

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
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_DELI_DATE", lbl01_DELI_DATE.Text);
                return false;
            }
            if (this.df01_ARRIV_DATE.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_ARRIV_DATE", lbl01_ARRIV_DATE.Text);
                return false;
            }
            if (this.cbo01_MRO_PO_TYPE.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_MRO_PO_TYPE", lbl01_MRO_PO_TYPE.Text);
                return false;
            }

            return true;
        }

        #endregion

        #region [ 이벤트 ]

        protected void cbo01_MRO_PO_TYPE_Change(object sender, DirectEventArgs e)
        {
            this.initGrid();
        }

        #endregion

        #region [ 헬프,콤보상자 관련 처리 ]

        //검색조건을 바꾸면 그리드 초기화 및 입력필드 초기화
        public void changeCondition(object sender, DirectEventArgs e)
        {
            this.initGrid();
        }

        // 초기화
        private void initGrid()
        {
            this.txt01_ARRIV_TIME.Value = string.Empty;

            this.df01_ARRIV_DATE.SetValue(DateTime.Now);

            this.Store1.RemoveAll();
        }

        #endregion


    }
}
