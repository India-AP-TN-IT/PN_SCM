using System;
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM26008 : BasePage
    {
        private string pakageName = "APG_SRM_MM26008";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM32001
        /// </summary>
        public SRM_MM26008()
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
                    this.SetCombo();
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
            Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);

            // 구매조직(유통경로)
            DataTable source = Library.GetTypeCode("2A").Tables[0];
            source.DefaultView.RowFilter = "TYPECD IN ('70','72')";
            Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "ALL");
            this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

            source = Library.GetTypeCode("1Z").Tables[0];
            source.DefaultView.RowFilter = "TYPECD NOT IN ('C')";
            Library.ComboDataBind(this.cbo01_SEARCH_OPT, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", false);
            this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.

            source = GetAcpDiv();
            Library.ComboDataBind(this.cbo01_ACP_DIV, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "ALL");
            this.cbo01_ACP_DIV.UpdateSelectedItems(); //꼭 해줘야한다.
        }

        /// <summary>
        /// 검수구분 콤보박스
        /// </summary>
        /// <returns></returns>
        private DataTable GetAcpDiv()
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                HEParameterSet paramSet = new HEParameterSet();
                paramSet.Add("LANG_SET", Util.UserInfo.LanguageShort);

                return proxy.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "GET_ACP_DIV"), paramSet).Tables[0];
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

            if (id == ButtonID.Search || id == ButtonID.M_Search)
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "GridPanel";
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

        /// <summary>
        /// etc_Button_Click
        /// 사용자 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void etc_Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {                       
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
                // 집계
                if (this.cbo01_SEARCH_OPT.Value.Equals("1ZS"))
                {
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
                }
                else //상세, 취소
                {
                    this.Store3.DataSource = result.Tables[0];
                    this.Store3.DataBind();
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

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            if (this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10"))
            {
                this.cdx01_CUSTCD.SetValue(string.Empty);
                this.cdx01_CUSTCD.ReadOnly = false;
            }
            else
            {
                this.cdx01_CUSTCD.ReadOnly = true;
            }

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_FROM_DATE.SetValue(DateTime.Now.ToString("yyyy-MM") + "-01");
            this.df01_TO_DATE.SetValue(DateTime.Now.ToString("yyyy-MM-dd"));

            this.cbo01_PURC_ORG.SelectedItem.Value = "";
            this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

            this.txt01_FPARTNO.SetValue(string.Empty);

            this.txt01_VGBEL.SetValue(string.Empty);
            this.txt01_VGPOS.SetValue(string.Empty);

            this.cbo01_ACP_DIV.SelectedItem.Value = "";
            this.cbo01_ACP_DIV.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cbo01_SEARCH_OPT.SelectedItem.Value = "1ZS";
            this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.

            this.Grid02.Hide();
            this.Grid01.Show();

            this.Store1.RemoveAll();
            this.Store3.RemoveAll();
        }

        /// <summary>
        /// 데이터 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("CUSTCD", cdx01_CUSTCD.Value);
            param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("PURC_ORG", cbo01_PURC_ORG.Value);
            param.Add("PARTNO", txt01_FPARTNO.Text);
            param.Add("VGBEL", txt01_VGBEL.Text);
            param.Add("VGPOS", txt01_VGPOS.Text);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            string procedureName = "";
            switch (cbo01_SEARCH_OPT.Value.ToString())
            {
                case "1ZS":
                    procedureName = "INQUERY_SUMMARY";
                    break;
                case "1ZD":
                    procedureName = "INQUERY_DETAIL";
                    param.Add("ACP_DIV", cbo01_ACP_DIV.Value);
                    break;
            }

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedureName), param);
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
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], (cbo01_SEARCH_OPT.Value.Equals("1ZS") ? Grid01 : Grid02));
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
            if (this.cdx01_CUSTCD.IsEmpty && !(this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10")))
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_CUSTCD", lbl01_CUST.Text);
                return false;
            }

            if (this.cbo01_BIZCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_BIZCD", lbl01_SAUP.Text);
                return false;
            }

            if (this.df01_FROM_DATE.IsEmpty || this.df01_TO_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_FROM_DATE", lbl01_BILLING_DATE.Text);
                return false;
            }
            
            /*
            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
                return false;
            }
            */
            return true;
        }

        #endregion

        #region [사용자 함수]

        protected void cbo01_SEARCH_OPT_Change(object sender, DirectEventArgs e)
        {
            Ext.Net.ComboBox cbo = (Ext.Net.ComboBox)sender;
            if (cbo.Value.Equals("1ZS"))
            {
                this.Grid01.Show();
                this.Grid02.Hide();
            }
            else
            {
                this.Grid01.Hide();
                this.Grid02.Show();                
            }
            
        }

        #endregion
    }
}
