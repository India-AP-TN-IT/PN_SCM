#region ▶ Description & History
/* 
 * 프로그램명 : 사급신청 등록 (구.VM4010)
 * 설      명 : 자재관리 > 사급관리 > 사급신청 등록
 * 최초작성자 : 손창현
 * 최초작성일 : 2017-08-30
 * 수정  내용 : 사급신청 등록 (SRM_MM26001) 기준으로 성능을 위한 디자인 작업 변경
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
using System.Web.UI.HtmlControls;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM26000 : BasePage
    {
        private string pakageName = "APG_SRM_MM26000";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SCM_MM26001
        /// </summary>
        public SRM_MM26000()
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

                    source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_COMBO"), param).Tables[0];

                    if (source.Rows.Count > 0)
                    {
                        this.lbl99_VTWEG_70.Text = source.Rows[0]["VTWEG_70"].ToString();
                        this.lbl99_VTWEG_72.Text = source.Rows[0]["VTWEG_72"].ToString();
                    }
                    else
                    {
                        this.lbl99_VTWEG_70.Text = Library.getLabel("", "70_RESALE_DOM");// "70:사급내수";
                        this.lbl99_VTWEG_72.Text = Library.getLabel("", "72_RESALE_EXP");//"72:사급수출";
                    }

                    this.lbl99_VTWEG_70.Hide();
                    this.lbl99_VTWEG_72.Hide();

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
                new Ext.Net.Parameter { Name = "Values", Value = "GetRowsValues(true)", Mode = ParameterMode.Raw, Encode = true });

                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "GridPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Checking And Saving Data...";
            }
            else if (id.Equals(ButtonID.Search))
            {
                
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "GridPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Loading Data...";
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

                //2018.11.16 배명희 ... 조회시 그리드 헤더에 날짜 표시하는 로직 한번 더 호출함.
                this.df01_GETDATE_Change(null, null);

                DataSet result = getDataSet();

                GridBind(result);
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
            this.SetMsg(Util.UserInfo.BusinessCode);//2018.11.16 배명희 ... 사업장별 제한일수 반영한 날짜 메시지 표시.


            this.cdx01_VINCD.SetValue(string.Empty);

            this.txt01_FPARTNO.Text = string.Empty;

            this.txt01_MGRNM.Text = string.Empty;

            df01_GETDATE_Change(null, null);

           // this.Store1.RemoveAll();
            this.Grid01_LD.Rows.Clear();
            this.Grid01.Rows.Clear();
            this.Grid01.Update();
            this.Grid01_LD.Update();      
        }

        //2018.11.16 배명희 ... 사업장별 제한일수 반영한 날짜 메시지 표시.
        private void SetMsg(string bizcd)
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", bizcd);

            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_MIN_REQ_DAY"), param);
            string date = Convert.ToDateTime(source.Tables[0].Rows[0][0]).ToString(this.GlobalLocalFormat_MonthDate);
            this.hidREQ_MIN_DATE.SetValue(source.Tables[0].Rows[0][0].ToString()); //신청수량 입력할수 있는 날짜숨김 필드에 셋팅 (sysdate에서 제한일수 더한 날짜)
            this.lblMsg.Text = string.Format(Library.getLabel("SRM_MM26000", "RESALE_MSG"), date);

            this.df01_GETDATE.SetValue(source.Tables[0].Rows[0][0].ToString());

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
                   "PARTNO", "DIV", "REQ_QTY", "REQ_EMPNM", "UNIT", "USER_ID", "UNIT_PACK_QTY"
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
                                //, this.UserInfo.UserName
                                , this.txt01_MGRNM.Value
                                , parameters[i]["UNIT"]
                                , this.UserInfo.UserID
                                , parameters[i]["UNIT_PACK_QTY"]
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
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_2"), saveParam);
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
        
        //팝업에서 취소 후 부모창 재조회
        [DirectMethod]
        public void fnSearch()
        {
            try
            {
                DataSet result = getDataSet();

                GridBind(result);
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
                        this.Grid01_Excel.ColumnModel.Columns[6 + i].Text = dt.AddDays(i).ToString("MM-dd");
                    }
                    
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01_Excel);                   
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

        #endregion


        #region "html로 그리드처럼 보이도록 구현하기"

        private void GridBind(DataSet result)
        {
            this.Grid01_LD.Rows.Clear();
            this.Grid01.Rows.Clear();

            for (int i = 0; i < result.Tables[0].Rows.Count; i++)
            {
                DataRow dr = result.Tables[0].Rows[i];
                string rowno = (i + 1).ToString();

                #region [왼쪽 (lock영역)]

                HtmlTableRow trLeft = new HtmlTableRow();
                trLeft.Height = "27px";

                //alternative 스타일
                if (i % 2 == 1)
                    trLeft.Attributes.Add("class", "row2");

                trLeft.Cells.Add(this.AddTdInput(rowno, "NO", rowno, false, "40", "center"));
                trLeft.Cells.Add(this.AddTd("center", dr["VINCD"].ToString(), 55));
                trLeft.Cells.Add(this.AddTdInput(rowno, "PARTNO", dr["PARTNO"].ToString(), false, "150", "left"));
                this.Grid01_LD.Rows.Add(trLeft);

                #endregion

                #region [오른쪽 (scroll 영역)]

                HtmlTableRow trRight = new HtmlTableRow();
                trRight.Height = "27px";

                //alternative 스타일
                if (i % 2 == 1)
                   trRight.Attributes.Add("class", "row2");


                trRight.Cells.Add(this.AddTdInput(rowno, "PARTNM", dr["PARTNM"].ToString(), false, "199", "left"));
                trRight.Cells.Add(this.AddTdInput(rowno, "UNIT", dr["UNIT"].ToString(), false, "49", "center"));
                trRight.Cells.Add(this.AddTdInput(rowno, "UNIT_PACK_QTY", dr["UNIT_PACK_QTY"].ToString(), false, "79", "right"));

                //D+0
                trRight.Cells.Add(this.AddTdInput(rowno, "D0_TOTAL", string.Format("{0:#,##0.###}", dr["D0_TOTAL"]), false));               //2018.06.11 배명희. 소숫점 3자리 까지 허용 
                //trRight.Cells.Add(this.AddTdInput(rowno, "D0_REQ_QTY", string.Format("{0:#,##0.###}", dr["D0_REQ_QTY"]), true));
                trRight.Cells.Add(this.AddTdInput(rowno, "D0_REQ_QTY", string.Format("{0:#,##0.###}", dr["D0_REQ_QTY"]), this.IsAllowInputResaleQty(0)));//2018.11.16 배명희. 제한일수에 따른 편집 가능여부 체크.
                trRight.Cells.Add(this.AddTdLink(rowno, "D0_FORE_QTY", string.Format("{0:#,##0.###}", dr["D0_FORE_QTY"]), "75", "right"));  
                trRight.Cells.Add(this.AddTdLink(rowno, "D0_CONF_QTY", string.Format("{0:#,##0.###}", dr["D0_CONF_QTY"]), "75", "right"));  
                
                //D+1
                trRight.Cells.Add(this.AddTdInput(rowno, "D1_TOTAL", string.Format("{0:#,##0.###}", dr["D1_TOTAL"]), false));               //2018.06.11 배명희. 소숫점 3자리 까지 허용 
                //trRight.Cells.Add(this.AddTdInput(rowno, "D1_REQ_QTY", string.Format("{0:#,##0.###}", dr["D1_REQ_QTY"]), true));            
                trRight.Cells.Add(this.AddTdInput(rowno, "D1_REQ_QTY", string.Format("{0:#,##0.###}", dr["D1_REQ_QTY"]), this.IsAllowInputResaleQty(1)));//2018.11.16 배명희. 제한일수에 따른 편집 가능여부 체크.
                trRight.Cells.Add(this.AddTdLink(rowno, "D1_FORE_QTY", string.Format("{0:#,##0.###}", dr["D1_FORE_QTY"]), "75", "right"));
                trRight.Cells.Add(this.AddTdLink(rowno, "D1_CONF_QTY", string.Format("{0:#,##0.###}", dr["D1_CONF_QTY"]), "75", "right"));

                //D+2
                trRight.Cells.Add(this.AddTdInput(rowno, "D2_TOTAL", string.Format("{0:#,##0.###}", dr["D2_TOTAL"]), false));               //2018.06.11 배명희. 소숫점 3자리 까지 허용 
                //trRight.Cells.Add(this.AddTdInput(rowno, "D2_REQ_QTY", string.Format("{0:#,##0.###}", dr["D2_REQ_QTY"]), true));
                trRight.Cells.Add(this.AddTdInput(rowno, "D2_REQ_QTY", string.Format("{0:#,##0.###}", dr["D2_REQ_QTY"]), this.IsAllowInputResaleQty(2)));//2018.11.16 배명희. 제한일수에 따른 편집 가능여부 체크.
                trRight.Cells.Add(this.AddTdLink(rowno, "D2_FORE_QTY", string.Format("{0:#,##0.###}", dr["D2_FORE_QTY"]), "75", "right"));
                trRight.Cells.Add(this.AddTdLink(rowno, "D2_CONF_QTY", string.Format("{0:#,##0.###}", dr["D2_CONF_QTY"]), "75", "right"));

                //D+3
                trRight.Cells.Add(this.AddTdInput(rowno, "D3_TOTAL", string.Format("{0:#,##0.###}", dr["D3_TOTAL"]), false));               //2018.06.11 배명희. 소숫점 3자리 까지 허용 
                //trRight.Cells.Add(this.AddTdInput(rowno, "D3_REQ_QTY", string.Format("{0:#,##0.###}", dr["D3_REQ_QTY"]), true));
                trRight.Cells.Add(this.AddTdInput(rowno, "D3_REQ_QTY", string.Format("{0:#,##0.###}", dr["D3_REQ_QTY"]), this.IsAllowInputResaleQty(3)));//2018.11.16 배명희. 제한일수에 따른 편집 가능여부 체크.
                trRight.Cells.Add(this.AddTdLink(rowno, "D3_FORE_QTY", string.Format("{0:#,##0.###}", dr["D3_FORE_QTY"]), "75", "right"));
                trRight.Cells.Add(this.AddTdLink(rowno, "D3_CONF_QTY", string.Format("{0:#,##0.###}", dr["D3_CONF_QTY"]), "75", "right"));

                //D+4
                trRight.Cells.Add(this.AddTdInput(rowno, "D4_TOTAL", string.Format("{0:#,##0.###}", dr["D4_TOTAL"]), false));               //2018.06.11 배명희. 소숫점 3자리 까지 허용 
                //trRight.Cells.Add(this.AddTdInput(rowno, "D4_REQ_QTY", string.Format("{0:#,##0.###}", dr["D4_REQ_QTY"]), true));
                trRight.Cells.Add(this.AddTdInput(rowno, "D4_REQ_QTY", string.Format("{0:#,##0.###}", dr["D4_REQ_QTY"]), this.IsAllowInputResaleQty(4)));//2018.11.16 배명희. 제한일수에 따른 편집 가능여부 체크.
                trRight.Cells.Add(this.AddTdLink(rowno, "D4_FORE_QTY", string.Format("{0:#,##0.###}", dr["D4_FORE_QTY"]), "75", "right"));
                trRight.Cells.Add(this.AddTdLink(rowno, "D4_CONF_QTY", string.Format("{0:#,##0.###}", dr["D4_CONF_QTY"]), "75", "right"));

                //D+5
                trRight.Cells.Add(this.AddTdInput(rowno, "D5_TOTAL", string.Format("{0:#,##0.###}", dr["D5_TOTAL"]), false));               //2018.06.11 배명희. 소숫점 3자리 까지 허용 
                //trRight.Cells.Add(this.AddTdInput(rowno, "D5_REQ_QTY", string.Format("{0:#,##0.###}", dr["D5_REQ_QTY"]), true));
                trRight.Cells.Add(this.AddTdInput(rowno, "D5_REQ_QTY", string.Format("{0:#,##0.###}", dr["D5_REQ_QTY"]), this.IsAllowInputResaleQty(5)));//2018.11.16 배명희. 제한일수에 따른 편집 가능여부 체크.
                trRight.Cells.Add(this.AddTdLink(rowno, "D5_FORE_QTY", string.Format("{0:#,##0.###}", dr["D5_FORE_QTY"]), "75", "right"));
                trRight.Cells.Add(this.AddTdLink(rowno, "D5_CONF_QTY", string.Format("{0:#,##0.###}", dr["D5_CONF_QTY"]), "75", "right"));

                //D+6
                trRight.Cells.Add(this.AddTdInput(rowno, "D6_TOTAL", string.Format("{0:#,##0.###}", dr["D6_TOTAL"]), false));               //2018.06.11 배명희. 소숫점 3자리 까지 허용 
                //trRight.Cells.Add(this.AddTdInput(rowno, "D6_REQ_QTY", string.Format("{0:#,##0.###}", dr["D6_REQ_QTY"]), true));
                trRight.Cells.Add(this.AddTdInput(rowno, "D6_REQ_QTY", string.Format("{0:#,##0.###}", dr["D6_REQ_QTY"]), this.IsAllowInputResaleQty(6)));//2018.11.16 배명희. 제한일수에 따른 편집 가능여부 체크.
                trRight.Cells.Add(this.AddTdLink(rowno, "D6_FORE_QTY", string.Format("{0:#,##0.###}", dr["D6_FORE_QTY"]), "75", "right"));
                trRight.Cells.Add(this.AddTdLink(rowno, "D6_CONF_QTY", string.Format("{0:#,##0.###}", dr["D6_CONF_QTY"]), "75", "right"));

                this.Grid01.Rows.Add(trRight);

                #endregion
            }

            //화면에 refresh
            this.Grid01.Update();
            this.Grid01_LD.Update();
        }


        //2018.11.16 배명희
        //조회기준일자+D 계산한 일자가 신청수량 입력 가능한지 여부 계산한다.
        private bool IsAllowInputResaleQty(int D)
        {
            DateTime dt = ((DateTime)df01_GETDATE.Value).AddDays(D);             //조회기준일자 + D일
            DateTime dtREQ_MIN_DATE = Convert.ToDateTime(hidREQ_MIN_DATE.Value); //SYSDATE + 제한일수에 해당하는 날짜

            if (DateTime.Compare(dt, dtREQ_MIN_DATE) < 0) return false;          //"조회기준일자+D일"이 "SYSDATE + 제한일수" 보다 이전이면 편집불가, 같거나 이후이면  편집 가능.
            else return true;
        }


        //화면 display용 필드 그리기
        private HtmlTableCell AddTd(string align, string value, int width)
        {
            HtmlTableCell td = new HtmlTableCell();
            td.Align = align;
            td.Width = width.ToString() + "px";
            HtmlGenericControl div = new HtmlGenericControl("div");
            div.Attributes.Add("style", " width:" + width.ToString() + "px; white-space:nowrap; text-overflow: ellipsis; overflow: hidden;text-align:" + align + ";");
            div.InnerText = value;
            td.Controls.Add(div);

            return td;
        }
        
        //키값 이거나 입력용 필드 그리기
        private HtmlTableCell AddTdInput(string rowno, string id, string value, bool edit)
        {
            return this.AddTdInput(rowno, id, value, edit, "79", "right");
        }


        //키값 이거나 입력용 필드 그리기
        private HtmlTableCell AddTdInput(string rowno, string id, string value, bool edit, string width, string align)
        {
            HtmlTableCell td = new HtmlTableCell();
            HtmlInputText input = new HtmlInputText("text");
            input.ID = "txt__" + rowno + "__" + id;
            input.Value = value;

            if (edit)
            {
                input.Attributes.Add("style", "width:" + width + "px; text-align:" + align + ";");
                input.Attributes.Add("onkeydown", "return KeyDown(this, event);");
                input.Attributes.Add("onkeyup", "return KeyUp(this, event);");
                input.Attributes.Add("onblur", "Calculate(this);");
                //input.Attributes.Add("onblur", "Format(this);");
                input.Attributes.Add("onfocus", "Focus(this);");
            }
            else
            {
                //input.Disabled = true; // ie8때문에 disabled대신에 readonly=true 사용 2015.01.13
                input.Attributes.Add("style", "border:none;width : " + width + "px;background-color:transparent;text-align:" + align + ";");
                input.Attributes.Add("readonly", "true");                
            }

            td.Controls.Add(input);
            return td;
        }

        //Link
        private HtmlTableCell AddTdLink(string rowno, string id, string value, string width, string align)
        {
            HtmlTableCell td = new HtmlTableCell();
            HtmlAnchor input = new HtmlAnchor();
            input.ID = "txt__" + rowno + "__" + id;
            input.InnerText = value;
            input.HRef = "javascript:linkClick('" + rowno + "', '" + input.ID + "');";
            input.Attributes.Add("style", "display: block; width : " + width + "px; text-align:" + align + "; color:blue;text-decoration:underline;");

            td.Controls.Add(input);
            return td;
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
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_GETDATE", lbl01_INQUERY_STD_DATE.Text);
                return  false;
            }

            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG_VTWEG.Text);
                return false;
            }

            //if (this.cdx01_VINCD.IsEmpty)
            //{
            //    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VINCD", lbl01_VIN.Text);
            //    return false;
            //}

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
        
        protected void df01_GETDATE_Change(object sender, DirectEventArgs e)
        {
            DateTime dt = (DateTime)this.df01_GETDATE.Value;

            this.lbl02_D0.Text = dt.ToString(this.GlobalLocalFormat_MonthDate);              //2018.11.16 배명희 다국어 처리함
            this.lbl02_D1.Text = dt.AddDays(1).ToString(this.GlobalLocalFormat_MonthDate);   //2018.11.16 배명희 다국어 처리함
            this.lbl02_D2.Text = dt.AddDays(2).ToString(this.GlobalLocalFormat_MonthDate);   //2018.11.16 배명희 다국어 처리함
            this.lbl02_D3.Text = dt.AddDays(3).ToString(this.GlobalLocalFormat_MonthDate);   //2018.11.16 배명희 다국어 처리함
            this.lbl02_D4.Text = dt.AddDays(4).ToString(this.GlobalLocalFormat_MonthDate);   //2018.11.16 배명희 다국어 처리함
            this.lbl02_D5.Text = dt.AddDays(5).ToString(this.GlobalLocalFormat_MonthDate);   //2018.11.16 배명희 다국어 처리함
            this.lbl02_D6.Text = dt.AddDays(6).ToString(this.GlobalLocalFormat_MonthDate);   //2018.11.16 배명희 다국어 처리함

            this.Grid01_LD.Rows.Clear();
            this.Grid01.Rows.Clear();
            this.Grid01.Update();
            this.Grid01_LD.Update(); 
        }

        //그리드 초기화
        protected void cbo01_PURC_ORG_Change(object sender, DirectEventArgs e)
        {
            try            
            {
                if (cbo01_PURC_ORG.SelectedItem.Value == null || cbo01_PURC_ORG.SelectedItem.Value == "")
                {
                    this.lbl99_VTWEG_72.Hide();
                    this.lbl99_VTWEG_70.Hide();
                }
                else if (cbo01_PURC_ORG.SelectedItem.Value.Equals("1A1110"))
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
            this.Grid01_LD.Rows.Clear();
            this.Grid01.Rows.Clear();
            this.Grid01.Update();
            this.Grid01_LD.Update();

            //2018.11.16 배명희 ... 사업장별 제한일수 반영한 날짜 메시지 표시.
            if (this.cbo01_BIZCD.Value != null)
                this.SetMsg(this.cbo01_BIZCD.Value.ToString());
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
