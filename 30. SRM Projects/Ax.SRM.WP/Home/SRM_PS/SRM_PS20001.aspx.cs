#region ▶ Description & History
/* 
 * 프로그램명 : 조립 작업지시 조회
 * 설      명 : 
 * 최초작성자 : 배명희
 * 최초작성일 : 2014-09-18
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

namespace Ax.SRM.WP.Home.SRM_PS
{

    public partial class SRM_PS20001 : BasePage
    {
        private string pakageName = "APG_SRM_PS20001";


        #region [ 초기설정 ]

        /// <summary>
        /// SRM_PS20001
        /// </summary>
        public SRM_PS20001()
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
                    if (!this.UserInfo.UserDivision.Equals("T12"))
                    {
                        txt01_REMARK.ReadOnly = false;
                        btn01_REMARK_SAVE.Visible = false;
                    }
                    else
                    {
                        txt01_REMARK.ReadOnly = false;
                        btn01_REMARK_SAVE.Visible = true;
                    }


                    this.SetCombo();
                    this.Reset();
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


        /// <summary>
        /// 콤보상자 바인딩(위치)
        /// </summary>
        private void SetCombo()
        {
            HEParameterSet paramSet = new HEParameterSet();
            paramSet.Add("LANG_SET", this.UserInfo.LanguageShort);
            DataSet source_VEND = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_VENDCD"), paramSet);
            Library.ComboDataBind(this.cbo01_CUSTCD, source_VEND.Tables[0], true, "NAME", "ID", true, "ALL");
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
                case "btn01_MODIFY":
                    //수정
                    Modify(sender, e);
                    break;

                case "btn01_NEW":
                    //신규
                    MakePopUp(string.Empty, "N", string.Empty);
                    break;
                case "btn01_DELETE":
                    //삭제
                    Delete(sender, e);
                    break;
                case "btn01_PRINT":
                    //삭제
                    Print(sender, e);
                    break;
                case "btn01_REMARK_SAVE":
                    Remark_Save(sender, e);
                    break;
                default:
                    break;
            }
        }

        #endregion

        #region [코드박스 이벤트 핸들러]


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
            this.cbo01_CUSTCD.SelectedItem.Index = 0;
            this.cbo01_CUSTCD.UpdateSelectedItems();

            this.cdx01_VINCD.SetValue(string.Empty);

            this.cbo01_SPEC.SelectedItem.Value = "%";
            this.cbo01_SPEC.UpdateSelectedItems();

            this.cbo01_TYPE.SelectedItem.Value = "%";
            this.cbo01_TYPE.UpdateSelectedItems();

            this.cbo01_APPLY.SelectedItem.Value = "Y";
            this.cbo01_APPLY.UpdateSelectedItems();

            this.cdx01_VENDCD.SetValue(string.Empty);

            this.txt01_PARTNO.SetValue(string.Empty);

            this.Store1.RemoveAll();

        }



        /// <summary>
        /// 데이터 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CUSTCD", cbo01_CUSTCD.Value);
            param.Add("VINCD", cdx01_VINCD.Value);
            param.Add("SPEC", cbo01_SPEC.Value);
            param.Add("TYPE", cbo01_TYPE.Value);
            param.Add("VENDCD", cdx01_VENDCD.Value);
            param.Add("MAIN_PARTNO", txt01_PARTNO.Value);
            param.Add("ALL", cbo01_APPLY.Value);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// 기본정보, 포장사진 및 포장방법, 부품/중포장/대포장 정보
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Basic(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_BASIC"), param);
        }

        /// <summary>
        /// 기본정보, 포장사진 및 포장방법, 부품/중포장/대포장 정보
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Basic_Print(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_BASIC_PRINT"), param);
        }

        /// <summary>
        /// 동일포장사양정보 프린트
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Same_Print(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SAME_PRINT"), param);
        }

        /// <summary>
        /// 포장재료 정보 프린트
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Ingridient_Print(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_INGRIDIENT_PRINT"), param);
        }

        /// <summary>
        /// 변경내역 프린트
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_ChangeHistory_Print(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CHANGEHISTORY_PRINT"), param);
        }

        /// <summary>
        /// 검토 및 승인 정보
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Apply(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_APPLY"), param);
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

            //// 조회용 Validation

            //if (this.df01_BEG_DATE.IsEmpty)
            //{
            //    this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_BEG_DATE", lbl01_WORK_DATE3.Text);
            //    return  false;
            //}

            //if (this.cdx01_LINECD.IsEmpty)
            //{
            //    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_LINECD", lbl01_LINECD.Text);
            //    return false;
            //}
            return true;
        }

        #endregion

        #region [사용자 함수]

        private void Print(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.Alert("출력할 ROW를 먼저 선택해주세요.");
                    return;
                }

                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_PS/SRM_PS20001";

                // Main Section ( 메인리포트 파라메터셋 )
                HERexSection mainSection = new HERexSection();
                //mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");            

                report.Sections.Add("MAIN", mainSection);

                // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                DataSet ds = this.getDataSet_Basic_Print(parameter[0]["MAIN_PARTNO_CODE"], parameter[0]["REG_DATE"]);

                if (ds.Tables[0].Rows.Count <= 0)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00022");
                    return;
                }
                DataSet ds1 = this.getDataSet_Same_Print(parameter[0]["MAIN_PARTNO_CODE"], parameter[0]["REG_DATE"]);
                DataSet ds2 = this.getDataSet_Ingridient_Print(parameter[0]["MAIN_PARTNO_CODE"], parameter[0]["REG_DATE"]);
                DataSet ds3 = this.getDataSet_ChangeHistory_Print(parameter[0]["MAIN_PARTNO_CODE"], parameter[0]["REG_DATE"]);
                DataSet ds4 = this.getDataSet_Apply(parameter[0]["MAIN_PARTNO_CODE"], parameter[0]["REG_DATE"]);

                // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                //ds.Tables[0].TableName = "DATA";
                //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
                //ds1.Tables[0].TableName = "DATA";
                //ds1.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "01.xml", XmlWriteMode.WriteSchema);
                //ds2.Tables[0].TableName = "DATA";
                //ds2.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "02.xml", XmlWriteMode.WriteSchema);
                //ds3.Tables[0].TableName = "DATA";
                //ds3.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "03.xml", XmlWriteMode.WriteSchema);
                //ds4.Tables[0].TableName = "DATA";
                //ds4.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "04.xml", XmlWriteMode.  WriteSchema);
                //ds5.Tables[0].TableName = "DATA";
                //ds5.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "05.xml", XmlWriteMode.WriteSchema);
                //ds6.Tables[0].TableName = "DATA";
                //ds6.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "06.xml", XmlWriteMode.WriteSchema);

                HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                HERexSection xmlSectionSub1 = new HERexSection(ds1, new HEParameterSet());
                HERexSection xmlSectionSub2 = new HERexSection(ds2, new HEParameterSet());
                HERexSection xmlSectionSub3 = new HERexSection(ds3, new HEParameterSet());
                HERexSection xmlSectionSub4 = new HERexSection(ds4, new HEParameterSet());

                // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
                // xmlSection.ReportParameter.Add("CORCD", "1000");
                report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
                report.Sections.Add("XML1", xmlSectionSub1);
                report.Sections.Add("XML2", xmlSectionSub2);
                report.Sections.Add("XML3", xmlSectionSub3);
                report.Sections.Add("XML4", xmlSectionSub4);

                AxReportForm.ShowReport(report);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {

            }
        }

        private void Delete(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.Alert("삭제할 ROW를 먼저 선택해주세요.");
                    return;
                }

                HEParameterSet param = new HEParameterSet();
                param.Add("MAIN_PARTNO", parameter[0]["MAIN_PARTNO_CODE"]);
                param.Add("REG_DATE", parameter[0]["REG_DATE"]);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE"), param);
                    this.Alert("정상적으로 삭제되었습니다.");
                    this.Search();
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

        private void Remark_Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.Alert("저장할 REMARK가 없습니다.");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "MAIN_PARTNO", "REG_DATE", "REMARK", "UPDATE_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    if (!string.IsNullOrEmpty(parameter[i]["R_NUMBER"]))
                    {
                        param.Tables[0].Rows.Add(
                             parameter[i]["MAIN_PARTNO"], parameter[i]["REG_DATE"], parameter[i]["REMARK"], this.UserInfo.EmpNo
                        );
                    }
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_REMARK"), param);
                    this.Alert("정상적으로 저장되었습니다.");
                    this.Search();
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

        private void Modify(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.Alert("수정할 ROW를 먼저 선택해주세요.");
                    return;
                }

                MakePopUp(parameter[0]["MAIN_PARTNO_CODE"], "M", parameter[0]["REG_DATE"]);
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
        public void MakePopUp(string partno, string mode, string reg_date)
        {
            // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
            HEParameterSet param = new HEParameterSet();
            param.Add("REG_DATE", reg_date);
            param.Add("Main_Partno", partno);
            param.Add("MODE", mode);

            Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_PS/SRM_PS20001P1.aspx", param, "HELP_PS20001P1", "Popup", 1380, 600);
        }
        #endregion
    }
}
