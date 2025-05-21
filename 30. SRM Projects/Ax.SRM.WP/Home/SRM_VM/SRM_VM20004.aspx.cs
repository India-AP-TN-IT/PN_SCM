#region ▶ Description & History
/* 
 * 프로그램명 : 업체 기본현황 작성
 * 설      명 : Home > 협력업체관리 > 업체정보관리 > 업체 비상연락망 등록
 * 최초작성자 : 배명희
 * 최초작성일 : 2015-02-25
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
using System.Text;

namespace Ax.EP.WP.Home.SRM_VM
{
    public partial class SRM_VM20004 : BasePage
    {
        private string pakageName = "APG_SRM_VM20004";
        //private string noimage = "../../images/common/no_image.gif";
        
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_VM20004
        /// </summary>
        public SRM_VM20004()
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
                    

                  
                    this.Reset(true);

                    // 코드 팝업을 띄우기 위해서 text에서 enter를 입력할 경우 팝업을 띄움, 현재는 aspx단에서 keymap으로 코딩되어있음.
                    //Util.SettingEnterKeyEvent(this, this.cdx01_PARTNO, this.btn01_PARTNO);

                    //this.Search();
                   
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
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "GridPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Loading Data...";
            }
            else if (ibtn.ID.Equals(ButtonID.Save))
            {
                ibtn.DirectEvents.Click.ExtraParams.Add(
               new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly:true})", Mode = ParameterMode.Raw, Encode = true });
           

                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.Page;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "GridPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Checking And Saving Data...";
            }

            else if (ibtn.ID.Equals(ButtonID.Reset))
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.Page;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "GridPanel";
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
                    Print();                    
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
            
        }


        #region [리포트 출력 관련]

        //private void PrintConfirm()
        //{
        //    if (!this.IsQueryValidation()) return;

        //    X.Msg.Show(new MessageBoxConfig
        //    {
        //        Title = "Confirm",
        //        Message = Library.getMessage("SRMVM-0011"),
        //        Buttons = MessageBox.Button.YESNOCANCEL,
        //        Icon = MessageBox.Icon.QUESTION,
        //        Fn = new JFunction { Fn = "PrintReport" },               
        //        AnimEl = "ButtonPrint"
        //    });
        //}
        /// <summary>
        /// Print
        /// </summary>
        [DirectMethod]
        public void Print()
        {
            if (!this.IsQueryValidation()) return;

            HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
            report.ReportName = "1000/SRM_VM/SRM_VM20003";

            // Main Section ( 메인리포트 파라메터셋 )
            HERexSection mainSection = new HERexSection();
            mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
          
            report.Sections.Add("MAIN", mainSection);

            // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
            DataSet ds = this.getDataSet();

            if (ds.Tables[0].Rows.Count <= 0)
            {
                this.MsgCodeAlert_ShowFormat("COM-00022");
                return;
            }


            //// DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
            //// 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
            //ds.Tables[0].TableName = "DATA";
            //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);

            HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());


            // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
            // xmlSection.ReportParameter.Add("CORCD", "1000");
            report.Sections.Add("XML", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정

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
        public void cdx01_UP_VEND_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            //UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
        
            cdx.UserParamSet.Add("OPTION", "1");
        }

        #endregion

        #region [ 기능 ]

        #region [ 초기화 관련 ]
        
        /// <summary>
        /// Reset
        /// </summary>
        public void Reset(bool isAllReset)
        {
            if (isAllReset)
            {
                //업체코드는 서연이화 사용자인 경우에만 초기화한다.
                if (this.UserInfo.UserDivision.Equals("T12"))
                    this.cdx01_VENDCD.SetValue(string.Empty);
            }


            this.ClearInput();

        }



        /// <summary>
        /// SetPartnerControlAuthority
        /// </summary>
        /// <param name="controls"></param>
        private void ClearInput()
        {
            this.LABEL_ADDR.Text = string.Empty;
            this.LABEL_FAX.Text = string.Empty;
            this.LABEL_REP_NAME.Text = string.Empty;
            this.LABEL_TEL.Text = string.Empty;
            this.Store1.RemoveAll();
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
                    this.LABEL_REP_NAME.Text = dr["REP_NAME"].ToString();
                    this.LABEL_FAX.Text = dr["FAX"].ToString();
                    this.LABEL_TEL.Text = dr["TEL"].ToString();
                    this.LABEL_ADDR.Text = dr["ADDR"].ToString();
                    #endregion
                    
                }
                else
                {
                    this.ClearInput();
                }

                this.Store1.DataSource = source.Tables[0];
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
        /// 협력업체 정보 조회
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
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
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
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

                //업체코드 입력된 상태인지 체크
                if (!IsQueryValidation())
                {
                    return;
                }

                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                if (parameters.Length == 0)
                {
                    this.MsgCodeAlert("COM-00020"); //저장할 data가 없습니다.
                    return;
                }


                DataSet param = Util.GetDataSourceSchema
                (
                    "CORCD", "BIZCD", "VENDCD", "TEAM_DIVCD", "SEQNO", "TITLE_NM", "NAME",
                    "CHARGE_JOB", "TELNO", "CELLNO", "E_MAIL", "AS_CHK", "SP_CHK", "CKD_CHK", "REMARK", "LANG_SET", "USER_ID"
                );

                for (int i = 0; i < parameters.Length; i++)
                {
                    param.Tables[0].Rows.Add
                    (
                        this.UserInfo.CorporationCode
                        , this.UserInfo.BusinessCode
                        , this.cdx01_VENDCD.Value
                        , parameters[i]["TEAM_DIVCD"]
                        , parameters[i]["SEQNO"]
                        , parameters[i]["TITLE_NM"]
                        , parameters[i]["NAME"]
                        , parameters[i]["CHARGE_JOB"]
                        , parameters[i]["TELNO"]
                        , parameters[i]["CELLNO"]
                        , parameters[i]["E_MAIL"]
                        , parameters[i]["AS_CHK"] == "true" ? "Y" : "N"
                        , parameters[i]["SP_CHK"] == "true" ? "Y" : "N"
                        , parameters[i]["CKD_CHK"] == "true" ? "Y" : "N"
                        , parameters[i]["REMARK"]
                        , this.UserInfo.Language
                        , this.UserInfo.UserID
                    );

                    //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)                    
                    if (!IsSaveValid(param.Tables[0].Rows[param.Tables[0].Rows.Count - 1], Convert.ToInt32(parameters[i]["NO"])))
                    {
                        return;
                    }
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param);
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
        public bool IsSaveValid(DataRow parameter, int actionRow = -1)
        {
            //{0}번째 행에 {1}는 {2}bytes이상 입력할 수 없습니다.
            if (Encoding.UTF8.GetByteCount(parameter["TITLE_NM"].ToString()) > 20)
            {
                this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "TITLE_NM"), 20);
                return false;
            }
            if (Encoding.UTF8.GetByteCount(parameter["NAME"].ToString()) > 50)
            {
                this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "NAME"), 50);
                return false;
            }
            if (Encoding.UTF8.GetByteCount(parameter["CHARGE_JOB"].ToString()) > 50)
            {
                this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "CHARGE_JOB"), 50);
                return false;
            }
            if (Encoding.UTF8.GetByteCount(parameter["TELNO"].ToString()) > 20)
            {
                this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "TELNO"), 20);
                return false;
            }
            if (Encoding.UTF8.GetByteCount(parameter["CELLNO"].ToString()) > 20)
            {
                this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "CELLNO"), 20);
                return false;
            }
            if (Encoding.UTF8.GetByteCount(parameter["E_MAIL"].ToString()) > 50)
            {
                this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "E_MAIL"), 50);
                return false;
            }
            if (Encoding.UTF8.GetByteCount(parameter["REMARK"].ToString()) > 100)
            {
                this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "REMARK"), 100);
                return false;
            }
            return true;
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


            return true;
        }

        #endregion

        #region [ 이벤트 ]

        

        #endregion
    }
}
