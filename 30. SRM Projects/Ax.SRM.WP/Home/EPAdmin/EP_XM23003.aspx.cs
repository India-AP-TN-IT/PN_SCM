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

namespace Ax.EP.WP.Home.EPAdmin
{
    /// <summary>
    /// EP_XM23003 <b>공지사항 목록</b>
    /// </summary>
    public partial class EP_XM23003 : BasePage
    {
        private string pakageName = "APG_EP_XM23003";

        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM23003
        /// </summary>
        public EP_XM23003()
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
                    this.SetCombo(); //콤보상자 바인딩//임시저장
                    Reset();
                    Search();
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

        #endregion

        #region [ 버튼설정 ]
        /// <summary>
        /// BuildButtons 
        /// 버튼생성
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Write, ButtonImage.Write, "Write", this.ButtonPanel);
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

                case ButtonID.Write:
                    Write(sender, e);
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
                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                HttpCookie cookie = new HttpCookie("PARAM_ID", "");
                HttpContext.Current.Response.Cookies.Add(cookie);

                HttpCookie cookie02 = new HttpCookie("PARAM_NM", "");
                HttpContext.Current.Response.Cookies.Add(cookie02);
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
        /// Search
        /// </summary>
        public void HR_Search()
        {
            try
            {
                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                HttpCookie cookie = new HttpCookie("PARAM_ID", this.cbo01_PARAM.Value.ToString());
                HttpContext.Current.Response.Cookies.Add(cookie);
                
                HttpCookie cookie02 = new HttpCookie("PARAM_NM", this.txt01_PARAMT.Text);
                HttpContext.Current.Response.Cookies.Add(cookie02);
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
            this.cbo01_PARAM.SelectedItem.Value = string.Empty;
            this.cbo01_PARAM.UpdateSelectedItems(); //꼭 해줘야한다.

            this.txt01_PARAMT.Text = string.Empty;
            
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
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("PARAM_ID", this.cbo01_PARAM.Value);
            param.Add("PARAM_NM", this.txt01_PARAMT.Text);
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// Update 조회수
        /// </summary>
        /// <returns></returns>
        private void getUpdate()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("NOTICE_SEQ", this.txt01_NOTICE_SEQ.Text);
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "UPDATE_SEQ"), param);
            }
        }

        /// RowSelect Handles the Event event of the RowDblClick control. ( 공지사항 클릭 )
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Ext.Net.DirectEventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void RowSelect(object sender, DirectEventArgs e)
        {
            string json = e.ExtraParams["Values"];
            Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);
            if(parameters.Length == 0)
                return;

            this.txt01_NOTICE_SEQ.Text = parameters[0]["NOTICE_SEQ"].ToString();

            if (!string.IsNullOrEmpty(parameters[0]["INSERT_ID"].ToString()))
            {
                // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                HEParameterSet param = new HEParameterSet();
                param.Add("NOTICE_SEQ", this.txt01_NOTICE_SEQ.Text);
                param.Add("INSERT_ID", parameters[0]["INSERT_ID"].ToString());

                //조회수 증가
                getUpdate();

                Util.UserPopup(this, this.UserHelpURL.Text, param, "HELP_XM23003P2", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
            }
        }

        /// ( 작성하기 버튼 )
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Ext.Net.DirectEventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Write(object sender, DirectEventArgs e)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("NOTICE_SEQ", string.Empty);
            param.Add("INSERT_ID", string.Empty);

            Util.UserPopup(this, this.UserHelpURL.Text, param, "HELP_XM23003P2", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
        }

        /// <summary>
        /// 콤보상자 바인딩(발생구분)
        /// </summary>
        private void SetCombo()
        {
            //조회조건
            DataTable dt = new DataTable();
            dt.Columns.Add("TYPENM");
            dt.Columns.Add("OBJECT_ID");
            dt.Rows.Add("제목", "01");
            dt.Rows.Add("내용", "02");
            dt.Rows.Add("작성자", "03");
            Library.ComboDataBind(this.cbo01_PARAM, dt, true, false);
        }

        /// <summary>
        /// etc_Button_Click
        /// 사용자 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void etc_Button_Click(object sender, EventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_HR_SEARCH":
                    this.Store1.RemoveAll();
                    HR_Search();
                    break;

                default:
                    break;
            }
        }

        #endregion
    }
}