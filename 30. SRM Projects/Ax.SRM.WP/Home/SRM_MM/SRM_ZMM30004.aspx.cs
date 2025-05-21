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
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using System.Data;
using System.Collections;
using System.Globalization;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_ZMM30004 : BasePage
    {
        private string pakageName = "ZPG_SRM_ZMM30004";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_ZMM30004
        /// </summary>
        public SRM_ZMM30004()
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
                    //Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);

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
                SetDateChange();
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

            param.Add("STD_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));            
            //param.Add("STD_DATE", this.GetDateText(this.df01_DELI_DATE, "yyyy-MM-dd"));

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

        //날짜 정보 변경 시
        [DirectMethod]
        public void SetDateChange()
        {

            //DateTime stdDate = ((DateTime)this.df01_DELI_DATE.Value);
            DateTime stdDate = ((DateTime)this.GetDateValue(this.df01_DELI_DATE));

            SetHeaderText(this.Grid01, stdDate);
        }


        private void SetHeaderText(GridPanel grid, DateTime dt)
        {
            //DateTime stdDate = ((DateTime)this.df01_DELI_DATE.Value);
            DateTime stdDate = ((DateTime)this.GetDateValue(this.df01_DELI_DATE));

            for (int i = 0; i < grid.ColumnModel.Columns.Count; i++)
            {
                if (grid.ColumnModel.Columns[i].ItemID != null && grid.ColumnModel.Columns[i].ItemID.StartsWith("HW"))
                {
                    int num = Convert.ToInt32(grid.ColumnModel.Columns[i].ItemID.Substring(2));
                    if (num == 0)
                    {
                        grid.ColumnModel.Columns[i].Text = stdDate.AddDays(num).ToString(this.GlobalLocalFormat_Date);
                        //+ "\n[" + this.GetWeekOfYear(stdDate.AddDays(i).ToString("yyyy-MM-dd")) 
                        //+ "/" + (i + 1) + "W]";                        

                    }
                    else if (num > 0 && num < 10)
                    {
                        grid.ColumnModel.Columns[i].Text = stdDate.AddDays(num * 7 + Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(stdDate.AddDays(num * 7).DayOfWeek)).ToString(this.GlobalLocalFormat_Date);
                        //+ "\n[" + WeekPosition(stdDate, i)                            
                        //+ "/" + (i + 1) + "W]";



                    }
                    else
                    {
                        grid.ColumnModel.Columns[i].Text = stdDate.AddDays(num * 7 + Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(stdDate.AddDays(num * 7).DayOfWeek)).ToString(this.GlobalLocalFormat_Date);
                        //+ "\n[" + WeekPosition(stdDate, i)                            
                        //+ "/" + (i + 1) + "W]";


                    }

                    grid.ColumnModel.Columns[i].Columns[0].Text = "[" + this.GetWeekOfYear(stdDate.AddDays(num * 7 + Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(stdDate.AddDays(num * 7).DayOfWeek)).ToString(this.GlobalLocalFormat_Date)) + "/" + (num + 1) + "W]";
                }
                else
                {

                    continue;


                }
            }
        }

        /// <summary>
        /// 인자로 받은 날짜(문자형)를 년도내 주차정보 구해 반환합니다.
        /// </summary>
        private int GetWeekOfYear(string sourceDate)
        {
            DateTimeFormatInfo dfi = DateTimeFormatInfo.CurrentInfo;
            DateTime date1 = Convert.ToDateTime(sourceDate);
            System.Globalization.Calendar cal = dfi.Calendar;

            //return cal.GetWeekOfYear(date1, CalendarWeekRule.FirstFullWeek, DayOfWeek.Monday);
            return cal.GetWeekOfYear(date1, CalendarWeekRule.FirstDay, DayOfWeek.Monday);
        }


        //private int WeekPosition(DateTime stdDate, int i)
        //{
        //    int WeekPosition = 0;
        //    int WeekCnt = 0;
        //    WeekPosition = this.GetWeekOfYear(stdDate.AddDays(i).ToString("yyyy-MM-dd"));



        //    WeekCnt = this.GetWeekOfYear(stdDate.ToString("yyyy-MM-dd"));

        //    int chk = WeekCnt - WeekPosition;

        //    if (i != 0 && (WeekCnt != 1 && chk > -1))
        //    {
        //        if (Convert.ToDateTime(stdDate.AddDays(i * 7 + Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(stdDate.AddDays(i * 7).DayOfWeek)).ToShortDateString()).Month == 1)
        //        {
        //            DateTime date = Convert.ToDateTime(stdDate.AddDays(i * 7 + Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(stdDate.AddDays(i * 7).DayOfWeek)).ToShortDateString());

        //            DateTime dateValue = new DateTime(date.Year, date.Month, 1);
        //            if ((int)dateValue.DayOfWeek != 1)
        //            {
        //                if (i < 10)
        //                    WeekPosition -= 1;
        //                else
        //                    WeekPosition -= 1;
        //            }
        //        }
        //    }

        //    return WeekPosition;
        //}

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
