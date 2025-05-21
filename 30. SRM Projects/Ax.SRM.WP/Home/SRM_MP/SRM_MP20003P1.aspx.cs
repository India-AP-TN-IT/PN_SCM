#region ▶ Description & History
/* 
 * 프로그램명 : 일괄등록     [D2](구.VG3070P1)
 * 설      명 : 
 * 최초작성자 : 이현범
 * 최초작성일 : 2014-09-23
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
using System.Linq;
using System.Web;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MP
{
    public partial class SRM_MP20003P1 : BasePage
    {
        #region [ 초기설정 ]
        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_MP20003P1()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = false;
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
                if (!IsPostBack)
                {
                    this.txt01_ID.Text = HttpUtility.ParseQueryString(Request.Url.Query).Get("ID");

                    string sQuery = Request.Url.Query;

                    txt01_VENDCD.Text = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");
                    chk01_EMPNO.Checked = true;

                    getDataSetBind();
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
        #endregion

        #region [ 버튼설정 ]
        /// <summary>
        /// BuildButtons
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            //MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Confirm, ButtonImage.Confirm, "Confirm", this.ButtonPanel);
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
            if (id.Equals(ButtonID.Confirm))
            {
                //저장시 모든 데이터 넘겨받도록함.
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues(false)", Mode = ParameterMode.Raw, Encode = true });
            }
            container.Add(ibtn);

        }
        #endregion

        #region [이벤트]
        /// <summary>
        /// Button_Click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public override void Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.ImageButton ibtn = (Ext.Net.ImageButton)sender;
            switch (ibtn.ID)
            {
                case ButtonID.Confirm:
                    Confirm(e);
                    break;
                case ButtonID.Reset:
                    Reset();
                    break;		

                default: break;
            }
        }

        /// <summary>
        /// Reset 초기화
        /// </summary>
        public void Reset()
        {
            this.chk01_EMPNO.Checked = false;
            this.chk01_DELI_DATE.Checked = false;
            this.df01_DELI_DATE.SetValue("");

            getDataSetBind();
        }

        #endregion

        #region [함수]
        private void getDataSetBind()
        {
            DataSet ds = null;

            HEParameterSet param = new HEParameterSet();
            param.Add("VENDCD", txt01_VENDCD.Text);
            param.Add("USER_ID", Util.UserInfo.UserID);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);

            ds = EPClientHelper.ExecuteDataSet("APG_SRM_MP20003.INQUERY_POPUP", param);

            if (ds.Tables[0].Rows.Count <= 0)
                return;

            this.Store1.DataSource = ds.Tables[0];
            this.Store1.DataBind();
        }

        public void Confirm(DirectEventArgs e)
        {
            string json = e.ExtraParams["Values"];
            Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

            string CHR_NM = "";
            string CHR_TEL = "";

            int idx = 0;
            int data_cnt = 0;

            if (this.chk01_EMPNO.Checked == true)
            {
                for (int i = 0; i < parameter.Count(); i++)
                {
                    if (parameter[i]["CHR_CHK"].Equals("1") || parameter[i]["CHR_CHK"].Equals("true"))
                    {
                        idx = i;
                        data_cnt += 1;
                    }
                }

                if (data_cnt > 0)
                {
                    CHR_NM = parameter[idx]["CHR_NM"];
                    CHR_TEL = parameter[idx]["CHR_TEL"];
                }
                else
                {
                    this.chk01_EMPNO.Checked = false;
                }

                try
                {
                    if (df01_DELI_DATE.Value.ToString() == null && df01_DELI_DATE.Value.ToString().Equals(""))
                    {
                        this.chk01_DELI_DATE.Checked = false;
                    }
                }
                catch
                {
                    this.chk01_DELI_DATE.Checked = false;
                }
            }

            string result = "";

            if (this.chk01_EMPNO.Checked == true && this.chk01_DELI_DATE.Checked == true)
            {
                result = "1";
            }
            else if (this.chk01_EMPNO.Checked == true && this.chk01_DELI_DATE.Checked == false)
            {
                result = "2";
            }
            else if (this.chk01_EMPNO.Checked == false && this.chk01_DELI_DATE.Checked == true)
            {
                result = "3";
            }

            X.Js.Call("parent.fn_MP20003", this.txt01_ID.Text, CHR_NM, CHR_TEL, ((DateTime)df01_DELI_DATE.Value).ToString("yyyy-MM-dd"), result);
        }
        #endregion
    }
}