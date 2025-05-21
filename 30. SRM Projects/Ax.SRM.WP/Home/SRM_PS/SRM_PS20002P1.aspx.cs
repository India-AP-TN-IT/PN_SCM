#region ▶ Description & History
/* 
 * 프로그램명 : 원가계산서
 * 설      명 : Home > 포장사양관리 > 원가계산서 > 팝업
 * 최초작성자 : 박의곤
 * 최초작성일 : 2017-04-17
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
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using System.Data;
using System.Collections;
using HE.Framework.Core.Report;

namespace Ax.EP.WP.Home.SRM_PS
{
    public partial class SRM_PS20002P1 : BasePage
    {
        private string pakageName = "APG_SRM_PS20002";

        #region [ 초기설정 ]
        /// <summary>
        /// SRM_PS20002
        /// </summary>
        public SRM_PS20002P1()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = false;
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

                    HEParameterSet paramSet = new HEParameterSet();
                    paramSet.Add("LANG_SET", this.UserInfo.LanguageShort);
                    DataSet source_VEND = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_PS20001", "INQUERY_VENDCD"), paramSet);
                    Library.ComboDataBind(this.cbo01_CUSTCD, source_VEND.Tables[0], false, "NAME", "ID", true, "ALL");

                    this.Reset(true);
                    this.hid01_MODE.SetValue(Request.Params["MODE"]); //신규:N, 수정:M
                    this.txt01_PARTNO.SetValue(Request.Params["Partno"]);
                    this.txt01_ID.Text = Request.Params["ID"];

                    //수정모드에서는 파트넘버 수정 불가, 버튼 실행불가
                    this.txt01_PARTNO.ReadOnly = false;
                    btn01_PACKINFO.Visible = true;
                    if (this.hid01_MODE.Text.Equals("M"))
                    {
                        txt01_PARTNO.ReadOnly = true;
                        btn01_PACKINFO.Visible = false;
                    }
                    else if (this.hid01_MODE.Text.Equals("V"))
                    {
                        (FindControl(ButtonID.Save) as Ext.Net.ImageButton).Visible = false;
                        (FindControl(ButtonID.Reset) as Ext.Net.ImageButton).Visible = false;
                    }
                    this.Search();

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
            //MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
            MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
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
            if (ibtn.ID.Equals(ButtonID.Search))
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "InputPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Loading Data...";
            }
            else if (ibtn.ID.Equals(ButtonID.Save))
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.Page;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "InputPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Checking And Saving Data...";
            }

            else if (ibtn.ID.Equals(ButtonID.Reset))
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.Page;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "InputPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Initializing Controls...";
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
                case ButtonID.Reset:
                    Reset(true);
                    break;
                case ButtonID.Save:
                    Save(sender, e);
                    break;
                case ButtonID.Print:
                    PrintConfirm();
                    break;
                case ButtonID.Close:
                    X.Js.Call("if (parent != null) parent.App." + this.txt01_ID.Text.Trim() + ".hide");
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
                case "btn01_PACKINFO":
                    GetPartNoDetail(txt01_PARTNO.Value);
                    break;
                case "btn01_PRINT":
                    PrintConfirm();
                    break;
                default:
                    break;
            }
        }
        #endregion

        #region [리포트 출력 관련]

        private void PrintConfirm()
        {
            X.Msg.Show(new MessageBoxConfig
            {
                Title = "Confirm",
                Message = "출력하시겠습니까?",
                Buttons = MessageBox.Button.YESNO,
                Icon = MessageBox.Icon.QUESTION,
                Fn = new JFunction { Fn = "PrintReport" },
                AnimEl = "ButtonPrint"
            });
        }
        /// <summary>
        /// Print
        /// </summary>
        [DirectMethod]
        public void Print()
        {
            try
            {
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_PS/SRM_PS20002";

                // Main Section ( 메인리포트 파라메터셋 )
                HERexSection mainSection = new HERexSection();
                //mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");            

                report.Sections.Add("MAIN", mainSection);

                // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                DataSet ds = this.getDataSet_Basic_Print();

                if (ds.Tables[0].Rows.Count <= 0)
                {
                    this.MsgCodeAlert_ShowFormat("COM-00022");
                    return;
                }
                DataSet ds1 = this.getDataSet_Ingredient_Print();
                DataSet ds2 = this.getDataSet_Manufacture_Print();

                // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                //ds.Tables[0].TableName = "DATA";
                //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
                //ds1.Tables[0].TableName = "DATA";
                //ds1.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "01.xml", XmlWriteMode.WriteSchema);
                //ds2.Tables[0].TableName = "DATA";
                //ds2.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "02.xml", XmlWriteMode.WriteSchema);

                HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                HERexSection xmlSectionSub1 = new HERexSection(ds1, new HEParameterSet());
                HERexSection xmlSectionSub2 = new HERexSection(ds2, new HEParameterSet());

                // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
                // xmlSection.ReportParameter.Add("CORCD", "1000");
                report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
                report.Sections.Add("XML1", xmlSectionSub1);
                report.Sections.Add("XML2", xmlSectionSub2);

                AxReportForm.ShowReport(report);
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


        #region [ 코드박스 이벤트 핸들러 ]

        #endregion

        #region [ 기능 ]
        // 파트넘버가 기존의 포장사양에 존재하는지 여부를 체크
        // 포장사양에 존재하면 포장사양의 데이터를 불러옴
        // 포장사양에 존재하나 원가계산서에도 존재하게 되면 원가계산서의 데이터를 불러옴
        private void GetPartNoDetail(object value)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("PARTNO", value);


            //txt01_TOP_PART_X.Value = 76.3;
            //txt01_TOP_PART_Y.Value = 80.8;
            //txt01_TOP_PART_Z.Value = 35.2;
            //txt01_TOP_MID_X.Value = 700;
            //txt01_TOP_MID_Y.Value = 410;
            //txt01_TOP_MID_Z.Value = 300;

            //X.Js.Call("fn_top_change");

            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_GETPARNO"), param);
            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow dr = ds.Tables[0].Rows[0];
                this.txt01_TOP_PART_X.SetValue(ChangeNull(dr["TOP_PART_X"]));
                this.txt01_TOP_PART_Y.SetValue(ChangeNull(dr["TOP_PART_Y"]));
                this.txt01_TOP_PART_Z.SetValue(ChangeNull(dr["TOP_PART_Z"]));
                this.txt01_TOP_MID_X.SetValue(ChangeNull(dr["TOP_MID_X"]));
                this.txt01_TOP_MID_Y.SetValue(ChangeNull(dr["TOP_MID_Y"]));
                this.txt01_TOP_MID_Z.SetValue(ChangeNull(dr["TOP_MID_Z"]));
                this.txt01_PARTNM.SetValue(ChangeNull(dr["PARTNM"]));
                this.cdx01_VINCD.SetValue(ChangeNull(dr["VINCD"]));
                this.cdx01_VENDCD.SetValue(ChangeNull(dr["VENDCD"]));
                this.txt01_TYPE.SetValue(ChangeNull(dr["MID_PACKCODE"])); //중포장코드
                this.txt01_LOAD_QTY.SetValue(ChangeNull(dr["MID_LOAD_QTY"]));
                this.cbo01_CUSTCD.SetValue(ChangeNull(dr["CUSTCD"]));


                X.Js.Call("fn_top_change");
                Search();
            }
        }

        // 재질단가 콤보구현
        [DirectMethod]
        public void test(string value)
        {
        }
        [DirectMethod]
        public void ChangeMaterialCost(string value, string depth, string rtnValue)
        {
            try
            {
                string material_ucost = string.Empty;
                Ext.Net.ComboBox cb2 = this.FindControl("cbo" + depth + "_PACK_MATERIAL") as Ext.Net.ComboBox;
                if (cb2.SelectedItem.Value != null)
                {
                    if (cb2.SelectedItem.Value.ToString().Equals("OPP TAPE"))
                    {
                        material_ucost = "12.2";
                    }
                    else if (cb2.SelectedItem.Value.ToString().Equals("PE SHEET"))
                    {
                        material_ucost = "227";
                    }
                    else if (cb2.SelectedItem.Value.ToString().Equals("PE BAG"))
                    {
                        material_ucost = "227";
                    }
                    else if (cb2.SelectedItem.Value.ToString().Equals("VINYL BAG"))
                    {
                        material_ucost = "1890";
                    }
                    else
                    {
                        material_ucost = rtnValue;
                    }

                }

                Ext.Net.ComboBox cb = this.FindControl("cbo" + depth + "_MATERIAL_UCOST_H") as Ext.Net.ComboBox;

                DataTable dt = new DataTable();
                dt.Columns.Add("CODE");
                dt.Columns.Add("NAME");
                dt.Rows.Add("870", "870");
                dt.Rows.Add("645", "645");

                DataTable dt2 = new DataTable();
                dt2.Columns.Add("CODE");
                dt2.Columns.Add("NAME");
                dt2.Rows.Add("682", "682");
                dt2.Rows.Add("471", "471");

                DataTable dt3 = new DataTable();
                dt3.Columns.Add("CODE");
                dt3.Columns.Add("NAME");
                dt3.Rows.Add(material_ucost, material_ucost);

                if (value.Equals("DW3"))
                {
                    SetDataRow(dt, material_ucost);
                    Library.ComboDataBind(cb, dt, false, "NAME", "CODE", true);

                }
                else if (value.Equals("SW3"))
                {
                    SetDataRow(dt2, material_ucost);
                    Library.ComboDataBind(cb, dt2, false, "NAME", "CODE", true);
                }
                else
                {
                    Library.ComboDataBind(cb, dt3, false, "NAME", "CODE", true);
                }
                //X.Js.Call("SetMaterialUcost", depth, material_ucost);                
                cb.SelectedItem.Value = material_ucost;
                cb.UpdateSelectedItems();



            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        // ctime 콤보구현
        [DirectMethod]
        public void ChangeProcCtime(string value, string depth, string rtnValue)
        {
            try
            {
                Ext.Net.ComboBox cb = this.FindControl("cbo" + depth + "_CTIME_H") as Ext.Net.ComboBox;

                DataTable dt = new DataTable();
                dt.Columns.Add("CODE");
                dt.Columns.Add("NAME");
                dt.Rows.Add("30", "30");

                DataTable dt2 = new DataTable();
                dt2.Columns.Add("CODE");
                dt2.Columns.Add("NAME");
                dt2.Rows.Add("2", "2");
                dt2.Rows.Add("3", "3");
                dt2.Rows.Add("5", "5");
                dt2.Rows.Add("10", "10");

                DataTable dt3 = new DataTable();
                dt3.Columns.Add("CODE");
                dt3.Columns.Add("NAME");
                dt3.Rows.Add("20", "20 (4등분)");
                dt3.Rows.Add("30", "30 (6등분)");
                dt3.Rows.Add("35", "35 (10등분)");
                dt3.Rows.Add("40", "40 (15등분)");
                dt3.Rows.Add("70", "70 (15등분 이상)");

                DataTable dt4 = new DataTable();
                dt4.Columns.Add("CODE");
                dt4.Columns.Add("NAME");
                dt4.Rows.Add("25", "25");

                DataTable dt5 = new DataTable();
                dt5.Columns.Add("CODE");
                dt5.Columns.Add("NAME");
                dt5.Rows.Add(rtnValue, rtnValue);

                string ctime = string.Empty;

                if (value.Equals("BOX조립"))
                {
                    Library.ComboDataBind(cb, dt, false, "NAME", "CODE", false);
                    if (string.IsNullOrEmpty(rtnValue)) ctime = "30";
                    else ctime = rtnValue;
                    SetDataRow(dt, ctime);
                }
                else if (value.Equals("제품적입"))
                {
                    if (string.IsNullOrEmpty(rtnValue)) ctime = "";
                    else ctime = rtnValue;
                    SetDataRow(dt2, ctime);
                    Library.ComboDataBind(cb, dt2, false, "NAME", "CODE", false);
                }
                else if (value.Equals("격자조립"))
                {
                    if (string.IsNullOrEmpty(rtnValue)) ctime = "";
                    else ctime = rtnValue;
                    SetDataRow(dt3, ctime);
                    Library.ComboDataBind(cb, dt3, false, "NAME", "CODE", false);
                }
                else if (value.Equals("마무리"))
                {
                    if (string.IsNullOrEmpty(rtnValue)) ctime = "25";
                    else ctime = rtnValue;
                    SetDataRow(dt4, ctime);
                    Library.ComboDataBind(cb, dt4, false, "NAME", "CODE", false);
                }
                else
                {
                    Library.ComboDataBind(cb, dt5, false, "NAME", "CODE", false);
                    ctime = rtnValue;
                }

                //X.Js.Call("SetCtime", depth, ctime);

                cb.SelectedItem.Value = ctime;
                cb.UpdateSelectedItems();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        private void SetDataRow(DataTable dt, string ctime)
        {
            bool check = false;
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i][0].ToString().Equals(ctime))
                {
                    check = true;
                }
            }
            if (check == false)
            {
                dt.Rows.Add(ctime, ctime);
            }
        }

        // ctime 콤보구현
        [DirectMethod]
        public void ChangeSetCtime(string value, string depth)
        {
            try
            {
                Ext.Net.ComboBox cb = this.FindControl("cbo" + depth + "_CTIME_H") as Ext.Net.ComboBox;
                cb.SelectedItem.Value = value;
                cb.UpdateSelectedItems();

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

        #region [ 초기화 관련 ]
        /// <summary>
        /// Reset
        /// </summary>
        public void Reset(bool isAllReset)
        {
            if (isAllReset)
            {
                this.ClearInput(this.Controls, isAllReset);
            }
        }



        /// <summary>
        /// SetPartnerControlAuthority
        /// </summary>
        /// <param name="controls"></param>
        private void ClearInput(ControlCollection controls, bool isAllReset)
        {
            foreach (Control ctrl in controls)
            {
                // 텍스트 필드일경우 
                Ext.Net.TextField txtField = ctrl as Ext.Net.TextField;
                if (txtField != null)
                {
                    if (txtField.ID != "txt01_ID")
                    {
                        if (isAllReset)
                        {
                            if (txtField.ID == "txt01_MAIN_PARTNO")
                            {
                                //txtField.SetValue(hid01_MAIN_PARTNO.Text);
                            }
                            else
                                txtField.SetValue(string.Empty);
                        }
                        else
                            txtField.SetValue(string.Empty);

                    }
                    continue;
                }

                // 텍스트 필드일경우 
                Ext.Net.TextArea txtArea = ctrl as Ext.Net.TextArea;
                if (txtArea != null)
                {
                    txtArea.SetValue(string.Empty);
                    continue;
                }

                // 코드박스 일경우 
                Ax.EP.UI.IEPCodeBox cdxField = ctrl as Ax.EP.UI.IEPCodeBox;
                if (cdxField != null)
                {
                    cdxField.SetValue(string.Empty);
                    continue;
                }

                //콤보상자인 경우
                Ext.Net.ComboBox cboField = ctrl as Ext.Net.ComboBox;
                if (cboField != null)
                {
                    //if (cboField.ID.IndexOf("PACK_MATERIAL") == -1)
                    //{
                    //    cboField.SelectedItem.Value = cboField.Items[0].Value;
                    //    cboField.UpdateSelectedItems();
                    //}
                    //else
                    //{
                    //    cboField.SelectedItem.Value = string.Empty;
                    //    cboField.UpdateSelectedItems();
                    //}

                    X.Js.Call("RemoveCls", cboField.ID);

                    cboField.SelectedItem.Value = string.Empty;
                    cboField.UpdateSelectedItems();

                    continue;

                }

                //number필드인 경우
                Ext.Net.NumberField numField = ctrl as Ext.Net.NumberField;
                if (numField != null)
                {
                    X.Js.Call("RemoveCls", numField.ID);
                    numField.SetValue(null);
                    continue;
                }

                Ext.Net.DateField dateField = ctrl as Ext.Net.DateField;
                if (dateField != null)
                {
                    //if (dateField.ReadOnly == false)
                    //{
                    //    dateField.SetValue(DateTime.Now);
                    //}
                    dateField.SetValue(null);
                    continue;
                }

                Ext.Net.Image imageField = ctrl as Ext.Net.Image;
                if (imageField != null)
                {
                    imageField.ImageUrl = CommonString.NoImage;
                    continue;
                }

                Ext.Net.FileUploadField fileField = ctrl as Ext.Net.FileUploadField;
                if (fileField != null)
                {
                    fileField.Reset();
                    continue;
                }


                //그외 컨트롤인 경우
                if (ctrl.HasControls())
                {
                    ClearInput(ctrl.Controls, isAllReset);
                }
            }
        }

        #endregion


        #region [조회]
        /// <summary>
        /// 조회
        /// </summary>
        public void Search()
        {
            try
            {
                DataSet source_Basic = this.getDataSet_Basic();
                DataSet source_Ingredient = this.getDataSet_Ingredient();
                DataSet source_Manufacture = this.getDataSet_Manufacture();

                if (source_Basic.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = source_Basic.Tables[0].Rows[0];
                    #region [ 자동계산입력양식(제품사이즈, 중포장사이즈, 업체/제품 구분 입력 요망) ]
                    this.txt01_TOP_PART_X.SetValue(ChangeNull(dr["TOP_PART_X"]));
                    this.txt01_TOP_PART_Y.SetValue(ChangeNull(dr["TOP_PART_Y"]));
                    this.txt01_TOP_PART_Z.SetValue(ChangeNull(dr["TOP_PART_Z"]));
                    this.txt01_TOP_MID_X.SetValue(ChangeNull(dr["TOP_MID_X"]));
                    this.txt01_TOP_MID_Y.SetValue(ChangeNull(dr["TOP_MID_Y"]));
                    this.txt01_TOP_MID_Z.SetValue(ChangeNull(dr["TOP_MID_Z"]));

                    this.txt01_LOAD_X.SetValue(ChangeNull(dr["LOAD_X"]));
                    this.txt01_LOAD_Y.SetValue(ChangeNull(dr["LOAD_Y"]));
                    this.txt01_LOAD_Z.SetValue(ChangeNull(dr["LOAD_Z"]));
                    this.txt01_LOAD_TOTAL.SetValue(ChangeNull(dr["LOAD_TOTAL"]));

                    this.cbo01_VEND_DIV.SelectedItem.Value = ChangeNulltoString(dr["VEND_DIV"]).ToString();//업체구분
                    this.cbo01_VEND_DIV.UpdateSelectedItems();

                    this.cbo01_PART_DIV.SelectedItem.Value = ChangeNulltoString(dr["PART_DIV"]).ToString();//제품구분
                    this.cbo01_PART_DIV.UpdateSelectedItems();

                    #endregion

                    #region [ 기본 정보 ]
                    this.cbo01_CUSTCD.SelectedItem.Value = ChangeNulltoString(dr["CUSTCD"]).ToString();//법인명
                    this.cbo01_CUSTCD.UpdateSelectedItems();

                    this.cdx01_VINCD.SetValue(ChangeNull(dr["VINCD"])); //차종

                    this.txt01_TYPE.SetValue(ChangeNull(dr["TYPE_STANDARD"])); //중포장코드
                    this.cdx01_VENDCD.SetValue(ChangeNull(dr["VENDCD"])); //공급업체(포장업체)

                    this.txt01_PARTNO.SetValue(ChangeNull(dr["PARTNO"]));
                    this.txt01_PARTNM.SetValue(ChangeNulltoString(dr["PARTNM"]));

                    this.txt01_LOAD_QTY.SetValue(ChangeNull(dr["LOAD_QTY"])); // 적입수량

                    this.txt01_MATERIAL_SUM.SetValue(ChangeNull(dr["MATERIAL_SUM"])); // ①재 료 비 소 계
                    this.txt01_MANUFATUR_SUM.SetValue(ChangeNull(dr["MANUFATUR_SUM"])); // ④ 가 공 비 소 계
                    this.txt01_BASIC_COST.SetValue(ChangeNull(dr["BASIC_COST"])); //일반관리비
                    this.txt01_PROFIT.SetValue(ChangeNull(dr["PROFIT"])); //이 윤
                    this.txt01_MATERIAL_MANAGE_COST.SetValue(ChangeNull(dr["MATERIAL_MANAGE_COST"])); //재료관리비
                    this.txt01_PROC_HEAT.SetValue(ChangeNull(dr["PROC_HEAT"])); //열 처 리

                    this.txt01_PROC_VALUE.SetValue(ChangeNull(dr["PROC_VALUE"])); // 열 처 리 입력값
                    this.txt01_PROC_VALUE2.SetValue(ChangeNull(dr["PROC_VALUE2"])); // 열 처 리 입력값2

                    this.txt01_STUFF_CHARGE.SetValue(ChangeNull(dr["STUFF_CHARGE"])); // STUFF_CHARGE
                    this.txt01_STUFF_CHARGE_VALUE.SetValue(ChangeNull(dr["STUFF_CHARGE_VALUE"])); // STUFFING 입력값
                    this.txt01_STUFF_CHARGE_VALUE2.SetValue(ChangeNull(dr["STUFF_CHARGE_VALUE2"])); // STUFFING 입력값2

                    this.txt01_USE_MACHINE.SetValue(ChangeNull(dr["USE_MACHINE"])); // 중장비 사용료
                    this.txt01_USE_MACHINE_VALUE.SetValue(ChangeNull(dr["USE_MACHINE_VALUE"]));// 중장비 사용료 입력값
                    this.txt01_USE_MACHINE_VALUE2.SetValue(ChangeNull(dr["USE_MACHINE_VALUE2"]));// 중장비 사용료 입력값2

                    this.txt01_MOLD_COST.SetValue(ChangeNull(dr["MOLD_COST"])); // 금형비
                    this.txt01_PACKING_TOTAL.SetValue(ChangeNull(dr["PACKING_TOTAL"])); // 포장비 원가
                    this.dte01_WRITE_DATE.SetValue(ChangeNulltoString(dr["WRITE_DATE"])); // 작성일
                    this.txt01_WRITER.SetValue(ChangeNulltoString(dr["WRITER"])); // 작성자
                    this.txt01_CHECKER.SetValue(ChangeNulltoString(dr["CHECKER"])); // 검토
                    this.txt01_APPLYER.SetValue(ChangeNulltoString(dr["APPLYER"])); // 승인

                    this.txt01_CHECK_BOXCOST.SetValue(ChangeNull(dr["CHECK_BOXCOST"])); // 검토금액(1BOX)
                    this.txt01_DECIDED_BOXCOST.SetValue(ChangeNull(dr["DECIDED_BOXCOST"])); //결정금액(1BOX)
                    this.txt01_CHECK_EACOST.SetValue(ChangeNull(dr["CHECK_EACOST"])); // 검토금액(1EA)
                    this.txt01_DECIDED_EACOST.SetValue(ChangeNull(dr["DECIDED_EACOST"])); // 결정금액(1EA)

                    #endregion
                }
                X.AddScript("console.log('xAdd');");
                int index = 1;
                if (source_Ingredient.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in source_Ingredient.Tables[0].Rows)
                    {
                        #region [ 재료비 ]
                        X.Js.Call("setValueCombo", "cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL", ChangeNulltoString(dr["PACK_MATERIAL"]).ToString());
                        //(this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL") as Ext.Net.ComboBox).SelectedItem.Value = dr["PACK_MATERIAL"].ToString(); //부품명
                        //(this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL") as Ext.Net.ComboBox).UpdateSelectedItems(); //꼭 해줘야한다.


                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_PART_SIZE_X") as Ext.Net.NumberField).SetValue(ChangeNull(dr["PART_SIZE_X"])); //가로(mm)
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_PART_SIZE_Y") as Ext.Net.NumberField).SetValue(ChangeNull(dr["PART_SIZE_Y"])); //세로(mm)
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_PART_SIZE_Z") as Ext.Net.NumberField).SetValue(ChangeNull(dr["PART_SIZE_Z"])); //높이(mm)

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_PART_USAGE") as Ext.Net.NumberField).SetValue(ChangeNull(dr["PART_USAGE"])); //usage

                        (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PART_USAGE_UNIT") as Ext.Net.ComboBox).SelectedItem.Value = ChangeNulltoString(dr["PART_USAGE_UNIT"]).ToString(); //PART USAGE UNIT
                        (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PART_USAGE_UNIT") as Ext.Net.ComboBox).UpdateSelectedItems(); //꼭 해줘야한다.


                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_UCOST") as Ext.Net.NumberField).SetValue(ChangeNull(dr["UCOST"])); //원단가
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_UCOST_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["UCOST"])); //원단가

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_UCOST_ADD") as Ext.Net.NumberField).SetValue(ChangeNull(dr["UCOST_ADD"])); //보정단가
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_UCOST_ADD_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["UCOST_ADD"])); //보정단가

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_UCOST_TOTAL") as Ext.Net.NumberField).SetValue(ChangeNull(dr["UCOST_TOTAL"])); //총단가
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_UCOST_TOTAL_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["UCOST_TOTAL"])); //총단가

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_JANG") as Ext.Net.NumberField).SetValue(ChangeNull(dr["JANG"])); //장절
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_JANG_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["JANG"])); //장절

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_POK") as Ext.Net.NumberField).SetValue(ChangeNull(dr["POK"])); //폭절
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_POK_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["POK"])); //폭절

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_APPLY_JIPOK") as Ext.Net.NumberField).SetValue(ChangeNull(dr["APPLY_JIPOK"])); //지폭적용
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_JAEJOK") as Ext.Net.NumberField).SetValue(ChangeNull(dr["JAEJOK"])); //재적
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_JAEJOK_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["JAEJOK"])); //재적

                        //(this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_MATERIAL") as Ext.Net.ComboBox).SelectedItem.Value = dr["MATERIAL"].ToString(); //재질
                        //(this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_MATERIAL") as Ext.Net.ComboBox).UpdateSelectedItems();

                        X.Js.Call("setValueCombo", "cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_MATERIAL", ChangeNulltoString(dr["MATERIAL"]).ToString()); //재질

                        ChangeMaterialCost(dr["MATERIAL"].ToString(), "0" + index, dr["MATERIAL_UCOST"].ToString()); //콤보가 생성되면서 값이 세팅된다.

                        //X.Js.Call("setValueCombo", "cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_MATERIAL_UCOST_H", dr["MATERIAL_UCOST"].ToString()); //재질단가

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_INGREDIENT_UCOST") as Ext.Net.NumberField).SetValue(ChangeNull(dr["INGREDIENT_UCOST"])); //재료비  
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_INGREDIENT_UCOST_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["INGREDIENT_UCOST"])); //재료비  

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_REMARK") as Ext.Net.TextField).SetValue(ChangeNulltoString(dr["REMARK"]).ToString()); //비고  

                        X.Js.Call("MaterialStyle", ((index > 9) ? index.ToString() : "0" + index), ChangeNulltoString(dr["PACK_MATERIAL"]).ToString()); // 스타일 설정

                        index++;
                    }
                        #endregion
                }

                index = 1;
                if (source_Manufacture.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in source_Manufacture.Tables[0].Rows)
                    {
                        #region [ 가공비 ]
                        X.Js.Call("setValueCombo", "cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PROC", ChangeNulltoString(dr["PROC"]).ToString()); // 공정명

                        ChangeProcCtime(ChangeNulltoString(dr["PROC"]).ToString(), "0" + index, ChangeNulltoString(dr["CTIME"]).ToString()); //콤보가 생성되면서 값이 세팅된다.

                        //X.Js.Call("setValueCombo", "cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_CTIME_H", ChangeNulltoString(dr["CTIME"]).ToString()); // CTIME

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_CV") as Ext.Net.NumberField).SetValue(ChangeNull(dr["CV"])); //CV
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_CV_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["CV"])); //CV

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_MAN_QTY") as Ext.Net.NumberField).SetValue(ChangeNull(dr["MAN_QTY"])); //인원
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_IMYUL") as Ext.Net.NumberField).SetValue(ChangeNull(dr["IMYUL"])); //임율

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_MAN_COST_TOTAL") as Ext.Net.NumberField).SetValue(ChangeNull(dr["MAN_COST_TOTAL"])); //노무비 금액
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_MAN_COST_TOTAL_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["MAN_COST_TOTAL"])); //노무비 금액

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_MACHINE_NM") as Ext.Net.TextField).SetValue(ChangeNulltoString(dr["MACHINE_NM"])); //기계명

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_MACHINE_COST") as Ext.Net.NumberField).SetValue(ChangeNull(dr["MACHINE_COST"])); //기계경비
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_MACHINE_COST_h") as Ext.Net.NumberField).SetValue(ChangeNull(dr["MACHINE_COST"])); //기계경비

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_MACHINE_COST_TOTAL") as Ext.Net.NumberField).SetValue(ChangeNull(dr["MACHINE_COST_TOTAL"])); //금액
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_MACHINE_COST_TOTAL_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["MACHINE_COST_TOTAL"])); //금액

                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_COST_TOTAL") as Ext.Net.NumberField).SetValue(ChangeNull(dr["COST_TOTAL"])); //가공비
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_COST_TOTAL_H") as Ext.Net.NumberField).SetValue(ChangeNull(dr["COST_TOTAL"])); //가공비
                        X.Js.Call("ProcStyle", ((index > 9) ? index.ToString() : "0" + index)); // 스타일 설정
                        index++;
                        #endregion
                    }
                }

                //txt01_initCheck.Value = "1";

            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        private object ChangeNull(object p)
        {
            if (p == DBNull.Value)
            {
                return null;
            }
            else return p;
        }

        private object ChangeNulltoString(object p)
        {
            if (p == DBNull.Value || p == null)
            {
                return "";
            }
            else return p;
        }

        #endregion

        #region [DataSet 가져오기]
        /// <summary>
        /// 기본정보
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Basic()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("PARTNO", txt01_PARTNO.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_BASIC"), param);
        }

        /// <summary>
        /// 재료비
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Ingredient()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("PARTNO", txt01_PARTNO.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_INGREDIENT"), param);
        }

        /// <summary>
        /// 가공비
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Manufacture()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("PARTNO", txt01_PARTNO.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_MANUFACTURE"), param);
        }

        /// <summary>
        /// 기본정보 출력
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Basic_Print()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("PARTNO", txt01_PARTNO.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_BASIC_PRINT"), param);
        }


        /// <summary>
        /// 재료비 출력
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Ingredient_Print()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("PARTNO", txt01_PARTNO.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_INGREDIENT_PRINT"), param);
        }

        /// <summary>
        /// 가공비 출력
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Manufacture_Print()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("PARTNO", txt01_PARTNO.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_MANUFACTURE_PRINT"), param);
        }
        #endregion

        #region [ 저장 ]
        /// <summary>
        /// SaveAndDelete
        /// 저장(업데이트)
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                ArrayList arrDataSet = new ArrayList();
                ArrayList arrProcedure = new ArrayList();

                this.Remove_All(arrDataSet, arrProcedure); //기본정보 제외 모두 삭제

                if (!this.Save_Basic(arrDataSet, arrProcedure)) // 기본정보 삭제
                {
                    return;
                }

                if (!this.Save_Ingredient(arrDataSet, arrProcedure)) //재료비
                {
                    return;
                }

                if (!this.Save_Manufacture(arrDataSet, arrProcedure)) //가공비
                {
                    return;
                }

                //한 transation에 넣기 위해 변수에 담는다.
                string[] procedure = new string[arrProcedure.Count];
                DataSet[] param = new DataSet[arrDataSet.Count];
                for (int i = 0; i < arrDataSet.Count; i++)
                {
                    procedure[i] = (string)arrProcedure[i];
                    param[i] = (DataSet)arrDataSet[i];
                }


                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.MultipleExecuteNonQueryTx(procedure, param);
                    this.MsgCodeAlert("COM-00902");//정상적으로 저장되었습니다.                    
                    this.Reset(false);
                    this.Search();
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
        /// 기본정보 제외 전체 삭제
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        private void Remove_All(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema("PARTNO");
                param.Tables[0].Rows.Add(this.txt01_PARTNO.Value);
                ds.Add(param);
                proc.Add("APG_SRM_PS20002.REMOVE_ALL");
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
        /// 기본정보
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        private bool Save_Basic(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "PARTNO", "PARTNM",
                                 "VINCD", "CUSTCD", "LOAD_QTY", "TYPE_STANDARD", "VENDCD", "TOP_PART_X",
                                 "TOP_PART_Y", "TOP_PART_Z", "TOP_MID_X", "TOP_MID_Y", "TOP_MID_Z",
                                 "LOAD_X", "LOAD_Y", "LOAD_Z", "LOAD_TOTAL", "VEND_DIV",
                                 "PART_DIV", "MATERIAL_SUM", "MANUFATUR_SUM", "BASIC_COST", "PROFIT",
                                 "MATERIAL_MANAGE_COST", "PROC_HEAT", "PROC_VALUE", "PROC_VALUE2", "STUFF_CHARGE",
                                 "STUFF_CHARGE_VALUE", "STUFF_CHARGE_VALUE2", "USE_MACHINE", "USE_MACHINE_VALUE", "USE_MACHINE_VALUE2",
                                 "MOLD_COST", "PACKING_TOTAL", "WRITE_DATE", "WRITER", "CHECKER",
                                 "APPLYER", "CHECK_BOXCOST", "DECIDED_BOXCOST", "CHECK_EACOST", "DECIDED_EACOST",
                                 "USER_ID");
                //NUMBER FIELD의 경우에는 VALUE값을 사용하면 NULL일경우에 -4~~~~~~~ 의 값이 들어가서 TEXT로 사용
                param.Tables[0].Rows.Add
                        (
                            this.txt01_PARTNO.Text, this.txt01_PARTNM.Text,
                            this.cdx01_VINCD.Value, this.cbo01_CUSTCD.Value, this.txt01_LOAD_QTY.Text, this.txt01_TYPE.Text, this.cdx01_VENDCD.Value, this.txt01_TOP_PART_X.Text,
                            this.txt01_TOP_PART_Y.Text, this.txt01_TOP_PART_Z.Text, this.txt01_TOP_MID_X.Text, this.txt01_TOP_MID_Y.Text, this.txt01_TOP_MID_Z.Text,
                            this.txt01_LOAD_X.Text, this.txt01_LOAD_Y.Text, this.txt01_LOAD_Z.Text, this.txt01_LOAD_TOTAL.Text, this.cbo01_VEND_DIV.Text,
                            this.cbo01_PART_DIV.Value, this.txt01_MATERIAL_SUM_H.Text, this.txt01_MANUFATUR_SUM_H.Text, this.txt01_BASIC_COST_H.Text, this.txt01_PROFIT_H.Text,
                            this.txt01_MATERIAL_MANAGE_COST_H.Text, this.txt01_PROC_HEAT_H.Text, this.txt01_PROC_VALUE.Text, this.txt01_PROC_VALUE2.Text, this.txt01_STUFF_CHARGE_H.Text,
                            this.txt01_STUFF_CHARGE_VALUE.Text, this.txt01_STUFF_CHARGE_VALUE2.Text, this.txt01_USE_MACHINE_H.Text, this.txt01_USE_MACHINE_VALUE.Text, this.txt01_USE_MACHINE_VALUE2.Text,
                            this.txt01_MOLD_COST_H.Text, this.txt01_PACKING_TOTAL_H.Text, (this.dte01_WRITE_DATE.IsEmpty) ? "" : this.dte01_WRITE_DATE.Value.ToString().Substring(0, 10), this.txt01_WRITER.Text, this.txt01_CHECKER.Text,
                            this.txt01_APPLYER.Text, this.txt01_CHECK_BOXCOST_H.Text, this.txt01_DECIDED_BOXCOST_H.Text, this.txt01_CHECK_EACOST_H.Text, this.txt01_DECIDED_EACOST_H.Text,
                            UserInfo.UserID
                        );

                //유효성 검사
                if (!ValidationBasic(param))
                {
                    return false;
                }

                ds.Add(param);
                proc.Add("APG_SRM_PS20002.SAVE_BASIC");

            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {

            }
            return true;
        }

        /// <summary>
        /// 재료비
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        private bool Save_Ingredient(ArrayList ds, ArrayList proc)
        {
            try
            {
                Ext.Net.ComboBox tx_pack_material = new Ext.Net.ComboBox();
                Ext.Net.NumberField tx_part_size_x = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_part_size_y = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_part_size_z = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_part_usage = new Ext.Net.NumberField();
                Ext.Net.ComboBox tx_part_usage_unit = new Ext.Net.ComboBox();
                Ext.Net.NumberField tx_ucost = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_ucost_add = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_ucost_total = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_jang = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_pok = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_apply_jipok = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_jaejok = new Ext.Net.NumberField();
                Ext.Net.ComboBox tx_material = new Ext.Net.ComboBox();
                Ext.Net.ComboBox tx_material_ucost = new Ext.Net.ComboBox();
                Ext.Net.NumberField tx_ingredient_ucost = new Ext.Net.NumberField();
                Ext.Net.TextField tx_remark = new Ext.Net.TextField();

                DataSet param = Util.GetDataSourceSchema(
                                 "PARTNO", "PACK_MATERIAL", "PART_SIZE_X", "PART_SIZE_Y", "PART_SIZE_Z", "PART_USAGE",
                                 "PART_USAGE_UNIT", "UCOST", "UCOST_ADD", "UCOST_TOTAL", "JANG", "POK",
                                 "APPLY_JIPOK", "JAEJOK", "MATERIAL", "MATERIAL_UCOST", "INGREDIENT_UCOST", "REMARK",
                                 "SORT_SEQ", "TEMP_SEQ");
                int index = 1;
                for (int i = 1; i < 15; i++)
                {
                    tx_pack_material = (this.FindControl("cbo" + ((i > 9) ? i.ToString() : "0" + i) + "_PACK_MATERIAL") as Ext.Net.ComboBox);
                    tx_part_size_x = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_PART_SIZE_X") as Ext.Net.NumberField);
                    tx_part_size_y = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_PART_SIZE_Y") as Ext.Net.NumberField);
                    tx_part_size_z = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_PART_SIZE_Z") as Ext.Net.NumberField);
                    tx_part_usage = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_PART_USAGE") as Ext.Net.NumberField);
                    tx_part_usage_unit = (this.FindControl("cbo" + ((i > 9) ? i.ToString() : "0" + i) + "_PART_USAGE_UNIT") as Ext.Net.ComboBox);
                    tx_ucost = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_UCOST_H") as Ext.Net.NumberField);
                    tx_ucost_add = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_UCOST_ADD_H") as Ext.Net.NumberField);
                    tx_ucost_total = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_UCOST_TOTAL_H") as Ext.Net.NumberField);
                    tx_jang = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_JANG_H") as Ext.Net.NumberField);
                    tx_pok = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_POK_H") as Ext.Net.NumberField);
                    tx_apply_jipok = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_APPLY_JIPOK") as Ext.Net.NumberField);
                    tx_jaejok = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_JAEJOK_H") as Ext.Net.NumberField);
                    tx_material = (this.FindControl("cbo" + ((i > 9) ? i.ToString() : "0" + i) + "_MATERIAL") as Ext.Net.ComboBox);
                    tx_material_ucost = (this.FindControl("cbo" + ((i > 9) ? i.ToString() : "0" + i) + "_MATERIAL_UCOST_H") as Ext.Net.ComboBox);
                    tx_ingredient_ucost = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_INGREDIENT_UCOST_H") as Ext.Net.NumberField);
                    tx_remark = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_REMARK") as Ext.Net.TextField);

                    //NUMBER FIELD의 경우에는 VALUE값을 사용하면 NULL일경우에 -4~~~~~~~ 의 값이 들어가서 TEXT로 사용
                    if (!string.IsNullOrEmpty(tx_pack_material.Text)) //재료명이 존재할 경우만
                    {
                        param.Tables[0].Rows.Add
                                (
                                    txt01_PARTNO.Text
                                    , tx_pack_material.Value, tx_part_size_x.Text, tx_part_size_y.Text, tx_part_size_z.Text, tx_part_usage.Text
                                    , tx_part_usage_unit.Value, tx_ucost.Text, tx_ucost_add.Text, tx_ucost_total.Text, tx_jang.Text
                                    , tx_pok.Text, tx_apply_jipok.Text, tx_jaejok.Text, tx_material.Value, tx_material_ucost.Value
                                    , tx_ingredient_ucost.Text, tx_remark.Text
                                    , index, i
                                );
                        index++;
                    }
                }
                //유효성 검사
                if (!ValidationIngredient(param))
                {
                    return false;
                }
                param.Tables[0].Columns.Remove("TEMP_SEQ");
                ds.Add(param);
                proc.Add("APG_SRM_PS20002.SAVE_INGREDIENT");
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
                return false;
            }
            finally
            {

            }
            return true;
        }

        /// <summary>
        /// 가공비
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        private bool Save_Manufacture(ArrayList ds, ArrayList proc)
        {
            try
            {
                Ext.Net.ComboBox tx_proc = new Ext.Net.ComboBox();
                Ext.Net.ComboBox tx_ctime = new Ext.Net.ComboBox();
                Ext.Net.NumberField tx_cv = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_man_qty = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_imyul = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_man_cost_total = new Ext.Net.NumberField();
                Ext.Net.TextField tx_machine_nm = new Ext.Net.TextField();
                Ext.Net.NumberField tx_machine_cost = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_machine_cost_total = new Ext.Net.NumberField();
                Ext.Net.NumberField tx_cost_total = new Ext.Net.NumberField();

                DataSet param = Util.GetDataSourceSchema(
                                 "PARTNO", "PROC", "CTIME", "CV", "MAN_QTY", "IMYUL",
                                 "MAN_COST_TOTAL", "MACHINE_NM", "MACHINE_COST", "MACHINE_COST_TOTAL", "COST_TOTAL",
                                 "SORT_SEQ", "TEMP_SEQ");
                int index = 1;
                for (int i = 1; i < 7; i++)
                {
                    tx_proc = (this.FindControl("cbo" + ((i > 9) ? i.ToString() : "0" + i) + "_PROC") as Ext.Net.ComboBox);
                    tx_ctime = (this.FindControl("cbo" + ((i > 9) ? i.ToString() : "0" + i) + "_CTIME_H") as Ext.Net.ComboBox);
                    tx_cv = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_CV_H") as Ext.Net.NumberField);
                    tx_man_qty = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_MAN_QTY") as Ext.Net.NumberField);
                    tx_imyul = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_IMYUL") as Ext.Net.NumberField);
                    tx_man_cost_total = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_MAN_COST_TOTAL_H") as Ext.Net.NumberField);
                    tx_machine_nm = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_MACHINE_NM") as Ext.Net.TextField);
                    tx_machine_cost = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_MACHINE_COST_H") as Ext.Net.NumberField);
                    tx_machine_cost_total = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_MACHINE_COST_TOTAL_H") as Ext.Net.NumberField);
                    tx_cost_total = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_COST_TOTAL_H") as Ext.Net.NumberField);

                    if (!string.IsNullOrEmpty(tx_proc.Text)) //공정명이 존재할 경우만 진행
                    {
                        param.Tables[0].Rows.Add
                                (
                                    txt01_PARTNO.Text
                                    , tx_proc.Value, tx_ctime.Text, tx_cv.Text, tx_man_qty.Text, tx_imyul.Text
                                    , tx_man_cost_total.Text, tx_machine_nm.Text, tx_machine_cost.Text, tx_machine_cost_total.Text, tx_cost_total.Text
                                    , index, i
                                );
                        index++;
                    }
                }
                //유효성 검사
                if (!ValidationManufacture(param))
                {
                    return false;
                }
                param.Tables[0].Columns.Remove("TEMP_SEQ");
                ds.Add(param);
                proc.Add("APG_SRM_PS20002.SAVE_MANUFATURE");
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
                return false;
            }
            finally
            {

            }
            return true;
        }
        #endregion

        #region [유효성]
        /// <summary>
        /// 기본정보 필수체크
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        private bool ValidationBasic(DataSet param)
        {
            if (param.Tables[0].Rows.Count > 0)
            {
                string lable = string.Empty;
                for (int i = 0; i < param.Tables[0].Columns.Count; i++)
                {
                    if (string.IsNullOrEmpty(param.Tables[0].Rows[0][i].ToString()))
                    {
                        string componentName = string.Empty;
                        if (i == 0) { lable = "품번"; componentName = "txt01_PARTNO"; }
                        else if (i == 1) { lable = "품명"; componentName = "txt01_PARTNM"; }
                        else if (i == 2) { lable = "차종"; componentName = "cdx01_VINCD"; }
                        else if (i == 3) { lable = "해외법인명"; componentName = "cbo01_CUSTCD"; }
                        else if (i == 4) { lable = "적입수량"; componentName = "txt01_LOAD_QTY"; }
                        //else if (i == 5) { lable = "중포장코드"; componentName = "txt01_TYPE"; }                       
                        else if (i == 6) { lable = "업체명"; componentName = "cdx01_VENDCD"; }

                        if (!string.IsNullOrEmpty(lable))
                        {
                            this.MsgCodeAlert_ShowFormat("EP20S01-003", componentName, new string[] { lable }); //{0}를(을) 입력해주세요.
                            return false;
                        }
                    }
                }
            }
            return true;
        }

        private bool ValidationIngredient(DataSet param)
        {
            //PARAM에는 이미 포장재가 존재하는 값만 만들어져 있음.
            if (param.Tables[0].Rows.Count > 0)
            {
                string lable = string.Empty;
                string index = string.Empty;
                string component = string.Empty;
                for (int i = 0; i < param.Tables[0].Rows.Count; i++)
                {
                    int temp_index = int.Parse(param.Tables[0].Rows[i]["TEMP_SEQ"].ToString());
                    index = (temp_index < 10) ? "0" + (temp_index) : (temp_index).ToString();

                    if (param.Tables[0].Rows[i]["PACK_MATERIAL"].ToString().Equals("C/BOX"))
                    {
                        if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["PART_SIZE_Z"].ToString()))
                        {
                            lable = index + "행의 규격 두께";
                            component = (this.FindControl("txt" + index + "_PART_SIZE_Z") as Ext.Net.NumberField).ID;
                            break;
                        }
                        else if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["MATERIAL"].ToString()))
                        {
                            lable = index + "행의 규격 재질";
                            component = (this.FindControl("cbo" + index + "_MATERIAL") as Ext.Net.ComboBox).ID;
                            break;
                        }
                        else if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["MATERIAL_UCOST"].ToString()))
                        {
                            lable = index + "행의 규격 재질단가";
                            component = (this.FindControl("cbo" + index + "_MATERIAL_UCOST") as Ext.Net.ComboBox).ID;
                            break;
                        }
                    }
                    else if (param.Tables[0].Rows[i]["PACK_MATERIAL"].ToString().Equals("C/PAD"))
                    {
                        if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["MATERIAL"].ToString()))
                        {
                            lable = index + "행의 규격 재질";
                            component = (this.FindControl("cbo" + index + "_MATERIAL") as Ext.Net.ComboBox).ID;
                            break;
                        }
                        else if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["MATERIAL_UCOST"].ToString()))
                        {
                            lable = index + "행의 규격 재질단가";
                            component = (this.FindControl("cbo" + index + "_MATERIAL_UCOST_H") as Ext.Net.ComboBox).ID;
                            break;
                        }
                    }
                    else if (param.Tables[0].Rows[i]["PACK_MATERIAL"].ToString().Equals("VINYL BAG") || param.Tables[0].Rows[i]["PACK_MATERIAL"].ToString().Equals("PE BAG") || param.Tables[0].Rows[i]["PACK_MATERIAL"].ToString().Equals("PE SHEET"))
                    {
                        if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["PART_SIZE_Z"].ToString()))
                        {
                            lable = index + "행의 규격 두께";
                            component = (this.FindControl("txt" + index + "_PART_SIZE_Z") as Ext.Net.NumberField).ID;
                            break;
                        }
                    }
                    else if (param.Tables[0].Rows[i]["PACK_MATERIAL"].ToString().Equals("격자 1 (가로)") || param.Tables[0].Rows[i]["PACK_MATERIAL"].ToString().Equals("격자 1 (세로)"))
                    {
                        if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["MATERIAL"].ToString()))
                        {
                            lable = index + "행의 규격 재질";
                            component = (this.FindControl("cbo" + index + "_MATERIAL") as Ext.Net.ComboBox).ID;
                            break;
                        }
                        else if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["MATERIAL_UCOST"].ToString()))
                        {
                            lable = index + "행의 규격 재질단가";
                            component = (this.FindControl("cbo" + index + "_MATERIAL_UCOST") as Ext.Net.ComboBox).ID;
                            break;
                        }
                    }

                    if (string.IsNullOrEmpty(lable) && string.IsNullOrEmpty(param.Tables[0].Rows[i]["PART_USAGE"].ToString()))
                    {
                        lable = index + "행의 US";
                        component = (this.FindControl("txt" + index + "_PART_USAGE") as Ext.Net.NumberField).ID;
                        break;
                    }

                }
                if (string.IsNullOrEmpty(lable)) return true;
                else
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", component, new string[] { "재료비의 " + lable }); //{0}를(을) 입력해주세요.
                    return false;
                }

            }
            else
            {
                this.MsgCodeAlert_ShowFormat("SRM_PS-0001", new string[] { "재료비" });//저장할 데이터가 없습니다.
                return false;
            }
        }


        private bool ValidationManufacture(DataSet param)
        {
            //PARAM에는 이미 포장재가 존재하는 값만 만들어져 있음.
            if (param.Tables[0].Rows.Count > 0)
            {
                string lable = string.Empty;
                string index = string.Empty;
                string component = string.Empty;
                for (int i = 0; i < param.Tables[0].Rows.Count; i++)
                {
                    int temp_index = int.Parse(param.Tables[0].Rows[i]["TEMP_SEQ"].ToString());
                    index = (temp_index < 10) ? "0" + (temp_index) : (temp_index).ToString();
                    if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["CV"].ToString()))
                    {
                        lable = index + "행의 C/V";
                        component = (this.FindControl("txt" + index + "_CV") as Ext.Net.NumberField).ID;
                        break;
                    }

                }
                if (string.IsNullOrEmpty(lable)) return true;
                else
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", component, new string[] { "가공비의 " + lable }); //{0}를(을) 입력해주세요.
                    return false;
                }

            }
            else
            {
                this.MsgCodeAlert_ShowFormat("SRM_PS-0001", new string[] { "가공비" });//저장할 데이터가 없습니다.
                return false;
            }
        }
        #endregion

        #region [util성]
        private object getDateString(DateField df)
        {
            if (df.Value == null)
            {
                return null;
            }
            else
            {
                if (df.Value.Equals(df.EmptyValue))
                {
                    return null;
                }
                else
                {
                    return ((DateTime)df.Value).ToString("yyyy-MM-dd");
                }
            }
        }
        #endregion

    }
}
