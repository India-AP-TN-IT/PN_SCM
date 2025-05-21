using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Ax.EP.Utility;
using HE.Framework.Core;
using TheOne.Security;

namespace Ax.EP.WP.Home.EPBase
{
    /// <summary>
    /// EPPwdChange 패스워드 변경 (패스워드 변경창)
    /// </summary>
    /// <remarks></remarks>
    public partial class EPPwdChange : Ax.EP.Utility.BasePage
    {
        /// <summary>
        /// Handles the Load event of the Page control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["type"].Equals("1"))
            {
                ImageButton2.Hidden = true;
            }

            if (!Util.UserInfo.Language.Equals("T2KO"))
            {
                // 로그인 언어가 한글이 아닐경우
                this.lbl01_EPPwdChange_01.Text = "Password Constraint";
                this.lbl01_EPPwdChange_02.Text = "Combination of alphabetic and symbol char and at least six char";
                this.lbl01_EPPwdChange_03.Text = "Mix of alphabetic and numeric and symbolic";
                this.lbl01_EPPwdChange_04.Text = "Characters such as inability to use more than 4 times";
                this.lbl01_EPPwdChange_05.Text = "Do not use a password that contains the ID None";
            }
        }

        /// <summary>
        /// ChangePaword 패스워드 변경
        /// </summary>
        /// <param name="newPassword"></param>
        [DirectMethod]
        public void ChangePaword(string newPassword)
        {
            // 패스워드 유효기간을 가져온다.
            int pwdChangePeriod;
            try { pwdChangePeriod = int.Parse(Ax.EP.Utility.EPAppSection.ToString("PasswordChangePeriod")); }
            catch { pwdChangePeriod = 90; }

            //패스워드 변경시 로그(axd1520) 등록 2018.10.18
            ActionHandle(this.GetMenuID(), "PWD_CHG");

            HEParameterSet param = new HEParameterSet();

            param.Add("CURRENT", CryptoHelper.EncryptBase64(TextFieldCurrentPW.Text));
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("PASSWORD", CryptoHelper.EncryptBase64(newPassword));
            param.Add("PWDPERIOD", pwdChangePeriod);

            DataSet ds = EPClientHelper.ExecuteDataSetTx("APG_EPSERVICE.EXECUTE_CHANGE_PWD", param);

            if (ds.Tables[0].Rows[0]["OUT_RESULT"].ToString().Equals("0"))
                WarinningMSG("Status", Library.getMessage("COM-00503"));        // 아이디가 없다
            else if (ds.Tables[0].Rows[0]["OUT_RESULT"].ToString().Equals("3")) // 동일 패스워드
                X.Msg.Alert("Status", Library.getMessage("COM-00509")).Show();  // 동일패스워드
            else if (ds.Tables[0].Rows[0]["OUT_RESULT"].ToString().Equals("4")) // 기존 비밀번호와 비교
                X.Msg.Alert("Status", Library.getMessage("COM-00510")).Show();  // 기존과 동일
            else
                WarinningMSG("Status", Library.getMessage("COM-00504"));        // 성공적으로 변경됨
        }

        /// <summary>
        /// 패스워드 validation
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Ext.Net.DirectEventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        
        public void Submit_Password(object sender, DirectEventArgs e)
        {
            X.Js.Call("checkPw", Util.UserInfo.UserID, Util.UserInfo.LanguageShort);
        }

        /// <summary>
        /// alert메시지 공통
        /// </summary>
        /// <param name="msgName">Name of the MSG.</param>
        /// <param name="msgText">The MSG text.</param>
        /// <remarks></remarks>
        private void WarinningMSG(string msgName, string msgText)
        {

            MessageBoxConfig config = new MessageBoxConfig();
            config.Title = msgName;
            config.Message = msgText;
            config.Closable = false;
            config.Icon = MessageBox.Icon.QUESTION;
            config.Buttons = MessageBox.Button.OK;
            config.MessageBoxButtonsConfig = new MessageBoxButtonsConfig
            {
                Yes = new MessageBoxButtonConfig { Handler = "hidePop();", Text = "OK" },
            };
            X.Msg.Show(config);
        }
    }
}