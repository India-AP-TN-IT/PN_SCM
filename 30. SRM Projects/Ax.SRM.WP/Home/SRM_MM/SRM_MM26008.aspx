<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM26008.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM26008" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible"/>
<meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
<meta content="/images/favicon/SCM.ico" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
    <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    <meta content="/images/favicon/SCM.ico" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
    <style type="text/css">
        
        .font-color-red 
        {
            color:#FF0000;
        }
	            
    </style>
    <style type="text/css">
        
        .x-column-header-align-right .x-column-header-text
        {
            margin-right:0px;
        }
        
    </style>
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

        function fn_cbo01_SEARCH_OPT_Change(obj, value) {
            if (value == "1ZS") {
                document.getElementById('App.lbl01_ACP_DIV_Container').style.display = 'none';
                document.getElementById('App.cbo01_ACP_DIV_Container').style.display = 'none';
            }
            else {
                document.getElementById('App.lbl01_ACP_DIV_Container').style.display = 'block';
                document.getElementById('App.cbo01_ACP_DIV_Container').style.display = 'block';
            }
        }

        function getRowClass(record, b, c, d) {
            var acpQty = record.data['ACP_QTY'];
            var amount = record.data['AMOUNT'];

            if (acpQty < 0 || amount < 0) return 'font-color-red';
        }

    </script>

</head>
<body>
    <form id="SRM_MM26008" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM26008" runat="server" Cls="search_area_title_name" />
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
                            <col style="width: 120px;" />
                            <col style="width: 250px;"/>
                            <col style="width: 120px;" />
                            <col style="width: 250px;"/>
                            <col style="width: 120px;" />
                            <col style="width: 250px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>      
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_CUST" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD_FIX" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" Text="Business Code" /><%--Text="사업장" />--%>
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
                                <ext:Label ID="lbl01_BILLING_DATE" runat="server" /><%--Text="대금청구일" />--%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer2" runat="server" Width="250" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:DateField ID="df01_FROM_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                        <ext:DisplayField ID="DisplayField1" Width="20"  Flex="1" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:DateField ID="df01_TO_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                            <th class="ess">         
                                <ext:Label ID="lbl01_PURC_ORG_VTWEG" runat="server" /><%--Text="구매조직(유통경로)" />--%>
                            </th>
                            <td>                                
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store33" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model33" runat="server">
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

                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" /><%--Text="PART NO(%)" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_VGBEL_PER" runat="server" /><%--Text="출하문서번호(%)" />--%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="200" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:TextField ID="txt01_VGBEL" Width="130" Cls="inputText" runat="server" />
                                        <ext:DisplayField ID="DisplayField2" Width="20" Flex="1" runat="server" FieldStyle="text-align:center;padding:3px" Text=" - " />
                                        <ext:TextField ID="txt01_VGPOS" Width="45" Cls="inputText" runat="server" />
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_ACP_DIV" runat="server" /><%--Text="검수구분" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_ACP_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
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
                            <th>
                                <ext:Label ID="lbl01_SEARCH_OPT" runat="server" /><%--Text="조회구분" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SEARCH_OPT" runat="server"  Mode="Local" ForceSelection="true"
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
                                    <Listeners>
                                        <Change Fn="fn_cbo01_SEARCH_OPT_Change"></Change>
                                    </Listeners>
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_SEARCH_OPT_Change" />
                                    </DirectEvents>
                                </ext:SelectBox>                                
                            </td>                            
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <%--집계그리드--%>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." SortableColumns="false">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="PURC_ORGNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="COINCD" />
                                            <ext:ModelField Name="SUM_QTY" />
                                            <ext:ModelField Name="SUM_AMT" />                                              
                                            <ext:ModelField Name="OUT_QTY" />
                                            <ext:ModelField Name="OUT_AMT" />
                                            <ext:ModelField Name="RTN_QTY" />
                                            <ext:ModelField Name="RTN_AMT" />
                                            <ext:ModelField Name="RETROACT_AMT" />
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
                                <ext:Column ID="CUSTCD" ItemID="VENDORCD" runat="server" DataIndex="CUSTCD" Width="80"  Align="Center" /><%--Text="거래처코드"--%>
                                <ext:Column ID="CUSTNM" ItemID="VENDORNM" runat="server" DataIndex="CUSTNM" Width="150"  Align="Left" /><%--Text="거래처명"--%> 
                                <ext:Column ID="PURC_ORGNM" ItemID="PURC_ORG" runat="server" DataIndex="PURC_ORGNM" Width="70"  Align="Center" /><%--Text="구매조직"--%> 
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120"  Align="Left"  /><%--Text="PART NO"--%> 
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="170"  Align="Left" Flex="1" /><%--Text="PART NAME"--%> 
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="50"  Align="Center" /><%--Text="단위"--%> 
                                <ext:Column ID="COINCD" ItemID="REC_WAERS" runat="server" DataIndex="COINCD" Width="40" Align="Center" /><%--Text="통화"--%> 
                                <ext:Column ID="SUMTOT" ItemID="SUMTOT" runat="server" ><%--Text="합계">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="SUM_QTY" ItemID="QTY" runat="server" DataIndex="SUM_QTY" Width="80" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="수량"--%>
                                        <ext:NumberColumn ID="SUM_AMT" ItemID="AMT" runat="server" DataIndex="SUM_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="금액"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="DELIVERY" ItemID="DELIVERY" runat="server" ><%--Text="출고">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="OUT_QTY" ItemID="QTY" runat="server" DataIndex="OUT_QTY" Width="80" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="수량"--%>
                                        <ext:NumberColumn ID="OUT_AMT" ItemID="AMT" runat="server" DataIndex="OUT_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="금액"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="RTN" ItemID="RTN" runat="server" ><%--Text="반품">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="RTN_QTY" ItemID="QTY" runat="server" DataIndex="RTN_QTY" Width="80" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="수량"--%>
                                        <ext:NumberColumn ID="RTN_AMT" ItemID="AMT" runat="server" DataIndex="RTN_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="금액"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="SETTLE2" ItemID="SETTLE2" runat="server" ><%--Text="소급">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="RETROACT_AMT" ItemID="AMT" runat="server" DataIndex="RETROACT_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="금액"--%>
                                    </Columns>
                                </ext:Column>
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true" />
                        </View>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single"/>
                        </SelectionModel>
                        <Listeners>
                                <%--<CellDblClick Fn ="CellDbClick"></CellDblClick>--%>
                        </Listeners>                                                  
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                    <%--상세그리드--%>
                    <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." SortableColumns="false" >
                        <Store>
                            <ext:Store ID="Store3" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="Model3" runat="server">
                                        <Fields>                                                                      
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="ACP_DATE" />
                                            <ext:ModelField Name="VBELN" />
                                            <ext:ModelField Name="POSNR" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="ACP_QTY" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="UCOST" />
                                            <ext:ModelField Name="AMOUNT" />
                                            <ext:ModelField Name="COINCD" />
                                            <ext:ModelField Name="PURC_ORGNM" />
                                            <ext:ModelField Name="ISSUE_NO" />
                                            <ext:ModelField Name="ACP_DIV" />
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
								<ext:RowNumbererColumn ID="NO_2" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:Column ID="CUSTCD_2" ItemID="VENDORCD" runat="server" DataIndex="CUSTCD" Width="80"  Align="Center" /><%--Text="거래처코드"--%>
                                <ext:Column ID="CUSTNM_2" ItemID="VENDORNM" runat="server" DataIndex="CUSTNM" Width="150"  Align="Left" /><%--Text="거래처명"--%>
								<ext:Column ID="ACP_DATE2" ItemID="BILLING_DATE" runat="server" DataIndex="ACP_DATE" Width="100"  Align="Center"  /><%--Text="대금청구일"--%>
								<ext:Column ID="VBELN_2" ItemID="VBELN" runat="server" DataIndex="VBELN" Width="120"  Align="Center" /><%--Text="청구문서번호"--%>
								<ext:Column ID="POSNR_2" ItemID="SEQ_NO" runat="server" DataIndex="POSNR" Width="40"  Align="Center" /><%--Text="순번"--%>
								<ext:Column ID="PARTNO_2" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="140"  Align="Left" /><%--Text="PART NO"--%>
                                <ext:Column ID="PARTNM_2" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="170"  Align="Left" Flex="1" /><%--Text="PART NAME"--%>
								<ext:NumberColumn ID="ACP_QTY_2" ItemID="QTY" runat="server" DataIndex="ACP_QTY" Width="80" Align="Right" Format="#,##0.###" Sortable="true" /> <%--Text="수량"--%>
                                <ext:Column ID="UNITNM_2" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="50"  Align="Center" /><%--Text="단위"--%> 
								<ext:NumberColumn ID="UCOST_2" ItemID="UCOST" runat="server" DataIndex="UCOST" Width="80" Align="Right" Format="#,##0.##" Sortable="true" /> <%--Text="단가"--%>
								<ext:NumberColumn ID="AMOUNT_2" ItemID="SUPPLYAMT" runat="server" DataIndex="AMOUNT" Width="100" Align="Right" Format="#,##0.##" Sortable="true" /> <%--Text="공급가액"--%>
                                <ext:Column ID="COINCD_2" ItemID="REC_WAERS" runat="server" DataIndex="COINCD" Width="40" Align="Center" /><%--Text="통화"--%>
								<ext:Column ID="PURC_ORGNM_2" ItemID="PURC_ORG" runat="server" DataIndex="PURC_ORGNM" Width="70"  Align="Center" /><%--Text="구매조직"--%> 
								<ext:Column ID="ISSUE_NO_2" ItemID="VGBEL" runat="server" DataIndex="ISSUE_NO" Width="120"  Align="Center" /><%--Text="출하문서번호"--%>
								<ext:Column ID="ACP_DIV_2" ItemID="ACP_DIV" runat="server" DataIndex="ACP_DIV" Width="70"  Align="Center" /><%--Text="검수구분"--%>
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true">
                                <GetRowClass Fn="getRowClass" />
                            </ext:GridView>
                        </View>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"/>
                        </SelectionModel>
                        <Listeners>
                                <%--<CellDblClick Fn ="CellDbClick"></CellDblClick>--%>
                        </Listeners>                                                  
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
