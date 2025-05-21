#region ▶ Description & History
/* 
 * 프로그램명 : 사급 직납 마감 등록 (구.VM4070)
 * 설      명 : 자재관리 > 사급관리 > 사급 직납 마감 등록
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

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM26007 : BasePage
    {
        private string pakageName = "APG_SRM_MM26007";
        //DataSet _ds = null;
        DateTime _dtWorkDate = new DateTime();
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM26007
        /// </summary>
        public SRM_MM26007()
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

                    DataTable source = Library.GetTypeCode("1A").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", false);
                    if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
                    {
                        this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                    }
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

                    HEParameterSet param = new HEParameterSet();
                    param.Add("LANG_SET", this.UserInfo.LanguageShort);

                    //source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_MM26006", "INQUERY_COMBO"), param).Tables[0];
                    DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_COMBO"), param, "OUT_CURSOR", "OUT_CURSOR2");

                    Library.ComboDataBind(this.cbo02_UNIT, ds.Tables[0].DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo02_UNIT.UpdateSelectedItems(); //꼭 해줘야한다.

                    Library.ComboDataBind(this.cbo01_NORMAL_RTN, ds.Tables[1].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_NORMAL_RTN.UpdateSelectedItems(); //꼭 해줘야한다.

                    Reset();

                    //해당월 마감일 표시
                    //changeCondition(null, null);
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
            //MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
            MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
            MakeButton(ButtonID.Close, ButtonImage.Close, "Close", this.ButtonPanel);
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
                ibtn.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                ibtn.DirectEvents.Click.Confirmation.Title = "Confirm";
                ibtn.DirectEvents.Click.Confirmation.Message = "Do you want save?";

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
                //case ButtonID.Print:
                //    Print();
                //    break;
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
        public void etc_Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_CONFIRM_P":
                    Confirm(sender, e);
                    break;
                case "btn01_CONFIRM_C":
                    Cancel(sender, e);
                    break;
                case "btn02_SAPIF":
                    Process(sender, e);
                    break;
                default:
                    break;
            }
        }

        #endregion

        #region [ 기능 ]
        public void Confirm(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                      "CORCD", "BIZCD", "STD_YYMM", "VENDCD", "PARTNO", "CUSTCD", "IO_DIV", "PURC_ORG", "PURC_OK", "USER_ID", "USER_NAME"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    if (!String.IsNullOrEmpty(parameter[i]["PURC_CON_NAME"]))
                    {
                        //{0}행은 SAP 확정되어 수정 불가합니다.
                        this.MsgCodeAlert_ShowFormat("SRMMM-0051", Convert.ToInt32(parameter[i]["NO"])); 
                        return;
                    }
                    
                    string VEND_OK = parameter[i]["VEND_OK"].ToString();
                    string CUST_OK = parameter[i]["CUST_OK"].ToString();

                    if(!VEND_OK.Equals("Y"))
                    {
                        //{0}행의 정보는 공급처에서 확인하지 않아 수정할 수 없습니다.
                        this.MsgCodeAlert_ShowFormat("SCMMM-0005", Convert.ToInt32(parameter[i]["NO"]));
                        return;
                    }

                    if (!CUST_OK.Equals("Y"))
                    {
                        //{0}행의 정보는 수요처에서 확인하지 않아 수정할 수 없습니다.
                        this.MsgCodeAlert_ShowFormat("SCMMM-0049", Convert.ToInt32(parameter[i]["NO"]));
                        return;
                    }
                    
                    param.Tables[0].Rows.Add(
                          Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM")
                        , parameter[i]["VENDCD"]
                        , parameter[i]["PARTNO"]
                        , parameter[i]["CUSTCD"]
                        , parameter[i]["IO_DIV"]
                        , this.cbo01_PURC_ORG.Value
                        , parameter[i]["PURC_OK"].ToString() == "Y" || parameter[i]["PURC_OK"].ToString() == "1" || parameter[i]["PURC_OK"].ToString() == "true" ? "Y" : "N"                        
                        , this.UserInfo.UserID
                        , this.UserInfo.UserName
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "CONFIRM"), param);
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

        public void Cancel(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                      "CORCD", "BIZCD", "STD_YYMM", "VENDCD", "PARTNO", "CUSTCD", "IO_DIV", "PURC_ORG", "PURC_OK", "USER_ID", "USER_NAME"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    if (!String.IsNullOrEmpty(parameter[i]["PURC_CON_NAME"]))
                    {
                        //{0}행은 SAP 확정되어 수정 불가합니다.
                        this.MsgCodeAlert_ShowFormat("SRMMM-0051", Convert.ToInt32(parameter[i]["NO"]));
                        return;
                    }
                    
                    param.Tables[0].Rows.Add(
                          Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM")
                        , parameter[i]["VENDCD"]
                        , parameter[i]["PARTNO"]
                        , parameter[i]["CUSTCD"]
                        , parameter[i]["IO_DIV"]
                        , this.cbo01_PURC_ORG.Value
                        , parameter[i]["PURC_OK"].ToString() == "Y" || parameter[i]["PURC_OK"].ToString() == "1" || parameter[i]["PURC_OK"].ToString() == "true" ? "Y" : "N"
                        , this.UserInfo.UserID
                        , this.UserInfo.UserName
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "CANCEL"), param);
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

        public void Process(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                      "CORCD", "BIZCD", "STD_YYMM", "VENDCD", "PARTNO", "CUSTCD", "IO_DIV", "PURC_ORG", "PROCESS_OK", "USER_ID", "USER_NAME", "IF_DATE", "IF_TIME"
                );

                string if_date = DateTime.Now.ToString("yyyyMMdd"); //SAP I/F 동일한 시간 저장을 위한 변수
                string if_time = DateTime.Now.ToString("HHmmss"); //SAP I/F 동일한 시간 저장을 위한 변수

                for (int i = 0; i < parameter.Length; i++)
                {
                    if (!String.IsNullOrEmpty(parameter[i]["PURC_CON_NAME"]))
                    {
                        //{0}행은 SAP 확정되어 수정 불가합니다.
                        this.MsgCodeAlert_ShowFormat("SRMMM-0051", Convert.ToInt32(parameter[i]["NO"]));
                        return;
                    }

                    param.Tables[0].Rows.Add(
                          Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM")
                        , parameter[i]["VENDCD"]
                        , parameter[i]["PARTNO"]
                        , parameter[i]["CUSTCD"]
                        , parameter[i]["IO_DIV"]
                        , this.cbo01_PURC_ORG.Value
                        , parameter[i]["PROCESS_OK"].ToString() == "Y" || parameter[i]["PROCESS_OK"].ToString() == "1" || parameter[i]["PROCESS_OK"].ToString() == "true" ? "Y" : "N"
                        , this.UserInfo.UserID
                        , this.UserInfo.UserName
                        , if_date
                        , if_time
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "PROCESS"), param);
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

            this.cbo02_UNIT.SelectedItem.Value = "EA";
            this.cbo02_UNIT.UpdateSelectedItems(); //꼭 해줘야한다.
            
            this.cbo01_NORMAL_RTN.SelectedItem.Index = 0;
            this.cbo01_NORMAL_RTN.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_DATE.SetValue(DateTime.Now);

            this.cdx01_VINCD.SetValue(string.Empty);

            this.Store1.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            //해당월 마감일 표시
            //changeCondition(null, null);

            HEParameterSet param = new HEParameterSet();            
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("DATE", ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM"));
            param.Add("TYPE", this.cbo01_NORMAL_RTN.Value);
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
            param.Add("CUSTCD", this.cdx01_CUSTCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);            
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("PARTNO", this.txt01_FPARTNO.Value);
            param.Add("UNDEFINED_ITEM", this.chk01_UNDEFINED_ITEM.Value.ToString());
            param.Add("UNTREATED_ITEM", this.chk02_UNTREATED_ITEM.Value.ToString());
            param.Add("LANG", this.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_2"), param);
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

                //LastDaysDisplay();

                //공통코드에 등록된 일자 기준(워크데이트만 포함)으로 마감 일 조정 2016.4.4 이현범
                //서연이화 사용자는 편집 불가 기능에 상관없이 수정 가능하도록 변경 2016.9.5 이현범
                if (_dtWorkDate < DateTime.Now && !this.UserInfo.UserDivision.Equals("T12"))
                {
                    this.MsgCodeAlert("SCMMM-0022");
                    return;
                }

                DataSet saveParam = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "STD_YYMM", "VENDCD", "PARTNO", "CUSTCD", "IO_DIV", "PURC_ORG", "UNIT", "RESALE_QTY", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    saveParam.Tables[0].Rows.Add
                    (
                        Util.UserInfo.CorporationCode
                        , this.cbo01_BIZCD.Value
                        , ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM")
                        , parameters[i]["VENDCD"]
                        , parameters[i]["PARTNO"]
                        , parameters[i]["CUSTCD"]
                        , parameters[i]["IO_DIV"]
                        , this.cbo01_PURC_ORG.Value
                        , parameters[i]["UNIT"]
                        , parameters[i]["RESALE_QTY"]                        
                        , this.UserInfo.UserID
                    );
                }
            
                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), saveParam);
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

        /*
        [DirectMethod]
        public void SetGridSetting(string gubun)
        {
            this.Store1.RemoveAll();

            //그리드 Lock 기능 있으면 2중 그리드가 되어 열이동 정상 작동 안됨
            if (gubun.Equals("1"))
            {
                this.Grid01.ColumnModel.Move(11, 10);
                this.Grid01.ColumnModel.Move(7, 1);
                this.Grid01.ColumnModel.Move(7, 1);
                this.Grid01.ColumnModel.Move(4, 7);
                this.Grid01.ColumnModel.Move(3, 6);
            }
            else
            {
                this.Grid01.ColumnModel.Move(11, 10);
                this.Grid01.ColumnModel.Move(7, 1);
                this.Grid01.ColumnModel.Move(7, 1);
                this.Grid01.ColumnModel.Move(4, 7);
                this.Grid01.ColumnModel.Move(3, 6);
            }

            this.Grid01.Refresh();
        }
        */

        public void changeCondition(object sender, DirectEventArgs e)
        {
            this.Store1.RemoveAll();
        }
        #endregion

        #region [ 유효성 검사 ]
        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {            
            // 조회용 Validation
            if (this.cbo01_BIZCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_BIZCD", lbl01_SAUP.Text);
                return false;
            }                
            
            if (this.df01_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_DATE", lbl01_STD_YYMM.Text);
                return  false;
            }

            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
                return false;
            }

            return true;
        }
        
        #endregion
            
    }
}
