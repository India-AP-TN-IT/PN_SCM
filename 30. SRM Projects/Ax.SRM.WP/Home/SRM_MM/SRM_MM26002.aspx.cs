#region ▶ Description & History
/* 
 * 프로그램명 : 협력사 재고 등록 (구.VM4030)
 * 설      명 : 자재관리 > 사급관리 > 협력사 재고 등록
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-07
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
 *				
 *
 * 
*/
#endregion
using System;
using System.Collections.Generic;
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml;
using ExportToExcel;
using System.Reflection;
//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Web;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using HE.EP.Utility;
//using Ext.Net;
//using HE.Framework.Core;
//using System.Data;
//using System.Collections;

//using DocumentFormat.OpenXml.Packaging;
//using DocumentFormat.OpenXml;
//using ExportToExcel;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM26002 : BasePage
    {
        private string pakageName = "APG_SRM_MM26002";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM26002
        /// </summary>
        public SRM_MM26002()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = true;
        }

        /// <summary>
        /// Page_Load
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!X.IsAjaxRequest)
                {
                    Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);
                    Library.ComboDataBind(this.cbo01_VEND_INV_DIV, Library.GetTypeCode("EW").Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);
                    Library.ComboDataBind(this.cbo01_SOURCING_DIVISION, Library.GetTypeCode("1I").Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);
                    //Library.ComboDataBind(this.cbo01_MAT_TYPE, Library.GetTypeCode("EA").Tables[0], false, "OBJECT_NM", "OBJECT_ID", true);

                    Reset();
                }
            }
            catch //(Exception ex)
            {
                // excel 다운로드는 메시지 처리 하지 않음
                //this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        #endregion

        #region [ 버튼설정 ]

        /// <summary>
        /// BuildButtons
        /// 기본 버튼생성
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
            MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
            MakeButton(ButtonID.Close, ButtonImage.Close, "Close", this.ButtonPanel);
            //엑셀 업로드용 버튼
            MakeButton(ButtonID.Upload, ButtonImage.Upload, "Upload", this.ButtonPanel2, true);
        }

        /// <summary>
        /// MakeButton
        /// </summary>
        /// <param name="id"></param>
        /// <param name="image"></param>
        /// <param name="alt"></param>
        /// <param name="container"></param>
        /// <param name="isUpload"></param>
        public void MakeButton(string id, string image, string alt, Ext.Net.Panel container, bool isUpload = false)
        {
            Ext.Net.ImageButton ibtn = CreateImageButton(id, image, alt, isUpload);
            if (id.Equals(ButtonID.Save)) //저장시 수정된 데이터만 저장한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
            }            
            container.Add(ibtn);
        }

        /// <summary>
        /// Button_Click
        /// 기본 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public override void Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.ImageButton ibtn = (Ext.Net.ImageButton)sender;

            switch (ibtn.ID)
            {
                case ButtonID.Search:
                    Search();
                    break;
                case ButtonID.Reset:
                    Reset();
                    break;
                case ButtonID.Save:
                    Save(sender, e);
                    break;
                case ButtonID.ExcelDL:
                    Excel_Export();
                    break;
                case ButtonID.Upload:
                    Excel_Import();
                    break;
                case ButtonID.Close:
                    X.Js.Call("closeTab");
                    break;
                default: break;
            }
        }

        #endregion

        /// <summary>
        /// etc_Button_Click
        /// 사용자 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void etc_Button_Click(object sender, EventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_DOWN":
                    Excel_Export1();
                    //Excel();
                    break;

                default:
                    break;
            }
        }

        #region [ 기능 ]

        [DirectMethod]
        public void SetCustVendVisible(string gubun)
        {
            this.Store1.RemoveAll();

            if (gubun.Equals("EWB"))
            {
                this.lbl01_CUST.Hidden = false;
                this.cdx01_CUSTCD.VisiableContainer = true;

                this.lbl01_VEND.Hidden = true;
                this.cdx01_VENDCD.VisiableContainer = false;
            }
            else
            {
                this.lbl01_CUST.Hidden = true;
                this.cdx01_CUSTCD.VisiableContainer = false;

                this.lbl01_VEND.Hidden = false;
                this.cdx01_VENDCD.VisiableContainer = true;
            }
        }

        /// <summary>
        /// Search
        /// </summary>
        public void Search()
        {
            try
            {
                //유효성 검사
                if (!IsQueryValidation())
                {
                    return;
                }

                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                //Reset();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }
        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.df01_GETDATE.SetValue(DateTime.Now);
            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
                this.cdx01_CUSTCD.SetValue(string.Empty);
            }

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.           

            this.df01_GETDATE.SetValue(DateTime.Now);

            this.cdx01_VINCD.SetValue(string.Empty);

            this.cbo01_VEND_INV_DIV.SelectedItem.Value = "EWB";
            this.cbo01_VEND_INV_DIV.UpdateSelectedItems();
            this.cbo01_VEND_INV_DIV.ReadOnly = true;

            this.cbo01_SOURCING_DIVISION.SelectedItem.Value = "1I320";
            this.cbo01_SOURCING_DIVISION.UpdateSelectedItems();

            //this.cbo01_MAT_TYPE.SelectedItem.Value = "EAR";
            //this.cbo01_MAT_TYPE.UpdateSelectedItems();
            //this.cbo01_MAT_TYPE.ReadOnly = true;

            this.txt01_FPARTNO.Text = string.Empty;
            //this.txt01_TPARTNO.Text = string.Empty;

            this.txt01_MGRNM.Text = string.Empty;
            this.fud02_FILEID1.Text = string.Empty;
            this.txt01_ROWCNT_EXCEL.Text = string.Empty;
            this.txt01_ROWCNT_ADDED.Text = string.Empty;

            this.Store1.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);

            param.Add("INV_DATE", ((DateTime)this.df01_GETDATE.Value).ToString("yyyy-MM-dd"));
            //param.Add("INV_DATE", this.GetDateText(this.df01_GETDATE, "yyyy-MM-dd"));

            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("PARTNO1", this.txt01_FPARTNO.Text);
            param.Add("SOURCING_DIV", this.cbo01_SOURCING_DIVISION.Value);
            //param.Add("PARTNO2", this.txt01_TPARTNO.Text.Equals(string.Empty) ? "Z" : this.txt01_TPARTNO.Text);            
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            if (cbo01_VEND_INV_DIV.Value.ToString().Equals("EWB"))
            {
                param.Add("CUSTCD", this.cdx01_CUSTCD.Value);
                //param.Add("MAT_TYPE", this.cbo01_MAT_TYPE.Value);
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_01"), param);
            }
            else
            {
                param.Add("CUSTCD", this.UserInfo.CustomerCD);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_02"), param);
            }
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet1()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);

            param.Add("INV_DATE", ((DateTime)this.df01_GETDATE.Value).ToString("yyyy-MM-dd"));
            //param.Add("INV_DATE", this.GetDateText(this.df01_GETDATE, "yyyy-MM-dd")); 

            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("PARTNO1", this.txt01_FPARTNO.Text);
            //param.Add("PARTNO2", this.txt01_TPARTNO.Text.Equals(string.Empty) ? "Z" : this.txt01_TPARTNO.Text);            
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            if (cbo01_VEND_INV_DIV.Value.ToString().Equals("EWB"))
            {
                param.Add("CUSTCD", this.cdx01_CUSTCD.Value);
                //param.Add("MAT_TYPE", this.cbo01_MAT_TYPE.Value);--제거 2018.11.07
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_01_EXCEL"), param);
            }
            else
            {
                param.Add("CUSTCD", this.UserInfo.CustomerCD);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_02_EXCEL"), param);
            }

        }
        /// <summary>
        /// SaveAndDelete
        /// 저장(업데이트)
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                DataSet removeParam = Util.GetDataSourceSchema
                (
                   //"CORCD", "BIZCD", "INV_INSPECTNO", "LANG_SET", "USER_ID"
                    "CORCD", "BIZCD", "CUSTCD", "INV_DATE", "PARTNO", "INV_INSPECTNO", "LANG_SET", "USER_ID"
                );

                DataSet saveParam = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "CUSTCD", "INV_DATE", //"STATUS_DIV", "MAT_TYPE", --2018.11.07 제거
                   "UNIT",  // --2018.11.07 추가
                   "OK_INV_QTY", "DEF_INV_QTY",
                   "LOSS_QTY", "MGRNM", "REMARK", "PARTNO", "LANG_SET", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    removeParam.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , this.cdx01_CUSTCD.Value

                        , ((DateTime)this.df01_GETDATE.Value).ToString("yyyy-MM-dd")
                        //, this.GetDateText(this.df01_GETDATE, "yyyy-MM-dd")

                        , parameters[i]["PARTNO"]
                        , parameters[i]["VEND_INVNO"]
                        , this.UserInfo.LanguageShort
                        , this.UserInfo.UserID
                    );

                    saveParam.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , cbo01_VEND_INV_DIV.Value.ToString().Equals("EWB") ? this.cdx01_CUSTCD.Value : this.UserInfo.CustomerCD

                        , ((DateTime)this.df01_GETDATE.Value).ToString("yyyy-MM-dd")
                        //, this.GetDateText(this.df01_GETDATE, "yyyy-MM-dd")

                        //, this.cbo01_VEND_INV_DIV.Value
                        //, parameters[i]["MAT_TYPE"]
                        , parameters[i]["UNIT"]             //2018.11.07 추가
                        , parameters[i]["OK_INV_QTY"] == "" ? "0" : parameters[i]["OK_INV_QTY"]
                        , parameters[i]["DEF_INV_QTY"] == "" ? "0" : parameters[i]["DEF_INV_QTY"]
                        , parameters[i]["LOSS_QTY"] == "" ? "0" : parameters[i]["LOSS_QTY"]
                        , this.txt01_MGRNM.Value
                        , parameters[i]["REMARK"]
                        , parameters[i]["PARTNO"]
                        , this.UserInfo.LanguageShort
                        , this.UserInfo.UserID
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid(saveParam.Tables[0].Rows[i], Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }

                string saveProcedure = "";
                string deleteProcedure = "";

                if (cbo01_VEND_INV_DIV.Value.ToString().Equals("EWB"))
                    saveProcedure = "SAVE_01";
                else
                    saveProcedure = "SAVE_02";

                //if (cbo01_VEND_INV_DIV.Value.ToString().Equals("EWB"))
                //    deleteProcedure = "REMOVE";
                //else
                //    deleteProcedure = "REMOVE02";

                string[] procedure = new string[] { string.Format("{0}.{1}", pakageName, "REMOVE_01"),
                                                    string.Format("{0}.{1}", pakageName, saveProcedure)};
                DataSet[] param = new DataSet[] {removeParam, saveParam};

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.MultipleExecuteNonQueryTx(procedure, param);
                    this.MsgCodeAlert("COM-00902");
                    Search();
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {

            }
        }

        /// <summary>
        /// Excel_Import(엑셀 업로드 버튼 클릭시)
        /// </summary>
        private void Excel_Import()
        {
            try
            {
                if (!fud02_FILEID1.HasFile)
                {
                    this.MsgCodeAlert("SRMQA00-0050");
                    return;
                }

                if (!IsQueryValidation()) return;

                //파일을 서버에 임시 저장
                string fname = System.Guid.NewGuid().ToString().Replace("-", string.Empty);

                //크롭 브라우저는 fud02_FILEID1.FileName시 파일명만 리턴.
                //IE는 fud02_FILEID1.FileName 시 경로포함한 파일명 리턴함.
                //그래서, System.IO.Path.GetFileName()를 이용하여 파일명만 가져온다.
                string fileName = EPAppSection.ToString("SERVER_TEMP_PATH") + fname + "_" + System.IO.Path.GetFileName(fud02_FILEID1.FileName);

                fud02_FILEID1.PostedFile.SaveAs(fileName);

                //저장된 파일로부터 데이터 읽어와서 DataTable생성(엑셀파일의 첫번째 줄의 헤더명이 컬럼명으로 지정되어 있음)
                DataTable dtUpload = ExcelHelper.XlsToDataTable(fileName, "", "YES", "1");

                //최초 만들어진 dtUpload의 컬럼명은 한글이므로 db에 맞는 컬럼명으로 변경해주기 위해
                //Grid02그리드로부터 DataIndex값 읽어와서 새로운 테이블 만들고 
                //엑셀로부터 읽어온 내용을 그대로 import함.
                DataTable dtTemp = new DataTable();
                for (int i = 0; i < Grid01.ColumnModel.Columns.Count; i++)
                {
                    dtTemp.Columns.Add(Grid01.ColumnModel.Columns[i].DataIndex);
                }
                for (int i = 0; i < dtUpload.Rows.Count; i++)
                {
                    DataRow dr = dtUpload.Rows[i];
                    DataRow drNew = dtTemp.NewRow();
                    if (!dr[0].ToString().Equals(string.Empty))
                    {
                        //for (int c = 0; c < dtUpload.Columns.Count; c++)
                        for (int c = 0; c < 7; c++)
                        {
                            drNew[c] = dr[c];
                        }
                        dtTemp.Rows.Add(drNew);
                    }
                }

                dtTemp.Columns[1].ColumnName = "VINCD";
                dtTemp.Columns[2].ColumnName = "PARTNO";
                dtTemp.Columns[3].ColumnName = "PARTNM";
                dtTemp.Columns[4].ColumnName = "STANDARD";
                dtTemp.Columns[5].ColumnName = "UNIT";
                dtTemp.Columns[6].ColumnName = "QTY";


                //대상건수/수행건수 표시
                this.txt01_ROWCNT_EXCEL.Text = dtTemp.Rows.Count.ToString();
                this.txt01_ROWCNT_ADDED.Text = "0";

                //저장하지 않고 그리드 바안딩
                //DataSet srcDs = this.getDataSet();
                //DataTable dt = srcDs.Tables[0];
                //for (int i = 0; i < dtTemp.Rows.Count; i++)
                //{
                //    DataRow[] dr = dt.Select("PARTNO='" + dtTemp.Rows[i]["PARTNO"].ToString() + "'");

                //    if (dr.Length > 0) dr[0]["OK_INV_QTY"] = dtTemp.Rows[i]["QTY"];
                //}
                //this.Store1.RemoveAll();
                //this.Store1.DataSource = srcDs.Tables[0];
                //this.Store1.DataBind();

                //삭제용 데이터셋 생성
                DataSet remove = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "CUSTCD", "INV_DATE", "PARTNO", "INV_INSPECTNO", "LANG_SET", "USER_ID"
                );

                //저장용 데이터셋 생성
                DataSet save = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "CUSTCD", "INV_DATE", //"STATUS_DIV", "MAT_TYPE", 제거2018.11.07
                   "PARTNO", "UNIT", "OK_INV_QTY", "MGRNM", "LANG_SET", "USER_ID"
                );

                //삭제 및 저장용 데이터 셋에 데이터 추가
                for (int i = 0; i < dtTemp.Rows.Count; i++)
                {
                    remove.Tables[0].Rows.Add
                    (
                        //dtTemp.Rows[i]["CORCD"],
                        //dtTemp.Rows[i]["BIZCD"],
                        //dtTemp.Rows[i]["VENDCD"],
                        //dtTemp.Rows[i]["ALCCD_O"],
                        //dtTemp.Rows[i]["PARTNO"]

                        Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , this.cdx01_CUSTCD.Value

                        , ((DateTime)this.df01_GETDATE.Value).ToString("yyyy-MM-dd")
                        //, this.GetDateText(this.df01_GETDATE, "yyyy-MM-dd")

                        , dtTemp.Rows[i]["PARTNO"]
                        , "-1"
                        , this.UserInfo.LanguageShort
                        , this.UserInfo.UserID
                    );

                    save.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , this.cdx01_CUSTCD.Value

                        , ((DateTime)this.df01_GETDATE.Value).ToString("yyyy-MM-dd")
                        //, this.GetDateText(this.df01_GETDATE, "yyyy-MM-dd")

                        //, this.cbo01_VEND_INV_DIV.Value
                        //, "EWB"   //가공전(EWB만 사용)
                        //, "EAR"
                        , dtTemp.Rows[i]["PARTNO"]
                        , dtTemp.Rows[i]["UNIT"]
                        , dtTemp.Rows[i]["QTY"] == "" ? "0" : dtTemp.Rows[i]["QTY"]
                        , this.txt01_MGRNM.Value
                        , this.UserInfo.LanguageShort
                        , this.UserInfo.UserID
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid(save.Tables[0].Rows[i], i + 1))
                    {
                        return;
                    }
                }

                if (save.Tables[0].Rows.Count > 0)
                {
                    this.Save1(remove, save);
                    this.txt01_ROWCNT_ADDED.Text = save.Tables[0].Rows.Count.ToString();
                }

                //작업완료한 후 임시 파일 삭제.
                if (System.IO.File.Exists(fileName))
                    System.IO.File.Delete(fileName);

            }
            catch (Exception ex)
            {
                this.txt01_ROWCNT_ADDED.Text = "0";
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {

            }
        }

        /// <summary>
        /// SaveAndDelete
        /// 저장(업데이트)
        /// </summary>
        /// <param name="actionType"></param>
        public void Save1(DataSet remove, DataSet save)
        {

            try
            {
                string[] procedure;
                DataSet[] param;
                if (remove == null)
                {
                    procedure = new string[] { string.Format("{0}.{1}", pakageName, "SAVE_IMPORT") };
                    param = new DataSet[] { save };
                }
                else
                {
                    procedure = new string[] { string.Format("{0}.{1}", pakageName, "REMOVE_IMPORT"),
                                                string.Format("{0}.{1}", pakageName, "SAVE_IMPORT")};
                    param = new DataSet[] { remove,
                                            save };
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.MultipleExecuteNonQueryTx(procedure, param);

                    this.MsgCodeAlert("COM-00902");
                    Search();
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {

            }
        }

        /// <summary>
        /// 양식다운로드
        /// </summary>
        private void Excel()
        {
            try
            {
                DataTable result = new DataTable();
                result = getDataSet().Tables[0];

                DataTable dtTemp = new DataTable();
                for (int i = 0; i < Grid01.ColumnModel.Columns.Count; i++)
                {
                    dtTemp.Columns.Add(Grid01.ColumnModel.Columns[i].DataIndex);
                }

                for (int i = 0; i < result.Rows.Count; i++)
                {
                    DataRow dr = result.Rows[i];
                    DataRow drNew = dtTemp.NewRow();
                    if (!dr[0].ToString().Equals(string.Empty))
                    {
                        for (int c = 0; c < result.Columns.Count; c++)
                        {
                            if (result.Columns[c].ColumnName.Equals("PARTNO"))
                                drNew[0] = dr[c];
                            else if (result.Columns[c].ColumnName.Equals("PARTNM"))
                                drNew[1] = dr[c];
                            else if (result.Columns[c].ColumnName.Equals("QTY"))
                                drNew[2] = dr[c];
                        }
                        dtTemp.Rows.Add(drNew);
                    }
                }

                DataSet ds = new DataSet();
                DataRow row = dtTemp.NewRow();
                row[0] = "A0A : ASS'Y         A0M : MATERIALS";
                row[1] = "";
                row[2] = "";

                dtTemp.Rows.InsertAt(row, 0);

                ds.Tables.Add(dtTemp);

                if (dtTemp == null) return;

                string tmpFileName = DateTime.Now.ToString("yyyy-MM-dd HHmmss");

                if (dtTemp.Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                {
                    string MyDocumentsPath = System.Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
                    string TargetFilename = System.IO.Path.Combine(MyDocumentsPath, "Sample.xls");

                    // 폴더가 존재하지 않는다면 폴더를 생성한다.
                    if (!System.IO.Directory.Exists("C:\\downloaded_SCM_Files"))
                        System.IO.Directory.CreateDirectory("C:\\downloaded_SCM_Files");

                    // 파일이 저장될 위치를 저장한다.
                    string ExcelFilePath = String.Format("C:\\downloaded_SCM_Files\\{0}", "SCM_MM26002(" + tmpFileName + ").xlsx");

                    CreateExcelFile.CreateExcelDocument(ds, "Basic Inventory Management(" + tmpFileName + ").xlsx", this.Response);

                    if (CreateExcelFile.CreateExcelDocument(ds, "Sample.xlsx", this.Response))
                    {
                        MsgCodeAlert_ShowFormat("SCMMM-0023", new string[] { "Sample.xlsx" });
                    }
                    else
                    {
                        //MsgCodeAlert_ShowFormat("SCMMM-0023", new string[] { MyDocumentsPath });
                        throw new System.Exception();
                    }

                    ExportGridToExcel(dtTemp, "SCM_MM26002(" + tmpFileName + ")", "xls");
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {

            }
        }


        public void ExportGridToExcel(DataTable Tbl, string fileName, string type)
        {
            try
            {
                if (Tbl == null || Tbl.Columns.Count == 0) throw new Exception("ExportToExcel: Null or empty input table!\n");

                Microsoft.Office.Interop.Excel.Application excelApp = new Microsoft.Office.Interop.Excel.Application();
                Microsoft.Office.Interop.Excel.Worksheet workSheet;
                Microsoft.Office.Interop.Excel.Workbook currentWorkbook;

                excelApp.Visible = false;
                currentWorkbook = excelApp.Workbooks.Add(true);
                workSheet = (Microsoft.Office.Interop.Excel.Worksheet)currentWorkbook.ActiveSheet;

                // single worksheet
                //Microsoft.Office.Interop.Excel.Workbook currentWorkbook = excelApp.Workbooks.Add(Type.Missing);
                //Excel._Worksheet workSheet = currentWorkbook.ActiveSheet;


                // column headings
                for (int i = 0; i < Tbl.Columns.Count; i++)
                {
                    workSheet.Cells[1, (i + 1)] = Tbl.Columns[i].ColumnName;
                }

                // rows
                for (int i = 0; i < Tbl.Rows.Count; i++)
                {
                    // to do: format datetime values before printing
                    for (int j = 0; j < Tbl.Columns.Count; j++)
                    {
                        workSheet.Cells[(i + 2), (j + 1)] = Tbl.Rows[i][j];
                    }
                }

                // 폴더가 존재하지 않는다면 폴더를 생성한다.
                if (!System.IO.Directory.Exists("C:\\downloaded_SCM_Files"))
                    System.IO.Directory.CreateDirectory("C:\\downloaded_SCM_Files");

                // 파일이 저장될 위치를 저장한다.
                string ExcelFilePath = String.Format("C:\\downloaded_SCM_Files\\{0}", fileName);


                // check fielpath
                if (ExcelFilePath != null && ExcelFilePath != "")
                {
                    try
                    {

                        //workSheet.SaveAs(ExcelFilePath, (type.Equals("xls") ? Microsoft.Office.Interop.Excel.XlFileFormat.xlWorkbookNormal : Microsoft.Office.Interop.Excel.XlFileFormat.xlWorkbookDefault)
                        //    , System.Reflection.Missing.Value, Missing.Value, false, false, Microsoft.Office.Interop.Excel.XlSaveAsAccessMode.xlNoChange, Microsoft.Office.Interop.Excel.XlSaveConflictResolution.xlUserResolution, true, Missing.Value, Missing.Value, Missing.Value);
                        currentWorkbook.SaveAs(
                            ExcelFilePath
                            , (type.Equals("xls") ? Microsoft.Office.Interop.Excel.XlFileFormat.xlWorkbookNormal : Microsoft.Office.Interop.Excel.XlFileFormat.xlWorkbookDefault)
                            , Missing.Value
                            , Missing.Value
                            , false
                            , false
                            , Microsoft.Office.Interop.Excel.XlSaveAsAccessMode.xlNoChange
                            , Microsoft.Office.Interop.Excel.XlSaveConflictResolution.xlUserResolution
                            , true
                            , Missing.Value
                            , Missing.Value
                            , Missing.Value
                            );
                        currentWorkbook.Saved = true;
                        excelApp.Quit();
                        MsgCodeAlert_ShowFormat("SCMMM-0023", new string[] { "C:\\downloaded_SCM_Files\\" + fileName });

                    }
                    catch (Exception ex)
                    {
                        throw new Exception("ExportToExcel: Excel file could not be saved! Check filepath.\n"
                            + ex.Message);
                    }
                }
                else    // no filepath is given
                {
                    excelApp.Visible = true;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("ExportToExcel: \n" + ex.Message);
            }
        }

        
        /// <summary>
        /// Excel_Export
        /// </summary>
        private void Excel_Export1()
        {
            try
            {
                DataSet result = getDataSet1();

                if (result == null) return;

                if (result.Tables[0].Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                {
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {

            }
        }

        /// <summary>
        /// Excel_Export
        /// </summary>
        private void Excel_Export()
        {
            try
            {
                DataSet result = getDataSet();

                if (result == null) return;

                if (result.Tables[0].Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                {
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {

            }
        } 

        #endregion

        #region [ 유효성 검사 ]

        /// <summary>
        /// Validation
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="actionType"></param>
        /// <param name="actionRow"></param>
        /// <remarks>actionRow 는 Grid 타일경우에만 사용한다.</remarks>
        /// <returns>bool</returns>
        public bool IsSaveValid(DataRow parameter, int actionRow = -1)
        {
            bool result = false;

            if (this.txt01_MGRNM.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_MGRNM", lbl01_REG_MGRNM.Text);
            }
            else
                result = true;

            return result;
        }

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {            
            // 조회용 Validation
            if (cbo01_VEND_INV_DIV.Value.ToString().Equals("EWB"))
            {
                if (this.cdx01_CUSTCD.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_CUSTCD", lbl01_CUST.Text);
                    return false;
                }
            }
            else
            {
                if (this.cdx01_VENDCD.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                    return false;
                }
            }

            if (this.df01_GETDATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_GETDATE", lbl01_INV_STD_DATE.Text);
                return  false;
            }
            return true;
        }

        #endregion
            
    }
}
