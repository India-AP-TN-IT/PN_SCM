#region ▶ Description & History
/* 
 * 프로그램명 : MS/ES스펙 조회 (신규)
 * 설      명 : 
 * 최초작성자 : 배명희
 * 최초작성일 : 2015-05-28
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
 *				2015-06-01      배명희     사용자 구분이 서연이화, 어드민인 경우 모든 데이터 조회(대상데이터는 CD4710)
 *				                           사용자 구분이 그 외 - 권한있는 스펙만 조회되며 (권한은 cd4720테이블 참조), 
 *				                                                 열람사유를 등록한 경우에만(관련테이블 QA7010) PDF파일 열람 가능(워터마크 처리)
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
using System.ServiceModel;

namespace Ax.SRM.WP.Home.SRM_QA
{
    public partial class SRM_QA34010 : BasePage
    {
        private string pakageName = "APG_SRM_QA34010";
        

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_QA34010
        /// </summary>
        public SRM_QA34010()
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
            MakeButton(ButtonID.Search,  ButtonImage.Search,  "Search",     this.ButtonPanel);
            MakeButton(ButtonID.Reset,   ButtonImage.Reset,   "Reset",      this.ButtonPanel);
            MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
            MakeButton(ButtonID.Close,   ButtonImage.Close,   "Close",      this.ButtonPanel);
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
                case "btn01_POP_QA34010P1":
                    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
                    HEParameterSet set = new HEParameterSet();
                    
                    set.Add("FILEID", FILEID.Value);
                    set.Add("DOCNO", DOCNO.Value);

                    Util.UserPopup((BasePage)this.Form.Parent.Page, this.UserHelpURL.Text, set, "HELP_QA34010P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
                    break;

                default:
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
           
            //유형코드
            DataSet source = Library.GetTypeCode("ML");
            Library.ComboDataBind(this.cbo01_LANG_DIV, source.Tables[0].DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "All");        //언어구분

            this.txt01_SPEC_NO.SetValue(string.Empty);
            this.txt01_SUBJECT.SetValue(string.Empty);
        
            Store1.RemoveAll();
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);            
            param.Add("SPEC_NO", txt01_SPEC_NO.Value);
            param.Add("LANG_DIV", this.cbo01_LANG_DIV.Value);
            param.Add("SUBJECT", txt01_SUBJECT.Value);
            param.Add("LAST_2MONTH", this.chk01_LAST_2MONTH.Checked);
            param.Add("USERID", Util.UserInfo.UserID);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            

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
                    result.Tables[0].Columns.Remove("FILENAME");
                    result.Tables[0].Columns.Remove("PATH");
                    result.Tables[0].Columns.Remove("FILEID");
                    result.Tables[0].Columns.Remove("DOCNO");
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
            
            return true;
        }

        #endregion
    }
}
