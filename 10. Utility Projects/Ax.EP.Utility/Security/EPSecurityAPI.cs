using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Security.Principal;

namespace Ax.EP.Utility
{
    /// <summary>
    /// LogonUser API에서 사용하는 로그온 타입
    /// </summary>
    public enum LogonType
    {
        LOGON32_LOGON_INTERACTIVE = 2,
        LOGON32_LOGON_NETWORK = 3,
        LOGON32_LOGON_BATCH = 4,
        LOGON32_LOGON_SERVICE = 5,
        LOGON32_LOGON_UNLOCK = 7,
        LOGON32_LOGON_NETWORK_CLEARTEXT = 8,
        LOGON32_LOGON_NEW_CREDENTIALS = 9
    }

    /// <summary>
    /// LogonUser API에서 사용하는 로그온 프로바이더
    /// </summary>
    public enum LogonProvider
    {
        LOGON32_PROVIDER_DEFAULT = 0,
        LOGON32_PROVIDER_WINNT35 = 1,
        LOGON32_PROVIDER_WINNT40 = 2,
        LOGON32_PROVIDER_WINNT50 = 3
    }

    /// <summary>
    /// WIN32 Security 관련 API 들에 대한 모음
    /// </summary>
    public class EPSecurityAPI
    {
        const int ERROR_INSUFFICIENT_BUFFER = 122;
     
        [DllImport("advapi32.dll", EntryPoint="LogonUser", SetLastError=true)]
        private static extern bool _LogonUser(string lpszUsername, string lpszDomain, string lpszPassword, int dwLogonType, int dwLogonProvider, out int phToken);
 
        /// <summary>
        /// 주어진 사용자 ID로 로그온하여 액세스 토큰을 반환한다.
        /// </summary>
        /// <param name="userName">사용자 ID</param>
        /// <param name="password">암호</param>
        /// <param name="domainName">도메인 이름</param>
        /// <param name="logonType">로그온 종류</param>
        /// <param name="logonProvider">로그온 프로바이더</param>
        /// <returns></returns>
        public static IntPtr LogonUser(string userName, string password, string domainName, LogonType logonType, LogonProvider logonProvider)
        {
            int token = 0;
            bool logonSuccess = _LogonUser(userName, domainName, password, (int)logonType, (int)logonProvider, out token);
 
            if (logonSuccess)
                return new IntPtr(token);
 
            int retval = Marshal.GetLastWin32Error();
            throw new Win32Exception(retval);
        }

        /// <summary>
        /// OpenFileServer   원격지 파일서버에 접근
        /// </summary>
        /// <returns></returns>
        public static WindowsImpersonationContext OpenFileServer()
        {
            // 원격 파일 서버 정보를 가져온다.
            string userId = EPAppSection.ToString("REMOTE_USER");
            string userPwd = EPAppSection.ToString("REMOTE_USER_PASSWD");
            string userDomain = EPAppSection.ToString("REMOTE_DOMAIN");

            IntPtr token = EPSecurityAPI.LogonUser(userId, userPwd, userDomain, LogonType.LOGON32_LOGON_NETWORK_CLEARTEXT, LogonProvider.LOGON32_PROVIDER_DEFAULT);
            WindowsIdentity identity = new WindowsIdentity(token);

            return identity.Impersonate();
        }

    }
}
