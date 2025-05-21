#region ▶ Description & History
/* 
 * 프로그램명 : 상세 견적 첨부     [D2](구.VG3070P1)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-09-23
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
using Ext.Net;
using Ax.EP.Utility;
using HE.Framework.Core;
using System.Data;

namespace Ax.EP.WP.Home.SRM_QA
{
    public partial class SRM_QA20002P2 : BasePage
    {
        private string pakageName = "APG_SRM_QA20002";

        #region [ 초기설정 ]
        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_QA20002P2()
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
                    this.txt01_DEFNO.SetValue(HttpUtility.ParseQueryString(sQuery).Get("DEFNO"));

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
            //파일관련
            this.fud01_FILEID1.Reset();
            this.hid01_FILEID1.Value = "";
            this.dwn01_FILEID1.Icon = Icon.None;
            this.dwn01_FILEID1.Text = "";
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
                    //fileDeleteConfirm();
                    fileDeleteConfirm(hid01_FILEID1.Value.ToString());
                    break;
                //case "lkb02_FILEID1":
                //    FileDown();
                //    break;
                default:
                    break;
            }
        }

        //public void FileDown()
        //{
        //    HEParameterSet param = new HEParameterSet();
        //        param.Add("CORCD", Util.UserInfo.CorporationCode);
        //        param.Add("BIZCD", this.txt01_BIZCD.Text);
        //        param.Add("DEFNO", this.txt01_DEFNO.Text);
        //        param.Add("USER_ID", Util.UserInfo.UserID);
        //        param.Add("LANG_SET", Util.UserInfo.LanguageShort);

        //        DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ATT_FILE"), param);

        //    //데이터가 있을 경우
        //    if (result.Tables[0].Rows.Count > 0)
        //    {
        //        Util.FileDownLoadByBlob(this.Page, (byte[])result.Tables[0].Rows[0]["ATT_FILE"], result.Tables[0].Rows[0]["ATT_FILENM"].ToString());
        //        this.lkb02_FILEID1.Text = result.Tables[0].Rows[0]["ATT_FILENM"].ToString() == "" ? " " : result.Tables[0].Rows[0]["ATT_FILENM"].ToString();
        //    }
        //}

        /// <summary>
        /// fileDeleteConfirm
        /// </summary>
        /// <param name="fileID"></param>
        public void fileDeleteConfirm()
        {
            //if (string.IsNullOrEmpty(lkb02_FILEID1.Text.Trim()))
            //{
            //    this.MsgCodeAlert("SRMQA00-0050");
            //    return;
            //}
            //else
            //{
            //    X.MessageBox.Confirm("Confirm", Library.getMessage("COM-00801"), new MessageBoxButtonsConfig
            //    {
            //        Yes = new MessageBoxButtonConfig
            //        {
            //            Handler = "App.direct.fileRemove()",
            //            Text = "Yes"
            //        },
            //        No = new MessageBoxButtonConfig
            //        {
            //            Text = "No"
            //        }
            //    }).Show();
            //}
        }

        /// <summary>
        /// fileRemove
        /// </summary>
        /// <param name="fileID"></param>
        [DirectMethod]
        public void fileRemove()
        {
            //try
            //{
            //    //파일삭제
            //    HEParameterSet param = new HEParameterSet();
            //    param.Add("CORCD", Util.UserInfo.CorporationCode);
            //    param.Add("BIZCD", this.txt01_BIZCD.Text);
            //    param.Add("DEFNO", this.txt01_DEFNO.Text);
            //    param.Add("USER_ID", Util.UserInfo.UserID);
            //    param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            //    using (EPClientProxy proxy = new EPClientProxy())
            //    {
            //        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_FILE"), param);
            //        this.MsgCodeAlert("SRMQA00-0049");
            //    }

            //    this.lkb02_FILEID1.Text = string.Empty;
            //    X.Js.Call("parent.fn_MP20003P2_R", this.txt01_ID.Text);
            //}
            //catch (Exception ex)
            //{
            //    this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            //}
            //finally
            //{

            //}
        }

        #endregion

        #region [이벤트]
        /// <summary>
        /// fileDeleteConfirm
        /// </summary>
        /// <param name="fileID"></param>
        public void fileDeleteConfirm(string fileID)
        {
            //파일이 존재하지 않습니다.
            if (string.IsNullOrEmpty(fileID))
            {
                this.MsgCodeAlert("SRMQA00-0050");
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

        /// <summary>
        /// fileDelete DirectMethod
        /// </summary>
        /// <param name="fileID"></param>
        [DirectMethod]
        public void fileDelete(string fileID)
        {
            try
            {
                // 1. 첨부파일 1개 지울때또 DB의 협력업체 기타 테이블의 파일링크 정보를 먼저 제거 후.
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.txt01_BIZCD.Text);
                param.Add("DEFNO", this.txt01_DEFNO.Text);
                param.Add("FILEID", fileID);
                param.Add("USER_ID", this.UserInfo.UserID);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_ATT_FILE"), param);
                    //X.MessageBox.Alert("FileDelete", "파일이 삭제 되었습니다.").Show();
                    this.MsgCodeAlert("EP20010-003");
                }

                // 2. 원격지 파일 및 메타 정보를 삭제한다.
                EPRemoteFileHandler.FileRemove(fileID);

                // 파일 정보 초기화 ( 3개중 삭제된 fileID 를 찾아서 해당 하는 항목만 초기화 )
                if (fileID.Equals(hid01_FILEID1.Value.ToString()))
                {
                    this.fud01_FILEID1.Reset();
                    this.dwn01_FILEID1.Icon = Icon.None;
                    this.dwn01_FILEID1.Text = "";
                    this.hid01_FILEID1.Value = "";
                }

                X.Js.Call("parent.fn_QA20002P2_R", this.txt01_ID.Text);
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

        #region [함수]
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                // 1. 기존의 oldFileID 를 받아온다
                string oldFileID1 = hid01_FILEID1.Value.ToString();

                // 2. 파일서버에 파일 저장후 결과값 반환
                //    DB 에 저장할 fileID 값을 생성한다  ( newFileID 또는 oldFileID 값이 선택적으로 반환됨)
                //
                //    동작조건1: 파일 등록/신규등록 : oldFileID 값은 비어있을것이며, FileUpload 는 newFileID 값읍 반환한다.
                //    동작조건2: 파일 등록/수정등록 : oldFileID 값은 넘어갈것이며, FileUpload 는 newFileID 값을 반환하고, oldFileID 값의 파일은 내부적으로 삭제처리한다.
                //    동작조건3: 파일 미등록/기존파일없음 : oldFileID 값은 비어있을것이며, FileUpload 는 비어있는값을 반환한다.
                //    동작조건4: 파일 미등록/기존파일있음 : oldFileID 값은 넘어갈것이며, FileUpload 는 oldFileID 값을 반환한다.
                //
                string newFileID1 = EPRemoteFileHandler.FileUpload(this.fud01_FILEID1, this.GetMenuID(), oldFileID1);

                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "DEFNO",
                   "FILEID", "USER_ID",
                   "LANG_SET"
                );

                param.Tables[0].Rows.Add(
                    Util.UserInfo.CorporationCode, this.txt01_BIZCD.Text, this.txt01_DEFNO.Text,
                    newFileID1,
                    Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ATT_FILE"), param);
                    this.MsgCodeAlert("COM-00902");
                    //DataSetBind();
                }

                X.Js.Call("parent.fn_QA20002P2_R", this.txt01_ID.Text);
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
                param.Add("DEFNO", this.txt01_DEFNO.Text);
                param.Add("USER_ID", Util.UserInfo.UserID);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ATT_FILE"), param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    //this.lkb02_FILEID1.Text = ds.Tables[0].Rows[0]["ATT_FILENM"].ToString() == "" ? " " : ds.Tables[0].Rows[0]["ATT_FILENM"].ToString();

                    // 여기서 부터 파일처리
                    this.hid01_FILEID1.SetValue(dr["ATT_FILE"]);

                    if (!this.hid01_FILEID1.Value.ToString().Equals(""))
                    {
                        this.dwn01_FILEID1.Text = dr["FILENAME"].ToString();
                        this.dwn01_FILEID1.NavigateUrl = Util.JsFileDirectDownloadByFileID(this.hid01_FILEID1.Value.ToString());
                        this.dwn01_FILEID1.Icon = Icon.Attach;
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
        #endregion
    }
}