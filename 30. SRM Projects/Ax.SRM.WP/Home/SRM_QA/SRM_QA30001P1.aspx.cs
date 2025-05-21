#region ▶ Description & History
/* 
 * 프로그램명 : 입고품 불량내용 상세조회 (구.VQ3010)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-02
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
    public partial class SRM_QA30001P1 : BasePage
    {
        private string pakageName = "APG_SRM_QA30001";
        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_QA30001P1()
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
                if (!IsPostBack)
                {
                    string sQuery = Request.Url.Query;

                    this.txt01_BIZCD.Text = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    string VENDCD0 = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");
                    string RCV_DATE0 = DateTime.Parse(HttpUtility.ParseQueryString(sQuery).Get("RCV_DATE")).ToString("yyyy-MM-dd");
                    string DEFNO0 = HttpUtility.ParseQueryString(sQuery).Get("DEFNO");
                    this.txt01_INSPECT_DIV.Text = HttpUtility.ParseQueryString(sQuery).Get("INSPECT_DIV");

                    DataSet ds = null;

                    HEParameterSet param = new HEParameterSet();
                    param.Add("CORCD", Util.UserInfo.CorporationCode);
                    param.Add("BIZCD", this.txt01_BIZCD.Text);
                    param.Add("VENDCD", VENDCD0);
                    param.Add("RCV_DATE", RCV_DATE0);
                    param.Add("DEFNO", DEFNO0);
                    param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                    param.Add("INSPECT_DIV", txt01_INSPECT_DIV.Text);
                    param.Add("USER_ID", Util.UserInfo.UserID);

                    ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_POPUP"), param);

                    if (ds.Tables[0].Rows.Count <= 0)
                        return;
                    else
                    {
                        DataRow dr = ds.Tables[0].Rows[0];
                        VENDCD.Text = dr["VENDCD"].ToString();
                        VENDNM.Text = dr["VENDNM"].ToString();
                        RCV_DATE.Text = DateTime.Parse(dr["RCV_DATE"].ToString()).ToString(this.GlobalLocalFormat_Date);
                        DEFNO.Text = dr["DEFNO"].ToString();
                        VINCD.Text = dr["VINCD"].ToString();
                        LOTNO.Text = DateTime.Parse(dr["LOTNO"].ToString()).ToString(this.GlobalLocalFormat_Date);
                        PARTNO.Text = dr["PARTNO"].ToString();
                        PARTNM.Text = dr["PARTNM"].ToString();
                        ITEMNM.Text = dr["ITEMNM"].ToString();
                        NAME_KOR.Text = dr["NAME_KOR"].ToString();
                        DEFNM.Text = dr["DEFNM"].ToString();
                        DEF_PLACECD.Text = dr["DEF_PLACECD"].ToString();
                        DEF_QTY.Text = string.Format("{0:#,#}", dr["DEF_QTY"]); 
                        INSPECT_QTY.Text = string.Format("{0:#,#}", dr["INSPECT_QTY"]);
                        MGRT_CNTTCD.Text = dr["MGRT_CNTTCD"].ToString();
                        REPLY_DEM_DATE.Text = DateTime.Parse(dr["REPLY_DEM_DATE"].ToString()).ToString(this.GlobalLocalFormat_Date);

                        if (!dr["OK_PHOTO"].ToString().Equals(""))
                            OK_PHOTO.ImageUrl = Util.FileEncoding((byte[])dr["OK_PHOTO"], true);
                        if (!dr["DEF_PHOTO"].ToString().Equals(""))
                            DEF_PHOTO.ImageUrl = Util.FileEncoding((byte[])dr["DEF_PHOTO"], true);
                    }

                    if (txt01_INSPECT_DIV.Text.Equals("FNINS01"))
                    {
                        HEParameterSet param02 = new HEParameterSet();
                        param02.Add("CORCD", Util.UserInfo.CorporationCode);
                        param02.Add("BIZCD", this.txt01_BIZCD.Text);
                        param02.Add("DEFNO", DEFNO0);
                        param02.Add("LANG_SET", Util.UserInfo.LanguageShort);
                        param02.Add("USER_ID", Util.UserInfo.UserID);

                        using (EPClientProxy proxy = new EPClientProxy())
                        {
                            proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_QA1020"), param02);
                        }
                    }
                    else if (txt01_INSPECT_DIV.Text.Equals("FNINS03"))
                    {
                        HEParameterSet param02 = new HEParameterSet();
                        param02.Add("CORCD", Util.UserInfo.CorporationCode);
                        param02.Add("BIZCD", this.txt01_BIZCD.Text);
                        param02.Add("NOTENO", DEFNO0);
                        param02.Add("RCV_DATE", RCV_DATE0);
                        param02.Add("LANG_SET", Util.UserInfo.LanguageShort);
                        param02.Add("USER_ID", Util.UserInfo.UserID);

                        using (EPClientProxy proxy = new EPClientProxy())
                        {
                            proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_QA1060"), param02);
                        }
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
                case ButtonID.Close:
                    X.Js.Call("closeTab");
                    break;
                default: break;
            }
        }

        /// <summary>
        /// Print
        /// </summary>
        private void Print()
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_QA/SRM_QA30001P1E";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함
                    
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
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getReportDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.txt01_BIZCD.Text);
            param.Add("VENDCD", this.VENDCD.Text);
            param.Add("RCV_DATE", this.RCV_DATE.Text);
            param.Add("DEFNO", this.DEFNO.Text);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("INSPECT_DIV", txt01_INSPECT_DIV.Text);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT"), param);
        }
    }
}