using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Ax.EP.Utility;
using HE.Framework;

namespace Ax.EP.WP
{
    /// <summary>
    /// Download
    /// </summary>
    public partial class Download : BasePage
    {
        public Download()
        {
            this.RequireAuthentication = false;
            this.RequireAuthority = false;
            this.EnableLangSetting = false;
            this.AutoVisibleByAuthority = false;
        }

        /// <summary>
        /// OnLoad
        /// </summary>
        /// <param name="e"></param>
        protected override void OnLoad(EventArgs e)
        {
            // 파일을 다운로드하거나 또는 이미지 태그의 src 로 지정이 가능

            /* Downloadpage 사용법 ( 값을 넘길대 반드시 파라메터 값은 encodeURIComponent 로 감싸서 지정바람~
               "/Download.aspx?FilePath=" + encodeURIComponent(_filePath);
               "/Download.aspx?FileID=" + encodeURIComponent(_fileID);
            */
            if (!String.IsNullOrEmpty(Request["FilePath"]) || !String.IsNullOrEmpty(Request["FileID"]))
            {
                try
                {
                    string filePath = string.Empty;

                    if (!String.IsNullOrEmpty(Request["FilePath"]))
                    {
                        // 일반 파일일 경우
                        filePath = Request["FilePath"].ToString().Trim();
                    }
                    else
                    {
                        // FILEID 일경우 원격서버를 통해 바로 다운로드 받는다.
                        Util.FileDownLoadByFileID(this, Request["FileID"]);
                        return;
                    }

                    string securityCheck = filePath.ToString().ToLower();

                    // *.aspx*, *.config*, *.asax*, *.bak*, *.dll*, *.cs*, *.ascx*, ../../../ 경로는 보안상 다운로드 할 수 없도록 한다.
                    if (securityCheck.IndexOf(".aspx") < 0 && securityCheck.IndexOf(".config") < 0 && securityCheck.IndexOf(".asax") < 0 &&
                        securityCheck.IndexOf(".bak") < 0 && securityCheck.IndexOf(".cs") < 0 && securityCheck.IndexOf(".dll") < 0 &&
                        securityCheck.IndexOf(".ascx") < 0 && securityCheck.IndexOf("../../../") < 0)
                    {
                        if (securityCheck.Substring(0, 3) == "../" || securityCheck.Substring(0, 1) == "/")
                            filePath = Server.MapPath(filePath);
                        else
                            filePath = Server.MapPath("/files/" + filePath);

                        if (System.IO.File.Exists(filePath))
                        {
                            Response.Clear();
                            Response.ContentType = "application/vnd.ms-excel"; // "Application/Octet-Stream"

                            //string strFileName = HttpUtility.UrlEncode(new System.IO.FileInfo(filePath).Name, new System.Text.UTF8Encoding()).Replace("+", "%20");
                            string strFileName = Server.UrlPathEncode(new System.IO.FileInfo(filePath).Name);

                            Response.AddHeader("Content-Disposition", "attachment; filename=\"" + strFileName + "\"");
                            Response.AddHeader("Content-Length", new System.IO.FileInfo(filePath).Length.ToString());
                            Response.WriteFile(filePath);
                            Response.Flush();
                            
                            //삭제플래그 넘긴 경우 브라우저에 파일response하고 서버에서 임시저장해놓은 파일은 삭제한다.
                            if (!String.IsNullOrEmpty(Request["FileDelete"]) && Request["FileDelete"].Equals("1"))
                                System.IO.File.Delete(filePath);
                        }
                        else
                        {
                            this.scriptBlock.InnerHtml = "<script type='text/javascript'>alert('Not exists file. 서버에 파일 [" + filePath.Replace("\\", "\\\\").Replace("'", "\\'").Replace("\n", "\\n").Replace("\r", "\\r") + "] 이 존재하지 않습니다.');";
                        }
                    }
                    else
                    {
                        this.scriptBlock.InnerHtml = "<script type='text/javascript'>alert('You can't download. This file is security. 보안상의 이유로 해당 파일은 다운로드 할 수 없습니다.');</script>";
                    }
                }
                catch (Exception ex)
                {
                    ExceptionHandler.ErrorHandle(this, this.GetMenuID(), ex);

                    // 예외 에러
                    string errorID = "E" + DateTime.Now.ToString("yyMMddHHmmssff");
                    string errorPage = Request.Url.ToString();

                    string stackTrace = String.Format("<BR>Deatil Information : {0}", ex.ToString().Replace("\r\n", "<br/>"));

                    lblErrorTitle.Text = "PGM : " + errorPage + "<BR/>An error has occurred while processing you request job. <br/>";
                    lblErrorMessage.Text = string.Format("EID : {0}<br/>If you are having the same problem continues, please contact the administrator of the service.<br/><br/>" +
                                                         "Error Message : {1}{2}",
                                            errorID, ex.Message, stackTrace);

                    this.scriptBlock.InnerHtml = "<script type='text/javascript'>alert('" + ex.ToString().Replace("\\", "\\\\").Replace("'", "\\'").Replace("\n", "\\n").Replace("\r", "\\r") + "');</script>";
                }
                finally
                {
                }
            }
            else
            {
                this.scriptBlock.InnerHtml = "<script type='text/javascript'>alert('FilePath or FileID not support. FilePath 또는 FileID 가 지정되지 않았습니다.');</script>";
            }
        }
    }
}