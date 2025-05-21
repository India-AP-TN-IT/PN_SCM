using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Ax.ReportExporter
{
    public partial class RexControl : Form
    {
        private string exportType = string.Empty;
        private string exportLocale = string.Empty;
        private string exportName = string.Empty;
        private string exportPath = string.Empty;
        private string exportData = string.Empty;

        public RexControl()
        {
            InitializeComponent();
        }

        public RexControl(string[] args) : this()
        {
            try
            {
                /*
                this.exportType = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(args[0]));
                this.exportLocale = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(args[1]));
                this.exportName = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(args[2]));
                this.exportPath = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(args[3]));
                this.exportData = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(args[4]));
                */

                // 파라메터 처리 방식을 파일로 변경   by 2018.11.15 김건우
                string argsFile = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(args[0]));
                string []argsData = System.IO.File.ReadAllText(argsFile).Split('\t');

                this.exportType = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(argsData[0]));
                this.exportLocale = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(argsData[1]));
                this.exportName = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(argsData[2]));
                this.exportPath = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(argsData[3]));
                this.exportData = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(argsData[4]));



                System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(exportLocale);
                System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(exportLocale);

                // 디버깅용
                if (args.Length > 5) this.exportPath = "C:\\Temp\\Ax.ReportExporter\\";
            }
            catch
            {
            }
            finally
            {
            }
        }

        private void RexControl_Load(object sender, EventArgs e)
        {
            try
            {
                //axRexViewer.ChangeLocale((short)System.Threading.Thread.CurrentThread.CurrentCulture.LCID);
                axRexViewer.OpenOOF(exportData);

                // 이전 날짜 파일 삭제
                if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(exportPath)))
                    System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(exportPath));

                foreach (string files in System.IO.Directory.GetFiles(System.IO.Path.GetDirectoryName(exportPath)))
                {
                    if (!System.IO.File.GetCreationTime(files).ToString("yyyy-MM-dd").Equals(DateTime.Now.ToString("yyyy-MM-dd")))
                        System.IO.File.Delete(files);
                }

                //axRexViewer.SetCSS("export.pdf.option.fontembedding=1"); // 기본값이 1
                axRexViewer.Export(false, exportType, exportPath + exportName, 1, -1, "");

                System.IO.File.WriteAllText(exportPath + exportName.Replace(".pdf","") + "_debug.txt", string.Format("exportType : {0}\r\nexportLocale : {1}\r\nexportName : {2}\r\nexportPath : {3}\r\nexportData : {4}", exportType, exportLocale, exportName, exportPath, exportData));

                
            }
            catch
            {
            }
            finally
            {
                Application.Exit();
            }
        }
    }
}
