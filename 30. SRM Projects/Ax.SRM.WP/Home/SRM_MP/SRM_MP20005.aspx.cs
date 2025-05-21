#region ▶ Description & History
/* 
 * 프로그램명 : 납품서 등록
 * 설      명 : 일반구매 > 납품관리 > 발주접수
 * 최초작성자 : 이재우
 * 최초작성일 : 2017-09-18
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

namespace Ax.SRM.WP.Home.SRM_MP
{

    public partial class SRM_MP20005 : BasePage
    {
        private string pakageName = "APG_SRM_MP20005";
        

        #region [ 초기설정 ]

        /// <summary>
        /// SCM_MP20005
        /// </summary>
        public SRM_MP20005()
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
                    Library.ComboDataBind(this.cbo01_MRO_PO_TYPE, Library.GetTypeCode("1J").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);
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
            MakeButton(ButtonID.Search,  ButtonImage.Search,  "Search",     this.ButtonPanel);
            MakeButton(ButtonID.Reset,   ButtonImage.Reset,   "Reset",      this.ButtonPanel);
            MakeButton(ButtonID.Print,   ButtonImage.Print,   "Print",      this.ButtonPanel);
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
                case "btn01_MP20005":
                        DataSet result = getDataSetDetail();
                        this.Store3.DataSource = result.Tables[0];
                        this.Store3.DataBind();

                        if (V_STATUS.Text.Equals(" "))
                        {
                            SAVE();
                            //개발 기간동안 막아둠
                            MAIL(result);
                        }

                        if(Util.UserInfo.Language.ToString().Equals("KO"))
                            Grid01.GetStore().GetAt(Convert.ToInt32(V_ROW.Value)).Set("STATUS", "접수");
                        else
                            Grid01.GetStore().GetAt(Convert.ToInt32(V_ROW.Value)).Set("STATUS", "RECEIPT");

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
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();
                //Reset();

                this.Store3.RemoveAll();
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
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_MRO_PO_TYPE.SelectedItem.Value = "";
            this.cbo01_MRO_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.
            this.df01_BEG_DATE.SetValue(DateTime.Now.ToString("yyyy-MM") + "-01");
            this.df01_END_DATE.SetValue(DateTime.Now);
            this.txt01_PONO.SetValue("");

            if (this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
                this.cdx01_VENDCD.ReadOnly = false;
            }
            else
            {
                this.cdx01_VENDCD.SetValue(this.UserInfo.VenderCD);
                this.cdx01_VENDCD.ReadOnly = true;
            }

            Store1.RemoveAll();
        }



        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", cdx01_VENDCD.Value);
            param.Add("MRO_PO_TYPE", cbo01_MRO_PO_TYPE.Value);
            param.Add("FROMDATE", ((DateTime)this.df01_BEG_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("TODATE", ((DateTime)this.df01_END_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("PONO", txt01_PONO.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_HEARDER"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getReportDataSet()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", cdx01_VENDCD.Value);
            param.Add("MRO_PO_TYPE", V_MRO_PO_TYPE.Value);
            param.Add("PO_DATE", V_PO_DATE.Value);
            param.Add("PONO", V_PONO.Value); // 2017-11-08 박의곤 프린트시 합쳐지는 문제 분리작업
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSetDetail()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("PONO", V_PONO.Value);
            param.Add("PONO_SEQ", V_PONO_SEQ.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_DETAIL"), param);
        }

        private void SAVE()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("PO_DATE", V_PO_DATE.Value);
            param.Add("PONO", V_PONO.Value);
            param.Add("PONO_SEQ", V_PONO_SEQ.Value);

            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param);
                //this.MsgCodeAlert("SCM_MP00-0001");
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
                report.ReportName = "1000/SRM_MP/SRM_MP20005";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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
        /// Excel_Export
        /// </summary>
        private void Excel_Export()
        {
            try
            {

                DataSet result = getDataSetDetail();

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

        [DirectMethod]
        public void Grid01_Cell_DoubleClick()
        {
            DataSet result = getDataSetDetail();
            this.Store3.DataSource = result.Tables[0];
            this.Store3.DataBind();

            if (V_STATUS.Text.Equals(" "))
            {
                SAVE();
                //개발 기간동안 막아둠
                MAIL(result);
            }

            if (Util.UserInfo.LanguageShort.ToString().Equals("KO"))
                Grid01.GetStore().GetAt(Convert.ToInt32(V_ROW.Value)).Set("STATUS", "접수");
            else
                Grid01.GetStore().GetAt(Convert.ToInt32(V_ROW.Value)).Set("STATUS", "RECEIPT");

            Grid01.Refresh();
        }

        private void MAIL(DataSet ds)
        {
            //' * 일반구매담당 : 손순진과장 / 052-219-5216 /  sonsj@seoyoneh.com
            //' - 사업장 : 울산 / 아산  
            //' - 팀구분 : 구매
            //' * 울산 총무구매담당 : 김학준과장 / 052-219-5038 / kimhj@seoyoneh.com
            //' - 사업장 : 울산
            //' - 팀구분 : 총무
            //' * 아산 총무구매담당 : 조광제차장 / 041-539-6353 / jokj@seoyoneh.com
            //' - 사업장 : 아산
            //' - 팀구분 : 총무
            string mailTo = "sonsj@seoyoneh.com";

            if (this.cbo01_BIZCD.Value.Equals("1001") && this.cbo01_MRO_PO_TYPE.Value.Equals("H1B")) //울산/총무
                mailTo = "sonsj@seoyoneh.com";
            else if (this.cbo01_BIZCD.Value.Equals("1002") && this.cbo01_MRO_PO_TYPE.Value.Equals("H1B")) //아산/총무
                mailTo = "jokj@seoyoneh.com";

            string mailData = "";
            mailData = (this.UserInfo.LanguageShort.Equals("KO") ? "업체코드 : " : "Customer Code : ") + this.cdx01_VENDCD.Value;
            mailData += (this.UserInfo.LanguageShort.Equals("KO") ? "\n업체명 : " : "Customer Name : ") + this.cdx01_VENDCD.Text;
            mailData += (this.UserInfo.LanguageShort.Equals("KO") ? "\n발주접수일자 : " : "Receipt Date of order : ") + DateTime.Now;

            string pono = "";
            string pono_temp = "";
            string podate = "";
            string podate_temp = "";
            string vendCode = "";
            string vendName = "";

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (pono != ds.Tables[0].Rows[i]["PONO"].ToString())
                {
                    pono_temp = ds.Tables[0].Rows[i]["PONO"].ToString() + "-" + ds.Tables[0].Rows[i]["PONO_SEQ"].ToString();
                    pono = pono.Length == 0 ? pono_temp : pono + ", " + pono_temp;
                }
                if (podate != ds.Tables[0].Rows[i]["PO_DATE"].ToString())
                {
                    podate_temp = ds.Tables[0].Rows[i]["PO_DATE"].ToString();
                    podate = podate + podate_temp;
                }
                if (vendCode.Length == 0)
                {
                    vendCode = ds.Tables[0].Rows[i]["VENDCD"].ToString();
                    vendName = ds.Tables[0].Rows[i]["VENDNM"].ToString();
                }
            }
            
            mailData += (this.UserInfo.LanguageShort.Equals("KO") ? "\n발주번호 : " : "\nOrder No. : ") + pono;
            mailData += (this.UserInfo.LanguageShort.Equals("KO") ? "\n발주일자 : " : "\nOrder Date. : ") + podate;

            DataSet param = Util.GetDataSourceSchema
            (
               "CORCD", "BIZCD", "MAIL_TO", "MAIL_SUBJECT", "MAIL_BODY", "LANG_SET", "USERID"
            );

            param.Tables[0].Rows.Add
            (
                Util.UserInfo.CorporationCode
                , this.cbo01_BIZCD.Value
                , mailTo
                , (this.UserInfo.LanguageShort.Equals("KO") ? "[서연이화SCM] 일반구매 발주접수" : "[VAN] Receipt of Purchase Order") + " (" + vendCode + ":" + vendName + ")"
                , mailData
                , this.UserInfo.LanguageShort
                , this.UserInfo.UserID
            );

            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SEND_EMAIL"), param);
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
                this.MsgCodeAlert_ShowFormat("SCMMP00-0024", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            else if (this.df01_BEG_DATE.IsEmpty || this.df01_END_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SCMMP00-0024", "df01_BEG_DATE", lbl01_PO_DATE.Text);
                return false;
            }

            return true;
        }

        #endregion
    }
}
