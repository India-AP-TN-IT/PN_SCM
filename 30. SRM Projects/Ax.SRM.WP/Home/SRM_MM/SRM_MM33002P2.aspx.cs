#region ▶ Description & History
/* 
 * 프로그램명 : 월별 검수실적 출력(Popup) (구.VM3120_RPT 월별 검수실적 출력)
 * 설      명 : 
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-21
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
using System.Web;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using HE.Framework.Core.Report;

namespace Ax.SRM.WP.Home.SRM_MM
{
    /// <summary>
    /// <b>자재관리>검수관리>월별 검수실적 출력(Popup)</b>
    /// - 작 성 자 : 이명희<br />
    /// - 작 성 일 : 2014-10-21<br />
    /// </summary>
    public partial class SRM_MM33002P2 : BasePage
    {
        private string pakageName = "APG_SRM_MM33002";

        #region [ 초기설정 ]

        /// <summary>
        /// SCM_MM33002P2 생성자
        /// </summary>
        public SRM_MM33002P2()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = false;
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
                    Library.ComboDataBind(this.cbo01_MAT_TYPE, Library.GetTypeCode("EA").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);
                    Library.ComboDataBind(this.cbo01_LV_DIV, Library.GetTypeCode("EJ").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);
                    Library.ComboDataBind(this.cbo01_ORDER_GUBUN, Library.GetTypeCode("VA", "12").Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);
                }

                if (!IsPostBack)
                {
                    string sQuery = Request.Url.Query;

                    string BIZCD = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    string VENDCD = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");
                    string RCV_DATE = HttpUtility.ParseQueryString(sQuery).Get("RCV_DATE");
                    string MAT_TYPE = HttpUtility.ParseQueryString(sQuery).Get("MAT_TYPE");
                    string LV_DIV = HttpUtility.ParseQueryString(sQuery).Get("LV_DIV");                    
                    string FPARTNO = HttpUtility.ParseQueryString(sQuery).Get("FPARTNO");
                    //string TPARTNO = HttpUtility.ParseQueryString(sQuery).Get("TPARTNO");

                    this.cbo01_BIZCD.SetValue(BIZCD);
                    this.cdx01_VENDCD.SetValue(VENDCD);
                    this.df01_RCV_DATE.SetValue(RCV_DATE);
                    this.cbo01_MAT_TYPE.SetValue(MAT_TYPE);
                    this.cbo01_LV_DIV.SetValue(LV_DIV);
                    this.txt01_FPARTNO.SetValue(FPARTNO);
                    //this.txt01_TPARTNO.SetValue(TPARTNO);
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
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
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
                case ButtonID.Print:
                    Print();
                    break;
                default: break;
            }
        }

        #endregion

        #region [ 기능 ]

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
            param.Add("RCV_DATE", ((DateTime)this.df01_RCV_DATE.Value).ToString("yyyy-MM"));
            param.Add("MAT_TYPE", this.cbo01_MAT_TYPE.Value);
            param.Add("LV_DIV", this.cbo01_LV_DIV.Value);
            param.Add("FPARTNO", this.txt01_FPARTNO.Text);
            //param.Add("TPARTNO", this.txt01_TPARTNO.Text.Equals(string.Empty) ? "Z" : this.txt01_TPARTNO.Text);
            param.Add("ORDER", this.cbo01_ORDER_GUBUN.Value); //ORDER BY
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PRINT"), param);
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
                report.ReportName = "1000/SRM_MM/SRM_MM33002";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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
                mainSection.ReportParameter.Add("RCV_DATE", this.df01_RCV_DATE.Value);
                mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);

                report.Sections.Add("MAIN", mainSection);

                // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                DataSet ds = getDataSet();

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
            if (this.df01_RCV_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_RCV_DATE", lbl01_STD_YYMM.Text);
                return false;
            }
            return true;
        }

        #endregion
    }
}