using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using Ext.Net;
using Ax.EP.Utility.Security;
using HE.Framework.Core;
using TheOne.Configuration;

namespace Ax.EP.Utility
{
    /// <summary>
    /// Util
    /// </summary>
    /// <remarks>2014.07.01 Edited by KGW</remarks>
    public static class Util
    {
        #region 전역 속성

        /// <summary>
        ///  SYSTEM_CODE 시스템 코드를 가져옵니다.
        /// </summary>
        public static string SystemCode
        {
            get { return AppSectionFactory.AppSection["SYSTEM_CODE"]; }
        }

        #endregion

        #region 세션관련 유틸리티
        /// <summary>
        /// UserInfo 사용자 인증 정보
        /// </summary>
        public static EPUserInfoContext UserInfo
        {
            get { return EPUserInfoContext.Current; }
        }

        /// <summary>
        /// SetCookieUserInfo 사용자 인증정보 셋팅
        /// </summary>
        /// <param name="ctx"></param>
        public static void SetCookieUserInfo(EPUserInfoContext ctx)
        {
            string authString = EPUserInfoContext.VersionIndependantSerialize(ctx);
            HttpCookie cookie = new HttpCookie(EPUserInfoContext.AUTHINFO_KEY, authString);
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        /// <summary>
        /// ClearCookieUserInfo 사용자 인증정보 삭제
        /// </summary>
        public static void ClearCookieUserInfo()
        {
            HttpContext.Current.Response.Cookies.Remove(EPUserInfoContext.AUTHINFO_KEY);

            HttpCookie cookie = new HttpCookie(EPUserInfoContext.AUTHINFO_KEY, "");
            cookie.Expires = new DateTime(0x7cf, 10, 12);
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        /// <summary>
        /// GetSession Gets the session.
        /// </summary>
        /// <param name="keys">The keys.</param>
        /// <returns></returns>
        /// <remarks></remarks>
        public static Dictionary<string, string> GetSession(string[] keys)
        {
            Dictionary<string, string> session = new Dictionary<string, string>();
            for (int i = 0; i < keys.Length; i++)
            {
                session.Add(keys[i], EPUserInfoContext.Current[keys[i]].ToString());
            }
            return session;
        }

        /// <summary>
        /// SetSession Sets the session.
        /// </summary>
        /// <param name="key">The key.</param>
        /// <param name="value">The value.</param>
        /// <remarks></remarks>
        public static void SetSession(string key, string value)
        {
            EPUserInfoContext.Current[key] = value;
        }

        /// <summary>
        /// SetSession Sets the session.
        /// </summary>
        /// <param name="session">The session.</param>
        /// <remarks></remarks>
        public static void SetSession(Dictionary<string, string> session)
        {
            foreach (KeyValuePair<string, string> item in session)
            {
                EPUserInfoContext.Current[item.Key] = item.Value;
            }
        }
        #endregion

        #region 사용자 메시지 상자 유틸리티

        /// <summary>
        /// CodeMessage
        /// </summary>
        /// <param name="code"></param>
        public static void CodeMessage(string code)
        {
            Util.CodeMessage(code, "");
        }

        /// <summary>
        /// CodeMessage_ShowFormat
        /// </summary>
        /// <param name="code"></param>
        /// <param name="focusComponent"></param>
        /// <param name="args"></param>
        public static string CodeMessage02(string menuid, string code, params object[] args)
        {
            string result = Library.getLabel(menuid, code);
            result = string.Format(result, args);

            return result;
        }

        /// <summary>
        /// CodeMessage
        /// </summary>
        /// <param name="code"></param>
        /// <param name="focusComponent"></param>
        public static void CodeMessage(string code, string focusComponent)
        {
            // Cdx 컨트롤에 _TYPECD 를 안붙일경우 강제 붙임 처리
            if (focusComponent.ToUpper().StartsWith("CDX") && !focusComponent.ToUpper().EndsWith("_TYPECD"))
                focusComponent += "_TYPECD";

            string handler = "App." + focusComponent + ".focus();";
            string[] result = Library.getMessageWithTitle(code);

            if (focusComponent == "")
                Util.Alert(result);
            else
                Util.Alert(result, handler);
        }

        /// <summary>
        /// CodeMessage_ShowFormat
        /// </summary>
        /// <param name="code"></param>
        /// <param name="args"></param>
        public static void CodeMessage_ShowFormat(string code, params object[] args)
        {
            Util.CodeMessage_ShowFormat(code, "", args);
        }

        /// <summary>
        /// CodeMessage_ShowFormat
        /// </summary>
        /// <param name="code"></param>
        /// <param name="focusComponent"></param>
        /// <param name="args"></param>
        public static void CodeMessage_ShowFormat(string code, string focusComponent, params object[] args)
        {
            // Cdx 컨트롤에 _TYPECD 를 안붙일경우 강제 붙임 처리
            if (focusComponent.ToUpper().StartsWith("CDX") && !focusComponent.ToUpper().EndsWith("_TYPECD"))
                focusComponent += "_TYPECD";

            string handler = "App." + focusComponent + ".focus();";
            string[] result = Library.getMessageWithTitle(code);
            result[1] = string.Format(result[1], args);

            if (focusComponent == "")
                Util.Alert(result);
            else
                Util.Alert(result, handler);
        }

        /// <summary>
        /// Alert
        /// </summary>
        /// <param name="msg"></param>
        public static void Alert(string msg)
        {
            Util.Alert(new string[] { "Alert", msg }, MessageBox.Icon.INFO);
        }

        /// <summary>
        /// Alert
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="msgType"></param>
        public static void Alert(string msg, MessageBox.Icon msgType)
        {
            Util.Alert(new string[] { "Alert", msg }, msgType);
        }

        /// <summary>
        /// Alert
        /// </summary>
        /// <param name="title"></param>
        /// <param name="msg"></param>
        public static void Alert(string title, string msg)
        {
            Util.Alert(new string[] { title, msg }, MessageBox.Icon.INFO);
        }

        /// <summary>
        /// Alert
        /// </summary>
        /// <param name="title"></param>
        /// <param name="msg"></param>
        /// <param name="msgType"></param>
        public static void Alert(string title, string msg, MessageBox.Icon msgType)
        {
            Util.Alert(new string[] { title, msg }, msgType);
        }

        /// <summary>
        /// Alert
        /// </summary>
        /// <param name="msg"></param>
        public static void Alert(string[] msg)
        {
            Util.Alert(msg, "", MessageBox.Icon.INFO);
        }


       /// <summary>
       /// Alert
       /// </summary>
       /// <param name="msg"></param>
       /// <param name="msgType"></param>
        public static void Alert(string[] msg, MessageBox.Icon msgType)
        {
            Util.Alert(msg, "", msgType);
        }

        /// <summary>
        /// Alert with focus
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="handler"></param>
        private static void Alert(string[] msg, string handler)
        {
            Util.Alert(msg, handler, MessageBox.Icon.INFO);
        }

        /// <summary>
        /// Alert with focus
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="handler"></param>
        /// <param name="msgType"></param>
        private static void Alert(string[] msg, string handler, MessageBox.Icon msgType)
        {
            string title = msg[0];
            string message = msg[1].Replace("\r\n", "<br/>").Replace("\n\r", "<br/>").Replace("\r", "<br/>").Replace("\n", "<br/>");

            if (msgType != MessageBox.Icon.ERROR)
            {
                // 일반 메세지
                X.Msg.Show(new MessageBoxConfig
                {
                    Title = title,
                    Message = message,
                    Buttons = MessageBox.Button.OK,
                    Icon = msgType,
                    Closable = true,
                    Handler = handler
                });
            }
            else
            {
                // 오류났을때 메세지
                X.Msg.Info(new InfoPanel
                {
                    UI = Ext.Net.UI.Info,
                    Title = msg[0],
                    Html = msg[1],
                    Icon = Icon.Error,
                    HideDelay = 2000,
                    MaxHeight = 800,
                    MaxWidth = 600,
                    ShowPin = true,
                    OverflowY = Overflow.Auto,
                    Pinned = true,
                    Alignment = AnchorPoint.Center,
                    Closable = true,
                    Buttons = { (new Ext.Net.Button("Close", "this.up('infopanel').destroy();")) }
                }).Show();
            }
        }

        #endregion

        #region 네트워크 유틸리티
        /// <summary>
        /// GetClientIP 사용자의 IP(IPv4)를 문자열로 리턴한다.
        /// </summary>
        public static string GetClientIP()
        {
            //IPHostEntry host = Dns.GetHostEntry(Dns.GetHostName());
            //string ipAddr = string.Empty;


            //for (int k = 0; k < host.AddressList.Length; k++)
            //{
            //    if (host.AddressList[k].AddressFamily == AddressFamily.InterNetwork)
            //    {
            //        ipAddr = host.AddressList[k].ToString();
            //        break;
            //    }
            //}

            //return ipAddr;
            return HttpContext.Current.Request.UserHostAddress.ToString();
        }
        #endregion

        #region DataSet 생성 ( String Parameter 이용 )
        /// <summary>
        /// GetDataSourceSchema 파라메터셋으로 부터 데이터셋을 반환
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>DataSet</returns>
        public static DataSet GetDataSourceSchema(params string[] parameters)
        {
            DataTable source = new DataTable();
            for (int i = 0; i < parameters.Length; i++)
            {
                //source.Columns.Add(parameters[i], typeof(object));
                if (parameters[i].IndexOf("$") > -1)
                {
                    string[] temp = parameters[i].Split('$');
                    if (temp[0].Equals("CLOB"))
                    {
                        source.Columns.Add(parameters[i]);
                    }
                    else
                    {
                        source.Columns.Add("$" + temp[1]);

                        switch (temp[0].ToUpper())
                        {
                            case "BLOB":
                                source.Columns[source.Columns.Count - 1].DataType = typeof(byte[]);
                                break;
                        }
                    }
                }
                else
                    source.Columns.Add(parameters[i], typeof(object));
            }

            
            DataSet set = new DataSet();
            set.Tables.Add(source);

            return set;
        }
        #endregion

        #region 파일 다운로드 유틸리티 (물리적인 경로 및 원격지 파일 ID)
        /// <summary>
        /// FileDownLoadByPath
        /// </summary>
        /// <param name="path">The path.</param>
        /// <remarks></remarks>
        public static void FileDownLoadByPath(System.Web.UI.Page page, string path)
        {
            if (File.Exists(path))
            {
                FileStream fs = null;
                FileInfo finfo = null;

                try
                {
                    finfo = new FileInfo(path);
                    string filename = finfo.Name;
                    fs = File.OpenRead(path);
                    byte[] bytes = new byte[fs.Length];

                    fs.Read(bytes, 0, bytes.Length);
                    page.Response.Clear();
                    page.Response.ContentType = "application/vnd.ms-excel"; // "Application/Octet-Stream"
                    page.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + page.Server.UrlPathEncode(filename) + "\"");
                    page.Response.AddHeader("Content-Length", finfo.Length.ToString());
                    page.Response.OutputStream.Write(bytes, 0, bytes.Length);
                    page.Response.Flush();
                }
                finally
                {
                    if (finfo != null)
                        finfo = null;
                    if (fs != null)
                    {
                        fs.Close();
                        fs.Dispose();
                        fs = null;
                    }
                }
            }
        }

        /// <summary>
        /// FileDownLoadByFileID
        /// </summary>
        /// <param name="path">The path.</param>
        /// <remarks></remarks>
        public static void FileDownLoadByFileID(System.Web.UI.Page page, string fileID)
        {
            EPRemoteFileInfo fileInfo = EPRemoteFileHandler.FileDownload(fileID);

            if (fileInfo.FileContent.Length >= 0)
            {
                page.Response.Clear();
                page.Response.ContentType = "application/vnd.ms-excel"; // "Application/Octet-Stream"
                page.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + page.Server.UrlPathEncode(fileInfo.DBFileName) + "\"");
                page.Response.AddHeader("Content-Length", fileInfo.FileContent.Length.ToString());
                page.Response.OutputStream.Write(fileInfo.FileContent, 0, fileInfo.FileContent.Length);
                page.Response.Flush();
            }
        }

        //public static string FileNameEncode(

        /// <summary>
        /// FileImageByFileID
        /// </summary>
        /// <param name="path">The path.</param>
        /// <remarks></remarks>
        public static void FileImageByFileID(System.Web.UI.Page page, string fileID)
        {
            EPRemoteFileInfo fileInfo = EPRemoteFileHandler.FileDownload(fileID);

            if (fileInfo.FileContent.Length > 0)
            {
                page.Response.Clear();
                page.Response.ContentType = "image/jpeg"; // "Application/Octet-Stream"
                page.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + page.Server.UrlPathEncode(fileInfo.DBFileName) + "\"");
                page.Response.AddHeader("Content-Length", fileInfo.FileContent.Length.ToString());
                page.Response.OutputStream.Write(fileInfo.FileContent, 0, fileInfo.FileContent.Length);
                page.Response.Flush();
            }
            else
            {
                page.Response.Clear();
                page.Response.ContentType = "image/gif"; // "Application/Octet-Stream"
                page.Response.AddHeader("Content-Disposition", "attachment; filename=\"noimage.gif\"");
                page.Response.WriteFile(page.Server.MapPath("/images/etc/no_image.gif"));
                page.Response.Flush();
            }
        }

        /// <summary>
        /// FileEncoding  ( bytes 를 Base64Encoding 처리 )
        /// </summary>
        /// <param name="_src"></param>
        /// <param name="isImage"></param>
        /// <returns></returns>
        public static string FileEncoding(byte[] _src, bool isImage = false)
        {
            string returnStr = Convert.ToBase64String(_src, Base64FormattingOptions.None);

            return (isImage ? "data:image/png;base64," : "") + returnStr;
        }
        #endregion

        #region 수치 유효성검사 관련 유틸리티
        /// <summary>
        /// IsInteger Determines whether the specified STR number is integer.
        /// </summary>
        /// <param name="strNumber">The STR number.</param>
        /// <returns><c>true</c> if the specified STR number is integer; otherwise, <c>false</c>.</returns>
        /// <remarks></remarks>
        public static bool IsInteger(String strNumber)
        {
            Regex objNotIntPattern = new Regex("[^0-9-]");
            Regex objIntPattern = new Regex("^-[0-9]+$|^[0-9]+$");
            return !objNotIntPattern.IsMatch(strNumber) && objIntPattern.IsMatch(strNumber);
        }

        // Function to test whether the string is valid number or not
        /// <summary>
        /// IsNumber Determines whether the specified STR number is number.
        /// </summary>
        /// <param name="strNumber">The STR number.</param>
        /// <returns><c>true</c> if the specified STR number is number; otherwise, <c>false</c>.</returns>
        /// <remarks></remarks>
        public static bool IsNumber(String strNumber)
        {
            Regex objNotNumberPattern = new Regex("[^0-9.-]");
            Regex objTwoDotPattern = new Regex("[0-9]*[.][0-9]*[.][0-9]*");
            Regex objTwoMinusPattern = new Regex("[0-9]*[-][0-9]*[-][0-9]*");
            String strValidRealPattern = "^([-]|[.]|[-.]|[0-9])[0-9]*[.]*[0-9]+$";
            String strValidIntegerPattern = "^([-]|[0-9])[0-9]*$";
            Regex objNumberPattern = new Regex("(" + strValidRealPattern + ")|(" + strValidIntegerPattern + ")");
            return !objNotNumberPattern.IsMatch(strNumber) &&
            !objTwoDotPattern.IsMatch(strNumber) &&
            !objTwoMinusPattern.IsMatch(strNumber) &&
            objNumberPattern.IsMatch(strNumber);
        }

        // Function To test for Alphabets. 
        /// <summary>
        /// IsAlpha Determines whether the specified STR to check is alpha.
        /// </summary>
        /// <param name="strToCheck">The STR to check.</param>
        /// <returns><c>true</c> if the specified STR to check is alpha; otherwise, <c>false</c>.</returns>
        /// <remarks></remarks>
        public static bool IsAlpha(String strToCheck)
        {
            Regex objAlphaPattern = new Regex("[^a-zA-Z]");
            return !objAlphaPattern.IsMatch(strToCheck);
        }

        // Function to Check for AlphaNumeric.
        /// <summary>
        /// IsAlphaNumeric Determines whether [is alpha numeric] [the specified STR to check].
        /// </summary>
        /// <param name="strToCheck">The STR to check.</param>
        /// <returns><c>true</c> if [is alpha numeric] [the specified STR to check]; otherwise, <c>false</c>.</returns>
        /// <remarks></remarks>
        public static bool IsAlphaNumeric(String strToCheck)
        {
            Regex objAlphaNumericPattern = new Regex("[^a-zA-Z0-9]");
            return !objAlphaNumericPattern.IsMatch(strToCheck);
        }

        /// <summary>
        /// GetFileExt 주어진 파일의 확장자 반환, 파일명을 소문자로 변환 후 확장자를 추출
        /// </summary>
        /// <param name="fileName">전체 파일명</param>
        /// <returns>파일명의 확장자</returns>
        /// <remarks></remarks>
        public static string GetFileExt(string fileName)
        {
            string[] f = fileName.ToLower().Split(new char[] { '.' });
            return f[f.Length - 1];
        }

        /// <summary>
        /// IsNumeric IsNumeric Method 숫자여부 체크 
        /// </summary>
        /// <param name="strNumber"></param>
        /// <returns></returns>
        public static bool IsNumeric(string strNumber)
        {
            try
            {
                double iNumber = Convert.ToDouble(strNumber);
                return true;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// IsNullOrEmpty 스트링의 문자 체크 
        /// </summary>
        /// <param name="value">object</param>
        /// <param name="type">U:대문자, else:그대로</param>
        /// <param name="defaultValue">기본값</param>
        /// <returns></returns>
        public static string IsNullOrEmpty(object value, string type, string defaultValue)
        {
            return String.IsNullOrEmpty(value.ToString()) ? defaultValue : type.Equals("U") ? value.ToString().ToUpper() : value.ToString();
        }

        /// <summary>
        /// IsEmailAddr
        /// </summary>
        /// <param name="lang"></param>
        /// <returns></returns>
        public static bool IsEmailAddr(string lang)
        {
            if (lang.Equals("")) return true;

            string pattern = @"^(?("")(""[^""]+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))";
            pattern += @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$";
            if (!Regex.IsMatch(lang, pattern))
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// IsDate_yyyyMMdd 문자열 날짜형식 체크
        /// (yyyyMMDD)형식 체크
        /// </summary>
        /// <param name="date">string</param>
        public static bool IsDate_yyyyMMdd(string date)
        {
            string pattern = @"^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$";
            if (!Regex.IsMatch(date, pattern))
            {
                return false;
            }

            return true;
        }

        #endregion

        #region UI 관련 유틸리티

        /// <summary>
        /// GetMenuID  페이지 ID 를 반환한다.
        /// </summary>
        /// <param name="page"></param>
        /// <returns>string</returns>
        public static string GetMenuID(BasePage page)
        {
            //return page.Request.Url.LocalPath.Substring(page.Request.Url.LocalPath.LastIndexOf("/") + 1).ToUpper().Replace(".ASPX", "");
            return System.IO.Path.GetFileName(page.Request.Url.LocalPath).ToUpper().Replace(".ASPX", "");
        }

        /// <summary>
        /// GetMenuName 메뉴명을 반환한다.
        /// </summary>
        /// <param name="id"></param>
        /// <returns>string</returns>
        public static string GetMenuName(BasePage page)
        {
            return Library.getMenuName(Util.GetMenuID(page));
        }


        /// <summary>
        /// GetMenuName 메뉴명을 반환한다.
        /// </summary>
        /// <param name="id"></param>
        /// <returns>string</returns>
        public static string GetMenuName(string menuID)
        {
            return Library.getMenuName(menuID);
        }

        /// <summary>
        /// GetMenuUrl
        /// </summary>
        /// <param name="menuID"></param>
        /// <returns></returns>
        public static string GetMenuUrl(string menuID)
        {
            return Library.getMenuUrl(menuID);
        }

        /// <summary>
        /// SettingEnterKeyEvent Enter 키시 포커스 이동 기능
        /// </summary>
        /// <param name="page"></param>
        /// <param name="m_TextBox"></param>
        /// <param name="m_Button"></param>
        public static void SettingEnterKeyEvent(System.Web.UI.Page page, TextFieldBase m_TextBox, Ext.Net.ImageButton m_Button)
        {
            KeyMap enter = new KeyMap();
            enter.Target = m_TextBox.ID;

            KeyBinding kb = new KeyBinding();
            kb.Keys.Add(new Key() { Code = KeyCode.ENTER });
            kb.Handler = "App." + m_Button.ID + ".fireEvent('click')";
            enter.Binding.Add(kb);

            page.Controls.Add(enter);
        }

        /// <summary>
        /// GetHeaderColumnName 헤더의 텍스트를 리턴한다.
        /// </summary>
        /// <param name="gridPanel"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public static string GetHeaderColumnName(Ext.Net.GridPanel gridPanel, string columnName)
        {
            foreach (ColumnBase col in gridPanel.ColumnModel.Columns)
            {
                if (col.Columns.Count > 0)
                {
                    foreach (ColumnBase col2 in col.Columns)
                        if (col2.ID.Equals(columnName)) return col2.Text;
                }
                if (col.ID.Equals(columnName)) return col.Text;
            }

            return columnName;
        }

        /// <summary>
        /// SetHeaderColumnHidden 헤더의 특정컬럼을 숨김/보이기 처리를 한다.
        /// </summary>
        /// <param name="gridPanel"></param>
        /// <param name="columnName"></param>
        /// <param name="isHidden"></param>
        public static void SetHeaderColumnHidden(Ext.Net.GridPanel gridPanel, string columnName, bool isHidden)
        {
            foreach (ColumnBase col in gridPanel.ColumnModel.Columns)
            {
                if (col.Columns.Count > 0)
                {
                    foreach (ColumnBase col2 in col.Columns)
                        if (col2.ID.Equals(columnName)) col2.Hidden = isHidden;
                }
                if (col.ID.Equals(columnName)) col.Hidden=isHidden;
            }
        }

        /// <summary>
        /// JsFileDirectDownloadByFileID ( 자바스크립트 다운로드문자열로 변경 )
        /// </summary>
        /// <param name="fileID"></param>
        /// <returns></returns>
        public static string JsFileDirectDownloadByFileID(string fileID)
        {
            //X.MessageBox.Notify("System Notice", "10초이내 다운로드가 시작됩니다.(Within 10 seconds to start the download.)").Show();
            return String.Format("javascript:FileDirectDownloadByFileID(document, '{0}');", fileID);
        }

        /// <summary>
        /// JsFileDirectDownloadByPath ( 자바스크립트 다운로드문자열로 변경 )
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
        public static string JsFileDirectDownloadByPath(string filePath)
        {
            //X.MessageBox.Notify("System Notice", "10초이내 다운로드가 시작됩니다.(Within 10 seconds to start the download.)").Show();
            return String.Format("javascript:FileDirectDownloadByPath(document, '{0}');", filePath);
        }

        #endregion

        #region 기본 팝업창(고객사, 협력사, 품번, 등) / 코드 팝업창(차종, 품목, 등) / 사용자 팝업창(기타 등) 호출 정의


        /// <summary>
        /// HelpPopup 기본 HelpWindow Popup 호출 ( 고객사, 헙력사, 품번, 등등 )
        /// </summary>
        /// <param name="page"></param>
        /// <param name="helperID"></param>
        /// <param name="type"></param>
        /// <param name="id"></param>
        /// <param name="code"></param>
        /// <param name="text"></param>
        /// <param name="div"></param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <param name="param"></param>
        public static void HelpPopup(BasePage page, string helperID, PopupHelper.HelpType type, string id, string code, string text, string div, int width = PopupHelper.defaultPopupWidth, int height = PopupHelper.defaultPopupHeight, HEParameterSet param = null)
        {
            Ext.Net.Window Help = PopupHelper.HelpWindow(helperID, type, id, code, text, div, width, height, param);
            if (Help != null)
            {
                Help.Render(page.Form);
                Help.Show();
            }
        }


        /// <summary>
        /// CodePopup 공용 유형코드 CodeWindow Popup 호출 ( 차종, 품목, 등등 )
        /// </summary>
        /// <param name="page"></param>
        /// <param name="id"></param>
        /// <param name="code"></param>
        /// <param name="code_name"></param>
        /// <param name="class_id"></param>
        /// <param name="type"></param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <param name="param"></param>
        public static void CodePopup(BasePage page, string id, string code, string code_name, string class_id, string type = "input", int width = PopupHelper.defaultPopupWidth, int height = PopupHelper.defaultPopupHeight, HEParameterSet param = null)
        {
            Ext.Net.Window Help = PopupHelper.CodeWindow(id, code, code_name, class_id, type, width, height, param);
            if (Help != null)
            {
                Help.Render(page.Form);
                Help.Show();
            }
        }

        /// <summary>
        /// UserPopup 사용자 정의 UserWindow Popup 호출 ( 기타 사용자 정의 팝업창 )
        /// </summary>
        /// <param name="page"></param>
        /// <param name="url"></param>
        /// <param name="param"></param>
        /// <param name="id"></param>
        /// <param name="title"></param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <remarks>param 정의 HEParameterSet 를 통하여 정의 바랍니다.
        /// HEParameterSet param = new HEParameterSet()
        /// param.Add("name", "ABCD");
        /// param.Add("value", "1234");
        /// </remarks>
        public static void UserPopup(BasePage page, string url, HEParameterSet param, string id = "Popup", string title = "Popup", int width = PopupHelper.defaultPopupWidth, int height = PopupHelper.defaultPopupHeight)
        {
            Ext.Net.Window Help = PopupHelper.UserWindow(url, param, id, title, width, height);
            if (Help != null)
            {
                Help.Render(page.Form);
                Help.Show();
            }
        }

        #endregion

        #region [blob]
        public static void FileDownLoadByBlob(System.Web.UI.Page page, byte[] bytes, string fileName)
        {
            page.Response.Clear();
            page.Response.ContentType = "application/vnd.ms-excel"; // "Application/Octet-Stream"
            page.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + page.Server.UrlPathEncode(fileName) + "\"");
            page.Response.AddHeader("Content-Length", bytes.Length.ToString());
            page.Response.OutputStream.Write(bytes, 0, bytes.Length);
            page.Response.Flush();
        }

        /// <summary>
        /// ImageCollapse 이미지 축소 처리
        /// </summary>
        /// <param name="fileContent"></param>
        /// <param name="localPath"></param>
        /// <returns></returns>
        public static byte[] ImageCollapse(byte[] fileContent)
        {
            byte[] result= null;
            try
            {
                System.Drawing.Bitmap _bmpSource = new System.Drawing.Bitmap(System.Drawing.Image.FromStream(new MemoryStream(fileContent)));

                int sourceWidth = _bmpSource.Size.Width;
                int sourceHeight = _bmpSource.Size.Height;
                int targetWidth = sourceWidth;
                int targetHeight = sourceHeight;

                // 가로사진이라면
                if (sourceWidth >= sourceHeight)
                {
                    // 가로가 1024보다 크면 가로를 1024로 고정하고 세로를 축소
                    if (sourceWidth > 1024)
                    {
                        targetWidth = 1024;
                        targetHeight = 1024 * sourceHeight / sourceWidth;
                    }
                }
                else
                {
                    // 세로가 1024보다 크면 세로를 1024로 고정하고 가로를 축소
                    if (sourceHeight > 1024)
                    {
                        targetWidth = 1024 * sourceWidth / sourceHeight;
                        targetHeight = 1024;
                    }
                }

                // 새로운 사이즈로 축소한다.
                System.Drawing.Bitmap _bmpTarget = (new System.Drawing.Bitmap(_bmpSource, targetWidth, targetHeight));

                // 이미지 파일 축소후 저장

                string fileFullPath = EPAppSection.ToString("SERVER_TEMP_PATH") + Guid.NewGuid().ToString() + ".dump";
                _bmpTarget.Save(fileFullPath, System.Drawing.Imaging.ImageFormat.Jpeg);


                FileStream fs = null;
             
                try
                {
                   
                    fs = File.OpenRead(fileFullPath);
                    result = new byte[fs.Length];

                    fs.Read(result, 0, result.Length);
                    
                }
                finally
                {

                    if (fs != null)
                    {
                        fs.Close();
                        fs.Dispose();
                        fs = null;

                        File.Delete(fileFullPath);
                    }
                    else
                    {
                        result = fileContent;
                    }
                }

            }
            catch
            {
                result = fileContent;
            }

            return result;
        }

        #endregion

        #region 웹서비스

        /// <summary>
        /// 웹서비스 SendTimeOut 값 가져오기
        /// </summary>
        /// <param name="serverPath">서버경로</param>
        /// <returns></returns>
        public static int GetSendTimeOut(string serverPath)
        {
            System.Configuration.ExeConfigurationFileMap map = new System.Configuration.ExeConfigurationFileMap();
            map.ExeConfigFilename = System.IO.Path.Combine(serverPath, "web.config");
            System.Configuration.Configuration config = System.Configuration.ConfigurationManager.OpenMappedExeConfiguration(map, System.Configuration.ConfigurationUserLevel.None);
            System.ServiceModel.Configuration.ServiceModelSectionGroup section = config.GetSectionGroup("system.serviceModel") as System.ServiceModel.Configuration.ServiceModelSectionGroup;

            double sendTimeOut = 0;
            try
            {
                sendTimeOut = section.Bindings.BasicHttpBinding.Bindings["POMM0030_SCM_SOBinding"].SendTimeout.TotalMilliseconds;
            }
            catch
            {
                sendTimeOut = 120000.0;
            }

            return Convert.ToInt32(sendTimeOut);
        }

        #endregion

        #region [파일확장자체크]

        public static bool IsValidImage(string fileName)
        {
            bool ret = false;
            switch (System.IO.Path.GetExtension(fileName).ToUpper())
            {
                case ".JPG":
                case ".JPEG":
                case ".JPE":
                case ".JFIF":
                case ".GIF":
                case ".BMP":
                case ".DIB":
                case ".PNG":
                case ".TIF":
                case ".TIFF":
                case ".ICO":
                    ret = true;
                    break;

            }
            return ret;
        }

        public static bool IsValidPdf(string fileName)
        {
            bool ret = false;
            switch (System.IO.Path.GetExtension(fileName).ToUpper())
            { 
                case ".PDF":
                    ret= true;
                    break;
               
            }
            return ret;
        }

        public static bool IsValidZip(string fileName)
        {
            bool ret = false;
            switch (System.IO.Path.GetExtension(fileName).ToUpper())
            {
                case ".ZIP":
                    ret = true;
                    break;

            }
            return ret;
        }
        #endregion

        // Grid Merge
        public static void GridMerge(DataTable result, string[] strColumnName)
        {
            if (result.Rows.Count <= 0) return;

            int firstCol = 0;
            int count = 0;

            string col = "";
            string nxt_row_col = "";
            string snxt_row_col = "";

            ArrayList arrGridNxt02 = new ArrayList();
            ArrayList arrGridNxt = new ArrayList();
            ArrayList arrGridPre02 = new ArrayList();
            ArrayList arrGridPre = new ArrayList();

            for (int j = 0; j < result.Columns.Count; j++)
            {

                if (strColumnName[0].ToString().Equals(result.Columns[j].ColumnName))
                    firstCol = j; 
            }

            for (int j = 0; j < result.Columns.Count; j++)
            {
                arrGridNxt02.Clear();
                arrGridPre02.Clear();

                count = 0;

                for (int i = result.Rows.Count - 1; i > 0; i--)
                {
                    for (int k = 0; k < strColumnName.Length; k++)
                    {
                        if (strColumnName[k].ToString().Equals(result.Columns[j].ColumnName))
                        {
                            if (result.Columns[j].DataType.Equals(typeof(string)))
                            {
                                col = result.Rows[i][j].ToString();
                                nxt_row_col = result.Rows[i-1][j].ToString();

                                if (i >= 2)
                                    snxt_row_col = result.Rows[i - 2][j].ToString();
                                

                                if (col == nxt_row_col && !col.Equals(string.Empty) && !nxt_row_col.Equals(string.Empty))
                                {
                                    if(count == 0)
                                    {
                                        arrGridPre02.Add(i);
                                        count++;
                                    }

                                    if (col != snxt_row_col && i >= 2)
                                    {
                                        arrGridNxt02.Add(i - 1);

                                        arrGridPre02.Add(i - 2);
                                    }

                                    if (count > 0 && i < 2)
                                    {
                                        if(col != snxt_row_col)
                                            arrGridNxt02.Add(i - 1);
                                        else
                                            arrGridNxt02.Add(i - 2);
                                    }

                                    if (firstCol == j)
                                    {
                                        result.Rows[i][j] = string.Empty;   //레코드 값 변경
                                    }
                                    else
                                    {
                                        if (arrGridNxt.Count > 0 && arrGridPre.Count > 0)
                                        {
                                            for (int l = 0; l < arrGridNxt.Count; l++)
                                            {
                                                for (int m = Convert.ToInt32(arrGridPre[l].ToString()); m > Convert.ToInt32(arrGridNxt[l].ToString()); m--)
                                                {
                                                    if (i >= 1)
                                                        if (result.Rows[i][j].Equals(result.Rows[i - 1][j]))
                                                            result.Rows[i][j] = string.Empty;   //레코드 값 변경   
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if (arrGridNxt02.Count > 0 && arrGridPre02.Count > 0)
                {
                    arrGridNxt = (ArrayList)arrGridNxt02.Clone();
                    arrGridPre = (ArrayList)arrGridPre02.Clone();
                }
            }
        }
    }
}
