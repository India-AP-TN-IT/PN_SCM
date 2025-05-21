<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM32004.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM32004" %>
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
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
	    .x-grid-cell-VEND_LOTNO DIV,
	    .x-grid-cell-CHANGE_4M DIV,
	    .x-grid-cell-PRDT_DATE DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }

    </style>

    <!--그리드 필수 입력필드-->
    <style type="text/css">
        #PRDT_DATE
        {
            background: url(../../images/common/point_icon.png) right 10px no-repeat;
        }
    </style>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        //        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        //        그리드 스크롤바 있을 때, 포커스 막 이동시 스크롤이 맨앞으로 갔다가 다시 돌아오면서 화면에 잔상 남는 부분때문에 추가
        //        ---------------------------------------------------------------------------------------------------------------------------------------------------*/


        Ext.override(Ext.view.Table,
        {
            focusRow: function (rowIdx) {
                var me = this,
                    row,
                    gridCollapsed = me.ownerCt && me.ownerCt.collapsed,
                    record;
                if (me.isVisible(true) && !gridCollapsed && (row = me.getNode(rowIdx, true)) && me.el) {

                    record = me.getRecord(row);
                    rowIdx = me.indexInStore(row);

                    me.selModel.setLastFocused(record);
                    if (!Ext.isIE) {
                        row.focus();
                    }

                    me.focusedRow = row;
                    me.fireEvent('rowfocus', record, row, rowIdx);
                }
            }
        }
        );

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight() - 3);
            App.Grid02.setHeight(App.GridPanel.getHeight() - App.InputPanel.getHeight() - 14);
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
            var CtlPopup = Ext.getCmp("HELP_XM20002P1");
            CtlPopup.hide();
                        
            var grid = App.Grid02;

            grid.store.insert(0, record);
            grid.store.getAt(0).data["CHECK_VALUE"] = true;
            grid.store.getAt(0).dirty = true;

            grid.view.refresh();                        
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
    
            var grid = grid.ownerCt;

            var deli_note = grid.getStore().getAt(rowIndex).data["DELI_NOTE"];
            var deli_note_seq = grid.getStore().getAt(rowIndex).data["DELI_CNT"];

            App.direct.Cell_DoubleClick(deli_note, deli_note_seq);
        }

        var BeforeEdit = function (rowEditor, e) {
            //console.log(rowEditor, e);
            currentCellObject = e;
        }

        var AfterEdit = function (rowEditor, e) {
            var grid = App.Grid01;
            if (e.column.dataIndex == "VEND_LOTNO") {
                var check = /^[A-Za-z0-9]*$/;
                var vendLotNo = e.grid.getStore().getAt(e.rowIdx).data["VEND_LOTNO"];

                if (!check.test(vendLotNo)) {
                    //업체 Lot No는 영어,숫자로만 구성되어야 합니다
                    App.direct.MsgCodeAlert('SRMMM-0026');
                    e.grid.getStore().getAt(e.rowIdx).set("VEND_LOTNO", '');
                    return false;
                }
            }
        }

        var ctrlV_KeyDown = function (control, a, b, c) {
            var ctrlV = control.rawValue.split(' ');
            var length = ctrlV.length;

            if (length == 1) return;

            var columnName = control.ownerCt.name;
            var grd = control.ownerCt.grid;

            for (i = 0; i < length; i++) {
                if (grd.getStore().getAt(currentCellObject.rowIdx + i)) {

                    switch (columnName) {
                        case 'VEND_LOTNO':
                            var check = /^[A-Za-z0-9]*$/;
                            if (!check.test(ctrlV[i])) ctrlV[i] = '';
                            break;
                    }
                    if (i == 0) control.setValue(ctrlV[i]);
                    else grd.getStore().getAt(currentCellObject.rowIdx + i).set(columnName, ctrlV[i]);
                }
            }
        }

        var specialKey_KeyDown = function (o, e) {
            var grd = o.ownerCt.grid;
            test = grd;

            var colName = currentCellObject.grid.columns[currentCellObject.colIdx].dataIndex;
            var offset = 0;

            for (var i = 0; grd.columns.length; i++) {
                if (grd.columns[i].dataIndex == colName) {

                    offset = i;
                    break;
                }
            };

            if (e.getKey() === 40) {
                grd.editingPlugin.startEdit(currentCellObject.rowIdx + 1, offset); // DOwn
            }
            else if (e.getKey() === 38) {
                grd.editingPlugin.startEdit(currentCellObject.rowIdx - 1, offset); // Up
            }
        }
             
    </script>
</head>
<body>
    <form id="SRM_MM32004" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM32004" runat="server" Cls="search_area_title_name" />
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
                                </ext:SelectBox>
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
                               <ext:Label ID="lbl01_STR_LOC" runat="server" />
                            </th>
                            <td>                                                                                                 
                                <epc:EPCodeBox ID="cdx01_STR_LOC" runat="server" HelperID="HELP_STR_LOC" PopupMode="Search" PopupType="HelpWindow" 
                                    WidthTYPECD="60"/>    
                            </td>                            

                            <th class="ess">         
                                <ext:Label ID="lbl01_DELI_DATE" runat="server" />
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
                                <ext:Label ID="lbl01_DELI_NOTE2" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_DELI_NOTE" Width="150" Cls="inputText" runat="server" />    
                            </td>
                            <td colspan="2">
                                <ext:FieldContainer ID="FieldContainer3" runat="server" Width="300" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                <Items>
                                    <ext:Button ID="btn01_PART_PRINT" runat="server" MarginSpec="0px 10px 0px 0px" TextAlign="Center">
                                        <DirectEvents>
                                            <Click OnEvent="etc_Button_Click" >
                                            </Click>
                                        </DirectEvents>
                                    </ext:Button>
                                    <ext:Button ID="btn01_SEL_PRINT" runat="server" Text="Print Selected Tags"  MarginSpec="0px 10px 0px 0px" TextAlign="Center">
                                        <DirectEvents>
                                            <Click OnEvent="etc_Button_Click" >
                                                <ExtraParams> 
                                                    <ext:Parameter Mode="Raw" Encode="true" Name="Values" Value="App.Grid02.getRowsValues({dirtyRowsOnly:true})" />
                                                </ExtraParams>
                                            </Click>
                                        </DirectEvents>
                                    </ext:Button>
                                </Items>
                                </ext:FieldContainer>
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ContentPanel" runat="server" Region="Center" Layout="BorderLayout">
                <Items>
                    <ext:Panel ID="GridPanel" Region="West" Width="640" Border="True" runat="server" Cls="grid_area">
                        <Items>
                            <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store1" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="GridModel1" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="NO" />
                                                    <ext:ModelField Name="DELI_DATE"/>
                                                    <ext:ModelField Name="DELI_CNT"/>
                                                    <ext:ModelField Name="DELI_NOTE"/>
                                                    <ext:ModelField Name="NATIONCD"/>
                                                    <ext:ModelField Name="NATIONNM"/>
                                                    <ext:ModelField Name="CUSTCD"/>
                                                    <ext:ModelField Name="CUSTNM"/>
                                                    <ext:ModelField Name="SUM_CUSTCD"/>
                                                    <ext:ModelField Name="BOX_COUNT"/>
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
                                        <ext:Column ID ="Column1" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                            <Renderer Fn="rendererNo" />
                                        </ext:Column>
                                        <ext:Column ID="DELI_DATE" ItemID="DELI_DATE" runat="server" DataIndex="DELI_DATE" Width="70" Align="Center"/> <%--Text="납품일자"--%>
                                        <ext:Column ID="DELI_CNT" ItemID="DELI_CNT" runat="server" DataIndex="DELI_CNT" Width="60" Align="Center"/> <%--Text="납품차수"--%>
                                        <ext:Column ID="DELI_NOTE" ItemID="DELI_NOTE" runat="server" DataIndex="DELI_NOTE" Width="130" Align="Center"/> <%--Text="납품전표"--%>
                                        <ext:Column ID="NATIONNM" ItemID="NATIONNM" runat="server" DataIndex="NATIONNM" Width="80" Align="Center"/> <%--Text="국가"--%>
                                        <ext:Column ID="CUSTNM" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="100" Align="Left" Flex="1"/> <%--Text="고객사"--%>
                                        <ext:Column ID="SUM_CUSTCD" ItemID="SUM_CUSTCD" runat="server" DataIndex="SUM_CUSTCD" Width="80" Align="Center"/> <%--Text="식별코드"--%>
                                        <ext:Column ID="BOX_COUNT" ItemID="BOX_COUNT" runat="server" DataIndex="BOX_COUNT" Width="60" Align="Center" Text="Boxes" />
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
                                <Listeners>
                                        <CellClick Fn ="CellDbClick"></CellClick>
                                        <%--<CellDblClick Fn ="CellDbClick"></CellDblClick>--%>
                                </Listeners>                        
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                </BottomBar>
                            </ext:GridPanel>
                        </Items>
                    </ext:Panel>
                    <ext:Panel ID="MarginPanel" runat="server" Region="West" Width="10px">
                        <Items></Items>
                    </ext:Panel>
                    <ext:Panel runat="server" Region="Center">
                        <Items>
                            <ext:Panel ID="InputPanel" runat="server" Cls="bottom_area_table" StyleSpec="margin-top:0; margin-bottom:10px;">
                                <Content>
                                <table>
                                <colgroup>
                                    <col style="width: 130px;" /> 
                                    <col style="width: 210px;" />
                                    <col style="width: 130px;" /> 
                                    <col style="width: 100px;" /> 
                                    <col style="width: 100px;" /> 
                                    <col style="width: 100px;" /> 
                                    <col />
                                </colgroup>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_DELI_NOTE" runat="server" />
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_DELI_NOTE" runat="server" Width="150" ReadOnly="true" />
                                        </td>   
                                        <th>
                                            <ext:Label ID="lbl02_DELI_CNT" runat="server" />
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_DELI_CNT" runat="server" Width="70" ReadOnly="true" />
                                        </td>   
                                        <th>
                                            <ext:Label ID="lbl02_TAG_SIZE" runat="server" Text="TAG SIZE"/>
                                        </th>
                                        <td>
                                            <ext:SelectBox ID="cbo01_PRINT_SIZE" runat="server"  Mode="Local" ForceSelection="true"
                                                DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="100">
                                                <Store>
                                                    <ext:Store ID="Store43" runat="server" >
                                                        <Model>
                                                            <ext:Model ID="Model43" runat="server">
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
                                        <td>
                                            <ext:FieldContainer ID="FieldContainer1" runat="server" Width="300" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                                <Items>

                                                    <ext:RadioGroup ID="RadioGroup2" runat="server" Width="190" Cls="inputText" ColumnsWidths="80,80">
                                                        <Items>
                                                            <ext:Radio ID="rdo01_SET_1ST" Cls="inputText" runat="server" InputValue="1" Checked="true" />
                                                            <ext:Radio ID="rdo01_SET_2ST" Cls="inputText" runat="server" InputValue="2" />
                                                        </Items>
                                                    </ext:RadioGroup>

                                                </Items>
                                            </ext:FieldContainer>
                                        </td>
                                    </tr>                                                                      
                                </table>
                                </Content>
                            </ext:Panel>
                            <ext:Panel ID="GridPanel2" Region="Center" Border="True" runat="server" Cls="grid_area">
                                <Items>                                                
                                    <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                        <Store>
                                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="GridModel2" runat="server" Name ="ModelGrid">
                                                        <Fields>
                                                            <ext:ModelField Name="NO" /> 
                                                            <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>       
                                                            <ext:ModelField Name="PONO" />
                                                            <ext:ModelField Name="PARTNO"/>
                                                            <ext:ModelField Name="PARTNM"/>
                                                            <ext:ModelField Name="BOX_BARCODE"/>
                                                            <ext:ModelField Name="BOX_SEQ"/>
                                                            <ext:ModelField Name="QTY"/>
                                                            <ext:ModelField Name="PO_UNIT"/>
                                                            <ext:ModelField Name="PRDT_DATE"/>
                                                            <ext:ModelField Name="VEND_LOTNO"/>
                                                            <ext:ModelField Name="CUST_PONO"/>
                                                            <ext:ModelField Name="SD_PONO"/>
                                                            <ext:ModelField Name="CHANGE_4M"/>
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
                                            <ext:BufferedRenderer ID="BufferedRenderer3"  runat="server"/>
                                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                                <Listeners>                                    
                                                    <BeforeEdit fn="BeforeEdit" />
                                                    <Edit fn ="AfterEdit" />
                                                </Listeners>
                                            </ext:CellEditing>
                                        </Plugins>  
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ID ="D_NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                                    <Renderer Fn="rendererNo" />
                                                </ext:Column>
                                                <ext:CheckColumn runat="server" ID ="D_CHECK" Text=""  DataIndex="CHECK_VALUE" Width="35" 
                                                                 StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true" HeaderCheckbox="true">
                                        
                                                </ext:CheckColumn>   
                                                <ext:Column ID="D_PONO" ItemID="PONO" runat="server" DataIndex="PONO" Width="90" Align="Center" /><%--Text="발주번호"--%>  
                                                <ext:Column ID="D_PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="품번"--%>  
                                                <ext:Column ID="D_PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="170" Align="Left" /><%--Text="품명"--%>  
                                                <ext:Column ID="D_BOX_BARCODE" ItemID="BOX_BARCODE" runat="server" DataIndex="BOX_BARCODE" Width="140" Align="Center" /><%--Text="박스ID"--%>  
                                                <ext:Column ID="D_BOX_SEQ" ItemID="BOX_SEQ" runat="server" DataIndex="BOX_SEQ" Width="60" Align="Center" /><%--Text="순번"--%>  
                                                <ext:NumberColumn ID="D_QTY" ItemID="QTY" runat="server" DataIndex="QTY" Width="70" Align="Right" Format="#,##0.###" /><%--Text="수량"--%>  
                                                <ext:Column ID="D_PO_UNIT" ItemID="UNIT" runat="server" DataIndex="PO_UNIT" Width="60" Align="Center" /><%--Text="단위"--%>  
                                                <%--<ext:Column ID="D_PRDT_DATE" ItemID="PRDT_DATE" runat="server" DataIndex="PRDT_DATE" Hidden="false" Width="90" Align="Center" />--%><%--Text="제조일자"--%>  
                                                <ext:DateColumn ID="PRDT_DATE" ItemID="PRDT_DATE" runat="server" Hidden="true" DataIndex="PRDT_DATE" Width="90" Align="Center" Sortable="true"><%--Text="제조일자"--%>
                                                    <Editor>
                                                        <ext:DateField ID="txt02_PRDT_DATE" runat="server" SelectOnFocus="true">
                                                            <Listeners>
                                                                <SpecialKey Fn="specialKey_KeyDown"></SpecialKey>
                                                            </Listeners>
                                                        </ext:DateField>
                                                    </Editor>
                                                </ext:DateColumn>
                                                <%--<ext:Column ID="D_VEND_LOTNO" ItemID="VEND_LOTNO" runat="server" DataIndex="VEND_LOTNO" Hidden="false" Width="90" Align="Center" />--%><%--Text="LOTNO"--%>  
                                                <ext:Column ID="D_VEND_LOTNO" ItemID="VEND_LOTNO" runat="server" Hidden="false" DataIndex="VEND_LOTNO" Width="100" Align="Left" Sortable="true"><%--Text="업체LOT NO"--%> 
                                                    <Editor>
                                                        <ext:TextField  ID="txt02_VEND_LOTNO" Cls="inputText" FieldCls="inputText" SelectOnFocus="true" runat="server" Height="22">
                                                            <Listeners>
                                                                <SpecialKey Fn="specialKey_KeyDown"></SpecialKey>
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ID="D_CUST_PONO" ItemID="CUST_PONO" runat="server" DataIndex="CUST_PONO" Hidden="true" Width="90" Align="Center" /><%--Text="고객PONO"--%>  
                                                <ext:Column ID="D_SD_PONO" ItemID="SD_PONO" runat="server" DataIndex="SD_PONO" Width="90" Hidden="true" Align="Center" /><%--Text="영업SONO"--%>  
                                                <%--<ext:Column ID="D_CHANGE_4M" ItemID="CHANGE_4M" runat="server" DataIndex="CHANGE_4M" Hidden="false" Width="150" Align="Left" />--%><%--Text="4M변경내역"--%> 
                                                <ext:Column ID="D_CHANGE_4M" ItemID="CHANGE_4M" runat="server" Hidden="true"  DataIndex="CHANGE_4M" Width="130" Align="Left" Sortable="true"><%--Text="4M변경내역"--%> 
                                                    <Editor>
                                                        <ext:TextField  ID="txt02_CHANGE_4M" Cls="inputText" FieldCls="inputText" SelectOnFocus="true" runat="server" Height="22">
                                                            <Listeners>
                                                                <SpecialKey Fn="specialKey_KeyDown"></SpecialKey>
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Editor>
                                                </ext:Column>
                                            </Columns>
                                            <Listeners>
                                                <%--<HeaderClick Fn="onSelectionCheckHeaderChange" />--%> <%--그리드 헤더의 체크박스를 클릭할 경우 발생--%>
                                            </Listeners>
                                        </ColumnModel>
                                        <Loader ID="Loader3" runat="server" AutoLoad="false" Mode="Data">
                                            <LoadMask ShowMask="true" />
                                        </Loader>
                                        <View>
                                            <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true"/>
                                        </View>
                                        <%-- SelectionModel은 checkbox, cell, row가 존재하고 그리드를 클릭시 그리드의 선택된 행의값이 json형태로 넘어감 (EP20S01참고)--%>
                                        <SelectionModel>
                                        </SelectionModel>                   
                                        <BottomBar>
                                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                            <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                        </BottomBar>
                                    </ext:GridPanel>
                                </Items>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>               
                </Items>
            </ext:Panel>     
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
