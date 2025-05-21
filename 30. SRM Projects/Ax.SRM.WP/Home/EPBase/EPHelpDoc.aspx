<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EPHelpDoc.aspx.cs" Inherits="Ax.EP.WP.Home.EPBase.EPHelpDoc" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image">
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>Help Documents</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        var downloadHelp = function (fname, fnamesrc) {
            if (document.getElementById("loggbn").value == "1") {
                FileDirectDownloadByPath(document, fnamesrc);
            }
            else {
                FileDirectDownloadByPath(document, fname);
            }
        }

        function UI_Shown() {
            UI_Resize()
        }

        function UI_Resize() {
            
        }
        
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <!-- size : 360x260 -->
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="60">
                <Content>
                    <div class="pop_help" style="height:60px;">
                        <h1 style="padding-top:14px;">
                            <ext:Label ID="lbl01_EPHelpDoc" runat="server" Text="Help Documents" />
                            <ext:ImageButton ID="ImageButton2" runat="server" ImageUrl="../../images/main/close.gif" Cls="pop_close">
                                <Listeners>
                                    <Click Handler="hidePop()" />
                                </Listeners>
                            </ext:ImageButton>
                        </h1>
                    </div>
                    <input type="hidden" runat="server" id="loggbn" />
                </Content>
            </ext:Panel>
            <ext:Panel ID="ContentPanel" runat="server" Cls="popup_table" Region="Center">
                <Content>
                    <table style="width:100%">
                        <colgroup>
                            <col style="width:35%;" />
                            <col style="width:30%;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th colspan="2">
                                <ext:Label ID="Label2" Text="Help Name" runat="server">
                                </ext:Label>
                            </th>
                            <th class="nlr">
                                <ext:Label ID="Label4" Text="Download" runat="server">
                                </ext:Label>
                            </th>
                        </tr>
                        <tr>
                            <th>
                                SRM Manual
                            </th>
                            <td>
                                User Manual
                            </td>
                            <td class="a_code">
                                <ext:ImageButton ID="ImageBtnPartner" runat="server" ImageUrl="../../images/btn/btn_down.gif"
                                    Cls="Download">
                                    <Listeners>
                                        <%--<Click Handler="downloadHelp('manual/SAP用SCM메뉴얼.pdf','manual/src/SAP用SCM메뉴얼.pptx')" />--%>
                                        <Click Handler="downloadHelp('manual/SCM_User_Manual.pdf','manual/src/SCM_User_Manual.pptx')" />
                                    </Listeners>
                                </ext:ImageButton>
                            </td>
                        </tr>
                        <%--<tr>
                            <th>
                                Seoyon E-hwa User
                            </th>
                            <td>
                                Contact Manual
                            </td>
                            <td class="a_code">
                                <ext:ImageButton ID="ImageButton9" runat="server" ImageUrl="../../images/btn/btn_down.gif"
                                    Cls="Download">
                                    <Listeners>
                                        <Click Handler="downloadHelp('manual/GD_TI21_사용자지침서_웹포탈.pdf')" />
                                    </Listeners>
                                </ext:ImageButton>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                BarCode Printer Driver
                            </th>
                            <td>
                                ZM400 BarCode Printer Driver
                            </td>
                            <td class="a_code">
                                <ext:ImageButton ID="ImageButton4" runat="server" ImageUrl="../../images/btn/btn_down.gif"
                                    Cls="Download">
                                    <Listeners>
                                        <Click Handler="downloadHelp('ZM400.exe')" />
                                    </Listeners>
                                </ext:ImageButton>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                BarCode Printer Manual
                            </th>
                            <td>
                                ZM400 BarCode Printer Manual
                            </td>
                            <td class="a_code">
                                <ext:ImageButton ID="ImageButton1" runat="server" ImageUrl="../../images/btn/btn_down.gif"
                                    Cls="Download">
                                    <Listeners>
                                        <Click Handler="downloadHelp('manual/GD_TI21_사용자지침서_웹포탈_PRINT.pdf')" />
                                    </Listeners>
                                </ext:ImageButton>
                            </td>
                        </tr>--%>
                    </table>
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
