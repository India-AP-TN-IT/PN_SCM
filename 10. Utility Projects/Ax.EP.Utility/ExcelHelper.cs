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
using Ax.EP.UI;


namespace Ax.EP.Utility
{
    /// <summary>
    /// ExcelHelper
    /// </summary>
    public static class ExcelHelper
    {
        #region Property
        /// <summary>
        /// Excel Import Property mode ( 읽을때 파일 모드 )
        /// </summary>
        public enum Mode
        {
            /// <summary>
            /// 생성, 글쓰기 모드
            /// </summary>
            New,
            /// <summary>
            /// 수정모드
            /// </summary>
            Modify,
            /// <summary>
            /// 읽기 전용 모드
            /// </summary>
            Read,
            /// <summary>
            /// 읽기전용
            /// </summary>
            ReadOnly
        }
        #endregion

        #region Excel Import Helper
        /// <summary>
        /// Query Templete
        /// </summary>
        private const string Query = "SELECT * FROM [{0}$]";

        /// <summary>
        /// XLSConnectionString
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="hdr"></param>
        /// <param name="imex"></param>
        /// <returns></returns>
        public static string XLSConnectionString(string fileName, string hdr="YES", string imex="1")
        {
            FileInfo fi = new FileInfo(fileName);
            string ext = fi.Extension.ToLower();
            string conString = string.Empty;
            if (ext.Equals(".xls"))
            {
                // 엑셀 파일 2003 이전 버전
                //conString = @"Provider=Microsoft.Jet.OLEDB.4.0; Data Source=" + fileName + ";Extended Properties='Excel 8.0;HDR="+hdr+";IMEX="+imex+";'";
                conString = @"Provider=Microsoft.ACE.OLEDB.12.0; Data Source=" + fileName + ";Extended Properties='Excel 8.0;HDR=" + hdr + ";IMEX=" + imex + ";'";
            }
            else
            {
                // 엑셀 2007 버전 
                conString = @"Provider=Microsoft.ACE.OLEDB.12.0; Data Source=" + fileName + "; Extended Properties='Excel 12.0;HDR=" + hdr + ";IMEX=" + imex + ";'";
            }
            return conString;
        }

        /// <summary>
        /// XlsToDataTable
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="field"></param>
        /// <param name="hdr"></param>
        /// <param name="imex"></param>
        /// <param name="range"></param>
        /// <returns></returns>
        public static DataTable XlsToDataTable(string fileName, string field, string hdr, string imex, string range)
        {
            string conString = XLSConnectionString(fileName, hdr, imex);
            string query = string.Empty;

            DataSet ds = new DataSet();

            OleDbConnection oleDBCon = null;
            OleDbDataAdapter oleAdapter = null;
            //OleDbDataAdapter oleDBCom = null;
            //OleDbDataReader oleDBReader = null;
            try
            {
                oleDBCon = new OleDbConnection(conString);

                oleDBCon.Open();

                DataTable sheetTable = oleDBCon.GetSchema("Tables");
                if (sheetTable.Rows.Count > 0)
                {
                    DataRow rowSheetName = sheetTable.Rows[0];

                    for (int i = 0; i < sheetTable.Rows.Count; i++)
                    {
                        rowSheetName = sheetTable.Rows[i];

                        if (rowSheetName["TABLE_NAME"].ToString().IndexOf("Print_Titles") >= 0 ||
                            rowSheetName["TABLE_NAME"].ToString().IndexOf("Print_Area") >= 0 ||
                            rowSheetName["TABLE_NAME"].ToString().IndexOf("FilterDatabase") >= 0)
                        {
                            continue;
                        }
                        else
                            break;
                    }

                    if (rowSheetName != null)
                    {
                        String sheetName = rowSheetName["TABLE_NAME"].ToString();

                        if (!field.Equals(string.Empty))
                        {
                            query = "SELECT * FROM [" + sheetName + "] Where " + field + " <> ''";
                        }
                        else
                        {
                            query = "SELECT * FROM [" + sheetName + "]";
                        }
                        oleAdapter = new OleDbDataAdapter(query, oleDBCon);
                        oleAdapter.Fill(ds);
                        //oleDBReader = oleDBCom.ExecuteReader(CommandBehavior.CloseConnection);
                        //dtData.Load(oleDBReader);
                    }
                    else
                        throw new Exception("Not found data sheet");
                }
            }
            catch (Exception e) { System.Diagnostics.Debug.WriteLine("Util.XlsToDataTable():" + e.Message); }
            finally
            {
                if (oleDBCon.State == ConnectionState.Open) oleDBCon.Close();
            }
            return ds.Tables[0];
        }

        /// <summary>
        /// XlsToDataTable
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="field"></param>
        /// <param name="hdr"></param>
        /// <param name="imex"></param>
        /// <returns></returns>
        public static DataTable XlsToDataTable(string fileName, string field, string hdr, string imex)
        {
            return XlsToDataTable(fileName, field, hdr, imex, string.Empty);
        }

        /// <summary>
        /// XlsToDataTable
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="field"></param>
        /// <returns></returns>
        public static DataTable XlsToDataTable(string fileName, string field)
        {
            return XlsToDataTable(fileName, field, "YES", "1", string.Empty);
        }

        /// <summary>
        /// XlsToDataTable
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static DataTable XlsToDataTable(string fileName)
        {
            return XlsToDataTable(fileName, "PARTNO", "YES", "1", string.Empty);
        }

        /// <summary>
        /// ReadSheet
        /// </summary>
        /// <param name="FileName"></param>
        /// <param name="SheetName"></param>
        /// <returns></returns>
        private static DataSet ReadSheet(string FileName, string SheetName)
        {
            string connectionString = ExcelHelper.XLSConnectionString(FileName);
            string query = string.Format(Query, SheetName);

            OleDbConnection oleDBCon = null;
            OleDbCommand oleDBCom = null;
            OleDbDataAdapter oleDBAdpt = null;

            try
            {
                oleDBCon = new OleDbConnection(connectionString);
                oleDBCom = new OleDbCommand(query, oleDBCon);
                oleDBAdpt = new OleDbDataAdapter(oleDBCom);

                DataSet returnValue = new DataSet();

                oleDBAdpt.Fill(returnValue);

                return returnValue;
            }
            finally
            {
                oleDBAdpt.Dispose();
                oleDBAdpt = null;

                oleDBCom.Dispose();
                oleDBCom = null;

                if (oleDBCon.State != ConnectionState.Closed)
                {
                    oleDBCon.Close();
                }
                oleDBCon.Dispose();
                oleDBCon = null;
            }
        }

        /// <summary>
        /// ReadSheet
        /// </summary>
        /// <param name="m_File"></param>
        /// <param name="SheetName"></param>
        /// <returns></returns>
        public static DataSet ReadSheet(FileUploadField m_File, string SheetName)
        {
            string server_file = string.Empty;
            try
            {
                server_file = Path.Combine(HttpContext.Current.Server.MapPath("/Uploads/"), Util.UserInfo.UserID + m_File.PostedFile.FileName.Substring(m_File.FileName.LastIndexOf("\\") + 1));

                if (m_File.PostedFile.ContentLength > 0)
                {
                    m_File.PostedFile.SaveAs(server_file);
                }

                return ExcelHelper.ReadSheet(server_file, SheetName);
            }
            finally
            {
                if (server_file != string.Empty)
                    System.IO.File.Delete(server_file);
            }
        }
        #endregion

        #region Excel Export Helper
        /// <summary>
        ///  ExportExcel(그리드 정보대로 엑셀 변환함.) 배명희
        /// </summary>
        /// <param name="page"></param>
        /// <param name="Exceldt"></param>
        /// <param name="grid"></param>
        public static void ExportExcel(Page page, DataTable Exceldt, GridPanel grid)
        {
            ExcelHelper.ExportExcel(page, Exceldt, false, "", true, grid);
        }
        /// <summary>
        /// ExportExcel
        /// </summary>
        /// <param name="page"></param>
        /// <param name="Exceldt"></param>
          
        public static void ExportExcel(Page page, DataTable Exceldt)
        {   
            ExcelHelper.ExportExcel(page, Exceldt, false, "", true);
        }

        /// <summary>
        /// ExportExcel
        /// </summary>
        /// <param name="page"></param>
        /// <param name="Excelds"></param>
        public static void ExportExcel(Page page, DataSet Excelds)
        {
            ExcelHelper.ExportExcel(page, Excelds.Tables[0], false, "", true);
        }


        /// <summary>
        /// ExportExcel
        /// </summary>
        /// <param name="page"></param>
        /// <param name="Exceldt"></param>
        /// <param name="AllText"></param>
           
        public static void ExportExcel(Page page, DataTable Exceldt, bool AllText)
        {
            ExcelHelper.ExportExcel(page, Exceldt, AllText, "", true);
        }

        /// <summary>
        /// ExportExcel
        /// </summary>
        /// <param name="page"></param>
        /// <param name="Excelds"></param>
        /// <param name="AllText"></param>
        public static void ExportExcel(Page page, DataSet Excelds, bool AllText)
        {
            ExcelHelper.ExportExcel(page, Excelds.Tables[0], AllText, "", true);
        }

        //텍스트 스타일 지정 처리
        private static void SetTextStyle(string columnName, BoundField column, bool AllText)
        {
            if (columnName.IndexOf("DATE") >= 0 || columnName.IndexOf("YYMM") >= 0 || columnName.IndexOf("YY_MM") >= 0 ||
                               columnName.IndexOf("YMD") >= 0 || columnName.IndexOf("날짜") >= 0 || columnName.IndexOf("일자") >= 0 ||
                               columnName.IndexOf("LOTNO") >= 0 || columnName.IndexOf("LOT_NO") >= 0 || columnName.IndexOf("CHR_") >= 0 ||
                               columnName.IndexOf("년월") >= 0 || columnName.IndexOf("시작일") >= 0 || columnName.IndexOf("종료일") >= 0 ||
                               columnName.IndexOf("납품기한") >= 0 || columnName.IndexOf("CORCD") >= 0 || columnName.IndexOf("BIZCD") >= 0 ||
                               columnName.IndexOf("CUSTCD") >= 0 || columnName.IndexOf("VENDCD") >= 0 || columnName.IndexOf("VEND_CD") >= 0 ||
                               (columnName.IndexOf("UNIT") >= 0 && columnName.IndexOf("QTY") <  0) || columnName.IndexOf("VINCD") >= 0 || columnName.IndexOf("ITEMCD") >= 0 ||
                               columnName.IndexOf("CASENO") >= 0 || columnName.IndexOf("CASECD") >= 0 || columnName.IndexOf("INVOICE_NO") >= 0 ||
                               columnName.IndexOf("ORDER_NO") >= 0 || columnName.IndexOf("BARCODE") >= 0 || columnName.IndexOf("HS_CD") >= 0 ||
                               columnName.IndexOf("CUST_CD") >= 0 || columnName.IndexOf("PARTNO") >= 0 || columnName.IndexOf("PARTNM") >= 0 ||
                               columnName.IndexOf("CONT_NO") >= 0 || columnName.IndexOf("SEAL_NO") >= 0 || columnName.IndexOf("CASE_NO") >= 0 ||
                               columnName.IndexOf("NOTE_NO") >= 0 || columnName.IndexOf("TRANS_NO") >= 0 || columnName.IndexOf("EMPNO") >= 0 ||
                               columnName.IndexOf("SAL_SEQ") >= 0 || columnName.IndexOf("OUT_NO") >= 0 || columnName.IndexOf("PARTNO") >= 0 ||
                               columnName.IndexOf("REMARK") >= 0 || columnName.IndexOf("RCVNO") >= 0 || columnName.IndexOf("ACPNO") >= 0 ||
                               columnName.IndexOf("ORDNO") >= 0 || columnName.IndexOf("TIME") >= 0 || columnName.IndexOf("ACPNO") >= 0 ||
                               columnName.IndexOf("DELI_NOTE") >= 0 || //납품서번호 항목 추가함. 2019-09-05
                               columnName.IndexOf("CANCEL_DELI_NOTE") >= 0 || //취소납품서번호 항목 추가함. 2019-09-06 LYZ
                           AllText)
            {
                column.ItemStyle.CssClass = "cssDate";

                if (columnName.IndexOf("PARTNO") < 0 && columnName.IndexOf("PARTNM") < 0 && columnName.IndexOf("CUSTNM") < 0 && columnName.IndexOf("VENDNM") < 0)
                    column.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            }
        }

        /// <summary>
        /// 엑셀 export시 컬럼 헤더명을 가져오기 위한 재귀메서드
        /// </summary>
        /// <param name="headerNode"></param>
        /// <param name="children"></param>
        /// <param name="arr"></param>
        /// <param name="AllText"></param>
        private static void Repeat(EPGridView gridView, Column headerNode, ItemsCollection<ColumnBase> children, ArrayList arr, bool AllText, DataTable excelTable)
        {
            for ( int i = 0; i< children.Count; i++ )
            {
                if (children[i].Columns.Count > 0)
                {
                    Column col = gridView.HeaderAdd(headerNode.Columns, children[i].Text);
                    Repeat(gridView, col, children[i].Columns, arr, AllText, excelTable);
                }
                else
                {
                    if (children[i].DataIndex == null) continue;
                    if (!excelTable.Columns.Contains(children[i].DataIndex)) continue;

                    BoundField column = new BoundField();

                    column.DataField = children[i].DataIndex; 
                    column.HeaderText = children[i].Text;
                    
                    SetTextStyle(children[i].DataIndex, column, AllText);
                    
                    arr.Add(column);

                    gridView.HeaderAdd(headerNode.Columns, children[i].Text);
                }
            }
        }
        /// <summary>
        /// ExportExcel(다국어 처리)
        /// 기존의 ExportExcel과 동일한데, Exceldt로부터 컬럼 정보를 생성하는 것이 아니라, 그리드로부터 컬럼정보 생성하도록 구현함.
        /// 배명희
        /// </summary>
        /// <param name="page"></param>
        /// <param name="Exceldt"></param>
        /// <param name="AllText"></param>
        /// <param name="fileName"></param>
        /// <param name="isHeader"></param>
        /// <param name="grid"></param>
        public static void ExportExcel(Page page, DataTable Exceldt, bool AllText, string fileName, bool isHeader, GridPanel grid)
        {
            EPGridView GV = new EPGridView();

            bool isRowNumberCol = false;
            ArrayList arrColumn = new ArrayList();

            for (int i = 0; i < grid.ColumnModel.Columns.Count; i++)
            {
                string columnName = "";
                string headerText = "";
                //행번호 있는 그리드이면 엑셀에도 no컬럼 표시하기 위해.
                if (grid.ColumnModel.Columns[i] is RowNumbererColumn ||
                    (grid.ColumnModel.Columns[i].ID.Equals("NO") && grid.ColumnModel.Columns[i].DataIndex == null))
                {
                    columnName = "RNUM__"; //이 이름으로 쿼리 컬럼이 있진 않겠지...?? 
                    headerText = "NO";
                    isRowNumberCol = true;

                    BoundField column = new BoundField();

                    column.DataField = columnName;
                    column.HeaderText = headerText;
                    arrColumn.Add(column);

                    GV.HeaderAdd(headerText);
                }
                else
                {
                    if (grid.ColumnModel.Columns[i].Columns.Count == 0)
                    {
                        if (grid.ColumnModel.Columns[i].DataIndex == null) continue;
                        if (grid.ColumnModel.Columns[i].DataIndex == "CHECK_VALUE") continue;

                        if (!Exceldt.Columns.Contains(grid.ColumnModel.Columns[i].DataIndex)) continue;

                        columnName = grid.ColumnModel.Columns[i].DataIndex; //Exceldt.Columns[i].ColumnName.ToUpper();
                        headerText = grid.ColumnModel.Columns[i].Text;

                        BoundField column = new BoundField();

                        column.DataField = columnName;
                        column.HeaderText = headerText;

                        SetTextStyle(columnName, column, AllText);      //특정 컬럼 텍스트 스타일로 지정

                        arrColumn.Add(column);

                        GV.HeaderAdd(headerText);
                    }
                    else
                    {
                        Column col = GV.HeaderAdd(grid.ColumnModel.Columns[i].Text);

                        //멀티헤더인 경우 tree구조로 컬럼 정보가 들어가있음. 그래서, 재귀호출해서 컬럼 정보 추가.
                        //Repeat(GV, col, grid.ColumnModel.Columns[i], arrColumn, AllText);
                        Repeat(GV, col, grid.ColumnModel.Columns[i].Columns, arrColumn, AllText, Exceldt);
                    }
                }
            }

            //행번호 컬럼이 존재하면 데이터테이블에도 행번호 컬럼 추가하여 번호 먹임. 없으면 말고
            if(isRowNumberCol)
                Exceldt = ExcelHelper.CleanUpExcelDataAndAddRowNumber(Exceldt);
            else
                Exceldt = ExcelHelper.CleanUpExcelData(Exceldt);

            //혹시 데이터가 없으면 빈행이라도 추가한다. 
            //데이터 export가 아니라 엑셀 양식 다운인 경우에, 레코드 없는 경우
            //제대로 동작하지 않음...
            if (Exceldt.Rows.Count == 0)
            {
                DataRow dr = Exceldt.NewRow();
                Exceldt.Rows.Add(dr);
            }

            //page.Response관련해서는 GridPanel데이터 다 읽어온 후에 호출하도록.
            //그존에 호출하니 response값이 이상해짐. 이유는 모르겠으나 뭔가 꼬이는것 같음. 
            //그 아래는 원래 메서드와 동일.
            page.Response.Clear();

            //파일이름 설정

            string fName = string.Format("{0}.xls", ((BasePage)page).GetMenuID_Name() + "_" + DateTime.Now.ToString("yyyyMMddHHmmss"));
            //헤더부분에 내용을 추가
            page.Response.AddHeader("Content-Disposition", "attachment;filename=\"" + page.Server.UrlPathEncode(fileName == "" ? fName : fileName) + "\"");
            page.Response.Charset = "euc-kr";
            page.Response.ContentEncoding = System.Text.Encoding.GetEncoding("euc-kr");
            //컨텐츠 타입 설정
            page.Response.ContentType = "application/vnd.ms-excel";

            string tmpFileName = DateTime.Now.Ticks.ToString();
            tmpFileName = "c:\\Temp\\" + tmpFileName;

            //StringWriter SW = new StringWriter();
            StreamWriter SW = new StreamWriter(tmpFileName, false, System.Text.Encoding.GetEncoding(949));
            HtmlTextWriter HW = new HtmlTextWriter(SW);

            //새로운 GridView 셋팅
            GV.Font.Names = new string[] { "GulimChe", "Arial" };
            GV.Font.Size = FontUnit.Point(9);
            GV.HeaderStyle.Height = 25;
            GV.ShowHeader = false;  //  Ext.Grid 사용시에는 디폴트 헤더를 사용하지 않는다. 
            GV.HeaderStyle.BackColor = System.Drawing.Color.FromArgb(0, 112, 192);
            GV.HeaderStyle.ForeColor = System.Drawing.Color.White;
            GV.HeaderStyle.Font.Bold = true;
            GV.DataSource = Exceldt;
            GV.AutoGenerateColumns = false;

            if (!isHeader && Exceldt.Rows.Count > 0)
                Exceldt.Rows.RemoveAt(0);

            if (AllText)
            {
                // DataSet 새로 생성
                DataTable nExceldt = new DataTable(Exceldt.TableName);

                for (int i = 0; i < Exceldt.Columns.Count; i++)
                    nExceldt.Columns.Add(new DataColumn(Exceldt.Columns[i].ColumnName, typeof(string)));

                Exceldt.Select().CopyToDataTable<DataRow>(nExceldt, LoadOption.OverwriteChanges);

                // 데이터 복제
                for (int i = 0; i < nExceldt.Columns.Count; i++)
                {
                    // 숫자필드중 값이 0 이 아니면서 1보다 작거나 -1보다 클경우 강제로 앞에 0 삽입
                    for (int j = 0; j < nExceldt.Rows.Count; j++)
                    {
                        if (!nExceldt.Rows[j].IsNull(i))
                        {
                            double s;
                            if (double.TryParse(nExceldt.Rows[j][i].ToString(), out s))
                            {
                                if (s >= 0 && (s < 1) && nExceldt.Rows[j][i].ToString().Trim().StartsWith("."))
                                    nExceldt.Rows[j][i] = "0" + nExceldt.Rows[j][i].ToString().Trim();
                                else if (s < 0 && (s > -1) && nExceldt.Rows[j][i].ToString().Trim().StartsWith("-."))
                                    nExceldt.Rows[j][i] = "-0" + nExceldt.Rows[j][i].ToString().Trim().Substring(1);
                                else if (s >= 0 && (s < 1) && nExceldt.Rows[j][i].ToString().Trim().StartsWith(","))
                                    nExceldt.Rows[j][i] = "0" + nExceldt.Rows[j][i].ToString().Trim();
                                else if (s < 0 && (s > -1) && nExceldt.Rows[j][i].ToString().Trim().StartsWith("-,"))
                                    nExceldt.Rows[j][i] = "-0" + nExceldt.Rows[j][i].ToString().Trim().Substring(1);
                            }
                        }
                    }
                }

                GV.DataSource = nExceldt;
            }

            foreach (object column in arrColumn)
            {                
                GV.Columns.Add((BoundField)column);
            }
            GV.DataBind();
            

            HW.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\">\r\n");
            HW.WriteLine("<style>.cssDate {mso-number-format:\\@;}</style>\r\n");
            GV.RenderControl(HW);

            HW.Close();
            SW.Close();

            page.Response.AddHeader("Content-Length", new FileInfo(tmpFileName).Length.ToString());
            page.Response.WriteFile(tmpFileName);
            page.Response.Flush();

            if (File.Exists(tmpFileName)) File.Delete(tmpFileName);

            //page.Response.End();
        }

        /// <summary>
        /// ExportExcel
        /// </summary>
        /// <param name="page"></param>
        /// <param name="Exceldt"></param>
        /// <param name="AllText"></param>
        /// <param name="fileName"></param>
        /// <param name="isHeader"></param>
        public static void ExportExcel(Page page, DataTable Exceldt, bool AllText, string fileName, bool isHeader)
        {
            Exceldt = ExcelHelper.CleanUpExcelData(Exceldt);

            page.Response.Clear();

            //파일이름 설정
            BasePage pg = page as BasePage;

            string fName = string.Format("{0}.xls", ((BasePage)page).GetMenuID_Name() + "_" + DateTime.Now.ToString("yyyyMMddHHmmss"));
            //헤더부분에 내용을 추가
            page.Response.AddHeader("Content-Disposition", "attachment;filename=\"" + page.Server.UrlPathEncode(fileName == "" ? fName : fileName) + "\"");
            page.Response.Charset = "euc-kr";
            page.Response.ContentEncoding = System.Text.Encoding.GetEncoding("euc-kr");
            //컨텐츠 타입 설정
            page.Response.ContentType = "application/vnd.ms-excel";

            string tmpFileName = DateTime.Now.Ticks.ToString();
            tmpFileName = "c:\\Temp\\" + tmpFileName;


            //StringWriter SW = new StringWriter();
            StreamWriter SW = new StreamWriter(tmpFileName, false, System.Text.Encoding.GetEncoding(949));
            HtmlTextWriter HW = new HtmlTextWriter(SW);

            //새로운  GridView를 
            EPGridView GV = new EPGridView();
            GV.Font.Names = new string[] { "GulimChe", "Arial" };
            GV.Font.Size = FontUnit.Point(9);
            GV.HeaderStyle.Height = 25;
            GV.HeaderStyle.BackColor = System.Drawing.Color.FromArgb(0, 112, 192);
            GV.HeaderStyle.ForeColor = System.Drawing.Color.White;
            GV.HeaderStyle.Font.Bold = true;
            GV.DataSource = Exceldt;
            GV.AutoGenerateColumns = false;


            ArrayList arrColumn = new ArrayList();


            for (int i = 0; i < Exceldt.Columns.Count; i++)
            {
                BoundField column = new BoundField();

                string columnName = Exceldt.Columns[i].ColumnName.ToUpper();

                column.DataField = columnName;
                column.HeaderText = (!isHeader ? Exceldt.Rows[0][i].ToString() : columnName);

                SetTextStyle(columnName, column, AllText);//특정 컬럼 텍스트 스타일로 지정

                arrColumn.Add(column);
            }

            if (!isHeader && Exceldt.Rows.Count > 0)
                Exceldt.Rows.RemoveAt(0);


            if (AllText)
            {
                // DataSet 새로 생성
                DataTable nExceldt = new DataTable(Exceldt.TableName);

                for (int i = 0; i < Exceldt.Columns.Count; i++)
                    nExceldt.Columns.Add(new DataColumn(Exceldt.Columns[i].ColumnName, typeof(string)));

                Exceldt.Select().CopyToDataTable<DataRow>(nExceldt, LoadOption.OverwriteChanges);

                // 데이터 복제
                for (int i = 0; i < nExceldt.Columns.Count; i++)
                {
                    // 숫자필드중 값이 0 이 아니면서 1보다 작거나 -1보다 클경우 강제로 앞에 0 삽입
                    for (int j = 0; j < nExceldt.Rows.Count; j++)
                    {
                        if (!nExceldt.Rows[j].IsNull(i))
                        {
                            double s;
                            if (double.TryParse(nExceldt.Rows[j][i].ToString(), out s))
                            {
                                if (s >= 0 && (s < 1) && nExceldt.Rows[j][i].ToString().Trim().StartsWith("."))
                                    nExceldt.Rows[j][i] = "0" + nExceldt.Rows[j][i].ToString().Trim();
                                else if (s < 0 && (s > -1) && nExceldt.Rows[j][i].ToString().Trim().StartsWith("-."))
                                    nExceldt.Rows[j][i] = "-0" + nExceldt.Rows[j][i].ToString().Trim().Substring(1);
                                else if (s >= 0 && (s < 1) && nExceldt.Rows[j][i].ToString().Trim().StartsWith(","))
                                    nExceldt.Rows[j][i] = "0" + nExceldt.Rows[j][i].ToString().Trim();
                                else if (s < 0 && (s > -1) && nExceldt.Rows[j][i].ToString().Trim().StartsWith("-,"))
                                    nExceldt.Rows[j][i] = "-0" + nExceldt.Rows[j][i].ToString().Trim().Substring(1);
                            }
                        }
                    }
                }

                GV.DataSource = nExceldt;
            }

            foreach (object column in arrColumn)
                GV.Columns.Add((BoundField)column); 

            GV.DataBind();

            HW.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\">\r\n");
            HW.WriteLine("<style>.cssDate {mso-number-format:\\@;}</style>\r\n");
            GV.RenderControl(HW);

            HW.Close();
            SW.Close();

            page.Response.AddHeader("Content-Length", new FileInfo(tmpFileName).Length.ToString());
            page.Response.WriteFile(tmpFileName);
            page.Response.Flush();

            if (File.Exists(tmpFileName)) File.Delete(tmpFileName);

            //page.Response.End();
        }

        /// <summary>
        /// ExportExcel
        /// </summary>
        /// <param name="page"></param>
        /// <param name="Excelds"></param>
        /// <param name="AllText"></param>
        /// <param name="fileName"></param>
        /// <param name="isHeader"></param>
        public static void ExportExcel(Page page, DataSet Excelds, bool AllText, string fileName, bool isHeader)
        {
            ExcelHelper.ExportExcel(page, Excelds.Tables[0], AllText, fileName, isHeader);
        }

        /// <summary>
        /// ExportDirectExcel 엑셀로 바로 저장
        /// </summary>
        /// <param name="page"></param>
        /// <param name="Exceldt"></param>
        /// <param name="spliter"></param>
        /// <param name="fileName"></param>
        public static void ExportDirectExcel(Page page, DataTable Exceldt, string spliter, string fileName)
        {
            Exceldt = ExcelHelper.CleanUpExcelData(Exceldt);
            page.Response.Clear();

            //파일이름 설정
            string fName = fileName;
            //헤더부분에 내용을 추가
            page.Response.AddHeader("Content-Disposition", "attachment;filename=\"" + page.Server.UrlPathEncode(fName) + "\"");
            page.Response.Charset = "euc-kr";
            page.Response.ContentEncoding = System.Text.Encoding.GetEncoding("euc-kr");
            //컨텐츠 타입 설정
            page.Response.ContentType = "application/octet-stream";

            string tmpFileName = DateTime.Now.Ticks.ToString();
            tmpFileName = "c:\\Temp\\" + tmpFileName;

            StreamWriter SW = new StreamWriter(tmpFileName, false, System.Text.Encoding.GetEncoding(949));

            for (int i = 0; i < Exceldt.Rows.Count; i++)
            {
                string lineStr = "";
                for (int j = 0; j < Exceldt.Columns.Count; j++)
                {
                    if (lineStr != "") lineStr += spliter;
                    lineStr += (Exceldt.Rows[i].IsNull(j) ? "" : Exceldt.Rows[i][j].ToString());
                }

                SW.WriteLine(lineStr);
            }

            SW.Close();

            page.Response.AddHeader("Content-Length", new FileInfo(tmpFileName).Length.ToString());
            page.Response.WriteFile(tmpFileName);
            page.Response.Flush();

            if (File.Exists(tmpFileName)) File.Delete(tmpFileName);

            page.Response.End();
        }

        public static void ExportDirectExcel(Page page, DataSet Excelds, string spliter, string fileName)
        {
            ExcelHelper.ExportDirectExcel(page, Excelds.Tables[0], spliter, fileName);
        }

        /// <summary>
        /// CleanUpExcelData 엑셀 다운로드시 데이터 정리 작업
        /// - 태그로 인식 방지를 위한 변형된 데이터 원상복귀
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        public static DataTable CleanUpExcelData(DataTable dt)
        {
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                if (typeof(string).Equals(dt.Columns[i].DataType) && !dt.Columns[i].ColumnName.Equals("CONTENTS"))
                {
                    for (int j = 0; j < dt.Rows.Count; j++)
                    {
                        dt.Rows[j][i] = dt.Rows[j][i].ToString().Replace("&lt;", "<");
                        dt.Rows[j][i] = dt.Rows[j][i].ToString().Replace("&gt;", ">");
                    }
                }
            }
            return dt;
        }

        /// <summary>
        /// CleanUpExcelData 엑셀 다운로드시 데이터 정리 작업
        /// - 태그로 인식 방지를 위한 변형된 데이터 원상복귀
        /// and
        /// 행번호 컬럼 추가.(배명희)
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        public static DataTable CleanUpExcelDataAndAddRowNumber(DataTable dt)
        {
            if (!dt.Columns.Contains("RNUM__"))
                dt.Columns.Add("RNUM__");

            for (int i = 0; i < dt.Columns.Count; i++)
            {
                if ((typeof(string).Equals(dt.Columns[i].DataType) && !dt.Columns[i].ColumnName.Equals("CONTENTS")) || dt.Columns[i].ColumnName.Equals("RNUM__"))
                {
                    for (int j = 0; j < dt.Rows.Count; j++)
                    {
                        dt.Rows[j][i] = dt.Rows[j][i].ToString().Replace("&lt;", "<");
                        dt.Rows[j][i] = dt.Rows[j][i].ToString().Replace("&gt;", ">");

                        if (dt.Columns[i].ColumnName.Equals("RNUM__")) dt.Rows[j]["RNUM__"] = j + 1;
                    }
                }
            }
            return dt;
        }

        /// <summary>
        /// CleanUpExcelData 엑셀 다운로드시 데이터 정리 작업
        /// - 태그로 인식 방지를 위한 변형된 데이터 원상복귀/// 
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        public static DataTable CleanUpExcelData(DataSet ds)
        {
            return ExcelHelper.CleanUpExcelData(ds.Tables[0]);
        }
        #endregion
    }
}
