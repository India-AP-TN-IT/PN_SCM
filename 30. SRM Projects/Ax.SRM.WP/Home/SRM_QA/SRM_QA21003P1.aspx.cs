/* 
 * 프로그램명 : 이의제기 공문     [D2](구.VQ2070)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-13
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
 *				
 *
 * 
*/
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

namespace Ax.SRM.WP.Home.SRM_QA
{
    public partial class SRM_QA21003P1 : BasePage
    {
        private string pakageName = "APG_SRM_QA21003";

        #region [ 초기설정 ]
        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_QA21003P1()
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
                    Reset();

                    string sQuery = Request.Url.Query;
                    this.txt01_ID.Text = HttpUtility.ParseQueryString(sQuery).Get("ID");
                    string CORCD = HttpUtility.ParseQueryString(sQuery).Get("CORCD");
                    string BIZCD = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    string DOCRPTNO = HttpUtility.ParseQueryString(sQuery).Get("DOCRPTNO");
                    string FORMOBJNO = HttpUtility.ParseQueryString(sQuery).Get("FORMOBJNO");
                    string RROG_DIV = HttpUtility.ParseQueryString(sQuery).Get("RROG_DIV");

                    this.txt01_CORCD.SetValue(CORCD);
                    this.txt01_BIZCD.SetValue(BIZCD);
                    this.txt02_DOCRPTNO.SetValue(DOCRPTNO);
                    this.txt02_FORMOBJNO.SetValue(FORMOBJNO);
                    this.txt01_RROG_DIV.SetValue(RROG_DIV);

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
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
            //MakeButton(ButtonID.FileDown, ButtonImage.FileDown, "FileDown", this.ButtonPanel, true);  //파일다운로드할 때는 반드시 UPLOAD여부에 TRUE로 전달하여야 한다. 그래야  IFRAME처리가 된다고 함.
            MakeButton(ButtonID.Delete, ButtonImage.Delete, "Delete", this.ButtonPanel);
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
                    X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
                    break;
                case ButtonID.FileDown:
                    FileDown();
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
                    fileDeleteConfirm();
                    break;
                case "btn01_FILEID2_DEL":
                    fileDeleteConfirm("1");
                    break;
                case "lkb02_FILEID1":
                    FileDown();
                    break;
                case "lkb02_FILEID2":
                    FileDown("1");
                    break;
                default:
                    break;
            }
        }

        #endregion

        #region [ 기능 ]

        /// <summary>
        /// Reset 초기화
        /// </summary>
        public void Reset()
        {
            this.txt02_REQT_REASON.SetValue(string.Empty);
            this.txt02_REQT_SUBJECT.SetValue(string.Empty);
        }

        public void Search()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.txt01_CORCD.Text);
            param.Add("BIZCD", this.txt01_BIZCD.Text);
            param.Add("DOCRPTNO", this.txt02_DOCRPTNO.Text);
            param.Add("FORMOBJNO", this.txt02_FORMOBJNO.Text);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);
            DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_QA21003P1"), param);

            //데이터가 있을 경우
            if (result.Tables[0].Rows.Count > 0)
            {
                //데이터 바인딩
                this.txt02_REQT_SUBJECT.Value = result.Tables[0].Rows[0]["REQT_SUBJECT"];
                this.txt02_REQT_REASON.Value = result.Tables[0].Rows[0]["REQT_REASON"];//저거 아이디 임.. 젤 지워서 그렇슴
                this.txt02_RSLT_SUBJECT.Value = result.Tables[0].Rows[0]["RSLT_SUBJECT"];
                this.txt02_RSLT_CNTT.Value = result.Tables[0].Rows[0]["RSLT_CNTT"];
                
                this.lkb02_FILEID1.Text = result.Tables[0].Rows[0]["ATT_FILE1_NM"].ToString() == "" ? " " : result.Tables[0].Rows[0]["ATT_FILE1_NM"].ToString();
                this.lkb02_FILEID2.Text = result.Tables[0].Rows[0]["ATT_FILE2_NM"].ToString() == "" ? " " : result.Tables[0].Rows[0]["ATT_FILE2_NM"].ToString();
            }
        }

        /// <summary>
        /// Save
        /// 저장
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                byte[] file1 = this.fud02_FILEID1.FileBytes;
                byte[] file2 = this.fud02_FILEID2.FileBytes;

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "DOCRPTNO", "FORMOBJNO",
                    "REQT_SUBJECT", "REQT_REASON",
                    "RSLT_SUBJECT", "RSLT_CNTT", "USER_ID", "LANG_SET",
                    "ATT_FILE1_NM", "BLOB$ATT_FILE1", "ATT_FILE2_NM", "BLOB$ATT_FILE2"
                );

                param.Tables[0].Rows.Add(
                    this.txt01_CORCD.Text, this.txt01_BIZCD.Text, this.txt02_DOCRPTNO.Text, this.txt02_FORMOBJNO.Text,
                    this.txt02_REQT_SUBJECT.Text, this.txt02_REQT_REASON.Text, this.txt02_RSLT_SUBJECT.Text, this.txt02_RSLT_CNTT.Text,
                    Util.UserInfo.UserID, Util.UserInfo.LanguageShort,
                    System.IO.Path.GetFileName(fud02_FILEID1.FileName),        //첨부파일1명
                    file1,                                                  //첨부파일1 데이터
                    System.IO.Path.GetFileName(fud02_FILEID2.FileName),  //첨부파일2명
                    file2                                                   //첨부파일2 데이터
                );

                //유효성 검사
                if (!Validation(Library.ActionType.Save)) return;

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_QA21003P1"), param);
                    this.MsgCodeAlert("COM-00902");
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

        public void FileDown(string cnt = "0")
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.txt01_CORCD.Text);
            param.Add("BIZCD", this.txt01_BIZCD.Text);
            param.Add("DOCRPTNO", this.txt02_DOCRPTNO.Text);
            param.Add("FORMOBJNO", this.txt02_FORMOBJNO.Text);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);
            DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_QA21003P1_FILE"), param);

            //데이터가 있을 경우
            if (result.Tables[0].Rows.Count > 0)
            {
                if (cnt.Equals("0"))
                {
                    Util.FileDownLoadByBlob(this.Page, (byte[])result.Tables[0].Rows[0]["ATT_FILE1"], result.Tables[0].Rows[0]["ATT_FILE1_NM"].ToString());
                    this.lkb02_FILEID1.Text = result.Tables[0].Rows[0]["ATT_FILE1_NM"].ToString();
                }
                else
                {
                    Util.FileDownLoadByBlob(this.Page, (byte[])result.Tables[0].Rows[0]["ATT_FILE2"], result.Tables[0].Rows[0]["ATT_FILE2_NM"].ToString());
                    this.lkb02_FILEID2.Text = result.Tables[0].Rows[0]["ATT_FILE2_NM"].ToString();
                }
            }
        }

        /// <summary>
        /// fileDeleteConfirm
        /// </summary>
        /// <param name="fileID"></param>
        public void fileDeleteConfirm(string cnt = "0")
        {
            if (cnt.Equals("0") && string.IsNullOrEmpty(lkb02_FILEID1.Text.Trim()))
            {
                this.MsgCodeAlert("SRMQA00-0050");
                return;
            }
            else if (cnt.Equals("1") && string.IsNullOrEmpty(lkb02_FILEID2.Text.Trim()))
            {
                this.MsgCodeAlert("SRMQA00-0050");
                return;
            }
            else
            {
                X.MessageBox.Confirm("Confirm", Library.getMessage("COM-00801"), new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.fileRemove('" + cnt + "')",
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
        public void fileRemove(string cnt = "0")
        {
            try
            {
                //파일삭제
                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "DOCRPTNO", "FORMOBJNO", "LANG_SET", "USER_ID", "CNT"
                );

                param.Tables[0].Rows.Add(
                      this.txt01_CORCD.Text, this.txt01_BIZCD.Text, this.txt02_DOCRPTNO.Text, this.txt02_FORMOBJNO.Text, Util.UserInfo.UserID, Util.UserInfo.LanguageShort, cnt
                  );

                //유효성 검사
                if (!Validation(Library.ActionType.Delete)) return;

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_FILE"), param);
                    this.MsgCodeAlert("SRMQA00-0049");
                }

                if (cnt.Equals("0"))
                    this.lkb02_FILEID1.Text = string.Empty;
                else
                    this.lkb02_FILEID2.Text = string.Empty;
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {

            }
        }

        public void Remove()
        {
            //저장공간
            DataSet param = Util.GetDataSourceSchema
            (
               "CORCD", "BIZCD", "DOCRPTNO", "FORMOBJNO", "LANG_SET", "USER_ID"
            );

            param.Tables[0].Rows.Add(
                  this.txt01_CORCD.Text, this.txt01_BIZCD.Text, this.txt02_DOCRPTNO.Text, this.txt02_FORMOBJNO.Text, Util.UserInfo.UserID, Util.UserInfo.LanguageShort
              );

            //유효성 검사
            if (!Validation(Library.ActionType.Delete)) return;

            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_QA21003P1"), param);
                this.MsgCodeAlert("COM-00002");
                Search();
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
        public bool Validation(Library.ActionType actionType)
        {
            bool result = false;

            // 저장
            if (actionType == Library.ActionType.Save) 
            {
                //제목
                if (this.txt02_REQT_SUBJECT.Text.Trim().Equals("") || String.IsNullOrEmpty(this.txt02_REQT_SUBJECT.Text))
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0022");
                    return false;
                }
                //사유
                if (this.txt02_REQT_REASON.Text.Trim().Equals("") || String.IsNullOrEmpty(this.txt02_REQT_REASON.Text))
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0023");
                    return false;
                }
                //의뢰진행 체크
                else if (this.txt01_RROG_DIV.Text.Equals("FEB") || this.txt01_RROG_DIV.Text.Equals("FEC"))
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0016");
                    return false;
                }
                //결과 체크
                else if (!String.IsNullOrEmpty(this.txt02_RSLT_SUBJECT.Text) && !this.txt02_RSLT_SUBJECT.Text.Equals(""))
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0017");
                    return false;
                }
                else
                    return true;
                
            }

            // 삭제
            if (actionType == Library.ActionType.Delete)
            {
                //의뢰진행 체크
                if (this.txt01_RROG_DIV.Text.Equals("FEB") || this.txt01_RROG_DIV.Text.Equals("FEC"))
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0018");
                    return false;
                }
                //결과 체크
                else if (!String.IsNullOrEmpty(this.txt02_RSLT_SUBJECT.Text) && !this.txt02_RSLT_SUBJECT.Text.Equals(""))
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0019");
                    return false;
                }
                else
                    return true;

            }

            return result;
        }
        #endregion
    }
}