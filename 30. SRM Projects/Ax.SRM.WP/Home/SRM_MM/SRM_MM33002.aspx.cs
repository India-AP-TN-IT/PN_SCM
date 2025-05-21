#region ▶ Description & History
/* 
 * 프로그램명 : 자재관리 월별 검수 실적
 * 설      명 : 
 * 최초작성자 : 이재우
 * 최초작성일 : 2017-10-27
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
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using System.Collections.Generic;

namespace Ax.SRM.WP.Home.SRM_MM
{

    public partial class SRM_MM33002 : BasePage
    {
        private string pakageName = "APG_SRM_MM33002";

        #region [ 초기설정 ]

        /// <summary>
        /// SCM_MP30010
        /// </summary>
        public SRM_MM33002()
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

                    //구매조직
                    DataTable source = Library.GetTypeCode("1A").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "ALL");
                    if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
                    {
                        this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                    }
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

                    //마감유형
                    source = Library.GetTypeCode("1M").Tables[0];
                    source.DefaultView.RowFilter = "TYPECD NOT IN ('D','E')"; //D:일반구매,E:기타
                    Library.ComboDataBind(this.cbo01_RCV_TYPE, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "ALL");

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

            if (id.Equals(ButtonID.ExcelDL)) //선택한 row를 가져온다.
            {

                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Grid01SelectedValues", Value = "App.Grid01.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw, Encode = true });
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Grid02SelectedValues", Value = "App.Grid02.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw, Encode = true });
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Grid03SelectedValues", Value = "App.Grid03.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw, Encode = true });
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Grid04SelectedValues", Value = "App.Grid04.getRowsValues({selectedOnly:true})", Mode = ParameterMode.Raw, Encode = true });
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
                case ButtonID.ExcelDL:
                    Excel_Export(sender, e);
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
                case "":
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

                switch (this.cbo01_RCV_TYPE.Value.ToString())
                {
                    case "1MA":
                        this.Grid02.Hidden = false;
                        this.Grid03.Hidden = true;
                        this.Grid04.Hidden = true;
                        break;
                    case "1MB":
                        this.Grid02.Hidden = true;
                        this.Grid03.Hidden = false;
                        this.Grid04.Hidden = true;
                        break;
                    case "1MC":
                        this.Grid02.Hidden = true;
                        this.Grid03.Hidden = true;
                        this.Grid04.Hidden = false;
                        break;
                    default :
                        this.Grid02.Hidden = false;
                        this.Grid03.Hidden = true;
                        this.Grid04.Hidden = true;
                        break;
                }

                this.Store7.RemoveAll();
                this.Store8.RemoveAll();
                this.Store9.RemoveAll();
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

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_FROM_DATE.SetValue(DateTime.Now.ToString("yyyy-MM-01"));
            this.df01_TO_DATE.SetValue(DateTime.Now.ToString("yyyy-MM-dd"));

            this.cbo01_PURC_ORG.SelectedItem.Value = "";
            this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

            this.cbo01_RCV_TYPE.SelectedItem.Value = "";
            this.cbo01_RCV_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

            this.Store1.RemoveAll();

            this.Store7.RemoveAll();
            this.Store8.RemoveAll();
            this.Store9.RemoveAll();

            this.Grid02.Hidden = false;
            this.Grid03.Hidden = true;
            this.Grid04.Hidden = true;
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
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("DATE_FROM", ((DateTime)this.df01_FROM_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("DATE_TO", ((DateTime)this.df01_TO_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.SelectedItem.Value);
            param.Add("RCV_TYPE", this.cbo01_RCV_TYPE.SelectedItem.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// getDataSetDetail
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSetDetail(string vendCd, string rcvMonth, string rcvType, string purcOrg, string vatCd, string rcvBizcd)
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("ACC_VENDCD", vendCd);
            param.Add("ACC_MONTH", rcvMonth);
            param.Add("ACC_RCV_TYPE", rcvType);
            param.Add("ACC_PURC_ORG", purcOrg);
            param.Add("ACC_VATCD", vatCd);
            param.Add("ACC_RCV_BIZCD", rcvBizcd);
            param.Add("VINCD", "A3" + txt01_VINCD.Value);
            param.Add("PARTNO", txt01_FPARTNO.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_" + rcvType), param);
        }

        /// <summary>
        /// Excel_Export
        /// </summary>
        private void Excel_Export(object sender, DirectEventArgs e)
        {
            try
            {
                Dictionary<string, string>[] grid01SelectedValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid01SelectedValues"]);
                Dictionary<string, string>[] grid02SelectedValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid02SelectedValues"]);
                Dictionary<string, string>[] grid03SelectedValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid03SelectedValues"]);
                Dictionary<string, string>[] grid04SelectedValues = JSON.Deserialize<Dictionary<string, string>[]>(e.ExtraParams["Grid04SelectedValues"]);

                if (grid01SelectedValues.Length.Equals(0) && grid02SelectedValues.Length.Equals(0) && grid03SelectedValues.Length.Equals(0) && grid04SelectedValues.Length.Equals(0))
                {
                    //선택된 Row가 없습니다. 확인 바랍니다.
                    this.MsgCodeAlert("COM-00100");
                    return;
                }

                DataSet result;

                if (grid02SelectedValues.Length > 0 || grid03SelectedValues.Length > 0 || grid04SelectedValues.Length > 0)
                {
                    string vendCd = ACC_VENDCD.Value.ToString();
                    string rcvMonth = ACC_MONTH.Value.ToString();
                    string rcvType = ACC_RCV_TYPE.Value.ToString();
                    string purcOrg = ACC_PURC_ORG.Value.ToString();
                    string vatCd = ACC_VATCD.Value.ToString();
                    string rcvBizcd = ACC_RCV_BIZCD.Value.ToString();

                    result = getDataSetDetail(vendCd, rcvMonth, rcvType, purcOrg, vatCd, rcvBizcd);
                }
                else
                {
                    result = getDataSet();
                }

                if (result == null) return;

                if (result.Tables.Count == 0) return;

                if (result.Tables[0].Rows.Count == 0)
                {
                    // 출력 또는 내보낼 데이터가 없습니다. 
                    this.MsgCodeAlert("COM-00807");
                }
                else
                {
                    if (grid04SelectedValues.Length > 0)
                    {
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid04);
                    }
                    else if (grid03SelectedValues.Length > 0)
                    {
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid03);
                    }
                    else if (grid02SelectedValues.Length > 0)
                    {
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid02);
                    }
                    else
                    {
                        ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);
                    }

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
            if (!(this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10")) && this.cdx01_VENDCD.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            if (this.df01_FROM_DATE.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_FROM_DATE", lbl01_RCV_DATE2.Text);
                return false;
            }

            if (this.df01_TO_DATE.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_TO_DATE", lbl01_RCV_DATE2.Text);
                return false;
            }

            return true;
        }

        #endregion

        #region [ 이벤트 ]

        protected void cbo01_PURC_ORG_Change(object sender, DirectEventArgs e)
        {

        }

        protected void cbo01_RCV_TYPE_Change(object sender, DirectEventArgs e)
        {

        }

        [DirectMethod]
        public void Grid01_Cell_Click(string vendCd, string rcvMonth, string rcvType, string purcOrg, string vatCd, string rcvBizcd)
        {
            DataSet resultDetail = getDataSetDetail(vendCd, rcvMonth, rcvType, purcOrg, vatCd, rcvBizcd);

            switch (rcvType)
            {
                case "1MA":
                    //this.Grid02.Hidden = false;
                    //this.Grid03.Hidden = true;
                    //this.Grid04.Hidden = true;
                    this.Store8.RemoveAll();
                    this.Store9.RemoveAll();
                    this.Store7.DataSource = resultDetail.Tables[0];
                    this.Store7.DataBind();

                    break;
                case "1MB":
                    //this.Grid02.Hidden = true;
                    //this.Grid03.Hidden = false;
                    //this.Grid04.Hidden = true;
                    this.Store7.RemoveAll();
                    this.Store9.RemoveAll();
                    this.Store8.DataSource = resultDetail.Tables[0];
                    this.Store8.DataBind();
                    break;
                case "1MC":
                    //this.Grid02.Hidden = true;
                    //this.Grid03.Hidden = true;
                    //this.Grid04.Hidden = false;
                    this.Store7.RemoveAll();
                    this.Store8.RemoveAll();
                    this.Store9.DataSource = resultDetail.Tables[0];
                    this.Store9.DataBind();
                    break;
            }
        }

        #endregion
    }
}
