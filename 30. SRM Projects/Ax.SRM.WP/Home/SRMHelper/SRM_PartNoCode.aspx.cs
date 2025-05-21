using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Ax.EP.Utility;
using Ax.EP.Utility.Security;
using HE.Framework.Core;
using System.Data;
using System.Text;


namespace Ax.SRM.WP.Home.SRMHelper
{
    /// <summary>
    /// <b>공통팝업 > 품번검색 마스터</b>
    /// - 작 성 자 : 김건우<br />
    /// - 작 성 일 : 2014-07-28<br />
    public partial class SRM_PartNoCode : BasePage
    {
        public SRM_PartNoCode()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // 원래 팝업창 사이즈 보다 40만큼 작게 내부에 팝업을 뛰움
                cdx01_VINCD.PopupWidth = PopupHelper.defaultPopupWidth - 40;
                cdx01_VINCD.PopupHeight = PopupHelper.defaultPopupHeight - 80;

                if (!IsPostBack)
                {
                    string sQuery = Request.Url.Query;
                    this.txt01_ID.Text = HttpUtility.ParseQueryString(sQuery).Get("ID");
                    this.txt01_PNO.Text = HttpUtility.ParseQueryString(sQuery).Get("CODE");
                    this.txt01_PNO_NAME.Text = HttpUtility.ParseQueryString(sQuery).Get("TEXT");

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

        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);            
            MakeButton(ButtonID.Accept, ButtonImage.Accept, "Accept", this.ButtonPanel);
        }

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


        //선택된 행 입력
        public void GridPanel_RowDblClick(object sender, DirectEventArgs e)
        {
            try
            {
                string values = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(values);
                X.Js.Call("fn_sendParentWindow", this.txt01_ID.Text, parameters[0]["PARTNO"], parameters[0]["PARTNM"], parameters[0]["PARTNO"], JSON.Serialize(parameters[0]));
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        //검색
        public void GridDataBind()
        {
            try
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD",Util.UserInfo.CorporationCode);
                param.Add("BIZCD",Util.UserInfo.BusinessCode);
                param.Add("PARTNO", this.txt01_PNO.Value);
                param.Add("PARTNM", this.txt01_PNO_NAME.Value);
                param.Add("VINCD", this.cdx01_VINCD.Value);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                DataSet result = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_PARTNO", param);
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

        //초기화
        public void Reset()
        {
            this.txt01_PNO.Value = "";
            this.txt01_PNO_NAME.Value = "";
            this.cdx01_VINCD.SetValue("");
            this.Store1.RemoveAll();
        }

        //선택
        public void Accept(string json)
        {
            try
            {
                Dictionary<string, object>[] parameter = JSON.Deserialize<Dictionary<string, object>[]>(json);
                if (parameter.Count() > 0)
                {
                    X.Js.Call("fn_sendParentWindow", this.txt01_ID.Text, parameter[0]["PARTNO"], parameter[0]["PARTNM"], parameter[0]["PARTNO"], JSON.Serialize(parameter[0]));
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