using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Ax.EP.Utility;

namespace Ax.EP.WP.Home.EPBase
{
    /// <summary>
    /// EPHelpDoc 메뉴얼다운로드
    /// </summary>
    /// <remarks></remarks>
    public partial class EPHelpDoc : Ax.EP.Utility.BasePage
    {
        /// <summary>
        /// Handles the Load event of the Page control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Page_Load(object sender, EventArgs e)
        {
            this.loggbn.Value = (this.UserInfo.UserDivision.Equals("T12")) ? "1" : "0";
        }
    }
}