<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM30002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM30002" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" >
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
    <form id="SRM_MM30002" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM30002" runat="server" Cls="search_area_title_name" /><%--Text="MIP A/S/K 자재소요계획 현황" />--%>
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
                            <col style="width: 300px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>   
                            <th class="ess">
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
                                <ext:Label ID="lbl01_PLAN_DATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_DELI_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />                                
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" />
                            </th>
                            <td>                                
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store33" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model33" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>
                        </tr> 
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" />                     
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                    
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />                                
                            </td>
                            <th>
                                <ext:Label ID="lbl01_CUSTOMER" runat="server" /><%--Text="고객사" />--%>
                            </th>
                            <td colspan="3">
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
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
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />                                            
                                            <ext:ModelField Name="SUM_TOT" />
                                            <ext:ModelField Name="ALL_SUM_TOT" />
                                            <ext:ModelField Name="D0" />
                                            <ext:ModelField Name="D1" />
                                            <ext:ModelField Name="D2" />
                                            <ext:ModelField Name="D3" />
                                            <ext:ModelField Name="D4" />
                                            <ext:ModelField Name="D5" />
                                            <ext:ModelField Name="D6" />
                                            <ext:ModelField Name="D7" />
                                            <ext:ModelField Name="D8" />
                                            <ext:ModelField Name="D9" />
                                            <ext:ModelField Name="D10" />
                                            <ext:ModelField Name="D11" />
                                            <ext:ModelField Name="D12" />
                                            <ext:ModelField Name="D13" />
                                            <ext:ModelField Name="D14" />
                                            <ext:ModelField Name="D15" />
                                            <ext:ModelField Name="D16" />
                                            <ext:ModelField Name="D17" />
                                            <ext:ModelField Name="D18" />
                                            <ext:ModelField Name="D19" />
                                            <ext:ModelField Name="D20" />
                                            <ext:ModelField Name="D21" />
                                            <ext:ModelField Name="D22" />
                                            <ext:ModelField Name="D23" />
                                            <ext:ModelField Name="D24" />
                                            <ext:ModelField Name="D25" />
                                            <ext:ModelField Name="D26" />
                                            <ext:ModelField Name="D27" />
                                            <ext:ModelField Name="D28" />
                                            <ext:ModelField Name="D29" />
                                            <ext:ModelField Name="D30" />
                                            <ext:ModelField Name="FORECAST" />
                                            <ext:ModelField Name="CUST" />
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
                                <ext:RowNumbererColumn ID="NO"      ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center"  />
                                <ext:Column ID="VINCD"              ItemID="VIN"       runat="server" DataIndex="VINCD"      Width="60" Align="Center" /><%--Text="차종"      --%>
                                <ext:Column ID="PARTNO"             ItemID="PARTNO"    runat="server" DataIndex="PARTNO"     Width="120" Align="Left"  /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM"             ItemID="PARTNM"    runat="server" DataIndex="PARTNM"     MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME" --%>                                
                                <ext:NumberColumn ID="SUM_TOT"      ItemID="SUM_TOT"     runat="server" DataIndex="SUM_TOT"      Width="80" Align="Right" Format="#,##0.###"/><%--Text="확정합계"  --%>  
                                <ext:NumberColumn ID="ALL_SUM_TOT"  ItemID="SUMTOT_QTY" runat="server" DataIndex="ALL_SUM_TOT"  Width="80" Align="Right" Format="#,##0.###"/><%--Text="전체합계"  --%>                                
                                <ext:NumberColumn ID="D0"           ItemID="D0"     runat="server" DataIndex="D0"     Text="D+0"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D1"           ItemID="D1"     runat="server" DataIndex="D1"     Text="D+1"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D2"           ItemID="D2"     runat="server" DataIndex="D2"     Text="D+2"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D3"           ItemID="D3"     runat="server" DataIndex="D3"     Text="D+3"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D4"           ItemID="D4"     runat="server" DataIndex="D4"     Text="D+4"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D5"           ItemID="D5"     runat="server" DataIndex="D5"     Text="D+5"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D6"           ItemID="D6"     runat="server" DataIndex="D6"     Text="D+6"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D7"           ItemID="D7"     runat="server" DataIndex="D7"     Text="D+7"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D8"           ItemID="D8"     runat="server" DataIndex="D8"     Text="D+8"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D9"           ItemID="D9"     runat="server" DataIndex="D9"     Text="D+9"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D10"          ItemID="D10"    runat="server" DataIndex="D10"    Text="D+10"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D11"          ItemID="D11"    runat="server" DataIndex="D11"    Text="D+11"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D12"          ItemID="D12"    runat="server" DataIndex="D12"    Text="D+12"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D13"          ItemID="D13"    runat="server" DataIndex="D13"    Text="D+13"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D14"          ItemID="D14"    runat="server" DataIndex="D14"    Text="D+14"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D15"          ItemID="D15"    runat="server" DataIndex="D15"    Text="D+15"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D16"          ItemID="D16"    runat="server" DataIndex="D16"    Text="D+16"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D17"          ItemID="D17"    runat="server" DataIndex="D17"    Text="D+17"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D18"          ItemID="D18"    runat="server" DataIndex="D18"    Text="D+18"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D19"          ItemID="D19"    runat="server" DataIndex="D19"    Text="D+19"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D20"          ItemID="D20"    runat="server" DataIndex="D20"    Text="D+20"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D21"          ItemID="D21"    runat="server" DataIndex="D21"    Text="D+21"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D22"          ItemID="D22"    runat="server" DataIndex="D22"    Text="D+22"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D23"          ItemID="D23"    runat="server" DataIndex="D23"    Text="D+23"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D24"          ItemID="D24"    runat="server" DataIndex="D24"    Text="D+24"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D25"          ItemID="D25"    runat="server" DataIndex="D25"    Text="D+25"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D26"          ItemID="D26"    runat="server" DataIndex="D26"    Text="D+26"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D27"          ItemID="D27"    runat="server" DataIndex="D27"    Text="D+27"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D28"          ItemID="D28"    runat="server" DataIndex="D28"    Text="D+28"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D29"          ItemID="D29"    runat="server" DataIndex="D29"    Text="D+29"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D30"          ItemID="D30"    runat="server" DataIndex="D30"    Text="D+30"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="FORECAST"     ItemID="FORECAST" runat="server" DataIndex="FORECAST"   Width="80" Align="Right" Format="#,##0.###"/><%--Text="미확정량"  --%>
                                <ext:Column ID="CUST"               ItemID="CUSTOMER" runat="server" DataIndex="CUST"       Width="80" Align="Center"/><%--Text="고객사"      --%>                               
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
