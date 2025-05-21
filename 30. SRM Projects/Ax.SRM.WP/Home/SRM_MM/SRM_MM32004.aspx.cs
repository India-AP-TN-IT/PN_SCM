using System;
using System.Collections.Generic;
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using HE.Framework.Core.Report;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM32004 : BasePage
    {
        private string pakageName = "APG_SRM_MM32004";        

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM32004
        /// </summary>
        public SRM_MM32004()
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
                    //콤보 바인딩
                    SetCombo();
                    //초기 조회
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
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
            //MakeButton(ButtonID.Delete, ButtonImage.Delete, "Delete", this.ButtonPanel);
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
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid02.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });

                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "GridPanel2";
                ibtn.DirectEvents.Click.EventMask.Msg = "Checking And Saving Data...";
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
                case ButtonID.Save:
                    Save(sender, e);
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
                case "btn01_PART_PRINT":
                    Part_Print();
                    break;
                case "btn01_SEL_PRINT":
                    SelPart_Print(sender, e);
                    break;
                default:
                    break;
            }
        }

        #endregion

        #region [ 기능 ]

        /// <summary>
        /// COMBO BINDING
        /// </summary>
        private void SetCombo()
        {
            Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);

            DataTable source = Library.GetTypeCode("1K").Tables[0];
            source.DefaultView.RowFilter = "TYPECD NOT IN ('NI')";
            Library.ComboDataBind(this.cbo01_PURC_PO_TYPE, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
            this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

            source = Library.GetTypeCode("1A").Tables[0];
            Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", false);
            if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
            {
                this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
            }
            this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

            source = new DataTable();
            source.Columns.Add("OBJECT_ID");
            source.Columns.Add("OBJECT_NM");
            source.Rows.Add("", "Normal");
            source.Rows.Add("S", "Small");
            Library.ComboDataBind(this.cbo01_PRINT_SIZE, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
            this.cbo01_PRINT_SIZE.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
            this.cbo01_PRINT_SIZE.UpdateSelectedItems(); //꼭 해줘야한다.
        }

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

                this.txt02_DELI_NOTE.Text = "";
                this.txt02_DELI_CNT.Text = "";

                Store2.RemoveAll();

                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();
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

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_FROM_DATE.SetValue(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
            this.df01_TO_DATE.SetValue(DateTime.Now.ToString("yyyy-MM-dd"));

            //this.cbo01_PURC_PO_TYPE.SelectedItem.Index = 0;
            //this.cbo01_PURC_ORG.SelectedItem.Index = 0;

            this.txt01_DELI_NOTE.SetValue(string.Empty);
            this.txt02_DELI_NOTE.SetValue(string.Empty);
            this.txt02_DELI_CNT.SetValue(string.Empty);

            this.cdx01_STR_LOC.SetValue(string.Empty);
            
            this.Store1.RemoveAll();
            this.Store2.RemoveAll();
        }

        /// <summary>
        /// 저장
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <param name="status"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    //저장할 대상 Data가 없습니다.
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema("CORCD", "BIZCD", "DELI_NOTE", "BOX_BARCODE", "PRDT_DATE", "VEND_LOTNO", "CHANGE_4M");

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        this.UserInfo.CorporationCode
                        , cbo01_BIZCD.Value
                        , txt02_DELI_NOTE.Value
                        , parameters[i]["BOX_BARCODE"].ToString()
                        , ((parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty) ? string.Empty : DateTime.Parse(parameters[i]["PRDT_DATE"].ToString()).ToString("yyyy-MM-dd"))
                        , parameters[i]["VEND_LOTNO"]
                        , parameters[i]["CHANGE_4M"].ToString()
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_TAG_INFO"), param);
                    this.MsgCodeAlert("COM-00902");
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
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", cdx01_VENDCD.Value);
            param.Add("PURC_PO_TYPE", cbo01_PURC_PO_TYPE.Value);
            param.Add("PURC_ORG", cbo01_PURC_ORG.Value);
            param.Add("STR_LOC", cdx01_STR_LOC.Value); //저장위치
            param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("DELI_NOTE", txt01_DELI_NOTE.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);           

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// getDataSetDetail
        /// </summary>
        /// <param name="groupID"></param>
        /// <returns></returns>
        private DataSet getDataSetDetail(string deli_note, string deli_note_seq)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("DELI_NOTE", deli_note);
            param.Add("DELI_NOTE_SEQ", deli_note_seq);            
            param.Add("LANG_SET", this.UserInfo.LanguageShort);              

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_DETAIL"), param);
        }

        /// <summary>
        /// getReportDataSet
        /// </summary>
        /// <param name="groupID"></param>
        /// <returns></returns>
        private DataSet getReportDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("DELI_NOTE", txt02_DELI_NOTE.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PRINT"), param);
        }

        /// <summary>
        /// Excel_Export
        /// </summary>
        private void Excel_Export()
        {
            try
            {
                DataSet result = getDataSetDetail(this.txt02_DELI_NOTE.Text, this.txt02_DELI_CNT.Text);

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
            //if (this.cbo01_PURC_PO_TYPE.IsEmpty)
            //{
            //    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_PO_TYPE", lbl01_PURC_PO_TYPE.Text);
            //    return false;
            //}
            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
                return false;
            }
            return true;
        }

        #endregion

        #region [ 이벤트 ]

        public void changeCondition(object sender, DirectEventArgs e)
        {
            if (cbo01_PURC_ORG.Value.ToString().Equals("1A1100"))
            {
                this.df01_FROM_DATE.SetValue(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
            }
            else
            {
                this.df01_FROM_DATE.SetValue(DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd"));
            }

            this.df01_TO_DATE.SetValue(DateTime.Now);
        }

        [DirectMethod]
        public void Cell_DoubleClick(string deli_note, string deli_note_seq)
        {
            this.txt02_DELI_NOTE.Text = deli_note;
            this.txt02_DELI_CNT.Text = deli_note_seq;

            DataSet result = getDataSetDetail(deli_note, deli_note_seq);

            this.Store2.DataSource = result.Tables[0];
            this.Store2.DataBind();
        }

        private void Part_Print(DataSet srcDs)
        {
            try
            {
                if (txt02_DELI_NOTE.Text.Length == 0)
                {
                    this.MsgCodeAlert("SRMMM-0054"); //선택한 납품서 정보가 없습니다.
                    return;
                }
                string PRINT_SIZE = cbo01_PRINT_SIZE.Value.ToString();
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM22011"+ PRINT_SIZE;  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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
                mainSection.ReportParameter.Add("TYPE", RadioGroup2.CheckedItems[0].InputValue.ToString());

                report.Sections.Add("MAIN", mainSection);

                // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                DataSet ds = srcDs;

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

        private void Part_Print()
        {
            this.Part_Print(getReportDataSet());
        }

        public void SelPart_Print(object sender, DirectEventArgs e)
        {

            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    this.MsgCodeAlert("QA01-0030");
                    return;
                }


                if (parameters.Length > 500)
                {
                    this.Alert("Information", "Too many data selected. A maximum of 500 is possible.", MessageBox.Icon.INFO);
                    return;
                }


                System.Text.StringBuilder selBarcode = new System.Text.StringBuilder();
                for (int i = 0; i < parameters.Length; i++) selBarcode.AppendFormat(",{0}", parameters[i]["BOX_BARCODE"]);

                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", this.UserInfo.CorporationCode);
                param.Add("BIZCD", cbo01_BIZCD.Value);
                param.Add("DELI_NOTE", txt02_DELI_NOTE.Value);
                param.Add("BOX_BARCODE_LIST", selBarcode.ToString().Substring(1));
                param.Add("LANG_SET", this.UserInfo.LanguageShort);

                DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SEL_PRINT"), param);
                this.Part_Print(ds);

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

    }
}
