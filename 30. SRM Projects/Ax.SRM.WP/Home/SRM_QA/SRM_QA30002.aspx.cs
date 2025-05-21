#region ▶ Description & History
/* 
 * 프로그램명 : 입고품 불량내용 조회 (구.VQ3010)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-02
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
using System.ServiceModel;

namespace Ax.SRM.WP.Home.SRM_QA
{
    public partial class SRM_QA30002 : BasePage
    {
        private string pakageName = "APG_SRM_QA30002";
        

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA30002
        /// </summary>
        public SRM_QA30002()
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

            if (id.Equals(ButtonID.Search))
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "ContentsPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Loading Data...";
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
                case ButtonID.ExcelDL:
                    Excel_Export();
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
                
                this.DisplayChart();
                this.DisplayGrid(string.Empty);                

            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }            
            finally
            {
             
            }
        }

        public void DisplayChart()
        {
            DataSet result = getDataSet();

            //ppm 최대값 찾기
            int MaxPPM = Convert.ToInt32(result.Tables[0].Compute("MAX(RESULT_PPM)", null) == DBNull.Value ? 0 : result.Tables[0].Compute("MAX(RESULT_PPM)", null));
            int MaxPPM2 = Convert.ToInt32(result.Tables[0].Compute("MAX(TARGET_PPM)", null) == DBNull.Value ? 0 : result.Tables[0].Compute("MAX(TARGET_PPM)", null));

            if (MaxPPM > MaxPPM2)
                Chart1.Axes[0].SetMaximum(MaxPPM * 1.3);
            else
                Chart1.Axes[0].SetMaximum(MaxPPM2 * 1.3);

            //건수 최대값 찾기
            int MaxCount = Convert.ToInt32(result.Tables[0].Compute("MAX(RESULT_COUNT)", null) == DBNull.Value ? 0 : result.Tables[0].Compute("MAX(RESULT_COUNT)", null));
            int MaxCount2 = Convert.ToInt32(result.Tables[0].Compute("MAX(TARGET_COUNT)", null) == DBNull.Value ? 0 : result.Tables[0].Compute("MAX(TARGET_COUNT)", null));

            if (MaxCount > MaxCount2)
                Chart2.Axes[0].SetMaximum(MaxCount * 1.3);
            else
                Chart2.Axes[0].SetMaximum(MaxCount2 * 1.3);

            //ppm 차트 데이터 바인딩
            this.Store_LineChart.DataSource = result.Tables[0];
            this.Store_LineChart.DataBind();
            
            //건수 차트 데이터 바인딩
            this.Store_ColumnChart.DataSource = result.Tables[0];
            this.Store_ColumnChart.DataBind();

        }

        [DirectMethod]
        public void DisplayGrid(string MM)
        {

            DataSet dsTopGrid = getDataSetTopGrid();
            
            
            dsTopGrid.Tables[0].DefaultView.RowFilter = "DIV = 'DQ'";
            DataTable dtMM = dsTopGrid.Tables[0].DefaultView.ToTable().Copy();

            dsTopGrid.Tables[0].DefaultView.RowFilter = "DIV IN ('TARGET PPM', 'TARGET CNT', 'RESULT PPM', 'RESULT CNT')";
            DataTable dtTopGrid = dsTopGrid.Tables[0].DefaultView.ToTable().Copy();

            if (MM.Equals(string.Empty))
            {
                if (dtMM.Rows.Count > 0)
                {
                    DataRow dr = dtMM.Rows[0];
                    for (int i = 1; i <= 12; i++)
                    {
                        if (!string.IsNullOrEmpty(dr["M" + i.ToString().PadLeft(2, '0')].ToString()))
                        {
                            MM = i.ToString().PadLeft(2, '0');
                        }
                    }
                }
            }
                        

            DataColumn dc = new DataColumn();
            dc.DefaultValue = MM;
            dc.ColumnName = "MM";
            dc.DataType = typeof(string);
            dtTopGrid.Columns.Add(dc);

            this.StoreTopGrid.DataSource = dtTopGrid;
            this.StoreTopGrid.DataBind();
            

            DataSet dsBottom = getDataSetBottomGrid(MM);
            this.StoreBottomGrid.DataSource = dsBottom;
            this.StoreBottomGrid.DataBind();

            string text = this.Grid02.ColumnModel.Columns[0].Text;
            this.Grid02.ColumnModel.Columns[0].Text = string.Format(text, MM);
            
            X.Mask.Hide();
        }


        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {

            this.setComboCORCD();

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);
            
            this.txt01_STD_YEAR.SetValue(DateTime.Now.Year);  
            //BASE에서 일괄적으로 위아래버튼 사라지게 처리함. 
            //이화면에서는 필요하므로 다시 살림
            this.txt01_STD_YEAR.HideTrigger = false;
            this.txt01_STD_YEAR.SpinDownEnabled = true;
            this.txt01_STD_YEAR.SpinUpEnabled = true;

            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }

            Store_ColumnChart.RemoveAll();
            Store_LineChart.RemoveAll();
            StoreTopGrid.RemoveAll();
            StoreBottomGrid.RemoveAll();

            Chart2.Axes[0].Title = Library.getLabel(GetMenuID(), "COUNT");
        }


        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private void setComboCORCD()
        {
            HEParameterSet param = new HEParameterSet();            
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_EPCOMMON", "INQUERY_CORCD"), param);
            source.Tables[0].DefaultView.RowFilter = "CORCD= '8'";
            DataTable dtCORCD = source.Tables[0].DefaultView.ToTable().Copy();
            Library.ComboDataBind(this.cbo01_CORCD, dtCORCD, false, "CORNM", "CORCD", false);

            this.cbo01_CORCD.SelectedItem.Value = Util.UserInfo.CorporationCode;
            this.cbo01_CORCD.UpdateSelectedItems(); //꼭 해줘야한다.
        }


        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("YYYY", this.txt01_STD_YEAR.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CHART"), param);
            //foreach(DataRow dr in source.Tables[0].Rows)
            //{
            //    //if(dr["TARGET_PPM"]==DBNull.Value) dr["TARGET_PPM"] = 0;
            //    //if (dr["RESULT_PPM"] == DBNull.Value) dr["RESULT_PPM"] = 0;
            //    //if (dr["TARGET_COUNT"] == DBNull.Value) dr["TARGET_COUNT"] = 0;
            //    //if (dr["RESULT_COUNT"] == DBNull.Value) dr["RESULT_COUNT"] = 0;

            //    dr["TARGET_PPM"] = 650;
            //    dr["TARGET_COUNT"] = 15357;
            //}
            return source;
        }

        private DataSet getDataSetTopGrid()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("YYYY", this.txt01_STD_YEAR.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_TOP"), param);
           
            return source;
        }

        private DataSet getDataSetBottomGrid(string MM)
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("YYYYMM", this.txt01_STD_YEAR.Value.ToString()+ "-" + MM);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_BOTTOM"), param);

            return source;
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
                    result.Tables[0].Columns.Remove("INSPECT_DIVCD");
                    result.Tables[0].Columns.Remove("VENDCD");
                    result.Tables[0].Columns.Remove("BIZCD");
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
                this.MsgCodeAlert_ShowFormat("SRMQA00-0046", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            if (this.txt01_STD_YEAR.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "df01_RCV_DATE", lbl01_STD_DATE.Text);
                return  false;
            }
            return true;
        }

        #endregion
    }
}
