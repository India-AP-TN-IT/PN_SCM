#region ▶ Description & History
/* 
 * 프로그램명 : 거래처 ASN 처리 정보 등록
 * 설      명 : 자재관리 > 서열투입현황 > 거래처 ASN 처리 정보 등록
 * 최초작성자 : 이재우
 * 최초작성일 : 2017-09-26
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
using System.Threading;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM35010 : BasePage
    {
        private string pakageName = "SIS.APG_SRM_MM35010";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM35010
        /// </summary>
        public SRM_MM35010()
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
            //MakeButton(ButtonID.Print, ButtonImage.Print, "납품전표출력", this.ButtonPanel);
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            //MakeButton(ButtonID.Regist, ButtonImage.New, "New", this.ButtonPanel);
            //MakeButton(ButtonID.Modify, ButtonImage.Modify, "Modify", this.ButtonPanel);
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
                new Ext.Net.Parameter { Name = "Grid01DirtyValues", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
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
                //case ButtonID.Print:
                //    PrintCheck(sender, e);
                //    break;
                case ButtonID.Search:
                    Search();
                    break;
                case ButtonID.Reset:
                    Reset();
                    break;
                //case ButtonID.Regist:
                //    SetButton("ButtonRegist");
                //    break;
                //case ButtonID.Modify:
                //    SetButton("ButtonModify");
                //    break;
                case ButtonID.Save:
                    SaveConfirm(sender, e);
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
        public void etc_Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn02_VENDCD":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    Util.HelpPopup(this, "HELP_VENDCD", PopupHelper.HelpType.Search, "GRID_VENDCD_HELP01", this.CodeValue.Text, this.NameValue.Text, "");
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
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            if (this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
                this.cdx01_VENDCD.ReadOnly = false;
            }
            else
            {
                this.cdx01_VENDCD.SetValue(this.UserInfo.VenderCD);
                this.cdx01_VENDCD.ReadOnly = true;
            }

            this.cbo01_ASN_YN.SelectedItem.Index = 0;
            this.cbo01_ASN_YN.SelectedItem.Value = "";
            this.cbo01_ASN_YN.UpdateSelectedItems(); //꼭 해줘야한다.

            this.Store1.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            //param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("ASN_YN", this.cbo01_ASN_YN.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            string procedure = "INQUERY";

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);
        }

        /// <summary>
        /// 저장여부 묻기
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void SaveConfirm(object sender, DirectEventArgs e)
        {
            try
            {
                // 서연이화 사용자만 저장가능함
                if (!(this.UserInfo.UserDivision.Equals("T10") || this.UserInfo.UserDivision.Equals("T12")))
                {
                    //저장할 권한이 없습니다.
                    this.MsgCodeAlert("CD00-0064");
                    return;
                }

                string json = e.ExtraParams["Grid01DirtyValues"];

                //저장하시겠습니까?
                string[] msg = Library.getMessageWithTitle("COM-00909");

                Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
                {
                    Yes = new MessageBoxButtonConfig
                    {
                        Handler = "App.direct.Save('" + json.Replace("'", "\\'") + "')",
                        Text = "YES"
                    },
                    No = new MessageBoxButtonConfig
                    {
                        Text = "NO"
                    }
                }).Show();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {

            }
        }

        [DirectMethod]
        public void Save(string json)
        {
            try
            {
                Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

                DataSet param = Util.GetDataSourceSchema
                    (
                        "BIZCD", "VENDCD", "ASN_YN", "USER_ID"
                    );

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (parameters[i]["VENDCD"] == null || parameters[i]["VENDCD"] == string.Empty)
                    {
                        continue;
                    }
                    param.Tables[0].Rows.Add
                    (
                        this.cbo01_BIZCD.Value
                        , parameters[i]["VENDCD"].ToString()
                        , parameters[i]["ASN_YN"].ToString()=="true"?"Y":"N"
                        , this.UserInfo.UserID
                    );
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), param);
                }

                //저장되었습니다.
                this.MsgCodeAlert("COM-00001");

                this.Search();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
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
        
        #endregion

        #region [ 유효성 검사 ]
        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsQueryValidation()
        {            
            // 조회용 Validation
            if (this.cdx01_VENDCD.IsEmpty && !(this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10")))
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            // 서연이화 사용자만 조회가능함
            if (!(this.UserInfo.UserDivision.Equals("T10") || this.UserInfo.UserDivision.Equals("T12")))
            {
                //조회 권한이 없습니다.
                this.MsgCodeAlert("CD00-0027");
                return false;
            }

            return true;
        }

        #endregion

        #region [ 헬프,콤보상자 관련 처리 ]

        //검색조건을 바꾸면 자동으로 차수 콤보 세팅 및 그리드 초기화
        public void changeCondition(object sender, DirectEventArgs e)
        {
            this.initGrid();
        }

        private void initGrid()
        {
            this.Store1.RemoveAll();
        }

        #endregion

    }
}
