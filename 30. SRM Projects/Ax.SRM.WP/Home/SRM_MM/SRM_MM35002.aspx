<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM35002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM35002" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" >
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="HE.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="HE.POTAL" />

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
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
    <form id="SRM_MM35002" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM35002" runat="server" Cls="search_area_title_name" /><%--Text="2시간대별 투입현황" />--%>
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
                            <col style="width: 150px;" />
                            <col style="width: 300px;" />
                            <col style="width: 150px;" />
                            <col style="width: 300px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60" />                                    
                            </td>   
                            <th>
                                <ext:Label ID="lbl01_SAUP" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store5" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model1" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="BIZCD" />
                                                        <ext:ModelField Name="BIZCDTYPE" />
                                                        <ext:ModelField Name="BIZNM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_INPUT_DATE" runat="server" /><%--Text="투입일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_INPUT_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />                                
                            </td>
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" /><%--차종--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_MAT_ITEM" runat="server" /><%--Text="자재품목" /> --%>                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_MAT_ITEM" OnDirectEventChange="Button_Click" runat="server" ClassID="E0" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td> 
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" />     
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
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="MAT_ITEM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="MAT_INPUT_QTY" />
                                            <ext:ModelField Name="BAS_INV_OK_QTY" />
                                            <ext:ModelField Name="REQ_QTY" />
                                            <ext:ModelField Name="SUMQTY" />
                                            <ext:ModelField Name="T0709" />
                                            <ext:ModelField Name="T0911" />
                                            <ext:ModelField Name="T1113" />
                                            <ext:ModelField Name="T1315" />
                                            <ext:ModelField Name="T1517" />
                                            <ext:ModelField Name="T1719" />
                                            <ext:ModelField Name="T1921" />
                                            <ext:ModelField Name="T2123" />
                                            <ext:ModelField Name="T2301" />
                                            <ext:ModelField Name="T0103" />
                                            <ext:ModelField Name="T0305" />
                                            <ext:ModelField Name="T0507" />                                            
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
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center"  />
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD"  Width="50" Align="Center"  /><%--Text="차종"  --%>
                                <ext:Column ID="MAT_ITEM" ItemID="MAT_ITEM" runat="server" DataIndex="MAT_ITEM"  Width="120" Align="Center"  /><%--Text="자재품목"  --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left"  /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME" --%>
                                <ext:Column ID="STANDARD" ItemID="STANDARD" runat="server" DataIndex="STANDARD" MinWidth="120" Align="Left" Flex="1"/> <%--Text="규격" --%>
                                <ext:NumberColumn ID="MAT_INPUT_QTY" ItemID="MAT_INPUT_QTY" runat="server" DataIndex="MAT_INPUT_QTY" Width="60" Align="Right" Format="#,##0"/> <%--Text="전일투입"--%>
                                <ext:NumberColumn ID="BAS_INV_OK_QTY" ItemID="BAS_INV_OK_QTY" runat="server" DataIndex="BAS_INV_OK_QTY" Width="60" Align="Right" Format="#,##0"/> <%--Text="기초재고"--%>                                 
                                <ext:NumberColumn ID="REQ_QTY" ItemID="PROD_PLAN" runat="server" DataIndex="REQ_QTY" Width="60" Align="Right" Format="#,##0"/> <%--Text="생산계획"--%>
                                
                                <ext:Column ID="MAT_INPUT_RSLT" ItemID="MAT_INPUT_RSLT" runat="server" ><%--Text="자재투입실적">--%>
                                    <Columns> 
                                        <ext:NumberColumn ID="SUMQTY" ItemID="TOTAL" runat="server" DataIndex="SUMQTY" Width="55" Align="Right" Format="#,##0" Sortable="true" /><%--합계--%>
                                        <ext:NumberColumn ID="T0709" ItemID="T0709" runat="server" DataIndex="T0709" Width="50" Align="Right" Text="07~09" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T0911" ItemID="T0911" runat="server" DataIndex="T0911" Width="50" Align="Right" Text="09~11" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T1113" ItemID="T1113" runat="server" DataIndex="T1113" Width="50" Align="Right" Text="11~13" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T1315" ItemID="T1315" runat="server" DataIndex="T1315" Width="50" Align="Right" Text="13~15" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T1517" ItemID="T1517" runat="server" DataIndex="T1517" Width="50" Align="Right" Text="15~17" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T1719" ItemID="T1719" runat="server" DataIndex="T1719" Width="50" Align="Right" Text="17~19" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T1921" ItemID="T1921" runat="server" DataIndex="T1921" Width="50" Align="Right" Text="19~21" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T2123" ItemID="T2123" runat="server" DataIndex="T2123" Width="50" Align="Right" Text="21~23" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T2301" ItemID="T2301" runat="server" DataIndex="T2301" Width="50" Align="Right" Text="23~01" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T0103" ItemID="T0103" runat="server" DataIndex="T0103" Width="50" Align="Right" Text="01~03" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T0305" ItemID="T0305" runat="server" DataIndex="T0305" Width="50" Align="Right" Text="03~05" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="T0507" ItemID="T0507" runat="server" DataIndex="T0507" Width="50" Align="Right" Text="05~07" Format="#,##0" Sortable="true" />                                        
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
