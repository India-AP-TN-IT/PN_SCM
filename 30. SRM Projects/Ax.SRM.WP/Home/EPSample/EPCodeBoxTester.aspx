<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EPCodeBoxTester.aspx.cs" Inherits="Ax.EP.WP.Home.EPSample.EPCodeBoxTest" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
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

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();


            //App.cdx01_VINCD_TYPECD.setValue("dd")
            //Ext.getCmp("cdx01_VINCD_TYPECD").setValue("ddd");
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            //App.Grid01.setHeight(App.GridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }
     
    </script>
</head>
<body>
    <form id="EP20S01" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_EPCodeBoxTester" runat="server" Cls="search_area_title_name" Text="테스트" />
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 100px;" />
                            <col />
                            <col style="width: 100px;" />
                            <col />
                            <col style="width: 100px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_VINCD" runat="server" Text="Vehicle Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_ITEMCD" runat="server" Text="Item Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_ITEMCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A4" PopupMode="Search" PopupType="CodeWindow"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_ETC" runat="server" Text="Etc User Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_ETC" OnDirectEventChange="Button_Click" runat="server" HelperID="USER_LINECD" PopupMode="Search" PopupType="UserWindow" 
                                                OnBeforeDirectButtonClick="CodeBox_BeforeDirectButtonClick"
                                                OnCustomRemoteValidation="CodeBox_CustomRemoteValidation"
                                                UserHelpURL="../SRMHelper/SRM_VenderCode.aspx"
                                                 />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_VENDCD" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" OnDirectEventChange="Button_Click" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_CUSTCD" runat="server" Text="Cust Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" OnDirectEventChange="Button_Click" runat="server" HelperID="HELP_CUSTCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_PARTNO" runat="server" Text="Part No" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_PARTNO" WidthTYPECD="100" OnDirectEventChange="Button_Click" runat="server" HelperID="HELP_PARTNO" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ResultPanel" Region="Center" runat="server">
                <Items>
                    <ext:Label ID="lblResult" runat="server" Text=""></ext:Label>
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
