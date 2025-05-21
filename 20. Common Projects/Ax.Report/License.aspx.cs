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
using System.IO;
using System.Net;
using System.Text;

public partial class license : System.Web.UI.Page
{
    override protected void OnInit(EventArgs e)
    {
        Page.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Page.Server.ScriptTimeout = 6000;
        this.PreRender += new EventHandler(License_PreRender);
        base.OnInit(e);
    }

    private void License_PreRender(object sender, EventArgs e)
    {
        /*
        Response.Clear();
        Response.Charset = "UTF-8";
        Response.ContentType = "text/xml";
        Response.Write("<?xml version='1.0' encoding='UTF-8'?>");
        Response.Write("<gubun>");
        Response.Flush();
        Response.End();
         */

        Response.Clear();
        Response.Charset = "UTF-8";
        Response.ContentType = "text/xml";

        Response.Write(fnGetLicense(Request.Url.ToString()));
        Response.Flush();
        Response.End();
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    /// <summary>
    public string fnGetLicense(
        string sUrl
    )
    {
        //파라메터 설정
        StringBuilder postParams = new StringBuilder();
        postParams.Append("ID=SLI");

        //파라메터 Encoding Type 설정
        Encoding encoding = Encoding.UTF8;
        byte[] result = encoding.GetBytes(postParams.ToString());

        sUrl = sUrl.Substring(0, sUrl.LastIndexOf('/')) + "/rexservice.aspx";

        // 타겟이 되는 웹페이지 URL
        HttpWebRequest wReqFirst = (HttpWebRequest)WebRequest.Create(sUrl);

        // HttpWebRequest 오브젝트 설정
        wReqFirst.Method = "POST";
        wReqFirst.ContentType = "application/x-www-form-urlencoded;charset=UTF-8";
        wReqFirst.ContentLength = result.Length;

        Stream postDataStream = wReqFirst.GetRequestStream();
        postDataStream.Write(result, 0, result.Length);
        postDataStream.Close();
        HttpWebResponse wRespFirst = (HttpWebResponse)wReqFirst.GetResponse();

        // Response의 결과를 스트림을 생성합니다.
        Stream respPostStream = wRespFirst.GetResponseStream();

        // Response의 Encoding Type 설정
        StreamReader readerPost = new StreamReader(respPostStream, Encoding.UTF8);

        // 생성한 스트림으로부터 string으로 변환합니다.
        return readerPost.ReadToEnd();
    }
}
