<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM22002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM22002" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" >
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="HE.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="HE.POTAL" />

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
        .x-grid-cell-UNIT_PACK_QTY_SIM DIV,
	    .x-grid-cell-DELI_QTY DIV,
	    .x-grid-cell-VEND_LOTNO DIV,
	    .x-grid-cell-CHANGE_4M DIV,
	    .x-grid-cell-PRDT_DATE DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }
	    
	    /* word-wrap 적용 */
	    #FTA_CERTI-titleEl
	    {
            padding-top:11px;
	    }
	    #FTA_CERTI-textEl
	    {
           white-space: initial;
        }
    </style>
    <style type="text/css">
        .font-color-blue .x-grid-cell-INSPECT_YN
        {
            color:#0000FF;
            text-decoration: underline;
        };
        
        .font-color-black .x-grid-cell-INSPECT_YN
        {
            color:#FF0000;
            text-decoration: none;
        };
    </style>
    <style type="text/css">
        .bottom_area_title_name2 { clear:both;  margin-top:0px; height:20px; display:block; background:url(../../images/common/title_icon_s.gif) 0 8px no-repeat; padding-left:10px;font-size:12px;color:#010101;text-align:left;font-weight:bold;}
    </style>
    <!--그리드 필수 입력필드-->
    <style type="text/css">
        #DELI_QTY, #PRDT_DATE
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
            //(입고 완료된 납품서는 조회되지 않습니다.)
            //App.ConditionPanel.setHeight(App.ConditionPanel.getHeight() + 5);
            //document.getElementById('ConditionPanel').style.marginTop = 5 + 'px';
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            //App.GridPanel.setHeight(Math.floor(SRM_MM22002.offsetHeight * 0.25));
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
            App.BottomGridPanel.setHeight(App.pnl01_Bottom.getHeight() - 30);
            App.Grid02.setHeight(App.BottomGridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        //성적서 입력 여부를 y로 업데이트한다. 
        function fn_GridSetInputY() {
            var rowIdx = App.CodeRow.getValue();
            var grid = App.Grid01;
            grid.getStore().getAt(rowIdx).set("ISOK", "Y");
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var Grid01_CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

            App.CodeRow.setValue(rowIndex);

            var deliNote = grid.getStore().getAt(rowIndex).data["DELI_NOTE"];
            var invoice_no = grid.getStore().getAt(rowIndex).data["INVOICE_NO"];

            App.direct.Grid01_Cell_DoubleClick(deliNote, invoice_no);
        }
        
        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var Grid02_CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
//2018.01.23 글로벌표준 검사성적서 등록 기능 사용하지 않음.
//            //CellDbClick이벤트의 파라메터중 3번째로 넘어오는 cellIndex는 
//            //더블클릭한 셀의 인덱스를 가져오도록 되어 있는데
//            //ItemId가 동일한 여러 컬럼이 존재하는 경우에는(다국어) 제대로 값이 넘어오지 않음.
//            //그래서 7번째 파라메터인 obj4의 하위속성을 이용하여 cellIndex값 제대로 추출함.
//            //cellIndex = obj4.target.offsetParent.cellIndex;
//            var grid = grid.ownerCt;
//            
//            // cellIndex는 Hidden된 컬럼은 제외한 index 임
//            // grid.columns은 Hidden 포함
//            // grid.columnManager.columns은 Hidden 제외
//            // console.log(grid.columns[cellIndex].id, grid.columnManager.columns[cellIndex].id);            

//            //if (grid.columnManager.columns[cellIndex].id == 'INSPECT_YN') {
//            if (grid.columns[cellIndex].id == 'INSPECT_YN') {
//                /* 참고: cs단에서 메서드 생성시 public으로  */
//                if (grid.getStore().getAt(rowIndex).data["INSPECT_YN_CODE"] != "Y") //유겸사가 아닌 경우 
//                {
//                    App.direct.MsgCodeAlert("COM-00907");   //성적서를 등록할 수 없는 항목입니다.
//                    return;
//                }

//                App.CodeRow.setValue(rowIndex);

//                var partno = grid.getStore().getAt(rowIndex).data["PARTNO"];
//                var qty = grid.getStore().getAt(rowIndex).data["DELI_QTY"];
//                var barcode = grid.getStore().getAt(rowIndex).data["BARCODE"];
//                var deliCnt = grid.getStore().getAt(rowIndex).data["DELI_CNT"];

//                App.direct.Grid02_Cell_DoubleClick(qty, partno, barcode, deliCnt);
//            }
        }

        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        var AfterEdit = function (rowEditor, e) {
            var grid = App.Grid01;

            if (e.column.dataIndex == "UNIT_PACK_QTY") {
                var unitQty = e.grid.getStore().getAt(e.rowIdx).data["UNIT_PACK_QTY"];
                if (unitQty < 1) e.grid.getStore().getAt(e.rowIdx).set("UNIT_PACK_QTY", null);
            }
            else if (e.column.dataIndex == "DELI_TYPE") {
                var deliType = e.grid.getStore().getAt(e.rowIdx).data["DELI_TYPE"];

                /*
                if (deliQty % unitQty != 0) {
                //적입량이 맞지 않습니다.
                App.direct.MsgCodeAlert('SRMMM-0025');
                e.grid.getStore().getAt(e.rowIdx).set("DELI_QTY", '');
                return false;
                }
                */
            }
            else if (e.column.dataIndex == "DELI_QTY") {
                var deliQty = e.grid.getStore().getAt(e.rowIdx).data["DELI_QTY"];
                var unitQty = e.grid.getStore().getAt(e.rowIdx).data["UNIT_PACK_QTY"];
                var corcd = e.grid.getStore().getAt(e.rowIdx).data["CORCD"];
                var purcOrg = App.cbo01_PURC_ORG.value.toString();

                if (unitQty == '' || unitQty == null || unitQty == 0) {
                    //적입량이 맞지 않습니다.
                    App.direct.MsgCodeAlert('SRMMM-0025');
                    return false;
                }

                //2018.10.01 해외법인은 납품수량이 적입량의 배수가 되도록 체크하는 로직 삭제. 
                //소숫점 계산 정확도를 위해서 parseFloat과 toFixed 사용. 2018-06-12 bmh
                //if (parseFloat(deliQty % unitQty).toFixed(3) != 0) {
                //    //적입량이 맞지 않습니다.
                //    App.direct.MsgCodeAlert('SRMMM-0025');
                //    e.grid.getStore().getAt(e.rowIdx).set("DELI_QTY", null);
                //    return false;
                //}

                /* 수정시에는 잔량을 클라이언트에서 체크 안함
                if (deliQty > remainQty) {
                //잔량이 부족합니다.
                App.direct.MsgCodeAlert('SRMMM-0030');
                e.grid.getStore().getAt(e.rowIdx).set("DELI_QTY", '');
                return false;
                }
                */
                //박스수량 적용
                e.grid.getStore().getAt(e.rowIdx).set("BOX_QTY", Math.ceil(deliQty / unitQty)); //<--2018.10.01 박수수량계산시 올림처리함.
            }
            else if (e.column.dataIndex == "VEND_LOTNO") {
                var check = /^[A-Za-z0-9]*$/;
                var vendLotNo = e.grid.getStore().getAt(e.rowIdx).data["VEND_LOTNO"];

                if (!check.test(vendLotNo)) {
                    //업체 Lot No는 영어,숫자로만 구성되어야 합니다.
                    App.direct.MsgCodeAlert('SRMMM-0026');
                    e.grid.getStore().getAt(e.rowIdx).set("VEND_LOTNO", '');
                    return false;
                }
            }
            else if (e.column.dataIndex == "PRDT_DATE") {
                var prdtDate = e.grid.getStore().getAt(e.rowIdx).data["PRDT_DATE"];
                var deliDate = e.grid.getStore().getAt(e.rowIdx).data["DELI_DATE"];

                if (prdtDate != null) {
                    if (prdtDate > deliDate) {
                        //제조일자는 납품일자보다 작아야 합니다.
                        App.direct.MsgCodeAlert('SRMMM-0031');
                        e.grid.getStore().getAt(e.rowIdx).set("PRDT_DATE", '');
                        return false;
                    }
                }
            }
        }

        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            // 틀고정을 사용할 경우 틀고정안된 셀의 colIndex와 틀고정된 셀의 colIndex가 동일하게 나와, 
            // 둘중에 하나라도 편집가능하면 둘다 편집가능한 상태가 되어버림
            // 편집불가 셀은 selectionModel.view.editingPlugin.activeColumn로 판단하여 startEdit를 실행못하도록 막음
            if (selectionModel.view.editingPlugin.activeColumn == null) return;

            var grid = selectionModel.view.ownerCt;
            grid.editingPlugin.startEdit(rowIndex, colIndex);
        }

        //도착예정일자 변경시 도착일자<납품일자 일 경우 에러메시지 표기        
        function changeARRIV_DATE(obj, arriDate) {
            /*
            var deliDate = document.getElementById('df01_DELI_DATE-inputEl').value;
            var arriDate = obj.rawValue;

            if (arriDate < deliDate) {
            //도착일자가 맞지 않습니다.
            App.direct.MsgCodeAlert('SRMMM-0021');
            document.getElementById('df01_ARRIV_DATE-inputEl').value = deliDate;
            return false;
            }
            else {
            return true;
            }
            */
        }

        function changeDELI_DATE() {

        }

        // 수정모드 : 도착일자를 수정하면.. 전체 항목에 반영
        function changeARRIVE_date() {
            var grid = App.Grid01;
        }

        function changeARRIV_TIME(obj, value) {
            document.getElementById('txt01_ARRIV_TIME-inputEl').value = checkArrivTime(value);
        }

        var checkArrivTime = function (value) {
            var length = String(value).length;
            var temp = "";
            switch (length) {
                case 0: return temp;
                case 1: temp = value < 3 ? value : ""; break;
                case 2: temp = value < 24 ? value : ""; break;
                case 3:
                    var temp12 = Number(String(value).substr(0, 2));
                    var temp3 = Number(String(value).substr(2, 1));
                    temp = temp12 < 24 && temp3 < 6 ? value : ""; break;
                case 4:
                    var temp12 = Number(String(value).substr(0, 2));
                    var temp34 = Number(String(value).substr(2, 2));
                    temp = temp12 < 24 && temp34 < 60 ? value : ""; break;
            }
            if (temp == "") return checkArrivTime(String(value).substr(0, length - 1));
            else return temp;
        }

        //2018.10.17 해외법인 수입검사 컬럼 숨김. 
        // 검사유무가 YES이면 파란색링크 형식으로 변경
//        function getRowClass(record, b, c, d) {
//            var inspect_yn = record.data['INSPECT_YN_CODE'];
//            if (inspect_yn == 'Y') return 'font-color-blue';
//            else return 'font-color-black';
//        }

        // 검사성적서 저장 후 호출하는 함수
        function fn_GridSetInputY() {
            var selectedGrid01Row = App.Grid01.getRowsValues({ selectedOnly: true });
            var deliNote = selectedGrid01Row[0]["DELI_NOTE"];
            var deliNoteSeq = selectedGrid01Row[0]["DELI_NOTE_SEQ"];

            App.direct.Grid01_Cell_DoubleClick(deliNote, deliNoteSeq);
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드에서 오른쪽 화살표 버튼을 클릭했을때
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var gridRightButton_Handler = function (editor, command, row, rowIndex, colIndex) {
            var grd = App.Grid01; // editor.grid; 4.X

            var unitQty = grd.getStore().getAt(rowIndex).data["UNIT_PACK_QTY"];
            var remainQty = grd.getStore().getAt(rowIndex).data["REMAIN_QTY"];

            var corcd = grd.getStore().getAt(rowIndex).data["CORCD"];
            var purcOrg = App.cbo01_PURC_ORG.value.toString();

            // unitQty가 0일 경우, 내수이면서 국내사용자 이면 validation 통과
            if (unitQty == 0 && purcOrg == '1A1100' && corcd == '1000') {
                unitQty = remainQty;
            }

            //2018.10.01 해외법인은 납품수량이 적입량의 배수가 되도록 체크하는 로직 삭제. 
            //if (remainQty % unitQty != 0) {
            //    //적입량이 맞지 않습니다.
            //    EPNotify(getCodeMsg("SRMMM-0025"), "Error");
            //    return false;
            //}

            if (rowIndex > 0) {
                // 이전 row의 업체 LOTNO가 있다면 그걸 현재 row로 덮어씌움
                var vendLotno = '', prdtDate = '', i;
                for (i = rowIndex - 1; i >= 0; i--) {
                    if (vendLotno == '') vendLotno = grd.getStore().getAt(i).data["VEND_LOTNO"];
                    if (prdtDate == '') prdtDate = grd.getStore().getAt(i).data["PRDT_DATE"];
                    if (vendLotno != '' && prdtDate != '') break;
                }

                if (vendLotno != '') grd.getStore().getAt(rowIndex).set("VEND_LOTNO", vendLotno);
                if (prdtDate != '') grd.getStore().getAt(rowIndex).set("PRDT_DATE", prdtDate);

                //if (vendLotno != '') grd.getStore().getAt(rowIndex).data["VEND_LOTNO"] = vendLotno;
                //if (prdtDate != '') grd.getStore().getAt(rowIndex).data["PRDT_DATE"] = prdtDate;
            }

            grd.getStore().getAt(rowIndex).set("DELI_QTY", remainQty);
            grd.getStore().getAt(rowIndex).set("BOX_QTY", Math.ceil(remainQty / unitQty)); //<--2018.10.01 박수수량 계산시 올림처리함.

            /*
            // refresh는 IE일 경우 스크롤 제일 아래에서 화살표 기능 이용시 높은 확률로 화면 렌더링이 안되는 현상 발생 (스크롤 올리면 나옴)
            // 잔량을 납품수량으로 복사
            grd.getStore().getAt(rowIndex).data["DELI_QTY"] = remainQty;
            grd.getStore().getAt(rowIndex).data["BOX_QTY"] = remainQty / unitQty;
            grd.getStore().getAt(rowIndex).modified = { "VEND_LOTNO": "", "PRDT_DATE": "", "DELI_QTY": "", "BOX_QTY": "" };
            grd.getStore().getAt(rowIndex).dirty = true;

            grd.view.refresh(false);
            */
        }

    </script>
    <script type="text/javascript" id="FocusHandler">
        var moveFocus = function (o, e) {
            var grd = o.ownerCt.grid;

            if (e.getKey() === 40) {
                grd.editingPlugin.startEdit(currentCellObject.rowIdx + 1, currentCellObject.colIdx); // DOwn
            }
            else if (e.getKey() === 38) {
                grd.editingPlugin.startEdit(currentCellObject.rowIdx - 1, currentCellObject.colIdx); // Up
            }
            /*
            else if (e.getKey() === 37) {
                grd.editingPlugin.startEdit(currentCellObject.rowIdx, currentCellObject.colIdx -1); // Left
            }
            else if (e.getKey() === 39) {
                grd.editingPlugin.startEdit(currentCellObject.rowIdx, currentCellObject.colIdx + 1); // Right
            }
            */
        }
    </script>

</head>
<body>
    <form id="SRM_MM22002" runat="server">
    <!-- timeout 2분 설정 -->
    <ext:ResourceManager ID="ResourceManager1" runat="server" AjaxTimeout="60000">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="UserHelpURL" runat="server" Hidden="true" Text="../SRM_QA/SRM_QA23001P1.aspx"></ext:TextField> 
    <ext:TextField ID="PopupWidth" runat="server" Hidden="true" Text="900"></ext:TextField> 
    <ext:TextField ID="PopupHeight" runat="server" Hidden="true" Text="500"></ext:TextField> 
    <%--<ext:TextField ID="hidMODE" runat="server" Hidden="true" Text="Regist" /> 등록 또는 수정 모드 기록용--%>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MM22002" runat="server" Cls="search_area_title_name" /><%--Text="납품서 수정 및 재발행" />--%>
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
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="80" 
                                 OnAfterValidation="changeCondition"/>
                                
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
                                        <Select OnEvent="changeCondition" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td>  
                            <th  class="ess">         
                                <ext:Label ID="lbl01_PURC_PO_TYPE" runat="server" /><%--Text="구매오더유형" /> --%>                      
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PURC_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="160">
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
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_PURC_PO_TYPE_Change" />
                                    </DirectEvents>                          
                                </ext:SelectBox>
                            </td>
                            <th  class="ess">         
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" /><%--Text="구매조직" /> --%>                      
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_PURC_ORG_Change" />
                                    </DirectEvents>                                    
                                </ext:SelectBox>
                            </td>  
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_STR_LOC" runat="server" /><%--Text="저장위치" /> --%>                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_STR_LOC" runat="server" HelperID="HELP_STR_LOC" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="80" 
                                 OnBeforeDirectButtonClick="cdx01_STR_LOC_BeforeDirectButtonClick" OnAfterValidation="changeCondition"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_DELI_NOTE2" runat="server" /><%--Text="PART NO" />--%>                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_DELI_NOTE2" Width="120" Cls="inputText" runat="server" />    
                            </td>
                            <td>
                                <ext:Button ID="btn01_PRINT_REPORT" runat="server" TextAlign="Center" StyleSpec="" Cls="mg_r4"><%--Text="납품전표출력" >--%>
                                    <DirectEvents>
                                        <Click OnEvent="etc_Button_Click">
                                            <ExtraParams>
                                                <ext:Parameter Name="Grid01SelectedValues" Value="App.Grid01.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                                <ext:Parameter Name="Grid01DirtyValues" Value="App.Grid01.getRowsValues({dirtyRowsOnly:true})" Mode="Raw" Encode="true" />
                                                <ext:Parameter Name="Grid02DirtyValues" Value="App.Grid02.getRowsValues({dirtyRowsOnly:true})" Mode="Raw" Encode="true" />
                                            </ExtraParams>
                                        </Click>
                                    </DirectEvents>
                                </ext:Button>
                            </td>
                            <td colspan="3">
                                <ext:Label ID="lbl01_DELI_NOTE_MESSAGE1" runat="server" /><%--Text="입고 완료된 납품서는 조회되지 않습니다." />--%>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8" style="height:30px; vertical-align:middle;">
                                <font color="red" style="font-weight:bold; text-decoration-color:red">* WARNING: If you modify Delivery note, you must change Box tag.</font>
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="North" Border="True" runat="server" Cls="grid_area" StyleSpec="margin-bottom:10px;" Flex="1">
                <Items>                   
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>                                       
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="DELI_DATE" />
                                            <ext:ModelField Name="DELI_CNT" />                                            
                                            <ext:ModelField Name="DELI_NOTE" />
                                            <ext:ModelField Name="STR_LOCNM" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="ZGRTYPNM" />
                                            <ext:ModelField Name="DELI_TYPE" Type="Boolean" />
                                            <ext:ModelField Name="CANCEL_DELI_NOTE" />                                            
                                            <ext:ModelField Name="SOURCING_DIV" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="STR_LOC" />
                                            <ext:ModelField Name="PURC_ORG" />
                                            <ext:ModelField Name="PURC_PO_TYPE" />
                                            <ext:ModelField Name="ZGRTYP" />
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
                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                <Listeners>                                    
                                    <BeforeEdit fn="BeforeEdit" />
                                    <Edit fn ="AfterEdit" />
                                </Listeners>
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:Column ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="180" Align="Left" /><%--Text="업체명"--%>
                                <ext:Column ID="DELI_DATE" ItemID="DELI_DATE" runat="server" DataIndex="DELI_DATE" Width="90" Align="Center" /><%--Text="납품일자"--%>
                                <ext:Column ID="DELI_CNT" ItemID="DELI_CNT" runat="server" DataIndex="DELI_CNT" Width="80" Align="Center" /><%--Text="납품차수"--%>
                                <ext:Column ID="DELI_NOTE" ItemID="DELI_NOTE" runat="server" DataIndex="DELI_NOTE" Width="130" Align="Left" /><%--Text="납품서번호"--%>
                                <ext:Column ID="STR_LOCNM" ItemID="STR_LOCNM" runat="server" DataIndex="STR_LOCNM" Width="140" Align="Left" /><%--Text="저장위치" --%>
                                <ext:Column ID="CUSTNM" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="150" Align="Left" /><%--Text="고객사"--%>
                                <ext:Column ID="ZGRTYPNM" ItemID="ZGRTYP" runat="server" DataIndex="ZGRTYPNM" Width="160" Align="Left" /><%--Text="입고(정산)기준"--%>
                                <ext:CheckColumn runat="server" ID ="DELI_TYPE" ItemID="DELI_CANCEL" Text="납품취소"  DataIndex="DELI_TYPE" Width="90"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Sortable="false" Selectable="true" >                                        
                                </ext:CheckColumn>
                                <ext:Column ID="CANCEL_DELI_NOTE" ItemID="CANCEL_DELI_NOTE" runat="server" DataIndex="CANCEL_DELI_NOTE" Width="130" Align="Left" /><%--Text="취소전 납품서번호"--%>
                                <ext:Column ID="INVOICE_NO" ItemID="INVOICE_NO" runat="server" DataIndex="INVOICE_NO" Width="100" Align="Center"  Text="Vendor Invoice"/><%--Text="Vendor Invoice"--%>
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server"  EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
<%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">
                                <Listeners>
                                    <Select Fn="CellFocus"></Select>
                                </Listeners>
                            </ext:CellSelectionModel>
                        </SelectionModel>
                        <Listeners>
                                <CellClick Fn ="Grid01_CellDbClick"></CellClick>
                                <%--<CellDblClick Fn ="Grid01_CellDbClick"></CellDblClick>--%>
                        </Listeners>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="pnl01_Bottom" Region="Center" runat="server" Flex="2">
                <Items>
                    <ext:Panel ID="ButtonPanel05" runat="server" Region="North" Height="23" Hidden="false" >
                        <Items> 
                            <ext:Panel ID="Panel15" runat="server" StyleSpec="margin-right:10px; float:left;" Width="150" Hidden="false">
                                <Items>
                                    <ext:Label ID="lbl01_DELI_NOTE_DETAIL" runat="server" Cls="bottom_area_title_name2" Text="납품서 상세정보"/><%--Text="납품서 상세정보"--%>
                                </Items>
                            </ext:Panel>
                        </Items> 
                    </ext:Panel>
                    <ext:Panel ID="BottomGridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                        <Items>  
                            <ext:GridPanel ID="Grid02" runat="server" TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store7" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="Model4" runat="server">
                                                <Fields>                                       
                                                    <ext:ModelField Name="NO" />
                                                    <ext:ModelField Name="PO_DELI_DATE" />
                                                    <ext:ModelField Name="PONO_S" />
                                                    <ext:ModelField Name="VINCD" />
                                                    <ext:ModelField Name="PARTNO" />
                                                    <ext:ModelField Name="PARTNM" />
                                                    <ext:ModelField Name="PO_UNITNM" />
                                                    <ext:ModelField Name="UNIT_PACK_QTY_SIM" />
                                                    <ext:ModelField Name="UNIT_PACK_QTY" />
                                                    <ext:ModelField Name="PO_QTY" />
                                                    <ext:ModelField Name="REMAIN_QTY" />
                                                    <ext:ModelField Name="DELI_QTY" /> <%--Type="Int" 수량 소수점 3자리로 변경하여 주석처리. 2018.06.12 --%>
                                                    <ext:ModelField Name="VEND_LOTNO" />
                                                    <ext:ModelField Name="PRDT_DATE" />
                                                    <ext:ModelField Name="CHANGE_4M" />
                                                    <ext:ModelField Name="BOX_QTY" Type="Int" />
                                                    <ext:ModelField Name="DELI_DETAIL_TYPE"  Type="Boolean" DefaultValue=false />
                                                    <ext:ModelField Name="INSPECT_YN" />
                                                    <ext:ModelField Name="CHECK_CERT" />
                                                    <ext:ModelField Name="INPUT_COUNT" />
                                                    <ext:ModelField Name="CHECK_COUNT" />
                                                    <ext:ModelField Name="CUST_ORD_INFO" />
                                                    <ext:ModelField Name="CUSTNM" />
                                                    <ext:ModelField Name="CUST_PONO" />
                                                    <ext:ModelField Name="PURC_GRP" />
                                                    <ext:ModelField Name="PMI" />
                                                    <ext:ModelField Name="SD_PONO" />
                                                    <ext:ModelField Name="UMSONNM" />
                                                    <ext:ModelField Name="PONO" />
                                                    <ext:ModelField Name="PONO_SEQ" />
                                                    <ext:ModelField Name="STR_LOC" />
                                                    <ext:ModelField Name="PO_UNIT" />
                                                    <ext:ModelField Name="DELI_NOTE" />
                                                    <ext:ModelField Name="DELI_NOTE_SEQ" />
                                                    <ext:ModelField Name="BARCODE" />
                                                    <ext:ModelField Name="DELI_CNT" />
                                                    <ext:ModelField Name="DELI_DATE" />
                                                    <ext:ModelField Name="CORCD" />
                                                    <ext:ModelField Name="UMSON" />
                                                    <ext:ModelField Name="INSPECT_YN_CODE" />
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
                                    <%--<ext:BufferedRenderer ID="BufferedRenderer2"  runat="server"/>--%>
                                    <ext:CellEditing ID="CellEditing2" runat="server" ClicksToEdit="1" >
                                        <Listeners>                                    
                                            <BeforeEdit fn="BeforeEdit" />
                                            <Edit fn ="AfterEdit" />
                                        </Listeners>
                                    </ext:CellEditing>
                                </Plugins>  
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ID ="NO2" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" Locked="true" >
                                            <Renderer Fn="rendererNo"></Renderer>
                                        </ext:Column>
                                        <ext:Column ID="PO_DELI_DATE" ItemID="PO_DELI_DATE" runat="server" DataIndex="PO_DELI_DATE" Width="85" Align="Center" Locked="true" /><%--Text="납기일자"--%>
                                        <ext:Column ID="PONO_S" ItemID="PONO" runat="server" DataIndex="PONO_S" Width="110" Align="Left" Locked="true" /><%--Text="발주번호"--%>
                                        <ext:Column ID="VINCD" ItemID="VINCD" runat="server" DataIndex="VINCD" Width="70" Align="Center" Locked="true" /><%--Text="차종"--%>
                                        <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="140" Align="Left" Locked="true" /><%--Text="PART NO"--%>
                                        <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="120" Align="Left" Flex="1" /><%--Text="PART NAME"--%>
                                        <ext:Column ID="PO_UNITNM" ItemID="UNIT" runat="server" DataIndex="PO_UNITNM" Width="55" Align="Center" /><%--Text="UNIT"--%>
                                        <ext:NumberColumn ID="UNIT_PACK_QTY" ItemID="UNIT_PACK_QTY_SIM" runat="server" DataIndex="UNIT_PACK_QTY" Width="110" Align="Right" Format="#,##0.###" Sortable="true"><%--Text="적입량"--%>
                                            <Editor>
                                                <ext:NumberField ID="txt02_UNIT_PACK_QTY" Cls="inputText_Num" FieldCls="inputText_Num" SelectOnFocus="true" runat="server" MinValue="0.5" DecimalPrecision="3"> <%--DecimalPrecision="3" 소수점 3자리 입력 허용.--%>
                                                    <Listeners>
                                                        <SpecialKey Fn="moveFocus"></SpecialKey>
                                                    </Listeners>
                                                </ext:NumberField>
                                            </Editor>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn ID="PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="PO_QTY" Width="90" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="발주량"--%>
                                        <ext:NumberColumn ID="REMAIN_QTY" ItemID="REMAINQTY" runat="server" DataIndex="REMAIN_QTY" Width="120" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="잔량"--%>

                                        <%-- 그리드에 이미지를 클릭할 수 있는 column (팝업을 위한 그리드의 돋보기 버튼)--%>
                                        <ext:ImageCommandColumn ID="ImageCommandColumn1" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="22" Align="Center" >
                                           <Commands>
                                              <ext:ImageCommand Icon="ArrowRight" ToolTip-Text="Copy" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                           </Commands>
                                           <Listeners>
                                              <Command Fn="gridRightButton_Handler" />                                         
                                           </Listeners>
                                        </ext:ImageCommandColumn>

                                        <ext:Column ID="DELI_NOTE_REG" ItemID="DELI_NOTE_REG" runat="server" ><%--Text="납품서등록">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="DELI_QTY" ItemID="DELI_QTY" runat="server" DataIndex="DELI_QTY" Width="120" Align="Right" Format="#,##0.###" Sortable="true"><%--Text="납품량"--%>
                                                    <Editor>
                                                        <ext:NumberField ID="txt02_DELI_QTY" Cls="inputText_Num" FieldCls="inputText_Num" SelectOnFocus="true" runat="server" MinValue="0" DecimalPrecision="3"><%--DecimalPrecision="3" 소수점 3자리 입력 허용.--%>
                                                            <Listeners>
                                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                                            </Listeners>
                                                        </ext:NumberField>
                                                    </Editor>
                                                </ext:NumberColumn>
                                                <ext:DateColumn ID="PRDT_DATE" ItemID="PRDT_DATE" runat="server" Hidden="true"  DataIndex="PRDT_DATE" Width="90" Align="Center" Sortable="true"><%--Text="제조일자"--%>
                                                    <Editor>
                                                        <ext:DateField ID="txt02_PRDT_DATE" runat="server" SelectOnFocus="true">
                                                            <Listeners>
                                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                                            </Listeners>
                                                        </ext:DateField>
                                                    </Editor>
                                                </ext:DateColumn>
                                                <ext:Column ID="VEND_LOTNO" ItemID="VEND_LOTNO" runat="server" Hidden="true"  DataIndex="VEND_LOTNO" Width="100" Align="Left" Sortable="true"><%--Text="업체LOT NO"--%> 
                                                    <Editor>
                                                        <ext:TextField  ID="txt02_VEND_LOTNO" Cls="inputText"  FieldCls="inputText" SelectOnFocus="true" runat="server" Height="22">
                                                            <Listeners>
                                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Editor>
                                                </ext:Column>
                                                <%--Text="4M변경내역"--%> 
                                                <ext:Column ID="CHANGE_4M" ItemID="CHANGE_4M" runat="server" DataIndex="CHANGE_4M" Width="100" Align="Left" Sortable="true" Hidden="true">
                                                    <Editor>
                                                        <ext:TextField  ID="txt02_CHANGE_4M" Cls="inputText" FieldCls="inputText" SelectOnFocus="true" runat="server"  Height="22">
                                                            <Listeners>
                                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:NumberColumn ID="BOX_QTY" ItemID="BOX_QTY" runat="server" DataIndex="BOX_QTY" Width="100" Align="Right" Format="#,##0" Sortable="true"><%--Text="박스수량"--%>
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column> 
                                        <ext:CheckColumn runat="server" ID ="DELI_DETAIL_CANCEL" ItemID="DELI_CANCEL" Text="납품취소"  DataIndex="DELI_DETAIL_TYPE" Width="90"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Sortable="false" Selectable="true" >                                        
                                        </ext:CheckColumn>
                                        <ext:Column ID="INSPECTION" ItemID="INSPECTION" runat="server" Visible="false" ><%--Text="수입검사" 2018.10.17 해외법인 수입검사 컬럼 숨김.--%>
                                            <Columns>
                                                <ext:Column ID="INSPECT_YN" ItemID="INSPECT_YN" runat="server" DataIndex="INSPECT_YN" Width="90" Align="Center" Sortable="true" Visible="false"/><%--Text="유/무검사"--%>
                                                <ext:Column ID="CHECK_CERT" ItemID="CERTIFICATE_YN3" runat="server" DataIndex="CHECK_CERT" Width="100" Align="Center" Sortable="true" Visible="false"/><%--Text="성적서관리"--%>
                                                <ext:Column ID="INPUT_COUNT" ItemID="INPUT_COUNT" runat="server" DataIndex="INPUT_COUNT" Width="120" Align="Right" Sortable="true" Visible="false"/><%--Text="성적서결과입력건수"--%>
                                                <ext:Column ID="CHECK_COUNT" ItemID="CHECK_COUNT" runat="server" DataIndex="CHECK_COUNT" Width="120" Align="Right" Sortable="true" Visible="false"/><%--Text="검사대상항목건수"--%>
                                            </Columns>
                                        </ext:Column> 
                                        <ext:Column ID="CUST_ORD_INFO" ItemID="CUST_ORD_INFO" Hidden="true" runat="server" ><%--Text="고객사수주정보">--%>
                                            <Columns>
                                                <ext:Column ID="CUSTNM2" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="90" Align="Center" Sortable="true"/><%--Text="고객사"--%>
                                                <ext:Column ID="CUST_PONO" ItemID="CUST_PONO" runat="server" DataIndex="CUST_PONO" Width="120" Align="Left" Sortable="true"/><%--Text="고객발주번호"--%>
                                                <ext:Column ID="PURC_GRP" ItemID="PURC_GRP" Hidden="true"  runat="server" DataIndex="PURC_GRP" Width="90" Align="Center" Sortable="true"/><%--Text="구매그룹"--%>
                                                <ext:Column ID="PMI" ItemID="PMI" Hidden="true"  runat="server" DataIndex="PMI" Width="90" Align="Left" Sortable="true"/><%--Text="PMI"--%>
                                                <ext:Column ID="SD_PONO" ItemID="SD_PONO" Hidden="true"  runat="server" DataIndex="SD_PONO" Width="120" Align="Left" Sortable="true"/><%--Text="영업오더번호"--%>
                                            </Columns>
                                        </ext:Column> 
                                        <ext:Column ID="UMSONNM" ItemID="UMSON" runat="server" DataIndex="UMSONNM" Width="100" Align="Center" /><%--Text="유/무상구분"--%>
                                        </Columns>                            
                                </ColumnModel>
                                <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                    <LoadMask ShowMask="true" />
                                </Loader>
                                <View>
                                    <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true">
                                        <%--<GetRowClass Fn="getRowClass" />--%>
                                    </ext:GridView>
                                </View>
                                <%--
                                <SelectionModel>
                                    <ext:CellSelectionModel  ID="CellSelectionModel2" runat="server">
                                        <Listeners>
                                            <Select Fn="CellFocus"></Select>
                                        </Listeners>
                                    </ext:CellSelectionModel >
                                </SelectionModel>
                                --%>
                                <Listeners>
                                    <CellDblClick Fn ="Grid02_CellDbClick"></CellDblClick>
                                </Listeners>
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                </BottomBar>
                            </ext:GridPanel>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="TimeRegistPanel" Region="South" Cls="excel_upload_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
							<col style="width: 140px;" />
							<col style="width: 200px;" />
							<col style="width: 140px;" />
							<col style="width: 130px;" />
							<col style="width: 160px;" />
							<col style="width: 130px;" />
							<col style="width: 150px;" />
							<col style="width: 200px;" />
							<col style="width: 140px;" />
                            <col />
                        </colgroup>
                        <tr>
							<th class="ess">
								<ext:Label ID="lbl01_INVOICE" Text="Vendor Invoice" runat="server"/>
							</th>                                         
							<td>
								<ext:TextField ID="txt01_INVOICE" Width="190" Cls="inputText" MaxLength="25" runat="server" />
							</td>
                            <th class="ess">
                                <ext:Label ID="lbl01_DELI_DATE" runat="server" /><%--납품일자--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_DELI_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="false" ReadOnly="true"  >
                                     <Listeners>
                                        <Change Fn="changeDELI_DATE"></Change>
                                    </Listeners>
                                </ext:DateField>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_ARRIV_DATE" runat="server" /><%--도착예정일자--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_ARRIV_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  >
                                     <Listeners>
                                        <Change Fn="changeARRIV_DATE"></Change>
                                    </Listeners>
                                </ext:DateField>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_ARRIV_TIME" runat="server" /><%--도착예정시간--%>
                            </th>
                            <td>
                                <div style="float:left">
                                    <ext:TextField ID="txt01_ARRIV_TIME" Width="115" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/" MaxLengthText="4" MaxLength="4" EnforceMaxLength="true"> 
                                        <Listeners>
                                            <Change Fn="changeARRIV_TIME"></Change>
                                        </Listeners>
                                    </ext:TextField>
                                </div>
                                <div>&nbsp;(0000~2359)</div>
                            </td>   
                            <th>
                                <ext:Label ID="lbl01_TRUCK_NO" runat="server"/>
                            </th>                   
                            <td>
                                <ext:TextField ID="txt01_TRUCK_NO" Width="150" Cls="inputText" runat="server" />                              
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
