<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_SD30013.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_SD.SRM_SD30013" %>
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
    <form id="SRM_SD30013" runat="server">
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
                    <ext:Label ID="lbl01_SRM_SD30013" runat="server" Cls="search_area_title_name" /><%--Text="서열부품 PARTNO" />--%>
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
                            <col style="width: 300px;"/>
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
                                <ext:Label ID="lbl01_WORK_DATE3" runat="server" /><%--Text="일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_BEG_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                            </td>
                            <th style="display:none;">
                                <ext:Label ID="lbl01_VINCD" runat="server" /><%--Text="Vihicle Code" />--%>
                            </th>
                            <td style="display:none;">
                                <epc:EPCodeBox ID="cdx01_VINCD" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow"/>
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
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="PREVDAY_RSLT_QTY" />
                                            <ext:ModelField Name="PBS_QTY" />
                                            <ext:ModelField Name="PAINT_REJECT_QTY" />
                                            <ext:ModelField Name="WBS_QTY" />
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
                                            <ext:ModelField Name="DDAY11_QTY" />
                                            <ext:ModelField Name="DDAY12_QTY" />
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
                                            <ext:ModelField Name="D1DAY11_QTY" />
                                            <ext:ModelField Name="D1DAY12_QTY" />
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
                                            <ext:ModelField Name="D2DAY11_QTY" />
                                            <ext:ModelField Name="D2DAY12_QTY" />
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
                                            <ext:ModelField Name="D3DAY11_QTY" />
                                            <ext:ModelField Name="D3DAY12_QTY" />
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
                                            <ext:ModelField Name="D4DAY11_QTY" />
                                            <ext:ModelField Name="D4DAY12_QTY" />
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
                                            <ext:ModelField Name="D31DAY_QTY" />
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
                                <ext:DateColumn ID="PLAN_DATE"          ItemID="PLAN_DATE"      runat="server" DataIndex="PLAN_DATE"   Width="100" Align="Center" Locked="true"/>     <%--Text="계획일자" --%>   
                                <ext:Column ID="VINCD"                  ItemID="VINCD"          runat="server" DataIndex="VINCD"       Width="65"  Align="Center" Locked="true"/>     <%--Text="차종" --%>       
                                <ext:Column ID="ALCCD"                  ItemID="ALCCD"          runat="server" DataIndex="ALCCD"       Width="65"  Align="Left"  Locked="true"/>      <%--Text="ALC 코드" --%>   
                                <ext:Column ID="PARTNO"                 ItemID="PARTNOTITLE"    runat="server" DataIndex="PARTNO"      Width="160" Align="Left" Locked="true"/>       <%--Text="품번"--%>        
                                <ext:Column ID="PARTNM"                 ItemID="PARTNMTITLE"    runat="server" DataIndex="PARTNM"      MinWidth="220"  Align="Left" Flex="1" />       <%--Text="품명" --%>       
                                <ext:NumberColumn ID="PREVDAY_RSLT_QTY" ItemID="PREVDAY_RSLT"   runat="server" DataIndex="PREVDAY_RSLT_QTY" Width="80" Align="Right" Format="#,##0.###"/> <%--Text="전일실적"--%>    
                                <ext:NumberColumn ID="PBS_QTY"          ItemID="PBS"            runat="server" DataIndex="PBS_QTY"           Width="80" Align="Right" Format="#,##0.###"/><%--Text="PBS" --%>        
                                <ext:NumberColumn ID="PAINT_REJECT_QTY" ItemID="PAINT_REJECT"   runat="server" DataIndex="PAINT_REJECT_QTY"  Width="80" Align="Right" Format="#,##0.###"/><%--Text="REJ" --%>        
                                <ext:NumberColumn ID="WBS_QTY"          ItemID="WBS"            runat="server" DataIndex="WBS_QTY"           Width="80" Align="Right" Format="#,##0.###"/><%--Text="WBS" --%>
                                <ext:Column ID="DDAY"                   ItemID="DDAY"           runat="server" ><%--Text="D DAY"--%>
                                    <Columns>
                                        <ext:NumberColumn ID="DDAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="DDAY1_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T1" --%>
                                        <ext:NumberColumn ID="DDAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="DDAY2_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T2" --%>
                                        <ext:NumberColumn ID="DDAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="DDAY3_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T3" --%>
                                        <ext:NumberColumn ID="DDAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="DDAY4_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T4" --%>
                                        <ext:NumberColumn ID="DDAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="DDAY5_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T5" --%> 
                                        <ext:NumberColumn ID="DDAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="DDAY6_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T6" --%>
                                        <ext:NumberColumn ID="DDAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="DDAY7_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T7" --%> 
                                        <ext:NumberColumn ID="DDAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="DDAY8_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T8" --%>
                                        <ext:NumberColumn ID="DDAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="DDAY9_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T9" --%>
                                        <ext:NumberColumn ID="DDAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="DDAY10_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T10" --%>
                                        <ext:NumberColumn ID="DDAY11_QTY" ItemID="DDAY11_QTY" runat="server" DataIndex="DDAY11_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T11" --%>
                                        <ext:NumberColumn ID="DDAY12_QTY" ItemID="DDAY12_QTY" runat="server" DataIndex="DDAY12_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T12" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D1DAY" ItemID="D1DAY" runat="server" ><%--Text="D+1 DAY"--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D1DAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="D1DAY1_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T1" --%>
                                        <ext:NumberColumn ID="D1DAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="D1DAY2_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T2" --%>
                                        <ext:NumberColumn ID="D1DAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="D1DAY3_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T3" --%>
                                        <ext:NumberColumn ID="D1DAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="D1DAY4_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T4" --%> 
                                        <ext:NumberColumn ID="D1DAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="D1DAY5_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T5" --%>
                                        <ext:NumberColumn ID="D1DAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="D1DAY6_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T6" --%>
                                        <ext:NumberColumn ID="D1DAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="D1DAY7_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T7" --%> 
                                        <ext:NumberColumn ID="D1DAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="D1DAY8_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T8" --%>
                                        <ext:NumberColumn ID="D1DAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="D1DAY9_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T9" --%>
                                        <ext:NumberColumn ID="D1DAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="D1DAY10_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T10" --%>
                                        <ext:NumberColumn ID="D1DAY11_QTY" ItemID="DDAY11_QTY" runat="server" DataIndex="D1DAY11_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T11" --%>
                                        <ext:NumberColumn ID="D1DAY12_QTY" ItemID="DDAY12_QTY" runat="server" DataIndex="D1DAY12_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T12" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D2DAY" ItemID="D2DAY" runat="server" ><%--Text="D+2 DAY"--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D2DAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="D2DAY1_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T1" --%>
                                        <ext:NumberColumn ID="D2DAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="D2DAY2_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T2" --%>
                                        <ext:NumberColumn ID="D2DAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="D2DAY3_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T3" --%>
                                        <ext:NumberColumn ID="D2DAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="D2DAY4_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T4" --%>
                                        <ext:NumberColumn ID="D2DAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="D2DAY5_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T5" --%>
                                        <ext:NumberColumn ID="D2DAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="D2DAY6_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T6" --%>
                                        <ext:NumberColumn ID="D2DAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="D2DAY7_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T7" --%>
                                        <ext:NumberColumn ID="D2DAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="D2DAY8_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T8" --%>
                                        <ext:NumberColumn ID="D2DAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="D2DAY9_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T9" --%>
                                        <ext:NumberColumn ID="D2DAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="D2DAY10_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T10" --%>
                                        <ext:NumberColumn ID="D2DAY11_QTY" ItemID="DDAY11_QTY" runat="server" DataIndex="D2DAY11_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T11" --%>
                                        <ext:NumberColumn ID="D2DAY12_QTY" ItemID="DDAY12_QTY" runat="server" DataIndex="D2DAY12_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T12" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D3DAY" ItemID="D3DAY" runat="server" ><%--Text="D+3 DAY"--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D3DAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="D3DAY1_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T1" --%>
                                        <ext:NumberColumn ID="D3DAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="D3DAY2_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T2" --%>
                                        <ext:NumberColumn ID="D3DAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="D3DAY3_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T3" --%>
                                        <ext:NumberColumn ID="D3DAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="D3DAY4_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T4" --%>
                                        <ext:NumberColumn ID="D3DAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="D3DAY5_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T5" --%>
                                        <ext:NumberColumn ID="D3DAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="D3DAY6_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T6" --%>
                                        <ext:NumberColumn ID="D3DAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="D3DAY7_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T7" --%>
                                        <ext:NumberColumn ID="D3DAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="D3DAY8_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T8" --%>
                                        <ext:NumberColumn ID="D3DAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="D3DAY9_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T9" --%>
                                        <ext:NumberColumn ID="D3DAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="D3DAY10_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T10" --%>
                                        <ext:NumberColumn ID="D3DAY11_QTY" ItemID="DDAY11_QTY" runat="server" DataIndex="D3DAY11_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T11" --%>
                                        <ext:NumberColumn ID="D3DAY12_QTY" ItemID="DDAY12_QTY" runat="server" DataIndex="D3DAY12_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T12" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D4DAY" ItemID="D4DAY" runat="server" Text="D+4 DAY">
                                    <Columns>
                                        <ext:NumberColumn ID="D4DAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="D4DAY1_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T1" --%>
                                        <ext:NumberColumn ID="D4DAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="D4DAY2_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T2" --%>
                                        <ext:NumberColumn ID="D4DAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="D4DAY3_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T3" --%>
                                        <ext:NumberColumn ID="D4DAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="D4DAY4_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T4" --%>
                                        <ext:NumberColumn ID="D4DAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="D4DAY5_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T5" --%>
                                        <ext:NumberColumn ID="D4DAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="D4DAY6_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T6" --%>
                                        <ext:NumberColumn ID="D4DAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="D4DAY7_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T7" --%>
                                        <ext:NumberColumn ID="D4DAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="D4DAY8_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T8" --%>
                                        <ext:NumberColumn ID="D4DAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="D4DAY9_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T9" --%>
                                        <ext:NumberColumn ID="D4DAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="D4DAY10_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T10" --%>
                                        <ext:NumberColumn ID="D4DAY11_QTY" ItemID="DDAY11_QTY" runat="server" DataIndex="D4DAY11_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T11" --%>
                                        <ext:NumberColumn ID="D4DAY12_QTY" ItemID="DDAY12_QTY" runat="server" DataIndex="D4DAY12_QTY" Width="70" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T12" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:NumberColumn ID="D5DAY_QTY" ItemID="D5DAY" runat="server" DataIndex="D5DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+5" --%>
                                <ext:NumberColumn ID="D6DAY_QTY" ItemID="D6DAY" runat="server" DataIndex="D6DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+6" --%>
                                <ext:NumberColumn ID="D7DAY_QTY" ItemID="D7DAY" runat="server" DataIndex="D7DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+7" --%>
                                <ext:NumberColumn ID="D8DAY_QTY" ItemID="D8DAY" runat="server" DataIndex="D8DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+8" --%>
                                <ext:NumberColumn ID="D9DAY_QTY" ItemID="D9DAY" runat="server" DataIndex="D9DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+9" --%>
                                <ext:NumberColumn ID="D10DAY_QTY" ItemID="D10DAY" runat="server" DataIndex="D10DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+10" --%>
                                <ext:NumberColumn ID="D11DAY_QTY" ItemID="D11DAY" runat="server" DataIndex="D11DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+11" --%>
                                <ext:NumberColumn ID="D12DAY_QTY" ItemID="D12DAY" runat="server" DataIndex="D12DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+12" --%>

                                <ext:NumberColumn ID="D13DAY_QTY" ItemID="D13DAY" runat="server" DataIndex="D13DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+13" --%>
                                <ext:NumberColumn ID="D14DAY_QTY" ItemID="D14DAY" runat="server" DataIndex="D14DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+14" --%>
                                <ext:NumberColumn ID="D15DAY_QTY" ItemID="D15DAY" runat="server" DataIndex="D15DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+15" --%>
                                <ext:NumberColumn ID="D16DAY_QTY" ItemID="D16DAY" runat="server" DataIndex="D16DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+16" --%>
                                <ext:NumberColumn ID="D17DAY_QTY" ItemID="D17DAY" runat="server" DataIndex="D17DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+17" --%>
                                <ext:NumberColumn ID="D18DAY_QTY" ItemID="D18DAY" runat="server" DataIndex="D18DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+18" --%>
                                <ext:NumberColumn ID="D19DAY_QTY" ItemID="D19DAY" runat="server" DataIndex="D19DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+19" --%>
                                <ext:NumberColumn ID="D20DAY_QTY" ItemID="D20DAY" runat="server" DataIndex="D20DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+20" --%>
                                <ext:NumberColumn ID="D21DAY_QTY" ItemID="D21DAY" runat="server" DataIndex="D21DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+21" --%>
                                <ext:NumberColumn ID="D22DAY_QTY" ItemID="D22DAY" runat="server" DataIndex="D22DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+22" --%>
                                <ext:NumberColumn ID="D23DAY_QTY" ItemID="D23DAY" runat="server" DataIndex="D23DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+23" --%>
                                <ext:NumberColumn ID="D24DAY_QTY" ItemID="D24DAY" runat="server" DataIndex="D24DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+24" --%>
                                <ext:NumberColumn ID="D25DAY_QTY" ItemID="D25DAY" runat="server" DataIndex="D25DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+25" --%>
                                <ext:NumberColumn ID="D26DAY_QTY" ItemID="D26DAY" runat="server" DataIndex="D26DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+26" --%>
                                <ext:NumberColumn ID="D27DAY_QTY" ItemID="D27DAY" runat="server" DataIndex="D27DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+27" --%>
                                <ext:NumberColumn ID="D28DAY_QTY" ItemID="D28DAY" runat="server" DataIndex="D28DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+28" --%>
                                <ext:NumberColumn ID="D29DAY_QTY" ItemID="D29DAY" runat="server" DataIndex="D29DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+29" --%>
                                <ext:NumberColumn ID="D30DAY_QTY" ItemID="D30DAY" runat="server" DataIndex="D30DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+30" --%>
                                <ext:NumberColumn ID="D31DAY_QTY" ItemID="D31DAY" runat="server" DataIndex="D31DAY_QTY" Width="70" Align="Right" Format="#,##0.###"/><%--Text="D+31" --%>
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
