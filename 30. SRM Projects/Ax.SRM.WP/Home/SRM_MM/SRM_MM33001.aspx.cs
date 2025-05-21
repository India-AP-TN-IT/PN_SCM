#region ▶ Description & History
/* 
 * 프로그램명 : 일별 검수 실적(구.VM3110)
 * 설      명 : 자재관리 > 검수관리 > 일별검수실적
 * 최초작성자 : 배명희
 * 최초작성일 : 2014-09-04
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

namespace HE.SCM.WP.Home.SCM_MM
{
    public partial class SRM_MM33001 : BasePage
    {
        private string pakageName = "APG_SRM_MM33001";        

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM33001
        /// </summary>
        public SRM_MM33001()
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
                    Library.ComboDataBind(this.cbo01_SEARCH_OPT, Library.GetTypeCode("VA", "2").Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);
                    Library.ComboDataBind(this.cbo01_MAT_TYPE, Library.GetTypeCode("EA").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);
                    Library.ComboDataBind(this.cbo01_ACP_DIV, Library.GetTypeCode("EJ").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);

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

        #endregion

        #region [ 기능 ]

        [DirectMethod]
        public void SetGridDisplay(string searchOpt)
        {
            if (searchOpt.Equals("VA3"))
            {
                ((Ext.Net.Button)this.FindControl(ButtonID.Search)).DirectEvents.Click.EventMask.CustomTarget = "Grid01";
                this.Grid01.Show();
                this.Grid02.Hide();
            }
            else
            {
                ((Ext.Net.Button)this.FindControl(ButtonID.Search)).DirectEvents.Click.EventMask.CustomTarget = "Grid02";
                this.Grid01.Hide();
                this.Grid02.Show();
            }
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
                if (this.cbo01_SEARCH_OPT.Value.ToString().Equals("VA3"))
                {
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
                }
                else
                {
                    this.Store2.DataSource = result.Tables[0];
                    this.Store2.DataBind();
                }
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

            //업체코드는 서연이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }

            if (this.cbo01_SEARCH_OPT.Items.Count > 0)
            {
                this.cbo01_SEARCH_OPT.SelectedItem.Value = "VA3";
                this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.
            }
            if (this.cbo01_ACP_DIV.Items.Count > 0)
            {
                this.cbo01_ACP_DIV.SelectedItem.Value = "";
                this.cbo01_ACP_DIV.UpdateSelectedItems();
            }
            if (this.cbo01_MAT_TYPE.Items.Count > 0)
            {
                this.cbo01_MAT_TYPE.SelectedItem.Value = "";
                this.cbo01_MAT_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.
            }
            this.txt01_PARTNO1.Text = string.Empty;
            //this.txt01_PARTNO2.Text = string.Empty;

            this.cdx01_VINCD.SetValue(string.Empty);

            this.df01_BEG_DATE.SetValue(DateTime.Now);
            this.df01_END_DATE.SetValue(DateTime.Now);

            this.Store1.RemoveAll();
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
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("BEG_DATE", ((DateTime)this.df01_BEG_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("END_DATE", ((DateTime)this.df01_END_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("LV_DIV", this.cbo01_ACP_DIV.Value);
            param.Add("PARTNO1", this.txt01_PARTNO1.Text);
            //param.Add("PARTNO2", this.txt01_PARTNO2.Text.Equals(string.Empty) ? "Z" : this.txt01_PARTNO2.Text);
            param.Add("MAT_TYPE", this.cbo01_MAT_TYPE.Value);
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            
            string procedure = "";
            if (this.cbo01_SEARCH_OPT.Value.ToString().Equals("VA3"))
            {
                procedure = "INQUERY_TOTAL";    // 집계
            }
            else
            {
                procedure = "INQUERY_DETAIL";   // 상세
            }
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);
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
                    if (this.cbo01_SEARCH_OPT.Value.ToString().Equals("VA3"))                    
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);                   
                    else                   
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
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            return true;
        }

        #endregion

    }
}
