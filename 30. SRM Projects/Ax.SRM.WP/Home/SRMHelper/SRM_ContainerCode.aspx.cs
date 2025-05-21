using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using TheOne.UIModel;
using Ext.Net;
using Ax.EP.Utility;
using Ax.EP.Utility.Security;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRMHelper
{
    /// <summary>
    /// <b>공통팝업 > 고객사</b>
    /// - 작 성 자 : 김건우<br />
    /// - 작 성 일 : 2014-07-28<br />
    /// </summary>
    public partial class SRM_ContainerCode : Ax.EP.Utility.BasePage
    {
        /// <summary>
        /// SRM_StoreLocationCode 생성자
        /// </summary>
        public SRM_ContainerCode()
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

                    this.txt01_CONTCD.Text = HttpUtility.ParseQueryString(sQuery).Get("CODE");
                    this.txt01_CONTNM.Text = HttpUtility.ParseQueryString(sQuery).Get("TEXT");
                    this.txt01_ID.Text = HttpUtility.ParseQueryString(sQuery).Get("ID");

                    this.txt01_BIZCD.Text = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");

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
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Accept, ButtonImage.Accept, "Accept", this.ButtonPanel);
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
            if (id == ButtonID.Accept)
            {
                ibtn.Cls = "";
                ibtn.DirectEvents.Click.Event -= new ComponentDirectEvent.DirectEventHandler(Button_Click);
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Encode=true, Value = "App.Grid01.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw });

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
                case ButtonID.Search:
                    GridDataBind();
                    break;
                case ButtonID.Reset:
                    Reset();
                    break;
                case ButtonID.Accept:
                    Accept(e.ExtraParams["Values"]);
                    break;
                //case "btn01_CLOSE":
                //    X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
                //    break;
                default: break;
            }
        }


        /// <summary>
        /// GridPanel_RowDblClick 선택된 행 입력
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void GridPanel_RowDblClick(object sender, DirectEventArgs e)
        {
            try
            {
                string values = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(values);
                X.Js.Call("fn_sendParentWindow", this.txt01_ID.Text, parameters[0]["CONTCD"], parameters[0]["CONTNM"], parameters[0]["CONTCD"], JSON.Serialize(parameters[0]));
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
            this.txt01_CONTCD.Value = "";
            this.txt01_CONTNM.Value = "";
            this.Store1.RemoveAll();
        }

        /// <summary>
        /// Search 검색
        /// </summary>
        public void GridDataBind()
        {
            try
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", this.UserInfo.CorporationCode);
                param.Add("BIZCD", this.txt01_BIZCD.Text);             
                param.Add("CONTCD", txt01_CONTCD.Text);
                param.Add("CONTNM", txt01_CONTNM.Text);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                DataSet ds = null;
                ds = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_CONTCD", param);

                this.Store1.DataSource = ds.Tables[0];
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
        /// Accept 값 선택
        /// </summary>
        /// <param name="v"></param>
        public void Accept(string json)
        {
            try
            {
                Dictionary<string, object>[] parameter = JSON.Deserialize<Dictionary<string, object>[]>(json);
                if (parameter.Count() > 0)
                {
                    X.Js.Call("fn_sendParentWindow", this.txt01_ID.Text, parameter[0]["CONTCD"], parameter[0]["CONTNM"], parameter[0]["CONTCD"], JSON.Serialize(parameter[0]));
                }
                else
                {
                    //TITLE : 경고, MESSAGE : 행을 선택해 주세요.
                    this.MsgCodeAlert("COM-00804");
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