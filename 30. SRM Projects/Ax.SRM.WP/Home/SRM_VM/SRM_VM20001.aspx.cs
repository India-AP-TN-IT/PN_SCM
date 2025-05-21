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

namespace Ax.EP.WP.Home.SRM_VM
{
    public partial class SRM_VM20001 : BasePage
    {
        private string pakageName = "APG_SRM_VM20001";
        //private string noimage = "../../images/common/no_image.gif";


        #region [ 초기설정 ]

        /// <summary>
        /// SRM_VM20001
        /// </summary>
        public SRM_VM20001()
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
                if (Library.checkAuth("2610"))
                {
                    this.FindControl("cdx01_VENDCD").Visible = false;
                    VEND_DIV.Text = "true";
                }
                else
                {
                    this.FindControl("cdx03_VENDCD").Visible = false;
                    VEND_DIV.Text = "false";
                }

                if (!X.IsAjaxRequest)
                {
                    //BASE에서 일괄적으로 위아래버튼 사라지게 처리함. 
                    //이화면에서는 필요하므로 다시 살림
                    this.txt01_STD_YEAR.HideTrigger = false;
                    this.txt01_STD_YEAR.SpinDownEnabled = true;
                    this.txt01_STD_YEAR.SpinUpEnabled = true;


                    this.txt02_STD_YEAR.HideTrigger = false;
                    this.txt02_STD_YEAR.SpinDownEnabled = true;
                    this.txt02_STD_YEAR.SpinUpEnabled = true;

                    this.txt03_STD_YEAR.HideTrigger = false;
                    this.txt03_STD_YEAR.SpinDownEnabled = true;
                    this.txt03_STD_YEAR.SpinUpEnabled = true;

                    this.SetCombo();


                    this.img01_PHOTO1.ImageUrl = CommonString.NoImage;
                    this.img01_PHOTO2.ImageUrl = CommonString.NoImage;
                    this.img01_PHOTO3.ImageUrl = CommonString.NoImage;
                    this.img01_REP_PHOTO.ImageUrl = CommonString.NoImage;
                    this.img01_SEAL_IMAGE.ImageUrl = CommonString.NoImage;

                    this.Reset(true);

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
                case ButtonID.Search:
                    Reset(false);
                    Search();
                    break;
                case ButtonID.Reset:
                    Reset(true);
                    break;
                case ButtonID.Save:
                    Save(sender, e);
                    break;
                case ButtonID.Print:
                    //Print();
                    PrintConfirm();
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
                case "btn01_FILEID1_DEL":
                    fileDeleteConfirm(hid01_FILEID1.Value.ToString());
                    break;
                case "btn01_FILEID2_DEL":
                    fileDeleteConfirm(hid01_FILEID2.Value.ToString());
                    break;
                case "btn01_REMOVE_REP_PHOTO":
                    repPhotoDeleteConfirm();
                    break;
                case "btn01_REMOVE_PHOTO1":
                    PhotoDeleteConfirm("1");
                    break;
                case "btn01_REMOVE_PHOTO2":
                    PhotoDeleteConfirm("2");
                    break;
                case "btn01_REMOVE_PHOTO3":
                    PhotoDeleteConfirm("3");
                    break;
                case "btn01_REMOVE_SEAL_IMAGE":
                    sealImageDeleteConfirm();
                    break;
                case "btn01_DELETE":
                    //주요설비현황(생산설비) 삭제버튼
                    Remove_ASRM2130(e);
                    break;
                case "btn01_SAVE":
                    //주요설비현황(생산설비) 저장버튼
                    Save_ASRM2130(e);
                    break;
                case "btn02_DELETE":
                    //주요설비현황(실험 및 측정설비) 삭제버튼
                    Remove_ASRM2140(e);
                    break;
                case "btn02_SAVE":
                    //주요설비현황(실험 및 측정설비) 저장버튼
                    Save_ASRM2140(e);
                    break;
                case "btn03_DELETE":
                    //주요공급업체 매입현황 삭제버튼
                    Remove_ASRM2100(e);
                    break;
                case "btn03_SAVE":
                    //주요공급업체 매입현황 저장버튼
                    Save_ASRM2100(e);
                    break;
                case "btn04_DELETE":
                    //서연이화 금형 보유현황 삭제버튼
                    Remove_ASRM2150(e);
                    break;
                case "btn04_SAVE":
                    //서연이화 금형 보유현황 저장버튼
                    Save_ASRM2150(e);
                    break;
                case "btn05_DELETE":
                    //1차사 거래현황 삭제버튼
                    Remove_ASRM2160(e);
                    break;
                case "btn05_SAVE":
                    //1차사 거래현황  저장버튼
                    Save_ASRM2160(e);
                    break;
                case "btn01_PRINT_SUMMARY":
                    //중역보고용 요약 정보 출력
                    Print2();
                    break;
                case "btn06_DELETE":
                    //재무제표 삭제
                    Remove_ASRM2090();
                    break;
                case "btn06_SAVE":
                    //재무제표 저장
                    Save_VM2090();
                    break;
                case "btn01_SQ_CATEGORY":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용                  
                    Util.CodePopup(this, "GRID_SQ_CATEGORY_HELP", this.CodeValue.Text, this.NameValue.Text, "VC", "input");
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
        public void fileDeleteConfirm(string fileID)
        {
            //파일이 존재하지 않습니다.
            if (string.IsNullOrEmpty(fileID))
            {
                this.MsgCodeAlert("SRMQA00-0050");
            }
            else
            {
                X.MessageBox.Confirm("Confirm", Library.getMessage("EP20010-001"), new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.fileDelete('" + fileID + "')",
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
        public void fileDelete(string fileID)
        {
            try
            {
                // 1. 첨부파일 1개 지울때또 DB의 협력업체 기타 테이블의 파일링크 정보를 먼저 제거 후.
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
                param.Add("FILEID", fileID);
                param.Add("USER_ID", this.UserInfo.UserID);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_ATTACH"), param);
                    //X.MessageBox.Alert("FileDelete", "파일이 삭제 되었습니다.").Show();
                    this.MsgCodeAlert("EP20010-003");
                }

                // 2. 원격지 파일 및 메타 정보를 삭제한다.
                EPRemoteFileHandler.FileRemove(fileID);

                // 파일 정보 초기화 ( 3개중 삭제된 fileID 를 찾아서 해당 하는 항목만 초기화 )
                if (fileID.Equals(hid01_FILEID1.Value.ToString()))
                {
                    this.fud01_FILEID1.Reset();
                    this.dwn01_FILEID1.Icon = Icon.None;
                    this.dwn01_FILEID1.Text = "";
                    this.hid01_FILEID1.Value = "";
                }
                else if (fileID.Equals(hid01_FILEID2.Value.ToString()))
                {
                    this.fud01_FILEID2.Reset();
                    this.dwn01_FILEID2.Icon = Icon.None;
                    this.dwn01_FILEID2.Text = "";
                    this.hid01_FILEID2.Value = "";
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
        /// fileDeleteConfirm
        /// </summary>
        /// <param name="fileID"></param>
        public void repPhotoDeleteConfirm()
        {
            if (this.hid01_REP_PHOTO.Value.ToString().Equals(string.Empty))
            {
                //대표자 사진이 존재하지 않습니다.
                this.MsgCodeAlert("SRMVM-0002");
            }
            else
            {
                X.MessageBox.Confirm("Confirm", Library.getMessage("EP20010-001"), new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.repPhotoDelete()",
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
        public void repPhotoDelete()
        {
            try
            {
                // 1. db로부터 이미지 삭제
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
                param.Add("USER_ID", this.UserInfo.UserID);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_REP_PHOTO"), param);
                    //X.MessageBox.Alert("FileDelete", "파일이 삭제 되었습니다.").Show();
                    this.MsgCodeAlert("EP20010-003");
                }

                this.hid01_REP_PHOTO.Value = string.Empty;
                this.fuf01_REP_PHOTO.Reset();
                img01_REP_PHOTO.ImageUrl = CommonString.NoImage;

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
        /// fileDeleteConfirm
        /// </summary>
        /// <param name="fileID"></param>
        public void PhotoDeleteConfirm(string photono)
        {
            string photo_yn = "";
            if (photono.Equals("1"))
                photo_yn = this.hid01_PHOTO1.Value.ToString();
            else if (photono.Equals("2"))
                photo_yn = this.hid01_PHOTO2.Value.ToString();
            else
                photo_yn = this.hid01_PHOTO3.Value.ToString();

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
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
                param.Add("USER_ID", this.UserInfo.UserID);
                param.Add("PHOTONO", photono);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_PHOTO"), param);
                    //X.MessageBox.Alert("FileDelete", "파일이 삭제 되었습니다.").Show();
                    this.MsgCodeAlert("EP20010-003");
                }

                if (photono.Equals("1"))
                {
                    this.hid01_PHOTO1.Value = string.Empty;
                    this.fuf01_PHOTO1.Reset();
                    img01_PHOTO1.ImageUrl = CommonString.NoImage;
                }
                else if (photono.Equals("2"))
                {
                    this.hid01_PHOTO2.Value = string.Empty;
                    this.fuf01_PHOTO2.Reset();
                    img01_PHOTO2.ImageUrl = CommonString.NoImage;
                }
                else
                {
                    this.hid01_PHOTO3.Value = string.Empty;
                    this.fuf01_PHOTO3.Reset();
                    img01_PHOTO3.ImageUrl = CommonString.NoImage;
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
        /// fileDeleteConfirm
        /// </summary>
        /// <param name="fileID"></param>
        public void sealImageDeleteConfirm()
        {
            if (this.hid01_SEAL_IMAGE.Value.ToString().Equals(string.Empty))
            {
                //대표자 사진이 존재하지 않습니다.
                this.MsgCodeAlert("SRMVM-0002");
            }
            else
            {
                X.MessageBox.Confirm("Confirm", Library.getMessage("EP20010-001"), new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.sealImageDelete()",
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
        public void sealImageDelete()
        {
            try
            {
                // 1. db로부터 이미지 삭제
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
                param.Add("USER_ID", this.UserInfo.UserID);

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_SEAL_IMAGE"), param);
                    //X.MessageBox.Alert("FileDelete", "파일이 삭제 되었습니다.").Show();
                    this.MsgCodeAlert("EP20010-003");
                }

                this.hid01_SEAL_IMAGE.Value = string.Empty;
                this.fuf01_SEAL_IMAGE.Reset();
                img01_SEAL_IMAGE.ImageUrl = CommonString.NoImage;

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

        #region [리포트 출력 관련]

        private void PrintConfirm()
        {
            if (!this.IsQueryValidation()) return;

            X.Msg.Show(new MessageBoxConfig
            {
                Title = "Confirm",
                Message = Library.getMessage("SRMVM-0011"),
                Buttons = MessageBox.Button.YESNOCANCEL,
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
            if (!this.IsQueryValidation()) return;

            HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
            report.ReportName = "1000/SRM_VM/SRM_VM20001";

            // Main Section ( 메인리포트 파라메터셋 )
            HERexSection mainSection = new HERexSection();
            mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
            mainSection.ReportParameter.Add("STD_YEAR", this.txt01_STD_YEAR.Value);
            mainSection.ReportParameter.Add("ASRM2160_STD_YEAR", this.txt03_STD_YEAR.Value);
            mainSection.ReportParameter.Add("ASRM2100_STD_YEAR", this.txt02_STD_YEAR.Value);

            report.Sections.Add("MAIN", mainSection);

            // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
            DataSet ds = this.getDataSetReport();

            if (ds.Tables[0].Rows.Count <= 0)
            {
                this.MsgCodeAlert_ShowFormat("COM-00022");
                return;
            }
            DataSet source = this.getFinancialDataSetReport();
            DataSet ds1 = new DataSet();
            DataSet ds2 = new DataSet();
            DataSet ds3 = new DataSet();
            DataSet ds4 = new DataSet();
            DataSet ds5 = new DataSet();
            DataSet ds6 = new DataSet();
            ds1.Tables.Add(source.Tables[0].Copy());
            ds2.Tables.Add(source.Tables[1].Copy());
            ds3.Tables.Add(ds.Tables[1].Copy());
            ds4.Tables.Add(ds.Tables[2].Copy());
            ds5.Tables.Add(ds.Tables[3].Copy());
            ds6.Tables.Add(ds.Tables[4].Copy());

            //// DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
            //// 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
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
            HERexSection xmlSectionSub5 = new HERexSection(ds5, new HEParameterSet());
            HERexSection xmlSectionSub6 = new HERexSection(ds6, new HEParameterSet());

            // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
            // xmlSection.ReportParameter.Add("CORCD", "1000");
            report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
            report.Sections.Add("XML1", xmlSectionSub1);
            report.Sections.Add("XML2", xmlSectionSub2);
            report.Sections.Add("XML3", xmlSectionSub3);
            report.Sections.Add("XML4", xmlSectionSub4);
            report.Sections.Add("XML5", xmlSectionSub5);
            report.Sections.Add("XML6", xmlSectionSub6);

            AxReportForm.ShowReport(report);

        }


        /// <summary>
        /// Print2
        /// </summary>
        [DirectMethod]
        public void Print2()
        {
            if (!this.IsQueryValidation()) return;

            HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
            report.ReportName = "1000/SRM_VM/SRM_VM20002";

            // Main Section ( 메인리포트 파라메터셋 )
            HERexSection mainSection = new HERexSection();
            mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
            mainSection.ReportParameter.Add("MENUID", "SRM_VM20001");
            mainSection.ReportParameter.Add("ASRM2160_STD_YEAR", this.txt03_STD_YEAR.Value);

            report.Sections.Add("MAIN", mainSection);


            // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
            DataSet ds = this.getDataSetReport2();
            if (ds.Tables[0].Rows.Count <= 0)
            {
                this.MsgCodeAlert_ShowFormat("COM-00022");
                return;
            }

            //OUT_CURSOR_SRM2090
            DataSet ds1 = new DataSet();
            ds1.Tables.Add(ds.Tables[1].Copy());
            //OUT_CURSOR_SRM2150
            DataSet ds2 = new DataSet();
            ds2.Tables.Add(ds.Tables[2].Copy());
            //OUT_CURSOR_SRM2160
            DataSet ds3 = new DataSet();
            ds3.Tables.Add(ds.Tables[3].Copy());

            //// DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
            //// 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
            //ds.Tables[0].TableName = "DATA";
            //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
            //ds1.Tables[0].TableName = "DATA";
            //ds1.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "01.xml", XmlWriteMode.WriteSchema);
            //ds2.Tables[0].TableName = "DATA";
            //ds2.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "02.xml", XmlWriteMode.WriteSchema);
            //ds3.Tables[0].TableName = "DATA";
            //ds3.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "03.xml", XmlWriteMode.WriteSchema);

            HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
            HERexSection xmlSectionSub1 = new HERexSection(ds1, new HEParameterSet());
            HERexSection xmlSectionSub2 = new HERexSection(ds2, new HEParameterSet());
            HERexSection xmlSectionSub3 = new HERexSection(ds3, new HEParameterSet());

            // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
            // xmlSection.ReportParameter.Add("CORCD", "1000");
            report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
            report.Sections.Add("XML1", xmlSectionSub1);
            report.Sections.Add("XML2", xmlSectionSub2);
            report.Sections.Add("XML3", xmlSectionSub3);
            AxReportForm.ShowReport(report);

        }

        #endregion



        #endregion

        #region [ 코드박스 이벤트 핸들러 ]
        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_VENDCD_AfterValidation(object sender, DirectEventArgs e)
        {
            //업체코드입력시 자동 조회
            //업체코드 미입력상태이거나 잘못된 코드 입력된 경우에는 초기화만.
            this.Reset(false);
            if (!this.cdx01_VENDCD.IsEmpty && this.cdx01_VENDCD.isValid)
                this.Search();
        }

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx03_VENDCD_AfterValidation(object sender, DirectEventArgs e)
        {
            //업체코드입력시 자동 조회
            //업체코드 미입력상태이거나 잘못된 코드 입력된 경우에는 초기화만.
            this.Reset(false);
            if (!this.cdx03_VENDCD.IsEmpty && this.cdx03_VENDCD.isValid)
                this.Search();
        }

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_UP_VEND_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            //UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();

            cdx.UserParamSet.Add("OPTION", "1");
        }

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx03_UP_VEND_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            //UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
        }

        #endregion

        #region [ 기능 ]

        #region [ 초기화 관련 ]
        /// <summary>
        /// 콤보상자 바인딩(유형코드 등등)
        /// </summary>
        private void SetCombo()
        {
            //유형코드
            DataSet source = Library.GetTypeCode("VB");

            //업체차수 콤보바인딩
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='1'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_VEND_TIER, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select"); //업체차수 
            Library.ComboDataBind(this.cbo01_MAIN_DELI_TIER1, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");        //현지납품선TIER
            Library.ComboDataBind(this.cbo01_MAIN_DELI_TIER2, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");        //현지납품선TIER
            Library.ComboDataBind(this.cbo01_MAIN_DELI_TIER3, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");        //현지납품선TIER

            //하도급업체여부 콤보바인딩
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='2'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_SUBCONTR_YN, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");


            //업체 사용언어 콤보바인딩
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='3'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_USE_LANG, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");

            //노조구분 콤보바인딩
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='4'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_LABOR1, source.Tables[0].DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
            Library.ComboDataBind(this.cbo01_LABOR2, source.Tables[0].DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
            Library.ComboDataBind(this.cbo01_LABOR3, source.Tables[0].DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);

            //인증구분
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='5'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_QUAL_CERTI_DIV1, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");
            Library.ComboDataBind(this.cbo01_QUAL_CERTI_DIV2, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");
            Library.ComboDataBind(this.cbo01_QUAL_CERTI_DIV3, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");
            Library.ComboDataBind(this.cbo01_QUAL_CERTI_DIV4, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");
            Library.ComboDataBind(this.cbo01_QUAL_CERTI_DIV5, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");


            //SQ인증 등급
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='6'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_SQ_GRADE1, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");
            Library.ComboDataBind(this.cbo01_SQ_GRADE2, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");
            Library.ComboDataBind(this.cbo01_SQ_GRADE3, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");

            //단위
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='7'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_UNIT, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");


            //상장여부
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='8'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_STOCK_YN, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");

            //회사규모
            source.Tables[0].DefaultView.RowFilter = "GROUPCD='9'";
            source.Tables[0].DefaultView.Sort = "SORT_SEQ";
            Library.ComboDataBind(this.cbo01_SCALE, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "Select");
        }
        /// <summary>
        /// Reset
        /// </summary>
        public void Reset(bool isAllReset)
        {
            
            if (isAllReset)
            {
                if (VEND_DIV.Text.Equals("true"))
                {
                    this.cdx03_VENDCD.SetValue(string.Empty);
                }
                else
                {
                    //업체코드는 서연이화 사용자인 경우에만 초기화한다.
                    if (this.UserInfo.UserDivision.Equals("T12"))
                        this.cdx01_VENDCD.SetValue(string.Empty);
                }
            }


            this.ClearInput(this.Controls);

            //파일관련
            this.fud01_FILEID1.Reset();
            this.fud01_FILEID2.Reset();
            this.hid01_FILEID1.Value = "";
            this.hid01_FILEID2.Value = "";
            this.dwn01_FILEID1.Icon = Icon.None;
            this.dwn01_FILEID2.Icon = Icon.None;
            this.dwn01_FILEID1.Text = "";
            this.dwn01_FILEID2.Text = "";

            this.hid01_REP_PHOTO.Value = string.Empty;
            this.img01_REP_PHOTO.ImageUrl = CommonString.NoImage;
            this.fuf01_REP_PHOTO.Reset();

            this.hid01_PHOTO1.Value = string.Empty;
            this.img01_PHOTO1.ImageUrl = CommonString.NoImage;
            this.fuf01_PHOTO1.Reset();

            this.hid01_PHOTO2.Value = string.Empty;
            this.img01_PHOTO2.ImageUrl = CommonString.NoImage;
            this.fuf01_PHOTO2.Reset();

            this.hid01_PHOTO3.Value = string.Empty;
            this.img01_PHOTO3.ImageUrl = CommonString.NoImage;
            this.fuf01_PHOTO3.Reset();

            this.hid01_SEAL_IMAGE.Value = string.Empty;
            this.img01_SEAL_IMAGE.ImageUrl = CommonString.NoImage;
            this.fuf01_SEAL_IMAGE.Reset();

            //주요설비현황(생산설비) 그리드 초기화
            this.Store_Grid01.RemoveAll();

            //주요설비현황(실험및측정설비) 그리드 초기화
            this.Store_Grid02.RemoveAll();

            //주요공급업체매입현황 그리드 초기화
            this.Store_Grid03.RemoveAll();

            //금형보유현황 그리드 초기화
            this.Store_Grid04.RemoveAll();
            this.lbl01_INJECTION_TOT.Text = "0";
            this.lbl01_FORMING_TOT.Text = "0";
            this.lbl01_PRESS_TOT.Text = "0";
            this.lbl01_ETC_TOT.Text = "0";
            this.lbl01_TOTAL_TOT.Text = "0";

            //서연이화 SQ주관장 초기화
            cbo01_SYEH_SQ_MAIN.SelectedItem.Index = 0;
            cbo01_SYEH_SQ_MAIN.UpdateSelectedItems();

            //1차사 거래 현황 그리드 초기화
            this.Store_Grid05.RemoveAll();
        }



        /// <summary>
        /// SetPartnerControlAuthority
        /// </summary>
        /// <param name="controls"></param>
        private void ClearInput(ControlCollection controls)
        {


            foreach (Control ctrl in controls)
            {
                // 텍스트 필드일경우 
                Ext.Net.TextField txtField = ctrl as Ext.Net.TextField;
                if (txtField != null)
                {

                    if (ctrl.ID.Equals("txt01_VEND_NATCD"))
                    {
                        //txtField.SetValue("대한민국");    //국가 "대한민국"으로 세팅
                        txtField.SetValue(Library.getLabel(GetMenuID(), "KOREA"));    //국가 "대한민국"으로 세팅
                        continue;
                    }
                    else
                    {
                        if (!ctrl.ID.Equals("VEND_DIV"))
                        {   
                            txtField.SetValue(string.Empty);
                            continue;
                        }
                    }

                }

                // 코드박스 일경우 
                Ax.EP.UI.IEPCodeBox cdxField = ctrl as Ax.EP.UI.IEPCodeBox;
                if (cdxField != null)
                {
                    if (ctrl.ID.Equals("cdx01_VENDCD"))
                        continue;                                   //업체코드는 초기화하지 않음   
                    if (ctrl.ID.Equals("cdx03_VENDCD"))
                        continue; 
                    else if (ctrl.ID.Equals("cdx01_MONEY_UNIT"))
                    {
                        this.cdx01_MONEY_UNIT.SetValue("I2KRW");    //화폐단위는 기본 "KRW"로 세팅
                        continue;
                    }
                    else
                    {
                        cdxField.SetValue(string.Empty);
                        continue;
                    }
                }

                //콤보상자인 경우
                Ext.Net.ComboBox cboField = ctrl as Ext.Net.ComboBox;
                if (cboField != null)
                {
                    if (ctrl.ID.Equals("cbo01_LABOR1") || ctrl.ID.Equals("cbo01_LABOR2") || ctrl.ID.Equals("cbo01_LABOR3"))
                    {
                        cboField.SelectedItem.Value = "VB10";
                    }
                    else
                    {
                        cboField.SelectedItem.Value = "";
                    }

                    cboField.UpdateSelectedItems();
                    continue;

                }

                //number필드인 경우
                Ext.Net.NumberField numField = ctrl as Ext.Net.NumberField;
                if (numField != null)
                {
                    if (ctrl.ID.Equals("txt01_STD_YEAR") || ctrl.ID.Equals("txt02_STD_YEAR") || ctrl.ID.Equals("txt03_STD_YEAR"))
                    {
                        numField.SetValue(DateTime.Now.Year - 1);    //기준년도는 기본 전년도로 세팅        
                        //this.txt01_STD_YEAR_Change(null, null);
                        continue;
                    }
                    else
                    {
                        numField.SetValue(null);
                        continue;
                    }


                }

                Ext.Net.DateField dateField = ctrl as Ext.Net.DateField;
                if (dateField != null)
                {
                    dateField.SetValue(null);
                    continue;
                }

                //Ext.Net.Image image = ctrl as Ext.Net.Image;
                //if (image != null)
                //{
                //    image.ImageUrl = CommonString.NoImage;
                //    continue;
                //}

                //그외 컨트롤인 경우
                if (ctrl.HasControls())
                {
                    ClearInput(ctrl.Controls);
                }
            }
        }

        #endregion

        #region [SRM2090 재무제표 현황]

        private DataSet Get_ASRM2090()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
            param.Add("STD_YEAR", this.txt01_STD_YEAR.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ASRM2090"), param);

            if (source.Tables[0].Rows.Count > 0)
            {
                DataRow dr = source.Tables[0].Rows[0];

                #region [ 재무재표현황 ]

                this.cdx01_MONEY_UNIT.SetValue(dr["MONEY_UNIT"]);

                this.txt01_DEBT.SetValue(dr["DEBT"] != DBNull.Value ? Convert.ToDecimal(dr["DEBT"]).ToString("#,###") : "0");
                this.txt01_QUITY.SetValue(dr["QUITY"] != DBNull.Value ? Convert.ToDecimal(dr["QUITY"]).ToString("#,###") : "0");
                this.txt01_TOTAL_SALES.SetValue(dr["TOTAL_SALES"] != DBNull.Value ? Convert.ToDecimal(dr["TOTAL_SALES"]).ToString("#,###") : "0");
                this.txt01_ORDINARY_INCOME.SetValue(dr["ORDINARY_INCOME"] != DBNull.Value ? Convert.ToDecimal(dr["ORDINARY_INCOME"]).ToString("#,###") : "0");
                this.txt01_BUSINESS_PROFITS.SetValue(dr["BUSINESS_PROFITS"] != DBNull.Value ? Convert.ToDecimal(dr["BUSINESS_PROFITS"]).ToString("#,###") : "0");

                this.txt01_ASSETS.SetValue(dr["ASSETS"] != DBNull.Value ? Convert.ToDecimal(dr["ASSETS"]).ToString("#,###") : "0");
                this.txt01_PERSON_SALES.SetValue(dr["PERSON_SALES"] != DBNull.Value ? Convert.ToDecimal(dr["PERSON_SALES"]).ToString("#,###") : "0");

                this.txt01_DEBT_RATE.SetValue(dr["DEBT_RATE"] != DBNull.Value ? Convert.ToDecimal(dr["DEBT_RATE"]).ToString("#,###") : "0");
                this.txt01_TURNOVER_RATE.SetValue(dr["TURNOVER_RATE"] != DBNull.Value ? Convert.ToDecimal(dr["TURNOVER_RATE"]).ToString("#,###") : "0");


                this.txt01_HKMC_TRADE_RATE.SetValue(dr["HKMC_TRADE_RATE"]);
                this.txt01_ETC_TRACE_RATE.SetValue(dr["ETC_TRACE_RATE"]);

                #endregion
            }
            else
            {

                this.cdx01_MONEY_UNIT.SetValue("I2KRW");
                this.txt01_ASSETS.SetValue(null);
                this.txt01_PERSON_SALES.SetValue(null);
                this.txt01_DEBT.SetValue(null);
                this.txt01_DEBT_RATE.SetValue(null);
                this.txt01_QUITY.SetValue(null);
                this.txt01_TURNOVER_RATE.SetValue(null);
                this.txt01_TOTAL_SALES.SetValue(null);
                this.txt01_BUSINESS_PROFITS.SetValue(null);
                this.txt01_HKMC_TRADE_RATE.SetValue(null);
                this.txt01_ETC_TRACE_RATE.SetValue(null);
                this.txt01_ORDINARY_INCOME.SetValue(null);
            }
            return source;
        }

        /// <summary>
        /// 재무제표 현황 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_VM2090()
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD",
                                 "STD_YEAR", "MONEY_UNIT", "DEBT", "QUITY",
                                 "ASSETS", "TOTAL_SALES", "BUSINESS_PROFITS",
                                 "ORDINARY_INCOME", "PERSON_SALES", "DEBT_RATE",
                                 "TURNOVER_RATE", "HKMC_TRADE_RATE", "ETC_TRACE_RATE",
                                 "USER_ID");

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.txt01_STD_YEAR.Value,
                            this.cdx01_MONEY_UNIT.Value,
                            this.txt01_DEBT.Value == null ? null : this.txt01_DEBT.Value.ToString().Replace(",", ""),
                            this.txt01_QUITY.Value == null ? null : this.txt01_QUITY.Value.ToString().Replace(",", ""),
                            this.txt01_ASSETS.Value == null ? null : this.txt01_ASSETS.Value.ToString().Replace(",", ""),
                            this.txt01_TOTAL_SALES.Value == null ? null : this.txt01_TOTAL_SALES.Value.ToString().Replace(",", ""),
                            this.txt01_BUSINESS_PROFITS.Value == null ? null : this.txt01_BUSINESS_PROFITS.Value.ToString().Replace(",", ""),
                            this.txt01_ORDINARY_INCOME.Value == null ? null : this.txt01_ORDINARY_INCOME.Value.ToString().Replace(",", ""),
                            this.txt01_PERSON_SALES.Value == null ? null : this.txt01_PERSON_SALES.Value.ToString().Replace(",", ""),
                            this.txt01_DEBT_RATE.Value == null ? null : this.txt01_DEBT_RATE.Value.ToString().Replace(",", ""),
                            this.txt01_TURNOVER_RATE.Value == null ? null : this.txt01_TURNOVER_RATE.Value.ToString().Replace(",", ""),
                            this.txt01_HKMC_TRADE_RATE.Value,
                            this.txt01_ETC_TRACE_RATE.Value,
                            this.UserInfo.UserID
                        );

                if (!this.txt01_STD_YEAR.IsEmpty)
                {
                    using (EPClientProxy proxy = new EPClientProxy())
                    {
                        proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ASRM2090"), param);
                        this.MsgCodeAlert("COM-00902");
                        this.Get_ASRM2090();
                    }
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
        ///재무제표 삭제
        /// </summary>
        /// <param name="e"></param>
        public void Remove_ASRM2090()
        {
            try
            {

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "VENDCD", "STD_YEAR", "USER_ID"
                );

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode,
                            VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.txt01_STD_YEAR.Value,
                            this.UserInfo.UserID
                        );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE_ASRM2090"), param);
                    this.MsgCodeAlert("COM-00903");
                    this.Get_ASRM2090();
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


        ///// <summary>
        ///// 년도별 재무제표정보 조회
        ///// </summary>
        ///// <returns></returns>
        //private DataSet getFinancialDataSet()
        //{
        //    HEParameterSet param = new HEParameterSet();
        //    param.Add("CORCD", this.UserInfo.CorporationCode);
        //    param.Add("BIZCD", this.UserInfo.BusinessCode);
        //    param.Add("VENDCD", this.cdx01_VENDCD.Value);
        //    param.Add("STD_YEAR", this.txt01_STD_YEAR.Value);
        //    param.Add("LANG_SET", this.UserInfo.LanguageShort);
        //    param.Add("USER_ID", this.UserInfo.UserID);
        //    return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_FINANCIAL"), param, new string[] { "OUT_CURSOR", "OUT_CURSOR_PURCHASE" });
        //}

        #endregion

        #region [SRM2100 : 주요공급업체 매입현황]

        private void Get_ASRM2100()
        {
            this.YEAR_PURCAMT.Text = string.Format(Library.getLabel("SRM_VM20001", "YEAR_PURCAMT"), this.txt02_STD_YEAR.Value.ToString());

            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
            param.Add("STD_YEAR", this.txt02_STD_YEAR.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ASRM2100"), param);


            this.Store_Grid03.RemoveAll();
            this.Store_Grid03.DataSource = source.Tables[0];
            this.Store_Grid03.DataBind();

            for (int i = source.Tables[0].Rows.Count; i < 4; i++)
            {
                Store_Grid03.Add(i);
            }

        }

        /// <summary>
        /// 주요공급업체 매입현황 저장
        /// </summary>
        /// <param name="e"></param>
        public void Save_ASRM2100(DirectEventArgs e)
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
                    "CORCD", "VENDCD", "STD_YEAR", "SEQNO", "VENDNM1", "ITEMNM1", "PURCHASE1", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value, this.txt02_STD_YEAR.Value,
                         parameter[i]["SEQNO"], parameter[i]["VENDNM1"], parameter[i]["ITEMNM1"], parameter[i]["PURCHASE1"],
                         Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ASRM2100_2"), param);
                    this.MsgCodeAlert("COM-00902");
                    this.Get_ASRM2100();
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
        /// 주요공급업체 매입현황 삭제
        /// </summary>
        /// <param name="e"></param>
        public void Remove_ASRM2100(DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00023");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "VENDCD", "STD_YEAR", "SEQNO", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value, this.txt02_STD_YEAR.Value,
                         parameter[i]["SEQNO"], Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "DELETE_ASRM2100_2"), param);
                    this.MsgCodeAlert("COM-00903");
                    this.Get_ASRM2100();
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

        #region [SRM2130 : 주요설비현황(생산설비)]

        private DataSet Get_ASRM2130()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            DataSet sourceFacil = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ASRM2130"), param);

            for (int i = sourceFacil.Tables[0].Rows.Count + 1; i < 4; i++)
            {
                sourceFacil.Tables[0].Rows.Add(i, "", "", "", "", "", null);
            }

            this.Store_Grid01.RemoveAll();
            this.Store_Grid01.DataSource = sourceFacil.Tables[0];
            this.Store_Grid01.DataBind();
                        
            //for (int i = sourceFacil.Tables[0].Rows.Count; i < 4; i++)
            //{
            //    Store_Grid01.Add(i);
            //}

            return sourceFacil;
        }

        /// <summary>
        /// 주요설비현황(생산설비) 저장
        /// </summary>
        /// <param name="e"></param>
        public void Save_ASRM2130(DirectEventArgs e)
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
                    "CORCD", "VENDCD", "FACILNM1", "MAKER1", "REMARK1", "SEQNO", "FACILCNT", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                         parameter[i]["FACILNM1"], parameter[i]["FACIL_MAKER1"], parameter[i]["FACIL_REMARK1"], parameter[i]["SEQNO"], parameter[i]["FACILCNT"],
                         Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ASRM2130_2"), param);
                    this.MsgCodeAlert("COM-00902");
                    this.Get_ASRM2130();
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
        /// 주요설비현황(생산설비) 삭제
        /// </summary>
        /// <param name="e"></param>
        public void Remove_ASRM2130(DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00023");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "VENDCD", "SEQNO", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                         parameter[i]["SEQNO"], Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "DELETE_ASRM2130_2"), param);
                    this.MsgCodeAlert("COM-00903");
                    this.Get_ASRM2130();
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

        #region [SRM2140 : 주요설비현황(실험 및 측정설비)]

        private DataSet Get_ASRM2140()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            DataSet sourceEquip = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ASRM2140"), param);

            for (int i = sourceEquip.Tables[0].Rows.Count + 1; i < 4; i++)
            {
                sourceEquip.Tables[0].Rows.Add("", "", i, "", "", "", null, null);
            }

            this.Store_Grid02.RemoveAll();
            this.Store_Grid02.DataSource = sourceEquip.Tables[0];
            this.Store_Grid02.DataBind();

            //for (int i = sourceEquip.Tables[0].Rows.Count; i < 4; i++)
            //{
            //    Store_Grid02.Add(i);
            //}

            return sourceEquip;
        }

        /// <summary>
        /// 주요설비현황(실험 및 측정설비) 저장
        /// </summary>
        /// <param name="e"></param>
        public void Save_ASRM2140(DirectEventArgs e)
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
                    "CORCD", "VENDCD", "EQUIPNM1", "MAKER1", "REMARK1", "SEQNO", "EQUIPCNT", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                         parameter[i]["EQUIPNM1"], parameter[i]["EQUIP_MAKER1"], parameter[i]["EQUIP_REMARK1"], parameter[i]["SEQNO"], parameter[i]["EQUIPCNT"],
                         Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ASRM2140_2"), param);
                    this.MsgCodeAlert("COM-00902");
                    this.Get_ASRM2140();
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
        /// 주요설비현황(실험 및 측정설비) 삭제
        /// </summary>
        /// <param name="e"></param>
        public void Remove_ASRM2140(DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00023");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "VENDCD", "SEQNO", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                         parameter[i]["SEQNO"], Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "DELETE_ASRM2140_2"), param);
                    this.MsgCodeAlert("COM-00903");
                    this.Get_ASRM2140();
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

        #region [SRM2150 : 금형보유현황 ]

        //서연이화 금형 보유현황
        private void Get_ASRM2150()
        {

            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ASRM2150"), param);

            for (int i = source.Tables[0].Rows.Count + 1; i < 10; i++)
            {
                source.Tables[0].Rows.Add(i, "",null, null,null, null, null,null);
            }

            this.Store_Grid04.RemoveAll();
            this.Store_Grid04.DataSource = source.Tables[0];
            this.Store_Grid04.DataBind();
            
            //for (int i = source.Tables[0].Rows.Count; i < 10; i++)
            //{
            //    Store_Grid04.Add(i);
            //}

            //합계처리
            int injection = 0;
            int forming = 0;
            int press = 0;
            int etc = 0;
            int total = 0;
            foreach (DataRow dr in source.Tables[0].Rows)
            {
                injection += (dr["INJECTION"] == DBNull.Value ? 0 : Convert.ToInt32(dr["INJECTION"]));
                forming += (dr["FORMING"] == DBNull.Value ? 0 : Convert.ToInt32(dr["FORMING"]));
                press += (dr["PRESS"] == DBNull.Value ? 0 : Convert.ToInt32(dr["PRESS"]));
                etc += (dr["ETC"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ETC"]));
                total += (dr["TOTAL"] == DBNull.Value ? 0 : Convert.ToInt32(dr["TOTAL"]));
            }

            this.lbl01_INJECTION_TOT.Text = injection.ToString("#,##0");
            this.lbl01_FORMING_TOT.Text = forming.ToString("#,##0");
            this.lbl01_PRESS_TOT.Text = press.ToString("#,##0");
            this.lbl01_ETC_TOT.Text = etc.ToString("#,##0");
            this.lbl01_TOTAL_TOT.Text = total.ToString("#,##0");
        }

        /// <summary>
        /// 금형 보유 현황 저장
        /// </summary>
        /// <param name="e"></param>
        public void Save_ASRM2150(DirectEventArgs e)
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
                    "CORCD", "VENDCD", "SEQNO", "VIN", "INJECTION", "FORMING", "PRESS", "ETC", "TOTAL", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    if (parameter[i]["VIN"] == null || parameter[i]["VIN"] == string.Empty)
                    {
                        this.MsgCodeAlert_ShowFormat("SRMVM-0007", "Grid04", parameter[i]["NO"]);
                        return;
                    }


                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                         parameter[i]["SEQNO"], parameter[i]["VIN"], parameter[i]["INJECTION"],
                         parameter[i]["FORMING"], parameter[i]["PRESS"], parameter[i]["ETC"],
                         parameter[i]["TOTAL"], Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ASRM2150_2"), param);
                    this.MsgCodeAlert("COM-00902");
                    this.Get_ASRM2150();
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
        ///금형 보유현황 매입현황 삭제
        /// </summary>
        /// <param name="e"></param>
        public void Remove_ASRM2150(DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00023");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "VENDCD", "SEQNO", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                         parameter[i]["SEQNO"], Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "DELETE_ASRM2150_2"), param);
                    this.MsgCodeAlert("COM-00903");
                    this.Get_ASRM2150();
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

        #region [SRM2160 : 1차사 거래 현황 저장 ]

        //1차사 거래 현황
        private void Get_ASRM2160()
        {

            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("STD_YEAR", this.txt03_STD_YEAR.Value);
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ASRM2160"), param);


            this.Store_Grid05.RemoveAll();
            this.Store_Grid05.DataSource = source.Tables[0];
            this.Store_Grid05.DataBind();

            for (int i = source.Tables[0].Rows.Count; i < 3; i++)
            {
                Store_Grid05.Add(i);
            }

        }


        /// <summary>
        /// 1차사 거래 현황 저장
        /// </summary>
        /// <param name="e"></param>
        public void Save_ASRM2160(DirectEventArgs e)
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
                    "CORCD", "VENDCD", "SEQNO", "STD_YEAR", "BIZ_CODE", "SQ_CATEGORY", "VENDNM1", "TRANS_AMT1", "TRANS_RATE1", "VENDNM2", "TRANS_AMT2", "TRANS_RATE2", "VENDNM3", "TRANS_AMT3", "TRANS_RATE3", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    if (parameter[i]["BIZ_CODE"] == null || parameter[i]["BIZ_CODE"] == string.Empty)
                    {
                        this.MsgCodeAlert("SRMVM-0015"); //SQ MARK인증정보를 먼저 등록하여야 합니다.
                        return;
                    }

                    if (parameter[i]["SQ_CATEGORY"] == null || parameter[i]["SQ_CATEGORY"] == string.Empty)
                    {
                        this.MsgCodeAlert("SRMVM-0015"); //SQ MARK인증정보를 먼저 등록하여야 합니다.
                        return;
                    }

                    //if (parameter[i]["MAIN_ITEM"] == null || parameter[i]["MAIN_ITEM"] == string.Empty)
                    //{
                    //    this.MsgCodeAlert_ShowFormat("SRMVM-0009", "Grid05", parameter[i]["NO"]);
                    //    return;
                    //}

                    //if (parameter[i]["SEWING_RATE"] != null || parameter[i]["SEWING_RATE"] != string.Empty)
                    //{
                    //    decimal rate = Convert.ToDecimal(parameter[i]["SEWING_RATE"]);
                    //    if (rate > 100)
                    //    {
                    //        this.MsgCodeAlert_ShowFormat("SRMVM-0012", "Grid05", parameter[i]["NO"]);
                    //        return;
                    //    }
                    //}

                    if (!(parameter[i]["TRANS_RATE1"] == null || parameter[i]["TRANS_RATE1"] == string.Empty))
                    {
                        decimal rate = Convert.ToDecimal(parameter[i]["TRANS_RATE1"]);
                        if (rate > 100)
                        {
                            this.MsgCodeAlert_ShowFormat("SRMVM-0012", "Grid05", parameter[i]["NO"]);
                            return;
                        }
                    }

                    if (!(parameter[i]["TRANS_RATE2"] == null || parameter[i]["TRANS_RATE2"] == string.Empty))
                    {
                        decimal rate = Convert.ToDecimal(parameter[i]["TRANS_RATE2"]);
                        if (rate > 100)
                        {
                            this.MsgCodeAlert_ShowFormat("SRMVM-0012", "Grid05", parameter[i]["NO"]);
                            return;
                        }
                    }

                    if (!(parameter[i]["TRANS_RATE3"] == null || parameter[i]["TRANS_RATE3"] == string.Empty))
                    {
                        decimal rate = Convert.ToDecimal(parameter[i]["TRANS_RATE3"]);
                        if (rate > 100)
                        {
                            this.MsgCodeAlert_ShowFormat("SRMVM-0012", "Grid05", parameter[i]["NO"]);
                            return;
                        }
                    }

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                         parameter[i]["SEQNO"], this.txt03_STD_YEAR.Value,
                         parameter[i]["BIZ_CODE"], parameter[i]["SQ_CATEGORY"],
                         parameter[i]["VENDNM1"], parameter[i]["TRANS_AMT1"], parameter[i]["TRANS_RATE1"],
                         parameter[i]["VENDNM2"], parameter[i]["TRANS_AMT2"], parameter[i]["TRANS_RATE2"],
                         parameter[i]["VENDNM3"], parameter[i]["TRANS_AMT3"], parameter[i]["TRANS_RATE3"],
                         Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_ASRM2160_2"), param);
                    this.MsgCodeAlert("COM-00902");
                    this.Get_ASRM2160();
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
        ///1차사 거래 현황 삭제
        /// </summary>
        /// <param name="e"></param>
        public void Remove_ASRM2160(DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameter.Length == 0)
                {
                    this.MsgCodeAlert("COM-00023");
                    return;
                }

                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "VENDCD", "SEQNO", "USER_ID"
                );

                for (int i = 0; i < parameter.Length; i++)
                {

                    param.Tables[0].Rows.Add(
                         Util.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                         parameter[i]["SEQNO"], Util.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "DELETE_ASRM2160_2"), param);
                    this.MsgCodeAlert("COM-00903");
                    this.Get_ASRM2160();
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


        #region [조회]
        /// <summary>
        /// 조회
        /// </summary>
        public void Search()
        {
            try
            {
                if (!IsQueryValidation())
                {
                    return;
                }

                DataSet source = this.getDataSet();

                if (source.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = source.Tables[0].Rows[0];

                    #region [ 기본 정보 ]
                    this.txt01_VAATZCD.SetValue(dr["VAATZCD"]);
                    this.cbo01_SYEH_SQ_MAIN.SetValue(dr["SYEH_SQ_MAIN"]);
                    this.cbo01_VEND_TIER.SetValue(dr["VEND_TIER"]);
                    //this.txt01_UP_VEND.SetValue(dr["UP_VEND"]);
                    this.cdx01_UP_VEND.SetValue(dr["UP_VEND"]);
                    this.cbo01_SUBCONTR_YN.SetValue(dr["SUBCONTR_YN"]);

                    this.txt01_VEND_NATCD.SetValue(dr["VEND_NATCD"]);
                    this.txt01_CITY.SetValue(dr["CITY"]);
                    this.cbo01_USE_LANG.SetValue(dr["USE_LANG"]);
                    this.txt01_VENDNM_EN.SetValue(dr["VENDNM_EN"]);
                    this.txt01_VENDNM.SetValue(dr["VENDNM"]);
                    this.txt01_RESI_NO.SetValue(dr["RESI_NO"]);
                    this.txt01_EMAIL.SetValue(dr["EMAIL"]);
                    this.txt01_TEL.SetValue(dr["TEL"]);
                    this.txt01_FAX.SetValue(dr["FAX"]);
                    this.txt01_ADDR_EN.SetValue(dr["ADDR_EN"]);
                    this.txt01_CITY_EN.SetValue(dr["CITY_EN"]);
                    this.txt01_STATE.SetValue(dr["STATE"]);
                    this.txt01_ADDR.SetValue(dr["ADDR"]);

                    this.img01_SEAL_IMAGE.ImageUrl = (dr["SEAL_IMAGE"] == DBNull.Value ? CommonString.NoImage : Util.FileEncoding((byte[])dr["SEAL_IMAGE"], true));
                    this.hid01_SEAL_IMAGE.Text = (dr["SEAL_IMAGE"] == DBNull.Value ? string.Empty : "Y");

                    #endregion

                    #region [ 대표자 정보 ]
                    this.txt01_REP_NAME_EN.SetValue(dr["REP_NAME_EN"]);
                    this.txt01_REP_NAME.SetValue(dr["REP_NAME"]);
                    this.df01_BIRTH_DATE.SetValue(dr["BIRTH_DATE"]);
                    this.txt01_FAMILY_ADDR.SetValue(dr["FAMILY_ADDR"]);
                    this.txt01_LAST_SCH_EN.SetValue(dr["LAST_SCH_EN"]);
                    this.txt01_LAST_SCH.SetValue(dr["LAST_SCH"]);
                    this.txt01_CAREER_EN.SetValue(dr["CAREER_EN"]);
                    this.txt01_CAREER.SetValue(dr["CAREER"]);
                    this.img01_REP_PHOTO.ImageUrl = (dr["REP_PHOTO"] == DBNull.Value ? CommonString.NoImage : Util.FileEncoding((byte[])dr["REP_PHOTO"], true));
                    this.hid01_REP_PHOTO.Text = (dr["REP_PHOTO"] == DBNull.Value ? string.Empty : "Y");
                    #endregion

                    #region [ 임직원 정보 ]
                    this.txt01_EXECUTIVE.SetValue(dr["EXECUTIVE"]);
                    this.txt01_MANAGER.SetValue(dr["MANAGER"]);
                    this.txt01_PROD_LOCAL.SetValue(dr["PROD_LOCAL"]);
                    this.txt01_PROD_FOREIGN.SetValue(dr["PROD_FOREIGN"]);
                    this.txt01_SUBCONTRACT.SetValue(dr["SUBCONTRACT"]);
                    this.txt01_PROD_TOTAL.SetValue(dr["PROD_TOTAL"]);
                    this.txt01_ALL_CNT.SetValue(dr["ALL_CNT"]);
                    #endregion

                    #region [ 노조 정보 ]
                    this.cbo01_LABOR1.SetValue(dr["LABOR_DIV1"]);
                    this.txt01_LABOR_CNT1.SetValue(dr["LABOR_CNT1"]);
                    this.cbo01_LABOR2.SetValue(dr["LABOR_DIV2"]);
                    this.txt01_LABOR_CNT2.SetValue(dr["LABOR_CNT2"]);
                    this.cbo01_LABOR2.SetValue(dr["LABOR_DIV3"]);
                    this.txt01_LABOR_CNT3.SetValue(dr["LABOR_CNT3"]);

                    #endregion

                    #region [ 품질인증 정보 ]
                    this.cbo01_QUAL_CERTI_DIV1.SetValue(dr["QUAL_CERTI_DIV1"]);
                    this.df01_CERTI_DATE1.SetValue(dr["CERTI_DATE1"]);
                    this.txt01_AUTH_NATION1.SetValue(dr["AUTH_NATION1"]);
                    this.txt01_AUTH_AGENCY1.SetValue(dr["AUTH_AGENCY1"]);
                    this.cbo01_QUAL_CERTI_DIV2.SetValue(dr["QUAL_CERTI_DIV2"]);
                    this.df01_CERTI_DATE2.SetValue(dr["CERTI_DATE2"]);
                    this.txt01_AUTH_NATION2.SetValue(dr["AUTH_NATION2"]);
                    this.txt01_AUTH_AGENCY2.SetValue(dr["AUTH_AGENCY2"]);
                    this.cbo01_QUAL_CERTI_DIV3.SetValue(dr["QUAL_CERTI_DIV3"]);
                    this.df01_CERTI_DATE3.SetValue(dr["CERTI_DATE3"]);
                    this.txt01_AUTH_NATION3.SetValue(dr["AUTH_NATION3"]);
                    this.txt01_AUTH_AGENCY3.SetValue(dr["AUTH_AGENCY3"]);
                    this.cbo01_QUAL_CERTI_DIV4.SetValue(dr["QUAL_CERTI_DIV4"]);
                    this.df01_CERTI_DATE4.SetValue(dr["CERTI_DATE4"]);
                    this.txt01_AUTH_NATION4.SetValue(dr["AUTH_NATION4"]);
                    this.txt01_AUTH_AGENCY4.SetValue(dr["AUTH_AGENCY4"]);
                    this.cbo01_QUAL_CERTI_DIV5.SetValue(dr["QUAL_CERTI_DIV5"]);
                    this.df01_CERTI_DATE5.SetValue(dr["CERTI_DATE5"]);
                    this.txt01_AUTH_NATION5.SetValue(dr["AUTH_NATION5"]);
                    this.txt01_AUTH_AGENCY5.SetValue(dr["AUTH_AGENCY5"]);
                    #endregion

                    #region [ 품목 정보 ]
                    this.cdx01_MAIN_CATEGORY.SetValue(dr["MAIN_CATEGORY"]);
                    this.txt01_PARTNM_EN1.SetValue(dr["PARTNM_EN1"]);
                    this.txt01_PARTNM1.SetValue(dr["PARTNM1"]);
                    this.txt01_MAIN_DELINM_EN1.SetValue(dr["MAIN_DELINM_EN1"]);
                    this.txt01_MAIN_DELINM1.SetValue(dr["MAIN_DELINM1"]);
                    this.cbo01_MAIN_DELI_TIER1.SetValue(dr["MAIN_DELI_TIER1"]);
                    this.txt01_YEARLY_SALES1.SetValue(dr["YEARLY_SALES1"] != DBNull.Value ? Convert.ToDecimal(dr["YEARLY_SALES1"]).ToString("#,###") : "0");
                    this.txt01_SALES_RATIO1.SetValue(dr["SALES_RATIO1"]);
                    this.df01_FIRST_DELI_DATE1.SetValue(dr["FIRST_DELI_DATE1"]);
                    this.img01_PHOTO1.ImageUrl = (dr["PHOTO1"] == DBNull.Value ? CommonString.NoImage : Util.FileEncoding((byte[])dr["PHOTO1"], true));
                    this.hid01_PHOTO1.Text = (dr["PHOTO1"] == DBNull.Value ? string.Empty : "Y");
                    this.txt01_PARTNM_EN2.SetValue(dr["PARTNM_EN2"]);
                    this.txt01_PARTNM2.SetValue(dr["PARTNM2"]);
                    this.txt01_MAIN_DELINM_EN2.SetValue(dr["MAIN_DELINM_EN2"]);
                    this.txt01_MAIN_DELINM2.SetValue(dr["MAIN_DELINM2"]);
                    this.cbo01_MAIN_DELI_TIER2.SetValue(dr["MAIN_DELI_TIER2"]);
                    this.txt01_YEARLY_SALES2.SetValue(dr["YEARLY_SALES2"] != DBNull.Value ? Convert.ToDecimal(dr["YEARLY_SALES2"]).ToString("#,###") : "0");
                    this.txt01_SALES_RATIO2.SetValue(dr["SALES_RATIO2"]);
                    this.df01_FIRST_DELI_DATE2.SetValue(dr["FIRST_DELI_DATE2"]);
                    this.img01_PHOTO2.ImageUrl = (dr["PHOTO2"] == DBNull.Value ? CommonString.NoImage : Util.FileEncoding((byte[])dr["PHOTO2"], true));
                    this.hid01_PHOTO2.Text = (dr["PHOTO2"] == DBNull.Value ? string.Empty : "Y");
                    this.txt01_PARTNM_EN3.SetValue(dr["PARTNM_EN3"]);
                    this.txt01_PARTNM3.SetValue(dr["PARTNM3"]);
                    this.txt01_MAIN_DELINM_EN3.SetValue(dr["MAIN_DELINM_EN3"]);
                    this.txt01_MAIN_DELINM3.SetValue(dr["MAIN_DELINM3"]);
                    this.cbo01_MAIN_DELI_TIER3.SetValue(dr["MAIN_DELI_TIER3"]);
                    this.txt01_YEARLY_SALES3.SetValue(dr["YEARLY_SALES3"] != DBNull.Value ? Convert.ToDecimal(dr["YEARLY_SALES3"]).ToString("#,###") : "0");
                    this.txt01_SALES_RATIO3.SetValue(dr["SALES_RATIO3"]);
                    this.df01_FIRST_DELI_DATE3.SetValue(dr["FIRST_DELI_DATE3"]);
                    this.img01_PHOTO3.ImageUrl = (dr["PHOTO3"] == DBNull.Value ? CommonString.NoImage : Util.FileEncoding((byte[])dr["PHOTO3"], true));
                    this.hid01_PHOTO3.Text = (dr["PHOTO3"] == DBNull.Value ? string.Empty : "Y");
                    #endregion

                    #region [ 주주현황 ]
                    this.txt01_SHAREHOLDER_EN1.SetValue(dr["SHAREHOLDER_EN1"]);
                    this.txt01_SHAREHOLDER1.SetValue(dr["SHAREHOLDER1"]);
                    this.txt01_SHARE_RATE1.SetValue(dr["SHARE_RATE1"]);
                    this.txt01_SHAREHOLDER_EN2.SetValue(dr["SHAREHOLDER_EN2"]);
                    this.txt01_SHAREHOLDER2.SetValue(dr["SHAREHOLDER2"]);
                    this.txt01_SHARE_RATE2.SetValue(dr["SHARE_RATE2"]);
                    this.txt01_SHAREHOLDER_EN3.SetValue(dr["SHAREHOLDER_EN3"]);
                    this.txt01_SHAREHOLDER3.SetValue(dr["SHAREHOLDER3"]);
                    this.txt01_SHARE_RATE3.SetValue(dr["SHARE_RATE3"]);
                    this.txt01_SHAREHOLDER_EN4.SetValue(dr["SHAREHOLDER_EN4"]);
                    this.txt01_SHAREHOLDER4.SetValue(dr["SHAREHOLDER4"]);
                    this.txt01_SHARE_RATE4.SetValue(dr["SHARE_RATE4"]);
                    #endregion

                    #region [ 관계사현황(계열사) ]
                    this.txt01_AFFILIATE_EN1.SetValue(dr["AFFILIATE_EN1"]);
                    this.txt01_AFFILIATE1.SetValue(dr["AFFILIATE1"]);
                    this.txt01_AFFILIATE_EN2.SetValue(dr["AFFILIATE_EN2"]);
                    this.txt01_AFFILIATE2.SetValue(dr["AFFILIATE2"]);
                    this.txt01_AFFILIATE_EN3.SetValue(dr["AFFILIATE_EN3"]);
                    this.txt01_AFFILIATE3.SetValue(dr["AFFILIATE3"]);
                    #endregion

                    #region [ 해외진출현황 ]
                    this.txt01_US_CNT.SetValue(dr["US_CNT"]);
                    this.txt01_US_REMARK.SetValue(dr["US_REMARK"]);
                    this.txt01_CHINA_CNT.SetValue(dr["CHINA_CNT"]);
                    this.txt01_CHINA_REMARK.SetValue(dr["CHINA_REMARK"]);
                    this.txt01_EU_CNT.SetValue(dr["EU_CNT"]);
                    this.txt01_EU_REMARK.SetValue(dr["EU_REMARK"]);
                    this.txt01_INDIA_CNT.SetValue(dr["INDIA_CNT"]);
                    this.txt01_INDIA_REMARK.SetValue(dr["INDIA_REMARK"]);
                    this.txt01_ETC_CNT.SetValue(dr["ETC_CNT"]);
                    this.txt01_ETC_REMARK.SetValue(dr["ETC_REMARK"]);
                    #endregion

                    #region [ 연혁 ]
                    this.df01_FOUND_DATE.SetValue(dr["FOUND_DATE"]);
                    this.txt01_FOUNDER.SetValue(dr["FOUNDER"]);
                    this.txt01_CURR_HEAD.SetValue(dr["CURR_HEAD"]);
                    this.txt01_RELATION.SetValue(dr["RELATION"]);
                    #endregion

                    #region [ SQ인증 ]
                    this.txt01_BIZCD1.SetValue(dr["BIZ_CODE1"]);
                    this.cdx01_SQ_CATEGORY1.SetValue(dr["SQ_CATEGORY1"]);
                    this.cbo01_SQ_GRADE1.SetValue(dr["SQ_GRADE1"]);
                    this.txt01_SQ_POINT1.SetValue(dr["SQ_POINT1"]);
                    this.df01_CERT_DATE1.SetValue(dr["CERT_DATE1"]);
                    this.df01_VALID_DATE1.SetValue(dr["VALID_DATE1"]);
                    this.txt01_MAIN_CHARGE1.SetValue(dr["MAIN_CHARGE1"]);
                    this.chk01_SQ_MAIN1.SetValue(dr["SQ_MAIN1"].ToString() == "Y" ? true : false);

                    this.txt01_BIZCD2.SetValue(dr["BIZ_CODE2"]);
                    this.cdx01_SQ_CATEGORY2.SetValue(dr["SQ_CATEGORY2"]);
                    this.cbo01_SQ_GRADE2.SetValue(dr["SQ_GRADE2"]);
                    this.txt01_SQ_POINT2.SetValue(dr["SQ_POINT2"]);
                    this.df01_CERT_DATE2.SetValue(dr["CERT_DATE2"]);
                    this.df01_VALID_DATE2.SetValue(dr["VALID_DATE2"]);
                    this.txt01_MAIN_CHARGE2.SetValue(dr["MAIN_CHARGE2"]);
                    this.chk01_SQ_MAIN2.SetValue(dr["SQ_MAIN2"].ToString() == "Y" ? true : false);

                    this.txt01_BIZCD3.SetValue(dr["BIZ_CODE3"]);
                    this.cdx01_SQ_CATEGORY3.SetValue(dr["SQ_CATEGORY3"]);
                    this.cbo01_SQ_GRADE3.SetValue(dr["SQ_GRADE3"]);
                    this.txt01_SQ_POINT3.SetValue(dr["SQ_POINT3"]);
                    this.df01_CERT_DATE3.SetValue(dr["CERT_DATE3"]);
                    this.df01_VALID_DATE3.SetValue(dr["VALID_DATE3"]);
                    this.txt01_MAIN_CHARGE3.SetValue(dr["MAIN_CHARGE3"]);
                    this.chk01_SQ_MAIN3.SetValue(dr["SQ_MAIN3"].ToString() == "Y" ? true : false);
                    #endregion

                    #region [ 기타 ]
                    this.txt01_AREA.SetValue(dr["AREA"] != DBNull.Value ? Convert.ToDecimal(dr["AREA"]).ToString("#,###") : "0");
                    this.txt01_BUILDING.SetValue(dr["BUILDING"] != DBNull.Value ? Convert.ToDecimal(dr["BUILDING"]).ToString("#,###") : "0");
                    this.cbo01_UNIT.SetValue(dr["UNIT"]);
                    this.cbo01_SCALE.SetValue(dr["SCALE"]);
                    this.cbo01_STOCK_YN.SetValue(dr["STOCK_YN"]);
                    this.txt01_CAPACITY_RATE.SetValue(dr["CAPACITY_RATE"]);


                    // 여기서 부터 파일처리
                    this.hid01_FILEID1.SetValue(dr["CREDIT_EVAL_FILE"]);
                    this.hid01_FILEID2.SetValue(dr["SQ_CERTI_FILE"]);

                    if (!this.hid01_FILEID1.Value.ToString().Equals(""))
                    {
                        this.dwn01_FILEID1.Text = dr["CREDIT_EVAL_FILENAME"].ToString();
                        this.dwn01_FILEID1.NavigateUrl = Util.JsFileDirectDownloadByFileID(this.hid01_FILEID1.Value.ToString());
                        this.dwn01_FILEID1.Icon = Icon.Attach;
                    }

                    if (!this.hid01_FILEID2.Value.ToString().Equals(""))
                    {
                        this.dwn01_FILEID2.Text = dr["SQ_CERTI_FILENAME"].ToString();
                        this.dwn01_FILEID2.NavigateUrl = Util.JsFileDirectDownloadByFileID(this.hid01_FILEID2.Value.ToString());
                        this.dwn01_FILEID2.Icon = Icon.Attach;
                    }


                    #endregion

                    #region [최근 년도 처리]

                    this.txt01_STD_YEAR.SetValue(dr["ASRM2090_STD_YEAR"]);
                    this.txt02_STD_YEAR.SetValue(dr["ASRM2100_STD_YEAR"]);
                    this.txt03_STD_YEAR.SetValue(dr["ASRM2160_STD_YEAR"]);

                    #endregion

                }
                else
                {
                    this.ClearInput(this.Controls);
                }

                #region [서연이화 금형 보유현황]
                this.Get_ASRM2150();
                #endregion

                #region [1차사 거래 현황]
                this.Get_ASRM2160();
                #endregion


                #region [ 주요설비현황(생산설비) ]

                this.Get_ASRM2130();

                //this.txt01_FACILNM1.SetValue(dr["FACILNM1"]);
                //this.txt01_FACIL_MAKER1.SetValue(dr["FACIL_MAKER1"]);
                //this.txt01_FACIL_REMARK1.SetValue(dr["FACIL_REMARK1"]);
                //this.txt01_FACILNM2.SetValue(dr["FACILNM2"]);
                //this.txt01_FACIL_MAKER2.SetValue(dr["FACIL_MAKER2"]);
                //this.txt01_FACIL_REMARK2.SetValue(dr["FACIL_REMARK2"]);
                //this.txt01_FACILNM3.SetValue(dr["FACILNM3"]);
                //this.txt01_FACIL_MAKER3.SetValue(dr["FACIL_MAKER3"]);
                //this.txt01_FACIL_REMARK3.SetValue(dr["FACIL_REMARK3"]);
                //this.txt01_FACILNM4.SetValue(dr["FACILNM4"]);
                //this.txt01_FACIL_MAKER4.SetValue(dr["FACIL_MAKER4"]);
                //this.txt01_FACIL_REMARK4.SetValue(dr["FACIL_REMARK4"]);
                #endregion

                #region [ 주요설비현황(실험 및 측정설비) ]
                this.Get_ASRM2140();
                //this.txt01_EQUIPNM1.SetValue(dr["EQUIPNM1"]);
                //this.txt01_EQUIP_MAKER1.SetValue(dr["EQUIP_MAKER1"]);
                //this.txt01_EQUIP_REMARK1.SetValue(dr["EQUIP_REMARK1"]);
                //this.txt01_EQUIPNM2.SetValue(dr["EQUIPNM2"]);
                //this.txt01_EQUIP_MAKER2.SetValue(dr["EQUIP_MAKER2"]);
                //this.txt01_EQUIP_REMARK2.SetValue(dr["EQUIP_REMARK2"]);
                //this.txt01_EQUIPNM3.SetValue(dr["EQUIPNM3"]);
                //this.txt01_EQUIP_MAKER3.SetValue(dr["EQUIP_MAKER3"]);
                //this.txt01_EQUIP_REMARK3.SetValue(dr["EQUIP_REMARK3"]);
                //this.txt01_EQUIPNM4.SetValue(dr["EQUIPNM4"]);
                //this.txt01_EQUIP_MAKER4.SetValue(dr["EQUIP_MAKER4"]);
                //this.txt01_EQUIP_REMARK4.SetValue(dr["EQUIP_REMARK4"]);
                #endregion

                #region [ 재무제표현황, 주요 공급업체 매입현황(매입액 높은 순으로 : 사급제외)]
                //txt01_STD_YEAR_Change(null, null);
                this.Get_ASRM2090();
                this.Get_ASRM2100();
                #endregion

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
        /// 협력업체 정보 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }


        #endregion

        #region [출력]
        /// <summary>
        /// 협력업체 정보 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSetReport()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("ASRM2160_STD_YEAR", this.txt03_STD_YEAR.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT"), param, new string[] { "OUT_CURSOR", "OUT_CURSOR_ASRM2130", "OUT_CURSOR_ASRM2140", "OUT_CURSOR_ASRM2150", "OUT_CURSOR_ASRM2160" });
        }

        /// <summary>
        /// 년도별 재무제표정보 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getFinancialDataSetReport()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
            param.Add("STD_YEAR", this.txt01_STD_YEAR.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("ASRM2100_STD_YEAR", this.txt02_STD_YEAR.Value);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_FINANCIAL_REPORT"), param, new string[] { "OUT_CURSOR", "OUT_CURSOR_PURCHASE" });
        }


        /// <summary>
        /// 중역보고용 협력업체 정보 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSetReport2()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("ASRM2090_STD_YEAR", this.txt01_STD_YEAR.Value);
            param.Add("ASRM2160_STD_YEAR", this.txt03_STD_YEAR.Value);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT2"), param, new string[] { "OUT_CURSOR", "OUT_CURSOR_ASRM2090", "OUT_CURSOR_ASRM2150", "OUT_CURSOR_ASRM2160" });
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

                //유효성 검사
                if (!IsSaveValid())
                {
                    return;
                }

                ArrayList arrDataSet = new ArrayList();
                ArrayList arrProcedure = new ArrayList();

                //저장
                this.Save_ASRM2010(arrDataSet, arrProcedure); //일반정보
                this.Save_ASRM2020(arrDataSet, arrProcedure); //대표자정보
                this.Save_ASRM2030(arrDataSet, arrProcedure); //임직원 및 노조정보
                this.Save_ASRM2040(arrDataSet, arrProcedure); //품질인증정보
                this.Save_ASRM2050(arrDataSet, arrProcedure); //품목정보
                this.Save_ASRM2060(arrDataSet, arrProcedure); //주주현황
                this.Save_ASRM2070(arrDataSet, arrProcedure); //관계사현황
                this.Save_ASRM2080(arrDataSet, arrProcedure); //해외진출
                //this.Save_VM2090(arrDataSet, arrProcedure); //재무제표
                //this.Save_VM2100(arrDataSet, arrProcedure); //매입현황
                this.Save_ASRM2110(arrDataSet, arrProcedure); //SQ인증정보
                this.Save_ASRM2120(arrDataSet, arrProcedure); //기타정보
                //this.Save_VM2130(arrDataSet, arrProcedure); //주요 설비 정보(생산설비)
                //this.Save_VM2140(arrDataSet, arrProcedure); //업체 주요 장비 정보 (실험 및 측정 장비) 

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
        /// 일반정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2010(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD", "VAATZCD", "SYEH_SQ_MAIN", "VEND_TIER", "UP_VEND", "SUBCONTR_YN",
                                 "VEND_NATCD", "STATE", "CITY", "CITY_EN", "USE_LANG", "VENDNM_EN",
                                 "VENDNM", "RESI_NO", "EMAIL", "TEL", "FAX", "ADDR_EN", "ADDR",
                                 "FOUND_DATE", "FOUNDER", "CURR_HEAD", "RELATION", "USER_ID", "BLOB$SEAL_IMAGE"
                                 );

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode,
                            VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.txt01_VAATZCD.Value,
                            this.cbo01_SYEH_SQ_MAIN.Value,
                            this.cbo01_VEND_TIER.Value,
                    //this.txt01_UP_VEND.Value,
                            this.cdx01_UP_VEND.Value,
                            this.cbo01_SUBCONTR_YN.Value,
                            this.txt01_VEND_NATCD.Value,
                            this.txt01_STATE.Value,
                            this.txt01_CITY.Value,
                            this.txt01_CITY_EN.Value,
                            this.cbo01_USE_LANG.Value,
                            this.txt01_VENDNM_EN.Value,
                            this.txt01_VENDNM.Value,
                            this.txt01_RESI_NO.Value,
                            this.txt01_EMAIL.Value,
                            this.txt01_TEL.Value,
                            this.txt01_FAX.Value,
                            this.txt01_ADDR_EN.Value,
                            this.txt01_ADDR.Value,
                            this.getDateString(this.df01_FOUND_DATE),
                            this.txt01_FOUNDER.Value,
                            this.txt01_CURR_HEAD.Value,
                            this.txt01_RELATION.Value,
                            this.UserInfo.UserID,
                            (this.fuf01_SEAL_IMAGE.FileBytes.Length == 0 ? null : Util.ImageCollapse(this.fuf01_SEAL_IMAGE.FileBytes))
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20001.SAVE_ASRM2010_2");
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
        /// 대표자정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2020(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD", "REP_NAME_EN", "REP_NAME",
                                 "BIRTH_DATE", "FAMILY_ADDR", "LAST_SCH_EN", "LAST_SCH",
                                 "CAREER_EN", "CAREER", "BLOB$PHOTO", "USER_ID"
                                 );

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode,
                            VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.txt01_REP_NAME_EN.Value,
                            this.txt01_REP_NAME.Value,
                            this.getDateString(this.df01_BIRTH_DATE),
                            this.txt01_FAMILY_ADDR.Value,
                            this.txt01_LAST_SCH_EN.Value,
                            this.txt01_LAST_SCH.Value,
                            this.txt01_CAREER_EN.Value,
                            this.txt01_CAREER.Value,
                            (this.fuf01_REP_PHOTO.FileBytes.Length == 0 ? null : Util.ImageCollapse(this.fuf01_REP_PHOTO.FileBytes)),
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20001.SAVE_ASRM2020");
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
        /// 임직원 및 노조정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2030(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD", "EXECUTIVE", "MANAGER",
                                 "PROD_LOCAL", "PROD_FOREIGN", "SUBCONTRACT",
                                 "LABOR_DIV1", "LABOR_CNT1", "LABOR_DIV2", "LABOR_CNT2",
                                 "LABOR_DIV3", "LABOR_CNT3", "USER_ID"
                                 );

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode,
                            VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.txt01_EXECUTIVE.Value,
                            this.txt01_MANAGER.Value,
                            this.txt01_PROD_LOCAL.Value,
                            this.txt01_PROD_FOREIGN.Value,
                            this.txt01_SUBCONTRACT.Value,
                            this.cbo01_LABOR1.Value,
                            this.txt01_LABOR_CNT1.Value,
                            this.cbo01_LABOR2.Value,
                            this.txt01_LABOR_CNT2.Value,
                            this.cbo01_LABOR3.Value,
                            this.txt01_LABOR_CNT3.Value,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20001.SAVE_ASRM2030");
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
        ///  품질인증정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2040(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD",
                                 "QUAL_CERTI_DIV1", "CERTI_DATE1", "AUTH_NATION1", "AUTH_AGENCY1",
                                 "QUAL_CERTI_DIV2", "CERTI_DATE2", "AUTH_NATION2", "AUTH_AGENCY2",
                                 "QUAL_CERTI_DIV3", "CERTI_DATE3", "AUTH_NATION3", "AUTH_AGENCY3",
                                 "QUAL_CERTI_DIV4", "CERTI_DATE4", "AUTH_NATION4", "AUTH_AGENCY4",
                                 "QUAL_CERTI_DIV5", "CERTI_DATE5", "AUTH_NATION5", "AUTH_AGENCY5",
                                 "USER_ID"
                                 );

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode,
                            VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.cbo01_QUAL_CERTI_DIV1.Value,
                            this.getDateString(this.df01_CERTI_DATE1),
                            this.txt01_AUTH_NATION1.Value,
                            this.txt01_AUTH_AGENCY1.Value,
                            this.cbo01_QUAL_CERTI_DIV2.Value,
                            this.getDateString(this.df01_CERTI_DATE2),
                            this.txt01_AUTH_NATION2.Value,
                            this.txt01_AUTH_AGENCY2.Value,
                            this.cbo01_QUAL_CERTI_DIV3.Value,
                            this.getDateString(this.df01_CERTI_DATE3),
                            this.txt01_AUTH_NATION3.Value,
                            this.txt01_AUTH_AGENCY3.Value,
                            this.cbo01_QUAL_CERTI_DIV4.Value,
                            this.getDateString(this.df01_CERTI_DATE4),
                            this.txt01_AUTH_NATION4.Value,
                            this.txt01_AUTH_AGENCY4.Value,
                            this.cbo01_QUAL_CERTI_DIV5.Value,
                            this.getDateString(this.df01_CERTI_DATE5),
                            this.txt01_AUTH_NATION5.Value,
                            this.txt01_AUTH_AGENCY5.Value,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20001.SAVE_ASRM2040");
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
        /// 품목정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2050(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD", "MAIN_CATEGORY",
                                 "PARTNM_EN1", "PARTNM1", "MAIN_DELINM_EN1", "MAIN_DELINM1", "MAIN_DELI_TIER1", "YEARLY_SALES1", "SALES_RATIO1", "FIRST_DELI_DATE1", "BLOB$PHOTO1",
                                 "PARTNM_EN2", "PARTNM2", "MAIN_DELINM_EN2", "MAIN_DELINM2", "MAIN_DELI_TIER2", "YEARLY_SALES2", "SALES_RATIO2", "FIRST_DELI_DATE2", "BLOB$PHOTO2",
                                 "PARTNM_EN3", "PARTNM3", "MAIN_DELINM_EN3", "MAIN_DELINM3", "MAIN_DELI_TIER3", "YEARLY_SALES3", "SALES_RATIO3", "FIRST_DELI_DATE3", "BLOB$PHOTO3",
                                 "USER_ID");

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode,
                            VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.cdx01_MAIN_CATEGORY.Value,
                            this.txt01_PARTNM_EN1.Value,
                            this.txt01_PARTNM1.Value,
                            this.txt01_MAIN_DELINM_EN1.Value,
                            this.txt01_MAIN_DELINM1.Value,
                            this.cbo01_MAIN_DELI_TIER1.Value,
                            this.txt01_YEARLY_SALES1.Value == null ? null : this.txt01_YEARLY_SALES1.Value.ToString().Replace(",", ""),
                            this.txt01_SALES_RATIO1.Value,
                            this.getDateString(this.df01_FIRST_DELI_DATE1),
                            (this.fuf01_PHOTO1.FileBytes.Length == 0 ? null : Util.ImageCollapse(this.fuf01_PHOTO1.FileBytes)),
                            this.txt01_PARTNM_EN2.Value,
                            this.txt01_PARTNM2.Value,
                            this.txt01_MAIN_DELINM_EN2.Value,
                            this.txt01_MAIN_DELINM2.Value,
                            this.cbo01_MAIN_DELI_TIER2.Value,
                            this.txt01_YEARLY_SALES2.Value == null ? null : this.txt01_YEARLY_SALES2.Value.ToString().Replace(",", ""),
                            this.txt01_SALES_RATIO2.Value,
                            this.getDateString(this.df01_FIRST_DELI_DATE2),
                            (this.fuf01_PHOTO2.FileBytes.Length == 0 ? null : Util.ImageCollapse(this.fuf01_PHOTO2.FileBytes)),
                            this.txt01_PARTNM_EN3.Value,
                            this.txt01_PARTNM3.Value,
                            this.txt01_MAIN_DELINM_EN3.Value,
                            this.txt01_MAIN_DELINM3.Value,
                            this.cbo01_MAIN_DELI_TIER3.Value,
                            this.txt01_YEARLY_SALES3.Value == null ? null : this.txt01_YEARLY_SALES3.Value.ToString().Replace(",", ""),
                            this.txt01_SALES_RATIO3.Value,
                            this.getDateString(this.df01_FIRST_DELI_DATE3),
                            (this.fuf01_PHOTO3.FileBytes.Length == 0 ? null : Util.ImageCollapse(this.fuf01_PHOTO3.FileBytes)),
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20001.SAVE_ASRM2050");
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
        /// 주주현황 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2060(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD",
                                 "SHAREHOLDER_EN1", "SHAREHOLDER1", "SHARE_RATE1",
                                 "SHAREHOLDER_EN2", "SHAREHOLDER2", "SHARE_RATE2",
                                 "SHAREHOLDER_EN3", "SHAREHOLDER3", "SHARE_RATE3",
                                 "SHAREHOLDER_EN4", "SHAREHOLDER4", "SHARE_RATE4",
                                 "USER_ID");

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.txt01_SHAREHOLDER_EN1.Value, this.txt01_SHAREHOLDER1.Value, this.txt01_SHARE_RATE1.Value,
                            this.txt01_SHAREHOLDER_EN2.Value, this.txt01_SHAREHOLDER2.Value, this.txt01_SHARE_RATE2.Value,
                            this.txt01_SHAREHOLDER_EN3.Value, this.txt01_SHAREHOLDER3.Value, this.txt01_SHARE_RATE3.Value,
                            this.txt01_SHAREHOLDER_EN4.Value, this.txt01_SHAREHOLDER4.Value, this.txt01_SHARE_RATE4.Value,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20001.SAVE_ASRM2060");
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
        /// 관계사현황(계열사) 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2070(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD",
                                 "AFFILIATE_EN1", "AFFILIATE1",
                                 "AFFILIATE_EN2", "AFFILIATE2",
                                 "AFFILIATE_EN3", "AFFILIATE3",
                                 "USER_ID");

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.txt01_AFFILIATE_EN1.Value, this.txt01_AFFILIATE1.Value,
                            this.txt01_AFFILIATE_EN2.Value, this.txt01_AFFILIATE2.Value,
                            this.txt01_AFFILIATE_EN3.Value, this.txt01_AFFILIATE3.Value,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20001.SAVE_ASRM2070");
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
        /// 업체 해외진출 현황 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2080(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD",
                                 "US_CNT", "US_REMARK",
                                 "CHINA_CNT", "CHINA_REMARK",
                                 "EU_CNT", "EU_REMARK",
                                 "INDIA_CNT", "INDIA_REMARK",
                                 "ETC_CNT", "ETC_REMARK",
                                 "USER_ID");

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.txt01_US_CNT.Value, this.txt01_US_REMARK.Value,
                            this.txt01_CHINA_CNT.Value, this.txt01_CHINA_REMARK.Value,
                            this.txt01_EU_CNT.Value, this.txt01_EU_REMARK.Value,
                            this.txt01_INDIA_CNT.Value, this.txt01_INDIA_REMARK.Value,
                            this.txt01_ETC_CNT.Value, this.txt01_ETC_REMARK.Value,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20001.SAVE_ASRM2080");
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
        ///  SQ인증 정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2110(ArrayList ds, ArrayList proc)
        {
            try
            {
                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD",
                                 "BIZ_CODE1", "SQ_CATEGORY1", "SQ_GRADE1", "SQ_POINT1", "CERT_DATE1", "VALID_DATE1", "MAIN_CHARGE1", "SQ_MAIN1",
                                 "BIZ_CODE2", "SQ_CATEGORY2", "SQ_GRADE2", "SQ_POINT2", "CERT_DATE2", "VALID_DATE2", "MAIN_CHARGE2", "SQ_MAIN2",
                                 "BIZ_CODE3", "SQ_CATEGORY3", "SQ_GRADE3", "SQ_POINT3", "CERT_DATE3", "VALID_DATE3", "MAIN_CHARGE3", "SQ_MAIN3", 
                                 "USER_ID");

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.txt01_BIZCD1.Value, this.cdx01_SQ_CATEGORY1.Value, this.cbo01_SQ_GRADE1.Value, this.txt01_SQ_POINT1.Value, this.getDateString(this.df01_CERT_DATE1), this.getDateString(this.df01_VALID_DATE1), this.txt01_MAIN_CHARGE1.Value, this.chk01_SQ_MAIN1.Value.ToString() == "true" ? "Y" : "N",
                            this.txt01_BIZCD2.Value, this.cdx01_SQ_CATEGORY2.Value, this.cbo01_SQ_GRADE2.Value, this.txt01_SQ_POINT2.Value, this.getDateString(this.df01_CERT_DATE2), this.getDateString(this.df01_VALID_DATE2), this.txt01_MAIN_CHARGE2.Value, this.chk01_SQ_MAIN2.Value.ToString() == "true" ? "Y" : "N",
                            this.txt01_BIZCD3.Value, this.cdx01_SQ_CATEGORY3.Value, this.cbo01_SQ_GRADE3.Value, this.txt01_SQ_POINT3.Value, this.getDateString(this.df01_CERT_DATE3), this.getDateString(this.df01_VALID_DATE3), this.txt01_MAIN_CHARGE3.Value, this.chk01_SQ_MAIN3.Value.ToString() == "true" ? "Y" : "N",
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20001.SAVE_ASRM2110_2");
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
        /// 기타 정보 저장
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="proc"></param>
        public void Save_ASRM2120(ArrayList ds, ArrayList proc)
        {
            try
            {

                // 1. 기존의 oldFileID 를 받아온다
                string oldFileID1 = hid01_FILEID1.Value.ToString();
                string oldFileID2 = hid01_FILEID2.Value.ToString();


                // 2. 파일서버에 파일 저장후 결과값 반환
                //    DB 에 저장할 fileID 값을 생성한다  ( newFileID 또는 oldFileID 값이 선택적으로 반환됨)
                //
                //    동작조건1: 파일 등록/신규등록 : oldFileID 값은 비어있을것이며, FileUpload 는 newFileID 값읍 반환한다.
                //    동작조건2: 파일 등록/수정등록 : oldFileID 값은 넘어갈것이며, FileUpload 는 newFileID 값을 반환하고, oldFileID 값의 파일은 내부적으로 삭제처리한다.
                //    동작조건3: 파일 미등록/기존파일없음 : oldFileID 값은 비어있을것이며, FileUpload 는 비어있는값을 반환한다.
                //    동작조건4: 파일 미등록/기존파일있음 : oldFileID 값은 넘어갈것이며, FileUpload 는 oldFileID 값을 반환한다.
                //
                string newFileID1 = EPRemoteFileHandler.FileUpload(this.fud01_FILEID1, this.GetMenuID(), oldFileID1);
                string newFileID2 = EPRemoteFileHandler.FileUpload(this.fud01_FILEID2, this.GetMenuID(), oldFileID2);



                DataSet param = Util.GetDataSourceSchema(
                                 "CORCD", "VENDCD",
                                 "AREA", "BUILDING", "UNIT",
                                 "SCALE", "STOCK_YN", "CAPACITY_RATE",
                                 "CREDIT_EVAL_FILE", "SQ_CERTI_FILE",
                                 "USER_ID");

                param.Tables[0].Rows.Add
                        (
                            this.UserInfo.CorporationCode, VEND_DIV.Text.Equals("false") ? this.cdx01_VENDCD.Value : this.cdx03_VENDCD.Value,
                            this.txt01_AREA.Value == null ? null : this.txt01_AREA.Value.ToString().Replace(",", ""),
                            this.txt01_BUILDING.Value == null ? null : this.txt01_BUILDING.Value.ToString().Replace(",", ""),
                            this.cbo01_UNIT.Value,
                            this.cbo01_SCALE.Value,
                            this.cbo01_STOCK_YN.Value,
                            this.txt01_CAPACITY_RATE.Value,
                            newFileID1,
                            newFileID2,
                            this.UserInfo.UserID
                        );

                ds.Add(param);
                proc.Add("APG_SRM_VM20001.SAVE_ASRM2120");
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

        #endregion

        #region [ 유효성 검사 ]


        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsSaveValid()
        {
            if (VEND_DIV.Text.Equals("false"))
            {
                //업체코드 필수입력
                if (this.cdx01_VENDCD.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", this.lbl01_VEND.Text); //{0}를(을) 입력해주세요.
                    return false;
                }
            }
            else
            {
                //업체코드 필수입력
                if (this.cdx03_VENDCD.IsEmpty)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx03_VENDCD", this.lbl01_VEND.Text); //{0}를(을) 입력해주세요.
                    return false;
                }
            }

            //사업자번호 체크
            if (this.txt01_RESI_NO.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_RESI_NO", this.lbl01_CMPNO.Text); //{0}를(을) 입력해주세요.
                return false;
            }
            if (this.txt01_RESI_NO.Text.Length != 10)
            {
                this.MsgCodeAlert_ShowFormat("SRMVM-0013"); //사업자번호는 10자리 숫자만 입력해주세요.
                return false;
            }

            //하도급업체여부가 yes인 경우 하도금 임직원 1명 이상 반드시 입력하여야 함.
            if (!this.cbo01_SUBCONTR_YN.IsEmpty)
            {
                if (this.cbo01_SUBCONTR_YN.Value.ToString().Equals("VB4"))
                {
                    if (this.txt01_SUBCONTRACT.IsEmpty || Convert.ToInt32(this.txt01_SUBCONTRACT.Value) <= 0)
                    {
                        this.MsgCodeAlert("SRMVM-0005", "txt01_SUBCONTRACT"); //하도급업체인 경우 하도급 직원수를 입력하여야 합니다.
                        return false;
                    }
                }
            }

            //노조구분값이 있는 경우 인원은 반드시 입력해야함.
            if (!this.cbo01_LABOR1.IsEmpty && this.txt01_LABOR_CNT1.IsEmpty)
            {
                if (!this.cbo01_LABOR1.Value.ToString().Equals("VB10"))
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_LABOR_CNT1", this.lbl01_EMPCNT.Text); //{0}를(을) 입력해주세요.
                    return false;
                }
            }
            if (!this.cbo01_LABOR2.IsEmpty && this.txt01_LABOR_CNT2.IsEmpty)
            {
                if (!this.cbo01_LABOR2.Value.ToString().Equals("VB10"))
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_LABOR_CNT2", this.lbl01_EMPCNT.Text); //{0}를(을) 입력해주세요.
                    return false;
                }
            }
            if (!this.cbo01_LABOR3.IsEmpty && this.txt01_LABOR_CNT3.IsEmpty)
            {
                if (!this.cbo01_LABOR3.Value.ToString().Equals("VB10"))
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_LABOR_CNT3", this.lbl01_EMPCNT.Text); //{0}를(을) 입력해주세요.
                    return false;
                }
            }


            //사진 확장자 체크
            if (fuf01_PHOTO1.HasFile)
            {
                if (!Util.IsValidImage(fuf01_PHOTO1.PostedFile.FileName))
                {
                    this.MsgCodeAlert("SRMVM-0004");    //이미지 파일만 업로드해주세요.
                    return false;
                }
            }
            if (fuf01_PHOTO2.HasFile)
            {
                if (!Util.IsValidImage(fuf01_PHOTO2.PostedFile.FileName))
                {
                    this.MsgCodeAlert("SRMVM-0004");    //이미지 파일만 업로드해주세요.
                    return false;
                }
            }
            if (fuf01_PHOTO3.HasFile)
            {
                if (!Util.IsValidImage(fuf01_PHOTO3.PostedFile.FileName))
                {
                    this.MsgCodeAlert("SRMVM-0004"); //이미지 파일만 업로드해주세요.
                    return false;
                }
            }


            //파일확장자체크           
            if (fud01_FILEID1.HasFile)
            {
                if (!Util.IsValidPdf(fud01_FILEID1.PostedFile.FileName) && !Util.IsValidZip(fud01_FILEID1.PostedFile.FileName))
                {
                    this.MsgCodeAlert("SRMVM-0001"); //PDF, ZIP 파일만 업로드 가능합니다.
                    return false;
                }

            }
            if (fud01_FILEID2.HasFile)
            {
                if (!Util.IsValidPdf(fud01_FILEID2.PostedFile.FileName) && !Util.IsValidZip(fud01_FILEID2.PostedFile.FileName))
                {
                    this.MsgCodeAlert("SRMVM-0001"); //PDF, ZIP 파일만 업로드 가능합니다.
                    return false;
                }
            }

            if (!(this.cbo01_SQ_GRADE1.IsEmpty || this.cbo01_SQ_GRADE2.IsEmpty || this.cbo01_SQ_GRADE3.IsEmpty))
            {
                if (!fud01_FILEID2.HasFile && hid01_FILEID2.IsEmpty)
                {
                    this.MsgCodeAlert("SRMVM-0006"); //SQ인증서 사본을 반드시 업로드하여 주세요.
                    return false;
                }
            }
            return true;
        }


        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {

            if (VEND_DIV.Text.Equals("true"))
            {
                // 조회용 Validation
                if (this.cdx03_VENDCD.IsEmpty && this.cdx03_VENDCD.isValid)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx03_VENDCD", lbl01_VEND.Text);
                    return false;
                }
            }
            else
            {
                // 조회용 Validation
                if (this.cdx01_VENDCD.IsEmpty && this.cdx01_VENDCD.isValid)
                {
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                    return false;
                }
            }

            return true;
        }

        #endregion

        #region [ 이벤트 ]


        [DirectMethod]
        public void txt01_STD_YEAR_Change()
        {

            this.Get_ASRM2090();
            //DataSet source = this.Get_SRM2090();


            //this.Store_Grid03.RemoveAll();
            //this.Store_Grid03.DataSource = source.Tables[1];
            //this.Store_Grid03.DataBind();

            //for (int i = source.Tables[1].Rows.Count; i < 4; i++)
            //{
            //    Store_Grid03.Add(i);
            //}

            //this.txt02_STD_YEAR.SetValue(this.txt01_STD_YEAR.Value);

        }

        [DirectMethod]
        public void txt02_STD_YEAR_Change()
        {

            this.YEAR_PURCAMT.Text = string.Format(Library.getLabel("SRM_VM20001", "YEAR_PURCAMT"), this.txt02_STD_YEAR.Value.ToString());

            this.Get_ASRM2100();

        }
        [DirectMethod]
        public void txt03_STD_YEAR_Change()
        {
            if (!IsQueryValidation())
            {
                return;
            }
            this.Get_ASRM2160();


        }

        #endregion
    }
}
