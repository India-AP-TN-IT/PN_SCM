using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using Ax.EP.Utility;
using Ax.EP.Utility.Security;
using HE.Framework.Core;
using TheOne.Security;
using TheOne.Configuration;

namespace Ax.EP.WP
{
    /// <summary>
    /// Global ....
    /// </summary>
    /// <remarks></remarks>
    public class Global : System.Web.HttpApplication
    {

        /// <summary>
        /// Handles the Start event of the Application control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Application_Start(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// Handles the Start event of the Session control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Session_Start(object sender, EventArgs e)
        {
            if (Request.Url.Host.ToString().Equals("localhost"))
            {
                if (Util.UserInfo != null)
                {
                    EPUserInfoContext.ClearCallContext();
                    EPUserInfoContext.ClearThreadPrincipal();
                    Util.ClearCookieUserInfo();
                }
                EPUserInfoContext ctx = new EPUserInfoContext("DEV1");
                //EPUserInfoContext ctx = new EPUserInfoContext("1000051");
                //EPUserInfoContext ctx = new EPUserInfoContext("1002021");
                ctx.Password = "0000";
                ctx.UserName = "개발자";
                ctx.CorporationCode = "5200";
                ctx.BusinessCode = "5210";
                ctx.DeptID = "H00175";
                ctx.DeptName = "전산팀";
                ctx.EmpNo = "DEV1";        // 서연이화 직원일경우 실제 사번을 그외는 공란
                ctx.UserDivision = "T12";      // T11 : 고객,  T12 : 서연이화,  T15 : 협력업체,   T16: 2차 협력업체
                //ctx.UserDivision = "T15";      // T11 : 고객,  T12 : 서연이화,  T15 : 협력업체,   T16: 2차 협력업체
                ctx.CertCourse = "T4D";
                ctx.CustomerCD = "10006";
                ctx.CustomerName = "";           // 고객일경우 실 고객코드를
                ctx.Currency = "";           // 협력업체일경우 실 업체코드를 
                ctx.VenderCD = "";
                //ctx.VenderName = "(주)신진엔지니어링";
                //100055, (주)대하
                //100010, (주)신진엔지니어링
                ctx.Language = "T2EN";

                // 사용자 인증 정보 쿠키에 저장
                string authString = EPUserInfoContext.VersionIndependantSerialize(ctx);
                HttpCookie cookie = new HttpCookie(EPUserInfoContext.AUTHINFO_KEY, authString);
                Response.Cookies.Add(cookie);
            }
        }

        /// <summary>
        /// Handles the BeginRequest event of the Application control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// Handles the AuthenticateRequest event of the Application control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// Handles the Error event of the Application control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Application_Error(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// Handles the End event of the Session control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Session_End(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// Handles the End event of the Application control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}