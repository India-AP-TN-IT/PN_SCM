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
    /// EPRemoteFileInfo
    /// </summary>
    public class EPRemoteFileInfo
    {
        public string DBFileID = string.Empty;                // DBFileID
        public string DBFileName = string.Empty;              // DBFileName
        public string DBPath = string.Empty;                  // DBPath
        public int DBFileSize = 0;                         // DBFileSize
        public string DBMenuID = string.Empty;                // DBMenuID

        public string LocalFilePath = string.Empty;           // LocalFilePath
        public string RemoteFilePath = string.Empty;          // RemoteFilePath
        public string RemoteFileName = string.Empty;          // RemoteFileName
        public byte[] FileContent = null;                     // FileContent

        /// <summary>
        /// Save 로컬경로에 파일을 저장한다.
        /// </summary>
        public void Save()
        {
            SaveAs(this.LocalFilePath);
        }

        /// <summary>
        /// SaveAs 로컬경로에 파일을 저장한다.
        /// </summary>
        /// <param name="fileName"></param>
        public void SaveAs(string fileFullPath)
        {
            if (this.DBFileSize > 0)
            {
                // 로컬 폴더가 없을 경우 폴더를 생성한다.
                if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(fileFullPath)))
                    System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(fileFullPath));

                FileStream fs = new FileStream(fileFullPath, FileMode.Create, FileAccess.Write);

                this.DBFileSize = this.FileContent.Length;

                fs.Write(this.FileContent, 0, this.DBFileSize);
                fs.Close();
                fs.Dispose();
            }
        }
    }
}
