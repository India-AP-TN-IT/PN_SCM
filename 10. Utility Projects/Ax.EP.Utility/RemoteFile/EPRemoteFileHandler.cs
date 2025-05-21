using System;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Principal;
using Ax.EP.Utility;
using HE.Framework.Core;
using System.Data;
using TheOne.Security;

namespace Ax.EP.Utility
{
    /// <summary>
    /// EPRemoteFileHandler
    /// </summary>
    public static class EPRemoteFileHandler
    {
        #region FileDownload
        /// <summary>
        /// FileDownload  원격서버로 부터 파일을 EPRemoteFileInfo 클래스로 반환한다.
        /// </summary>
        /// <param name="fileID"></param>
        /// <returns>EPRemoteFileInfo</returns>
        public static EPRemoteFileInfo FileDownload(string fileID)
        {
            EPRemoteFileInfo fileInfo = getFileMetaInfo(fileID);

            if (fileInfo != null)
            {
                // 원격지 인증을 수행한다.
                WindowsImpersonationContext ctx = EPSecurityAPI.OpenFileServer();

                // 원격지 파일 존재 여부 확인
                bool remoteFileExists = File.Exists(fileInfo.RemoteFilePath);

                // 로컬 폴더가 없을 경우 폴더를 생성한다.
                if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(fileInfo.LocalFilePath)))
                    System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(fileInfo.LocalFilePath));

                // 원격지로부터 파일을 복사해 온다
                if (remoteFileExists) File.Copy(fileInfo.RemoteFilePath, fileInfo.LocalFilePath, true);

                // 원격지 인증을 해제한다.
                //ctx.Undo();

                // 실제로 파일이 복사되었을때 읽어오도록 한다.
                if (File.Exists(fileInfo.LocalFilePath) && remoteFileExists)
                {

                    // 파일을 읽어서 Bytes Array 로 생성한다.
                    FileStream fs = new FileStream(fileInfo.LocalFilePath, FileMode.Open);

                    fileInfo.DBFileSize = (int)fs.Length;   // 실제 파일사이즈로 처리한다.
                    fileInfo.FileContent = new byte[fileInfo.DBFileSize];

                    fs.Read(fileInfo.FileContent, 0, fileInfo.DBFileSize);
                    fs.Close();

                    // Read 완료후 임시 로컬파일을 삭제한다.
                    File.Delete(fileInfo.LocalFilePath);
                }
                else
                {
                    throw new FileLoadException("ERROR : Not Found File from Remote Server  or  Don't bring remote file!\r\n원격서버에 파일이 없거나 또는 가져오지 못하였습니다.");
                }
            }

            // 읽은 파일을 EPRemoteFileInfo 클래스로 반환한다.
            return fileInfo;
        }
        #endregion

        #region FileRemove
        /// <summary>
        /// FileRemove   DB XD7000의 메타정보를 가져온다.
        /// </summary>
        /// <param name="fileInfo"></param>
        public static void FileRemove(EPRemoteFileInfo fileInfo)
        {
            FileRemove(fileInfo.DBFileID);
        }

        /// <summary>
        /// FileRemove   DB XD7000의 메타정보를 가져온다.
        /// </summary>
        /// <param name="fileID"></param>
        public static void FileRemove(string fileID)
        {
            EPRemoteFileInfo fileInfo = getFileMetaInfo(fileID);

            if (fileInfo != null)
            {
                // 원격지 인증을 수행한다.
                WindowsImpersonationContext ctx = EPSecurityAPI.OpenFileServer();

                // 원격지 파일삭제 처리 수행
                if (File.Exists(fileInfo.RemoteFilePath)) File.Delete(fileInfo.RemoteFilePath);

                // 원격지 인증을 해제한다.
                //ctx.Undo();

                // XD7000 의 메타정보도 함께 삭제한다.
                removeFileMetaInfo(fileID);
            }
        }
        #endregion

        #region FileUpload
 
        /// <summary>
        /// FileUpload
        /// </summary>
        /// <param name="fileField"></param>
        /// <param name="saveFolder"></param>
        /// <param name="oldFileID"></param>
        /// <returns></returns>
        public static string FileUpload(Ext.Net.FileUploadField fileField, string saveFolder, string oldFileID)
        {
            string newFileID = string.Empty;

            // 새로운 파일을 업로드할 경우에만 처리 한다.
            if (fileField.HasFile)
            {
                // 파일정보를 생성한다.
                EPRemoteFileInfo fileInfo = new EPRemoteFileInfo();
                fileInfo.DBPath = Util.SystemCode + "/" + saveFolder;
                fileInfo.DBFileID = System.Guid.NewGuid().ToString().Replace("-", string.Empty);
                fileInfo.DBFileName = System.IO.Path.GetFileName(fileField.FileName);
                fileInfo.DBFileSize = fileField.FileBytes.Length;
                fileInfo.DBMenuID = ((BasePage)fileField.Page).GetMenuID();

                fileInfo.LocalFilePath = EPAppSection.ToString("SERVER_TEMP_PATH") + "/" + fileInfo.DBPath + "/" + fileInfo.DBFileID + fileInfo.DBFileName;
                fileInfo.RemoteFilePath = EPAppSection.ToString("REMOTE_FILE_PATH") + "/" + fileInfo.DBPath + "/" + fileInfo.DBFileID + fileInfo.DBFileName;
                fileInfo.RemoteFileName = fileInfo.DBFileID + fileInfo.DBFileName;

                fileInfo.FileContent = fileField.FileBytes;

                // 신규파일 정상 업로드
                newFileID = FileUpload(fileInfo, saveFolder, oldFileID);

                // 구형파일이 있을경우 신규 파일 정상 처리후 구형 파일 삭제
                if (!string.IsNullOrEmpty(oldFileID)) FileRemove(oldFileID);
            }
            else
            {
                // 없으면 기존 파일 유지를 위해 oldFileID 그대로 반환
                newFileID = oldFileID;
            }

            // 신규 파일ID 를 반환
            return newFileID;
        }

        /// <summary>
        /// FileUpload
        /// </summary>
        /// <param name="fileInfo"></param>
        /// <param name="saveFolder"></param>
        /// <param name="oldFileID"></param>
        /// <returns>string</returns>
        public static string FileUpload(EPRemoteFileInfo fileInfo, string saveFolder, string oldFileID)
        {
            string newFileID = string.Empty;

            if (fileInfo.FileContent.Length > 0)
            {
                try
                {
                    // 로컬 폴더가 없을 경우 폴더를 생성한다.
                    if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(fileInfo.LocalFilePath)))
                        System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(fileInfo.LocalFilePath));

                    // 이미지 파일이면 축소후 저장하고 이미지 파일이 아니면 원본을 그대로 저장한다.
                    if (!ImageCollapse(fileInfo.FileContent, fileInfo.LocalFilePath)) fileInfo.Save();

                    // 원격지 인증을 수행한다.
                    WindowsImpersonationContext ctx = EPSecurityAPI.OpenFileServer();

                    // 원격서버 인증후 원격 폴더 체크
                    if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(fileInfo.RemoteFilePath)))
                        System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(fileInfo.RemoteFilePath));

                    // 로컬파일을 원격 파일로 이동한다.
                    File.Move(fileInfo.LocalFilePath, fileInfo.RemoteFilePath);

                    // 원격지 인증을 해제한다.
                    //ctx.Undo();

                    // 정상완료되면 WCF 를 통하여 DB 의 XD7000 에 메타정보를 저장한다.
                    setFileMetaInfo(fileInfo);

                    newFileID = fileInfo.DBFileID;

                    // oldFileID가 있을경우 신규 파일 정상 처리후 구형 파일 삭제
                    if (!string.IsNullOrEmpty(oldFileID)) FileRemove(oldFileID);
                }
                catch (Exception ex)
                {
                    // 오류 발생시 로컬 파일이 있을경우 로컬 파일을 먼저 삭제처리 후 Exception 을 상위로 던진다.
                    if (File.Exists(fileInfo.LocalFilePath)) File.Delete(fileInfo.LocalFilePath);
                    throw ex;
                }
            }
            else
            {
                // FileInfo 에 Contents 가 없을경우 기존 파일 유지를 위해 oldFileID 반환
                newFileID = oldFileID;
            }

            // 정상 저장시 fileID 를 반환한다.
            return newFileID;
        }
        #endregion

        #region Internal Code

        /// <summary>
        /// ImageCollapse 이미지 축소 처리
        /// </summary>
        /// <param name="fileContent"></param>
        /// <param name="localPath"></param>
        /// <returns></returns>
        public static bool ImageCollapse(byte[] fileContent, string localPath)
        {
            bool result = false;

            try
            {
                Bitmap _bmpSource = new Bitmap(Image.FromStream(new MemoryStream(fileContent)));

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
                Bitmap _bmpTarget = (new Bitmap(_bmpSource, targetWidth, targetHeight));

                //// GDI+를 이용해서 축소된 이미지 생성
                //Bitmap _bmpTarget = new Bitmap(targetWidth, targetHeight); 
                //Graphics g = Graphics.FromImage(_bmpTarget);
                //g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                //g.DrawImage(_bmpSource, new Rectangle(0, 0, targetWidth, targetHeight));
                
                // 이미지 파일 축소후 저장
                _bmpTarget.Save(localPath, System.Drawing.Imaging.ImageFormat.Jpeg);

                result = true;
            }
            catch
            {
                result = false;
            }

            return result;
        }

        /// <summary>
        /// setFileMetaInfo   DB XD7000 에 파일메타 정보를 저장한다.
        /// </summary>
        /// <param name="fileInfo"></param>
        private static void setFileMetaInfo(EPRemoteFileInfo fileInfo)
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("FILEID", fileInfo.DBFileID);
            param.Add("FILENAME", fileInfo.DBFileName);
            param.Add("PATH", fileInfo.DBPath);
            param.Add("FILE_SIZE", fileInfo.DBFileSize);
            param.Add("MENUID", fileInfo.DBMenuID);

            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx("APG_EPSERVICE.SET_FILE_METAINFO", param);
            }
        }

        /// <summary>
        /// getFileMetaInfo   DB XD7000의 메타정보를 가져온다.
        /// </summary>
        /// <param name="fileID"></param>
        private static EPRemoteFileInfo getFileMetaInfo(string fileID)
        {
            EPRemoteFileInfo fileInfo = null;

            HEParameterSet param = new HEParameterSet();
            param.Add("FILEID", fileID);
            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.GET_FILE_METAINFO", param);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                // 파일정보를 생성한다.
                fileInfo = new EPRemoteFileInfo();

                fileInfo.DBPath = ds.Tables[0].Rows[0]["PATH"].ToString();
                fileInfo.DBFileID = ds.Tables[0].Rows[0]["FILEID"].ToString();
                fileInfo.DBFileName = ds.Tables[0].Rows[0]["FILENAME"].ToString();
                fileInfo.DBFileSize = int.Parse(ds.Tables[0].Rows[0]["FILE_SIZE"].ToString());
                fileInfo.DBMenuID = ds.Tables[0].Rows[0]["MENUID"].ToString();

                fileInfo.LocalFilePath = EPAppSection.ToString("SERVER_TEMP_PATH") + "/" + fileInfo.DBPath + "/" + System.Guid.NewGuid().ToString().Replace("-", string.Empty) /*fileInfo.DBFileID(*/ + fileInfo.DBFileName;
                fileInfo.RemoteFilePath = EPAppSection.ToString("REMOTE_FILE_PATH") + "/" + fileInfo.DBPath + "/" + fileInfo.DBFileID + fileInfo.DBFileName;
                fileInfo.RemoteFileName = fileInfo.DBFileID + fileInfo.DBFileName;
            }

            return fileInfo;
        }

        /// <summary>
        /// removeFileMetaInfo   DB XD7000의 메타정보를 삭제한다..
        /// </summary>
        /// <param name="fileID"></param>
        private static void removeFileMetaInfo(string fileID)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("FILEID", fileID);

            // XD7000 DB 의 메타 정보를 제거한다.
            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx("APG_EPSERVICE.REMOVE_FILE_METAINFO", param);
            }
        }
        #endregion
    }
}
