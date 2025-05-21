/* 
 * 프로그램명 : 이의제기 공문     [D2](구.VQ2080)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-20
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
    public partial class SRM_QA21004P2 : BasePage
    {
        private string pakageName = "APG_SRM_QA21004";

        #region [ 초기설정 ]
        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_QA21004P2()
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
                case ButtonID.Delete:
                    Remove();
                    break;
                case "btn01_CLOSE":
                    X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
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
            this.txt02_RSLT_CNTT.SetValue(string.Empty);
            this.txt02_RSLT_SUBJECT.SetValue(string.Empty);
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
            DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_QA21004P2"), param);

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
                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "DOCRPTNO", "FORMOBJNO",
                    "RSLT_SUBJECT", "RSLT_CNTT", "USER_ID", "LANG_SET"
                );

                param.Tables[0].Rows.Add(
                    this.txt01_CORCD.Text, this.txt01_BIZCD.Text, this.txt02_DOCRPTNO.Text, this.txt02_FORMOBJNO.Text,
                    this.txt02_RSLT_SUBJECT.Text, this.txt02_RSLT_CNTT.Text, 
                    Util.UserInfo.UserID, Util.UserInfo.LanguageShort
                );

                //유효성 검사
                if (!Validation(Library.ActionType.Save)) return;

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_QA21004P2"), param);
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
            DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_QA21004P2"), param);

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
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_QA21004P2"), param);
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
                if (this.txt02_RSLT_SUBJECT.Text.Trim().Equals("") || String.IsNullOrEmpty(this.txt02_RSLT_SUBJECT.Text))
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0022");
                    return false;
                }
                //결과
                if (this.txt02_RSLT_CNTT.Text.Trim().Equals("") || String.IsNullOrEmpty(this.txt02_RSLT_CNTT.Text))
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0034");
                    return false;
                }
                //의뢰진행 체크
                else if (this.txt01_RROG_DIV.Text.Length > 0)
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0036");
                    return false;
                }
                else
                    return true;
                
            }

            // 삭제
            if (actionType == Library.ActionType.Delete)
            {
                //의뢰진행 체크
                if (this.txt01_RROG_DIV.Text.Length > 0)
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0035");
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