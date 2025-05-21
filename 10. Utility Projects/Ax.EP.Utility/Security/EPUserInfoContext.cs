using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TheOne.Security;

namespace Ax.EP.Utility.Security
{
    public class EPUserInfoContext : UserInfoContext
    {
        #region "속성 키 이름"
        
        private const string LANG_SET_KEY = "LANG_SET";
        private const string LANG_SET_SHORT_KEY = "LANG_SET_SHORT";
        private const string CORCD_KEY = "CORCD";
        private const string CUSTCD_KEY = "CUSTCD";
        private const string USERID_KEY = "USERID";
        private const string BIZCD_KEY = "BIZCD";
        private const string USERNM_KEY = "USERNM";
        private const string USER_DIV_KEY = "USER_DIV";
        private const string CERT_COURSE_KEY = "CERT_COURSE";
        private const string LINECD_KEY = "LINECD";
        private const string LINENAME_KEY = "LINENAME";
        private const string EMPNO_KEY = "EMPNO";
        private const string CUSTNM_KEY = "CUSTNM";
        private const string COINCD_KEY = "COINCD";
        private const string VENDCD_KEY = "VENDCD";
        private const string VENDNM_KEY = "VENDNM";
        private const string ADMIN_FLAG_KEY = "ADMIN_FLAG";
        private const string PASSWORD_KEY = "PASSWORD";

        public const string AUTHINFO_KEY = "__AUTHINFO";
        #endregion

        public new static EPUserInfoContext Current
        {
            get { return (EPUserInfoContext)UserInfoContext.Current;  }
        }

        #region "속성"

        /// <summary>
        /// Get SYSTEM_CODE
        /// </summary>
        public string SystemCode
        {
            get { return Util.SystemCode; }
        }

        /// <summary>
        /// Gets or sets the Language
        /// </summary>
        /// <value>Language.</value>
        /// <remarks></remarks>
        public string Language
        {
            get { return (base[LANG_SET_KEY] == null ? string.Empty : base[LANG_SET_KEY]); }
            set { base[LANG_SET_KEY] = value; }
        }

        /// <summary>
        /// Gets the Lang_SEt_SHORT.
        /// </summary>
        /// <remarks></remarks>
        public string LanguageShort
        {
            get { return (base[LANG_SET_KEY] == null) ? string.Empty : base[LANG_SET_KEY].Substring(2, 2); }
        }

        /// <summary>
        /// Gets or sets the CorporationCode.
        /// </summary>
        /// <value>The CorporationCode.</value>
        /// <remarks></remarks>
        public string CorporationCode
        {
            get { return (base[CORCD_KEY] == null ? string.Empty : base[CORCD_KEY]); }
            set { base[CORCD_KEY] = value; }
        }
        
        /// <summary>
        /// Gets or sets the CustomerCD.
        /// </summary>
        /// <value>The CustomerCD.</value>
        /// <remarks></remarks>
        public string CustomerCD
        {
            get { return (base[CUSTCD_KEY] == null ? string.Empty : base[CUSTCD_KEY]); }
            set { base[CUSTCD_KEY] = value; }
        }

        /// <summary>
        /// Gets or sets the BusinessCode.
        /// </summary>
        /// <value>The BusinessCode.</value>
        /// <remarks></remarks>
        public string BusinessCode
        {
            get { return (base[BIZCD_KEY] == null ? string.Empty : base[BIZCD_KEY]); }
            set { base[BIZCD_KEY] = value; }
        }
        /// <summary>
        /// Gets or sets the UserName.
        /// </summary>
        /// <value>UserName</value>
        /// <remarks></remarks>
        public string UserName
        {
            get { return (base[USERNM_KEY] == null ? string.Empty : base[USERNM_KEY]); }
            set { base[USERNM_KEY] = value; }
        }
        /// <summary>
        /// Gets or sets the UserDivision
        /// </summary>
        /// <value>The UserDivision.</value>
        /// <remarks></remarks>
        public string UserDivision
        {
            get { return (base[USER_DIV_KEY] == null ? string.Empty : base[USER_DIV_KEY]); }
            set { base[USER_DIV_KEY] = value; }
        }
        /// <summary>
        /// Gets or sets the CertCourse
        /// </summary>
        /// <value>The CertCourse.</value>
        /// <remarks></remarks>
        public string CertCourse
        {
            get { return (base[CERT_COURSE_KEY] == null ? string.Empty : base[CERT_COURSE_KEY]); }
            set { base[CERT_COURSE_KEY] = value; }
        }
        /// <summary>
        /// Gets or sets the DeptID
        /// </summary>
        /// <value>The DeptID.</value>
        /// <remarks></remarks>
        public string DeptID
        {
            get { return (base[LINECD_KEY] == null ? string.Empty : base[LINECD_KEY]); }
            set { base[LINECD_KEY] = value; }
        }

        /// <summary>
        /// Gets or sets the DeptName
        /// </summary>
        /// <value>The DeptID.</value>
        /// <remarks></remarks>
        public string DeptName
        {
            get { return (base[LINENAME_KEY] == null ? string.Empty : base[LINENAME_KEY]); }
            set { base[LINENAME_KEY] = value; }
        }
        /// <summary>
        /// Gets or sets the EMPNO.
        /// </summary>
        /// <value>The EMPNO.</value>
        /// <remarks></remarks>
        public string EmpNo
        {
            get { return (base[EMPNO_KEY] == null ? string.Empty : base[EMPNO_KEY]); }
            set { base[EMPNO_KEY] = value; }
        }
        /// <summary>
        /// Gets or sets the CustomerName
        /// </summary>
        /// <value>The CustomerName.</value>
        /// <remarks></remarks>
        public string CustomerName
        {
            get { return (base[CUSTNM_KEY] == null ? string.Empty : base[CUSTNM_KEY]); }
            set { base[CUSTNM_KEY] = value; }
        }
        /// <summary>
        /// Gets or sets the COI n_ CD.
        /// </summary>
        /// <value>The COI n_ CD.</value>
        /// <remarks></remarks>
        public string Currency
        {
            get { return (base[COINCD_KEY] == null ? string.Empty : base[COINCD_KEY]); }
            set { base[COINCD_KEY] = value; }
        }

        /// <summary>
        /// Password
        /// </summary>
        public string Password
        {
            get { return (base[PASSWORD_KEY] == null ? string.Empty : CryptoHelper.DecryptText(base[PASSWORD_KEY].Replace("!!!EQ!!!", "="))); }
            set { base[PASSWORD_KEY] = (string.IsNullOrEmpty(value) ? null : CryptoHelper.EncryptBase64(value).Replace("=", "!!!EQ!!!")); }
        }

        #endregion

        public EPUserInfoContext(string userId) : base(userId)
        {

        }

        public EPUserInfoContext(string userId, string authData) : base(userId)
        {
            this.InitializeContextData(authData);
        }

        /// <summary>
        /// 사용자의 VenderCD
        /// </summary>
        /// <value>The VenderCD.</value>
        /// <remarks></remarks>
        public string VenderCD
        {
            get { return (base[VENDCD_KEY] == null ? string.Empty : base[VENDCD_KEY]); }
            set { base[VENDCD_KEY] = value; }
        }

        /// <summary>
        /// 사용자의 VenderName
        /// </summary>
        /// <value>The VenderName.</value>
        /// <remarks></remarks>
        public string VenderName
        {
            get { return (base[VENDNM_KEY] == null ? string.Empty : base[VENDNM_KEY]); }
            set { base[VENDNM_KEY] = value; }
        }

        /// <summary>
        /// 관리자 여부
        /// </summary>
        /// <value>The IsAdmin.</value>
        /// <remarks></remarks>
        public string IsAdmin
        {
            get { return (base[ADMIN_FLAG_KEY] == null ? string.Empty : base[ADMIN_FLAG_KEY]); }
            set { base[ADMIN_FLAG_KEY] = value; }
        }

        public bool IsAdminBool
        {
            get { return (IsAdmin.Equals("1") ? true : false); }
            set { IsAdmin = (value ? "1" : "0"); }
        }

        public bool IsVender
        {
            get { return (UserDivision.Equals("T15") ? true : false); }
        }

        public bool IsSecondVender
        {
            get { return (UserDivision.Equals("T16") ? true : false); }
        }

        public bool isCustomer
        {
            get { return (UserDivision.Equals("T11") ? true : false); }
        }
    }
}