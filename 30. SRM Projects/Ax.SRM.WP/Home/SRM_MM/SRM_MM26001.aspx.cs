#region ▶ Description & History
/* 
 * 프로그램명 : 사급신청 등록 (구.VM4010)
 * 설      명 : 자재관리 > 사급관리 > 사급신청 등록
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-09-30
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
    public partial class SRM_MM26001 : BasePage
    {
        private string pakageName = "APG_SRM_MM26001";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM26001
        /// </summary>
        public SRM_MM26001()
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
                    Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
                    if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
                    {
                        this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                    }
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

                    HEParameterSet param = new HEParameterSet();
                    param.Add("LANG_SET", this.UserInfo.LanguageShort);

                    source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_COMBO"), param).Tables[0];

                    if (source.Rows.Count > 0)
                    {
                        this.lbl99_VTWEG_70.Text = source.Rows[0]["VTWEG_70"].ToString();
                        this.lbl99_VTWEG_72.Text = source.Rows[0]["VTWEG_72"].ToString();
                    }
                    else
                    {
                        this.lbl99_VTWEG_70.Text = "70:사급내수";
                        this.lbl99_VTWEG_72.Text = "72:사급수출";
                    }

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
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues(true)", Mode = ParameterMode.Raw, Encode = true });
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
                case ButtonID.Close:
                    X.Js.Call("closeTab");
                    break;
                default: break;
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

                this.txt01_MGRNM.Text = string.Empty;

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
        
        //팝업에서 취소 후 부모창 재조회
        [DirectMethod]
        public void fnSearch()
        {
            try
            {
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
                this.cdx01_CUSTCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.           

            this.df01_GETDATE.SetValue(DateTime.Now);

            this.cdx01_VINCD.SetValue(string.Empty);

            this.cbo01_PURC_ORG.SelectedItem.Index = 0;            

            this.txt01_FPARTNO.Text = string.Empty;
           
            this.txt01_MGRNM.Text = string.Empty;

            df01_GETDATE_Change(null, null);
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
            param.Add("CUSTCD", this.cdx01_CUSTCD.Value);
            param.Add("GETDATE", ((DateTime)this.df01_GETDATE.Value).ToString("yyyy-MM-dd"));
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("PARTNO", this.txt01_FPARTNO.Text);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

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
                Dictionary<string, object>[] parameters = JSON.Deserialize<Dictionary<string, object>[]>(json);

                if (parameters.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
                }

                if (!IsSaveValid())
                    return;
        
                DataSet saveParam = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "CUSTCD", "PURC_ORG", "REQ_DATE",
                   "PARTNO", "DIV", "REQ_QTY", "REQ_EMPNM", "USER_ID"
                );

                //그리드 전체 데이터를 7일동안 입력된 수량을 조회하여 숫자가 있으면 데이터 생성
                for (int i = 0; i < parameters.Length; i++) //품번
                {
                    for (int j = 0; j < 7; j++) //7일
                    {
                        string req_qty = this.Nvl(parameters[i]["D" + (j).ToString() + "_REQ_QTY"], "0").ToString();

                        if (!req_qty.Equals("0")) //요청 수량이 0이 아니면
                        {
                            saveParam.Tables[0].Rows.Add
                            (
                                Util.UserInfo.CorporationCode
                                , this.cbo01_BIZCD.Value
                                , this.cdx01_CUSTCD.Value
                                , this.cbo01_PURC_ORG.Value
                                , ((DateTime)this.df01_GETDATE.Value).ToString("yyyy-MM-dd")
                                , parameters[i]["PARTNO"]
                                , j, req_qty
                                , this.UserInfo.UserName
                                , this.UserInfo.UserID
                            );
                        }
                    }
                }

                if (saveParam.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert("COM-00020");
                    return;
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
                    DateTime dt = (DateTime)this.df01_GETDATE.Value;

                    for (int i = 0; i < 7; i++)
                    {
                        this.Grid01.ColumnModel.Columns[5 + i].Text = dt.AddDays(i).ToString("MM-dd");
                    }

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
        public bool IsSaveValid()
        {
            bool result = false;

            if (this.txt01_MGRNM.IsEmpty)
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_MGRNM", lbl01_REQ_MGRNM.Text);
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
            if (this.cdx01_CUSTCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_CUSTCD", lbl01_CUST.Text);
                return false;
            }
            if (this.df01_GETDATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_GETDATE", lbl01_REQ_DATE.Text);
                return  false;
            }
            return true;
        }

        #endregion

        #region [ 이벤트 ]
        
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
                case "btn01_CONFIRM_PROC":
                    //확정 처리
                    ChangeConfirm(sender, e);
                    break;
                default:
                    break;
            }
        }

        //그리드 초기화
        protected void cbo01_PURC_ORG_Change(object sender, DirectEventArgs e)
        {
            try
            {
                if (cbo01_PURC_ORG.SelectedItem.Value.Equals("1A1110"))
                {
                    this.lbl99_VTWEG_72.Show();
                    this.lbl99_VTWEG_70.Hide();
                }
                else
                {
                    this.lbl99_VTWEG_70.Show();
                    this.lbl99_VTWEG_72.Hide();                    
                }

                changeCondition(null, null);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {
            }
        }

        public void changeCondition(object sender, DirectEventArgs e)
        {
            this.Store1.RemoveAll();
        }

        //확정 처리
        public void ChangeConfirm(object sender, DirectEventArgs e)
        {
            try
            {
                //조회 조건이 모두 입력되었는지...
                if (!IsQueryValidation())
                    return;

                //담당자가 입력되었는지...
                if (!IsSaveValid())
                    return;

                string json = e.ExtraParams["Values"];
                
                string[] msg = Library.getMessageWithTitle("SRMMM-0057"); //확정 후 수정은 불가합니다. 확정 처리 하시겠습니까?

                Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.Confirm('Y', '" + json.Replace("'", "\\'") + "')",
                        Text = "YES"
                    },
                    No = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.Confirm('N', '" + json.Replace("'", "\\'") + "')",
                        Text = "NO"
                    }
                }).Show();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
        }

        [DirectMethod]
        public void Confirm(string value, string json)
        {
            try
            {
                if (value.Equals("Y"))
                {
                    Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                    DataSet saveParam = Util.GetDataSourceSchema
                    (
                        "CORCD", "BIZCD", "CUSTCD", "PURC_ORG", "REQ_DATE",
                        "PARTNO", "MGRNM", "USER_ID"
                    );
                
                    for (int i = 0; i < parameters.Length; i++) //품번
                    {
                        //일주일 수량중 미확정량 수량이 있는 품번만 확정 처리
                        string D0 = this.Nvl(parameters[i]["D0_FORE_QTY"], "0").ToString();
                        string D1 = this.Nvl(parameters[i]["D1_FORE_QTY"], "0").ToString();
                        string D2 = this.Nvl(parameters[i]["D2_FORE_QTY"], "0").ToString();
                        string D3 = this.Nvl(parameters[i]["D3_FORE_QTY"], "0").ToString();
                        string D4 = this.Nvl(parameters[i]["D4_FORE_QTY"], "0").ToString();
                        string D5 = this.Nvl(parameters[i]["D5_FORE_QTY"], "0").ToString();
                        string D6 = this.Nvl(parameters[i]["D6_FORE_QTY"], "0").ToString();

                        if (!D0.Equals("0") || !D1.Equals("0") || !D2.Equals("0") || !D3.Equals("0") || !D4.Equals("0") || !D5.Equals("0") || !D6.Equals("0"))
                        {
                            saveParam.Tables[0].Rows.Add
                            (
                                Util.UserInfo.CorporationCode
                                , this.cbo01_BIZCD.Value
                                , this.cdx01_CUSTCD.Value
                                , this.cbo01_PURC_ORG.Value
                                , ((DateTime)this.df01_GETDATE.Value).ToString("yyyy-MM-dd")
                                , parameters[i]["PARTNO"]
                                , this.txt01_MGRNM.Text
                                , this.UserInfo.UserID
                            );
                        }
                    }

                    if (saveParam.Tables[0].Rows.Count == 0)
                    {
                        this.MsgCodeAlert("SRMMM-0058"); //확정할 데이터가 없습니다.
                        return;
                    }

                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "CONFIRM"), saveParam);
                        this.MsgCodeAlert("COM-00005");
                        Search();
                    }
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
        }

        //그리드 날짜 변경
        protected void df01_GETDATE_Change(object sender, DirectEventArgs e)
        {            
            DateTime dt = (DateTime)this.df01_GETDATE.Value;

            for (int i = 0; i < 7; i++)
            {
                this.Grid01.ColumnModel.Columns[5 + i].Text = dt.AddDays(i).ToString("MM-dd");
            }

            this.Store1.RemoveAll();
        }
        
        //팝업 type 이 'C' 이면 확정, 'N' 이면 미확정
        [DirectMethod]
        public void MakePopUp(String[] arr, string type)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("CUSTCD", cdx01_CUSTCD.Value);
            param.Add("REQ_DATE", ((DateTime)this.df01_GETDATE.Value).ToString("yyyy-MM-dd"));
            param.Add("DIV", arr[0]);
            param.Add("PARTNO", arr[1]);
            param.Add("PARTNM", arr[2]);
            param.Add("UNIT", arr[3]);

            if (type.Equals("C"))
            {
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM26001P1.aspx", param, "HELP_MM26001P1", "Popup", 800, 600);
            }
            else if (type.Equals("N"))
            {
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM26001P2.aspx", param, "HELP_MM26001P2", "Popup", 800, 600);
            }
        }

        public object Nvl(object value, object replace)
        {
            object result = value;

            if (value == null)
            {
                result = replace;
            }
            else if (value == DBNull.Value)
            {
                result = replace;
            }            

            return result;
        }

        #endregion    
    }
}