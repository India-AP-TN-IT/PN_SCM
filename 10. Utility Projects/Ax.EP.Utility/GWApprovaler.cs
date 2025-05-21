/*
 * GWApprovaler.cs
 *	: 하드 코드된 대칭키를 제공하는 디폴트 키 프로바이더 클래스
 * 
 * Copyright (C) 주식회사 서연이화 1980-2015. All right reserved.
 * 
 * Written by GeonWoo
 * 
 * 이 코드는 (주) 서연이화의 자산입니다. 무단으로 이 코드의 전체 혹은
 * 일부를 복제, 수정하거나 공개하는 것은 저작권 위반입니다.
 *
 * 이 코드는 (주) 서연이화 제품의 일부로서 사용될 때만이 유효하며
 * 그 외의 사용은 금지되어 있습니다.
 * 
 */
using System;
using System.Text;
using System.Data;
using HE.Framework.Core;
using Newtonsoft.Json;
using System.IO;
using HE.Framework.ServiceModel;
using System.Diagnostics;
using TheOne.Net;
using System.Security.Principal;


namespace Ax.EP.Utility
{
    /// <summary>
    /// 서연이화 물류 시스템에서 사용하는 전자결재자입니다.
    /// </summary>
    public class GWApprovaler
    {
        private bool _IsLauncher;
        private string _ERPID;
        private string _WorkKind;
        private string _CompanyID;
        private string _Subject;
        private string _EMPNO;
        //private TextBox _URL;

        private HEParameterSet _fileList;

        /// <summary>
        /// 결재창이 나타나기 전에 발생하는 이벤트에 대한 대리자입니다.
        /// </summary>
        /// <param name="ERPID"></param>
        /// <param name="procedure"></param>
        /// <param name="parameters"></param>
        /// <param name="instance"></param>
        public delegate void BeforeCall(string ERPID, string procedure, HEParameterSet parameters, DataSet instance);

        /// <summary>
        /// 결재창이 나타나기 전에 발생하는 이벤트 핸들러입니다.
        /// </summary>
        public event BeforeCall BeforeCalling;

        /// <summary>
        /// 결재창이 나타나기 전에 발생하는 이벤트입니다.
        /// </summary>
        /// <param name="ERPID"></param>
        /// <param name="procedure"></param>
        /// <param name="parameters"></param>
        /// <param name="instance"></param>
        public void OnBeforeCalling(string ERPID, string procedure, HEParameterSet parameters, DataSet instance)
        {
            if (this.BeforeCalling != null)
                this.BeforeCalling(ERPID, procedure, parameters, instance);
            else
                throw new Exception("GWApprovaler Instance에 'OnBeforeCalling' 이벤트가 정의되지 않았습니다.");
        }

        /// <summary>
        /// 결재자가 생성한 프로세스 인스턴스 OID를 가져옵니다.
        /// </summary>
        public string ERPID
        {
            set  { this._ERPID = value; }
            get { return this._ERPID; }
        }

        /// <summary>
        /// 생성자입니다.
        /// </summary>
        /// <param name="workkind"></param>
        /// <param name="subject"></param>
        public GWApprovaler(string workkind, string subject)
        {
            this.Initialize(workkind, subject, false);
        }

        /// <summary>
        /// 생성자입니다.
        /// </summary>
        /// <param name="workkind"></param>
        /// <param name="subject"></param>
        /// <param name="subjectWithDate"></param>
        public GWApprovaler(string workkind, string subject, bool subjectWithDate)
        {
            this.Initialize(workkind, subject, subjectWithDate);
        }

        /// <summary>
        /// 생성자입니다.
        /// </summary>
        /// <param name="workKind"></param>
        /// <param name="subject"></param>
        /// <param name="subjectWithDate"></param>
        private void Initialize(string workKind, string subject, bool subjectWithDate)
        {
            BasePage page = System.Web.HttpContext.Current.Handler as BasePage;

            _IsLauncher = (page.UserInfo.EmpNo.IndexOf("DEV") > 0);
            _WorkKind = workKind;
            _Subject = (subjectWithDate ? DateTime.Now.ToString("yyyy.MM.dd") + " " : "") + subject;
            ERPID = String.Format("G{0}{1}",
                DateTime.Now.ToString("yyyyMMddHHmmss"),
                Guid.NewGuid().ToString().ToUpper().Replace("-", "").Substring(0, 18));

            _CompanyID = "10";  // 서연이화 고정

            _EMPNO = _IsLauncher ? "061208" : page.UserInfo.EmpNo;
            _fileList = new HEParameterSet();

            //_URL = new TextBox();
            //_URL.Text = "";
        }

        /// <summary>
        /// 첨부파일을 추가
        /// </summary>
        /// <param name="fileFullPath"></param>
        public void FileAdd(string fileFullPath)
        {
            FileAdd(fileFullPath, false);
        }

        /// <summary>
        /// 첨부파일을 추가
        /// </summary>
        /// <param name="fileFullPath"></param>
        public void FileAdd(string fileFullPath, bool doFileDelete)
        {
            string fileKey = _fileList.Items.Count.ToString();

            // 새로운 파일을 업로드할 경우에만 처리 한다.
            if (System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(fileFullPath)))
            {
                FileStream stream = new FileStream(fileFullPath, FileMode.Open, FileAccess.Read);

                // 파일정보를 생성한다.
                EPRemoteFileInfo fileInfo = new EPRemoteFileInfo();
                fileInfo.DBPath = "GW_AppIF/" + this.ERPID;
                fileInfo.DBFileName = System.IO.Path.GetFileName(fileFullPath);
                fileInfo.DBFileSize = (int)stream.Length;
                fileInfo.DBMenuID = (doFileDelete ? fileFullPath : string.Empty);

                fileInfo.LocalFilePath = EPAppSection.ToString("SERVER_TEMP_PATH") + "/" + fileInfo.DBPath + "/" + fileInfo.DBFileName;
                fileInfo.RemoteFilePath = EPAppSection.ToString("REMOTE_FILE_PATH") + "/" + fileInfo.DBPath + "/" + fileInfo.DBFileName;

                fileInfo.RemoteFileName = fileInfo.DBFileName;

                fileInfo.FileContent = new byte[(int)stream.Length];

                stream.Read(fileInfo.FileContent, 0, fileInfo.FileContent.Length);
                stream.Close();
                stream.Dispose();

                // 파일 목록에 파일을 추가 한다.
                _fileList.Add(fileKey, fileInfo);
            }
            else
            {
                throw new FileNotFoundException("Not Found File : " + fileFullPath);
            }
        }

        /// <summary>
        /// 파일을 서버로 전송
        /// </summary>
        /// <param name="fileInfo"></param>
        private void FileTransfer(EPRemoteFileInfo fileInfo)
        {
            try
            {
                if (fileInfo.FileContent.Length > 0)
                {
                    try
                    {
                        // 로컬 폴더가 없을 경우 폴더를 생성한다.
                        if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(fileInfo.LocalFilePath)))
                            System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(fileInfo.LocalFilePath));

                        // 이미지 파일이면 축소후 저장하고 이미지 파일이 아니면 원본을 그대로 저장한다.
                        if (!EPRemoteFileHandler.ImageCollapse(fileInfo.FileContent, fileInfo.LocalFilePath)) fileInfo.Save();

                        // 원격지 인증을 수행한다.
                        WindowsImpersonationContext ctx = EPSecurityAPI.OpenFileServer();

                        // 원격서버 인증후 원격 폴더 체크
                        if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(fileInfo.RemoteFilePath)))
                            System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(fileInfo.RemoteFilePath));

                        // 로컬파일을 원격 파일로 이동한다.
                        File.Move(fileInfo.LocalFilePath, fileInfo.RemoteFilePath);

                        // 원본파일 삭제 옵션시 원본도 삭제
                        if (!string.IsNullOrEmpty(fileInfo.DBMenuID) && File.Exists(fileInfo.DBMenuID)) File.Delete(fileInfo.DBMenuID);

                        // 원격지 인증을 해제한다.
                        //ctx.Undo();
                    }
                    catch (Exception ex)
                    {
                        // 오류 발생시 로컬 파일이 있을경우 로컬 파일을 먼저 삭제처리 후 Exception 을 상위로 던진다.
                        if (File.Exists(fileInfo.LocalFilePath)) File.Delete(fileInfo.LocalFilePath);
                        throw ex;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Can't access fileServer", ex);
            }
        }

        /// <summary>
        /// 결재창을 호출 후 기간시스템에 결재에 관련된 정보를 업데이트하지 않을 경우 사용합니다.
        /// </summary>
        /// <param name="procedureName"></param>
        /// <param name="parameters"></param>
        public void CallWithoutEvent(string procedureName, HEParameterSet parameters)
        {
            this.Execute(true, procedureName, parameters);
        }

        /// <summary>
        /// 결재창을 호출 후 기간시스템에 결재에 관련된 정보를 업데이트 해야 할 경우 사용합니다.
        /// </summary>
        /// <param name="procedureName"></param>
        /// <param name="parameters"></param>
        public void Call(string procedureName, HEParameterSet parameters)
        {
            this.Execute(false, procedureName, parameters);
        }

        /// <summary>
        /// 인스턴스 데이처를 처리하고 결재 윈도우를 호출합니다.
        /// </summary>
        /// <param name="isNonUpdate"></param>
        /// <param name="procedureName"></param>
        /// <param name="parameters"></param>
        private void Execute(bool isNonUpdate, string procedureName, HEParameterSet parameters)
        {
            BasePage page = System.Web.HttpContext.Current.Handler as BasePage;

            if (page.UserInfo.UserDivision.Equals("T12") || page.UserInfo.UserDivision.Equals("T10"))
            {
                int isFile = 0;

                // 파일이 있으면 파일 처리 문저 수행
                foreach (HEParameterSetItem obj in this._fileList.Items)
                {
                    EPRemoteFileInfo fileInfo = obj.Value as EPRemoteFileInfo;
                    if (fileInfo != null) FileTransfer(fileInfo);

                    isFile++;
                }

                // 인스턴스 및 데이터 처리
                string paramJson = JsonConvert.SerializeObject(parameters);

                // JObject 변환후 HEParameterSet 의 기본 파라메터 삭제 후 다시 Serializable
                Newtonsoft.Json.Linq.JObject jo = Newtonsoft.Json.Linq.JObject.Parse(paramJson);
                jo.Remove("_ParameterSetName");
                jo.Remove("_ParameterSetCount");
                paramJson = JsonConvert.SerializeObject(jo);

                DataSet instance = Util.GetDataSourceSchema("ERPID", "WORKKIND", "COMPANYID", "EMPNO", "SUBJECT", "PROCEDURE", "PARAM", "ISFILE");

                instance.Tables[0].Rows.Add(_ERPID, _WorkKind, _CompanyID, _EMPNO, _Subject, procedureName, paramJson, isFile);

                if (!isNonUpdate)
                    this.OnBeforeCalling(_ERPID, procedureName, parameters, instance);


                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx("GW.APG_GWINSTANCE.CREATE_INSTANCE", instance);
                }

                // 브라우저 호출
                string approvalUrl = String.Format(Library.GetSysEnviroment("GW", _IsLauncher ? "URL_DEV" : "URL_RUN"), _ERPID); // ERPID 프로퍼티 에서 처리

                Ext.Net.X.Js.Call("ShowApproval", TheOne.Security.UserInfoContext.Current.UserID, approvalUrl);
            }
            else
            {
                page.MsgCodeAlert("Approval feature is available only to internal users.");
            }
        }
    }
}
