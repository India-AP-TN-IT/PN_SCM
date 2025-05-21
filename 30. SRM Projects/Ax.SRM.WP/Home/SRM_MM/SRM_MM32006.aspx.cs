using System;
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM32006 : BasePage
    {
        private string pakageName = "APG_SRM_MM32006";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM32006
        /// SCM 의 SCM_MM32005 아이디가 SRM 에서 SRM_MM32006 으로 변경 (신규 화면에 의한 아이디 중복)
        /// </summary>
        public SRM_MM32006()
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
            
            this.txt01_FPARTNO.Text = string.Empty;
            //this.txt01_TPARTNO.Text = string.Empty;

            this.df01_DELI_DATE.SetValue(DateTime.Now);

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
            param.Add("DELI_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("FPARTNO", this.txt01_FPARTNO.Text);
            //param.Add("TPARTNO", this.txt01_TPARTNO.Text.Equals(string.Empty) ? "Z" : this.txt01_TPARTNO.Text);
            param.Add("DELI_CNT", this.txt01_DELI_CNT.Value);
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
            if (this.cdx01_VENDCD.IsEmpty && !(this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10")))
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            if (this.df01_DELI_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_DELI_DATE", lbl01_DELIVERYDATE.Text);
                return  false;
            }
            return true;
        }

        #endregion
    }
}
