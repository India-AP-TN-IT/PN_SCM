﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_VM20005.aspx.cs" Inherits="Ax.EP.WP.Home.SRM_VM.SRM_VM20005" %>
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

    <title>일반구매업체 기본정보 등록</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <style type="text/css">
    .bottom_area_title_name2 {
        clear: both;
        margin-top: 10px;
        height: 18px;        
        background: url(../../images/common/title_icon_s.gif) 0 8px no-repeat;
        padding-left: 10px;
        font-size: 12px;
        color: #010101;
        text-align: left;
        font-weight: bold;
        };
        
    </style>
    <style type="text/css">
    .x-grid-cell-TRANS_VENDNM1 DIV,	    
        .x-grid-cell-TRANS_AMT1 DIV,	    
        .x-grid-cell-TRANS_RATE1 DIV,	    
	    .x-grid-cell-TRANS_VENDNM2 DIV,	    
	    .x-grid-cell-TRANS_AMT2 DIV,	    
        .x-grid-cell-TRANS_RATE2 DIV,	    
	    .x-grid-cell-TRANS_VENDNM3 DIV,	    
	    .x-grid-cell-TRANS_AMT3 DIV,	    
        .x-grid-cell-TRANS_RATE3 DIV,	    
	    .x-grid-cell-VENDNM DIV,
	    .x-grid-cell-MAIN_ITEM DIV,
	    .x-grid-cell-YEAR_PURCAMT DIV,
	    .x-grid-cell-VIN DIV,
	    .x-grid-cell-INJECTION DIV,
	    .x-grid-cell-FORMING DIV,
	    .x-grid-cell-PRESS DIV,
	    .x-grid-cell-ETC1 DIV,
	    .x-grid-cell-FACILNM DIV,
	    .x-grid-cell-FACIL_MAKER DIV,
	    .x-grid-cell-FACILCNT DIV,
	    .x-grid-cell-FACIL_REMARK DIV,
	    .x-grid-cell-EQUIPNM DIV,
	    .x-grid-cell-EQUIP_MAKER DIV,
	    .x-grid-cell-EQUIPCNT DIV,
	    .x-grid-cell-EQUIP_REMARK DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    };
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">


        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            App.pnl01_FAC.setHeight(470);
            //            App.pnl01_BIZ.setHeight(207);
            App.InputPanel.setHeight(App.pnl01_GEN.getHeight() +
//                                    App.pnl01_EMP_GRP.getHeight() +
                                    App.pnl01_HIS_GRP.getHeight() +
                                    App.pnl01_FIN_GRP.getHeight() +
                                    App.pnl01_STCK_GRP.getHeight() +
                                    App.pnl01_ETC.getHeight() +
                                    App.pnl01_PUR.getHeight() +
                                    App.pnl01_FAC.getHeight() + 10);
        }




        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드 신규행 추가
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var addNewRow = function (grid) {
            grid.editingPlugin.cancelEdit();

            //유형코드를 제외하면 TYPECD=OBJECTID임. 필수 체크할 때는 OBJECTID를 체크하여야함. (코드입력후 0.5초 이후에 조회하여 명칭 가져오는 타이밍때문에 빈값이 있을수 있음.)
            if (App.cdx01_VENDCD_OBJECTID.getValue() == "") {
                //업체코드를 선택하세요.             
                App.direct.MsgCodeAlert_ShowFormat("COM-00901", "cdx01_VENDCD_TYPECD", [App.lbl01_VEND.text]);
                return;
            }

            // Create a record instance through the ModelManager
            var r;

            if (grid.id == "Grid01") {
                //                r = Ext.ModelManager.create({
                //                    VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
                //                    FACILNM1: '',
                //                    FACIL_MAKER1: '',
                //                    FACIL_REMARK1: '',
                //                    FACILCNT: '',
                //                    SEQNO: '',
                //                    ISNEW: true
                //                }, 'ModelGrid');

                r = Ext.create('ModelGrid', {
                    VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
                    FACILNM1: '',
                    FACIL_MAKER1: '',
                    FACIL_REMARK1: '',
                    FACILCNT: '',
                    SEQNO: '',
                    ISNEW: true
                });
            }
            else if (grid.id == "Grid02") {
                //                r = Ext.ModelManager.create({
                //                    VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
                //                    EQUIPNM1: '',
                //                    EQUIP_MAKER1: '',
                //                    EQUIP_REMARK1: '',
                //                    EQUIPCNT: '',
                //                    SEQNO: '',
                //                    ISNEW: true
                //                }, 'ModelGrid02');

                r = Ext.create('ModelGrid02', {
                    VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
                    EQUIPNM1: '',
                    EQUIP_MAKER1: '',
                    EQUIP_REMARK1: '',
                    EQUIPCNT: '',
                    SEQNO: '',
                    ISNEW: true
                });
            }
            else if (grid.id == "Grid03") {
                //                r = Ext.ModelManager.create({
                //                    VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
                //                    STD_YEAR: App.txt02_STD_YEAR.getValue(),
                //                    SEQNO: '',
                //                    VENDNM1: '',
                //                    ITEMNM1: '',
                //                    PURCHASE1: '',
                //                    ISNEW: true
                //                }, 'ModelGrid03');

                r = Ext.create('ModelGrid03', {
                    VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
                    STD_YEAR: App.txt02_STD_YEAR.getValue(),
                    SEQNO: '',
                    VENDNM1: '',
                    ITEMNM1: '',
                    PURCHASE1: '',
                    ISNEW: true
                });
            }
            else if (grid.id == "Grid04") {
                //                r = Ext.ModelManager.create({
                //                    VIN: '',
                //                    INJECTION: '',
                //                    FORMING: '',
                //                    PRESS: '',
                //                    ETC: '',
                //                    TOTAL: '',
                //                    ISNEW: true
                //                }, 'ModelGrid04');
                r = Ext.create('ModelGrid04', {
                    VIN: '',
                    INJECTION: '',
                    FORMING: '',
                    PRESS: '',
                    ETC: '',
                    TOTAL: '',
                    ISNEW: true
                });
            }
            else if (grid.id == "Grid05") {
                //3레코드까지만 신규 추가 가능
                if (grid.store.getCount() >= 3) {
                    App.direct.MsgCodeAlert("SRMVM-0014"); //1차사 거래현황은 최대 3건까지만 등록할 수 있습니다.
                    return;
                }
                //                r = Ext.ModelManager.create({
                //                    VENDNM: '',
                //                    MAIN_ITEM: '',
                //                    SEWING_AMT: '',
                //                    SEWING_RATE: '',
                //                    INJ_AMT: '',
                //                    INJ_RATE: '',
                //                    BUSI_BEG_DATE: '',
                //                    ISNEW: true
                //                }, 'ModelGrid05');
                r = Ext.create('ModelGrid05', {
                    VENDNM: '',
                    MAIN_ITEM: '',
                    SEWING_AMT: '',
                    SEWING_RATE: '',
                    INJ_AMT: '',
                    INJ_RATE: '',
                    BUSI_BEG_DATE: '',
                    ISNEW: true
                });
            }
            grid.store.insert(0, r);
            grid.getSelectionModel().select(0, 2);
            //grid.editingPlugin.startEdit(0, 2); 0번째 줄에 4번째 컬럼을 에디트 모드로 설정하는 샘플 코드
        };

        var removeRow = function (grid, checkColumn) {
            var sm = grid.getSelectionModel();

            if (!sm.getSelection()[0].data[checkColumn]) return;

            Ext.Msg.confirm('Confirm', 'Do you want to delete selected row? ', function (btn, text) {
                if (btn == 'yes') {
                    grid.editingPlugin.cancelEdit();
                    grid.store.remove(sm.getSelection());
                    if (grid.store.getCount() > 0) {
                        sm.select(0);
                    }
                }
                return false;
            })

        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드의 editor를 활성화시키는 시점에서 작동        
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        var t;

        // 그리드를 editor한 후에 발생되는 이벤트
        var AfterEdit = function (rowEditor, e) {

            if (e.grid.id == "Grid04") {
                t = e.grid.getStore();
                //서연이화 보유 금형현황 그리드인경우 합계 계산
                if (e.column.dataIndex == "INJECTION" || e.column.dataIndex == "FORMING" ||
                    e.column.dataIndex == "PRESS" || e.column.dataIndex == "ETC") {
                    var injection = e.grid.getStore().getAt(e.rowIdx).data["INJECTION"] == null ? 0 : Number(e.grid.getStore().getAt(e.rowIdx).data["INJECTION"]);
                    var forming = e.grid.getStore().getAt(e.rowIdx).data["FORMING"] == null ? 0 : Number(e.grid.getStore().getAt(e.rowIdx).data["FORMING"]);
                    var press = e.grid.getStore().getAt(e.rowIdx).data["PRESS"] == null ? 0 : Number(e.grid.getStore().getAt(e.rowIdx).data["PRESS"]);
                    var etc = e.grid.getStore().getAt(e.rowIdx).data["ETC"] == null ? 0 : Number(e.grid.getStore().getAt(e.rowIdx).data["ETC"]);
                    var total = injection + forming + press + etc;

                    e.grid.getStore().getAt(e.rowIdx).data["TOTAL"] = total;

                    setGrid04Total(e.grid.getStore()); //전 레코드 합계계산하여 하단에 표시함.

                    e.grid.view.refreshNode(e.rowIdx);
                }

            }

            if (e.column.dataIndex != "CHECK_VALUE") {
                e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", false);
                e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", e.grid.getStore().getAt(e.rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
            } else {
                e.grid.getStore().getAt(e.rowIdx).dirty = e.grid.getStore().getAt(e.rowIdx).data["CHECK_VALUE"];
            }

        }

        // 그리드의 cell에 포커스가 갈 경우에 자동으로 editor가 실행이 되도록 한다. 
        // 원인: 그리드 내의 콤보박스는 editor을 포함하지 않아 eiditorTab 이벤트가 실행이되지 않음. 따라서 콤보박스에서 tab을 눌렀을 경우에 
        // editor가 포함된 cell에 포커스가 가면 editor가 실행이 되고 이후에 tab을 클릭하면 editor가 포함된 cell로 자동으로 이동이 된다.
        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            var grid = selectionModel.view.ownerCt;

            grid.editingPlugin.startEdit(rowIndex, colIndex);
        }


        function checkExtension(value) {
            if (value.match("\.pdf$") != null) {
                return true;
            }

            return "Incorrect file type";
        }

        function fn_toNumber(val) {

            var re = /,/g;
            if (val == null || val == "")
                return 0;
            else {
                var ret = val.toString();
                return parseInt(ret.replace(re, ""), 10);
            }

        }

        function fn_toCommaString(num) {

            var len, point, str;

            num = num + "";
            var under0 = num.indexOf("."); //소수점 분리
            var rest = "";
            if (under0 != -1) {
                rest = num.substring(under0, num.length);
                num = num.substr(0, under0);

            }

            point = num.length % 3
            len = num.length;

            str = num.substring(0, point);
            while (point < len) {
                if (str != "") str += ",";
                str += num.substring(point, point + 3);
                point += 3;
            }
            return str + rest;
        }

        //재무제표 정보 계산
        function fn_FinancialChange() {

            //부채
            var debt = fn_toNumber(App.txt01_DEBT.getValue());

            //자기자본
            var quity = fn_toNumber(App.txt01_QUITY.getValue());

            //총매출
            var total_sales = fn_toNumber(App.txt01_TOTAL_SALES.getValue());

            //총원           
            var all_cnt = fn_toNumber(App.txt01_ALL_CNT.getValue());

            //영업이익
            var biz_sales = fn_toNumber(App.txt01_BUSINESS_PROFITS.getValue());

            // 자산 = 부채+자기자본
            App.txt01_ASSETS.setValue(fn_toCommaString(debt + quity));

            //부채비율 = 부채 / 자기자본
            if (quity > 0)
                App.txt01_DEBT_RATE.setValue(fn_toCommaString(Math.round(debt / quity * 100)));
            else
                App.txt01_DEBT_RATE.setValue(null);

            //자본회전율 = 총매출 / 자기자본
            if (quity > 0)
                App.txt01_TURNOVER_RATE.setValue(fn_toCommaString(Math.round(total_sales / quity * 100)));

            //인당매출 = 총매출 / 총원
            if (all_cnt > 0)
                App.txt01_PERSON_SALES.setValue(fn_toCommaString(Math.round(total_sales / all_cnt)));

            //영업이익율 = 영업이익/총매출 *100
            if (total_sales > 0) {
                var rate = Math.round(biz_sales / total_sales * 100 * 100);
                App.txt01_ORDINARY_INCOME.setValue(fn_toCommaString(rate / 100));
            }
        }

        //재무제표 정보 거래비율 계산
        function fn_RateChange() {
            var hkmc = 0;
            var val = App.txt01_HKMC_TRADE_RATE.getValue();
            if (val != null) {
                hkmc = parseInt(val, 10);
            }
            App.txt01_ETC_TRACE_RATE.setValue(100 - hkmc);
        }
        //임직원정보 합계 계산
        function fn_EmployeeChange() {
            var executive = ((App.txt01_EXECUTIVE.getValue() == null) ? 0 : parseInt(App.txt01_EXECUTIVE.getValue(), 10));
            var manager = ((App.txt01_MANAGER.getValue() == null) ? 0 : parseInt(App.txt01_MANAGER.getValue(), 10));
            var prod_local = ((App.txt01_PROD_LOCAL.getValue() == null) ? 0 : parseInt(App.txt01_PROD_LOCAL.getValue(), 10));
            var prod_foreign = ((App.txt01_PROD_FOREIGN.getValue() == null) ? 0 : parseInt(App.txt01_PROD_FOREIGN.getValue(), 10));
            var subcontract = ((App.txt01_SUBCONTRACT.getValue() == null) ? 0 : parseInt(App.txt01_SUBCONTRACT.getValue(), 10));

            App.txt01_PROD_TOTAL.setValue(prod_local + prod_foreign);
            App.txt01_ALL_CNT.setValue(executive + manager + prod_local + prod_foreign + subcontract);

        }

        // 숫자타입에서 .formatString()을 사용하면 천단위 구분 문자 ","가 들어간 문자열로 변환
        // 예) var test = 10000; 
        //     alert(test.formatString());  ==> "10,000" 
        Number.prototype.formatString = function () {
            if (this == 0) return "0";

            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (this + '');

            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');

            return n;
        };

        //서연이화 금형보유현황 총계 계산
        function setGrid04Total(store) {
            var i = 0;
            var rowcnt = store.count();
            var injection = 0;
            var forming = 0;
            var press = 0;
            var etc = 0;
            var total = 0;
            for (i = 0; i < rowcnt; i++) {
                injection += store.getAt(i).data["INJECTION"] == null ? 0 : Number(store.getAt(i).data["INJECTION"]);
                forming += store.getAt(i).data["FORMING"] == null ? 0 : Number(store.getAt(i).data["FORMING"]);
                press += store.getAt(i).data["PRESS"] == null ? 0 : Number(store.getAt(i).data["PRESS"]);
                etc += store.getAt(i).data["ETC"] == null ? 0 : Number(store.getAt(i).data["ETC"]);
                total += store.getAt(i).data["TOTAL"] == null ? 0 : Number(store.getAt(i).data["TOTAL"]);
            }

            App.lbl01_INJECTION_TOT.setText(injection.formatString());
            App.lbl01_FORMING_TOT.setText(forming.formatString());
            App.lbl01_PRESS_TOT.setText(press.formatString());
            App.lbl01_ETC_TOT.setText(etc.formatString());
            App.lbl01_TOTAL_TOT.setText(total.formatString());
        }



        var PrintReport = function (btn) {

            if (btn == "yes")
                App.direct.Print();
            else if (btn == "no")
                App.direct.Print2();

        }

        function NumberOnly(obj, e) {

            e = e || window.event;


            //e.keyCode == 8 : back space
            //e.keyCode == 8 : delete
            //e.keyCode >= 48 && e.keyCode <= 57 : 숫자
            //e.keyCode >= 96 && e.keyCode <= 105 : 숫자(num pad)
            //숫자만 입력 
            return e.keyCode == 8 || e.keyCode == 46 ||
                    (e.keyCode >= 48 && e.keyCode <= 57) ||
                    (e.keyCode >= 96 && e.keyCode <= 105);

        }
        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }
        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.

            var grid = App.Grid05;
            var rowIdx = App.CodeRow.getValue();



            grid.getStore().getAt(App.CodeRow.getValue()).set("SQ_CATEGORYNM", typeNM);
            grid.getStore().getAt(App.CodeRow.getValue()).set("SQ_CATEGORY", objectID);


            // 필수코드 ( 반드시 )
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", false);
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", grid.getStore().getAt(rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        텍스트에서 enter키를 누를경우(버튼과 동일하나 넘어오는 파라메터가 달라서 찾기 버튼이벤트는 PopupHandler_button으로 하단에 구현
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var PopupHandler = function (editor, e) {
            /*
            e.getKey()
            editor.getValue()               - 현재 선택된 TEXTFIELD            
            */
            var grd = editor.ownerCt.grid;

            if (e.getKey() === e.ENTER) {
                // BeforeEdit에서 param e를 전역 currentCellObject에 담아두고 Enter Key시에 사용한다. 
                // 이유 : 팝업창 뜬이후에 포커스가 바뀌면 row, col index가 변경되는 현상이 생겼음.
                App.CodeRow.setValue(currentCellObject.rowIdx);
                App.CodeCol.setValue(currentCellObject.colIdx);


                PopUpFire();
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드에서 버튼을 클릭했을때 팝업을 띄어주는 메서드
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var PopupHandler_button = function (editor, command, row, rowIndex, colIndex) {
            //var grd = editor.grid;
            var grd = editor.ownerCt.grid;

            App.CodeRow.setValue(rowIndex);
            App.CodeCol.setValue(colIndex - 1); // 버튼의 이전행이 무조껀 코드가 되어야한다.

            PopUpFire();
        }

        var PopUpFire = function () {
            App.btn01_SQ_CATEGORY.fireEvent('click');
        }

        function fn_txt01_STD_YEAR_Change() {
            App.direct.txt01_STD_YEAR_Change();
        }

        function fn_txt02_STD_YEAR_Change() {
            App.direct.txt02_STD_YEAR_Change();
        }

        function fn_txt03_STD_YEAR_Change() {
            App.direct.txt03_STD_YEAR_Change();
        }

        //화면 로딩시 업체로 로그인한 경우 기본으로 해당 업체코드가 박혀 있으므로 자동 조회되도록 함.
        function DefaultSearch() {
            if (App.cdx01_VENDCD_TYPECD.value != undefined && App.cdx01_VENDCD_TYPECD.value != "") {
                App.ButtonSearch.fireEvent('click');
            }
        }
    </script>
</head>
<body>
    <form id="SRM_VM20005" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();DefaultSearch();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_SQ_CATEGORY" runat="server" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn"  OnDirectClick="etc_Button_Click" Hidden="true"/>
    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="CodeCol" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col index (사용하지 않으나 차후 필요할지 몰라서)--%>
    <ext:Label ID="Pur_Hid"  runat="server" Hidden="true"/>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>           
        </Listeners>
        <Items>
            <%--타이틀 및 공통버튼 영역--%>
            <ext:Panel ID="TitlePanel" Region="North" runat="server" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_VM20005" runat="server" Cls="search_area_title_name"/><%--Text="업체 기본현황 작성" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>

            <%--조회조건 영역--%>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />    
                            <col style="width: 400px;" />                        
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" Text="Vender Code"/><%--Text="Vender Code" />--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"
                                                OnAfterValidation="cdx01_VENDCD_AfterValidation"/>
                            </td>   
                            <td >                               
                              
                            </td>
                        </tr>                        
                    </table>
                </Content>
            </ext:Panel>

            <%--입력 영역--%>
            <ext:Panel ID="InputPanel" runat="server" Width="1260" Height="2630" Region="Center" Scrollable="Both" StyleSpec="overflow:auto;" > 
                <Items>

                    <%--1.일반정보--%>
                    <ext:Label ID="lbl01_TIT_GEN" runat="server" Cls="bottom_area_title_name" /><%--Text="일반정보"--%>
                    <ext:Panel ID="pnl01_GEN" Cls="excel_upload_area_table" runat="server" StyleSpec="width:1200px !important;">
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 50px;" />
                                    <col style="width: 100px;" />
                                    <col style="width: 200px;"/>
                                    <col style="width: 150px;"/>
                                    <col style="width: 200px;"/>
                                    <col style="width: 150px;"/>
                                    <col />
                                </colgroup>
                                <tr>
                                    <th colspan="2">
                                        <ext:Label ID="lbl01_VEND_NATION" runat="server" /><%--Text="업체소속국가" />--%>
                                    </th>
                                    <td>
                                        <ext:TextField ID="txt01_VEND_NATCD"  runat="server" Width="150" Cls="inputText" />
                                    </td>    
                                    <th>
                                        <ext:Label ID="lbl01_CITY" runat="server" /><%--Text="도시" />--%>
                                    </th>  
                                    <td>
                                        <ext:TextField ID="txt01_CITY"  runat="server" Width="150" Cls="inputText" />
                                    </td>
                                    <th>
                                        <ext:Label ID="lbl01_VEND_CHASU" runat="server" /><%--Text="업체차수(HKMC기준)" />--%>
                                    </th>
                                    <td>
                                        <ext:SelectBox ID="cbo01_VEND_TIER" runat="server"  Mode="Local" ForceSelection="true" DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="100">
                                            <Store>
                                                <ext:Store ID="Store1" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model1" runat="server">
                                                            <Fields>
                                                                <ext:ModelField Name="OBJECT_NM" />
                                                                <ext:ModelField Name="OBJECT_ID" />
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                        </ext:SelectBox>
                                    </td>    
                                </tr>        
                                <tr>
                                    <th colspan="2" class="ess">
                                          <ext:Label ID="lbl02_VENDNM_LOC" runat="server" /><%--Text="현지어" />--%>
                                    </th>
                                    <td colspan="5">
                                        <ext:TextField ID="txt01_VENDNM"  runat="server" Width="1047" Cls="inputText" />
                                    </td>                                       
                                </tr>
                                <tr>
                                    <th colspan="2" class="ess">
                                        <ext:Label ID="lbl01_CMPNO" runat="server" /><%--Text="사업자등록번호" />--%>
                                    </th>
                                    <td colspan="3">
                                        <ext:TextField ID="txt01_RESI_NO"  runat="server" Width="500" Cls="inputText" FieldCls="inputText"  MaskRe="/[0-9]/" MaxLength="10">
                                            <Listeners>
                                                <KeyDown Handler="NumberOnly(this, event);"></KeyDown>
                                            </Listeners>
                                        </ext:TextField>
                                    </td>    
                                    <th>
                                        <ext:Label ID="lbl01_CHR_EMAIL" runat="server" /><%--Text="전자우편" />--%>
                                    </th>  
                                    <td>
                                        <ext:TextField ID="txt01_EMAIL"  runat="server" Width="347" Cls="inputText" />
                                    </td>                                    
                                </tr>
                                <tr>
                                    <th colspan="2">
                                        <ext:Label ID="lbl01_TEL" runat="server" /><%--Text="전화번호" />--%>
                                    </th>
                                    <td colspan="3">
                                        <ext:TextField ID="txt01_TEL"  runat="server" Width="500" Cls="inputText" FieldCls="inputText" MaskRe="/[0-9-]/"/>
                                    </td>    
                                    <th>
                                        <ext:Label ID="lbl01_FAX" runat="server" /><%--Text="팩스번호" />--%>
                                    </th>  
                                    <td>
                                        <ext:TextField ID="txt01_FAX"  runat="server" Width="347" Cls="inputText" FieldCls="inputText" MaskRe="/[0-9-]/"/>
                                    </td>                                    
                                </tr>
                                <tr>
                                    <th class="line">
                                        <ext:Label ID="lbl01_ADDR" runat="server" /><%--Text="주소" />--%>
                                    </th>
                                    <th>
                                        <ext:Label ID="lbl02_LOCAL_LANG" runat="server" /><%--Text="현지어" />--%>
                                    </th>
                                    <td colspan="5">
                                        <ext:TextField ID="txt01_ADDR"  runat="server" Width="1047" Cls="inputText" />
                                    </td>                                   
                                </tr>
                            </table>
                        </Content>
                    </ext:Panel>

                   <%--2.대표자정보--%>
                    <ext:Panel ID="pnl01_REP" runat="server"  Width="540"  StyleSpec="margin-right:20px; float:left;">
                        <Items>
                            <ext:Label ID="lbl01_TIT_REP"  runat="server"  Cls="bottom_area_title_name" /> <%--Text="대표자정보"--%>
                            <ext:Panel ID="Panel2" Cls="excel_upload_area_table" runat="server" >
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 50px;" />
                                    <col style="width: 100px;" />
                                    <col />
                                </colgroup>
                                <tr>
                                    <th style="height:40px !important;" colspan="2">
                                        <ext:Label ID="lbl01_NAME_LOCAL" runat="server" /><%--Text="성명(현지어)" />--%>
                                    </th>
                                    <td>
                                        <ext:TextField ID="txt01_REP_NAME"  runat="server" Width="387" Cls="inputText" />
                                    </td>  
                                </tr>  
                                <tr>
                                    <th style="height:40px !important;" colspan="2">
                                        <ext:Label ID="lbl01_BIRTHDAY2" runat="server" /><%--Text="생년월일" />--%>
                                    </th>
                                    <td>
                                        <ext:DateField ID="df01_BIRTH_DATE"  Width="150"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                                    </td>  
                                </tr>  
                                <tr>
                                    <th style="height:40px !important;" colspan="2">
                                        <ext:Label ID="lbl01_PRMT_ADDR3" runat="server" /><%--Text="본적" />--%>
                                    </th>
                                    <td>
                                        <ext:TextField ID="txt01_FAMILY_ADDR"  runat="server" Width="387" Cls="inputText" />
                                    </td>  
                                </tr>           
                            </table>
                        </Content>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>

                   <%--10.연혁--%>
                    <ext:Panel ID="pnl01_HIS_GRP" runat="server"  Width="640">
                        <Items>
                            <ext:Label ID="lbl01_TIT_HIS" runat="server" Cls="bottom_area_title_name"/><%--Text="연혁"--%>
                            <ext:Panel ID="pnl01_HIS" Cls="excel_upload_area_table" runat="server" >
                                <Content>
                                    <table  style="width:450px !important">
                                        <colgroup>
                                            <col style="width: 150px;" />                                        
                                            <col />                                                   
                                        </colgroup>                                      
                                        <tr>
                                            <th><ext:Label ID="lbl02_FOUNDDATE" runat="server" /><%--Text="설립일자" />--%></th>
                                            <td class="vt_am"><ext:DateField ID="df01_FOUND_DATE"  Width="150"  Cls="inputDate" Type="Date" runat="server" Editable="true"   /></td>
                                        </tr>
                                        <tr>
                                            <th><ext:Label ID="lbl01_FOUNDER" runat="server" /><%--Text="설립자" />--%></th>
                                            <td class="vt_am"><ext:TextField ID="txt01_FOUNDER"  runat="server" Width="535" Cls="inputText" /></td>
                                        </tr>
                                        <tr>
                                            <th><ext:Label ID="lbl01_CURR_REP" runat="server" /><%--Text="現오너" />--%></th>
                                            <td class="vt_am"><ext:TextField ID="txt01_CURR_HEAD"  runat="server" Width="535" Cls="inputText" /></td>
                                        </tr>
                                        <tr>
                                            <th><ext:Label ID="lbl01_REP_RELATION" runat="server" /><%--Text="설립자와의 관계" />--%></th>
                                            <td class="vt_am"><ext:TextField ID="txt01_RELATION"  runat="server" Width="535" Cls="inputText" /></td>
                                        </tr>
                                    </table>
                                </Content>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>

                    <%--3.임직원정보--%>
                    <ext:Panel ID="pnl01_EMP_GRP" runat="server" Width="250" StyleSpec="margin-right:20px; float:left;">
                        <Items>
                            <ext:Label ID="lbl01_TIT_EMP" runat="server" Cls="bottom_area_title_name"/>  <%--Text="임직원정보"--%>
                            <ext:Panel ID="pnl01_EMP" Cls="excel_upload_area_table" runat="server" >
                                <Content>
                                    <table>
                                        <colgroup>
                                            <col style="width: 75px;" />
                                            <col style="width: 75px;" />
                                            <col />                                                   
                                        </colgroup>
                                        <tr>
                                            <th colspan="2">
                                                <ext:Label ID="lbl01_ADJUST_CNT" runat="server" /><%--Text="총원" />--%>
                                            </th>
                                            <td >
                                                <ext:NumberField ID="txt01_ALL_CNT"  runat="server" Width="100" Cls="inputText_Num bg_ea" FieldCls="inputText_Num bg_ea" ReadOnly="true" HideTrigger="true"/>
                                            </td> 
                                        </tr>
                                        <tr>
                                            <th colspan="2">
                                                <ext:Label ID="lbl01_OFFICER_NM" runat="server" /><%--Text="임원" />--%>
                                            </th>
                                            <td >
                                                <ext:NumberField ID="txt01_EXECUTIVE"  runat="server" Width="100" Cls="inputText_Num" FieldCls="inputText_Num" Step="1" HideTrigger="true" MinValue="0">
                                                    <Listeners>
                                                        <Change Fn="fn_EmployeeChange"></Change>
                                                    </Listeners>
                                                </ext:NumberField>
                                            </td> 
                                        </tr>
                                        <tr>
                                            <th colspan="2">
                                                <ext:Label ID="lbl01_MANAGER_NM" runat="server" /><%--Text="관리직" />--%>
                                            </th>
                                            <td >
                                                <ext:NumberField ID="txt01_MANAGER"  runat="server" Width="100" Cls="inputText_Num" FieldCls="inputText_Num" Step="1" HideTrigger="true" MinValue="0">
                                                   <Listeners>
                                                        <Change Fn="fn_EmployeeChange"></Change>
                                                    </Listeners>
                                                </ext:NumberField>
                                            </td> 
                                        </tr>
                                        <tr>
                                            <th rowspan="3" class="line">
                                                <ext:Label ID="lbl01_PRODUCER_NM" runat="server" /><%--Text="생산직" />--%>
                                            </th>
                                            <th>
                                                <ext:Label ID="lbl01_TOT2" runat="server" /><%--Text="계" />--%>
                                            </th>
                                            <td>
                                                <ext:NumberField ID="txt01_PROD_TOTAL"  runat="server" Width="100" Cls="inputText_Num bg_ea" FieldCls="inputText_Num bg_ea" ReadOnly="true" HideTrigger="true"/>
                                                    
                                            </td> 
                                        </tr>
                                        <tr>
                                            <th>
                                                <ext:Label ID="lbl01_NATIVE" runat="server" /><%--Text="내국인" />--%>
                                            </th>
                                            <td>
                                                <ext:NumberField ID="txt01_PROD_LOCAL"  runat="server" Width="100" Cls="inputText_Num" FieldCls="inputText_Num" Step="1" HideTrigger="true" MinValue="0">
                                                   <Listeners>
                                                        <Change Fn="fn_EmployeeChange"></Change>
                                                    </Listeners>
                                                </ext:NumberField>
                                            </td> 
                                        </tr>
                                        <tr>
                                            <th>
                                                <ext:Label ID="lbl01_NATIVE_DIV" runat="server" /><%--Text="외국인" />--%>
                                            </th>
                                            <td>
                                                <ext:NumberField ID="txt01_PROD_FOREIGN"  runat="server" Width="100" Cls="inputText_Num" FieldCls="inputText_Num" Step="1" HideTrigger="true" MinValue="0">
                                                    <Listeners>
                                                        <Change Fn="fn_EmployeeChange"></Change>
                                                    </Listeners>
                                                </ext:NumberField>
                                            </td> 
                                        </tr>
                                        <tr>
                                            <th colspan="2">
                                                <ext:Label ID="lbl01_SUBCONTR_CNT" runat="server" /><%--Text="하도급" />--%>
                                            </th>
                                            <td >
                                                <ext:NumberField ID="txt01_SUBCONTRACT"  runat="server" Width="100" Cls="inputText_Num" FieldCls="inputText_Num"  Step="1" HideTrigger="true" MinValue="0">
                                                    <Listeners>
                                                        <Change Fn="fn_EmployeeChange"></Change>
                                                    </Listeners>
                                                </ext:NumberField>
                                            </td> 
                                        </tr>

                                    </table>
                                </Content>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>

                    <%--4.재무제표현황--%>
                    <ext:Panel ID="pnl01_FIN_GRP" runat="server" Width="930">
                        <Items>
                            <ext:Panel ID="Panel11" runat="server" Height="30" Hidden="false">
                                <Items> 
                                    <ext:Panel ID="Panel12" runat="server" StyleSpec="margin-top:10px;margin-right:20px; float:left;" Width="400">
                                        <Items>
                                            <ext:Label ID="lbl01_TIT_FIN" runat="server" Cls="bottom_area_title_name2"  Width="400px"/><%--Text="재무제표현황"--%>
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="Panel17" runat="server" Width="200" Hidden="false" Cls="bottom_area_btn" StyleSpec="margin-top:5px;">
                                        <Items>
              
                                            <ext:Button ID="btn06_DELETE" runat="server" TextAlign="Center" Cls="mg_r4" Width="72px" StyleSpec="margin-left:10px;margin-bottom:5px;"><%--Text="삭제" >--%>
                                                <DirectEvents>
                                                    <Click OnEvent="etc_Button_Click" >
                                                        <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want delete?"></Confirmation>  
                                                    </Click>
                                                </DirectEvents>
                                            </ext:Button>    
                                           
                                            <ext:Button ID="btn06_SAVE" runat="server" TextAlign="Center" Cls="mg_r4" Width="72px" StyleSpec="margin-bottom:5px;margin-right:0px" ><%--Text="저장" >--%>
                                                <DirectEvents>
                                                    <Click OnEvent="etc_Button_Click" >
                                                        <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want save?"></Confirmation>  
                                                    </Click>
                                                </DirectEvents>
                                            </ext:Button>   
                                        </Items>
                                    </ext:Panel>      
                                </Items>
                            </ext:Panel>
                            <ext:Panel ID="pnl01_FIN" Cls="excel_upload_area_table" runat="server" >
                                <Content>
                                    <table style="height:0px;">
                                        <colgroup>
                                            <col style="width: 150px;" />
                                            <col style="width: 250px;" />                                            
                                            <col style="width: 150px;" />
                                            <col style="width: 80px;" />
                                            <col style="width: 100px;" />
                                            <col />
                                        </colgroup>
                                        <tr>
                                            <th style="height:35px !important;">
                                                <ext:Label ID="lbl01_STD_YEAR" runat="server" /><%--Text="기준년도" />--%>
                                            </th>
                                            <td><ext:NumberField ID="txt01_STD_YEAR" Width="100" Cls="inputText_Code" FieldCls="inputText_Code" AllowDecimals="true" Step="1" MinValue="1900" MaxValue="9999" runat="server" >
                                                    <%--<DirectEvents>
                                                        <Change OnEvent="txt01_STD_YEAR_Change" />
                                                    </DirectEvents>--%>
                                                    <Listeners>
                                                        
                                                        <Change Fn="fn_txt01_STD_YEAR_Change"></Change>
                                                    </Listeners>
                                                </ext:NumberField>
                                            </td>
                                            <th style="height:35px !important;">
                                                <ext:Label ID="lbl01_MONEY_UNIT" runat="server" /><%--Text="화폐단위" />--%>
                                            </th> 
                                            <td colspan="3">
                                                <epc:EPCodeBox ID="cdx01_MONEY_UNIT" runat="server" ClassID="I2" PopupMode="Search" PopupType="CodeWindow"/>
                                            </td>                                           
                                        </tr>
                                        <tr>
                                            <th style="height:35px !important;">
                                                <ext:Label ID="lbl01_DEBT" runat="server" /><%--Text="부채" />--%></th>
                                            <td>                                                
                                                <ext:TextField runat="server" ID="txt01_DEBT" Width="245" Cls="inputText_Num" FieldCls="inputText_Num" MaskRe="/[0-9\-\,]/">
                                                    <Listeners>
                                                        <Focus Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0'));" />
                                                        <Blur Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0,0'));" />
                                                        
                                                        <Change Fn="fn_FinancialChange"></Change>
                                                    </Listeners>                                                   
                                                </ext:TextField>
                                            </td>
                                            <th style="height:35px !important;">
                                                <ext:Label ID="lbl01_ASSET" runat="server" /></th><%--Text="자산" />--%>
                                            <td colspan="3">
                                                <%--<ext:NumberField ID="txt01_ASSETS" Width="337" Cls="inputText_Num" FieldCls="inputText_Num" AllowDecimals="true" Step="1" runat="server" ReadOnly="true"/></td>--%>
                                                <ext:TextField runat="server" ID="txt01_ASSETS" Width="390" Cls="inputText_Num bg_ea" FieldCls="inputText_Num" Enabled="false" ReadOnly="true" >                                                                                                   
                                                </ext:TextField>
                                            </tr>
                                         <tr>
                                            <th style="height:35px !important;"><ext:Label ID="lbl01_CAPITAL" runat="server" /><%--Text="자기자본" />--%></th>
                                            <td>
                                                <ext:TextField runat="server" ID="txt01_QUITY" Width="245" Cls="inputText_Num" FieldCls="inputText_Num" MaskRe="/[0-9\-\,]/">
                                                    <Listeners>
                                                        <Focus Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0'));" />
                                                        <Blur Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0,0'));" />
                                                        <Change Fn="fn_FinancialChange"></Change>
                                                    </Listeners>
                                                  
                                                </ext:TextField>
                                                </td>
                                            <th style="height:35px !important;">
                                                <ext:Label ID="lbl01_PERSON_SALES" runat="server" /></th><%--Text="인당매출" />--%>
                                            <td colspan="3">                                               
                                                <ext:TextField runat="server" ID="txt01_PERSON_SALES" Width="390" Cls="inputText_Num bg_ea" FieldCls="inputText_Num"  ReadOnly="true">
                                                </ext:TextField>                                        
                                            </tr>
                                        <tr>
                                            <th style="height:35px !important;"><ext:Label ID="lbl01_TOT_SALAMT" runat="server" /><%--Text="총매출" />--%></th>
                                            <td>
                                                <ext:TextField runat="server" ID="txt01_TOTAL_SALES" Width="245" Cls="inputText_Num" FieldCls="inputText_Num" MaskRe="/[0-9\-\,]/">
                                                    <Listeners>
                                                        <Focus Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0'));" />
                                                        <Blur Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0,0'));" />
                                                        <Change Fn="fn_FinancialChange"></Change>
                                                       
                                                    </Listeners>                                                  
                                                </ext:TextField>
                                            </td>
                                            <th style="height:35px !important;">
                                                <ext:Label ID="lbl01_DEBT_RATE" runat="server" ReadOnly="true"/><%--Text="부채비율" />--%></th>
                                            <td colspan="3">
                                                <ext:TextField runat="server" ID="txt01_DEBT_RATE" Width="390" Cls="inputText_Num bg_ea" FieldCls="inputText_Num"  ReadOnly="true">                                                                                                   
                                                </ext:TextField>
                                             </tr>
                                        <tr>
                                            <th style="height:35px !important;"><ext:Label ID="lbl01_BIZ_PROFITS" runat="server" /><%--Text="영업이익" />--%></th>
                                            <td>
                                                <ext:TextField runat="server" ID="txt01_BUSINESS_PROFITS" Width="245" Cls="inputText_Num" FieldCls="inputText_Num" MaskRe="/[0-9\-\,]/">
                                                    <Listeners>
                                                        <Focus Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0'));" />
                                                        <Blur Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0,0'));" />
                                                        <Change Fn="fn_FinancialChange"></Change>
                                                    </Listeners>                                                   
                                                </ext:TextField>
                                            </td>    
                                            <th style="height:35px !important;"><ext:Label ID="lbl01_CAPITAL_RATE" runat="server" ReadOnly="true"/><%--Text="자본회전율" />--%></th>
                                            <td colspan="3">
                                                <ext:TextField runat="server" ID="txt01_TURNOVER_RATE" Width="390" Cls="inputText_Num bg_ea" FieldCls="inputText_Num"  ReadOnly="true">                                                                                                   
                                                </ext:TextField>
                                            </td>     
                                           
                                        </tr>
                                        <tr>
                                            <th style="height:35px !important;"><ext:Label ID="lbl01_BIZ_PROFITS_RATE" runat="server" /><%--Text="경상이익" ==> 영업이익률로 변경/>--%></th>
                                            <td>
                                                <ext:TextField runat="server" ID="txt01_ORDINARY_INCOME" Width="245" Cls="inputText_Num bg_ea" FieldCls="inputText_Num" MaskRe="/[0-9\-\,]/" ReadOnly="true">
                                                   <%-- <Listeners>
                                                        <Focus Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0'));" />
                                                        <Blur Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0,0'));" />                                                        
                                                    </Listeners>    --%>                                                
                                                </ext:TextField>
                                            </td>    
                                            <th style="height:35px !important;"><ext:Label ID="lbl01_HKMC_RATE" runat="server" /><%--Text="HKMC 거래비율" />--%></th>
                                            <td class="vt_am">
                                                <ext:NumberField ID="txt01_HKMC_TRADE_RATE" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" AllowDecimals="true" Step="1" runat="server" MinValue="0" MaxValue="100" HideTrigger="true">
                                                    <Listeners>
                                                        <Change Fn="fn_RateChange"></Change>
                                                    </Listeners>                                                   
                                                </ext:NumberField></td>     
                                            <th style="height:35px !important;"><ext:Label ID="lbl01_ETC_RATE" runat="server" /><%--Text="기타 매출비율" />--%></th>
                                            <td class="vt_am"><ext:NumberField ID="txt01_ETC_TRACE_RATE" Width="203" Cls="inputText_Num bg_ea" FieldCls="inputText_Num bg_ea" AllowDecimals="true" Step="1" runat="server" ReadOnly="true" HideTrigger="true"/></td>                                                                                                                           
                                        </tr>
                                    </table>
                                </Content>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>

                    <%--7.주주현황--%>
                    <ext:Panel ID="pnl01_STCK_GRP" runat="server" Width="555">
                        <Items>
                            <ext:Label ID="lbl01_TIT_STCK" runat="server" Cls="bottom_area_title_name"/><%--Text="주주현황"--%>
                            <ext:Panel ID="pnl01_STCK" Cls="excel_upload_area_table" runat="server" >
                                <Content>
                                    <table style="height:0px;">
                                        <colgroup>
                                            <col style="width: 150px;" />
                                            <col style="width: 100px;" />
                                            <col style="width: 100px;" />
                                            <col style="width: 100px;" />
                                            <col />                                                   
                                        </colgroup>
                                        <tr>
                                            <th class="line">
                                                
                                            </th>
                                            <th class="line">
                                                <ext:Label ID="lbl01_STOCK1" runat="server" /><%--Text="대주주1" />--%>
                                            </th> 
                                            <th class="line">
                                                <ext:Label ID="lbl01_STOCK2" runat="server" /><%--Text="대주주2" />--%>
                                            </th> 
                                            <th class="line">
                                                <ext:Label ID="lbl01_STOCK3" runat="server" /><%--Text="대주주3" />--%>
                                            </th> 
                                            <th>
                                                <ext:Label ID="lbl01_STOCK4" runat="server" /><%--Text="대주주4" />--%>
                                            </th> 
                                        </tr>
                                        <tr>
                                            <th class="line"><ext:Label ID="lbl02_NAME_EN" runat="server" /><%--Text="성명(영어)" />--%></th>
                                            <td class="vt_am"><ext:TextField ID="txt01_SHAREHOLDER_EN1"  runat="server" Width="100" Cls="inputText" /></td>
                                            <td class="vt_am"><ext:TextField ID="txt01_SHAREHOLDER_EN2"  runat="server" Width="100" Cls="inputText" /></td>
                                            <td class="vt_am"><ext:TextField ID="txt01_SHAREHOLDER_EN3"  runat="server" Width="100" Cls="inputText" /></td>
                                            <td class="vt_am"><ext:TextField ID="txt01_SHAREHOLDER_EN4"  runat="server" Width="100" Cls="inputText" /></td>
                                        </tr>
                                        <tr>
                                            <th class="line"><ext:Label ID="lbl02_NAME_LOCAL" runat="server" /><%--Text="성명(현지어)" />--%></th>
                                            <td class="vt_am"><ext:TextField ID="txt01_SHAREHOLDER1"  runat="server" Width="100" Cls="inputText" /></td>
                                            <td class="vt_am"><ext:TextField ID="txt01_SHAREHOLDER2"  runat="server" Width="100" Cls="inputText" /></td>
                                            <td class="vt_am"><ext:TextField ID="txt01_SHAREHOLDER3"  runat="server" Width="100" Cls="inputText" /></td>
                                            <td class="vt_am"><ext:TextField ID="txt01_SHAREHOLDER4"  runat="server" Width="100" Cls="inputText" /></td>
                                        </tr>
                                        <tr>
                                            <th class="line"><ext:Label ID="lbl01_STOCK_RATE" runat="server" /><%--Text="지분율(%)" />--%></th>
                                            <td class="vt_am"><ext:NumberField ID="txt01_SHARE_RATE1"  runat="server" Width="100" Cls="inputText_Num" FieldCls="inputText_Num" MaxValue="100" MinValue="0" HideTrigger="true"/></td>
                                            <td class="vt_am"><ext:NumberField ID="txt01_SHARE_RATE2"  runat="server" Width="100" Cls="inputText_Num" FieldCls="inputText_Num" MaxValue="100" MinValue="0" HideTrigger="true"/></td>
                                            <td class="vt_am"><ext:NumberField ID="txt01_SHARE_RATE3"  runat="server" Width="100" Cls="inputText_Num" FieldCls="inputText_Num" MaxValue="100" MinValue="0" HideTrigger="true"/></td>
                                            <td class="vt_am"><ext:NumberField ID="txt01_SHARE_RATE4"  runat="server" Width="100" Cls="inputText_Num" FieldCls="inputText_Num" MaxValue="100" MinValue="0" HideTrigger="true"/></td>
                                        </tr>
                                    </table>
                                </Content>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>

                    <%--15.기타--%>
                    <ext:Label ID="lbl01_TIT_ETC"  runat="server" Cls="bottom_area_title_name" /><%--Text="기타--%>
                    <ext:Panel ID="pnl01_ETC" Cls="excel_upload_area_table" runat="server"  StyleSpec="width:1200px !important;">
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 100px;" />
                                    <col style="width: 80px;" />
                                    <col style="width: 100px;" />                                              
                                    <col style="width: 80px;" />
                                    <col style="width: 100px;" />                                              
                                    <col style="width: 120px;" />
                                    <col style="width: 100px;" />                                              
                                    <col style="width: 100px;" />
                                    <col style="width: 100px;" />                                              
                                    <col style="width: 100px;" />
                                    <col style="width: 100px;" />
                                    <col style="width: 100px;" />
                                </colgroup>
                                <tr>
                                    <th>
                                        <ext:Label ID="lbl01_SITE" runat="server" /><%--Text="대지" />--%>
                                    </th>
                                    <td >
                                        <%--<ext:NumberField ID="txt01_AREA" Width="74" Cls="inputText_Num" FieldCls="inputText_Num" AllowDecimals="true" runat="server"/>--%>
                                        <ext:TextField runat="server" ID="txt01_AREA" Width="74" Cls="inputText_Num" FieldCls="inputText_Num" MaskRe="/[0-9\-\,]/">
                                            <Listeners>
                                                <Focus Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0'));" />
                                                <Blur Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0,0'));" />
                                            </Listeners>
                                        </ext:TextField>
                                    </td> 
                                    <th>
                                        <ext:Label ID="lbl01_BUILDING" runat="server" /><%--Text="건물" />--%>
                                    </th>
                                    <td >
                                        <%--<ext:NumberField ID="txt01_BUILDING" Width="74" Cls="inputText_Num" FieldCls="inputText_Num" AllowDecimals="true" runat="server"/>--%>
                                        <ext:TextField runat="server" ID="txt01_BUILDING" Width="74" Cls="inputText_Num" FieldCls="inputText_Num" MaskRe="/[0-9\-\,]/">
                                            <Listeners>
                                                <Focus Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0'));" />
                                                <Blur Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0,0'));" />
                                            </Listeners>
                                        </ext:TextField>
                                    </td> 
                                    <th>
                                        <ext:Label ID="lbl01_UNIT" runat="server" /><%--Text="단위" />--%>
                                    </th>
                                    <td >
                                        <ext:SelectBox ID="cbo01_UNIT" runat="server"  Mode="Local" ForceSelection="true" DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="114">
                                            <Store>
                                                <ext:Store ID="Store18" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model18" runat="server">
                                                            <Fields>
                                                                <ext:ModelField Name="OBJECT_NM" />
                                                                <ext:ModelField Name="OBJECT_ID" />
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                        </ext:SelectBox>
                                    </td> 
                                    <th>
                                        <ext:Label ID="lbl01_COMP_SCALE" runat="server" /><%--Text="회사규모" />--%>
                                    </th>
                                    <td >
                                        <ext:SelectBox ID="cbo01_SCALE" runat="server"  Mode="Local" ForceSelection="true" DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="94">
                                            <Store>
                                                <ext:Store ID="Store19" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model19" runat="server">
                                                            <Fields>
                                                                <ext:ModelField Name="OBJECT_NM" />
                                                                <ext:ModelField Name="OBJECT_ID" />
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                        </ext:SelectBox>
                                    </td> 
                                    <th>
                                        <ext:Label ID="lbl01_STOCKYN" runat="server" /><%--Text="상장여부" />--%>
                                    </th>
                                    <td >
                                        <ext:SelectBox ID="cbo01_STOCK_YN" runat="server"  Mode="Local" ForceSelection="true" DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="94">
                                            <Store>
                                                <ext:Store ID="Store20" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model20" runat="server">
                                                            <Fields>
                                                                <ext:ModelField Name="OBJECT_NM" />
                                                                <ext:ModelField Name="OBJECT_ID" />
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                        </ext:SelectBox>
                                    </td>
                                    <th>
                                        <ext:Label ID="lbl01_EQ_RUNRATE" runat="server" /><%--Text="설비가동율" />--%>
                                    </th>
                                    <td >
                                        <ext:NumberField ID="txt01_CAPACITY_RATE" Width="120" Cls="inputText_Num" FieldCls="inputText_Num" AllowDecimals="true" runat="server" MaxValue="100" MinValue="0" HideTrigger="true"/>
                                    </td>  
                                </tr>
                            </table>
                        </Content>
                    </ext:Panel>

                    <%--13.주요공급업체 매입현황--%>                    
                    <%--<ext:Panel ID="pnl01_PUR" runat="server" Region="North" style="height:200px; width:1500px !important; margin-bottom: 10px;">--%>
                    <ext:Panel ID="pnl01_PUR" runat="server" Region="North" style="height:200px; width:1200px !important; margin-bottom: 10px;">
                        <Content>
                            <ext:Panel ID="ButtonPanel03" runat="server" Region="North" Height="23" Hidden="false" >
                                <Items> 
                                    <ext:Panel ID="Panel10" runat="server" StyleSpec="margin-right:20px; float:left;" Width="600" Hidden="false">
                                        <Items>
                                            <ext:Label ID="lbl01_TIT_PUR2"  runat="server" Cls="bottom_area_title_name2" Width="500px"/><%--Text="주요 공급업체 매출현황(매출액 높은 순)"--%>
                                        </Items>
                                    </ext:Panel>

                                    <ext:Panel ID="Panel7" runat="server" Width="410" Hidden="false" Cls="bottom_area_btn" >
                                        <Items>
                                            <ext:FieldContainer runat="server" ID="FieldContainer" Layout="ColumnLayout">
                                                <Items>
                                                    <ext:NumberField ID="txt02_STD_YEAR" Width="180" Cls="inputText_Code" StyleSpec="margin-right:20px;" FieldCls="inputText_Code" AllowDecimals="true" Step="1" MinValue="1900" MaxValue="9999" runat="server" >
                                                        <%--<DirectEvents>
                                                            <Change OnEvent="txt02_STD_YEAR_Change" />   
                                                                                                                                                                                                                                            
                                                        </DirectEvents>--%>
                                                        <Listeners>
                                                            <Change Fn="fn_txt02_STD_YEAR_Change"></Change>
                                                        </Listeners>
                                                    </ext:NumberField>

                                                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_icon_add.png" Cls="pr5" ID="btnRowAdd03" StyleSpec="margin-bottom:5px;">
                                                        <Listeners>
                                                            <Click Handler = "addNewRow(App.Grid03)" />
                                                        </Listeners>
                                                    </ext:ImageButton>
                                                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_icon_del.png" ID="btnRowDelete03" StyleSpec="margin-bottom:5px;">
                                                        <Listeners>
                                                            <Click Handler = "removeRow(App.Grid03,'ISNEW')" />
                                                        </Listeners>
                                                    </ext:ImageButton>
                                            
                                                    <ext:Button ID="btn03_DELETE" runat="server" TextAlign="Center" Cls="mg_r4" Width="72px" StyleSpec="margin-left:10px;margin-bottom:5px;"><%--Text="삭제" >--%>
                                                        <DirectEvents>
                                                            <Click OnEvent="etc_Button_Click" >
                                                                <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want delete?"></Confirmation>     
                                                                <ExtraParams>
                                                                    <ext:Parameter Name="Values" Value="App.Grid03.getRowsValues({dirtyRowsOnly: true})" Mode="Raw" Encode="true" />
                                                                </ExtraParams>
                                                            </Click>
                                                        </DirectEvents>
                                                    </ext:Button>    
                                           
                                                    <ext:Button ID="btn03_SAVE" runat="server" TextAlign="Center" Cls="mg_r4" Width="72px" StyleSpec="margin-bottom:5px;margin-right:0px" ><%--Text="저장" >--%>
                                                        <DirectEvents>
                                                            <Click OnEvent="etc_Button_Click" >
                                                                <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want save?"></Confirmation>     
                                                                <ExtraParams>
                                                                    <ext:Parameter Name="Values" Value="App.Grid03.getRowsValues({dirtyRowsOnly: true})" Mode="Raw" Encode="true" />
                                                                </ExtraParams>
                                                            </Click>
                                                        </DirectEvents>
                                                    </ext:Button>   
                                                </Items>
                                            </ext:FieldContainer>
                                        </Items>
                                    </ext:Panel>      
                                </Items>
                            </ext:Panel>
                            
                            <ext:Panel ID="GridPanel03" Region="Center" Border="True" runat="server" Cls="grid_area" >
                                <Items>  
                                    <ext:GridPanel ID="Grid03" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." Height="152">
                                        <Store>
                                            <ext:Store ID="Store_Grid03" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="Model22" runat="server" Name="ModelGrid03">
                                                        <Fields>
                                                            <%--임의로 생성--%>
                                                            <ext:ModelField Name="NO" /> 
                                                            <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>

                                                            <%--실제 디비에서 가져와서 사용함.--%>
                                                            <ext:ModelField Name="CORCD" />
                                                            <ext:ModelField Name="VENDCD" />
                                                            <ext:ModelField Name="STD_YEAR" />
                                                            <ext:ModelField Name="SEQNO" />
                                                            <ext:ModelField Name="VENDNM1" />
                                                            <ext:ModelField Name="ITEMNM1" />
                                                            <ext:ModelField Name="PURCHASE1" />      
                                                    
                                                            <%--DELETE ROW가 존재시--%>
                                                            <ext:ModelField Name="ISNEW" Type="Boolean" />                               
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                                <Listeners>
                                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                                    <Load Delay="1" Handler="GridStoreReady(App.GridStatus3, this.getTotalCount()); "></Load>
                                                </Listeners>
                                            </ext:Store>
                                        </Store>
                                        <Plugins>
                                            <ext:BufferedRenderer ID="BufferedRenderer3"  runat="server"/>
                                            <ext:CellEditing ID="CellEditing3" runat="server" ClicksToEdit="1" >
                                                <Listeners>                                    
                                                    <BeforeEdit fn="BeforeEdit" />
                                                    <Edit fn ="AfterEdit" />                                    
                                                </Listeners> 
                                            </ext:CellEditing>
                                        </Plugins>  
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <%--NO컬럼--%>
                                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                                <ext:Column ID ="Column2" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                                    <Renderer Fn="rendererNo"></Renderer>
                                                </ext:Column>
                                                <%--선택체크박스--%>
                                                <ext:CheckColumn runat="server" ID ="CheckColumn2" Text=""  DataIndex="CHECK_VALUE" Width="35" 
                                                                 StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true">
                                                        
                                                </ext:CheckColumn>                                                 
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="VENDNM" ItemID="VENDNM" DataIndex="VENDNM1" runat="server" Width="350" Flex="1" Align="Left"><%--Text="업체명" --%>
                                                    <Editor>
                                                        <ext:TextField ID="TextField9" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>
                                                </ext:Column>
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="MAIN_ITEM" ItemID="MAIN_ITEM" DataIndex="ITEMNM1" runat="server" Width="310" Align="Left"><%--Text="품목명(대표품목)" --%>
                                                    <Editor>
                                                        <ext:TextField ID="TextField8" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>
                                                </ext:Column>
                                                <%-- 일반 Number editor--%>
                                                <ext:NumberColumn ID="YEAR_PURCAMT" ItemID="YEAR_PURCAMT" DataIndex="PURCHASE1" runat="server" Width="250" Align="Right" Format="#,##0"><%--Text="매입액" --%>
                                                    <Editor>                                                        
                                                        <ext:NumberField ID="NumberField3" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" Height ="22"  />
                                                    </Editor>
                                                </ext:NumberColumn>
                                            </Columns>                                           
                                        </ColumnModel>
                                        <Loader ID="Loader3" runat="server" AutoLoad="false" Mode="Data">
                                            <LoadMask ShowMask="true" />
                                        </Loader>
                                        <View>
                                            <ext:GridView ID="GridView3" runat="server"  EnableTextSelection="true"/>
                                        </View>
                                        <SelectionModel>                            
                                            <ext:CellSelectionModel  ID="CellSelectionModel2" runat="server">
                                                <Listeners><Select Fn="CellFocus"></Select></Listeners>
                                            </ext:CellSelectionModel >
                                        </SelectionModel>                                                   
                                        <BottomBar>
                                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                            <ext:StatusBar ID="GridStatus3" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                        </BottomBar>
                                    </ext:GridPanel>
                                </Items>
                            </ext:Panel>  

                        </Content>
                    </ext:Panel>

                    <%--17.주요설비현황--%>                       
                    <ext:Panel ID="pnl01_FAC" runat="server" Region="North" style="height:470px; width:1200px !important;margin-bottom: 10px;">
                        <Content>                        
                            <%--17.1. 주요설비현황(생산설비)--%>                
                            <ext:Panel ID="ButtonPanel01" runat="server" Region="North" Height="23" Hidden="false" >
                                <Items> 
                                    <ext:Panel ID="Panel4" runat="server" StyleSpec="margin-right:20px; float:left;" Width="500" Hidden="false">
                                        <Items>
                                            <ext:Label ID="lbl01_TIT_FAC" runat="server" Cls="bottom_area_title_name2" Width="300px"/><%--Text="주요설비현황 [생산설비]" --%> 
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="Panel6" runat="server" Width="400" Hidden="false" Cls="bottom_area_btn" >
                                        <Items>
                                            <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_icon_add.png" Cls="pr5" ID="btnRowAdd" StyleSpec="margin-bottom:5px;">
                                                <Listeners>
                                                    <Click Handler = "addNewRow(App.Grid01)" />
                                                </Listeners>
                                            </ext:ImageButton>
                                            <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_icon_del.png" ID="btnRowDelete" StyleSpec="margin-bottom:5px;">
                                                <Listeners>
                                                    <Click Handler = "removeRow(App.Grid01,'ISNEW')" />
                                                </Listeners>
                                            </ext:ImageButton>

                                            
                                            
                                            <ext:Button ID="btn01_DELETE" runat="server" TextAlign="Center" Cls="mg_r4" Width="72px" StyleSpec="margin-left:10px;margin-bottom:5px;"><%--Text="삭제" >--%>
                                                <DirectEvents>
                                                    <Click OnEvent="etc_Button_Click" >
                                                        <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want delete?"></Confirmation>     
                                                        <ExtraParams>
                                                            <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({dirtyRowsOnly: true})" Mode="Raw" Encode="true" />
                                                        </ExtraParams>
                                                    </Click>
                                                </DirectEvents>
                                            </ext:Button>    
                                           
                                            <ext:Button ID="btn01_SAVE" runat="server" TextAlign="Center" Cls="mg_r4" Width="72px" StyleSpec="margin-bottom:5px;margin-right:0px" ><%--Text="저장" >--%>
                                                <DirectEvents>
                                                    <Click OnEvent="etc_Button_Click" >
                                                        <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want save?"></Confirmation>     
                                                        <ExtraParams>
                                                            <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({dirtyRowsOnly: true})" Mode="Raw" Encode="true" />
                                                        </ExtraParams>
                                                    </Click>
                                                </DirectEvents>
                                            </ext:Button>    
                                         </Items>
                                    </ext:Panel>                            
                                </Items>
                            </ext:Panel>         
                            <ext:Panel ID="GridPanel01" Region="North" Border="True" runat="server" Cls="grid_area" style="margin-bottom: 10px">
                                <Items>  
                                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." Height="152">
                                        <Store>
                                            <ext:Store ID="Store_Grid01" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="GridModel1" runat="server" Name="ModelGrid">
                                                        <Fields>
                                                            <%--임의로 생성--%>
                                                            <ext:ModelField Name="NO" /> 
                                                            <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>

                                                            <%--실제 디비에서 가져와서 사용함.--%>
                                                            <ext:ModelField Name="CORCD" />
                                                            <ext:ModelField Name="VENDCD" />
                                                            <ext:ModelField Name="SEQNO" />
                                                            <ext:ModelField Name="FACILCNT" />
                                                            <ext:ModelField Name="FACILNM1" />
                                                            <ext:ModelField Name="FACIL_MAKER1" />
                                                            <ext:ModelField Name="FACIL_REMARK1" />      
                                                    
                                                            <%--DELETE ROW가 존재시--%>
                                                            <ext:ModelField Name="ISNEW" Type="Boolean" />                               
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
                                                <%--NO컬럼--%>
                                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                                    <Renderer Fn="rendererNo"></Renderer>
                                                </ext:Column>
                                                <%--선택체크박스--%>
                                                <ext:CheckColumn runat="server" ID ="D_CHECK" Text=""  DataIndex="CHECK_VALUE" Width="35" 
                                                                 StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true">
                                                        
                                                </ext:CheckColumn>   
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="FACILNM" ItemID="FACILNM" DataIndex="FACILNM1" runat="server" Width="200" Flex="1" Align="Left"><%--Text="설비명" --%>
                                                    <Editor>
                                                        <ext:TextField ID="TextField1" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>
                                                </ext:Column>
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="FACIL_MAKER" ItemID="FACIL_MAKER" DataIndex="FACIL_MAKER1" runat="server" Width="200" Align="Left"><%--Text="설비제작처" --%>
                                                    <Editor>
                                                        <ext:TextField ID="TextField2" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>
                                                </ext:Column>
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="FACILCNT" ItemID="FACILCNT" DataIndex="FACILCNT" runat="server" Width="100" Align="Right"><%--Text="보유대수" --%>
                                                    <Editor>
                                                        <ext:NumberField ID="TextField4" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" Height ="22" />
                                                    </Editor>
                                                </ext:Column>
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="FACIL_REMARK" ItemID="FACIL_REMARK" DataIndex="FACIL_REMARK1" runat="server" Width="400" Align="Left"><%--Text="비고" --%>
                                                    <Editor>
                                                        <ext:TextField ID="TextField3" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>
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
                                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">
                                                <Listeners><Select Fn="CellFocus"></Select></Listeners>
                                            </ext:CellSelectionModel >
                                        </SelectionModel>                                                   
                                        <BottomBar>
                                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                        </BottomBar>
                                    </ext:GridPanel>
                                </Items>
                            </ext:Panel>  

                             <%--17.2.주요설비현황(실험 및 측정설비)--%>    
                            <ext:Panel ID="ButtonPanel02" runat="server" Region="North" Height="23" Hidden="false" >
                                <Items> 
                                    <ext:Panel ID="Panel13" runat="server" StyleSpec="margin-right:10px; float:left;" Width="500" Hidden="false">
                                        <Items>
                                            <ext:Label ID="lbl01_TIT_EQUIP"  runat="server" Cls="bottom_area_title_name2" /> <%--Text="주요설비현황 [실험 및 측정설비]"--%>                                            
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="Panel14" runat="server" Width="400" Hidden="false" Cls="bottom_area_btn" >
                                        <Items>
                                            <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_icon_add.png" Cls="pr5" ID="btnRowAdd02" StyleSpec="margin-bottom:5px;">
                                                <Listeners>
                                                    <Click Handler = "addNewRow(App.Grid02)" />
                                                </Listeners>
                                            </ext:ImageButton>
                                            <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_icon_del.png" ID="btnRowDelete02" StyleSpec="margin-bottom:5px;">
                                                <Listeners>
                                                    <Click Handler = "removeRow(App.Grid02,'ISNEW')" />
                                                </Listeners>
                                            </ext:ImageButton>
                                            
                                            <ext:Button ID="btn02_DELETE" runat="server" TextAlign="Center" Cls="mg_r4" Width="72px" StyleSpec="margin-left:10px;margin-bottom:5px;"><%--Text="삭제" >--%>
                                                <DirectEvents>
                                                    <Click OnEvent="etc_Button_Click" >
                                                        <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want delete?"></Confirmation>     
                                                        <ExtraParams>
                                                            <ext:Parameter Name="Values" Value="App.Grid02.getRowsValues({dirtyRowsOnly: true})" Mode="Raw" Encode="true" />
                                                        </ExtraParams>
                                                    </Click>
                                                </DirectEvents>
                                            </ext:Button>    
                                           
                                            <ext:Button ID="btn02_SAVE" runat="server" TextAlign="Center" Cls="mg_r4" Width="72px" StyleSpec="margin-bottom:5px;margin-right:0px" ><%--Text="저장" >--%>
                                                <DirectEvents>
                                                    <Click OnEvent="etc_Button_Click" >
                                                        <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want save?"></Confirmation>     
                                                        <ExtraParams>
                                                            <ext:Parameter Name="Values" Value="App.Grid02.getRowsValues({dirtyRowsOnly: true})" Mode="Raw" Encode="true" />
                                                        </ExtraParams>
                                                    </Click>
                                                </DirectEvents>
                                            </ext:Button>    
                                            </Items>
                                    </ext:Panel>                            
                                </Items>
                            </ext:Panel> 
                            <ext:Panel ID="Panel15" Region="Center" Border="True" runat="server" Cls="grid_area" >
                                <Items>  
                                    <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." Height="152">
                                        <Store>
                                            <ext:Store ID="Store_Grid02" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="Model21" runat="server" Name="ModelGrid02">
                                                        <Fields>
                                                            <%--임의로 생성--%>
                                                            <ext:ModelField Name="NO" /> 
                                                            <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>

                                                            <%--실제 디비에서 가져와서 사용함.--%>
                                                            <ext:ModelField Name="CORCD" />
                                                            <ext:ModelField Name="VENDCD" />
                                                            <ext:ModelField Name="SEQNO" />
                                                            <ext:ModelField Name="EQUIPCNT" />
                                                            <ext:ModelField Name="EQUIPNM1" />
                                                            <ext:ModelField Name="EQUIP_MAKER1" />
                                                            <ext:ModelField Name="EQUIP_REMARK1" />      
                                                    
                                                            <%--DELETE ROW가 존재시--%>
                                                            <ext:ModelField Name="ISNEW" Type="Boolean" />                               
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
                                            <ext:BufferedRenderer ID="BufferedRenderer4"  runat="server"/>
                                            <ext:CellEditing ID="CellEditing4" runat="server" ClicksToEdit="1" >
                                                <Listeners>                                    
                                                    <BeforeEdit fn="BeforeEdit" />
                                                    <Edit fn ="AfterEdit" />                                    
                                                </Listeners> 
                                            </ext:CellEditing>
                                        </Plugins>  
                                        <ColumnModel ID="ColumnModel4" runat="server">
                                            <Columns>
                                                <%--NO컬럼--%>
                                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                                <ext:Column ID ="Column7" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                                    <Renderer Fn="rendererNo"></Renderer>
                                                </ext:Column>
                                                <%--선택체크박스--%>
                                                <ext:CheckColumn runat="server" ID ="CheckColumn3" Text=""  DataIndex="CHECK_VALUE" Width="35" 
                                                                    StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true">
                                                        
                                                </ext:CheckColumn>   
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="EQUIPNM" ItemID="EQUIPNM" DataIndex="EQUIPNM1" runat="server" Flex="1" Width="200" Align="Left"><%--Text="설비명" --%>
                                                    <Editor>
                                                        <ext:TextField ID="TextField10" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>
                                                </ext:Column>
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="EQUIP_MAKER" ItemID="EQUIP_MAKER" DataIndex="EQUIP_MAKER1" runat="server" Width="200" Align="Left"><%--Text="설비제작처" --%>
                                                    <Editor>
                                                        <ext:TextField ID="TextField11" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>
                                                </ext:Column>
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="EQUIPCNT" ItemID="EQUIPCNT" DataIndex="EQUIPCNT" runat="server" Width="100" Align="Right"><%--Text="보유대수" --%>
                                                    <Editor>
                                                        <ext:NumberField ID="NumberField2" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" Height ="22" />
                                                    </Editor>
                                                </ext:Column>
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="EQUIP_REMARK" ItemID="EQUIP_REMARK" DataIndex="EQUIP_REMARK1" runat="server" Width="400" Align="Left"><%--Text="비고" --%>
                                                    <Editor>
                                                        <ext:TextField ID="TextField12" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>
                                                </ext:Column>
                                            </Columns>
                                            
                                        </ColumnModel>
                                        <Loader ID="Loader4" runat="server" AutoLoad="false" Mode="Data">
                                            <LoadMask ShowMask="true" />
                                        </Loader>
                                        <View>
                                            <ext:GridView ID="GridView4" runat="server"  EnableTextSelection="true"/>
                                        </View>
                                        <SelectionModel>                            
                                            <ext:CellSelectionModel  ID="CellSelectionModel3" runat="server">
                                                <Listeners><Select Fn="CellFocus"></Select></Listeners>
                                            </ext:CellSelectionModel >
                                        </SelectionModel>                                                   
                                        <BottomBar>
                                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                            <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                        </BottomBar>
                                    </ext:GridPanel>
                                </Items>
                            </ext:Panel>
                        </Content>
                    </ext:Panel>
                </Items>
            </ext:Panel>

        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
