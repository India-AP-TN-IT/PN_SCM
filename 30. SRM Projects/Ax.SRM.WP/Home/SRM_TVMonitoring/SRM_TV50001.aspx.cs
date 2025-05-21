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
using System.Threading;

using System.Configuration;
using System.ServiceModel.Configuration;

namespace Ax.SRM.WP.Home.SRM_TVMonitoring
{
    public partial class SRM_TV50001 : BasePage
    {
        private string pakageName = "MES.PKG_TVOUT_SHIFT_UPH_BYLINE";
        private int m_ReloadTime = 10;
        public static int m_remain = 9;

        public SRM_TV50001()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = true;
        }

        #region [ Buttons ]
        /// <summary>
        /// BuildButtons 
        /// 버튼생성
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
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
                case ButtonID.Close:
                    X.Js.Call("closeTab");
                    break;
                default: break;
            }
        }

        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!X.IsAjaxRequest)
                {
                    Reset();
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

        public void Search()
        {
            try
            {
                this.ResourceManager1.AjaxTimeout = Util.GetSendTimeOut(Server.MapPath("/"));

                DataTable dt = getDataSet().Tables[0];
                int iCurHour = Convert.ToInt16(getSVRTime().Hour);
                this.InitData(iCurHour, ref dt);

                this.Store1.DataSource = dt;
                this.Store1.DataBind();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {
            }
        }
        public void Reset()
        {
            this.df02_WORK_DATE.SetValue(DateTime.Now);
            this.Grid01.Show();
            this.Store1.RemoveAll();
        }


        [DirectMethod()]
        public DateTime getSVRTime()
        {
            DateTime tDate = DateTime.Now;
            try
            {
                HEParameterSet param = new HEParameterSet();
                DataSet ds = EPClientHelper.ExecuteDataSet("PKG_COM.GET_SVR_TIME", param);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    tDate = DateTime.ParseExact(ds.Tables[0].Rows[0]["SVRTIME"].ToString(), "yyyy-MM-dd HH:mm:ss", System.Globalization.CultureInfo.CurrentUICulture);
                }
            }
            catch
            {
            }
            return tDate;
        }
        private DataSet getDataSet()
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CORCD", Util.UserInfo.CorporationCode);
            param.Add("BIZCD", Util.UserInfo.BusinessCode);
            param.Add("YMD", ((DateTime)this.df02_WORK_DATE.Value).ToString("yyyy-MM-dd"));
            param.Add("VINCD", "SP2I");

            string procedure = "GET_SHIFT_UPH_BYLINE";

            return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);
        }


        private void InitData(int iCurHour, ref DataTable dt)
        {
            string selDate = ((DateTime)this.df02_WORK_DATE.Value).ToString("yyyy-MM-dd");
            string curDate = getSVRTime().ToString("yyyy-MM-dd");

            if (selDate != curDate) iCurHour = 7;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                int iUPH = 0;
                int iUnit = 0;
                int iSumH = 0;
                int iSumSH1 = 0;
                int iSumSH2 = 0;
                int iSumSH3 = 0;
                int iTAVG = 0;
                int iSH1 = 0;
                int iSH2 = 0;
                int iSH3 = 0;

                int.TryParse(Convert.ToString(dt.Rows[i]["UPH"]), out iUPH);

                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    DataColumn col = dt.Columns[j];
                    string colName = col.ColumnName;
                    if (colName.StartsWith("TOT"))
                    {
                        string sLineNm = Convert.ToString(dt.Rows[i]["LINE"]);
                        int hour = Convert.ToInt16(colName.Replace("TOT_", ""));
                        bool isNum = int.TryParse(Convert.ToString(dt.Rows[i][j]), out iUnit);

                        iTAVG += iUnit;
                        if (08 <= hour && hour <= 16) iSH1 += iUnit;
                        if (17 <= hour && hour <= 24) iSH2 += iUnit;
                        if (01 <= hour && hour <= 07) iSH3 += iUnit;

                        if (8 <= iCurHour && iCurHour <= 16)
                        {
                            if (hour <= iCurHour && hour >= 8) iSumSH1++;
                        }
                        else if (17 <= iCurHour && iCurHour <= 24)
                        {
                            iSumSH1 = 9;
                            if (hour <= iCurHour && hour >= 17) iSumSH2++;
                        }
                        else if (1 <= iCurHour && iCurHour <= 7)
                        {
                            iSumSH1 = 9;
                            iSumSH2 = 8;
                            if (hour <= iCurHour && hour >= 1) iSumSH3++;
                        }

                        if (iUnit == 0)
                        {
                            if (iCurHour > 0 && iCurHour < 8)
                            {
                                if (hour > iCurHour && hour < 8)
                                {
                                    dt.Rows[i][j] = DBNull.Value;
                                }
                            }
                            else
                            {
                                if (hour > iCurHour || hour < 8)
                                {
                                    dt.Rows[i][j] = DBNull.Value;
                                }
                            }
                        }
                    }
                }

                iSumH = iSumSH1 + iSumSH2 + iSumSH3;
                int dGAVG = iSumH == 0 ? 0 : (iTAVG / iSumH);
                int dAVG1 = iSumSH1 == 0 ? 0 : (iSH1 / iSumSH1);
                int dAVG2 = iSumSH2 == 0 ? 0 : (iSH2 / iSumSH2);
                int dAVG3 = iSumSH3 == 0 ? 0 : (iSH3 / iSumSH3);

                dt.Rows[i]["GAVG"] = dGAVG;// FX.Utils.Glb_FNS.GetO2D(iTAVG / iSumH);
                dt.Rows[i]["AVG1"] = dAVG1;// FX.Utils.Glb_FNS.GetO2D(iSH1 / iSumH);
                dt.Rows[i]["AVG2"] = dAVG2;// FX.Utils.Glb_FNS.GetO2D(iSH2 / iSumH);
                dt.Rows[i]["AVG3"] = dAVG3;// FX.Utils.Glb_FNS.GetO2D(iSH3 / iSumH);
            }
        }
        protected void refresh_Time(object sender, DirectEventArgs e)
        {
            this.txt01_timer.Text = m_remain.ToString("N0") + " / " + m_ReloadTime.ToString("N0");
            if (m_remain >= m_ReloadTime)
            {
                X.Js.Call("UI_Shown");
                Search();
                m_remain = 0;
            }
            m_remain++;

        }
    }
}