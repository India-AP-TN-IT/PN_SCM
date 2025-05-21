#region ▶ Description & History
/* 
 * 프로그램명 : 납품실적등록(구.VP2070)
 * 설      명 : 생산협업 > 납품실적관리 > 납품실적등록
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-10-10
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
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_SD
{
    public partial class SRM_SD22001 : BasePage
    {
        private string pakageName = "APG_SRM_SD22001";

        #region [ 초기설정 ]

        /// <summary>
        /// SCM_SD22001
        /// </summary>
        public SRM_SD22001()
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
                    this.SetCustCombo();

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

        #endregion

        #region [ 기능 ]

        private void SetCustCombo()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("GROUPCD", "SD014");
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_MM30002", "INQUERY_CODE"), param);

            Library.ComboDataBind(this.cbo01_CUST_COR, source.Tables[0], false, "CDNM", "CD", true);
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
            //업체코드는 서연이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_STD_DATE.SetValue(DateTime.Now);

            this.cbo01_CUST_COR.SelectedItem.Value = "M01";
            this.cbo01_CUST_COR.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_CUST_COR.ReadOnly = true;

            this.hid01_CUSTCD.Text = "10019"; //모비스  

            this.fud02_FILEID1.Reset();
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
            param.Add("VENDCD", this.hid01_CUSTCD.Text);
            param.Add("STD_DATE", ((DateTime)this.df01_STD_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("DOCCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
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
                    //ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01); 
                    //엑셀 업로드를 위해 업로드 양식에 맞게 다운로드 하기 위해 
                    //보이지 않는 그리드로 데이터 표시하여 다운로드 처리함.
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
                   "CORCD", "BIZCD", "VENDCD", "STD_DATE", "DOCCD", "LANG_SET", "USER_ID"
                );

                //저장용 데이터셋 생성
                DataSet save = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "VENDCD", "STD_DATE", "DOCCD", "DELI_PART", "REG_PART", "PLAN_PART",
                   "PARTNO", "PARTNM", "PONO", "DELI_DATE", "PO_QTY", "DELI_QTY", "PREV_DELI_DIV", "PREV_DELI_QTY",
                   "GRADE", "LEG_QUALITY", "ISS_DATE", "RCV_DATE", "RCV_QTY", "LANG_SET", "USER_ID"
                );

                //삭제 및 저장용 데이터 셋에 데이터 추가
                remove.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode
                    , this.cbo01_BIZCD.Value
                    , this.hid01_CUSTCD.Text
                    , ((DateTime)this.df01_STD_DATE.Value).ToString("yyyy-MM-dd")
                    , this.cdx01_VENDCD.Value
                    , this.UserInfo.LanguageShort
                    , this.UserInfo.UserID
                );

                for (int i = 0; i < dtTemp.Rows.Count; i++)
                {
                    save.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , this.hid01_CUSTCD.Text
                        , ((DateTime)this.df01_STD_DATE.Value).ToString("yyyy-MM-dd")
                        , this.cdx01_VENDCD.Value
                        , dtTemp.Rows[i]["DELI_PART"]
                        , dtTemp.Rows[i]["REG_PART"]
                        , dtTemp.Rows[i]["PLAN_PART"]
                        , dtTemp.Rows[i]["PARTNO"].ToString().Replace(" ", "-")
                        , dtTemp.Rows[i]["PARTNM"]
                        , dtTemp.Rows[i]["PONO"]
                        , dtTemp.Rows[i]["DELI_DATE"].ToString().Replace("-", "")
                        , dtTemp.Rows[i]["PO_QTY"]
                        , dtTemp.Rows[i]["DELI_QTY"]
                        , dtTemp.Rows[i]["PREV_DELI_DIV"]
                        , dtTemp.Rows[i]["PREV_DELI_QTY"]
                        , dtTemp.Rows[i]["GRADE"]
                        , dtTemp.Rows[i]["LEG_QUALITY"]
                        , dtTemp.Rows[i]["ISS_DATE"].ToString().Replace("-", "")
                        , dtTemp.Rows[i]["RCV_DATE"].ToString().Replace("-", "")
                        , dtTemp.Rows[i]["RCV_QTY"]
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
                    this.Save(remove, save);
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
            if (this.df01_STD_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("COM-00906", "df01_STD_DATE", lbl01_STD_DATE.Text);
                return result;
            }
            //COM-00904 : {0}번째 행의 {1}를(을) 입력해주세요.
            if (String.IsNullOrEmpty(parameter["CORCD"].ToString()) || parameter["CORCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "CORCD"));

            else if (String.IsNullOrEmpty(parameter["BIZCD"].ToString()) || parameter["BIZCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "BIZCD"));

            else if (String.IsNullOrEmpty(parameter["VENDCD"].ToString()) || parameter["VENDCD"].ToString().Trim().Equals(""))
                this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "VENDCD"));           

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
            if (this.df01_STD_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_STD_DATE", lbl01_STD_DATE.Text);
                return false;
            }
            return true;
        }

        #endregion

    }
}
