using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ax.EP.Utility;
using Ax.EP.Utility.Security;

namespace Ax.EP.WP
{       
    /// <summary>
    /// 예외 페이지
    /// </summary>
    /// <remarks></remarks>
    public partial class ErrorPage : System.Web.UI.Page
    {
        /// <summary>
        /// Handles the Load event of the Page control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Page_Load(object sender, EventArgs e)
        {
            EPUserInfoContext ctx = CreateUserInfoContext();
            string language = (ctx != null? ctx.LanguageShort : "EN");

            System.Exception ex = Server.GetLastError();

            if (ex != null && ex is HttpUnhandledException)
            {
                ex = ex.InnerException;
            }

            if (ex is TheOne.Security.AuthenticationException)
            {
                lblErrorTitle.Text = "User authentication error.";
                lblErrorMessage.Text = "This is an unauthenticated user. Please sign in again.";
            }

            // 404 에러일 경우 
            else if (ex.GetBaseException() is System.IO.FileNotFoundException)
            {
                lblErrorTitle.Text = "Sorry. <BR/>.The page you requested could not be found.<BR/>";
                lblErrorMessage.Text = "Corresponds to the The page find the siryeoneun Web renamed or has been deleted or is currently available you entered <BR/> "+
                                       "page address is correct, please check again, the same problem <BR/> "+
                                       "If you are constantly to the Service Managerplease contact. <BR/>";
            }
            else
            {
                // 예외 에러
                string errorID = Request.QueryString["ErrorID"];
                string errorPage = Request.QueryString["ErrorPage"];

                string stackTrace = String.Empty;
                if (EPAppSection.ToBoolean(EPAppSection.ErrorStackTrace))
                {
                    stackTrace = String.Format("<BR>Deatil Information : {0}", ex.ToString().Replace("\r\n", "<br/>"));
                }

                lblErrorTitle.Text = "PGM : " + errorPage + "<BR/>An error has occurred while processing you request job. <br/>";
                lblErrorMessage.Text = string.Format("EID : {0}<br/>If you are having the same problem continues, please contact the administrator of the service.<br/><br/>"+
                                                     "Error Message : {1}{2}",
                                        errorID, ex.Message, stackTrace);
            }

            Server.ClearError();
        }

        private EPUserInfoContext CreateUserInfoContext()
        {
            try
            {
                // 쿠키 정보를 가지고 사용자 컨텍스트 정보를 추출한다.
                HttpCookie cookie = Request.Cookies[EPUserInfoContext.AUTHINFO_KEY];

                if (cookie == null || string.IsNullOrEmpty(cookie.Value))
                {
                    return null;
                }

                return new EPUserInfoContext("anonymous", cookie.Value);
            }
            catch
            {
                return null;
            }
        }
    }
}