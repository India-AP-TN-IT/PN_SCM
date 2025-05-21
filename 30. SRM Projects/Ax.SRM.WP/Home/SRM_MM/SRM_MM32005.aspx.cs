using System;
using System.Collections.Generic;
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using HE.Framework.Core.Report;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM32005 : BasePage
    {
        private string pakageName = "APG_SRM_MM32005";        

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM32005
        /// </summary>
        public SRM_MM32005()
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
            //MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
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
                case "btn01_PART_PRINT":
                    Part_Print(e);
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
            Library.ComboDataBind(this.cbo01_PURC_PO_TYPE, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
            this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

            source = Library.GetTypeCode("1A").Tables[0];
            Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
            if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
            {
                this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
            }
            this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.
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
            
            this.cbo01_PURC_PO_TYPE.SelectedItem.Index = 0;
            this.cbo01_PURC_ORG.SelectedItem.Index = 0;

            this.txt01_FPARTNO.SetValue(string.Empty);
            this.cdx01_VINCD.SetValue(string.Empty);

            this.cdx01_STR_LOC.SetValue(string.Empty);
            
            this.Store1.RemoveAll();            
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
            param.Add("PURC_ORG", cbo01_PURC_ORG.Value);
            param.Add("PURC_PO_TYPE", cbo01_PURC_PO_TYPE.Value);
            param.Add("STR_LOC", cdx01_STR_LOC.Value); //저장위치
            param.Add("VINCD", cdx01_VINCD.Value);            
            param.Add("PARTNO", txt01_FPARTNO.Value);
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

            return true;
        }

        #endregion

        #region [ 이벤트 ]
        
        protected void cbo01_PURC_ORG_Change(object sender, DirectEventArgs e)
        {
            if (cbo01_PURC_ORG.SelectedItem.Value.Equals("1A1110"))
            {
                this.cbo01_PURC_PO_TYPE.SelectedItem.Value = "1KMA";
                this.cbo01_PURC_PO_TYPE.UpdateSelectedItems();
            }
        }

        private void Part_Print(DirectEventArgs e)
        {
            try
            {
                DataTable dt = new DataTable("DATA");
                dt.Columns.Add("NATIONCD");
                dt.Columns.Add("NATIONNM");
                dt.Columns.Add("PARTNO");
                dt.Columns.Add("UNIT");
                dt.Columns.Add("PARTNM");
                dt.Columns.Add("EXP_VENDNM");
                dt.Columns.Add("VINNM");
                dt.Columns.Add("LOT_NO");
                dt.Columns.Add("RCV_VENDNM");
                dt.Columns.Add("CCC_AUTH");
                dt.Columns.Add("VEND_LOT_NO");
                dt.Columns.Add("CHANGE_YN");
                dt.Columns.Add("CHANGE_NOTE");
                dt.Columns.Add("MEDI_PACK_QTY");

                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (!string.IsNullOrEmpty(parameters[i]["BOX_CNT"])) // 박스수량이 있는것만
                    {
                        if (String.IsNullOrEmpty(parameters[i]["MEDI_PACK_QTY"].ToString()) || parameters[i]["MEDI_PACK_QTY"].ToString().Trim().Equals("") || parameters[i]["MEDI_PACK_QTY"].ToString().Trim().Equals("0"))
                        {
                            this.MsgCodeAlert_ShowFormat("SRMALC00-0001", i+1, Util.GetHeaderColumnName(Grid01, "D_MEDI_PACK_QTY"));
                            return;
                        }
                        else if (String.IsNullOrEmpty(parameters[i]["PRDT_DATE"].ToString()) || parameters[i]["PRDT_DATE"].ToString().Trim().Equals(""))
                        {
                            this.MsgCodeAlert_ShowFormat("SRMALC00-0001", i + 1, Util.GetHeaderColumnName(Grid01, "D_PRDT_DATE"));
                            return;
                        }

                        for (int j = 0; j < int.Parse(parameters[i]["BOX_CNT"]); j++)
                        {
                            dt.LoadDataRow(new object[] { parameters[i]["NATIONCD"] 
                                              ,parameters[i]["EN_NATIONNM"] +" - " + parameters[i]["SUM_CUSTCD"]
                                              ,parameters[i]["PARTNO"]
                                              ,decimal.Parse(parameters[i]["MEDI_PACK_QTY"]).ToString("#,##0.###") +" "+ parameters[i]["PO_UNIT"]                                               
                                              ,parameters[i]["PARTNM"]  
                                              ,parameters[i]["EXP_VENDNM"]  
                                              ,parameters[i]["VINCD"]  
                                              ,string.IsNullOrEmpty(parameters[i]["PRDT_DATE"])?"":DateTime.Parse(parameters[i]["PRDT_DATE"]).ToString("yyyy-MM-dd")  
                                              ,parameters[i]["VENDNM"] //RCV_VENDNM
                                              ,"" 
                                              ,DateTime.Parse(parameters[i]["PRDT_DATE"]).ToString("yyyy-MM-dd") + "/" + parameters[i]["LOTNO"] //2018.03.08 KDY 수정, 이호길 요청
                                              ,string.IsNullOrEmpty(parameters[i]["CHANGE_4M"])?"":"CHANGED"
                                              ,parameters[i]["CHANGE_4M"]
                                              ,parameters[i]["MEDI_PACK_QTY"] // 필수 체크로 넣음
                            }, false);

                        }
                    }
                }
              
                if (dt.Rows.Count == 0)
                {                    
                    this.MsgCodeAlert("SRMMM-0056"); //발행가능한 식별표가 없습니다.
                    return;
                }
                
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM32004";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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
                DataSet ds = new DataSet();
                ds.Tables.Add(dt);

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

         // <summary>
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

            //  Validation
            if (actionType == Library.ActionType.Search)
            {
                if (String.IsNullOrEmpty(parameter["MEDI_PACK_QTY"].ToString()) || parameter["MEDI_PACK_QTY"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMALC00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "D_MEDI_PACK_QTY"));
                else if (String.IsNullOrEmpty(parameter["LOT_NO"].ToString()) || parameter["LOT_NO"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("SRMALC00-0001", actionRow, Util.GetHeaderColumnName(Grid01, "D_PRDT_DATE"));
                else
                    result = true;

            }
            return result;
        }
        #endregion

    }
}
