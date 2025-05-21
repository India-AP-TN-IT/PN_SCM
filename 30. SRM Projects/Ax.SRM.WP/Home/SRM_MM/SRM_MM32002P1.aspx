<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM32002P1.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM32002P1" %>
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
    <form id="SRM_MM32002P1" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM32002P1" runat="server" Cls="search_area_title_name" Text="일별/월별 상세조회" />
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
                            <col />                            
                            <col style="width: 100px;" />
                            <col style="width: 130px;" />
                        </colgroup>                        
                        <tr>
                            <th style="width:100px;">         
                                <ext:Label ID="lbl01_PARTNO" runat="server" Text="PART NO" /><%--Text="PART NO" /> --%>                      
                            </th>
                            <td >
                                <ext:Label ID="PARTNO" runat="server"/>
                            </td>
                            <th style="width:100px;">         
                                <ext:Label ID="lbl01_PARTNM" runat="server" Text="PART NAME" /><%--Text="PART NAME" /> --%>                      
                            </th>
                            <td>
                                <ext:Label ID="PARTNM" runat="server" />
                            </td>
                            <th style="width:100px;">         
                                <ext:Label ID="lbl01_UNIT" runat="server" Text="UNIT" /><%--Text="UNIT" /> --%>                      
                            </th>
                            <td>
                                <ext:Label ID="UNIT" runat="server" />
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
                                            <ext:ModelField Name="DELI_DATE"/>
                                            <ext:ModelField Name="STR_LOC"/>
                                            <ext:ModelField Name="STR_LOCNM"/>
                                            <ext:ModelField Name="DELI_QTY"/>                       
                                            <ext:ModelField Name="OK_QTY"/>                       
                                            <ext:ModelField Name="NG_QTY"/>                       
                                            <ext:ModelField Name="UPDATE_ID"/>                       
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
                                <ext:Column            ID="DELI_DATE" ItemID="DELI_DATE" runat="server" DataIndex="DELI_DATE" Width="80"  Align="center" Text="납품일자" />
                                <ext:Column            ID="STR_LOCNM" ItemID="STR_LOCNM" runat="server" DataIndex="STR_LOCNM" Width="80"  Align="left" Text="저장위치"/>
                                <ext:NumberColumn      ID="DELI_QTY"        ItemID="DELI_QTY"         runat="server" DataIndex="DELI_QTY"    Width="100"  Align="Right"  Format="#,##0.###" Text="납품수량"/>
                                <ext:NumberColumn      ID="OK_QTY"        ItemID="OK_QTY"         runat="server" DataIndex="OK_QTY"    Width="100"  Align="Right"  Format="#,##0.###" Text="합격수량"/>
                                <ext:NumberColumn      ID="NG_QTY"        ItemID="DEF_QTY"         runat="server" DataIndex="NG_QTY"    Width="100"  Align="Right"  Format="#,##0.###" Text="불량수량"/>
                                <ext:Column            ID="UPDATE_ID" ItemID="UPDATE_ID3" runat="server" DataIndex="UPDATE_ID" Width="100"  Align="left" Text="최종수정ID" />
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
