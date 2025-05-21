<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM26007.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM26007" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" >
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
	    /*.edit-row*/ .x-grid-cell-UNIT DIV,
	    /*.edit-row*/ .x-grid-cell-CLS_QTY DIV
	    {
	        border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
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
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }
        //체크컬럼 전용 4.x
        var BeforeCheckChange = function (column, rowIndex, record, eOpts) {
            console.log(column.id);

            var vend_ok = record.get('VEND_OK');
            var cust_ok = record.get('CUST_OK');
            var purc_ok = record.get('PURC_OK_DATE');
            var process_ok = record.get('PURC_CON_DATE');            

            if (vend_ok != "Y" && (column.id == "PURC_OK" || column.id == "PROCESS_OK")) {
                App.direct.MsgCodeAlert('SRMMM-0044'); //공급처에서 확인하지 않아 수정할 수 없습니다.
                return false;
            }

            if (cust_ok != "Y" && (column.id == "PURC_OK" || column.id == "PROCESS_OK")) {
                App.direct.MsgCodeAlert('SRMMM-0050'); //수요처에서 확인하지 않아 수정할 수 없습니다.
                return false;
            }

            if (purc_ok.length > 0 && column.id == "RESALE_QTY") {
                App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
                return false;
            }

            if (purc_ok.length == 0 && (column.id == "PROCESS_OK")) {
                App.direct.MsgCodeAlert('SRMMM-0052'); //서연이화 확인 후 처리가 가능합니다.
                return false;
            }

            if (process_ok.length > 0 && (column.id == "PURC_OK" || column.id == "PROCESS_OK")) {
                App.direct.MsgCodeAlert('COM-00203'); //이미 프로세스가 진행된 건입니다. 변경이 불가합니다.!!!
                return false;
            }
        }

        //체크컬럼은 동작하지 않음 4.x
        var BeforeEdit = function (rowEditor, e) {
            
            var vend_ok = e.grid.getStore().getAt(e.rowIdx).data["VEND_OK"];
            var cust_ok = e.grid.getStore().getAt(e.rowIdx).data["CUST_OK"];
            var purc_ok = e.grid.getStore().getAt(e.rowIdx).data["PURC_OK_DATE"];
            var process_ok = e.grid.getStore().getAt(e.rowIdx).data["PURC_CON_DATE"];
            if (vend_ok != "Y" && (e.column.dataIndex == "PURC_OK" || e.column.dataIndex == "PROCESS_OK")) {
                App.direct.MsgCodeAlert('SRMMM-0044'); //공급처에서 확인하지 않아 수정할 수 없습니다.
                return false;
            }

            if (cust_ok != "Y" && (e.column.dataIndex == "PURC_OK" || e.column.dataIndex == "PROCESS_OK")) {
                App.direct.MsgCodeAlert('SRMMM-0050'); //수요처에서 확인하지 않아 수정할 수 없습니다.
                return false;
            }

            /*
            if (purc_ok.length > 0 && (e.column.dataIndex == "UNIT" || e.column.dataIndex == "RESALE_QTY")) {
            App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
            return false;
            }
            */

            if (purc_ok.length > 0 && e.column.dataIndex == "RESALE_QTY") {
                App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
                return false;
            }

            if (purc_ok.length == 0 && (e.column.dataIndex == "PROCESS_OK")) {
                App.direct.MsgCodeAlert('SRMMM-0052'); //서연이화 확인 후 처리가 가능합니다.
                return false;
            }

            if (process_ok.length > 0 && (e.column.dataIndex == "PURC_OK" || e.column.dataIndex == "PROCESS_OK")) {
                App.direct.MsgCodeAlert('COM-00203'); //이미 프로세스가 진행된 건입니다. 변경이 불가합니다.!!!
                return false;
            }
        }
        //beforedit로 우선 변경
        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            var grid = selectionModel.view.ownerCt;
            //grid.editingPlugin.startEdit(rowIndex, colIndex);
            
            var purc_ok = grid.getStore().getAt(rowIndex).data["PURC_OK_DATE"];

            if (purc_ok.length > 0) {
                Ext.getCmp('cbo02_UNIT').disable();
            }
            else {
                Ext.getCmp('cbo02_UNIT').enable();
            }
        }

        var getRowClass = function (record) {
            return "edit-row";
        };

        var SelectionCheckChange = function () {
            var grid = App.Grid01;

            for (i = 0; i < grid.store.getTotalCount(); i++) {

                var vend_ok = grid.getStore().getAt(i).data["VEND_OK"];
                var cust_ok = grid.getStore().getAt(i).data["CUST_OK"];
                var process_ok = grid.getStore().getAt(i).data["PROCESS_OK"];

                if (vend_ok == "Y" && cust_ok == "Y" && process_ok != "Y") {
                    grid.store.getAt(i).data["PURC_OK"] = App.chk01_ALL_CHECK_YN.checked;
                    grid.store.getAt(i).dirty = App.chk01_ALL_CHECK_YN.checked;
                }
                grid.store.getAt(i).data["NO"] = i + 1; //2015-03-03 체크박스 체크할 때 "NO"에도 값 넣어줌. (renderer를 통해서 값이 들어가긴 하지만  buffered 특성상 화면에 displayed 되지 않았을 때는 값이 없는 경우 발생함)
            }
            grid.view.refresh();
        }

        var SelectionCheckChange2 = function () {
            var grid = App.Grid01;

            for (i = 0; i < grid.store.getTotalCount(); i++) {

                var purc_ok = grid.getStore().getAt(i).data["PURC_OK_DATE"];
                var process_ok = grid.getStore().getAt(i).data["PURC_CON_DATE"];

                if (purc_ok.length > 0 && process_ok.length == 0) {
                    grid.store.getAt(i).data["PROCESS_OK"] = App.chk02_ALL_CHECK_YN.checked;
                    grid.store.getAt(i).dirty = App.chk02_ALL_CHECK_YN.checked;
                }
                grid.store.getAt(i).data["NO"] = i + 1; //2015-03-03 체크박스 체크할 때 "NO"에도 값 넣어줌. (renderer를 통해서 값이 들어가긴 하지만  buffered 특성상 화면에 displayed 되지 않았을 때는 값이 없는 경우 발생함)
            }
            grid.view.refresh();
        }
    </script>
</head>
<body>
    <form id="SRM_MM26007" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM26007" runat="server" Cls="search_area_title_name" /><%--Text="사급 직납 마감 등록" />--%>
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
                            <col style="width: 200px;" />
                            <col style="width: 150px;" />
                            <col style="width: 200px;" />
                            <col style="width: 150px;" />
                            <col style="width: 200px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
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
                                    <DirectEvents>
                                        <Change OnEvent="changeCondition" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td>                            
                            <th class="ess">
                                <ext:Label ID="lbl01_STD_YYMM" runat="server" /><%--Text="기준년월" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_DATE" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true" >
                                    <DirectEvents>
                                        <Change OnEvent="changeCondition" />
                                    </DirectEvents>
                                </ext:DateField>
                            </td>
                            <%--
                            <th class="ess">
                                <ext:Label ID="lbl01_NORMAL_RTN" runat="server" />
                            </th>
                            <td>
                                <ext:RadioGroup ID="RadioGroup2" runat="server" Width="200" Cls="inputText" ColumnsWidths="100,100">
                                    <Items>
                                        <ext:Radio ID="rdo01_NORMAL" Cls="inputText" runat="server" InputValue="1" Checked="true" />
                                        <ext:Radio ID="rdo01_RTN" Cls="inputText" runat="server" InputValue="2" />
                                    </Items>       
                                    <Listeners>
                                        <Change Handler="App.direct.SetGridSetting(this.getChecked()[0].inputValue.toString());" Delay="500" />
                                    </Listeners>                             
                                </ext:RadioGroup>
                            </td>
                            --%><%--Text="정상/반품 구분" />--%>
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
                            <th>
                                <ext:Label ID="lbl01_NORMAL_RTN" runat="server" />
                            </th>
                            <td>                                
                                <ext:SelectBox ID="cbo01_NORMAL_RTN" runat="server"  Mode="Local" ForceSelection="true"
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
                        <tr>                            
                              
                            <th>
                                <ext:Label ID="lbl01_OPT11" runat="server"/>
                            </th>  
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD_FREE" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_OPT12" runat="server" />                                
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD_FIX" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>                                
                            </td> 
                             <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" />                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />    
                            </td>
                        </tr>    
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_PURC_OK" runat="server" /><%--서연이화 확인--%>
                            </th>
                            <td colspan="3">
                                <ext:FieldContainer ID="FieldContainer1" runat="server" MsgTarget="Side" Flex="1" Width="300" Layout="TableLayout">
                                    <Items>                                        
                                        <ext:Checkbox ID="chk01_ALL_CHECK_YN" runat="server" Width="100" Cls="inputText" >
                                            <Listeners>
                                                <Change Fn="SelectionCheckChange" />
                                            </Listeners>
                                        </ext:Checkbox><%--BoxLabel="전체 선택/해제" >--%>
                                        <ext:Checkbox ID="chk01_UNDEFINED_ITEM" runat="server" MarginSpec="0px 0px 0px 10px" Width="150" Cls="inputText" >
                                            <Listeners>
                                                <Change Fn="SelectionCheckChange" />
                                            </Listeners>
                                        </ext:Checkbox><%--BoxLabel="미확인항목" >--%>
                                        <ext:Button ID="btn01_CONFIRM_P" runat="server" MarginSpec="0px 0px 0px 0px" TextAlign="Center">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" >
                                                    <ExtraParams>
                                                        <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({dirtyRowsOnly: true})" Mode="Raw" Encode="true" />
                                                    </ExtraParams>
                                                </Click>
                                            </DirectEvents>
                                        </ext:Button> 
                                        <ext:Button ID="btn01_CONFIRM_C" runat="server" MarginSpec="0px 0px 0px 0px" TextAlign="Center">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" >
                                                    <ExtraParams>
                                                        <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({dirtyRowsOnly: true})" Mode="Raw" Encode="true" />
                                                    </ExtraParams>
                                                </Click>
                                            </DirectEvents>
                                        </ext:Button> 
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                             <th>
                                <ext:Label ID="lbl01_SAPIF_INFO" runat="server" /><%--SAP Interface 정보--%>
                            </th>
                            <td colspan="3">
                                <ext:FieldContainer ID="FieldContainer2" runat="server" MsgTarget="Side" Flex="1" Width="250" Layout="TableLayout">
                                    <Items>                                        
                                        <ext:Checkbox ID="chk02_ALL_CHECK_YN" runat="server" Width="100" Cls="inputText" >
                                            <Listeners>
                                                <Change Fn="SelectionCheckChange2" />
                                            </Listeners>
                                        </ext:Checkbox><%--BoxLabel="전체 선택/해제" >--%>
                                        <ext:Checkbox ID="chk02_UNTREATED_ITEM" runat="server" MarginSpec="0px 0px 0px 10px" Width="150" Cls="inputText" >
                                            <Listeners>
                                                <Change Fn="SelectionCheckChange2" />
                                            </Listeners>
                                        </ext:Checkbox><%--BoxLabel="미확인항목" >--%>
                                        <ext:Button ID="btn02_SAPIF" runat="server" MarginSpec="0px 0px 0px 0px" TextAlign="Center">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" >
                                                    <ExtraParams>
                                                        <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({dirtyRowsOnly: true})" Mode="Raw" Encode="true" />
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
            
            <ext:Panel ID="Panel2" runat="server" Region="North" Height="27" >
                <Content>
                    <table style="height:0px; margin-bottom: 10px;">
                        <tr>
                            <td align="left" style="color:#555;">
                                <ext:Label ID="lbl01_MM26007_MSG001" runat="server" />
                                <ext:Label ID="lbl01_MM26007_MSG002" runat="server" />
                                <ext:Label ID="lbl01_MM26007_MSG003" runat="server" />
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
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="IO_DIV" />
                                            <ext:ModelField Name="NORMAL_RTN" />
                                            <ext:ModelField Name="VENDCD" /> 
                                            <ext:ModelField Name="VENDNM" /> 
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="RESALE_QTY" />
                                            <ext:ModelField Name="VEND_OK" />
                                            <ext:ModelField Name="VEND_NAME" />
                                            <ext:ModelField Name="VEND_OK_DATE" />
                                            <ext:ModelField Name="CUST_OK" />
                                            <ext:ModelField Name="CUST_NAME" />
                                            <ext:ModelField Name="CUST_OK_DATE" />
                                            <ext:ModelField Name="PURC_OK" />
                                            <ext:ModelField Name="PURC_CLS_DATE" />
                                            <ext:ModelField Name="PURC_NAME" />
                                            <ext:ModelField Name="PURC_OK_DATE" />
                                            <ext:ModelField Name="PROCESS_OK" />
                                            <ext:ModelField Name="PURC_CON_NAME" />
                                            <ext:ModelField Name="PURC_CON_DATE" />
                                            <ext:ModelField Name="IO_CANCEL" />
                                            <ext:ModelField Name="CANC_USER" />
                                            <ext:ModelField Name="CANC_DATE" />     
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
                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                <Listeners>                                    
                                    <BeforeEdit fn="BeforeEdit" />                                      
                                </Listeners>
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                             <%--locked이 포함되어있으면 beforeedit가 먹지 않는다. 없다면 된다--%>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true" Width="40" Align="Center" Locked="true" >
                                    <Renderer Fn="rendererNo"  ></Renderer>                                    
                                </ext:Column>
                                <ext:Column ID="NORMAL_RTN" ItemID="NORMAL_RTN" runat="server" DataIndex="NORMAL_RTN" Width="70" Align="Center" Locked="true" />
                                <ext:Column ID="VENDCD" ItemID="OPT11" runat="server" DataIndex="VENDCD" Width="70" Align="Center" Locked="true" /><%--Text="공급처"   --%>
                                <ext:Column ID="VENDNM" ItemID="OPT11_NM" runat="server" DataIndex="VENDNM" Width="140" Align="Left" Locked="true" /><%--Text="공급처명" --%>
                                <ext:Column ID="VINNM"  ItemID="VIN" runat="server" DataIndex="VINNM" Width="40" Align="Center" Locked="true" /><%--Text="차종"  --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" Locked="true" /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="170" Flex="1" Align="Left" /><%--Text="PART NAME" --%>
                                <ext:Column ID="CUSTCD" ItemID="OPT12" runat="server" DataIndex="CUSTCD" Width="70" Align="Center" /><%--Text="수요처"   --%>
                                <ext:Column ID="CUSTNM" ItemID="OPT12_NM" runat="server" DataIndex="CUSTNM" Width="140" Align="Left" /><%--Text="수요처명" --%>
                                
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server"  DataIndex="UNIT"   Width="60" Align="Left" >
                                    <Renderer Fn="gridComboRenderer" />
                                    <Editor>                                        
                                        <ext:ComboBox ID="cbo02_UNIT" runat="server"  DisplayField="OBJECT_NM" ValueField="OBJECT_ID" QueryMode="Local" AllowBlank = "false" Editable="false">                         
                                            <Store>
                                                <ext:Store ID="Store15" runat="server">
                                                    <Model>
                                                        <ext:Model ID="Model15" runat="server" IDPropery="TYPECD">
                                                            <Fields>                                                                                    
                                                                <ext:ModelField Name="OBJECT_ID" />
                                                                <ext:ModelField Name="OBJECT_NM" />
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>                                            
                                        </ext:ComboBox>                                      
                                    </Editor>
                                </ext:Column> <%--Text="단위"    --%>
                                <ext:NumberColumn ID="RESALE_QTY" ItemID="CLS_QTY" runat="server" DataIndex="RESALE_QTY"  Width="80" Align="Right" Format="#,##0.###" ><%--Text="마감수량"  --%>
                                    <Editor>
                                        <ext:NumberField ID="txt02_RESALE_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" DecimalPrecision="3" /><%--DecimalPrecision="3" 소수점 3자리 입력 허용.--%>
                                    </Editor>
                                </ext:NumberColumn> 

                                <ext:Column ID="VEND_OK2" ItemID="VEND_OK" runat="server"  ><%--Text="공급처 확인">--%>
                                    <Columns>
                                        <ext:Column ID="VEND_OK" ItemID="CHGCFM1" runat="server" Resizable="false" DataIndex="VEND_OK" Width="40" Align="Center" Sortable="false" /><%--Text="확인"   --%>
                                        <ext:Column ID="VEND_NAME" ItemID="CHARGE" runat="server" Resizable="false" DataIndex="VEND_NAME" Width="70" Align="Left" Sortable="false" /><%--Text="담당자"   --%>
                                        <ext:Column ID="VEND_OK_DATE" ItemID="OK_DATE" runat="server" DataIndex="VEND_OK_DATE" Width="120" Align="Center" Sortable="false" /><%--Text="확인일시"      --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="CUST_OK2" ItemID="CUST_OK" runat="server" ><%--Text="수요처 확인">--%>
                                    <Columns>
                                        <ext:Column ID="CUST_OK" ItemID="CHGCFM1" runat="server" Resizable="false" DataIndex="CUST_OK" Width="40" Align="Center" Sortable="false" /><%--Text="확인"   --%>                                    
                                        <ext:Column ID="CUST_NAME" ItemID="CHARGE" runat="server" Resizable="false" DataIndex="CUST_NAME" Width="70" Align="Left" Sortable="false" /><%--Text="담당자"   --%>
                                        <ext:Column ID="CUST_OK_DATE" ItemID="OK_DATE" runat="server" DataIndex="CUST_OK_DATE" Width="120" Align="Center" Sortable="false" /><%--Text="확인일시"      --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="PURC_OK2" ItemID="PURC_OK" runat="server" ><%--Text="서연이화 확인">--%>
                                    <Columns>
                                        <ext:CheckColumn ID ="PURC_OK" ItemID="CHGCFM" runat="server" DataIndex="PURC_OK" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >
                                            <Listeners><BeforeCheckChange fn="BeforeCheckChange" /></Listeners>
                                        </ext:CheckColumn>                                                   
                                        <ext:Column ID="PURC_NAME" ItemID="CHARGE" runat="server" Resizable="false" DataIndex="PURC_NAME" Width="70" Align="Left" Sortable="false" /><%--Text="담당자"   --%>
                                        <ext:Column ID="PURC_OK_DATE" ItemID="OK_DATE" runat="server" DataIndex="PURC_OK_DATE" Width="120" Align="Center" Sortable="false" /><%--Text="확인일시"      --%>
                                    </Columns>
                                </ext:Column>
                                 <ext:Column ID="SAPIF_PROCESS" ItemID="SAPIF_PROCESS" runat="server" ><%--Text="SAP Interface 처리">--%>
                                    <Columns>                                        
                                        <ext:CheckColumn ID ="PROCESS_OK" ItemID="CONFIRM_YN" runat="server" DataIndex="PROCESS_OK" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="선택"--%>
                                            <Listeners><BeforeCheckChange fn="BeforeCheckChange" /></Listeners>
                                        </ext:CheckColumn> 
                                        <ext:Column ID="PURC_CON_NAME" ItemID="CHARGE" runat="server" Resizable="false" DataIndex="PURC_CON_NAME" Width="70" Align="Left" Sortable="false" /><%--Text="담당자"   --%>
                                        <ext:Column ID="PURC_CON_DATE" ItemID="PURC_CON_DATE" runat="server" DataIndex="PURC_CON_DATE" Width="120" Align="Center" Sortable="false" /><%--Text="확정일시"      --%>
                                    </Columns>
                                </ext:Column>                                
                                <ext:Column ID="SAPIF_INFO" ItemID="SAPIF_INFO" runat="server" ><%--Text="SAP Interface 정보">--%>
                                    <Columns>                                        
                                        <ext:Column ID="PURC_CLS_DATE" ItemID="PURC_CLS_DATE" runat="server" DataIndex="PURC_CLS_DATE" Width="100" Align="Center" Sortable="false" /><%--Text="마감반영일자"      --%>
                                        <ext:Column ID="IO_CANCEL" ItemID="CANCEL" runat="server" Resizable="false" DataIndex="IO_CANCEL" Width="40" Align="Center" Sortable="false" /><%--Text="취소"   --%>                                    
                                        <ext:Column ID="CANC_USER" ItemID="CANCEL_USER" runat="server" Resizable="false" DataIndex="CANC_USER" Width="70" Align="Left" Sortable="false" /><%--Text="취소등록자"   --%>
                                        <ext:Column ID="CANC_DATE" ItemID="CANCEL_DATE" runat="server" DataIndex="CANC_DATE" Width="100" Align="Center" Sortable="false" /><%--Text="취소일시"      --%>                                        
                                    </Columns>
                                </ext:Column>                                
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true" >                                
                                <GetRowClass Fn="getRowClass" />
                            </ext:GridView>
                        </View>                        
                        <SelectionModel>
                      <%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">
                                <Listeners>
                                    <Select Fn="CellFocus"></Select>
                                </Listeners>
                            </ext:CellSelectionModel >
                            
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
