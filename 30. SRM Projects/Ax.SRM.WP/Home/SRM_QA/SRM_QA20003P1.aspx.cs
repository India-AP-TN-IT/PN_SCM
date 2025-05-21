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
    /// <summary>
    /// <b>품질팝업 > 입고불량 대책서 검토결과(당사)</b>
    /// - 작 성 자 : 이현범<br />
    /// - 작 성 일 : 2014-10-06<br />
    /// </summary>
    public partial class SRM_QA20003P1 : BasePage
    {
        private string _DOCNO2 = "";
        private string pakageName = "APG_SRM_QA20003";
        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_QA20003P1()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = false;
        }

        /// <summary>
        /// Page_Load
        /// </summary>
        /// <param name="SendBacker"></param>
        /// <param name="e"></param>
        protected void Page_Load(object SendBacker, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, true);

                    Reset();

                    string sQuery = Request.Url.Query;
                    string BIZCD = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    string VENDCD = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");
                    string DOCNO = HttpUtility.ParseQueryString(sQuery).Get("DOCNO");
                    string RCV_DATE = HttpUtility.ParseQueryString(sQuery).Get("RCV_DATE");
                    string DEFNO = HttpUtility.ParseQueryString(sQuery).Get("DEFCD");
                    _DOCNO2 = HttpUtility.ParseQueryString(sQuery).Get("DOCNO2");

                    this.cbo01_BIZCD.SelectedItem.Value = BIZCD;
                    this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
                    this.cdx01_VENDCD.SetValue(VENDCD);
                    this.txt01_DOCNO.SetValue(DOCNO);
                    this.txt01_DOCNO2.SetValue(_DOCNO2);

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

        /// <summary>
        /// BuildButtons
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Receive, ButtonImage.Receive, "Receive", this.ButtonPanel);
            MakeButton(ButtonID.SendBack, ButtonImage.SendBack, "SendBack", this.ButtonPanel);
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
            if (id == ButtonID.Receive)
            {
                ibtn.Cls = "";
                ibtn.DirectEvents.Click.Event -= new ComponentDirectEvent.DirectEventHandler(Button_Click);
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Encode = true , Value = "App.Grid01.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw });

            }
            else if (id == ButtonID.SendBack)
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
        /// <param name="SendBacker"></param>
        /// <param name="e"></param>
        public override void Button_Click(object SendBacker, DirectEventArgs e)
        {
            Ext.Net.ImageButton ibtn = (Ext.Net.ImageButton)SendBacker;
            switch (ibtn.ID)
            {
                case ButtonID.Reset:
                    Reset();
                    break;
                case ButtonID.Receive:
                    Receive(SendBacker, e, ibtn.ID);
                    break;
                case ButtonID.SendBack:
                    Receive(SendBacker, e, ibtn.ID);
                    break;
                case "btn01_CLOSE":
                    //X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
                    break;
                default: break;
            }
        }


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

                result = EPClientHelper.ExecuteDataSet("APG_SRM_QA20003.INQUERY_QA20003P1", param);

                if (result.Tables[0].Rows.Count > 0)
                {
                    this.txt01_USER_ID.SetValue(result.Tables[0].Rows[0]["VEND_MGR"]);
                    this.txt02_OCCUR_APPLI.SetValue(result.Tables[0].Rows[0]["OCCUR_APPLI"]);
                    this.txt02_IMPROV_MEAS.SetValue(result.Tables[0].Rows[0]["IMPROV_MEAS"]);
                    this.txt02_RSLT_CNTT.SetValue(result.Tables[0].Rows[0]["RSLT_CNTT"]);
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
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.txt01_DOCNO.SetValue(string.Empty);
            this.txt01_USER_ID.SetValue(string.Empty);
        }

        /// <summary>
        /// Receive, SendBack
        /// 접수, 반송
        /// </summary>
        /// <param name="actionType"></param>
        public void Receive(object SendBacker, DirectEventArgs e, string btn_id)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                string FIRM_STATUS = "";

                if (btn_id.Equals("ButtonReceive"))
                    FIRM_STATUS = "FQY";
                else
                    FIRM_STATUS = "FQN";

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "RSLT_CNTT", "FIRM_STATUS", 
                    "DOCNO", "USER_ID", "LANG_SET", "DOCNO2"
                );

                if (txt01_DOCNO2.Value.Equals("") || txt01_DOCNO2.Value == null)
                    _DOCNO2 = "0";
                else
                    _DOCNO2 = "1";

                param.Tables[0].Rows.Add(
                    Util.UserInfo.CorporationCode, this.cbo01_BIZCD.Value, txt02_RSLT_CNTT.Value, FIRM_STATUS,
                    txt01_DOCNO.Value, Util.UserInfo.UserID, Util.UserInfo.LanguageShort, _DOCNO2
                );

                if (param.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0011", lbl02_RSLT_CNTT.Text);
                    return;
                }

                ////유효성 검사
                if (btn_id.Equals("Button_Receive"))
                {
                    if (!Validation(FIRM_STATUS, Library.ActionType.Receive))
                    {
                        return;
                    }
                }
                else
                {
                    if (!Validation(FIRM_STATUS, Library.ActionType.SendBack))
                    {
                        return;
                    }
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_RECEIVE"), param);
                    this.MsgCodeAlert("COM-00902");
                    _DOCNO2 = txt01_DOCNO.Text;
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

            // 접수, 반송 공통
            if (actionType == Library.ActionType.Receive || actionType == Library.ActionType.SendBack) 
            {
                if (txt02_OCCUR_APPLI.Value.Equals("") || txt02_OCCUR_APPLI.Value == null)
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0008", lbl02_OCCUR_APPLI.Text);

                else if (txt02_IMPROV_MEAS.Value.Equals("") || txt02_IMPROV_MEAS.Value == null)
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0009", lbl02_IMPROV_MEAS.Text);

                else if (txt02_RSLT_CNTT.Value.Equals("") || txt02_RSLT_CNTT.Value == null)
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0010", lbl02_RSLT_CNTT.Text);

                else
                    result = true;

            }

            return result;
        }
        #endregion
    }
}