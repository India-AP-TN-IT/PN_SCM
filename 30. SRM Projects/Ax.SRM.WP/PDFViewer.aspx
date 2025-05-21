<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PDFViewer.aspx.cs" Inherits="Ax.EP.WP.PDFViewer"  %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title><%=Ax.EP.Utility.EPAppSection.ToString("TITLE") %> PDF Viewer</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="./css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
    <script src="./Script/pdfobject_source.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script src="./Script/base64.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
</head>
<body style="margin:0px 0px 0px 0px; height:100%; width:100%;">
    <form id="form1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server"/>
        <div id="errorMsg" style="padding:10px 10px 10px 10px; display:none;">
	        <div>
                <b><asp:Label ID="lblTitle" runat="server" Text="Can not find the PDF Viewer(PDF 뷰어를 찾을수 없습니다)"></asp:Label><hr/></b><br/>
	        </div>
            <div>
                <asp:Label ID="lblErrorMessage" runat="server" Text="">
                    Caution : Available only in Internet Explorer.<br/><br/>
 
                    You need to install Adobe Reader or Adobe PDF or Acrobat PDF Reader, you can view the document.<br />
                    After you go to the following URL: Please download and install the Reader Please browse the document again.<br /><br /><br />



                    주의 : Internet Explorer 에서만 사용가능합니다.<br/><br/>

                    Adobe Reader 또는 Adobe PDF 또는 Acrobat PDF Reader 를 설치하셔야 문서를 볼 수 있습니다.<br />
                    아래 URL 로 이동하시어 Reader 를 다운로드 및 설치하신 후 문서를 다시 조회하십시요.<br /><br />

                    <b>Download</b> : <a href="http://get.adobe.com/reader"><b style="color:blue">http://get.adobe.com/reader</b></a><br /><br /><br /><br />
                    COPYRIGHT(c) SEOYON E-HWA. ALL RIGHTS RESERVED. <hr />
                </asp:Label>
            </div>
        </div>
    </form>
</body>
</html>
