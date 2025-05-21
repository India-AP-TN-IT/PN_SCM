using System;
using System.Data;
using System.IO;
using System.Linq;
using System.ServiceModel;
using System.Web;
using System.Web.UI;
using Ext.Net;
using Ax.EP.Utility.Security;
using HE.Framework.Core;
using TheOne.Configuration;

namespace Ax.EP.Utility
{
    /// <summary>
    /// BasePage
    /// </summary>
    /// <remarks>2014.06.30 Edited by KGW</remarks>
    public class BasePage : System.Web.UI.Page
    {
        #region Basic Property

        /// <summary>
        /// RequireAuthentication
        /// </summary>
        protected bool RequireAuthentication
        {
            get;
            set;
        }

        /// <summary>
        /// RequireAuthority 버튼 권한 설정을 담당하는 Property
        /// </summary>
        /// <value><c>true</c> if [enable button setting]; otherwise, <c>false</c>.</value>
        /// <remarks></remarks>
        protected bool RequireAuthority
        {
            get;
            set;
        }

        /// <summary>
        /// AutoVisibleByAuthority Button 컨트롤의 ID를 기준으로 권한에 의해서 Visible 설정을 할 지 여부를 가져오거나 설정합니다.
        /// Button 컨트롤만 적용되며, ID가 권한에 영향을 받는 ID만 적용됩니다.
        /// </summary>
        /// <remarks>
        /// RequrieAuthority 가 true 이어야 적용됩니다.
        /// </remarks>
        protected bool AutoVisibleByAuthority
        {
            get;
            set;
        }

        /// <summary>
        /// EnableLangSetting 언어 설정을 담당하는 Property
        /// </summary>
        /// <value><c>true</c> if [enable lang setting]; otherwise, <c>false</c>.</value>
        /// <remarks></remarks>
        protected bool EnableLangSetting
        {
            get;
            set;
        }

        public bool IsMobilePage
        {
            get;
            set;
        }

        /// <summary>
        /// UserInfo 사용자 인증 정보
        /// </summary>
        public EPUserInfoContext UserInfo
        {
            get { return EPUserInfoContext.Current; }
        }

        /// <summary>
        /// SystemCode 시스템 코드를 가져옵니다.
        /// </summary>
        public string SystemCode
        {
            get { return EPAppSection.ToString("SYSTEM_CODE"); }
        }

        /// <summary>
        /// _securityContext
        /// </summary>
        private EPSecurityContext _securityContext = null;

        /// <summary>
        /// SecurityContext 화면 사용 권한
        /// </summary>
        protected EPSecurityContext SecurityContext
        {
            get { return _securityContext; }
        }

        public string GlobalLocalFormat_Date
        {
            get;
            set;
        }

        public string GlobalLocalFormat_Month
        {
            get;
            set;
        }

        public string GlobalLocalFormat_MonthDate
        {
            get;
            set;
        }

        public string GlobalLocale
        {
            get;
            set;
        }

        //기본버튼 설정
        public static string BaseSearchImage = "";
        public static string BaseRestImage = "";
        public static string BaseSaveImage = "";
        public static string BaseCloseImage = "";
        public static string BaseNewImage = "";
        public static string BaseDeleteImage = "";
        public static string BasePrintImage = "";
        public static string BaseAcceptImage = "";
        public static string BaseRowAddImage = "";
        public static string BaseRowDeleteImage = "";

        #endregion

        #region 생성자 및 초기화
        /// <summary>
        /// 생성자 ="BasePage
        /// </summary>
        /// <remarks></remarks>
        public BasePage()
            : base()
        {
            this.RequireAuthentication = true;
            this.RequireAuthority = true;
            this.AutoVisibleByAuthority = true;
            this.EnableLangSetting = true;
            this.IsMobilePage = false;

            // 인증 정보 초기화 수행
            EPUserInfoContext.ClearCallContext();
            EPUserInfoContext.ClearThreadPrincipal();
        }

        /// <summary>
        /// OnLoad Handles the Load event of the Page control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected override void OnLoad(EventArgs e)
        {
            try
            {
                // Load 작업 전처리
                if (this.RequireAuthority)
                {
                    if (!this.IsPostBack)
                    {
                        // 최초 로드시에는 서비스를 호출하여 권한 개체를 생성한다.
                        _securityContext = CreateSecurityContext();
                        this.ViewState[EPSecurityContext.KEY_NAME] = _securityContext.ACLString;
                    }
                    else
                    {
                        // PostBack인 경우 ViewState에 저장된 정보를 사용하여 권한 개체를 생성한다.
                        string aclString = this.ViewState[EPSecurityContext.KEY_NAME] as string;
                        if (aclString != null)
                        {
                            _securityContext = new EPSecurityContext(aclString);
                        }
                    }
                }

                if (this.UserInfo != null)
                {
                    // 화면에서 파트너(고객사/협력사) 컨트롤 관련 비활성화 처리 ( 업체일경우 )
                    // 단, TextField 에 대해서만 자동 처리.
                    SetPartnerControlAuthority(this.Controls);
                }

                // 화면에서 사용할 버튼 생성
                BuildButtons();

                Ext.Net.Panel btnPanel = this.FindControl("ButtonPanel") as Ext.Net.Panel;

                if (btnPanel != null)
                {
                    // 개발모드일경우 언어셋 변경 기능 부여
                    if (Request.Url.Host.ToString().Equals("localhost"))
                    {
                    
                        Ext.Net.Button btn;
                        btn = new Button("K"); btn.Listeners.Click.Handler = "App.direct.ChangeLangSet(\"T2KO\")"; if(this.UserInfo.Language.Equals("T2KO")) btn.StyleSpec = "background:green;"; btnPanel.Add(btn);
                        btn = new Button("E"); btn.Listeners.Click.Handler = "App.direct.ChangeLangSet(\"T2EN\")"; if(this.UserInfo.Language.Equals("T2EN")) btn.StyleSpec = "background:green;"; btnPanel.Add(btn);
                        //btn = new Button("B"); btn.Listeners.Click.Handler = "App.direct.ChangeLangSet(\"T2PT\")"; if(this.UserInfo.Language.Equals("T2PT")) btn.StyleSpec = "background:green;"; btnPanel.Add(btn);
                        //btn = new Button("C"); btn.Listeners.Click.Handler = "App.direct.ChangeLangSet(\"T2ZH\")"; if(this.UserInfo.Language.Equals("T2ZH")) btn.StyleSpec = "background:green;"; btnPanel.Add(btn);
                        //btn = new Button("S"); btn.Listeners.Click.Handler = "App.direct.ChangeLangSet(\"T2SK\")"; if(this.UserInfo.Language.Equals("T2SK")) btn.StyleSpec = "background:green;"; btnPanel.Add(btn);
                        //btn = new Button("P"); btn.Listeners.Click.Handler = "App.direct.ChangeLangSet(\"T2PL\")"; if(this.UserInfo.Language.Equals("T2PL")) btn.StyleSpec = "background:green;"; btnPanel.Add(btn);
                    };

                    //2015.07.06
                    //ButtonPanel의 width가 20px정도 크게 잡히는 문제있음. 그래서 버튼 오른쪽이 잘리는 현상발생하여 버튼 추가 후 doLayout(); 호출해줌.
                    //btnPanel.DoLayout(); 
                    btnPanel.UpdateLayout(); 
                }

               

                // Load 작업 후처리
                if (!IsPostBack)
                {
                    // 빌어먹을 캐시를 사용하지 않는다.
                    Response.Cache.SetNoStore();
                    Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
                }

                InitializeCulture();

                // Load 작업 후처리
                if (!IsPostBack)
                {
                    if (AutoVisibleByAuthority)
                    {
                        SetButtonAuthority(this.Controls);
                    }

                    if (EnableLangSetting)
                    {
                        LanguageHelper.SettingLangSet(this);
                    }

                    
                    ButtonImageSetting();

                    // 웹페이지 타이틀을 처리한다.
                    try
                    {
                        if (!this.GetMenuID().Equals(CommonString.LOGIN_PAGE_ID.ToUpper()) && !this.GetMenuID().Equals(CommonString.MAIN_PAGE_ID.ToUpper()) && !this.GetMenuName().Equals(""))
                        {
                            this.Title = this.GetMenuName();
                        }

                        if (this.Title.Equals("")) this.Title = this.GetMenuID();
                    }
                    catch
                    {
                        // Title 태그는 없을경우 그냥 무시한다.
                    }
                    finally
                    {
                    }
                }

                // Open 시 로그기록 자동실시
                if (!this.IsPostBack && !X.IsAjaxRequest) this.ActionHandle("OPEN");

                base.OnLoad(e);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {
            }
        }


        #endregion

        #region 버튼 생성 관련

        /// <summary>
        /// ButtonImageSetting 기본버튼 관련 설정
        /// </summary>
        protected void ButtonImageSetting()
        {
            if (Util.UserInfo != null)
            {
                BaseSearchImage = Util.UserInfo.LanguageShort.Equals("KO") ? ButtonImage.korSearch : ButtonImage.Search;
                BaseRestImage = Util.UserInfo.LanguageShort.Equals("KO") ? ButtonImage.korReset : ButtonImage.Reset;
                BaseSaveImage = Util.UserInfo.LanguageShort.Equals("KO") ? ButtonImage.korSave : ButtonImage.Save;
                BaseCloseImage = Util.UserInfo.LanguageShort.Equals("KO") ? ButtonImage.korClose : ButtonImage.Close;
                BaseNewImage = Util.UserInfo.LanguageShort.Equals("KO") ? ButtonImage.korNew : ButtonImage.New;
                BaseDeleteImage = Util.UserInfo.LanguageShort.Equals("KO") ? ButtonImage.korDelete : ButtonImage.Delete;
                BasePrintImage = Util.UserInfo.LanguageShort.Equals("KO") ? ButtonImage.korPrint : ButtonImage.Print;
                BaseAcceptImage = Util.UserInfo.LanguageShort.Equals("KO") ? ButtonImage.korAccept : ButtonImage.Accept;
                BaseRowAddImage = Util.UserInfo.LanguageShort.Equals("KO") ? ButtonImage.korRowAdd : ButtonImage.RowAdd;
                BaseRowDeleteImage = Util.UserInfo.LanguageShort.Equals("KO") ? ButtonImage.korRowDelete : ButtonImage.RowDelete;
            }
        }

        /// <summary>
        /// BuildButtons화면에서 사용할 버튼을 생성합니다.
        /// </summary>
        protected virtual void BuildButtons()
        {
            // 상속받은 페이지에서 구체적인 내용 구현
        }

        /// <summary>
        /// CreateImageButton
        /// </summary>
        /// <param name="id"></param>
        /// <param name="imageUrl"></param>
        /// <param name="alt"></param>
        /// <param name="isUpload"></param>
        /// <returns></returns>
        protected Ext.Net.ImageButton CreateImageButton(string id, string imageUrl, string alt, bool isUpload = false)
        {
            Ext.Net.ImageButton button = new Ext.Net.ImageButton();
            button.ID = id;
            button.ImageUrl = imageUrl;
            button.DisabledImageUrl = imageUrl.Replace(".gif", "_h.gif");
            //button.Cls = "btn";
            //2013년 07월 25일 버튼 클래스 변경
            if (id.Equals(ButtonID.Close))
            {
                button.Cls = "";
            }
            else
            {
                button.Cls = "pr5";
            }

            button.AlternateText = alt;
            if (isUpload) button.DirectEvents.Click.IsUpload = isUpload;

            button.DirectEvents.Click.Event += new ComponentDirectEvent.DirectEventHandler(Internal_Button_Click);

            if (id == ButtonID.Search || id == ButtonID.M_Search)
            {
                button.DirectEvents.Click.EventMask.ShowMask = true;
                button.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                button.DirectEvents.Click.EventMask.CustomTarget = "Grid01";
                button.DirectEvents.Click.EventMask.Msg = "Loading Data...";
            }
            else if (id == ButtonID.Excel || id == ButtonID.ExcelDL)
            {
                button.DirectEvents.Click.IsUpload = true;
            }
            else if (id == ButtonID.Save)
            {
                button.DirectEvents.Click.EventMask.ShowMask = true;
                button.DirectEvents.Click.EventMask.Target = MaskTarget.Page;
                button.DirectEvents.Click.EventMask.CustomTarget = "Grid01";
                button.DirectEvents.Click.EventMask.Msg = "Checking And Saving Data...";
            }
            else if (id == ButtonID.Delete)
            {
                button.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                button.DirectEvents.Click.Confirmation.Title = "Confirm";
                button.DirectEvents.Click.Confirmation.Message = "Do you want delete?";
                //button.DirectEvents.Click.Confirmation.Cancel = "Cancel";
                button.DirectEvents.Click.EventMask.ShowMask = true;
                button.DirectEvents.Click.EventMask.Target = MaskTarget.Page;
                button.DirectEvents.Click.EventMask.CustomTarget = "Grid01";
                button.DirectEvents.Click.EventMask.Msg = "Checking And Deleting Data...";
            }
            else if (id == ButtonID.RowDel || id == ButtonID.RowDel2 || id == ButtonID.RowDel3)
            {
                button.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                button.DirectEvents.Click.Confirmation.Title = "Confirm";
                button.DirectEvents.Click.Confirmation.Message = "Do you want delete?";
                //button.DirectEvents.Click.Confirmation.Cancel = "Cancel";
            }
            else if (id == ButtonID.Cancel)
            {
                button.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                button.DirectEvents.Click.Confirmation.Title = "Confirm";
                button.DirectEvents.Click.Confirmation.Message = "Do you want cancel?";
                //button.DirectEvents.Click.Confirmation.Cancel = "Cancel";
                button.DirectEvents.Click.EventMask.ShowMask = true;
                button.DirectEvents.Click.EventMask.Target = MaskTarget.Page;
                button.DirectEvents.Click.EventMask.CustomTarget = "Grid01";
                button.DirectEvents.Click.EventMask.Msg = "Checking And Canceling Data...";
            }
            else if (id == ButtonID.RowDelete || id == ButtonID.RowDelete2 || id == ButtonID.RowDelete3 || id == ButtonID.RowDelete4 || id == ButtonID.RowDelete5 || id == ButtonID.RowDelete6)
            {
                button.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                button.DirectEvents.Click.Confirmation.Title = "Confirm";
                button.DirectEvents.Click.Confirmation.Message = "Do you want delete to selected row?";
                //button.DirectEvents.Click.Confirmation.Cancel = "Cancel";
            }

            return button;
        }


        /// <summary>
        /// CreateButton
        /// </summary>
        /// <param name="id"></param>
        /// <param name="text"></param>
        /// <param name="isUpload"></param>
        /// <returns></returns>
        protected Ext.Net.Button CreateButton(string id, string text, bool isUpload = false)
        {
            Ext.Net.Button button = new Ext.Net.Button();
            button.ID = id;

            button.Text = text;
            if (isUpload) button.DirectEvents.Click.IsUpload = isUpload;

            button.DirectEvents.Click.Event += new ComponentDirectEvent.DirectEventHandler(Internal_Button_Click);

            button.DirectEvents.Click.EventMask.ShowMask = true;
            button.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
            button.DirectEvents.Click.EventMask.CustomTarget = "Grid01";
            button.DirectEvents.Click.EventMask.Msg = "Executing Data...";
    
            return button;
        }

        /// <summary>
        /// Internal_Button_Click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Internal_Button_Click(object sender, DirectEventArgs e)
        {
            string ActionName = ((Ext.Net.Button)sender).ID.ToUpper().Trim();
            if (ActionName.Substring(0, 4) == "BTN_") ActionName = ActionName.Substring(4);
            if (ActionName.Substring(0, 3) == "BTN") ActionName = ActionName.Substring(3);
            if (ActionName.Substring(0, 6) == "BUTTON") ActionName = ActionName.Substring(6);

            this.ActionHandle(this.GetMenuID(), ActionName);

            Button_Click(sender, e);
        }

        /// <summary>
        /// Button_Click 버튼 클릭 이벤트 핸들러입니다.
        /// </summary>
        /// <param name="sender">이벤트 원본입니다.</param>
        /// <param name="e">이벤트 데이터입니다.</param>
        public virtual void Button_Click(object sender, DirectEventArgs e)
        {
            // 상속받은 페이지에서 구체적인 내용 구현
        }

        #endregion

        #region 사용자 인증 검사

        /// <summary>
        /// OnInit
        /// </summary>
        /// <param name="e"></param>
        protected override void OnInit(EventArgs e)
        {
            Authenticate();
            base.OnInit(e);
        }

        /// <summary>
        /// isMobileDevice
        /// </summary>
        /// <returns></returns>
        public bool isMobileDevice()
        {
            bool result = false;
            string[] mobileKeyWords = { "iPhone", "iPod", "BlackBerry", "Android", "Windows CE", "Windows CE;", "LG", "MOT", "SAMSUNG", "SonyEricsson", "Mobile", "Symbian", "Opera Mobi", "Opera Mini", "IEmobile" };

            foreach (string key in mobileKeyWords)
            {
                if (this.Request.UserAgent.ToUpper().IndexOf(key.ToUpper()) >= 0)
                {
                    result = true;
                    break;
                }
            }

            return result;
        }

        /// <summary>
        /// Authenticate 로그온 되었는가를 검사한다.
        /// </summary>
        protected virtual void Authenticate()
        {
            if (this.DesignMode)
            {
                return;
            }

            EPUserInfoContext userInfo = CreateUserInfoContext();

            // 초기 인증계정 처리용 로그인 페이지 목록 체크
            // 2015.11.02   by  김건우,오세민
            string login_page1 = EPAppSection.ToString("MOBILE_LOGIN_PAGE_ID").ToUpper();
            string login_page2 = EPAppSection.ToString("LOGIN_PAGE_ID").ToUpper();

            // 초기 인증계정 없을시 Login(EPLogin / MLogin) 페이지에서 DB 정보 바인딩을 위해 임시 계정 생성
            // 2015.11.02   by  김건우,오세민
            if (userInfo == null && (this.GetMenuID().Equals(login_page1) || this.GetMenuID().Equals(login_page2)))
            {
                if (Util.UserInfo != null)
                {
                    EPUserInfoContext.ClearCallContext();
                    EPUserInfoContext.ClearThreadPrincipal();
                    Util.ClearCookieUserInfo();
                }
                EPUserInfoContext ctx = new EPUserInfoContext("tempuser");

                // 사용자 인증 정보 쿠키에 저장
                string authString = EPUserInfoContext.VersionIndependantSerialize(ctx);
                HttpCookie cookie = new HttpCookie(EPUserInfoContext.AUTHINFO_KEY, authString);
                Response.Cookies.Add(cookie);

                userInfo = ctx;
            }

            // 임시계정 상태에서 Login(EPLogin / MLogin) 페이지외 다른페이지 접근시 임시 계정 인증처리 해제
            // 2015.11.02   by  김건우,오세민
            if (userInfo != null && userInfo.UserID.Equals("tempuser"))
            {
                if (!this.GetMenuID().Equals(login_page1) && !this.GetMenuID().Equals(login_page2))
                {
                    EPUserInfoContext.ClearCallContext();
                    EPUserInfoContext.ClearThreadPrincipal();
                    Util.ClearCookieUserInfo();

                    userInfo = null;
                }
            }

            if (userInfo != null)
            {
                userInfo.SetCallContext();
                userInfo.SetThreadPrincipal();

                if (EPAppSection.ToBoolean("MOBILE_MODE_USE") && (this.IsMobilePage || this.isMobileDevice()) && this.Request.Url.ToString().ToUpper().IndexOf(CommonString.LOGIN_PAGE_ID.ToUpper() + ".ASPX") >= 0)
                {
                    // Mobile 로그인 페이지로 이동
                    X.Redirect(CommonString.MobileLoginPageUrlStr);
                }
            }
            else if (this.RequireAuthentication)
            {
                //throw new AuthenticationException();
                // 모바일 또는 일반 로그인 페이지로 이동
                if (EPAppSection.ToBoolean("MOBILE_MODE_USE") && (this.IsMobilePage || this.isMobileDevice()))
                    X.Redirect(CommonString.MobileLoginPageUrlStr);
                else
                    X.Redirect(CommonString.LoginPageUrlStr);
            }
            else if (EPAppSection.ToBoolean("MOBILE_MODE_USE") && (this.IsMobilePage || this.isMobileDevice()) && this.Request.Url.ToString().ToUpper().IndexOf(CommonString.LOGIN_PAGE_ID.ToUpper() + ".ASPX") >= 0)
            {
                // 모바일 로그인 페이지로 이동
                X.Redirect(CommonString.MobileLoginPageUrlStr);
            }
        }
        /// <summary>
        /// CreateUserInfoContext
        /// </summary>
        /// <returns></returns>
        protected virtual EPUserInfoContext CreateUserInfoContext()
        {
            // 쿠키 정보를 가지고 사용자 컨텍스트 정보를 추출한다.
            HttpCookie cookie = Request.Cookies[EPUserInfoContext.AUTHINFO_KEY];

            if (cookie == null || string.IsNullOrEmpty(cookie.Value))
            {
                return null;
            }

            return new EPUserInfoContext("anonymous", cookie.Value);
        }
        #endregion

        #region 화면(메뉴) 사용 권한 관련

        /// <summary>
        /// CreateSecurityContext
        /// </summary>
        /// <returns></returns>
        private EPSecurityContext CreateSecurityContext()
        {
            HEParameterSet paramSet = new HEParameterSet();
            paramSet.Add("SYSTEMCODE", Util.SystemCode);
            paramSet.Add("USERID", Util.UserInfo.UserID);
            paramSet.Add("MENUID", this.GetMenuID());

            DataSet dsACL = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.INQUERY_AUTHBYMENU", paramSet);

            int basicAcl = 0;
            int extAcl = 0;

            if (dsACL.Tables.Count > 0 && dsACL.Tables[0].Rows.Count > 0)
            {
                DataRow row = dsACL.Tables[0].Rows[0];

                basicAcl += (ConvertBitToInt(row["BASICACLD"]) << 0);
                basicAcl += (ConvertBitToInt(row["BASICACLU"]) << 1);
                basicAcl += (ConvertBitToInt(row["BASICACLR"]) << 2);
                basicAcl += (ConvertBitToInt(row["BASICACLC"]) << 3);

                string extAclName = "EXTACL{0}";

                for (int i = 1; i < 32; i++)
                {
                    extAcl += (ConvertBitToInt(row[string.Format(extAclName, i)]) << i);
                }
            }

            return new EPSecurityContext(basicAcl, extAcl);
        }

        /// <summary>
        /// ConvertBitToInt
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        private int ConvertBitToInt(object value)
        {
            if (value == DBNull.Value)
            {
                return 0;
            }
            else if (Convert.ToInt32(value) > 0)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// SetPartnerControlAuthority
        /// </summary>
        /// <param name="controls"></param>
        private void SetPartnerControlAuthority(ControlCollection controls)
        {
            // 파트너(고객사/협력사)가 아니라면 처리하지 않는다
            if (!this.UserInfo.UserDivision.Equals("T11") && !this.UserInfo.UserDivision.Equals("T15") && !this.UserInfo.UserDivision.Equals("T16")) return;

            foreach (Control ctrl in controls)
            {
                // 텍스트 필드일경우에 한해서만 처리하도록 한다.
                Ext.Net.TextField txtField = ctrl as Ext.Net.TextField;

                if (txtField != null)
                {
                    string controlID;
                    if (txtField.ID.Length > 6)
                        controlID = txtField.ID.ToUpper().Trim().Substring(6);
                    else
                        controlID = txtField.ID.ToUpper().Trim();

                    if ((this.UserInfo.UserDivision.Equals("T11") && (controlID.Equals("CUSTCD") || controlID.Equals("CUSTNM"))) ||
                        (this.UserInfo.UserDivision.Equals("T15") && (controlID.Equals("VENDCD") || controlID.Equals("VENDNM"))) ||
                        (this.UserInfo.UserDivision.Equals("T16") && (controlID.Equals("VENDCD") || controlID.Equals("VENDNM"))) ||
                        (!this.UserInfo.UserDivision.Equals("T12") && (controlID.Equals("CUSTCD_FIX") || controlID.Equals("CUSTNM_FIX"))))
                    {
                        txtField.TextChanged += new EventHandler(InternalTextField_Change_Event);
                        txtField.DirectEvents.Change.Event += new ComponentDirectEvent.DirectEventHandler(InternalTextField_Change_Event);

                        // 처음 값 처리
                        this.InternalTextField_Change_Event(txtField, null);

                        txtField.ReadOnly = true;
                    }
                }

                // 코드박스 일경우에 한해서만 처리하도록 한다.
                Ax.EP.UI.IEPCodeBox cdxField = ctrl as Ax.EP.UI.IEPCodeBox;

                if (cdxField != null)
                {
                    if ((this.UserInfo.UserDivision.Equals("T11") && cdxField.HelperID.Equals("HELP_CUSTCD")) ||
                        (this.UserInfo.UserDivision.Equals("T15") && cdxField.HelperID.Equals("HELP_VENDCD") || cdxField.HelperID.Equals("HELP_M_VENDCD")) ||
                        (this.UserInfo.UserDivision.Equals("T16") && cdxField.HelperID.Equals("HELP_VENDCD") || cdxField.HelperID.Equals("HELP_M_VENDCD")) ||
                        (!this.UserInfo.UserDivision.Equals("T12") && cdxField.HelperID.Equals("HELP_CUSTCD_FIX")))
                    {
                        cdxField.InnerTextField_TypeCD.RemoteValidation.Clear();
                        cdxField.InnerTextField_TypeCD.TextChanged += new EventHandler(InternalTextField_Change_Event);
                        cdxField.InnerTextField_TypeCD.DirectEvents.Change.Event += new ComponentDirectEvent.DirectEventHandler(InternalTextField_Change_Event);

                        cdxField.InnerTextField_ObjectID.TextChanged += new EventHandler(InternalTextField_Change_Event);
                        cdxField.InnerTextField_ObjectID.DirectEvents.Change.Event += new ComponentDirectEvent.DirectEventHandler(InternalTextField_Change_Event);

                        // 처음 값 처리
                        this.InternalTextField_Change_Event(cdxField, null);

                        cdxField.InnerTextField_TypeCD.ReadOnly = true;
                        cdxField.InnerTextField_TypeNM.ReadOnly = true;
                        cdxField.InnerImageButton_Helper.Enabled = false;
                        cdxField.VisiableHelper = false;
                    }
                }

                if (ctrl.HasControls())
                {
                    SetPartnerControlAuthority(ctrl.Controls);
                }
            }
        }

        /// <summary>
        /// InternalTextField_Change_Event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void InternalTextField_Change_Event(object sender, EventArgs e)
        {
            Ext.Net.TextField txtField = sender as Ext.Net.TextField;

            if (txtField != null)
            {
                string controlID = txtField.ID.ToUpper().Trim().Substring(6);

                if (controlID.Equals("CUSTCD") && this.UserInfo.UserDivision.Equals("T11")) txtField.Value = Util.UserInfo.CustomerCD;
                if (controlID.Equals("CUSTNM") && this.UserInfo.UserDivision.Equals("T11")) txtField.Value = Util.UserInfo.CustomerName;
                if (controlID.Equals("VENDCD") && this.UserInfo.UserDivision.Equals("T15")) txtField.Value = Util.UserInfo.VenderCD;
                if (controlID.Equals("VENDNM") && this.UserInfo.UserDivision.Equals("T15")) txtField.Value = Util.UserInfo.VenderName;
                if (controlID.Equals("VENDCD") && this.UserInfo.UserDivision.Equals("T16")) txtField.Value = Util.UserInfo.VenderCD;
                if (controlID.Equals("VENDNM") && this.UserInfo.UserDivision.Equals("T16")) txtField.Value = Util.UserInfo.VenderName;
                if (controlID.Equals("CUSTCD_FIX") && !this.UserInfo.UserDivision.Equals("T12")) txtField.Value = Util.UserInfo.CustomerCD;
                if (controlID.Equals("CUSTNM_FIX") && !this.UserInfo.UserDivision.Equals("T12")) txtField.Value = Util.UserInfo.CustomerName;
            }


            Ax.EP.UI.IEPCodeBox cdxField = sender as Ax.EP.UI.IEPCodeBox;

            if (cdxField != null)
            {
                if (this.UserInfo.UserDivision.Equals("T11") && cdxField.HelperID.Equals("HELP_CUSTCD"))
                {
                    cdxField.isEditable = true;
                    cdxField.Value = Util.UserInfo.CustomerCD;
                    cdxField.Text = Util.UserInfo.CustomerName;
                    cdxField.isEditable = false;
                }
                if (!this.UserInfo.UserDivision.Equals("T12") && cdxField.HelperID.Equals("HELP_CUSTCD_FIX"))
                {
                    cdxField.isEditable = true;
                    cdxField.Value = Util.UserInfo.CustomerCD;
                    cdxField.Text = Util.UserInfo.CustomerName;
                    cdxField.isEditable = false;
                }
                if (this.UserInfo.UserDivision.Equals("T15") && cdxField.HelperID.Equals("HELP_VENDCD") || cdxField.HelperID.Equals("HELP_M_VENDCD"))
                {
                    cdxField.isEditable = true;
                    cdxField.Value = Util.UserInfo.VenderCD;
                    cdxField.Text = Util.UserInfo.VenderName;
                    cdxField.isEditable = false;
                }
                if (this.UserInfo.UserDivision.Equals("T16") && cdxField.HelperID.Equals("HELP_VENDCD") || cdxField.HelperID.Equals("HELP_M_VENDCD"))
                {
                    cdxField.isEditable = true;
                    cdxField.Value = Util.UserInfo.VenderCD;
                    cdxField.Text = Util.UserInfo.VenderName;
                    cdxField.isEditable = false;
                }
            }
        }

        /// <summary>
        /// SetButtonAuthority
        /// </summary>
        /// <param name="controls"></param>
        private void SetButtonAuthority(ControlCollection controls)
        {
            foreach (Control ctrl in controls)
            {
                Ext.Net.Button button = ctrl as Ext.Net.Button;

                if (button != null)
                {
                    if (Request.Url.Host.ToString().Equals("localhost"))
                    {
                        // localhost 는 모든권한을 가지도록 수정
                        button.Visible = true;
                    }
                    else
                    {
                        // 정상 운영시는 권한 처리
                        button.Visible = CheckAuth(button.ID, button.Visible);
                    }
                }

                if (ctrl.HasControls())
                {
                    SetButtonAuthority(ctrl.Controls);
                }
            }
        }

        /// <summary>
        /// CheckAuth
        /// </summary>
        /// <param name="controlID"></param>
        /// <param name="defaultVisible"></param>
        /// <returns></returns>
        /// <remarks>컨트롤 이름에 따른 권한 검사</remarks>
        private bool CheckAuth(string controlID, bool defaultVisible)
        {
            try
            {
                if (controlID.Contains(ButtonID.Search))
                {
                    return this.SecurityContext.CanSelect;
                }
                else if (controlID.Contains(ButtonID.Save) || controlID.Contains(ButtonID.RowSave) || controlID.Contains(ButtonID.RowAdd) || controlID.Contains(ButtonID.RowDelete))
                {
                    return this.SecurityContext.CanSave;
                }
                else if (controlID.Contains(ButtonID.Delete))
                {
                    return this.SecurityContext.CanDelete;
                }
                else if (controlID.Contains(ButtonID.Reset))
                {
                    return this.SecurityContext.CanReset;
                }
                else if (controlID.Contains(ButtonID.Print) || controlID.Contains(ButtonID.Excel) || controlID.Contains(ButtonID.ExcelDL))
                {
                    return this.SecurityContext.CanPrint;
                }
                else if (controlID.Contains(ButtonID.Down) || controlID.Contains(ButtonID.FileDown))
                {
                    return this.SecurityContext.CanDown;
                }
                else
                {
                    return defaultVisible;
                }
            }
            catch
            {
                return defaultVisible;
            }
        }
        #endregion

        #region BasePage 기본 메서드 ( DirectMethod 및 Page 관련 메소드, 에러제어, 컬쳐처리 )
 
        /// <summary>
        /// OnError Handler
        /// </summary>
        /// <param name="e"></param>
        protected override void OnError(EventArgs e)
        {
            ExceptionHandler.OnErrorHandler(this, e);
        }

        /// <summary>
        /// ActionHandle
        /// </summary>
        /// <param name="actionName"></param>
        [DirectMethod]
        public void ActionHandle(string actionName)
        {
            ExceptionHandler.ActionHandle(this, this.GetMenuID(), actionName);
        }

        /// <summary>
        /// ActionHandle
        /// </summary>
        /// <param name="pgmID"></param>
        /// <param name="actionName"></param>
        [DirectMethod]
        public void ActionHandle(string pgmID, string actionName)
        {
            if (string.IsNullOrEmpty(pgmID)) pgmID = this.GetMenuID();
            ExceptionHandler.ActionHandle(this, pgmID, actionName);
        }

        /// <summary>
        /// ChangeLangSet
        /// </summary>
        /// <param name="langSet"></param>
        [DirectMethod]
        public void ChangeLangSet(string langSet)
        {
            this.UserInfo.Language = langSet;

            // 사용자 인증 쿠키 정보 갱신
            Util.SetCookieUserInfo(this.UserInfo);

            this.UserInfo.SetCallContext();
            this.UserInfo.SetThreadPrincipal();
            X.Redirect(this.Page.Request.Url.PathAndQuery);
        }

        /// <summary>
        /// InitializeCulture
        /// </summary>
        protected override void InitializeCulture()
        {
            if (UserInfo != null)
            {
                string locale = "ko-KR", code = UserInfo.LanguageShort.ToString();

                HEParameterSet param = new HEParameterSet();
                param.Add("CLASS_ID", "T2");
                param.Add("LANG_SET", "KO");
                param.Add("CODE", code);

                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.INQUERY_LANGUAGE_LIST", param); //데이터 베이스 조회

                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    locale = ds.Tables[0].Rows[0]["LOCALE"].ToString();

                this.GlobalLocale = locale;

                if (Ext.Net.ResourceManager.IsSupportedCulture(locale))
                {
                    System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(locale);
                    System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(locale);
                    ResourceManager resourceManager = this.FindControl("ResourceManager1") as ResourceManager;

                    if (resourceManager != null)
                    {
                        resourceManager.Locale = locale;//code; --//2019.03.27 변경 날짜 포맷 변경 

                        string localeDateFormat = resourceManager.CurrentLocale.DateTimeFormat.ShortDatePattern.Replace(" ", "").ToLower().Replace("yyyy", "Y").Replace("yy", "Y").Replace("mm", "m").Replace("dd", "d");

                        //this.RegisterStartupScript("LocaleDateFormat", "<script type=\"text/javascript\">\r\nvar localeDateFormat = \"" + localeDateFormat + "\";\r\n</script>");
                        //is.ClientScript.RegisterStartupScript(this.GetType(), "LocaleDateFormat", "<script type=\"text/javascript\">\r\nExt.Date.defaultFormat = \"" + localeDateFormat + "\";\r\n</script>");
                        // 재정의 날짜 처리-//2019.03.27 변경 날짜 포맷 변경   common.js 도 함께 변경
                        this.ClientScript.RegisterStartupScript(this.GetType(), "LocaleDateFormat", "<script type=\"text/javascript\">\r\nExt.Date.defaultFormat = \"" + localeDateFormat + "\"; Ext.util.Format.defaultDateFormat= \"" + localeDateFormat + "\"; Ext.util.Format.dateFormat= \"" + localeDateFormat + "\"; \r\n</script>");

                        this.GlobalLocalFormat_Date = resourceManager.CurrentLocale.DateTimeFormat.ShortDatePattern.ToLower();
                        this.GlobalLocalFormat_Date = this.GlobalLocalFormat_Date.Replace(" ", "").Replace("dd", "d").Replace("mm", "m").Replace("yyyy", "y").Replace("yy", "y");
                        this.GlobalLocalFormat_Date = this.GlobalLocalFormat_Date.Replace("d", "dd").Replace("m", "MM").Replace("y", "yyyy");
                        this.GlobalLocalFormat_Month = this.GlobalLocalFormat_Date.Replace(".dd", "").Replace("dd.", "").Replace("-dd", "").Replace("dd-", "").Replace("/dd", "").Replace("dd/", "");
                        this.GlobalLocalFormat_MonthDate = this.GlobalLocalFormat_Date.Replace(".yyyy", "").Replace("yyyy.", "").Replace("-yyyy", "").Replace("yyyy-", "").Replace("/yyyy", "").Replace("yyyy/", "");
                    }
                }

                /*
                switch (UserInfo.LanguageShort.ToString())
                {
                    case "KO":
                        System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("ko-KR");
                        System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo("ko-KR");
                        break;
                    case "EN":
                        System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-US");
                        System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo("en-US");
                        break;
                    case "PL":
                        System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("pl-PL");
                        System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo("pl-PL");
                        break;
                    case "ZH":
                        System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("zh-CN");
                        System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo("zh-CN");
                        break;
                }
                */
                base.InitializeCulture();
            }

        }

        /// <summary>
        /// GetCodeMessage
        /// </summary>
        /// <param name="code"></param>
        [DirectMethod]
        public string GetCodeMessage(string code)
        {
            return Library.getMessage(code, UserInfo.LanguageShort);
        }

        /// <summary>
        /// MsgCodeAlert
        /// </summary>
        /// <param name="code"></param>
        [DirectMethod]
        public void MsgCodeAlert(string code)
        {
            Util.CodeMessage(code);
        }

        /// <summary>
        /// MsgCodeAlert ( Focus Support )
        /// </summary>
        /// <param name="code"></param>
        [DirectMethod]
        public void MsgCodeAlert(string code, string focusComponent)
        {
            Util.CodeMessage(code, focusComponent);
        }

        /// <summary>
        /// MsgCodeAlert_ShowFormat
        /// </summary>
        /// <param name="code"></param>
        /// <param name="args"></param>
        public void MsgCodeAlert_ShowFormat(string code, params object[] args)
        {
            Util.CodeMessage_ShowFormat(code, args);
        }

        /// <summary>
        /// MsgCodeAlert_ShowFormat ( Focus Support )
        /// </summary>
        /// <param name="code"></param>
        /// <param name="component"></param>
        /// <param name="args"></param>
        [DirectMethod]
        public void MsgCodeAlert_ShowFormat(string code, string focusComponent, params object[] args)
        {
            Util.CodeMessage_ShowFormat(code, focusComponent, args);
        }

        /// <summary>
        /// Alert
        /// </summary>
        /// <param name="text"></param>
        [DirectMethod]
        public void Alert(string text)
        {
            Util.Alert(text, MessageBox.Icon.INFO);
        }

        /// <summary>
        /// Alert
        /// </summary>
        /// <param name="text"></param>
        /// <param name="msgType"></param>
        [DirectMethod]
        public void Alert(string text, MessageBox.Icon msgType)
        {
            Util.Alert(text, msgType);
        }

        /// <summary>
        /// Alert
        /// </summary>
        /// <param name="title"></param>
        /// <param name="text"></param>
        [DirectMethod]
        public void Alert(string title, string text)
        {
            Util.Alert(title, text, MessageBox.Icon.INFO);
        }

        /// <summary>
        /// Alert
        /// </summary>
        /// <param name="title"></param>
        /// <param name="text"></param>
        /// <param name="msgType"></param>
        [DirectMethod]
        public void Alert(string title, string text, MessageBox.Icon msgType)
        {
            Util.Alert(title, text, msgType);
        }

        /// <summary>
        /// ErrorMessageAlert  에러메세지 전용  Alert
        /// </summary>
        /// <param name="page"></param>
        /// <param name="ex"></param>
        [DirectMethod]
        public void ErrorMessageAlert(BasePage page, Exception ex)
        {
            if (ex.InnerException != null && ex is System.Web.HttpUnhandledException)
                ex = ex.InnerException;

            if (!ExceptionHandler.IsBusinessException(ex)) 
            {
                // 일반 오류 메세지
                ExceptionHandler.ErrorHandle(page, ex);
                this.Alert("Error", "eventSource : " + ex.Source + "<br/>eventType : " + ex.GetType() + "<br/>eventMessage : " + ex.Message +
                                    "<br/>eventTarget : " + ex.TargetSite + "<br/><br/>" + ex.StackTrace, MessageBox.Icon.ERROR);
            }
            else
            {
                // 패키지에서 개발자가 직접 던전 에러 메세지 ( -20001 만 해당 )
                string msg = ex.Message;
                string oraMsg = "ORA-20001: ";

                msg = msg.Substring(msg.IndexOf(oraMsg) + oraMsg.Length);
                //msg = msg.Substring(0, msg.IndexOf("ORA"));

                this.Alert("Warning", msg, MessageBox.Icon.WARNING);
            }

        }
        
        /// <summary>
        /// FileDownLoadByPath
        /// </summary>
        /// <param name="path"></param>
        [DirectMethod]
        public void FileDownLoadByPath(string path)
        {
            Util.FileDownLoadByPath(this, path);
        }

        /// <summary>
        /// FileDownLoadByFileID
        /// </summary>
        /// <param name="fileID"></param>
        [DirectMethod]
        public void FileDownLoadByFileID(string fileID)
        {
            Util.FileDownLoadByFileID(this, fileID);
        }

        /// <summary>
        /// GetClientIP
        /// </summary>
        [DirectMethod]
        public string GetClientIP()
        {
            return Util.GetClientIP();
        }

        /// <summary>
        /// GetMenuID
        /// </summary>
        /// <returns></returns>
        [DirectMethod]
        public string GetMenuID()
        {
            return Util.GetMenuID(this);
        }

        /// <summary>
        /// GetMenuName
        /// </summary>
        /// <returns></returns>
        [DirectMethod]
        public string GetMenuName()
        {
            return Util.GetMenuName(Util.GetMenuID(this));
        }

        /// <summary>
        /// GetMenuID_Name
        /// </summary>
        /// <returns></returns>
        [DirectMethod]
        public string GetMenuID_Name()
        {
            return "[" + Util.GetMenuID(this) + "] " + Util.GetMenuName(Util.GetMenuID(this));
        }

        /// <summary>
        /// GetMenuUrl
        /// </summary>
        /// <returns></returns>
        [DirectMethod]
        public string GetMenuUrl(string id)
        {
            return Util.GetMenuUrl(id); 
        }

        /// <summary>
        /// GetMenuName2
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [DirectMethod]
        public string GetMenuName2(string id)
        {
            return Util.GetMenuName(id);
        }

        /// <summary>
        /// 로그아웃
        /// </summary>
        /// <remarks>#프로시저   : APG_KOCOMAIN.PRC_LOGOUT (WCFClient.ExecuteQuery)
        /// 파라메터    : param.Add("USER_ID", this.UserInfo.USER_ID);
        /// 파라메터    : //param.Add("USER_IP", Request.UserHostAddress.ToString());
        /// 파라메터    : //param.Add("USER_IP", Util.GetClientIP());
        /// #세션 삭제
        /// 모든 세션을 없앰 [USER_ID],[LANG_SET],[CORCD],[BIZCD],[FLAG_SET],[Table]</remarks>
        [DirectMethod]
        public void Logout()
        {
            this.ActionHandle(this.GetMenuID(), "LOGOUT");
            EPUserInfoContext.ClearCallContext();
            EPUserInfoContext.ClearThreadPrincipal();
            Util.ClearCookieUserInfo();
            X.Redirect(CommonString.LoginPageUrlStr);
        }

        [DirectMethod]
        public void LogoutCheck(string message)
        {
            X.Msg.Confirm("Question", message.Trim(), new MessageBoxButtonsConfig
            {
                Yes = new MessageBoxButtonConfig { Handler = "App.direct.Logout()", Text = "Ok" },
                No = new MessageBoxButtonConfig { Text = "Cancel" }
            }).Show();
        }

        /// <summary>
        /// 홈
        /// </summary>
        [DirectMethod]
        public void Home()
        {
            this.ActionHandle(this.GetMenuID(), "HOME");
            X.Redirect(CommonString.MobileMainPageUrlStr);
        }
        #endregion


                /// <summary>
        /// DateField 컨트롤의 value값이 0001-01-01인 경우,  rawText 값을 반환.(현재 로그인한 언어의 날짜타입에 맞춰서)
        /// </summary>
        /// <param name="page"></param>
        /// <param name="df"></param>
        /// <returns></returns>
        public string GetDateText(DateField df)
        {
            try
            {
                string format = df.Format;

                if (format == this.GlobalLocalFormat_Date)
                    return GetDateText(df, "yyyy-MM-dd"); //년-월-일 
                else if (format == this.GlobalLocalFormat_Month)
                    return GetDateText(df, "yyyy-MM");    //년-월
                else if (format == this.GlobalLocalFormat_MonthDate)
                    return GetDateText(df, "MM-dd");      //월-일
                else
                    return GetDateText(df, "yyyy-MM-dd"); //년-월-일 

                //DateTime dt = (DateTime)df.Value;
                //string dfValue = dt.ToString("yyyy-MM-dd");
                //string format = df.Format;

                //if (dfValue == "0001-01-01" || df.IsEmpty)
                //{
                //    //datefield의 value값이 제대로 넘어오지 않은 경우. rawText로부터 값 읽어온다.
                //    dt = DateTime.ParseExact(df.RawText, format, null);                    
                //}

                //if (format == page.GlobalLocalFormat_Date)
                //    return dt.ToString("yyyy-MM-dd");
                //else if (format == page.GlobalLocalFormat_Month)
                //    return dt.ToString("yyyy-MM");
                //else if (format == page.GlobalLocalFormat_MonthDate)
                //    return dt.ToString("MM-dd");
                //else
                //    return dt.ToString("yyyy-MM-dd");


            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        /// <summary>
        ///  DateField 컨트롤의 value값이 0001-01-01인 경우,  rawText 값을 반환.(toFormat에 맞춰서)
        /// </summary>
        /// <param name="df"></param>
        /// <param name="toFormat"></param>
        /// <returns></returns>
        public string GetDateText(DateField df, string toFormat)
        {
            try
            {
                DateTime dt = (DateTime)df.Value;
                string dfValue = dt.ToString("yyyy-MM-dd");
                string format = df.Format;

                if (dfValue == "0001-01-01" || df.IsEmpty)
                {
                    //datefield의 value값이 제대로 넘어오지 않은 경우. rawText로부터 값 읽어온다.
                    dt = DateTime.ParseExact(df.RawText, format, null);
                }

                return dt.ToString(toFormat);

            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// DateField 컨트롤의 value값이 0001-01-01인 경우 rawText 값을 datetime으로 변환하여 object타입으로 반환.
        /// </summary>
        /// <param name="df"></param>
        /// <returns></returns>
        public object GetDateValue(DateField df)
        {
            try
            {
                DateTime dt = (DateTime)df.Value;
                string dfValue = dt.ToString("yyyy-MM-dd");
                string format = df.Format;

                if (dfValue == "0001-01-01" || df.IsEmpty)
                {
                    //datefield의 value값이 제대로 넘어오지 않은 경우. rawText로부터 값 읽어온다.
                    dt = DateTime.ParseExact(df.RawText, format, null);
                }

                return dt;


            }
            catch (Exception ex)
            {
                return new DateTime(1, 1, 1);
            }
        }
    }
}
