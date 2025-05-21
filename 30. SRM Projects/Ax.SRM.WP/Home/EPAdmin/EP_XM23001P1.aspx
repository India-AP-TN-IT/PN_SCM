<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM23001P1.aspx.cs" Inherits="Ax.EP.WP.Home.EPAdmin.EP_XM23001P1" %>
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

    <title>Notice Popup</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            UI_Resize()
        }

        function UI_Resize() {
            document.getElementById("div_CONTENTS").style.height = "22px"
            var H = App.ConditionPanel.getHeight() - document.getElementById("table_Main").offsetHeight + 22 - 3;
            document.getElementById("div_CONTENTS").style.height = H + "px";
        }
    </script>
</head>
<body>
    <form id="EP_XM23001P1" runat="server">
    <%-- Ext.NET 사용 시 필수 입력 --%>
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:TextField ID="NOSEQ" runat="server" Hidden="true"/>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="0">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" >
                <Content>
                    <div class="popup_area">
                        <h1>
                            <ext:Label ID="lbl01_EP_XM23001P1" runat="server" Text="Notice" />
                            <ext:ImageButton ID="ImageButton2" runat="server" ImageUrl="../../images/main/close.gif" Cls="pop_close">
                                <Listeners>
                                    <Click Handler="hidePop()" />
                                </Listeners>
                            </ext:ImageButton>
                        </h1>
                    </div>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="Center" Cls="search_area_table lrmargin10" StyleSpec="margin-bottom: 0px;" runat="server">
                <Content>
                    <table id="table_Main" style="width:100%; height:0px;">
                        <colgroup>
                            <col id="c1" style="width:17%;" />
                            <col id="c2" style="width:16%;" />
                            <col id="c3" style="width:17%;" />
                            <col id="c4" style="width:16%;" />
                            <col id="c5" style="width:17%;" />
                            <col id="c6" style="width:17%;" />
                        </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_IMPT_DIV" runat="server" Text="중요도" />
                            </th>
                            <td>
                                <ext:Label ID="lbl01_IMPT_DIV_CONTENT" Flex="1" type="inputtext"  runat="server"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_REGISTER" runat="server" Text="등록자"  />
                            </th>
                            <td>
                                <ext:Label ID="lbl01_INSERT_ID_CONTENT" Flex="1"  type="inputtext"  runat="server"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_REGDATE" runat="server" Text="등록일" />
                            </th>
                            <td>
                                <ext:Label ID="lbl01_INSERT_DATE_CONTENT" Flex="1" type="inputtext" runat="server"/>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_SUBJECT" runat="server" Text="제목" />
                            </th>
                            <td colspan="5">
                                <ext:TextField ID="txtSUBJECT" ReadOnly="true" type="inputtext" Width="631" FieldStyle="border:0px; width:100%;" runat="server"/>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_CONTENTS" runat="server" Text="내용" />
                            </th>
                            <td colspan="5" id="td_CONTENTS" style="vertical-align:top;">
                                <div id="div_CONTENTS" style="padding:0px;margin:0px; overflow-x:hidden;overflow-y:auto;">
                                    <%=vContents%>
                                </div>
                            </td>
                        </tr>
                        <% if (vFileCount > 0)
                            {  %>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_ATTACHMENT" runat="server" Text="첨부" />
                            </th>
                            <td colspan="5" id="td_FILES" style="padding-bottom: 6px">
                                <table>
                                    <tr><td><ext:Hyperlink ID="dwn02_FILEID1" runat="server" NavigateUrl="" Text="" Hidden="true" StyleSpec="color:#000;float:left;" /></td></tr>
                                    <tr><td><ext:Hyperlink ID="dwn02_FILEID2" runat="server" NavigateUrl="" Text="" Hidden="true" StyleSpec="color:#000;float:left;" /></td></tr>
                                    <tr><td><ext:Hyperlink ID="dwn02_FILEID3" runat="server" NavigateUrl="" Text="" Hidden="true" StyleSpec="color:#000;float:left;" /></td></tr>
                                </table>
                            </td>
                        </tr>
                        <%} %>
                        <tr>
                            <th>
                                <img src="../../images/common/pre_arrow.png" style="vertical-align: middle;" />
                                <ext:Label ID="lbl01_PREVIOUS" runat="server" Text="이전글" />
                            </th>
                            <td colspan="5">
                                <ext:Label ID="LabelBefore" runat="server" StyleSpec="float: left; width:100%;">
                                </ext:Label>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <img src="../../images/common/next_arrow.png" style="vertical-align: middle;" />
                                <ext:Label ID="lbl01_NEXT" runat="server" Text="다음글" />
                            </th>
                            <td colspan="5">
                                <ext:Label ID="LabelAfter" runat="server" StyleSpec="float: left; width:100%;">
                                </ext:Label>
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
