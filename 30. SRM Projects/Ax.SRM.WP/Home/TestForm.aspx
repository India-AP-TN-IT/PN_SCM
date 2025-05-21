<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestForm.aspx.cs" Inherits="Ax.SRM.WP.Home.TestForm" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<%@ Import Namespace="System.Collections.Generic" %>

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
            currentCellObject = e;
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

            for (i = 0; i < grid.store.count(); i++) {

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

            for (i = 0; i < grid.store.count(); i++) {

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
    <form id="Form1" runat="server">
        <ext:ResourceManager ID="ResourceManager1" runat="server">
            <Listeners>
                <DocumentReady Handler="ExtDocumentReady();" />
            </Listeners>
        </ext:ResourceManager>

        <ext:Store ID="Store1" runat="server" PageSize="10">
            <Model>
                <ext:Model ID="Model1" runat="server" IDProperty="Name">
                    <Fields>
                        <ext:ModelField Name="Name" />
                        <ext:ModelField Name="Price" />
                        <ext:ModelField Name="Change" />
                        <ext:ModelField Name="PctChange" />
                    </Fields>
                </ext:Model>
            </Model>
        </ext:Store>

        <ext:GridPanel
            ID="GridPanel1"
            runat="server"
            StoreID="Store1"
            Title="Company List"
            Collapsible="true"
            Width="700"
            EnableColumnMove="true">
            <ColumnModel ID="ColumnModel1" runat="server">
                <Columns>
                    <ext:Column ID="Column1" runat="server" Text="Company" Width="160" DataIndex="Name" Flex="1" />
                    <ext:Column ID="Column2" runat="server" Text="Price" Width="75" DataIndex="Price">
                        <Renderer Format="UsMoney" />
                    </ext:Column>
                    <ext:Column ID="Column3" runat="server" Text="Change" Width="75" DataIndex="Change" />
                    <ext:Column ID="Column4" runat="server" Text="Change" Width="75" DataIndex="PctChange" />
                </Columns>
            </ColumnModel>
            <SelectionModel>
                <ext:CellSelectionModel ID="CellSelectionModel1" runat="server">
                    <DirectEvents>
                        <Select OnEvent="Cell_Click" />
                    </DirectEvents>
                </ext:CellSelectionModel>
            </SelectionModel>
            <BottomBar>
                <ext:PagingToolbar ID="PagingToolbar1" runat="server" Weight="10" HideRefresh="true" />
            </BottomBar>
            <Buttons>
                <ext:Button ID="Button2" runat="server" Text="Clear">
                    <DirectEvents>
                        <Click OnEvent="Clear_Click" />
                    </DirectEvents>
                </ext:Button>

                <ext:Button ID="Button3" runat="server" Text="Set selection to [2,2]">
                    <DirectEvents>
                        <Click OnEvent="Set_Click" />
                    </DirectEvents>
                </ext:Button>
            </Buttons>
        </ext:GridPanel>

        <div style="width:688px; border:1px solid gray; padding:5px;">
            <ext:Label ID="Label1" runat="server" />
        </div>
    </form>
  </body>
</html>