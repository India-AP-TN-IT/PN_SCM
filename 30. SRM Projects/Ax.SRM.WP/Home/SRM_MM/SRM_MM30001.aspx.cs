#region ▶ Description & History
/* 
 * 프로그램명 : MIP 자재소요계획 현황
 * 설      명 : 자재관리 > 계획관리 > MIP 자재소요계획 현황
 * 최초작성자 : 이재우
 * 최초작성일 : 2017-09-05
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

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM30001 : BasePage
    {
        private string pakageName = "APG_SRM_MM30001";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SCM_MM30001
        /// </summary>
        public SRM_MM30001()
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

                    //조회구분 : 집계/상세
                    DataTable source = Library.GetTypeCode("1Z").Tables[0];
                    source.DefaultView.RowFilter = "TYPECD IN ('S', 'D')";
                    Library.ComboDataBind(this.cbo01_SEARCH_OPT, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.

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

            if (id == ButtonID.Search || id == ButtonID.M_Search)
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "GridPanel";
                ibtn.DirectEvents.Click.EventMask.Msg = "Loading Data...";
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

                // 집계, 상세 구분
                if (this.cbo01_SEARCH_OPT.Value.Equals("1ZS"))
                {
                    this.Store1.DataSource = result.Tables[0];
                    this.Store1.DataBind();
                }
                else
                {
                    this.Store2.DataSource = result.Tables[0];
                    this.Store2.DataBind();
                }

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
            //업체코드는 서연이화 사용자인 경우에만 초기화한다.
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
                        
            //this.cdx01_LINECD.SetValue(string.Empty);
            this.txt01_LINECD.SetValue(string.Empty);
            //this.cdx01_VINCD.SetValue(string.Empty);
            this.txt01_VINCD.SetValue(string.Empty);

            this.txt01_FPARTNO.Text = string.Empty;

            this.cbo01_SEARCH_OPT.SelectedItem.Value = "1ZS";
            this.cbo01_SEARCH_OPT.UpdateSelectedItems(); //꼭 해줘야한다.
            this.df01_REQ_DATE.SetValue(DateTime.Now);

            this.Grid01.Show();
            this.Grid02.Hide();            

            this.Store1.RemoveAll();
            this.Store2.RemoveAll();
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
            param.Add("REQ_DATE", ((DateTime)this.df01_REQ_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("LINECD", this.txt01_LINECD.Text);
            param.Add("VINCD", this.txt01_VINCD.Text);
            param.Add("FPARTNO", this.txt01_FPARTNO.Text);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            param.Add("USER_ID", this.UserInfo.UserID);

            //집계/상세 구분
            if (this.cbo01_SEARCH_OPT.Value.Equals("1ZS"))
            {
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SUMMARY"), param);
            }
            else
            {
                return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_DETAIL"), param);
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
                    ExcelHelper.ExportExcel(this.Page, result.Tables[0], (cbo01_SEARCH_OPT.Value.Equals("1ZS") ? Grid01 : Grid02));
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

            if (this.cbo01_BIZCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_BIZCD", lbl01_SAUP.Text);
                return false;
            }

            if (this.df01_REQ_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_REQ_DATE", lbl01_INQUERY_STD_DATE.Text);
                return  false;
            }
            return true;
        }

        #endregion

        #region [사용자 함수]

        /// <summary>
        /// 집계/상세 선택시 각각 다른 그리드를 보여줌
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void cbo01_SEARCH_OPT_Change(object sender, DirectEventArgs e)
        {
            //df01_REQ_DATE_Change(true);

            Ext.Net.ComboBox cbo = (Ext.Net.ComboBox)sender;
            if (cbo.Value.Equals("1ZS"))
            {
                this.Grid01.Show();
                this.Grid02.Hide();
            }
            else
            {
                this.Grid01.Hide();
                this.Grid02.Show();
            }
        }

        //날짜 정보 변경 시
        [DirectMethod]
        public void df01_REQ_DATE_Change(bool value)
        {
            if (value)
            {
                int grid01 = 8; //집계 그리드 날짜 시작 컬럼
                int grid02 = 12; //상세 그리드 날짜 시작 컬럼

                DateTime dt = (DateTime)this.df01_REQ_DATE.Value;

                this.Store1.RemoveAll();
                this.Store2.RemoveAll();

                //for (int i = 0; i < 14; i++) //14일간의 정보를 표시
                for (int i = 0; i < 31; i++) //31일간의 정보를 표시
                {
                    this.Grid01.ColumnModel.Columns[grid01 + i].Text = dt.AddDays(i).ToString(this.GlobalLocalFormat_MonthDate);
                    this.Grid02.ColumnModel.Columns[grid02 + i].Text = dt.AddDays(i).ToString(this.GlobalLocalFormat_MonthDate);
                }

                /*
                int day = 0;
                DateTime dt = (DateTime)this.df01_REQ_DATE.Value;

                if (this.cbo01_SEARCH_OPT.Value.Equals("1ZS"))
                {
                    // 집계
                    this.Store1.RemoveAll();

                    int count = this.Grid01.ColumnModel.Columns.Count;
                    for (int i = 8; i < count; i++)
                    {
                        this.Grid01.ColumnModel.Columns[i].Text = dt.AddDays(day).ToString("MM-dd");
                        day++;
                    }
                }
                else
                {
                    // 상세
                    this.Store2.RemoveAll();

                    int count = this.Grid02.ColumnModel.Columns.Count;
                    for (int i = 12; i < count; i++)
                    {
                        this.Grid02.ColumnModel.Columns[i].Text = dt.AddDays(day).ToString("MM-dd");
                        day++;
                    }
                }
                */
            }
        }

        #endregion

        #region [코드박스 이벤트 핸들러]
        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_LINECD_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            // UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
            if (this.cbo01_BIZCD.Value == null)
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
            else
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.Value);
        }

        #endregion
    }
}