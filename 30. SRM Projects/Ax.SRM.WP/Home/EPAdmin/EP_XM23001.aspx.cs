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
    /// EP_XM23001 <b>공지사항 등록</b>
    /// </summary>
    public partial class EP_XM23001 : BasePage
    {
        private string pakageName = "APG_EP_XM23001";

        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM23001
        /// </summary>
        public EP_XM23001()
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
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
            MakeButton(ButtonID.Delete, ButtonImage.Delete, "Delete", this.ButtonPanel);
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
                case ButtonID.Save:
                    Save();
                    break;
                case ButtonID.Delete:
                    Delete();
                    break;
                case ButtonID.Close:
                    X.Js.Call("closeTab");
                    break;
                default: break;
            }
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
                    fileDeleteConfirm(hid02_FILEID1.Value.ToString());
                    break;
                case "btn01_FILEID2_DEL":
                    fileDeleteConfirm(hid02_FILEID2.Value.ToString());
                    break;
                case "btn01_FILEID3_DEL":
                    fileDeleteConfirm(hid02_FILEID3.Value.ToString());
                    break;
                default:
                    break;
            }
        }

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

                Reset();
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
            param.Add("SUBJECT", txt01_SUBJECT.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_NOTICE"), param);
        }

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.df02_NOTICE_BEG_DATE.Value = DateTime.Now;
            this.df02_NOTICE_END_DATE.Value = DateTime.Parse("9999-12-31");
            this.txt02_NOTICE_SEQ.Value = "";
            this.txt02_INSERT_ID.Value = Util.UserInfo.UserID;
            this.txt02_INSERT_NAME.Value = Util.UserInfo.UserName;
            this.chk02_NOTICE_DIV.Checked = false;
            this.rdo02_GENERAL.Checked = true;
            this.rdo02_IMPORTANCE.Checked = false;
            this.rdo02_URGENCY.Checked = false;
            this.chk02_POP_YN.Checked = false;
            this.chk02_PRE_LOGIN_YN.Checked = false;
            this.df02_POP_BEG_DATE.Value = DateTime.Now;
            this.df02_POP_END_DATE.Value = DateTime.Now.AddDays(30);
            this.txt02_SUBJECT.Value = "";
            this.heb02_CONTENTS.Value = "";

            //파일관련
            this.fud02_FILEID1.Reset();
            this.fud02_FILEID2.Reset();
            this.fud02_FILEID3.Reset();
            this.hid02_FILEID1.Value = "";
            this.hid02_FILEID2.Value = "";
            this.hid02_FILEID3.Value = "";

            this.dwn02_FILEID1.Icon = Icon.None;
            this.dwn02_FILEID2.Icon = Icon.None;
            this.dwn02_FILEID3.Icon = Icon.None;
            this.dwn02_FILEID1.Text = "";
            this.dwn02_FILEID2.Text = "";
            this.dwn02_FILEID3.Text = "";

            if (!Util.UserInfo.UserDivision.Equals("T12"))
            {
                fud02_FILEID1.Disabled = true;
                fud02_FILEID2.Disabled = true;
                fud02_FILEID3.Disabled = true;
                btn01_FILEID1_DEL.Disabled = true;
                btn01_FILEID2_DEL.Disabled = true;
                btn01_FILEID3_DEL.Disabled = true;
            }
        }

        /// <summary>
        /// Save
        /// 저장(업데이트) 및 삭제
        /// </summary>
        public void Save()
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "RECEIPT", "NOTICE_BEG_DATE", "NOTICE_END_DATE",
                   "NOTICE_SEQ", "USER_ID",
                   "NOTICE_DIV", "IMPT_DIV", "POP_YN", "PRE_LOGIN_YN", "POP_BEG_DATE",
                   "POP_END_DATE", "SUBJECT", "CONTENTS",
                   "ATTACH_YN",
                   "FILEID1", "FILEID2", "FILEID3"
                );

                string NOTICE_DIV = "";
                string IMPT_DIV = "";
                string POP_YN = "";
                string PRE_LOGIN_YN = "";

                NOTICE_DIV = this.chk02_NOTICE_DIV.Checked ? "TZ1" : "TZ0";
                IMPT_DIV = this.rdo02_GENERAL.Checked ? "U53" : this.rdo02_IMPORTANCE.Checked ? "U52" : "U51";
                POP_YN = this.chk02_POP_YN.Checked ? "TZ1" : "TZ0";
                PRE_LOGIN_YN = this.chk02_PRE_LOGIN_YN.Checked ? "TZ1" : "TZ0";

                // 1. 기존의 oldFileID 를 받아온다
                string oldFileID1 = hid02_FILEID1.Value.ToString();
                string oldFileID2 = hid02_FILEID2.Value.ToString();
                string oldFileID3 = hid02_FILEID3.Value.ToString();

                // 2. 파일서버에 파일 저장후 결과값 반환
                //    DB 에 저장할 fileID 값을 생성한다  ( newFileID 또는 oldFileID 값이 선택적으로 반환됨)
                //
                //    동작조건1: 파일 등록/신규등록 : oldFileID 값은 비어있을것이며, FileUpload 는 newFileID 값읍 반환한다.
                //    동작조건2: 파일 등록/수정등록 : oldFileID 값은 넘어갈것이며, FileUpload 는 newFileID 값을 반환하고, oldFileID 값의 파일은 내부적으로 삭제처리한다.
                //    동작조건3: 파일 미등록/기존파일없음 : oldFileID 값은 비어있을것이며, FileUpload 는 비어있는값을 반환한다.
                //    동작조건4: 파일 미등록/기존파일있음 : oldFileID 값은 넘어갈것이며, FileUpload 는 oldFileID 값을 반환한다.
                //
                string newFileID1 = EPRemoteFileHandler.FileUpload(this.fud02_FILEID1, this.GetMenuID(), oldFileID1);
                string newFileID2 = EPRemoteFileHandler.FileUpload(this.fud02_FILEID2, this.GetMenuID(), oldFileID2);
                string newFileID3 = EPRemoteFileHandler.FileUpload(this.fud02_FILEID3, this.GetMenuID(), oldFileID3);

                // 3. DB 에 저장 한다. ( 패키지 내부에는 FILEID 값이 없을경우 해당 FIELDID Update 하지 않는다. - 기존정보 유지를 위해 )
                //    2번의 동작조건 2,4 번으로 인하여 첨부파일 변경시 또는 첨부변경없이 데이터 수정시 패키지에서 별도 파일존재여부 체크하는 로직을 넣을 필요 없이 
                //    newFileID 값을 그대로 가져다 Update 쳐도 기존 첨부파일에 영향을 주지 않음
                param.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode, "", ((DateTime)this.df02_NOTICE_BEG_DATE.Value).ToString("yyyy-MM-dd"),
                    ((DateTime)this.df02_NOTICE_END_DATE.Value).ToString("yyyy-MM-dd"), this.txt02_NOTICE_SEQ.Value, this.UserInfo.UserID,
                    NOTICE_DIV, IMPT_DIV, POP_YN, PRE_LOGIN_YN, ((DateTime)this.df02_POP_BEG_DATE.Value).ToString("yyyy-MM-dd"),
                    ((DateTime)this.df02_POP_END_DATE.Value).ToString("yyyy-MM-dd"), this.txt02_SUBJECT.Value, this.heb02_CONTENTS.Value,
                    "",
                    newFileID1, newFileID2, newFileID3
                );

                //유효성 검사
                if (!Validation(param.Tables[0].Rows[0], Library.ActionType.Save))
                {
                    return;
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName,"SAVE"), param);
                    this.MsgCodeAlert("EP20010-002");
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

        /// <summary>
        /// Delete
        /// 삭제
        /// </summary>
        public void Delete()
        {
            try
            {
                string fileID1 = this.hid02_FILEID1.Value.ToString();
                string fileID2 = this.hid02_FILEID2.Value.ToString();
                string fileID3 = this.hid02_FILEID3.Value.ToString();

                // 1. 지울때는 실제 db 정보 먼저 삭제 후
                using (EPClientProxy proxy = new EPClientProxy())
                {
                    HEParameterSet param = new HEParameterSet();
                    param.Add("CORCD", Util.UserInfo.CorporationCode);
                    param.Add("NOTICE_SEQ", this.txt02_NOTICE_SEQ.Value);
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_NOTICE"), param);

                    this.MsgCodeAlert("EP20010-008");

                    Search();
                }

                // 2. 원격 서버 파일 및 메타정보를 삭제한다. ( XD7000 메타 정보 포함 )
                EPRemoteFileHandler.FileRemove(fileID1);
                EPRemoteFileHandler.FileRemove(fileID2);
                EPRemoteFileHandler.FileRemove(fileID3);
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
        /// RowSelect
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RowSelect(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, object>[] parameter = JSON.Deserialize<Dictionary<string, object>[]>(json);

                Reset();

                this.txt02_NOTICE_SEQ.Value = parameter[0]["NOTICE_SEQ"].ToString();

                HEParameterSet param = new HEParameterSet();
                param.Add("NOTICE_SEQ", this.txt02_NOTICE_SEQ.Value);
                DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName,"INQUERY_NOTICE_DETAIL"), param);

                if (result.Tables[0].Rows[0][0].ToString().Length > 0)
                {
                    this.df02_NOTICE_BEG_DATE.SetValue(result.Tables[0].Rows[0]["NOTICE_BEG_DATE"]);
                    this.df02_NOTICE_END_DATE.SetValue(result.Tables[0].Rows[0]["NOTICE_END_DATE"]);
                    this.txt02_INSERT_ID.SetValue(result.Tables[0].Rows[0]["UPDATE_ID"]);
                    this.txt02_INSERT_NAME.SetValue(result.Tables[0].Rows[0]["UPDATE_NAME"]);
                    if (DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd")) > DateTime.Parse(result.Tables[0].Rows[0]["NOTICE_END_DATE"].ToString()))
                        this.chk02_NOTICE_DIV.Checked = true;
                    if (result.Tables[0].Rows[0]["IMPT_DIV"].Equals("U53"))
                        this.rdo02_GENERAL.Checked = true;
                    else if (result.Tables[0].Rows[0]["IMPT_DIV"].Equals("U52"))
                        this.rdo02_IMPORTANCE.Checked = true;
                    else if (result.Tables[0].Rows[0]["IMPT_DIV"].Equals("U51"))
                        this.rdo02_URGENCY.Checked = true;
                    if (result.Tables[0].Rows[0]["POP_YN"].Equals("TZ1"))
                        chk02_POP_YN.Checked = true;
                    if (result.Tables[0].Rows[0]["PRE_LOGIN_YN"].Equals("TZ1"))
                        this.chk02_PRE_LOGIN_YN.Checked = true;
                    this.df02_POP_BEG_DATE.SetValue(result.Tables[0].Rows[0]["POP_BEG_DATE"]);
                    this.df02_POP_END_DATE.SetValue(result.Tables[0].Rows[0]["POP_END_DATE"]);
                    this.txt02_SUBJECT.SetValue(result.Tables[0].Rows[0]["SUBJECT"]);
                    this.heb02_CONTENTS.SetValue(result.Tables[0].Rows[0]["CONTENTS"]);


                    // 여기서 부터 파일처리
                    this.hid02_FILEID1.SetValue(result.Tables[0].Rows[0]["FILEID1"]);
                    this.hid02_FILEID2.SetValue(result.Tables[0].Rows[0]["FILEID2"]);
                    this.hid02_FILEID3.SetValue(result.Tables[0].Rows[0]["FILEID3"]);

                    if (!this.hid02_FILEID1.Value.ToString().Equals(""))
                    {
                        this.dwn02_FILEID1.Text = result.Tables[0].Rows[0]["FILENAME1"].ToString();
                        this.dwn02_FILEID1.NavigateUrl = Util.JsFileDirectDownloadByFileID(this.hid02_FILEID1.Value.ToString());
                        this.dwn02_FILEID1.Icon = Icon.Attach;
                    }

                    if (!this.hid02_FILEID2.Value.ToString().Equals(""))
                    {
                        this.dwn02_FILEID2.Text = result.Tables[0].Rows[0]["FILENAME2"].ToString();
                        this.dwn02_FILEID2.NavigateUrl = Util.JsFileDirectDownloadByFileID(this.hid02_FILEID2.Value.ToString());
                        this.dwn02_FILEID2.Icon = Icon.Attach;
                    }

                    if (!this.hid02_FILEID3.Value.ToString().Equals(""))
                    {
                        this.dwn02_FILEID3.Text = result.Tables[0].Rows[0]["FILENAME3"].ToString();
                        this.dwn02_FILEID3.NavigateUrl = Util.JsFileDirectDownloadByFileID(this.hid02_FILEID3.Value.ToString());
                        this.dwn02_FILEID3.Icon = Icon.Attach;
                    }

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
        /// fileDelete DirectMethod
        /// </summary>
        /// <param name="fileID"></param>
        [DirectMethod]
        public void fileDelete(string fileID)
        {
            try
            {
                // 1. 첨부파일 1개 지울때또 DB의 공지사항 테이블의 파일링크 정보를 먼저 제거 후.
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("NOTICE_SEQ", this.txt02_NOTICE_SEQ.Value);
                param.Add("FILEID", fileID);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName,"REMOVE_ATTACH"), param);
                    //X.MessageBox.Alert("FileDelete", "파일이 삭제 되었습니다.").Show();
                    this.MsgCodeAlert("EP20010-003");
                }

                // 2. 원격지 파일 및 메타 정보를 삭제한다.
                EPRemoteFileHandler.FileRemove(fileID);

                // 파일 정보 초기화 ( 3개중 삭제된 fileID 를 찾아서 해당 하는 항목만 초기화 )
                if (fileID.Equals(hid02_FILEID1.Value.ToString()))
                {
                    this.fud02_FILEID1.Reset();
                    this.dwn02_FILEID1.Icon = Icon.None;
                    this.dwn02_FILEID1.Text = "";
                    this.hid02_FILEID1.Value = "";
                }
                else if (fileID.Equals(hid02_FILEID2.Value.ToString()))
                {
                    this.fud02_FILEID2.Reset();
                    this.dwn02_FILEID2.Icon = Icon.None;
                    this.dwn02_FILEID2.Text = "";
                    this.hid02_FILEID2.Value = "";
                }
                else if (fileID.Equals(hid02_FILEID3.Value.ToString()))
                {
                    this.fud02_FILEID3.Reset();
                    this.dwn02_FILEID3.Icon = Icon.None;
                    this.dwn02_FILEID3.Text = "";
                    this.hid02_FILEID3.Value = "";
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

        #region [ 유효성 검사 ]

        /// <summary>
        /// Validation
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="actionType"></param>
        /// <param name="actionRow"></param>
        /// <remarks>actionRow 는 Grid 타일경우에만 사용한다.</remarks>
        /// <returns>bool</returns>
        public bool Validation(DataRow parameter, Library.ActionType actionType, int actionRow = -1)
        {
            bool result = false;

            // 저장용 Validation
            if (actionType == Library.ActionType.Save)
            {
                if (String.IsNullOrEmpty(parameter["NOTICE_BEG_DATE"].ToString()) || parameter["NOTICE_BEG_DATE"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20010-004", "df02_NOTICE_BEG_DATE", lbl02_NOTICE_BEG_DATE.Text);

                else if (String.IsNullOrEmpty(parameter["NOTICE_END_DATE"].ToString()) || parameter["NOTICE_END_DATE"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20010-005", "df02_NOTICE_END_DATE", lbl02_NOTICE_END_DATE.Text);

                else if (String.IsNullOrEmpty(parameter["SUBJECT"].ToString()) || parameter["SUBJECT"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20010-006", "txt02_SUBJECT", lbl02_SUBJECT.Text);

                else if (String.IsNullOrEmpty(parameter["CONTENTS"].ToString()) || parameter["CONTENTS"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20010-007", "heb02_CONTENTS", lbl02_CONTENTS.Text);

                else
                    result = true;

            }
            // 삭제용 Validation
            else if (actionType == Library.ActionType.Delete)
            {
                result = true;
            }
            // 처리용 Validation
            else if (actionType == Library.ActionType.Process)
            {
                result = true;
            }
            // 조회용 Validation
            else
            {
                result = true;
            }

            return result;
        }

        #endregion
    }
}