using System;
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MM
{

    public partial class SRM_MM32001 : BasePage
    {
        private string pakageName = "APG_SRM_MM32001";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM32001
        /// </summary>
        public SRM_MM32001()
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

            DataTable source = Library.GetTypeCode("1K").Tables[0];
            source.DefaultView.RowFilter = "TYPECD NOT IN ('NI')";
            Library.ComboDataBind(this.cbo01_PURC_PO_TYPE, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
            this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

            source = Library.GetTypeCode("1A").Tables[0];
            Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", false);
            if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
            {
                this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
            }
            this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

            source = Library.GetTypeCode("1Z").Tables[0];
            Library.ComboDataBind(this.cbo01_SEARCH_OPT, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
            this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.

            HEParameterSet param = new HEParameterSet();
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_COMBO"), param).Tables[0];
            Library.ComboDataBind(this.cbo01_DATE, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
            this.cbo01_DATE.UpdateSelectedItems(); //꼭 해줘야한다.
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

        #region [코드박스 이벤트 핸들러]


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
            //업체코드는 서연이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cbo01_SEARCH_OPT.SelectedItem.Value = "1ZD";
            this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.

            this.txt01_FPARTNO.SetValue(string.Empty);
            this.txt01_PONO.SetValue(string.Empty);
            this.txt01_DELI_NOTE.SetValue(string.Empty);

            this.cdx01_STR_LOC.SetValue(string.Empty);

            this.cbo01_DATE.SelectedItem.Value = "PO_DELI_DATE";
            this.cbo01_DATE.UpdateSelectedItems(); //꼭 해줘야한다.

            this.Today.SetValue(DateTime.Now.ToString("yyyy-MM-dd"));

            this.Grid02.Show();
            this.Grid01.Hide();

            this.Store1.RemoveAll();
            this.Store3.RemoveAll();

            changeCondition(null, null);            
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
            param.Add("VENDCD", cdx01_VENDCD.Value);
            param.Add("DATE_TYPE", cbo01_DATE.Value);
            param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));            
            param.Add("PURC_ORG", cbo01_PURC_ORG.Value);
            param.Add("PURC_PO_TYPE", cbo01_PURC_PO_TYPE.Value);
            param.Add("PARTNO", txt01_FPARTNO.Value);
            param.Add("STR_LOC", cdx01_STR_LOC.Value); //저장위치
            param.Add("TYPE", cbo01_SEARCH_OPT.Value);
            param.Add("PONO", txt01_PONO.Value);
            param.Add("DELI_NOTE", txt01_DELI_NOTE.Value);
            param.Add("CUSTCD", cdx01_CUSTCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);            

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
            if (this.cdx01_VENDCD.IsEmpty && !(this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10")))
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            if (this.cbo01_BIZCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_BIZCD", lbl01_BIZCD.Text);
                return false;
            }

            if (this.df01_FROM_DATE.IsEmpty || this.df01_TO_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_FROM_DATE", cbo01_DATE.SelectedItem.Text);
                return false;
            }
            
            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
                return false;
            }

            return true;
        }

        #endregion

        #region [사용자 함수]
        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_STR_LOC_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            // UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
            if (this.cbo01_BIZCD.Value == null)
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
            else
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.Value);
        }


        protected void cbo01_SEARCH_OPT_Change(object sender, DirectEventArgs e)
        {
            Store1.RemoveAll();
            Store3.RemoveAll();
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

        public void changeCondition(object sender, DirectEventArgs e)
        {
            try
            {
                if (cbo01_PURC_ORG.Value.ToString().Equals("1A1110"))
                {
                    this.cbo01_DATE.SelectedItem.Value = "PO_DATE";
                    this.cbo01_DATE.UpdateSelectedItems(); //꼭 해줘야한다.
                }
                else if (cbo01_PURC_ORG.Value.ToString().Equals("1A1100"))
                {
                    this.cbo01_DATE.SelectedItem.Value = "PO_DELI_DATE";
                    this.cbo01_DATE.UpdateSelectedItems(); //꼭 해줘야한다.
                }
            }
            catch
            {
            }

            changeCondition_Date(null, null);
        }

        public void changeCondition_Date(object sender, DirectEventArgs e)
        {
            try
            {
                if (this.cbo01_DATE.Value.ToString().Equals("PO_DATE") && cbo01_PURC_ORG.Value.ToString().Equals("1A1110"))
                {
                    this.df01_FROM_DATE.SetValue(DateTime.Now.AddDays(-90).ToString("yyyy-MM-dd"));
                }
                else
                {
                    this.df01_FROM_DATE.SetValue(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
                }
            }
            catch
            {
                this.df01_FROM_DATE.SetValue(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
            }

            this.df01_TO_DATE.SetValue(DateTime.Now);
        }

        [DirectMethod]
        public void MakePopUp(String[] arr, string type)
        {            
            // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
            HEParameterSet param = new HEParameterSet();
            if (type.Equals("S"))
            {
                param.Add("CORCD", UserInfo.CorporationCode);
                param.Add("BIZCD", cbo01_BIZCD.Value);
                param.Add("VENDCD", arr[7]);
                param.Add("PURC_ORG", arr[0]);
                param.Add("PURC_PO_TYPE", arr[1]);
                param.Add("VINCD", arr[2]);
                param.Add("PARTNO", arr[3]);
                param.Add("PARTNM", arr[4]);
                param.Add("UNIT", arr[5]);
                param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));            
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM32002P1.aspx", param, "HELP_MM32002P1", "Popup", 800, 600);
            }
            else if (type.Equals("O"))
            {
                param.Add("CORCD", UserInfo.CorporationCode);
                param.Add("BIZCD", cbo01_BIZCD.Value);
                param.Add("VENDCD", arr[7]);
                param.Add("PURC_ORG", arr[0]);
                param.Add("PURC_PO_TYPE", arr[1]);
                param.Add("VINCD", arr[2]);
                param.Add("PARTNO", arr[3]);
                param.Add("PARTNM", arr[4]);
                param.Add("UNIT", arr[5]);
                param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM32001P1.aspx", param, "HELP_MM32001P1", "Popup", 800, 600);
            }
            else if (type.Equals("I"))
            {
                param.Add("CORCD", UserInfo.CorporationCode);
                param.Add("BIZCD", cbo01_BIZCD.Value);
                param.Add("VENDCD", arr[7]);
                param.Add("PURC_ORG", arr[0]);
                param.Add("PURC_PO_TYPE", arr[1]);
                param.Add("PURC_GRP", arr[6]);
                param.Add("PARTNO", arr[3]);
                param.Add("PARTNM", arr[4]);
                param.Add("UNIT", arr[5]);
                param.Add("GRN_NO", "");
                param.Add("DATE_TYPE", this.cbo01_DATE.Value); //날짜 조건에 따라 팝업 조회 조건 변경
                param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DIV", "D");
                param.Add("CUSTCD", arr[8]);
                //입하정보
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM31006P2.aspx", param, "HELP_MM31006P2", "Popup", 800, 600);
            }
            else if (type.Equals("M"))
            {
                param.Add("CORCD", UserInfo.CorporationCode);
                param.Add("BIZCD", cbo01_BIZCD.Value);
                param.Add("VENDCD", arr[5]);
                param.Add("PURC_ORG", arr[6]);
                param.Add("PURC_PO_TYPE", arr[7]);
                param.Add("PURC_GRP", arr[8]);
                param.Add("PARTNO", arr[1]);
                param.Add("PARTNM", arr[2]);
                param.Add("UNIT", arr[3]);
                param.Add("GRN_NO", arr[4]);
                param.Add("DATE_TYPE", this.cbo01_DATE.Value); //날짜 조건에 따라 팝업 조회 조건 변경
                param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));
                param.Add("DIV", "D");
                param.Add("CUSTCD", arr[9]);
                //입하정보
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM31006P2.aspx", param, "HELP_MM31006P2", "Popup", 800, 600);
            }
            else
            {
                //param.Add("PONO", param1);
                param.Add("PONO", arr[0]);
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM32002P2.aspx", param, "HELP_MM32002P2", "Popup", 800, 600);
            }
        }
        #endregion
    }
}
