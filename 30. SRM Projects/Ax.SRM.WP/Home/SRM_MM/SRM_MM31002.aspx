<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM31002.aspx.cs" Inherits="HE.SRM.WP.Home.SRM_MM.SRM_MM31002" %>
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
    <form id="SRM_MM31002" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM31002" runat="server" Cls="search_area_title_name" /><%--Text="OEM 자재발주" />--%>
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
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
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
                                <ext:Label ID="lbl01_PO_DATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_PO_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  >
                                    <DirectEvents>
                                        <Select OnEvent="df01_PO_DATE_Change" />
                                    </DirectEvents>
                                </ext:DateField>                                
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
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" Text="lbl01_PARTNO" />                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />                                
                            </td>
                            <th>
                            </th>
                            <td>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_LOG_DIV" runat="server" Hidden="true" /><%--Text="물류구분" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_LOG_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115" Hidden="true">
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
                                </ext:SelectBox>                            
                            </td> 
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Label ID="lbl01_MM_MSG001" runat="server" Region="North" Height="25" Cls="grid_area_coment"/>  <%--Text=">> D-DAY 정상발주이고, 이후는 참조용 입니다."--%>            
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>                    
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="LOG_DIV" />
                                            <ext:ModelField Name="YARDNM" />
                                            <ext:ModelField Name="STR_LOC" />
                                            <ext:ModelField Name="MAT_ITEM" />
                                            <ext:ModelField Name="MAT_GRP" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="UNITNM" />
                                            <ext:ModelField Name="YESTERDAY_PLAN" />
                                            <ext:ModelField Name="YESTERDAY_QTY" />
                                            <ext:ModelField Name="PREVDAY_PLAN_BY_RSLT_QTY" />
                                            <ext:ModelField Name="INV_D0" />
                                            <ext:ModelField Name="REQ_D0" />
                                            <ext:ModelField Name="GAP_D0" />
                                            <ext:ModelField Name="NOR_D0" />
                                            <ext:ModelField Name="ADD_D0" />
                                            <ext:ModelField Name="PO_D0" />
                                            <ext:ModelField Name="INV_D1" />
                                            <ext:ModelField Name="REQ_D1" />
                                            <ext:ModelField Name="GAP_D1" />
                                            <ext:ModelField Name="NOR_D1" />
                                            <ext:ModelField Name="ADD_D1" />
                                            <ext:ModelField Name="PO_D1" />
                                            <ext:ModelField Name="INV_D2" />
                                            <ext:ModelField Name="REQ_D2" />
                                            <ext:ModelField Name="GAP_D2" />
                                            <ext:ModelField Name="NOR_D2" />
                                            <ext:ModelField Name="ADD_D2" />
                                            <ext:ModelField Name="PO_D2" />
                                            <ext:ModelField Name="INV_D3" />
                                            <ext:ModelField Name="REQ_D3" />
                                            <ext:ModelField Name="GAP_D3" />
                                            <ext:ModelField Name="NOR_D3" />
                                            <ext:ModelField Name="ADD_D3" />
                                            <ext:ModelField Name="PO_D3" />
                                            <ext:ModelField Name="INV_D4" />
                                            <ext:ModelField Name="REQ_D4" />
                                            <ext:ModelField Name="GAP_D4" />
                                            <ext:ModelField Name="NOR_D4" />
                                            <ext:ModelField Name="ADD_D4" />
                                            <ext:ModelField Name="PO_D4" />
                                            <ext:ModelField Name="INV_D5" />
                                            <ext:ModelField Name="REQ_D5" />
                                            <ext:ModelField Name="GAP_D5" />
                                            <ext:ModelField Name="NOR_D5" />
                                            <ext:ModelField Name="ADD_D5" />
                                            <ext:ModelField Name="PO_D5" />
                                            <ext:ModelField Name="INV_D6" />
                                            <ext:ModelField Name="REQ_D6" />
                                            <ext:ModelField Name="GAP_D6" />
                                            <ext:ModelField Name="NOR_D6" />
                                            <ext:ModelField Name="ADD_D6" />
                                            <ext:ModelField Name="PO_D6" />
                                            <ext:ModelField Name="INV_D7" />
                                            <ext:ModelField Name="REQ_D7" />
                                            <ext:ModelField Name="GAP_D7" />
                                            <ext:ModelField Name="NOR_D7" />
                                            <ext:ModelField Name="ADD_D7" />
                                            <ext:ModelField Name="PO_D7" />
                                            <ext:ModelField Name="INV_D8" />
                                            <ext:ModelField Name="REQ_D8" />
                                            <ext:ModelField Name="GAP_D8" />
                                            <ext:ModelField Name="NOR_D8" />
                                            <ext:ModelField Name="ADD_D8" />
                                            <ext:ModelField Name="PO_D8" />
                                            <ext:ModelField Name="INV_D9" />
                                            <ext:ModelField Name="REQ_D9" />
                                            <ext:ModelField Name="GAP_D9" />
                                            <ext:ModelField Name="NOR_D9" />
                                            <ext:ModelField Name="ADD_D9" />
                                            <ext:ModelField Name="PO_D9" />
                                            <ext:ModelField Name="INV_D10" />
                                            <ext:ModelField Name="REQ_D10" />
                                            <ext:ModelField Name="GAP_D10" />
                                            <ext:ModelField Name="NOR_D10" />
                                            <ext:ModelField Name="ADD_D10" />
                                            <ext:ModelField Name="PO_D10" />
                                            <ext:ModelField Name="INV_D11" />
                                            <ext:ModelField Name="REQ_D11" />
                                            <ext:ModelField Name="GAP_D11" />
                                            <ext:ModelField Name="NOR_D11" />
                                            <ext:ModelField Name="ADD_D11" />
                                            <ext:ModelField Name="PO_D11" />
                                            <ext:ModelField Name="INV_D12" />
                                            <ext:ModelField Name="REQ_D12" />
                                            <ext:ModelField Name="GAP_D12" />
                                            <ext:ModelField Name="NOR_D12" />
                                            <ext:ModelField Name="ADD_D12" />
                                            <ext:ModelField Name="PO_D12" />
                                            <ext:ModelField Name="PO_STATUS" />
                                            <ext:ModelField Name="HMCTOT" />
                                            <ext:ModelField Name="HMC0" />
                                            <ext:ModelField Name="HMC1" />
                                            <ext:ModelField Name="HMC2" />
                                            <ext:ModelField Name="HMC3" />
                                            <ext:ModelField Name="HMC4" />
                                            <ext:ModelField Name="HMC5" />
                                            <ext:ModelField Name="HMC6" />
                                            <ext:ModelField Name="HMC7" />
                                            <ext:ModelField Name="HMC8" />
                                            <ext:ModelField Name="HMC9" />
                                            <ext:ModelField Name="HMC10" />
                                            <ext:ModelField Name="HMC11" />
                                            <ext:ModelField Name="HMC12" />                                            
                                            <ext:ModelField Name="TMONTH_SURP_QTY" />
                                            <ext:ModelField Name="OSTAND_ORDER_QTY" />                                            
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
                                <ext:RowNumbererColumn ID="RowNumbererColumn1"      ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center"  />
                                <ext:Column ID="LOG_DIV" ItemID="LOG_DIV" runat="server" DataIndex="LOG_DIV" Width="80" Align="Left"  Hidden="true" /><%--Text="물류구분"      --%>
                                <ext:Column ID="YARDNM" ItemID="STR_LOC" runat="server" DataIndex="YARDNM" Width="90" Align="Left" /><%--Text="저장위치"      --%>
                                <ext:Column ID="MAT_ITEM" ItemID="MAT_GRP" runat="server" DataIndex="MAT_ITEM" Width="120" Align="Left" /><%--Text="자재그룹"  --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left"  /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME" --%>
                                <ext:Column ID="STANDARD" ItemID="STANDARD"  runat="server" DataIndex="STANDARD" Width="120" Align="Left"/><%--Text="규격"      --%>
                                <ext:Column ID="UNITNM" ItemID="UNITNM"  runat="server" DataIndex="UNITNM" Width="60" Align="Center"/><%--Text="단위"      --%>
                                <ext:Column ID="PRE_PROD_INFO" ItemID="PRE_PROD_INFO" runat="server" ><%--Text="전일생산정보">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="YESTERDAY_PLAN" ItemID="PROD_PLAN" runat="server" DataIndex="YESTERDAY_PLAN" Width="70" Align="Right" Format="#,##0" Sortable="true"/><%--Text="생산계획"  --%>
                                        <ext:NumberColumn ID="YESTERDAY_QTY" ItemID="PROD_RSLT" runat="server" DataIndex="YESTERDAY_QTY" Width="70" Align="Right" Format="#,##0" Sortable="true"/><%--Text="생산실적"  --%>  
                                        <ext:NumberColumn ID="PREDAY_PLAN_BY_RSLT_QTY" ItemID="NOT_RSLT" runat="server" DataIndex="PREVDAY_PLAN_BY_RSLT_QTY"  Width="70" Align="Right" Format="#,##0" Sortable="true"/><%--Text="미실적"  --%>                                
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D0_PO" ItemID="D0_PO" runat="server" ><%--Text=" 08시 기준">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D0" ItemID="BAS_INV" runat="server" DataIndex="INV_D0" Width="70" Align="Right" Format="#,##0" Sortable="true"/><%--Text="기초재고"  --%>
                                        <ext:NumberColumn ID="REQ_D0" ItemID="PROD_PLAN" runat="server" DataIndex="REQ_D0" Width="70" Align="Right" Format="#,##0" Sortable="true"/><%--Text="생산계획"  --%>  
                                        <ext:NumberColumn ID="GAP_D0" ItemID="EXC_QTY" runat="server" DataIndex="GAP_D0"  Width="70" Align="Right" Format="#,##0" Sortable="true"/><%--Text="과부족"  --%>  
                                        <ext:NumberColumn ID="NOR_DO" ItemID="NORMAL" runat="server" DataIndex="NOR_D0"  Width="70" Align="Right" Format="#,##0" Sortable="true"/><%--Text="정상"  --%>  
                                        <ext:NumberColumn ID="ADD_D0" ItemID="ADD" runat="server" DataIndex="ADD_D0"  Width="70" Align="Right" Format="#,##0" Sortable="true" Hidden="true"/><%--Text="추가"  --%>
                                        <ext:NumberColumn ID="PO_D0" ItemID="GA_SUB_TOTAL" runat="server" DataIndex="PO_D0"  Width="70" Align="Right" Format="#,##0" Sortable="true" Hidden="true"/><%--Text="소계"  --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D1_PO" ItemID="D1_PO" runat="server" ><%--Text="D+1 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D1" ItemID="EXP_INV" runat="server"       DataIndex="INV_D1" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고"  --%>
                                        <ext:NumberColumn ID="REQ_D1" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D1" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획"  --%>  
                                        <ext:NumberColumn ID="GAP_D1" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D1" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족"  --%>  
                                        <ext:NumberColumn ID="NOR_D1" ItemID="NORMAL" runat="server"        DataIndex="NOR_D1" Width="70" Align="Right" Format="#,##0"/><%--Text="정상"  --%>  
                                        <ext:NumberColumn ID="ADD_D1" ItemID="ADD" runat="server"           DataIndex="ADD_D1" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가"  --%>
                                        <ext:NumberColumn ID="PO_D1" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D1" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계"  --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D2_PO" ItemID="D2_PO" runat="server" ><%--Text="D+2 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D2" ItemID="EXP_INV" runat="server"       DataIndex="INV_D2" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고"  --%>
                                        <ext:NumberColumn ID="REQ_D2" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D2" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획"  --%>  
                                        <ext:NumberColumn ID="GAP_D2" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D2" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족"  --%>  
                                        <ext:NumberColumn ID="NOR_D2" ItemID="NORMAL" runat="server"        DataIndex="NOR_D2" Width="70" Align="Right" Format="#,##0"/><%--Text="정상"  --%>  
                                        <ext:NumberColumn ID="ADD_D2" ItemID="ADD" runat="server"           DataIndex="ADD_D2" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가"  --%>
                                        <ext:NumberColumn ID="PO_D2" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D2" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계"  --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D3_PO" ItemID="D3_PO" runat="server" ><%--Text="D+3 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D3" ItemID="EXP_INV" runat="server"       DataIndex="INV_D3" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고"  --%>
                                        <ext:NumberColumn ID="REQ_D3" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D3" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획"  --%>  
                                        <ext:NumberColumn ID="GAP_D3" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D3" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족"  --%>  
                                        <ext:NumberColumn ID="NOR_D3" ItemID="NORMAL" runat="server"        DataIndex="NOR_D3" Width="70" Align="Right" Format="#,##0"/><%--Text="정상"  --%>  
                                        <ext:NumberColumn ID="ADD_D3" ItemID="ADD" runat="server"           DataIndex="ADD_D3" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가"  --%>
                                        <ext:NumberColumn ID="PO_D3" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D3" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계"  --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D4_PO" ItemID="D4_PO" runat="server" ><%--Text="D+4 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D4" ItemID="EXP_INV" runat="server"       DataIndex="INV_D4" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고"  --%>
                                        <ext:NumberColumn ID="REQ_D4" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D4" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획"  --%>  
                                        <ext:NumberColumn ID="GAP_D4" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D4" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족"  --%>  
                                        <ext:NumberColumn ID="NOR_D4" ItemID="NORMAL" runat="server"        DataIndex="NOR_D4" Width="70" Align="Right" Format="#,##0"/><%--Text="정상"  --%>  
                                        <ext:NumberColumn ID="ADD_D4" ItemID="ADD" runat="server"           DataIndex="ADD_D4" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가"  --%>
                                        <ext:NumberColumn ID="PO_D4" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D4" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계"  --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D5_PO" ItemID="D5_PO" runat="server" ><%--Text="D+5 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D5" ItemID="EXP_INV" runat="server"       DataIndex="INV_D5" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고"  --%>
                                        <ext:NumberColumn ID="REQ_D5" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D5" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획"  --%>  
                                        <ext:NumberColumn ID="GAP_D5" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D5" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족"  --%>  
                                        <ext:NumberColumn ID="NOR_D5" ItemID="NORMAL" runat="server"        DataIndex="NOR_D5" Width="70" Align="Right" Format="#,##0"/><%--Text="정상"  --%>  
                                        <ext:NumberColumn ID="ADD_D5" ItemID="ADD" runat="server"           DataIndex="ADD_D5" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가"  --%>
                                        <ext:NumberColumn ID="PO_D5" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D5" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계"  --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D6_PO" ItemID="D6_PO" runat="server" ><%--Text="D+6 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D6" ItemID="EXP_INV" runat="server"       DataIndex="INV_D6" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고" --%>
                                        <ext:NumberColumn ID="REQ_D6" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D6" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획" --%>  
                                        <ext:NumberColumn ID="GAP_D6" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D6" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족" --%>  
                                        <ext:NumberColumn ID="NOR_D6" ItemID="NORMAL" runat="server"        DataIndex="NOR_D6" Width="70" Align="Right" Format="#,##0"/><%--Text="정상" --%>  
                                        <ext:NumberColumn ID="ADD_D6" ItemID="ADD" runat="server"           DataIndex="ADD_D6" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가" --%>
                                        <ext:NumberColumn ID="PO_D6" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D6" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D7_PO" ItemID="D7_PO" runat="server" ><%--Text="D+7 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D7" ItemID="EXP_INV" runat="server"       DataIndex="INV_D7" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고" --%>
                                        <ext:NumberColumn ID="REQ_D7" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D7" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획" --%>  
                                        <ext:NumberColumn ID="GAP_D7" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D7" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족" --%>  
                                        <ext:NumberColumn ID="NOR_D7" ItemID="NORMAL" runat="server"        DataIndex="NOR_D7" Width="70" Align="Right" Format="#,##0"/><%--Text="정상" --%>  
                                        <ext:NumberColumn ID="ADD_D7" ItemID="ADD" runat="server"           DataIndex="ADD_D7" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가" --%>
                                        <ext:NumberColumn ID="PO_D7" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D7" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D8_PO" ItemID="D8_PO" runat="server" ><%--Text="D+8 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D8" ItemID="EXP_INV" runat="server"       DataIndex="INV_D8" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고" --%>
                                        <ext:NumberColumn ID="REQ_D8" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D8" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획" --%>  
                                        <ext:NumberColumn ID="GAP_D8" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D8" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족" --%>  
                                        <ext:NumberColumn ID="NOR_D8" ItemID="NORMAL" runat="server"        DataIndex="NOR_D8" Width="70" Align="Right" Format="#,##0"/><%--Text="정상" --%>  
                                        <ext:NumberColumn ID="ADD_D8" ItemID="ADD" runat="server"           DataIndex="ADD_D8" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가" --%>
                                        <ext:NumberColumn ID="PO_D8" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D8" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D9_PO" ItemID="D9_PO" runat="server" ><%--Text="D+9 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D9" ItemID="EXP_INV" runat="server"       DataIndex="INV_D9" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고" --%>
                                        <ext:NumberColumn ID="REQ_D9" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D9" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획" --%>  
                                        <ext:NumberColumn ID="GAP_D9" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D9" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족" --%>  
                                        <ext:NumberColumn ID="NOR_D9" ItemID="NORMAL" runat="server"        DataIndex="NOR_D9" Width="70" Align="Right" Format="#,##0"/><%--Text="정상" --%>  
                                        <ext:NumberColumn ID="ADD_D9" ItemID="ADD" runat="server"           DataIndex="ADD_D9" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가" --%>
                                        <ext:NumberColumn ID="PO_D9" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D9" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D10_PO" ItemID="D10_PO" runat="server" ><%--Text="D+10 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D10" ItemID="EXP_INV" runat="server"       DataIndex="INV_D10" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고" --%>
                                        <ext:NumberColumn ID="REQ_D10" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D10" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획" --%>  
                                        <ext:NumberColumn ID="GAP_D10" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D10" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족" --%>  
                                        <ext:NumberColumn ID="NOR_D10" ItemID="NORMAL" runat="server"        DataIndex="NOR_D10" Width="70" Align="Right" Format="#,##0"/><%--Text="정상" --%>  
                                        <ext:NumberColumn ID="ADD_D10" ItemID="ADD" runat="server"           DataIndex="ADD_D10" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가" --%>
                                        <ext:NumberColumn ID="PO_D10" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D10" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D11_PO" ItemID="D11_PO" runat="server" ><%--Text="D+11 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D11" ItemID="EXP_INV" runat="server"       DataIndex="INV_D11" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고" --%>
                                        <ext:NumberColumn ID="REQ_D11" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D11" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획" --%>  
                                        <ext:NumberColumn ID="GAP_D11" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D11" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족" --%>  
                                        <ext:NumberColumn ID="NOR_D11" ItemID="NORMAL" runat="server"        DataIndex="NOR_D11" Width="70" Align="Right" Format="#,##0"/><%--Text="정상" --%>  
                                        <ext:NumberColumn ID="ADD_D11" ItemID="ADD" runat="server"           DataIndex="ADD_D11" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가" --%>
                                        <ext:NumberColumn ID="PO_D11" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D11" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D12_PO" ItemID="D12_PO" runat="server" ><%--Text="D+12 발주">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="INV_D12" ItemID="EXP_INV" runat="server"       DataIndex="INV_D12" Width="70" Align="Right" Format="#,##0"/><%--Text="예상재고" --%>
                                        <ext:NumberColumn ID="REQ_D12" ItemID="PROD_PLAN" runat="server"     DataIndex="REQ_D12" Width="70" Align="Right" Format="#,##0"/><%--Text="생산계획" --%>  
                                        <ext:NumberColumn ID="GAP_D12" ItemID="EXC_QTY" runat="server"       DataIndex="GAP_D12" Width="70" Align="Right" Format="#,##0"/><%--Text="과부족" --%>  
                                        <ext:NumberColumn ID="NOR_D12" ItemID="NORMAL" runat="server"        DataIndex="NOR_D12" Width="70" Align="Right" Format="#,##0"/><%--Text="정상" --%>  
                                        <ext:NumberColumn ID="ADD_D12" ItemID="ADD" runat="server"           DataIndex="ADD_D12" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="추가" --%>
                                        <ext:NumberColumn ID="PO_D12" ItemID="GA_SUB_TOTAL" runat="server"   DataIndex="PO_D12" Width="70" Align="Right" Format="#,##0" Hidden="true"/><%--Text="소계" --%>
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
