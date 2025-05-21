<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ImageView.aspx.cs" Inherits="Ax.SRM.WP.ImageView" %>
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

    <title>Image Viewer</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />

    <script type="text/javascript">
        function Print() {
            window.onbeforeprint = function () { document.getElementById("ControlBar").style.display = "none"; };
            window.onafterprint = function () { document.getElementById("ControlBar").style.display = "block"; };
            window.print();
        }

        function Close() {
            if (parent.ImageZoomPopWindowHandler)
                parent.ImageZoomPopWindowHandler.hide();
        }

        function RenderImage(_src) {            
            document.getElementById("SrcImg").src = _src;
            document.getElementById("NewImg").src = _src;

            window.onload();
            window.onresize();
        }

        window.onload = function anonymoys() {

            var srcImg = document.getElementById("SrcImg");
            var newImg = document.getElementById("NewImg");

            // 사이즈 자동 조철
            if (srcImg.width < newImg.width) {
                newImg.style.width = "";
                newImg.style.height = "";
            };

            srcImg.style.display = "none";
        }

        window.onresize = function anonymous() {

            var srcImg = document.getElementById("SrcImg");
            var newImg = document.getElementById("NewImg");

            srcImg.style.display = "block";
            newImg.style.width = "100%";
            newImg.style.height = "100%";

            // 사이즈 자동 조철
            if (srcImg.width < newImg.width) {
                newImg.style.width = "";
                newImg.style.height = "";
            };

            srcImg.style.display = "none";
        }
    </script>
</head>
<body style="margin:5px 5px 0px 5px;">
    <div id="ControlBar" style="height:30px; text-align:right;">
    <a href="javascript:Print();"><img src="/images/btn/btn_print.gif"  style="border-width:0px;" /></a>&nbsp;<a href="javascript:Close();"><img src="/images/btn/btn_close.gif" style="border-width:0px;" /></a>
    </div>
    <img id="NewImg" runat="server" src="/images/etc/no_image.gif" style="width:100%; height:100%; border:1px solid #000000;"/>
    <img id="SrcImg" runat="server" src="/images/etc/no_image.gif" style="border-width:0px;"/>
</body>
</html>
