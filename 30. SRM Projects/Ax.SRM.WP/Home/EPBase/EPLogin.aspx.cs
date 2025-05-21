using System;
using System.Data;
using System.DirectoryServices.AccountManagement;
using System.Text;
using System.Web;
using Ax.EP.Utility;
using Ax.EP.Utility.Security;
using Ext.Net;
using HE.Framework.Core;
using TheOne.Configuration;
using TheOne.Security;

namespace Ax.EP.WP.Home.EPBase
{
    /// <summary>
    /// 로그인 페이지(EPLogin)
    /// </summary>
    /// <remarks>사용자 로그인시 이용된다.
    /// 사용자가 ACTIVE DIRECTORY값을 받아오면 ...  추가할것</remarks>
    public partial class EPLogin : BasePage
    {
        public EPLogin()
        {
            this.RequireAuthentication = false;
            this.RequireAuthority = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !X.IsAjaxRequest)
            {
                if (!Request.Headers["Accept-Language"].Substring(0, 2).ToUpper().Equals("KO")) this.BIZMGR.Text = "View contact information for lost password";

                lbl_CORPERATION.Text = Ax.EP.Utility.EPAppSection.ToString("COPERATION");
                lbl01_Addr.Text = Ax.EP.Utility.EPAppSection.ToString("COPYRIGHT_" + Ax.EP.Utility.EPAppSection.ToString("COPERATION")).Replace("&nbsp;"," ").Replace("Tel : +82-52-219-5045","");
                LOGO.ImageUrl ="../../images/login/login_logo.png?v=" + Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER");
                // 페이지 기본 셋팅
                InitPage();

                // 로그인전 팝업 공지사항 표시
                ShowPopup_Notice();
            }
        }

        /// <summary>
        /// 로딩시 기본 설정 세팅
        /// </summary>
        /// <remarks>로그인 페이지에서 설정된 쿠키값이 기본 세팅됨.
        /// 1. 처음 로그인 : 쿠키가 없어서 빈값으로 보임.
        /// 2. 로그인 이후 : 설정된 로그인 값이 기본으로 세팅됨.</remarks>
        private void InitPage()
        {
            try
            {
                //Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
               // Response.Cache.SetNoStore();

                if (Request.Browser.Cookies)
                {
                    bool korean = (Request.Headers["Accept-Language"].Substring(0, 2).ToUpper().Equals("KO") ? true : false);

                    Library.setLoginLanguageBox(SelectBoxLanguage, (korean ? "KO" : "EN"), false, false);

                    if (Request.Cookies["AX_" + Util.SystemCode + "_CK_USER_ID"] != null)
                    {
                        TextFieldLogin.Text = Request.Cookies["AX_" + Util.SystemCode + "_CK_USER_ID"].Value;
                        SelectBoxLanguage.SelectedItem.Value = Request.Cookies["AX_" + Util.SystemCode + "_CK_LANGUAGE"].Value;

                        if (this.TextFieldLogin.Text == "")
                            this.TextFieldLogin.Focus();
                        else
                            this.TextFieldPassword.Focus();
                    }
                }
                else
                {
                    Response.Write("Don't use. Because not support cookie of your browser. Solve change the browser.");
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

        /// <summary>
        /// ShowPopup_Notice 공지사항 표시
        /// </summary>
        private void ShowPopup_Notice()
        {
            try
            {
                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EP_XM23001.INQUERY_LOGIN_POPUP", null);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    StringBuilder sbCorcd = new StringBuilder();
                    StringBuilder sbSeq = new StringBuilder();

                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            sbCorcd.Append(ds.Tables[0].Rows[i]["CORCD"].ToString());
                            sbSeq.Append(ds.Tables[0].Rows[i]["NOTICE_SEQ"].ToString());
                        }
                        else
                        {
                            sbCorcd.Append("," + ds.Tables[0].Rows[i]["CORCD"].ToString());
                            sbSeq.Append("," + ds.Tables[0].Rows[i]["NOTICE_SEQ"].ToString());
                        }
                    }

                    X.Js.Call("noticePopup('" + sbSeq.ToString() + "', '" + sbCorcd.ToString() + "', " + PopupHelper.defaultPopupWidth.ToString() + ", " + PopupHelper.defaultPopupHeight.ToString() + ", 10, 200); dummy");
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
        /// 로그인 validation
        /// </summary>
        /// <param name="sender">sender</param>
        /// <param name="e">e</param>
        /// <remarks>아이디와 패스워드는 필수로 입력을 해야한다.</remarks>
        public void Login(object sender, DirectEventArgs e)
        {
            if (!String.IsNullOrEmpty(TextFieldLogin.Text) && !String.IsNullOrEmpty(TextFieldPassword.Text))
            {
                Login_DataBind();
            }
            else
            {
                string message = null;

                string lang = SelectBoxLanguage.SelectedItem.Value.Substring(2, 2).ToUpper();
                if (lang == "") lang = "EN";

                if (String.IsNullOrEmpty(TextFieldLogin.Text))
                    message = Library.getMessage("COM-00501", lang);
                else if (String.IsNullOrEmpty(TextFieldPassword.Text))
                    message = Library.getMessage("COM-00502", lang);

                this.Alert("Login Alert", message);
            }
        }

        /// <summary>
        /// 로그인 처리 Login_DataBind
        /// </summary>
        private void Login_DataBind()
        {
            try
            {
                // 로그인 오류 허용 횟수를 가져온다
                int loginErrorArrowTimes;
                try { loginErrorArrowTimes = int.Parse(Ax.EP.Utility.EPAppSection.ToString("LoginErrorAllowTimes")); } catch { loginErrorArrowTimes = 5; } // 기본값 5회 

                //만약 Active Directory 유저일경우에 Ad쪽 인증을 거치고 인증이 된다면 XD1120 에서 데이터를 가지고 온다.
                string strAdAuth = AdUserAuthorize();

                // 메세지 처리를 위해 기본 언어 가져오기
                string lang = SelectBoxLanguage.SelectedItem.Value.Substring(2, 2).ToUpper();
                if (lang == "") lang = "EN";

                // AD 인증사용자의 경우 AD 인증을 통과하였거나 또는 DB 인증 유저일경우 아래 실행 그외는 실패
                if (strAdAuth.Substring(0, 1).Equals("T"))
                {
                    HEParameterSet param = new HEParameterSet();
                    param.Add("USER_ID", TextFieldLogin.Text);
                    param.Add("PASSWORD", CryptoHelper.EncryptBase64(TextFieldPassword.Text));
                    //param.Add("USER_IP", Request.UserHostAddress.ToString());
                    param.Add("USER_IP", (strAdAuth == "TAD" ? "AD" : Util.GetClientIP()));
                    param.Add("LANG_SET", lang);

                    DataSet ds = EPClientHelper.ExecuteDataSetTx("APG_EPSERVICE.EXECUTE_LOGIN", param);

                    // 패스워드 오류횟수 체크 후 인증로직을 빠져나간다. ( DB 인증 유저만 )
                    if (int.Parse(ds.Tables[0].Rows[0]["PWD_ERR_COUNT"].ToString()) >= loginErrorArrowTimes && strAdAuth == "TDB")
                    {
                        this.Alert("Login Alert", "You can not access the system. Because the wrong password more than " + loginErrorArrowTimes.ToString() + " times.<br> Please ask Administrator.");
                        return;
                    }

                    // DB 인증을 성공하였거나 또는 AD 인증을 통과하였을 때
                    if (ds.Tables[0].Rows[0]["VALID_PASSWD"].ToString().Equals("Y") || strAdAuth == "TAD")
                    {
                        // 패스워드가 일치할때
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
                        ctx.Language = SelectBoxLanguage.SelectedItem.Value;
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

                        ctx.SetCallContext();
                        ctx.SetThreadPrincipal();

                        try
                        {
                            // 오류가 없다면 오류 횟수 초기화
                            HEParameterSet param1 = new HEParameterSet();
                            param1.Add("USER_ID", TextFieldLogin.Text);
                            int result = EPClientHelper.ExecuteNonQuery("APG_EPSERVICE.EXECUTE_PWDERR_CLEAR", param1);

                            // Login 로그 기록
                            this.ActionHandle(this.GetMenuID(), "LOGIN");

                            // 개발자 계정 접속시 다국어 메시지 매핑 정보 저장
                            if (this.UserInfo.UserID.Equals("DEV1"))
                            {
                                Ax.EP.Utility.FindMessageHelper.init(Server.MapPath("/"));
                            }
                        }
                        catch (Exception ex)
                        {
                            ExceptionHandler.ErrorHandle(this, ex);
                        }

                        X.Js.Call("goMain", (strAdAuth == "TAD" ? "Y" : ds.Tables[0].Rows[0]["VALID_PASSWD"].ToString()));
                    }
                    else
                    {
                        // DB 패스워드 인증을 실패하였을 경우 오류횟수를 증가시키고 메세지 표시
                        HEParameterSet param1 = new HEParameterSet();
                        param1.Add("USER_ID", TextFieldLogin.Text);

                        DataSet ds1 = EPClientHelper.ExecuteDataSetTx("APG_EPSERVICE.EXECUTE_PWDERR_LOG", param1);

                        if (int.Parse(ds1.Tables[0].Rows[0]["PWD_ERR_COUNT"].ToString()) >= loginErrorArrowTimes)
                            this.Alert("Login Alert", "You can not access the system. Because the wrong password more than " + loginErrorArrowTimes.ToString() + " times.<br> Please ask Administrator.");
                        else
                        {
                            this.Alert("Login Alert", "Password Error Times : " + ds1.Tables[0].Rows[0]["PWD_ERR_COUNT"].ToString() + " times.<br>If an incorrect password " + loginErrorArrowTimes.ToString() + " times or more, if you can not access the system.");
                            //this.Alert("Login Alert", "Password Error. Please confirm your passwords.");                              
                        }
                    }
                }
                else if (strAdAuth.Equals("NOT")) this.Alert("Login Alert", "Account has been disabled or unregistered account. Please, Check your login ID first.");   // XD1120 테이블에 사용자 아이디 미 존재시
                else if (strAdAuth.Equals("FAD_ID")) this.Alert("Login Alert", "Don't exist User ID in Active Directory. Please ask Administrator.");                   // AD 유저이나 AD 에 아이디가 미존재시
                else if (strAdAuth.Equals("FAD_NO")) this.Alert("Login Alert", "Can not find the login information EmployeeNo. Please ask Administrator.");             // AD 유저이나 AD 에 아이디가 미존재시
                else if (strAdAuth.Equals("FAD_PW")) this.Alert("Login Alert", "Password Error. Please confirm your passwords.");                                       // AD 인증 패스워드 오류시
                else this.Alert("Login Alert", "Unknown Error. Please ask Administrator.");                                                                             // 그외 알수 없는 에러 발생시
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
        /// Ads the user authorize.
        /// </summary>
        /// <returns></returns>
        /// <remarks></remarks>
        private string AdUserAuthorize()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("USER_ID", TextFieldLogin.Text);
            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.GET_ACCOUNT", param);
            if (ds == null || ds.Tables.Count <= 0 || ds.Tables[0].Rows.Count <= 0)
            {
                return "NOT"; // Not Exist Account or Disabled Account.  ( XD1120 )
            }
            else
            {
                /*
                if (ds.Tables[0].Rows[0]["CERT_COURSE"].ToString().Equals("T4A"))
                    return CheckADLogin(ds.Tables[0].Rows[0]["EMPNO"].ToString(), TextFieldPassword.Text);  // AD ( CERT_COURSE = T4A )
                else
                    return "TDB"; // 일반사용자 DB Authoirize Target User
                 */
                return "TDB"; // 신규 SRM은 무조건 DB 인증으로 처리
            }
        }

        /// <summary>
        /// AD 로그인 로직 처리
        /// </summary>
        /// <param name="_userID">The _user ID.</param>
        /// <param name="_passWord">The _pass word.</param>
        /// <returns></returns>
        /// <remarks></remarks>
        private string CheckADLogin(string _userID, string _passWord)
        {
            string bLogin = "TAD";  // AD Authoirize Target User

            if (string.IsNullOrEmpty(_userID)) return "FAD_NO";     // Not EMPNO ( 내부직원이긴 하나 UserId 는 있고 Empno 가 없을 경우 )

            // Activie Directory 로그인
            string addomainName = AppSectionFactory.AppSection["ADDomainName"];
            string adloginid = AppSectionFactory.AppSection["ADLoginID"];
            string adloginpassword = AppSectionFactory.AppSection["ADLoginPassword"];

            // 인증서버 및 디렉토리 사용자 ID 를 설정
            PrincipalContext ldsContext = new PrincipalContext(ContextType.Domain, addomainName, adloginid, adloginpassword);

            // 사용자가 존재하는지를 체크
            UserPrincipal principal = Principal.FindByIdentity(ldsContext, _userID) as UserPrincipal;

            // 사용자가 없는 경우
            if (principal == null)
            {
                // 아이디 존재하지 않는다는 메세지 처리
                bLogin = "FAD_ID";      // AD ID Not Found
            }
            else
            {
                // 패스워드 확인 
                if (!principal.Context.ValidateCredentials(_userID, _passWord))
                {
                    // 패스워드 일치하지 않는다는 메세지 처리
                    bLogin = "FAD_PW";       // AD Wrong Passord
                }
            }

            return bLogin;
        }

        /// <summary>
        /// ChangeLangSet
        /// </summary>
        /// <param name="langSet"></param>
        [DirectMethod]
        public void PopPwd()
        {
            HEParameterSet set = new HEParameterSet();
            Util.UserPopup(this, "EPContact.aspx", set, "Popup", "Actual Manager", 900, 460);            
        }
    }
}
