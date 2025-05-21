#region ▶ Description & History
/* 
 * 프로그램명 : 일별/차수별 출력
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-28
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
using Ext.Net;
using Ax.EP.Utility;
using HE.Framework.Core;
using System.Data;
using HE.Framework.Core.Report;

namespace Ax.EP.WP.Home.SRM_ALC
{
    public partial class SRM_ALC30005 : BasePage
    {
        private string pakageName = "APG_SRM_ALC30005";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_ALC30005 생성자
        /// </summary>
        public SRM_ALC30005()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = false;
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
                    this.SetCombo(); //콤보상자 바인딩//임시저장
                    this.SetCombo("1");
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

        //공장 정보 변경 시
        [DirectMethod]
        public void SetPlantComboChange()
        {
            string PLANT_GB = this.cbo01_PLANT_GB.Value.ToString();
            this.SetCombo(PLANT_GB);
        }

        #endregion

        #region [ 버튼설정 ]

        /// <summary>
        /// BuildButtons
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
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
                case ButtonID.Print:
                    Print();
                    break;
                case ButtonID.Reset:
                    Reset();
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
        /// Reset
        /// </summary>
        public void Reset()
        {
            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }
            this.df01_QUT_DATE.SetValue(DateTime.Now);
            this.cbo01_PLANT_GB.SelectedItem.Value = "1";
            this.cbo01_PLANT_GB.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_LINE_GB.SelectedItem.Value = "1";
            this.cbo01_LINE_GB.UpdateSelectedItems(); //꼭 해줘야한다.
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getReportDataSet()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("YMD", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));
            param.Add("PLANT_GB", this.cbo01_PLANT_GB.Value);
            param.Add("LINE_GB", this.cbo01_LINE_GB.Value);
            param.Add("CHASU_QTY", this.txt01_CHASU_QTY.Text);
            param.Add("FIELD_NM1", this.txt01_FIELD_NM1.Text);
            param.Add("FIELD_NM2", this.txt01_FIELD_NM2.Text);
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
                //유효성 검사
                if (!IsQueryValidation()) return;

                DataSet ds02 = ItemChasu();
                if (ds02.Tables[0].Rows.Count > 0)
                {
                    this.txt01_FIELD_NM1.Text = ds02.Tables[0].Rows[0]["FIELD_NM1"].ToString();
                    this.txt01_FIELD_NM2.Text = ds02.Tables[0].Rows[0]["FIELD_NM2"].ToString();
                    this.txt01_CHASU_QTY.Text = ds02.Tables[0].Rows[0]["CHASU_QTY"].ToString();
                }

                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_ALC/SRM_ALC30005";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

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
                mainSection.ReportParameter.Add("PLANT_GB", this.cbo01_PLANT_GB.SelectedItem.Text);
                mainSection.ReportParameter.Add("FIELD_NM1", this.cbo01_PLANT_GB.SelectedItem.Text);
                mainSection.ReportParameter.Add("FIELD_NM2", this.cbo01_PLANT_GB.SelectedItem.Text);

                report.Sections.Add("MAIN", mainSection);

                // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                DataSet ds = getReportDataSet();

                // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                //ds.Tables[0].TableName = "DATA";
                //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                    // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
                    // xmlSection.ReportParameter.Add("CORCD", "1000");
                    report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정

                    AxReportForm.ShowReport(report);
                }

                //if (ds.Tables[0].Rows.Count > 0)
                //{
                //    if (ds.Tables[0].Rows.Count > 1)
                //    {
                //        ds.Tables[0].Columns.Add("NO");

                //        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                //        {
                //            ds.Tables[0].Rows[i]["NO"] = i + 1;
                //        }

                //        int rowsCnt = ds.Tables[0].Rows.Count - 1;
                //        ds.Tables[0].Rows[rowsCnt]["NO"] = "";
                //        ds.Tables[0].Rows[rowsCnt]["PLANT_GB"] = "";
                //        ds.Tables[0].Rows[rowsCnt]["LINE_GB"] = "";
                //        ds.Tables[0].Rows[rowsCnt]["ALC"] = "STOT";
                //    }

                //    // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                //    // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                //    //ds.Tables[0].TableName = "DATA";
                //    //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);

                //    HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                //    // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
                //    // xmlSection.ReportParameter.Add("CORCD", "1000");
                //    report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정

                //    AxReportForm.ShowReport(report);
                //}
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
        /// 콤보상자 바인딩(발생구분)
        /// </summary>
        private void SetCombo()
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", this.UserInfo.CorporationCode);
            set.Add("BIZCD", this.UserInfo.BusinessCode);
            set.Add("PLANT_GB", "-999");
            set.Add("LANG_SET", this.UserInfo.LanguageShort);
            set.Add("USER_ID", this.UserInfo.UserID);
            //발생구분 콤보상자 바인딩
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PLANT"), set);
            Library.ComboDataBind(this.cbo01_PLANT_GB, source.Tables[0], false, "PLANT_GBNM", "PLANT_GB", true);
        }

        /// <summary>
        /// 콤보상자 바인딩(발생구분)
        /// </summary>
        private void SetCombo(string cnt = "1")
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", this.UserInfo.CorporationCode);
            set.Add("BIZCD", this.UserInfo.BusinessCode);
            set.Add("PLANT_GB", cnt);
            set.Add("LANG_SET", this.UserInfo.LanguageShort);
            set.Add("USER_ID", this.UserInfo.UserID);

            //LINE 콤보상자 바인딩
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_LINE"), set);
            Library.ComboDataBind(this.cbo01_LINE_GB, source.Tables[0], false, "LINE_GBNM", "LINE_GB", true);

            this.cbo01_LINE_GB.SelectedItem.Value = "1";
            this.cbo01_LINE_GB.UpdateSelectedItems(); //꼭 해줘야한다.
        }

        private DataSet ItemChasu()
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", Util.UserInfo.CorporationCode);
            set.Add("BIZCD", Util.UserInfo.BusinessCode);
            set.Add("VEND_CD", this.cdx01_VENDCD.Value);
            set.Add("PLANT_GB", this.cbo01_PLANT_GB.Value);
            set.Add("LINE_GB", this.cbo01_LINE_GB.Value);
            set.Add("USER_ID", Util.UserInfo.UserID);
            set.Add("LANG_SET", Util.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ITEMCHASU"), set);
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
                this.MsgCodeAlert_ShowFormat("SRMMP00-0024", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            else if (this.df01_QUT_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMMP00-0023", "df01_QUT_DATE", lbl01_DD.Text);
                return false;
            }
            return true;
        }

        #endregion
    }
}