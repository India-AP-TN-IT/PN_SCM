#region ▶ Description & History
/* 
 * 프로그램명 : FIELD CLAIM 업체 변제 LIST 출력(Popup) (구.VQ2080_RPT FIELD CLAIM 업체 변제 LIST 출력)
 * 설      명 : 
 * 최초작성자 : 이현범
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
using Ext.Net;
using Ax.EP.Utility;
using HE.Framework.Core;
using System.Data;
using HE.Framework.Core.Report;

namespace Ax.EP.WP.Home.SRM_QA
{
    public partial class SRM_QA21004P3 : BasePage
    {
        private string pakageName = "APG_SRM_QA21004";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA21004P3 생성자
        /// </summary>
        public SRM_QA21004P3()
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
                }

                if (!IsPostBack)
                {
                    string sQuery = Request.Url.Query;

                    string BIZCD = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    string YYMM = HttpUtility.ParseQueryString(sQuery).Get("YYMM");
                    string CLAIM_OCCUR_DIV = HttpUtility.ParseQueryString(sQuery).Get("CLAIM_OCCUR_DIV");
                    string OCCUR_DIV = HttpUtility.ParseQueryString(sQuery).Get("OCCUR_DIV");

                    this.cbo01_BIZCD.SetValue(BIZCD);
                    this.df01_YYMM.SetValue(YYMM);
                    this.txt01_CLAIM_OCCUR_DIV.SetValue(CLAIM_OCCUR_DIV);
                    this.txt01_OCCUR_DIV.SetValue(OCCUR_DIV);
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
        private DataSet getReportDataSet()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("YYMM", ((DateTime)this.df01_YYMM.Value).ToString("yyyy-MM"));
            param.Add("CLAIM_OCCUR_DIV", this.txt01_CLAIM_OCCUR_DIV.Text);
            param.Add("OCCUR_DIV", this.txt01_OCCUR_DIV.Text);
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
                report.ReportName = "1000/SRM_QA/SRM_QA21004P3";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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
                mainSection.ReportParameter.Add("YYMM", this.df01_YYMM.Value);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);

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

        #endregion

        #region [ 유효성 검사 ]

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {
            // 조회용 Validation
            if (this.df01_YYMM.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "df01_YYMM", lbl01_YYMM.Text);
                return false;
            }
            return true;
        }

        #endregion
    }
}