#region ▶ Description & History
/* 
 * 프로그램명 : 발주정보 조회(납기일자별)
 * 설      명 : 자재관리 > 발주관리 > 발주정보 조회(납기일자별) 조회
 * 최초작성자 : 손창현
 * 최초작성일 : 2017-07-18
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
using HE.Framework.Core.Report;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM31007 : BasePage
    {
        private string pakageName = "APG_SRM_MM31007";
        
        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM31007
        /// </summary>
        public SRM_MM31007()
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
                    // [SRM] Library.ComboDataBind(this.cbo01_LOG_DIV, Library.GetTypeCode("EB").Tables[0], true, "OBJECT_NM", "OBJECT_ID", true);

                    DataTable source = Library.GetTypeCode("1K").Tables[0];
                    source.DefaultView.RowFilter = "TYPECD NOT IN ('NI')";
                    Library.ComboDataBind(this.cbo01_PURC_PO_TYPE, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.

                    source = Library.GetTypeCode("1A").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", false);
                    if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
                    {
                        this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                    }
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

                    source = Library.GetTypeCode("1Y").Tables[0];
                    Library.ComboDataBind(this.cbo01_QUERY_COND, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_QUERY_COND.UpdateSelectedItems(); //꼭 해줘야한다.

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
            //MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
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
            if (this.UserInfo.UserDivision.Equals("T12"))
                this.cdx01_VENDCD.SetValue(string.Empty);

            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.txt01_FPARTNO.SetValue(string.Empty);
            
            this.cdx01_STR_LOC.SetValue(string.Empty);
            this.cdx01_CUSTCD.SetValue(string.Empty);

            this.cbo01_QUERY_COND.SelectedItem.Value = "1YX";
            this.cbo01_QUERY_COND.UpdateSelectedItems(); //꼭 해줘야한다.

            this.df01_PO_STD_DATE.SetValue(DateTime.Now);

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
            param.Add("STD_DATE", ((DateTime)this.df01_PO_STD_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("PURC_ORG", cbo01_PURC_ORG.Value);
            param.Add("PURC_PO_TYPE", cbo01_PURC_PO_TYPE.Value);
            param.Add("PARTNO", txt01_FPARTNO.Value);
            param.Add("STR_LOC", cdx01_STR_LOC.Value); //저장위치
            param.Add("CUSTCD", cdx01_CUSTCD.Value);
            param.Add("QUERY_COND", cbo01_QUERY_COND.Value);
            param.Add("PONO", txt01_PONO.Value);
            param.Add("PONO_SEQ", txt01_PONO_SEQ.Value);
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

                if (result == null) return;

                if (result.Tables[0].Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                {
                    SetYmdDateChange(false);
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
            //if (this.cdx01_VENDCD.IsEmpty)
            if (this.cdx01_VENDCD.IsEmpty && !(this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10")))
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
                return false;
            }
            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
                return false;
            }
            if (this.df01_PO_STD_DATE.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_PO_DATE_BEG", lbl01_PO_STD_DATE.Text);
                return  false;
            }
            
            return true;
        }

        #endregion

        #region [ 이벤트 ]
        //날짜 정보 변경 시
        [DirectMethod]
        public void SetYmdDateChange(bool value)
        {
            try
            {
                if (value)
                    this.Store1.RemoveAll();

                int idx = this.Grid01.ColumnModel.Columns.Count; //마지막의 30개 컬럼에 대하여 처리한다.

                DateTime dt = (DateTime)this.df01_PO_STD_DATE.Value;

                int j = 0;

                for (int i = idx - 30; i < idx; i++)
                {
                    this.Grid01.ColumnModel.Columns[i].Text = dt.AddDays(j).ToString("MM-dd");
                    j++;
                }
            }
            catch
            {
            }
        }

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void cdx01_STR_LOC_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            // UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
            if (this.cbo01_BIZCD.Value == null)
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
            else
                cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.Value);
        }

        [DirectMethod]
        public void MakePopUp(String[] arr, string type)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", UserInfo.CorporationCode);
            param.Add("BIZCD", cbo01_BIZCD.Value);
            param.Add("VENDCD", arr[0]);
            param.Add("PURC_ORG", arr[1]);
            param.Add("PURC_PO_TYPE", arr[2]);
            param.Add("VINCD", arr[3]);
            param.Add("PARTNO", arr[4]);
            param.Add("PARTNM", arr[5]);
            param.Add("STR_LOC", arr[6]);
            param.Add("UNIT", arr[7]);
            param.Add("CUSTCD", arr[8]);
            param.Add("STD_DATE", ((DateTime)this.df01_PO_STD_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("DAY", arr[9]);
            param.Add("QUERY_COND", cbo01_QUERY_COND.Value);

            if (type.Equals("P")) //발주량
            {
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM31007P1.aspx", param, "HELP_MM31007P1", "Popup", 800, 600);
            }
            else //납품량
            {
                Util.UserPopup((BasePage)this.Form.Parent.Page, "../SRM_MM/SRM_MM31007P2.aspx", param, "HELP_MM31007P2", "Popup", 800, 600);
            }
        }
        #endregion
    }
}
