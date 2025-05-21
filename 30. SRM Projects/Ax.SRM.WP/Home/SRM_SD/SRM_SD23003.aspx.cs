#region ▶ Description & History
/* 
 * 프로그램명 : 물류모니터링(구.VP5030)
 * 설      명 : 생산협업 > 직납업체 모니터링 > 물류모니터링
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-21
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

namespace Ax.SRM.WP.Home.SRM_SD
{
    public partial class SRM_SD23003 : BasePage
    {
        private string pakageName = "APG_SRM_SD23003";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SCM_SD23003
        /// </summary>
        public SRM_SD23003()
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
                case ButtonID.Upload:
                    Excel_Import();
                    break;
                case ButtonID.ExcelDL:
                    Excel_Export();
                    break;
                case ButtonID.Close:
                    X.Js.Call("closeTab");
                    break;
                default: break;
            }
        }

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
                    Excel();
                    break;

                default:
                    break;
            }
        }

        #endregion

        #region [ 기능 ]

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
            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
                this.cdx01_CUSTCD.SetValue(string.Empty);
            }

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_PLAN_DATE.SetValue(DateTime.Now);

            this.cbo01_PLANTCD.SelectedItem.Value = "";
            this.cbo01_PLANTCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.fud02_FILEID1.Reset();
            this.txt01_ROWCNT_EXCEL.Text = string.Empty;
            this.txt01_ROWCNT_ADDED.Text = string.Empty;

            this.Store1.RemoveAll();

            changeCondition(null, null);
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
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("CUSTCD", this.cdx01_CUSTCD.Value);
            param.Add("PLANTCD", this.cbo01_PLANTCD.Value);
            param.Add("PLAN_DATE", ((DateTime)this.df01_PLAN_DATE.Value).ToString("yyyy-MM-dd"));            
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
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
                   "CORCD", "BIZCD", "VENDCD", "CUSTCD", "PLANTCD", "PARTNO", "OUT_DATE", "LANG_SET", "USER_ID"
                );
        
                DataSet saveParam = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "OUT_DATE", "VENDCD", "CUSTCD", "PLANTCD", "PARTNO", "VEND_INV_QTY", "WH_INV_QTY", "CUST_INV_QTY",
                   "PLAN_QTY1", "PLAN_QTY2", "PLAN_QTY3", "PLAN_QTY4", "PLAN_QTY5", "PLAN_QTY6", "PLAN_QTY7", "PLAN_QTY8", "PLAN_QTY9", "PLAN_QTY10",
                   "REMARK", "LANG_SET", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    removeParam.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , this.cdx01_VENDCD.Value
                        , this.cdx01_CUSTCD.Value
                        , this.cbo01_PLANTCD.Value
                        , parameters[i]["PARTNO"]
                        , ((DateTime)this.df01_PLAN_DATE.Value).ToString("yyyy-MM-dd")
                        , this.UserInfo.LanguageShort
                        , this.UserInfo.UserID
                    );

                    saveParam.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , ((DateTime)this.df01_PLAN_DATE.Value).ToString("yyyy-MM-dd")
                        , this.cdx01_VENDCD.Value
                        , this.cdx01_CUSTCD.Value
                        , this.cbo01_PLANTCD.Value
                        , parameters[i]["PARTNO"]
                        , parameters[i]["VEND_INV_QTY"] == "" ? "0" : parameters[i]["VEND_INV_QTY"]
                        , parameters[i]["WH_INV_QTY"] == "" ? "0" : parameters[i]["WH_INV_QTY"]
                        , parameters[i]["CUST_INV_QTY"] == "" ? "0" : parameters[i]["CUST_INV_QTY"]
                        , parameters[i]["PLAN_QTY1"] == "" ? "0" : parameters[i]["PLAN_QTY1"]
                        , parameters[i]["PLAN_QTY2"] == "" ? "0" : parameters[i]["PLAN_QTY2"]
                        , parameters[i]["PLAN_QTY3"] == "" ? "0" : parameters[i]["PLAN_QTY3"]
                        , parameters[i]["PLAN_QTY4"] == "" ? "0" : parameters[i]["PLAN_QTY4"]
                        , parameters[i]["PLAN_QTY5"] == "" ? "0" : parameters[i]["PLAN_QTY5"]
                        , parameters[i]["PLAN_QTY6"] == "" ? "0" : parameters[i]["PLAN_QTY6"]
                        , parameters[i]["PLAN_QTY7"] == "" ? "0" : parameters[i]["PLAN_QTY7"]
                        , parameters[i]["PLAN_QTY8"] == "" ? "0" : parameters[i]["PLAN_QTY8"]
                        , parameters[i]["PLAN_QTY9"] == "" ? "0" : parameters[i]["PLAN_QTY9"]
                        , parameters[i]["PLAN_QTY10"] == "" ? "0" : parameters[i]["PLAN_QTY10"]
                        , ""
                        , this.UserInfo.LanguageShort
                        , this.UserInfo.UserID
                    );
                   
                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid(saveParam.Tables[0].Rows[i], Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }

                //저장
                this.Regist(removeParam, saveParam);

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
        /// SaveAndDelete
        /// 저장(업데이트)
        /// </summary>
        /// <param name="actionType"></param>
        public void Regist(DataSet remove, DataSet save)
        {
            try
            {
                string[] procedure;
                DataSet[] param;
                if (remove == null)
                {
                    procedure = new string[] { string.Format("{0}.{1}", pakageName, "SAVE") };
                    param = new DataSet[] { save };
                }
                else
                {
                    procedure = new string[] { string.Format("{0}.{1}", pakageName, "REMOVE"),
                                                string.Format("{0}.{1}", pakageName, "SAVE")};
                    param = new DataSet[] { remove, save };
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

        /// <summary>
        /// 양식다운로드
        /// </summary>
        private void Excel()
        {
            try
            {
                DataSet result = getDataSet();

                if (result == null) return;

                if (result.Tables[0].Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                {
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid02);                   
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
        /// Excel_Import(엑셀 업로드 버튼 클릭시)
        /// </summary>
        private void Excel_Import()
        {
            try
            {
                if (!fud02_FILEID1.HasFile) return;

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
                for (int i = 0; i < Grid02.ColumnModel.Columns.Count; i++)
                {
                    dtTemp.Columns.Add(Grid02.ColumnModel.Columns[i].DataIndex);
                }
                for (int i = 0; i < dtUpload.Rows.Count; i++)
                {
                    DataRow dr = dtUpload.Rows[i];
                    DataRow drNew = dtTemp.NewRow();
                    if (!dr[0].ToString().Equals(string.Empty))
                    {
                        for (int c = 0; c < dtUpload.Columns.Count; c++)
                        {
                            drNew[c] = dr[c];
                        }
                        dtTemp.Rows.Add(drNew);
                    }
                }

                //대상건수/수행건수 표시
                this.txt01_ROWCNT_EXCEL.Text = dtTemp.Rows.Count.ToString();
                this.txt01_ROWCNT_ADDED.Text = "0";

                //삭제용 데이터셋 생성
                DataSet remove = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "VENDCD", "CUSTCD", "PLANTCD", "PARTNO", "OUT_DATE", "LANG_SET", "USER_ID"
                );

                //저장용 데이터셋 생성
                DataSet save = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "OUT_DATE", "VENDCD", "CUSTCD", "PLANTCD", "PARTNO", "VEND_INV_QTY", "WH_INV_QTY", "CUST_INV_QTY",
                   "PLAN_QTY1", "PLAN_QTY2", "PLAN_QTY3", "PLAN_QTY4", "PLAN_QTY5", "PLAN_QTY6", "PLAN_QTY7", "PLAN_QTY8", "PLAN_QTY9", "PLAN_QTY10",
                   "REMARK", "LANG_SET", "USER_ID"
                );

                
                for (int i = 0; i < dtTemp.Rows.Count; i++)
                {
                    //삭제 및 저장용 데이터 셋에 데이터 추가
                    remove.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , this.cdx01_VENDCD.Value
                        , this.cdx01_CUSTCD.Value
                        , this.cbo01_PLANTCD.Value
                        , dtTemp.Rows[i]["PARTNO"]
                        , ((DateTime)this.df01_PLAN_DATE.Value).ToString("yyyy-MM-dd")
                        , this.UserInfo.LanguageShort
                        , this.UserInfo.UserID
                    );

                    save.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , ((DateTime)this.df01_PLAN_DATE.Value).ToString("yyyy-MM-dd")
                        , this.cdx01_VENDCD.Value
                        , this.cdx01_CUSTCD.Value
                        , this.cbo01_PLANTCD.Value
                        , dtTemp.Rows[i]["PARTNO"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["VEND_INV_QTY"].ToString()) ? "0" : dtTemp.Rows[i]["VEND_INV_QTY"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["WH_INV_QTY"].ToString())  ? "0" : dtTemp.Rows[i]["WH_INV_QTY"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["CUST_INV_QTY"].ToString())  ? "0" : dtTemp.Rows[i]["CUST_INV_QTY"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["PLAN_QTY1"].ToString())  ? "0" : dtTemp.Rows[i]["PLAN_QTY1"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["PLAN_QTY2"].ToString())  ? "0" : dtTemp.Rows[i]["PLAN_QTY2"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["PLAN_QTY3"].ToString())  ? "0" : dtTemp.Rows[i]["PLAN_QTY3"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["PLAN_QTY4"].ToString())  ? "0" : dtTemp.Rows[i]["PLAN_QTY4"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["PLAN_QTY5"].ToString())  ? "0" : dtTemp.Rows[i]["PLAN_QTY5"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["PLAN_QTY6"].ToString())  ? "0" : dtTemp.Rows[i]["PLAN_QTY6"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["PLAN_QTY7"].ToString())  ? "0" : dtTemp.Rows[i]["PLAN_QTY7"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["PLAN_QTY8"].ToString())  ? "0" : dtTemp.Rows[i]["PLAN_QTY8"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["PLAN_QTY9"].ToString())  ? "0" : dtTemp.Rows[i]["PLAN_QTY9"]
                        , String.IsNullOrEmpty(dtTemp.Rows[i]["PLAN_QTY10"].ToString()) ? "0" : dtTemp.Rows[i]["PLAN_QTY10"]
                        , ""
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
                    this.Regist(remove, save);
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

            //if (this.cdx01_VENDCD.IsEmpty)
            //    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
            if (this.cdx01_CUSTCD.IsEmpty)
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_CUST.Text);
            else if (this.cbo01_PLANTCD.IsEmpty)
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PLANTCD", lbl01_VEND_PLANT.Text);
            else if (this.df01_PLAN_DATE.IsEmpty)
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_PLAN_DATE", lbl01_SHIP_DATE.Text);
            //COM-00904 : {0}번째 행의 {1}를(을) 입력해주세요.
            else if (String.IsNullOrEmpty(parameter["PARTNO"].ToString()) || parameter["PARTNO"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "PARTNO"));
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
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.df01_PLAN_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_PLAN_DATE", lbl01_SHIP_DATE.Text);
                return  false;
            }
            if (this.cdx01_CUSTCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_CUSTCD", lbl01_CUST.Text);
                return false;
            }
            if (this.cbo01_PLANTCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PLANTCD", lbl01_VEND_PLANT.Text);
                return false;
            }
            return true;
        }

        #endregion

        #region [ 이벤트 ]

        public void changeCondition(object sender, DirectEventArgs e)
        {
            try
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.Value);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);

                DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PLANTCD"), param);

                Library.ComboDataBind(this.cbo01_PLANTCD, source.Tables[0], false, "CDNM", "CD", false);
            }
            catch
            {
            }
        }

        /*
        public void cdx01_CUSTCD_AfterValidation(object sender, DirectEventArgs e)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("GROUPCD", "SD016");
            param.Add("MAPPINGCD", this.cdx01_CUSTCD.Value);
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PLANTCD"), param);

            Library.ComboDataBind(this.cbo01_PLANTCD, source.Tables[0], false, "CDNM", "CD", true);
        }
        */
        #endregion

    }
}
