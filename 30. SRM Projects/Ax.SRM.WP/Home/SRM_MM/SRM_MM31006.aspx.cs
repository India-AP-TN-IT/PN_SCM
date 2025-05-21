#region ▶ Description & History
/* 
 * 프로그램명 : 자재발주정보 조회
 * 설      명 : 자재관리 > 발주관리 > 자재발주정보 조회
 * 최초작성자 : 이재우
 * 최초작성일 : 2017-07-18
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
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using HE.Framework.Core.Report;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM31006 : BasePage
    {
        private string pakageName = "APG_SRM_MM31006";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM31006
        /// </summary>
        public SRM_MM31006()
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
                    // [SRM] Library.ComboDataBind(this.cbo01_LOG_DIV, Library.GetTypeCode("EB").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);

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

                    source = Library.GetTypeCode("1Y").Tables[0];
                    Library.ComboDataBind(this.cbo01_QUERY_COND, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_QUERY_COND.UpdateSelectedItems(); //꼭 해줘야한다.

                    HEParameterSet param = new HEParameterSet();
                    param.Add("LANG_SET", this.UserInfo.LanguageShort);
                    
                    source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_COMBO"), param).Tables[0];
                    Library.ComboDataBind(this.cbo01_DATE, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_DATE.UpdateSelectedItems(); //꼭 해줘야한다.

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
            //MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
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
                case ButtonID.Print:
                    Print();
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
            //업체코드는 서연이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cbo01_QUERY_COND.SelectedItem.Value = "1YX";
            this.cbo01_QUERY_COND.UpdateSelectedItems(); //꼭 해줘야한다.

            this.txt01_FPARTNO.SetValue(string.Empty);
            
            this.cdx01_STR_LOC.SetValue(string.Empty);
            this.cdx01_CUSTCD.SetValue(string.Empty);

            this.cbo01_DATE.SelectedItem.Value = "PO_DATE";
            this.cbo01_DATE.UpdateSelectedItems(); //꼭 해줘야한다.

            changeCondition(null, null);

            this.Store1.RemoveAll();
        }

        [DirectMethod]
        public void cbo01_QUERY_COND_change(object sender, DirectEventArgs e)
        {
            switch (this.cbo01_QUERY_COND.Value.ToString())
            {
                case "":
                case "1YA":
                    //완납
                    this.cbo01_DATE.ReadOnly = false;
                    this.df01_PO_DATE_BEG.ReadOnly = false;
                    this.df01_PO_DATE_TO.ReadOnly = false;

                    this.cbo01_DATE.Hidden = false;
                    this.df01_PO_DATE_BEG.Hidden = false;
                    this.df01_PO_DATE_TO.Hidden = false;
                    this.lbl01_PERIOD.Hidden = false;

                    break;
                case "1YX":
                    //미납
                    this.cbo01_DATE.ReadOnly = true;
                    this.df01_PO_DATE_BEG.ReadOnly = true;
                    this.df01_PO_DATE_TO.ReadOnly = true;

                    this.cbo01_DATE.Hidden = true;
                    this.df01_PO_DATE_BEG.Hidden = true;
                    this.df01_PO_DATE_TO.Hidden = true;
                    this.lbl01_PERIOD.Hidden = true;

                    break;
            }
        }
                
        public void changeCondition(object sender, DirectEventArgs e)
        {
            try
            {
                if (cbo01_PURC_ORG.Value.ToString().Equals("1A1110"))
                {
                    this.cbo01_DATE.SelectedItem.Value = "PO_DATE";
                    this.cbo01_DATE.UpdateSelectedItems(); //꼭 해줘야한다.
                }
                else if (cbo01_PURC_ORG.Value.ToString().Equals("1A1100"))
                {
                    this.cbo01_DATE.SelectedItem.Value = "PO_DELI_DATE";
                    this.cbo01_DATE.UpdateSelectedItems(); //꼭 해줘야한다.
                }
            }
            catch
            {
            }

            changeCondition_Date(null, null);
        }

        public void changeCondition_Date(object sender, DirectEventArgs e)
        {
            try
            {
                if (this.cbo01_DATE.Value.ToString().Equals("PO_DATE") && cbo01_PURC_ORG.Value.ToString().Equals("1A1110"))
                {
                    this.df01_PO_DATE_BEG.SetValue(DateTime.Now.AddDays(-90).ToString("yyyy-MM-dd"));
                }
                else
                {
                    this.df01_PO_DATE_BEG.SetValue(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
                }
            }
            catch
            {
                this.df01_PO_DATE_BEG.SetValue(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
            }

            this.df01_PO_DATE_TO.SetValue(DateTime.Now);
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
            param.Add("DATE_TYPE", this.cbo01_DATE.Value);
            param.Add("PO_DATE_BEG", ((DateTime)this.df01_PO_DATE_BEG.Value).ToString("yyyy-MM-dd"));
            param.Add("PO_DATE_TO", ((DateTime)this.df01_PO_DATE_TO.Value).ToString("yyyy-MM-dd"));
            param.Add("PURC_ORG", cbo01_PURC_ORG.Value);
            param.Add("PURC_PO_TYPE", cbo01_PURC_PO_TYPE.Value);
            param.Add("PARTNO", txt01_FPARTNO.Value);
            param.Add("STR_LOC", cdx01_STR_LOC.Value); //저장위치
            param.Add("CUSTCD", cdx01_CUSTCD.Value);
            param.Add("QUERY_COND", cbo01_QUERY_COND.Value);
            param.Add("PONO", txt01_PONO.Value);
            param.Add("PONO_SEQ", txt01_PONO_SEQ.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// getReportDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getReportDataSet()
        {             
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("DATE_TYPE", this.cbo01_DATE.Value);
            param.Add("PO_DATE_BEG", ((DateTime)this.df01_PO_DATE_BEG.Value).ToString("yyyy-MM-dd"));
            param.Add("PO_DATE_TO", ((DateTime)this.df01_PO_DATE_TO.Value).ToString("yyyy-MM-dd"));
            param.Add("PURC_ORG", cbo01_PURC_ORG.Value);
            param.Add("PURC_PO_TYPE", cbo01_PURC_PO_TYPE.Value);
            param.Add("PARTNO", txt01_FPARTNO.Value);
            param.Add("STR_LOC", cdx01_STR_LOC.Value); //저장위치
            param.Add("CUSTCD", cdx01_CUSTCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT"), param);
        }

        /// <summary>
        /// Print
        /// </summary>
        private void Print()
        {
            try
            {
                //유효성 검사
                if (!IsQueryValidation()) return;

                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM31006";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

                /* 
                 * 신규 리포트 또는 리포트 컬럼 변동시 디자인용 컬럼정의 XML 파일은 리포트 호출시 
                 * 하기 코드를 이용하여 직접 생성하여 사용하세요 ( 주의. reb 파일을 먼저 report 하위에 생성후 아래 xml 파일을 생성하세요 )
                 * 넘기고자 하는 DataSet 개체의 이름이 ds 라면
                 * ds.Tables[0].TableName = "DATA";
                 * ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
                 * 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                 * */

                // Main Section ( 메인리포트 파라메터셋 )
                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                mainSection.ReportParameter.Add("PO_DATE_BEG", this.df01_PO_DATE_BEG.Value);
                mainSection.ReportParameter.Add("PO_DATE_TO", this.df01_PO_DATE_TO.Value);
                mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
                //mainSection.ReportParameter.Add("PO_DATE_08", this.D0_PO.Text);

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

        #endregion

        #region [ 유효성 검사 ]

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {            
            // 조회용 Validation
            //if (this.cdx01_VENDCD.IsEmpty)
            if (this.cdx01_VENDCD.IsEmpty && !(this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10")))
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
                return false;
            }
            if (this.df01_PO_DATE_BEG.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_PO_DATE_BEG", cbo01_DATE.SelectedItem.Text);//lbl01_PO_DATE.Text);
                return  false;
            }
            if (this.df01_PO_DATE_TO.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_PO_DATE_TO",  cbo01_DATE.SelectedItem.Text);//lbl01_PO_DATE.Text);
                return false;
            }
            return true;
        }

        #endregion

        #region [ 이벤트 ]
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

        [DirectMethod]
        public void MakePopUp(String[] arr, string type)
        {
            HEParameterSet param = new HEParameterSet();

            if (type.Equals("I"))
            {                
                param.Add("CORCD", UserInfo.CorporationCode);
                param.Add("BIZCD", cbo01_BIZCD.Value);
                param.Add("VENDCD", arr[7]);
                param.Add("PURC_ORG", arr[0]);
                param.Add("PURC_PO_TYPE", arr[1]);
                param.Add("PURC_GRP", arr[2]);
                param.Add("PARTNO", arr[3]);
                param.Add("PARTNM", arr[4]);
                param.Add("UNIT", arr[5]);
                param.Add("GRN_NO", arr[6]);
                param.Add("DATE_FROM", ((DateTime)this.df01_PO_DATE_BEG.Value).ToString("yyyy-MM-dd"));
                param.Add("DATE_TO", ((DateTime)this.df01_PO_DATE_TO.Value).ToString("yyyy-MM-dd"));
                param.Add("DIV", "I");
                param.Add("DATE_TYPE", this.cbo01_QUERY_COND.Value.ToString().Equals("1YX")? "" : this.cbo01_DATE.Value); //날짜 조건에 따라 팝업 조회 조건 변경 (미납일 경우에 빈값)
                param.Add("CUSTCD", "");
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM31006P1.aspx", param, "HELP_MM31006P1", "Popup", 800, 600);
            }
            else if (type.Equals("D"))
            {
                param.Add("PONO", arr[6]);
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM32002P2.aspx", param, "HELP_MM32002P2", "Popup", 800, 600);
            }
        }
        #endregion
    }
}
