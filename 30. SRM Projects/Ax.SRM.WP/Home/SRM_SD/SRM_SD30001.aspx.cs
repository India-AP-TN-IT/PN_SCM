#region ▶ Description & History
/* 
 * 프로그램명 : MOBIS 예상발주(구.VC3060)
 * 설      명 : 생산협업 > 예상발주관리 > MOBIS 예상발주
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
    public partial class SRM_SD30001 : BasePage
    {
        private string pakageName = "APG_SRM_SD30001";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SCM_SD30001
        /// </summary>
        public SRM_SD30001()
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
                    // Ajax Timeout 설정
                    this.ResourceManager1.AjaxTimeout = Util.GetSendTimeOut(Server.MapPath("/"));

                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);
                    Library.ComboDataBind(this.cbo01_JOB_TYPE, Library.GetTypeCode("A1").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);

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

            this.df01_RECEIPT_DATE.SetValue(DateTime.Now);

            this.cbo01_JOB_TYPE.SelectedItem.Value = "";
            this.cbo01_JOB_TYPE.UpdateSelectedItems();

            this.Store1.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            //기준일자 max 가져오기
            HEParameterSet param2 = new HEParameterSet();
            param2.Add("CORCD", Util.UserInfo.CorporationCode);
            param2.Add("BIZCD", this.cbo01_BIZCD.Value);
            param2.Add("LANG_SET", this.UserInfo.LanguageShort);
            param2.Add("USER_ID", this.UserInfo.UserID);
            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_MAX"), param2);

            string maxDate = "";
            if (ds.Tables[0].Rows.Count > 0)
                maxDate = ds.Tables[0].Rows[0]["RECEIPT_DATE"].ToString();

            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            //max 기준일자와 입력한 기준일자가 다르면 max 기준일자로 조회하
            if (!maxDate.Equals("") && maxDate != ((DateTime)this.df01_RECEIPT_DATE.Value).ToString("yyyy-MM-dd"))
                param.Add("RECEIPT_DATE", maxDate);
            else
                param.Add("RECEIPT_DATE", ((DateTime)this.df01_RECEIPT_DATE.Value).ToString("yyyy-MM-dd"));
            //조회 업체가 없으면 서연이화로 조회
            param.Add("VENDCD", this.cdx01_VENDCD.Value.ToString().Equals("") ? "100000" : this.cdx01_VENDCD.Value);
            param.Add("SUBCON_DIV", this.cdx01_VENDCD.Value.ToString().Equals("") ? "P" : "C");
            if (this.cbo01_JOB_TYPE.Value.Equals(""))
            {
                param.Add("DEPT1", "EH0");
                param.Add("DEPT2", "EK0");
                param.Add("DEPT3", "M00");
            }
            else if (this.cbo01_JOB_TYPE.Value.Equals("A1A"))
            {
                param.Add("DEPT1", "M00");
                param.Add("DEPT2", "");
                param.Add("DEPT3", "");
            }
            else if (this.cbo01_JOB_TYPE.Value.Equals("A1S"))
            {
                param.Add("DEPT1", "EH0");
                param.Add("DEPT2", "EK0");
                param.Add("DEPT3", "");
            }
            else
            {
                param.Add("DEPT1", "");
                param.Add("DEPT2", "");
                param.Add("DEPT3", "");
            }
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
            //if (this.cdx01_VENDCD.IsEmpty)
            //{
            //    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
            //    return false;
            //}
            if (this.df01_RECEIPT_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_RECEIPT_DATE", lbl01_STD_DATE.Text);
                return  false;
            }
            return true;
        }

        #endregion

    }
}
