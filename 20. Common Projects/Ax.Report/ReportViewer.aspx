<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportViewer.aspx.cs" Inherits="Ax.Report.ReportViewer" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" style="margin:0px; height:100%">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta content="./SCM.ico?v=20220511000000" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />
    <meta name="description" content="자동차 내장제 제조, 도아트림, 범퍼, 시트, Automotive interior manufacture, door trim, bumper, console, seat,Global Auto Parts Supplier,Development manufacture and sales of automobile-interior parts" />
    <meta name="keywords" content="서연이화, 주식회사 서연이화, Seoyoneh, Seoyon E-Hwa, Seoyon E-Hwa Co.,ltd, Van, Scm, 자재공급, Potal" />

    <title>Seoyon E-Hwa Group Report Viewer::서연이화 그룹 Report Viewer::</title>

    <link rel="shortcut icon" type="image/x-icon" href="./SCM.ico?v=20220511000000" />

    <script type="text/javascript" src="./script/rexpert.js?v=20220511000000"></script>
    <script type="text/javascript" src="./script/rexpert_properties.js?v=20220511000000"></script>
</head>
<body style="margin:0px 0px 0px 0px; height:100%; width:100%; font-family:Arial,맑은 고딕;font-size:10pt;">
        <div id="renderMsg" style="padding:10px 10px 10px 10px; display:block; font-family:Arial,맑은 고딕;font-size:10pt;">
            <table border="0" style="width:630px; height:240px; border:0px;font-family:Arial,맑은 고딕;font-size:10pt;" >
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
        <iframe id="rptViewer" name="rptViewer" height="100%" width="100%" frameborder="0"></iframe>
    <form id="form1" runat="server">
    </form>
    
</body>
</html>
