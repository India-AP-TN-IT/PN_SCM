using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.DirectoryServices.AccountManagement;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using Ext.Net;
using Ax.EP.Utility;
using Ax.EP.Utility.Security;
using HE.Framework.Core;
using TheOne.Security;
using TheOne.Configuration;

namespace Ax.EP.WP.Home.EPBase
{
    /// <summary>
    /// HEPS용 로그인 페이지(EPLogin_Heps)
    /// </summary>
    /// <remarks>사용자 로그인시 이용된다.
    /// 사용자가 ACTIVE DIRECTORY값을 받아오면 ...  추가할것</remarks>
    public partial class EPLogin_Heps : BasePage
    {
        public EPLogin_Heps()
        {
            this.RequireAuthentication = false;
            this.RequireAuthority = false;
        }
        /// <summary>
        /// _userId
        /// </summary>
        protected string _userId = string.Empty;

        /// <summary>
        /// Handles the Load event of the Page control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        /// http://~/Home/EPBase/EPLogin_Heps.aspx
        /// http://~/Home/EPBase/EPLogin_Heps.aspx?login_id=110403
        /// 
        protected void Page_Load(object sender, EventArgs e)
        {
            //X.MessageBox.Progress("SRM System Authorize", "SEOYON E-HWA HEPS AUTHORIZING!", "... wait a second! ...").Show();
            X.MessageBox.Notify("SRM System Authorize", "SEOYON E-HWA GROUPWARE AUTHORIZING!").Show();

            if (
                Request["login_id"] == null
                || Request.UrlReferrer == null
                || (
                    Request.UrlReferrer.ToString().ToUpper().IndexOf("HANILEH") < 0 &&
                    Request.UrlReferrer.ToString().ToUpper().IndexOf("SEOYONEH") < 0 &&
                    Request.UrlReferrer.ToString().ToUpper().IndexOf("SEO-YON.COM") < 0
                   )
               )
            {
                X.MessageBox.Notify("SRM System Notice", "Access from wrong path!").Show();
                goNotAuth();
            }
            else
            {
                HiddenLanguage.Text = "T2EN";

                //_userId = "100" + Request["login_id"].ToString().Trim();
                _userId = Request["login_id"].ToString().Trim();
                _userId = _userId.Substring(_userId.Length - 6);
                TextFieldLogin.Text = _userId;
                Login_DataBind();
            }
        }

        /// <summary>
        /// 로그인
        /// </summary>
        /// <remarks># 로그인 시 바인딩 함수
        /// 프로시저 : APG_KOCOMAIN.PRC_LOGIN
        /// 파라메터 : param.Add("VI_USER_ID",  TextFieldLogin.Text);
        /// 파라메터 : param.Add("VI_PASSWORD", TextFieldPassword.Text);
        /// [return] : IS_LOGIN ? Y(성공) : N(실패)
        /// </remarks>
        private void Login_DataBind()
        {
            try
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("USER_ID", TextFieldLogin.Text);
                param.Add("PASSWORD", "");
                param.Add("USER_IP", Util.GetClientIP());
                param.Add("LANG_SET", this.HiddenLanguage.Text);

                DataSet ds = EPClientHelper.ExecuteDataSetTx("APG_EPSERVICE.EXECUTE_LOGIN", param);

                // DB 인증을 성공하였거나 또는 AD 인증을 통과하였을 때
                if (ds.Tables[0].Rows.Count != 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];

                    EPUserInfoContext ctx = new EPUserInfoContext(row["USERID"].ToString());
                    ctx.CorporationCode = row["CORCD"].ToString();
                    ctx.BusinessCode = row["BIZCD"].ToString();
                    ctx.UserName = row["USERNAME"].ToString();
                    ctx.CertCourse = row["CERT_COURSE"].ToString();
                    ctx.UserDivision = row["USER_DIV"].ToString();
                    ctx.IsAdmin = row["ADMIN_FLAG"].ToString();
                    ctx.EmpNo = row["EMPNO"].ToString();
                    ctx.DeptID = row["LINECD"].ToString();
                    ctx.DeptName = row["LINENAME"].ToString();
                    ctx.Language = this.HiddenLanguage.Text;
                    ctx.CustomerCD = row["CUSTCD"].ToString();
                    ctx.CustomerName = row["CUSTNM"].ToString();
                    ctx.VenderCD = row["VENDCD"].ToString();
                    ctx.VenderName = row["VENDNM"].ToString();
                    ctx.Password = CryptoHelper.DecryptText(row["PASSWORD"].ToString());

                    // 사용자 인증 정보 쿠키에 저장
                    string authString = EPUserInfoContext.VersionIndependantSerialize(ctx);
                    HttpCookie cookie = new HttpCookie(EPUserInfoContext.AUTHINFO_KEY, authString);
                    Response.Cookies.Add(cookie);

                    // 현재 로그인 정보를 파일 쿠키에 기록함
                    SetCookie("AX_" + Util.SystemCode + "_CK_USER_ID", ctx.UserID);
                    SetCookie("AX_" + Util.SystemCode + "_CK_LANGUAGE", ctx.Language);

                    try
                    {
                        // Login 로그 기록
                        this.ActionHandle(this.GetMenuID(), "LOGIN");
                    }
                    catch (Exception ex)
                    {
                        ExceptionHandler.ErrorHandle(this, ex);
                    }
                    finally
                    {
                        X.Js.Call("goMain", "Y");
                    }
                }
                else
                {
                    X.MessageBox.Notify("SRM System Notice", "None permmission for SRM System!").Show();
                    goNotAuth();
                }
            }
            catch (Exception e)
            {
                ExceptionHandler.ErrorHandle(this, this.GetMenuID(), e);
                X.MessageBox.Notify("SRM System Error", e.Message).Show();

                goNotAuth();
            }
        }

        /// <summary>
        /// goNotAuth
        /// </summary>
        public void goNotAuth()
        {
            X.Redirect(CommonString.LoginPageUrlStr, "Move to login page, now");
        }

        /// <summary>
        /// 쿠키 세팅
        /// </summary>
        /// <param name="cookieName">쿠키이름</param>
        /// <param name="cookieValue">쿠키 값</param>
        /// <remarks>USER_ID, LANGUAGESET을 설정한다.
        /// 설정된 쿠키는 평생 유효하며, 로그인 페이지 재 진입시에 자동으로 로그인, LANGUAGE에 세팅을 한다.</remarks>
        private void SetCookie(string cookieName, string cookieValue)
        {
            HttpCookie httpCookie = new HttpCookie(cookieName);
            httpCookie.Value = cookieValue;
            Response.Cookies.Add(httpCookie);
            Response.Cookies[cookieName].Expires = DateTime.Now.AddDays(1000000);
        }
    }
}
