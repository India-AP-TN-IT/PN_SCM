#region ▶ Description & History
/* 
 * 프로그램명 : 사급 직납 마감 등록 (구.VM4070)
 * 설      명 : 자재관리 > 사급관리 > 사급 직납 마감 등록
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-07
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
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using HE.Framework.Core.Report;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM26006 : BasePage
    {
        private string pakageName = "APG_SRM_MM26006";        
        DateTime _dtWorkDate = new DateTime();
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM26006
        /// </summary>
        public SRM_MM26006()
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
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);

                    DataTable source = Library.GetTypeCode("1A").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", false);
                    if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
                    {
                        this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                    }
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.
                                        
                    HEParameterSet param = new HEParameterSet();
                    param.Add("LANG_SET", this.UserInfo.LanguageShort);

                    source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_COMBO"), param).Tables[0];

                    Library.ComboDataBind(this.cbo02_UNIT, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo02_UNIT.UpdateSelectedItems(); //꼭 해줘야한다.

                    SetCustVendVisible("1");
                    
                    Reset();

                    //해당월 마감일 표시
                    changeCondition(null, null);
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
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
            //MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
            MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
            MakeButton(ButtonID.Close, ButtonImage.Close, "Close", this.ButtonPanel);

            //엑셀 업로드용 버튼
            MakeButton(ButtonID.Upload, ButtonImage.Upload, "Upload", this.ButtonPanel2, true);
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
                ibtn.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                ibtn.DirectEvents.Click.Confirmation.Title = "Confirm";
                ibtn.DirectEvents.Click.Confirmation.Message = "Do you want save?";

                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
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
                //case ButtonID.Print:
                //    Print();
                //    break;
                case ButtonID.ExcelDL:
                    Excel_Export();
                    break;
                case ButtonID.Upload:
                    Excel_Import();
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
                case "btn01_DOWN":
                    Excel();
                    break;

                case "btn01_PRINT_REPORT2":
                    //거래명세표 출력 버튼
                    Print();
                    break;

                default:
                    break;
            }
        }

        #endregion

        #region [ 기능 ]

        [DirectMethod]
        public void SetCustVendVisible(string gubun)
        {
            this.Store1.RemoveAll();

            bool value = RadioGroup2.CheckedItems[0].InputValue.ToString().Equals("1"); //정상이면 true

            if (gubun.Equals("1"))
            {
                this.lbl01_CUST.Hidden = true;
                this.cdx01_CUSTCD.VisiableContainer = false;
                this.cdx01_CUSTCD2.VisiableContainer = true;

                this.lbl01_VEND.Hidden = false;
                this.cdx01_VENDCD.VisiableContainer = true;
                this.cdx01_VENDCD2.VisiableContainer = false;

                this.cbo02_UNIT.ReadOnly = (value ? false : true);
                this.txt02_RESALE_QTY.ReadOnly = (value ? false : true);
                this.VEND_OK.Editable = true;
                this.CUST_OK.Editable = false;
            }
            else
            {
                this.lbl01_CUST.Hidden = false;
                this.cdx01_CUSTCD.VisiableContainer = true;
                this.cdx01_CUSTCD2.VisiableContainer = false;

                this.lbl01_VEND.Hidden = true;
                this.cdx01_VENDCD.VisiableContainer = false;
                this.cdx01_VENDCD2.VisiableContainer = true;

                this.cbo02_UNIT.ReadOnly = (value ? true : false);
                this.txt02_RESALE_QTY.ReadOnly = (value ? true : false);
                this.VEND_OK.Editable = false;
                this.CUST_OK.Editable = true;
            }
        }

        [DirectMethod]
        public void SetGridSetting(string gubun)
        {
            this.SetCustVendVisible(RadioGroup1.CheckedItems[0].InputValue.ToString());

            //그리드 Lock 기능 있으면 2중 그리드가 되어 열이동 정상 작동 안됨
            if (gubun.Equals("1"))
            {
                this.Grid01.ColumnModel.Move(9, 8);
            }
            else
            {
                this.Grid01.ColumnModel.Move(9, 8);
            }

            this.Grid01.Refresh();
        }
        
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

                //Reset();
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
            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
                this.cdx01_CUSTCD.SetValue(string.Empty);
            }

            this.rdo01_OPT11.Selectable = true;

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.           

            this.df01_DATE.SetValue(DateTime.Now);

            this.cdx01_VINCD.SetValue(string.Empty);
            this.txt01_PARTNO.Text = string.Empty;
            this.txt01_MGRNM.Text = string.Empty;
            this.txt01_ROWCNT_EXCEL.Text = string.Empty;
            this.txt01_ROWCNT_ADDED.Text = string.Empty;

            this.Store1.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            //해당월 마감일 표시
            changeCondition(null, null);

            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("TYPE", RadioGroup2.CheckedItems[0].InputValue.ToString().Equals("1") ? "1" : "2");
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
            param.Add("DATE", ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM"));
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("PARTNO", this.txt01_PARTNO.Text);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1"))
            {
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("CUSTCD", this.cdx01_CUSTCD2.Value);
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_01"), param);
            }
            else
            {
                param.Add("CUSTCD", this.cdx01_CUSTCD.Value);
                param.Add("VENDCD", this.cdx01_VENDCD2.Value);
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_02"), param);
            }
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private string[] getWorkDateChk()
        {
            string strWokrDate = string.Empty;
            string strClsTime = string.Empty;
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
            param.Add("STD_YYMM", ((DateTime)this.df01_DATE.Value).AddMonths(1).ToString("yyyy-MM"));//DateTime.Now.ToString("yyyy-MM"));
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.SelectedItem.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_WORK_DATE_CHK"), param);

            if (ds.Tables[0].Rows.Count > 0)
            {
                strWokrDate = ds.Tables[0].Rows[0]["WORK_DATE"].ToString();
                strClsTime = ds.Tables[0].Rows[0]["CLS_TIME"].ToString();
            }
            return new string[] { strWokrDate, strClsTime };
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getReportDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("TYPE", RadioGroup2.CheckedItems[0].InputValue.ToString().Equals("1") ? "1" : "2");
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
            param.Add("DATE", ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM"));
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("PARTNO", this.txt01_PARTNO.Text);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1"))
            {
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("CUSTCD", this.cdx01_CUSTCD2.Value);
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT01"), param);
            }
            else
            {
                param.Add("CUSTCD", this.cdx01_CUSTCD.Value);
                param.Add("VENDCD", this.cdx01_VENDCD2.Value);
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT02"), param);
            }
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

                LastDaysDisplay();
                
                //공통코드에 등록된 일자 기준(워크데이트만 포함)으로 마감 일 조정 2016.4.4 이현범
                //서연이화 사용자는 편집 불가 기능에 상관없이 수정 가능하도록 변경 2016.9.5 이현범
                if (_dtWorkDate < DateTime.Now && !this.UserInfo.UserDivision.Equals("T12"))
                {
                    this.MsgCodeAlert("SCMMM-0022");
                    return;
                }

                DataSet removeParam = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "STD_YYMM", "VENDCD", "PARTNO", "CUSTCD", "IO_DIV", "PURC_ORG", "USER_ID"
                );

                DataSet saveParam = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "STD_YYMM", "VENDCD", "PARTNO", "CUSTCD", "IO_DIV", "PURC_ORG", "UNIT", "RESALE_QTY",
                   "VEND_NAME", "VEND_OK", "CUST_NAME", "CUST_OK", "USER_ID", "TYPE"
                );

                bool report = false;

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (Convert.ToDecimal(parameters[i]["RESALE_QTY"]) == 0) //2018.06.11  소숫점 허용
                    {
                        removeParam.Tables[0].Rows.Add
                        (
                            Util.UserInfo.CorporationCode
                            , this.cbo01_BIZCD.Value
                            , ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM")
                            , RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") ? this.cdx01_VENDCD.Value : parameters[i]["CUSTCD"] //this.cdx01_VENDCD.Value
                            , parameters[i]["PARTNO"]
                            , RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") ? parameters[i]["CUSTCD"] : this.cdx01_CUSTCD.Value //parameters[i]["CUSTCD"]
                            , RadioGroup2.CheckedItems[0].InputValue.ToString()
                            , this.cbo01_PURC_ORG.Value
                            , this.UserInfo.UserID
                        );        
                    }
                    else
                    {   
                        saveParam.Tables[0].Rows.Add
                        (
                            Util.UserInfo.CorporationCode
                            , this.cbo01_BIZCD.Value
                            , ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM")
                            , RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") ? this.cdx01_VENDCD.Value : parameters[i]["CUSTCD"]
                            , parameters[i]["PARTNO"]
                            , RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") ? parameters[i]["CUSTCD"] : this.cdx01_CUSTCD.Value
                            , RadioGroup2.CheckedItems[0].InputValue.ToString()
                            , this.cbo01_PURC_ORG.Value
                            , parameters[i]["UNIT"]
                            , parameters[i]["RESALE_QTY"] == "" ? "0" : parameters[i]["RESALE_QTY"]
                            , RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") && parameters[i]["VEND_OK"].ToString() == "true" ? this.txt01_MGRNM.Value : parameters[i]["VEND_NAME"]
                            , parameters[i]["VEND_OK"].ToString() == "Y" || parameters[i]["VEND_OK"].ToString() == "1" || parameters[i]["VEND_OK"].ToString() == "true" ? "Y" : "N"
                            , RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("2") && parameters[i]["CUST_OK"].ToString() == "true" ? this.txt01_MGRNM.Value : parameters[i]["CUST_NAME"]
                            , parameters[i]["CUST_OK"].ToString() == "Y" || parameters[i]["CUST_OK"].ToString() == "1" || parameters[i]["CUST_OK"].ToString() == "true" ? "Y" : "N"                            
                            , this.UserInfo.UserID
                            , RadioGroup1.CheckedItems[0].InputValue.ToString()
                        );

                        int rowcnt = saveParam.Tables[0].Rows.Count;
                        //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                        //if (!IsSaveValid(saveParam.Tables[0].Rows[i], parameters[i]["PURC_CLS_DATE"], Convert.ToInt32(parameters[i]["NO"])))
                        if (!IsSaveValid(saveParam.Tables[0].Rows[rowcnt - 1], RadioGroup2.CheckedItems[0].InputValue.ToString(), parameters[i]["PURC_CLS_DATE"], Nvl(parameters[i]["UNIT"], "").ToString(), Convert.ToInt32(parameters[i]["NO"])))
                        {
                            return;
                        }

                        //수요처에서 정상이고 확인정보가 있다면 거래명세서 출력
                        if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("2") && RadioGroup2.CheckedItems[0].InputValue.ToString().Equals("1") && (parameters[i]["CUST_OK"].ToString() == "Y" || parameters[i]["CUST_OK"].ToString() == "1" || parameters[i]["CUST_OK"].ToString() == "true"))
                            report = true;
                        //else if (RadioGroup2.CheckedItems[0].InputValue.ToString().Equals("2") && (parameters[i]["VEND_OK"].ToString() == "Y" || parameters[i]["VEND_OK"].ToString() == "1" || parameters[i]["VEND_OK"].ToString() == "true"))
                        //    report = true;
                    }
                }

                string[] procedure = new string[] { string.Format("{0}.{1}", pakageName, "REMOVE"),
                                                    string.Format("{0}.{1}", pakageName, "SAVE")};
                DataSet[] param = new DataSet[] {removeParam, saveParam};

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.MultipleExecuteNonQueryTx(procedure, param);
                    this.MsgCodeAlert("COM-00902");
                    Search();

                    //정상이고 수요처 확인이 있다면 거래명세서 출력
                    if (report)
                    {
                        //거래명세서를 출력하시겠습니까?
                        string[] msg = Library.getMessageWithTitle("SRMMM-0053");

                        Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
                        {
                            Yes = new MessageBoxButtonConfig
                            {
                                Handler = "App.direct.AutoPrint('Y')",
                                Text = "YES"
                            },
                            No = new MessageBoxButtonConfig
                            {
                                Handler = "App.direct.AutoPrint('N')",
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
        
        public object Nvl(object value, object replace)
        {
            object result = value;

            if (value == null)
            {
                result = replace;
            }
            else if (value == DBNull.Value)
            {
                result = replace;
            }

            return result;
        }

        [DirectMethod]
        public void AutoPrint(string printYN)
        {
            if (printYN.Equals("Y"))
            {
                Print();
            }           
        }

        /// <summary>
        /// Print
        /// </summary>
        private void Print()
        {
            try
            {
                //유효성 검사
                if (!IsQueryValidation())
                {
                    return;
                }

                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM26006";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

                /* 
                 * 신규 리포트 또는 리포트 컬럼 변동시 디자인용 컬럼정의 XML 파일은 리포트 호출시 
                 * 하기 코드를 이용하여 직접 생성하여 사용하세요 ( 주의. reb 파일을 먼저 report 하위에 생성후 아래 xml 파일을 생성하세요 )
                 * 넘기고자 하는 DataSet 개체의 이름이 ds 라면
                 * ds.Tables[0].TableName = "DATA";
                 * ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
                 * 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                 * */

                string strVENDCUST = string.Empty;
                string strMSG = string.Empty;
                string strMM = string.Empty;
                string strTitleMSG = string.Empty;

                if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1"))
                {
                    strVENDCUST = this.cdx01_VENDCD.Value + " / " + this.cdx01_VENDCD.Text;
                    strTitleMSG = Library.getLabel(GetMenuID(), "MM_MSG005");//"하기의 거래처로 자재를 공급하였습니다.";
                }
                else
                {
                    strVENDCUST = this.cdx01_CUSTCD.Value + " / " + this.cdx01_CUSTCD.Text;
                    strTitleMSG = Library.getLabel(GetMenuID(), "MM_MSG006");  //"하기의 거래처로 사급자재를 공급받았습니다.";
                }

                if (((DateTime)this.df01_DATE.Value).ToString("MM").IndexOf("0") == 0)
                    strMM = ((DateTime)this.df01_DATE.Value).ToString("MM").Replace("0", "");
                else
                    strMM = ((DateTime)this.df01_DATE.Value).ToString("MM");

                strMSG = ((DateTime)this.df01_DATE.Value).ToString("yyyy") + Library.getLabel(GetMenuID(), "YEAR") + " " + strMM + Library.getLabel(GetMenuID(), "MONTH") + " " + strVENDCUST;

                // Main Section ( 메인리포트 파라메터셋 )
                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                mainSection.ReportParameter.Add("MSG01", strMSG);
                mainSection.ReportParameter.Add("MSG_TITLE", strTitleMSG);

                report.Sections.Add("MAIN", mainSection);

                // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                DataSet ds = getReportDataSet();

                // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                //ds.Tables[0].TableName = "DATA";
                //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);

                HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
                // xmlSection.ReportParameter.Add("CORCD", "1000");
                report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정

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
        /// Excel_Import(엑셀 업로드 버튼 클릭시)
        /// </summary>
        private void Excel_Import()
        {
            try
            {
                LastDaysDisplay();

                //공통코드에 등록된 일자 기준(워크데이트만 포함)으로 마감 일 조정 2016.4.4 이현범
                //서연이화 사용자는 편집 불가 기능에 상관없이 수정 가능하도록 변경 2016.9.5 이현범
                if (_dtWorkDate < DateTime.Now && !this.UserInfo.UserDivision.Equals("T12"))
                {
                    this.MsgCodeAlert("SCMMM-0022");
                    return;
                }

                DataSet result = getDataSet();

                if (result.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert("COM-00912");
                    return;
                }

                if (!fud02_FILEID1.HasFile) return;
                if (!IsSearchValid()) return;

                //파일을 서버에 임시 저장
                string fname = System.Guid.NewGuid().ToString().Replace("-", string.Empty);

                //크롭 브라우저는 fud02_FILEID1.FileName시 파일명만 리턴.
                //IE는 fud02_FILEID1.FileName 시 경로포함한 파일명 리턴함.
                //그래서, System.IO.Path.GetFileName()를 이용하여 파일명만 가져온다.
                string fileName = EPAppSection.ToString("SERVER_TEMP_PATH") + fname + "_" + System.IO.Path.GetFileName(fud02_FILEID1.FileName);

                fud02_FILEID1.PostedFile.SaveAs(fileName);

                //저장된 파일로부터 데이터 읽어와서 DataTable생성(엑셀파일의 첫번째 줄의 헤더명이 컬럼명으로 지정되어 있음)
                DataTable dtUpload = ExcelHelper.XlsToDataTable(fileName, "", "YES", "1");

                //최초 만들어진 dtUpload의 컬럼명은 한글이므로 db에 맞는 컬럼명으로 변경해주기 위해
                //Grid02그리드로부터 DataIndex값 읽어와서 새로운 테이블 만들고 
                //엑셀로부터 읽어온 내용을 그대로 import함.
                //공급처, 수요처 확인 완료된 데이터는 양식 업로드 시 제외 됨.
                DataTable dtTemp = new DataTable();
                for (int i = 0; i < Grid02.ColumnModel.Columns.Count; i++)
                {
                    dtTemp.Columns.Add(Grid02.ColumnModel.Columns[i].DataIndex);
                }                

                for (int i = 0; i < dtUpload.Rows.Count; i++)
                {
                    DataRow dr1 = dtUpload.Rows[i];

                    for(int j = 0; j < result.Tables[0].Rows.Count; j++)
                    {
                        DataRow dr2 = result.Tables[0].Rows[j];

                        if ((dr2["VEND_OK"].ToString().Equals("0") && dr2["CUST_OK"].ToString().Equals("0"))
                            || (dr2["VEND_OK"].ToString().Equals("N") && dr2["CUST_OK"].ToString().Equals("N"))
                            || (dr2["VEND_OK"].ToString().Equals("") && dr2["CUST_OK"].ToString().Equals("")))
                        {
                            if (Util.UserInfo.CorporationCode.ToString().Trim() == dr2["CORCD"].ToString().Trim() &&
                                this.cbo01_BIZCD.Value.ToString().Trim() == dr2["BIZCD"].ToString().Trim() &&
                                dr1[4].ToString().Trim() == dr2["PARTNO"].ToString().Trim() &&
                                dr1[0].ToString().Trim() == dr2["CUSTCD"].ToString().Trim() &&
                                ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM").Trim() == dr2["STD_YYMM"].ToString().Trim())
                            {
                                DataRow dr = dtUpload.Rows[i];
                                DataRow drNew = dtTemp.NewRow();
                                if (!dr[0].ToString().Equals(string.Empty))
                                {
                                    for (int c = 0; c < dtUpload.Columns.Count; c++)
                                    {
                                        drNew[c] = dr[c];
                                    }
                                    dtTemp.Rows.Add(drNew);
                                }
                                break;
                            }
                        }
                    }
                }

                //대상건수/수행건수 표시
                this.txt01_ROWCNT_EXCEL.Text = dtTemp.Rows.Count.ToString();
                this.txt01_ROWCNT_ADDED.Text = "0";
                                
                DataSet removeParam = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "STD_YYMM", "VENDCD", "PARTNO", "CUSTCD", "IO_DIV", "PURC_ORG", "USER_ID"
                );

                DataSet saveParam = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "STD_YYMM", "VENDCD", "PARTNO", "CUSTCD", "IO_DIV", "PURC_ORG", "UNIT", "RESALE_QTY",
                   "VEND_NAME", "VEND_OK", "CUST_NAME", "CUST_OK", "USER_ID", "TYPE"
                );

                for (int i = 0; i < dtTemp.Rows.Count; i++)
                {
                    if (dtTemp.Rows[i]["RESALE_QTY"] == DBNull.Value || Convert.ToDecimal(dtTemp.Rows[i]["RESALE_QTY"]) == 0) //2018.06.11 소숫점 허용
                    {
                        //removeParam.Tables[0].Rows.Add
                        //(
                        //    Util.UserInfo.CorporationCode
                        //    , this.cbo01_BIZCD.Value
                        //    , ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM")
                        //    , this.cdx01_VENDCD.Value
                        //    , dtTemp.Rows[i]["PARTNO"]
                        //    , dtTemp.Rows[i]["CUSTCD"]
                        //    , this.UserInfo.LanguageShort
                        //    , this.UserInfo.UserID
                        //);        
                        continue;
                    }
                    else
                    {                        
                        saveParam.Tables[0].Rows.Add
                        (
                            Util.UserInfo.CorporationCode
                            , this.cbo01_BIZCD.Value
                            , ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM")
                            , RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") ? this.cdx01_VENDCD.Value : dtTemp.Rows[i]["CUSTCD"]
                            , dtTemp.Rows[i]["PARTNO"]
                            , RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") ? dtTemp.Rows[i]["CUSTCD"] : this.cdx01_CUSTCD.Value
                            , RadioGroup2.CheckedItems[0].InputValue.ToString()
                            , this.cbo01_PURC_ORG.Value
                            , dtTemp.Rows[i]["UNIT"]
                            , (dtTemp.Rows[i]["RESALE_QTY"] == DBNull.Value || string.IsNullOrEmpty(dtTemp.Rows[i]["RESALE_QTY"].ToString())) ? "0" : dtTemp.Rows[i]["RESALE_QTY"]
                            //, qty
                            , RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") ? this.txt01_MGRNM.Value : ""
                            , RadioGroup2.CheckedItems[0].InputValue.ToString().Equals("1") ? "Y" : ""
                            , RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("2") ? this.txt01_MGRNM.Value : ""
                            , RadioGroup2.CheckedItems[0].InputValue.ToString().Equals("2") ? "Y" : ""
                            , this.UserInfo.UserID
                            , RadioGroup1.CheckedItems[0].InputValue.ToString()
                        );

                        //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                        int rowcnt = saveParam.Tables[0].Rows.Count ;
                        if (!IsSaveValid(saveParam.Tables[0].Rows[rowcnt-1], RadioGroup2.CheckedItems[0].InputValue.ToString(), "", Nvl(dtTemp.Rows[i]["UNIT"], "").ToString(), i + 1))
                        {
                            return;
                        }
                    }                    
                }

                if (saveParam.Tables[0].Rows.Count > 0)
                {
                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), saveParam);
                        this.MsgCodeAlert("COM-00902");
                        Search();
                    }
                    this.txt01_ROWCNT_ADDED.Text = saveParam.Tables[0].Rows.Count.ToString();
                }

                //작업완료한 후 임시 파일 삭제.
                if (System.IO.File.Exists(fileName))
                    System.IO.File.Delete(fileName);
            }
            catch (Exception ex)
            {
                this.txt01_ROWCNT_ADDED.Text = "0";
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {

            }
        }

        /// <summary>
        /// 양식다운로드
        /// </summary>
        private void Excel()
        {
            try
            {
                DataSet result = new DataSet();
                result = getDataSet();

                if (result == null) return;

                if (result.Tables[0].Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid02);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {
            }
        }

        private void LastDaysDisplay()
        {
            //마감일 기준 조회
            string[] strClsInfo = getWorkDateChk();

            if (!strClsInfo[0].Equals(string.Empty))
            {
                _dtWorkDate = DateTime.Parse(strClsInfo[0]);

                //마감기한 날짜뿐아니라 시간도 db로부터 가져와서 체크함.
                int hour = Convert.ToInt32(strClsInfo[1].Substring(0, 2));
                int minute = Convert.ToInt32(strClsInfo[1].Substring(3, 2));
                if (hour == 24 && minute == 0)
                {
                    //24:00 은 실질적으로 다음날 00:00 와 동일함. 
                    _dtWorkDate = _dtWorkDate.AddDays(1);
                }
                else
                {
                    _dtWorkDate = _dtWorkDate.AddHours(hour);
                    _dtWorkDate = _dtWorkDate.AddMinutes(minute);
                }
                
                DateTime dtDisPlayDate = DateTime.Parse(strClsInfo[0]);
                
                //string strMsg = dtDisPlayDate.Year.ToString() + Library.getLabel(GetMenuID(), "YEAR") + " " + dtDisPlayDate.Month.ToString() + Library.getLabel(GetMenuID(), "MONTH") + dtDisPlayDate.Day.ToString();
                string strMsg = dtDisPlayDate.Year.ToString() + Library.getLabel(GetMenuID(), "YEAR") + " " + dtDisPlayDate.Month.ToString() + Library.getLabel(GetMenuID(), "MONTH") + dtDisPlayDate.Day.ToString() + Library.getLabel(GetMenuID(), "DAY") + " (" + strClsInfo[1] + ")";
                                
                if (!this.UserInfo.UserDivision.Equals("T12"))
                {
                    this.lbl01_MM_MSG004.Html = Util.CodeMessage02(this.GetMenuID(), "MM_MSG004", "<span style='font-weight:bold'>" + strMsg + "</span>");
                }
                else
                {
                    //this.lbl01_MM_MSG004.Text = Util.CodeMessage02(this.GetMenuID(), "MM_MSG008", strMsg); //☞ {0}일까지 등록 가능합니다. (서연이화 사용자 제외)
                    this.lbl01_MM_MSG004.Html = Util.CodeMessage02(this.GetMenuID(), "MM_MSG009", "<span style='font-weight:bold'>" + strMsg + "</span>");  //MM_MSG009  ☞ {0} 까지 등록 가능합니다. (서연이화 사용자 제외)                    
                }
            }
            else
                this.lbl01_MM_MSG004.Text = Util.CodeMessage02(this.GetMenuID(), "MM_MSG007");
        }

        //일자 검색조건을 바꾸면 자동으로 마감일 기준 조회
        public void changeCondition(object sender, DirectEventArgs e)
        {
            this.LastDaysDisplay();

            this.Store1.RemoveAll();
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
        public bool IsSaveValid(DataRow parameter, string IO_DIV, string PURC_CLS_DATE, string UNIT, int actionRow = -1)
        {
            bool result = false;
            string VEND_OK = parameter["VEND_OK"].ToString();
            string CUST_OK = parameter["CUST_OK"].ToString();
            decimal RESALE_QTY = decimal.Parse(parameter["RESALE_QTY"].ToString());

            if (IO_DIV.Equals("1")) //정상일 경우
            {
                if (this.txt01_MGRNM.IsEmpty &&
                    ((RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") && VEND_OK == "Y")
                    || (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("2") && CUST_OK == "Y")))
                        this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_MGRNM", lbl01_CHR_NM.Text);
                else if (this.txt01_MGRNM.IsEmpty && CUST_OK == "Y")
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_MGRNM", lbl01_CHR_NM.Text);
                else if (!PURC_CLS_DATE.Equals(""))
                    //{0}행의 정보는 마감되어 수정할 수 없습니다.
                    this.MsgCodeAlert_ShowFormat("SCMMM-0003", actionRow);
                else if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") && CUST_OK == "Y")
                    //{0}행의 정보는 수요처에서 확인하여 수정할 수 없습니다.
                    this.MsgCodeAlert_ShowFormat("SCMMM-0004", actionRow);
                else if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("2") && VEND_OK == "N")
                    //{0}행의 정보는 공급처에서 확인하지 않아 수정할 수 없습니다.
                    this.MsgCodeAlert_ShowFormat("SCMMM-0005", actionRow);
                else if (UNIT.Equals(""))
                    //{0}번째 행의 {1}를(을) 입력해주세요.
                    this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "UNIT"));
                else if(RESALE_QTY < 0)
                    this.MsgCodeAlert("SCMMM-0024");
                else
                    result = true;
            }
            else //반품일 경우
            {
                if (this.txt01_MGRNM.IsEmpty &&
                    ((RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") && VEND_OK == "Y")
                    || (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("2") && CUST_OK == "Y")))
                        this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_MGRNM", lbl01_CHR_NM.Text);
                else if (this.txt01_MGRNM.IsEmpty && CUST_OK == "Y")
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_MGRNM", lbl01_CHR_NM.Text);
                else if (!PURC_CLS_DATE.Equals(""))
                    //{0}행의 정보는 마감되어 수정할 수 없습니다.
                    this.MsgCodeAlert_ShowFormat("SCMMM-0003", actionRow);
                else if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1") && CUST_OK == "N")
                    //{0}행의 정보는 수요처에서 확인하지 않아 수정할 수 없습니다.
                    this.MsgCodeAlert_ShowFormat("SCMMM-0049", actionRow);
                else if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("2") && VEND_OK == "Y")
                    //{0}행의 정보는 공급처에서 확인하여 수정할 수 없습니다.
                    this.MsgCodeAlert_ShowFormat("SCMMM-0048", actionRow);
                else if (UNIT.Equals(""))
                    //{0}번째 행의 {1}를(을) 입력해주세요.
                    this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "UNIT"));
                else if (RESALE_QTY < 0)
                    this.MsgCodeAlert("SCMMM-0024");
                else
                    result = true;
            }

            return result;
        }

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {            
            // 조회용 Validation
            if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1"))
            {
                if (this.cdx01_VENDCD.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                    return false;
                }                
            }
            else
            {
                if (this.cdx01_CUSTCD.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_CUSTCD", lbl01_CUST.Text);
                    return false;
                }
            }

            if (this.cbo01_BIZCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_BIZCD", lbl01_SAUP.Text);
                return false;
            }
            
            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
                return false;
            }

            if (this.df01_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_DATE", lbl01_STD_YYMM.Text);
                return false;
            }
            return true;
        }

        /// <summary>
        /// 조회시 필수 입력 체크
        /// </summary>
        /// <returns></returns>
        public bool IsSearchValid()
        {
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.txt01_MGRNM.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_MGRNM", lbl01_CHR_NM.Text);
                return false;
            }
            //if (this.df01_STD_DATE.IsEmpty)
            //{
            //    this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_STD_DATE", lbl01_REG_DATE.Text);
            //    return false;
            //}
            return true;
        }

        #endregion
            
    }
}
