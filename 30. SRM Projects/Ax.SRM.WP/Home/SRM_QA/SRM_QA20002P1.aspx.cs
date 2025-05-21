/* 
 * 프로그램명 : 입고불량 대책서 검토결과(업체)     [D2](구.VQ2010)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-08
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
    public partial class SRM_QA20002P1 : BasePage
    {
        private string _DOCNO2 = "";
        private string pakageName = "APG_SRM_QA20002";

        #region [ 초기설정 ]
        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_QA20002P1()
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
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, true);

                    Reset();

                    this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
                    this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
                    this.txt01_DOCNO.SetValue(string.Empty);
                    this.txt01_USER_ID.SetValue(string.Empty);
                    if (this.UserInfo.UserDivision.Equals("T12"))
                    {
                        this.cdx01_VENDCD.SetValue(string.Empty);
                    }

                    string sQuery = Request.Url.Query;
                    string BIZCD = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    string VENDCD = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");
                    string DOCNO = HttpUtility.ParseQueryString(sQuery).Get("DOCNO");
                    string RCV_DATE = HttpUtility.ParseQueryString(sQuery).Get("RCV_DATE");
                    string INSPECT_DIV = HttpUtility.ParseQueryString(sQuery).Get("INSPECT_DIV");
                    string DEFCD = HttpUtility.ParseQueryString(sQuery).Get("DEFCD");
                    _DOCNO2 = HttpUtility.ParseQueryString(sQuery).Get("DOCNO2");
                    string VENDCDSTATUSCD = HttpUtility.ParseQueryString(sQuery).Get("VENDCDSTATUSCD");
                    string FIRMSTATUSCD = HttpUtility.ParseQueryString(sQuery).Get("FIRMSTATUSCD");
                    string CHKBTN = HttpUtility.ParseQueryString(sQuery).Get("CHKBTN");

                    this.cbo01_BIZCD.SelectedItem.Value = BIZCD;
                    this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
                    this.cdx01_VENDCD.SetValue(VENDCD);
                    this.txt01_DOCNO.SetValue(DOCNO);
                    this.txt01_DOCNO2.SetValue(_DOCNO2);
                    this.txt01_CHKBTN.SetValue(CHKBTN);
                    this.txt01_FIRMSTATUSCD.SetValue(FIRMSTATUSCD);

                    this.GridDataBind();
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
            MakeButton(ButtonID.Write, ButtonImage.Write, "Write", this.ButtonPanel);
            MakeButton(ButtonID.Send, ButtonImage.Send, "Send", this.ButtonPanel);
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
            if (id == ButtonID.Write)
            {
                ibtn.Cls = "";
                ibtn.DirectEvents.Click.Event -= new ComponentDirectEvent.DirectEventHandler(Button_Click);
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Encode = true , Value = "App.Grid01.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw });

            }
            else if (id == ButtonID.Send)
            {
                ibtn.Cls = "";
                ibtn.DirectEvents.Click.Event -= new ComponentDirectEvent.DirectEventHandler(Button_Click);
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Encode = true, Value = "App.Grid01.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw });

            } 
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
                case ButtonID.Write:
                    if (txt01_CHKBTN.Value.Equals("") || txt01_CHKBTN.Value.Equals("CR") || txt01_FIRMSTATUSCD.Value.Equals("FQN"))
                    {
                        if (!txt01_FIRMSTATUSCD.Value.Equals("FQY"))
                        {
                            Write(sender, e, ibtn.ID);
                        }
                        txt01_CHKBTN.Value = "CR";
                    }
                    else if (txt01_CHKBTN.Value.Equals("CR") && txt01_FIRMSTATUSCD.Value.Equals("FQY"))
                    {
                        MsgCodeAlert("SRMMP00-0018");
                    }
                    else if (txt01_CHKBTN.Value.Equals("SR"))
                    {
                        MsgCodeAlert("SRMMP00-0019");
                    }
                    break;
                case ButtonID.Send:
                    if (txt01_CHKBTN.Value.Equals("CR") || txt01_FIRMSTATUSCD.Value.Equals("FQN"))
                    {
                        Write(sender, e, ibtn.ID);
                        txt01_CHKBTN.Value = "SR";
                    }
                    else if (txt01_CHKBTN.Value.Equals(""))
                    {
                        MsgCodeAlert("SRMMP00-0021");
                    }
                    else if (txt01_CHKBTN.Value.Equals("SR"))
                    {
                        MsgCodeAlert("SRMMP00-0019");
                    }
                    break;
                case "btn01_CLOSE":
                    //X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
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
                case "lkb02_FILEID1":
                    FileDown();
                    break;
                default:
                    break;
            }
        }

        #endregion

        #region [ 기능 ]

        /// <summary>
        /// GridDataBind 검색
        /// </summary>
        public void GridDataBind()
        {
            try
            {
                DataSet result = null;
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", this.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("DOCNO", this.txt01_DOCNO.Text);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                param.Add("USER_ID", Util.UserInfo.UserID);

                result = EPClientHelper.ExecuteDataSet("APG_SRM_QA20002.INQUERY_QA20002P1", param);

                if (result.Tables[0].Rows.Count > 0)
                {
                    this.txt01_USER_ID.SetValue(result.Tables[0].Rows[0]["VEND_MGR"]);
                    this.txt02_OCCUR_APPLI.SetValue(result.Tables[0].Rows[0]["OCCUR_APPLI"]);
                    this.txt02_IMPROV_MEAS.SetValue(result.Tables[0].Rows[0]["IMPROV_MEAS"]);
                    this.txt02_RSLT_CNTT.SetValue(result.Tables[0].Rows[0]["RSLT_CNTT"]);
                    this.lkb02_FILEID1.Text = result.Tables[0].Rows[0]["ATT_FILE_NM"].ToString() == "" ? " " : result.Tables[0].Rows[0]["ATT_FILE_NM"].ToString();
                }

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
        /// Reset 초기화
        /// </summary>
        public void Reset()
        {
            this.txt02_OCCUR_APPLI.SetValue(string.Empty);
            this.txt02_IMPROV_MEAS.SetValue(string.Empty);
            this.txt02_RSLT_CNTT.SetValue(string.Empty);
            this.lkb02_FILEID1.Text = "";
        }

        /// <summary>
        /// Write, Send
        /// 작성, 회신
        /// </summary>
        /// <param name="actionType"></param>
        public void Write(object sender, DirectEventArgs e, string btn_id)
        {
            try
            {
                byte[] file = this.fud02_FILEID1.FileBytes;

                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                string STATUS = "";

                if (btn_id.Equals("ButtonWrite"))
                    STATUS = "FHY";
                else
                    STATUS = "FHN";

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "DOCNO", "OCCUR", "IMPROV",
                    "EMPNO", "STATUS", "VEND_MGR", "USER_ID", "LANG_SET",
                    "ATT_FILE_NM", "BLOB$ATT_FILE"
                );

                param.Tables[0].Rows.Add(
                    Util.UserInfo.CorporationCode, this.cbo01_BIZCD.Value, this.txt01_DOCNO.Value,
                    txt02_OCCUR_APPLI.Value, txt02_IMPROV_MEAS.Value,
                    Util.UserInfo.UserID, STATUS, this.txt01_USER_ID.Value, Util.UserInfo.UserID, Util.UserInfo.LanguageShort,
                    System.IO.Path.GetFileName(fud02_FILEID1.FileName),        //첨부파일1명
                    file                                                 //첨부파일1 데이터
                );

                ////유효성 검사
                if (btn_id.Equals("ButtonWrite"))
                {
                    if (!Validation(STATUS, Library.ActionType.Write))
                    {
                        return;
                    }
                }
                else
                {
                    if (!Validation(STATUS, Library.ActionType.Send))
                    {
                        return;
                    }
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_MAKE"), param);
                    this.MsgCodeAlert("COM-00902");

                    this.GridDataBind();
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

        public void FileDown()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
            param.Add("DOCNO", this.txt01_DOCNO.Text);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            param.Add("USER_ID", Util.UserInfo.UserID);
            DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_QA20002P1_FILE"), param);

            //데이터가 있을 경우
            if (result.Tables[0].Rows.Count > 0)
            {
                Util.FileDownLoadByBlob(this.Page, (byte[])result.Tables[0].Rows[0]["ATT_FILE"], result.Tables[0].Rows[0]["ATT_FILE_NM"].ToString());
                this.lkb02_FILEID1.Text = result.Tables[0].Rows[0]["ATT_FILE_NM"].ToString() == "" ? " " : result.Tables[0].Rows[0]["ATT_FILE_NM"].ToString();
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
                this.MsgCodeAlert("SRMQA00-0050");
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
                param.Add("CORCD", this.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
                param.Add("DOCNO", this.txt01_DOCNO.Text);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                param.Add("USER_ID", Util.UserInfo.UserID);

                //유효성 검사
                //if (txt01_CHKBTN.Value.Equals("CR") && txt01_FIRMSTATUSCD.Value.Equals("FQY"))
                //{
                //    MsgCodeAlert("SRMMP00-0018");
                //    return;
                //}
                //else if (txt01_CHKBTN.Value.Equals("SR"))
                //{
                //    MsgCodeAlert("SRMMP00-0019");
                //    return;
                //}

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_FILE"), param);
                    this.MsgCodeAlert("SRMQA00-0049");
                }

                this.lkb02_FILEID1.Text = string.Empty;
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
        public bool Validation(string STATUS, Library.ActionType actionType, int actionRow = -1)
        {
            bool result = false;

            // 작성, 회신 공통
            if (actionType == Library.ActionType.Write || actionType == Library.ActionType.Send) 
            {
                if (txt01_USER_ID.Value.Equals("") || txt01_USER_ID.Value == null)
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0046", "txt01_USER_ID", lbl01_WRITE_EMP.Text);

                else if (txt02_OCCUR_APPLI.Value.Equals("") || txt02_OCCUR_APPLI.Value == null)
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "txt02_OCCUR_APPLI", lbl02_OCCUR_APPLI.Text);

                else if (txt02_IMPROV_MEAS.Value.Equals("") || txt02_IMPROV_MEAS.Value == null)
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "txt02_IMPROV_MEAS", lbl02_IMPROV_MEAS.Text);

                else if (STATUS.Equals("FHN"))
                {
                    if (!txt01_FIRMSTATUSCD.Value.Equals("FQN") && !txt01_FIRMSTATUSCD.Value.Equals(string.Empty))
                        this.MsgCodeAlert_ShowFormat("SRMMP00-0017");
                    else
                        result = true;
                }
                else
                    result = true;

            }

            return result;
        }
        #endregion
    }
}