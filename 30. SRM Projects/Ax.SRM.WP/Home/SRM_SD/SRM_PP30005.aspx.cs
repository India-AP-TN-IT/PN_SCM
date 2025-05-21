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
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_SD
{

    public partial class SRM_PP30005 : BasePage
    {
        private string pakageName = "APG_SRM_PP30005";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_PM30005
        /// </summary>
        public SRM_PP30005()
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
                    this.SetCombo();    //위치 정보 콤보상자 바인딩
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
            try
            {
                //위치
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", Util.UserInfo.BusinessCode);
                param.Add("USER_ID", Util.UserInfo.UserID);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                param.Add("VENDCD", "");
                DataSet ds2 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_MM35003", "INQUERY_INSTALL_POS"), param);
                Library.ComboDataBind(this.SelectBox01_INSTALL_POS, ds2.Tables[0], false, "TYPECD", "OBJECT_ID", true);
            }
            catch
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
            this.SelectBox01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.SelectBox01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            if (this.SelectBox01_INSTALL_POS.Items.Count > 0)
            {
                this.SelectBox01_INSTALL_POS.SelectedItem.Index = 0;
                this.SelectBox01_INSTALL_POS.UpdateSelectedItems(); //꼭 해줘야한다.
            }

            this.cdx01_LINECD.SetValue("");

            this.df01_BEG_DATE.SetValue(DateTime.Now);

            this.Store1.RemoveAll();
            
        }



        /// <summary>
        /// 데이터 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", SelectBox01_BIZCD.Value);
            param.Add("BEG_DATE", ((DateTime)this.df01_BEG_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("END_DATE", ((DateTime)this.df01_BEG_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("LINECD", cdx01_LINECD.Value);
            param.Add("INSTALL_POS", SelectBox01_INSTALL_POS.Value);
            param.Add("SHIFT", "");
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

            if (this.df01_BEG_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_BEG_DATE", lbl01_WORK_DATE3.Text);
                return  false;
            }

            if (this.cdx01_LINECD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_LINECD", lbl01_LINECD.Text);
                return false;
            }
            return true;
        }

        #endregion
    }
}
