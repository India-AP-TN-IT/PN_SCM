/* 
 * 프로그램명 : Claim 통보서 조회     [D2](구.VQ3040)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-10
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
 *				
 *
 * 
*/
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

namespace HE.MP.WP.Home.SRM_QA
{
    public partial class SRM_QA31001 : BasePage
    {
        private string pakageName = "APG_SRM_QA31001";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA31001
        /// </summary>
        public SRM_QA31001()
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
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, true);
                    SetCombo();

                    Reset();

                    // 코드 팝업을 띄우기 위해서 text에서 enter를 입력할 경우 팝업을 띄움, 현재는 aspx단에서 keymap으로 코딩되어있음.
                    //Util.SettingEnterKeyEvent(this, this.cdx01_PARTNO, this.btn01_PARTNO);
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

            if (id.Equals(ButtonID.ExcelDL))
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            }
            else if(id.Equals(ButtonID.Print))
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            }
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
                    Print(sender, e);
                    break;
                case ButtonID.ExcelDL:
                    Excel_Export(sender, e);
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
                if (!Validation(Library.ActionType.Search))
                    return;

                if (cbo01_ClAIM.Value.Equals("FUFD"))
                {
                    DataSet result = getDataSet();
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
                }
                else
                {
                    DataSet result = getDataSet02();
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
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
        private void Print(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] gridParam = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (gridParam.Count() == 0)
                {
                    this.MsgCodeAlert("SRMQA00-0047");
                    return;
                }

                this.txt01_CLAIM_OCCUR_DIV.Text = gridParam[0]["CLAIM_OCCUR_DIV"].ToString();
                this.txt01_CUST_DOCRPTNO.Text = gridParam[0]["CUST_DOCRPTNO"].ToString();

                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);

                if (this.txt01_CLAIM_OCCUR_DIV.Text.Equals("FUFD"))
                    report.ReportName = "1000/SRM_QA/SRM_QA31001_FE";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함
                else
                    report.ReportName = "1000/SRM_QA/SRM_QA31001_HE";
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
                DataSet ds = getReportDataSet(this.txt01_CLAIM_OCCUR_DIV.Text, this.txt01_CUST_DOCRPTNO.Text);

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
        private DataSet getReportDataSet(string CLAIM_OCCUR_DIV, string CUST_DOCRPTNO)
        {
            HEParameterSet param = new HEParameterSet();

            if (CLAIM_OCCUR_DIV.Equals("FUFD"))
            {
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.Value);
                param.Add("PROC_DATE", ((DateTime)this.df01_STD_YYMM.Value).ToString("yyyy-MM"));
                param.Add("CLAIM_OCCUR_DIV", CLAIM_OCCUR_DIV);
                param.Add("CUST_DOCRPTNO", "");
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("USER_ID", this.UserInfo.UserID);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);
            }
            else
            {
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.Value);
                param.Add("PROC_DATE", ((DateTime)this.df01_STD_YYMM.Value).ToString("yyyy-MM"));
                param.Add("CLAIM_OCCUR_DIV", CLAIM_OCCUR_DIV);
                param.Add("CUST_DOCRPTNO", CUST_DOCRPTNO);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("USER_ID", this.UserInfo.UserID);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);
            }
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT"), param);
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
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("PROC_DATE", ((DateTime)this.df01_STD_YYMM.Value).ToString("yyyy-MM"));
            param.Add("CLAIM_OCCUR_DIV", this.cbo01_ClAIM.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
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
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("PROC_DATE", ((DateTime)this.df01_STD_YYMM.Value).ToString("yyyy-MM"));
            param.Add("CLAIM_OCCUR_DIV", this.cbo01_ClAIM.Value);
            param.Add("OCCUR_DIV", this.cbo01_OCCUR.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SECOND"), param);
        }

        /// <summary>
        /// Excel_Export
        /// </summary>
        private void Excel_Export(object sender, DirectEventArgs e)
        {
            try
            {
                if (!Validation(Library.ActionType.Search))
                    return;

                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] gridParam = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (gridParam.Count() == 0)
                {
                    this.MsgCodeAlert("SRMQA00-0044");
                    return;
                }

                if (gridParam.Count() == 1)
                {
                    if (gridParam[0]["CLAIM_OCCUR_DIV"].Equals("FUFD"))
                    {
                        HEParameterSet param = new HEParameterSet();
                        param.Add("CORCD", gridParam[0]["CORCD"]);
                        param.Add("BIZCD", gridParam[0]["BIZCD"]);
                        param.Add("VENDCD", this.cdx01_VENDCD.Value);
                        param.Add("PROC_DATE", gridParam[0]["PROC_DATE"]);
                        param.Add("USER_ID", this.UserInfo.UserID);
                        param.Add("LANG_SET", this.UserInfo.LanguageShort);

                        DataSet result = null;

                        result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_EXCEL"), param);

                        if (result == null) return;

                        if (result.Tables[0].Rows.Count == 0)
                            this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                        else
                        {
                            ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid02);
                        }
                    }
                    else
                    {
                        HEParameterSet param = new HEParameterSet();
                        param.Add("CORCD", gridParam[0]["CORCD"]);
                        param.Add("BIZCD", gridParam[0]["BIZCD"]);
                        param.Add("VENDCD", this.cdx01_VENDCD.Value);
                        param.Add("PROC_DATE", gridParam[0]["PROC_DATE"]);
                        param.Add("CLAIM_OCCUR_DIV", gridParam[0]["CLAIM_OCCUR_DIV"]);
                        param.Add("OCCUR_DIV", this.cbo01_OCCUR.Value);
                        param.Add("OCCURNO", gridParam[0]["DOCRPTNO"]);
                        param.Add("USER_ID", this.UserInfo.UserID);
                        param.Add("LANG_SET", this.UserInfo.LanguageShort);

                        DataSet result = null;

                        result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_EXCEL02"), param);

                        if (result == null) return;

                        if (result.Tables[0].Rows.Count == 0)
                            this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                        else
                        {
                            ExcelHelper.ExportExcel(this.Page, result.Tables[0]);
                        }
                    }
                }
                else
                {
                    this.MsgCodeAlert("SRMQA00-0044");
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
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_ClAIM.SelectedItem.Value = "FUFD";
            this.cbo01_ClAIM.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_OCCUR.Value = "IZINMIP";
            this.cbo01_OCCUR.UpdateSelectedItems(); //꼭 해줘야한다.
            this.df01_STD_YYMM.SetValue(DateTime.Now.ToString("yyyy-MM"));

            this.cbo01_OCCUR.Hidden = true;
            this.lbl02_OCCUR_DIV.Hidden = true;
            this.GridPanel.Show();
            this.GridPanel02.Hide();

            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }
            Store1.RemoveAll();
            Store4.RemoveAll();
        }

        /// <summary>
        /// 콤보상자 바인딩(발생구분, 발생구분2)
        /// </summary>
        private void SetCombo()
        {
            //발생구분
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("COLUMN_ID", "CLAIM_OCCUR_DIV");
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CLAIM_OCCUR_DIV"), param);

            Library.ComboDataBind(this.cbo01_ClAIM, ds.Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);

            HEParameterSet param2 = new HEParameterSet();
            param2.Add("CORCD", Util.UserInfo.CorporationCode);
            param2.Add("BIZCD", Util.UserInfo.BusinessCode);
            param2.Add("USER_ID", Util.UserInfo.UserID);
            param2.Add("LANG_SET", Util.UserInfo.LanguageShort);

            //발생구분2         
            DataSet ds2 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_OCCUR_DIV"), param2);

            Library.ComboDataBind(this.cbo01_OCCUR, ds2.Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);
        }

        #endregion

        #region [ 이벤트 ]

        //발생구분 선택
        protected void cbo01_QUOT_CNT_Change(object sender, DirectEventArgs e)
        {
            if (cbo01_ClAIM.Value.Equals("FUFD"))
            {
                this.lbl02_OCCUR_DIV.Hidden = true;
                this.cbo01_OCCUR.Hidden = true;
            }
            else if (cbo01_ClAIM.Value.Equals("FUHA"))
            {
                this.lbl02_OCCUR_DIV.Hidden = false;
                this.cbo01_OCCUR.Hidden = false;
            }
        }

        #endregion

        #region [함수]

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
        public bool Validation(Library.ActionType actionType)
        {
            bool result = false;

            // 저장용 Validation
            if (actionType == Library.ActionType.Save)
            {
                result = true;
            }
            // 처리용 Validation
            else if (actionType == Library.ActionType.Process)
            {
                result = true;
            }
            // 조회용 Validation
            else if (actionType == Library.ActionType.Search)
            {
                if (String.IsNullOrEmpty(this.cdx01_VENDCD.Value.ToString()) || this.cdx01_VENDCD.Value.ToString().Equals(""))
                {
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0002");
                }
                else if (this.df01_STD_YYMM.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "lbl01_STD_YYMM", lbl01_STD_YYMM.Text);
                }
                else
                    result = true;
            }
            else if (actionType == Library.ActionType.ExcelDL)
            {
                if (String.IsNullOrEmpty(this.cdx01_VENDCD.Value.ToString()) || this.cdx01_VENDCD.Value.ToString().Equals(""))
                {
                    this.MsgCodeAlert_ShowFormat("SRMMP00-0002");
                }
                else if (this.df01_STD_YYMM.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "lbl01_STD_YYMM", lbl01_STD_YYMM.Text);
                }
                else
                    result = true;
            }

            return result;
        }

        #endregion
    }
}
