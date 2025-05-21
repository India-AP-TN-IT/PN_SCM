<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM30001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM30001" %>
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
            fn_SetYmdDateChange(true);
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

        var fn_SetYmdDateChange = function () {
            App.direct.df01_REQ_DATE_Change(true);
        };

    </script>
</head>
<body>
    <form id="SRM_MM30001" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM30001" runat="server" Cls="search_area_title_name" /><%--Text="MIP 자재소요계획 현황" />--%>
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
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="80"/>
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
                                <ext:Label ID="lbl01_INQUERY_STD_DATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_REQ_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true">
                                    <Listeners>
                                        <Change Fn="fn_SetYmdDateChange"></Change>
                                    </Listeners>
                                </ext:DateField>
                            </td>
                            <th >
                                <ext:Label ID="lbl01_SEARCH_OPT" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SEARCH_OPT" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
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
                                <%--
                                <ext:ComboBox ID="cbo01_SEARCH_OPT" runat="server"  Mode="Local" 
                                TriggerAction="All" Width="150" Editable="false">
                                    <Items>
                                        <ext:ListItem Value="S" Text="집계 (Summary)" />
                                        <ext:ListItem Value="D" Text="상세 (Detail)" />
                                        <ext:ListItem Value="C" Text="취소 (Cancel)" />
                                    </Items>
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_SEARCH_OPT_Change" />
                                    </DirectEvents>   
                                </ext:ComboBox>
                                --%>
                            </td> 
                        </tr> 
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_LINECD_PER" runat="server" /><%--Text="라인코드" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_LINECD" Width="180" Cls="inputText" runat="server" FieldStyle="text-transform:uppercase;" />
                            </td>
                            <td style="display:none;">
                                <epc:EPCodeBox ID="cdx01_LINECD" runat="server" HelperID="HELP_LINE" PopupMode="Search" PopupType="HelpWindow"
                                    OnBeforeDirectButtonClick="cdx01_LINECD_BeforeDirectButtonClick" WidthTYPECD="80"/>    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_VIN_PER" runat="server" />                     
                            </th>
                            <td>
                                <ext:TextField ID="txt01_VINCD" Width="180" Cls="inputText" runat="server" FieldStyle="text-transform:uppercase;" />
                            </td>
                            <td style="display:none;">
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_SUBCON_PNO_PER" runat="server" />                       
                            </th>
                            <td colspan="3">
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" FieldStyle="text-transform:uppercase;" />
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <%-- 집계 그리드 --%>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
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
                                            <ext:ModelField Name="MTOT" />
                                            <ext:ModelField Name="MD0" />
                                            <ext:ModelField Name="MD1" />
                                            <ext:ModelField Name="MD2" />
                                            <ext:ModelField Name="MD3" />
                                            <ext:ModelField Name="MD4" />
                                            <ext:ModelField Name="MD5" />
                                            <ext:ModelField Name="MD6" />
                                            <ext:ModelField Name="MD7" />
                                            <ext:ModelField Name="MD8" />
                                            <ext:ModelField Name="MD9" />
                                            <ext:ModelField Name="MD10" />
                                            <ext:ModelField Name="MD11" />
                                            <ext:ModelField Name="MD12" />
                                            <ext:ModelField Name="MD13" />
                                            <ext:ModelField Name="MD14" />
                                            <ext:ModelField Name="MD15" />
                                            <ext:ModelField Name="MD16" />
                                            <ext:ModelField Name="MD17" />
                                            <ext:ModelField Name="MD18" />
                                            <ext:ModelField Name="MD19" />
                                            <ext:ModelField Name="MD20" />
                                            <ext:ModelField Name="MD21" />
                                            <ext:ModelField Name="MD22" />
                                            <ext:ModelField Name="MD23" />
                                            <ext:ModelField Name="MD24" />
                                            <ext:ModelField Name="MD25" />
                                            <ext:ModelField Name="MD26" />
                                            <ext:ModelField Name="MD27" />
                                            <ext:ModelField Name="MD28" />
                                            <ext:ModelField Name="MD29" />
                                            <ext:ModelField Name="MD30" />
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
                                <ext:Column ID="VENDCD_1" ItemID="VENDCD6" runat="server" DataIndex="VENDCD" Width="70"  Align="Center" /><%--Text="업체코드"--%>
                                <ext:Column ID="VENDNM_1" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="120" Align="Left" /><%--Text="업체명"--%>
                                <ext:Column ID="VINCD_1" ItemID="VIN" runat="server" DataIndex="VINCD" Width="40" Align="Center" /><%--Text="차종"--%>
                                <ext:Column ID="PARTNO_1" ItemID="SUBCON_PNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="외작 PART NO"--%>
                                <ext:Column ID="PARTNM_1" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME"--%>
                                <ext:Column ID="UNIT_1" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="40" Align="Center" /><%--Text="UNIT"--%>
                                <ext:Column ID="TOT_1" ItemID="TOT2" runat="server" ><%--Text="계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MTOT" ItemID="REQQTY" runat="server" DataIndex="MTOT" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D0_1" ItemID="D0" runat="server" ><%--Text="D-DAY">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD0_1" ItemID="REQQTY" runat="server" DataIndex="MD0" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D1_1" ItemID="D1" runat="server" ><%--Text="D+1">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD1_1" ItemID="REQQTY" runat="server" DataIndex="MD1" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D2_1" ItemID="D2" runat="server" ><%--Text="D+2">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD2_1" ItemID="REQQTY" runat="server" DataIndex="MD2" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D3_1" ItemID="D3" runat="server" ><%--Text="D+3">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD3_1" ItemID="REQQTY" runat="server" DataIndex="MD3" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D4_1" ItemID="D4" runat="server" ><%--Text="D+4">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD4_1" ItemID="REQQTY" runat="server" DataIndex="MD4" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D5_1" ItemID="D5" runat="server" ><%--Text="D+5">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD5_1" ItemID="REQQTY" runat="server" DataIndex="MD5" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D6_1" ItemID="64" runat="server" ><%--Text="D+6">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD6_1" ItemID="REQQTY" runat="server" DataIndex="MD6" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D7_1" ItemID="D7" runat="server" ><%--Text="D+7">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD7_1" ItemID="REQQTY" runat="server" DataIndex="MD7" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D8_1" ItemID="D8" runat="server" ><%--Text="D+8">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD8_1" ItemID="REQQTY" runat="server" DataIndex="MD8" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D9_1" ItemID="D9" runat="server" ><%--Text="D+9">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD9_1" ItemID="REQQTY" runat="server" DataIndex="MD9" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D10_1" ItemID="D10" runat="server" ><%--Text="D+10">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD10_1" ItemID="REQQTY" runat="server" DataIndex="MD10" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D11_1" ItemID="D11" runat="server" ><%--Text="D+11">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD11_1" ItemID="REQQTY" runat="server" DataIndex="MD11" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D12_1" ItemID="D12" runat="server" ><%--Text="D+12">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD12_1" ItemID="REQQTY" runat="server" DataIndex="MD12" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D13_1" ItemID="D13" runat="server" ><%--Text="D+13">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD13_1" ItemID="REQQTY" runat="server" DataIndex="MD13" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D14_1" ItemID="D14" runat="server" ><%--Text="D+14">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD14_1" ItemID="REQQTY" runat="server" DataIndex="MD14" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D15_1" ItemID="D15" runat="server" ><%--Text="D+15">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD15_1" ItemID="REQQTY" runat="server" DataIndex="MD15" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D16_1" ItemID="D16" runat="server" ><%--Text="D+16">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD16_1" ItemID="REQQTY" runat="server" DataIndex="MD16" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D17_1" ItemID="D17" runat="server" ><%--Text="D+17">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD17_1" ItemID="REQQTY" runat="server" DataIndex="MD17" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D18_1" ItemID="D18" runat="server" ><%--Text="D+18">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD18_1" ItemID="REQQTY" runat="server" DataIndex="MD18" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D19_1" ItemID="D19" runat="server" ><%--Text="D+19">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD19_1" ItemID="REQQTY" runat="server" DataIndex="MD19" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D20_1" ItemID="D20" runat="server" ><%--Text="D+20">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD20_1" ItemID="REQQTY" runat="server" DataIndex="MD20" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D21_1" ItemID="D21" runat="server" ><%--Text="D+21">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD21_1" ItemID="REQQTY" runat="server" DataIndex="MD21" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D22_1" ItemID="D22" runat="server" ><%--Text="D+22">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD22_1" ItemID="REQQTY" runat="server" DataIndex="MD22" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D23_1" ItemID="D23" runat="server" ><%--Text="D+23">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD23_1" ItemID="REQQTY" runat="server" DataIndex="MD23" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D24_1" ItemID="D24" runat="server" ><%--Text="D+24">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD24_1" ItemID="REQQTY" runat="server" DataIndex="MD24" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D25_1" ItemID="D25" runat="server" ><%--Text="D+25">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD25_1" ItemID="REQQTY" runat="server" DataIndex="MD25" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D26_1" ItemID="D26" runat="server" ><%--Text="D+26">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD26_1" ItemID="REQQTY" runat="server" DataIndex="MD26" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D27_1" ItemID="D27" runat="server" ><%--Text="D+27">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD27_1" ItemID="REQQTY" runat="server" DataIndex="MD27" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D28_1" ItemID="D28" runat="server" ><%--Text="D+28">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD28_1" ItemID="REQQTY" runat="server" DataIndex="MD28" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D29_1" ItemID="D29" runat="server" ><%--Text="D+29">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD29_1" ItemID="REQQTY" runat="server" DataIndex="MD29" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D30_1" ItemID="D30" runat="server" ><%--Text="D+30">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MD30_1" ItemID="REQQTY" runat="server" DataIndex="MD30" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
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
					<%-- 상세 그리드 --%>
                    <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel2" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
											<ext:ModelField Name="LINECD" />
                                            <ext:ModelField Name="LINENM" />
                                            <ext:ModelField Name="VINCD" />
											<ext:ModelField Name="MIP_PARTNO" />
                                            <ext:ModelField Name="MIP_PARTNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="UNIT" />
											<ext:ModelField Name="PTOT" />
                                            <ext:ModelField Name="MTOT" />
                                            <ext:ModelField Name="PD0" />
											<ext:ModelField Name="MD0" />
											<ext:ModelField Name="PD1" />
                                            <ext:ModelField Name="MD1" />
											<ext:ModelField Name="PD2" />
                                            <ext:ModelField Name="MD2" />
											<ext:ModelField Name="PD3" />
                                            <ext:ModelField Name="MD3" />
											<ext:ModelField Name="PD4" />
                                            <ext:ModelField Name="MD4" />
                                            <ext:ModelField Name="PD5" />
                                            <ext:ModelField Name="MD5" />
                                            <ext:ModelField Name="PD6" />
                                            <ext:ModelField Name="MD6" />
                                            <ext:ModelField Name="PD7" />
                                            <ext:ModelField Name="MD7" />
                                            <ext:ModelField Name="PD8" />
                                            <ext:ModelField Name="MD8" />
                                            <ext:ModelField Name="PD9" />
                                            <ext:ModelField Name="MD9" />
                                            <ext:ModelField Name="PD10" />
                                            <ext:ModelField Name="MD10" />
                                            <ext:ModelField Name="PD11" />
                                            <ext:ModelField Name="MD11" />
                                            <ext:ModelField Name="PD12" />
                                            <ext:ModelField Name="MD12" />
                                            <ext:ModelField Name="PD13" />
                                            <ext:ModelField Name="MD13" />
                                            <ext:ModelField Name="PD14" />
                                            <ext:ModelField Name="MD14" />
                                            <ext:ModelField Name="PD15" />
                                            <ext:ModelField Name="MD15" />
                                            <ext:ModelField Name="PD16" />
                                            <ext:ModelField Name="MD16" />
                                            <ext:ModelField Name="PD17" />
                                            <ext:ModelField Name="MD17" />
                                            <ext:ModelField Name="PD18" />
                                            <ext:ModelField Name="MD18" />
                                            <ext:ModelField Name="PD19" />
                                            <ext:ModelField Name="MD19" />
                                            <ext:ModelField Name="PD20" />
                                            <ext:ModelField Name="MD20" />
                                            <ext:ModelField Name="PD21" />
                                            <ext:ModelField Name="MD21" />
											<ext:ModelField Name="PD22" />
                                            <ext:ModelField Name="MD22" />
											<ext:ModelField Name="PD23" />
                                            <ext:ModelField Name="MD23" />
											<ext:ModelField Name="PD24" />
                                            <ext:ModelField Name="MD24" />
                                            <ext:ModelField Name="PD25" />
                                            <ext:ModelField Name="MD25" />
                                            <ext:ModelField Name="PD26" />
                                            <ext:ModelField Name="MD26" />
                                            <ext:ModelField Name="PD27" />
                                            <ext:ModelField Name="MD27" />
                                            <ext:ModelField Name="PD28" />
                                            <ext:ModelField Name="MD28" />
                                            <ext:ModelField Name="PD29" />
                                            <ext:ModelField Name="MD29" />
                                            <ext:ModelField Name="PD30" />
                                            <ext:ModelField Name="MD30" />
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
                                <ext:RowNumbererColumn ID="RowNumbererColumn1" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:Column ID="VENDCD_2" ItemID="VENDCD6" runat="server" DataIndex="VENDCD" Width="70"  Align="Center" /><%--Text="업체코드"--%>
                                <ext:Column ID="VENDNM_2" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="120" Align="Left"  /><%--Text="업체명"--%>
								<ext:Column ID="LINECD_2" ItemID="LINECD" runat="server" DataIndex="LINECD" Width="70"  Align="Center"  /><%--Text="라인코드"--%>
                                <ext:Column ID="LINENM_2" ItemID="LINENM" runat="server" DataIndex="LINENM" Width="120" Align="Left" /><%--Text="라인명"--%>
                                <ext:Column ID="VINCD_2" ItemID="VIN" runat="server" DataIndex="VINCD" Width="40" Align="Center" /><%--Text="차종"--%>
								<ext:Column ID="MIP_PARTNO_2" ItemID="ASSY_PNO" runat="server" DataIndex="MIP_PARTNO" Width="120" Align="Left" /><%--Text="제품 PART NO"--%>
                                <ext:Column ID="MIP_PARTNM_2" ItemID="PARTNM" runat="server" DataIndex="MIP_PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME"--%>
                                <ext:Column ID="PARTNO_2" ItemID="SUBCON_PNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="외작 PART NO"--%>
                                <ext:Column ID="PARTNM_2" ItemID="SUB_PNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME"--%>
                                <ext:Column ID="UNIT_2" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="40" Align="Center" /><%--Text="UNIT"--%>
                                <ext:Column ID="TOT_2" ItemID="TOT2" runat="server" ><%--Text="계">--%>
                                    <Columns>
										<ext:NumberColumn ID="PTOT_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PTOT" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MTOT_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MTOT" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D0_2" ItemID="D0" runat="server" ><%--Text="D-DAY">--%>
                                    <Columns>
										<ext:NumberColumn ID="PD0_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD0" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD0_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD0" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D1_2" ItemID="D1" runat="server" ><%--Text="D+1">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD1_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD1" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD1_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD1" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D2_2" ItemID="D2" runat="server" ><%--Text="D+2">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD2_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD2" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD2_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD2" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D3_2" ItemID="D3" runat="server" ><%--Text="D+3">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD3_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD3" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD3_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD3" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D4_2" ItemID="D4" runat="server" ><%--Text="D+4">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD4_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD4" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD4_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD4" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D5_2" ItemID="D5" runat="server" ><%--Text="D+5">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD5_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD5" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD5_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD5" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D6_2" ItemID="D6" runat="server" ><%--Text="D+6">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD6_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD6" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD6_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD6" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D7_2" ItemID="D7" runat="server" ><%--Text="D+7">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD7_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD7" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD7_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD7" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D8_2" ItemID="D8" runat="server" ><%--Text="D+8">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD8_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD8" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD8_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD8" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D9_2" ItemID="D9" runat="server" ><%--Text="D+9">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD9_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD9" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD9_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD9" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D10_2" ItemID="D10" runat="server" ><%--Text="D+10">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD10_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD10" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD10_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD10" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D11_2" ItemID="D11" runat="server" ><%--Text="D+11">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD11_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD11" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD11_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD11" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D12_2" ItemID="D12" runat="server" ><%--Text="D+12">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD12_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD12" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD12_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD12" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
								<ext:Column ID="D13_2" ItemID="D13" runat="server" ><%--Text="D+13">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD13_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD13" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD13_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD13" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D14_2" ItemID="D14" runat="server" ><%--Text="D+14">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD14_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD14" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD14_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD14" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D15_2" ItemID="D15" runat="server" ><%--Text="D+15">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD15_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD15" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD15_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD15" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D16_2" ItemID="D16" runat="server" ><%--Text="D+16">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD16_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD16" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD16_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD16" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D17_2" ItemID="D17" runat="server" ><%--Text="D+17">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD17_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD17" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD17_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD17" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D18_2" ItemID="D18" runat="server" ><%--Text="D+18">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD18_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD18" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD18_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD18" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D19_2" ItemID="D19" runat="server" ><%--Text="D+19">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD19_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD19" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD19_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD19" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D20_2" ItemID="D20" runat="server" ><%--Text="D+20">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD20_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD20" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD20_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD20" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D21_2" ItemID="D21" runat="server" ><%--Text="D+21">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD21_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD21" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD21_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD21" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D22_2" ItemID="D22" runat="server" ><%--Text="D+22">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD22_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD22" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD22_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD22" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D23_2" ItemID="D23" runat="server" ><%--Text="D+23">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD23_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD23" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD23_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD23" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D24_2" ItemID="D24" runat="server" ><%--Text="D+24">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD24_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD24" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD24_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD24" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D25_2" ItemID="D25" runat="server" ><%--Text="D+25">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD25_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD25" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD25_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD25" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D26_2" ItemID="D26" runat="server" ><%--Text="D+26">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD26_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD26" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD26_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD26" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D27_2" ItemID="D27" runat="server" ><%--Text="D+27">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD27_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD27" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD27_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD27" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D28_2" ItemID="D28" runat="server" ><%--Text="D+28">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD28_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD28" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD28_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD28" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D29_2" ItemID="D29" runat="server" ><%--Text="D+29">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD29_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD29" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD29_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD29" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D30_2" ItemID="D30" runat="server" ><%--Text="D+30">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="PD30_2" ItemID="PRDT_PLAN_QTY" runat="server" DataIndex="PD30" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="제품계획수량">--%>
                                        <ext:NumberColumn ID="MD30_2" ItemID="MAT_REQ_QTY" runat="server" DataIndex="MD30" Width="70" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="자재소요량">--%>
                                    </Columns>
                                </ext:Column>
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
