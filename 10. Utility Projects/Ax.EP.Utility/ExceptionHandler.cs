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
    /// ExceptionHandler
    /// </summary>
    /// /// <remarks>2014.06.30 Edited by KGW</remarks>
    public static class ExceptionHandler
    {
        internal readonly static string BusinessPrefix = "[CODE : 20001] ";
        private readonly static string DbExceptionName = "TheOne.Data.DbException";
        private readonly static string EPExceptionName = typeof(HEException).FullName;

        /// <summary>
        /// OnErrorHandler
        /// </summary>
        /// <param name="page"></param>
        /// <param name="e"></param>
        public static void OnErrorHandler(BasePage page, EventArgs e)
        {
            System.Exception ex = page.Server.GetLastError();

            if (ex.InnerException != null && ex is System.Web.HttpUnhandledException)
                ex = ex.InnerException;

            string errorID = "E" + DateTime.Now.ToString("yyMMddHHmmssff");

            if (X.IsAjaxRequest || page.IsPostBack)
            {
                bool businessException = IsBusinessException(ex);
                // 예외 로그
                if (!businessException) ErrorHandle(page, errorID, ex);

                MessageBoxConfig config = new MessageBoxConfig();
                config.Buttons = MessageBox.Button.OK;
                config.Icon = MessageBox.Icon.ERROR;
                config.HeaderIcon = Icon.Error;
                config.Closable = false;
                config.MaxWidth = 800;
                config.MinWidth = 300;
                config.Title = "Error";
                config.Message = ex.Message.Replace("\r\n", "<br/>").Replace("\n\r", "<br/>").Replace("\r", "<br/>").Replace("\n", "<br/>");

                // 예외의 유형에 따라 메시지 박스에 표시할 내용 결정
                if (!businessException)
                {
                    string stackTrace = String.Format("<br/></br/>{0}", ex.StackTrace.Replace("\r\n", "<br/>").Replace("\n\r", "<br/>").Replace("\r", "<br/>").Replace("\n", "<br/>"));
                    config.Message = String.Format("<b>{0}</b><br/>(Error ID : {1}){2}", config.Message, errorID, stackTrace);
                }

                page.Response.Clear();
                page.Response.Write(JSON.Serialize(new { script = "Ext.Msg.show(" + config.ToScript() + ");" }));
                page.Server.ClearError();
                page.Response.End();
            }
            else
            {
                // 예외 로그
                ErrorHandle(page, errorID, ex);

                // 에러 페이지로 redirect
                page.Server.Transfer(@"/Error/ErrorPage.aspx?errorID=" + errorID + @"&errorPage=" + page.Request.Url.ToString());
            }
        }

        /// <summary>
        /// IsBusinessException  단순 메시지 박스를 표시할 지, 예외 대화상자를 표시할 지 여부
        /// </summary>
        /// <param name="ex"></param>
        /// <returns></returns>
        public static bool IsBusinessException(Exception ex)
        {
            if (ex is HEException)
            {
                return true;
            }

            // WCF 서비스 오류인지 검사
            FaultException<ExceptionDetail> fex = ex as FaultException<ExceptionDetail>;
            if (fex == null)
            {
                return false;
            }

            // C# 코드에서 throw new GDException 으로 예외가 발생한 경우
            if (String.Compare(fex.Detail.Type, EPExceptionName, true) == 0)
            {
                return true;
            }

            // 오라클 프로시저에서 RAISE_APPLICATION_ERROR(-20001, "") 으로 예외가 발생한 경우
            if (String.Compare(fex.Detail.Type, DbExceptionName, true) == 0)
            {
                return fex.Detail.Message.StartsWith(BusinessPrefix, StringComparison.OrdinalIgnoreCase);
            }

            return false;
        }

        /// <summary>
        /// ErrorHandle 에러내용을 처리하는 함수
        /// </summary>
        /// <param name="msg">The MSG.</param>
        /// <remarks></remarks>
        public static void ErrorHandle(BasePage page, string errorHID, Exception ex)
        {
            try
            {
                if (EPAppSection.ToBoolean(EPAppSection.ErrorLogging))
                {
                    string exceptionMessage = ex.Message;
                    string exceptionStack = ex.ToString();
                    string exceptionTarget = ex.TargetSite.ToString();
                    string exceptionCode = ex.TargetSite.GetHashCode().ToString();
                    string system_code = AppSectionFactory.AppSection["SYSTEM_CODE"];

                    try
                    {
                        System.Diagnostics.StackTrace st = new System.Diagnostics.StackTrace(ex);
                        System.Reflection.MethodBase mb = st.GetFrame(st.FrameCount - 1).GetMethod();

                        exceptionTarget = mb.DeclaringType.FullName + "." + mb.Name + "()";

                        // 폴더에 로그 기록
                        string fileFullPath = EPAppSection.ToString("SERVER_TEMP_PATH") + @"\Ax.EP.Utility.ExceptionHandler_" + DateTime.Now.ToString("yyMMdd") + ".log";

                        if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(fileFullPath)))
                            System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(fileFullPath));

                        StreamWriter sw = new StreamWriter(fileFullPath, true);
                        sw.Write(errorHID + " : " + exceptionCode + ":=== EXCEPTION [" + exceptionTarget + "] :: " + exceptionMessage + "\r\n--Detailed Exception Info :\r\n\r\n" + exceptionStack + "\r\n\r\n");
                        sw.Close();
                    }
                    catch
                    {
                        // 예외 File 로그 기록 과정에서 발생하는 예외는 무시한다.
                    }

                    // DB 에 로그 기록
                    HEParameterSet param = new HEParameterSet();
                    param.Add("MENUID", page.GetMenuID());
                    param.Add("SYSTEMCODE", system_code);
                    param.Add("USERID", page.UserInfo.UserID);
                    //param.Add("IP", page.Request.UserHostAddress.ToString());
                    param.Add("IP", Util.GetClientIP());
                    param.Add("EXCEPTIONDATA", errorHID + " : " + exceptionStack);

                    int result = EPClientHelper.ExecuteNonQuery("APG_EPSERVICE.INSERTERRORLOG", param);
                }
            }
            catch
            {
                // 예외 DB 로그 기록 과정에서 발생하는 예외는 무시한다.
            }
        }

        public static void ErrorHandle(BasePage page, Exception ex)
        {
            string errorID = "E" + DateTime.Now.ToString("yyMMddHHmmssff");
            ExceptionHandler.ErrorHandle(page, errorID, ex);
        }

        /// <summary>
        /// ActionHandle 액션로그를 처리하는 함수
        /// </summary>
        /// <param name="msg">The MSG.</param>
        /// <remarks></remarks>
        public static void ActionHandle(BasePage page, string pgmID, string actionName)
        {
            try
            {
                if (EPAppSection.ToBoolean(EPAppSection.ActionLogging))
                {
                    string system_code = AppSectionFactory.AppSection["SYSTEM_CODE"];

                    HEParameterSet param = new HEParameterSet();
                    param.Add("MENUID", pgmID);
                    param.Add("SYSTEMCODE", system_code);
                    param.Add("USERID", page.UserInfo.UserID);
                    //param.Add("IP", page.Request.UserHostAddress.ToString());
                    param.Add("IP", Util.GetClientIP());
                    param.Add("ACTIONNAME", actionName);

                    int result = EPClientHelper.ExecuteNonQuery("APG_EPSERVICE.INSERTACTIONLOG", param);
                }
            }
            catch
            {
                // 예외 로그 기록 과정에서 발생하는 예외는 무시한다.
            }
        }
    }
}
