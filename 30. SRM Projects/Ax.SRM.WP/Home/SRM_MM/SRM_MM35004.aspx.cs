#region ▶ Description & History
/* 
 * 프로그램명 : 차종별 서열지 출력 (직서열) (구.VM3221)
 * 설      명 : 자재관리 > 서열투입현황 > 차종별 서열지 출력 (직서열)
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-22
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

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM35004 : BasePage
    {
        private string pakageName = "APG_SRM_MM35004";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM35004
        /// </summary>
        public SRM_MM35004()
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
                    this.SetSeqTypeCombo(); //콤보상자 바인딩(서열지유형)
                    this.SetCombo();        //콤보상자 바인딩(자재품목, 위치)
                    this.Reset();           //초기화
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
            MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
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
                
        /// <summary>
        /// 더블클릭시 검사성적서 등록 팝업 표시한다.
        /// </summary>
        /// <param name="qty"></param>
        /// <param name="partno"></param>
        /// <param name="barcode"></param>
        /// <param name="deli_date"></param>
        /// <param name="deli_cnt"></param>
        [DirectMethod]
        public void Cell_DoubleClick(string qty, string partno, string barcode, string deli_date, string deli_cnt)
        {
            // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
            HEParameterSet set = new HEParameterSet();
            set.Add("QTY", qty);
            set.Add("PARTNO", partno);
            set.Add("BARCODE", barcode);
            set.Add("BIZCD", this.cbo01_BIZCD.Value);
            set.Add("VENDCD", this.cdx01_VENDCD.Value);
            set.Add("DELI_DATE", DateTime.Parse(deli_date).ToString("yyyy-MM-dd"));
            set.Add("DELI_CNT", deli_cnt);
            set.Add("NOTE_TYPE", "S");
            set.Add("LINENM", "");
            set.Add("VINNM", this.cdx01_VINCD.Text);
            set.Add("MAT_ITEMNM", this.cbo01_MAT_ITEM.Text);
            set.Add("INSTALL_POSNM", this.cbo01_INSTALL_POS.Text);
            //Util.UserPopup(this, "HELP_CUST_ITEMCD", PopupHelper.HelpType.Search, "GRID_CUST_ITEMCD_HELP01", this.CodeValue.Text, this.NameValue.Text, "", 
            //PopupHelper.defaultPopupWidth, PopupHelper.defaultPopupHeight, set);

            Util.UserPopup(this, this.UserHelpURL.Text, set, "HELP_QA23001P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
        }

        #endregion

        #region [ 기능 ]

        /// <summary>
        /// 콤보상자 바인딩(자재품목, 위치)
        /// </summary>
        private void SetCombo()
        {
            //자재품목
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);

            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "SYSHANIL.PKG_SCM_MM35003", "INQUERY_MAT_ITEM"), param);
            Library.ComboDataBind(this.cbo01_MAT_ITEM, ds.Tables[0], false, "TYPENM", "OBJECT_ID", true);

            //위치         
            DataSet ds2 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "SYSHANIL.PKG_SCM_MM35003", "INQUERY_INSTALL_POS"), param);

            Library.ComboDataBind(this.cbo01_INSTALL_POS, ds2.Tables[0], false, "TYPECD", "OBJECT_ID", true);
        }

        /// <summary>
        /// 콤보상자 바인딩(서열지유형)
        /// </summary>
        private void SetSeqTypeCombo()
        {            
            DataSet source = new DataSet();
            DataTable dt = new DataTable();
            dt.Columns.Add("CODE");
            dt.Columns.Add("NAME");

            dt.Rows.Add("2PA", "2P A Type");
            dt.Rows.Add("2PB", "2P B Type");
            dt.Rows.Add("4PA", "4P A Type");
            dt.Rows.Add("4PB", "4P B Type");
            source.Tables.Add(dt);
            Library.ComboDataBind(this.cbo01_SEQ_TYPE, dt, false, "NAME", "CODE", true);        
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
            //업체코드는 서연이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            
            this.df01_INPUT_DATE.SetValue(DateTime.Now);

            this.cdx01_VINCD.SetValue(string.Empty);
            if (cbo01_MAT_ITEM.Items.Count > 0)
            {
                this.cbo01_MAT_ITEM.SelectedItem.Index = 0;
                this.cbo01_MAT_ITEM.UpdateSelectedItems(); //꼭 해줘야한다.
            }
            if (cbo01_INSTALL_POS.Items.Count > 0)
            {
                this.cbo01_INSTALL_POS.SelectedItem.Index = 0;
                this.cbo01_INSTALL_POS.UpdateSelectedItems(); //꼭 해줘야한다.
            }            

            this.txt01_FROM_CHASU.SetValue(string.Empty);
            this.txt01_TO_CHASU.SetValue(string.Empty);

            if (cbo01_SEQ_TYPE.Items.Count > 0)
            {
                this.cbo01_SEQ_TYPE.SelectedItem.Index = 0;
                this.cbo01_SEQ_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.
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
            
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            //param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("INPUT_DATE", ((DateTime)this.df01_INPUT_DATE.Value).ToString("yyyy-MM-dd"));            
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("MAT_ITEM", this.cbo01_MAT_ITEM.Value);
            param.Add("INSTALL_POS", this.cbo01_INSTALL_POS.Value);
            param.Add("FROM_CHASU", this.txt01_FROM_CHASU.Text);
            param.Add("TO_CHASU", this.txt01_TO_CHASU.Text);            
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
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
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("INPUT_DATE", ((DateTime)this.df01_INPUT_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("MAT_ITEM", this.cbo01_MAT_ITEM.Value);
            param.Add("INSTALL_POS", this.cbo01_INSTALL_POS.Value);
            param.Add("FROM_CHASU", this.txt01_FROM_CHASU.Text);
            param.Add("TO_CHASU", this.txt01_TO_CHASU.Text);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            if(this.cbo01_SEQ_TYPE.Value.ToString().Equals("2PA"))
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT_2PA"), param);
            else
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT_5IN1"), param);
        }

        /// <summary>
        /// Print
        /// </summary>
        private void Print()
        {
            //검사성적서 체크로직 주석처리 2013.07.18 
            //  (황연규조장 합의완료.)
            //if (IsPrintable())
            //{

            //테스트 임시 주석
            this.Save(); 

            //테스트 임시 주석
            // 직서열지 출력시 MM1023 자료를 MM1024 에 넣어준다.  (2009.05.22) 김연수
            // 생산계획 수립시 데이터가 새로 만들어 지는 관계로 수입검사에서 
            // 조회가 되지 않은 문제해결
            this.CopyFrom_MM1023_To_MM1024();

            this.PrintReport();
            //}
        }

        private bool IsPrintable()
        {
            //검사성적서 입력 건 체크          
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("INPUT_DATE", ((DateTime)this.df01_INPUT_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("MAT_ITEM", this.cbo01_MAT_ITEM.Value);
            param.Add("INSTALL_POS", this.cbo01_INSTALL_POS.Value);
            param.Add("FROM_CHASU", this.txt01_FROM_CHASU.Text);
            param.Add("TO_CHASU", this.txt01_TO_CHASU.Text);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            DataSet source =  EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PRINT_YN"), param);
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
                this.MsgCodeAlert("SCMQA00-0048");
            }

            return isprintable;
        }

        private void Save()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("INPUT_DATE", ((DateTime)this.df01_INPUT_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("MAT_ITEM", this.cbo01_MAT_ITEM.Value);
            param.Add("INSTALL_POS", this.cbo01_INSTALL_POS.Value);
            param.Add("FROM_CHASU", this.txt01_FROM_CHASU.Text);
            param.Add("TO_CHASU", this.txt01_TO_CHASU.Text);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            EPClientHelper.ExecuteNonQuery(string.Format("{0}.{1}", pakageName, "SAVE_MM1060"), param);
        }

        private void PrintReport()
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);

                if (this.cbo01_SEQ_TYPE.Value.ToString().Equals("2PA"))
                    report.ReportName = "1000/SRM_MM/SRM_MM35003_2PA";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함
                else if (this.cbo01_SEQ_TYPE.Value.ToString().Equals("2PB"))
                    report.ReportName = "1000/SRM_MM/SRM_MM35003_2PB";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함
                else if (this.cbo01_SEQ_TYPE.Value.ToString().Equals("4PA"))
                    report.ReportName = "1000/SRM_MM/SRM_MM35003_4PA";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함
                else
                    report.ReportName = "1000/SRM_MM/SRM_MM35003_4PB";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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

                report.Sections.Add("MAIN", mainSection);

                // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                DataSet ds = getReportDataSet();

                // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                //ds.Tables[0].TableName = "DATA";
                //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);

                HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                //// 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
                //// xmlSection.ReportParameter.Add("CORCD", "1000");
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
        
        //'### 직서열자료 MM1023 To MM1024 (2009.05.22) 김연수
        private void CopyFrom_MM1023_To_MM1024()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("YMD", ((DateTime)this.df01_INPUT_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("ITEMCD", this.cbo01_MAT_ITEM.Value);
            param.Add("POSCD", this.cbo01_INSTALL_POS.Value);
            param.Add("BEG_CNT", this.txt01_FROM_CHASU.Text);
            param.Add("END_CNT", this.txt01_TO_CHASU.Text);

            EPClientHelper.ExecuteNonQuery(string.Format("{0}.{1}", pakageName, "SEND_MM1070"), param);
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
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.df01_INPUT_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_INPUT_DATE", lbl01_DELIVERYDATE.Text);
                return  false;
            }
            if (this.cdx01_VINCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VINCD", lbl01_VIN.Text);
                return false;
            }
            if (this.txt01_FROM_CHASU.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_FROM_CHASU", lbl01_CHASU.Text);
                return false;
            }
            if (this.txt01_TO_CHASU.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_TO_CHASU", lbl01_CHASU.Text);
                return false;
            }
            return true;
        }

        #endregion

    }
}
