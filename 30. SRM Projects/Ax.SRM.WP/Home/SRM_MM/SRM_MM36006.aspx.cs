#region ▶ Description & History
/* 
 * 프로그램명 : 납품전표 검수 실적(구.VM3310)
 * 설      명 : 자재관리 > 검수관리 > 납품전표 검수 실적
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-09-25
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
    public partial class SRM_MM36006 : BasePage
    {
        private string pakageName = "APG_SRM_MM33004";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM36006
        /// </summary>
        public SRM_MM36006()
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
                    SetCustVendVisible("2");
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

        [DirectMethod]
        public void SetCustVendVisible(string gubun)
        {
            this.Store1.RemoveAll();

            if (gubun.Equals("1"))
            {
                this.lbl01_CUST.Hidden = true;
                this.cdx01_CUSTCD.VisiableContainer = false;

                this.lbl01_VEND.Hidden = false;
                this.cdx01_VENDCD.VisiableContainer = true;                
            }
            else
            {
                this.lbl01_CUST.Hidden = false;
                this.cdx01_CUSTCD.VisiableContainer = true;                

                this.lbl01_VEND.Hidden = true;
                this.cdx01_VENDCD.VisiableContainer = false;                
            }
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

            this.txt01_PARTNO.Text = string.Empty;            

            this.df01_FROM_DATE.SetValue(DateTime.Now);
            this.df01_TO_DATE.SetValue(DateTime.Now);

            this.rdo01_OPT11.Selectable = true;

            this.Store1.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            string settle_id_div = string.Empty;
            string vendor = string.Empty;
            if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1"))
            {
                vendor = this.cdx01_VENDCD.Value;
                settle_id_div = "I";
            }
            else
            {
                vendor = this.cdx01_CUSTCD.Value;
                settle_id_div = "O";
            }

            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("BEG_DATE", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM"));
            param.Add("END_DATE", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM"));
            param.Add("VENDORCD", vendor);
            param.Add("SETTLE_IO_DIV", settle_id_div);            
            param.Add("PARTNO", this.txt01_PARTNO.Text);
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
        /// Print
        /// </summary>
        private void Print()
        {
            try
            {
                string settle_id_div = string.Empty;
                string vendor = string.Empty;
                if (RadioGroup1.CheckedItems[0].InputValue.ToString().Equals("1"))
                {
                    vendor = this.cdx01_VENDCD.Value;
                    settle_id_div = "I";
                }
                else
                {
                    vendor = this.cdx01_CUSTCD.Value;
                    settle_id_div = "O";
                }

                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.Value);
                param.Add("BEG_DATE", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM"));
                param.Add("END_DATE", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM"));
                param.Add("VENDORCD", vendor);
                param.Add("SETTLE_IO_DIV", settle_id_div);
                param.Add("PARTNO", this.txt01_PARTNO.Text);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);            
                         

                /* 
                 * 신규 리포트 또는 리포트 컬럼 변동시 디자인용 컬럼정의 XML 파일은 리포트 호출시 
                 * 하기 코드를 이용하여 직접 생성하여 사용하세요 ( 주의. reb 파일을 먼저 report 하위에 생성후 아래 xml 파일을 생성하세요 )
                 * 넘기고자 하는 DataSet 개체의 이름이 ds 라면
                 * ds.Tables[0].TableName = "DATA";
                 * ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
                 * 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                 * */

                // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                DataSet source1 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
                DataSet source2 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT"), param);

                if (source1 != null && source1.Tables[0].Rows.Count > 0)
                {

                    HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                    report.ReportName = "1000/SCM_MM/SCM_MM33004_1";  // 리포트ID 경로포함 ( 확장자 .reb 는 제외 )  ** 주의 ** 리포트 파일은 디자인후 속성창의 빌드작업에 포함리소스로 지정하도록 한다.
                    source1.Tables[0].TableName = "DATA";
                    source1.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);

                    HERexSection xmlSection = new HERexSection(source1, new HEParameterSet());

                    // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
                    // xmlSection.ReportParameter.Add("CORCD", "1000");
                    report.Sections.Add("XML1", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
                    AxReportForm.ShowReport(report);
                }

                if (source2 != null && source2.Tables[0].Rows.Count > 0)
                {

                    HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                    report.ReportName = "1000/SCM_MM/SCM_MM33004_2";  // 리포트ID 경로포함 ( 확장자 .reb 는 제외 )  ** 주의 ** 리포트 파일은 디자인후 속성창의 빌드작업에 포함리소스로 지정하도록 한다.
                    source2.Tables[0].TableName = "DATA";
                    source2.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
                    HERexSection xmlSection = new HERexSection(source2, new HEParameterSet());
                    // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
                    // xmlSection.ReportParameter.Add("CORCD", "1000");
                    report.Sections.Add("XML1", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
                    AxReportForm.ShowReport(report);
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
            return true;
        }

        #endregion

    }
}
