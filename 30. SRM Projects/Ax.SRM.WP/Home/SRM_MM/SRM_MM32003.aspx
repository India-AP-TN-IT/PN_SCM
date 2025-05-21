<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM32003.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM32003" %>
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
        .highlight .x-grid-cell {background: yellow ;}
        
	    .x-grid-cell-CODE DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }	    
	    /*.x-grid-row-selected .x-grid-td {background: lightblue;color:black !important;}*/
	            
    </style>
    <style type="text/css">
        
        .font-color-red 
        {
            color:#FF0000;
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

        var linkRenderer = function (value, meta, record, index, cellIndex) {
            var param = "Ext.getStore('" + record.store.storeId + "')";
            
            var color = "blue";

            if (value < 0)
                color = "red";

            return Ext.String.format("<a style='color:" + color + ";text-decoration:underline;' href='#' onclick=\"linkClick({0},{1},{2});\">{3}</a>", param, index, cellIndex, (record.store.storeId == 'Store1') ? numberWithCommas(value) : value);
        };
        var linkClick = function (store, rowIndex, cellIndex) {
            var param1 = new Array(store.getAt(rowIndex).data["PURC_ORG"], store.getAt(rowIndex).data["PURC_PO_TYPE"], store.getAt(rowIndex).data["VINCD"], store.getAt(rowIndex).data["PARTNO"], store.getAt(rowIndex).data["PARTNM"], store.getAt(rowIndex).data["UNITNM"], store.getAt(rowIndex).data["PURC_GRP"], store.getAt(rowIndex).data["VENDCD"], store.getAt(rowIndex).data["CUSTCD"]);
            App.direct.MakePopUp(param1, 'I');
        };

        var linkRenderer2 = function (value, meta, record, index, cellIndex) {
            var param = "Ext.getStore('" + record.store.storeId + "')";
            var color = "blue";
            return Ext.String.format("<a style='color:" + color + ";text-decoration:underline;' href='#' onclick=\"linkClick2({0},{1},{2});\">{3}</a>", param, index, cellIndex, (record.store.storeId == 'Store1') ? numberWithCommas(value) : value);
        };

        var linkClick2 = function (store, rowIndex, cellIndex) {
            var param1 = new Array(store.getAt(rowIndex).data["PONO"], store.getAt(rowIndex).data["PARTNO"], store.getAt(rowIndex).data["PARTNM"], store.getAt(rowIndex).data["UNITNM"]);
            App.direct.MakePopUp(param1, 'D');
        };

        function numberWithCommas(x) {
            var parts = x.toString().split(".");
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            return parts.join(".");
        }
                
        function getRowClass(record, b, c, d) {
            var color = record.data['COLOR'];
            var grn_qty = record.data['GRN_QTY'];
            var gap_color = record.data['GAP_COLOR'];

            if (color == 'Y' || grn_qty < 0) return 'font-color-red';
            if (gap_color == 'Y') return 'font-color-red';
        }

        function getRowClass2(record, b, c, d) {            
            var grn_qty = record.data['GRN_QTY'];
            var gap_color = record.data['GAP_COLOR'];

            if (grn_qty < 0) return 'font-color-red';
            if (gap_color == 'Y') return 'font-color-red';
            
        }

    </script>

</head>
<body>
    <form id="SRM_MM32003" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM32003" runat="server" Cls="search_area_title_name" />
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
                            <col style="width: 100px;" />
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
                                <ext:Label ID="lbl01_BIZCD" runat="server" Text="Business Code" />
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
                                <ext:Label ID="lbl01_RCV_DATE" runat="server" />
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
                            <th>
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" />
                            </th>
                            <td>                                
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="200">
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
                                <ext:Label ID="lbl01_PURC_PO_TYPE" runat="server" />                   
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PURC_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store6" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model6" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <%--
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_PURC_PO_TYPE_Change" />
                                    </DirectEvents>                          
                                    --%>         
                                </ext:SelectBox>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />    
                            </td>
                            <th>
                               <ext:Label ID="lbl01_STR_LOC" runat="server" />
                            </th>
                            <td>                                                                                                 
                                <epc:EPCodeBox ID="cdx01_STR_LOC" runat="server" HelperID="HELP_STR_LOC" PopupMode="Search" PopupType="HelpWindow" 
                                    OnBeforeDirectButtonClick="cdx01_STR_LOC_BeforeDirectButtonClick" WidthTYPECD="60"/>    
                            </td>
                            <th>
                                <ext:Label ID="lbl01_SEARCH_OPT" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SEARCH_OPT" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="200">
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
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_SEARCH_OPT_Change" />
                                    </DirectEvents>
                                </ext:SelectBox>                                
                            </td>                            
                        </tr>
                        <tr>
                            <th>
                               <ext:Label ID="lbl01_CUSTNM" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD" PopupMode="Search" PopupType="HelpWindow"/>    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_DELI_NOTE2" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_DELI_NOTE" Width="150" Cls="inputText" runat="server" />    
                            </td>
                            <th>
                                <ext:Label ID="lbl01_RCV_DIV" runat="server" />                   
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_RCV_DIV" runat="server" ClassID="1D" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_MOVE_CODE" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_MOVE_CODE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="TYPECD" TriggerAction="All" Width="200">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="TYPECD" />
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
                    <%--집계그리드--%>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." SortableColumns="false">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="PURC_ORG" />
                                            <ext:ModelField Name="PURC_ORGNM" />
                                            <ext:ModelField Name="PURC_PO_TYPE" />
                                            <ext:ModelField Name="PURC_PO_TYPENM" />
                                            <ext:ModelField Name="PURC_GRP" />
                                            <ext:ModelField Name="PURC_GRPNM" />
                                            <ext:ModelField Name="VINCD" />                                              
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="UNITNM" />
                                            <ext:ModelField Name="GRN_QTY" />
                                            <ext:ModelField Name="MOVE_TYPE" />
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />                                            
                                            <ext:ModelField Name="COLOR" />
                                            <ext:ModelField Name="GRN_AMT" />
                                            <ext:ModelField Name="MONTHLY_AMT" />
                                            <ext:ModelField Name="GAP_COLOR" />
											<ext:ModelField Name="INVOICE_NO" />
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
                                <ext:Column            ID="VENDCD" ItemID="VENDCD6" runat="server" DataIndex="VENDCD" Width="80"  Align="Center" />
                                <ext:Column            ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="150"  Align="Left" />
                                <ext:Column            ID="PURC_ORGNM" ItemID="PURC_ORGNM" runat="server" DataIndex="PURC_ORGNM" Width="70"  Align="center"  />
                                <ext:Column            ID="PURC_PO_TYPENM" ItemID="PURC_PO_TYPENM" runat="server" DataIndex="PURC_PO_TYPENM" Width="150"  Align="left" />
                                <ext:Column            ID="PURC_GRPNM" ItemID="PURC_GRPNM" runat="server" DataIndex="PURC_GRPNM" Width="70"  Align="left" />
                                <ext:Column            ID="VINNM" ItemID="VIN" runat="server" DataIndex="VINNM" Width="70"  Align="center" />
                                <ext:Column            ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120"  Align="Left"  />
                                <ext:Column            ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="170"  Align="Left" Flex="1" />
                                <ext:Column            ID="UNITNM" ItemID="UNIT" runat="server" DataIndex="UNITNM" Width="60"  Align="center" />
                                <ext:NumberColumn      ID="GRN_QTY"         ItemID="GRN_QTY"         runat="server" DataIndex="GRN_QTY"    Width="80"  Align="Right"  Format="#,##0.###" >
                                    <Renderer Fn="linkRenderer"/>
                                </ext:NumberColumn>
                                <ext:NumberColumn      ID="GRN_AMT" ItemID="RCV_AMT"         runat="server" DataIndex="GRN_AMT"    Width="100"  Align="Right"  Format="#,##0.##" />
                                <ext:NumberColumn      ID="MONTHLY_AMT" ItemID="MONTH_ACP_AMT"         runat="server" DataIndex="MONTHLY_AMT"    Width="100"  Align="Right"  Format="#,##0.##" />
                                <ext:Column            ID="MOVE_TYPE" ItemID="MOVE_TYPE" runat="server" DataIndex="MOVE_TYPE" Width="200" Align="Left" Hidden="true" />
                                <ext:Column            ID="CUSTNM" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="150"  Align="left" />
                                <ext:Column ID="INVOICE_NO" ItemID="INVOICE_NO" runat="server" DataIndex="INVOICE_NO" Width="100" Align="Center"  Text="Vendor Invoice"/><%--Text="Vendor Invoice"--%>
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
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
                                            <ext:ModelField Name="RCV_DATE" /><ext:ModelField Name="RCVNO" /><ext:ModelField Name="PURC_ORG" />  
                                            <ext:ModelField Name="PURC_ORGNM" /><ext:ModelField Name="PURC_PO_TYPE" /><ext:ModelField Name="PURC_PO_TYPENM" />
                                            <ext:ModelField Name="VINCD" /><ext:ModelField Name="VINNM" /><ext:ModelField Name="STR_LOC" />
                                            <ext:ModelField Name="STR_LOCNM" /><ext:ModelField Name="PARTNO" /><ext:ModelField Name="PARTNM" />                                             
                                            <ext:ModelField Name="UNIT" /><ext:ModelField Name="UNITNM" /><ext:ModelField Name="GRN_QTY" /> 
                                            <ext:ModelField Name="RCV_DIV" /><ext:ModelField Name="DELI_DATE" /><ext:ModelField Name="DELI_CNT" /> 
                                            <ext:ModelField Name="DELI_NOTE" /><ext:ModelField Name="DELI_QTY" /><ext:ModelField Name="OK_QTY" /> 
                                            <ext:ModelField Name="DEF_QTY" /><ext:ModelField Name="PURC_GRP" /><ext:ModelField Name="PURC_GRPNM" />
                                            <ext:ModelField Name="VENDCD" /><ext:ModelField Name="VENDNM" /><ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" /><ext:ModelField Name="CANCELNO" /><ext:ModelField Name="COLOR" />
                                            <ext:ModelField Name="MOVE_CODE" /><ext:ModelField Name="MOVE_CODENM" /><ext:ModelField Name="PONO" />
                                            <ext:ModelField Name="GRN_AMT" /><ext:ModelField Name="MONTHLY_AMT" /><ext:ModelField Name="GAP_COLOR" />
											<ext:ModelField Name="INVOICE_NO" />
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
                                <ext:RowNumbererColumn ID="NO_1"      ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center"  />
                                <ext:Column            ID="VENDCD_1" ItemID="VENDCD6" runat="server" DataIndex="VENDCD" Width="80"  Align="Center" />
                                <ext:Column            ID="VENDNM_1" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="100"  Align="Left" />
                                <ext:Column ID="RCV_INFO_H" ItemID="RCV_INFO" runat="server" >
                                    <Columns>
                                        <ext:Column            ID="RCV_DATE_1" ItemID="RCV_DATE" runat="server" DataIndex="RCV_DATE" Width="80"  Align="center"  />
                                        <ext:Column            ID="PRCVNO_1" ItemID="RCVNO" runat="server" DataIndex="RCVNO" Width="120"  Align="center"  />
                                        <ext:Column            ID="VINNM_1" ItemID="VIN" runat="server" DataIndex="VINNM" Width="70"  Align="center" />
                                        <ext:Column            ID="PARTNO_1" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120"  Align="left" />
                                        <ext:Column            ID="PARTNM_1" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="170"  Align="left" />
                                        <ext:Column            ID="UNITNM_1" ItemID="UNIT" runat="server" DataIndex="UNITNM" Width="60"  Align="center" />
                                        <ext:NumberColumn      ID="GRN_QTY_1"        ItemID="GRN_QTY"         runat="server" DataIndex="GRN_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                        <ext:NumberColumn      ID="GRN_AMT_1" ItemID="RCV_AMT"         runat="server" DataIndex="GRN_AMT"    Width="100"  Align="Right"  Format="#,##0.##" />
                                        <ext:NumberColumn      ID="MONTHLY_AMT_1" ItemID="MONTH_ACP_AMT"         runat="server" DataIndex="MONTHLY_AMT"    Width="100"  Align="Right"  Format="#,##0.##" />
                                        <ext:Column            ID="RCV_DIV_1" ItemID="RCV_DIV" runat="server" DataIndex="RCV_DIV" Width="100"  Align="Left"  Hidden="false" />
                                    </Columns>
                                </ext:Column>
                                <ext:Column            ID="MOVE_CODENM_1" ItemID="MOVE_CODENM" runat="server" DataIndex="MOVE_CODENM" Width="150"  Align="left" />
                                <ext:Column            ID="PURC_ORGNM_1" ItemID="PURC_ORGNM" runat="server" DataIndex="PURC_ORGNM" Width="70"  Align="center" />
                                <ext:Column            ID="PURC_PO_TYPENM_1" ItemID="PURC_PO_TYPENM" runat="server" DataIndex="PURC_PO_TYPENM" Width="150"  Align="left" />
                                <ext:Column            ID="PURC_GRPNM_1" ItemID="PURC_GRPNM" runat="server" DataIndex="PURC_GRPNM" Width="70"  Align="left" />
                                <ext:Column            ID="STR_LOCNM_1" ItemID="STR_LOCNM" runat="server" DataIndex="STR_LOCNM" Width="80"  Align="left" />
                                <ext:Column            ID="CUSTNM_1" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="150"  Align="left" />
                                <ext:Column ID="DELI_INFO_H" ItemID="DELI_INFO" runat="server" >
                                    <Columns>
                                        <ext:Column ID="PONO_1" ItemID="PONO" runat="server" DataIndex="PONO" Width="110"  Align="Center" > <%--발주번호--%>
                                            <Renderer Fn="linkRenderer2"/>
                                        </ext:Column>
                                        <ext:Column            ID="DELI_DATE_1" ItemID="DELI_DATE" runat="server" DataIndex="DELI_DATE" Width="90"  Align="center" />
                                        <ext:Column            ID="DELI_CNT_1" ItemID="DELI_CNT" runat="server" DataIndex="DELI_CNT" Width="80"  Align="center"  />
                                        <ext:Column            ID="DELI_NOTE_1" ItemID="DELI_NOTE" runat="server" DataIndex="DELI_NOTE" Width="130"  Align="center" />
                                        <ext:NumberColumn      ID="DELI_QTY_1"        ItemID="DELI_QTY"         runat="server" DataIndex="DELI_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                        <ext:NumberColumn      ID="OK_QTY_1"        ItemID="OK_QTY"         runat="server" DataIndex="OK_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                        <ext:NumberColumn      ID="DEF_QTY_1"        ItemID="DEF_QTY"         runat="server" DataIndex="DEF_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                    </Columns>
                                </ext:Column>                                
                                <%--<ext:Column            ID="MOVE_CODE_1" ItemID="MOVE_CODE" runat="server" DataIndex="MOVE_CODE" Width="70"  Align="center" />--%>
                                
                                <ext:Column            ID="CANCELNO_1" ItemID="CANCELNO" runat="server" DataIndex="CANCELNO" Width="120"  Align="center" />
                                <ext:Column ID="INVOICE_NO_1" ItemID="INVOICE_NO" runat="server" DataIndex="INVOICE_NO" Width="100" Align="Center"  Text="Vendor Invoice"/><%--Text="Vendor Invoice"--%>
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">                                
                                <GetRowClass Fn="getRowClass2" />
                            </ext:GridView>
                        </View>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single"/>
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
