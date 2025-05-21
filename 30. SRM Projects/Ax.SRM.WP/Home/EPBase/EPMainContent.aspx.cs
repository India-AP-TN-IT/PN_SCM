using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.EP.WP.Home.EPBase
{
    /// <summary>
    /// EPMainContent(KdCoMainM_Contents)  기본 메인 내용
    /// </summary>
    /// <remarks></remarks>
    public partial class EPMainContent : Ax.EP.Utility.BasePage
    {
        /// <summary>
        /// Page_Load Handles the Load event of the Page control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !X.IsAjaxRequest)
            {
                Notice_DataBind();          //공지사항
                VendorNotice_DataBind();    //협력업체 게시판
                Status_DataBind();          //발주현황 및 불량 현황 조회               

                string tag = this.lbl01_MSG_SRM_02.Text;
                this.lbl01_MSG_SRM_02.Text = string.Empty;
                this.lbl01_MSG_SRM_02.Html = tag.Replace("&lt;", "<").Replace("&gt;", ">").Replace("\"", "'");     
            }
       
        }

        /// <summary>
        /// Notice_DataBind 공지사항을 가져온다.
        /// </summary>
        /// <remarks></remarks>
        public void Notice_DataBind()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("USER_DIV", Util.UserInfo.UserDivision);
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EP_XM23001.INQUERY_MAIN_NOTICE", param, "OUT_CURSOR", "OUT_CURSOR_USER", "OUT_CURSOR_RATE");

            this.Store1.DataSource = ds.Tables[0];
            this.Store1.DataBind();
        }

        /// <summary>
        /// VendorNotice_DataBind 협력업체 게시판을 가져온다.
        /// </summary>
        /// <remarks></remarks>
        public void VendorNotice_DataBind()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EP_XM23003.INQUERY_MAIN_NOTICE", param);

            this.Store2.DataSource = ds.Tables[0];
            this.Store2.DataBind();
        }

        /// <summary>
        /// Status_DataBind 발주현황  및 불량 현황을 가져온다.
        /// </summary>
        /// <remarks></remarks>
        public void Status_DataBind()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("VENDCD", Util.UserInfo.VenderCD);
            param.Add("DELI_DATE", DateTime.Now.ToString(this.GlobalLocalFormat_Date));
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);
            
            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPCOMMON.INQUERY_MAIN_STATUS", param, "OUT_CURSOR", "OUT_CURSOR_DEF");

            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow dr = ds.Tables[0].Rows[0];
                this.lbl01_DATA_11.Text = string.Format("{0:#,##0}", dr["COL1"]);
                this.lbl01_DATA_12.Text = string.Format("{0:#,##0}", dr["COL2"]);
                this.lbl01_DATA_21.Text = string.Format("{0:#,##0}", dr["COL3"]);
                this.lbl01_DATA_22.Text = string.Format("{0:#,##0}", dr["COL4"]);
                this.lbl01_DATA_31.Text = string.Format("{0:#,##0}", dr["COL5"]);
                this.lbl01_DATA_32.Text = string.Format("{0:#,##0}", dr["COL6"]);
                this.lbl01_DATA_41.Text = string.Format("{0:#,##0}", dr["COL7"]);
                this.lbl01_DATA_42.Text = string.Format("{0:#,##0}", dr["COL8"]);
            }
           
            //서연이화 국내법인인 경우 입고품 불량 내용 현황 표시함.(그리드)
            if(this.UserInfo.CorporationCode.Equals("1000"))
            {
                this.div02.Visible = false;
                this.div01.Visible = true;

                DataSet ds2 = EPClientHelper.ExecuteDataSet("APG_EPCOMMON.INQUERY_MAIN_STATUS2", param);
                this.Store3.DataSource = ds2.Tables[0];
                this.Store3.DataBind();
            }
            else
            {
                //서연이화 해외법인인 경우 불량현황 통계 표시함.
                this.div02.Visible = true;
                this.div01.Visible = false;
                if (ds.Tables[1].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[1].Rows[0];
                    this.lbl01_TOT_CNT.Text = string.Format("{0:#,##0}", dr["TOT_CNT"]);
                    this.lbl01_TOT_PROC_CNT.Text = string.Format("{0:#,##0}", dr["TOT_PRC_CNT"]);
                    this.lbl01_MON_CNT.Text = string.Format("{0:#,##0}", dr["MON_CNT"]);
                    this.lbl01_MON_PROC_CNT.Text = string.Format("{0:#,##0}", dr["MON_PRC_CNT"]);
                    this.lbl01_DAY_CNT.Text = string.Format("{0:#,##0}", dr["DAY_CNT"]);
                    this.lbl01_DAY_PROC_CNT.Text = string.Format("{0:#,##0}", dr["DAY_PRC_CNT"]);
                }
            }
        }

        /// <summary>
        /// RowSelect Handles the Event event of the RowDblClick control. ( 공지사항 클릭 )
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Ext.Net.DirectEventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void RowSelect(object sender, DirectEventArgs e)
        {
            string json = e.ExtraParams["Values"];
            Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);
            X.Js.Call("newWindowPop", parameters[0]["NOTICE_SEQ"], 780, 550);
        }

        /// <summary>
        /// RowSelect Handles the Event event of the RowDblClick control. ( 협력업체 게시판 클릭 )
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Ext.Net.DirectEventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void VendorRowSelect(object sender, DirectEventArgs e)
        {
            string json = e.ExtraParams["Values"];
            Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

            if (parameters.Length == 0)
                return;

            string id = "";

            //조회수 증가
            if(parameters[0]["SUBJECT"].ToString().Contains("[품질]") == true)
            {
                id = "APG_EP_XM23006";
                getUpdate(parameters[0]["NOTICE_SEQ"].ToString(), id);
            }
            else
            {
                id = "APG_EP_XM23003";
                getUpdate(parameters[0]["NOTICE_SEQ"].ToString(), id);
            }

            //이전글, 다음글 클릭시 조회 조건 넘겨주기 위해 필요한 설정.
            //메인에서는 디폴트로 빈문자 넘긴다.
            HttpCookie cookie = new HttpCookie("PARAM_ID", "");
            HttpContext.Current.Response.Cookies.Add(cookie);
            HttpCookie cookie02 = new HttpCookie("PARAM_NM", "");
            HttpContext.Current.Response.Cookies.Add(cookie02);

            X.Js.Call("newWindowPop2", parameters[0]["NOTICE_SEQ"], 800, 550, id, id.Replace("APG_", "") + "P1", id.Replace("PKG", "HELP") + "P1");
        }
        
        /// <summary>
        /// Update 조회수
        /// </summary>
        /// <returns></returns>
        private void getUpdate(string notice_seq, string id)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("NOTICE_SEQ", notice_seq);
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", id, "UPDATE_SEQ"), param);
            }
        }
        
        //공지사항 화면 열기
        [DirectMethod]
        public void OpenNotice()
        {
            HEParameterSet param = new HEParameterSet();

            X.Js.Call("addUserTab", "EP_XM23002", this.GetMenuUrl("EP_XM23002"), PopupHelper.GetUrlString(param));
        }
        
        //협력업체 게시판 화면 열기
        [DirectMethod]
        public void OpenVendorNotice()
        {
            HEParameterSet param = new HEParameterSet();

            X.Js.Call("addUserTab", "EP_XM23005", this.GetMenuUrl("EP_XM23005"), PopupHelper.GetUrlString(param));
        }

        //입고품 불량내용 조회 화면 열기
        [DirectMethod]
        public void OpenQA30001()
        {
            HEParameterSet param = new HEParameterSet();

            X.Js.Call("addUserTab", "SRM_QA30001", this.GetMenuUrl("SRM_QA30001"), PopupHelper.GetUrlString(param));
        }
    }
}