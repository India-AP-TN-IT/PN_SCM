using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ax.EP.Utility;
using HE.Framework.Core;
using System.Text;
using System.Data;
using Ext.Net;

namespace Ax.EP.WP.Home.EPAdmin
{
    /// <summary>
    /// <b>공지사항 팝업</b>
    /// - 작 성 자 : 이명희<br />
    /// - 작 성 일 : 2010-08-05<br />
    /// </summary>
    public partial class EP_XM23001P1 : BasePage
    {
        string noticeNo = string.Empty;
        public DataSet ds;
        public string vContents = "";
        public int vFileCount = 0;
        private string pakageName = "APG_EP_XM23001";

        public EP_XM23001P1()
            : base()
        {
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
            noticeNo = Request.QueryString["param1"];

            if (Request.QueryString["srcnoticeSeq"] == null)
                NOSEQ.Text = noticeNo;
            else
                NOSEQ.Text = Request.QueryString["srcnoticeSeq"];
        }

        private void Notice_DataBind()
        {
            try
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("NOTICE_SEQ", noticeNo);
                param.Add("USER_ID", Util.UserInfo.UserID);
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("USER_DIV", Util.UserInfo.UserDivision);
                param.Add("IP",  GetClientIP());
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName,"INQUERY_MAIN_NOTICE_DETAIL"), param);

                vContents = ds.Tables[0].Rows[0]["CONTENTS"].ToString();
                vFileCount = int.Parse(ds.Tables[0].Rows[0]["COUNT_FILE"].ToString());

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
            string strNextEmpty = string.Empty;
            string strPreEmpty = string.Empty;

            if (Util.UserInfo.LanguageShort.Equals("KO"))
            {
                strNextEmpty = "이전 공지사항이 없습니다.";
                strPreEmpty = "다음 공지사항이 없습니다.";
            }
            else
            {
                strNextEmpty = "Previous Notice is not exist.";
                strPreEmpty = "Next Notice is not exist.";
            }

            if (ds.Tables[0].Rows.Count > 0)
            {
                lbl01_IMPT_DIV_CONTENT.Text = "[ " + dataTable.Rows[0]["IMPT_DIV"].ToString() + " ]";
                lbl01_INSERT_ID_CONTENT.Text = dataTable.Rows[0]["INSERT_ID"].ToString();
                lbl01_INSERT_DATE_CONTENT.Text = DateTime.Parse(dataTable.Rows[0]["UPDATE_DATE"].ToString()).ToString(this.GlobalLocalFormat_Date);
                txtSUBJECT.Text = dataTable.Rows[0]["SUBJECT"].ToString();

                if (dataTable.Rows[0]["B_SUBJECT"].ToString().Equals(""))
                {
                    LabelBefore.Text = strNextEmpty;
                }
                else
                {
                    this.LabelBefore.Html = "<a href='EP_XM23001P1.aspx?param1=" + dataTable.Rows[0]["B_NOTICE_SEQ"].ToString() +
                        "&srcnoticeSeq=" + NOSEQ.Text + "'>" + dataTable.Rows[0]["B_SUBJECT"].ToString() + "</a>";
                }

                if (dataTable.Rows[0]["F_SUBJECT"].ToString().Equals(""))
                {
                    LabelAfter.Text = strPreEmpty;
                }
                else
                {
                    this.LabelAfter.Html = "<a href='EP_XM23001P1.aspx?param1=" + dataTable.Rows[0]["F_NOTICE_SEQ"].ToString() +
                        "&srcnoticeSeq=" + NOSEQ.Text + "'>" + dataTable.Rows[0]["F_SUBJECT"].ToString() + "</a>";
                }

                if (!dataTable.Rows[0]["FILEID1"].ToString().Equals(""))
                {
                    this.dwn02_FILEID1.Hidden = false;
                    this.dwn02_FILEID1.Text = dataTable.Rows[0]["FILENAME1"].ToString();
                    this.dwn02_FILEID1.NavigateUrl = Util.JsFileDirectDownloadByFileID(dataTable.Rows[0]["FILEID1"].ToString());
                    this.dwn02_FILEID1.Icon = Icon.Attach;
                }
                if (!dataTable.Rows[0]["FILEID2"].ToString().Equals(""))
                {
                    this.dwn02_FILEID2.Hidden = false;
                    this.dwn02_FILEID2.Text = dataTable.Rows[0]["FILENAME2"].ToString();
                    this.dwn02_FILEID2.NavigateUrl = Util.JsFileDirectDownloadByFileID(dataTable.Rows[0]["FILEID2"].ToString());
                    this.dwn02_FILEID2.Icon = Icon.Attach;
                }
                if (!dataTable.Rows[0]["FILEID3"].ToString().Equals(""))
                {
                    this.dwn02_FILEID3.Hidden = false;
                    this.dwn02_FILEID3.Text = dataTable.Rows[0]["FILENAME3"].ToString();
                    this.dwn02_FILEID3.NavigateUrl = Util.JsFileDirectDownloadByFileID(dataTable.Rows[0]["FILEID3"].ToString());
                    this.dwn02_FILEID3.Icon = Icon.Attach;
                }
            }
        }        
    }
}