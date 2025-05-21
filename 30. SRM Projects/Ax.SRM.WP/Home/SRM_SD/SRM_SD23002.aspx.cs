#region ▶ Description & History
/* 
 * 프로그램명 : 생산협업 > 직납업체 모니터링 > ALC 마스터 등록
 * 설      명 : 
 * 최초작성자 : 배명희
 * 최초작성일 : 2014-09-01
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

    public partial class SRM_SD23002 : BasePage
    {
        private string pakageName = "APG_SRM_SD23002";

        #region [ 초기설정 ]

        /// <summary>
        /// SCM_SD23002
        /// </summary>
        public SRM_SD23002()
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
                    TextField_UpdateId.Text = this.UserInfo.UserID;
                    Library.GetBIZCD(this.SelectBox01_BIZCD, this.UserInfo.CorporationCode, false);

                    Reset();

                    // 코드 팝업을 띄우기 위해서 text에서 enter를 입력할 경우 팝업을 띄움, 현재는 aspx단에서 keymap으로 코딩되어있음.
                    //Util.SettingEnterKeyEvent(this, this.cdx01_PARTNO, this.btn01_PARTNO);


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
            MakeButton(ButtonID.Delete, ButtonImage.Delete, "Delete", this.ButtonPanel);
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
            else if (id.Equals(ButtonID.Delete)) // 삭제시 선택된 데이터만 삭제한다.
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly:true})", Mode = ParameterMode.Raw, Encode = true });
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
                    //Reset();
                    Search();
                    break;
                case ButtonID.Reset:
                    Reset();
                    break;
                case ButtonID.Save:
                    Save(sender, e);
                    break;
                case ButtonID.Delete:
                    Delete(sender, e);
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
                case "btn01_CUST_ITEMCD":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    HEParameterSet set = new HEParameterSet();
                    set.Add("BIZCD", this.SelectBox01_BIZCD.Value);
                    set.Add("VENDCD", this.cdx01_VENDCD.Value);
                    Util.HelpPopup(this, "HELP_CUST_ITEMCD", PopupHelper.HelpType.Search, "GRID_CUST_ITEMCD_HELP01", this.CodeValue.Text, this.NameValue.Text,  "", PopupHelper.defaultPopupWidth, PopupHelper.defaultPopupHeight,set);
                    break;

                default:
                    break;
            }
        }

        #endregion

        #region [ 기능 ]

        /// <summary>
        /// 조회
        /// </summary>
        public void Search()
        {
            try
            {
                //유효성 검사
                if (!IsSearchValid())
                {
                    return;
                }
                
                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

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
        /// 조회버튼 클릭시 데이터 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.SelectBox01_BIZCD.Value);            
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("PARTNO1", this.txt01_PARTNO1.Text.Equals(string.Empty) ? "0" : this.txt01_PARTNO1.Text);
            param.Add("PARTNO2", this.txt01_PARTNO2.Text.Equals(string.Empty) ? "Z" : this.txt01_PARTNO2.Text);
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// 엑셀다운로드용 데이터 조회(엑셀양식용)
        /// </summary>
        /// <returns></returns>
        private DataSet getExcelDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.SelectBox01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("PARTNO1", this.txt01_PARTNO1.Text.Equals(string.Empty) ? "0" : this.txt01_PARTNO1.Text);
            param.Add("PARTNO2", this.txt01_PARTNO2.Text.Equals(string.Empty) ? "Z" : this.txt01_PARTNO2.Text);
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_EXCEL"), param);
        }

        /// <summary>
        /// Excel_Export(엑셀 다운로드 버튼 클릭시)
        /// </summary>
        private void Excel_Export()
        {
            try
            {
                //엑셀 익스포트용 양식이 별도로 있음. 엑셀 내보내기 양식용 그리드==> GRID02
                DataSet result = getExcelDataSet();

                if (result == null) return;

                //if (result.Tables[0].Rows.Count == 0)
                //    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                //else
                ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid02);
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
                string fname =  System.Guid.NewGuid().ToString().Replace("-", string.Empty);
                
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
                   "CORCD", "BIZCD", "VENDCD", "ALCCD", "PARTNO"
                );

                //저장용 데이터셋 생성
                DataSet save = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "VENDCD", "ALCCD", "PARTNO", "CUST_ITEMCD", "WORK_DIR_DIV",
                   "BEG_DATE", "END_DATE", "USAGE", "VINCD", "CUSTCD", "UPDATE_ID"
                );
            
                //삭제 및 저장용 데이터 셋에 데이터 추가
                for (int i = 0; i < dtTemp.Rows.Count; i++)
                {
                    remove.Tables[0].Rows.Add
                    (
                        dtTemp.Rows[i]["CORCD"],
                        dtTemp.Rows[i]["BIZCD"],
                        dtTemp.Rows[i]["VENDCD"],
                        dtTemp.Rows[i]["ALCCD_O"],
                        dtTemp.Rows[i]["PARTNO"]
                    );

                    save.Tables[0].Rows.Add
                    (
                        dtTemp.Rows[i]["CORCD"]
                        , dtTemp.Rows[i]["BIZCD"]
                        , dtTemp.Rows[i]["VENDCD"]
                        , dtTemp.Rows[i]["ALCCD"]
                        , dtTemp.Rows[i]["PARTNO"]
                        , dtTemp.Rows[i]["CUST_ITEMCD"]
                        , "CA" + dtTemp.Rows[i]["WORK_DIR_DIV"].ToString()
                        , (dtTemp.Rows[i]["BEG_DATE"].ToString() == string.Empty ? string.Empty : DateTime.Parse(dtTemp.Rows[i]["BEG_DATE"].ToString()).ToString("yyyy-MM-dd"))
                        , (dtTemp.Rows[i]["END_DATE"].ToString() == string.Empty ? string.Empty : DateTime.Parse(dtTemp.Rows[i]["END_DATE"].ToString()).ToString("yyyy-MM-dd"))
                        , dtTemp.Rows[i]["USAGE"]
                        , "A3" + dtTemp.Rows[i]["VINCD"].ToString()
                        , dtTemp.Rows[i]["CUSTCD"]
                        , this.UserInfo.UserID
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid(save.Tables[0].Rows[i], i+1))
                    {
                        return;
                    }
                }

                if (save.Tables[0].Rows.Count > 0)
                {
                    this.Save(remove, save);
                    this.txt01_ROWCNT_ADDED.Text = save.Tables[0].Rows.Count.ToString();
                }

                //작업완료한 후 임시 파일 삭제.
                if(System.IO.File.Exists(fileName))
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
        /// Reset
        /// </summary>
        public void Reset()
        {
            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }
            this.txt01_PARTNO1.Text = string.Empty;
            this.txt01_PARTNO2.Text = string.Empty;

            this.SelectBox01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.SelectBox01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cdx01_VINCD.SetValue(string.Empty);

            this.fud02_FILEID1.Reset();
            this.txt01_ROWCNT_EXCEL.Text = string.Empty;
            this.txt01_ROWCNT_ADDED.Text = string.Empty;

            this.Store1.RemoveAll();
        }

        /// <summary>
        /// SaveAndDelete
        /// 저장(업데이트)
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(DataSet remove, DataSet save)
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
        /// 저장버튼 클릭시
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

                DataSet remove = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "VENDCD", "ALCCD", "PARTNO"
                );


                DataSet save = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "VENDCD", "ALCCD", "PARTNO", "CUST_ITEMCD", "WORK_DIR_DIV", 
                   "BEG_DATE", "END_DATE", "USAGE", "VINCD", "CUSTCD", "UPDATE_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    remove.Tables[0].Rows.Add
                    (
                        parameters[i]["CORCD_O"],
                        parameters[i]["BIZCD_O"],
                        parameters[i]["VENDCD"],
                        parameters[i]["ALCCD_O"],
                        parameters[i]["PARTNO_O"]
                    );

                    save.Tables[0].Rows.Add
                    (
                        parameters[i]["CORCD"]
                        , parameters[i]["BIZCD"]
                        , parameters[i]["VENDCD"]
                        , parameters[i]["ALCCD"]
                        , parameters[i]["PARTNO"]
                        , parameters[i]["CUST_ITEMCD"]
                        , parameters[i]["WORK_DIR_DIV"]
                        , (parameters[i]["BEG_DATE"] == null ? "" : DateTime.Parse(parameters[i]["BEG_DATE"]).ToString("yyyy-MM-dd"))
                        , (parameters[i]["END_DATE"] == null ? "" : DateTime.Parse(parameters[i]["END_DATE"]).ToString("yyyy-MM-dd"))
                        , parameters[i]["USAGE"]
                        , parameters[i]["VINCD"]
                        , parameters[i]["CUSTCD"]
                        , this.UserInfo.UserID
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsSaveValid(save.Tables[0].Rows[i], Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }

                this.Save(remove, save);
               
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
        /// 삭제버튼 클릭시
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void Delete(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    this.MsgCodeAlert("COM-00100");//선택된 Row가 없습니다. 확인 바랍니다.
                    return;
                }

                DataSet remove = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "VENDCD", "ALCCD", "PARTNO"
                );
            
                for (int i = 0; i < parameters.Length; i++)
                {
                    remove.Tables[0].Rows.Add
                    (
                        parameters[i]["CORCD_O"],
                        parameters[i]["BIZCD_O"],
                        parameters[i]["VENDCD"],
                        parameters[i]["ALCCD_O"],
                        parameters[i]["PARTNO_O"]
                    );
                   
                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                    if (!IsDeleteValid(remove.Tables[0].Rows[i], Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }

                // 선택된 데이터가 없을경우
                if (remove.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert("COM-00100");//선택된 Row가 없습니다. 확인 바랍니다.
                    return;
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE"), remove);
                    this.MsgCodeAlert("COM-00903");
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
        public bool IsSaveValid(DataRow parameter, int actionRow)
        {
            bool result = false;
            if (cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("COM-00906", "cdx01_VENDCD", lbl01_VEND.Text);
                return result;
            }

            //COM-00904 : {0}번째 행의 {1}를(을) 입력해주세요.
            if (String.IsNullOrEmpty(parameter["CORCD"].ToString()) || parameter["CORCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "CORCD"));               
          
            else if (String.IsNullOrEmpty(parameter["BIZCD"].ToString()) || parameter["BIZCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "BIZCD"));

            else if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "VENDCD"));

            else if (String.IsNullOrEmpty(parameter["ALCCD"].ToString()) || parameter["ALCCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "ALCCD"));

            else if (String.IsNullOrEmpty(parameter["PARTNO"].ToString()) || parameter["PARTNO"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "PARTNO"));

            else if (String.IsNullOrEmpty(parameter["BEG_DATE"].ToString()) || parameter["BEG_DATE"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "BEG_DATE"));

            else if (String.IsNullOrEmpty(parameter["CUST_ITEMCD"].ToString()) || parameter["CUST_ITEMCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "CUST_ITEMCD"));

            else if (String.IsNullOrEmpty(parameter["WORK_DIR_DIV"].ToString()) || parameter["WORK_DIR_DIV"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "WORK_DIR_DIV"));

            else
                result = true;
           
            return result;
        }

        /// <summary>
        /// 삭제용 validation
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="actionRow"></param>
        /// <returns></returns>
        public bool IsDeleteValid(DataRow parameter, int actionRow = -1)
        {
            bool result = false;
            if (cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("COM-00906", "cdx01_VENDCD", lbl01_VEND.Text);
                return result;
            }
            
            // 삭제용 Validation           
            //COM-00905 : 해당 내역은 신규 데이터이므로 삭제할 수 없습니다.
            //COM-00904 : {0}번째 행의 {1}를(을) 입력해주세요.
            if (String.IsNullOrEmpty(parameter["CORCD"].ToString()) || parameter["CORCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "CORCD"));

            else if (String.IsNullOrEmpty(parameter["BIZCD"].ToString()) || parameter["BIZCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "BIZCD"));

            else if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "VENDCD"));

            else if (String.IsNullOrEmpty(parameter["ALCCD"].ToString()) || parameter["ALCCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "ALCCD"));

            else if (String.IsNullOrEmpty(parameter["PARTNO"].ToString()) || parameter["PARTNO"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "PARTNO"));

            else
                result = true;
            
            return result;
        }

        /// <summary>
        /// 조회시 필수 입력 체크
        /// </summary>
        /// <returns></returns>
        public bool IsSearchValid()
        {
            bool result = false;

            //서연이화 내부 직원인 경우에는 필수 입력 체크 안함.
            //외부 협력업체인 경우에는 업체코드 필수 입력.
            if (this.UserInfo.UserDivision.Equals("T12")) 
                result = true;

            else
            {
                if (this.cdx01_VENDCD.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00906", "cdx01_VENDCD", lbl01_VEND.Text);
                    result = false;
                }
                else
                {
                    result = true;
                }
            }
        

            return result;
        }

        #endregion
    }
}
