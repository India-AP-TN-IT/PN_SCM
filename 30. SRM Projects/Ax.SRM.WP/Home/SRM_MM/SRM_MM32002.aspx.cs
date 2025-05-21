using System;
using System.Collections.Generic;
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using HE.Framework.Core.Report;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM32002 : BasePage
    {
        private string pakageName = "APG_SRM_MM32002";
        private string pakageName2 = "APG_SRM_MM22002"; //납품전표 출력
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM32001
        /// </summary>
        public SRM_MM32002()
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
                    this.SetCombo();
                    this.Reset();                    
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
        
        /// <summary>
        /// 콤보상자 바인딩(위치)
        /// </summary>
        private void SetCombo()
        {
            Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);

            DataTable source = Library.GetTypeCode("1K").Tables[0];
            source.DefaultView.RowFilter = "TYPECD NOT IN ('NI')";
            Library.ComboDataBind(this.cbo01_PURC_PO_TYPE, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
            this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

            source = Library.GetTypeCode("1A").Tables[0];
            Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", false);
            if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
            {
                this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
            }
            this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

            source = Library.GetTypeCode("1Z").Tables[0];
            Library.ComboDataBind(this.cbo01_SEARCH_OPT, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
            this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.
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
            MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
            MakeButton(ButtonID.Close,   ButtonImage.Close,   "Close",      this.ButtonPanel);
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

            if (id == ButtonID.Search || id == ButtonID.M_Search)
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "GridPanel";
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
                case ButtonID.Search:
                    Search();
                    break;
                case ButtonID.Reset:
                    Reset();
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
                // 집계
                if (this.cbo01_SEARCH_OPT.Value.Equals("1ZS"))
                {
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
                }
                else //상세, 취소
                {
                    this.Store3.DataSource = result.Tables[0];
                    this.Store3.DataBind();
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
        /// Reset
        /// </summary>
        public void Reset()
        {
            //업체코드는 서연이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cbo01_SEARCH_OPT.SelectedItem.Value = "1ZD";
            this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.
            this.btn01_PRINT_REPORT.Show();

            this.df01_FROM_DATE.SetValue(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
            this.df01_TO_DATE.SetValue(DateTime.Now.ToString("yyyy-MM-dd"));

            this.txt01_FPARTNO.SetValue(string.Empty);
            this.txt01_DELI_NOTE.SetValue(string.Empty);

            this.cdx01_STR_LOC.SetValue(string.Empty);

            this.Grid02.Show();
            this.Grid01.Hide();

            this.Store1.RemoveAll();
            this.Store3.RemoveAll();            
        }
        
        /// <summary>
        /// 데이터 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", cdx01_VENDCD.Value);
            param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));            
            param.Add("PURC_ORG", cbo01_PURC_ORG.Value);
            param.Add("PURC_PO_TYPE", cbo01_PURC_PO_TYPE.Value);
            param.Add("PARTNO", txt01_FPARTNO.Value);
            param.Add("STR_LOC", cdx01_STR_LOC.Value); //저장위치
            param.Add("TYPE", cbo01_SEARCH_OPT.Value);
            param.Add("DELI_NOTE", txt01_DELI_NOTE.Value);
            param.Add("CUSTCD", cdx01_CUSTCD.Value);
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
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], (cbo01_SEARCH_OPT.Value.Equals("1ZS") ? Grid01 : Grid02));
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

            if (this.cbo01_BIZCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_BIZCD", lbl01_BIZCD.Text);
                return false;
            }

            if (this.df01_FROM_DATE.IsEmpty || this.df01_TO_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_FROM_DATE", lbl01_DELIVERYDATE.Text);
                return false;
            }
            
            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
                return false;
            }

            return true;
        }

        #endregion

        #region [사용자 함수]
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
        
        protected void cbo01_SEARCH_OPT_Change(object sender, DirectEventArgs e)
        {
            Ext.Net.ComboBox cbo = (Ext.Net.ComboBox)sender;
            if (cbo.Value.Equals("1ZS"))
            {
                this.Grid01.Show();
                this.Grid02.Hide();
            }
            else
            {
                this.Grid01.Hide();
                this.Grid02.Show();
            }

            if (cbo.Value.Equals("1ZD"))
            {
                this.btn01_PRINT_REPORT.Show();
            }
            else
            {
                this.btn01_PRINT_REPORT.Hide();
            }
        }

        [DirectMethod]
        public void MakePopUp(String[] arr, string type)
        {            
            // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
            HEParameterSet param = new HEParameterSet();
            if (type.Equals("S"))
            {
                // 집계, 납품수량
                param.Add("CORCD", UserInfo.CorporationCode);
                param.Add("BIZCD", cbo01_BIZCD.Value);
                param.Add("VENDCD", arr[7]);
                param.Add("PURC_ORG", arr[0]);
                param.Add("PURC_PO_TYPE", arr[1]);
                param.Add("VINCD", arr[2]);
                param.Add("PARTNO", arr[3]);
                param.Add("PARTNM", arr[4]);
                param.Add("UNIT", arr[5]);
                param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));            
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM32002P1.aspx", param, "HELP_MM32001P1", "Popup", 800, 600);
            }
            else if (type.Equals("I"))
            {
                // 집계, 입하수량
                param.Add("CORCD", UserInfo.CorporationCode);
                param.Add("BIZCD", cbo01_BIZCD.Value);
                param.Add("VENDCD", arr[7]);
                param.Add("PURC_ORG", arr[0]);
                param.Add("PURC_PO_TYPE", arr[1]);
                param.Add("PURC_GRP", arr[6]);
                param.Add("PARTNO", arr[3]);
                param.Add("PARTNM", arr[4]);
                param.Add("UNIT", arr[5]);
                param.Add("GRN_NO", "");
                param.Add("DATE_TYPE", ""); //전기일자 (입고일자)
                param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DIV", "D");
                param.Add("CUSTCD", "");
                //입하정보
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM31006P2.aspx", param, "HELP_MM31006P2", "Popup", 800, 600);
            }
            else if (type.Equals("M"))
            {
                // 상세, 입하수량
                param.Add("CORCD", UserInfo.CorporationCode);
                param.Add("BIZCD", cbo01_BIZCD.Value);
                param.Add("VENDCD", arr[5]);
                param.Add("PURC_ORG", arr[6]);
                param.Add("PURC_PO_TYPE", arr[7]);
                param.Add("PURC_GRP", arr[8]);
                param.Add("PARTNO", arr[1]);
                param.Add("PARTNM", arr[2]);
                param.Add("UNIT", arr[3]);
                param.Add("GRN_NO", arr[4]);
                param.Add("DATE_TYPE", ""); //전기일자 (입고일자)
                param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DIV", "D");
                param.Add("CUSTCD", "");
                //입하정보
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM31006P2.aspx", param, "HELP_MM31006P2", "Popup", 800, 600);
            }
            else
            {
                // 상세, 발주번호
                //param.Add("PONO", param1);
                param.Add("PONO", arr[0]);
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM32002P2.aspx", param, "HELP_MM32001P2", "Popup", 800, 600);
            }
        }
        
        #endregion

        #region 납품전표 출력
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

                Dictionary<string, string>[] grid02SelectedValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid02SelectedValues"]);
                
                if (grid02SelectedValues.Length.Equals(0))
                {
                    //선택된 Row가 없습니다. 확인 바랍니다.
                    this.MsgCodeAlert("COM-00100");
                    return;
                }

                string deliDate = grid02SelectedValues[0]["DELI_DATE"];
                string deliNote = grid02SelectedValues[0]["DELI_NOTE"].Split('-')[0];
                string sourcingDiv = grid02SelectedValues[0]["SOURCING_DIV"];
                string purcOrg = grid02SelectedValues[0]["PURC_ORG"];
                string purcPoType = grid02SelectedValues[0]["PURC_PO_TYPE"];
                string arriveDate = grid02SelectedValues[0]["ARRIV_DATE"];
                string invoice_no = grid02SelectedValues[0]["INVOICE_NO"];

                printReport(deliDate, deliNote, sourcingDiv, purcOrg, purcPoType, arriveDate, invoice_no);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {

            }
        }
        
        private void printReport(string deliDate, string deliNote, string sourcingDiv, string purcOrg, string purcPoType, string arriveDate, string invoice_no)
        {
            //출력 가능여부 체크
            if (IsPrintable(deliDate, deliNote))
            {
                //1A1100:내수, 1A1110:수출
                if (purcOrg.Equals("1A1110"))
                {
                    //CKD 리포트 호출
                    printReportCKD(deliDate, deliNote, arriveDate);
                }
                else if (purcPoType.Equals("1K10"))
                {
                    //상품매출 입고검사표 리포트 호출 (EYG)
                    printReportEYG(deliDate, deliNote, arriveDate);
                }
                else if (sourcingDiv.Equals("1I120") || sourcingDiv.Equals("1I200"))
                {
                    //1I120:비서열-실적, 1I200:직서열-실적
                    //납품명세표 리포트 호출 (E2B)
                    printReportE2B(deliDate, deliNote, arriveDate);
                }
                else// if (sourcingDiv.Equals("1I100"))
                {
                    //1I100:입고
                    //거래명세표 리포트 호출 (E2A)
                    printReportE2A(deliDate, deliNote, arriveDate, invoice_no);
                }
            }
        }

        private DataSet getDataSetSealImage()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName2, "INQUERY_SEAL_IMAGE"), param);
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
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName2, "INQUERY_REPORT_" + reportType), param, cursorNames);
            }
            else
            {
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName2, "INQUERY_REPORT_" + reportType), param);
            }
        }

        /// <summary>
        /// 출력가능여부 체크
        /// </summary>
        /// <returns></returns>
        private bool IsPrintable(string deliDate, string deliNote)
        {
            //검사성적서 입력 건 체크          
            HEParameterSet param = new HEParameterSet();
            param.Add("DELI_DATE", deliDate);
            param.Add("DELI_NOTE", deliNote);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName2, "INQUERY_PRINT_YN"), param);
            bool isprintable = true;
            for (int i = 0; i < source.Tables[0].Rows.Count; i++)
            {
                //한건이라도 출력불가 레코드가 있으면 출력 불가능.
                if (source.Tables[0].Rows[i]["PRINTABLE"].ToString().Equals("NO"))
                    isprintable = false;
            }

            //검사성적서가 입력되지 않은 건이 있어 출력할 수 없습니다.
            if (isprintable == false)
            {
                this.MsgCodeAlert("SRMQA00-0048");
            }

            return isprintable;
        }

        /// <summary>
        /// 거래명세표 출력
        /// </summary>
        private void printReportE2A(string deliDate, string deliNote, string arriveDate, string invoice_no)
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
                //mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);
                mainSection.ReportParameter.Add("ARRIV_DATE", arriveDate);
                mainSection.ReportParameter.Add("INVOICE_NO", invoice_no);

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

        /// <summary>
        /// 납품명세표 출력
        /// </summary>
        private void printReportE2B(string deliDate, string deliNote, string arriveDate)
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
                //mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);
                mainSection.ReportParameter.Add("ARRIV_DATE", arriveDate);

                report.Sections.Add("MAIN", mainSection);

                DataSet ds = getDataSetReport(deliDate, deliNote, "E2B");
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
        private void printReportEYG(string deliDate, string deliNote, string arriveDate)
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM22001_EYG";

                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                //mainSection.ReportParameter.Add("DELI_DATE", this.df01_NOTE_CRT_DATE.Value);
                mainSection.ReportParameter.Add("DELI_DATE", deliDate);
                mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
                //mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);
                mainSection.ReportParameter.Add("ARRIV_DATE", arriveDate);

                report.Sections.Add("MAIN", mainSection);

                DataSet ds = getDataSetReport(deliDate, deliNote, "EYG");
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
        /// 거래명세서(CKD)
        /// </summary>
        private void printReportCKD(string deliDate, string deliNote, string arriveDate)
        {
            try
            {
                DataSet ds = getDataSetReport(deliDate, deliNote, "CKD");
                if (ds.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00022"); //출력할 대상 Data가 없습니다.
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

        #endregion
    }
}
