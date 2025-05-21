<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM23001P2.aspx.cs" Inherits="Ax.EP.WP.Home.EPAdmin.EP_XM23001P2" %>
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
 
    <title>Notice Open Popup</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script src="../../Script/PopupCookie.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            UI_Resize()
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            var H = App.ContentPanel.getHeight() - document.getElementById("notice_popup_s2").offsetHeight - 42 - 7;
            document.getElementById("DIV_CONTENT").style.height = H + "px";
        }

        var fn_fileDisplay = function (e) {
            document.getElementById(e).style.display = "";
        };

    </script>
    <%--4.X--%>
    <style type="text/css">
        .x-form-cb-label{color:White;}
    </style>
</head>
<body>
    <form id="EP_XM23001P2" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout">
         <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="45">
                <Content>
                    <div class="notice_popup_t">
                        <h1 style="padding-top:11px;">
                            <ext:Label ID="lbl01_NOTICE_TITLE" runat="server" Text="Subject" />
                        </h1>
                    </div>
                    <ext:TextField ID="NOSEQ" runat="server" Hidden="true" />
                    <ext:TextField ID="CORCD" runat="server" Hidden="true" />
                </Content>
            </ext:Panel>

            <ext:Panel ID="Panel1" runat="server" Region="North" Height="25">
                <Content>
                    <div >
                        <h1 style="padding-top:3px;float:left;margin-left:10px;">
                            <ext:Label ID="lbl01_WRITER" runat="server" Text="설수정" />
                        </h1>
                        <h1 style="padding-top:3px;float:right;margin-right:10px;">
                            <ext:Label ID="lbl01_WRITE_DATE" runat="server" Text="2017-01-01" />
                        </h1>
                    </div>
                </Content>
            </ext:Panel>

            <ext:Panel ID="ContentPanel" Region="Center" runat="server" Cls="notice_popup_c" StyleSpec="padding-bottom:0px;">
                <Content>
                    <div id="DIV_CONTENT" runat="server" style="padding:0px;margin:0px; height:100px; overflow-x:hidden; vertical-align:top; overflow-y:auto;">
                    </div>
                    <div id="notice_popup_s2">
                        <ul class="notice_popup_file" runat="server" visible="false" id="FileList">
                            <li id="liFileId1" style="display: none;">
                                <span><ext:Hyperlink ID="dwn01_FILEID1" runat="server" /></span>
                            </li>
                            <li id="liFileId2" style="display: none;">
                                <span><ext:Hyperlink ID="dwn01_FILEID2" runat="server" /></span>
                            </li>
                            <li id="liFileId3" style="display: none;">
                                <span><ext:Hyperlink ID="dwn01_FILEID3" runat="server"  /></span>
                            </li>
                        </ul>
                    </div>
                </Content>
            </ext:Panel>
            <ext:Panel ID="BottomPanel" Height="27"  Region="South" runat="server" BodyCls="notice_close">
                <Content>
                    <div class="fl pl10" style="width:260px">
                        <ext:Checkbox ID="chkShow" ItemID="SHOW" Name="chkShow" Checked="false" runat="server" Hidden="true" BoxLabel="Not popup no longer(더이상 안보기)"/>
                    </div>
                    <div class="fl pl10" style="width:280px">
                        <ext:Checkbox ID="chkDayShow" ItemID="DAYSHOW" Name="chkDayShow" Checked="false" runat="server" BoxLabel="Not popup only one day(하루만 안보기)"/>
                    </div>
                    <div class="fr pr10">
                        <ext:ImageButton Align="AbsMiddle" ID="btn01_CLOSE" runat="server" ImageUrl="../../images/btn/btn_notice_close.gif" OnClientClick="hidePop();" />
                    </div>
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
