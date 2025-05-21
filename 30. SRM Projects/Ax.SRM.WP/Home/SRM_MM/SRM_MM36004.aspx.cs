#region ▶ Description & History
/* 
 * 프로그램명 : 일별 사급 현황 (구.VM3140)
 * 설      명 : 자재관리 > 사급관리 > 일별 사급 현황
 * 최초작성자 : 이명희
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

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM36004 : BasePage
    {
        private string pakageName = "APG_SRM_MM36004";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM36004
        /// </summary>
        public SRM_MM36004()
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
                    Library.ComboDataBind(this.cbo01_SEARCH_OPT, Library.GetTypeCode("VA", "6").Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);

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
                if (this.cbo01_SEARCH_OPT.Value.ToString().Equals("VA11"))
                {
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
                }
                else
                {
                    this.Store2.DataSource = result.Tables[0];
                    this.Store2.DataBind();
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
            //고객코드는 서연이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_CUSTCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_BEG_DATE.SetValue(DateTime.Now);
            this.df01_END_DATE.SetValue(DateTime.Now);

            this.cdx01_MAT_ITEM.SetValue(string.Empty);

            this.txt01_FPARTNO.Text = string.Empty;
            //this.txt01_TPARTNO.Text = string.Empty;

            this.cbo01_SEARCH_OPT.SelectedItem.Value = "VA11";
            this.cbo01_SEARCH_OPT.UpdateSelectedItems();

            this.Store1.RemoveAll();
            this.Store2.RemoveAll();
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
            param.Add("CUSTCD", this.cdx01_CUSTCD.Value);
            param.Add("OUT_DATE", ((DateTime)this.df01_BEG_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("OUT_DATE_END", ((DateTime)this.df01_END_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("PARTNO1", this.txt01_FPARTNO.Text);
            //param.Add("PARTNO2", this.txt01_TPARTNO.Text.Equals(string.Empty) ? "Z" : this.txt01_TPARTNO.Text);
            param.Add("MAT_ITEM", this.cdx01_MAT_ITEM.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            string procedureName = string.Empty;

            if (this.cbo01_SEARCH_OPT.Value.Equals("VA12"))
                procedureName = "INQUERY_S02";
            else
                procedureName = "INQUERY_S01";

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
                {
                    if (this.cbo01_SEARCH_OPT.Value.ToString().Equals("VA11"))
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);
                    else
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid02);                 
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
            if (this.cdx01_CUSTCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_CUSTCD", lbl01_CUST.Text);
                return false;
            }
            if (this.df01_BEG_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_BEG_DATE", lbl01_STD_DATE.Text);
                return  false;
            }
            if (this.df01_END_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_END_DATE", lbl01_STD_DATE.Text);
                return false;
            }
            return true;
        }

        #endregion

        #region [ 이벤트 ]

        protected void cbo01_SEARCH_OPT_Change(object sender, DirectEventArgs e)
        {
            this.Store1.RemoveAll();
            this.Store2.RemoveAll();

            if (cbo01_SEARCH_OPT.SelectedItem.Value.Equals("VA11"))
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
