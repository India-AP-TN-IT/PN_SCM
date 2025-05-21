<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM30012.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM30012" %>
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
            App.Grid02.setHeight(App.GridPanel.getHeight());
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
    <form id="SRM_MM30012" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM30012" runat="server" Cls="search_area_title_name" /><%--Text="MIP A/S/K 자재소요계획 현황" />--%>
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
                            <th>
                                <ext:Label ID="lbl01_SEARCH_OPT" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SEARCH_OPT" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="200">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_SEARCH_OPT_Change" />
                                    </DirectEvents>
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
                                <ext:Label ID="lbl01_MIP_PARTNO_PER" runat="server" />                    
                            </th>
                            <td>
                                <ext:TextField ID="txt01_PARTNO" Width="150" Cls="inputText" runat="server" />                                
                            </td>  
                           <th>         
                                <ext:Label ID="lbl01_SUBCON_PNO_PER" runat="server" />                    
                            </th>
                            <td colspan="3">
                                <ext:TextField ID="txt01_SUBCON_PARTNO" Width="150" Cls="inputText" runat="server" />                                
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
                                            <ext:ModelField Name="VINNM" />                                            
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />                                            
                                            <ext:ModelField Name="DCNTT" />                                            
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
                                            <ext:ModelField Name="D31" />
                                            <ext:ModelField Name="TBNT" />
                                            <ext:ModelField Name="PRTN" />
                                            <ext:ModelField Name="DDR0" />
                                            <ext:ModelField Name="MITU" />
                                            <ext:ModelField Name="PSEQ" />
                                            <ext:ModelField Name="DDTT" />
                                            <ext:ModelField Name="INSERT_DATE" />
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
                                <ext:Column ID="VINNM_1"              ItemID="VIN"       runat="server" DataIndex="VINNM"      Width="60" Align="Center" /><%--Text="차종"      --%>
                                <ext:Column ID="PARTNO_1"             ItemID="SUBCON_PNO"    runat="server" DataIndex="PARTNO"     Width="120" Align="Left"  /><%--Text="외작 PART NO"   --%>
                                <ext:Column ID="PARTNM_1"             ItemID="SUBCON_PNM"    runat="server" DataIndex="PARTNM"     MinWidth="180" Align="Left" Flex="1"/><%--Text="외작 PART NAME" --%>                                
                                <ext:NumberColumn ID="DCNTT_1"        ItemID="DCNTT"     runat="server" DataIndex="DCNTT"   Text="D SUM"   Width="80" Align="Right" Format="#,##0.###"/><%--Text="D SUM"  --%>                                  
                                <ext:NumberColumn ID="D0_1"           ItemID="D0"     runat="server" DataIndex="D0"     Text="D+0"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D1_1"           ItemID="D1"     runat="server" DataIndex="D1"     Text="D+1"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D2_1"           ItemID="D2"     runat="server" DataIndex="D2"     Text="D+2"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D3_1"           ItemID="D3"     runat="server" DataIndex="D3"     Text="D+3"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D4_1"           ItemID="D4"     runat="server" DataIndex="D4"     Text="D+4"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D5_1"           ItemID="D5"     runat="server" DataIndex="D5"     Text="D+5"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D6_1"           ItemID="D6"     runat="server" DataIndex="D6"     Text="D+6"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D7_1"           ItemID="D7"     runat="server" DataIndex="D7"     Text="D+7"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D8_1"           ItemID="D8"     runat="server" DataIndex="D8"     Text="D+8"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D9_1"           ItemID="D9"     runat="server" DataIndex="D9"     Text="D+9"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D10_1"          ItemID="D10"    runat="server" DataIndex="D10"    Text="D+10"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D11_1"          ItemID="D11"    runat="server" DataIndex="D11"    Text="D+11"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D12_1"          ItemID="D12"    runat="server" DataIndex="D12"    Text="D+12"    Width="60" Align="Right" Format="#,##0.###"/>                                
                                <ext:NumberColumn ID="D13_1"          ItemID="D13"    runat="server" DataIndex="D13"    Text="D+13"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D14_1"          ItemID="D14"    runat="server" DataIndex="D14"    Text="D+14"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D15_1"          ItemID="D15"    runat="server" DataIndex="D15"    Text="D+15"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D16_1"          ItemID="D16"    runat="server" DataIndex="D16"    Text="D+16"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D17_1"          ItemID="D17"    runat="server" DataIndex="D17"    Text="D+17"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D18_1"          ItemID="D18"    runat="server" DataIndex="D18"    Text="D+18"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D19_1"          ItemID="D19"    runat="server" DataIndex="D19"    Text="D+19"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D20_1"          ItemID="D20"    runat="server" DataIndex="D20"    Text="D+20"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D21_1"          ItemID="D21"    runat="server" DataIndex="D21"    Text="D+21"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D22_1"          ItemID="D22"    runat="server" DataIndex="D22"    Text="D+22"    Width="60" Align="Right" Format="#,##0.###"/>                                
                                <ext:NumberColumn ID="D23_1"          ItemID="D23"    runat="server" DataIndex="D23"    Text="D+23"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D24_1"          ItemID="D24"    runat="server" DataIndex="D24"    Text="D+24"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D25_1"          ItemID="D25"    runat="server" DataIndex="D25"    Text="D+25"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D26_1"          ItemID="D26"    runat="server" DataIndex="D26"    Text="D+26"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D27_1"          ItemID="D27"    runat="server" DataIndex="D27"    Text="D+27"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D28_1"          ItemID="D28"    runat="server" DataIndex="D28"    Text="D+28"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D29_1"          ItemID="D29"    runat="server" DataIndex="D29"    Text="D+29"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D30_1"          ItemID="D30"    runat="server" DataIndex="D30"    Text="D+30"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D31_1"          ItemID="D31"    runat="server" DataIndex="D31"    Text="D+31"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="M0_1"           ItemID="M0_1"   runat="server" DataIndex="TBNT"   Text="M"       Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="M1_1"           ItemID="M1_1"   runat="server" DataIndex="PRTN"   Text="M+1"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="DDR0_1"         ItemID="DDR0_1" runat="server" DataIndex="DDR0"   Text="P7 REMAIN"     Width="90" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="MITU_1"         ItemID="MITU_1" runat="server" DataIndex="MITU"   Text="MITU"     Width="80" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="PSEQ_1"         ItemID="PSEQ_1" runat="server" DataIndex="PSEQ"   Text="PRE-SEQ"     Width="80" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="DDTT_1"         ItemID="DDTT_1" runat="server" DataIndex="DDTT"   Text="P7 TOTAL"     Width="80" Align="Right" Format="#,##0.###"/>
                                <ext:Column ID="INSERT_DATE_1"        ItemID="INSERT_DATE_1"    runat="server" DataIndex="INSERT_DATE"  Text="Insert Date"    MinWidth="180" Align="Center" />                                
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
                   <%--상세--%>
                   <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." Hidden="true">
                        <Store>
                            <ext:Store ID="Store3" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="Model3" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="MIP_PARTNO" />
                                            <ext:ModelField Name="MIP_PARTNM" />   
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />                                            
                                            <ext:ModelField Name="DCNTT" />                                            
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
                                            <ext:ModelField Name="D31" />
                                            <ext:ModelField Name="TBNT" />
                                            <ext:ModelField Name="PRTN" />
                                            <ext:ModelField Name="DDR0" />
                                            <ext:ModelField Name="MITU" />
                                            <ext:ModelField Name="PSEQ" />
                                            <ext:ModelField Name="DDTT" />
                                            <ext:ModelField Name="INSERT_DATE" />                                            
                                        </Fields>
                                    </ext:Model>
                                </Model>
                                <Listeners>
                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                    <Load Delay="1" Handler="GridStoreReady(App.GridStatus2, this.getTotalCount());  "></Load>
                                </Listeners>
                            </ext:Store>
                        </Store>
                        <Plugins>
                            <ext:BufferedRenderer ID="BufferedRenderer2"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel2" runat="server">
                            <Columns>
                               <ext:RowNumbererColumn ID="RowNumbererColumn1"      ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center"  />
                                <ext:Column ID="VINNM_2"              ItemID="VIN"       runat="server" DataIndex="VINNM"      Width="60" Align="Center" /><%--Text="차종"      --%>
                                <ext:Column ID="MIP_PARTNO_2"         ItemID="MIP_PARTNO"    runat="server" DataIndex="MIP_PARTNO"     Width="120" Align="Left"  /><%--Text="내장 PART NO"   --%>
                                <ext:Column ID="MIP_PARTNM_2"         ItemID="MIP_PARTNM"    runat="server" DataIndex="MIP_PARTNM"     MinWidth="180" Align="Left" /><%--Text="내작 PART NAME" --%>
                                <ext:Column ID="PARTNO_2"             ItemID="SUBCON_PNO"    runat="server" DataIndex="PARTNO"     Width="120" Align="Left"  /><%--Text="외작 PART NO"   --%>
                                <ext:Column ID="PARTNM_2"             ItemID="SUBCON_PNM"    runat="server" DataIndex="PARTNM"     MinWidth="180" Align="Left" /><%--Text="외작 PART NAME" --%>
                                <ext:NumberColumn ID="DCNTT_2"        ItemID="DCNTT"     runat="server" DataIndex="DCNTT"   Text="D SUM"   Width="80" Align="Right" Format="#,##0.###"/><%--Text="D SUM"  --%>                                  
                                <ext:NumberColumn ID="D0_2"           ItemID="D0"     runat="server" DataIndex="D0"     Text="D+0"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D1_2"           ItemID="D1"     runat="server" DataIndex="D1"     Text="D+1"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D2_2"           ItemID="D2"     runat="server" DataIndex="D2"     Text="D+2"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D3_2"           ItemID="D3"     runat="server" DataIndex="D3"     Text="D+3"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D4_2"           ItemID="D4"     runat="server" DataIndex="D4"     Text="D+4"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D5_2"           ItemID="D5"     runat="server" DataIndex="D5"     Text="D+5"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D6_2"           ItemID="D6"     runat="server" DataIndex="D6"     Text="D+6"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D7_2"           ItemID="D7"     runat="server" DataIndex="D7"     Text="D+7"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D8_2"           ItemID="D8"     runat="server" DataIndex="D8"     Text="D+8"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D9_2"           ItemID="D9"     runat="server" DataIndex="D9"     Text="D+9"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D10_2"          ItemID="D10"    runat="server" DataIndex="D10"    Text="D+10"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D11_2"          ItemID="D11"    runat="server" DataIndex="D11"    Text="D+11"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D12_2"          ItemID="D12"    runat="server" DataIndex="D12"    Text="D+12"    Width="60" Align="Right" Format="#,##0.###"/>                                
                                <ext:NumberColumn ID="D13_2"          ItemID="D13"    runat="server" DataIndex="D13"    Text="D+13"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D14_2"          ItemID="D14"    runat="server" DataIndex="D14"    Text="D+14"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D15_2"          ItemID="D15"    runat="server" DataIndex="D15"    Text="D+15"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D16_2"          ItemID="D16"    runat="server" DataIndex="D16"    Text="D+16"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D17_2"          ItemID="D17"    runat="server" DataIndex="D17"    Text="D+17"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D18_2"          ItemID="D18"    runat="server" DataIndex="D18"    Text="D+18"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D19_2"          ItemID="D19"    runat="server" DataIndex="D19"    Text="D+19"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D20_2"          ItemID="D20"    runat="server" DataIndex="D20"    Text="D+20"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D21_2"          ItemID="D21"    runat="server" DataIndex="D21"    Text="D+21"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D22_2"          ItemID="D22"    runat="server" DataIndex="D22"    Text="D+22"    Width="60" Align="Right" Format="#,##0.###"/>                                
                                <ext:NumberColumn ID="D23_2"          ItemID="D23"    runat="server" DataIndex="D23"    Text="D+23"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D24_2"          ItemID="D24"    runat="server" DataIndex="D24"    Text="D+24"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D25_2"          ItemID="D25"    runat="server" DataIndex="D25"    Text="D+25"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D26_2"          ItemID="D26"    runat="server" DataIndex="D26"    Text="D+26"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D27_2"          ItemID="D27"    runat="server" DataIndex="D27"    Text="D+27"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D28_2"          ItemID="D28"    runat="server" DataIndex="D28"    Text="D+28"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D29_2"          ItemID="D29"    runat="server" DataIndex="D29"    Text="D+29"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D30_2"          ItemID="D30"    runat="server" DataIndex="D30"    Text="D+30"    Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D31_2"          ItemID="D31"    runat="server" DataIndex="D31"    Text="D+31"    Width="60" Align="Right" Format="#,##0.###"/>                                
                                <ext:NumberColumn ID="M0_2"           ItemID="M0_2"   runat="server" DataIndex="TBNT"   Text="M"       Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="M1_2"           ItemID="M1_2"   runat="server" DataIndex="PRTN"   Text="M+1"     Width="60" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="DDR0_2"         ItemID="DDR0_2" runat="server" DataIndex="DDR0"   Text="P7 REMAIN"     Width="90" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="MITU_2"         ItemID="MITU_2" runat="server" DataIndex="MITU"   Text="MITU"     Width="80" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="PSEQ_2"         ItemID="PSEQ_2" runat="server" DataIndex="PSEQ"   Text="PRE-SEQ"     Width="80" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="DDTT_2"         ItemID="DDTT_2" runat="server" DataIndex="DDTT"   Text="P7 TOTAL"     Width="80" Align="Right" Format="#,##0.###"/>
                                <ext:Column ID="INSERT_DATE_2"        ItemID="INSERT_DATE_2"    runat="server" DataIndex="INSERT_DATE"     Text="Insert Date"  MinWidth="180" Align="Center" />                             
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>                            
                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"/>
                        </SelectionModel>                       
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>                 
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
