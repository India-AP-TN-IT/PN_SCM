<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_SD30010.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_SD.SRM_SD30010" %>
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

        var fn_BizcdChange = function () {
            var bizcd = "";
            if (App.SelectBox01_BIZCD.getValue() != null) {
                bizcd = App.SelectBox01_BIZCD.getValue().toString();
            }
            App.direct.SetComboBindVincd(bizcd);
        };

        var fn_VincdChange = function () {
            
            /*
            var bizcd = "";
            var vincd = "";
            if (App.SelectBox01_BIZCD.getValue() != null) {
                bizcd = App.SelectBox01_BIZCD.getValue().toString();
            }
            if (App.sbox01_VINCD.getValue() != null) {
                vincd = App.sbox01_VINCD.getValue().toString();
            }
            App.direct.SetComboBindCustItem(bizcd, vincd);
            */
        };
      
    </script>
</head>
<body>
    <form id="SRM_SD30010" runat="server">
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
                    <ext:Label ID="lbl01_SRM_SD30010" runat="server" Cls="search_area_title_name" /><%--Text="서열 부품 상세" />--%>
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
                            <col style="width: 180px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 180px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 180px;"/>
                            <col style="width: 100px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_BIZCD" runat="server" /><%--Text="Business Code" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox01_BIZCD" runat="server" Mode="Local" ForceSelection="true"
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
                                    <Listeners>
                                        <Change Fn="fn_BizcdChange"></Change>
                                    </Listeners>
                                </ext:SelectBox>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_WORK_DATE3" runat="server" /><%--Text="일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_BEG_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   >
                                    <%--<DirectEvents>
                                        <Change OnEvent="changeCondition" />
                                    </DirectEvents>--%>
                                </ext:DateField>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_HANIL_VIN" runat="server" />                 
                            </th>
                            <td>
                                <ext:TextField ID="txt01_VINCD" Width="120" Cls="inputText" runat="server" />                             
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_ALCCD" runat="server" Text="ALC" />                 
                            </th>
                            <td>
                                <ext:TextField ID="txt01_ALCCD" Width="120" Cls="inputText" runat="server" />                             
                            </td>
                            <th style="display:none;">
                                <ext:Label ID="lbl02_VINCD" runat="server" /><%--Text="차종" />--%>
                            </th>
                            <td style="display:none;">
                                <ext:SelectBox ID="sbox01_VINCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="VINNM" ValueField="MODELCD" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>                                                       
                                                        <ext:ModelField Name="MODELCD" />
                                                        <ext:ModelField Name="VINNM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <Listeners>
                                        <Change Fn="fn_VincdChange"></Change>
                                    </Listeners>
                                </ext:SelectBox>
                            </td>
                        </tr> 
                        <%-- SRM 사용안함
                        <tr>
                            <th>                                
                                <ext:Label ID="lbl01_CUST_ITEM" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="sbox01_CUST_ITEM" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="CUST_ITEMNM" ValueField="CUST_ITEMCD" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model runat="server">
                                                    <Fields>                                                       
                                                        <ext:ModelField Name="CUST_ITEMCD" />
                                                        <ext:ModelField Name="CUST_ITEMNM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>

                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>                           
                        </tr> --%>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50" Buffered="true">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="PLAN_DATE" />
                                            <ext:ModelField Name="PROC_DIV" />
                                            <ext:ModelField Name="VEND_VINCD" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="TYPECD" />
                                            <ext:ModelField Name="VEND_ITEM_TYPECD" />
                                            <ext:ModelField Name="VEND_ITEM_TYPENM" />
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="VEND_PLANTCD" />
                                            <ext:ModelField Name="WORK_DIR_DIV2" />
                                            <ext:ModelField Name="PREVDAY_RSLT_QTY" />
                                            <ext:ModelField Name="PBS_QTY" />
                                            <ext:ModelField Name="PAINT_REJECT_QTY" />
                                            <ext:ModelField Name="WBS_QTY" />
                                            <ext:ModelField Name="DDAY_QTY" />
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
                                            <ext:ModelField Name="P6_REMAIN_QTY" />
                                            <ext:ModelField Name="P6_FULL_TOT_QTY" />
                                            <ext:ModelField Name="TOTAL" />                                            
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
                                <ext:DateColumn ID="PLAN_DATE"              ItemID="PLAN_DATE"      runat="server" DataIndex="PLAN_DATE"  Width="80" Align="Center" Locked="true"/><%--Text="계획일자"   --%>
                                <ext:Column ID="PROC_DIV"               ItemID="PROC_DIV"       runat="server" DataIndex="PROC_DIV"   Width="60" Align="Center" Locked="true"/><%--Text="처리구분"   --%>
                                <ext:Column ID="VEND_VINCD"             ItemID="VEND_VIN"       runat="server" DataIndex="VEND_VINCD" Width="75" Align="Center" Locked="true"/><%--Text="고객사차종" --%>
                                <ext:Column ID="VINCD"                  ItemID="HANIL_VIN"      runat="server" DataIndex="VINCD"      Width="60" Align="Center" Locked="true"/><%--Text="당사차종"   --%>                                
                                <%--<ext:Column ID="TYPECD"              ItemID="TYPECD"      runat="server" Text="코드"    DataIndex="TYPECD"   Width="100" Align="Center" Locked="true"/>--%>
                                <ext:Column ID="VEND_ITEM"                ItemID="VEND_ITEM"    runat="server" Locked="true" ><%--Text="고객사품목" --%>
                                    <Columns>
                                        <ext:Column ID="VEND_ITEM_TYPECD" ItemID="CODE"         runat="server" DataIndex="VEND_ITEM_TYPECD" Width="40"  Align="Center" Locked="true" Sortable="true"/><%--Text="코드"--%>                
                                        <ext:Column ID="VEND_ITEM_TYPENM" ItemID="TYPENM"       runat="server" DataIndex="VEND_ITEM_TYPENM" Width="150" Align="Left"   Locked="true" Sortable="true"/><%--Text="유형명"--%>  
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="ALCCD"                  ItemID="ALCCD"          runat="server" DataIndex="ALCCD"            Width="50" Align="Center" Locked="true" /><%--Text="ALC코드"--%>  
                                <ext:Column ID="VEND_PLANTCD"           ItemID="PLANT"          runat="server" DataIndex="VEND_PLANTCD"     Width="40" Align="Center" Locked="true" /><%--Text="공장"--%>     
                                <ext:Column ID="WORK_DIR_DIV2"          ItemID="WORK_DIR_DIV2"  runat="server" DataIndex="WORK_DIR_DIV2"    Width="60" Align="Center" Locked="true" /><%--Text="작업지시" --%>
                                <ext:NumberColumn ID="PREVDAY_RSLT_QTY" ItemID="PREVDAY_RSLT"   runat="server" DataIndex="PREVDAY_RSLT_QTY" Width="80" Align="Right" Format="#,##0.###"/><%--Text="전일실적" --%>
                                <ext:NumberColumn ID="PBS_QTY"          ItemID="PBS"            runat="server" DataIndex="PBS_QTY"          Width="50" Align="Right" Format="#,##0.###"/><%--Text="PBS"      --%>
                                <ext:NumberColumn ID="PAINT_REJECT_QTY" ItemID="PAINT_REJECT"   runat="server" DataIndex="PAINT_REJECT_QTY" Width="50" Align="Right" Format="#,##0.###"/><%--Text="REJ" --%>     
                                <ext:NumberColumn ID="WBS_QTY"          ItemID="WBS"            runat="server" DataIndex="WBS_QTY"          Width="55" Align="Right" Format="#,##0.###"/><%--Text="WBS"  --%>    
                                <ext:Column ID="DDAY"                   ItemID="DDAY"           runat="server" ><%--Text="D DAY"--%>
                                    <Columns>
                                        <ext:NumberColumn ID="DDAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="DDAY1_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T1" --%>
                                        <ext:NumberColumn ID="DDAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="DDAY2_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T2" --%>
                                        <ext:NumberColumn ID="DDAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="DDAY3_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T3" --%>
                                        <ext:NumberColumn ID="DDAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="DDAY4_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T4" --%>
                                        <ext:NumberColumn ID="DDAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="DDAY5_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T5" --%>
                                        <ext:NumberColumn ID="DDAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="DDAY6_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T6" --%>
                                        <ext:NumberColumn ID="DDAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="DDAY7_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T7" --%>
                                        <ext:NumberColumn ID="DDAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="DDAY8_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T8" --%>
                                        <ext:NumberColumn ID="DDAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="DDAY9_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T9" --%>
                                        <ext:NumberColumn ID="DDAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="DDAY10_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T10" --%>
                                        <ext:NumberColumn ID="DDAY11_QTY" ItemID="DDAY11_QTY" runat="server" DataIndex="DDAY11_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T11" --%>
                                        <ext:NumberColumn ID="DDAY12_QTY" ItemID="DDAY12_QTY" runat="server" DataIndex="DDAY12_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T12" --%>

                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D1DAY" ItemID="D1DAY" runat="server" ><%--Text="D+1 DAY">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D1DAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="D1DAY1_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T1" --%>
                                        <ext:NumberColumn ID="D1DAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="D1DAY2_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T2" --%>
                                        <ext:NumberColumn ID="D1DAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="D1DAY3_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T3" --%>
                                        <ext:NumberColumn ID="D1DAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="D1DAY4_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T4" --%>
                                        <ext:NumberColumn ID="D1DAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="D1DAY5_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T5" --%>
                                        <ext:NumberColumn ID="D1DAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="D1DAY6_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T6" --%>
                                        <ext:NumberColumn ID="D1DAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="D1DAY7_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T7" --%>
                                        <ext:NumberColumn ID="D1DAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="D1DAY8_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T8" --%>
                                        <ext:NumberColumn ID="D1DAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="D1DAY9_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T9" --%>
                                        <ext:NumberColumn ID="D1DAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="D1DAY10_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T10" --%>
                                        <ext:NumberColumn ID="D1DAY11_QTY" ItemID="DDAY11_QTY" runat="server" DataIndex="D1DAY11_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T11" --%>
                                        <ext:NumberColumn ID="D1DAY12_QTY" ItemID="DDAY12_QTY" runat="server" DataIndex="D1DAY12_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T12" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D2DAY" ItemID="D2DAY" runat="server" ><%--Text="D+2 DAY">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D2DAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="D2DAY1_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T1" --%>
                                        <ext:NumberColumn ID="D2DAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="D2DAY2_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T2" --%>
                                        <ext:NumberColumn ID="D2DAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="D2DAY3_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T3" --%>
                                        <ext:NumberColumn ID="D2DAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="D2DAY4_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T4" --%>
                                        <ext:NumberColumn ID="D2DAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="D2DAY5_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T5" --%>
                                        <ext:NumberColumn ID="D2DAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="D2DAY6_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T6" --%>
                                        <ext:NumberColumn ID="D2DAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="D2DAY7_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T7" --%>
                                        <ext:NumberColumn ID="D2DAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="D2DAY8_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T8" --%>
                                        <ext:NumberColumn ID="D2DAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="D2DAY9_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T9" --%>
                                        <ext:NumberColumn ID="D2DAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="D2DAY10_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T10" --%>
                                        <ext:NumberColumn ID="D2DAY11_QTY" ItemID="DDAY11_QTY" runat="server" DataIndex="D2DAY11_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T11" --%>
                                        <ext:NumberColumn ID="D2DAY12_QTY" ItemID="DDAY12_QTY" runat="server" DataIndex="D2DAY12_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T12" --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D3DAY" ItemID="D3DAY" runat="server" ><%--Text="D+3 DAY">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D3DAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="D3DAY1_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T1" --%>
                                        <ext:NumberColumn ID="D3DAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="D3DAY2_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T2" --%>
                                        <ext:NumberColumn ID="D3DAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="D3DAY3_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T3" --%>
                                        <ext:NumberColumn ID="D3DAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="D3DAY4_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T4" --%>
                                        <ext:NumberColumn ID="D3DAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="D3DAY5_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T5" --%>
                                        <ext:NumberColumn ID="D3DAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="D3DAY6_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T6" --%>
                                        <ext:NumberColumn ID="D3DAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="D3DAY7_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T7" --%>
                                        <ext:NumberColumn ID="D3DAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="D3DAY8_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T8" --%>
                                        <ext:NumberColumn ID="D3DAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="D3DAY9_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T9" --%>
                                        <ext:NumberColumn ID="D3DAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="D3DAY10_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T10" --%>
                                        <ext:NumberColumn ID="D3DAY11_QTY" ItemID="DDAY11_QTY" runat="server" DataIndex="D3DAY11_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T11" --%>
                                        <ext:NumberColumn ID="D3DAY12_QTY" ItemID="DDAY12_QTY" runat="server" DataIndex="D3DAY12_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T12" --%>

                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D4DAY" ItemID="D4DAY" runat="server" ><%--Text="D+4 DAY">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D4DAY1_QTY" ItemID="DDAY1_QTY" runat="server" DataIndex="D4DAY1_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T1" --%>
                                        <ext:NumberColumn ID="D4DAY2_QTY" ItemID="DDAY2_QTY" runat="server" DataIndex="D4DAY2_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T2" --%>
                                        <ext:NumberColumn ID="D4DAY3_QTY" ItemID="DDAY3_QTY" runat="server" DataIndex="D4DAY3_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T3" --%>
                                        <ext:NumberColumn ID="D4DAY4_QTY" ItemID="DDAY4_QTY" runat="server" DataIndex="D4DAY4_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T4" --%>
                                        <ext:NumberColumn ID="D4DAY5_QTY" ItemID="DDAY5_QTY" runat="server" DataIndex="D4DAY5_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T5" --%>
                                        <ext:NumberColumn ID="D4DAY6_QTY" ItemID="DDAY6_QTY" runat="server" DataIndex="D4DAY6_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T6" --%>
                                        <ext:NumberColumn ID="D4DAY7_QTY" ItemID="DDAY7_QTY" runat="server" DataIndex="D4DAY7_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T7" --%>
                                        <ext:NumberColumn ID="D4DAY8_QTY" ItemID="DDAY8_QTY" runat="server" DataIndex="D4DAY8_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T8" --%>
                                        <ext:NumberColumn ID="D4DAY9_QTY" ItemID="DDAY9_QTY" runat="server" DataIndex="D4DAY9_QTY" Width="45" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T9" --%>
                                        <ext:NumberColumn ID="D4DAY10_QTY" ItemID="DDAY10_QTY" runat="server" DataIndex="D4DAY10_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T10" --%>
                                        <ext:NumberColumn ID="D4DAY11_QTY" ItemID="DDAY11_QTY" runat="server" DataIndex="D4DAY11_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T11" --%>
                                        <ext:NumberColumn ID="D4DAY12_QTY" ItemID="DDAY12_QTY" runat="server" DataIndex="D4DAY12_QTY" Width="50" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="T12" --%>

                                    </Columns>
                                </ext:Column>
                               <%-- <ext:NumberColumn ID="D5DAY_QTY" ItemID="D5DAY" runat="server" Text="D+5" DataIndex="D5DAY_QTY" Width="45" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D6DAY_QTY" ItemID="D6DAY" runat="server" Text="D+6" DataIndex="D6DAY_QTY" Width="45" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D7DAY_QTY" ItemID="D7DAY" runat="server" Text="D+7" DataIndex="D7DAY_QTY" Width="45" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D8DAY_QTY" ItemID="D8DAY" runat="server" Text="D+8" DataIndex="D8DAY_QTY" Width="45" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D9DAY_QTY" ItemID="D9DAY" runat="server" Text="D+9" DataIndex="D9DAY_QTY" Width="45" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D10DAY_QTY" ItemID="D10DAY" runat="server" Text="D+10" DataIndex="D10DAY_QTY" Width="45" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D11DAY_QTY" ItemID="D11DAY" runat="server" Text="D+11" DataIndex="D11DAY_QTY" Width="45" Align="Right" Format="#,##0.###"/>
                                <ext:NumberColumn ID="D12DAY_QTY" ItemID="D12DAY" runat="server" Text="D+12" DataIndex="D12DAY_QTY" Width="45" Align="Right" Format="#,##0.###"/>--%>
                                <ext:NumberColumn ID="REM"              runat="server" ItemID="P6_REM"      DataIndex="P6_REMAIN_QTY"   Width="80" Align="Right" Format="#,##0.###"/><%--Text="REM"      --%>
                                <ext:NumberColumn ID="P6_FULL_TOT_QTY"  runat="server" ItemID="P6_GTOTAL"   DataIndex="P6_FULL_TOT_QTY" Width="80" Align="Right" Format="#,##0.###"/><%--Text="G-TOTAL"  --%>
                                <ext:NumberColumn ID="TOTAL"            runat="server" ItemID="TOTAL"       DataIndex="TOTAL"           Width="80" Align="Right" Format="#,##0.###"/><%--Text="합계"     --%>
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
