<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM26006.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM26006" %>
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
	    /*.edit-row */.x-grid-cell-UNIT DIV,
	    /*.edit-row */.x-grid-cell-CLS_QTY DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }
	    
	    .readonly-row .x-grid-cell-UNIT DIV,
	    .readonly-row .x-grid-cell-CLS_QTY DIV
	    {	
		    border-width:0px;
		    border-style:none;
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

        var AfterEdit = function (rowEditor, e) {

            if (e.column.dataIndex != "CHK") {
                e.grid.getStore().getAt(e.rowIdx).set("CHK", false);
                e.grid.getStore().getAt(e.rowIdx).set("CHK", e.grid.getStore().getAt(e.rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
            } else {
                e.grid.getStore().getAt(e.rowIdx).dirty = e.grid.getStore().getAt(e.rowIdx).data["CHK"];
            }
        }

        //체크컬럼 전용 4.x
        var BeforeCheckChange = function (column, rowIndex, record, eOpts) {
            var type = App.RadioGroup1.getChecked()[0].inputValue.toString(); //1 공급처 2 수요처            
            var div = App.RadioGroup2.getChecked()[0].inputValue.toString(); //1 정상 2 반품
            var vend_ok = record.get('VEND_OK');
            var cust_ok = record.get('CUST_OK');
            var purc_ok = record.get('PURC_OK');

            if (div == "1") { //정상일 경우
                //공급처이고 서연이화 확인하였을 때 수정금지
                if (type == "1") {
                    if (purc_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    if (cust_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0046'); //수요처에서 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    /*
                    if (column.id == "UNIT" || column.id == "RESALE_QTY") {
                    if (vend_ok == "Y") {
                    App.direct.MsgCodeAlert('SRMMM-0047'); //공급처에서 확인된 정보는 수정할 수 없습니다.
                    return false;
                    }
                    }
                    */

                    if (column.id == "RESALE_QTY" && vend_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0047'); //공급처에서 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }
                }

                //수요처 확인 수정시 공급처 체크 여부 확인
                if (column.id == "CUST_OK") {

                    if (purc_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    if (vend_ok != "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0044'); //공급처에서 확인하지 않아 수정할 수 없습니다.
                        return false;
                    }
                }
            }
            else { //반품일 경우

                if (type == "2") {
                    if (purc_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    if (vend_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0047'); //공급처에서 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    /*
                    if (column.id == "UNIT" || column.id == "RESALE_QTY") {
                    if (cust_ok == "Y") {
                    App.direct.MsgCodeAlert('SRMMM-0046'); //수요처에서 확인된 정보는 수정할 수 없습니다.
                    return false;
                    }
                    }
                    */

                    if (column.id == "RESALE_QTY" && cust_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0046'); //수요처에서 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }
                }

                //공급처 확인 수정시 수요처 체크 여부 확인
                if (column.id == "VEND_OK") {

                    if (purc_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    if (cust_ok != "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0050'); //수요처에서 확인하지 않아 수정할 수 없습니다.
                        return false;
                    }
                }
            }
        }

        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;

            var purc_ok = e.grid.getStore().getAt(e.rowIdx).data["PURC_OK_DATE"];

            if (purc_ok.length > 0) {
                Ext.getCmp('cbo02_UNIT').disable();
            }
            else {
                Ext.getCmp('cbo02_UNIT').enable();
            }

            var type = App.RadioGroup1.getChecked()[0].inputValue.toString(); //1 공급처 2 수요처
            var div = App.RadioGroup2.getChecked()[0].inputValue.toString(); //1 정상 2 반품
            var vend_ok = e.grid.getStore().getAt(e.rowIdx).data["VEND_OK"];
            var cust_ok = e.grid.getStore().getAt(e.rowIdx).data["CUST_OK"];
            var purc_ok = e.grid.getStore().getAt(e.rowIdx).data["PURC_OK"];

            if (div == "1") { //정상일 경우
                //공급처이고 서연이화 확인하였을 때 수정금지
                if (type == "1") {
                    if (purc_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    if (cust_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0046'); //수요처에서 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    /*
                    if (e.column.dataIndex == "UNIT" || e.column.dataIndex == "RESALE_QTY") {
                        if (vend_ok == "Y") {
                            App.direct.MsgCodeAlert('SRMMM-0047'); //공급처에서 확인된 정보는 수정할 수 없습니다.
                            return false;
                        }
                    }
                    */

                    if (e.column.dataIndex == "RESALE_QTY" && vend_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0047'); //공급처에서 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }
                }

                //수요처 확인 수정시 공급처 체크 여부 확인
                if (e.column.dataIndex == "CUST_OK") {

                    if (purc_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    if (vend_ok != "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0044'); //공급처에서 확인하지 않아 수정할 수 없습니다.
                        return false;
                    }
                }
            }
            else { //반품일 경우

                if (type == "2") {
                    if (purc_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    if (vend_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0047'); //공급처에서 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    /*
                    if (e.column.dataIndex == "UNIT" || e.column.dataIndex == "RESALE_QTY") {
                        if (cust_ok == "Y") {
                            App.direct.MsgCodeAlert('SRMMM-0046'); //수요처에서 확인된 정보는 수정할 수 없습니다.
                            return false;
                        }
                    }
                    */

                    if (e.column.dataIndex == "RESALE_QTY" && cust_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0046'); //수요처에서 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }
                }

                //공급처 확인 수정시 수요처 체크 여부 확인
                if (e.column.dataIndex == "VEND_OK") {

                    if (purc_ok == "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0043'); //서연이화 확인된 정보는 수정할 수 없습니다.
                        return false;
                    }

                    if (cust_ok != "Y") {
                        App.direct.MsgCodeAlert('SRMMM-0050'); //수요처에서 확인하지 않아 수정할 수 없습니다.
                        return false;
                    }
                }
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
            if ((App.rdo01_OPT11.checked == true && App.rdo01_NORMAL.checked == true)
                || (App.rdo01_OPT12.checked == true && App.rdo01_RTN.checked == true)) {
                return "edit-row";
            }
            else {
                return "readonly-row";
            }
        };

        var SelectionCheckChangeNumber = function () {
            var grid = App.Grid01;

            for (i = 0; i < grid.store.count(); i++) {

                var vend_ok = grid.getStore().getAt(i).data["VEND_OK"];
                var cust_ok = grid.getStore().getAt(i).data["CUST_OK"];

                if (grid.getStore().getAt(i).data["RESALE_QTY"] != "0") {
                    if (App.rdo01_NORMAL.checked == true) {
                        if (App.rdo01_OPT11.checked == true) {
                            if (cust_ok != "Y") {
                                grid.store.getAt(i).data["VEND_OK"] = App.chk01_QTY_CHECK_YN.checked;
                                grid.store.getAt(i).dirty = App.chk01_QTY_CHECK_YN.checked;
                            }
                        }
                        else {
                            grid.store.getAt(i).data["CUST_OK"] = App.chk01_QTY_CHECK_YN.checked;
                            grid.store.getAt(i).dirty = App.chk01_QTY_CHECK_YN.checked;
                        }
                    }
                    else {
                        if (App.rdo01_OPT12.checked == true) {
                            if (vend_ok != "Y") {
                                grid.store.getAt(i).data["CUST_OK"] = App.chk01_QTY_CHECK_YN.checked;
                                grid.store.getAt(i).dirty = App.chk01_QTY_CHECK_YN.checked;
                            }
                        }
                        else {
                            grid.store.getAt(i).data["VEND_OK"] = App.chk01_QTY_CHECK_YN.checked;
                            grid.store.getAt(i).dirty = App.chk01_QTY_CHECK_YN.checked;
                        }
                    }

                    grid.store.getAt(i).data["NO"] = i + 1; //2015-03-03 체크박스 체크할 때 "NO"에도 값 넣어줌. (renderer를 통해서 값이 들어가긴 하지만  buffered 특성상 화면에 displayed 되지 않았을 때는 값이 없는 경우 발생함)                    
                }
            }
            grid.view.refresh();
        }

        var SelectionCheckChange = function () {
            var grid = App.Grid01;

            for (i = 0; i < grid.store.count(); i++) {

                var vend_ok = grid.getStore().getAt(i).data["VEND_OK"];
                var cust_ok = grid.getStore().getAt(i).data["CUST_OK"];

                if (App.rdo01_NORMAL.checked == true) {
                    if (App.rdo01_OPT11.checked == true) {
                        if (cust_ok != "Y") {
                            grid.store.getAt(i).data["VEND_OK"] = App.chk01_ALL_CHECK_YN.checked;
                            grid.store.getAt(i).dirty = App.chk01_ALL_CHECK_YN.checked;
                        }
                    }
                    else {
                        grid.store.getAt(i).data["CUST_OK"] = App.chk01_ALL_CHECK_YN.checked;
                        grid.store.getAt(i).dirty = App.chk01_ALL_CHECK_YN.checked;
                    }
                }
                else {
                    if (App.rdo01_OPT12.checked == true) {
                        if (vend_ok != "Y") {
                            grid.store.getAt(i).data["CUST_OK"] = App.chk01_ALL_CHECK_YN.checked;
                            grid.store.getAt(i).dirty = App.chk01_ALL_CHECK_YN.checked;
                        }
                    }
                    else {
                        grid.store.getAt(i).data["VEND_OK"] = App.chk01_ALL_CHECK_YN.checked;
                        grid.store.getAt(i).dirty = App.chk01_ALL_CHECK_YN.checked;
                    }
                }
                grid.store.getAt(i).data["NO"] = i + 1; //2015-03-03 체크박스 체크할 때 "NO"에도 값 넣어줌. (renderer를 통해서 값이 들어가긴 하지만  buffered 특성상 화면에 displayed 되지 않았을 때는 값이 없는 경우 발생함)                
            }
            grid.view.refresh();
        }        

    </script>
</head>
<body>
    <form id="SRM_MM26006" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM26006" runat="server" Cls="search_area_title_name" /><%--Text="사급 직납 마감 등록" />--%>
                    <ext:Label ID ="lbl01_SRM_MM26006_MSG1" runat="server" Cls="search_area_title_name" StyleSpec="padding-left:210px;">
<%--                        <Content>
                            ( ※ 중요 : 실 납품 거래처코드 확인 후 등록 바랍니다. (important :After check Real Delivery Customer Code, Please Register )
                        </Content>--%>
                    </ext:Label>
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
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND_DIV" runat="server" /><%--Text="업체구분" />--%>
                            </th>
                            <td>
                                <ext:RadioGroup ID="RadioGroup1" runat="server" Width="200" Cls="inputText" ColumnsWidths="100,100" GroupName="a">
                                    <Items>
                                        <ext:Radio ID="rdo01_OPT11" Cls="inputText" runat="server" InputValue="1" Checked="true" >                                                                
                                        </ext:Radio>
                                        <ext:Radio ID="rdo01_OPT12" Cls="inputText" runat="server" InputValue="2" Checked="false" />
                                    </Items>       
                                    <Listeners>
                                        <Change Handler="App.direct.SetCustVendVisible(this.getChecked()[0].inputValue.toString());"  Delay="500" />
                                    </Listeners>     
                                </ext:RadioGroup>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_NORMAL_RTN" runat="server" /><%--Text="정상/반품 구분" />--%>
                            </th>
                            <td>
                                <ext:RadioGroup ID="RadioGroup2" runat="server" Width="200" Cls="inputText" ColumnsWidths="100,100">
                                    <Items>
                                        <ext:Radio ID="rdo01_NORMAL" Cls="inputText" runat="server" InputValue="1" Checked="true" />
                                        <ext:Radio ID="rdo01_RTN" Cls="inputText" runat="server" InputValue="2" />
                                    </Items>       
                                    <Listeners>
                                        <Change Handler="App.direct.SetGridSetting(this.getChecked()[0].inputValue.toString());" Delay="500" /> <%--delay필수 4.x--%>
                                    </Listeners>                             
                                </ext:RadioGroup>
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
                            <th class="ess">
                                <ext:Label ID="lbl01_CUST" runat="server" />
                                <ext:Label ID="lbl01_VEND" runat="server" Hidden="true" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD_FIX" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
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
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" />                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_PROD_VENDOR" runat="server"/>
                            </th>  
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD2" runat="server" HelperID="HELP_VENDCD_FREE" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                                <epc:EPCodeBox ID="cdx01_CUSTCD2" runat="server" HelperID="HELP_CUSTCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>                        
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                 
                            </th>
                            <td>
                                <ext:TextField ID="txt01_PARTNO" Width="150" Cls="inputText" runat="server" />                                                          
                            </td>
                        </tr>                        
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="EmpRegistPanel" Region="North" Cls="excel_upload_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 750px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_CHR_NM" runat="server" /><%--담당자명--%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer1" runat="server" MsgTarget="Side" Flex="1" Width="450" Layout="TableLayout">
                                    <Items>
                                        <ext:TextField ID="txt01_MGRNM" Width="150" Cls="inputText" runat="server" MarginSpec="0px 20px 0px 0px" />
                                        <ext:Checkbox ID="chk01_QTY_CHECK_YN" runat="server" Width="150" Cls="inputText" >
                                            <Listeners>
                                                <Change Fn="SelectionCheckChangeNumber" />
                                            </Listeners>
                                        </ext:Checkbox><%--BoxLabel="수량만 선택/해제" >--%>
                                        <ext:Checkbox ID="chk01_ALL_CHECK_YN" runat="server" Width="150" Cls="inputText" >
                                            <Listeners>
                                                <Change Fn="SelectionCheckChange" />
                                            </Listeners>
                                        </ext:Checkbox><%--BoxLabel="전체 선택/해제" >--%>
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                            <td align="left" style="color:#555;">
                                <ext:Label ID="lbl01_MM_MSG004"  runat="server" />  <%--Text="☞ 매월 {0}일까지 등록 가능합니다."--%>                                                                    
                            </td>                            
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ExcelUploadPanel" Region="North" Cls="excel_upload_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 410px;"/>
                            <col style="width: 100px;"/>
                            <col style="width: 100px;"/>
                            <col />
                        </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_EXCEL" runat="server" /><%--Text="Excel Upload" />--%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer3" runat="server" Width="410" MinWidth="410" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:FileUploadField ID="fud02_FILEID1" runat="server" Cls="inputText" ButtonText="Browser" Width="400" />
                                    </Items>
                                </ext:FieldContainer>
                            </td>    
                            <td>
                                <ext:Panel ID="ButtonPanel2" runat="server"  StyleSpec="width:100%;"  Height="30">
                                    <Items>
                                        <%-- 엑셀 파일 업로드 버튼 --%>
                                    </Items>
                                </ext:Panel>
                            </td>  
                            <td>
                                <ext:Button ID="btn01_DOWN" runat="server" TextAlign="Center"><%--Text="양식다운로드" >--%>
                                    <DirectEvents>
                                        <Click OnEvent="etc_Button_Click" />
                                    </DirectEvents>
                                </ext:Button>      
                            </td>  
                            <td>
                                <ext:FieldContainer ID="FieldContainer2" runat="server" Width="260" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:Label ID="lbl01_ROWCNT"            runat="server" /><%--Text="(적용건수 : " />--%>
                                        <ext:Label ID="lbl01_ROWCNT_EXCEL"      runat="server" /><%--Text="대상건수" />--%>
                                        <ext:TextField ID="txt01_ROWCNT_EXCEL"  runat="server" Width="50" Cls="inputText_Num" ReadOnly="true" />
                                        <ext:Label ID="lbl01_ROWCNT_ADDED"      runat="server" /><%--Text="처리건수"/>--%>
                                        <ext:TextField ID="txt01_ROWCNT_ADDED"  runat="server" Width="50" Cls="inputText_Num" ReadOnly="true" />
                                        <ext:Label ID="lbl01_ROWCNT_E"          runat="server" /><%--Text=" )" />--%>
                                        <ext:Button ID="btn01_PRINT_REPORT2"  Text="거래명세표 출력" runat="server" MarginSpec="0px 0px 0px 10px" TextAlign="Center"><%--Text="거래명세표 출력" >--%>
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" />
                                            </DirectEvents>
                                        </ext:Button> 
                                    </Items>
                                </ext:FieldContainer>
                            </td>   
                        </tr>      
                    </table>
                </Content>
            </ext:Panel> 
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>                    
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="VINCD" /> 
                                            <ext:ModelField Name="UNIT" />                                           
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />                                                                                      
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
                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                <Listeners>                                    
                                    <BeforeEdit fn="BeforeEdit" />
                                    <Edit fn ="AfterEdit" />
                                </Listeners>
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true" Width="40" Align="Center" Draggable="false" >
                                    <Renderer Fn="rendererNo"  ></Renderer>                                    
                                </ext:Column>                                
                                <ext:Column ID="CUSTCD" ItemID="VENDORCD" runat="server" DataIndex="CUSTCD" Width="80" Align="Center" Draggable="false"  /><%--Text="거래처"   --%>
                                <ext:Column ID="CUSTNM" ItemID="VENDORNM" runat="server" DataIndex="CUSTNM" Width="130" Align="Left" Draggable="false"/><%--Text="거래처명" --%>
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="40" Align="Center" Draggable="false"/><%--Text="차종"  --%>                                                                
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" Draggable="false"/><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="100" Align="Left" Flex="1" Draggable="false"/><%--Text="PART NAME" --%>
                                
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server"  DataIndex="UNIT"   Width="60" Align="Left" Draggable="false">
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
                                
                                <ext:NumberColumn ID="RESALE_QTY" ItemID="CLS_QTY" runat="server" DataIndex="RESALE_QTY"  Width="80" Align="Right" Format="#,##0.###" Draggable="false"><%--Text="마감수량"  --%>
                                    <Editor>
                                        <ext:NumberField ID="txt02_RESALE_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" DecimalPrecision="3" /><%--DecimalPrecision="3" 소수점 3자리 입력 허용.--%>
                                    </Editor>
                                </ext:NumberColumn> 
                                <ext:Column ID="VEND_OK2" ItemID="VEND_OK" runat="server" Draggable="false"><%--Text="공급처 확인">--%>
                                    <Columns>
                                        <ext:CheckColumn ID ="VEND_OK" ItemID="CHGCFM" runat="server" DataIndex="VEND_OK" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" Draggable="false"><%--Text="확인"--%>
                                            <Listeners><BeforeCheckChange fn="BeforeCheckChange" /></Listeners>
                                        </ext:CheckColumn>                                    
                                        <ext:Column ID="VEND_NAME" ItemID="CHARGE" runat="server" Resizable="false" DataIndex="VEND_NAME" Width="80" Align="Left" Draggable="false"/><%--Text="담당자"   --%>
                                        <ext:Column ID="VEND_OK_DATE" ItemID="OK_DATE" runat="server" DataIndex="VEND_OK_DATE" Width="130" Align="Center" Draggable="false"/><%--Text="확인일시"      --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="CUST_OK2" ItemID="CUST_OK" runat="server" Draggable="false"><%--Text="수요처 확인">--%>
                                    <Columns>
                                        <ext:CheckColumn ID ="CUST_OK" ItemID="CHGCFM1" runat="server" DataIndex="CUST_OK" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" Draggable="false"><%--Text="확인"--%>
                                            <Listeners><BeforeCheckChange fn="BeforeCheckChange" /></Listeners>
                                        </ext:CheckColumn>                                    
                                        <ext:Column ID="CUST_NAME" ItemID="CHARGE" runat="server" Resizable="false" DataIndex="CUST_NAME" Width="80" Align="Left" Sortable="true" Draggable="false"/><%--Text="담당자"   --%>
                                        <ext:Column ID="CUST_OK_DATE" ItemID="OK_DATE1" runat="server" DataIndex="CUST_OK_DATE" Width="130" Align="Center" Sortable="true" Draggable="false"/><%--Text="확인일시"      --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="PURC_OK2" ItemID="PURC_OK" runat="server" Draggable="false"><%--Text="서연이화 확인">--%>
                                    <Columns>
                                        <ext:Column ID="PURC_OK" ItemID="CHGCFM" runat="server" DataIndex="PURC_OK" Width="40" Align="Center" Sortable="true" Draggable="false"/><%--Text="확인"      --%>
                                        <ext:Column ID="PURC_NAME" ItemID="CHARGE" runat="server" Resizable="false" DataIndex="PURC_NAME" Width="80" Align="Left" Sortable="true" Draggable="false"/><%--Text="담당자"   --%>
                                        <ext:Column ID="PURC_OK_DATE" ItemID="OK_DATE2" runat="server" DataIndex="PURC_OK_DATE" Width="130" Align="Center" Sortable="true" Draggable="false"/><%--Text="확인일시"      --%>
                                        <ext:Column ID="PURC_CLS_DATE" ItemID="PURC_CLS_DATE" runat="server" DataIndex="PURC_CLS_DATE" Width="100" Align="Center" Sortable="true" Draggable="false"/><%--Text="마감일자"      --%>
                                    </Columns>
                                </ext:Column>                                
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server"  EnableTextSelection="true">                                
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
                    <ext:GridPanel ID="Grid02" runat="server" Visible="false" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="Model2" runat="server">
                                        <Fields>                                       
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="UNIT" />       
                                            <ext:ModelField Name="RESALE_QTY" />       
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
                            <ext:BufferedRenderer ID="BufferedRenderer2"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel2" runat="server">
                            <Columns>
                                <%--<ext:Column ID="E_SEQ" ItemID="SEQ" runat="server" DataIndex="SEQ" Width="40" Align="Right" />--%><%--Text="SEQ"   --%>       
                                <ext:Column ID="E_CUSTCD" ItemID="VENDORCD" runat="server" DataIndex="CUSTCD" Width="80" Align="Center" /><%--Text="거래처"   --%>
                                <ext:Column ID="E_CUSTNM" ItemID="VENDORNM" runat="server" DataIndex="CUSTNM" Width="140" Align="Left"/><%--Text="거래처명" --%>
                                <ext:Column ID="E_VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="40" Align="Center" /><%--Text="차종"  --%>                                
                                <ext:Column ID="E_UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="60" Align="Center" /><%--Text="단위"  --%>                                
                                <ext:Column ID="E_PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="PART NO"   --%>
                                <ext:Column ID="E_PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" /><%--Text="PART NAME" --%>                                
                                <ext:Column ID="E_RESALE_QTY" ItemID="CLS_QTY" runat="server" DataIndex="RESALE_QTY"  Width="80" Align="Right" /><%--Text="마감수량"  --%>
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView2" runat="server"  EnableTextSelection="true"/>
                        </View>                        
                    </ext:GridPanel>
                </Items>
            </ext:Panel>                 
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
