using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Ax.EP.Utility;
using HE.Framework.Core;
using System.Text;
using System.Data;

namespace Ax.EP.WP.Home.EPAdmin
{
    /// <summary>
    /// <b>공지사항 팝업(공지전용)</b>
    /// - 작 성 자 : 김한철<br />
    /// - 작 성 일 : 2010-11-11<br />
    /// </summary>
    public partial class EP_XM23001P2 : BasePage
    {
        //데이터 공간
        public DataSet ds = null;
        public string vSubject = "";
        public string vContents = "";
        public int vFileCount = 0;
        private string pakageName = "APG_EP_XM23001";
        public EP_XM23001P2()
            : base()
        {
            this.RequireAuthentication = false;
            this.RequireAuthority = false;
            this.AutoVisibleByAuthority = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                GetParameter();
                Notice_DataBind();
            }
        }

        private void GetParameter()
        {
            NOSEQ.Text = Request.QueryString["param1"];
            CORCD.Text = Request.QueryString["param2"];
        }

        private void Notice_DataBind()
        {
            try
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", CORCD.Text);
                param.Add("NOTICE_SEQ", NOSEQ.Text);
                ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName,"INQUERY_MAIN_POPUP_DETAIL"), param);

                this.lbl01_NOTICE_TITLE.Text = ds.Tables[0].Rows[0]["SUBJECT"].ToString();
                this.DIV_CONTENT.InnerHtml = ds.Tables[0].Rows[0]["CONTENTS"].ToString();
                vFileCount = int.Parse(ds.Tables[0].Rows[0]["COUNT_FILE"].ToString());
                this.lbl01_WRITER.Text = ds.Tables[0].Rows[0]["INSERT_ID"].ToString();
                this.lbl01_WRITE_DATE.Text = ds.Tables[0].Rows[0]["INSERT_DATE"].ToString();
                if (vFileCount > 0) this.FileList.Visible = true;

                SetDataToComponet(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally { }
        }

        private void SetDataToComponet(DataTable dataTable)
        {
            if (!Convert.ToString(dataTable.Rows[0]["FILEID1"]).Equals(""))
            {
                this.dwn01_FILEID1.Text = dataTable.Rows[0]["FILENAME1"].ToString();
                this.dwn01_FILEID1.NavigateUrl = Util.JsFileDirectDownloadByFileID(dataTable.Rows[0]["FILEID1"].ToString());
                this.dwn01_FILEID1.Icon = Icon.Attach;
                X.Js.Call("fn_fileDisplay", "liFileId1");
            }
            if (!Convert.ToString(dataTable.Rows[0]["FILEID2"]).Equals(""))
            {
                this.dwn01_FILEID2.Text = dataTable.Rows[0]["FILENAME2"].ToString();
                this.dwn01_FILEID2.NavigateUrl = Util.JsFileDirectDownloadByFileID(dataTable.Rows[0]["FILEID2"].ToString());
                this.dwn01_FILEID2.Icon = Icon.Attach;
                X.Js.Call("fn_fileDisplay", "liFileId2");
            }
            if (!Convert.ToString(dataTable.Rows[0]["FILEID3"]).Equals(""))
            {
                this.dwn01_FILEID3.Text = dataTable.Rows[0]["FILENAME3"].ToString();
                this.dwn01_FILEID3.NavigateUrl = Util.JsFileDirectDownloadByFileID(dataTable.Rows[0]["FILEID3"].ToString());
                this.dwn01_FILEID3.Icon = Icon.Attach;
                X.Js.Call("fn_fileDisplay", "liFileId3");
            }
        } 
    }
}