#region ▶ Description & History
/* 
 * 프로그램명 : 상세 견적 첨부
 * 설      명 : 
 * 최초작성자 : 손창현
 * 최초작성일 : 2017-09-19
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
using System.Web;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MP
{
    public partial class SRM_MP20003P2 : BasePage
    {
        private string pakageName = "APG_SRM_MP20003";

        #region [ 초기설정 ]
        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_MP20003P2()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = false;
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
                if (!IsPostBack)
                {
                    string sQuery = Request.Url.Query;
                    this.txt01_ID.SetValue(HttpUtility.ParseQueryString(Request.Url.Query).Get("ID"));
                    this.txt01_BIZCD.SetValue(HttpUtility.ParseQueryString(sQuery).Get("BIZCD"));
                    this.txt01_PRNO.SetValue(HttpUtility.ParseQueryString(sQuery).Get("PRNO"));
                    this.txt01_PRNO_SEQ.SetValue(HttpUtility.ParseQueryString(sQuery).Get("PRNO_SEQ"));
                    this.txt01_SEQ.SetValue(HttpUtility.ParseQueryString(sQuery).Get("SEQ"));

                    DataSetBind();
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
        /// </summary>
        protected override void BuildButtons()
        {
            //MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            //MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
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
                case ButtonID.Reset:
                    Reset();
                    break;
                case ButtonID.Save:
                    Save(sender, e);
                    break;
                case "btn01_CLOSE":
                    //X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
                    break;
                default: break;
            }
        }

		#endregion						

        #region [ 기능 ]

        /// <summary>
        /// Reset 초기화
        /// </summary>
        public void Reset()
        {
        }

        /// <summary>
        /// etc_Button_Click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void etc_Button_Click(object sender, EventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_FILEID1_DEL":
                    fileDeleteConfirm();
                    break;
                case "lkb02_FILEID1":
                    FileDown();
                    break;
                default:
                    break;
            }
        }

        public void FileDown()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.txt01_BIZCD.Text);
            param.Add("PRNO", this.txt01_PRNO.Text);
            param.Add("PRNO_SEQ", this.txt01_PRNO_SEQ.Text);
            param.Add("SEQ", this.txt01_SEQ.Text);                
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ATT_FILE"), param);

            //데이터가 있을 경우
            if (result.Tables[0].Rows.Count > 0)
            {
                Util.FileDownLoadByBlob(this.Page, (byte[])result.Tables[0].Rows[0]["ATT_FILE"], result.Tables[0].Rows[0]["ATT_FILENM"].ToString());
                this.lkb02_FILEID1.Text = result.Tables[0].Rows[0]["ATT_FILENM"].ToString() == "" ? " " : result.Tables[0].Rows[0]["ATT_FILENM"].ToString();
            }
        }

        /// <summary>
        /// fileDeleteConfirm
        /// </summary>
        /// <param name="fileID"></param>
        public void fileDeleteConfirm()
        {
            if (string.IsNullOrEmpty(lkb02_FILEID1.Text.Trim()))
            {
                this.MsgCodeAlert("SCMQA00-0050");
                return;
            }
            else
            {
                X.MessageBox.Confirm("Confirm", Library.getMessage("COM-00801"), new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.fileRemove()",
                        Text = "Yes"
                    },
                    No = new MessageBoxButtonConfig
                    {
                        Text = "No"
                    }
                }).Show();
            }
        }

        /// <summary>
        /// fileRemove
        /// </summary>
        /// <param name="fileID"></param>
        [DirectMethod]
        public void fileRemove()
        {
            try
            {
                //파일삭제
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.txt01_BIZCD.Text);
                param.Add("PRNO", this.txt01_PRNO.Text);
                param.Add("PRNO_SEQ", this.txt01_PRNO_SEQ.Text);
                param.Add("SEQ", this.txt01_SEQ.Text);
                param.Add("USER_ID", Util.UserInfo.UserID);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_FILE"), param);
                    this.MsgCodeAlert("SCMQA00-0049");
                }

                this.lkb02_FILEID1.Text = string.Empty;
                X.Js.Call("parent.fn_MP20003P2_R", this.txt01_ID.Text);
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

        #region [이벤트]
        /// <summary>
        /// fileDeleteConfirm
        /// </summary>
        /// <param name="fileID"></param>
        public void fileDeleteConfirm(string fileID)
        {
            if (string.IsNullOrEmpty(fileID))
            {
                this.Alert("Not File", "Not Exists File (파일이 존재하지 않습니다.)");
            }
            else
            {
                X.MessageBox.Confirm("Confirm", Library.getMessage("EP20010-001"), new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.fileDelete('" + fileID + "')",
                        Text = "Yes"
                    },
                    No = new MessageBoxButtonConfig
                    {
                        Text = "No"
                    }
                }).Show();
            }
        }

        #endregion

        #region [함수]
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                byte[] file = this.fud02_FILEID1.FileBytes;

                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "PRNO", "PRNO_SEQ", "SEQ", 
                   "BLOB$ATT_FILE", "ATT_FILENM", "USER_ID", "LANG_SET"
                );

                param.Tables[0].Rows.Add(
                    Util.UserInfo.CorporationCode, this.txt01_BIZCD.Text, this.txt01_PRNO.Text, this.txt01_PRNO_SEQ.Text, this.txt01_SEQ.Text,
                    file,                                                 //첨부파일1 데이터
                    System.IO.Path.GetFileName(fud02_FILEID1.FileName),        //첨부파일1명
                    Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "UPDATE_ATT_FILE"), param);
                    this.MsgCodeAlert("COM-00902");
                    DataSetBind();
                }

                X.Js.Call("parent.fn_MP20003P2_R", this.txt01_ID.Text);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {

            }
        }

        public void DataSetBind()
        {
            try
            {
                DataSet ds = null;

                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.txt01_BIZCD.Text);
                param.Add("PRNO", this.txt01_PRNO.Text);
                param.Add("PRNO_SEQ", this.txt01_PRNO_SEQ.Text);
                param.Add("SEQ", this.txt01_SEQ.Text);
                param.Add("USER_ID", Util.UserInfo.UserID);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ATT_FILE"), param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    this.lkb02_FILEID1.Text = ds.Tables[0].Rows[0]["ATT_FILENM"].ToString() == "" ? " " : ds.Tables[0].Rows[0]["ATT_FILENM"].ToString();
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
    }
}