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
    public partial class DownloadImage : BasePage
    {
        public DownloadImage()
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
                        Util.FileImageByFileID(this, Request["FileID"]);
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
                            Response.ContentType = "image/jpeg"; // "Application/Octet-Stream"
                            Response.AddHeader("Content-Disposition", "attachment; filename=\"" + Server.UrlPathEncode(new System.IO.FileInfo(filePath).Name) + "\"");
                            Response.AddHeader("Content-Length", new System.IO.FileInfo(filePath).Length.ToString());
                            Response.WriteFile(filePath);
                            Response.Flush();

                            //삭제플래그 넘긴 경우 브라우저에 이미지 표시하고 이미지파일은 삭제한다.
                            if (!String.IsNullOrEmpty(Request["FileDelete"]) && Request["FileDelete"].Equals("1"))
                                System.IO.File.Delete(filePath);
                        }
                        else
                        {
                            // 이미지 파일이 없을때
                            this.NoImage();
                        }
                    }
                    else
                    {
                        // 보안조건으로 인해 다운로드 불허할때 
                        this.NoImage();
                    }
                }
                catch (Exception ex)
                {
                    ExceptionHandler.ErrorHandle(this, this.GetMenuID(), ex);

                    // 오류발생시 로그기록하고  noimage 처리
                    this.NoImage();
                }
                finally
                {
                }
            }
            else
            {
                // FilePath 또는 FileID 미 지정시 
                this.NoImage();

            }
        }

        /// <summary>
        /// 이미지 없을때 처리
        /// </summary>
        public void NoImage()
        {
            Response.Clear();
            Response.ContentType = "image/gif"; // "Application/Octet-Stream"
            Response.AddHeader("Content-Disposition", "attachment; filename=\"noimage.gif\"");
            Response.WriteFile(Server.MapPath("/images/etc/no_image.gif"));
            Response.Flush();
        }
    }
}