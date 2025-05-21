<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM26001P1.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM26001P1" %>
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
            App.Grid01.setHeight(App.GridPanel.getHeight());
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
    <form id="SRM_MM26001P1" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM26001P1" runat="server" Cls="search_area_title_name" />
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
                            <col style="width: 130px;" />
                            <col style="width: 100px;" />
                            <col style="width: 200px;" />
                            <col style="width: 100px;" />
                            <col />
                        </colgroup>                        
                        <tr>                            
                            <th style="width:100px;">         
                                <ext:Label ID="lbl01_PARTNO" runat="server" />
                            </th>
                            <td >
                                <ext:TextField ID="txt01_PARTNO" Width="120" Cls="inputText" runat="server" ReadOnly="true" />        
                            </td>            
                            <th style="width:100px;">         
                                <ext:Label ID="lbl01_PARTNM" runat="server" />
                            </th>
                            <td >
                                <ext:TextField ID="txt01_PARTNM" Width="190" Cls="inputText" runat="server" ReadOnly="true" />        
                            </td>
                            <th style="width:100px;">         
                                <ext:Label ID="lbl01_UNIT" runat="server" /><%--Text="UNIT" /> --%>                      
                            </th>
                            <td>
                                <ext:TextField ID="txt01_UNIT" runat="server" Width="100" Cls="inputText" runat="server" ReadOnly="true" />        
                            </td>            
                        </tr>                        
                    </table>
                </Content>
            </ext:Panel>
            
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="RESALE_REQNO"/>
                                            <ext:ModelField Name="ARRIV_REQ_DATE"/>
                                            <ext:ModelField Name="REQ_DATE"/>
                                            <ext:ModelField Name="REQ_QTY"/>
                                            <ext:ModelField Name="CHK_MGRNM"/>                       
                                            <ext:ModelField Name="CHK_YN"/>                       
                                            <ext:ModelField Name="CHK_DATE"/>
                                            <ext:ModelField Name="ZRSLT_SAP"/>
                                            <ext:ModelField Name="ZDATE_PO"/>
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
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:Column            ID="RESALE_REQNO" ItemID="RESALE_REQNO" runat="server" DataIndex="RESALE_REQNO" Width="140"  Align="center" />
                                <ext:Column            ID="ARRIV_REQ_DATE" ItemID="DELI_REQ_DATE" runat="server" DataIndex="ARRIV_REQ_DATE" Width="80"  Align="center" />                                
                                <ext:Column            ID="REQ_DATE" ItemID="REQ_DATE" runat="server" DataIndex="REQ_DATE" Width="80"  Align="center" />
                                <ext:NumberColumn      ID="REQ_QTY"        ItemID="CONF_QTY"         runat="server" DataIndex="REQ_QTY"    Width="80"  Align="Right"  Format="#,##0" />
                                <ext:Column            ID="CHK_MGRNM" ItemID="CHR_NM" runat="server" DataIndex="CHK_MGRNM" Width="80"  Align="center" />                                        
                                <ext:Column            ID="CHK_YN" ItemID="CONFYN" runat="server" DataIndex="CHK_YN" Width="70"  Align="center" />
                                <ext:Column            ID="CHK_DATE" ItemID="CONFIRM_DATE" runat="server" DataIndex="CHK_DATE" MinWidth="100" Align="center" />
                                <ext:Column            ID="ZRSLT_SAP" ItemID="RSLT_SAP" runat="server" DataIndex="ZRSLT_SAP" MinWidth="100" Align="center" />
                                <ext:Column            ID="ZDATE_PO" ItemID="ZDATE_PO" runat="server" DataIndex="ZDATE_PO" MinWidth="160" Flex="1" Align="center" />
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
<%--            <ext:Panel ID="BottomButtonPanel" runat="server" Region="South" Height="23" Cls="bottom_area_btn">
                <Items>
                    <ext:Label ID="QTY_AMT" runat="server" />
                </Items>
            </ext:Panel>--%>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
