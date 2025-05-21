using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using Ext.Net;
using Ax.EP.Utility.Security;
using HE.Framework.Core;
using TheOne.Configuration;

namespace Ax.EP.UI
{
    /// <summary>
    /// EPGridView 정의 ( ExcelExport 에 이용되는 GridView 재정의 )
    /// <remarks>System.Web.UI.Control.GridView 에 columnModel 기능 추가</remarks>
    /// </summary>
    public class EPGridView : System.Web.UI.WebControls.GridView
    {
        public const string SPLITER = "!|!";

        // 멀티헤더를 위한 컬럼모델 정의
        private Ext.Net.ItemsCollection<ColumnBase> columnModel = new ItemsCollection<ColumnBase>();

        public EPGridView()
            : base()
        {
            this.RowDataBound += new GridViewRowEventHandler(EPGridView_RowDataBound);
        }

        #region 컬럼모델에 헤더 추가 
        /// <summary>
        /// HeaderAdd
        /// </summary>
        /// <param name="headerText"></param>
        /// <returns></returns>
        public Column HeaderAdd(string headerText)
        {
            return HeaderAdd(columnModel, headerText);
        }

        /// <summary>
        /// HeaderAdd
        /// </summary>
        /// <param name="columns"></param>
        /// <param name="headerText"></param>
        /// <returns></returns>
        public Column HeaderAdd(ItemsCollection<ColumnBase> columns, string headerText)
        {
            Column col = new Column();
            col.Text = headerText;
            
            columns.Add(col);

            return col;
        }
        #endregion

        #region 컬럼 제어 유틸리티
        /// <summary>
        /// getColumnCount 전체 컬럼개수
        /// </summary>
        /// <param name="columns"></param>
        /// <returns></returns>
        private int getColumnCount(ItemsCollection<ColumnBase> columns)
        {
            int cols = 0;

            foreach (Column col in columns)
            {
                if (col.Columns.Count > 0)
                    cols += this.getColumnCount(col.Columns);
                else
                    cols++;
            }

            return cols;
        }
        /*
        /// <summary>
        /// getRowCount 전체 로우개수  ( 문제있음 동작안됨 )
        /// </summary>
        /// <param name="columns"></param>
        /// <returns></returns>
        private int getRowCount(ItemsCollection<ColumnBase> columns)
        {
            int rows = 1;

            foreach (Column col in columns)
            {
                int count = 1;

                if (col.Columns.Count > 0)
                    count += this.getRowCount(col.Columns);

                if (count > rows) rows = count;
            }

            return rows;
        }
        */
        #endregion

        #region 멀티헤더 생성
        /// <summary>
        /// EPGridView_RowDataBound 컬럼 헤더를 생성한다.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void EPGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                if (columnModel.Count > 0)
                {
                    // 헤더 정보 만들기
                    SortedList header1 = new SortedList();
                    SortedList header2 = new SortedList();
                    SortedList header3 = new SortedList();
                    SortedList header4 = new SortedList();

                    int level = 0;

                    for (int i = 0; i < columnModel.Count; i++)
                    {
                        level = (level < 1 ? 1 : level);

                        int cols = getColumnCount(columnModel[i].Columns);
                        if (cols == 0) cols = 1;

                        header1.Add(i * 1000000, columnModel[i].Text + SPLITER + cols.ToString() + SPLITER + "1");

                        if (columnModel[i].Columns.Count > 0)
                        {
                            for (int j = 0; j < columnModel[i].Columns.Count; j++)
                            {
                                level = (level < 2 ? 2 : level);
                                cols = getColumnCount(columnModel[i].Columns[j].Columns);
                                if (cols == 0) cols = 1;

                                header2.Add(i * 1000000 + j * 10000, columnModel[i].Columns[j].Text + SPLITER + cols.ToString() + SPLITER + "1");

                                if (columnModel[i].Columns[j].Columns.Count > 0)
                                {
                                    for (int k = 0; k < columnModel[i].Columns[j].Columns.Count; k++)
                                    {
                                        level = (level < 3 ? 3 : level);
                                        cols = getColumnCount(columnModel[i].Columns[j].Columns[k].Columns);
                                        if (cols == 0) cols = 1;

                                        header3.Add(i * 1000000 + j * 10000 + k * 100, columnModel[i].Columns[j].Columns[k].Text + SPLITER + cols.ToString() + SPLITER + "1");

                                        if (columnModel[i].Columns[j].Columns[k].Columns.Count > 0)
                                        {
                                            for (int z = 0; z < columnModel[i].Columns[j].Columns[k].Columns.Count; z++)
                                            {
                                                level = (level < 4 ? 4 : level);
                                                cols = getColumnCount(columnModel[i].Columns[j].Columns[k].Columns[z].Columns);
                                                if (cols == 0) cols = 1;

                                                header4.Add(i * 1000000 + j * 10000 + k * 100 + z * 1, columnModel[i].Columns[j].Columns[k].Columns[z].Text + SPLITER + cols.ToString() + SPLITER + "1");
                                            }
                                        }
                                        else
                                        {
                                            header3[i * 1000000 + j * 10000 + k * 100] = columnModel[i].Columns[j].Columns[k].Text + SPLITER + cols.ToString() + SPLITER + "$$$$$2";
                                        }
                                    }
                                }
                                else
                                {
                                    header2[i * 1000000 + j * 10000] = columnModel[i].Columns[j].Text + SPLITER + cols.ToString() + SPLITER + "$$$$$3";
                                }
                            }
                        }
                        else
                        {
                            header1[i * 1000000] = columnModel[i].Text + SPLITER + cols.ToString() + SPLITER + "$$$$$4";
                        }
                    }

                    // 헤더정보 머지 처리 
                    int step = 4 - (level);

                    // 실제 멀티헤더 생성
                    if (level >= 4) GetMyMultiHeader(e, header4, step);
                    if (level >= 3) GetMyMultiHeader(e, header3, step);
                    if (level >= 2) GetMyMultiHeader(e, header2, step);
                    if (level >= 1) GetMyMultiHeader(e, header1, step);
                }
             }
        }
        #endregion

        #region Refactoring the MultiHeader
        /// <summary>
        /// Gets my multi header.
        /// </summary>
        /// <param name="e">The <see cref="T:System.Web.UI.WebControls.GridViewRowEventArgs"/> instance containing the event data.</param>
        /// <param name="GetCels">The get cels. is sorted list that contain the cells the key is the position of the cell and the valu is a comma delemeted 
        ///  data to hold the cell information , index 0 is for the Content of the cell m index 1 is the coms span , index 2 is the row span 
        ///  pleas dont leav the colmn span and rowspan empty</param>
        private static void GetMyMultiHeader(GridViewRowEventArgs e, SortedList GetCels, int step)
        {

            if (e.Row.RowType == DataControlRowType.Header)
            {
                GridViewRow HeaderRow;
                IDictionaryEnumerator enumCels = GetCels.GetEnumerator();

                HeaderRow = new GridViewRow(-1, -1, DataControlRowType.Header, DataControlRowState.Normal);
                while (enumCels.MoveNext())
                {
                    string[] cont = enumCels.Value.ToString().Split(new string[] { SPLITER }, StringSplitOptions.None);
                    if (cont[2].StartsWith("$$$$$")) cont[2] = (Convert.ToInt16(cont[2].Substring(5)) - step).ToString();

                    TableCell Cell = new TableCell();
                    Cell.RowSpan = Convert.ToInt16(cont[2].ToString());
                    Cell.ColumnSpan = Convert.ToInt16(cont[1].ToString());
                    Cell.Controls.Add(new LiteralControl(cont[0].ToString()));

                    Cell.HorizontalAlign = HorizontalAlign.Center;
                    Cell.Height = 25;
                    Cell.BackColor = System.Drawing.Color.FromArgb(0, 112, 192);
                    Cell.ForeColor = System.Drawing.Color.White;
                    Cell.Font.Bold = true;

                    HeaderRow.Cells.Add(Cell);
                }

                e.Row.Parent.Controls.AddAt(0, HeaderRow);
            }
        }
        #endregion
    }
}
