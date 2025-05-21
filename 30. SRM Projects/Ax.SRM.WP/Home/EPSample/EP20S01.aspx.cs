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

using System.IO;
using System.IO.Compression;


namespace Ax.EP.WP.Home.EPSample
{
    /// <summary>
    /// <b>샘플프로그램</b>
    /// - 작 성 자 : 박의곤<br />
    /// - 작 성 일 : 2010-07-25<br />
    /// </summary>
    public partial class EP20S01 : BasePage
    {
        private string pakageName = "APG_EP20S01";

        #region [ 초기설정 ]

        /// <summary>
        /// EP20S01
        /// </summary>
        public EP20S01()
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
                    Library.GetBIZCD(this.SelectBox01_BIZCD, this.UserInfo.CorporationCode, true);
                    Library.GetBIZCD(this.SelectBox02_BIZCD, this.UserInfo.CorporationCode, false);
                    Reset();
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
        /// 기본 버튼생성
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
            MakeButton(ButtonID.Delete, ButtonImage.Delete, "Delete", this.ButtonPanel);
            MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
            MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
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
                case ButtonID.Save:
                    SaveAndDelete(Library.ActionType.Save);
                    break;
                case ButtonID.Delete:
                    SaveAndDelete(Library.ActionType.Delete);
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

        #endregion

        #region [ 기능 ]
        /// <summary>
        /// Search
        /// </summary>
        public void Search()
        {
            try
            {
                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                Reset();
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
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", SelectBox01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("PARTNO", this.cdx01_PARTNO.Value);
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

        private void Print()
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/EP/EP20S01";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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
                mainSection.ReportParameter.Add("TEST_PARAM1", "파라메터1");
                mainSection.ReportParameter.Add("TEST_PARAM2", "파라메터2");
                report.Sections.Add("MAIN", mainSection);

                // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                DataSet ds = getDataSet();

                // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                // ds.Tables[0].TableName = "DATA";
                // ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);

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
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.SelectBox02_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.SelectBox02_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cdx02_VENDCD.SetValue(cdx01_VENDCD.Value);
            this.cdx02_VINCD.SetValue(string.Empty);
            this.cdx02_PARTNO.SetValue(string.Empty);
            this.txt02_STANDARD.SetValue(string.Empty);
            this.txt02_WEIGHT.SetValue(0.00000);
            this.df02_BEG_DATE.SetValue(DateTime.Now);
            this.df02_END_DATE.SetValue(DateTime.Now);
            this.txt02_EMPNO.SetValue(string.Empty);
            this.cdx02_ITEMCD.SetValue(string.Empty);
            this.txt02_PACK_QTY.SetValue(0);
        }

        /// <summary>
        /// SaveAndDelete
        /// 저장(업데이트) 및 삭제
        /// </summary>
        /// <param name="actionType"></param>
        public void SaveAndDelete(Library.ActionType actionType)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "VENDCD", "PARTNO", "PARTNM", "VINCD", "ITEMCD", "STANDARD", "WEIGHT", "PACK_QTY"
                   , "BEG_DATE", "END_DATE", "EMPNO", "UPDATE_ID"
                );


                param.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode, this.SelectBox02_BIZCD.Value, this.cdx02_VENDCD.Value, this.cdx02_PARTNO.Value, this.cdx02_PARTNO.Text
                    , cdx02_VINCD.Value, this.cdx02_ITEMCD.Value, this.txt02_STANDARD.Value, this.txt02_WEIGHT.Text, this.txt02_PACK_QTY.Text
                    , (this.df02_BEG_DATE.IsEmpty) ? "" : ((DateTime)this.df02_BEG_DATE.Value).ToString("yyyy-MM-dd")
                    , (this.df02_END_DATE.IsEmpty) ? "" : ((DateTime)this.df02_END_DATE.Value).ToString("yyyy-MM-dd")
                    , txt02_EMPNO.Value, this.UserInfo.UserID
                );

                //유효성 검사
                if (!Validation(param.Tables[0].Rows[0], actionType))
                {
                    return;
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, actionType == Library.ActionType.Save ? "SAVE" : "REMOVE"), param);
                    this.MsgCodeAlert(actionType == Library.ActionType.Save ? "EP20S01_001" : "EP20S01_002");
                    Search();
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
        /// RowSelect
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RowSelect(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, object>[] parameters = JSON.Deserialize<Dictionary<string, object>[]>(json);

                if (parameters.Length > 0)
                {
                    this.SelectBox02_BIZCD.SetValue(parameters[0]["BIZCD"]);
                    this.cdx02_VENDCD.SetValue(parameters[0]["VENDCD"]);
                    this.cdx02_VINCD.SetValue(parameters[0]["VINCD"]);
                    this.cdx02_PARTNO.SetValue(parameters[0]["PARTNO"]);
                    this.txt02_STANDARD.SetValue(parameters[0]["STANDARD"]);
                    this.txt02_WEIGHT.SetValue(parameters[0]["WEIGHT"]);
                    this.df02_BEG_DATE.SetValue(parameters[0]["BEG_DATE"]);
                    this.df02_END_DATE.SetValue(parameters[0]["END_DATE"]);
                    this.txt02_EMPNO.SetValue(parameters[0]["EMPNO"]);
                    this.cdx02_ITEMCD.SetValue(parameters[0]["ITEMCD"]);
                    this.txt02_PACK_QTY.SetValue(parameters[0]["PACK_QTY"]);
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
        /// <param name="parameter"></param>
        /// <param name="actionType"></param>
        /// <param name="actionRow"></param>
        /// <remarks>actionRow 는 Grid 타일경우에만 사용한다.</remarks>
        /// <returns>bool</returns>
        public bool Validation(DataRow parameter, Library.ActionType actionType, int actionRow = -1)
        {
            bool result = false;

            

            // 저장용 Validation
            if (actionType == Library.ActionType.Save)
            {
                if (String.IsNullOrEmpty(parameter["BEG_DATE"].ToString()) || parameter["BEG_DATE"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "df02_BEG_DATE", lbl02_START_END_DATE.Text);

                if (String.IsNullOrEmpty(parameter["END_DATE"].ToString()) || parameter["END_DATE"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "df02_END_DATE", lbl02_START_END_DATE.Text);

                else if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx02_VENDCD", lbl02_VENDCD.Text);

                else if (String.IsNullOrEmpty(parameter["PARTNO"].ToString()) || parameter["PARTNO"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx02_PARTNO", lbl02_PARTNO.Text);

                else if (String.IsNullOrEmpty(parameter["VINCD"].ToString()) || parameter["VINCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx02_VINCD", lbl02_VINCD.Text);

                else if (String.IsNullOrEmpty(parameter["ITEMCD"].ToString()) || parameter["ITEMCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx02_ITEMCD", lbl02_ITEMCD.Text);

                else if (String.IsNullOrEmpty(parameter["STANDARD"].ToString()) || parameter["STANDARD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt02_STANDARD", lbl02_STANDARD.Text);

                else if (String.IsNullOrEmpty(parameter["WEIGHT"].ToString()) || parameter["WEIGHT"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt02_WEIGHT", lbl02_WEIGHT.Text);

                else if (String.IsNullOrEmpty(parameter["PACK_QTY"].ToString()) || parameter["PACK_QTY"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt02_PACK_QTY", lbl02_PACK_QTY.Text);

                else if (String.IsNullOrEmpty(parameter["EMPNO"].ToString()) || parameter["EMPNO"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt02_EMPNO", lbl02_EMPNO3.Text);

                else
                    result = true;

            }
            // 삭제용 Validation
            else if (actionType == Library.ActionType.Delete)
            {
                if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx02_VENDCD", lbl02_VENDCD.Text);

                else if (String.IsNullOrEmpty(parameter["PARTNO"].ToString()) || parameter["PARTNO"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx02_PARTNO", lbl02_PARTNO.Text);

                else
                    result = true;
            }
            // 처리용 Validation
            else if (actionType == Library.ActionType.Process)
            {
                result = true;
            }
            // 조회용 Validation
            else
            {
                result = true;
            }

            return result;
        }

        #endregion
    }
}
