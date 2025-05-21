#region ▶ Description & History
/* 
 * 프로그램명 : 납품실적조회(구.VP2080)
 * 설      명 : 생산협업 > 납품실적관리 > 납품실적조회
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-10
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
    public partial class SRM_SD32002 : BasePage
    {
        private string pakageName = "APG_SRM_SD32002";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SCM_SD32002
        /// </summary>
        public SRM_SD32002()
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
                    //Library.ComboDataBind(this.cbo01_JOB_TYPE, Library.GetTypeCode("A1").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);

                    this.SetCustCombo();

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

        private void SetCustCombo()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("GROUPCD", "SD014");
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_MM30002", "INQUERY_CODE"), param);

            Library.ComboDataBind(this.cbo01_CUST_COR, source.Tables[0], false, "CDNM", "CD", true);
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
            //업체코드는 서연이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_SDATE.SetValue(DateTime.Now.ToString("yyyy-MM") + "-01");
            this.df01_EDATE.SetValue(DateTime.Now);

            this.txt01_PARTNO.Text = string.Empty;

            //this.cbo01_JOB_TYPE.SelectedItem.Value = "";
            //this.cbo01_JOB_TYPE.UpdateSelectedItems();

            this.cbo01_CUST_COR.SelectedItem.Value = "M01";
            this.cbo01_CUST_COR.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_CUST_COR.ReadOnly = true;

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
            param.Add("SDATE", ((DateTime)this.df01_SDATE.Value).ToString("yyyy-MM-dd"));
            param.Add("EDATE", ((DateTime)this.df01_EDATE.Value).ToString("yyyy-MM-dd"));
            param.Add("PARTNO", this.txt01_PARTNO.Text);
            //param.Add("CUST_COR", this.cbo01_CUST_COR.Value);
            //param.Add("JOB_TYPE", this.cbo01_JOB_TYPE.Value);
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
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.df01_SDATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_SDATE", lbl01_STD_DATE.Text);
                return  false;
            }
            else
            {
                if (((DateTime)this.df01_SDATE.Value).Month != DateTime.Now.Month)
                {
                    this.MsgCodeAlert("SCMMM-0018", "df01_SDATE");//기준 시작일자는 이전달로 조회할 수 없습니다.
                    return false;
                }
            }
            if (this.df01_EDATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_EDATE", lbl01_STD_DATE.Text);
                return false;
            }            

            return true;
        }

        #endregion

    }
}
