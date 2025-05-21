<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportExport.aspx.cs" Inherits="Ax.Report.ReportExport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta content="./SCM.ico?v=20220511000000" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />
    <meta name="description" content="자동차 내장제 제조, 도아트림, 범퍼, 시트, Automotive interior manufacture, door trim, bumper, console, seat,Global Auto Parts Supplier,Development manufacture and sales of automobile-interior parts" />
    <meta name="keywords" content="서연이화, 주식회사 서연이화, Seoyoneh, Seoyon E-Hwa, Seoyon E-Hwa Co.,ltd, Van, Scm, 자재공급, Potal" />

    <title>Seoyon E-Hwa Group Report Viewer::서연이화 그룹 PDF Viewer::</title>

    <link rel="shortcut icon" type="image/x-icon" href="./SCM.ico?v=20220511000000" />
    <script src="./Script/pdfobject_source.js?V=20220511000000" type="text/javascript"></script>
    <script src="./Script/base64.js?V=20220511000000" type="text/javascript"></script>
</head>
<body style="margin:0px 0px 0px 0px; height:100%; width:100%; font-family:Arial,맑은 고딕;font-size:10pt;">
    <form id="form1" runat="server">
        <div id="renderMsg" style="padding:10px 10px 10px 10px; display:block;">
            <table border="0" style="width:620px; height:240px; border:0px;" >
                <tr>
                    <td>
                        <asp:Image ID="Image1" Width="270" Height="230" runat="server" ImageUrl="./loading_img.gif" />
                    </td>
                    <td style="padding-left:10px;">
	                    <div style="color:gray; font-family:tahoma; font-weight:bold; font-size:20px;">
                            <hr/><asp:Label ID="lblPDFTitle" runat="server" Text="">
                                <b>Document Loading...</b>
                            </asp:Label><hr/>
	                    </div>
                        <div style="color:gray; font-family:tahoma">
                            <asp:Label ID="lblPDFTitleMessage" runat="server" Text="">
                                <BR />The one that generated the current PDF document..<br />
                                It may take some time, please wait ...<br /><br />

                                현재 PDF 문서를 생성하고 있는중입니다.<br />
                                다소 시간이 소요될 수 있으니 잠시 기다려 주세요<br /><br />

                                <hr />COPYRIGHT(c) SEOYON E-HWA. ALL RIGHTS RESERVED. <hr />
                            </asp:Label>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="errorMsg" style="padding:10px 10px 10px 10px; display:none;">
	        <div>
                <b><asp:Label ID="lblTitle" runat="server" Text="Can not find the PDF Viewer(PDF 뷰어를 찾을수 없습니다)"></asp:Label><hr/></b><br/>
	        </div>
            <div>
                <asp:Label ID="lblErrorMessage" runat="server" Text="">
                    You need to install Adobe Reader or Adobe PDF or Acrobat PDF Reader, you can view the document.<br />
                    After you go to the following URL: Please download and install the Reader Please browse the document again.<br /><br />

                    Adobe Reader 또는 Adobe PDF 또는 Acrobat PDF Reader 를 설치하셔야 문서를 볼 수 있습니다.<br />
                    아래 URL 로 이동하시어 Reader 를 다운로드 및 설치하신 후 문서를 다시 조회하십시요.<br /><br />

                    <b>Download</b> : <a href="http://get.adobe.com/reader"><b style="color:blue">http://get.adobe.com/reader</b></a><br /><br /><br /><br />
                    COPYRIGHT(c) SEOYON E-HWA. ALL RIGHTS RESERVED. <hr />
                </asp:Label>
            </div>
        </div>
        <asp:Label ID="scriptBlock" runat="server">
        </asp:Label>
    </form>
</body>
</html>
