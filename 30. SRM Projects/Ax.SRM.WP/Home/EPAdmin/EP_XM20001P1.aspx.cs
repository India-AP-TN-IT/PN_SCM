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

namespace Ax.EP.WP.Home.EP_XM
{
    /// <summary>
    /// <b>복사 대상 사용자ID 입력 팝업</b>
    /// - 작 성 자 : 이현범<br />
    /// - 작 성 일 : 2014-11-06<br />
    /// </summary>
    public partial class EP_XM20001P1 : BasePage
    {
        /// <summary>
        /// EP_XM20001P1 생성자
        /// </summary>
        public EP_XM20001P1()
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

                    this.txt01_ID.Text = HttpUtility.ParseQueryString(sQuery).Get("ID");
                    this.chk01_XM20001P1_CHK_1.Checked = true;
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
            MakeButton(ButtonID.Confirm, ButtonImage.Confirm, "Confirm", this.ButtonPanel);
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
                case ButtonID.Confirm:
                    Choice();
                    break;
                case "btn01_CLOSE":
                    Choice();
                    X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
                    break;
                default: break;
            }
        }

        /// <summary>
        /// Reset 초기화
        /// </summary>
        public void Reset()
        {
        }

        /// <summary>
        /// Confirm 값 선택
        /// </summary>
        /// <param name="v"></param>
        public void Choice()
        {
            try
            {
                X.Js.Call("parent.fn_XM20001", this.txt01_ID.Text, this.txt01_USERID.Text, this.chk01_XM20001P1_CHK_1.Checked);
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