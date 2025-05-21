using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ax.EP.Utility;

namespace Ax.EP.WP
{
    /// <summary>
    /// Default
    /// </summary>
    /// <remarks></remarks>
    public partial class Default : System.Web.UI.Page
    {
        /// <summary>
        /// Handles the Load event of the Page control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Page_Load(object sender, EventArgs e)
        {
            /*
            Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SOClient soap9 = new SRM.WP.POMM0090_Service.POMM0090_MES_SOClient();
            soap9.ClientCredentials.UserName.UserName = @"IF_EHW";
            soap9.ClientCredentials.UserName.Password = @"interface!12";

            Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SORequest request9 = new SRM.WP.POMM0090_Service.POMM0090_MES_SORequest();
            Ax.SRM.WP.POMM0090_Service.DT_POMM0090_MESZMMS0210 data9 = new SRM.WP.POMM0090_Service.DT_POMM0090_MESZMMS0210();
            data9.BUDAT = "TEST";
            data9.BUKRS = "TEST";
            data9.BWART = "TEST";
            data9.DELI_NOTE = "TEST";
            data9.DELI_NOTE_CNT = "TEST";
            data9.EBELN = "TEST";
            data9.EBELP = "TEST";
            data9.ELIKZ = "TEST";
            data9.IF_DATE = "TEST";
            data9.IF_TIME = "TEST";
            data9.IPNAM = "TEST";
            data9.LGORT = "TEST";
            data9.LIFNR = "TEST";
            data9.MATNR = "TEST";
            data9.MEINS = "TEST";
            data9.MENGE = "TEST";
            data9.MES_DOC = "TEST";
            data9.NMENGE = "TEST";
            data9.TXZ01 = "TEST";
            data9.WERKS = "TEST";
            data9.ZDATE_PO = "TEST";
            data9.ZDATE_SAP = "TEST";
            data9.ZMSG_SAP = "TEST";
            data9.ZRSLT_SAP = "TEST";
            data9.ZTIME_SAP = "TEST";

            Ax.SRM.WP.POMM0090_Service.DT_POMM0090_MES pomm0090 = new SRM.WP.POMM0090_Service.DT_POMM0090_MES();
            pomm0090.ZMMS0210 = new SRM.WP.POMM0090_Service.DT_POMM0090_MESZMMS0210[1];
            pomm0090.ZMMS0210.SetValue(data9, 0);
            request9.MT_POMM0090_MES = pomm0090;

            Ax.SRM.WP.POMM0090_Service.DT_POMM0090_MES_response response9 = new SRM.WP.POMM0090_Service.DT_POMM0090_MES_response();
            response9 = soap9.POMM0090_MES_SO(request9.MT_POMM0090_MES);
            */


            
            
            /*
            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM pomm0030 = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM();
            Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SOClient soap = new Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SOClient();
            soap.ClientCredentials.UserName.UserName = @"IF_EHW";
            soap.ClientCredentials.UserName.Password = @"interface!12";

            Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SORequest request = new Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SORequest();
            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200 data = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200();
            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200 data2 = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200();

            data.BUKRS = "1100";
            data.WERKS = "1120";
            data.DELI_NOTE = "1100201707190006";
            data.DELI_NOTE_CNT = "1";
            data.IF_DATE = "20170719";
            data.IF_TIME = "135439";
            data.LFDAT = "20170720";
            data.CRDAT = "20170719";
            data.LIFNR = "100040";
            data.EKORG = "1100";
            data.DELI_TYPE = "X";
            data.EBELN = "4100000213";
            data.EBELP = "10";
            data.MATNR = "88700-F2000XFD";
            data.LGORT = "2110";
            data.LFIMG = "1000";
            data.MEINS = "EA";
            data.BARCODE = "110020170719000100001";
            data.NATION_CD = "KR";
            data.LOT_NO = "20170715";
            data.VEND_LOTNO = "TEST001";
            data.CHANGE_NOTE = "TEST1";

            data2.BUKRS = "1100";
            data2.WERKS = "1120";
            data2.DELI_NOTE = "1100201707190006";
            data2.DELI_NOTE_CNT = "2";
            data2.IF_DATE = "20170719";
            data2.IF_TIME = "135439";
            data2.LFDAT = "20170720";
            data2.CRDAT = "20170719";
            data2.LIFNR = "100040";
            data2.EKORG = "1100";
            data2.DELI_TYPE = "X";
            data2.EBELN = "4100000470";
            data2.EBELP = "10";
            data2.MATNR = "88401-4F500";
            data2.LGORT = "2110";
            data2.LFIMG = "50";
            data2.MEINS = "EA";
            data2.BARCODE = "110020170719000100002";
            data2.NATION_CD = "KR";
            data2.LOT_NO = "20170715";
            data2.VEND_LOTNO = "TEST002";
            data2.CHANGE_NOTE = "TEST2";

            pomm0030.ZMMS0200 = new SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200[2];

            pomm0030.ZMMS0200.SetValue(data, 0);
            pomm0030.ZMMS0200.SetValue(data2, 1);

            request.MT_POMM0030_SCM = pomm0030;

            Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_response response = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_response();
            response = soap.POMM0030_SCM_SO(request.MT_POMM0030_SCM);
            */
            Response.Redirect(CommonString.LoginPageUrlStr + "?v=" + EPAppSection.ToString("SYSTEM_VER"));
        }
    }
}