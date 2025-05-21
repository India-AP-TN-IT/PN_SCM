using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Drawing;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Ax.EP.Utility;
using HE.Framework;
using Ax.EP.Utility.Security;
using iTextSharp.text.pdf;
using iTextSharp.text;

namespace Ax.EP.WP
{
    /// <summary>
    /// Download
    /// </summary>
    public partial class PDFViewer : BasePage
    {
        public PDFViewer()
        {
            //로그인했을 때만 pdf view 허용.
            this.AutoVisibleByAuthority = true;
            //this.RequireAuthentication = false;
            //this.RequireAuthority = false;
            //this.EnableLangSetting = false;
            //this.AutoVisibleByAuthority = false;
        }

        /// <summary>
        /// OnLoad
        /// </summary>
        /// <param name="e"></param>
        protected override void OnLoad(EventArgs e)
        {
            /* PDFViewer 사용법
               "/PDFViewer.aspx?FileID=" + _fileID;
               샘플ID : baba3b9ba9314890a2005a29eda66d04
               http://localhost:59902/PDFViewer.aspx?FILEID=190ac37e4ea547c38f7e9e68474b1f8d
            */

            if (!String.IsNullOrEmpty(Request["FileID"]) && !String.IsNullOrEmpty(Request["Execute"]))
            {
                try
                {
                    string filePath = string.Empty;

                    // FILEID 일경우 원격서버를 통해 바로 다운로드 받는다.
                    EPRemoteFileInfo fileInfo = EPRemoteFileHandler.FileDownload(Request["FileID"]);

                    if (System.IO.Path.GetExtension(fileInfo.DBFileName).ToUpper().Equals(".PDF"))
                    {
                        if (fileInfo != null && fileInfo.FileContent.Length >= 0)
                        {
                            string fileFullPath = EPAppSection.ToString("SERVER_TEMP_PATH") + "/PDF/" + Guid.NewGuid().ToString().Replace("-", "") + fileInfo.DBFileName;
                            fileInfo.SaveAs(fileFullPath);

                            // 워터마크 삽입코드
                            PdfAddWaterMark(fileFullPath);

                            // PDF 파일 전송처리
                            if (System.IO.File.Exists(fileFullPath))
                            {
                                this.PDFTransfer(fileFullPath, fileInfo.DBFileName);    
                                //File.Delete(fileFullPath);
                            }
                        }
                        else
                            Ext.Net.X.Js.Call("alert", "Not found PDF Documents. (PDF 문서를 찾을 수 없습니다.)");
                    }
                    else
                        Ext.Net.X.Js.Call("alert", "Not a PDF file. (PDF 파일이 아닙니다.)");


                    fileInfo = null;
                }
                catch (Exception ex)
                {
                    ExceptionHandler.ErrorHandle(this, this.GetMenuID(), ex);
                    Ext.Net.X.Js.Call("alert", ex.ToString().Replace("\\", "\\\\").Replace("'", "\\'").Replace("\n", "\\n").Replace("\r", "\\r"));
                }
                finally
                {
                }
            }
            else
            {
                if (!String.IsNullOrEmpty(Request["FileID"]))
                    Ext.Net.X.Js.Call("PDFShow", Convert.ToBase64String(System.Text.Encoding.Default.GetBytes(this.Page.Request.Url.PathAndQuery + "&Execute=1")));
                else
                    Ext.Net.X.Js.Call("alert", "Invalid request. (잘못된 요청입니다.)");
            }
        }

        // 워터마크 처리
        private static void PdfAddWaterMark(String fileFullPath)
        {
            string tmpFile = fileFullPath + "_" + DateTime.Now.Ticks.ToString();

            PdfReader pdfReader = null;
            Stream outputStream = null;
            PdfStamper pdfStamper = null;

            try
            {
                File.Move(fileFullPath, tmpFile);

                pdfReader = new PdfReader(tmpFile);
                outputStream = new FileStream(fileFullPath, FileMode.Create, FileAccess.Write, FileShare.None);

                pdfStamper = new PdfStamper(pdfReader, outputStream, '1', true);

                //string fontPath = Path.Combine(Directory.GetParent(Environment.GetFolderPath(System.Environment.SpecialFolder.System)).FullName, "Fonts"); //framework 3.5
                string fontPath = Environment.GetFolderPath(System.Environment.SpecialFolder.Fonts); //framework 4.0
                string userInfo = EPUserInfoContext.Current.DeptName + " " + EPUserInfoContext.Current.UserName;  // SRM
                //string userInfo = StaticHeUserInfoContext.DeptName + " " + StaticHeUserInfoContext.UserName;  // ERM
                string timeInfo = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

                for (int pageIndex = 1; pageIndex <= pdfReader.NumberOfPages; pageIndex++)
                {
                    PdfContentByte pdfData = pdfStamper.GetOverContent(pageIndex);
                    pdfData.SaveState();

                    pdfData.SetGState(new PdfGState { FillOpacity = 0.6f, StrokeOpacity = 0.6f });
                    pdfData.SetColorFill(new BaseColor(Color.DarkGray));
                    pdfData.BeginText();

                    float offSet = 60;
                    float availWidth = pdfData.PdfDocument.PageSize.Width;//(pdfData.PdfDocument.PageSize.Width - (offSet*2));
                    float availHeight = pdfData.PdfDocument.PageSize.Height - (offSet * 2);

                    //// #### 워터마크 4개짜리 여기부터
                    //float x = availWidth / 6;
                    //float y = availHeight / 4;
                    //float markFontSize = (18f) * 96f / 72f;

                    //pdfData.SetFontAndSize(BaseFont.CreateFont(fontPath + "\\malgunbd.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED), markFontSize);

                    //// Line 1
                    //pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x * 1 + 30, y * 4 + markFontSize - 30, 40);
                    //pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x * 1 + 30 + (markFontSize * 0.9f), y * 4 - 30, 40);

                    //pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, (x * 5) - offSet, y * 3 + markFontSize - 30, 40);
                    //pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, (x * 5) - offSet + (markFontSize * 0.9f), y * 3 - 30, 40);

                    //// Line 3
                    //pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x * 1 + 30, y * 2 + markFontSize - 30, 40);
                    //pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x * 1 + 30 + (markFontSize * 0.9f), y * 2 - 30, 40);
                    //pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, (x * 7) - offSet, y * 2 + markFontSize - 30, 40);
                    //pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, (x * 7) - offSet + (markFontSize * 0.9f), y * 2 - 30, 40);

                    //// Line 4
                    //pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x * 3, y * 1 + markFontSize - 30, 40);
                    //pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x * 3 + (markFontSize * 0.9f), y * 1 - 30, 40);

                    //// #### 워터마크 4개짜리 여기까지

                    // #### 워터마크 8개 짜리 여기부터
                    float x = availWidth / 6;
                    float y = availHeight / 5;
                    float markFontSize = (14f) * 96f / 72f;

                    pdfData.SetFontAndSize(BaseFont.CreateFont(fontPath + "\\malgunbd.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED), markFontSize);

                    // Line 0
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x, y * 5 + markFontSize, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x + (markFontSize * 0.9f), y * 5, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x * 5, y * 5 + markFontSize, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x * 5 + (markFontSize * 0.9f), y * 5, 45);

                    // Line 1
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x * 3, y * 4 + markFontSize, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x * 3 + (markFontSize * 0.9f), y * 4, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x * 7, y * 4 + markFontSize, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x * 7 + (markFontSize * 0.9f), y * 4, 45);

                    // Line 2
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x, y * 3 + markFontSize, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x + (markFontSize * 0.9f), y * 3, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x * 5, y * 3 + markFontSize, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x * 5 + (markFontSize * 0.9f), y * 3, 45);

                    // Line 3
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x * 3, y * 2 + markFontSize, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x * 3 + (markFontSize * 0.9f), y * 2, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x * 7, y * 2 + markFontSize, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x * 7 + (markFontSize * 0.9f), y * 2, 45);

                    // Line 4
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x, y * 1 + markFontSize, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x + (markFontSize * 0.9f), y * 1, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, userInfo, x * 5, y * 1 + markFontSize, 45);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_CENTER, timeInfo, x * 5 + (markFontSize * 0.9f), y * 1, 45);
                    // #### 워터마크 8개 짜리 여기까지


                    pdfData.EndText();
                    pdfData.Stroke();

                    // 하단 좌측 경고 문구 처리
                    pdfData.SetGState(new PdfGState { FillOpacity = 1f, StrokeOpacity = 1f });
                    pdfData.SetColorFill(new BaseColor(Color.Red));
                    pdfData.BeginText();
                    
                    float bottomFontSize = (5f) * 96f / 72f;
                    float height = pdfData.PdfDocument.PageSize.Height;

                    pdfData.SetFontAndSize(BaseFont.CreateFont(fontPath + "\\malgunbd.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED), bottomFontSize);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_LEFT, "※ (주)서연이화에서 제공한 스펙에 대하여 (주)서연이화 동의 없이 재 배포 할 수 없으며,", 30, ((bottomFontSize * 4f) + (bottomFontSize * 0.2f)), 0);
                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_LEFT, "   무단 배포 시 민형사상의 책임 등 의 불이익이 발생 할 수 있음.", 30, (bottomFontSize * 3), 0);

                    pdfData.EndText();
                    pdfData.Stroke();

                    // 하단 우측 회사표시 처리
                    pdfData.SetColorFill(new BaseColor(Color.Black));
                    pdfData.BeginText();

                    pdfData.ShowTextAligned(iTextSharp.text.Element.ALIGN_RIGHT, "[ 주 식 회 사 서 연 이 화 ]", pdfData.PdfDocument.PageSize.Width - 30, (bottomFontSize * 3), 0);

                    pdfData.EndText();
                    pdfData.Stroke();

                    // 이미지 처리 여기부터
                    //iTextSharp.text.Rectangle pageRectangle = pdfReader.GetPageSizeWithRotation(pageIndex);
                    //FileStream fileStreamImage = new FileStream("d:\\test.gif", FileMode.Open, FileAccess.Read, FileShare.Read);
                    //iTextSharp.text.Image jpeg = iTextSharp.text.Image.GetInstance(System.Drawing.Image.FromStream(fileStreamImage), System.Drawing.Imaging.ImageFormat.Png);

                    //float width = pageRectangle.Width;
                    //float height = pageRectangle.Height;

                    //jpeg.SetAbsolutePosition(width / 2 - jpeg.Width / 2, height / 2 - jpeg.Height / 2);
                    //jpeg.Rotation = 0;

                    //pdfData.AddImage(jpeg);
                    // 이미지 처리 여기까지
                    pdfData.RestoreState();
                }
                pdfStamper.Close();
                pdfStamper.Dispose();
                outputStream.Close();
                outputStream.Dispose();

                pdfReader.Close();
                pdfReader.Dispose();

                if (File.Exists(tmpFile)) File.Delete(tmpFile);
            }
            catch (Exception ex)
            {
                if (pdfStamper != null) { pdfStamper.Close(); pdfStamper.Dispose(); }
                if (outputStream != null) { outputStream.Close(); outputStream.Dispose(); }
                if (pdfReader != null) { pdfReader.Close(); pdfReader.Dispose(); }

                if (File.Exists(fileFullPath)) File.Delete(fileFullPath);
                if (File.Exists(tmpFile)) File.Delete(tmpFile);

                throw ex;
            }
            finally 
            {
            }
        }

        // 파일전송처리
        private void PDFTransfer(string fileFullPath, string srcFileName)
        {
            using (MemoryStream output = new MemoryStream())
            {
                PdfReader reader = new PdfReader(fileFullPath);

                //PdfEncryptor.Encrypt(reader, output, true, null, "!work@", PdfWriter.ALLOW_PRINTING | PdfWriter.ALLOW_SCREENREADERS);
                //PdfEncryptor.Encrypt(reader, output, true, null, "!work@", PdfWriter.ALLOW_SCREENREADERS);
                PdfEncryptor.Encrypt(reader, output, true, null, "!work@", 0);

                byte[] bytes = output.ToArray();

                reader.Close();

                Response.Clear();
                Response.ContentType = "application/pdf"; // "Application/Octet-Stream"
                Response.AddHeader("Content-Disposition", "filename=\"" + Server.UrlPathEncode(srcFileName) + "\"");
                //Response.AddHeader("Content-Length", new System.IO.FileInfo(fileFullPath).Length.ToString());
                Response.AddHeader("Content-Length", bytes.Length.ToString());
                Response.BinaryWrite(bytes);
                //Response.WriteFile(fileFullPath);
                Response.Flush();

            }
        }
    }
}