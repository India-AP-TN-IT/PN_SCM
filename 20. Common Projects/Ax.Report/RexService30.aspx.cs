using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.OleDb;

public partial class rexservice30 : System.Web.UI.Page
{
    override protected void OnInit(EventArgs e)
    {
        Page.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Page.Server.ScriptTimeout = 6000;
        this.PreRender += new EventHandler(rexservice_PreRender);
        base.OnInit(e);
    }

    private void rexservice_PreRender(object sender, EventArgs e)
    {
        string designtype = Request.Params.Get("designtype");
        if (designtype == string.Empty || designtype == null) designtype = "";

        if (designtype.Equals("service"))
        {
            //
            RexServer.CRexDesign oRexDesign = new RexServer.CRexDesign(Request, Response);
            oRexDesign.getServiceList();
        }
        else if (designtype.Equals("schema"))
        {
            RexServer.CRexDesign oRexDesign = new RexServer.CRexDesign(Request, Response);
            oRexDesign.getSchemaList();
        }
        else if (designtype.Equals("table"))
        {
            RexServer.CRexDesign oRexDesign = new RexServer.CRexDesign(Request, Response);
            oRexDesign.getTableList();
        }
        else if (designtype.Equals("field"))
        {
            RexServer.CRexDesign oRexDesign = new RexServer.CRexDesign(Request, Response);
            oRexDesign.getFieldList();
        }
        else if (designtype.Equals("execfield"))
        {
            RexServer.CRexDesign oRexDesign = new RexServer.CRexDesign(Request, Response);
            oRexDesign.getExecFieldList();
        }
        else if (designtype.Equals("data"))
        {
            RexServer.CRexDesign oRexDesign = new RexServer.CRexDesign(Request, Response);
            if (oRexDesign.m_sDataType.Equals("CSV"))
            {
                Response.ContentType = oRexDesign.m_sNlsContentTypeCsv;
            }
            else
            {    // XML
                Response.ContentType = oRexDesign.m_sNlsContentTypeXml;
            }

            oRexDesign.getData();
        }
        else // run
        {

            string sID = (Request.Params.Get("ID") == null ? "" : Request.Params.Get("ID"));
            string sOT = (Request.Params.Get("OT") == null ? "" : Request.Params.Get("OT"));

            if (!sID.Equals(""))
            {

                RexServer.CRexDesign30 oRexDesign30 = new RexServer.CRexDesign30(Request, Response);

                if (sID.Equals("LM"))
                {
                    oRexDesign30.checkLogin();
                }
                else if (sID.Equals("SCL"))
                {
                    oRexDesign30.getServiceList();
                }
                else if (sID.Equals("STLIC"))
                {
                    oRexDesign30.getTableList();
                }
                else if (sID.Equals("SFLIT"))
                {
                    oRexDesign30.getFieldList();
                }
                else if (sID.Equals("SDCSV") && sOT.Equals("FieldInfoOnly"))
                {
                    oRexDesign30.getExecFieldList();
                }
                else if (sID.Equals("SDCSV") && sOT.Equals("DataAndFieldInfo"))
                {
                    oRexDesign30.getData();
                }
                else if (sID.Equals("SDCSV") && sOT.Equals("DataOnly"))
                {
                    oRexDesign30.getData();
                }

            }
            else
            {
                //RexServer.CRexService oRexService = new RexServer.CRexService(Request, Response);
                RexServer.CRexService oRexService = new RexServer.CRexService(Request, Response, Application);
                oRexService.getData();
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
}