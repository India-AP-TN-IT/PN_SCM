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
    public partial class SRM_MM26003 : BasePage
    {
        private string pakageName = "APG_SRM_MM26003";

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_MM26003
        /// </summary>
        public SRM_MM26003()
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
                    Library.GetBIZCD(this.cbo02_BIZCD, this.UserInfo.CorporationCode, false);
                    Library.GetBIZCD(this.cbo03_BIZCD, this.UserInfo.CorporationCode, false);//2018.11.16 배명희  사급신청등록 제한일수 등록

                    //구매조직
                    DataTable source = Library.GetTypeCode("1A").Tables[0];
                    Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true, "");
                    Library.ComboDataBind(this.cbo02_PURC_ORG, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true, "");
                    if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
                    {
                        this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                        this.cbo02_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                    }
                    this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.
                    this.cbo02_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.

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
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);
            MakeButton(ButtonID.Delete, ButtonImage.Delete, "Delete", this.ButtonPanel);
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
                case ButtonID.Save:
                    Save(sender, e);
                    break;
                case ButtonID.Delete:
                    Delete(sender, e);
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

                //2018.11.16 배명희  사급신청등록 제한일수 등록
                if (result.Tables[0].Rows.Count > 0)
                {
                    this.txt03_MIN_REQ_DAY.SetValue(result.Tables[0].Rows[0]["MIN_REQ_DAY"]);
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
            this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.txt01_SER_YEAR.SetValue(DateTime.Now.Year);

            //this.cbo01_PURC_ORG.SelectedItem.Value = "";
            //this.cbo01_PURC_ORG.UpdateSelectedItems();


            this.cbo02_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo02_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            //this.cbo02_PURC_ORG.SelectedItem.Value = "";
            //this.cbo02_PURC_ORG.UpdateSelectedItems();

            this.df02_STD_YYMM.SetValue(DateTime.Now);

            this.df02_END_DATE.SetValue(DateTime.Now);

            this.txt02_END_TIME.Value = "";

            this.Store1.RemoveAll();

            //2018.11.16 배명희  사급신청등록 제한일수 등록
            this.cbo03_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
            this.cbo03_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

            this.txt03_MIN_REQ_DAY.SetValue(0);
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
            param.Add("STD_YYMM", this.txt01_SER_YEAR.Value);
            param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// Save
        /// 저장(업데이트)
        /// </summary>
        /// <param name="actionType"></param>
        public void Save(object sender, DirectEventArgs e)
        {
            try
            {
                if (!IsSaveValidation())
                {
                    return;
                }

                DataSet saveParam = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "STD_YYMM", "PURC_ORG", "CLS_DATE", "CLS_TIME", "USER_ID"
                );


                saveParam.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode
                    , this.cbo02_BIZCD.Value
                    , ((DateTime)this.df02_STD_YYMM.Value).ToString("yyyy-MM")
                    , this.cbo02_PURC_ORG.Value
                    , ((DateTime)this.df02_END_DATE.Value).ToString("yyyy-MM-dd")
                    , this.txt02_END_TIME.Value
                    , this.UserInfo.UserID
                );


                //using (EPClientProxy proxy = new EPClientProxy())
                //{
                //    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE"), saveParam);
                //    Search();
                //}

                //2018.11.16 배명희 사급신청등록 제한일수 등록 추가.
                DataSet saveParam2 = Util.GetDataSourceSchema("CORCD", "BIZCD", "MIN_REQ_DAY");
                saveParam2.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode
                    , this.cbo03_BIZCD.Value
                    , this.txt03_MIN_REQ_DAY.Value.ToString() == "" ? "0" : this.txt03_MIN_REQ_DAY.Value
                );

                DataSet[] source = new DataSet[] { saveParam, saveParam2 };
                string[] proc = new string[] { string.Format("{0}.{1}", pakageName, "SAVE"),
                                                string.Format("{0}.{1}", pakageName, "SAVE_MIN_REQ_DAY")};

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.MultipleExecuteNonQueryTx(proc, source);
                    //proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_MIN_REQ_DAY"), saveParam2);
                    Search();
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

        /// <summary>
        /// Delete
        /// 삭제
        /// </summary>
        /// <param name="actionType"></param>
        public void Delete(object sender, DirectEventArgs e)
        {
            try
            {
                if (!IsDeleteValidation())
                {
                    return;
                }

                DataSet deleteParam = Util.GetDataSourceSchema
                (
                   "CORCD", "BIZCD", "STD_YYMM", "PURC_ORG"
                );

                deleteParam.Tables[0].Rows.Add
                (
                    Util.UserInfo.CorporationCode
                    , this.cbo02_BIZCD.Value
                    , ((DateTime)this.df02_STD_YYMM.Value).ToString("yyyy-MM")
                    , this.cbo02_PURC_ORG.Value
                );

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "REMOVE"), deleteParam);
                    Search();
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
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_BIZCD", lbl01_SAUP.Text);
                return false;
            }
            if (this.cbo01_PURC_ORG.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
                return false;
            }
            if (this.txt01_SER_YEAR.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_SER_YEAR", lbl01_SER_YEAR.Text);
                return false;
            }
            return true;
        }

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsSaveValidation()
        {
            // 저장용 Validation
            if (this.cbo02_BIZCD.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo02_BIZCD", lbl02_SAUP.Text);
                return false;
            }
            if (this.cbo02_PURC_ORG.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo02_PURC_ORG", lbl02_PURC_ORG.Text);
                return false;
            }
            if (this.df02_STD_YYMM.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df02_STD_YYMM", lbl02_CLS_YYMM.Text);
                return false;
            }
            if (this.df02_END_DATE.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df02_END_DATE", lbl02_END_DATE.Text);
                return false;
            }
            if (this.txt02_END_TIME.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt02_END_TIME", lbl02_END_TIME.Text);
                return false;
            }
            return true;
        }

        /// <summary>
        /// Validation
        /// </summary>
        /// <returns></returns>
        public bool IsDeleteValidation()
        {
            // 삭제용 Validation
            if (this.cbo02_BIZCD.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo02_BIZCD", lbl02_SAUP.Text);
                return false;
            }
            if (this.cbo02_PURC_ORG.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo02_PURC_ORG", lbl02_PURC_ORG.Text);
                return false;
            }
            if (this.df02_STD_YYMM.IsEmpty)
            {
                //{0}를(을) 입력해주세요.
                this.MsgCodeAlert_ShowFormat("EP20S01-003", "df02_STD_YYMM", lbl02_CLS_YYMM.Text);
                return false;
            }
            return true;
        }

        #endregion

        #region 이벤트

        protected void cbo01_BIZCD_Change(object sender, DirectEventArgs e)
        {
            this.cbo02_BIZCD.SetValue(this.cbo01_BIZCD.Value);
            this.cbo03_BIZCD.SetValue(this.cbo01_BIZCD.Value);//2018.11.16 배명희   사급신청등록 제한일수 등록
        }

        protected void cbo01_PURC_ORG_Change(object sender, DirectEventArgs e)
        {
            this.cbo02_PURC_ORG.SetValue(this.cbo01_PURC_ORG.Value);
        }

        [DirectMethod]
        public void Grid01_Cell_DoubleClick(string yymm, string date, string time)
        {
            this.df02_STD_YYMM.SetValue(yymm);
            this.df02_END_DATE.SetValue(date);
            this.txt02_END_TIME.SetValue(time.Replace(":", ""));
        }

        #endregion

    }
}