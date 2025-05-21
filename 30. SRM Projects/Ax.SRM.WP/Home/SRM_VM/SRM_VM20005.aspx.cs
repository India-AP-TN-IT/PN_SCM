#region ▶ Description & History
/* 
 * 프로그램명 : 일반구매업체 기본정보등록
 * 설      명 : Home > 협력업체관리 > 업체정보관리 > 기본정보등록
 * 최초작성자 : 이현범
 * 최초작성일 : 2015-10-01
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

namespace Ax.EP.WP.Home.SRM_VM
{
    public partial class SRM_VM20005 : BasePage
    {
        private string pakageName = "APG_SRM_VM20005";
        //private string noimage = "../../images/common/no_image.gif";


        #region [ 초기설정 ]

        /// <summary>
        /// SRM_VM20005
        /// </summary>
        public SRM_VM20005()
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


                    //BASE에서 일괄적으로 위아래버튼 사라지게 처리함. 
                    //이화면에서는 필요하므로 다시 살림
                    this.txt01_STD_YEAR.HideTrigger = false;
                    this.txt01_STD_YEAR.SpinDownEnabled = true;
                    this.txt01_STD_YEAR.SpinUpEnabled = true;


                    this.txt02_STD_YEAR.HideTrigger = false;
                    this.txt02_STD_YEAR.SpinDownEnabled = true;
                    this.txt02_STD_YEAR.SpinUpEnabled = true;

                    this.SetCombo();

                    this.Reset(true);

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
            MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
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
            if (ibtn.ID.Equals(ButtonID.Search))
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "InputPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Loading Data...";
            }
            else if (ibtn.ID.Equals(ButtonID.Save))
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.Page;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "InputPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Checking And Saving Data...";
            }

            else if (ibtn.ID.Equals(ButtonID.Reset))
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.Page;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "InputPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Initializing Controls...";
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
                    Reset(false);
                    Search();
                    break;
                case ButtonID.Reset:
                    Reset(true);
                    break;
                case ButtonID.Save:
                    Save(sender, e);
                    break;
                case ButtonID.Print:
                    //Print();
                    PrintConfirm();
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
                case "btn01_DELETE":
                    //주요설비현황(생산설비) 삭제버튼
                    Remove_ASRM2130(e);
                    break;
                case "btn01_SAVE":
                    //주요설비현황(생산설비) 저장버튼
                    Save_ASRM2130(e);
                    break;
                case "btn02_DELETE":
                    //주요설비현황(실험 및 측정설비) 삭제버튼
                    Remove_ASRM2140(e);
                    break;
                case "btn02_SAVE":
                    //주요설비현황(실험 및 측정설비) 저장버튼
                    Save_ASRM2140(e);
                    break;
                case "btn03_DELETE":
                    //주요공급업체 매입현황 삭제버튼
                    Remove_ASRM2100(e);
                    break;
                case "btn03_SAVE":
                    //주요공급업체 매입현황 저장버튼
                    Save_ASRM2100(e);
                    break;
                case "btn01_PRINT_SUMMARY":
                    //중역보고용 요약 정보 출력
                    Print2();
                    break;
                case "btn06_DELETE":
                    //재무제표 삭제
                    Remove_ASRM2090();
                    break;
                case "btn06_SAVE":
                    //재무제표 저장
                    Save_VM2090();
                    break;
                case "btn01_SQ_CATEGORY":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용                  
                    Util.CodePopup(this, "GRID_SQ_CATEGORY_HELP", this.CodeValue.Text, this.NameValue.Text, "VC", "input");
                    break;
                default:
                    break;
            }
        }

        #region [리포트 출력 관련]

        private void PrintConfirm()
        {
            if (!this.IsQueryValidation()) return;

            X.Msg.Show(new MessageBoxConfig
            {
                Title = "Confirm",
                Message = Library.getMessage("SRMVM-0017"),
                Buttons = MessageBox.Button.YESNO,
                Icon = MessageBox.Icon.QUESTION,
                Fn = new JFunction { Fn = "PrintReport" },
                AnimEl = "ButtonPrint"
            });
        }
        /// <summary>
        /// Print
        /// </summary>
        [DirectMethod]
        public void Print()
        {
            if (!this.IsQueryValidation()) return;

            HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
            report.ReportName = "1000/SRM_VM/SRM_VM20005";

            // Main Section ( 메인리포트 파라메터셋 )
            HERexSection mainSection = new HERexSection();
            mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
            mainSection.ReportParameter.Add("STD_YEAR", this.txt01_STD_YEAR.Value);
            mainSection.ReportParameter.Add("ASRM2100_STD_YEAR", this.txt02_STD_YEAR.Value);

            report.Sections.Add("MAIN", mainSection);

            // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
            DataSet ds = this.getDataSetReport();//C:\10.Seoyoneh\tfs\Ax_SRM\Ax.SRM\30. SRM Projects\Ax.SRM.WP\Home\SRM_VM\SRM_VM20005.aspx

            if (ds.Tables[0].Rows.Count <= 0)
            {
                this.MsgCodeAlert_ShowFormat("COM-00022");
                return;
            }
            DataSet source= this.getFinancialDataSetReport();
            DataSet ds1 = new DataSet();
            DataSet ds2 = new DataSet();
            DataSet ds3 = new DataSet();
            DataSet ds4 = new DataSet();
            DataSet ds5 = new DataSet();
            DataSet ds6 = new DataSet();
            ds1.Tables.Add(source.Tables[0].Copy());
            ds2.Tables.Add(source.Tables[1].Copy());
            ds3.Tables.Add(ds.Tables[1].Copy());
            ds4.Tables.Add(ds.Tables[2].Copy());
            ds5.Tables.Add(ds.Tables[3].Copy());
            ds6.Tables.Add(ds.Tables[4].Copy());

            //// DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
            //// 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
            //ds.Tables[0].TableName = "DATA";
            //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
            //ds1.Tables[0].TableName = "DATA";
            //ds1.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "01.xml", XmlWriteMode.WriteSchema);
            //ds2.Tables[0].TableName = "DATA";
            //ds2.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "02.xml", XmlWriteMode.WriteSchema);
            //ds3.Tables[0].TableName = "DATA";
            //ds3.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "03.xml", XmlWriteMode.WriteSchema);
            //ds4.Tables[0].TableName = "DATA";
            //ds4.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "04.xml", XmlWriteMode.WriteSchema);
            //ds5.Tables[0].TableName = "DATA";
            //ds5.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "05.xml", XmlWriteMode.WriteSchema);
            //ds6.Tables[0].TableName = "DATA";
            //ds6.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "06.xml", XmlWriteMode.WriteSchema);

            HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
            HERexSection xmlSectionSub1 = new HERexSection(ds1, new HEParameterSet());
            HERexSection xmlSectionSub2 = new HERexSection(ds2, new HEParameterSet());
            HERexSection xmlSectionSub3 = new HERexSection(ds3, new HEParameterSet());
            HERexSection xmlSectionSub4 = new HERexSection(ds4, new HEParameterSet());
            HERexSection xmlSectionSub5 = new HERexSection(ds5, new HEParameterSet());
            HERexSection xmlSectionSub6 = new HERexSection(ds6, new HEParameterSet());

            // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
            // xmlSection.ReportParameter.Add("CORCD", "1000");
            report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
            report.Sections.Add("XML1", xmlSectionSub1);
            report.Sections.Add("XML2", xmlSectionSub2);
            report.Sections.Add("XML3", xmlSectionSub3);
            report.Sections.Add("XML4", xmlSectionSub4);
            report.Sections.Add("XML5", xmlSectionSub5);
            report.Sections.Add("XML6", xmlSectionSub6);

            AxReportForm.ShowReport(report);

        }


        /// <summary>
        /// Print2
        /// </summary>
        [DirectMethod]
        public void Print2()
        {
            //if (!this.IsQueryValidation()) return;

            //HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
            //report.ReportName = "1000/SRM_VM/SRM_VM20002";

            //// Main Section ( 메인리포트 파라메터셋 )
            //HERexSection mainSection = new HERexSection();
            //mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
            //mainSection.ReportParameter.Add("MENUID", "SRM_VM20005");

            //report.Sections.Add("MAIN", mainSection);


            //// XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
            //DataSet ds = this.getDataSetReport2();
            //if (ds.Tables[0].Rows.Count <= 0)
            //{
            //    this.MsgCodeAlert_ShowFormat("COM-00022");
            //    return;
            //}

            ////OUT_CURSOR_SRM2090
            //DataSet ds1 = new DataSet();    
            //ds1.Tables.Add(ds.Tables[1].Copy());
            ////OUT_CURSOR_SRM2150
            //DataSet ds2 = new DataSet();    
            //ds2.Tables.Add(ds.Tables[2].Copy());
            ////OUT_CURSOR_SRM2160
            //DataSet ds3 = new DataSet();
            //ds3.Tables.Add(ds.Tables[3].Copy());

            ////// DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
            ////// 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
            ////ds.Tables[0].TableName = "DATA";
            ////ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
            ////ds1.Tables[0].TableName = "DATA";
            ////ds1.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "01.xml", XmlWriteMode.WriteSchema);
            ////ds2.Tables[0].TableName = "DATA";
            ////ds2.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "02.xml", XmlWriteMode.WriteSchema);
            ////ds3.Tables[0].TableName = "DATA";
            ////ds3.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "03.xml", XmlWriteMode.WriteSchema);

            //HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
            //HERexSection xmlSectionSub1 = new HERexSection(ds1, new HEParameterSet());
            //HERexSection xmlSectionSub2 = new HERexSection(ds2, new HEParameterSet());
            //HERexSection xmlSectionSub3 = new HERexSection(ds3, new HEParameterSet());

            //// 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
            //// xmlSection.ReportParameter.Add("CORCD", "1000");
            //report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
            //report.Sections.Add("XML1", xmlSectionSub1);
            //report.Sections.Add("XML2", xmlSectionSub2);
            //report.Sections.Add("XML3", xmlSectionSub3);
            //AxReportForm.ShowReport(report);

        }

        #endregion

        #endregion

        #region [ 코드박스 이벤트 핸들러 ]
        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_VENDCD_AfterValidation(object sender, DirectEventArgs e)
        {
            //업체코드입력시 자동 조회
            //업체코드 미입력상태이거나 잘못된 코드 입력된 경우에는 초기화만.
            this.Reset(false);
            if (!this.cdx01_VENDCD.IsEmpty && this.cdx01_VENDCD.isValid)
                this.Search();
        }


        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_UP_VEND_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            //UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();

            cdx.UserParamSet.Add("OPTION", "1");
        }

        #endregion

        #region [ 기능 ]

        #region [ 초기화 관련 ]
        /// <summary>
        /// 콤보상자 바인딩(유형코드 등등)
        /// </summary>
        private void SetCombo()
        {
            //유형코드
            DataSet source = Library.GetTypeCode("VB");

            //업체차수 콤보바인딩
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='1'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_VEND_TIER, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select"); //업체차수 

            //단위
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='7'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_UNIT, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");

            //상장여부
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='8'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_STOCK_YN, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");

            //회사규모
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='9'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_SCALE, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");
        }
        /// <summary>
        /// Reset
        /// </summary>
        public void Reset(bool isAllReset)
        {
            if (isAllReset)
            {
                //업체코드는 서연이화 사용자인 경우에만 초기화한다.
                if (this.UserInfo.UserDivision.Equals("T12"))
                    this.cdx01_VENDCD.SetValue(string.Empty);
            }

            this.ClearInput(this.Controls);

            //주요설비현황(생산설비) 그리드 초기화
            this.Store_Grid01.RemoveAll();

            //주요설비현황(실험및측정설비) 그리드 초기화
            this.Store_Grid02.RemoveAll();

            //주요공급업체매입현황 그리드 초기화
            this.Store_Grid03.RemoveAll();

            if(this.Pur_Hid.Text.Length == 0)
                this.Pur_Hid.Text = this.lbl01_TIT_PUR2.Text;

            this.lbl01_TIT_PUR2.Text = this.Pur_Hid.Text + "(" + string.Format(Library.getLabel("SRM_VM20005", "YEAR_PURCAMT"), this.txt02_STD_YEAR.Value.ToString()).ToString().Substring(0, 4) + ")";
        }



        /// <summary>
        /// SetPartnerControlAuthority
        /// </summary>
        /// <param name="controls"></param>
        private void ClearInput(ControlCollection controls)
        {
            foreach (Control ctrl in controls)
            {
                // 텍스트 필드일경우 
                Ext.Net.TextField txtField = ctrl as Ext.Net.TextField;
                if (txtField != null)
                {

                    if (ctrl.ID.Equals("txt01_VEND_NATCD"))
                    {
                        //txtField.SetValue("대한민국");    //국가 "대한민국"으로 세팅
                        txtField.SetValue(Library.getLabel(GetMenuID(), "KOREA"));    //국가 "대한민국"으로 세팅
                        continue;
                    }
                    else
                    {

                        txtField.SetValue(string.Empty);
                        continue;
                    }

                }

                // 코드박스 일경우 
                Ax.EP.UI.IEPCodeBox cdxField = ctrl as Ax.EP.UI.IEPCodeBox;
                if (cdxField != null)
                {
                    if (ctrl.ID.Equals("cdx01_VENDCD"))
                        continue;                                   //업체코드는 초기화하지 않음   
                    else if (ctrl.ID.Equals("cdx01_MONEY_UNIT"))
                    {
                        this.cdx01_MONEY_UNIT.SetValue("I2KRW");    //화폐단위는 기본 "KRW"로 세팅
                        continue;
                    }
                    else
                    {
                        cdxField.SetValue(string.Empty);
                        continue;
                    }
                }

                //콤보상자인 경우
                Ext.Net.ComboBox cboField = ctrl as Ext.Net.ComboBox;
                if (cboField != null)
                {
                    if (ctrl.ID.Equals("cbo01_VEND_TIER"))
                    {
                        cboField.SelectedItem.Value = "VBP1";
                        cboField.ReadOnly = true;
                    }
                    else
                    {
                        cboField.SelectedItem.Value = "";
                    }

                    cboField.UpdateSelectedItems();
                    continue;

                }

                //number필드인 경우
                Ext.Net.NumberField numField = ctrl as Ext.Net.NumberField;
                if (numField != null)
                {
                    if (ctrl.ID.Equals("txt01_STD_YEAR") || ctrl.ID.Equals("txt02_STD_YEAR") || ctrl.ID.Equals("txt03_STD_YEAR"))
                    {
                        numField.SetValue(DateTime.Now.Year - 1);    //기준년도는 기본 전년도로 세팅        
                        //this.txt01_STD_YEAR_Change(null, null);
                        continue;
                    }
                    else
                    {
                        numField.SetValue(null);
                        continue;
                    }


                }

                Ext.Net.DateField dateField = ctrl as Ext.Net.DateField;
                if (dateField != null)
                {
                    dateField.SetValue(null);
                    continue;
                }

                //그외 컨트롤인 경우
                if (ctrl.HasControls())
                {
                    ClearInput(ctrl.Controls);
                }
            }
        }

        #endregion

        #region [SRM2090 재무제표 현황]

        private DataSet Get_ASRM2090()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("STD_YEAR", this.txt01_STD_YEAR.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ASRM2090"), param);

            if (source.Tables[0].Rows.Count > 0)
            {
                DataRow dr = source.Tables[0].Rows[0];

                #region [ 재무재표현황 ]

                this.cdx01_MONEY_UNIT.SetValue(dr["MONEY_UNIT"]);

                this.txt01_DEBT.SetValue(dr["DEBT"] != DBNull.Value ? Convert.ToDecimal(dr["DEBT"]).ToString("#,###") : "0");
                this.txt01_QUITY.SetValue(dr["QUITY"] != DBNull.Value ? Convert.ToDecimal(dr["QUITY"]).ToString("#,###") : "0");
                this.txt01_TOTAL_SALES.SetValue(dr["TOTAL_SALES"] != DBNull.Value ? Convert.ToDecimal(dr["TOTAL_SALES"]).ToString("#,###") : "0");
                this.txt01_ORDINARY_INCOME.SetValue(dr["ORDINARY_INCOME"] != DBNull.Value ? Convert.ToDecimal(dr["ORDINARY_INCOME"]).ToString("#,###") : "0");
                this.txt01_BUSINESS_PROFITS.SetValue(dr["BUSINESS_PROFITS"] != DBNull.Value ? Convert.ToDecimal(dr["BUSINESS_PROFITS"]).ToString("#,###") : "0");

                this.txt01_ASSETS.SetValue(dr["ASSETS"] != DBNull.Value ? Convert.ToDecimal(dr["ASSETS"]).ToString("#,###") : "0");
                this.txt01_PERSON_SALES.SetValue(dr["PERSON_SALES"] != DBNull.Value ? Convert.ToDecimal(dr["PERSON_SALES"]).ToString("#,###") : "0");

                this.txt01_DEBT_RATE.SetValue(dr["DEBT_RATE"] != DBNull.Value ? Convert.ToDecimal(dr["DEBT_RATE"]).ToString("#,###") : "0");
                this.txt01_TURNOVER_RATE.SetValue(dr["TURNOVER_RATE"] != DBNull.Value ? Convert.ToDecimal(dr["TURNOVER_RATE"]).ToString("#,###") : "0");


                this.txt01_HKMC_TRADE_RATE.SetValue(dr["HKMC_TRADE_RATE"]);
                this.txt01_ETC_TRACE_RATE.SetValue(dr["ETC_TRACE_RATE"]);

                #endregion
            }
            else
            {

                this.cdx01_MONEY_UNIT.SetValue("I2KRW");
                this.txt01_ASSETS.SetValue(null);
                this.txt01_PERSON_SALES.SetValue(null);
                this.txt01_DEBT.SetValue(null);
                this.txt01_DEBT_RATE.SetValue(null);
                this.txt01_QUITY.SetValue(null);
                this.txt01_TURNOVER_RATE.SetValue(null);
                this.txt01_TOTAL_SALES.SetValue(null);
                this.txt01_BUSINESS_PROFITS.SetValue(null);
                this.txt01_HKMC_TRADE_RATE.SetValue(null);
                this.txt01_ETC_TRACE_RATE.SetValue(null);
                this.txt01_ORDINARY_INCOME.SetValue(null);
            }
            return source;
        }

        /// <summary>
        /// 재무제표 현황 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_VM2090()
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD",
                                 "STD_YEAR", "MONEY_UNIT", "DEBT", "QUITY",
                                 "ASSETS", "TOTAL_SALES", "BUSINESS_PROFITS",
                                 "ORDINARY_INCOME", "PERSON_SALES", "DEBT_RATE",
                                 "TURNOVER_RATE", "HKMC_TRADE_RATE", "ETC_TRACE_RATE",
                                 "USER_ID");

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode, this.cdx01_VENDCD.Value,
                            this.txt01_STD_YEAR.Value,
                            this.cdx01_MONEY_UNIT.Value,
                            this.txt01_DEBT.Value == null ? null : this.txt01_DEBT.Value.ToString().Replace(",", ""),
                            this.txt01_QUITY.Value == null ? null : this.txt01_QUITY.Value.ToString().Replace(",", ""),
                            this.txt01_ASSETS.Value == null ? null : this.txt01_ASSETS.Value.ToString().Replace(",", ""),
                            this.txt01_TOTAL_SALES.Value == null ? null : this.txt01_TOTAL_SALES.Value.ToString().Replace(",", ""),
                            this.txt01_BUSINESS_PROFITS.Value == null ? null : this.txt01_BUSINESS_PROFITS.Value.ToString().Replace(",", ""),
                            this.txt01_ORDINARY_INCOME.Value == null ? null : this.txt01_ORDINARY_INCOME.Value.ToString().Replace(",", ""),
                            this.txt01_PERSON_SALES.Value == null ? null : this.txt01_PERSON_SALES.Value.ToString().Replace(",", ""),
                            this.txt01_DEBT_RATE.Value == null ? null : this.txt01_DEBT_RATE.Value.ToString().Replace(",", ""),
                            this.txt01_TURNOVER_RATE.Value == null ? null : this.txt01_TURNOVER_RATE.Value.ToString().Replace(",", ""),
                            this.txt01_HKMC_TRADE_RATE.Value,
                            this.txt01_ETC_TRACE_RATE.Value,
                            this.UserInfo.UserID
                        );

                if (!this.txt01_STD_YEAR.IsEmpty)
                {
                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ASRM2090"), param);
                        this.MsgCodeAlert("COM-00902");
                        this.Get_ASRM2090();
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

        /// <summary>
        ///재무제표 삭제
        /// </summary>
        /// <param name="e"></param>
        public void Remove_ASRM2090()
        {
            try
            {

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "VENDCD", "STD_YEAR", "USER_ID"
                );

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode,
                            this.cdx01_VENDCD.Value,
                            this.txt01_STD_YEAR.Value,
                            this.UserInfo.UserID
                        );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_ASRM2090"), param);
                    this.MsgCodeAlert("COM-00903");
                    this.Get_ASRM2090();
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


        ///// <summary>
        ///// 년도별 재무제표정보 조회
        ///// </summary>
        ///// <returns></returns>
        //private DataSet getFinancialDataSet()
        //{
        //    HEParameterSet param = new HEParameterSet();
        //    param.Add("CORCD", this.UserInfo.CorporationCode);
        //    param.Add("BIZCD", this.UserInfo.BusinessCode);
        //    param.Add("VENDCD", this.cdx01_VENDCD.Value);
        //    param.Add("STD_YEAR", this.txt01_STD_YEAR.Value);
        //    param.Add("LANG_SET", this.UserInfo.LanguageShort);
        //    param.Add("USER_ID", this.UserInfo.UserID);
        //    return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_FINANCIAL"), param, new string[] { "OUT_CURSOR", "OUT_CURSOR_PURCHASE" });
        //}

        #endregion

        #region [ASRM2100 : 주요공급업체 매입현황]

        private void Get_ASRM2100()
        {
            this.YEAR_PURCAMT.Text = string.Format(Library.getLabel("SRM_VM20005", "YEAR_PURCAMT"), this.txt02_STD_YEAR.Value.ToString());

            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("STD_YEAR", this.txt02_STD_YEAR.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ASRM2100"), param);


            this.Store_Grid03.RemoveAll();
            this.Store_Grid03.DataSource = source.Tables[0];
            this.Store_Grid03.DataBind();

            for (int i = source.Tables[0].Rows.Count; i < 4; i++)
            {
                Store_Grid03.Add(i);
            }

        }

        /// <summary>
        /// 주요공급업체 매입현황 저장
        /// </summary>
        /// <param name="e"></param>
        public void Save_ASRM2100(DirectEventArgs e)
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
                    "CORCD", "VENDCD", "STD_YEAR", "SEQNO", "VENDNM1", "ITEMNM1", "PURCHASE1", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, this.cdx01_VENDCD.Value, this.txt02_STD_YEAR.Value,
                         parameter[i]["SEQNO"], parameter[i]["VENDNM1"], parameter[i]["ITEMNM1"], parameter[i]["PURCHASE1"],
                         Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ASRM2100_2"), param);
                    this.MsgCodeAlert("COM-00902");
                    this.Get_ASRM2100();
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
        /// 주요공급업체 매입현황 삭제
        /// </summary>
        /// <param name="e"></param>
        public void Remove_ASRM2100(DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00023");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "VENDCD", "STD_YEAR", "SEQNO", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, this.cdx01_VENDCD.Value, this.txt02_STD_YEAR.Value,
                         parameter[i]["SEQNO"], Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "DELETE_ASRM2100_2"), param);
                    this.MsgCodeAlert("COM-00903");
                    this.Get_ASRM2100();
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

        #region [ASRM2130 : 주요설비현황(생산설비)]

        private DataSet Get_ASRM2130()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            DataSet sourceFacil = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ASRM2130"), param);
            for (int i = sourceFacil.Tables[0].Rows.Count + 1; i < 4; i++)
            {
                sourceFacil.Tables[0].Rows.Add(i, "", "", "", "", "", null);
            }
            this.Store_Grid01.RemoveAll();
            this.Store_Grid01.DataSource = sourceFacil.Tables[0];
            this.Store_Grid01.DataBind();

            //for (int i = sourceFacil.Tables[0].Rows.Count; i < 4; i++)
            //{
            //    Store_Grid01.Add(i);
            //}

            return sourceFacil;
        }

        /// <summary>
        /// 주요설비현황(생산설비) 저장
        /// </summary>
        /// <param name="e"></param>
        public void Save_ASRM2130(DirectEventArgs e)
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
                    "CORCD", "VENDCD", "FACILNM1", "MAKER1", "REMARK1", "SEQNO", "FACILCNT", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, this.cdx01_VENDCD.Value,
                         parameter[i]["FACILNM1"], parameter[i]["FACIL_MAKER1"], parameter[i]["FACIL_REMARK1"], parameter[i]["SEQNO"], parameter[i]["FACILCNT"],
                         Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ASRM2130_2"), param);
                    this.MsgCodeAlert("COM-00902");
                    this.Get_ASRM2130();
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
        /// 주요설비현황(생산설비) 삭제
        /// </summary>
        /// <param name="e"></param>
        public void Remove_ASRM2130(DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00023");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "VENDCD", "SEQNO", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, this.cdx01_VENDCD.Value,
                         parameter[i]["SEQNO"], Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "DELETE_ASRM2130_2"), param);
                    this.MsgCodeAlert("COM-00903");
                    this.Get_ASRM2130();
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

        #region [ASRM2140 : 주요설비현황(실험 및 측정설비)]

        private DataSet Get_ASRM2140()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            DataSet sourceEquip = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ASRM2140"), param);
            for (int i = sourceEquip.Tables[0].Rows.Count + 1; i < 4; i++)
            {
                sourceEquip.Tables[0].Rows.Add("", "", i, "", "", "", null, null);
            }
            this.Store_Grid02.RemoveAll();
            this.Store_Grid02.DataSource = sourceEquip.Tables[0];
            this.Store_Grid02.DataBind();

            //for (int i = sourceEquip.Tables[0].Rows.Count; i < 4; i++)
            //{
            //    Store_Grid02.Add(i);
            //}

            return sourceEquip;
        }

        /// <summary>
        /// 주요설비현황(실험 및 측정설비) 저장
        /// </summary>
        /// <param name="e"></param>
        public void Save_ASRM2140(DirectEventArgs e)
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
                    "CORCD", "VENDCD", "EQUIPNM1", "MAKER1", "REMARK1", "SEQNO", "EQUIPCNT", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, this.cdx01_VENDCD.Value,
                         parameter[i]["EQUIPNM1"], parameter[i]["EQUIP_MAKER1"], parameter[i]["EQUIP_REMARK1"], parameter[i]["SEQNO"], parameter[i]["EQUIPCNT"],
                         Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ASRM2140_2"), param);
                    this.MsgCodeAlert("COM-00902");
                    this.Get_ASRM2140();
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
        /// 주요설비현황(실험 및 측정설비) 삭제
        /// </summary>
        /// <param name="e"></param>
        public void Remove_ASRM2140(DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00023");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "VENDCD", "SEQNO", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, this.cdx01_VENDCD.Value,
                         parameter[i]["SEQNO"], Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "DELETE_ASRM2140_2"), param);
                    this.MsgCodeAlert("COM-00903");
                    this.Get_ASRM2140();
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

        #region [조회]
        /// <summary>
        /// 조회
        /// </summary>
        public void Search()
        {
            try
            {
                if (!IsQueryValidation())
                {
                    return;
                }

                DataSet source = this.getDataSet();

                if (source.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = source.Tables[0].Rows[0];

                    #region [ 기본 정보 ]
                    this.cbo01_VEND_TIER.SetValue(dr["VEND_TIER"]);
                    //this.txt01_UP_VEND.SetValue(dr["UP_VEND"]);

                    this.txt01_VEND_NATCD.SetValue(dr["VEND_NATCD"]);
                    this.txt01_CITY.SetValue(dr["CITY"]);
                    this.txt01_VENDNM.SetValue(dr["VENDNM"]);
                    this.txt01_RESI_NO.SetValue(dr["RESI_NO"]);
                    this.txt01_EMAIL.SetValue(dr["EMAIL"]);
                    this.txt01_TEL.SetValue(dr["TEL"]);
                    this.txt01_FAX.SetValue(dr["FAX"]);
                    this.txt01_ADDR.SetValue(dr["ADDR"]);

                    #endregion

                    #region [ 대표자 정보 ]
                    this.txt01_REP_NAME.SetValue(dr["REP_NAME"]);
                    this.df01_BIRTH_DATE.SetValue(dr["BIRTH_DATE"]);
                    this.txt01_FAMILY_ADDR.SetValue(dr["FAMILY_ADDR"]);
                    #endregion

                    #region [ 임직원 정보 ]
                    this.txt01_EXECUTIVE.SetValue(dr["EXECUTIVE"]);
                    this.txt01_MANAGER.SetValue(dr["MANAGER"]);
                    this.txt01_PROD_LOCAL.SetValue(dr["PROD_LOCAL"]);
                    this.txt01_PROD_FOREIGN.SetValue(dr["PROD_FOREIGN"]);
                    this.txt01_SUBCONTRACT.SetValue(dr["SUBCONTRACT"]);
                    this.txt01_PROD_TOTAL.SetValue(dr["PROD_TOTAL"]);
                    this.txt01_ALL_CNT.SetValue(dr["ALL_CNT"]);
                    #endregion

                    #region [ 주주현황 ]
                    this.txt01_SHAREHOLDER_EN1.SetValue(dr["SHAREHOLDER_EN1"]);
                    this.txt01_SHAREHOLDER1.SetValue(dr["SHAREHOLDER1"]);
                    this.txt01_SHARE_RATE1.SetValue(dr["SHARE_RATE1"]);
                    this.txt01_SHAREHOLDER_EN2.SetValue(dr["SHAREHOLDER_EN2"]);
                    this.txt01_SHAREHOLDER2.SetValue(dr["SHAREHOLDER2"]);
                    this.txt01_SHARE_RATE2.SetValue(dr["SHARE_RATE2"]);
                    this.txt01_SHAREHOLDER_EN3.SetValue(dr["SHAREHOLDER_EN3"]);
                    this.txt01_SHAREHOLDER3.SetValue(dr["SHAREHOLDER3"]);
                    this.txt01_SHARE_RATE3.SetValue(dr["SHARE_RATE3"]);
                    this.txt01_SHAREHOLDER_EN4.SetValue(dr["SHAREHOLDER_EN4"]);
                    this.txt01_SHAREHOLDER4.SetValue(dr["SHAREHOLDER4"]);
                    this.txt01_SHARE_RATE4.SetValue(dr["SHARE_RATE4"]);
                    #endregion

                    #region [ 연혁 ]
                    this.df01_FOUND_DATE.SetValue(dr["FOUND_DATE"]);
                    this.txt01_FOUNDER.SetValue(dr["FOUNDER"]);
                    this.txt01_CURR_HEAD.SetValue(dr["CURR_HEAD"]);
                    this.txt01_RELATION.SetValue(dr["RELATION"]);
                    #endregion

                    #region [ 기타 ]
                    this.txt01_AREA.SetValue(dr["AREA"] != DBNull.Value ? Convert.ToDecimal(dr["AREA"]).ToString("#,###") : "0");
                    this.txt01_BUILDING.SetValue(dr["BUILDING"] != DBNull.Value ? Convert.ToDecimal(dr["BUILDING"]).ToString("#,###") : "0");
                    this.cbo01_UNIT.SetValue(dr["UNIT"]);
                    this.cbo01_SCALE.SetValue(dr["SCALE"]);
                    this.cbo01_STOCK_YN.SetValue(dr["STOCK_YN"]);
                    this.txt01_CAPACITY_RATE.SetValue(dr["CAPACITY_RATE"]);

                    #endregion

                    #region [최근 년도 처리]

                    this.txt01_STD_YEAR.SetValue(dr["ASRM2090_STD_YEAR"]);
                    this.txt02_STD_YEAR.SetValue(dr["ASRM2100_STD_YEAR"]);

                    #endregion

                }
                else
                {
                    this.ClearInput(this.Controls);
                }

                #region [ 주요설비현황(생산설비) ]

                this.Get_ASRM2130();

                #endregion

                #region [ 주요설비현황(실험 및 측정설비) ]
                this.Get_ASRM2140();
                #endregion

                #region [ 재무제표현황, 주요 공급업체 매입현황(매입액 높은 순으로 : 사급제외)]
                //txt01_STD_YEAR_Change(null, null);
                this.Get_ASRM2090();
                this.Get_ASRM2100();
                #endregion

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
        /// 협력업체 정보 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }




        #endregion

        #region [출력]
        ///// <summary>
        ///// 협력업체 정보 조회
        ///// </summary>
        ///// <returns></returns>
        private DataSet getDataSetReport()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT"), param, new string[] { "OUT_CURSOR", "OUT_CURSOR_ASRM2130", "OUT_CURSOR_ASRM2140", "OUT_CURSOR_ASRM2150", "OUT_CURSOR_ASRM2160" });
        }

        ///// <summary>
        ///// 년도별 재무제표정보 조회
        ///// </summary>
        ///// <returns></returns>
        private DataSet getFinancialDataSetReport()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("STD_YEAR", this.txt01_STD_YEAR.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("ASRM2100_STD_YEAR", this.txt02_STD_YEAR.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_FINANCIAL_REPORT"), param, new string[] { "OUT_CURSOR", "OUT_CURSOR_PURCHASE" });
        }


        ///// <summary>
        ///// 중역보고용 협력업체 정보 조회
        ///// </summary>
        ///// <returns></returns>
        //private DataSet getDataSetReport2()
        //{
        //    HEParameterSet param = new HEParameterSet();
        //    param.Add("CORCD", this.UserInfo.CorporationCode);
        //    param.Add("BIZCD", this.UserInfo.BusinessCode);
        //    param.Add("VENDCD", this.cdx01_VENDCD.Value);
        //    param.Add("LANG_SET", this.UserInfo.LanguageShort);
        //    param.Add("USER_ID", this.UserInfo.UserID);
        //    param.Add("SRM2090_STD_YEAR", this.txt01_STD_YEAR.Value);
        //    param.Add("SRM2160_STD_YEAR", this.txt03_STD_YEAR.Value);

        //    return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT2"), param, new string[] { "OUT_CURSOR", "OUT_CURSOR_SRM2090", "OUT_CURSOR_SRM2150", "OUT_CURSOR_SRM2160" });
        //}
        #endregion

        #region [ 저장 ]
        /// <summary>
        /// SaveAndDelete
        /// 저장(업데이트)
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {

                //유효성 검사
                if (!IsSaveValid())
                {
                    return;
                }

                ArrayList arrDataSet = new ArrayList();
                ArrayList arrProcedure = new ArrayList();

                //저장
                this.Save_ASRM2010(arrDataSet, arrProcedure); //일반정보
                this.Save_ASRM2020(arrDataSet, arrProcedure); //대표자정보
                this.Save_ASRM2030(arrDataSet, arrProcedure); //임직원 및 노조정보
                //this.Save_VM2090(arrDataSet, arrProcedure); //재무제표
                this.Save_ASRM2060(arrDataSet, arrProcedure); //주주현황
                //this.Save_VM2100(arrDataSet, arrProcedure); //매입현황
                this.Save_ASRM2120(arrDataSet, arrProcedure); //기타정보
                //this.Save_VM2130(arrDataSet, arrProcedure); //주요 설비 정보(생산설비)

                //한 transation에 넣기 위해 변수에 담는다.
                string[] procedure = new string[arrProcedure.Count];
                DataSet[] param = new DataSet[arrDataSet.Count];
                for (int i = 0; i < arrDataSet.Count; i++)
                {
                    procedure[i] = (string)arrProcedure[i];
                    param[i] = (DataSet)arrDataSet[i];
                }


                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.MultipleExecuteNonQueryTx(procedure, param);
                    this.MsgCodeAlert("COM-00902");//정상적으로 저장되었습니다.
                    this.Reset(false);
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
        /// 일반정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2010(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD", "VEND_TIER",
                                 "VEND_NATCD", "CITY",
                                 "VENDNM", "RESI_NO", "EMAIL", "TEL", "FAX", "ADDR",
                                 "FOUND_DATE", "FOUNDER", "CURR_HEAD", "RELATION", "USER_ID"
                                 );

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode,
                            this.cdx01_VENDCD.Value,
                            this.cbo01_VEND_TIER.Value,
                    //this.txt01_UP_VEND.Value,
                            this.txt01_VEND_NATCD.Value,
                            this.txt01_CITY.Value,
                            this.txt01_VENDNM.Value,
                            this.txt01_RESI_NO.Value,
                            this.txt01_EMAIL.Value,
                            this.txt01_TEL.Value,
                            this.txt01_FAX.Value,
                            this.txt01_ADDR.Value,
                            this.getDateString(this.df01_FOUND_DATE),
                            this.txt01_FOUNDER.Value,
                            this.txt01_CURR_HEAD.Value,
                            this.txt01_RELATION.Value,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20005.SAVE_ASRM2010");
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
        /// 대표자정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2020(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD", "REP_NAME",
                                 "BIRTH_DATE", "FAMILY_ADDR", "USER_ID"
                                 );

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode,
                            this.cdx01_VENDCD.Value,
                            this.txt01_REP_NAME.Value,
                            this.getDateString(this.df01_BIRTH_DATE),
                            this.txt01_FAMILY_ADDR.Value,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20005.SAVE_ASRM2020");
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
        /// 임직원 정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2030(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD", "EXECUTIVE", "MANAGER",
                                 "PROD_LOCAL", "PROD_FOREIGN", "SUBCONTRACT",
                                 "USER_ID"
                                 );

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode,
                            this.cdx01_VENDCD.Value,
                            this.txt01_EXECUTIVE.Value,
                            this.txt01_MANAGER.Value,
                            this.txt01_PROD_LOCAL.Value,
                            this.txt01_PROD_FOREIGN.Value,
                            this.txt01_SUBCONTRACT.Value,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20005.SAVE_ASRM2030");
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
        /// 주주현황 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2060(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD",
                                 "SHAREHOLDER_EN1", "SHAREHOLDER1", "SHARE_RATE1",
                                 "SHAREHOLDER_EN2", "SHAREHOLDER2", "SHARE_RATE2",
                                 "SHAREHOLDER_EN3", "SHAREHOLDER3", "SHARE_RATE3",
                                 "SHAREHOLDER_EN4", "SHAREHOLDER4", "SHARE_RATE4",
                                 "USER_ID");

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode, this.cdx01_VENDCD.Value,
                            this.txt01_SHAREHOLDER_EN1.Value, this.txt01_SHAREHOLDER1.Value, this.txt01_SHARE_RATE1.Value,
                            this.txt01_SHAREHOLDER_EN2.Value, this.txt01_SHAREHOLDER2.Value, this.txt01_SHARE_RATE2.Value,
                            this.txt01_SHAREHOLDER_EN3.Value, this.txt01_SHAREHOLDER3.Value, this.txt01_SHARE_RATE3.Value,
                            this.txt01_SHAREHOLDER_EN4.Value, this.txt01_SHAREHOLDER4.Value, this.txt01_SHARE_RATE4.Value,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20005.SAVE_ASRM2060");
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
        /// 기타 정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2120(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD",
                                 "AREA", "BUILDING", "UNIT",
                                 "SCALE", "STOCK_YN", "CAPACITY_RATE",
                                 "USER_ID");

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode, this.cdx01_VENDCD.Value,
                            this.txt01_AREA.Value == null ? null : this.txt01_AREA.Value.ToString().Replace(",", ""),
                            this.txt01_BUILDING.Value == null ? null : this.txt01_BUILDING.Value.ToString().Replace(",", ""),
                            this.cbo01_UNIT.Value,
                            this.cbo01_SCALE.Value,
                            this.cbo01_STOCK_YN.Value,
                            this.txt01_CAPACITY_RATE.Value,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20005.SAVE_ASRM2120");
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

        #region [util성]
        private object getDateString(DateField df)
        {
            if (df.Value == null)
            {
                return null;
            }
            else
            {
                if (df.Value.Equals(df.EmptyValue))
                {
                    return null;
                }
                else
                {
                    return ((DateTime)df.Value).ToString("yyyy-MM-dd");
                }
            }
        }
        #endregion

        #endregion

        #region [ 유효성 검사 ]


        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsSaveValid()
        {
            //업체코드 필수입력
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", this.lbl01_VEND.Text); //{0}를(을) 입력해주세요.
                return false;
            }

            //업체명 필수입력
            if (this.txt01_VENDNM.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_VENDNM", this.lbl02_VENDNM_LOC.Text); //{0}를(을) 입력해주세요.
                return false;
            }

            //사업자번호 체크
            if (this.txt01_RESI_NO.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_RESI_NO", this.lbl01_CMPNO.Text); //{0}를(을) 입력해주세요.
                return false;
            }
            if (this.txt01_RESI_NO.Text.Length != 10)
            {
                this.MsgCodeAlert_ShowFormat("SRMVM-0013"); //사업자번호는 10자리 숫자만 입력해주세요.
                return false;
            }

            return true;
        }


        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {

            // 조회용 Validation
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }


            return true;
        }

        #endregion

        #region [ 이벤트 ]


        [DirectMethod]
        public void txt01_STD_YEAR_Change()
        {

            this.Get_ASRM2090();
            //DataSet source = this.Get_SRM2090();


            //this.Store_Grid03.RemoveAll();
            //this.Store_Grid03.DataSource = source.Tables[1];
            //this.Store_Grid03.DataBind();

            //for (int i = source.Tables[1].Rows.Count; i < 4; i++)
            //{
            //    Store_Grid03.Add(i);
            //}

            //this.txt02_STD_YEAR.SetValue(this.txt01_STD_YEAR.Value);

        }

        [DirectMethod]
        public void txt02_STD_YEAR_Change()
        {

            this.YEAR_PURCAMT.Text = string.Format(Library.getLabel("SRM_VM20005", "YEAR_PURCAMT"), this.txt02_STD_YEAR.Value.ToString());
            this.lbl01_TIT_PUR2.Text = this.Pur_Hid.Text + "(" + string.Format(Library.getLabel("SRM_VM20005", "YEAR_PURCAMT"), this.txt02_STD_YEAR.Value.ToString()).ToString().Substring(0, 4) + ")";

            this.Get_ASRM2100();

        }

        #endregion
    }
}
