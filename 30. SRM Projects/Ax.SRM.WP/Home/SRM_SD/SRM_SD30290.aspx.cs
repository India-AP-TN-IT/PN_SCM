#region ▶ Description & History
/* 
 * 프로그램명 : 사급직납 마감일자 등록
 * 설      명 : 자재관리 > 사급관리 > 사급직납 마감일자 등록
 * 최초작성자 : 이재우
 * 최초작성일 : 2017-10-08
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
    public partial class SRM_SD30290 : BasePage
    {
        private string pakageName = "SYSHANIL.PKG_SD30290";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_SD30290
        /// </summary>
        public SRM_SD30290()
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
                //if (!IsQueryValidation())
                //{
                //    return;
                //}

                DataSet result = getDataSet();
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();
                DetailReset();
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
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.
            this.df01_DATE_BEG.SetValue(DateTime.Now.AddDays(-1));
            this.df01_DATE_TO.SetValue(DateTime.Now);
            this.rdo01_ALL.Checked = true;
            this.Store1.RemoveAll();

            DetailReset();
        }

        private void DetailReset()
        {
            txt02_ASSY_HLOTNO.SetValue(string.Empty);
            txt02_PARTNO_TITLE.SetValue(string.Empty);
            txt02_ALC.SetValue(string.Empty);
            txt02_PROD_DATE.SetValue(string.Empty);
            txt02_OUT_DATE.SetValue(string.Empty);
            txt02_POSTITLE.SetValue(string.Empty);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getDataSet()
        {
            string plant = string.Empty;
            if(rdo01_ALL.Checked) plant = "";
            else if(rdo01_HW_1PLANT.Checked) plant = "1";
            else if(rdo01_ALL.Checked) plant = "2";
            else plant = "4";

            HEParameterSet paramSet = new HEParameterSet();
            paramSet.Add("CORCD", this.UserInfo.CorporationCode);
            paramSet.Add("BIZCD", this.cbo01_BIZCD.Value);
            paramSet.Add("SDATE", ((DateTime)this.df01_DATE_BEG.Value).ToString("yyyy-MM-dd"));
            paramSet.Add("EDATE", ((DateTime)this.df01_DATE_TO.Value).ToString("yyyy-MM-dd"));
            paramSet.Add("STIME", "");
            paramSet.Add("ETIME", "");
            paramSet.Add("PLANT", plant);
            paramSet.Add("VIN_CODE", txt01_VID.Value);
            
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), paramSet);
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

        #region 이벤트 

        [DirectMethod]
        public void Grid01_Cell_DoubleClick(string lotno)
        {
            HEParameterSet paramSet = new HEParameterSet();
            paramSet.Add("CORCD", this.UserInfo.CorporationCode);
            paramSet.Add("BIZCD", this.cbo01_BIZCD.Value);
            paramSet.Add("EX_LOTNO", lotno);

            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "GET_LOTDATA"), paramSet);
            if (ds.Tables[0].Rows.Count > 0)
            {
                txt02_ASSY_HLOTNO.SetValue(ds.Tables[0].Rows[0]["LOTNO"]);
                txt02_PARTNO_TITLE.SetValue(ds.Tables[0].Rows[0]["PARTNO"]);
                txt02_ALC.SetValue(ds.Tables[0].Rows[0]["ALCCD"]);
                txt02_PROD_DATE.SetValue(ds.Tables[0].Rows[0]["PROD_DATE"]);
                txt02_OUT_DATE.SetValue(ds.Tables[0].Rows[0]["OUT_READ_DATE"]);
                txt02_POSTITLE.SetValue(ds.Tables[0].Rows[0]["INSTALL_POS"]);
            }
       
        }

        #endregion

    }
}