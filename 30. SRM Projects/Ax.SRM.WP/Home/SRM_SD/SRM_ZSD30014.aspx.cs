#region ▶ Description & History
/* 
 * 프로그램명 : 서열부품 상세 (구.VC3020)
 * 설      명 : 
 * 최초작성자 : 오세민
 * 최초작성일 : 2014-08-28
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
using System.ServiceModel;

namespace Ax.SRM.WP.Home.SRM_SD
{
    public partial class SRM_ZSD30014 : BasePage
    {
        private string pakageName = "ZPG_SRM_ZSD30014";


        #region [ 초기설정 ]

        /// <summary>
        /// SCM_PM3004
        /// </summary>
        public SRM_ZSD30014()
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
                    // Ajax Timeout 설정
                    this.ResourceManager1.AjaxTimeout = Util.GetSendTimeOut(Server.MapPath("/"));

                    Library.GetBIZCD(this.SelectBox01_BIZCD, this.UserInfo.CorporationCode, false);

                    //차종콤보
                    this.SetComboBindVincd(this.UserInfo.BusinessCode);
                    //품목콤보
                    this.SetComboBindItem(this.UserInfo.BusinessCode, "");

                    //작업지시구분
                    //this.SetComboBindWorkDirDiv(this.UserInfo.BusinessCode, DateTime.Now.ToString("yyyy-MM-dd"));

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

        #endregion

        #region [ 기능 ]
        [DirectMethod]
        public void SetComboBindWorkDirDiv(string bizcd, object plandate)
        {
            //작업지시구분
            HEParameterSet param4 = new HEParameterSet();
            param4.Add("CORCD", this.UserInfo.CorporationCode);
            param4.Add("BIZCD", bizcd);
            param4.Add("PLAN_DATE", DateTime.Parse(plandate.ToString()).ToString("yyyy-MM-dd"));
            param4.Add("LANG_SET", this.UserInfo.LanguageShort);
            param4.Add("USER_ID", this.UserInfo.UserID);
            //Library.ComboDataBind(this.sbox_WORK_DIR_DIV, EPClientHelper.ExecuteDataSet("PKG_SRM_ZSD30014.INQUERY_WORK_DIR_DIV", param4).Tables[0], true, "TYPENM", "OBJECT_ID", true);

        }

        [DirectMethod]
        public void SetComboBindVincd(string bizcd)
        {
            // 차종
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", this.UserInfo.CorporationCode);
            param.Add("BIZCD", bizcd);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            Library.ComboDataBind(this.sbox01_VINCD, EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_VINCD"), param).Tables[0], true, "VINNM", "MODELCD", true);

        }
        [DirectMethod]
        public void SetComboBindItem(string bizcd, string vincd)
        {
            //고객품목 콤보상자 셋팅하기
            //차종콤보에 value값은 [차종코드+ "-" + 모델코드]로 구성되어 있음.
            HEParameterSet param2 = new HEParameterSet();
            param2.Add("CORCD", this.UserInfo.CorporationCode);
            param2.Add("BIZCD", bizcd);
            if (vincd.Equals(string.Empty))
                param2.Add("MODELCD", "");
            else
            {
                param2.Add("MODELCD", vincd.Substring(vincd.IndexOf("-") + 1));
            }
            param2.Add("LANG_SET", this.UserInfo.LanguageShort);
            param2.Add("USER_ID", this.UserInfo.UserID);
            Library.ComboDataBind(this.sbox_ITEM, EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CUST_ITEM"), param2).Tables[0], true, "CUST_ITEMNM", "CUST_ITEMCD", true);
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
            this.SelectBox01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.SelectBox01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_BEG_DATE.SetValue(DateTime.Now);

            if (this.sbox01_VINCD.Items.Count > 0)
            {
                this.sbox01_VINCD.SelectedItem.Index = 0;
                this.sbox01_VINCD.UpdateSelectedItems(); //꼭 해줘야한다.
            }

            //if (this.sbox_WORK_DIR_DIV.Items.Count > 0)
            //{
            //    this.sbox_WORK_DIR_DIV.SelectedItem.Index = 0;
            //    this.sbox_WORK_DIR_DIV.UpdateSelectedItems(); //꼭 해줘야한다.
            //}
            if (this.sbox_ITEM.Items.Count > 0)
            {
                this.sbox_ITEM.SelectedItem.Index = 0;
                this.sbox_ITEM.UpdateSelectedItems(); //꼭 해줘야한다.
            }
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
            param.Add("BIZCD", SelectBox01_BIZCD.Value);
            if (this.sbox01_VINCD.Value.ToString().Equals(string.Empty))
                param.Add("VINCD", "");
            else
            {
                string vincd = this.sbox01_VINCD.Value.ToString().Substring(0, this.sbox01_VINCD.Value.ToString().LastIndexOf("-"));
                param.Add("VINCD", vincd);
            }

            param.Add("PLAN_DATE", ((DateTime)this.df01_BEG_DATE.Value).ToString("yyyy-MM-dd"));
            //param.Add("PLAN_DATE", this.GetDateText(this.df01_BEG_DATE, "yyyy-MM-dd"));

            param.Add("PLAN_DIV", "");
            param.Add("VEND_ITEM_TYPECD", this.sbox_ITEM.Value);
            param.Add("WORK_DIR_DIV", "");//this.sbox_WORK_DIR_DIV.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);
            //Util.Alert(this.sbox_WORK_DIR_DIV.Value.ToString());
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
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);
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

            //if (this.df01_BEG_DATE.IsEmpty)
            if (this.GetDateText(this.df01_BEG_DATE) == string.Empty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_BEG_DATE", lbl01_WORK_DATE3.Text);
                return false;
            }


            return true;
        }

        #endregion
    }
}
