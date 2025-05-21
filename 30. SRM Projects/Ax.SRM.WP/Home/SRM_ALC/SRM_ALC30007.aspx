<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_ALC30007.aspx.cs" Inherits="Ax.EP.WP.Home.SRM_ALC.SRM_ALC30007" %>
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

    <title>Popup</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
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
    <form id="SRM_ALC30007" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize" />
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" >
                <Items>
                    <ext:Label ID="lbl01_SRM_ALC30007" runat="server" Cls="search_area_title_name" /><%--Text="월별 집계 출력" />--%>
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
                            <col style="width: 300px;" />
                            <col style="width: 100px;" />
                            <col />
                        </colgroup>                        
                        <tr>   
							<th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server"/>

                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>  
                            <th class="ess">
                                <ext:Label ID="lbl01_YYMM" runat="server" /> <%--Text="년월" --%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_YYMM" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />                                
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
