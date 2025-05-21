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
    public partial class SRM_QA30001 : BasePage
    {
        private string pakageName = "APG_SRM_QA30001";
        

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA30001
        /// </summary>
        public SRM_QA30001()
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
        public void etc_Button_Click(object sender, EventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_POP_QA30001P1":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    HEParameterSet set = new HEParameterSet();
                    set.Add("INSPECT_DIV", V_INSPECT_DIV.Value);
                    set.Add("BIZCD", V_BIZCD.Value);
                    set.Add("VENDCD", V_VENDCD.Value);
                    set.Add("RCV_DATE", DateTime.Parse(RCV_DATE02.Value.ToString()).ToString("yyyy-MM-dd"));
                    set.Add("DEFNO", DEFNO02.Value);

                    Util.UserPopup((BasePage)this.Form.Parent.Page, this.UserHelpURL.Text, set, "HELP_QA30001P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
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
                
                //Reset();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }            
            finally
            {
                /* 결재 테스트 
                GWApprovaler gwapprovaler = new GWApprovaler("QA40034_1", "한도견본보유현황", true);

                // GW_Instance 용 파라메터 ( 신형은 호출 파라메터를 파라메터 셋으로 정의하여야 함 )
                // 주의 : 파라메터 앞에 IN_ 를 붙여야 함(프로시저 파라메터와 이름 동일), 프로시저의 파라메터 순서와 동일하여야 함
                HEParameterSet param = new HEParameterSet();
                param.Add("IN_CORCD", this.UserInfo.CorporationCode);
                param.Add("IN_BIZCD", this.UserInfo.BusinessCode);
                param.Add("IN_PRINT_DATE", DateTime.Now.ToString("yyyy-MM-dd"));
                param.Add("IN_BOUT_YN", "N");
                param.Add("IN_PID", gwapprovaler.ERPID);

                // 첨부파일 있을경우 ( true 옵션은 결재연동후 자동삭제 )
                gwapprovaler.FileAdd(@"D:\안드로이드교육자료\Android 기본 - Ch1~Ch4.pptx");
                gwapprovaler.FileAdd(@"D:\안드로이드교육자료\Android 기본 - Ch5~Ch8.pptx");

                // GW_Instance 용 파라메터 전달
                gwapprovaler.CallWithoutEvent("GWP_QA40034_1", param);
                */
            }
        }

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);

            this.df01_RCV_DATE.SetValue(DateTime.Now.ToString("yyyy-MM"));

            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }
            Store1.RemoveAll();
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
            param.Add("RCV_DATE", ((DateTime)this.df01_RCV_DATE.Value).ToString("yyyy-MM"));
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);

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

            if (this.df01_RCV_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "df01_RCV_DATE", lbl01_STD_YYMM.Text);
                return  false;
            }
            return true;
        }

        #endregion
    }
}
