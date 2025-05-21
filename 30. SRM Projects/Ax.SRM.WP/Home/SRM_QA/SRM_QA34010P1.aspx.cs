#region ▶ Description & History
/* 
 * 프로그램명 : 열람사유입력 팝업
 * 설      명 : 
 * 최초작성자 : 배명희
 * 최초작성일 : 2015-05-28
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
using HE.Framework.Core.Report;

namespace Ax.EP.WP.Home.SRM_QA
{
    public partial class SRM_QA34010P1 : BasePage
    {
        private string pakageName = "APG_SRM_QA34010";
        /// <summary>
        /// SRM_QA34010P1 생성자
        /// </summary>
        public SRM_QA34010P1()
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
                this.hiddenLANG_SET.Text = this.UserInfo.LanguageShort;
                this.txt01_ID.Text = "HELP_QA34010P1";

                if (!IsPostBack)
                {
                    string sQuery = Request.Url.Query;

                    string FILEID = HttpUtility.ParseQueryString(sQuery).Get("FILEID");
                    string DOCNO = HttpUtility.ParseQueryString(sQuery).Get("DOCNO");
                    this.txt01_FILEID.SetValue(FILEID);
                    this.txt01_DOCNO.SetValue(DOCNO);

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
        /// 열람 이력 저장
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        [DirectMethod]
        public void etc_Button_Click()
        {          
            Save();                    
        }

        /// <summary>
        /// Close_Button_Click
        /// 사용자 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void Close_Button_Click(object sender, EventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_CLOSE":
                    X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
                    break;

                default:
                    break;
            }
        }

        //열람사유 입력 여부 확인
        public bool IsSaveValid()
        {
            bool result = true;

            if (this.txt01_ACCESS_REASON.IsEmpty)
            {
                result = false;
                this.MsgCodeAlert_ShowFormat("COM-00906", "txt01_ACCESS_REASON", this.lbl01_INPUT_REASON.Text);
            }

            return result;
        }

        //열람 사유 등록 및 pdf 표시
        private void Save()
        {
            if (!this.IsSaveValid()) return;

          
            HEParameterSet set = new HEParameterSet();
            set.Add("DOCNO", this.txt01_DOCNO.Value);
            set.Add("ACCESS_USERID", Util.UserInfo.UserID);
            set.Add("ACCESS_REASON", this.txt01_ACCESS_REASON.Value);

            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_HISTORY"), set);
            }




            string url = "/PDFViewer.aspx?FileID=" + this.txt01_FILEID.Value.ToString();

            X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
            X.Js.Call("parent.fn_PDF", url);

            
        }
    }
}