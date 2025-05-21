#region ▶ Description & History
/* 
 * 프로그램명 : MIP A/S/K 자재소요계획 현황(구.VM3320)
 * 설      명 : 자재관리 > 소요관리 > MIP A/S/K 자재소요계획 현황
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-09-16
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

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM30012 : BasePage
    {
        private string pakageName = "APG_SRM_MM30012";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SCM_MM30002
        /// </summary>
        public SRM_MM30012()
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

                    DataTable source  = Library.GetTypeCode("1Z","A").Tables[0];
                    Library.ComboDataBind(this.cbo01_SEARCH_OPT, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.

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
                if (result.Tables[0].Rows.Count > 20000)
                {
                    MsgCodeAlert_ShowFormat("SRMMM-0061", "", "20000");
                    return;
                }
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

            this.cbo01_SEARCH_OPT.SelectedItem.Value = "1ZS";
            this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            
            this.txt01_SUBCON_PARTNO.Text = string.Empty;
            this.txt01_PARTNO.Text = string.Empty;
            this.cdx01_VINCD.SetValue(string.Empty);
            

            this.df01_DELI_DATE.SetValue(DateTime.Now);

            this.Grid01.Show();
            this.Grid02.Hide();

            this.Store1.RemoveAll();
            this.Store3.RemoveAll();  
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("PLAN_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("PARTNO", this.txt01_SUBCON_PARTNO.Value); //외작
            param.Add("MIP_PARTNO", this.txt01_PARTNO.Value);    //내작
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("TYPE", cbo01_SEARCH_OPT.Value);
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
                Store3.RemoveAll();
                this.Grid01.Hide();
                this.Grid02.Show();
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
            if (this.df01_DELI_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_DELI_DATE", lbl01_PLAN_DATE.Text);
                return  false;
            }
            return true;
        }

        #endregion
    }
}