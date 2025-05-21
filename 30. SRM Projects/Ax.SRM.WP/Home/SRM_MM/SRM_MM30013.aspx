<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM30013.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM30013" %>
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
    <form id="SRM_MM30013" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM30013" runat="server" Cls="search_area_title_name" /><%--Text="MIP 자재소요계획 현황" />--%>
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
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" FieldStyle="text-transform:uppercase;" />
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_MIP_PARTNO_PER" runat="server" />                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_MIP_PARTNO" Width="120" Cls="inputText" runat="server" FieldStyle="text-transform:uppercase;" />
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
                                            <ext:ModelField Name="MD" />
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
                                            <ext:ModelField Name="DDR0" />
                                            <ext:ModelField Name="TBNT" />
                                            <ext:ModelField Name="PRTN" />
                                            <ext:ModelField Name="MITU" />
                                            <ext:ModelField Name="PSEQ" />
                                            <ext:ModelField Name="DDTT" />
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
                                <ext:Column ID="TOT_1" ItemID="OUR_USE_PLAN" runat="server" ><%--Text="당사 소요 계획">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="MTOT" ItemID="TOT2" runat="server" DataIndex="MTOT" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="계">--%>                                   
                                        <ext:NumberColumn ID="MD" ItemID="PREVDAY_PLAN_BY_RSLT_QTY" runat="server" DataIndex="MD" Width="110" Align="Right" Format="#,##0.###" Sortable="true"  Visible="false"/><%--Text="전일미실적">--%>              
                                        <ext:NumberColumn ID="MD0_1" ItemID="D" runat="server" DataIndex="MD0" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D">--%>                                    
                                        <ext:NumberColumn ID="MD1_1" ItemID="D1" runat="server" DataIndex="MD1" Width="80" Align="Right" Format="#,##0.###" Sortable="true"  /><%--Text="D+1">--%>                                    
                                        <ext:NumberColumn ID="MD2_1" ItemID="D2" runat="server" DataIndex="MD2" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+2">--%>                                   
                                        <ext:NumberColumn ID="MD3_1" ItemID="D3" runat="server" DataIndex="MD3" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+3">--%>                                
                                        <ext:NumberColumn ID="MD4_1" ItemID="D4" runat="server" DataIndex="MD4" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+4">--%>                                    
                                        <ext:NumberColumn ID="MD5_1" ItemID="D5" runat="server" DataIndex="MD5" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+5">--%>                                    
                                        <ext:NumberColumn ID="MD6_1" ItemID="D6" runat="server" DataIndex="MD6" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+6">--%>                                    
                                        <ext:NumberColumn ID="MD7_1" ItemID="D7" runat="server" DataIndex="MD7" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+7">--%>                                    
                                        <ext:NumberColumn ID="MD8_1" ItemID="D8" runat="server" DataIndex="MD8" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+8">--%>                                    
                                        <ext:NumberColumn ID="MD9_1" ItemID="D9" runat="server" DataIndex="MD9" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+9">--%>                                    
                                        <ext:NumberColumn ID="MD10_1" ItemID="D10" runat="server" DataIndex="MD10" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+10">--%>                                    
                                        <ext:NumberColumn ID="MD11_1" ItemID="D11" runat="server" DataIndex="MD11" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+11">--%>                                    
                                        <ext:NumberColumn ID="MD12_1" ItemID="D12" runat="server" DataIndex="MD12" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+12">--%>                                    
                                        <ext:NumberColumn ID="MD13_1" ItemID="D13" runat="server" DataIndex="MD13" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+13">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="Column1" ItemID="CUST_USE_PLAN" runat="server" ><%--고객사 소요계획--%>
                                    <Columns>
                                        <ext:NumberColumn ID="NumberColumn1" ItemID="D_SUM" runat="server" DataIndex="DCNTT" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn20" ItemID="D" runat="server" DataIndex="D0" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn2" ItemID="D1" runat="server" DataIndex="D1" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn3" ItemID="D2" runat="server" DataIndex="D2" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn4" ItemID="D3" runat="server" DataIndex="D3" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn5" ItemID="D4" runat="server" DataIndex="D4" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn6" ItemID="D5" runat="server" DataIndex="D5" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn7" ItemID="D6" runat="server" DataIndex="D6" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn8" ItemID="D7" runat="server" DataIndex="D7" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn9" ItemID="D8" runat="server" DataIndex="D8" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn10" ItemID="D9" runat="server" DataIndex="D9" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn11" ItemID="D10" runat="server" DataIndex="D10" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn12" ItemID="D11" runat="server" DataIndex="D11" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn13" ItemID="D12" runat="server" DataIndex="D12" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn14" ItemID="D13_31" runat="server" DataIndex="DDR0" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn15" ItemID="TMONTH" runat="server" DataIndex="TBNT" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn16" ItemID="OSTAND" runat="server" DataIndex="PRTN" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn17" ItemID="MITU" runat="server" DataIndex="MITU" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn18" ItemID="PRE_SEQ" runat="server" DataIndex="PSEQ" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
                                        <ext:NumberColumn ID="NumberColumn19" ItemID="P7_TOTAL" runat="server" DataIndex="DDTT" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소요량">--%>
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
                                            <ext:ModelField Name="MTOT" />
                                            <ext:ModelField Name="MD" />
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
                                            <ext:ModelField Name="DDR0" />
                                            <ext:ModelField Name="TBNT" />
                                            <ext:ModelField Name="PRTN" />
                                            <ext:ModelField Name="MITU" />
                                            <ext:ModelField Name="PSEQ" />
                                            <ext:ModelField Name="DDTT" />
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
                                <ext:Column ID="Column2" ItemID="OUR_USE_PLAN" runat="server" ><%--Text="당사 소요 계획">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="NumberColumn21" ItemID="TOT2" runat="server" DataIndex="MTOT" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="계">--%>                                   
                                        <ext:NumberColumn ID="NumberColumn22" ItemID="PREVDAY_PLAN_BY_RSLT_QTY" runat="server" DataIndex="MD" Width="110" Align="Right" Format="#,##0.###" Sortable="true" Visible="false" /><%--Text="전일미실적">--%>              
                                        <ext:NumberColumn ID="MD0_2" ItemID="D" runat="server" DataIndex="MD0" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D">--%>                                    
                                        <ext:NumberColumn ID="MD1_2" ItemID="D1" runat="server" DataIndex="MD1" Width="80" Align="Right" Format="#,##0.###" Sortable="true"  /><%--Text="D+1">--%>                                    
                                        <ext:NumberColumn ID="MD2_2" ItemID="D2" runat="server" DataIndex="MD2" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+2">--%>                                   
                                        <ext:NumberColumn ID="MD3_2" ItemID="D3" runat="server" DataIndex="MD3" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+3">--%>                                
                                        <ext:NumberColumn ID="MD4_2" ItemID="D4" runat="server" DataIndex="MD4" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+4">--%>                                    
                                        <ext:NumberColumn ID="MD5_2" ItemID="D5" runat="server" DataIndex="MD5" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+5">--%>                                    
                                        <ext:NumberColumn ID="MD6_2" ItemID="D6" runat="server" DataIndex="MD6" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+6">--%>                                    
                                        <ext:NumberColumn ID="MD7_2" ItemID="D7" runat="server" DataIndex="MD7" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+7">--%>                                    
                                        <ext:NumberColumn ID="MD8_2" ItemID="D8" runat="server" DataIndex="MD8" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+8">--%>                                    
                                        <ext:NumberColumn ID="MD9_2" ItemID="D9" runat="server" DataIndex="MD9" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+9">--%>                                    
                                        <ext:NumberColumn ID="MD10_2" ItemID="D10" runat="server" DataIndex="MD10" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+10">--%>                                    
                                        <ext:NumberColumn ID="MD11_2" ItemID="D11" runat="server" DataIndex="MD11" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+11">--%>                                    
                                        <ext:NumberColumn ID="MD12_2" ItemID="D12" runat="server" DataIndex="MD12" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+12">--%>                                    
                                        <ext:NumberColumn ID="MD13_2" ItemID="D13" runat="server" DataIndex="MD13" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+13">--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="Column3" ItemID="CUST_USE_PLAN" runat="server" ><%--고객사 소요계획--%>
                                    <Columns>
                                        <ext:NumberColumn ID="NumberColumn37" ItemID="D_SUM" runat="server" DataIndex="DCNTT" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D SUM">--%>
                                        <ext:NumberColumn ID="NumberColumn38" ItemID="D" runat="server" DataIndex="D0" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D">--%>
                                        <ext:NumberColumn ID="NumberColumn39" ItemID="D1" runat="server" DataIndex="D1" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+1">--%>
                                        <ext:NumberColumn ID="NumberColumn40" ItemID="D2" runat="server" DataIndex="D2" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+2">--%>
                                        <ext:NumberColumn ID="NumberColumn41" ItemID="D3" runat="server" DataIndex="D3" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+3">--%>
                                        <ext:NumberColumn ID="NumberColumn42" ItemID="D4" runat="server" DataIndex="D4" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+4">--%>
                                        <ext:NumberColumn ID="NumberColumn43" ItemID="D5" runat="server" DataIndex="D5" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+5">--%>
                                        <ext:NumberColumn ID="NumberColumn44" ItemID="D6" runat="server" DataIndex="D6" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+6">--%>
                                        <ext:NumberColumn ID="NumberColumn45" ItemID="D7" runat="server" DataIndex="D7" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+7">--%>
                                        <ext:NumberColumn ID="NumberColumn46" ItemID="D8" runat="server" DataIndex="D8" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+8">--%>
                                        <ext:NumberColumn ID="NumberColumn47" ItemID="D9" runat="server" DataIndex="D9" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+9">--%>
                                        <ext:NumberColumn ID="NumberColumn48" ItemID="D10" runat="server" DataIndex="D10" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+10">--%>
                                        <ext:NumberColumn ID="NumberColumn49" ItemID="D11" runat="server" DataIndex="D11" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+11">--%>
                                        <ext:NumberColumn ID="NumberColumn50" ItemID="D12" runat="server" DataIndex="D12" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D+12">--%>
                                        <ext:NumberColumn ID="NumberColumn51" ItemID="D13_31" runat="server" DataIndex="DDR0" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="D13~D31">--%>
                                        <ext:NumberColumn ID="NumberColumn52" ItemID="TMONTH" runat="server" DataIndex="TBNT" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="M">--%>
                                        <ext:NumberColumn ID="NumberColumn53" ItemID="OSTAND" runat="server" DataIndex="PRTN" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="M+1">--%>
                                        <ext:NumberColumn ID="NumberColumn54" ItemID="MITU" runat="server" DataIndex="MITU" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="MITU">--%>
                                        <ext:NumberColumn ID="NumberColumn55" ItemID="PRE_SEQ" runat="server" DataIndex="PSEQ" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="PRE-SEQ">--%>
                                        <ext:NumberColumn ID="NumberColumn56" ItemID="P7_TOTAL" runat="server" DataIndex="DDTT" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="P7 TOTAL">--%>
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
