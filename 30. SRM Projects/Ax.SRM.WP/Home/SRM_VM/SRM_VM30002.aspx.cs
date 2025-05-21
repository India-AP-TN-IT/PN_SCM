#region ▶ Description & History
/* 
 * 프로그램명 : 업체정보 종합 조회
 * 설      명 : 협력업체 > 업체정보 관리 > 업체정보 종합 조회
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-07
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

namespace Ax.SRM.WP.Home.SRM_VM
{
    public partial class SRM_VM30002 : BasePage
    {
        private string pakageName = "APG_SRM_VM30002";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_VM30002
        /// </summary>
        public SRM_VM30002()
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
                    
                    Library.ComboDataBind(this.cbo01_SQ_CATEGORY, Library.GetTypeCode("VC").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);

                    //유형코드
                    DataSet source = Library.GetTypeCode("VB");

                    //업체차수 콤보바인딩
                    source.Tables[0].DefaultView.RowFilter = "GROUPCD='1'";
                    source.Tables[0].DefaultView.Sort = "SORT_SEQ";
                    Library.ComboDataBind(this.cbo01_VEND_TIER, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select"); //업체차수


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
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Down, ButtonImage.Down, "Down", this.ButtonPanel);
            MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
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
            if (id.Equals(ButtonID.Down)) //체크된 행의 파일만 다운로드 한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            }
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
                case ButtonID.Down:
                    FileDown(sender, e);
                    break;
                case ButtonID.ExcelDL:
                    Excel_Export();
                    break;
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
                case "ButtonExcel":
                    Excel_Export2(e);
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


                this.Store2.RemoveAll();
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

            this.cbo01_SQ_CATEGORY.SelectedItem.Value = "";
            this.cbo01_SQ_CATEGORY.UpdateSelectedItems(); //꼭 해줘야한다.

            this.txt01_VENDNM.Text = string.Empty;

            this.Store1.RemoveAll();
            this.Store2.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();

            //param.Add("DELI_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("VENDNM", this.txt01_VENDNM.Text);
            param.Add("SQ_CATEGORY", this.cbo01_SQ_CATEGORY.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("VEND_TIER", this.cbo01_VEND_TIER.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        private DataSet getDataSetDetail(string vendcd)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("VENDCD", vendcd);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_DETAIL"), param);
        }


        /// <summary>
        /// 선택된 파일 다운로드
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void FileDown(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    this.MsgCodeAlert("COM-00021");
                    return;
                }

                ArrayList arr = new ArrayList();
                for (int i = 0; i < parameters.Length; i++)
                {
                    if (bool.Parse(parameters[i]["CHECK_VALUE"]))
                    {
                        if (!parameters[i]["CREDIT_EVAL_FILE"].Equals(""))                        
                            arr.Add(parameters[i]["CREDIT_EVAL_FILE"]);
                        
                    }
                    if (bool.Parse(parameters[i]["CHECK_VALUE2"]))
                    {
                        if (!parameters[i]["SQ_CERTI_FILE"].Equals(""))
                            arr.Add(parameters[i]["SQ_CERTI_FILE"]);
                    }
                    

                    //if (bool.Parse(parameters[i]["CHECK_VALUE"]))
                    //{
                    //    if (!parameters[i]["CREDIT_EVAL_FILE"].ToArray().Equals(""))                            
                    //        X.Js.Call("FileDirectDownloadByFileID(document, '" + parameters[i]["CREDIT_EVAL_FILE"] + "')");
                    //}
                    //if (bool.Parse(parameters[i]["CHECK_VALUE2"]))
                    //{
                    //    if (!parameters[i]["SQ_CERTI_FILE"].ToArray().Equals(""))
                    //        X.Js.Call("FileDirectDownloadByFileID(document, '" + parameters[i]["SQ_CERTI_FILE"] + "')");
                    //}
                }
                if (arr.Count > 0)
                {
                    string str = "";
                    for (int i = 0; i < arr.Count; i++)
                    {
                        str += arr[i].ToString()+",";
                    }
                    X.Js.Call("MultiFileDirectDownloadByFileID(document, '" + str.Substring(0,str.Length-1) + "')");
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
        /// Print
        /// </summary>
        [DirectMethod]
        public void Print()
        {
            //if (!this.IsQueryValidation()) return;

            HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
            report.ReportName = "1000/SRM_VM/SRM_VM20001";

            // Main Section ( 메인리포트 파라메터셋 )
            HERexSection mainSection = new HERexSection();
            mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
            mainSection.ReportParameter.Add("STD_YEAR", this.hidASRM2090_STD_YEAR.Value);
            mainSection.ReportParameter.Add("ASRM2160_STD_YEAR", this.hidASRM2160_STD_YEAR.Value);
            mainSection.ReportParameter.Add("ASRM2100_STD_YEAR", this.hidASRM2100_STD_YEAR.Value);

            report.Sections.Add("MAIN", mainSection);

            // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
            DataSet ds = this.getDataSetReport();

            if (ds.Tables[0].Rows.Count <= 0)
            {
                this.MsgCodeAlert_ShowFormat("COM-00022");
                return;
            }
            DataSet source = this.getFinancialDataSetReport();
            DataSet ds1 = new DataSet();
            DataSet ds2 = new DataSet();
            DataSet ds3 = new DataSet();
            DataSet ds4 = new DataSet();
            DataSet ds5 = new DataSet();
            DataSet ds6 = new DataSet();
            ds1.Tables.Add(source.Tables[0].Copy());
            ds2.Tables.Add(source.Tables[1].Copy());
            ds3.Tables.Add(ds.Tables[1].Copy());
            ds4.Tables.Add(ds.Tables[2].Copy());
            ds5.Tables.Add(ds.Tables[3].Copy());
            ds6.Tables.Add(ds.Tables[4].Copy());

            //// DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
            //// 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
            //ds.Tables[0].TableName = "DATA";
            //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
            //ds1.Tables[0].TableName = "DATA";
            //ds1.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "01.xml", XmlWriteMode.WriteSchema);
            //ds2.Tables[0].TableName = "DATA";
            //ds2.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "02.xml", XmlWriteMode.WriteSchema);
            //ds3.Tables[0].TableName = "DATA";
            //ds3.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "03.xml", XmlWriteMode.WriteSchema);
            //ds4.Tables[0].TableName = "DATA";
            //ds4.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "04.xml", XmlWriteMode.WriteSchema);
            //ds5.Tables[0].TableName = "DATA";
            //ds5.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "05.xml", XmlWriteMode.WriteSchema);
            //ds6.Tables[0].TableName = "DATA";
            //ds6.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "06.xml", XmlWriteMode.WriteSchema);

            HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
            HERexSection xmlSectionSub1 = new HERexSection(ds1, new HEParameterSet());
            HERexSection xmlSectionSub2 = new HERexSection(ds2, new HEParameterSet());
            HERexSection xmlSectionSub3 = new HERexSection(ds3, new HEParameterSet());
            HERexSection xmlSectionSub4 = new HERexSection(ds4, new HEParameterSet());
            HERexSection xmlSectionSub5 = new HERexSection(ds5, new HEParameterSet());
            HERexSection xmlSectionSub6 = new HERexSection(ds6, new HEParameterSet());

            // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
            // xmlSection.ReportParameter.Add("CORCD", "1000");
            report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
            report.Sections.Add("XML1", xmlSectionSub1);
            report.Sections.Add("XML2", xmlSectionSub2);
            report.Sections.Add("XML3", xmlSectionSub3);
            report.Sections.Add("XML4", xmlSectionSub4);
            report.Sections.Add("XML5", xmlSectionSub5);
            report.Sections.Add("XML6", xmlSectionSub6);

            AxReportForm.ShowReport(report);

        }
        /// <summary>
        /// 협력업체 정보 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSetReport()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.hidVENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("ASRM2160_STD_YEAR", this.hidASRM2160_STD_YEAR.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_VM20001", "INQUERY_REPORT"), param, new string[] { "OUT_CURSOR", "OUT_CURSOR_ASRM2130", "OUT_CURSOR_ASRM2140", "OUT_CURSOR_ASRM2150", "OUT_CURSOR_ASRM2160" });
        }

        /// <summary>
        /// 년도별 재무제표정보 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getFinancialDataSetReport()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.hidVENDCD.Value);
            param.Add("STD_YEAR", this.hidASRM2090_STD_YEAR.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("ASRM2100_STD_YEAR", this.hidASRM2100_STD_YEAR.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_VM20001", "INQUERY_FINANCIAL_REPORT"), param, new string[] { "OUT_CURSOR", "OUT_CURSOR_PURCHASE" });
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
        /// Excel_Export
        /// </summary>
        private void Excel_Export2(DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00807");// 출력 또는 내보낼 데이터가 없습니다. 
                    return;
                }

                DataSet result = getDataSetDetail(parameter[0]["VENDCD"]);

                if (result == null) return;

                if (result.Tables[0].Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                {
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid02);
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
            return true;
        }

        #endregion

        #region [ 이벤트 ]

        [DirectMethod]
        public void Cell_DoubleClick(string vendcd, string ASRM2090_STD_YEAR, string ASRM2100_STD_YEAR, string ASRM2160_STD_YEAR)
        {
            this.hidVENDCD.SetValue(vendcd);
          
            this.hidASRM2090_STD_YEAR.SetValue(ASRM2090_STD_YEAR);
            this.hidASRM2100_STD_YEAR.SetValue(ASRM2100_STD_YEAR);
            this.hidASRM2160_STD_YEAR.SetValue(ASRM2160_STD_YEAR);

            DataSet source = getDataSetDetail(vendcd);

            this.Store2.DataSource = source.Tables[0];
            this.Store2.DataBind();
        }

        #endregion
    }
}
