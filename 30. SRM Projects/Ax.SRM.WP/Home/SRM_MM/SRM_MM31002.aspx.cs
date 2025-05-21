#region ▶ Description & History
/* 
 * 프로그램명 : OEM 자재발주 (구.VM3050)
 * 설      명 : 자재관리 > 발주관리 > OEM 자재발주
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-09-17
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

namespace HE.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM31002 : BasePage
    {
        private string pakageName = "SIS.APG_SRM_MM31002";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM31002
        /// </summary>
        public SRM_MM31002()
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
                    Reset();
                    df01_PO_DATE_Change(null, null);
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

            // [SRM] this.cbo01_LOG_DIV.SelectedItem.Value = "";
            // [SRM] this.cbo01_LOG_DIV.UpdateSelectedItems(); 

            this.txt01_FPARTNO.Text = string.Empty;

            this.cdx01_VINCD.SetValue(string.Empty);

            this.df01_PO_DATE.SetValue(DateTime.Now);

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
            param.Add("PO_DATE", ((DateTime)this.df01_PO_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            // [SRM] param.Add("LOG_DIV", this.cbo01_LOG_DIV.Value);
            param.Add("FPARTNO", this.txt01_FPARTNO.Text);
            //param.Add("TPARTNO", "");
            param.Add("VINCD", this.cdx01_VINCD.Value);
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
            param.Add("PO_DATE", ((DateTime)df01_PO_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            // [SRM] param.Add("LOG_DIV", "");
            param.Add("FPARTNO", this.txt01_FPARTNO.Text);
            //param.Add("TPARTNO", "");
            param.Add("VINCD", this.cdx01_VINCD.Value);
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
                report.ReportName = "1000/SRM_MM/SRM_MM31002";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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
                mainSection.ReportParameter.Add("PO_DATE", this.df01_PO_DATE.Value);
                mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
                mainSection.ReportParameter.Add("PO_DATE_08", this.D0_PO.Text);

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
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.df01_PO_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_PO_DATE", lbl01_PO_DATE.Text);
                return  false;
            }
            return true;
        }

        #endregion

        #region [ 이벤트 ]

        protected void df01_PO_DATE_Change(object sender, DirectEventArgs e)
        {
            this.D0_PO.Text = String.Format("{0} 08:00 Based", ((DateTime)df01_PO_DATE.Value).ToString(this.GlobalLocalFormat_Date));

            this.D1_PO.Text = String.Format("D+1 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(1).ToString(this.GlobalLocalFormat_Date));
            this.D2_PO.Text = String.Format("D+2 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(2).ToString(this.GlobalLocalFormat_Date));
            this.D3_PO.Text = String.Format("D+3 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(3).ToString(this.GlobalLocalFormat_Date));
            this.D4_PO.Text = String.Format("D+4 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(4).ToString(this.GlobalLocalFormat_Date));
            this.D5_PO.Text = String.Format("D+5 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(5).ToString(this.GlobalLocalFormat_Date));
            this.D6_PO.Text = String.Format("D+6 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(6).ToString(this.GlobalLocalFormat_Date));
            this.D7_PO.Text = String.Format("D+7 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(7).ToString(this.GlobalLocalFormat_Date));
            this.D8_PO.Text = String.Format("D+8 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(8).ToString(this.GlobalLocalFormat_Date));
            this.D9_PO.Text = String.Format("D+9 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(9).ToString(this.GlobalLocalFormat_Date));
            this.D10_PO.Text = String.Format("D+10 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(10).ToString(this.GlobalLocalFormat_Date));
            this.D11_PO.Text = String.Format("D+11 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(11).ToString(this.GlobalLocalFormat_Date));
            this.D12_PO.Text = String.Format("D+12 Order ({0})", ((DateTime)df01_PO_DATE.Value).AddDays(12).ToString(this.GlobalLocalFormat_Date));

            this.Store1.RemoveAll();
        }

        #endregion
    }
}
