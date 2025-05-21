<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM32001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM32001" %>
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
        
        .search_area_table table th.combo
        {
            height:30px;
            color:#393c45;
            text-align:left;
            font-weight:normal;
            padding-left:7px;
            border-bottom:1px solid #b1b1b1;            
            padding-right:0px;
            background:#e7eef4 url(../../images/common/point_icon.png) right 10px no-repeat;
        }
        
	    .x-grid-cell-CODE DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }	    
	    /*.x-grid-row-selected .x-grid-td {background: lightblue;color:black !important;}*/
        .font-color-red .x-grid-cell-PO_DELI_DATE
        {
            color:#FF0000;
        }
        .font-color-black .x-grid-cell-PO_DELI_DATE
        {
            color:#000000;
        }
        
        .font-color-red_all 
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

        var template = '<span style="color:{0}; font-weight:bold;font-size:15px;">{1}</span>';
        var template1 = '<span style="color:{0}; font-weight:normal;font-size:12px;">{1}</span>';

        //상세
        // 납기일자<=오늘 일 시, 빨간색
        var getRowClass = function (record, rowIndex, rowParams, store) {
            var poDeliDate = record.data['PO_DELI_DATE'];
            var today = document.getElementById('Today-inputEl').value;
            var po_qty = record.data['PO_QTY'];

            if (po_qty < 0) return 'font-color-red_all';
            else if (poDeliDate > today) return 'font-color-black';            
            else return 'font-color-red';
        }

        //집계
        var getRowClass2 = function (record, rowIndex, rowParams, store) {
            var po_qty = record.data['PO_QTY'];
            if (po_qty >= 0) return 'font-color-black';
            else return 'font-color-red_all';
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
//        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {            
//            App.direct.MakePopUp(grid.getStore().getAt(rowIndex).data["MAIN_PARTNO"], "V", grid.getStore().getAt(rowIndex).data["REG_DATE"]);
//        }

        var linkRenderer = function (value, meta, record, index, cellIndex) {
            var param = "Ext.getStore('" + record.store.storeId + "')";
            // 숫자면 콤마붙이기
            value = isNaN(value) ? value : numberWithCommas(value);
            return Ext.String.format("<a style='color:blue;text-decoration:underline;' href='#' onclick=\"linkClick({0},{1},{2});\">{3}</a>", param, index, cellIndex, value);
        };

        var linkClick = function (store, rowIndex, cellIndex) {
            // storeId : Store1 (집계) / Store3 (상세)
            // 그리드 : Grid01(집계) / Grid02(상세)
            if (store.storeId == 'Store1') {
                // 집계
                // 발주량:PO_QTY / 납품수량:DELI_QTY / 입하수량:GRN_QTY
                //var columnName = App.Grid01.columnManager.secondHeaderCt.columnManager.columns[cellIndex].id;
                var columnName = App.Grid01.columns[cellIndex].id;
                var type = '';

                switch (columnName) {
                    case 'PO_QTY': type = 'O'; break;
                    case 'DELI_QTY': type = 'S'; break;
                    case 'GRN_QTY': type = 'I'; break;
                }

                var param1 = new Array(store.getAt(rowIndex).data["PURC_ORG"], store.getAt(rowIndex).data["PURC_PO_TYPE"], store.getAt(rowIndex).data["VINCD"], store.getAt(rowIndex).data["PARTNO"], store.getAt(rowIndex).data["PARTNM"], store.getAt(rowIndex).data["UNITNM"], store.getAt(rowIndex).data["PURC_GRP"], store.getAt(rowIndex).data["VENDCD"], store.getAt(rowIndex).data["CUSTCD"]);
                App.direct.MakePopUp(param1, type);
            } else {
                // 상세
                // 발주번호:PONO_1 / 입하수량:GRN_QTY_1
                var leftColumns = App.Grid01.columns; // App.Grid02.columnManager.headerCt.columnManager.columns;
                var rightColumns = App.Grid02.columns;// App.Grid02.columnManager.secondHeaderCt.columnManager.columns;
                var columnName = '';
                var type = '';

                if (cellIndex > leftColumns.length) {
                    columnName = rightColumns[cellIndex].id;
                }
                else {
                    columnName = leftColumns[cellIndex].id;
                }

                switch (columnName) {
                    case 'PONO_1': type = 'D'; break;
                    case 'GRN_QTY_1': type = 'M'; break;
                }

                var param2 = new Array(store.getAt(rowIndex).data["PONO"], store.getAt(rowIndex).data["PARTNO"], store.getAt(rowIndex).data["PARTNM"], store.getAt(rowIndex).data["UNITNM"], store.getAt(rowIndex).data["RCVNO"], store.getAt(rowIndex).data["VENDCD"], store.getAt(rowIndex).data["PURC_ORG"], store.getAt(rowIndex).data["PURC_PO_TYPE"], store.getAt(rowIndex).data["PURC_GRP"], store.getAt(rowIndex).data["CUSTCD"]);
                App.direct.MakePopUp(param2, type);
            }
        };

        function numberWithCommas(x) {
            var parts = x.toString().split(".");
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            return parts.join(".");
        }
          
    </script>

</head>
<body>
    <form id="SRM_MM32001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:TextField ID="Today" runat="server" Hidden="true" Text=""></ext:TextField> 
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MM32001" runat="server" Cls="search_area_title_name" />
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
                            <th class="combo">
                                <%--<ext:Label ID="lbl01_PO_DELI_DATE" runat="server" />--%>
                                 <ext:SelectBox ID="cbo01_DATE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="90">
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
                                    <DirectEvents>
                                        <Change OnEvent="changeCondition_Date" />
                                    </DirectEvents>
                                </ext:SelectBox>
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
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" />
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
                                    <DirectEvents>
                                        <Change OnEvent="changeCondition" />
                                    </DirectEvents>
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
                            <th >
                                <ext:Label ID="lbl01_SEARCH_OPT" runat="server" />
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
                                <ext:Label ID="lbl01_PONO_PER" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_PONO" Width="150" Cls="inputText" runat="server" />    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_DELI_NOTE2" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_DELI_NOTE" Width="150" Cls="inputText" runat="server" />    
                            </td>                            
                            <th>
                               <ext:Label ID="lbl01_CUSTNM" runat="server" />
                            </th>
                            <td colspan="3">
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD" PopupMode="Search" PopupType="HelpWindow"/>    
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
                                            <ext:ModelField Name="PO_QTY" />

                                            <ext:ModelField Name="DELI_QTY" />
                                            <ext:ModelField Name="UNDELI_QTY" />
                                            
                                            <ext:ModelField Name="GRN_QTY" />
                                            <ext:ModelField Name="OK_QTY" />
                                            <ext:ModelField Name="NG_QTY" />
                                            <ext:ModelField Name="NOT_GRN_QTY" />

                                            <ext:ModelField Name="PAY_YN_DIV" />
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />

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
                                <ext:Column            ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="100"  Align="Left" />
                                <ext:Column            ID="PURC_ORGNM" ItemID="PURC_ORGNM" runat="server" DataIndex="PURC_ORGNM" Width="70"  Align="center"  />
                                <ext:Column            ID="PURC_PO_TYPENM" ItemID="PURC_PO_TYPENM" runat="server" DataIndex="PURC_PO_TYPENM" Width="90"  Align="left" />
                                <ext:Column            ID="PURC_GRPNM" ItemID="PURC_GRPNM" runat="server" DataIndex="PURC_GRPNM" Width="70"  Align="left" />
                                <ext:Column            ID="VINNM" ItemID="VIN" runat="server" DataIndex="VINNM" Width="70"  Align="center" />
                                <ext:Column            ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120"  Align="Left"  />
                                <ext:Column            ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="170"  Align="Left" />
                                <ext:Column            ID="UNITNM" ItemID="UNIT" runat="server" DataIndex="UNITNM" Width="60"  Align="center" />                                        
                                <ext:NumberColumn      ID="PO_QTY"         ItemID="PO_QTY"         runat="server" DataIndex="PO_QTY"    Width="80"  Align="Right"  Format="#,##0.###" >
                                    <Renderer Fn="linkRenderer"/>
                                </ext:NumberColumn>
                                <ext:Column ID="DELI_INFO" ItemID="DELI_INFO" runat="server" >
                                    <Columns>
                                    <ext:NumberColumn      ID="DELI_QTY"         ItemID="DELI_QTY"         runat="server" DataIndex="DELI_QTY"    Width="80"  Align="Right"  Format="#,##0.###" >
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="UNDELI_QTY"         ItemID="UNDELI_QTY"         runat="server" DataIndex="UNDELI_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="RCV_INFO" ItemID="ARRIVE_INFO" runat="server" >
                                    <Columns>
                                    <ext:NumberColumn      ID="GRN_QTY"         ItemID="ARRIV_QTY"         runat="server" DataIndex="GRN_QTY"    Width="80"  Align="Right"  Format="#,##0.###" >
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="OK_QTY"         ItemID="OK_QTY"         runat="server" DataIndex="OK_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                    <ext:NumberColumn      ID="NG_QTY"         ItemID="DEF_QTY"         runat="server" DataIndex="NG_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                    <ext:NumberColumn      ID="NOT_GRN_QTY"         ItemID="NOT_GRN_QTY"         runat="server" DataIndex="NOT_GRN_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                    </Columns>
                                </ext:Column>
                                <ext:Column            ID="PAY_YN_DIV" ItemID="UMSON" runat="server" DataIndex="PAY_YN_DIV" Width="80"  Align="center" />
                                <ext:Column            ID="CUSTNM" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="150"  Align="left" />
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true">                                
                                <GetRowClass Fn="getRowClass2" />
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
                                            <ext:ModelField Name="PO_DELI_DATE" /><ext:ModelField Name="PO_DATE" /><ext:ModelField Name="PONO" />  
                                            <ext:ModelField Name="VINCD" /><ext:ModelField Name="VINNM" /><ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" /><ext:ModelField Name="STR_LOC" /><ext:ModelField Name="STR_LOCNM" />
                                            <ext:ModelField Name="UNIT" /><ext:ModelField Name="UNITNM" /><ext:ModelField Name="UNIT_PACK_QTY_SIM" />                                             
                                            <ext:ModelField Name="PO_QTY" /><ext:ModelField Name="DELI_DATE" /><ext:ModelField Name="DELI_CNT" /> 
                                            <ext:ModelField Name="DELI_QTY" /><ext:ModelField Name="BOX_QTY" /><ext:ModelField Name="DELI_NOTE" /> 
                                            <ext:ModelField Name="RCV_DATE" /><ext:ModelField Name="GRN_QTY" /><ext:ModelField Name="OK_QTY" /> 
                                            <ext:ModelField Name="DEF_QTY" /><ext:ModelField Name="NOT_GRN_QTY" /><ext:ModelField Name="RCV_DIV" /> 
                                            <ext:ModelField Name="RCVNO" /><ext:ModelField Name="RCV_INFO" /><ext:ModelField Name="PURC_ORG" /> 
                                            <ext:ModelField Name="PURC_ORGNM" /><ext:ModelField Name="PURC_PO_TYPE" /><ext:ModelField Name="PURC_PO_TYPENM" />  
                                            <ext:ModelField Name="PURC_GRP" /><ext:ModelField Name="CUSTNM" /><ext:ModelField Name="PMI" />
                                            <ext:ModelField Name="SD_PONO" /><ext:ModelField Name="FTA_CERTI" /><ext:ModelField Name="PAY_YN_DIV" />
                                            <ext:ModelField Name="PURC_GRPNM" /><ext:ModelField Name="DELI_TYPE" /><ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" /><ext:ModelField Name="CUSTCD" /><ext:ModelField Name="CUST_PONO" /><ext:ModelField Name="ELIKZ" />
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
                                <ext:Column            ID="PO_DELI_DATE_1" ItemID="PO_DELI_DATE" runat="server" DataIndex="PO_DELI_DATE" Width="80"  Align="center"  />
                                <ext:Column            ID="PO_DATE_1" ItemID="PO_DATE" runat="server" DataIndex="PO_DATE" Width="80"  Align="center"  />
                                <ext:Column            ID="PONO_1" ItemID="PONO" runat="server" DataIndex="PONO" Width="110"  Align="center"  >
                                     <Renderer Fn="linkRenderer"/>
                                </ext:Column>
                                <ext:Column            ID="VINNM_1" ItemID="VIN" runat="server" DataIndex="VINNM" Width="70"  Align="center" />
                                <ext:Column            ID="PARTNO_1" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120"  Align="left" />
                                <ext:Column            ID="PARTNM_1" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="170"  Align="left" />
                                
                                <ext:Column            ID="STR_LOCNM_1" ItemID="STR_LOCNM" runat="server" DataIndex="STR_LOCNM" Width="80"  Align="left"/>
                                <ext:Column            ID="UNITNM_1" ItemID="UNIT" runat="server" DataIndex="UNITNM" Width="60"  Align="center" />
                                <ext:NumberColumn      ID="UNIT_PACK_QTY_SIM_1"        ItemID="UNIT_PACK_QTY_SIM"         runat="server" DataIndex="UNIT_PACK_QTY_SIM"    Width="80"  Align="Right"  Format="#,##0.###" />
                                <ext:NumberColumn      ID="PO_QTY_1"        ItemID="PO_QTY"         runat="server" DataIndex="PO_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />                                
                                <ext:Column ID="ELIKZ" ItemID="DELI_CMP_CHK" runat="server" DataIndex="ELIKZ" Width="80" Align="Center"/><%--Text="납품종료"--%>
                                <ext:Column ID="DELI_INFO_1" ItemID="DELI_INFO" runat="server" >
                                    <Columns>
                                    <ext:Column            ID="DELI_DATE_1" ItemID="DELI_DATE" runat="server" DataIndex="DELI_DATE" Width="80"  Align="center" />
                                    <ext:Column            ID="DELI_CNT_1" ItemID="DELI_CNT" runat="server" DataIndex="DELI_CNT" Width="60"  Align="center"  />
                                    <ext:NumberColumn      ID="DELI_QTY_1"        ItemID="DELI_QTY"         runat="server" DataIndex="DELI_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                    <ext:NumberColumn      ID="BOX_QTY_1"        ItemID="BOX_QTY"         runat="server" DataIndex="BOX_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                    <ext:Column            ID="DELI_NOTE_1" ItemID="DELI_NOTE" runat="server" DataIndex="DELI_NOTE" Width="130"  Align="center" />
                                    <ext:Column            ID="DELI_TYPE_1" ItemID="DELI_TYPE" runat="server" DataIndex="DELI_TYPE" Width="80"  Align="center" />
                                    </Columns>                                
                                </ext:Column>
                                
                                <ext:Column ID="RCV_INFO_1" ItemID="ARRIVE_INFO" runat="server" >
                                    <Columns>
                                    <ext:Column            ID="RCV_DATE_1" ItemID="ARRIVE_DATE" runat="server" DataIndex="RCV_DATE" Width="80"  Align="center" />
                                    <ext:NumberColumn      ID="GRN_QTY_1"        ItemID="ARRIV_QTY"         runat="server" DataIndex="GRN_QTY"    Width="80"  Align="Right"  Format="#,##0.###" >
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="OK_QTY_1"        ItemID="OK_QTY"         runat="server" DataIndex="OK_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                    <ext:NumberColumn      ID="DEF_QTY_1"        ItemID="DEF_QTY"         runat="server" DataIndex="DEF_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                    <ext:NumberColumn      ID="NOT_GRN_QTY_1"        ItemID="NOT_GRN_QTY"         runat="server" DataIndex="NOT_GRN_QTY"    Width="80"  Align="Right"  Format="#,##0.###" />
                                    <ext:Column            ID="RCV_DIV_1" ItemID="RCV_DIV" runat="server" DataIndex="RCV_DIV" Width="80"  Align="center" />
                                    <ext:Column            ID="RCVNO_1" ItemID="ARRIVENO" runat="server" DataIndex="RCVNO" Width="130"  Align="center" />                                    
                                    </Columns>
                                </ext:Column>
                                <ext:Column            ID="PURC_ORGNM_1" ItemID="PURC_ORGNM" runat="server" DataIndex="PURC_ORGNM" Width="70"  Align="center" />
                                <ext:Column            ID="PURC_PO_TYPENM_1" ItemID="PURC_PO_TYPENM" runat="server" DataIndex="PURC_PO_TYPENM" Width="90"  Align="left" />
                                <ext:Column            ID="PURC_GRPNM_1" ItemID="PURC_GRPNM" runat="server" DataIndex="PURC_GRPNM" Width="70"  Align="left" />

                                <ext:Column ID="CUST_ORDER_INFO_1" ItemID="CUST_ORDER_INFO" runat="server" >
                                    <Columns>
                                    <ext:Column            ID="CUSTNM_1" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="100"  Align="left" />
                                    <ext:Column            ID="CUST_PONO_1" ItemID="CUST_PONO" runat="server" DataIndex="CUST_PONO" Width="110"  Align="left"/>
                                    <ext:Column            ID="PMI_1" ItemID="PMI" runat="server" DataIndex="PMI" Width="70"  Align="left" Hidden="true" />
                                    <ext:Column            ID="SD_PONO_1" ItemID="SD_PONO" runat="server" DataIndex="SD_PONO" Width="120"  Align="left" />
                                    </Columns>
                                </ext:Column>
                                
                                <ext:Column            ID="FTA_CERTI_1" ItemID="FTA_CERTI" runat="server" DataIndex="FTA_CERTI" Width="80"  Align="center" />
                                <ext:Column            ID="PAY_YN_DIV_1" ItemID="UMSON" runat="server" DataIndex="PAY_YN_DIV" Width="80"  Align="center" />

                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">                                
                                <GetRowClass Fn="getRowClass" />
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
