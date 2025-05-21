/* 
 * 프로그램명 : 견적서 작성
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
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using HE.Framework.Core.Report;

namespace Ax.SRM.WP.Home.SRM_MP
{
    public partial class SRM_MP20003 : BasePage
    {
        private string pakageName = "APG_SRM_MP20003";
        private string _QUOT_CNT = "";
        private bool initStr = true;

        #region [ 초기설정 ]

        /// <summary>
        /// SCM_MP20003
        /// </summary>
        public SRM_MP20003()
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
                    initStr = false;
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);
                    Library.ComboDataBind(this.cbo01_MRO_PO_TYPE, Library.GetTypeCode("1J").Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);
                    
                    //Reset();
                    ComponentReset();

                    SetCombo();

                    //견적의뢰접수에서 데이터 넘어왔을경우에 조회를 함.
                    string vendcd = HttpUtility.ParseQueryString(Request.Url.Query).Get("Key1");
                    if (vendcd != null && vendcd != "")
                    {
                        string bizcd = HttpUtility.ParseQueryString(Request.Url.Query).Get("Key2");
                        string mro_po_type = HttpUtility.ParseQueryString(Request.Url.Query).Get("Key3");
                        string quot_date = HttpUtility.ParseQueryString(Request.Url.Query).Get("Key4");
                        string vendnm = HttpUtility.ParseQueryString(Request.Url.Query).Get("Key5");

                        this.cdx01_VENDCD.Value = vendcd;
                        this.cdx01_VENDCD.Text = vendnm;
                        this.cbo01_BIZCD.SelectedItem.Value = bizcd;
                        this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
                        this.cbo01_MRO_PO_TYPE.SelectedItem.Value = mro_po_type;
                        this.cbo01_MRO_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

                        this.df01_ETMT_DATE.SetValue(quot_date);

                        HEParameterSet param = new HEParameterSet();
                        param.Add("CORCD", Util.UserInfo.CorporationCode);
                        param.Add("BIZCD", bizcd);
                        param.Add("VENDCD", vendcd);
                        param.Add("MRO_PO_TYPE", mro_po_type);
                        param.Add("QUOTATION_DATE", quot_date);
                        param.Add("USER_ID", Util.UserInfo.UserID);
                        param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                        //조회
                        PopupSearch(param);
                        initStr = true;
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
            //MakeButton(ButtonID.Present, ButtonImage.Present, "Present", this.ButtonPanel);
            //MakeButton(ButtonID.PresentCancle, ButtonImage.PresentCancle, "PresentCancle", this.ButtonPanel);
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
            if (id.Equals(ButtonID.Save)) //저장시 수정된 데이터만 저장한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues()", Mode = ParameterMode.Raw, Encode = true });
            }
            //else if (id.Equals(ButtonID.Present)) // 제출 시 선택된 데이터만 제출한다.
            //{
            //    ibtn.DirectEvents.Click.ExtraParams.Add(
            //    new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            //}
            //else if (id.Equals(ButtonID.PresentCancle)) // 제출 취소시 선택된 데이터만 취소한다.
            //{
            //    ibtn.DirectEvents.Click.ExtraParams.Add(
            //    new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
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
                case ButtonID.Save:
                    Save(sender, e);
                    break;
                //case ButtonID.Present:
                //    Present(sender, e);
                //    break;
                //case ButtonID.PresentCancle:
                //    PresentCancle(sender, e);
                //    break;
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
        public void etc_Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_POP_MP20003P1":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    HEParameterSet set = new HEParameterSet();
                    set.Add("VENDCD", V_VENDCD.Value);

                    try
                    {
                        if (V_VENDCD.Value.Equals(""))
                        {
                            this.MsgCodeAlert_ShowFormat("SCMMP00-0024", "cdx01_VENDCD", lbl01_VEND.Text);
                            return;
                        }
                    }
                    catch
                    {
                        this.MsgCodeAlert_ShowFormat("SCMMP00-0024", "cdx01_VENDCD", lbl01_VEND.Text);
                        return;
                    }

                    Util.UserPopup((BasePage)this.Form.Parent.Page, this.UserHelpURL.Text, set, "HELP_MP20003P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
                    break;

                case "btn01_POP_MP20003P2":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    HEParameterSet param = new HEParameterSet();
                    param.Add("ATT_FILENM", V_ATT_FILENM.Value == null || V_ATT_FILENM.Value.ToString() == "" ? "N" : "Y");
                    param.Add("BIZCD", V_BIZCD.Value);
                    param.Add("PRNO", V_PRNO.Value);
                    param.Add("PRNO_SEQ", V_PRNO_SEQ.Value);
                    param.Add("SEQ", V_SEQ.Value);

                    Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MP/SRM_MP20003P2.aspx", param, "HELP_MP20003P2", "Popup", 760, 200);
                    break;

                case "btn01_PRESENT":
                    //제출
                    Present(sender, e);
                    break;

                case "btn01_PRESENT_CANCLE":
                    //제출취소
                    PresentCancle(sender, e);
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
                cbo01_QUOT_CNT_Change(null, null);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        //의뢰접수에서 작성버튼 누를시 조회돼는(팝업조회)
        public void PopupSearch(HEParameterSet param)
        {
            //this.Store1.RemoveAll();
            DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_THIRD"), param);
            this.Store1.DataSource = result.Tables[0];
            this.Store1.DataBind();

            SetCombo();

            this.cbo01_QUOT_CNT.Editable = false;
            this.D_CHECK.Editable = true;
            X.Js.Call("checkBoxControl", true, false);
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
            param.Add("MRO_PO_TYPE", this.cbo01_MRO_PO_TYPE.Value);
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
            param.Add("MRO_PO_TYPE", this.cbo01_MRO_PO_TYPE.Value);
            param.Add("QUWT_DATE", ((DateTime)this.df01_ETMT_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("QUOT_CNT", this.cbo01_QUOT_CNT.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SECOND"), param);
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
            param.Add("MRO_PO_TYPE", this.cbo01_MRO_PO_TYPE.Value);
            param.Add("QUWT_DATE", ((DateTime)this.df01_ETMT_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("QUOT_CNT", this.cbo01_QUOT_CNT.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT"), param);
        }
        
        /// <summary>
        /// Print
        /// </summary>
        private void Print()
        {
            try
            {
                if (cbo01_QUOT_CNT.Value.Equals("0"))
                {
                    //수정 모드에서만 출력이 가능합니다. 견적차수를 확인하세요!
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0026");
                    return;
                }

                //출력만 하고 제출을 하지 않는 경우가 많아서 확인 메시지 추가함. 2013-05-30
                //견적서 제출을 반드시 해주시기 바랍니다!
                this.MsgCodeAlert_ShowFormat("SCMMP00-0025");

                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MP/SRM_MP20003";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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
                DataSet result = null;

                if (cbo01_QUOT_CNT.Value.Equals("0") || cbo01_QUOT_CNT.Value.Equals(""))
                {
                    Store1.RemoveAll();
                    SetCombo();
                    result = getDataSet();
                }
                else if (!_QUOT_CNT.Equals("0"))
                {
                    Store1.RemoveAll();
                    result = getDataSet02();
                }                

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

                DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_MP20002", "INQUERY_ATT_FILE"), param);

                //데이터가 있을 경우
                if (result.Tables[0].Rows.Count > 0)
                {
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

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            ComponentReset();
            GridReset();
            
        }

        private void ComponentReset()
        {
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_MRO_PO_TYPE.SelectedItem.Value = "1JK1";
            this.cbo01_MRO_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_QUOT_CNT.SelectedItem.Value = "0";
            this.cbo01_QUOT_CNT.UpdateSelectedItems(); //꼭 해줘야한다.
            this.df01_ETMT_DATE.SetValue(DateTime.Now);

            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }
        }

        private void GridReset()
        {
            Store1.RemoveAll();
        }

        /// <summary>
        /// SaveAndDelete
        /// 저장
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                int count = 0; 

                for (int i = 0; i < parameter.Length; i++)
                {
                    if (Convert.ToBoolean(parameter[i]["CHECK_VALUE"]) == true)
                    {
                        count++;        
                    }
                }

                if (count == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                if (cbo01_QUOT_CNT.Value.Equals("0")) //신규저장시
                {
                    //차수생성(오늘일자 기준.. 화면에서 this.df01_ETMT_DATE.Value 넘겨주지만 쿼리내에서는 사용하지 않음.)
                    HEParameterSet param = new HEParameterSet();
                    param.Add("CORCD", Util.UserInfo.CorporationCode);
                    param.Add("BIZCD", this.cbo01_BIZCD.Value);
                    param.Add("VENDCD", this.cdx01_VENDCD.Value);
                    param.Add("MRO_PO_TYPE", this.cbo01_MRO_PO_TYPE.Value);
                    param.Add("QUWT_DATE", ((DateTime)this.df01_ETMT_DATE.Value).ToString("yyyy-MM-dd"));//의미 없음.
                    param.Add("USER_ID", Util.UserInfo.UserID);
                    param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                    DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_NEXTCHASU"), param);

                    DataSet param02 = Util.GetDataSourceSchema
                    (
                        "CORCD", "BIZCD", "PRNO", "PRNO_SEQ", "SEQ",
                        "VENDCD", "PARTNO", "PARTNM", "STANDARD", "MAKER",
                        "UNIT", "QUOT_QTY", "QUOT_UCOST", "ATT_FILENM", "DELI_DATE",
                        "REMARK", "QUOT_DUTY", "QUOT_TEL", "MRO_PO_TYPE", "QUOT_CNT",
                        "QUOT_NO", "USERID", "CNT"
                    );

                    int rIdx = 0;
                    for (int i = 0; i < parameter.Length; i++)
                    {
                        if (Convert.ToBoolean(parameter[i]["CHECK_VALUE"]) == true)
                        {
                            string flag = "false";
                            if (parameter[i]["QUOT_NO"] != null && !parameter[i]["QUOT_NO"].ToString().Equals(""))
                            {
                                flag = parameter[i]["QUOT_NO"];
                            }

                            string quot_no = "N";
                            if (flag.Equals("true"))
                            {
                                quot_no = "Y";
                            }

                            param02.Tables[0].Rows.Add(
                                 Util.UserInfo.CorporationCode, 
                                 this.cbo01_BIZCD.Value, 
                                 parameter[i]["PRNO"], 
                                 parameter[i]["PRNO_SEQ"], 
                                 parameter[i]["SEQ"],
                                 this.cdx01_VENDCD.Value, 
                                 parameter[i]["PARTNO"], 
                                 parameter[i]["PARTNM"], 
                                 parameter[i]["STANDARD"], 
                                 parameter[i]["MAKER"],
                                 parameter[i]["UNIT"], 
                                 parameter[i]["QTY"], 
                                 parameter[i]["QUOT_UCOST"], 
                                 "",
                                 (parameter[i]["QUOT_DELI_DATE"] == null || string.IsNullOrEmpty(parameter[i]["QUOT_DELI_DATE"].ToString())) ? string.Empty : DateTime.Parse(parameter[i]["QUOT_DELI_DATE"]).ToString("yyyy-MM-dd"),
                                 parameter[i]["REMARK"], 
                                 parameter[i]["QUOT_MGR_NAME"], 
                                 parameter[i]["QUOT_MGR_TELNO"], 
                                 parameter[i]["MRO_PO_TYPE"], 
                                 result.Tables[0].Rows[0][0].ToString(),
                                 quot_no, 
                                 Util.UserInfo.UserID, 
                                 "0"
                            );

                            //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                            if (!Validation(param02.Tables[0].Rows[rIdx], Library.ActionType.Save, Convert.ToInt32(parameter[i]["NO"])))
                            {
                                return;
                            }
                            rIdx++;
                        }
                    }

                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param02);
                        this.MsgCodeAlert("COM-00902");

                        //2015.06.02
                        //조회조건인 견적작성일과 관계없이 오늘일자로 견적데이터 등록됨.
                        //(신규 저장시 : QUWT_DATE 는 오늘일자, QUOT_CNT는 오늘일자 기준으로 최종차수로 저장되도록.)
                        //그러므로 저장 후, 오늘일자의 최종 차수로 조회조건 셋팅하고 재조회하도록 함.
                        this.df01_ETMT_DATE.SuspendEvents();        //change이벤트 발생하지 않도록 죽임.
                        this.df01_ETMT_DATE.SetValue(DateTime.Now); //added 오늘 날짜로 표시함.
                        this.df01_ETMT_DATE.ResumeEvents();         //값 설정후 change이벤트 발생가능하도록 다시 살림
                                                                    //억지로 이벤트 죽였다가 살리는 이유 : 
                                                                    //  기존값이 오늘일자가 아니었을 때, 오늘일자로 값 변경하면 아래 로직과는 별개로 new차수가 선택되어 버림
                                                                    //  (client에서 이벤트 타고 다시 처리됨)
                        _QUOT_CNT = result.Tables[0].Rows[0][0].ToString();
                        SetCombo(_QUOT_CNT);
                        cbo01_QUOT_CNT_Change(null, null);
                    }
                }
                else if (!cbo01_QUOT_CNT.Value.Equals("0"))
                {
                    DataSet param02 = Util.GetDataSourceSchema
                    (
                        "CORCD", "BIZCD", "PRNO", "PRNO_SEQ", "SEQ",
                        "VENDCD", "PARTNO", "PARTNM", "STANDARD", "MAKER",
                        "UNIT", "QUOT_QTY", "QUOT_UCOST", "ATT_FILENM", "DELI_DATE",
                        "REMARK", "QUOT_DUTY", "QUOT_TEL", "MRO_PO_TYPE", "QUOT_CNT",
                        "QUOT_NO", "USERID", "CNT"
                    );

                    int rIdx = 0;
                    for (int i = 0; i < parameter.Length; i++)
                    {
                        //견적상태 1L (A:접수대기/B:접수완료/C:작성완료/D:제출완료/E:견적승인)
                        string quot = Convert.ToString(parameter[i]["QUOT_TYPE"]).Trim();

                        if (Convert.ToBoolean(parameter[i]["CHECK_VALUE"]) == true && (quot.Equals("1LB") || quot.Equals("1LC")))
                        {
                            string flag = "false";
                            if (parameter[i]["QUOT_NO"] != null && !parameter[i]["QUOT_NO"].ToString().Equals(""))
                            {
                                flag = parameter[i]["QUOT_NO"];
                            }

                            string quot_no = "N";
                            if (flag.Equals("true"))
                            {
                                quot_no = "Y";
                            }

                            param02.Tables[0].Rows.Add(
                                 Util.UserInfo.CorporationCode, 
                                 this.cbo01_BIZCD.Value, 
                                 parameter[i]["PRNO"], 
                                 parameter[i]["PRNO_SEQ"], 
                                 parameter[i]["SEQ"],
                                 this.cdx01_VENDCD.Value, 
                                 parameter[i]["PARTNO"], 
                                 parameter[i]["PARTNM"], 
                                 parameter[i]["STANDARD"], 
                                 parameter[i]["MAKER"],
                                 parameter[i]["UNIT"], 
                                 parameter[i]["QTY"], 
                                 parameter[i]["QUOT_UCOST"], 
                                 "",
                                 (parameter[i]["QUOT_DELI_DATE"] == null || string.IsNullOrEmpty(parameter[i]["QUOT_DELI_DATE"].ToString())) ? string.Empty : DateTime.Parse(parameter[i]["QUOT_DELI_DATE"]).ToString("yyyy-MM-dd"),
                                 parameter[i]["REMARK"], 
                                 parameter[i]["QUOT_MGR_NAME"], 
                                 parameter[i]["QUOT_MGR_TELNO"], 
                                 parameter[i]["MRO_PO_TYPE"], 
                                 this.cbo01_QUOT_CNT.Value,
                                 quot_no, 
                                 Util.UserInfo.UserID, 
                                 "1"
                            );


                            //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                            if (!Validation(param02.Tables[0].Rows[rIdx], Library.ActionType.Save, Convert.ToInt32(parameter[i]["NO"])))
                            {
                                return;
                            }
                            rIdx++;
                        }
                    }

                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param02);
                        this.MsgCodeAlert("COM-00902");
                        _QUOT_CNT = this.cbo01_QUOT_CNT.Value.ToString();
                        SetCombo(_QUOT_CNT);
                        cbo01_QUOT_CNT_Change(null, null);
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
        /// Present
        /// 제출
        /// </summary>
        /// <param name="actionType"></param>
        public void Present(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "PRNO", "PRNO_SEQ", "SEQ",
                    "VENDCD", "USER_ID", "LANG_SET"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!PresentationValidation(parameter[i], Convert.ToInt32(parameter[i]["NO"])))
                    {
                        return;
                    }

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, this.cbo01_BIZCD.Value,
                         parameter[i]["PRNO"], parameter[i]["PRNO_SEQ"], parameter[i]["SEQ"],
                         this.cdx01_VENDCD.Value, Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "PRESENT"), param);
                    this.MsgCodeAlert("COM-00902");
                    _QUOT_CNT = this.cbo01_QUOT_CNT.Value.ToString();
                    SetCombo(_QUOT_CNT);
                    cbo01_QUOT_CNT_Change(null, null);
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
        /// PresentCancel
        /// 제출취소
        /// </summary>
        /// <param name="actionType"></param>
        public void PresentCancle(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "PRNO", "PRNO_SEQ", "SEQ",
                    "VENDCD", "USER_ID", "LANG_SET"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!PresentationCloseValidation(parameter[i], Convert.ToInt32(parameter[i]["NO"])))
                    {
                        return;
                    }

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, this.cbo01_BIZCD.Value,
                         parameter[i]["PRNO"], parameter[i]["PRNO_SEQ"], parameter[i]["SEQ"],
                         this.cdx01_VENDCD.Value, Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "PRESENT_CANCEL"), param);
                    this.MsgCodeAlert("COM-00902");
                    _QUOT_CNT = this.cbo01_QUOT_CNT.Value.ToString();
                    SetCombo(_QUOT_CNT);
                    cbo01_QUOT_CNT_Change(null, null);
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

        [DirectMethod]
        public void Cell_Click(string colname, int rowindex, int colindex)
        {
            //X.Js.Call("alert('" + colname + "'," + rowindex + "," + colindex + ")");
            X.Js.Call("alert", colname + "," + rowindex + "," + colindex);
        }

        #endregion

        #region [ 이벤트 ]

        //일괄등록 로직
        [DirectMethod]
        public void GridUpdate(string chr_nm, string chr_tel, string deli_date, string chk, int count, string json)
        {

            Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

            for (int i = 0; i < parameters.Length; i++)
            {
                int idx = Convert.ToInt32(parameters[i]["NO"]) - 1;

                if (chk.Equals("1"))
                {
                    this.Grid01.GetStore().GetAt(idx).Set("QUOT_MGR_NAME", chr_nm);
                    this.Grid01.GetStore().GetAt(idx).Set("QUOT_MGR_TELNO", chr_tel);
                    this.Grid01.GetStore().GetAt(idx).Set("QUOT_DELI_DATE", DateTime.Parse(deli_date).ToString("yyyy-MM-dd"));
                }
                else if (chk.Equals("2"))
                {
                    this.Grid01.GetStore().GetAt(idx).Set("QUOT_MGR_NAME", chr_nm);
                    this.Grid01.GetStore().GetAt(idx).Set("QUOT_MGR_TELNO", chr_tel);
                }
                else if (chk.Equals("3"))
                {
                    this.Grid01.GetStore().GetAt(idx).Set("QUOT_DELI_DATE", DateTime.Parse(deli_date).ToString("yyyy-MM-dd"));
                }
            }
            this.Grid01.GetStore().CommitChanges();
        }

        //상세견적첨부 저장 후 로직
        [DirectMethod]
        public void FileNmUpdate()
        {
            Search();
        }

        //차수별 조회
        protected void cbo01_QUOT_CNT_Change(object sender, DirectEventArgs e)
        {
            //유효성 검사 (조회)
            if (!Validation(null, Library.ActionType.Search, 0))
            {
                return;
            }

            if (cbo01_QUOT_CNT.Value.Equals("0") || cbo01_QUOT_CNT.Value.Equals(""))
            {
                Store1.RemoveAll();
                SetCombo();
                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                X.Js.Call("checkBoxControl", true, false);
                this.chk01_QUOT_NO.Editable = true;
                this.D_CHECK.Editable = true;
            }
            else if (!_QUOT_CNT.Equals("0"))               
            {
                Store1.RemoveAll();
                DataSet result = getDataSet02();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                X.Js.Call("checkBoxControl", true, true);
                //this.chk01_QUOT_NO.Editable = false;
                //this.D_CHECK.Editable = false;
            }
        }

        //검색조건을 바꾸면 자동으로 차수 콤보 세팅 및 그리드 초기화
        public void changeCondition(object sender, DirectEventArgs e)
        {
            this.SetCombo();
            if(initStr)this.initGrid();
        }

        private void initGrid()
        {
            this.Store1.RemoveAll();
        }

        #endregion

        #region [함수]

        //전체선택 및 그리드 컬럼 수정방지 
        private void GridEvent()
        {

        }

        private void SetCombo(string cnt = "0")
        {
            try
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("MRO_PO_TYPE", this.cbo01_MRO_PO_TYPE.Value);
                param.Add("QUWT_DATE", ((DateTime)this.df01_ETMT_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("LANG_SET", this.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);

                DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_MAKECHASU"), param);

                Library.ComboDataBind(this.cbo01_QUOT_CNT, source.Tables[0], false, "CDNM", "CD", true);

                this.cbo01_QUOT_CNT.SelectedItem.Value = cnt;
                this.cbo01_QUOT_CNT.Value = cnt;
                this.cbo01_QUOT_CNT.UpdateSelectedItems();
            }
            catch
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
                if (String.IsNullOrEmpty(this.cdx01_VENDCD.Value.ToString()) || this.cdx01_VENDCD.Value.ToString().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0002");

                else if (String.IsNullOrEmpty(parameter["PARTNM"].ToString()) || parameter["PARTNM"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "PARTNM"));
                /* 규격은 품번과 합쳐짐
                else if (String.IsNullOrEmpty(parameter["STANDARD"].ToString()) || parameter["STANDARD"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "STANDARD"));
                */
                else if (String.IsNullOrEmpty(parameter["QUOT_QTY"].ToString()) || parameter["QUOT_QTY"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QTY"));

                else if (Convert.ToInt64(parameter["QUOT_QTY"]) <= 0)
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QTY"));

                else if (String.IsNullOrEmpty(parameter["QUOT_UCOST"].ToString()) || parameter["QUOT_UCOST"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_UCOST"));

                else if (Convert.ToInt64(parameter["QUOT_UCOST"]) <= 0)
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_UCOST"));
                
                else if (String.IsNullOrEmpty(parameter["QUOT_DUTY"].ToString()) || parameter["QUOT_DUTY"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_MGR_NAME"));

                else if (String.IsNullOrEmpty(parameter["QUOT_TEL"].ToString()) || parameter["QUOT_TEL"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_MGR_TELNO"));
                
                else if (String.IsNullOrEmpty(parameter["DELI_DATE"].ToString()) || parameter["DELI_DATE"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "QUOT_DELI_DATE"));

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
                if (String.IsNullOrEmpty(this.cdx01_VENDCD.Value.ToString()) || this.cdx01_VENDCD.Value.ToString().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SCMMP00-0024", "cdx01_VENDCD", lbl01_VEND.Text);
                result = true;
            }

            return result;
        }

        //제출
        public bool PresentationValidation(Dictionary<string, string> parameter, int actionRow = -1)
        {
            //견적상태 1L (A:접수대기/B:접수완료/C:작성완료/D:제출완료/E:견적승인)
            string quot = Convert.ToString(parameter["QUOT_TYPE"]).Trim();

            if (String.IsNullOrEmpty(this.cdx01_VENDCD.Value.ToString()) || this.cdx01_VENDCD.Value.ToString().Equals(""))
            {
                this.MsgCodeAlert_ShowFormat("SCMMP00-0024", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            //견적상태 체크 1
            else if (quot.Equals("1LA") || quot.Equals("1LB"))
            {
                //X.Msg.Alert("경고", "미작성 견적서는 제출 불가합니다.").Show();
                this.MsgCodeAlert_ShowFormat("SCMMP00-0022", actionRow);
                return false;
            }

            //견적상태 체크 1
            else if (quot.Equals("1LD") || quot.Equals("1LE"))
            {
                //X.Msg.Alert("경고", "견적서 항목은 이미 제출된 견적 항목입니다.").Show();
                this.MsgCodeAlert_ShowFormat("SCMMP00-0003", actionRow);
                return false;
            }

            ////견적상태 체크 2
            //else if (Convert.ToString(parameter["VAN_PROCESS_CODE"]).Trim().Equals("H6C"))
            //{
            //    //X.Msg.Alert("경고", "견적서 항목은 이미 승인된 견적 항목입니다.").Show();
            //    this.MsgCodeAlert_ShowFormat("SCMMP00-0004", actionRow);
            //    return false;
            //}
            else
                return true;
        }

        //제출취소
        public bool PresentationCloseValidation(Dictionary<string, string> parameter, int actionRow = -1)
        {
            //견적상태 1L (A:접수대기/B:접수완료/C:작성완료/D:제출완료/E:견적승인)
            string quot = Convert.ToString(parameter["QUOT_TYPE"]).Trim();

            if (String.IsNullOrEmpty(this.cdx01_VENDCD.Value.ToString()) || this.cdx01_VENDCD.Value.ToString().Equals(""))
            {
                this.MsgCodeAlert_ShowFormat("SCMMP00-0024", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            //견적상태 체크 1
            else if (quot.Equals("1LA") || quot.Equals("1LB") ||quot.Equals("1LC"))
            {
                //X.Msg.Alert("경고", "{0}행의 견적서 항목은 제출되지 않는 견적 항목입니다.").Show();
                this.MsgCodeAlert_ShowFormat("SCMMP00-0005", actionRow);
                return false;
            }

            //견적상태 체크 2
            else if (quot.Equals("1LE"))
            {
                //X.Msg.Alert("경고", "견적서 항목은 이미 승인된 견적 항목입니다.").Show();
                this.MsgCodeAlert_ShowFormat("SCMMP00-0004", actionRow);
                return false;
            }

            else
                return true;
        }

        #endregion
    }
}
