#region ▶ Description & History
/* 
 * 프로그램명 : 업체 기본현황 작성
 * 설      명 : Home > 협력업체관리 > 업체정보관리 > 기본정보등록
 * 최초작성자 : 배명희
 * 최초작성일 : 2014-11-04
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
using System.Timers;

namespace Ax.EP.WP.Home.SRM_PS
{
    public partial class SRM_PS20001P1 : BasePage
    {
        private string pakageName = "APG_SRM_PS20001";
        //private string noimage = "../../images/common/no_image.gif";
        System.Timers.Timer timer = new System.Timers.Timer();

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_PS20001
        /// </summary>
        public SRM_PS20001P1()
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

                    this.SetCombo();
                    this.Reset(true);
                    //this.hid01_MAIN_PARTNO.SetValue(Request.Params["Main_Partno"]); // 메인 partno
                    this.hid01_MAIN_PARTNO.SetValue(Request.Params["MODE"]); //신규:N, 수정:M
                    this.txt01_MAIN_PARTNO.SetValue(Request.Params["Main_Partno"]);
                    this.txt01_ID.Text = Request.Params["ID"];
                    this.dte01_REG_DATE.Value = Request.Params["REG_DATE"];

                    this.txt01_MAIN_PARTNO.ReadOnly = false;
                    this.dte01_REG_DATE.ReadOnly = false;
                    if (this.hid01_MAIN_PARTNO.Text.Equals("M")) //수정일 경우에
                    {
                        this.txt01_MAIN_PARTNO.ReadOnly = true; //수정일경우에
                        this.dte01_REG_DATE.ReadOnly = true;
                    }
                    else if (this.hid01_MAIN_PARTNO.Text.Equals("V")) //view모드일경우에 저장버튼 제거
                    {
                        btn01_SAVE_L.Visible = false;
                        btn01_SAVE_T.Visible = false;
                        (FindControl(ButtonID.Reset) as Ext.Net.ImageButton).Visible = false;
                    }

                    // 자재팀 이외에 대포장정보, 승인 수정 불가
                    if (!this.UserInfo.UserDivision.Equals("T12"))
                    {
                        //대포장
                        this.txt01_LARGE_PACKCODE.ReadOnly = true;
                        this.txt01_LARGE_PACK_X.ReadOnly = true;
                        this.txt01_LARGE_PACK_Y.ReadOnly = true;
                        this.txt01_LARGE_PACK_Z.ReadOnly = true;
                        this.txt01_LARGE_F_QTY.ReadOnly = true;
                        this.cbo01_LARGE_F_QTY_UNIT.ReadOnly = true;
                        this.txt01_LARGE_LOAD_DEPTH.ReadOnly = true;
                        this.txt01_LARGE_LOAD_QTY.ReadOnly = true;
                        this.txt01_LARGE_LOAD_QTY_EA.ReadOnly = true;
                        this.cbo01_LARGE_LOAD_QTY_UNIT.ReadOnly = true;
                        this.txt01_LARGE_BOX_WEIGHT.ReadOnly = true;
                        this.cbo01_LARGE_ANTI_RUST.ReadOnly = true;
                        this.cbo01_LARGE_PO_MEASURE.ReadOnly = true;
                        this.txt01_LARGE_PO_MIN_QTY.ReadOnly = true;
                        this.txt01_LARGE_LOAD_RATE.ReadOnly = true;

                        //승인
                        this.dte01_SEOYON_ACCEPT_DATE.ReadOnly = true;
                        this.txt01_SEOYON_CHARGER.ReadOnly = true;
                        //this.txt01_SEOYON_CHECK.ReadOnly = true;
                        this.txt01_SEOYON_APPLY.ReadOnly = true;
                        this.dte01_CUST_ACCEPT_DATE.ReadOnly = true;
                        //this.txt01_CUST_CHECK.ReadOnly = true;
                        this.txt01_CUST_APPLY.ReadOnly = true;
                        this.dte01_GLOBAL_ACCEPT_DATE.ReadOnly = true;
                        this.txt01_GLOBAL_CHECK.ReadOnly = true;
                    }

                    this.Search("1");

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
            //MakeButton("ButtonSaveTemp", ButtonImage.Save, "Save", this.ButtonPanel);
            //MakeButton(ButtonID.Save, ButtonImage.Save, "최종 Save", this.ButtonPanel);
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
                case "btn01_REMOVE_PHOTO1":
                    PhotoDeleteConfirm("1");
                    break;
                case "btn01_REMOVE_PHOTO2":
                    PhotoDeleteConfirm("2");
                    break;
                case "btn01_GET_LAGE_PACKINFO":
                    POPUP("L");
                    break;
                case "btn01_GET_MID_PACKINFO":
                    POPUP("M");
                    break;
                case "btn01_SAVE_T":
                    SaveTemp(sender, e);
                    break;
                case "btn01_SAVE_L":
                    SaveLast(sender, e);
                    break;
                default:
                    break;
            }
        }

        #region [첨부파일, 이미지 -  업로드 및 삭제 관련]

        /// <summary>
        /// fileDeleteConfirm
        /// </summary>
        /// <param name="fileID"></param>
        public void PhotoDeleteConfirm(string photono)
        {
            string photo_yn = "";
            if (photono.Equals("1"))
                photo_yn = this.hid01_PHOTO1.Value.ToString();
            else
                photo_yn = this.hid01_PHOTO2.Value.ToString();

            if (photo_yn.Equals(string.Empty))
            {
                //제품 사진이 존재하지 않습니다.
                this.MsgCodeAlert("SRMVM-0003");
            }
            else
            {
                X.MessageBox.Confirm("Confirm", Library.getMessage("EP20010-001"), new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.PhotoDelete('" + photono + "')",
                        Text = "Yes"
                    },
                    No = new MessageBoxButtonConfig
                    {
                        Text = "No"
                    }
                }).Show();
            }
        }


        /// <summary>
        /// fileDelete DirectMethod
        /// </summary>
        /// <param name="fileID"></param>
        [DirectMethod]
        public void PhotoDelete(string photono)
        {
            try
            {
                // 1. db로부터 이미지 삭제
                HEParameterSet param = new HEParameterSet();
                param.Add("MAIN_PARTNO", this.txt01_MAIN_PARTNO.Value);
                param.Add("USER_ID", this.UserInfo.UserID);
                param.Add("PHOTONO", photono);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_PHOTO"), param);
                    this.MsgCodeAlert("EP20010-003");
                }

                if (photono.Equals("1"))
                {
                    this.hid01_PHOTO1.Value = string.Empty;
                    this.fuf01_PHOTO1.Reset();
                    img01_PHOTO1.ImageUrl = CommonString.NoImage;
                }
                else
                {
                    this.hid01_PHOTO2.Value = string.Empty;
                    this.fuf01_PHOTO2.Reset();
                    img01_PHOTO2.ImageUrl = CommonString.NoImage;
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

        #region [포장재료 선택 관련]
        /// <summary>
        /// MATERIAL_SELECT
        /// 포장재료 선택
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void MATERIAL_SELECT(object sender, DirectEventArgs e)
        {
            //Ext.Net.ComboBox cb = (Ext.Net.ComboBox)sender;
            //string selectedItem = cb.SelectedItem.Value;

            //HEParameterSet param = new HEParameterSet();
            //param.Add("PACK_MATERIAL", selectedItem);

            //DataSet ds =  EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SELECT_MAT"), param);
            //if (ds.Tables[0].Rows.Count > 0)
            //{
            //    string depth = cb.ID.Split('_')[0].ToString().Replace("cbo", "").Replace("PACK_MATERIAL", "");

            //    Ext.Net.TextField tx_material = this.FindControl("txt" + depth + "_MATERIAL") as Ext.Net.TextField;//재질
            //    Ext.Net.TextField tx_standard = this.FindControl("txt" + depth + "_STANDARD") as Ext.Net.TextField;//규격
            //    Ext.Net.ComboBox cbo_measure = this.FindControl("cbo" + depth + "_MAT_UNIT") as Ext.Net.ComboBox; //단위
            //    Ext.Net.NumberField nf2 = this.FindControl("txt" + depth + "_PACK_USAGE") as Ext.Net.NumberField; //소요량

            //    tx_material.SetValue(ds.Tables[0].Rows[0]["MATERIAL"]);
            //    tx_standard.SetValue(ds.Tables[0].Rows[0]["STANDARD"]);
            //    cbo_measure.SelectedItem.Value = (ds.Tables[0].Rows[0]["MAT_UNIT"] == DBNull.Value) ? "" : ds.Tables[0].Rows[0]["MAT_UNIT"].ToString();
            //    cbo_measure.UpdateSelectedItems();
            //    nf2.SetValue(ds.Tables[0].Rows[0]["PACK_USAGE"]);
            //}

        }
        #endregion

        #region [리포트 출력 관련]

        private void PrintConfirm()
        {
            //if (!this.IsQueryValidation()) return;

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
            //if (!this.IsQueryValidation()) return;
            if (string.IsNullOrEmpty(this.txt01_MAIN_PARTNO.Text))
            {
                this.MsgCodeAlert("COM-00807"); //출력할 정보가 없습니다.
                return;
            }

            HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
            report.ReportName = "1000/SRM_PS/SRM_PS20001";

            // Main Section ( 메인리포트 파라메터셋 )
            HERexSection mainSection = new HERexSection();
            //mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");            

            report.Sections.Add("MAIN", mainSection);

            // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
            DataSet ds = this.getDataSet_Basic_Print(this.txt01_MAIN_PARTNO.Text, this.dte01_REG_DATE.Value.ToString().Substring(0, 10));

            if (ds.Tables[0].Rows.Count <= 0)
            {
                this.MsgCodeAlert_ShowFormat("COM-00022");
                return;
            }
            DataSet ds1 = this.getDataSet_Same_Print(this.txt01_MAIN_PARTNO.Text, this.dte01_REG_DATE.Value.ToString().Substring(0, 10));
            DataSet ds2 = this.getDataSet_Ingridient_Print(this.txt01_MAIN_PARTNO.Text, this.dte01_REG_DATE.Value.ToString().Substring(0, 10));
            DataSet ds3 = this.getDataSet_ChangeHistory_Print(this.txt01_MAIN_PARTNO.Text, this.dte01_REG_DATE.Value.ToString().Substring(0, 10));
            DataSet ds4 = this.getDataSet_Apply(this.txt01_MAIN_PARTNO.Text, this.dte01_REG_DATE.Value.ToString().Substring(0, 10));

            // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
            // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
            //ds.Tables[0].TableName = "DATA";
            //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
            //ds1.Tables[0].TableName = "DATA";
            //ds1.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "01.xml", XmlWriteMode.WriteSchema);
            //ds2.Tables[0].TableName = "DATA";
            //ds2.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "02.xml", XmlWriteMode.WriteSchema);
            //ds3.Tables[0].TableName = "DATA";
            //ds3.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "03.xml", XmlWriteMode.WriteSchema);
            //ds4.Tables[0].TableName = "DATA";
            //ds4.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "04.xml", XmlWriteMode.WriteSchema);
            //ds5.Tables[0].TableName = "DATA";
            //ds5.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "05.xml", XmlWriteMode.WriteSchema);
            //ds6.Tables[0].TableName = "DATA";
            //ds6.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "06.xml", XmlWriteMode.WriteSchema);

            HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
            HERexSection xmlSectionSub1 = new HERexSection(ds1, new HEParameterSet());
            HERexSection xmlSectionSub2 = new HERexSection(ds2, new HEParameterSet());
            HERexSection xmlSectionSub3 = new HERexSection(ds3, new HEParameterSet());
            HERexSection xmlSectionSub4 = new HERexSection(ds4, new HEParameterSet());

            // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
            // xmlSection.ReportParameter.Add("CORCD", "1000");
            report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
            report.Sections.Add("XML1", xmlSectionSub1);
            report.Sections.Add("XML2", xmlSectionSub2);
            report.Sections.Add("XML3", xmlSectionSub3);
            report.Sections.Add("XML4", xmlSectionSub4);

            AxReportForm.ShowReport(report);

        }
        #endregion



        #endregion

        #region [ 코드박스 이벤트 핸들러 ]

        #endregion

        #region [ 기능 ]
        #endregion

        #region [ 초기화 관련 ]
        /// <summary>
        /// 콤보상자 바인딩(유형코드 등등) (필요할 경우 사용)
        /// </summary>
        private void SetCombo()
        {
            //유형코드
            DataSet source = Library.GetTypeCode("VB");

            HEParameterSet paramSet = new HEParameterSet();
            paramSet.Add("LANG_SET", this.UserInfo.LanguageShort);
            DataSet source_VEND = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_VENDCD"), paramSet);
            Library.ComboDataBind(this.cbo01_CUSTCD, source_VEND.Tables[0], false, "NAME", "ID", true, "ALL");
        }

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset(bool isAllReset)
        {
            if (isAllReset)
            {
                this.ClearInput(this.Controls, isAllReset);
            }
            //이미지
            this.hid01_PHOTO1.Value = string.Empty;
            this.hid01_PHOTO2.Value = string.Empty;
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
                    if (txtField.ID != "txt01_percentLabel" && txtField.ID != "txt01_ID")
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
                    if (cboField.ID.IndexOf("PACK_MATERIAL") == -1)
                    {
                        //cboField.SelectedItem.Value = cboField.Items[0].Value;
                        cboField.SelectedItem.Index = 0;
                        cboField.UpdateSelectedItems();
                    }
                    else
                    {
                        cboField.SelectedItem.Value = string.Empty;
                        cboField.UpdateSelectedItems();
                    }

                    continue;

                }

                //number필드인 경우
                Ext.Net.NumberField numField = ctrl as Ext.Net.NumberField;
                if (numField != null)
                {
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
                    if (!dateField.ID.Equals("dte01_REG_DATE")) dateField.SetValue(null);
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
        public void Search(string type)
        {
            try
            {
                DataSet source_Basic = this.getDataSet_Basic(txt01_MAIN_PARTNO.Text, dte01_REG_DATE.Value.ToString().Substring(0, 10));
                DataSet source_Same = this.getDataSet_Same(txt01_MAIN_PARTNO.Text, dte01_REG_DATE.Value.ToString().Substring(0, 10));
                DataSet source_Ingridient = this.getDataSet_Ingridient(txt01_MAIN_PARTNO.Text, dte01_REG_DATE.Value.ToString().Substring(0, 10));
                DataSet source_ChangeHistory = this.getDataSet_ChangeHistory(txt01_MAIN_PARTNO.Text, dte01_REG_DATE.Value.ToString().Substring(0, 10));
                DataSet source_Apply = this.getDataSet_Apply(txt01_MAIN_PARTNO.Text, dte01_REG_DATE.Value.ToString().Substring(0, 10));

                if (source_Basic.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = source_Basic.Tables[0].Rows[0];

                    #region [ 기본 정보 ]
                    this.cbo01_CUSTCD.SelectedItem.Value = ChangeNulltoString(dr["CUSTCD"]).ToString();//법인명
                    this.cbo01_CUSTCD.UpdateSelectedItems();
                    this.cdx01_VINCD.SetValue(ChangeNulltoString(dr["VINCD"])); //차종

                    this.cbo01_SPEC.SelectedItem.Value = ChangeNulltoString(dr["SPEC"]).ToString();//사양
                    this.cbo01_SPEC.UpdateSelectedItems();

                    this.cbo01_TYPE.SelectedItem.Value = ChangeNulltoString(dr["TYPE"]).ToString();//유형
                    this.cbo01_TYPE.UpdateSelectedItems();
                    this.cdx01_VENDCD.SetValue(ChangeNulltoString(dr["VENDCD"])); //공급업체(포장업체)
                    this.dte01_B_REQUEST_DATE.SetValue(ChangeNulltoString(dr["REQUEST_DATE"])); //적용요구시점
                    this.dte01_B_APPLY_DATE.SetValue(ChangeNulltoString(dr["APPLY_DATE"])); //실적용시점
                    #endregion

                    #region [ 포장사진 및 포장방법 ]
                    this.img01_PHOTO1.ImageUrl = (dr["PHOTO1"] == DBNull.Value ? CommonString.NoImage : Util.FileEncoding((byte[])dr["PHOTO1"], true)); // 부품사진
                    this.hid01_PHOTO1.Text = (dr["PHOTO1"] == DBNull.Value ? string.Empty : "Y");

                    this.img01_PHOTO2.ImageUrl = (dr["PHOTO2"] == DBNull.Value ? CommonString.NoImage : Util.FileEncoding((byte[])dr["PHOTO2"], true)); // 포장사진
                    this.hid01_PHOTO2.Text = (dr["PHOTO2"] == DBNull.Value ? string.Empty : "Y");

                    this.txt01_NOTE.SetValue(ChangeNulltoString(dr["NOTE"])); //note
                    #endregion

                    #region [ 부품/중포장/대포장 정보 ]
                    this.txt01_MAIN_PARTNO.SetValue(ChangeNulltoString(dr["MAIN_PARTNO"]));
                    this.txt01_MID_PACKCODE.SetValue(ChangeNulltoString(dr["MID_PACKCODE"]));
                    this.txt01_LARGE_PACKCODE.SetValue(ChangeNulltoString(dr["LARGE_PACKCODE"]));
                    this.txt01_MAIN_PARTNM.SetValue(ChangeNulltoString(dr["MAIN_PARTNM"]));
                    this.txt01_MID_PACK_X.SetValue(ChangeNull(dr["MID_PACK_X"]));
                    this.txt01_MID_PACK_Y.SetValue(ChangeNull(dr["MID_PACK_Y"]));
                    this.txt01_MID_PACK_Z.SetValue(ChangeNull(dr["MID_PACK_Z"]));
                    this.txt01_LARGE_PACK_X.SetValue(ChangeNull(dr["LARGE_PACK_X"]));
                    this.txt01_LARGE_PACK_Y.SetValue(ChangeNull(dr["LARGE_PACK_Y"]));
                    this.txt01_LARGE_PACK_Z.SetValue(ChangeNull(dr["LARGE_PACK_Z"]));
                    this.cbo01_LARGE_PO_MEASURE.SelectedItem.Value = ChangeNulltoString(dr["LARGE_PO_MEASURE"]).ToString();
                    this.cbo01_LARGE_PO_MEASURE.UpdateSelectedItems();
                    this.txt01_MAIN_INGRIDIENT.SetValue(ChangeNulltoString(dr["MAIN_INGRIDIENT"]));
                    this.txt01_MID_F_QTY.SetValue(ChangeNull(dr["MID_F_QTY"]));

                    this.cbo01_MID_F_QTY_UNIT.SelectedItem.Value = ChangeNulltoString(dr["MID_F_QTY_UNIT"]).ToString();
                    this.cbo01_MID_F_QTY_UNIT.UpdateSelectedItems();
                    this.txt01_LARGE_F_QTY.SetValue(ChangeNull(dr["LARGE_F_QTY"]));

                    this.cbo01_LARGE_F_QTY_UNIT.SelectedItem.Value = ChangeNulltoString(dr["LARGE_F_QTY_UNIT"]).ToString();
                    this.cbo01_LARGE_F_QTY_UNIT.UpdateSelectedItems();

                    this.cbo01_SURFACE.SelectedItem.Value = ChangeNulltoString(dr["SURFACE"]).ToString();
                    this.cbo01_SURFACE.UpdateSelectedItems();
                    this.txt01_MID_LOAD_DEPTH.SetValue(ChangeNull(dr["MID_LOAD_DEPTH"]));
                    this.txt01_LARGE_LOAD_DEPTH.SetValue(ChangeNull(dr["LARGE_LOAD_DEPTH"]));
                    this.txt01_LARGE_PO_MIN_QTY.SetValue(ChangeNull(dr["LARGE_PO_MIN_QTY"]));
                    this.txt01_PART_WEIGHT.SetValue(ChangeNull(dr["PART_WEIGHT"]));
                    this.txt01_MID_LOAD_QTY.SetValue(ChangeNull(dr["MID_LOAD_QTY"]));

                    this.cbo01_MID_LOAD_QTY_UNIT.SelectedItem.Value = ChangeNulltoString(dr["MID_LOAD_QTY_UNIT"]).ToString();
                    this.cbo01_MID_LOAD_QTY_UNIT.UpdateSelectedItems();
                    this.cbo01_MID_LOAD_QTY_UNIT2.SelectedItem.Value = ChangeNulltoString(dr["MID_LOAD_QTY_UNIT2"]).ToString();
                    this.cbo01_MID_LOAD_QTY_UNIT2.UpdateSelectedItems();
                    this.txt01_LARGE_LOAD_QTY.SetValue(ChangeNull(dr["LARGE_LOAD_QTY"]));
                    this.txt01_LARGE_LOAD_QTY_EA.SetValue(ChangeNull(dr["LARGE_LOAD_QTY_EA"]));

                    this.cbo01_LARGE_LOAD_QTY_UNIT.SelectedItem.Value = ChangeNulltoString(dr["LARGE_LOAD_QTY_UNIT"]).ToString();
                    this.cbo01_LARGE_LOAD_QTY_UNIT.UpdateSelectedItems();
                    this.txt01_PART_SIZE_X.SetValue(ChangeNull(dr["PART_SIZE_X"]));
                    this.txt01_PART_SIZE_Y.SetValue(ChangeNull(dr["PART_SIZE_Y"]));
                    this.txt01_PART_SIZE_Z.SetValue(ChangeNull(dr["PART_SIZE_Z"]));
                    this.txt01_MID_BOX_WEIGHT.SetValue(ChangeNull(dr["MID_BOX_WEIGHT"]));
                    this.txt01_LARGE_BOX_WEIGHT.SetValue(ChangeNull(dr["LARGE_BOX_WEIGHT"]));
                    this.txt01_LARGE_LOAD_RATE.SetValue(ChangeNull(dr["LARGE_LOAD_RATE"]));
                    this.txt01_PART_USAGE.SetValue(ChangeNull(dr["PART_USAGE"]));

                    this.cbo01_PART_USAGE_UNIT.SelectedItem.Value = ChangeNulltoString(dr["PART_USAGE_UNIT"]).ToString();
                    this.cbo01_PART_USAGE_UNIT.UpdateSelectedItems();

                    this.cbo01_MID_ANTI_RUST.SelectedItem.Value = ChangeNulltoString(dr["MID_ANTI_RUST"]).ToString();
                    this.cbo01_MID_ANTI_RUST.UpdateSelectedItems();

                    this.cbo01_LARGE_ANTI_RUST.SelectedItem.Value = ChangeNulltoString(dr["LARGE_ANTI_RUST"]).ToString();
                    this.cbo01_LARGE_ANTI_RUST.UpdateSelectedItems();

                    this.dte01_REG_DATE.SetValue(ChangeNulltoString(dr["REG_DATE"]));

                    #endregion
                }

                int index = 1;
                if (source_Same.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in source_Same.Tables[0].Rows)
                    {
                        #region [ 동일포장사양  정보 ]
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_NO") as Ext.Net.NumberField).SetValue(dr["NO"]); //no
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_PARTNO") as Ext.Net.TextField).SetValue(ChangeNulltoString(dr["PARTNO"])); //동일품번
                        (this.FindControl("dte" + ((index > 9) ? index.ToString() : "0" + index) + "_APPLY_DATE") as Ext.Net.DateField).SetValue(ChangeNulltoString(dr["APPLY_DATE"])); //적용시점
                        #endregion
                        index++;
                    }
                }

                index = 1;
                if (source_Ingridient.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in source_Ingridient.Tables[0].Rows)
                    {
                        #region [ 포장재료 정보 ]
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_MID_NO") as Ext.Net.NumberField).SetValue(dr["MID_NO"].ToString()); //포장재 no

                        bool flag = false;
                        for (int i = 0; i < (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL") as Ext.Net.ComboBox).Items.Count; i++)
                        {
                            if (dr["PACK_MATERIAL"].ToString().Equals((this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL") as Ext.Net.ComboBox).Items[i].Value))
                            {
                                flag = true;
                                break;
                            }
                        }

                        if (flag == false)
                        {
                            (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL") as Ext.Net.ComboBox).Items.Insert(0, new Ext.Net.ListItem(ChangeNulltoString(dr["PACK_MATERIAL"]).ToString(), ChangeNulltoString(dr["PACK_MATERIAL"]).ToString()));
                            if (type.Equals("2")) (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL") as Ext.Net.ComboBox).Update();
                            (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL") as Ext.Net.ComboBox).SelectedItem.Value = ChangeNulltoString(dr["PACK_MATERIAL"]).ToString(); //포장재                                                                        
                            (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL") as Ext.Net.ComboBox).UpdateSelectedItems(); //꼭 해줘야한다.
                        }
                        else
                        {
                            (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL") as Ext.Net.ComboBox).SelectedItem.Value = ChangeNulltoString(dr["PACK_MATERIAL"]).ToString(); //포장재                                                                        
                            (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_MATERIAL") as Ext.Net.ComboBox).UpdateSelectedItems();
                        }


                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_MATERIAL") as Ext.Net.TextField).SetValue(ChangeNulltoString(dr["MATERIAL"]).ToString()); //재질
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_STANDARD") as Ext.Net.TextField).SetValue(ChangeNulltoString(dr["STANDARD"]).ToString()); //규격
                        (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_MAT_UNIT") as Ext.Net.ComboBox).SelectedItem.Value = ChangeNulltoString(dr["MAT_UNIT"]).ToString(); //단위
                        (this.FindControl("cbo" + ((index > 9) ? index.ToString() : "0" + index) + "_MAT_UNIT") as Ext.Net.ComboBox).UpdateSelectedItems();
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_PACK_USAGE") as Ext.Net.NumberField).SetValue(ChangeNull(dr["PACK_USAGE"])); //소요량  
                        index++;
                    }
                        #endregion
                }

                index = 1;
                if (source_ChangeHistory.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in source_ChangeHistory.Tables[0].Rows)
                    {


                        #region [ 변경내역 정보 ]
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_CHG_NO") as Ext.Net.NumberField).SetValue(dr["CHG_NO"]); //히스토리 no
                        (this.FindControl("txt" + ((index > 9) ? index.ToString() : "0" + index) + "_CHG_REASON") as Ext.Net.TextField).SetValue(ChangeNulltoString(dr["CHG_REASON"])); //변경내역
                        (this.FindControl("dte" + ((index > 9) ? index.ToString() : "0" + index) + "_CHG_DATE") as Ext.Net.DateField).SetValue(ChangeNulltoString(dr["CHG_DATE"])); //적용시점    
                        #endregion
                        index++;
                    }
                }

                if (source_Apply.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = source_Apply.Tables[0].Rows[0];

                    #region [ 검토 및 승인 정보 ]
                    this.dte01_VEND_WRITE_DATE.SetValue(ChangeNulltoString(dr["VEND_WRITE_DATE"]));
                    this.txt01_VEND_CHARGER.SetValue(ChangeNulltoString(dr["VEND_CHARGER"]));
                    this.txt01_VEND_APPLY.SetValue(ChangeNulltoString(dr["VEND_APPLY"]));
                    this.dte01_SEOYON_ACCEPT_DATE.SetValue(ChangeNulltoString(dr["SEOYON_ACCEPT_DATE"]));
                    this.txt01_SEOYON_CHARGER.SetValue(ChangeNulltoString(dr["SEOYON_CHARGER"]));
                    //this.txt01_SEOYON_CHECK.SetValue(ChangeNulltoString(dr["SEOYON_CHECK"]));
                    this.txt01_SEOYON_APPLY.SetValue(ChangeNulltoString(dr["SEOYON_APPLY"]));
                    this.dte01_CUST_ACCEPT_DATE.SetValue(ChangeNulltoString(dr["CUST_ACCEPT_DATE"]));
                    //this.txt01_CUST_CHECK.SetValue(ChangeNulltoString(dr["CUST_CHECK"]));
                    this.txt01_CUST_APPLY.SetValue(ChangeNulltoString(dr["CUST_APPLY"]));
                    this.dte01_GLOBAL_ACCEPT_DATE.SetValue(ChangeNulltoString(dr["GLOBAL_ACCEPT_DATE"]));
                    this.txt01_GLOBAL_CHECK.SetValue(ChangeNulltoString(dr["GLOBAL_CHECK"]));
                    #endregion
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
        /// 기본정보, 포장사진 및 포장방법, 부품/중포장/대포장 정보
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Basic(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_BASIC"), param);
        }



        /// <summary>
        /// 동일포장사양정보
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Same(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SAME"), param);
        }

        /// <summary>
        /// 포장재료 정보
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Ingridient(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_INGRIDIENT"), param);
        }

        /// <summary>
        /// 변경내역
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_ChangeHistory(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CHANGEHISTORY"), param);
        }

        private DataSet getDataSet_Basic_Print(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_BASIC_PRINT"), param);
        }

        /// <summary>
        /// 동일포장사양정보 프린트
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Same_Print(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SAME_PRINT"), param);
        }

        /// <summary>
        /// 포장재료 정보 프린트
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Ingridient_Print(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_INGRIDIENT_PRINT"), param);
        }

        /// <summary>
        /// 변경내역 프린트
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_ChangeHistory_Print(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CHANGEHISTORY_PRINT"), param);
        }

        /// <summary>
        /// 검토 및 승인 정보
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet_Apply(string partno, string reg_date)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("MAIN_PARTNO", partno);
            param.Add("REG_DATE", reg_date);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_APPLY"), param);
        }


        #endregion


        #region [ 저장 ]
        /// <summary>
        /// SaveAndDelete
        /// 저장(업데이트) : 최종저장
        /// </summary>
        /// <param name="actionType"></param>
        public void SaveLast(object sender, DirectEventArgs e)
        {
            try
            {
                Save("L");
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
        /// 저장(업데이트) : 임시저장
        /// </summary>
        /// <param name="actionType"></param>
        public void SaveTemp(object sender, DirectEventArgs e)
        {
            try
            {
                Save("T");
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {

            }
        }

        private void Save(string type)
        {
            try
            {
                ArrayList arrDataSet = new ArrayList();
                ArrayList arrProcedure = new ArrayList();

                this.Remove_All(arrDataSet, arrProcedure); //기본정보 제외 모두 삭제

                if (!this.Save_Basic(arrDataSet, arrProcedure, type)) // 기본정보, 포장사진 및 포장방법, 부품/중포장/대포장 정보
                {
                    return;
                }

                if (!this.Save_Same(arrDataSet, arrProcedure, type)) //동일포장사양
                {
                    return;
                }

                if (!this.Save_Ingridient(arrDataSet, arrProcedure, type)) //포장재료
                {
                    return;
                }

                if (!this.Save_ChangeHistory(arrDataSet, arrProcedure, type)) //변경내역 정보
                {
                    return;
                }
                if (!this.Save_Apply(arrDataSet, arrProcedure, type)) //검토 및 승인 정보
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

                    if (type.Equals("T"))
                    {
                        this.hid01_MAIN_PARTNO.SetValue("M"); //신규:N, 수정:M
                        this.txt01_MAIN_PARTNO.SetValue(txt01_MAIN_PARTNO.Text);
                        this.dte01_REG_DATE.Value = dte01_REG_DATE.Value;
                        this.txt01_MAIN_PARTNO.ReadOnly = true;
                        this.dte01_REG_DATE.ReadOnly = true;
                    }


                    this.Search("2");
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
                DataSet param = Util.GetDataSourceSchema("MAIN_PARTNO", "REG_DATE");
                param.Tables[0].Rows.Add(this.txt01_MAIN_PARTNO.Value, this.dte01_REG_DATE.Value.ToString().Substring(0, 10));
                ds.Add(param);
                proc.Add("APG_SRM_PS20001.REMOVE_ALL");
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {

            }
        }

        public void FileSelected(object sender, DirectEventArgs e)
        {
            FileUploadField fu = sender as FileUploadField;
            if (fu.ID.Equals("fuf01_PHOTO1"))
            {
                img01_PHOTO1.ImageUrl = Util.FileEncoding((byte[])this.fuf01_PHOTO1.FileBytes, true);
            }
            else
                img01_PHOTO2.ImageUrl = Util.FileEncoding((byte[])this.fuf01_PHOTO2.FileBytes, true);

        }

        /// <summary>
        /// 기본정보, 포장사진 및 포장방법, 부품/중포장/대포장 정보 파라메터 생성
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        private bool Save_Basic(ArrayList ds, ArrayList proc, string type)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "MAIN_PARTNO", "MAIN_PARTNM",
                                 "MAIN_INGRIDIENT", "SURFACE", "PART_WEIGHT", "PART_SIZE_X", "PART_SIZE_Y", "PART_SIZE_Z",
                                 "PART_USAGE", "PART_USAGE_UNIT", "MID_PACKCODE", "MID_PACK_X", "MID_PACK_Y", "MID_PACK_Z",
                                 "MID_F_QTY", "MID_F_QTY_UNIT", "MID_LOAD_DEPTH", "MID_LOAD_QTY", "MID_LOAD_QTY_UNIT", "MID_LOAD_QTY_UNIT2", "MID_BOX_WEIGHT",
                                 "MID_ANTI_RUST", "LARGE_PACKCODE", "LARGE_PACK_X", "LARGE_PACK_Y", "LARGE_PACK_Z",
                                 "LARGE_F_QTY", "LARGE_F_QTY_UNIT", "LARGE_LOAD_DEPTH", "LARGE_LOAD_QTY", "LARGE_LOAD_QTY_EA", "LARGE_LOAD_QTY_UNIT",
                                 "LARGE_BOX_WEIGHT", "LARGE_ANTI_RUST", "LARGE_PO_MEASURE", "LARGE_PO_MIN_QTY", "LARGE_LOAD_RATE",
                                 "CUSTCD", "VINCD", "SPEC", "TYPE", "VENDCD",
                                 "REQUEST_DATE", "APPLY_DATE", "NOTE", "BLOB$PHOTO1", "BLOB$PHOTO2",
                                 "USER_ID", "MODE", "REG_DATE", "IS_FINAL");

                param.Tables[0].Rows.Add
                        (
                            this.txt01_MAIN_PARTNO.Value, this.txt01_MAIN_PARTNM.Value, this.txt01_MAIN_INGRIDIENT.Value, this.cbo01_SURFACE.Value, this.txt01_PART_WEIGHT.Text,
                            this.txt01_PART_SIZE_X.Text, this.txt01_PART_SIZE_Y.Text, this.txt01_PART_SIZE_Z.Text, this.txt01_PART_USAGE.Text, this.cbo01_PART_USAGE_UNIT.Value,
                            this.txt01_MID_PACKCODE.Text, this.txt01_MID_PACK_X.Text, this.txt01_MID_PACK_Y.Text, this.txt01_MID_PACK_Z.Text, this.txt01_MID_F_QTY.Text,
                            this.cbo01_MID_F_QTY_UNIT.Value, this.txt01_MID_LOAD_DEPTH.Text, this.txt01_MID_LOAD_QTY.Text, this.cbo01_MID_LOAD_QTY_UNIT.Value, this.cbo01_MID_LOAD_QTY_UNIT2.Value, this.txt01_MID_BOX_WEIGHT.Text,
                            this.cbo01_MID_ANTI_RUST.Value, this.txt01_LARGE_PACKCODE.Text, this.txt01_LARGE_PACK_X.Text, this.txt01_LARGE_PACK_Y.Text, this.txt01_LARGE_PACK_Z.Text,
                            this.txt01_LARGE_F_QTY.Text, this.cbo01_LARGE_F_QTY_UNIT.Value, this.txt01_LARGE_LOAD_DEPTH.Text, this.txt01_LARGE_LOAD_QTY.Text, this.txt01_LARGE_LOAD_QTY_EA.Value, this.cbo01_LARGE_LOAD_QTY_UNIT.Value,
                            this.txt01_LARGE_BOX_WEIGHT.Text, this.cbo01_LARGE_ANTI_RUST.Value, this.cbo01_LARGE_PO_MEASURE.Value, this.txt01_LARGE_PO_MIN_QTY.Text, this.txt01_LARGE_LOAD_RATE.Text,
                            this.cbo01_CUSTCD.Value, this.cdx01_VINCD.Value, this.cbo01_SPEC.Value, this.cbo01_TYPE.Value, this.cdx01_VENDCD.Value,
                            (this.dte01_B_REQUEST_DATE.IsEmpty) ? "" : this.dte01_B_REQUEST_DATE.Value.ToString().Substring(0, 10), (this.dte01_B_APPLY_DATE.IsEmpty) ? "" : this.dte01_B_APPLY_DATE.Value.ToString().Substring(0, 10), this.txt01_NOTE.Text,
                            (this.fuf01_PHOTO1.FileBytes.Length == 0 ? null : Util.ImageCollapse(this.fuf01_PHOTO1.FileBytes)),
                            (this.fuf01_PHOTO2.FileBytes.Length == 0 ? null : Util.ImageCollapse(this.fuf01_PHOTO2.FileBytes)),
                            this.UserInfo.UserID, this.hid01_MAIN_PARTNO.Value, (this.dte01_REG_DATE.IsEmpty) ? "" : this.dte01_REG_DATE.Value.ToString().Substring(0, 10), (type.Equals("L") ? "Y" : "N")
                        );

                //유효성 검사 (최종일경우만 유효성 검사한다.)
                if (type.Equals("L"))
                {
                    //if (UserInfo.UserDivision.Equals("T12"))
                    //{
                    //    //서연이화일경우에 대포품번이나 중포장코드가 입력되이있지 않다면 대포장 정보를 입력할 수 없다. 
                    //    if (string.IsNullOrEmpty(this.txt01_MAIN_PARTNO.Value.ToString()))
                    //    {
                    //        this.Alert("대표품번 또는 중포장코드가 비어있습니다.");
                    //        return false;
                    //    }

                    //}

                    if (!ValidationBasic(param))
                    {
                        return false;
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(txt01_MAIN_PARTNO.Text))
                    {
                        this.Alert("대표품번을 입력해주세요");
                        txt01_MAIN_PARTNO.Focus();
                        return false;
                    }
                    else if (string.IsNullOrEmpty(txt01_MAIN_PARTNM.Text))
                    {
                        this.Alert("대표품명을 입력해주세요");
                        txt01_MAIN_PARTNM.Focus();
                        return false;
                    }
                    else if (this.dte01_REG_DATE.IsEmpty)
                    {
                        this.Alert("등록일자를 입력해주세요");
                        dte01_REG_DATE.Focus();
                        return false;
                    }
                }

                ds.Add(param);
                proc.Add("APG_SRM_PS20001.SAVE_BASIC");

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
        /// 동일포장사양 파라메터 생성
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        private bool Save_Same(ArrayList ds, ArrayList proc, string type)
        {
            try
            {
                Ext.Net.TextField tx_partno = new Ext.Net.TextField();
                Ext.Net.DateField dt_apply_date = new Ext.Net.DateField();
                DataSet param = Util.GetDataSourceSchema(
                                 "MAIN_PARTNO", "PARTNO",
                                 "APPLY_DATE", "SORT_SEQ", "TEMP_SEQ", "REG_DATE");
                int index = 1;
                for (int i = 1; i < 11; i++)
                {
                    tx_partno = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_PARTNO") as Ext.Net.TextField);
                    dt_apply_date = (this.FindControl("dte" + ((i > 9) ? i.ToString() : "0" + i) + "_APPLY_DATE") as Ext.Net.DateField);
                    if (!string.IsNullOrEmpty(tx_partno.Text)) //동일 partno가 존재할 경우만 진행
                    {
                        param.Tables[0].Rows.Add
                                (
                                txt01_MAIN_PARTNO.Value, tx_partno.Value, dt_apply_date.IsEmpty ? "" : dt_apply_date.Value.ToString().Substring(0, 10), index, i, (this.dte01_REG_DATE.IsEmpty) ? "" : this.dte01_REG_DATE.Value.ToString().Substring(0, 10)
                                );
                        index++;
                    }
                }

                //유효성 검사 (최종일경우만 유효성 검사한다.)
                if (type.Equals("L"))
                {
                    if (!ValidationSame(param))
                    {
                        return false;
                    }
                }
                param.Tables[0].Columns.Remove("TEMP_SEQ");
                ds.Add(param);
                proc.Add("APG_SRM_PS20001.SAVE_SAME");
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
        /// 포장재료
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        private bool Save_Ingridient(ArrayList ds, ArrayList proc, string type)
        {
            try
            {
                Ext.Net.ComboBox tx_pack_material = new Ext.Net.ComboBox();
                Ext.Net.TextField tx_material = new Ext.Net.TextField();
                Ext.Net.ComboBox tx_mat_unit = new Ext.Net.ComboBox();
                Ext.Net.TextField tx_standard = new Ext.Net.TextField();
                Ext.Net.NumberField tx_pack_usage = new Ext.Net.NumberField();
                DataSet param = Util.GetDataSourceSchema(
                                 "MAIN_PARTNO", "PACK_MATERIAL", "MATERIAL", "MAT_UNIT", "STANDARD", "PACK_USAGE", "SORT_SEQ", "TEMP_SEQ", "REG_DATE");
                int index = 1;
                for (int i = 1; i < 11; i++)
                {
                    tx_pack_material = (this.FindControl("cbo" + ((i > 9) ? i.ToString() : "0" + i) + "_PACK_MATERIAL") as Ext.Net.ComboBox);
                    tx_material = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_MATERIAL") as Ext.Net.TextField);
                    tx_mat_unit = (this.FindControl("cbo" + ((i > 9) ? i.ToString() : "0" + i) + "_MAT_UNIT") as Ext.Net.ComboBox);
                    tx_standard = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_STANDARD") as Ext.Net.TextField);
                    tx_pack_usage = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_PACK_USAGE") as Ext.Net.NumberField);
                    if (!string.IsNullOrEmpty(tx_pack_material.Text)) //포장재가 존재할 경우만 진행
                    {
                        param.Tables[0].Rows.Add
                                (
                                    txt01_MAIN_PARTNO.Value, tx_pack_material.Value, tx_material.Value, tx_mat_unit.Value, tx_standard.Value, tx_pack_usage.Value, index, i, (this.dte01_REG_DATE.IsEmpty) ? "" : this.dte01_REG_DATE.Value.ToString().Substring(0, 10)
                                );
                        index++;
                    }
                }
                //유효성 검사 (최종일경우만 유효성 검사한다.)
                if (type.Equals("L"))
                {
                    if (!ValidationIngridient(param))
                    {
                        return false;
                    }
                }
                param.Tables[0].Columns.Remove("TEMP_SEQ");
                ds.Add(param);
                proc.Add("APG_SRM_PS20001.SAVE_INGRIDIENT");
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
        /// 변경내역
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        private bool Save_ChangeHistory(ArrayList ds, ArrayList proc, string type)
        {
            try
            {
                Ext.Net.TextField tx_chg_reason = new Ext.Net.TextField();
                Ext.Net.DateField dt_chg_date = new Ext.Net.DateField();
                DataSet param = Util.GetDataSourceSchema(
                                 "MAIN_PARTNO", "CHG_REASON",
                                 "CHG_DATE", "SORT_SEQ", "TEMP_SEQ", "REG_DATE");
                int index = 1;
                for (int i = 1; i < 11; i++)
                {
                    tx_chg_reason = (this.FindControl("txt" + ((i > 9) ? i.ToString() : "0" + i) + "_CHG_REASON") as Ext.Net.TextField);
                    dt_chg_date = (this.FindControl("dte" + ((i > 9) ? i.ToString() : "0" + i) + "_CHG_DATE") as Ext.Net.DateField);
                    if (!string.IsNullOrEmpty(tx_chg_reason.Text)) //동일 partno가 존재할 경우만 진행
                    {
                        param.Tables[0].Rows.Add
                                (
                                txt01_MAIN_PARTNO.Value, tx_chg_reason.Value, dt_chg_date.IsEmpty ? "" : dt_chg_date.Value.ToString().Substring(0, 10), index, i, (this.dte01_REG_DATE.IsEmpty) ? "" : this.dte01_REG_DATE.Value.ToString().Substring(0, 10)
                                );
                        index++;
                    }
                }
                //유효성 검사 (최종일경우만 유효성 검사한다.)
                if (type.Equals("L"))
                {
                    if (!ValidationChangeHistory(param))
                    {
                        return false;
                    }
                }
                param.Tables[0].Columns.Remove("TEMP_SEQ");
                ds.Add(param);
                proc.Add("APG_SRM_PS20001.SAVE_CHANGEHISTORY");
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
        /// 검토 및 승인 정보
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        private bool Save_Apply(ArrayList ds, ArrayList proc, string type)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "MAIN_PARTNO", "VEND_WRITE_DATE",
                                 "VEND_CHARGER", "VEND_APPLY", "SEOYON_ACCEPT_DATE", "SEOYON_CHARGER", "SEOYON_APPLY",
                                 "CUST_ACCEPT_DATE", "CUST_APPLY", "REG_DATE", "GLOBAL_ACCEPT_DATE", "GLOBAL_CHECK");

                param.Tables[0].Rows.Add
                        (
                            this.txt01_MAIN_PARTNO.Value, (this.dte01_VEND_WRITE_DATE.IsEmpty) ? "" : this.dte01_VEND_WRITE_DATE.Value.ToString().Substring(0, 10), this.txt01_VEND_CHARGER.Value, this.txt01_VEND_APPLY.Value,
                            (this.dte01_SEOYON_ACCEPT_DATE.IsEmpty) ? "" : this.dte01_SEOYON_ACCEPT_DATE.Value.ToString().Substring(0, 10), this.txt01_SEOYON_CHARGER.Value, /*this.txt01_SEOYON_CHECK.Value,*/ this.txt01_SEOYON_APPLY.Value,
                            (this.dte01_CUST_ACCEPT_DATE.IsEmpty) ? "" : this.dte01_CUST_ACCEPT_DATE.Value.ToString().Substring(0, 10), this.txt01_CUST_APPLY.Value
                            , (this.dte01_REG_DATE.IsEmpty) ? "" : this.dte01_REG_DATE.Value.ToString().Substring(0, 10)
                            , (this.dte01_GLOBAL_ACCEPT_DATE.IsEmpty) ? "" : this.dte01_GLOBAL_ACCEPT_DATE.Value.ToString().Substring(0, 10), this.txt01_GLOBAL_CHECK.Value
                        );
                //유효성 검사 (최종일경우만 유효성 검사한다.)
                if (type.Equals("L"))
                {
                    if (!ValidationApply(param))
                    {
                        return false;
                    }
                }
                ds.Add(param);
                proc.Add("APG_SRM_PS20001.SAVE_APPLY");
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

        #region
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
                        if (i == 0) { lable = "대표품번을"; componentName = "txt01_MAIN_PARTNO"; }
                        else if (i == 1) { lable = "대표품명을"; componentName = "txt01_MAIN_PARTNM"; }
                        else if (i == 2) { lable = "주원재료를"; componentName = "txt01_MAIN_INGRIDIENT"; }
                        else if (i == 3) { lable = "표면처리를"; componentName = "cbo01_SURFACE"; }
                        else if (i == 4) { lable = "부품무게를"; componentName = "txt01_PART_WEIGHT"; }
                        else if (i == 5) { lable = "부품사이즈를"; componentName = "txt01_PART_SIZE_X"; }
                        else if (i == 6) { lable = "부품사이즈를"; componentName = "txt01_PART_SIZE_Y"; }
                        else if (i == 7) { lable = "부품사이즈를"; componentName = "txt01_PART_SIZE_Z"; }
                        //else if (i == 8) { lable = "U/S를"; componentName ="txt01_PART_USAGE"; }
                        //else if (i == 9) { lable = "U/S단위를"; componentName ="cbo01_PART_USAGE_UNIT"; }
                        //else if (i == 10) { lable = "중포장코드를"; componentName ="txt01_MID_PACKCODE"; }
                        else if (i == 11) { lable = "외측사이즈를"; componentName = "txt01_MID_PACK_X"; }
                        else if (i == 12) { lable = "외측사이즈를"; componentName = "txt01_MID_PACK_Y"; }
                        else if (i == 13) { lable = "외측사이즈를"; componentName = "txt01_MID_PACK_Z"; }
                        else if (i == 14) { lable = "1단수량을"; componentName = "txt01_MID_F_QTY"; }
                        else if (i == 15) { lable = "1단수량단위를"; componentName = "cbo01_MID_F_QTY_UNIT"; }
                        else if (i == 16) { lable = "적재단수를"; componentName = "txt01_MID_LOAD_DEPTH"; }
                        else if (i == 17) { lable = "적입수량을"; componentName = "txt01_MID_LOAD_QTY"; }
                        else if (i == 18) { lable = "적입수량단위를"; componentName = "cbo01_MID_LOAD_QTY_UNIT"; }
                        else if (i == 19) { lable = "적입수량단위를"; componentName = "cbo01_MID_LOAD_QTY_UNIT2"; }
                        else if (i == 20) { lable = "박스중량을"; componentName = "txt01_MID_BOX_WEIGHT"; }
                        else if (i == 21) { lable = "방청여부를"; componentName = "cbo01_MID_ANTI_RUST"; }
                        //else if (i == 22) { lable = "대포장코드를"; componentName ="txt01_LARGE_PACKCODE"; }
                        else if (i == 23) { lable = "내측사이즈를"; componentName = "txt01_LARGE_PACK_X"; }
                        else if (i == 24) { lable = "내측사이즈를"; componentName = "txt01_LARGE_PACK_Y"; }
                        else if (i == 25) { lable = "내측사이즈를"; componentName = "txt01_LARGE_PACK_Z"; }
                        else if (i == 26) { lable = "1단수량을"; componentName = "txt01_LARGE_F_QTY"; }
                        else if (i == 27) { lable = "1단수량단위를"; componentName = "cbo01_LARGE_F_QTY_UNIT"; }
                        else if (i == 28) { lable = "적재단수를"; componentName = "txt01_LARGE_LOAD_DEPTH"; }
                        else if (i == 29) { lable = "적입수량BOX를"; componentName = "txt01_LARGE_LOAD_QTY"; }
                        else if (i == 30) { lable = "적입수량EA를"; componentName = "txt01_LARGE_LOAD_QTY_EA"; }
                        else if (i == 31) { lable = "적입수량단위를"; componentName = "cbo01_LARGE_LOAD_QTY_UNIT"; }
                        else if (i == 32) { lable = "대박스중량을"; componentName = "txt01_LARGE_BOX_WEIGHT"; }
                        else if (i == 33) { lable = "방청여부를"; componentName = "cbo01_LARGE_ANTI_RUST"; }
                        else if (i == 34) { lable = "발주단위를"; componentName = "cbo01_LARGE_PO_MEASURE"; }
                        else if (i == 35) { lable = "최소발주를"; componentName = "txt01_LARGE_PO_MIN_QTY"; }
                        else if (i == 36) { lable = "대포장적입율을"; componentName = "txt01_LARGE_LOAD_RATE"; }
                        else if (i == 37) { lable = "법인명을"; componentName = "cbo01_CUSTCD"; }
                        else if (i == 38) { lable = "차종을"; componentName = "cdx01_VINCD"; }
                        else if (i == 39) { lable = "사양을"; componentName = "cbo01_SPEC"; }
                        else if (i == 40) { lable = "유형을"; componentName = "cbo01_TYPE"; }
                        else if (i == 41) { lable = "공급업체를"; componentName = "cdx01_VENDCD"; }
                        else if (i == 42) { lable = "적용요구시점을"; componentName = "dte01_B_REQUEST_DATE"; }
                        else if (i == 43) { lable = "실적용시점을"; componentName = "dte01_B_APPLY_DATE"; }
                        else if (i == 44) { lable = "NOTE를"; componentName = "txt01_NOTE"; }
                        else if (i == 45) { lable = "부품사진을"; componentName = "fuf01_PHOTO1"; }
                        else if (i == 46) { lable = "포장사진을"; componentName = "fuf01_PHOTO2"; }

                        if (i != 10 && i != 22) //중포장은 필수 입력이 아님
                        {
                            //서연이화 자재팀이라면 필수 입력
                            if (i >= 20 && i <= 36 && UserInfo.UserDivision.Equals("T12"))
                            {
                                this.MsgCodeAlert_ShowFormat("EP20S01-003", componentName, new string[] { lable }); //{0}를(을) 입력해주세요.
                                return false;
                            }
                            else if ((i < 20 || i > 36) && !UserInfo.UserDivision.Equals("T12"))
                            {
                                this.MsgCodeAlert_ShowFormat("EP20S01-003", componentName, new string[] { lable }); //{0}를(을) 입력해주세요.
                                return false;
                            }
                        }


                    }
                }
            }
            return true;
        }

        private bool ValidationSame(DataSet param)
        {
            //PARAM에는 이미 PARTNO가 존재하는 값만 만들어져 있음.
            if (param.Tables[0].Rows.Count > 0)
            {
                string lable = string.Empty;
                string index = string.Empty;
                for (int i = 0; i < param.Tables[0].Rows.Count; i++)
                {
                    int temp_index = int.Parse(param.Tables[0].Rows[i]["TEMP_SEQ"].ToString());
                    index = (temp_index < 10) ? "0" + (temp_index) : (temp_index).ToString();

                    if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["APPLY_DATE"].ToString()))
                    {
                        lable = "동일포장사양정보의 " + index + "행의 적용시점을";
                        this.MsgCodeAlert_ShowFormat("EP20S01-003", (this.FindControl("dte" + index + "_APPLY_DATE") as Ext.Net.DateField).ID, new string[] { lable }); //{0}를(을) 입력해주세요.
                        return false;
                    }
                }

            }
            else
            {
                //동일 포장사양이 없을 수도 있음
                //this.MsgCodeAlert_ShowFormat("COM-00020");//저장할 데이터가 없습니다.
                //return false;
            }
            return true;
        }

        /// <summary>
        /// 승인 필수체크
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        private bool ValidationApply(DataSet param)
        {
            if (param.Tables[0].Rows.Count > 0)
            {
                string lable = string.Empty;
                for (int i = 1; i < param.Tables[0].Columns.Count; i++)
                {
                    if (string.IsNullOrEmpty(param.Tables[0].Rows[0][i].ToString()))
                    {
                        string componentName = string.Empty;
                        if (i == 1) { lable = "공급업체 작성일을"; componentName = "dte01_VEND_WRITE_DATE"; }
                        else if (i == 2) { lable = "공급업체 담당을"; componentName = "txt01_VEND_CHARGER"; }
                        else if (i == 3) { lable = "공급업체 승인을"; componentName = "txt01_VEND_APPLY"; }
                        else if (i == 4) { lable = "서연이화 접수일을"; componentName = "dte01_SEOYON_ACCEPT_DATE"; }
                        else if (i == 5) { lable = "서연이화 담당을"; componentName = "txt01_SEOYON_CHARGER"; }
                        else if (i == 6) { lable = "서연이화 승인을"; componentName = "txt01_SEOYON_APPLY"; }
                        else if (i == 7) { lable = "해외법인 접수일"; componentName = "dte01_CUST_ACCEPT_DATE"; }
                        else if (i == 8) { lable = "해외법인 승인을"; componentName = "txt01_CUST_APPLY"; }

                        //서연이화 자재팀이라면 필수 입력
                        if (i >= 4 && i <= 6 && UserInfo.UserDivision.Equals("T12"))
                        {
                            this.MsgCodeAlert_ShowFormat("EP20S01-003", componentName, new string[] { lable }); //{0}를(을) 입력해주세요.
                            return false;
                        }
                        else if (i >= 1 && i <= 3 && !UserInfo.UserDivision.Equals("T12"))
                        {
                            this.MsgCodeAlert_ShowFormat("EP20S01-003", componentName, new string[] { lable }); //{0}를(을) 입력해주세요.
                            return false;
                        }
                    }
                }
            }
            return true;
        }

        private bool ValidationIngridient(DataSet param)
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


                    if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["MAT_UNIT"].ToString()))
                    {
                        lable = index + "행의 단위를";
                        component = (this.FindControl("cbo" + index + "_MAT_UNIT") as Ext.Net.ComboBox).ID;
                        break;
                    }
                    //else if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["STANDARD"].ToString()))
                    //{
                    //    lable = index + "행의 규격을";
                    //    component = (this.FindControl("txt" + index + "_STANDARD") as Ext.Net.TextField).ID;
                    //    break;
                    //}
                    else if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["PACK_USAGE"].ToString()))
                    {
                        lable = index + "행의 소요량을";
                        component = (this.FindControl("txt" + index + "_PACK_USAGE") as Ext.Net.NumberField).ID;
                        break;
                    }

                }
                if (string.IsNullOrEmpty(lable)) return true;
                else
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", component, new string[] { "포장재료정보의 " + lable }); //{0}를(을) 입력해주세요.
                    return false;
                }

            }
            else
            {
                this.MsgCodeAlert_ShowFormat("SRM_PS-0001", new string[] { "포장재료정보" });//저장할 데이터가 없습니다.
                return false;
            }
        }

        private bool ValidationChangeHistory(DataSet param)
        {
            //PARAM에는 이미 변경내역이 존재하는 값만 만들어져 있음.
            if (param.Tables[0].Rows.Count > 0)
            {
                string lable = string.Empty;
                string index = string.Empty;
                for (int i = 0; i < param.Tables[0].Rows.Count; i++)
                {
                    int temp_index = int.Parse(param.Tables[0].Rows[i]["TEMP_SEQ"].ToString());
                    index = (temp_index < 10) ? "0" + (temp_index) : (temp_index).ToString();

                    if (string.IsNullOrEmpty(param.Tables[0].Rows[i]["CHG_DATE"].ToString()))
                    {
                        lable = "변경내역 " + index + "행의 적용시점을";
                        this.MsgCodeAlert_ShowFormat("EP20S01-003", (this.FindControl("dte" + index + "_CHG_DATE") as Ext.Net.DateField).ID, new string[] { lable }); //{0}를(을) 입력해주세요.
                        return false;
                    }
                }

            }
            else
            {
                //변경내역이 없을 수도 있음
                //this.MsgCodeAlert_ShowFormat("COM-00020");//저장할 데이터가 없습니다.
                //return false;
            }
            return true;
        }
        #endregion

        #region [버튼 팝업]
        /// <summary>
        /// POPUP (대포장 코드 가져오기)
        /// </summary>
        public void POPUP(string type)
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("LARGE_PACKCODE", type.Equals("L") ? this.txt01_LARGE_PACKCODE.Value : this.txt01_MID_PACKCODE.Value);
            set.Add("LARGE_PACKNM", string.Empty);
            set.Add("TYPE", type);
            Util.UserPopup(this, "../SRM_PS/SRM_PS20001P2.aspx", set, "HELP_PS20001P2", "Popup", 630, 500);
        }
        #endregion
    }
}
