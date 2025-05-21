#region ▶ Description & History
/* 
 * 프로그램명 : ALC 투입실적    [D2](구.VA3010)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-10-27
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
using HE.Framework.Core.Report;
using System.IO;
using System.Security.Principal;
using System.Xml;
using System.Diagnostics;

namespace Ax.SRM.WP.Home.SRM_ALC
{

    public partial class SRM_ALC30002 : BasePage
    {
        private string pakageName = "APG_SRM_ALC30002";
        private int _DASICNT = 2;

        #region [ 초기설정 ]

        /// <summary>
        /// SRM_ALC30002
        /// </summary>
        public SRM_ALC30002()
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

        private void initDate()
        {
            //2015.02.23 후로 ALC3003과 동일한 날짜 초기화 로직 적용
                        //06시 부터 오늘 날짜 그 이전은 어제 날짜
            //if (this.cbo01_DIVISION.Value.ToString().Equals("ON-LINE"))
            //{
            //    this.df01_QUT_DATE.SetValue(DateTime.Now);
            //    if (DateTime.Now.Hour < 6)
            //    {
            //        this.df01_QUT_DATE.SetValue(DateTime.Now.AddDays(-1));
            //    }
            //    else
            //    {
            //        this.df01_QUT_DATE.SetValue(DateTime.Now);
            //    }
            //}

            //03시~09시 사이에 오늘일자로 LSEQ = 1이 존재할때 까지 하루전 날짜로 표시
            if (this.cbo01_DIVISION.Value.ToString().Equals("ON-LINE"))
            {
                int hour = 0;
                hour = DateTime.Now.Hour;
                if (hour > 3 && hour < 9)
                {
                    DataSet ds = new DataSet();

                    HEParameterSet set = new HEParameterSet();
                    set.Add("CORCD", Util.UserInfo.CorporationCode);
                    set.Add("BIZCD", Util.UserInfo.BusinessCode);
                    set.Add("YMD", DateTime.Now.ToString("yyyyMMdd"));
                    set.Add("PLANT_GB", this.cbo01_PLANT_GB.Value);
                    set.Add("LINE_GB", this.cbo01_LINE_GB.Value);
                    set.Add("USER_ID", Util.UserInfo.UserID);
                    set.Add("LANG_SET", Util.UserInfo.LanguageShort);

                    ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_INIT_DATE"), set);

                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        if (ds.Tables[0].Rows[0]["CNT"].ToString().Equals("0"))
                        {
                            this.df01_QUT_DATE.SetValue(DateTime.Now.AddDays(-1));
                        }
                        else
                        {
                            //Print(); //사용안함.
                            this.df01_QUT_DATE.SetValue(DateTime.Now);
                        }
                    }
                }
                else if (hour <= 3)
                    this.df01_QUT_DATE.SetValue(DateTime.Now.AddDays(-1));
                else
                    this.df01_QUT_DATE.SetValue(DateTime.Now);
            }
        }

        //구분 정보 변경 시
        [DirectMethod]
        public void SetDivsionComboChange()
        {
            if (this.cbo01_DIVISION.Value.Equals("ON-LINE"))
            {
                initDate();
                //this.df01_QUT_DATE.SetValue(DateTime.Now);
                this.df01_QUT_DATE.Editable = false;
                this.txt02_CHASU.ReadOnly = true;
            }
            else
            {
                this.df01_QUT_DATE.Editable = true;
                this.txt02_CHASU.ReadOnly = false;
            }

            if (!this.cdx01_VENDCD.Value.Equals(string.Empty))
                Search();
        }

        //날짜 정보 변경 시
        [DirectMethod]
        public void SetYmdDateChange()
        {
            //if(this.cbo01_DIVISION.Value.Equals("ON-LINE"))
            //    this.df01_QUT_DATE.SetValue(DateTime.Now);
            //initDate();
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
            MakeButton(ButtonID.Print, ButtonImage.Print, "Print", this.ButtonPanel);
            MakeButton(ButtonID.FileDown, ButtonImage.FileDown, "FileDown", this.ButtonPanel, true);  //파일다운로드할 때는 반드시 UPLOAD여부에 TRUE로 전달하여야 한다. 그래야  IFRAME처리가 된다고 함.
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
                case ButtonID.Print:
                    Print();
                    break;
                case ButtonID.FileDown:
                    FileDown();
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

                Search_Print(ButtonID.Search);

                //X.Js.Call("fn_Search");
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        //조회, 출력, 파일 다운로드 공통 조회 부분
        private void Search_Print(string SP_Divn)
        {
            initDate();

            DataSet ds = ItemChasu();

            if (ds.Tables[0].Rows.Count > 0)
            {
                this.txt01_FIELD_NM1.Text = ds.Tables[0].Rows[0]["FIELD_NM1"].ToString();
                this.txt01_FIELD_NM2.Text = ds.Tables[0].Rows[0]["FIELD_NM2"].ToString();
                this.txt01_CHASU_QTY.Text = ds.Tables[0].Rows[0]["CHASU_QTY"].ToString();

                string ITEM1 = this.txt01_FIELD_NM1.Text == "" ? "ITEM" : this.txt01_FIELD_NM1.Text;
                string ITEM2 = this.txt01_FIELD_NM2.Text == "" ? "ITEM" : this.txt01_FIELD_NM2.Text;

                this.FIELD_NM1.Text = ITEM1;
                this.FIELD_NM2.Text = ITEM2;

                string LASTLSEQ = "";

                //최종 LSEQ를 알아냄.
                if (cbo01_DIVISION.Text.ToString().Equals("ON-LINE")) //온라인일 경우 출력하기 위한 차수를 넣어놓는다.
                {
                    DataSet ds02 = Lseq();

                    if (ds02.Tables[0].Rows.Count > 0)
                    {
                        LASTLSEQ = ds02.Tables[0].Rows[0]["LSEQ"].ToString();

                        // 차수 계산                        
                        //'2008.04.04 txtCHASU.Value = CStr(CLng(lastLSEQ) / (IIf(cboPLANT.Value <> "7", CLng(chasu_qty), CLng(chasu_qty) * 5)))
                        this.txt02_CHASU.Text = Math.Ceiling(Convert.ToDecimal(Convert.ToDecimal(LASTLSEQ) / (this.cbo01_PLANT_GB.Value.ToString() != "7" ? Convert.ToDecimal(this.txt01_CHASU_QTY.Text) : Convert.ToDecimal(this.txt01_CHASU_QTY.Text) * _DASICNT))).ToString();
                        if (Convert.ToInt64(LASTLSEQ) < Convert.ToInt64(this.txt01_CHASU_QTY.Text))
                        {
                            this.txt02_CHASU.Value = "1";
                        }
                        else
                            if (this.txt02_CHASU.Value.ToString().IndexOf('.') > 0)
                                this.txt02_CHASU.Value = this.txt02_CHASU.Text.Substring(Convert.ToInt32(this.txt02_CHASU.Text), Convert.ToInt32(this.txt02_CHASU.Text.IndexOf('.') - 1)) + 1;
                    }
                    else
                        return;
                }
                else //BATCH일 경우
                {
                    if (SP_Divn.Equals("ButtonSearch") || SP_Divn.Equals("crtTEXT") || SP_Divn.Equals("ButtonExcelDL"))
                    {
                        if (this.txt02_CHASU.Value.ToString().Equals(""))
                        {
                            this.txt02_CHASU.Value = "1";
                        }
                    }
                    else if (SP_Divn.Equals("ButtonPrint"))
                    {
                        Chasu();
                    }
                }

                if (SP_Divn.Equals("ButtonSearch"))
                {
                    ResultDs();
                }
            }
            else
            {
                if (SP_Divn.Equals("ButtonSearch"))
                {
                    Store1.RemoveAll();
                }
            }
        }

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            this.cdx01_VENDCD.SetValue(string.Empty);
            this.cbo01_DIVISION.Value = "ON-LINE";
            this.cbo01_DIVISION.SelectedItem.Value = "ON-LINE";
            this.cbo01_DIVISION.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_PLANT_GB.SelectedItem.Value = "1";
            this.cbo01_PLANT_GB.UpdateSelectedItems(); //꼭 해줘야한다.
            this.cbo01_LINE_GB.SelectedItem.Value = "1";
            this.cbo01_LINE_GB.UpdateSelectedItems(); //꼭 해줘야한다.
            this.FIELD_NM1.Text = "ITEM";
            this.FIELD_NM2.Text = "ITEM";

            this.Store1.RemoveAll();

            if (this.cbo01_DIVISION.Value.ToString().Equals("ON-LINE"))
            {
                this.txt02_CHASU.Value = "";
                this.df01_QUT_DATE.SetValue(DateTime.Now);
                //2015.02.23 ACL30003과 동일한 날짜초기화 로직 적용.
                //if (DateTime.Now.Hour < 6)
                //{
                //    this.df01_QUT_DATE.SetValue(DateTime.Now.AddDays(-1));
                //}
                //else
                //{
                //    this.df01_QUT_DATE.SetValue(DateTime.Now);
                //}

                initDate();

                this.df01_QUT_DATE.Editable = false;
                this.txt02_CHASU.ReadOnly = true;
            }
            else
            {
                this.txt02_CHASU.Value = "1";
                this.df01_QUT_DATE.SetValue(DateTime.Now);

                this.df01_QUT_DATE.Editable = true;
                this.txt02_CHASU.ReadOnly = false;
            }
        }
        /// <summary>
        /// OpenFileServer   원격지 파일서버에 접근
        /// </summary>
        /// <returns></returns>

        private void FileDown()
        {
            Search_Print("crtTEXT");

            DataSet ds = getFileDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                string strL = this.cbo01_LINE_GB.Value.ToString().Length == 1 ? "0" + this.cbo01_LINE_GB.Value.ToString() : this.cbo01_LINE_GB.Value.ToString();
                string strP = this.cbo01_PLANT_GB.Value.ToString().Length == 1 ? "0" + this.cbo01_PLANT_GB.Value.ToString() : this.cbo01_PLANT_GB.Value.ToString();

                string fileName = String.Format("{0}.txt", strP + strL + "_" + ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));

                this.Page.Response.Clear();
                this.Page.Response.ContentType = "application/vnd.ms-excel"; // "Application/Octet-Stream"
                this.Page.Response.AddHeader("Content-Disposition", "attachment; filename=" + Server.UrlEncode(fileName));

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    string plant = FillBlank2("2", this.cbo01_PLANT_GB.Value.ToString(), 2);              //' 공장
                    string line = FillBlank2("2", this.cbo01_LINE_GB.Value.ToString(), 2);                 //' 라인
                    string dt = FillBlank2("1", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"), 8);   //' 일자
                    string seq = FillBlank2("2", ds.Tables[0].Rows[i][0].ToString(), 4);
                    string trim_no = FillBlank2("1", ds.Tables[0].Rows[i][1].ToString(), 10); //'vid
                    string ord_no = FillBlank2("1", ds.Tables[0].Rows[i][2].ToString(), 8);
                    string lr = FillBlank2("1", ds.Tables[0].Rows[i][3].ToString(), 1);
                    string ln = FillBlank2("1", ds.Tables[0].Rows[i][4].ToString(), 1);
                    string l_no = FillBlank2("2", ds.Tables[0].Rows[i][5].ToString(), 4);
                    string item1 = FillBlank2("1", ds.Tables[0].Rows[i][6].ToString(), 5);
                    string item2 = FillBlank2("1", ds.Tables[0].Rows[i][7].ToString(), 5);
                    string _date = FillBlank2("1", ds.Tables[0].Rows[i][8].ToString(), 8);
                    string time = FillBlank2("1", ds.Tables[0].Rows[i][9].ToString(), 4);

                    string strLine = plant + line + dt + seq + trim_no + ord_no + lr + ln + l_no + item1 + item2 + _date + time + "\r\n";

                    if (i == 0) this.Page.Response.AddHeader("Content-Length", (strLine.Length * ds.Tables[0].Rows.Count).ToString());

                    this.Page.Response.Write(strLine);
                }
                this.Page.Response.Flush();
            }
            else
            {
            }
        }

        //텍스트 파일 공백
        private string FillBlank2(string Kind, string strDATA, int Length)
        {
            string result = "";
            string str = "";
            string blank = "";
            int strlen = 0;

            str = strDATA;

            if (strDATA.Equals(""))
                str = "";

            blank = "";
            strlen = str.Length;
            for (int i = 0; i < Length - strlen; i++)
            {
                blank = blank + " ";
            }

            if (Kind.Equals("1"))
            {
                result = str + blank;
            }
            else if (Kind.Equals("2"))
            {
                result = blank + str;
            }

            return result;
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

        private DataSet Lseq()
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", Util.UserInfo.CorporationCode);
            set.Add("BIZCD", Util.UserInfo.BusinessCode);
            set.Add("PLANT", this.cbo01_PLANT_GB.Value);
            set.Add("LINE", this.cbo01_LINE_GB.Value);
            set.Add("YMD", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));
            set.Add("USER_ID", Util.UserInfo.UserID);
            set.Add("LANG_SET", Util.UserInfo.LanguageShort);

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_LSEQ"), set);
        }

        //BATCH일 경우 출력하기 위한 차수가 올바른 차수인지 확인한다.
        private void Chasu()
        {
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", Util.UserInfo.CorporationCode);
            set.Add("BIZCD", Util.UserInfo.BusinessCode);
            set.Add("CHASU", this.txt01_CHASU_QTY.Text);
            set.Add("PLANT", this.cbo01_PLANT_GB.Value);
            set.Add("LINE", this.cbo01_LINE_GB.Value);
            set.Add("YMD", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));
            set.Add("USER_ID", Util.UserInfo.UserID);
            set.Add("LANG_SET", Util.UserInfo.LanguageShort);

            DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_CHASU"), set);

            string lastLSEQ = "";

            if (ds.Tables[0].Rows.Count > 0)
                lastLSEQ = ds.Tables[0].Rows[0][0].ToString();
            else
                return;

            if (lastLSEQ.Equals("0"))
                return;

            // 차수 계산 출력가능한 차수 이상이면 마지막 차수를 출력하도록 차수를 바꿈
            if (Convert.ToInt32(lastLSEQ) < Convert.ToInt32(this.txt02_CHASU.Text))
                this.txt02_CHASU.Text = lastLSEQ;
        }

        private void ResultDs()
        {
            DataSet result = null;
            result = getDataSet();
            this.Store1.RemoveAll();
            this.Store1.DataSource = result.Tables[0];
            this.Store1.DataBind();
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
            param.Add("CHASU_QTY", this.txt01_CHASU_QTY.Text);
            param.Add("CHASU", this.txt02_CHASU.Text);
            param.Add("DASICNT", _DASICNT);
            param.Add("FIELD_NM1", this.txt01_FIELD_NM1.Text);
            param.Add("FIELD_NM2", this.txt01_FIELD_NM2.Text);
            param.Add("PLANT_GB", this.cbo01_PLANT_GB.Value);
            param.Add("LINE_GB", this.cbo01_LINE_GB.Value);
            param.Add("YMD", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));
            param.Add("DIVISION", this.cbo01_DIVISION.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getFileDataSet()
        {
            HEParameterSet param = new HEParameterSet();

            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("CHASU_QTY", this.txt01_CHASU_QTY.Text);
            param.Add("CHASU", this.txt02_CHASU.Text);
            param.Add("DASICNT", _DASICNT);
            param.Add("FIELD_NM1", this.txt01_FIELD_NM1.Text);
            param.Add("FIELD_NM2", this.txt01_FIELD_NM2.Text);
            param.Add("PLANT_GB", this.cbo01_PLANT_GB.Value);
            param.Add("LINE_GB", this.cbo01_LINE_GB.Value);
            param.Add("YMD", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));
            param.Add("DIVISION", this.cbo01_DIVISION.Value);
            param.Add("USER_ID", this.UserInfo.UserID);
            param.Add("LANG_SET", this.UserInfo.LanguageShort);
            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_FILE"), param);
        }

        /// <summary>
        /// getDataSet
        /// </summary>
        /// <returns></returns>
        private DataSet getReportDataSet(string Plant)
        {
            HEParameterSet param = new HEParameterSet();
            DataSet ds = new DataSet();
            ds = null;

            if (Plant.Equals("!7_MAIN"))
            {
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", Util.UserInfo.BusinessCode);
                param.Add("DT", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));
                param.Add("CHASU", this.txt02_CHASU.Text);
                param.Add("FIELD_NM1", this.txt01_FIELD_NM1.Text);
                param.Add("FIELD_NM2", this.txt01_FIELD_NM2.Text);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("PLANT", this.cbo01_PLANT_GB.Value);
                param.Add("LINE", this.cbo01_LINE_GB.Value);
                param.Add("CHASU_QTY", this.txt01_CHASU_QTY.Text);
                param.Add("USER_ID", this.UserInfo.UserID);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);

                ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PLANT_MAIN"), param);
            }
            else if (Plant.Equals("!7_BOTTOM"))
            {
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", Util.UserInfo.BusinessCode);
                param.Add("FIELD_NM1", this.txt01_FIELD_NM1.Text);
                param.Add("FIELD_NM2", this.txt01_FIELD_NM2.Text);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("PLANT", this.cbo01_PLANT_GB.Value);
                param.Add("LINE", this.cbo01_LINE_GB.Value);
                param.Add("DT", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));
                param.Add("CHASU_QTY", this.txt01_CHASU_QTY.Text);
                param.Add("CHASU", this.txt02_CHASU.Text);
                param.Add("USER_ID", this.UserInfo.UserID);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);

                ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_PLANT_BOTTOM"), param);
            }
            else if (Plant.Equals("7_MAIN"))
            {
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", Util.UserInfo.BusinessCode);
                param.Add("DT", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));
                param.Add("CHASU", this.txt02_CHASU.Text);
                param.Add("FIELD_NM1", this.txt01_FIELD_NM1.Text);
                param.Add("FIELD_NM2", this.txt01_FIELD_NM2.Text);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("PLANT", this.cbo01_PLANT_GB.Value);
                param.Add("LINE", this.cbo01_LINE_GB.Value);
                param.Add("CHASU_QTY", this.txt01_CHASU_QTY.Text);
                param.Add("DASICNT", _DASICNT);
                param.Add("USER_ID", this.UserInfo.UserID);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);

                ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_7PLANT_MAIN"), param);
            }
            else if (Plant.Equals("7_BOTTOM"))
            {
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", Util.UserInfo.BusinessCode);
                param.Add("FIELD_NM1", this.txt01_FIELD_NM1.Text);
                param.Add("FIELD_NM2", this.txt01_FIELD_NM2.Text);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("PLANT", this.cbo01_PLANT_GB.Value);
                param.Add("LINE", this.cbo01_LINE_GB.Value);
                param.Add("DT", ((DateTime)this.df01_QUT_DATE.Value).ToString("yyyyMMdd"));
                param.Add("CHASU_QTY", this.txt01_CHASU_QTY.Text);
                param.Add("DASICNT", _DASICNT);
                param.Add("CHASU", this.txt02_CHASU.Text);
                param.Add("USER_ID", this.UserInfo.UserID);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);

                ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_7PLANT_BOTTOM"), param);
            }

            return ds;
        }

        /// <summary>
        /// Print
        /// </summary>
        private void Print()
        {
            try
            {
                //유효성 검사
                if (!IsQueryValidation()) return;

                Search_Print(ButtonID.Print);


                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);

                //7공장이 아닌 출력물
                if (!this.cbo01_PLANT_GB.Value.Equals("7"))
                {
                    report.ReportName = "1000/SRM_ALC/SRM_ALC30002_N7PLANT";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

                    /* 
                     * 신규 리포트 또는 리포트 컬럼 변동시 디자인용 컬럼정의 XML 파일은 리포트 호출시 
                     * 하기 코드를 이용하여 직접 생성하여 사용하세요 ( 주의. reb 파일을 먼저 report 하위에 생성후 아래 xml 파일을 생성하세요 )
                     * 넘기고자 하는 DataSet 개체의 이름이 ds 라면
                     * ds.Tables[0].TableName = "DATA";
                     * ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
                     * 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                     * */

                    // Main Section ( 메인리포트 파라메터셋 )
                    HERexSection mainSection = new HERexSection();
                    mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                    mainSection.ReportParameter.Add("PLANT_GB", this.cbo01_PLANT_GB.SelectedItem.Text);

                    report.Sections.Add("MAIN", mainSection);

                    // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                    DataSet ds = null;
                    DataSet ds02 = null;

                    ds = getReportDataSet("!7_MAIN");
                    ds02 = getReportDataSet("!7_BOTTOM");

                    // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                    // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                    //ds.Tables[0].TableName = "DATA";
                    //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "_MAIN(!7).xml", XmlWriteMode.WriteSchema);

                    //ds02.Tables[0].TableName = "DATA";
                    //ds02.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "_BOTTOM(!7).xml", XmlWriteMode.WriteSchema);

                    HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                    HERexSection xmlSection02 = new HERexSection(ds02, new HEParameterSet());

                    // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
                    // xmlSection.ReportParameter.Add("CORCD", "1000");
                    report.Sections.Add("XML_MAIN(!7)", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
                    report.Sections.Add("XML_BOTTOM(!7)", xmlSection02); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
                }
                else if (this.cbo01_PLANT_GB.Value.Equals("7"))
                {
                    report.ReportName = "1000/SRM_ALC/SRM_ALC30002_7PLANT";  // /Report 폴더의하의 경로 ( 확장자 .reb 는 제외 ) / 리포트 파일은 법인코드 경로 아래에 모아두도록 함

                    /* 
                     * 신규 리포트 또는 리포트 컬럼 변동시 디자인용 컬럼정의 XML 파일은 리포트 호출시 
                     * 하기 코드를 이용하여 직접 생성하여 사용하세요 ( 주의. reb 파일을 먼저 report 하위에 생성후 아래 xml 파일을 생성하세요 )
                     * 넘기고자 하는 DataSet 개체의 이름이 ds 라면
                     * ds.Tables[0].TableName = "DATA";
                     * ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
                     * 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                     * */

                    // Main Section ( 메인리포트 파라메터셋 )
                    HERexSection mainSection = new HERexSection();
                    mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
                    mainSection.ReportParameter.Add("PLANT_GB", this.cbo01_PLANT_GB.SelectedItem.Text);

                    report.Sections.Add("MAIN", mainSection);

                    // XML Section ( 데이터 커넥션 명 ) / 파라메터 : 데이터셋, 리포트파람(서브리포트파람존재시)
                    DataSet ds = null;
                    DataSet ds02 = null;

                    ds = getReportDataSet("7_MAIN");
                    ds02 = getReportDataSet("7_BOTTOM");

                    // DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
                    // 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
                    //ds.Tables[0].TableName = "DATA";
                    //ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "_MAIN(7).xml", XmlWriteMode.WriteSchema);

                    //ds02.Tables[0].TableName = "DATA";
                    //ds02.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "_BOTTOM(7).xml", XmlWriteMode.WriteSchema);

                    HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
                    HERexSection xmlSection02 = new HERexSection(ds02, new HEParameterSet());

                    // 서브리포트의 리포트파람이 존재할경우 하기와 같이 정의
                    // xmlSection.ReportParameter.Add("CORCD", "1000");
                    report.Sections.Add("XML_MAIN(7)", xmlSection); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
                    report.Sections.Add("XML_BOTTOM(7)", xmlSection02); // 리포트파일의 커넥션 이름과 동일하게 지정하여 섹션에 Add, 커넥션이 여러개일경우 여러개의 커넥션을 지정
                }

                AxReportForm.ShowReport(report);
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
        /// Excel_Export
        /// </summary>
        private void Excel_Export()
        {
            try
            {
                Search_Print(ButtonID.ExcelDL);
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
            //그리드에서 EMPNO
            DataTable dt = new DataTable();
            dt.Columns.Add("TYPENM");
            dt.Columns.Add("OBJECT_ID");
            dt.Rows.Add("ON-LINE", "ON-LINE");
            dt.Rows.Add("BATCH", "BATCH");
            Library.ComboDataBind(this.cbo01_DIVISION, dt, false, false);

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
