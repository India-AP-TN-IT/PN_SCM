#region ▶ Description & History
/* 
 * 프로그램명 : Shortage Monitoring
 * 설      명 : 자재관리 > 납품관리 > Shortage Monitoring
 * 최초작성자 : 배명희
 * 최초작성일 : 2018-06-27
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
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;


namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_ZMM32008 : BasePage
    {
        private string pakageName = "ZPG_SRM_ZMM32008";

        #region [ 초기설정 ]

        /// <summary>
        /// SCM_MM32007
        /// </summary>
        public SRM_ZMM32008()
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

                    //Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);
                    HEParameterSet set = new HEParameterSet();
                    set.Add("CORCD", this.UserInfo.CorporationCode);
                    set.Add("BIZCD", this.UserInfo.BusinessCode);
                    //창고 콤보상자 바인딩
                    DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_COMMON", "INQUERY_YARDNO"), set);
                    Library.ComboDataBind(this.cbo01_YARDNO, source.Tables[0], false, "YARDNM", "YARDNO", true);

                    Reset();
                    SetDateChange();
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
                SetDateChange();//그리드 컬럼 헤더에 날짜 표시

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
            //업체코드는 한일이화 사용자인 경우에만 초기화한다.
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            //this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            //this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_DELI_DATE.SetValue(DateTime.Now);
            this.Store1.RemoveAll();

            this.txt01_PARTNO.SetValue(string.Empty);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {

            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            //param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("BIZCD", this.UserInfo.BusinessCode);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);

            param.Add("PO_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
            //param.Add("PO_DATE", this.GetDateText(this.df01_DELI_DATE, "yyyy-MM-dd"));

            param.Add("YARDNO", this.cbo01_YARDNO.Value);
            param.Add("PARTNO", this.txt01_PARTNO.Value);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

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
                SetDateChange();

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

        //[DirectMethod]
        //public void CheckChange()
        //{
        //    GridPanel grid = this.Grid01;
        //    for (int i = 0; i < grid.ColumnModel.Columns.Count; i++)
        //    {
        //        if (grid.ColumnModel.Columns[i].ItemID != null && grid.ColumnModel.Columns[i].ItemID.StartsWith("DATE"))
        //        {

        //            if (grid.ColumnModel.Columns[i].ItemID.EndsWith("D2") ||
        //                grid.ColumnModel.Columns[i].ItemID.EndsWith("D3") ||
        //                grid.ColumnModel.Columns[i].ItemID.EndsWith("D4"))
        //            {
        //                grid.ColumnModel.Columns[i].Visible = this.chk01.Checked;
        //            }
        //        }
        //        else
        //        {
        //            if (grid.ColumnModel.Columns[i].Columns.Count == 0)
        //            {
        //                continue;
        //            }
        //            else
        //            {
        //                RepeatCheckChange(grid.ColumnModel.Columns[i].Columns);
        //            }
        //        }
        //    }
        //}
        //private void RepeatCheckChange(ItemsCollection<ColumnBase> children)
        //{
        //    for (int i = 0; i < children.Count; i++)
        //    {
        //        if (children[i].ItemID != null && children[i].ItemID.StartsWith("DATE"))
        //        {
        //            if (children[i].ItemID.EndsWith("D2") ||
        //               children[i].ItemID.EndsWith("D3") ||
        //               children[i].ItemID.EndsWith("D4"))
        //            {
        //                children[i].Visible = this.chk01.Checked;
        //            }
        //        }
        //        else
        //        {
        //            if (children[i].Columns.Count > 0)
        //            {

        //                RepeatCheckChange(children[i].Columns);
        //            }
        //            else
        //            {
        //                continue;
        //            }
        //        }
        //    }

        //}

        //날짜 정보 변경 시
        [DirectMethod]
        public void SetDateChange()
        {

            DateTime stdDate = ((DateTime)this.df01_DELI_DATE.Value);
            //DateTime stdDate = ((DateTime)this.GetDateValue(this.df01_DELI_DATE));

            SetHeaderText(this.Grid01, stdDate);
        }


        private static void SetHeaderText(GridPanel grid, DateTime dt)
        {
            for (int i = 0; i < grid.ColumnModel.Columns.Count; i++)
            {
                if (grid.ColumnModel.Columns[i].ItemID != null && grid.ColumnModel.Columns[i].ItemID.StartsWith("DATE"))
                {

                    if (grid.ColumnModel.Columns[i].ItemID.EndsWith("D0"))
                    {
                        grid.ColumnModel.Columns[i].Text = dt.ToShortDateString();
                    }
                    else if (grid.ColumnModel.Columns[i].ItemID.EndsWith("D1"))
                    {
                        grid.ColumnModel.Columns[i].Text = dt.AddDays(1).ToShortDateString();
                    }
                    else if (grid.ColumnModel.Columns[i].ItemID.EndsWith("D2"))
                    {
                        grid.ColumnModel.Columns[i].Text = dt.AddDays(2).ToShortDateString();
                    }
                    else if (grid.ColumnModel.Columns[i].ItemID.EndsWith("D3"))
                    {
                        grid.ColumnModel.Columns[i].Text = dt.AddDays(3).ToShortDateString();
                    }
                    else if (grid.ColumnModel.Columns[i].ItemID.EndsWith("D4"))
                    {
                        grid.ColumnModel.Columns[i].Text = dt.AddDays(4).ToShortDateString();
                    }
                }
                else
                {
                    if (grid.ColumnModel.Columns[i].Columns.Count == 0)
                    {
                        continue;
                    }
                    else
                    {
                        Repeat(grid.ColumnModel.Columns[i].Columns, dt);
                    }
                }
            }
        }

        /// <summary>
        /// 컬럼 헤더명 설정하기 위한 재귀메서드
        /// </summary>
        /// <param name="headerNode"></param>
        /// <param name="children"></param>
        /// <param name="arr"></param>
        /// <param name="AllText"></param>
        private static void Repeat(ItemsCollection<ColumnBase> children, DateTime dt)
        {
            for (int i = 0; i < children.Count; i++)
            {
                if (children[i].ItemID != null && children[i].ItemID.StartsWith("DATE"))
                {
                    if (children[i].ItemID.EndsWith("D0"))
                    {
                        children[i].Text = dt.ToShortDateString();
                    }
                    else if (children[i].ItemID.EndsWith("D1"))
                    {
                        children[i].Text = dt.AddDays(1).ToShortDateString();
                    }
                    else if (children[i].ItemID.EndsWith("D2"))
                    {
                        children[i].Text = dt.AddDays(2).ToShortDateString();
                    }
                    else if (children[i].ItemID.EndsWith("D3"))
                    {
                        children[i].Text = dt.AddDays(3).ToShortDateString();
                    }
                    else if (children[i].ItemID.EndsWith("D4"))
                    {
                        children[i].Text = dt.AddDays(4).ToShortDateString();
                    }
                }
                else
                {
                    if (children[i].Columns.Count > 0)
                    {

                        Repeat(children[i].Columns, dt);
                    }
                    else
                    {
                        continue;
                    }
                }
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
            if (this.cdx01_VENDCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            //if (this.df01_DELI_DATE.IsEmpty)
            if (this.GetDateText(this.df01_DELI_DATE) == string.Empty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_DELI_DATE", lbl01_STD_DATE.Text);
                return false;
            }
            return true;
        }

        #endregion

        #region [ 이벤트 ]

        #endregion

    }
}
