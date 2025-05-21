using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TheOne.Configuration;

namespace Ax.EP.Utility
{
    /// <summary>
    /// CommonString
    /// </summary>
    /// <remarks></remarks>
    public class CommonString
    {
        public static string LOGIN_PAGE_ID = EPAppSection.ToString("LOGIN_PAGE_ID");
        public static string MAIN_PAGE_ID = EPAppSection.ToString("MAIN_PAGE_ID");
        public static string BASE_PATH = EPAppSection.ToString("BASE_PATH");
        public static string HELP_BASE_PATH = EPAppSection.ToString("HELP_BASE_PATH");

        public static bool MOBILE_MODE_USE = EPAppSection.ToBoolean("MOBILE_MODE_USE");
        public static string MOBILE_MAIN_PAGE_ID = EPAppSection.ToString("MOBILE_MAIN_PAGE_ID");
        public static string MOBILE_LOGIN_PAGE_ID = EPAppSection.ToString("MOBILE_LOGIN_PAGE_ID");
        public static string MOBILE_BASE_PATH = EPAppSection.ToString("MOBILE_BASE_PATH");
        public static string MOBILE_HELP_BASE_PATH = EPAppSection.ToString("MOBILE_HELP_BASE_PATH");

        private static string _noImage = "/images/etc/no_image.gif";//4.X이미지 경로 변경
        private static string _homedirectory = "~/Home";
        private static string _loginPageUrlStr = _homedirectory + "/" + BASE_PATH + LOGIN_PAGE_ID + ".aspx";
        private static string _mainPageUrlStr = _homedirectory + "/" + BASE_PATH + MAIN_PAGE_ID + ".aspx";

        private static string _mobilehomedirectory = (MOBILE_MODE_USE ? "~/Mobile" : _homedirectory);
        private static string _mobileloginPageUrlStr = (MOBILE_MODE_USE ? _mobilehomedirectory + "/" + MOBILE_BASE_PATH + MOBILE_LOGIN_PAGE_ID + ".aspx" : _loginPageUrlStr);
        private static string _mobilemainPageUrlStr = (MOBILE_MODE_USE ? _mobilehomedirectory + "/" + MOBILE_BASE_PATH + MOBILE_MAIN_PAGE_ID + ".aspx" : _mainPageUrlStr);

        /// <summary>
        /// MainPageUrlStr
        /// </summary>
        public static string MainPageUrlStr
        {
            get { return CommonString._mainPageUrlStr; }
            set { CommonString._mainPageUrlStr = value; }
        }

        /// <summary>
        /// LoginPageUrlStr
        /// </summary>
        public static string LoginPageUrlStr
        {
            get { return CommonString._loginPageUrlStr; }
            set { CommonString._loginPageUrlStr = value; }
        }

        /// <summary>
        /// NoImage Property
        /// </summary>
        public static string NoImage
        {
            get { return CommonString._noImage; }
            set { CommonString._noImage = value; }
        }

        /// <summary>
        /// HomeDirectory Property
        /// </summary>
        public static string HomeDirectory
        {
            get { return CommonString._homedirectory; }
            set { CommonString._homedirectory = value; }
        }

        /// <summary>
        /// Mobilehomedirectory
        /// </summary>
        public static string MobileHomeDirectory
        {
            get { return CommonString._mobilehomedirectory; }
            set { CommonString._mobilehomedirectory = value; }
        }

        /// <summary>
        /// MobileloginPageUrlStr
        /// </summary>
        public static string MobileLoginPageUrlStr
        {
            get { return CommonString._mobileloginPageUrlStr; }
            set { CommonString._mobileloginPageUrlStr = value; }
        }

        /// <summary>
        /// MobilemainPageUrlStr
        /// </summary>
        public static string MobileMainPageUrlStr
        {
            get { return CommonString._mobilemainPageUrlStr; }
            set { CommonString._mobilemainPageUrlStr = value; }
        }

        /// <summary>
        /// returnFileType Returns the type of the file.
        /// </summary>
        /// <param name="fileType">Type of the file.</param>
        /// <returns></returns>
        /// <remarks></remarks>
        public static String returnFileType(string fileType)
        {
            string returnFileType = string.Empty;
            switch (fileType)
            {
                case "gif":
                    returnFileType = "image/gif";
                    break;
                case "bmp":
                    returnFileType = "image/bmp";
                    break;
                case "png":
                    returnFileType = "image/png";
                    break;
                case "rtf":
                    returnFileType = "text/rtf";
                    break;
                case "jpg":
                    returnFileType = "image/jpg";
                    break;
                case "jpe":
                    returnFileType = "image/jpeg";
                    break;
                case "jpeg":
                    returnFileType = "image/jpeg";
                    break;
                case "ppt":
                    returnFileType = "application/vnd.ms-powerpoint";
                    break;
                case "zip":
                    returnFileType = "application/zip";
                    break;
                case "psd":
                    returnFileType = "application/octet-stream";
                    break;
                case "xml":
                    returnFileType = "application/xml";
                    break;
                case "xls":
                    returnFileType = "application/vnd.ms-excel";
                    break;
                case "xlsx":
                    returnFileType = "application/vnd.ms-excel";
                    break;
                case "docs":
                    returnFileType = "application/vnd.ms-word";
                    break;
                case "docx":
                    returnFileType = "application/vnd.ms-word";
                    break;
                case "pdf":
                    returnFileType = "application/pdf";
                    break;
                case "txt":
                    returnFileType = "text/plain";
                    break;

            }
            return returnFileType;
        }
    }
}