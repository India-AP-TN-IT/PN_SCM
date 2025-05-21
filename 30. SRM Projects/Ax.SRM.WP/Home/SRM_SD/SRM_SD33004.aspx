<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_SD33004.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_SD.SRM_SD33004" %>
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
    <form id="SRM_SD33004" runat="server">
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
                    <ext:Label ID="lbl01_SRM_SD33004" runat="server" Cls="search_area_title_name" /><%--Text="물류모니터링조회" />--%>
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
                            <col />
                        </colgroup>
                        <tr>                               
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
                                <ext:Label ID="lbl01_SHIP_DATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_PLAN_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />                                
                            </td>
                        </tr>                        
                    </table>
                </Content>
            </ext:Panel>
            <ext:Label ID="lbl01_SD_MSG002" runat="server" Region="North" Height="25" Cls="grid_area_coment" />  <%--Text="과부족 = 물류사재고 + 고객사재고 + 출하 계 - 2T단위 계획"--%>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>                    
                    <ext:GridPanel ID="Grid01" runat="server" TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50" >
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="PLANTNM" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="CUST_ITEMCD" />
                                            <ext:ModelField Name="CUST_ITEMNM" />
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="INSTALL_POSNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="PREVDAY_RSLT_QTY" />                                             
                                            <ext:ModelField Name="VEND_INV_QTY" />
                                            <ext:ModelField Name="WH_INV_QTY" />
                                            <ext:ModelField Name="CUST_INV_QTY" />
                                            <ext:ModelField Name="BAS_INV" />
                                            <ext:ModelField Name="PLAN_QTY" />
                                            <ext:ModelField Name="PLAN_QTY1" />
                                            <ext:ModelField Name="PLAN_QTY2" />
                                            <ext:ModelField Name="PLAN_QTY3" />
                                            <ext:ModelField Name="PLAN_QTY4" />
                                            <ext:ModelField Name="PLAN_QTY5" />
                                            <ext:ModelField Name="PLAN_QTY6" />
                                            <ext:ModelField Name="PLAN_QTY7" />
                                            <ext:ModelField Name="PLAN_QTY8" />
                                            <ext:ModelField Name="PLAN_QTY9" />
                                            <ext:ModelField Name="PLAN_QTY10" />

                                            <ext:ModelField Name="DDAY1_QTY" />
                                            <ext:ModelField Name="D0T1_QTY" />
                                            <ext:ModelField Name="DDAY2_QTY" />
                                            <ext:ModelField Name="D0T2_QTY" />
                                            <ext:ModelField Name="DDAY3_QTY" />
                                            <ext:ModelField Name="D0T3_QTY" />
                                            <ext:ModelField Name="DDAY4_QTY" />
                                            <ext:ModelField Name="D0T4_QTY" />
                                            <ext:ModelField Name="DDAY5_QTY" />
                                            <ext:ModelField Name="D0T5_QTY" />
                                            <ext:ModelField Name="DDAY6_QTY" />
                                            <ext:ModelField Name="D0T6_QTY" />
                                            <ext:ModelField Name="DDAY7_QTY" />
                                            <ext:ModelField Name="D0T7_QTY" />
                                            <ext:ModelField Name="DDAY8_QTY" />
                                            <ext:ModelField Name="D0T8_QTY" />
                                            <ext:ModelField Name="DDAY9_QTY" />
                                            <ext:ModelField Name="D0T9_QTY" />
                                            <ext:ModelField Name="DDAY10_QTY" />
                                            <ext:ModelField Name="D0T10_QTY" />

                                            <ext:ModelField Name="D1DAY1_QTY" />
                                            <ext:ModelField Name="D1T1_QTY" />
                                            <ext:ModelField Name="D1DAY2_QTY" />
                                            <ext:ModelField Name="D1T2_QTY" />
                                            <ext:ModelField Name="D1DAY3_QTY" />
                                            <ext:ModelField Name="D1T3_QTY" />
                                            <ext:ModelField Name="D1DAY4_QTY" />
                                            <ext:ModelField Name="D1T4_QTY" />
                                            <ext:ModelField Name="D1DAY5_QTY" />
                                            <ext:ModelField Name="D1T5_QTY" />
                                            <ext:ModelField Name="D1DAY6_QTY" />
                                            <ext:ModelField Name="D1T6_QTY" />
                                            <ext:ModelField Name="D1DAY7_QTY" />
                                            <ext:ModelField Name="D1T7_QTY" />
                                            <ext:ModelField Name="D1DAY8_QTY" />
                                            <ext:ModelField Name="D1T8_QTY" />
                                            <ext:ModelField Name="D1DAY9_QTY" />
                                            <ext:ModelField Name="D1T9_QTY" />
                                            <ext:ModelField Name="D1DAY10_QTY" />
                                            <ext:ModelField Name="D1T10_QTY" />
                                                 
                                            <ext:ModelField Name="D2DAY_QTY" />  
                                            <ext:ModelField Name="D3DAY_QTY" />  
                                            <ext:ModelField Name="D4DAY_QTY" />  
                                            <ext:ModelField Name="D5DAY_QTY" />  
                                            <ext:ModelField Name="D6DAY_QTY" />  
                                            <ext:ModelField Name="D7DAY_QTY" />  
                                            <ext:ModelField Name="D8DAY_QTY" />  
                                            <ext:ModelField Name="D9DAY_QTY" />  
                                            <ext:ModelField Name="D10DAY_QTY" />  
                                            <ext:ModelField Name="D11DAY_QTY" />  
                                            <ext:ModelField Name="D12DAY_QTY" />                             
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
                            <%--<ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>--%>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" Locked="true" />
                                <ext:Column ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="200" Align="Left" Locked="true" /><%--Text="업체명"      --%>
                                <ext:Column ID="PLANTNM" ItemID="VEND_PLANT" runat="server" DataIndex="PLANTNM" Width="100" Align="Left" Locked="true"/><%--Text="고객사공장"      --%>
                                <ext:Column ID="VINNM" ItemID="VIN" runat="server" DataIndex="VINNM" Width="50" Align="Center" Locked="true" /><%--Text="차종"      --%>
                                <ext:Column ID="CUST_ITEMCD" ItemID="CUST_ITEM2" runat="server" DataIndex="CUST_ITEMCD" Width="110" Align="Left" Locked="true"/><%--Text="고객사 품목(PART)"--%>
                                <ext:Column ID="CUST_ITEMNM" ItemID="ITEMNM3" runat="server" DataIndex="CUST_ITEMNM" Width="150" Align="Left" Locked="true" /><%--Text="품목명"--%>
                                <ext:Column ID="ALCCD" ItemID="ALCCD" runat="server" DataIndex="ALCCD" Width="60" Align="Center" Locked="true"/> <%--Text="ALC"--%>   
                                <ext:Column ID="INSTALL_POSNM" ItemID="POSTITLE" runat="server" DataIndex="INSTALL_POSNM" Width="70" Align="Left" Locked="true" /><%--Text="위치"  --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="180" Align="Left" /><%--Text="PART NAME" --%>
                                <ext:NumberColumn ID="PREVDAY_RSLT_QTY" ItemID="PREVDAY_RSLT_QTY2" runat="server" DataIndex="PREVDAY_RSLT_QTY" Width="100" Align="Right" Format="#,##0.###"/><%--Text="고객사전일투입"  --%>
                                <ext:Column ID="INV_STATUS2" ItemID="INV_STATUS2" runat="server" ><%--Text="재고현황(완제품, 06시준)">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="VEND_INV_QTY" ItemID="VEND_INV_QTY" runat="server" DataIndex="VEND_INV_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="사내"--%>
                                        <ext:NumberColumn ID="WH_INV_QTY" ItemID="WH_INV_QTY" runat="server" DataIndex="WH_INV_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="물류사"--%>
                                        <ext:NumberColumn ID="CUST_INV_QTY" ItemID="CUSTOMER" runat="server" DataIndex="CUST_INV_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="고객사"--%>
                                        <ext:NumberColumn ID="BAS_INV" ItemID="SUM_AMT" runat="server" DataIndex="BAS_INV" Width="60" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="계"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="SHIP_PLAN" ItemID="SHIP_PLAN" runat="server" ><%--Text="출하계획">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PLAN_QTY" ItemID="TOT2" runat="server" DataIndex="PLAN_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="PLAN_QTY1" ItemID="QTY01" runat="server" DataIndex="PLAN_QTY1" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="PLAN_QTY2" ItemID="QTY02" runat="server" DataIndex="PLAN_QTY2" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="PLAN_QTY3" ItemID="QTY03" runat="server" DataIndex="PLAN_QTY3" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="PLAN_QTY4" ItemID="QTY04" runat="server" DataIndex="PLAN_QTY4" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="PLAN_QTY5" ItemID="QTY05" runat="server" DataIndex="PLAN_QTY5" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="PLAN_QTY6" ItemID="QTY06" runat="server" DataIndex="PLAN_QTY6" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="PLAN_QTY7" ItemID="QTY07" runat="server" DataIndex="PLAN_QTY7" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="PLAN_QTY8" ItemID="QTY08" runat="server" DataIndex="PLAN_QTY8" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="PLAN_QTY9" ItemID="QTY09" runat="server" DataIndex="PLAN_QTY9" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="PLAN_QTY10" ItemID="QTY10" runat="server" DataIndex="PLAN_QTY10" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="DDAY_PLAN" ItemID="DDAY_PLAN" runat="server" ><%--Text="D 일 고객사 계획">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="DDAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="DDAY1_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D0T1_QTY" ItemID="INREMAIN_0" runat="server" DataIndex="D0T1_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="DDAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="DDAY2_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D0T2_QTY" ItemID="INREMAIN_1" runat="server" DataIndex="D0T2_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="DDAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="DDAY3_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D0T3_QTY" ItemID="INREMAIN_2" runat="server" DataIndex="D0T3_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="DDAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="DDAY4_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D0T4_QTY" ItemID="INREMAIN_3" runat="server" DataIndex="D0T4_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="DDAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="DDAY5_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D0T5_QTY" ItemID="INREMAIN_4" runat="server" DataIndex="D0T5_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="DDAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="DDAY6_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D0T6_QTY" ItemID="INREMAIN_5" runat="server" DataIndex="D0T6_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="DDAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="DDAY7_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D0T7_QTY" ItemID="INREMAIN_6" runat="server" DataIndex="D0T7_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="DDAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="DDAY8_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D0T8_QTY" ItemID="INREMAIN_7" runat="server" DataIndex="D0T8_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="DDAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="DDAY9_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D0T9_QTY" ItemID="INREMAIN_8" runat="server" DataIndex="D0T9_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="DDAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="DDAY10_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D0T10_QTY" ItemID="EXC_QTY" runat="server" DataIndex="D0T10_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D1DAY_PLAN" ItemID="D1DAY_PLAN" runat="server" ><%--Text="D+1 일 고객사 계획">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D1DAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="D1DAY1_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D1T1_QTY" ItemID="INREMAIN_0" runat="server" DataIndex="D1T1_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="D1DAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="D1DAY2_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D1T2_QTY" ItemID="INREMAIN_1" runat="server" DataIndex="D1T2_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="D1DAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="D1DAY3_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D1T3_QTY" ItemID="INREMAIN_2" runat="server" DataIndex="D1T3_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="D1DAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="D1DAY4_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D1T4_QTY" ItemID="INREMAIN_3" runat="server" DataIndex="D1T4_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="D1DAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="D1DAY5_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D1T5_QTY" ItemID="INREMAIN_4" runat="server" DataIndex="D1T5_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="D1DAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="D1DAY6_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D1T6_QTY" ItemID="INREMAIN_5" runat="server" DataIndex="D1T6_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="D1DAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="D1DAY7_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D1T7_QTY" ItemID="INREMAIN_6" runat="server" DataIndex="D1T7_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="D1DAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="D1DAY8_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D1T8_QTY" ItemID="INREMAIN_7" runat="server" DataIndex="D1T8_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="D1DAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="D1DAY9_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D1T9_QTY" ItemID="INREMAIN_8" runat="server" DataIndex="D1T9_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="D1DAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="D1DAY10_QTY" Width="60" Align="Right" Format="#,##0.###" Text="2T" Sortable="true"/>
                                        <ext:NumberColumn ID="D1T10_QTY" ItemID="EXC_QTY" runat="server" DataIndex="D1T10_QTY" Width="60" Align="Right" Format="#,##0.###" Sortable="true" />
                                    </Columns>
                                </ext:Column>
                                <ext:NumberColumn ID="D2DAY_QTY" ItemID="D2DAY_QTY" runat="server" DataIndex="D2DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+2"/>
                                <ext:NumberColumn ID="D3DAY_QTY" ItemID="D3DAY_QTY" runat="server" DataIndex="D3DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+3"/>
                                <ext:NumberColumn ID="D4DAY_QTY" ItemID="D4DAY_QTY" runat="server" DataIndex="D4DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+4"/>
                                <ext:NumberColumn ID="D5DAY_QTY" ItemID="D5DAY_QTY" runat="server" DataIndex="D5DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+5"/>
                                <ext:NumberColumn ID="D6DAY_QTY" ItemID="D6DAY_QTY" runat="server" DataIndex="D6DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+6"/>
                                <ext:NumberColumn ID="D7DAY_QTY" ItemID="D7DAY_QTY" runat="server" DataIndex="D7DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+7"/>
                                <ext:NumberColumn ID="D8DAY_QTY" ItemID="D8DAY_QTY" runat="server" DataIndex="D8DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+8"/>
                                <ext:NumberColumn ID="D9DAY_QTY" ItemID="D9DAY_QTY" runat="server" DataIndex="D9DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+9"/>
                                <ext:NumberColumn ID="D10DAY_QTY" ItemID="D10DAY_QTY" runat="server" DataIndex="D10DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+10"/>
                                <ext:NumberColumn ID="D11DAY_QTY" ItemID="D11DAY_QTY" runat="server" DataIndex="D11DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+11"/>
                                <ext:NumberColumn ID="D12DAY_QTY" ItemID="D12DAY_QTY" runat="server" DataIndex="D12DAY_QTY" Width="60" Align="Right" Format="#,##0.###" Text="D+12"/>
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
