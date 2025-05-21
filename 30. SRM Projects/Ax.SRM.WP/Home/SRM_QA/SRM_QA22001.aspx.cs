#region ▶ Description & History
/* 
 * 프로그램명 : X-Bar R관리 조회/등록
 * 설      명 : 품질관리 > 공정능력관리
 * 최초작성자 : 배명희
 * 최초작성일 : 2014-09-29
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

namespace Ax.SRM.WP.Home.SRM_QA
{

    public partial class SRM_QA22001 : BasePage
    {
        private string pakageName = "APG_SRM_QA22001";
        

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA22001
        /// </summary>
        public SRM_QA22001()
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
                    Library.GetBIZCD(this.SelectBox01_BIZCD, this.UserInfo.CorporationCode, false);
                    this.SetUseYNCombo(); //콤보상자 바인딩(서열지유형)
                    this.Reset();           //초기화
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
        /// 더블클릭시 검사성적서 등록 팝업 표시한다.
        /// </summary>
        /// <param name="qty"></param>
        /// <param name="partno"></param>
        /// <param name="barcode"></param>
        /// <param name="deli_date"></param>
        /// <param name="deli_cnt"></param>
        [DirectMethod]
        public void Cell_DoubleClick(string serial)
        {
            // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
            HEParameterSet set = new HEParameterSet();
            set.Add("BIZCD", this.SelectBox01_BIZCD.Value);
            set.Add("VENDCD", this.cdx01_VENDCD.Value);
            set.Add("YM", ((DateTime)this.df01_WRITE_MONTH.Value).ToString("yyyy-MM"));
            set.Add("CARTYPE", this.cdx01_VINCD.Value);
            set.Add("ITEMCODE", this.cdx01_MAT_TYPE.Value);
            set.Add("MEASCD", this.cdx01_INPSECT_CLASSCD.Value);
            set.Add("SEARCHGB", this.SelectBox01_USEYN.Value);
            set.Add("SERIAL", serial);
           
           
            //Util.UserPopup(this, "HELP_CUST_ITEMCD", PopupHelper.HelpType.Search, "GRID_CUST_ITEMCD_HELP01", this.CodeValue.Text, this.NameValue.Text, "", PopupHelper.defaultPopupWidth, PopupHelper.defaultPopupHeight, set);

            Util.UserPopup(this, this.UserHelpURL.Text, set, "HELP_QA23001P2", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
        }


        #endregion

        #region [코드박스 이벤트 핸들러]
        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void CodeBox_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            // UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
            if (this.SelectBox01_BIZCD.Value == null)
                cdx.UserParamSet.Add("BIZCD", this.SelectBox01_BIZCD.SelectedItem.Value);
            else
                cdx.UserParamSet.Add("BIZCD", this.SelectBox01_BIZCD.Value);
        }


        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 벨리데이션
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void CodeBox_CustomRemoteValidation(object sender, EP.UI.EPCodeBox_ValidationResult rsltSet)
        {
            // 커스텀시 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            /* DB 의 코드를 통한 검증 로직 작성 및 결과 값 리턴 - 여기부터 */
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", SelectBox01_BIZCD.Value);
            param.Add("INSPECT_CLASSCD", cdx.TypeCD);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);

            DataSet ds = EPClientHelper.ExecuteDataSet("APG_SRM_QA22001.INSPECT_CLASSCD_VALIDATION", param);

            rsltSet.resultDataSet = ds;                                             //  결과 데이터셋
            rsltSet.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true; // 동일한 데이터가 있으면 true 없으면 false
            rsltSet.returnValueFieldName = "INSPECT_CLASSCD";
            rsltSet.returnTextFieldName = "INSPECT_CLASSNM";
        }

        #endregion

        #region [ 기능 ]

    

        /// <summary>
        /// 콤보상자 바인딩(사용여부)
        /// </summary>
        private void SetUseYNCombo()
        {
            
            DataSet source = new DataSet();
            DataTable dt = new DataTable();
            dt.Columns.Add("CODE");
            dt.Columns.Add("NAME");

            dt.Rows.Add("Y", "Y");
            dt.Rows.Add("N", "N");
            source.Tables.Add(dt);
            Library.ComboDataBind(this.SelectBox01_USEYN, dt, false, "NAME", "CODE", true);        
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
            this.SelectBox01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.SelectBox01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }

            this.df01_WRITE_MONTH.SetValue(DateTime.Now.ToString("yyyy-MM"));

            this.cdx01_VINCD.SetValue(string.Empty);
            this.cdx01_MAT_TYPE.SetValue(string.Empty);
            this.cdx01_INPSECT_CLASSCD.SetValue(string.Empty);


            if (SelectBox01_USEYN.Items.Count > 0)
            {
                this.SelectBox01_USEYN.SelectedItem.Index = 0;
                this.SelectBox01_USEYN.UpdateSelectedItems(); //꼭 해줘야한다.
            }
            this.Store1.RemoveAll();     
        }



        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("YYYYMM", ((DateTime)this.df01_WRITE_MONTH.Value).ToString("yyyy-MM"));  
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.SelectBox01_BIZCD.Value);
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("ITEMCD", this.cdx01_MAT_TYPE.Value);
            param.Add("MEAS_ITEMCD", this.cdx01_INPSECT_CLASSCD.Value);
            param.Add("USE_YN", this.SelectBox01_USEYN.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("SERIAL", "");
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            
                       
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
            if (this.df01_WRITE_MONTH.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "df01_WRITE_MONTH", lbl01_WRITE_MONTH.Text);
                return false;
            }

            return true;
        }

        #endregion
    }
}
