using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Ax.EP.Utility;
using System.Data;
using System.Collections;
using System.Text;

namespace Ax.EP.WP.Home.EPBase
{
    /// <summary>
    /// EPPwdExpire 패스워드 만료알림
    /// </summary>
    public partial class EPPwdExpire : BasePage
    {
        /// <summary>
        /// Pwd_Date
        /// </summary>
        public string Pwd_Date;
        /// <summary>
        /// Rest_Date
        /// </summary>
        public string REST_DATE;

        public string LANG_SET;

        public string PWDCHANGEPERIOD;

        /// <summary>
        /// Page_Load
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            // 패스워드 유효기간을 가져온다.
            int pwdChangePeriod;
            try { pwdChangePeriod = int.Parse(Ax.EP.Utility.EPAppSection.ToString("PasswordChangePeriod")); }
            catch { pwdChangePeriod = 90; }

            PWDCHANGEPERIOD = pwdChangePeriod.ToString();
    
            Pwd_Date = DateTime.Parse(Request["Pwd_Date"]).ToString(this.GlobalLocalFormat_Date);   
            REST_DATE = Request["REST_DATE"];
            LANG_SET = Util.UserInfo.Language;
        }
    }
}