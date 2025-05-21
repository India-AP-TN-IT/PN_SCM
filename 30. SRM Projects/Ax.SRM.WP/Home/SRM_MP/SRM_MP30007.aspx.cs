#region ▶ Description & History
/* 
 * 프로그램명 : 발주대비 납품입하실적
 * 설      명 : 
 * 최초작성자 : 손창현
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
using System.Collections.Generic;
using HE.Framework.Core.Report;

namespace Ax.SRM.WP.Home.SRM_MP
{
    public partial class SRM_MP30007 : BasePage
    {
        private string pakageName = "APG_SRM_MP30007";
        private string pakageName_transnote = "APG_SRM_MP20007";
        

        #region [ 초기설정 ]

        /// <summary>
        /// SCM_MP30007
        /// </summary>
        public SRM_MP30007()
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
        public void etc_Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;

            switch (btn.ID)
            {
                case "btn01_TRANS_PRINT":
                    //거래명세서 출력 버튼                    
                    PrintCheck(sender, e);
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
            this.cbo01_MRO_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.
            this.df01_BEG_DATE.SetValue(DateTime.Now.ToString("yyyy-MM") + "-01");
            this.df01_END_DATE.SetValue(DateTime.Now);
            
            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
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
            param.Add("SDATE", ((DateTime)this.df01_BEG_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("EDATE", ((DateTime)this.df01_END_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("MRO_PO_TYPE", cbo01_MRO_PO_TYPE.Value);
            param.Add("PONO", txt01_PONO.Value);
            param.Add("DELI_NOTE", txt01_DELI_NOTE.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
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
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);
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

        #region 거래명세서 출력
        /// <summary>
        /// 출력조건 확인
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void PrintCheck(object sender, DirectEventArgs e)
        {
            try
            {
                if (e.ExtraParams.Count.Equals(0))
                {
                    //선택된 Row가 없습니다. 확인 바랍니다.
                    this.MsgCodeAlert("COM-00100");
                    return;
                }

                Dictionary<string, string>[] grid01SelectedValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid01SelectedValues"]);


                if (grid01SelectedValues.Length.Equals(0))
                {
                    //선택된 Row가 없습니다. 확인 바랍니다.
                    this.MsgCodeAlert("COM-00100");
                    return;
                }
                //JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Values"]).Length

                string deliDate = grid01SelectedValues[0]["DELI_DATE"];
                string deliNote = grid01SelectedValues[0]["DELI_NOTE"];

                printReport(deliDate, deliNote);
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

        #region [ 전표 출력 ]

        private void printReport(string deliDate, string deliNote)
        {
            printReportE2A(deliDate, deliNote);
        }

        private DataSet getDataSetSealImage()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName_transnote, "INQUERY_SEAL_IMAGE"), param);
        }


        /// <summary>
        /// 납품전표 출력용 DATASET
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSetReport(string deliDate, string deliNote, string reportType)
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("DELI_DATE", deliDate);
            param.Add("DELI_NOTE", deliNote.Split('-')[0]);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName_transnote, "INQUERY_REPORT"), param);
        }

        /// <summary>
        /// 거래명세표 출력
        /// </summary>
        private void printReportE2A(string deliDate, string deliNote)
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MP/SRM_MP20006";

                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                //mainSection.ReportParameter.Add("DELI_DATE", deliDate);
                //mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
                //mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
                //mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);

                report.Sections.Add("MAIN", mainSection);

                DataSet ds = getDataSetReport(deliDate, deliNote, "E2A");
                DataSet sealImage = getDataSetSealImage();
                if (ds.Tables[0].Rows.Count == 0)
                {
                    //this.MsgCodeAlert_ShowFormat("COM-00022"); //출력할 대상 Data가 없습니다.
                    return;
                }
                HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                HERexSection xmlSection2 = new HERexSection(sealImage, new HEParameterSet());
                report.Sections.Add("XML", xmlSection);
                report.Sections.Add("XML2", xmlSection2);


                // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                //ds.Tables[0].TableName = "DATA";
                //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
                //sealImage.Tables[0].TableName = "DATA";
                //sealImage.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "_SEAL.xml", XmlWriteMode.WriteSchema);


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
            if (this.cdx01_VENDCD.IsEmpty && !(this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10")))
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
