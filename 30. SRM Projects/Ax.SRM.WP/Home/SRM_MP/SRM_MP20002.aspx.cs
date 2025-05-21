#region ▶ Description & History
/* 
 * 프로그램명 : 견적 의뢰 접수     [D2](구.VG3010)
 * 설      명 : 
 * 최초작성자 : 손창현
 * 최초작성일 : 2017-09-19
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
using System.Linq;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using HE.Framework.Core.Report;

namespace Ax.SRM.WP.Home.SRM_MP
{
    public partial class SRM_MP20002 : BasePage
    {
        private string pakageName = "APG_SRM_MP20002";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SCM_MP20002
        /// </summary>
        public SRM_MP20002()
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
            MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
            MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
            //MakeButton(ButtonID.Estimate, ButtonImage.Estimate, "Estimate", this.ButtonPanel);
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

            //if (id == ButtonID.Estimate)
            //{
            //    ibtn.DirectEvents.Click.Event -= new ComponentDirectEvent.DirectEventHandler(Button_Click);
            //    ibtn.DirectEvents.Click.ExtraParams.Add(
            //    new Ext.Net.Parameter { Name = "Values", Value = "Ext.encode(#{Grid01}.getRowsValues({selectedOnly:true}))", Mode = ParameterMode.Raw });
            //}

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
                //case ButtonID.Estimate:
                //    Estimate(e.ExtraParams["Values"]);
                    //break;
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
                case "btn01_MP20002":

                    DataSet result = getDataSet02();
                    this.Store3.DataSource = result.Tables[0];
                    this.Store3.DataBind();

                    //상태의 값이 아무것도 없다면 신규 접수 건으로 상태 업데이트와 메일을 발송한다.
                    if (V_STATUS.Value.ToString().Trim().Length == 0)
                    {
                        string value = SAVE(); //접수날짜 저장 후 '접수' 다국어 정보 문자로 가져옴
                        MAIL(result); //메일 발송
                        Grid01.GetStore().GetAt(Convert.ToInt32(V_ROW.Value)).Set("STATUS", value); //그리드에 표시                        
                    }

                    /* 구 SCM
                    DataSet result02 = getDataSet();
                    Grid01.GetStore().GetAt(Convert.ToInt32(V_ROW.Value)).Set("STATUS", result02.Tables[0].Rows[Convert.ToInt32(V_ROW.Value)]["STATUS"]);
                    
                    if (!V_OBJECT_ID.Value.Equals("VA5"))
                    {
                        SAVE();
                        //개발 기간 중 막아둠
                        MAIL(result);
                        DataSet result01 = getDataSet();
                        Grid01.GetStore().GetAt(Convert.ToInt32(V_ROW.Value)).Set("STATUS", result01.Tables[0].Rows[Convert.ToInt32(V_ROW.Value)]["STATUS"]);
                    }
                    */

                    break;

                case "btn01_ETMT":
                    //견적서 작성
                    Estimate(sender, e);
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
            this.df01_BEG_DATE.SetValue(DateTime.Now.AddMonths(-2));
            this.df01_END_DATE.SetValue(DateTime.Now);

            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }
            Store1.RemoveAll();
            Store3.RemoveAll();
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
                report.ReportName = "1000/SRM_MP/SRM_MP20002";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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
                mainSection.ReportParameter.Add("DATE", V_QUOTATION_DATE.Value);
                mainSection.ReportParameter.Add("VENDNM", this.cdx01_VENDCD.Text);
                mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
                //견적자료 요청일 = 발주일자 + 1 15:00
                mainSection.ReportParameter.Add("REPT_DATE", (Convert.ToDateTime(V_QUOTATION_DATE.Value).AddDays(1).ToString("yyyy-MM-dd") + " 15:00 한"));

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
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", cdx01_VENDCD.Value);
            param.Add("MRO_PO_TYPE", cbo01_MRO_PO_TYPE.Value);
            param.Add("FROMDATE", ((DateTime)this.df01_BEG_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("TODATE", ((DateTime)this.df01_END_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_HEARDER"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet02()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", cdx01_VENDCD.Value);
            param.Add("MRO_PO_TYPE", V_MRO_PO_TYPE.Value);
            param.Add("QUOTATION_DATE", V_QUOTATION_DATE.Value);
            param.Add("STATUS", V_STATUS.Value.ToString().Trim());
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_DETAIL"), param);
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
            param.Add("QUOTATION_DATE", V_QUOTATION_DATE.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT"), param);
        }

        private string SAVE()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", cdx01_VENDCD.Value);
            param.Add("MRO_PO_TYPE", V_MRO_PO_TYPE.Value);
            param.Add("QUOTATION_DATE", V_QUOTATION_DATE.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            using (EPClientProxy proxy = new EPClientProxy())
            {
                return proxy.ExecuteDataSetTx(string.Format("{0}.{1}", pakageName, "SAVE"), param).Tables[0].Rows[0][0].ToString();
            }
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

            if (this.cbo01_BIZCD.Value.Equals("1001") && V_MRO_PO_TYPE.Value.Equals("1JK2")) //울산/총무
                mailTo = "sonsj@seoyoneh.com";
            else if (this.cbo01_BIZCD.Value.Equals("1002") && V_MRO_PO_TYPE.Value.Equals("1JK2")) //아산/총무
                mailTo = "jokj@seoyoneh.com";            

            string mailData = "";
            mailData = (this.UserInfo.LanguageShort.Equals("KO") ? "업체코드 : " : "Customer Code : ") + this.cdx01_VENDCD.Value;
            mailData += (this.UserInfo.LanguageShort.Equals("KO") ? "\n업체명 : " : "Customer Name : ") + this.cdx01_VENDCD.Text;
            mailData += (this.UserInfo.LanguageShort.Equals("KO") ? "\n견적접수일자 : " : "Receipt Date of Estimate : ") + DateTime.Now;

            string pono = "";
            string pono_temp = "";
            string podate = "";
            string podate_temp = "";
            string email = "";
            string email_temp = "";
            string vendCode = "";
            string vendName = "";

            for(int i = 0; i <  ds.Tables[0].Rows.Count; i++)
            {
                if(pono != ds.Tables[0].Rows[i]["PONO"].ToString()) 
                {
                    pono_temp = ds.Tables[0].Rows[i]["PONO"].ToString() + "-" + ds.Tables[0].Rows[i]["PRNO_SEQ"].ToString();
                    pono = pono.Length == 0 ? pono_temp : pono + ", " + pono_temp;
                }
                if(podate != ds.Tables[0].Rows[i]["PO_DATE"].ToString())
                {
                    podate = ds.Tables[0].Rows[i]["PO_DATE"].ToString();
                    podate = podate + podate_temp;
                }

                if (email != ds.Tables[0].Rows[i]["EMAIL_ADDR"].ToString())
                {
                    email = ds.Tables[0].Rows[i]["EMAIL_ADDR"].ToString();
                    email = email + email_temp + ((i == ds.Tables[0].Rows.Count - 1) ? "" : ",");
                }

                if (vendCode.Length == 0)
                {
                    vendCode = ds.Tables[0].Rows[i]["VENDCD"].ToString();
                    vendName = ds.Tables[0].Rows[i]["VENDNM"].ToString();
                }
            }

            if (this.cbo01_BIZCD.Value.Equals("1001")) //울산/총무
            {
                mailTo = mailTo + "," + email;
            }

            mailData += (this.UserInfo.LanguageShort.Equals("KO") ? "\n의뢰번호 : " : "\nRequest No. : ") + pono;
            mailData += (this.UserInfo.LanguageShort.Equals("KO") ? "\n견적의뢰일자 : " : "\nRequest Date of Estimate : ") + podate;

            

            DataSet param = Util.GetDataSourceSchema
            (
               "CORCD", "BIZCD", "MAIL_TO", "MAIL_SUBJECT", "MAIL_BODY", "LANG_SET", "USERID"
            );

            param.Tables[0].Rows.Add
            (
                Util.UserInfo.CorporationCode
                , this.cbo01_BIZCD.Value
                , mailTo
                , (this.UserInfo.LanguageShort.Equals("KO") ? "[서연이화SCM] 일반구매 견적의뢰접수" : "[SCM] Receipt of Purchase request") + " (" + vendCode + ":" + vendName + ")"
                , mailData
                , this.UserInfo.LanguageShort
                , this.UserInfo.UserID
            );

            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SEND_EMAIL"), param);
            }
        }

        [DirectMethod]
        public void Estimate(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);
                if (parameter.Count() > 0)
                {
                    HEParameterSet param = new HEParameterSet();
                    param.Add("Key1", this.cdx01_VENDCD.Value);
                    param.Add("Key2", this.cbo01_BIZCD.Value);
                    param.Add("Key3", parameter[0]["MRO_PO_TYPE"].ToString());
                    param.Add("Key4", parameter[0]["QUOTATION_DATE"] == null ? string.Empty : parameter[0]["QUOTATION_DATE"].ToString());
                    param.Add("Key5", this.cdx01_VENDCD.Text.Replace(",", "&#44;").Replace(":", "&#58;"));

                    X.Js.Call("addUserTab", "SRM_MP20003", this.GetMenuUrl("SRM_MP20003"), PopupHelper.GetUrlString(param));
                }
                else
                {
                    MsgCodeAlert("SCMMP00-0007");
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
        /// Excel_Export
        /// </summary>
        private void Excel_Export()
        {
            try
            {
                DataSet result = getDataSet02();

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
        public void Cell_DoubleClick(object sender, DirectEventArgs e)
        {
            try
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", cbo01_BIZCD.Value);
                param.Add("PRNO", V_PRNO.Text);
                param.Add("PRNO_SEQ", V_PRNO_SEQ.Text);
                param.Add("SEQ", V_SEQ.Text);

                DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ATT_FILE"), param);

                //데이터가 있을 경우
                if (result.Tables[0].Rows.Count > 0)
                {
                    //Response.Clear();
                    ////Response.ContentType = "application/vnd.ms-excel"; // "Application/Octet-Stream" , application/x-msdownload
                    //Response.ContentType = "application/x-msdownload"; // "Application/Octet-Stream" , 
                    //Response.AddHeader("Content-Disposition", "attachment; filename=\"" + Server.UrlPathEncode(result.Tables[0].Rows[0]["ADD_FILENM"].ToString()) + "\"");
                    //Response.AddHeader("Content-Length", ((byte[])result.Tables[0].Rows[0]["ADD_FILE"]).Length.ToString());
                    //Response.OutputStream.Write((byte[])result.Tables[0].Rows[0]["ADD_FILE"], 0, ((byte[])result.Tables[0].Rows[0]["ADD_FILE"]).Length);
                    //Response.Flush();                    
                    Util.FileDownLoadByBlob(this.Page, (byte[])result.Tables[0].Rows[0]["ADD_FILE"], result.Tables[0].Rows[0]["ADD_FILENM"].ToString());                    
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
                this.MsgCodeAlert_ShowFormat("SCMMP00-0023", "df01_BEG_DATE", lbl01_ESMT_DATE.Text);
                return false;
            }
            else if (((DateTime)this.df01_BEG_DATE.Value) > ((DateTime)this.df01_END_DATE.Value))
            {
                this.MsgCodeAlert_ShowFormat("SCMMP00-0027", ((DateTime)this.df01_BEG_DATE.Value).ToString("yyyy-MM-dd"), ((DateTime)this.df01_END_DATE.Value).ToString("yyyy-MM-dd"));
                return false;
            }

            return true;
        }

        #endregion
    }
}
