#region ▶ Description & History
/* 
 * 프로그램명 : 견적 정보 조회    [D2](구.VG3030)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-09-17
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

namespace Ax.SRM.WP.Home.SRM_ALC
{

    public partial class SRM_ALC30004 : BasePage
    {
        private string pakageName = "APG_SRM_ALC30004";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_ALC30004
        /// </summary>
        public SRM_ALC30004()
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
                    this.SetCombo(); //콤보상자 바인딩//임시저장
                    this.SetCombo("1");
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

        //공장 정보 변경 시
        [DirectMethod]
        public void SetPlantComboChange()
        {
            string PLANT_GB = this.cbo01_PLANT_GB.Value.ToString();
            this.SetCombo(PLANT_GB);

            if (!this.cdx01_VENDCD.Value.Equals(string.Empty))
            {
                Search();
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
                
                DataSet ds = ItemChasu();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    this.txt01_FIELD_NM1.Text = ds.Tables[0].Rows[0]["FIELD_NM1"].ToString();
                    this.txt01_FIELD_NM2.Text = ds.Tables[0].Rows[0]["FIELD_NM2"].ToString();

                    string ITEM1 = this.txt01_FIELD_NM1.Text == "" ? "ITEM" : this.txt01_FIELD_NM1.Text;
                    string ITEM2 = this.txt01_FIELD_NM2.Text == "" ? "ITEM" : this.txt01_FIELD_NM2.Text;

                    FIELD_NM1.Text = ITEM1;
                    FIELD_NM2.Text = ITEM2;

                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        DataSet result = null;
                        result = getDataSet();
                        this.Store1.RemoveAll();
                        this.Store1.DataSource = result.Tables[0];
                        this.Store1.DataBind();
                    }
                }
                else
                {
                    Store1.RemoveAll();
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

        private DataSet ItemChasu()
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", Util.UserInfo.CorporationCode);
            set.Add("BIZCD", Util.UserInfo.BusinessCode);
            set.Add("VEND_CD", this.cdx01_VENDCD.Value);
            set.Add("PLANT_GB", this.cbo01_PLANT_GB.Value);
            set.Add("LINE_GB", this.cbo01_LINE_GB.Value);
            set.Add("USER_ID", Util.UserInfo.UserID);
            set.Add("LANG_SET", Util.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_ITEMCHASU"), set);
        }

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }
            this.df01_QUT_DATE.SetValue(DateTime.Now);
            this.cbo01_PLANT_GB.SelectedItem.Value = "7";
            this.cbo01_PLANT_GB.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_LINE_GB.SelectedItem.Value = "1";
            this.cbo01_LINE_GB.UpdateSelectedItems(); //꼭 해줘야한다.
            this.txt01_SEQ.SetValue("1");

            this.FIELD_NM1.Text = "ITEM";
            this.FIELD_NM2.Text = "ITEM";

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
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("YMD", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));
            param.Add("PLANT_GB", this.cbo01_PLANT_GB.Value);
            param.Add("LINE_GB", this.cbo01_LINE_GB.Value);
            param.Add("SEQ", this.txt01_SEQ.Text);
            param.Add("FIELD_NM1", this.txt01_FIELD_NM1.Text);
            param.Add("FIELD_NM2", txt01_FIELD_NM2.Text);            
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
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
                    result.Tables[0].Columns.Remove("TSEQ");
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

        /// <summary>
        /// 콤보상자 바인딩(발생구분)
        /// </summary>
        private void SetCombo()
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", this.UserInfo.CorporationCode);
            set.Add("BIZCD", this.UserInfo.BusinessCode);
            set.Add("PLANT_GB", "-999");
            set.Add("LANG_SET", this.UserInfo.LanguageShort);
            set.Add("USER_ID", this.UserInfo.UserID);
            //발생구분 콤보상자 바인딩
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PLANT"), set);
            Library.ComboDataBind(this.cbo01_PLANT_GB, source.Tables[0], false, "PLANT_GBNM", "PLANT_GB", true);
        }

        /// <summary>
        /// 콤보상자 바인딩(발생구분)
        /// </summary>
        private void SetCombo(string cnt = "1")
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", this.UserInfo.CorporationCode);
            set.Add("BIZCD", this.UserInfo.BusinessCode);
            set.Add("PLANT_GB", cnt);
            set.Add("LANG_SET", this.UserInfo.LanguageShort);
            set.Add("USER_ID", this.UserInfo.UserID);

            //LINE 콤보상자 바인딩
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_LINE"), set);
            Library.ComboDataBind(this.cbo01_LINE_GB, source.Tables[0], false, "LINE_GBNM", "LINE_GB", true);

            this.cbo01_LINE_GB.SelectedItem.Value = "1";
            this.cbo01_LINE_GB.UpdateSelectedItems(); //꼭 해줘야한다.
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

            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMMP00-0024", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            else if (this.df01_QUT_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMMP00-0023", "df01_QUT_DATE", lbl01_DD.Text);
                return false;
            }

            return true;
        }

        #endregion
    }
}
