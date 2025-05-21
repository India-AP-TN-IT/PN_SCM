using System;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;
using Ext.Net;
using HE.Framework.Core;
using TheOne.Configuration;

namespace Ax.EP.Utility
{
    /// <summary>
    /// PopupHelper
    /// </summary>
    /// <remarks>2014.07.01 Edited by KGW</remarks>
    public static class PopupHelper
    {
        public const int defaultPopupWidth = 640;
        public const int defaultPopupHeight = 540;

        #region 기본 HelpWindow 용 Enum Type 및 Url 처리용

        /// <summary>
        /// 핼프창 타입 정의  enum
        /// </summary>
        /// <remarks></remarks>
        public enum HelpType
        {
            /// <summary>
            /// 검색용
            /// </summary>
            Search,
            /// <summary>
            /// 입력용
            /// </summary>
            Input
        }

        /// <summary>
        /// GetHelpURL
        /// </summary>
        /// <param name="helperID"></param>
        /// <returns></returns>
        private static string GetHelpURL(string helperID)
        {
            string url = "/Home/" + CommonString.HELP_BASE_PATH + EPAppSection.ToString(helperID) + ".aspx";
            return url;
        }


        /// <summary>
        /// GetCodeURL
        /// </summary>
        /// <returns></returns>
        private static string GetCodeURL()
        {
            string url = "/Home/" + CommonString.HELP_BASE_PATH + EPAppSection.ToString("CODE_TYPECD") + ".aspx";
            return url;
        }

        #endregion

        #region 기본 HelpWindow 정의 ( 고객사, 협력사, 품번 ) => 호출은 Util 클래스를 통해서 처리

        /// <summary>
        /// HelpWindow
        /// </summary>
        /// <param name="helperID"></param>
        /// <param name="type"></param>
        /// <param name="id"></param>
        /// <param name="code"></param>
        /// <param name="text"></param>
        /// <param name="div"></param>
        /// <returns></returns>
        public static Window HelpWindow(string helperID, HelpType type, string id, string code, string text, string div)
        {
            return HelpWindow(helperID, type, id, code, text, div, PopupHelper.defaultPopupWidth, PopupHelper.defaultPopupHeight);
        }

        /// <summary>
        /// HelpWindow
        /// </summary>
        /// <param name="helperID"></param>
        /// <param name="type"></param>
        /// <param name="id"></param>
        /// <param name="code"></param>
        /// <param name="text"></param>
        /// <param name="div"></param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <returns></returns>
        public static Window HelpWindow(string helperID, HelpType type, string id, string code, string text, string div, int width, int height)
        {
            return HelpWindow(helperID, type, id, code, text, div, width, height, null);
        }

        /// <summary>
        /// HelpWindow
        /// </summary>
        /// <param name="helperID"></param>
        /// <param name="type"></param>
        /// <param name="id"></param>
        /// <param name="code"></param>
        /// <param name="text"></param>
        /// <param name="div"></param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public static Window HelpWindow(string helperID, HelpType type, string id, string code, string text, string div, int width, int height, HEParameterSet param)
        {
            if (Util.UserInfo != null)
            {
                // 고객사는 고객사 팝업창 안뜨도록
                if (EPAppSection.ToString("CUSTCD_HELPNAME").Equals(helperID) && Util.UserInfo.UserDivision.Equals("T11")) return null;
                if (EPAppSection.ToString("HELP_CUSTCD_FIX").Equals(helperID) && !Util.UserInfo.UserDivision.Equals("T12")) return null;
                // 협력사는 협력사 팝업창 안뜨도록
                if (EPAppSection.ToString("VENDCD_HELPNAME").Equals(helperID) && Util.UserInfo.UserDivision.Equals("T15")) return null;
                if (EPAppSection.ToString("VENDCD_HELPNAME").Equals(helperID) && Util.UserInfo.UserDivision.Equals("T16")) return null;
            }

            bool isMoblie = true;

            if (EPAppSection.ToString("VENDCD_M_HELPNAME").Equals(helperID))
            {
                isMoblie = false;
            }

            string url = GetHelpURL(helperID);
            string urlString = GetUrlString(param, url);
            if (urlString.StartsWith("?"))
                urlString = urlString.Substring(1);

            var win = new Window
            {
                ID = id,
                Title = "Search Window",
                Width = Unit.Pixel(width),
                Height = Unit.Pixel(height),
                Modal = true,
                Collapsible = isMoblie,
                Closable = isMoblie,
                Maximizable = isMoblie,
                Resizable = true,
                Hidden = true
            };
            win.Loader = new ComponentLoader();
            win.Loader.Url = url + "?TYPE=" + type + "&ID=" + id + "&CODE=" + code + "&TEXT=" + HttpContext.Current.Server.UrlEncode(text) + "&DIV=" + div + "&" +urlString;
            win.Loader.Mode = LoadMode.Frame;
            win.Loader.AutoLoad = true;
            win.Loader.LoadMask.ShowMask = true;
            win.Loader.LoadMask.Msg = "Loading...";
            return win;
        }

        #endregion

        #region 유형코드용 CodeWindow 정의 ( 차종, 품목, 등등 )  =>  호출은 Util 클래스를 통해서 처리

        /// <summary>
        /// CodeWindow
        /// </summary>
        /// <param name="id"></param>
        /// <param name="code"></param>
        /// <param name="code_name"></param>
        /// <param name="class_id"></param>
        /// <returns></returns>
        public static Window CodeWindow(string id, string code, string code_name, string class_id)
        {
            return CodeWindow(id, code, code_name, class_id, "input", PopupHelper.defaultPopupWidth, PopupHelper.defaultPopupHeight);
        }

        /// <summary>
        /// CodeWindow
        /// </summary>
        /// <param name="id"></param>
        /// <param name="code"></param>
        /// <param name="code_name"></param>
        /// <param name="class_id"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public static Window CodeWindow(string id, string code, string code_name, string class_id, string type)
        {
            return CodeWindow(id, code, code_name, class_id, type, PopupHelper.defaultPopupWidth, PopupHelper.defaultPopupHeight);
        }

        /// <summary>
        /// CodeWindow
        /// </summary>
        /// <param name="id"></param>
        /// <param name="code"></param>
        /// <param name="code_name"></param>
        /// <param name="class_id"></param>
        /// <param name="type"></param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <returns></returns>
        public static Window CodeWindow(string id, string code, string code_name, string class_id, string type, int width, int height)
        {
            return CodeWindow(id, code, code_name, class_id, type, width, height, null);
        }

        /// <summary>
        /// CodeWindow
        /// </summary>
        /// <param name="id"></param>
        /// <param name="code"></param>
        /// <param name="code_name"></param>
        /// <param name="class_id"></param>
        /// <param name="type"></param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public static Window CodeWindow(string id, string code, string code_name, string class_id, string type, int width, int height, HEParameterSet param)
        {
            string url = GetCodeURL();
            string urlString = GetUrlString(param, url);

            var win = new Window
            {
                ID = id,
                Title = "Search Window",
                Width = Unit.Pixel(width),
                Height = Unit.Pixel(height),
                Modal = true,
                Collapsible = true,
                Closable = true,
                Maximizable = true,
                Resizable = true,
                Hidden = true
            };

            win.Loader = new ComponentLoader();
            win.Loader.Url = url + "?ID=" + id + "&TYPE=" + type + "&CODE=" + code + "&CODE_NAME=" + HttpContext.Current.Server.UrlEncode(code_name) + "&CLASS_ID=" + class_id + urlString;
            win.Loader.Mode = LoadMode.Frame;
            win.Loader.AutoLoad = true;
            win.Loader.LoadMask.ShowMask = true;
            win.Loader.LoadMask.Msg = "Loading...";

            return win;
        }

        #endregion

        #region 사용자 정의용 UserWindow 정의 ( 사용자용 임의 정의 )  =>  호출은 Util 클래스를 통해서 처리

        /// <summary>
        /// UserWindow
        /// </summary>
        /// <param name="url"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public static Window UserWindow(string url, HEParameterSet param)
        {
            return UserWindow(url, param, "Popup", "Popup", PopupHelper.defaultPopupWidth, PopupHelper.defaultPopupHeight);
        }

        /// <summary>
        /// UserWindow
        /// </summary>
        /// <param name="url"></param>
        /// <param name="param"></param>
        /// <param name="id"></param>
        /// <param name="title"></param>
        /// <returns></returns>
        public static Window UserWindow(string url, HEParameterSet param, string id, string title)
        {
            return UserWindow(url, param, id, title, PopupHelper.defaultPopupWidth, PopupHelper.defaultPopupHeight);
        }

        /// <summary>
        /// UserWindow
        /// </summary>
        /// <param name="url"></param>
        /// <param name="param"></param>
        /// <param name="id"></param>
        /// <param name="title"></param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <returns></returns>
        public static Window UserWindow(string url, HEParameterSet param, string id, string title, int width, int height)
        {
            string urlString = GetUrlString(param, url);

            urlString += (urlString.IndexOf("?") >= 0 ? "&" : "?") + "ID="+id;

            var win = new Window
            {
                ID = id,
                Title = (string.IsNullOrEmpty(title) ? "Search Window" : title),
                Width = Unit.Pixel(width),
                Height = Unit.Pixel(height),
                Modal = true,
                Collapsible = true,
                Closable = true,
                Maximizable = true,
                Resizable = true,
                Hidden = true
            };

            win.Loader = new ComponentLoader();
            win.Loader.Url = url + urlString;
            win.Loader.Mode = LoadMode.Frame;
            win.Loader.AutoLoad = true;
            win.Loader.LoadMask.ShowMask = true;
            win.Loader.LoadMask.Msg = "Loading...";
            return win;
        }

        /// <summary>
        /// GetUrlString
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        public static string GetUrlString(HEParameterSet param)
        {
            return GetUrlString(param, string.Empty);
        }

        /// <summary>
        /// GetUrlString
        /// </summary>
        /// <param name="param"></param>
        /// <param name="currentUrl"></param>
        /// <returns></returns>
        public static string GetUrlString(HEParameterSet param, string currentUrl)
        {
            string urlString = string.Empty;
            bool isUrlParam = (currentUrl.IndexOf("?") >= 0 ? true : false);

            if (param != null)
            {
                // 파라메터가 있을경우 파라메터 QueryString Mapping  ( ex)   ?code=xxx&value=123&name=kkk
                for (int i = 0; i < param.Items.Count; i++)
                {
                    urlString += ((i == 0 && !isUrlParam) ? "?" : "&");
                    urlString += param.Items[i].Key + "=" + HttpContext.Current.Server.UrlEncode(param.Items[i].Value.ToString());
                }
            };

            return urlString;
        }

        #endregion
    }
}
