#region ▶ Description & History
/* 
 * 프로그램명 : 일검수/월검수 조회(구.VP4010)
 * 설      명 : 생산협업 > 검수정보관리 > 일검수/월검수 조회
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-01
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
    public partial class SRM_SD31001 : BasePage
    {
        private string pakageName = "APG_SRM_SD31001";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SCM_SD31001
        /// </summary>
        public SRM_SD31001()
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
                    Library.ComboDataBind(this.cbo01_DOM_DIV, Library.GetTypeCode("EJ").Tables[0], true, "OBJECT_NM", "TYPECD", true);
                    Library.ComboDataBind(this.cbo01_JOB_TYPE, Library.GetTypeCode("A1").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);
                    Library.ComboDataBind(this.cbo01_SEARCH_OPT, Library.GetTypeCode("VA", "5").Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);

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
            //업체코드는 서연이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_SDATE.SetValue(DateTime.Now);
            this.df01_EDATE.SetValue(DateTime.Now);

            this.df01_SDATE2.SetValue(DateTime.Now);
            this.df01_EDATE2.SetValue(DateTime.Now);

            this.cbo01_DOM_DIV.SelectedItem.Value = "";
            this.cbo01_DOM_DIV.UpdateSelectedItems();

            this.cbo01_JOB_TYPE.SelectedItem.Value = "";
            this.cbo01_JOB_TYPE.UpdateSelectedItems();

            this.cbo01_SEARCH_OPT.SelectedItem.Value = "VA9";
            this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.

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
            if (this.cbo01_SEARCH_OPT.SelectedItem.Value == "VA9")
            {
                param.Add("SDATE", ((DateTime)this.df01_SDATE.Value).ToString("yyyy-MM-dd"));
                param.Add("EDATE", ((DateTime)this.df01_EDATE.Value).ToString("yyyy-MM-dd"));
            }
            else
            {
                param.Add("SYYYYMM", ((DateTime)this.df01_SDATE2.Value).ToString("yyyy-MM"));
                param.Add("EYYYYMM", ((DateTime)this.df01_EDATE2.Value).ToString("yyyy-MM"));
            }
            param.Add("DOM_DIV", this.cbo01_DOM_DIV.Value);
            param.Add("JOB_TYPE", this.cbo01_JOB_TYPE.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);            
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            string procedure = "";
            if (this.cbo01_SEARCH_OPT.SelectedItem.Value == "VA9")
            {
                procedure = "INQUERY_DAY";
            }
            else
            {
                procedure = "INQUERY_MONTH";
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
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.df01_SDATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_SDATE", lbl01_ACP_STD.Text);
                return  false;
            }
            if (this.df01_EDATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_EDATE", lbl01_ACP_STD.Text);
                return false;
            }
            return true;
        }

        #endregion

        #region [ 이벤트 ]

        protected void cbo01_SEARCH_OPT_Change(object sender, DirectEventArgs e)
        {
            this.Store1.RemoveAll();

            if (cbo01_SEARCH_OPT.SelectedItem.Value.Equals("VA9"))
            {
                this.ACP_DATE.Hidden = false;
                this.ACP_YYYYMM.Hidden = true;
                this.contACPDAY.Hidden = false;
                this.contACPMONTH.Hidden = true;
            }
            else
            {
                this.ACP_DATE.Hidden = true;
                this.ACP_YYYYMM.Hidden = false;
                this.contACPDAY.Hidden = true;
                this.contACPMONTH.Hidden = false;
            }
        }

        #endregion
    }
}
