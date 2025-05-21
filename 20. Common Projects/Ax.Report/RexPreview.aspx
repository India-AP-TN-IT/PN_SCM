<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="rexpreview.aspx.cs" Inherits="rexpreview" validateRequest="false" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta content="./SCM.ico?v=20220307113400" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />
    <meta name="description" content="자동차 내장제 제조, 도아트림, 범퍼, 시트, Automotive interior manufacture, door trim, bumper, console, seat,Global Auto Parts Supplier,Development manufacture and sales of automobile-interior parts" />
    <meta name="keywords" content="서연이화, 주식회사 서연이화, Seoyoneh, Seoyon E-Hwa, Seoyon E-Hwa Co.,ltd, Van, Scm, 자재공급, Potal" />

    <title>Seoyon E-Hwa Group Report Viewer::서연이화 그룹 Report Viewer::</title>

    <link rel="shortcut icon" type="image/x-icon" href="./SCM.ico?v=20220511000000" />

    <script type="text/javascript" src="./script/rexpert.js?v=20220511000000"></script>
    <script type="text/javascript" src="./script/rexpert_properties.js?v=20220511000000"></script>
    <script type="text/javascript" src="./script/rexpert_viewer.js?v=20220511000000"></script>
    <script type="text/javascript" src="./script/base64.js?v=20220511000000"></script>
    <script type="text/javascript">
        // 모바일 브라우저 체크
        var isMobileDevice = function () {
            var result = false;

            var mobileKeyWords = new Array('iPhone', 'iPod', 'BlackBerry', 'Android', 'Windows CE', 'LG', 'MOT', 'SAMSUNG', 'SonyEricsson', 'Mobile', 'Symbian', 'Opera Mobi', 'Opera Mini', 'IEmobile');

            for (var i = 0; i < mobileKeyWords.length; i++) {
                if (navigator.userAgent.match(mobileKeyWords[i]) != null) {
                    result = true;
                    break;
                }
            }
            return result;
        };

        var isJavaAvailable = function () {
            var javaRegex = /(Java)(\(TM\)| Deployment)/,
      plugins = navigator.plugins;
            if (navigator && plugins) {
                for (plugin in plugins) {
                    if (plugins.hasOwnProperty(plugin) && javaRegex.exec(plugins[plugin].name)) {
                        return true;
                    }
                }
            }
            return false;
        }

        // NPAPI 지원 브라우저 체크
        var isNPAPI = function () {
            var agent = navigator.userAgent.toLowerCase();

            if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)) {
                return true;                // IE 인경우
            } else {
                if (agent.indexOf("chrome") != -1) {
                    var chromeVersion = window.navigator.userAgent.match(/Chrome\/(\d+)\./);
                    if (chromeVersion && chromeVersion[1]) {
                        if (parseInt(chromeVersion[1], 10) >= 42 && !isJavaAvailable()) {
                            return false;   // 크롬 42이상 버전에서 NPAPI 기능 사용 불가한 경우
                        }
                        else {
                            return true;    // 크롬 42버전이하에서 NPAPI 기능 활성화 된경우
                        }
                    }
                    else {
                        return true;        // 구형 크롬 브라우저
                    }
                } else {
                    return false;            // 크롬이 아닌경우 ( 사파라 / 파폭 등.. )
                }
            }
        }


        var get_param_value = function (_url, _name) {

            _name = _name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regexS = "[\\?&]" + _name + "=([^&#]*)";
            var regex = new RegExp(regexS);
            var results = regex.exec(_url);

            if (results == null)
                return "";
            else
                return results[1];
        };

    </script>
    <script type="text/javascript">

        var rptLocale = get_param_value(document.location.href, 'rptLocale');
        if (rptLocale == '') rptLocale = top.opener.rptLocale;
        var rptMode = get_param_value(document.location.href, 'rptMode');
        if (rptMode == '') rptMode = top.opener.rptMode;

        // PDF 모드가 아닐때 모바일 브라우저이거나 NPAPI 지원하지 않는 브라우저라면 강제 PDF 렌더 처리
        if (rptMode == "pdf") rptMode = "PDF";
        if (rptMode != "PDF" && (isMobileDevice() || !isNPAPI())) rptMode = "PDF";

         rptMode = "PDF";  // 해외 표준 버전은 무조건 PDF 모드로 렌더링
        if (rptMode == "PDF") {
            fnOpen = function anonymous(oOOF) {
                var oOOFStr = oOOF.toString();

                document.getElementById("renderMsg").style.display = "block";
                document.getElementById("exportdata").value = encode64Han(oOOFStr);
                document.getElementById("exporttype").value = rptMode;
                document.getElementById("exportname").value = oOOF.rptname;
                document.getElementById("exportlocale").value = rptLocale;
                document.getElementById("frmExportService").action = "./ReportExport.aspx?id=0";
                document.getElementById("frmExportService").submit();
            }
        }

    </script>
</head>
<body style="margin:0 0 0 0;width:100%;height:100%;font-family:Arial,맑은 고딕;font-size:9pt;">
<form id="frmExportService" name="frmExportService" method="post"  action="">
    <input type="hidden" id="exportdata" name="exportdata" value="" />
    <input type="hidden" id="exporttype" name="exporttype" value="" />
    <input type="hidden" id="exportname" name="exportname" value="" />
    <input type="hidden" id="exportlocale" name="exportlocale" value="" />
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
                        <div style="color:gray; font-family:tahoma; font-size:13px; ">
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

</form>
</body>
</html>

<script type="text/javascript">
    if (rptMode != "PDF") {
        document.getElementById("renderMsg").style.display = "none";
        rex_writeRexCtl("RexCtl");
    }

    if (parent != null && parent.document.getElementById("renderMsg") != null)
        parent.document.getElementById("renderMsg").style.display = "none";

    init();
</script>