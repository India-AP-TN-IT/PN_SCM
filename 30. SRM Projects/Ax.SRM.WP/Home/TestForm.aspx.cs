using System;
using System.Collections.Generic;
using System.Data;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home
{
    public partial class TestForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                this.Store1.DataSource = new List<Company>
             {
                 new Company("3m Co", 71.72, 0.02, 0.03),
                 new Company("Alcoa Inc", 29.01, 0.42, 1.47),
                 new Company("Altria Group Inc", 83.81, 0.28, 0.34),
                 new Company("American Express Company", 52.55, 0.01, 0.02),
                 new Company("American International Group, Inc.", 64.13, 0.31, 0.49),
                 new Company("AT&T Inc.", 31.61, -0.48, -1.54),
                 new Company("Boeing Co.", 75.43, 0.53, 0.71),
                 new Company("Caterpillar Inc.", 67.27, 0.92, 1.39),
                 new Company("Citigroup, Inc.", 49.37, 0.02, 0.04),
                 new Company("E.I. du Pont de Nemours and Company", 40.48, 0.51, 1.28),
                 new Company("Exxon Mobil Corp", 68.1, -0.43, -0.64),
                 new Company("General Electric Company", 34.14, -0.08, -0.23),
                 new Company("General Motors Corporation", 30.27, 1.09, 3.74),
                 new Company("Hewlett-Packard Co.", 36.53, -0.03, -0.08),
                 new Company("Honeywell Intl Inc", 38.77, 0.05, 0.13),
                 new Company("Intel Corporation", 19.88, 0.31, 1.58),
                 new Company("International Business Machines", 81.41, 0.44, 0.54),
                 new Company("Johnson & Johnson", 64.72, 0.06, 0.09),
                 new Company("JP Morgan & Chase & Co", 45.73, 0.07, 0.15),
                 new Company("McDonald\"s Corporation", 36.76, 0.86, 2.40),
                 new Company("Merck & Co., Inc.", 40.96, 0.41, 1.01),
                 new Company("Microsoft Corporation", 25.84, 0.14, 0.54),
                 new Company("Pfizer Inc", 27.96, 0.4, 1.45),
                 new Company("The Coca-Cola Company", 45.07, 0.26, 0.58),
                 new Company("The Home Depot, Inc.", 34.64, 0.35, 1.02),
                 new Company("The Procter & Gamble Company", 61.91, 0.01, 0.02),
                 new Company("United Technologies Corporation", 63.26, 0.55, 0.88),
                 new Company("Verizon Communications", 35.57, 0.39, 1.11),
                 new Company("Wal-Mart Stores, Inc.", 45.45, 0.73, 1.63)
             };

                if (!X.IsAjaxRequest)
                {
                    CellSelectionModel sm = this.GridPanel1.GetSelectionModel() as CellSelectionModel;
                    sm.SelectedCell.ColumnIndex = 1;
                    sm.SelectedCell.RowIndex = 1;
                    // selection by record id and field name working also
                    //sm.SelectedCell.RecordID = "Alcoa Inc";
                    //sm.SelectedCell.ColumnDataIndex = "Price";
                }
            }
        }

        public class Company
        {
            public Company(string name, double price, double change, double pctChange)
            {
                this.Name = name;
                this.Price = price;
                this.Change = change;
                this.PctChange = pctChange;
            }

            public string Name { get; set; }
            public double Price { get; set; }
            public double Change { get; set; }
            public double PctChange { get; set; }
        }

        protected void Cell_Click(object sender, DirectEventArgs e)
        {
            CellSelectionModel sm = this.GridPanel1.GetSelectionModel() as CellSelectionModel;
            this.Label1.Html = string.Format("RecordID: {0}<br />Name: {1}<br />Value: {2}<br />Row: {3}<br />Column: {4}", sm.SelectedCell.RecordID, sm.SelectedCell.ColumnDataIndex, sm.SelectedCell.Value, sm.SelectedCell.RowIndex.ToString(), sm.SelectedCell.ColumnIndex.ToString());
        }

        protected void Clear_Click(object sender, DirectEventArgs e)
        {
            CellSelectionModel sm = this.GridPanel1.GetSelectionModel() as CellSelectionModel;
            sm.Clear();
            sm.UpdateSelection();
            this.Label1.Html = "";
        }

        protected void Set_Click(object sender, DirectEventArgs e)
        {
            CellSelectionModel sm = this.GridPanel1.GetSelectionModel() as CellSelectionModel;
            sm.Clear();
            sm.SelectedCell.ColumnIndex = 2;
            sm.SelectedCell.RowIndex = 2;
            sm.UpdateSelection();
        }
    }
}