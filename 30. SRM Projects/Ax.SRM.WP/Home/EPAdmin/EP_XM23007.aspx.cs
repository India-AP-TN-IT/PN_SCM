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
    /// EP_XM23007 <b>품질담당자 게시판 목록</b>
    /// </summary>
    public partial class EP_XM23007 : BasePage
    {
        private string pakageName = "APG_EP_XM23006";

        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM23007
        /// </summary>
        public EP_XM23007()
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
                if (!X.IsAjaxRequest) Search();

              
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
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("PARAM_ID", string.Empty);
            param.Add("PARAM_NM", string.Empty);
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
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

            this.txt01_NOTICE_SEQ.Text = parameters[0]["NOTICE_SEQ"].ToString();

            if (!string.IsNullOrEmpty(parameters[0]["INSERT_ID"].ToString()))
            {
                // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                HEParameterSet param = new HEParameterSet();
                param.Add("NOTICE_SEQ", this.txt01_NOTICE_SEQ.Text);
                param.Add("INSERT_ID", parameters[0]["INSERT_ID"].ToString());

                //조회수 증가
                getUpdate();

                Util.UserPopup(this, this.UserHelpURL.Text, param, "HELP_XM23006P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
            }
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

        #endregion
    }
}