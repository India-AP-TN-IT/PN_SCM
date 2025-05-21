<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP30010P1.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MP.SRM_MP30010P1" %>
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

    <title>일별 납품 현황 Popup</title>

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
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        var fn_sendParentWindow = function (popupID, objectID, typeNM, typeCD, record) {
            parent.fn_SetValues(popupID, objectID, typeNM, typeCD, Ext.decode(record));
        }

    </script>
</head>
<body>
    <form id="SRM_PopCustItemcdGrid" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MP30010P1" runat="server" Cls="search_area_title_name"  /> <%--Text="일별 검수현황"--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>

            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="RCV_DATE"/>
                                            <ext:ModelField Name="PONO"/>
                                            <ext:ModelField Name="RCV_UCOST"/>
                                            <ext:ModelField Name="RCV_QTY"/>
                                            <ext:ModelField Name="RCV_AMT"/>
                                            <ext:ModelField Name="ARRIV_DATE"/>
                                            <ext:ModelField Name="ARRIV_QTY"/>
                                            <ext:ModelField Name="DELINO"/>
                                            <ext:ModelField Name="DELI_DATE"/>
                                            <ext:ModelField Name="DELI_QTY"/>
                                        </Fields>
                                    </ext:Model>
                                </Model>
                                <Listeners>
                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                    <Load Delay="1" Handler="GridStoreReady(App.GridStatus1, this.getTotalCount());  "></Load>
                                </Listeners>
                            </ext:Store>
                        </Store>
                        <Plugins>
                            <ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:DateColumn ID="RCV_DATE" ItemID="ACP_DATE" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" />  <%--Text="검수일자"--%> 
                                <ext:Column ID="PONO" ItemID="PONO" runat="server" DataIndex="PONO" MinWidth="80" Align="Center" Flex="1" />  <%--Text="발주번호"--%>
                                <ext:Column ID="ACP_INFO02" ItemID="ACP_INFO02" runat="server">  <%--Text="검수정보"--%>
                                    <Columns>
                                        <ext:NumberColumn ID="RCV_UCOST" ItemID="UCOST" runat="server" DataIndex="RCV_UCOST" Width="80" Align="Right" Format="#,##0" />  <%--Text="단가"--%> 
                                        <ext:NumberColumn ID="RCV_QTY" ItemID="QTY" runat="server" DataIndex="RCV_QTY" Width="60" Align="Right" Format="#,##0" />  <%--Text="수량"--%> 
                                        <ext:NumberColumn ID="RCV_AMT" ItemID="AMT" runat="server" DataIndex="RCV_AMT" Width="80" Align="Right" Format="#,##0" />  <%--Text="금액"--%> 
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="DELINO03" ItemID="DELINO03" runat="server">  <%--Text="거래명세서정보"--%>
                                    <Columns>
                                        <ext:Column ID="DELINO" ItemID="DELINO02" runat="server" DataIndex="DELINO" Width="120" Align="Center" />  <%--Text="거래명세서번호"--%>                                  
                                        <ext:DateColumn ID="DELI_DATE" ItemID="PRINTDATE" runat="server" DataIndex="DELI_DATE" Width="80" Align="Center" />  <%--Text="발행일자"--%> 
                                        <ext:NumberColumn ID="DELI_QTY" ItemID="QTY" runat="server" DataIndex="DELI_QTY" Width="60" Align="Right" Format="#,##0" />  <%--Text="수량"--%> 
                                    </Columns>
                                </ext:Column>
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>                            
                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single"/>
                        </SelectionModel>                            
                                          
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>

        </Items>
    </ext:Viewport>

    </form>
</body>
</html>
