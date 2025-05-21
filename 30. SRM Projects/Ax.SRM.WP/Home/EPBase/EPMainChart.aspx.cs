using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Ax.EP.Utility;
using HE.Framework.Core;

namespace Ax.EP.WP.Home.EPBase
{
    /// <summary>
    /// KdlframeChart (메인화면 챠트)
    /// </summary>
    /// <remarks></remarks>
    public partial class EPMainChart : Ax.EP.Utility.BasePage
    {
        private string _title = string.Empty;
        private string _code = string.Empty;
        private string _type = string.Empty;
        private int _index;

        /// <summary>
        /// CTitle Property
        /// </summary>
        public string CTitle
        {
            get { return _title; }
            set { _title = value; }
        }

        /// <summary>
        /// CCode Property
        /// </summary>
        public string CCode
        {
            get { return _code; }
            set { _code = value; }
        }

        /// <summary>
        /// CType Property
        /// </summary>
        public string CType
        {
            get { return _type; }
            set { _type = value; }
        }

        /// <summary>
        /// CIndex Property
        /// </summary>
        public int CIndex
        {
            get { return _index; }
            set { _index = value; }
        }
        /// <summary>
        /// Handles the Load event of the Page control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Page_Load(object sender, EventArgs e)
        {
            CTitle = Request["BizName"];
            CCode = Request["BizCode"];
            CType = Request["type"];
            CIndex = int.Parse(Request["index"]);
            SetDataToHidden();

            HEParameterSet param = new HEParameterSet();
            param.Add("YYYY", DateTime.Now.AddMonths(-1).ToString("yyyy"));
            param.Add("CUSTCD", CCode);

            DataSet ds = EPClientHelper.ExecuteDataSet("APG_KOCOMAIN.PRC_GET_CHART", param, "OUT_CURSOR1", "OUT_CURSOR2", "OUT_CURSOR3");

            DataTable dtChart1 = ds.Tables[0];
            DataTable dtChart2 = ds.Tables[1];
            DataTable dtChart3 = ds.Tables[2];

            //Random rand = new Random();
            DataTable dtChart = new DataTable();
            dtChart.Columns.Add("BizName", typeof(string));
            dtChart.Columns.Add("BizRatio", typeof(string));

            if (CType.Equals("1"))
            {
                long maxValue = 0;

                if (CTitle.Equals(Library.getMessage("MSG-000011")))
                {
                    dtChart.Clear();
                    for (int i = 0; i < dtChart1.Rows.Count; i++)
                    {
                        dtChart.Rows.Add(dtChart1.Rows[i]["CUSTNM"].ToString(), dtChart1.Rows[i]["RCV_RATE"].ToString());
                        if (!dtChart1.Rows[i].IsNull("RCV_RATE") && long.Parse(dtChart1.Rows[i]["RCV_RATE"].ToString()) > maxValue)
                            maxValue = long.Parse(dtChart1.Rows[i]["RCV_RATE"].ToString());
                    }
                }
                else
                {
                    dtChart.Clear();
                    dtChart.Rows.Add(Library.getMessage("MSG-000013"), dtChart1.Rows[CIndex]["RCV_RATE"].ToString());
                    dtChart.Rows.Add(Library.getMessage("MSG-000014"), dtChart1.Rows[CIndex]["ST_UNDELI_RATE"].ToString());
                    dtChart.Rows.Add(Library.getMessage("MSG-000015"), dtChart1.Rows[CIndex]["LT_UNDELI_RATE"].ToString());

                    if (long.Parse(dtChart1.Rows[CIndex]["RCV_RATE"].ToString()) > maxValue) maxValue = long.Parse(dtChart1.Rows[CIndex]["RCV_RATE"].ToString());
                    if (long.Parse(dtChart1.Rows[CIndex]["LT_UNDELI_RATE"].ToString()) > maxValue) maxValue = long.Parse(dtChart1.Rows[CIndex]["LT_UNDELI_RATE"].ToString());
                    if (long.Parse(dtChart1.Rows[CIndex]["LT_UNDELI_RATE"].ToString()) > maxValue) maxValue = long.Parse(dtChart1.Rows[CIndex]["LT_UNDELI_RATE"].ToString());
                }

                if (maxValue < 10)
                    initChart(ChartAll, "Emboss", 20, "%", true, true, dtChart, "0.6", true, CTitle, 5, CType);
                else if (maxValue < 50)
                    initChart(ChartAll, "Emboss", 60, "%", true, true, dtChart, "0.6", true, CTitle, 10, CType);
                else
                    initChart(ChartAll, "Emboss", 100, "%", true, true, dtChart, "0.6", false, CTitle, 20, CType);
            }
            else
            {
                long maxValue = 0;

                if (CTitle.Equals(Library.getMessage("MSG-000011")))
                {
                    dtChart.Clear();
                    for (int i = 0; i < dtChart2.Rows.Count; i++)
                    {
                        dtChart.Rows.Add(dtChart2.Rows[i]["CUSTNM"].ToString(), dtChart2.Rows[i]["SAL_AMT"].ToString());
                        if (!dtChart2.Rows[i].IsNull("SAL_AMT") && long.Parse(dtChart2.Rows[i]["SAL_AMT"].ToString()) > maxValue)
                            maxValue = long.Parse(dtChart2.Rows[i]["SAL_AMT"].ToString());
                    }
                    //initChart(ChartAll, "Emboss", 8000, "", true, true, dtChart, "0.6", false, "", 2000, CType);
                }
                else
                {

                    dtChart.Clear();

                    for (int i = 0; i < 12; i++)
                    { // 0 1 2 3 4
                        if (dtChart3.Rows.Count < i + 1)
                            dtChart.Rows.Add(i + 1 + Library.getMessage("MSG-000012"), 0);
                        else
                        {
                            dtChart.Rows.Add(int.Parse(dtChart3.Rows[i]["MM"].ToString()) + Library.getMessage("MSG-000012"), dtChart3.Rows[i]["SAL_AMT"].ToString());
                            if (!dtChart3.Rows[i].IsNull("SAL_AMT") && long.Parse(dtChart3.Rows[i]["SAL_AMT"].ToString()) > maxValue)
                                maxValue = long.Parse(dtChart3.Rows[i]["SAL_AMT"].ToString());
                        }
                    }
                }

                if (maxValue < 50)
                    initChart(ChartAll, "Emboss", 60, "", true, true, dtChart, "0.6", true, CTitle, 10, CType);
                else if (maxValue < 100)
                    initChart(ChartAll, "Emboss", 120, "", true, true, dtChart, "0.6", true, CTitle, 20, CType);
                else if (maxValue < 500)
                    initChart(ChartAll, "Emboss", 600, "", true, true, dtChart, "0.6", true, CTitle, 100, CType);
                else if (maxValue < 1000)
                    initChart(ChartAll, "Emboss", 1200, "", true, true, dtChart, "0.6", true, CTitle, 200, CType);
                else if (maxValue < 5000)
                    initChart(ChartAll, "Emboss", 6000, "", true, true, dtChart, "0.6", true, CTitle, 1000, CType);
                else if (maxValue < 10000)
                    initChart(ChartAll, "Emboss", 12000, "", true, true, dtChart, "0.6", true, CTitle, 2000, CType);
                else if (maxValue < 50000)
                    initChart(ChartAll, "Emboss", 54000, "", true, true, dtChart, "0.6", true, CTitle, 4000, CType);
                else
                    initChart(ChartAll, "Emboss", ((int.Parse(maxValue.ToString()) / 1000)) * 1000 + 8000, "", true, true, dtChart, "0.6", true, CTitle, 8000, CType);
            }

        }

        private void SetDataToHidden()
        {
            TextFieldTitle.Text = CTitle;
            TextFieldCode.Text = CCode;
            TextFieldType.Text = CType;
            TextFieldIndex.Text = CIndex.ToString();
        }

        /// <summary>
        /// Inits the chart.
        /// </summary>
        /// <param name="ChartAll">The chart all.</param>
        /// <param name="shape">The shape.</param>
        /// <param name="maxHeight">Height of the max.</param>
        /// <param name="typeY">The type Y.</param>
        /// <param name="isLabel">if set to <c>true</c> [is label].</param>
        /// <param name="is3D">if set to <c>true</c> [is3 D].</param>
        /// <param name="dt">The dt.</param>
        /// <param name="barWeight">The bar weight.</param>
        /// <param name="isTitle">if set to <c>true</c> [is title].</param>
        /// <param name="title">The title.</param>
        /// <param name="interVal">The inter val.</param>
        /// <param name="type">The type.</param>
        /// <remarks></remarks>
        private void initChart(System.Web.UI.DataVisualization.Charting.Chart ChartAll, string shape, int maxHeight
                                , string typeY, bool isLabel, bool is3D, DataTable dt, string barWeight, bool isTitle, string title, int interVal, string type)
        {
            ChartAll.Series["SeriesBizName"]["DrawingStyle"] = shape;


            Random rand = new Random();
            //var table = new DataTable();
            //table.Columns.Add("BizName", typeof(string));
            //table.Columns.Add("BizRatio", typeof(string));
            bool isExceed = false;
            double dMaxHeight = 0.0;
            foreach (DataRow drIn in dt.Rows)
            {
                //var row = table.NewRow();
                //row["BizName"] = drIn["BizName"].ToString();
                //row["BizRatio"] = drIn["BizRatio"].ToString();
                //table.Rows.Add(row);

                //if (int.Parse(drIn["BizRatio"].ToString()) > 97 && type.Equals("1"))
                //{
                //    maxHeight = 110;
                //}
                if (int.Parse(drIn["BizRatio"].ToString()) > dMaxHeight)
                {
                    dMaxHeight = Math.Ceiling(double.Parse(drIn["BizRatio"].ToString()) / interVal) * interVal;
                    isExceed = true;
                }

                if (isExceed == false)
                {
                    dMaxHeight = maxHeight;
                }
                //tempMaxRatio = int.Parse(drIn["BizRatio"].ToString());

            }

            ChartAll.ChartAreas["ChartAreaRatio"].AxisY.LabelStyle.Format = (typeY == "%") ? "{0.#}%" : "{0.#}";
            ChartAll.ChartAreas["ChartAreaRatio"].AxisY.Maximum = dMaxHeight;
            ChartAll.ChartAreas["ChartAreaRatio"].AxisY.Minimum = 0;
            ChartAll.ChartAreas["ChartAreaRatio"].Area3DStyle.Enable3D = is3D;
            ChartAll.ChartAreas["ChartAreaRatio"].AxisY.Interval = interVal;

            ChartAll.Series["SeriesBizName"].IsValueShownAsLabel = isLabel;
            ChartAll.Series["SeriesBizName"].LabelFormat = (typeY == "%") ? "{0.#}%" : "{0.#}";
            ChartAll.Series["SeriesBizName"].LabelForeColor = System.Drawing.Color.Black;
            ChartAll.Series["SeriesBizName"].LabelBackColor = System.Drawing.Color.Transparent;
            ChartAll.Series["SeriesBizName"]["PointWidth"] = barWeight;

            if (isTitle == true)
            {
                ChartAll.ChartAreas["ChartAreaRatio"].AxisX.Title = title;
            }

            //    ChartAll.ChartAreas("Default").Area3DStyle.Inclination = 20
            //ChartAll.ChartAreas("Default").Area3DStyle.Enable3D = True
            //ChartAll.ChartAreas("Default").Area3DStyle.LightStyle = LightStyle.Realistic
            //ChartAll.ChartAreas("Default").Area3DStyle.Rotation = 45
            //ChartAll.ChartAreas("Default").BackGradientStyle = GradientStyle.DiagonalRight

            ChartAll.DataSource = dt;
            ChartAll.DataBind();
        }

        /// <summary>
        /// ChartAll_Click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ChartAll_Click(object sender, ImageMapEventArgs e)
        {

            string[] setValues = new string[]{
                        CTitle,
                        CCode,
                        CType,
                        CIndex.ToString()
                    };
            X.Js.Call("NewChart", Util.UserInfo.UserID, true, "", setValues);

        }
    }
}