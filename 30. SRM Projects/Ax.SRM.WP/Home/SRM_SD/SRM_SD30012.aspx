<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_SD30012.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_SD.SRM_SD30012" %>
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
    <form id="SRM_SD30012" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server" AjaxTimeout="60000">
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
                    <ext:Label ID="lbl01_SRM_SD30012" runat="server" Cls="search_area_title_name" /><%--Text="주간 소요량" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_BIZCD" runat="server" /><%--Text="Business Code" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" Width="260">
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
                                <ext:Label ID="lbl01_WORK_DATE3" runat="server" /><%--Text="일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_BEG_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                            </td>
                        </tr> 
                        <tr style="display:none;">
                            <th>
                                <ext:Label ID="lbl01_PLANT" runat="server" /><%--Text="Vendor Plant" />--%>
                            </th>
                            <td colspan="3">
                                <ext:SelectBox ID="SelectBox01_PLANT" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="PLANTNM" ValueField="PLANTCD" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="PLANTCD" />
                                                        <ext:ModelField Name="PLANTNM" />
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
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50" >
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="PLAN_DATE"/>
                                            <ext:ModelField Name="PLANTNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="NOW_INV_QTY" />
                                            <ext:ModelField Name="WAREH_INV_QTY" />
                                            <ext:ModelField Name="PREVDAY_RSLT_QTY" />
                                            <ext:ModelField Name="DDAY1_QTY" />
                                            <ext:ModelField Name="DDAY2_QTY" />
                                            <ext:ModelField Name="DDAY3_QTY" />
                                            <ext:ModelField Name="DDAY4_QTY" />
                                            <ext:ModelField Name="DDAY5_QTY" />
                                            <ext:ModelField Name="DDAY6_QTY" />
                                            <ext:ModelField Name="DDAY7_QTY" />
                                            <ext:ModelField Name="DDAY8_QTY" />
                                            <ext:ModelField Name="DDAY9_QTY" />
                                            <ext:ModelField Name="DDAY10_QTY" />
                                            <ext:ModelField Name="DDAY_FULL_TOT_QTY" />
                                            <ext:ModelField Name="D1DAY1_QTY" />
                                            <ext:ModelField Name="D1DAY2_QTY" />
                                            <ext:ModelField Name="D1DAY3_QTY" />
                                            <ext:ModelField Name="D1DAY4_QTY" />
                                            <ext:ModelField Name="D1DAY5_QTY" />
                                            <ext:ModelField Name="D1DAY6_QTY" />
                                            <ext:ModelField Name="D1DAY7_QTY" />
                                            <ext:ModelField Name="D1DAY8_QTY" />
                                            <ext:ModelField Name="D1DAY9_QTY" />
                                            <ext:ModelField Name="D1DAY10_QTY" />
                                            <ext:ModelField Name="D1DAY_FULL_TOT_QTY" />
                                            <ext:ModelField Name="D2DAY1_QTY" />
                                            <ext:ModelField Name="D2DAY2_QTY" />
                                            <ext:ModelField Name="D2DAY3_QTY" />
                                            <ext:ModelField Name="D2DAY4_QTY" />
                                            <ext:ModelField Name="D2DAY5_QTY" />
                                            <ext:ModelField Name="D2DAY6_QTY" />
                                            <ext:ModelField Name="D2DAY7_QTY" />
                                            <ext:ModelField Name="D2DAY8_QTY" />
                                            <ext:ModelField Name="D2DAY9_QTY" />
                                            <ext:ModelField Name="D2DAY10_QTY" />
                                            <ext:ModelField Name="D2DAY_FULL_TOT_QTY" />
                                            <ext:ModelField Name="D3DAY1_QTY" />
                                            <ext:ModelField Name="D3DAY2_QTY" />
                                            <ext:ModelField Name="D3DAY3_QTY" />
                                            <ext:ModelField Name="D3DAY4_QTY" />
                                            <ext:ModelField Name="D3DAY5_QTY" />
                                            <ext:ModelField Name="D3DAY6_QTY" />
                                            <ext:ModelField Name="D3DAY7_QTY" />
                                            <ext:ModelField Name="D3DAY8_QTY" />
                                            <ext:ModelField Name="D3DAY9_QTY" />
                                            <ext:ModelField Name="D3DAY10_QTY" />
                                            <ext:ModelField Name="D3DAY_FULL_TOT_QTY" />
                                            <ext:ModelField Name="D4DAY1_QTY" />
                                            <ext:ModelField Name="D4DAY2_QTY" />
                                            <ext:ModelField Name="D4DAY3_QTY" />
                                            <ext:ModelField Name="D4DAY4_QTY" />
                                            <ext:ModelField Name="D4DAY5_QTY" />
                                            <ext:ModelField Name="D4DAY6_QTY" />
                                            <ext:ModelField Name="D4DAY7_QTY" />
                                            <ext:ModelField Name="D4DAY8_QTY" />
                                            <ext:ModelField Name="D4DAY9_QTY" />
                                            <ext:ModelField Name="D4DAY10_QTY" />
                                            <ext:ModelField Name="D4DAY_FULL_TOT_QTY" />
                                            <ext:ModelField Name="D5DAY_QTY" />
                                            <ext:ModelField Name="D6DAY_QTY" />
                                            <ext:ModelField Name="D7DAY_QTY" />
                                            <ext:ModelField Name="D8DAY_QTY" />
                                            <ext:ModelField Name="D9DAY_QTY" />
                                            <ext:ModelField Name="D10DAY_QTY" />
                                            <ext:ModelField Name="D11DAY_QTY" />
                                            <ext:ModelField Name="D12DAY_QTY" />
                                            <ext:ModelField Name="D13DAY_QTY" />
                                            <ext:ModelField Name="D14DAY_QTY" />
                                            <ext:ModelField Name="D15DAY_QTY" />
                                            <ext:ModelField Name="D16DAY_QTY" />
                                            <ext:ModelField Name="D17DAY_QTY" />
                                            <ext:ModelField Name="D18DAY_QTY" />
                                            <ext:ModelField Name="D19DAY_QTY" />
                                            <ext:ModelField Name="D20DAY_QTY" />
                                            <ext:ModelField Name="D21DAY_QTY" />
                                            <ext:ModelField Name="D22DAY_QTY" />
                                            <ext:ModelField Name="D23DAY_QTY" />
                                            <ext:ModelField Name="D24DAY_QTY" />
                                            <ext:ModelField Name="D25DAY_QTY" />
                                            <ext:ModelField Name="D26DAY_QTY" />
                                            <ext:ModelField Name="D27DAY_QTY" />
                                            <ext:ModelField Name="D28DAY_QTY" />
                                            <ext:ModelField Name="D29DAY_QTY" />
                                            <ext:ModelField Name="D30DAY_QTY" />
                                            <ext:ModelField Name="PO_SURP_QTY" />
                                            <ext:ModelField Name="DIR_TYPE" />
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
                                <ext:RowNumbererColumn ID="NO"          ItemID="NO"             runat="server" Text="No" Width="40" Align="Center" />
                                <ext:DateColumn ID="PLAN_DATE"          ItemID="PLAN_DATE"      runat="server" DataIndex="PLAN_DATE"        Width="90" Align="Center" Locked="true"/>  <%--Text="계획일자"    --%>
                                <ext:Column ID="PLANTNM"                ItemID="VENDOR_PLANT"   runat="server" DataIndex="PLANTNM"          Width="150"  Align="Center" Locked="true"/><%--Text="거래처공장"  --%>
                                <ext:Column ID="PARTNO"                 ItemID="PARTNOTITLE"    runat="server" DataIndex="PARTNO"           Width="150" Align="Left" Locked="true"/>   <%--Text="품번"      --%>  
                                <ext:Column ID="PARTNM"                 ItemID="PARTNMTITLE"    runat="server" DataIndex="PARTNM"           MinWidth="220"  Align="Left" Flex="1" />   <%--Text="품명"        --%>
                                <ext:NumberColumn ID="NOW_INV_QTY"      ItemID="NOW_INV"        runat="server" DataIndex="NOW_INV_QTY"      Width="80" Align="Right" Format="#,##0.###"/>  <%--Text="현재고"      --%>
                                <ext:NumberColumn ID="WAREH_INV_QTY"    ItemID="WAREH_INV"      runat="server" DataIndex="WAREH_INV_QTY"     Width="80" Align="Right" Format="#,##0.###"/> <%--Text="실물재고"    --%>
                                <ext:NumberColumn ID="PREVDAY_RSLT_QTY" ItemID="PREVDAY_RSLT"   runat="server" DataIndex="PREVDAY_RSLT_QTY" Width="80" Align="Right" Format="#,##0.###"/>  <%--Text="전일실적"    --%>
                                
                                <ext:NumberColumn ID="DDAY1_QTY" ItemID="D_08" runat="server" DataIndex="DDAY1_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D 08" --%>
                                <ext:NumberColumn ID="DDAY2_QTY" ItemID="D_10" runat="server" DataIndex="DDAY2_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D 10" --%>
                                <ext:NumberColumn ID="DDAY3_QTY" ItemID="D_12" runat="server" DataIndex="DDAY3_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D 12" --%>
                                <ext:NumberColumn ID="DDAY4_QTY" ItemID="D_15" runat="server" DataIndex="DDAY4_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D 15" --%>
                                <ext:NumberColumn ID="DDAY5_QTY" ItemID="D_17" runat="server" DataIndex="DDAY5_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D 17" --%>
                                <ext:NumberColumn ID="DDAY6_QTY" ItemID="D_20" runat="server" DataIndex="DDAY6_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D 20" --%>
                                <ext:NumberColumn ID="DDAY7_QTY" ItemID="D_23" runat="server" DataIndex="DDAY7_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D 23" --%>
                                <ext:NumberColumn ID="DDAY8_QTY" ItemID="D_01" runat="server" DataIndex="DDAY8_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D 01" --%>
                                <ext:NumberColumn ID="DDAY9_QTY" ItemID="D_04" runat="server" DataIndex="DDAY9_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D 04" --%>
                                <ext:NumberColumn ID="DDAY10_QTY" ItemID="D_06" runat="server" DataIndex="DDAY10_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D 06" --%>
                                <ext:NumberColumn ID="DDAY_FULL_TOT_QTY" ItemID="DDAY_FULL_TOT_QTY" runat="server" DataIndex="DDAY_FULL_TOT_QTY" Width="80" Align="Right" Format="#,##0.###"/><%--Text="D합계" --%>
                                    
                                <ext:NumberColumn ID="D1DAY1_QTY" ItemID="D1_08" runat="server" DataIndex="D1DAY1_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+1 08" --%>
                                <ext:NumberColumn ID="D1DAY2_QTY" ItemID="D1_10" runat="server" DataIndex="D1DAY2_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+1 10" --%>
                                <ext:NumberColumn ID="D1DAY3_QTY" ItemID="D1_12" runat="server" DataIndex="D1DAY3_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+1 12" --%>
                                <ext:NumberColumn ID="D1DAY4_QTY" ItemID="D1_15" runat="server" DataIndex="D1DAY4_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+1 15" --%>
                                <ext:NumberColumn ID="D1DAY5_QTY" ItemID="D1_17" runat="server" DataIndex="D1DAY5_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+1 17" --%>
                                <ext:NumberColumn ID="D1DAY6_QTY" ItemID="D1_20" runat="server" DataIndex="D1DAY6_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+1 20" --%>
                                <ext:NumberColumn ID="D1DAY7_QTY" ItemID="D1_23" runat="server" DataIndex="D1DAY7_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+1 23" --%>
                                <ext:NumberColumn ID="D1DAY8_QTY" ItemID="D1_01" runat="server" DataIndex="D1DAY8_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+1 01" --%>
                                <ext:NumberColumn ID="D1DAY9_QTY" ItemID="D1_04" runat="server" DataIndex="D1DAY9_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+1 04" --%>
                                <ext:NumberColumn ID="D1DAY10_QTY" ItemID="D1_06" runat="server" DataIndex="D1DAY10_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+1 06" --%>
                                <ext:NumberColumn ID="D1DAY_FULL_TOT_QTY" ItemID="D1DAY_FULL_TOT_QTY" runat="server" DataIndex="D1DAY_FULL_TOT_QTY" Width="80" Align="Right" Format="#,##0.###"/><%--Text="D+1합계" --%>

                                <ext:NumberColumn ID="D2DAY1_QTY" ItemID="D2_08" runat="server" DataIndex="D2DAY1_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+2 08" --%>
                                <ext:NumberColumn ID="D2DAY2_QTY" ItemID="D2_10" runat="server" DataIndex="D2DAY2_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+2 10" --%>
                                <ext:NumberColumn ID="D2DAY3_QTY" ItemID="D2_12" runat="server" DataIndex="D2DAY3_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+2 12" --%>
                                <ext:NumberColumn ID="D2DAY4_QTY" ItemID="D2_15" runat="server" DataIndex="D2DAY4_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+2 15" --%>
                                <ext:NumberColumn ID="D2DAY5_QTY" ItemID="D2_17" runat="server" DataIndex="D2DAY5_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+2 17" --%>
                                <ext:NumberColumn ID="D2DAY6_QTY" ItemID="D2_20" runat="server" DataIndex="D2DAY6_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+2 20" --%>
                                <ext:NumberColumn ID="D2DAY7_QTY" ItemID="D2_23" runat="server" DataIndex="D2DAY7_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+2 23" --%>
                                <ext:NumberColumn ID="D2DAY8_QTY" ItemID="D2_01" runat="server" DataIndex="D2DAY8_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+2 01" --%>
                                <ext:NumberColumn ID="D2DAY9_QTY" ItemID="D2_04" runat="server" DataIndex="D2DAY9_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+2 04" --%>
                                <ext:NumberColumn ID="D2DAY10_QTY" ItemID="D2_06" runat="server" DataIndex="D2DAY10_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+2 06" --%>
                                <ext:NumberColumn ID="D2DAY_FULL_TOT_QTY" ItemID="D2DAY_FULL_TOT_QTY" runat="server" DataIndex="D2DAY_FULL_TOT_QTY" Width="80" Align="Right" Format="#,##0.###"/><%--Text="D+2합계" --%>
                                   
                                <ext:NumberColumn ID="D3DAY1_QTY" ItemID="D3_08" runat="server" DataIndex="D3DAY1_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+3 08" --%>
                                <ext:NumberColumn ID="D3DAY2_QTY" ItemID="D3_10" runat="server" DataIndex="D3DAY2_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+3 10" --%>
                                <ext:NumberColumn ID="D3DAY3_QTY" ItemID="D3_12" runat="server" DataIndex="D3DAY3_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+3 12" --%>
                                <ext:NumberColumn ID="D3DAY4_QTY" ItemID="D3_15" runat="server" DataIndex="D3DAY4_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+3 15" --%>
                                <ext:NumberColumn ID="D3DAY5_QTY" ItemID="D3_17" runat="server" DataIndex="D3DAY5_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+3 17" --%>
                                <ext:NumberColumn ID="D3DAY6_QTY" ItemID="D3_20" runat="server" DataIndex="D3DAY6_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+3 20" --%>
                                <ext:NumberColumn ID="D3DAY7_QTY" ItemID="D3_23" runat="server" DataIndex="D3DAY7_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+3 23" --%>
                                <ext:NumberColumn ID="D3DAY8_QTY" ItemID="D3_01" runat="server" DataIndex="D3DAY8_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+3 01" --%>
                                <ext:NumberColumn ID="D3DAY9_QTY" ItemID="D3_04" runat="server" DataIndex="D3DAY9_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+3 04" --%>
                                <ext:NumberColumn ID="D3DAY10_QTY" ItemID="D3_06" runat="server" DataIndex="D3DAY10_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+3 06" --%>
                                <ext:NumberColumn ID="D3DAY_FULL_TOT_QTY" ItemID="D3DAY_FULL_TOT_QTY" runat="server" DataIndex="D3DAY_FULL_TOT_QTY" Width="80" Align="Right" Format="#,##0.###"/><%--Text="D+3합계" --%>
                                   
                                <ext:NumberColumn ID="D4DAY1_QTY" ItemID="D4_08" runat="server" DataIndex="D4DAY1_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+4 08" --%>
                                <ext:NumberColumn ID="D4DAY2_QTY" ItemID="D4_10" runat="server" DataIndex="D4DAY2_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+4 10" --%>
                                <ext:NumberColumn ID="D4DAY3_QTY" ItemID="D4_12" runat="server" DataIndex="D4DAY3_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+4 12"--%> 
                                <ext:NumberColumn ID="D4DAY4_QTY" ItemID="D4_15" runat="server" DataIndex="D4DAY4_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+4 15" --%>
                                <ext:NumberColumn ID="D4DAY5_QTY" ItemID="D4_17" runat="server" DataIndex="D4DAY5_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+4 17" --%>
                                <ext:NumberColumn ID="D4DAY6_QTY" ItemID="D4_20" runat="server" DataIndex="D4DAY6_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+4 20" --%>
                                <ext:NumberColumn ID="D4DAY7_QTY" ItemID="D4_23" runat="server" DataIndex="D4DAY7_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+4 23" --%>
                                <ext:NumberColumn ID="D4DAY8_QTY" ItemID="D4_01" runat="server" DataIndex="D4DAY8_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+4 01" --%>
                                <ext:NumberColumn ID="D4DAY9_QTY" ItemID="D4_04" runat="server" DataIndex="D4DAY9_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+4 04" --%>
                                <ext:NumberColumn ID="D4DAY10_QTY" ItemID="D4_06" runat="server" DataIndex="D4DAY10_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+4 06" --%>
                                <ext:NumberColumn ID="D4DAY_FULL_TOT_QTY" ItemID="D4DAY_FULL_TOT_QTY" runat="server" DataIndex="D4DAY_FULL_TOT_QTY" Width="80" Align="Right" Format="#,##0.###"/><%--Text="D+4합계" --%>
                                    
                                <ext:NumberColumn ID="D5DAY_QTY" ItemID="DDAY_EXP5" runat="server" DataIndex="D5DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+5예정" --%>
                                <ext:NumberColumn ID="D6DAY_QTY" ItemID="DDAY_EXP6" runat="server" DataIndex="D6DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+6예정" --%>
                                <ext:NumberColumn ID="D7DAY_QTY" ItemID="DDAY_EXP7" runat="server" DataIndex="D7DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+7예정" --%>
                                <ext:NumberColumn ID="D8DAY_QTY" ItemID="DDAY_EXP8" runat="server" DataIndex="D8DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+8예정" --%>
                                <ext:NumberColumn ID="D9DAY_QTY" ItemID="DDAY_EXP9" runat="server" DataIndex="D9DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+9예정" --%>
                                <ext:NumberColumn ID="D10DAY_QTY" ItemID="DDAY_EXP10" runat="server" DataIndex="D10DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+10예정" --%>
                                <ext:NumberColumn ID="D11DAY_QTY" ItemID="DDAY_EXP11" runat="server" DataIndex="D11DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+11예정" --%>
                                <ext:NumberColumn ID="D12DAY_QTY" ItemID="DDAY_EXP12" runat="server" DataIndex="D12DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+12예정" --%>
                                <ext:NumberColumn ID="D13DAY_QTY" ItemID="DDAY_EXP13" runat="server" DataIndex="D13DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+13예정" --%>
                                <ext:NumberColumn ID="D14DAY_QTY" ItemID="DDAY_EXP14" runat="server" DataIndex="D14DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+14예정" --%>
                                <ext:NumberColumn ID="D15DAY_QTY" ItemID="DDAY_EXP15" runat="server" DataIndex="D15DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+15예정" --%>
                                <ext:NumberColumn ID="D16DAY_QTY" ItemID="DDAY_EXP16" runat="server" DataIndex="D16DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+16예정" --%>
                                <ext:NumberColumn ID="D17DAY_QTY" ItemID="DDAY_EXP17" runat="server" DataIndex="D17DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+17예정" --%>
                                <ext:NumberColumn ID="D18DAY_QTY" ItemID="DDAY_EXP18" runat="server" DataIndex="D18DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+18예정" --%>
                                <ext:NumberColumn ID="D19DAY_QTY" ItemID="DDAY_EXP19" runat="server" DataIndex="D19DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+19예정"--%> 
                                <ext:NumberColumn ID="D20DAY_QTY" ItemID="DDAY_EXP20" runat="server" DataIndex="D20DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+20예정" --%>
                                <ext:NumberColumn ID="D21DAY_QTY" ItemID="DDAY_EXP21" runat="server" DataIndex="D21DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+21예정" --%>
                                <ext:NumberColumn ID="D22DAY_QTY" ItemID="DDAY_EXP22" runat="server" DataIndex="D22DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+22예정"--%> 
                                <ext:NumberColumn ID="D23DAY_QTY" ItemID="DDAY_EXP23" runat="server" DataIndex="D23DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+23예정" --%>
                                <ext:NumberColumn ID="D24DAY_QTY" ItemID="DDAY_EXP24" runat="server" DataIndex="D24DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+24예정"--%> 
                                <ext:NumberColumn ID="D25DAY_QTY" ItemID="DDAY_EXP25" runat="server" DataIndex="D25DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+25예정"--%> 
                                <ext:NumberColumn ID="D26DAY_QTY" ItemID="DDAY_EXP26" runat="server" DataIndex="D26DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+26예정" --%>
                                <ext:NumberColumn ID="D27DAY_QTY" ItemID="DDAY_EXP27" runat="server" DataIndex="D27DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+27예정" --%>
                                <ext:NumberColumn ID="D28DAY_QTY" ItemID="DDAY_EXP28" runat="server" DataIndex="D28DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+28예정" --%>
                                <ext:NumberColumn ID="D29DAY_QTY" ItemID="DDAY_EXP29" runat="server" DataIndex="D29DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+29예정" --%>
                                <ext:NumberColumn ID="D30DAY_QTY" ItemID="DDAY_EXP30" runat="server" DataIndex="D30DAY_QTY" Width="65" Align="Right" Format="#,##0.###"/><%--Text="D+30예정" --%>
                                <ext:NumberColumn ID="PO_SURP_QTY" ItemID="PO_SURP_QTY"  runat="server" DataIndex="PO_SURP_QTY"   Width="65" Align="Right" Format="#,##0.###"/><%--Text="발주잔량"     --%> 
                                <ext:NumberColumn ID="DIR_TYPE"    ItemID="DIR_TYPE_QTY" runat="server" DataIndex="DIR_TYPE"      Width="90" Align="Right" Format="#,##0.###"/><%--Text="납입지시수량"  --%>
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
