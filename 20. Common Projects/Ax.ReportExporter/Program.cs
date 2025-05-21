using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace Ax.ReportExporter
{
    static class Program
    {

        /// <summary>
        /// 해당 응용 프로그램의 주 진입점입니다.
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            //string []arg = new string[] { "cGRm", "a28tS1I=", "RVAyMFMwMV9ERVYxXzA2NTg3ZDk4LTU0MDMtNDJjNy1iMmU2LTNmMTMyZjk4ZWFmNy5wZGY=", "RTpcV29ya0RldlxIRV9TQ01cSEUuU0NNXDIwLiBDb21tb24gUHJvamVjdHNcSEUuUmVwb3J0XHJwdEZvcm1GaWxlc1xUZW1wXEV4cG9ydFw=", "PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0ndXRmLTgnPz48b29mIHZlcnNpb24gPSczLjAnPjxkb2N1bWVudCB0aXRsZT0ncmVwb3J0JyBlbmFibGUtdGhyZWFkPScwJz48ZmlsZS1saXN0PjxmaWxlIHR5cGU9J3JlYicgcGF0aD0naHR0cDovL2xvY2FsaG9zdC5jb20vSEUuUmVwb3J0L3JwdEZvcm1GaWxlcy9UZW1wLzEwMDAvRVAvRVAyMFMwMV9ERVYxXzA2NTg3ZDk4LTU0MDMtNDJjNy1iMmU2LTNmMTMyZjk4ZWFmNy5yZWInPjxjb25maWctcGFyYW0tbGlzdD48L2NvbmZpZy1wYXJhbS1saXN0PjwvZmlsZT48L2ZpbGUtbGlzdD48Y29ubmVjdGlvbi1saXN0Pjxjb25uZWN0aW9uIHR5cGU9J2ZpbGUnIG5hbWVzcGFjZT0nWE1MJz48Y29uZmlnLXBhcmFtLWxpc3Q+PGNvbmZpZy1wYXJhbSBuYW1lPSdjb25uZWN0aW9uLm9uY2UnPjE8L2NvbmZpZy1wYXJhbT48Y29uZmlnLXBhcmFtIG5hbWU9J3BhdGgnPmh0dHA6Ly9sb2NhbGhvc3QuY29tL0hFLlJlcG9ydC9ycHRYTUxUZW1wL0VQMjBTMDFfREVWMV8wNjU4N2Q5OC01NDAzLTQyYzctYjJlNi0zZjEzMmY5OGVhZjdfWE1MX0RFVjFfZTkwYjMwNTYtZTA5OC00ZjUzLWFjMmMtZTQ1MWE5MGEzNWFlLnhtbDwvY29uZmlnLXBhcmFtPjwvY29uZmlnLXBhcmFtLWxpc3Q+PGNvbnRlbnQgY29udGVudC10eXBlPSd4bWwnPjxjb250ZW50LXBhcmFtIG5hbWU9J3Jvb3QnPnslZGF0YXNldC54bWwucm9vdCV9PC9jb250ZW50LXBhcmFtPjxjb250ZW50LXBhcmFtIG5hbWU9J3ByZXNlcnZlZHdoaXRlc3BhY2UnPjE8L2NvbnRlbnQtcGFyYW0+PGNvbnRlbnQtcGFyYW0gbmFtZT0nYmluZG1vZGUnPm5hbWU8L2NvbnRlbnQtcGFyYW0+PC9jb250ZW50PjwvY29ubmVjdGlvbj48L2Nvbm5lY3Rpb24tbGlzdD48ZmllbGQtbGlzdD48ZmllbGQgbmFtZT0nUmVwb3J0VXNlcklEJz48IVtDREFUQVtERVYxXV0+PC9maWVsZD48ZmllbGQgbmFtZT0nUmVwb3J0VXNlck5hbWUnPjwhW0NEQVRBW+qwnOuwnOyekF1dPjwvZmllbGQ+PGZpZWxkIG5hbWU9J1BSSU5UX1VTRVInPjwhW0NEQVRBW0RFVjEo6rCc67Cc7J6QKV1dPjwvZmllbGQ+PGZpZWxkIG5hbWU9J1RFU1RfUEFSQU0xJz48IVtDREFUQVvtjIzrnbzrqZTthLAxXV0+PC9maWVsZD48ZmllbGQgbmFtZT0nVEVTVF9QQVJBTTInPjwhW0NEQVRBW+2MjOudvOuplO2EsDJdXT48L2ZpZWxkPjwvZmllbGQtbGlzdD48cGx1Z2luLWxpc3Q+PC9wbHVnaW4tbGlzdD48L2RvY3VtZW50Pjwvb29mPg==" };
            
            if (args.Length < 1)
                Application.Exit();
            else
                Application.Run(new RexControl(args));
        }
    }
}
