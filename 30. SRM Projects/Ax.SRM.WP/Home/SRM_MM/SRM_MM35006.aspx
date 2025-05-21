<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM35006.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM35006" %>
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
    <form id="SRM_MM35006" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM35006" runat="server" Cls="search_area_title_name" /><%--Text="서열투입현황" />--%>
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
                                <ext:Label ID="lbl01_VEND" runat="server" /><%--Text="업체" />--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>   
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" /><%--Text="사업장" />--%>
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
                                <ext:Label ID="lbl01_DELIVERYDATE" runat="server" /><%--Text="일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_STD_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />                                
                            </td>
                        </tr> 
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_LINECD" runat="server" /><%--Text="라인코드" />--%>                       
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_LINECD" runat="server" HelperID="HELP_LINE_SEQ" PopupMode="Search" PopupType="HelpWindow" 
                                OnBeforeDirectButtonClick="CodeBox_LINE_BeforeDirectButtonClick" WidthTYPECD="60"/>    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_CONTCD" runat="server" /><%--Text="물류용기코드" /> --%>                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CONTCD" runat="server" HelperID="HELP_CONTCD_SEQ" PopupMode="Search" PopupType="HelpWindow"
                                 OnBeforeDirectButtonClick="cdx01_CONTCD_BeforeDirectButtonClick" WidthTYPECD="60"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_SUBCON_PNO_PER" runat="server" />                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" FieldStyle="text-transform:uppercase;" />
                            </td>  
                            <%--
                            <th>
                                <ext:Label ID="lbl01_JIS_DIV" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_LOG_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_LOG_DIV_Change" />
                                    </DirectEvents>
                                </ext:SelectBox>                            
                            </td>                          
                            --%>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <%-- 집계내역 그리드 --%>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="250">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="LINENM" /><ext:ModelField Name="INSTALL_POS" />
                                            <ext:ModelField Name="MAT_ITEM" /><ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" /><ext:ModelField Name="LOG_DIV" />
                                            <ext:ModelField Name="ALCCD" />
                                            <%--
                                            <ext:ModelField Name="BAS_INV_OK_QTY" /><ext:ModelField Name="RSLT_QTY_SUM" />
                                            <ext:ModelField Name="CUR_INV_OK_QTY" /><ext:ModelField Name="EXCEED_PROD_QTY" />
                                            --%>
                                            <ext:ModelField Name="SUM_PROD_QTY" /><ext:ModelField Name="DAY_PROD_QTY" />
                                            <ext:ModelField Name="NIGHT_PROD_QTY" /><ext:ModelField Name="SUM_PLN" />
                                            <ext:ModelField Name="SUM_PLN1" /><ext:ModelField Name="SUM_PLN2" />
                                            
                                            <ext:ModelField Name="PLN1" /><ext:ModelField Name="PLN1_1" /><ext:ModelField Name="PLN1_2" />
                                            <ext:ModelField Name="PLN2" /><ext:ModelField Name="PLN2_1" /><ext:ModelField Name="PLN2_2" />
                                            <ext:ModelField Name="PLN3" /><ext:ModelField Name="PLN3_1" /><ext:ModelField Name="PLN3_2" />
                                            <ext:ModelField Name="PLN4" /><ext:ModelField Name="PLN4_1" /><ext:ModelField Name="PLN4_2" />
                                            <ext:ModelField Name="PLN5" /><ext:ModelField Name="PLN5_1" /><ext:ModelField Name="PLN5_2" />
                                            <ext:ModelField Name="PLN6" /><ext:ModelField Name="PLN6_1" /><ext:ModelField Name="PLN6_2" />
                                            <ext:ModelField Name="PLN7" /><ext:ModelField Name="PLN7_1" /><ext:ModelField Name="PLN7_2" />
                                            <ext:ModelField Name="PLN8" /><ext:ModelField Name="PLN8_1" /><ext:ModelField Name="PLN8_2" />
                                            <ext:ModelField Name="PLN9" /><ext:ModelField Name="PLN9_1" /><ext:ModelField Name="PLN9_2" />
                                            <ext:ModelField Name="PLN10" /><ext:ModelField Name="PLN10_1" /><ext:ModelField Name="PLN10_2" />
                                            <ext:ModelField Name="PLN11" /><ext:ModelField Name="PLN11_1" /><ext:ModelField Name="PLN11_2" />
                                            <ext:ModelField Name="PLN12" /><ext:ModelField Name="PLN12_1" /><ext:ModelField Name="PLN12_2" />
                                            <ext:ModelField Name="PLN13" /><ext:ModelField Name="PLN13_1" /><ext:ModelField Name="PLN13_2" />
                                            <ext:ModelField Name="PLN14" /><ext:ModelField Name="PLN14_1" /><ext:ModelField Name="PLN14_2" />
                                            <ext:ModelField Name="PLN15" /><ext:ModelField Name="PLN15_1" /><ext:ModelField Name="PLN15_2" />
                                            <ext:ModelField Name="PLN16" /><ext:ModelField Name="PLN16_1" /><ext:ModelField Name="PLN16_2" />
                                            <ext:ModelField Name="PLN17" /><ext:ModelField Name="PLN17_1" /><ext:ModelField Name="PLN17_2" />
                                            <ext:ModelField Name="PLN18" /><ext:ModelField Name="PLN18_1" /><ext:ModelField Name="PLN18_2" />
                                            <ext:ModelField Name="PLN19" /><ext:ModelField Name="PLN19_1" /><ext:ModelField Name="PLN19_2" />
                                            <ext:ModelField Name="PLN20" /><ext:ModelField Name="PLN20_1" /><ext:ModelField Name="PLN20_2" />
                                            <ext:ModelField Name="PLN21" /><ext:ModelField Name="PLN21_1" /><ext:ModelField Name="PLN21_2" />
                                            <ext:ModelField Name="PLN22" /><ext:ModelField Name="PLN22_1" /><ext:ModelField Name="PLN22_2" />
                                            <ext:ModelField Name="PLN23" /><ext:ModelField Name="PLN23_1" /><ext:ModelField Name="PLN23_2" />
                                            <ext:ModelField Name="PLN24" /><ext:ModelField Name="PLN24_1" /><ext:ModelField Name="PLN24_2" />
                                            <ext:ModelField Name="PLN25" /><ext:ModelField Name="PLN25_1" /><ext:ModelField Name="PLN25_2" />
                                            <ext:ModelField Name="PLN26" /><ext:ModelField Name="PLN26_1" /><ext:ModelField Name="PLN26_2" />
                                            <ext:ModelField Name="PLN27" /><ext:ModelField Name="PLN27_1" /><ext:ModelField Name="PLN27_2" />
                                            <ext:ModelField Name="PLN28" /><ext:ModelField Name="PLN28_1" /><ext:ModelField Name="PLN28_2" />
                                            <ext:ModelField Name="PLN29" /><ext:ModelField Name="PLN29_1" /><ext:ModelField Name="PLN29_2" />
                                            <ext:ModelField Name="PLN30" /><ext:ModelField Name="PLN30_1" /><ext:ModelField Name="PLN30_2" />
                                            <ext:ModelField Name="PLN31" /><ext:ModelField Name="PLN31_1" /><ext:ModelField Name="PLN31_2" />
                                            <ext:ModelField Name="PLN32" /><ext:ModelField Name="PLN32_1" /><ext:ModelField Name="PLN32_2" />
                                            <ext:ModelField Name="PLN33" /><ext:ModelField Name="PLN33_1" /><ext:ModelField Name="PLN33_2" />
                                            <ext:ModelField Name="PLN34" /><ext:ModelField Name="PLN34_1" /><ext:ModelField Name="PLN34_2" />
                                            <ext:ModelField Name="PLN35" /><ext:ModelField Name="PLN35_1" /><ext:ModelField Name="PLN35_2" />
                                            <ext:ModelField Name="PLN36" /><ext:ModelField Name="PLN36_1" /><ext:ModelField Name="PLN36_2" />
                                            <ext:ModelField Name="PLN37" /><ext:ModelField Name="PLN37_1" /><ext:ModelField Name="PLN37_2" />
                                            <ext:ModelField Name="PLN38" /><ext:ModelField Name="PLN38_1" /><ext:ModelField Name="PLN38_2" />
                                            <ext:ModelField Name="PLN39" /><ext:ModelField Name="PLN39_1" /><ext:ModelField Name="PLN39_2" />
                                            <ext:ModelField Name="PLN40" /><ext:ModelField Name="PLN40_1" /><ext:ModelField Name="PLN40_2" />
                                            <ext:ModelField Name="PLN41" /><ext:ModelField Name="PLN41_1" /><ext:ModelField Name="PLN41_2" />
                                            <ext:ModelField Name="PLN42" /><ext:ModelField Name="PLN42_1" /><ext:ModelField Name="PLN42_2" />
                                            <ext:ModelField Name="PLN43" /><ext:ModelField Name="PLN43_1" /><ext:ModelField Name="PLN43_2" />
                                            <ext:ModelField Name="PLN44" /><ext:ModelField Name="PLN44_1" /><ext:ModelField Name="PLN44_2" />
                                            <ext:ModelField Name="PLN45" /><ext:ModelField Name="PLN45_1" /><ext:ModelField Name="PLN45_2" />
                                            <ext:ModelField Name="PLN46" /><ext:ModelField Name="PLN46_1" /><ext:ModelField Name="PLN46_2" />
                                            <ext:ModelField Name="PLN47" /><ext:ModelField Name="PLN47_1" /><ext:ModelField Name="PLN47_2" />
                                            <ext:ModelField Name="PLN48" /><ext:ModelField Name="PLN48_1" /><ext:ModelField Name="PLN48_2" />
                                            <ext:ModelField Name="PLN49" /><ext:ModelField Name="PLN49_1" /><ext:ModelField Name="PLN49_2" />
                                            <ext:ModelField Name="PLN50" /><ext:ModelField Name="PLN50_1" /><ext:ModelField Name="PLN50_2" />
                                            <ext:ModelField Name="PLN51" /><ext:ModelField Name="PLN51_1" /><ext:ModelField Name="PLN51_2" />
                                            <ext:ModelField Name="PLN52" /><ext:ModelField Name="PLN52_1" /><ext:ModelField Name="PLN52_2" />
                                            <ext:ModelField Name="PLN53" /><ext:ModelField Name="PLN53_1" /><ext:ModelField Name="PLN53_2" />
                                            <ext:ModelField Name="PLN54" /><ext:ModelField Name="PLN54_1" /><ext:ModelField Name="PLN54_2" />
                                            <ext:ModelField Name="PLN55" /><ext:ModelField Name="PLN55_1" /><ext:ModelField Name="PLN55_2" />
                                            <ext:ModelField Name="PLN56" /><ext:ModelField Name="PLN56_1" /><ext:ModelField Name="PLN56_2" />
                                            <ext:ModelField Name="PLN57" /><ext:ModelField Name="PLN57_1" /><ext:ModelField Name="PLN57_2" />
                                            <ext:ModelField Name="PLN58" /><ext:ModelField Name="PLN58_1" /><ext:ModelField Name="PLN58_2" />
                                            <ext:ModelField Name="PLN59" /><ext:ModelField Name="PLN59_1" /><ext:ModelField Name="PLN59_2" />
                                            <ext:ModelField Name="PLN60" /><ext:ModelField Name="PLN60_1" /><ext:ModelField Name="PLN60_2" />
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
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Width="40" Align="Center" Text="No"  />
                                <ext:Column ID="LINENM" ItemID="LINEINFO" runat="server" DataIndex="LINENM" Width="150" Align="Left" /><%--라인정보--%>
                                <ext:Column ID="INSTALL_POS" ItemID="INSTALL_POS" runat="server" DataIndex="INSTALL_POS"  Width="50" Align="Center"  /><%--Text="위치"  --%>
                                <ext:Column ID="MAT_ITEM" ItemID="CONTCD" runat="server" DataIndex="MAT_ITEM"  Width="60" Align="Center"  /><%--Text="자재품목"  --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left"  /> <%--Text="PART NO"--%>  
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="150" Align="Left" Flex="1"/> <%--Text="PART NAME"--%>   
                                <ext:Column ID="LOG_DIV" ItemID="LOG_DIV" runat="server" DataIndex="LOG_DIV" MinWidth="100" Align="Left" /> <%--Text="물류구분" --%>
                                <ext:Column ID="ALCCD" ItemID="ALCCD_REP" runat="server" DataIndex="ALCCD" Width="60" Align="Center"/> <%--Text="대표ALC"--%> 
                                <%--
                                <ext:NumberColumn ID="BAS_INV_OK_QTY" ItemID="BAS_INV_OK_QTY" runat="server" DataIndex="BAS_INV_OK_QTY" Width="65" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="RSLT_QTY_SUM" ItemID="MAT_INPUT" runat="server" DataIndex="RSLT_QTY_SUM" Width="65" Align="Right" Format="#,##0.###"/> 
                                <ext:NumberColumn ID="CUR_INV_OK_QTY" ItemID="NOW_INV" runat="server" DataIndex="CUR_INV_OK_QTY" Width="65" Align="Right" Format="#,##0.###"/>
                                --%>
                                <ext:Column ID="PRD_QTY" ItemID="PRD_QTY" runat="server" ><%--Text="생산수량">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="SUM_PROD_QTY" ItemID="TOTAL" runat="server" DataIndex="SUM_PROD_QTY" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="합계"--%>
                                        <ext:NumberColumn ID="DAY_PROD_QTY" ItemID="DTIME_CNT" runat="server" DataIndex="DAY_PROD_QTY" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="주간"--%>
                                        <ext:NumberColumn ID="NIGHT_PROD_QTY" ItemID="NTIME_CNT" runat="server" DataIndex="NIGHT_PROD_QTY" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="야간"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="TOTAL" ItemID="TOTAL" runat="server" ><%--Text="합계">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="SUM_PLN" ItemID="PO" runat="server" DataIndex="SUM_PLN" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="SUM_PLN1" ItemID="DELI" runat="server" DataIndex="SUM_PLN1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="SUM_PLN2" ItemID="ARRIV" runat="server" DataIndex="SUM_PLN2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <%--
                                <ext:NumberColumn ID="EXCEED_PROD_QTY" ItemID="EXC_QTY" runat="server" DataIndex="EXCEED_PROD_QTY" Width="65" Align="Right" Format="#,##0.###"/>
                                --%>
                                <ext:Column ID="QTY01" ItemID="QTY01" runat="server" ><%--Text="1차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN1" ItemID="PO" runat="server" DataIndex="PLN1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN1_1" ItemID="DELI" runat="server" DataIndex="PLN1_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN1_2" ItemID="ARRIV" runat="server" DataIndex="PLN1_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY02" ItemID="QTY02" runat="server" ><%--Text="2차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN2" ItemID="PO" runat="server" DataIndex="PLN2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN2_1" ItemID="DELI" runat="server" DataIndex="PLN2_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN2_2" ItemID="ARRIV" runat="server" DataIndex="PLN2_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column> 
                                <ext:Column ID="QTY03" ItemID="QTY03" runat="server" ><%--Text="3차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN3" ItemID="PO" runat="server" DataIndex="PLN3" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN3_1" ItemID="DELI" runat="server" DataIndex="PLN3_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN3_2" ItemID="ARRIV" runat="server" DataIndex="PLN3_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY04" ItemID="QTY04" runat="server" ><%--Text="4차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN4" ItemID="PO" runat="server" DataIndex="PLN4" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN4_1" ItemID="DELI" runat="server" DataIndex="PLN4_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN4_2" ItemID="ARRIV" runat="server" DataIndex="PLN4_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY05" ItemID="QTY05" runat="server" ><%--Text="5차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN5" ItemID="PO" runat="server" DataIndex="PLN5" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN5_1" ItemID="DELI" runat="server" DataIndex="PLN5_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN5_2" ItemID="ARRIV" runat="server" DataIndex="PLN5_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY06" ItemID="QTY06" runat="server" ><%--Text="6차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN6" ItemID="PO" runat="server" DataIndex="PLN6" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN6_1" ItemID="DELI" runat="server" DataIndex="PLN6_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN6_2" ItemID="ARRIV" runat="server" DataIndex="PLN6_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY07" ItemID="QTY07" runat="server" ><%--Text="7차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN7" ItemID="PO" runat="server" DataIndex="PLN7" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN7_1" ItemID="DELI" runat="server" DataIndex="PLN7_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN7_2" ItemID="ARRIV" runat="server" DataIndex="PLN7_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY08" ItemID="QTY08" runat="server" ><%--Text="8차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN8" ItemID="PO" runat="server" DataIndex="PLN8" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN8_1" ItemID="DELI" runat="server" DataIndex="PLN8_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN8_2" ItemID="ARRIV" runat="server" DataIndex="PLN8_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY09" ItemID="QTY09" runat="server" ><%--Text="9차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN9" ItemID="PO" runat="server" DataIndex="PLN9" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN9_1" ItemID="DELI" runat="server" DataIndex="PLN9_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN9_2" ItemID="ARRIV" runat="server" DataIndex="PLN9_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY10" ItemID="QTY10" runat="server" ><%--Text="10차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN10" ItemID="PO" runat="server" DataIndex="PLN10" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN10_1" ItemID="DELI" runat="server" DataIndex="PLN10_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN10_2" ItemID="ARRIV" runat="server" DataIndex="PLN10_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY11" ItemID="QTY11" runat="server" ><%--Text="11차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN11" ItemID="PO" runat="server" DataIndex="PLN11" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN11_1" ItemID="DELI" runat="server" DataIndex="PLN11_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN11_2" ItemID="ARRIV" runat="server" DataIndex="PLN11_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY12" ItemID="QTY12" runat="server" ><%--Text="12차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN12" ItemID="PO" runat="server" DataIndex="PLN12" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN12_1" ItemID="DELI" runat="server" DataIndex="PLN12_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN12_2" ItemID="ARRIV" runat="server" DataIndex="PLN12_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column> 
                                <ext:Column ID="QTY13" ItemID="QTY13" runat="server" ><%--Text="13차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN13" ItemID="PO" runat="server" DataIndex="PLN13" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN13_1" ItemID="DELI" runat="server" DataIndex="PLN13_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN13_2" ItemID="ARRIV" runat="server" DataIndex="PLN13_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY14" ItemID="QTY14" runat="server" ><%--Text="14차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN14" ItemID="PO" runat="server" DataIndex="PLN14" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN14_1" ItemID="DELI" runat="server" DataIndex="PLN14_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN14_2" ItemID="ARRIV" runat="server" DataIndex="PLN14_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY15" ItemID="QTY15" runat="server" ><%--Text="15차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN15" ItemID="PO" runat="server" DataIndex="PLN15" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN15_1" ItemID="DELI" runat="server" DataIndex="PLN15_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN15_2" ItemID="ARRIV" runat="server" DataIndex="PLN15_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY16" ItemID="QTY16" runat="server" ><%--Text="16차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN16" ItemID="PO" runat="server" DataIndex="PLN16" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN16_1" ItemID="DELI" runat="server" DataIndex="PLN16_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN16_2" ItemID="ARRIV" runat="server" DataIndex="PLN16_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY17" ItemID="QTY17" runat="server" ><%--Text="17차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN17" ItemID="PO" runat="server" DataIndex="PLN17" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN17_1" ItemID="DELI" runat="server" DataIndex="PLN17_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN17_2" ItemID="ARRIV" runat="server" DataIndex="PLN17_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY18" ItemID="QTY18" runat="server" ><%--Text="18차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN18" ItemID="PO" runat="server" DataIndex="PLN18" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN18_1" ItemID="DELI" runat="server" DataIndex="PLN18_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN18_2" ItemID="ARRIV" runat="server" DataIndex="PLN18_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY19" ItemID="QTY19" runat="server" ><%--Text="19차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN19" ItemID="PO" runat="server" DataIndex="PLN19" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN19_1" ItemID="DELI" runat="server" DataIndex="PLN19_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN19_2" ItemID="ARRIV" runat="server" DataIndex="PLN19_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY20" ItemID="QTY20" runat="server" ><%--Text="20차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN20" ItemID="PO" runat="server" DataIndex="PLN20" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN20_1" ItemID="DELI" runat="server" DataIndex="PLN20_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN20_2" ItemID="ARRIV" runat="server" DataIndex="PLN20_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY21" ItemID="QTY21" runat="server" ><%--Text="21차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN21" ItemID="PO" runat="server" DataIndex="PLN21" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN21_1" ItemID="DELI" runat="server" DataIndex="PLN21_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN21_2" ItemID="ARRIV" runat="server" DataIndex="PLN21_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY22" ItemID="QTY22" runat="server" ><%--Text="22차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN22" ItemID="PO" runat="server" DataIndex="PLN22" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN22_1" ItemID="DELI" runat="server" DataIndex="PLN22_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN22_2" ItemID="ARRIV" runat="server" DataIndex="PLN22_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column> 
                                <ext:Column ID="QTY23" ItemID="QTY23" runat="server" ><%--Text="23차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN23" ItemID="PO" runat="server" DataIndex="PLN23" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN23_1" ItemID="DELI" runat="server" DataIndex="PLN23_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN23_2" ItemID="ARRIV" runat="server" DataIndex="PLN23_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY24" ItemID="QTY24" runat="server" ><%--Text="24차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN24" ItemID="PO" runat="server" DataIndex="PLN24" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN24_1" ItemID="DELI" runat="server" DataIndex="PLN24_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN24_2" ItemID="ARRIV" runat="server" DataIndex="PLN24_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY25" ItemID="QTY25" runat="server" ><%--Text="25차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN25" ItemID="PO" runat="server" DataIndex="PLN25" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN25_1" ItemID="DELI" runat="server" DataIndex="PLN25_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN25_2" ItemID="ARRIV" runat="server" DataIndex="PLN25_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY26" ItemID="QTY26" runat="server" ><%--Text="26차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN26" ItemID="PO" runat="server" DataIndex="PLN26" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN26_1" ItemID="DELI" runat="server" DataIndex="PLN26_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN26_2" ItemID="ARRIV" runat="server" DataIndex="PLN26_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY27" ItemID="QTY27" runat="server" ><%--Text="27차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN27" ItemID="PO" runat="server" DataIndex="PLN27" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN27_1" ItemID="DELI" runat="server" DataIndex="PLN27_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN27_2" ItemID="ARRIV" runat="server" DataIndex="PLN27_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY28" ItemID="QTY28" runat="server" ><%--Text="28차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN28" ItemID="PO" runat="server" DataIndex="PLN28" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN28_1" ItemID="DELI" runat="server" DataIndex="PLN28_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN28_2" ItemID="ARRIV" runat="server" DataIndex="PLN28_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY29" ItemID="QTY29" runat="server" ><%--Text="29차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN29" ItemID="PO" runat="server" DataIndex="PLN29" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN29_1" ItemID="DELI" runat="server" DataIndex="PLN29_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN29_2" ItemID="ARRIV" runat="server" DataIndex="PLN29_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY30" ItemID="QTY30" runat="server" ><%--Text="30차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN30" ItemID="PO" runat="server" DataIndex="PLN30" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN30_1" ItemID="DELI" runat="server" DataIndex="PLN30_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN30_2" ItemID="ARRIV" runat="server" DataIndex="PLN30_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY31" ItemID="QTY31" runat="server" ><%--Text="31차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN31" ItemID="PO" runat="server" DataIndex="PLN31" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN31_1" ItemID="DELI" runat="server" DataIndex="PLN31_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN31_2" ItemID="ARRIV" runat="server" DataIndex="PLN31_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY32" ItemID="QTY32" runat="server" ><%--Text="32차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN32" ItemID="PO" runat="server" DataIndex="PLN32" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN32_1" ItemID="DELI" runat="server" DataIndex="PLN32_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN32_2" ItemID="ARRIV" runat="server" DataIndex="PLN32_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column> 
                                <ext:Column ID="QTY33" ItemID="QTY33" runat="server" ><%--Text="33차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN33" ItemID="PO" runat="server" DataIndex="PLN33" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN33_1" ItemID="DELI" runat="server" DataIndex="PLN33_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN33_2" ItemID="ARRIV" runat="server" DataIndex="PLN33_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY34" ItemID="QTY34" runat="server" ><%--Text="34차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN34" ItemID="PO" runat="server" DataIndex="PLN34" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN34_1" ItemID="DELI" runat="server" DataIndex="PLN34_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN34_2" ItemID="ARRIV" runat="server" DataIndex="PLN34_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY35" ItemID="QTY35" runat="server" ><%--Text="35차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN35" ItemID="PO" runat="server" DataIndex="PLN35" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN35_1" ItemID="DELI" runat="server" DataIndex="PLN35_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN35_2" ItemID="ARRIV" runat="server" DataIndex="PLN35_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY36" ItemID="QTY36" runat="server" ><%--Text="36차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN36" ItemID="PO" runat="server" DataIndex="PLN36" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN36_1" ItemID="DELI" runat="server" DataIndex="PLN36_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN36_2" ItemID="ARRIV" runat="server" DataIndex="PLN36_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY37" ItemID="QTY37" runat="server" ><%--Text="37차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN37" ItemID="PO" runat="server" DataIndex="PLN37" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN37_1" ItemID="DELI" runat="server" DataIndex="PLN37_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN37_2" ItemID="ARRIV" runat="server" DataIndex="PLN37_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY38" ItemID="QTY38" runat="server" ><%--Text="38차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN38" ItemID="PO" runat="server" DataIndex="PLN38" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN38_1" ItemID="DELI" runat="server" DataIndex="PLN38_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN38_2" ItemID="ARRIV" runat="server" DataIndex="PLN38_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY39" ItemID="QTY39" runat="server" ><%--Text="39차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN39" ItemID="PO" runat="server" DataIndex="PLN39" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN39_1" ItemID="DELI" runat="server" DataIndex="PLN39_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN39_2" ItemID="ARRIV" runat="server" DataIndex="PLN39_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY40" ItemID="QTY40" runat="server" ><%--Text="40차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN40" ItemID="PO" runat="server" DataIndex="PLN40" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN40_1" ItemID="DELI" runat="server" DataIndex="PLN40_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN40_2" ItemID="ARRIV" runat="server" DataIndex="PLN40_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY41" ItemID="QTY41" runat="server" ><%--Text="41차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN41" ItemID="PO" runat="server" DataIndex="PLN41" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN41_1" ItemID="DELI" runat="server" DataIndex="PLN41_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN41_2" ItemID="ARRIV" runat="server" DataIndex="PLN41_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY42" ItemID="QTY42" runat="server" ><%--Text="42차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN42" ItemID="PO" runat="server" DataIndex="PLN42" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN42_1" ItemID="DELI" runat="server" DataIndex="PLN42_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN42_2" ItemID="ARRIV" runat="server" DataIndex="PLN42_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column> 
                                <ext:Column ID="QTY43" ItemID="QTY43" runat="server" ><%--Text="43차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN43" ItemID="PO" runat="server" DataIndex="PLN43" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN43_1" ItemID="DELI" runat="server" DataIndex="PLN43_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN43_2" ItemID="ARRIV" runat="server" DataIndex="PLN43_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY44" ItemID="QTY44" runat="server" ><%--Text="44차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN44" ItemID="PO" runat="server" DataIndex="PLN44" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN44_1" ItemID="DELI" runat="server" DataIndex="PLN44_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN44_2" ItemID="ARRIV" runat="server" DataIndex="PLN44_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY45" ItemID="QTY45" runat="server" ><%--Text="45차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN45" ItemID="PO" runat="server" DataIndex="PLN45" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN45_1" ItemID="DELI" runat="server" DataIndex="PLN45_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN45_2" ItemID="ARRIV" runat="server" DataIndex="PLN45_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY46" ItemID="QTY46" runat="server" ><%--Text="46차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN46" ItemID="PO" runat="server" DataIndex="PLN46" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN46_1" ItemID="DELI" runat="server" DataIndex="PLN46_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN46_2" ItemID="ARRIV" runat="server" DataIndex="PLN46_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY47" ItemID="QTY47" runat="server" ><%--Text="47차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN47" ItemID="PO" runat="server" DataIndex="PLN47" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN47_1" ItemID="DELI" runat="server" DataIndex="PLN47_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN47_2" ItemID="ARRIV" runat="server" DataIndex="PLN47_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY48" ItemID="QTY48" runat="server" ><%--Text="48차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN48" ItemID="PO" runat="server" DataIndex="PLN48" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN48_1" ItemID="DELI" runat="server" DataIndex="PLN48_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN48_2" ItemID="ARRIV" runat="server" DataIndex="PLN48_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY49" ItemID="QTY49" runat="server" ><%--Text="49차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN49" ItemID="PO" runat="server" DataIndex="PLN49" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN49_1" ItemID="DELI" runat="server" DataIndex="PLN49_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN49_2" ItemID="ARRIV" runat="server" DataIndex="PLN49_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY50" ItemID="QTY50" runat="server" ><%--Text="50차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN50" ItemID="PO" runat="server" DataIndex="PLN50" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN50_1" ItemID="DELI" runat="server" DataIndex="PLN50_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN50_2" ItemID="ARRIV" runat="server" DataIndex="PLN50_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY51" ItemID="QTY51" runat="server" ><%--Text="51차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN51" ItemID="PO" runat="server" DataIndex="PLN51" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN51_1" ItemID="DELI" runat="server" DataIndex="PLN51_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN51_2" ItemID="ARRIV" runat="server" DataIndex="PLN51_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY52" ItemID="QTY52" runat="server" ><%--Text="52차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN52" ItemID="PO" runat="server" DataIndex="PLN52" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN52_1" ItemID="DELI" runat="server" DataIndex="PLN52_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN52_2" ItemID="ARRIV" runat="server" DataIndex="PLN52_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column> 
                                <ext:Column ID="QTY53" ItemID="QTY53" runat="server" ><%--Text="53차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN53" ItemID="PO" runat="server" DataIndex="PLN53" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN53_1" ItemID="DELI" runat="server" DataIndex="PLN53_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN53_2" ItemID="ARRIV" runat="server" DataIndex="PLN53_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY54" ItemID="QTY54" runat="server" ><%--Text="54차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN54" ItemID="PO" runat="server" DataIndex="PLN54" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN54_1" ItemID="DELI" runat="server" DataIndex="PLN54_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN54_2" ItemID="ARRIV" runat="server" DataIndex="PLN54_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY55" ItemID="QTY55" runat="server" ><%--Text="55차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN55" ItemID="PO" runat="server" DataIndex="PLN55" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN55_1" ItemID="DELI" runat="server" DataIndex="PLN55_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN55_2" ItemID="ARRIV" runat="server" DataIndex="PLN55_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY56" ItemID="QTY56" runat="server" ><%--Text="56차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN56" ItemID="PO" runat="server" DataIndex="PLN56" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN56_1" ItemID="DELI" runat="server" DataIndex="PLN56_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN56_2" ItemID="ARRIV" runat="server" DataIndex="PLN56_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY57" ItemID="QTY57" runat="server" ><%--Text="57차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN57" ItemID="PO" runat="server" DataIndex="PLN57" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN57_1" ItemID="DELI" runat="server" DataIndex="PLN57_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN57_2" ItemID="ARRIV" runat="server" DataIndex="PLN57_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY58" ItemID="QTY58" runat="server" ><%--Text="58차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN58" ItemID="PO" runat="server" DataIndex="PLN58" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN58_1" ItemID="DELI" runat="server" DataIndex="PLN58_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN58_2" ItemID="ARRIV" runat="server" DataIndex="PLN58_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY59" ItemID="QTY59" runat="server" ><%--Text="59차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN59" ItemID="PO" runat="server" DataIndex="PLN59" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN59_1" ItemID="DELI" runat="server" DataIndex="PLN59_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN59_2" ItemID="ARRIV" runat="server" DataIndex="PLN59_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="QTY60" ItemID="QTY60" runat="server" ><%--Text="60차">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLN60" ItemID="PO" runat="server" DataIndex="PLN60" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="발주"--%>
                                        <ext:NumberColumn ID="PLN60_1" ItemID="DELI" runat="server" DataIndex="PLN60_1" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="납품"--%>
                                        <ext:NumberColumn ID="PLN60_2" ItemID="ARRIV" runat="server" DataIndex="PLN60_2" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="입하"--%>
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
