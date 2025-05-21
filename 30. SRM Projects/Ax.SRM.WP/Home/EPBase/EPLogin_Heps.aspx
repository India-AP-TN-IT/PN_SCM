<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EPLogin_Heps.aspx.cs" Inherits="Ax.EP.WP.Home.EPBase.EPLogin_Heps" enableViewStateMac="true"%>
<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>
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
    <meta name="description" content="<%=Ax.EP.Utility.EPAppSection.ToString("DESCRIPTION") %>" />
    <meta name="keywords" content="서연이화, 주식회사 서연이화, Seoyoneh, Seoyoneh E-Hwa, Seoyoneh E-Hwa Co.,ltd, Van, Scm, Srm, Gcs, Ckd,  자재공급" />

    <title>Seoyon E-Hwa SRM::서연이화::</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script src="../../Script/PopupCookie.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>

    <script type="text/javascript">
        var goMain = function (isLogin) {
            var frmLogin = document.getElementById("frmLogin");

            if (isLogin == "Y") {
                App.HiddenLanguage.setValue("T2KO");

                try {
                    window.moveTo(0, 0);
                    if (document.all) {
                        window.resizeTo(screen.availWidth, screen.availHeight);
                    }

                    else if (document.layers || document.getElementById) {
                        if (window.outerHeight < screen.availHeight || window.outerWidth < screen.availWidth) {
                            window.outerHeight = screen.availHeight;
                            window.outerWidth = screen.availWidth;
                        }
                    }
                }
                catch (exception) { }
                finally { }

                document.location.href = "EPMain.ASPX";
            }
        }
    </script>
</head>
<body class="login_bg" >
    <form id="frmLogin" runat="server" method="post">
        <ext:ResourceManager ID="ResourceManager1" runat="server"><Listeners><DocumentReady Handler="ExtDocumentReady();" /></Listeners></ext:ResourceManager>
        <ext:Hidden ID="HiddenLanguage" runat="server"></ext:Hidden>
        <ext:Hidden ID="TextFieldLogin" runat="server"></ext:Hidden>
    </form>
</body>
</html>
