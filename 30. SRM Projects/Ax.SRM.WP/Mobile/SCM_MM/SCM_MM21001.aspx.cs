#region ▶ Description & History
/* 
 * 프로그램명 : A/S, S/P, CKD 자재발주 (구.VM2010)
 * 설      명 : 자재관리 > 발주관리 > A/S, S/P, CKD 자재발주
 * 최초작성자 : 이명희
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
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using System.Data;
using System.Collections;
using System.Text;

namespace Ax.SRM.WP.Mobile.SRM_MM
{
    public partial class SRM_MM21001 : BasePage
    {
        private string pakageName = "APG_SRM_MOBILE";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM21001
        /// </summary>
        public SRM_MM21001()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = true;
            this.IsMobilePage = true;
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
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);
                    Library.ComboDataBind(this.cbo01_JOB_TYPE, Library.GetTypeCode("A1").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);
                    Reset();

                    ImageButtonLogout.Listeners.Click.Handler = "logoutHandler('" + Library.getMessage("Logout") + "')";
                }
            }
            catch //(Exception ex)
            {
                // excel 다운로드는 메시지 처리 하지 않음
                //this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        #endregion

        #region [ 버튼설정 ]

        /// <summary>
        /// BuildButtons
        /// 기본 버튼생성
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.M_Search, ButtonImage.M_Search, "Search", this.ButtonPanel);
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
        /// 기본 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public override void Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.ImageButton ibtn = (Ext.Net.ImageButton)sender;

            switch (ibtn.ID)
            {
                case ButtonID.M_Search:
                    Search();
                    break;
                case ButtonID.Close:
                    X.Js.Call("closeTab");
                    break;
                default: break;
            }
        }

        /// <summary>
        /// etc_Button_Click
        /// 사용자 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void etc_Button_Click(object sender, EventArgs e)
        {

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
                //유효성 검사
                if (!IsQueryValidation()) return;

                DataSet result = getDataSet();

                this.Store1.RemoveAll();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                //StringBuilder html = new StringBuilder();
                //html.Append("<Div style=\"height:300px;overflow-y:scroll;overflow-x:scroll;white-space:nowrap;\">");
                //html.Append("<table class=\"data\">");
                //html.Append("<tr><th>Name</th><th>Value</th></tr>");

                //for (int i = 0; i < result.Tables[0].Rows.Count; i++)
                //{
                //    for (int j = 0; j < result.Tables[0].Columns.Count; j++)
                //    {
                //        html.Append("<tr>");
                //        html.Append("<td>" + result.Tables[0].Columns[j] + "</td>");
                //        html.Append("<td>" + result.Tables[0].Rows[i][j] + "</td>");
                //        html.Append("</tr>");
                //    }
                //}

                //html.Append("</table>");
                //html.Append("</Div>");

                //this.Label1.Html = html.ToString();
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
        /// Reset
        /// </summary>
        public void Reset()
        {
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cdx01_VINCD.SetValue(string.Empty);

            this.df01_PO_DATE.SetValue(DateTime.Now);

            this.cbo01_JOB_TYPE.SelectedItem.Value = "";
            this.cbo01_JOB_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

            this.chk01_PO_STATUS_DIV.Checked = false;

            this.df01_PO_FROM_DATE.SetValue(DateTime.Now.AddDays(-30));

            this.Store1.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("PO_DATE", ((DateTime)this.df01_PO_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("PO_FROM_DATE", ((DateTime)this.df01_PO_FROM_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("JOB_TYPE", this.cbo01_JOB_TYPE.Value);
            param.Add("PO_STATUS_DIV", this.chk01_PO_STATUS_DIV.Checked ? "Y" : "N");
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_MM21001"), param);
        }

        #endregion

        #region [ 유효성 검사 ]

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {
            // 조회용 Validation
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.df01_PO_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_PO_DATE", lbl01_BASE_DATE.Text);
                return false;
            }
            return true;
        }

        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        [DirectMethod]
        public void GridDetailSave(object sender, DirectEventArgs e)
        {
            try
            {
                //string json = e.ExtraParams["Values"];
                //Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                //if (parameters.Length == 0)
                //{
                //    this.MsgCodeAlert("COM-00020");
                //    return;
                //}

                if (this.txt02_PONO.Text.Equals(string.Empty) || (this.df02_VAN_DELI_DATE.IsEmpty && this.chk02_VAN_OK_YN.IsEmpty))
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }


                DataSet param = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "PONO", "VAN_DELI_DATE", "VAN_OK_YN", "LANG_SET", "USER_ID"
                );

                param.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode
                    , this.cbo01_BIZCD.Value
                    , this.txt02_PONO.Text
                    , this.df02_VAN_DELI_DATE.Value == null ? "" : DateTime.Parse(this.df02_VAN_DELI_DATE.Text).ToString("yyyy-MM-dd")
                    , this.chk02_VAN_OK_YN.Checked == true ? "1" : "0"
                    , this.UserInfo.LanguageShort
                    , this.UserInfo.UserID
                );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_MM21001"), param);
                    //this.MsgCodeAlert("COM-00902");
                    //Search();
                    this.DetailWindow.Hide();
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
