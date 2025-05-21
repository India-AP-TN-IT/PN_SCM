<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM30011.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM30011" %>
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
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>    
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
            fn_SetYmdDateChange(true);
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

        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            //var grid = selectionModel.view.ownerCt;
            //grid.editingPlugin.startEdit(rowIndex, colIndex);
        }

        var fn_SetYmdDateChange = function () {
            App.direct.SetYmdDateChange(true);
        };

    </script>
</head>
<body>
    <form id="SRM_MM30011" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM30011" runat="server" Cls="search_area_title_name" /><%--Text="사급 직납 마감 등록" />--%>
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
                            <col style="width: 200px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                               <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>                                 
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"  />
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" Text="Business Code" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_BIZCD" ItemID="SAUP" runat="server" Cls="inputText"  Mode="Local" ForceSelection="true"
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
                                <ext:Label ID="lbl01_PLAN_DATE" runat="server" /><%--Text="기준년월" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true" >                                
                                    <Listeners>
                                        <Change Fn="fn_SetYmdDateChange"></Change>
                                    </Listeners>
                                </ext:DateField>
                            </td>    
                        </tr>
                        <tr>                            
                             <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" />                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="80"/>
                            </td> 
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />    
                            </td>
                            <th>
                                <ext:Label ID="lbl01_QUERY_COND" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SEARCH_TYPE" runat="server" Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
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
                                </ext:SelectBox>
                            </td>
                        </tr>                        
                    </table>
                </Content>
            </ext:Panel>
            
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>                                        
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." SortableColumns="false">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="PACK_QTY" />
                                            <ext:ModelField Name="SAFE_INV_QTY" />
                                            <ext:ModelField Name="BASE_INV_QTY" />
                                            <ext:ModelField Name="USE_INV_QTY" />
                                            <ext:ModelField Name="PENDING_PO_QTY" />
                                            <ext:ModelField Name="SUM_PR_QTY" />
                                            <ext:ModelField Name="SUM_PO_QTY" />
                                            <ext:ModelField Name="D0_PR_QTY" />
                                            <ext:ModelField Name="D0_PO_QTY" />
                                            <ext:ModelField Name="D1_PR_QTY" />
                                            <ext:ModelField Name="D1_PO_QTY" />
                                            <ext:ModelField Name="D2_PR_QTY" />
                                            <ext:ModelField Name="D2_PO_QTY" />
                                            <ext:ModelField Name="D3_PR_QTY" />
                                            <ext:ModelField Name="D3_PO_QTY" />
                                            <ext:ModelField Name="D4_PR_QTY" />
                                            <ext:ModelField Name="D4_PO_QTY" />
                                            <ext:ModelField Name="D5_PR_QTY" />
                                            <ext:ModelField Name="D5_PO_QTY" />
                                            <ext:ModelField Name="D6_PR_QTY" />
                                            <ext:ModelField Name="D6_PO_QTY" />
                                            <ext:ModelField Name="D7_PR_QTY" />
                                            <ext:ModelField Name="D7_PO_QTY" />
                                            <ext:ModelField Name="D8_PR_QTY" />
                                            <ext:ModelField Name="D8_PO_QTY" />
                                            <ext:ModelField Name="D9_PR_QTY" />
                                            <ext:ModelField Name="D9_PO_QTY" />
                                            <ext:ModelField Name="D10_PR_QTY" />
                                            <ext:ModelField Name="D10_PO_QTY" />
                                            <ext:ModelField Name="D11_PR_QTY" />
                                            <ext:ModelField Name="D11_PO_QTY" />
                                            <ext:ModelField Name="D12_PR_QTY" />
                                            <ext:ModelField Name="D12_PO_QTY" />
                                            <ext:ModelField Name="D13_PR_QTY" />
                                            <ext:ModelField Name="D13_PO_QTY" />

                                            <ext:ModelField Name="D14_PR_QTY" />
                                            <ext:ModelField Name="D14_PO_QTY" />
                                            <ext:ModelField Name="D15_PR_QTY" />
                                            <ext:ModelField Name="D15_PO_QTY" />
                                            <ext:ModelField Name="D16_PR_QTY" />
                                            <ext:ModelField Name="D16_PO_QTY" />
                                            <ext:ModelField Name="D17_PR_QTY" />
                                            <ext:ModelField Name="D17_PO_QTY" />
                                            <ext:ModelField Name="D18_PR_QTY" />
                                            <ext:ModelField Name="D18_PO_QTY" />
                                            <ext:ModelField Name="D19_PR_QTY" />
                                            <ext:ModelField Name="D19_PO_QTY" />
                                            <ext:ModelField Name="D20_PR_QTY" />
                                            <ext:ModelField Name="D20_PO_QTY" />
                                            <ext:ModelField Name="D21_PR_QTY" />
                                            <ext:ModelField Name="D21_PO_QTY" />
                                            <ext:ModelField Name="D22_PR_QTY" />
                                            <ext:ModelField Name="D22_PO_QTY" />
                                            <ext:ModelField Name="D23_PR_QTY" />
                                            <ext:ModelField Name="D23_PO_QTY" />
                                            <ext:ModelField Name="D24_PR_QTY" />
                                            <ext:ModelField Name="D24_PO_QTY" />
                                            <ext:ModelField Name="D25_PR_QTY" />
                                            <ext:ModelField Name="D25_PO_QTY" />
                                            <ext:ModelField Name="D26_PR_QTY" />
                                            <ext:ModelField Name="D26_PO_QTY" />
                                            <ext:ModelField Name="D27_PR_QTY" />
                                            <ext:ModelField Name="D27_PO_QTY" />
                                            <ext:ModelField Name="D28_PR_QTY" />
                                            <ext:ModelField Name="D28_PO_QTY" />
                                            <ext:ModelField Name="D29_PR_QTY" />
                                            <ext:ModelField Name="D29_PO_QTY" />
                                            <ext:ModelField Name="D30_PR_QTY" />
                                            <ext:ModelField Name="D30_PO_QTY" />
                                            <ext:ModelField Name="D31_PR_QTY" />
                                            <ext:ModelField Name="D31_PO_QTY" />
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
                                <ext:Column ID="VENDCD" ItemID="VENDCD6" runat="server" DataIndex="VENDCD" Width="80" Align="Center"  /><%--Text="업체코드"--%>
                                <ext:Column ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="100" Align="Left"  /><%--Text="업체명"--%>
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="40" Align="Center"  Visible="false" /><%--Text="차종"--%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left"  /><%--Text="PART NO"--%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1" /><%--Text="PART NAME"--%>
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="40" Align="Center" /><%--Text="UNIT"--%>
                                <%--<ext:Column ID="PACK_QTY" ItemID="PACK_QTY" runat="server" DataIndex="PACK_QTY" Width="80" Align="Right" />--%><%--Text="포장수량"--%>
                                <ext:NumberColumn ID="PACK_QTY" ItemID="PACK_QTY" runat="server" DataIndex="PACK_QTY" Width="80" Align="Right" Format="#,##0.###" />
                                <%--<ext:Column ID="SAFE_INV_QTY" ItemID="SAFE_INV_QTY" runat="server" DataIndex="SAFE_INV_QTY" Width="80" Align="Right" />--%><%--Text="안전재고량"--%>
                                <ext:NumberColumn ID="SAFE_INV_QTY" ItemID="SAFE_INV_QTY" runat="server" DataIndex="SAFE_INV_QTY" Width="80" Align="Right" Format="#,##0.###" />
                                <ext:Column ID="BASE_INV_QTY" ItemID="BASE_INV_QTY" runat="server" Hidden="true" ><%--Text="기초재고">--%>
                                    <Columns>
                                    <%--<ext:Column ID="BASE_INV_QTY_INFO" ItemID="BASE_INV_QTY_INFO" runat="server" DataIndex="BASE_INV_QTY" Width="80" Align="Right" Draggable="false" />--%><%--Text="기초재고 참고용"--%>
                                    <ext:NumberColumn ID="BASE_INV_QTY_INFO" ItemID="BASE_INV_QTY_INFO" runat="server"  Hidden="true" DataIndex="BASE_INV_QTY" Width="80" Align="Right" Format="#,##0.###" />
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="USE_INV_QTY" ItemID="USE_INV_QTY" runat="server" Visible="false" Hidden="true" ><%--Text="현재고">--%>
                                    <Columns>
                                    <%--<ext:Column ID="USE_INV_QTY_INFO" ItemID="USE_INV_QTY_INFO" runat="server" DataIndex="USE_INV_QTY" Width="80" Align="Right" Draggable="false" />--%><%--Text="현재고 매시정각"--%>
                                    <ext:NumberColumn ID="USE_INV_QTY_INFO" ItemID="USE_INV_QTY_INFO" runat="server" DataIndex="USE_INV_QTY" Width="80" Align="Right" Format="#,##0.###" />
                                    </Columns>
                                </ext:Column>
                                <%--<ext:Column ID="PENDING_PO_QTY" ItemID="PENDING_PO_QTY" runat="server" DataIndex="PENDING_PO_QTY" Width="80" Align="Right" />--%><%--Text="미납량"--%>
                                <ext:NumberColumn ID="PENDING_PO_QTY" ItemID="PENDING_PO_QTY" runat="server" DataIndex="PENDING_PO_QTY" Width="80" Align="Right" Format="#,##0.###" />
                                <ext:Column ID="SUM_QTY" ItemID="TOT2" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="SUM_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="SUM_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="SUM_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="SUM_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="SUM_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="SUM_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D0_QTY" ItemID="D0_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D0_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D0_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D0_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D0_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D0_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D0_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D1_QTY" ItemID="D1_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D1_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D1_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D1_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D1_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D1_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D1_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D2_QTY" ItemID="D2_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D2_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D2_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D2_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D2_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D2_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D2_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D3_QTY" ItemID="D3_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D3_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D3_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D3_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D3_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D3_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D3_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D4_QTY" ItemID="D4_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D4_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D4_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D4_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D4_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D4_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D4_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D5_QTY" ItemID="D5_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D5_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D5_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D5_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D5_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D5_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D5_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D6_QTY" ItemID="D6_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D6_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D6_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D6_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D6_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D6_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D6_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D7_QTY" ItemID="D7_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D7_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D7_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D7_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D7_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D7_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D7_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D8_QTY" ItemID="D8_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D8_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D8_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D8_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D8_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D8_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D8_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D9_QTY" ItemID="D9_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D9_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D9_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D9_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D9_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D9_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D9_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D10_QTY" ItemID="D10_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D10_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D10_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D10_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D10_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D10_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D10_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D11_QTY" ItemID="D11_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D11_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D11_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D11_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D11_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D11_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D11_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D12_QTY" ItemID="D12_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D12_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D12_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D12_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D12_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D12_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D12_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D13_QTY" ItemID="D13_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D13_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D13_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D13_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D13_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D13_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D13_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>

                                <ext:Column ID="D14_QTY" ItemID="D14_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D14_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D14_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D14_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D14_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D14_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D14_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D15_QTY" ItemID="D15_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D15_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D15_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D15_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D15_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D15_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D15_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D16_QTY" ItemID="D16_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D16_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D16_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D16_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D16_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D16_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D16_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D17_QTY" ItemID="D17_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D17_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D17_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D17_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D17_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D17_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D17_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D18_QTY" ItemID="D18_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D18_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D18_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D18_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D18_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D18_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D18_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D19_QTY" ItemID="D19_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D19_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D19_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D19_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D19_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D19_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D19_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D20_QTY" ItemID="D20_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D20_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D20_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D20_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D20_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D20_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D20_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D21_QTY" ItemID="D21_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D21_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D21_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D21_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D21_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D21_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D21_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D22_QTY" ItemID="D22_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D22_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D22_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D22_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D22_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D22_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D22_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D23_QTY" ItemID="D23_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D23_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D23_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D23_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D23_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D23_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D23_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D24_QTY" ItemID="D24_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D24_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D24_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D24_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D24_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D24_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D24_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D25_QTY" ItemID="D25_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D25_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D25_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D25_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D25_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D25_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D25_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D26_QTY" ItemID="D26_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D26_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D26_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D26_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D26_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D26_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D26_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D27_QTY" ItemID="D27_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D27_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D27_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D27_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D27_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D27_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D27_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D28_QTY" ItemID="D28_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D28_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D28_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D28_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D28_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D28_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D28_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D29_QTY" ItemID="D29_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D29_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D29_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D29_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D29_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D29_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D29_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D30_QTY" ItemID="D30_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D30_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D30_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D30_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D30_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D30_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D30_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D31_QTY" ItemID="D31_QTY" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="D31_PR_QTY" ItemID="PR_QTY" runat="server" DataIndex="D31_PR_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D31_PR_QTY"/><%--Text="예정량">--%>
                                        <ext:NumberColumn ID="D31_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="D31_PO_QTY" Width="65" Align="Right" Format="#,##0.###" Text="D31_PO_QTY"/><%--Text="발주량">--%>
                                    </Columns>
                                </ext:Column>
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">                                
<%--                                <GetRowClass Fn="getRowClass" />--%>
                            </ext:GridView>
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
