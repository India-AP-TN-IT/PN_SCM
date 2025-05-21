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
    /// <b>협력사 게시판 상세보기 팝업</b>
    /// - 작 성 자 : 이현범<br />
    /// - 작 성 일 : 2014-11-18<br />
    /// </summary>
    public partial class EP_XM23003P1 : BasePage
    {
        string noticeNo = string.Empty;
        public DataSet ds;
        public string vContents = "";
        public int vFileCount = 0;
        private string pakageName = "APG_EP_XM23003";

        public EP_XM23003P1()
            : base()
        {
            this.RequireAuthority = false;
            this.AutoVisibleByAuthority = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                reset();
                GetParameter();
                Notice_DataBind();
                Search_Reply();
            }
        }

        private void reset()
        {
            this.lbl01_USER_ID.Text = Util.UserInfo.UserName;

            //this.chk01_NOTICE_YN.ReadOnly = true;
        }

        private void GetParameter()
        {
            noticeNo = Request.QueryString["NOTICE_SEQ"];

            this.NOSEQ.Text = noticeNo;

            string sQuery = Request.Url.Query;
            this.txt01_ID.Text = HttpUtility.ParseQueryString(sQuery).Get("ID");

            Search_Reply();
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
                param.Add("PARAM_ID", string.Empty);
                param.Add("PARAM_NM", string.Empty);
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

        #region [ 버튼설정 ]
        /// <summary>
        /// BuildButtons 
        /// 버튼생성
        /// </summary>
        protected override void BuildButtons()
        {
            //MakeButton(ButtonID.Close, ButtonImage.Close, "Close", this.ButtonPanel);
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
                case ButtonID.Close:
                    X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
                    break;
                case "btn01_CLOSE":
                    X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
                    break;
                default: break;
            }
        }

        #endregion

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
                this.lbl01_INSERT_ID.Text = dataTable.Rows[0]["INSERT_NM"].ToString();
                //if(dataTable.Rows[0]["NOTICE_YN"].ToString().Equals("Y"))
                //{
                //    this.chk01_NOTICE_YN.Checked = true;
                //}
                //else
                //{
                //    this.chk01_NOTICE_YN.Checked = false;
                //}
                //this.lbl01_NOTICE_BEG_DATE.Text = dataTable.Rows[0]["NOTICE_BEG_DATE"].ToString();
                //this.lbl01_NOTICE_END_DATE.Text = dataTable.Rows[0]["NOTICE_END_DATE"].ToString();
                this.lbl01_INSERT_DATE.Text = dataTable.Rows[0]["INSERT_DATE"].ToString();
                this.lbl01_INSERT_ID.Text = dataTable.Rows[0]["INSERT_NM"].ToString();
                this.lbl01_SUBJECT02.Text = dataTable.Rows[0]["SUBJECT"].ToString();
                this.lbl01_SUBJECT02.Text = dataTable.Rows[0]["SUBJECT"].ToString();
                this.lbl02_IMPT_DIVNM.Text = dataTable.Rows[0]["IMPT_DIVNM"].ToString();

                if (dataTable.Rows[0]["B_SUBJECT"].ToString().Equals(""))
                {
                    LabelBefore.Text = strNextEmpty;
                }
                else
                {
                    this.LabelBefore.Html = "<a href='EP_XM23003P1.aspx?NOTICE_SEQ=" + dataTable.Rows[0]["B_NOTICE_SEQ"].ToString() +
                         "&srcnoticeSeq=" + NOSEQ.Text + "'>" + dataTable.Rows[0]["B_SUBJECT"].ToString() + "</a>";
                }

                if (dataTable.Rows[0]["F_SUBJECT"].ToString().Equals(""))
                {
                    LabelAfter.Text = strPreEmpty;
                }
                else
                {
                    this.LabelAfter.Html = "<a href='EP_XM23003P1.aspx?NOTICE_SEQ=" + dataTable.Rows[0]["F_NOTICE_SEQ"].ToString() +
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

        /// <summary>
        /// Search
        /// </summary>
        public void Search_Reply()
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
            param.Add("NOTICE_SEQ", NOSEQ.Text);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPLY"), param, "OUT_CURSOR", "OUT_CURSOR02");
        }

        [DirectMethod]
        public void Save_Reply()
        {
            try
            {
                if (string.IsNullOrEmpty(this.txt01_WRITE_TXT.Text.Trim()))
                {
                    this.MsgCodeAlert("COM-00910");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "NOTICE_SEQ", "CONTENTS", "LANG_SET", "USER_ID"
                );

                param.Tables[0].Rows.Add
               (
                   Util.UserInfo.CorporationCode, this.NOSEQ.Text,
                   this.txt01_WRITE_TXT.Text, Util.UserInfo.LanguageShort, Util.UserInfo.UserID
               );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_REPLY"), param);
                    this.MsgCodeAlert("COM-00902");
                    Search_Reply();
                    this.txt01_WRITE_TXT.SetValue(string.Empty);
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

        [DirectMethod]
        public void Delete_Reply(int row, string corcd, string notice_seq, string reply_seq, string user_id)
        {
            try
            {
                //관리자, 게시글 작성자
                if (Util.UserInfo.IsAdminBool == true || user_id.Equals(Util.UserInfo.UserID))
                {
                    DataSet param = Util.GetDataSourceSchema
                    (
                        "CORCD", "NOTICE_SEQ", "REPLY_SEQ", "LANG_SET", "USER_ID"
                    );

                    param.Tables[0].Rows.Add
                    (
                        corcd, notice_seq, reply_seq, Util.UserInfo.LanguageShort, Util.UserInfo.UserID
                    );

                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "DELETE_REPLY"), param);
                        this.MsgCodeAlert("COM-00903");
                        Search_Reply();
                    }
                }
                else
                {
                    MsgCodeAlert("SRMXM-0033");
                    return;
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
    }
}