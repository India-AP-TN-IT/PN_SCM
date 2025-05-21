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
    /// EP_XM23004 <b>협력업체 게시판</b>
    /// </summary>
    public partial class EP_XM23004 : BasePage
    {
        private string pakageName = "APG_EP_XM23003";

        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM23006
        /// </summary>
        public EP_XM23004()
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
                    SetCombo(); //콤보상자 바인딩//임시저장
                    Search("0");
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
                    this.Store1.RemoveAll();
                    this.Store2.RemoveAll();
                    Search("1");
                    break;
                case ButtonID.Reset:
                    Reset(true, "0");
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
        /// 콤보상자 바인딩(발생구분)
        /// </summary>
        private void SetCombo()
        {
            //조회조건
            DataTable dt = new DataTable();
            dt.Columns.Add("TYPENM");
            dt.Columns.Add("OBJECT_ID");
            dt.Rows.Add(this.UserInfo.LanguageShort.Equals("KO")?"제목":"Subject", "01");
            dt.Rows.Add(this.UserInfo.LanguageShort.Equals("KO")?"내용":"Contents", "02");
            dt.Rows.Add(this.UserInfo.LanguageShort.Equals("KO")?"작성자":"Writer", "03");
            Library.ComboDataBind(this.cbo01_PARAM, dt, true, false);
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
                case "btn01_HR_SEARCH":
                    this.Store1.RemoveAll();
                    this.Store2.RemoveAll();
                    Search("1");
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
        public void Search(string SearchCase)
        {
            try
            {
                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                if (SearchCase.Equals("0"))
                    Reset(true, SearchCase);
                else if (SearchCase.Equals("1"))
                    Reset(true, SearchCase);
                else if (SearchCase.Equals("2"))
                    Reset(false, SearchCase);
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
            param.Add("PARAM_ID", this.cbo01_PARAM.Value);
            param.Add("PARAM_NM", this.txt01_PARAMT.Text);
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSetReply()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("NOTICE_SEQ", this.txt01_NOTICE_SEQ.Value);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPLY"), param, "OUT_CURSOR", "OUT_CURSOR02");
        }

        /// <summary>
        /// Reset
        /// searchCase 0: 전부 리셋, 1: 검색조건 제외, 2: 입력 컨트롤 제외  
        /// </summary>
        public void Reset(bool chk, string searchCase)
        {
            //게시글 작성자와 관리자 권한 가진 사람만 Save, Delete 기능 가능하도록 수정
            if (chk == true)
            {
                ((Ext.Net.Button)this.FindControl(ButtonID.Delete)).Hidden = false;
                ((Ext.Net.Button)this.FindControl(ButtonID.Save)).Hidden = false;
            }
            else
            {
                if (!this.txt02_INSERT_ID.Text.Equals(Util.UserInfo.UserID) && Util.UserInfo.IsAdminBool != true)
                {
                    ((Ext.Net.Button)this.FindControl(ButtonID.Delete)).Hidden = true;
                    ((Ext.Net.Button)this.FindControl(ButtonID.Save)).Hidden = true;
                }
                else
                {
                    ((Ext.Net.Button)this.FindControl(ButtonID.Delete)).Hidden = false;
                    ((Ext.Net.Button)this.FindControl(ButtonID.Save)).Hidden = false;
                }
            }

            if (searchCase.Equals("2"))
            {
                this.txt01_WRITE_TXT.Value = "";
                this.Store2.RemoveAll();
                return;
            }

            this.df02_INSERT_DATE.ReadOnly = true;
            this.df02_NOTICE_BEG_DATE.ReadOnly = false;
            this.df02_NOTICE_END_DATE.ReadOnly = false;
            this.txt02_INSERT_ID.ReadOnly = true;
            this.txt02_INSERT_NAME.ReadOnly = true;
            this.chk02_NOTICE_YN.ReadOnly = false;

            this.rdo02_GENERAL.ReadOnly = false;
            this.rdo02_IMPORTANT.ReadOnly = false;
            this.rdo02_URGENCY.ReadOnly = false;
            this.txt02_SUBJECT.ReadOnly = false;
            this.heb02_CONTENTS.ReadOnly = false;

            fud02_FILEID1.Disabled = false;
            fud02_FILEID2.Disabled = false;
            fud02_FILEID3.Disabled = false;
            btn01_FILEID1_DEL.Disabled = false;
            btn01_FILEID2_DEL.Disabled = false;
            btn01_FILEID3_DEL.Disabled = false;

            this.df02_INSERT_DATE.Value = DateTime.Now;
            this.df02_NOTICE_BEG_DATE.Value = DateTime.Now;
            this.df02_NOTICE_END_DATE.Value = DateTime.Parse("9999-12-31");
            this.txt01_NOTICE_SEQ.Value = "";
            this.txt02_INSERT_ID.Value = Util.UserInfo.UserID;
            this.txt02_INSERT_NAME.Value = Util.UserInfo.UserName;
            this.chk02_NOTICE_YN.Checked = false;
            this.rdo02_GENERAL.Checked = true;
            this.rdo02_IMPORTANT.Checked = false;
            this.rdo02_URGENCY.Checked = false;
            this.txt02_SUBJECT.Value = "";
            this.heb02_CONTENTS.Value = "";

            if (searchCase.Equals("0"))
            {
                this.cbo01_PARAM.SelectedItem.Value = string.Empty;
                this.cbo01_PARAM.UpdateSelectedItems(); //꼭 해줘야한다.

                this.txt01_PARAMT.Text = string.Empty;
                this.Store2.RemoveAll();
            }

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
                   "CORCD", "BIZCD", "NOTICE_SEQ", "NOTICE_BEG_DATE", "NOTICE_END_DATE", "NOTICE_YN",
                   "SUBJECT", "CONTENTS", "IMPT_DIV", "ATTACH_YN", "FILEID1", "FILEID2", "FILEID3",
                   "NOTICE_DIV", "LANG_SET", "USER_ID"
                );

                string NOTICE_YN = "";
                string NOTICE_DIV = "";
                string IMPT_DIV = "";
                string ATTACH_YN = "";

                //NOTICE_DIV = this.chk02_NOTICE_DIV.Checked ? "TZ1" : "TZ0";
                NOTICE_YN = this.chk02_NOTICE_YN.Checked ? "Y" : "";
                IMPT_DIV = this.rdo02_GENERAL.Checked ? "U53" : this.rdo02_IMPORTANT.Checked ? "U52" : "U51";

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

                if (newFileID1.ToString().Length > 0 || newFileID2.ToString().Length > 0 || newFileID3.ToString().Length > 0)
                    ATTACH_YN = "Y";

                param.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode, Util.UserInfo.BusinessCode, this.txt01_NOTICE_SEQ.Value, ((DateTime)this.df02_NOTICE_BEG_DATE.Value).ToString("yyyy-MM-dd"),
                    ((DateTime)this.df02_NOTICE_END_DATE.Value).ToString("yyyy-MM-dd"), NOTICE_YN, this.txt02_SUBJECT.Text, this.heb02_CONTENTS.Value,
                    IMPT_DIV, ATTACH_YN, newFileID1, newFileID2, newFileID3, NOTICE_DIV, Util.UserInfo.LanguageShort, Util.UserInfo.UserID
                );

                //유효성 검사
                if (!Validation(param.Tables[0].Rows[0], Library.ActionType.Save))
                {
                    return;
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param);
                    MsgCodeAlert("EP20010-002");
                    Search("0");
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
                    param.Add("NOTICE_SEQ", this.txt01_NOTICE_SEQ.Value);
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_NOTICE"), param);

                    this.MsgCodeAlert("EP20010-008");

                    Search("0");
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

                Reset(false, "1");

                this.txt01_NOTICE_SEQ.Value = parameter[0]["NOTICE_SEQ"].ToString();

                DataSet ds = null;

                // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                HEParameterSet param = new HEParameterSet();
                param.Add("NOTICE_SEQ", this.txt01_NOTICE_SEQ.Value);
                param.Add("USER_ID", Util.UserInfo.UserID);
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("USER_DIV", Util.UserInfo.UserDivision);
                param.Add("IP", GetClientIP());
                param.Add("PARAM_ID", this.cbo01_PARAM.Value);
                param.Add("PARAM_NM", this.cbo01_PARAM.Text);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_MAIN_NOTICE_DETAIL"), param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    this.txt02_INSERT_ID.SetValue(dr["INSERT_ID"]);
                    this.txt02_INSERT_NAME.SetValue(dr["INSERT_NM"]);

                    this.df02_NOTICE_BEG_DATE.SetValue(dr["NOTICE_BEG_DATE"]);
                    this.df02_NOTICE_END_DATE.SetValue(dr["NOTICE_END_DATE"]);
                    this.df02_INSERT_DATE.SetValue(dr["INSERT_DATE"]);

                    if (string.IsNullOrEmpty(dr["NOTICE_YN"].ToString()) == false)
                    {
                        if (dr["NOTICE_YN"].ToString() == "Y") this.chk02_NOTICE_YN.Checked = true;
                        else this.chk02_NOTICE_YN.Checked = false;
                    }
                    else this.chk02_NOTICE_YN.Checked = false;

                    this.txt02_SUBJECT.SetValue(dr["SUBJECT"]);
                    this.heb02_CONTENTS.SetValue(dr["CONTENTS"]);

                    if (string.IsNullOrEmpty(dr["IMPT_DIV"].ToString()) == false)
                    {
                        this.rdo02_GENERAL.Checked = false;

                        if (dr["IMPT_DIV"].ToString().Equals("U51")) this.rdo02_GENERAL.Checked = true;
                        else if (dr["IMPT_DIV"].ToString().Equals("U52")) this.rdo02_IMPORTANT.Checked = true;
                        else if (dr["IMPT_DIV"].ToString().Equals("U53")) this.rdo02_URGENCY.Checked = true;
                    }

                    // 여기서 부터 파일처리
                    this.hid02_FILEID1.SetValue(dr["FILEID1"]);
                    this.hid02_FILEID2.SetValue(dr["FILEID2"]);
                    this.hid02_FILEID3.SetValue(dr["FILEID3"]);

                    if (!this.hid02_FILEID1.Value.ToString().Equals(""))
                    {
                        this.dwn02_FILEID1.Text = dr["FILENAME1"].ToString();
                        this.dwn02_FILEID1.NavigateUrl = Util.JsFileDirectDownloadByFileID(this.hid02_FILEID1.Value.ToString());
                        this.dwn02_FILEID1.Icon = Icon.Attach;
                    }

                    if (!this.hid02_FILEID2.Value.ToString().Equals(""))
                    {
                        this.dwn02_FILEID2.Text = dr["FILENAME2"].ToString();
                        this.dwn02_FILEID2.NavigateUrl = Util.JsFileDirectDownloadByFileID(this.hid02_FILEID2.Value.ToString());
                        this.dwn02_FILEID2.Icon = Icon.Attach;
                    }

                    if (!this.hid02_FILEID3.Value.ToString().Equals(""))
                    {
                        this.dwn02_FILEID3.Text = dr["FILENAME3"].ToString();
                        this.dwn02_FILEID3.NavigateUrl = Util.JsFileDirectDownloadByFileID(this.hid02_FILEID3.Value.ToString());
                        this.dwn02_FILEID3.Icon = Icon.Attach;
                    }

                    setEdit();

                    Search_Reply();
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
                param.Add("NOTICE_SEQ", this.txt01_NOTICE_SEQ.Value);
                param.Add("FILEID", fileID);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_ATTACH"), param);
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

        private void setEdit()
        {
            ((Ext.Net.Button)this.FindControl(ButtonID.Delete)).Hidden = true;
            ((Ext.Net.Button)this.FindControl(ButtonID.Save)).Hidden = true;

            this.df02_INSERT_DATE.ReadOnly = true;
            this.df02_NOTICE_BEG_DATE.ReadOnly = true;
            this.df02_NOTICE_END_DATE.ReadOnly = true;
            this.txt02_INSERT_ID.ReadOnly = true;
            this.txt02_INSERT_NAME.ReadOnly = true;
            this.chk02_NOTICE_YN.ReadOnly = true;

            this.rdo02_GENERAL.ReadOnly = true;
            this.rdo02_IMPORTANT.ReadOnly = true;
            this.rdo02_URGENCY.ReadOnly = true;
            this.txt02_SUBJECT.ReadOnly = true;
            this.heb02_CONTENTS.ReadOnly = true;

            fud02_FILEID1.Disabled = true;
            fud02_FILEID2.Disabled = true;
            fud02_FILEID3.Disabled = true;
            btn01_FILEID1_DEL.Disabled = true;
            btn01_FILEID2_DEL.Disabled = true;
            btn01_FILEID3_DEL.Disabled = true;

            //관리자, 게시글 작성자
            if (Util.UserInfo.IsAdminBool == true || this.txt02_INSERT_ID.Text.Equals(Util.UserInfo.UserID))
            {

                ((Ext.Net.Button)this.FindControl(ButtonID.Delete)).Hidden = false;
                ((Ext.Net.Button)this.FindControl(ButtonID.Save)).Hidden = false;

                this.df02_INSERT_DATE.ReadOnly = true;
                this.df02_NOTICE_BEG_DATE.ReadOnly = false;
                this.df02_NOTICE_END_DATE.ReadOnly = false;
                this.txt02_INSERT_ID.ReadOnly = true;
                this.txt02_INSERT_NAME.ReadOnly = true;
                this.chk02_NOTICE_YN.ReadOnly = false;

                this.rdo02_GENERAL.ReadOnly = false;
                this.rdo02_IMPORTANT.ReadOnly = false;
                this.rdo02_URGENCY.ReadOnly = false;
                this.txt02_SUBJECT.ReadOnly = false;
                this.heb02_CONTENTS.ReadOnly = false;

                fud02_FILEID1.Disabled = false;
                fud02_FILEID2.Disabled = false;
                fud02_FILEID3.Disabled = false;
                btn01_FILEID1_DEL.Disabled = false;
                btn01_FILEID2_DEL.Disabled = false;
                btn01_FILEID3_DEL.Disabled = false;
            }
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

                if (string.IsNullOrEmpty(this.txt01_NOTICE_SEQ.Value.ToString()))
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
                   Util.UserInfo.CorporationCode, this.txt01_NOTICE_SEQ.Value,
                   this.txt01_WRITE_TXT.Text, Util.UserInfo.LanguageShort, Util.UserInfo.UserID
               );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_REPLY"), param);
                    this.MsgCodeAlert("COM-00902");
                    Search("2");
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
                if (string.IsNullOrEmpty(this.txt01_NOTICE_SEQ.Value.ToString()))
                {
                    this.MsgCodeAlert("COM-00910");
                    return;
                }

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
                        Search("2");
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

        /// <summary>
        /// Search
        /// </summary>
        public void Search_Reply()
        {
            try
            {
                DataSet result = getDataSetReply();
                this.Store2.DataSource = result.Tables[0];
                this.Store2.DataBind();

                //if (result.Tables[1].Rows.Count > 0)
                //    this.txt01_INSERT_ID.SetValue(result.Tables[1].Rows[0]["INSERT_ID"].ToString());
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
                    this.MsgCodeAlert_ShowFormat("EP20010-004", "df02_NOTICE_BEG_DATE", lbl02_WRITE_DAY.Text);

                else if (String.IsNullOrEmpty(parameter["NOTICE_END_DATE"].ToString()) || parameter["NOTICE_END_DATE"].ToString().Trim().Equals(""))
                    this.MsgCodeAlert_ShowFormat("EP20010-005", "df02_NOTICE_END_DATE", lbl02_EXPIR_DATE.Text);

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