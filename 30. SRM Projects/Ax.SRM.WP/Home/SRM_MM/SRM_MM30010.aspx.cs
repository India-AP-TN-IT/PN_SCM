#region ▶ Description & History
/* 
 * 프로그램명 : 월간 구매계획 조회
 * 설      명 : 자재관리 > 계획관리 > 월간 구매계회 조회
 * 최초작성자 : 손창현
 * 최초작성일 : 2017-08-17
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
    public partial class SRM_MM30010 : BasePage
    {
        private string pakageName = "APG_SRM_MM30010";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM30010
        /// </summary>
        public SRM_MM30010()
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

                    DataTable source = Library.GetTypeCode("1E").Tables[0];
                    Library.ComboDataBind(this.cbo01_PLAN_DIV, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_PLAN_DIV.UpdateSelectedItems(); //꼭 해줘야한다.

                    source = Library.GetTypeCode("1A").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
                    {
                        this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                    }
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

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
            if (this.UserInfo.UserDivision.Equals("T12"))
            {
                this.cdx01_VENDCD.SetValue(string.Empty);
            }

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.           

            this.df01_DATE.SetValue(DateTime.Now);

            this.cbo01_PLAN_DIV.SelectedItem.Index = 0;
            this.cbo01_PURC_ORG.SelectedItem.Index = 0;
            this.cdx01_VINCD.SetValue(string.Empty);
            this.txt01_FPARTNO.SetValue(string.Empty);

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
            param.Add("BIZCD", this.cbo01_BIZCD.Value);
            param.Add("VENDCD", this.cdx01_VENDCD.Value);
            param.Add("DATE", ((DateTime)this.df01_DATE.Value).ToString("yyyy-MM"));
            param.Add("PLAN_DIV", this.cbo01_PLAN_DIV.Value);
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
            param.Add("VINCD", this.cdx01_VINCD.Value);
            param.Add("PARTNO", this.txt01_FPARTNO.Value);
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
                    SetYmdDateChange(false); //엑셀 양식의 그리드 컬럼명을 호출하기 위해 실행
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
        public void SetYmdDateChange(bool value)
        {
            if(value)
                this.Store1.RemoveAll();

            int idx = this.Grid01.ColumnModel.Columns.Count - 1; //마지막의 5개 컬럼에 대하여 처리한다.

            DateTime dt = (DateTime)this.df01_DATE.Value;

            for(int i = 0; i < 5; i++)
            {
                this.Grid01.ColumnModel.Columns[idx].Columns[i].Text = dt.AddMonths(i).ToString("yyyy-MM");                
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
            if (this.cbo01_BIZCD.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_BIZCD", lbl01_SAUP.Text);
                return false;
            }

            //if (this.cdx01_VENDCD.IsEmpty)
            if (this.cdx01_VENDCD.IsEmpty && !(this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10")))
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }

            if (this.df01_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_DATE", lbl01_STD_YYMM.Text);
                return false;
            }

            if (this.cbo01_PLAN_DIV.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PLAN_DIV", lbl01_PLAN_DIV.Text);
                return false;
            }

            return true;
        }
        
        #endregion
            
    }
}
