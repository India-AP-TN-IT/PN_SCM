#region ▶ Description & History
/* 
 * 프로그램명 : 일별검수현황 팝업     [D2](구.VG3090P1)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-09-22
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
using System.Data;
using System.Linq;
using System.Web;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MP
{
    public partial class SRM_MP30010P1 : BasePage
    {
        #region [ 초기설정 ]

        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_MP30010P1()
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

                    string CORCD = HttpUtility.ParseQueryString(sQuery).Get("CORCD");
                    string BIZCD = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    string VENDCD = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");
                    string RCV_DATE = HttpUtility.ParseQueryString(sQuery).Get("RCV_DATE");
                    string TEAM_DIV = HttpUtility.ParseQueryString(sQuery).Get("TEAM_DIV");
                    string PARTNO = HttpUtility.ParseQueryString(sQuery).Get("PARTNO");

                    DataSet ds = null;

                    HEParameterSet param = new HEParameterSet();
                    param.Add("CORCD", CORCD);
                    param.Add("BIZCD", BIZCD);
                    param.Add("VENDCD", VENDCD);
                    param.Add("TEAM_DIV", TEAM_DIV);
                    param.Add("RCV_DATE", RCV_DATE);
                    param.Add("PARTNO", PARTNO); 
                    param.Add("USER_ID", Util.UserInfo.UserID);
                    param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                    ds = EPClientHelper.ExecuteDataSet("PKG_SCM_MP30010.INQUERY_POPUP", param);

                    if (ds.Tables[0].Rows.Count <= 0)
                        return;

                    this.Store1.DataSource = ds.Tables[0];
                    this.Store1.DataBind();
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
            //MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
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
            //Ext.Net.ImageButton ibtn = CreateImageButton(id, image, alt, isUpload);
            //if (id == ButtonID.Accept)
            //{
            //    ibtn.Cls = "";
            //    ibtn.DirectEvents.Click.Event -= new ComponentDirectEvent.DirectEventHandler(Button_Click);
            //    ibtn.DirectEvents.Click.ExtraParams.Add(
            //    new Ext.Net.Parameter { Name = "Values", Encode = true , Value = "App.Grid01.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw });

            //} 
            //container.Add(ibtn);

        }

        #endregion

        #region [ 기능 ]

        /// <summary>
        /// etc_Button_Click
        /// 사용자 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void etc_Button_Click(object sender, EventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_ALL":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    HEParameterSet set = new HEParameterSet();
                    //set.Add("BIZCD", this.SelectBox01_BIZCD.Value);
                    //set.Add("VENDCD", this.cdx01_VENDCD.Value);
                    //Util.UserPopup(this, "HELP_CUST_ITEMCD", PopupHelper.HelpType.Search, "GRID_CUST_ITEMCD_HELP01", this.CodeValue.Text, this.NameValue.Text, "", PopupHelper.defaultPopupWidth, PopupHelper.defaultPopupHeight, set);
                    //Util.UserPopup(this, this.UserHelpURL.Text, set, "HELP_QA23001P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
                    break;

                default:
                    break;
            }
        }

        /// <summary>
        /// Reset 초기화
        /// </summary>
        public void Reset()
        {
            //this.txt01_LINECD.Value = "";
            //this.txt01_LINENM.Value = "";
            //this.Store1.RemoveAll();
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
                    //X.Js.Call("fn_sendParentWindow", this.txt01_ID.Text, parameter[0]["LINECD"], parameter[0]["LINENM"], parameter[0]["LINECD"], JSON.Serialize(parameter[0]));
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

        #endregion
    }
}