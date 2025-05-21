<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP20003.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MP.SRM_MP20003" %>
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
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">    
	    .x-grid-cell-PARTNM DIV,	    
	    .x-grid-cell-STANDARD DIV,	    
	    .x-grid-cell-MAKER DIV,	    
	    .x-grid-cell-QTY DIV,
	    .x-grid-cell-QUOT_UCOST DIV,
	    .x-grid-cell-QUOT_DUTY DIV,
	    .x-grid-cell-QUOT_TEL DIV,
	    .x-grid-cell-DELI_DATE02 DIV,
	    .x-grid-cell-REMARK DIV,
	    .x-grid-cell-ATT_FILENM DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }
		    
	    .edit-row02 .x-grid-cell-ATT_FILENM DIV
	    {	
		    /*border-width:1px;
		    border-style:solid;
		    border-color:silver;*/  /*darkgray; */
	    }    
	    
        /*4.X에서 CHECKCOLUM의 헤더의 체크위치가 제대로 지정되지 않아서 필요없는 DIV제거*/
        #D_CHECK-textEl
        {
            display:none;
        }		    	    
	    
    </style>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        // 그리드에서 선택된 Action Object
        var currentCellObject;

        //다이렉트 메서드 호출
        //App.direct.Cell_Click(position.row, position.column);

        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }

        // editor가 포함된 cell에서 tab을 누를경우에 실행되는 메소드를 override해서 원하는 방향으로 변경
        Ext.override(Ext.selection.CellModel, {
            onEditorTab: function (editingPlugin, e) {
                var me = this, direction = e.shiftKey ? 'left' : 'right', position = me.move(direction, e);

                if (position) {
                    // 만약 다음 셀이 editor가 되지 않는 셀이라면 한번더 tab을 누르는 효과를 준다.
                    //var isEditing = editingPlugin.getActiveEditor() == null || (editingPlugin.getActiveEditor().editing == false);

                    if (!editingPlugin.startEdit(position.row, position.column)) {
                        if (!(this.selection.columnHeader.id == 'D_CHECK_VALUE')) { //체크박스라면 멈춘다.
                            me.onEditorTab(editingPlugin, e);
                        }
                    }
                    else {
                        if (this.selection.columnHeader.id == 'NO') { //만약 No컬럼이면 한번더 tab을 누른효과를 준다.
                            me.onEditorTab(editingPlugin, e);
                        }
                    }
                }
            }
        });

        // 그리드의 cell에 포커스가 갈 경우에 자동으로 editor가 실행이 되도록 한다. 
        // 원인: 그리드 내의 콤보박스는 editor을 포함하지 않아 eiditorTab 이벤트가 실행이되지 않음. 따라서 콤보박스에서 tab을 눌렀을 경우에 
        // editor가 포함된 cell에 포커스가 가면 editor가 실행이 되고 이후에 tab을 클릭하면 editor가 포함된 cell로 자동으로 이동이 된다.
        var test;
        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            var grid = selectionModel.view.ownerCt;
            //grid.ownerCt.editingPlugin.startEdit(rowIndex, colIndex);
            
            var van_process_type = grid.getStore().getAt(rowIndex).data["VAN_PROCESS_CODE"];

            if (van_process_type == "H6B" || van_process_type == "H6C") {
                Ext.getCmp('txt02_PARTNM').disable();
                Ext.getCmp('txt02_STANDARD').disable();
                Ext.getCmp('txt02_MAKER').disable();
                Ext.getCmp('txt02_QTY').disable();
                Ext.getCmp('txt02_QUOT_UCOST').disable();
                Ext.getCmp('df02_DELI_DATE').disable();
                Ext.getCmp('txt02_REMARK').disable();
            }
            else {
                Ext.getCmp('txt02_PARTNM').enable();
                Ext.getCmp('txt02_STANDARD').enable();
                Ext.getCmp('txt02_MAKER').enable();
                Ext.getCmp('txt02_QTY').enable();
                Ext.getCmp('txt02_QUOT_UCOST').enable();
                Ext.getCmp('df02_DELI_DATE').enable();
                Ext.getCmp('txt02_REMARK').enable();
            }
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
            var codeName, textName;

            var grid = App.Grid01;
            var rowIdx = App.CodeRow.getValue();

            grid.getStore().getAt(App.CodeRow.getValue()).set(textName, typeNM);
            grid.getStore().getAt(App.CodeRow.getValue()).set(codeName, objectID);


            // 필수코드 ( 반드시 )
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", false);
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", grid.getStore().getAt(rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드의 editor를 활성화시키는 시점에서 작동        
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        // 그리드를 editor한 후에 발생되는 이벤트
        var AfterEdit = function (rowEditor, e) {
            var quot_cnt = App.cbo01_QUOT_CNT.getValue();

            if (quot_cnt == "" || quot_cnt == "0") {
                if (e.column.dataIndex != "CHECK_VALUE") {
                    e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", false);
                    e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", e.grid.getStore().getAt(e.rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
                } else {
                    e.grid.getStore().getAt(e.rowIdx).dirty = e.grid.getStore().getAt(e.rowIdx).data["CHECK_VALUE"];
                }
            }
        }

        function fn_PopupHandler(rowIndex, VENDCD, Popup) {

            App.CodeRow.setValue(rowIndex);
            App.V_VENDCD.setValue(VENDCD);
            PopUpFire(Popup);
        }

        var PopUpFire = function (Popup) {
            if (Popup == 'fn20003P') {
                App.btn01_POP_MP20003P1.fireEvent('click');
            }
            else {
                App.btn01_POP_MP20003P2.fireEvent('click');
            }
        }

        // 그리드의 셀을 클릭시 - 일괄 등록-
        var cellclick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

            var VENDCD = App.cdx01_VENDCD_OBJECTID.getValue();
            fn_PopupHandler(rowIndex, VENDCD, 'fn20003P');
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 그리드의 입력 폼 수정 유무
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/

        var EditChange = function () {

            var quot_cnt = App.cbo01_QUOT_CNT.getValue();
            var grid = App.Grid01;
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 그리드의 입력 형태별 css 유무
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/

        var getRowClass = function (record) {

//            var quot_cnt = App.cbo01_QUOT_CNT.getValue();
            var van_process_type = record.data['VAN_PROCESS_CODE'];

            if (van_process_type == "H6B" || van_process_type == "H6C") {
                return "edit-row02";
            }
            else {
                return "edit-row";
            }

            //            if (quot_cnt == "" || quot_cnt == null) {
            //                return "edit-row";
            //            }
            //            else {
            //                return "edit-row02";
            //            }
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 일괄등록에서 선택한 데이터 값
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/

        var fn_MP20003 = function (id, chr_nm, chr_tel, deli_date, chk) {
            var count = Ext.getCmp("Grid01").store.getCount();
            var dirty = App.Grid01.getRowsValues({ dirtyRowsOnly: true });
            App.direct.GridUpdate(chr_nm, chr_tel, deli_date, chk, count, dirty);

            Ext.getCmp(id).hide();
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 상세견적첨부에서 저장 후
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var fn_MP20003P2_R = function (id) {

            App.direct.FileNmUpdate();

            Ext.getCmp(id).hide();
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 신규, 차수 조회 시 check enable, disable 유무
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var checkBoxControl = function (_enable, _allCheck) {
            checkBox = document.getElementById("my-header-checkbox");
            var grid = App.Grid01;

            if (checkBox) {
                if (_allCheck) {
                    checkBox.checked = true;
                    for (i = 0; i < grid.store.count(); i++) {
                        grid.store.getAt(i).data["CHECK_VALUE"] = checkBox.checked;
                        grid.store.getAt(i).data["NO"] = i + 1; //2015-04-07 체크박스 체크할 때 "NO"에도 값 넣어줌. (renderer를 통해서 값이 들어가긴 하지만  buffered 특성상 화면에 displayed 되지 않았을 때는 값이 없는 경우 발생함)
                        grid.store.getAt(i).dirty = checkBox.checked;
                    }
                    grid.view.refresh();
                }
                checkBox.disabled = !_enable;
            }

            grid.view.refresh();
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 첨부파일 팝업창
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/

        var fn_MP20003P2 = function (id, chr_nm, chr_tel, deli_date, chk) {
            var count = Ext.getCmp("Grid01").store.getCount();
            var dirty = App.Grid01.getRowsValues({ dirtyRowsOnly: true });
            App.direct.GridUpdate(chr_nm, chr_tel, deli_date, chk, count, dirty);

            Ext.getCmp(id).hide();
        };

        function fn_PopupHandler02(rowIndex, ATT_FILENM, BIZCD, PRNO, PRNO_SEQ, SEQ, Popup) {
            
            App.CodeRow.setValue(rowIndex);
            App.V_ATT_FILENM.setValue(ATT_FILENM);
            App.V_BIZCD.setValue(BIZCD);
            App.V_PRNO.setValue(PRNO);
            App.V_PRNO_SEQ.setValue(PRNO_SEQ);
            App.V_SEQ.setValue(SEQ);
            
            PopUpFire(Popup);
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 그리드 cell 더블 클릭 시
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;
            //var cellIndex = obj4.target.offsetParent.cellIndex;

            //마직막 행 더블클릭 시 팝업 오픈 안되게
            //            if (grid.getStore().getTotalCount() == rowIndex + 1) return;

            var columnName = grid.columns[cellIndex].id; // grid.columnManager.columns[cellIndex].id;
            
            // ADD_FILENM : 첨부파일
            // ATT_FILENM : 상세견적첨부
            if (columnName == 'ADD_FILENM') { // file attach
                if (grid.getStore().getAt(rowIndex).data["ADD_FILENM"] != null && grid.getStore().getAt(rowIndex).data["ADD_FILENM"] != '') {
                    var prno = grid.getStore().getAt(rowIndex).data["PRNO"];
                    var prno_seq = grid.getStore().getAt(rowIndex).data["PRNO_SEQ"];
                    var seq = grid.getStore().getAt(rowIndex).data["SEQ"];

                    App.V_PRNO.setValue(prno);
                    App.V_PRNO_SEQ.setValue(prno_seq);
                    App.V_SEQ.setValue(seq);
                    App.btnDownload.fireEvent('click');
                }
            } else {

                var quot_cnt = App.cbo01_QUOT_CNT.getValue();

                if (quot_cnt == null || quot_cnt.toString() == "0") {
                    if (columnName == "ATT_FILENM") {
                        App.direct.MsgCodeAlert("SCMMP00-0006");
                    }
                }
                else {
                    if (columnName == "ATT_FILENM") {
                        var ATT_FILENM = "";
                        if (grid.getStore().getAt(rowIndex).data["ATT_FILENM"] == null)
                            ATT_FILENM = "";
                        else
                            ATT_FILENM = grid.getStore().getAt(rowIndex).data["ATT_FILENM"];
                        var BIZCD = App.cbo01_BIZCD.getValue();
                        var PRNO = grid.getStore().getAt(rowIndex).data["PRNO"];
                        var PRNO_SEQ = grid.getStore().getAt(rowIndex).data["PRNO_SEQ"];
                        var SEQ = grid.getStore().getAt(rowIndex).data["SEQ"];
                        fn_PopupHandler02(rowIndex, ATT_FILENM, BIZCD, PRNO, PRNO_SEQ, SEQ, 'fn20003P2');
                    }
                }
            }
        }

    </script>
</head>
<body>
    <form id="SRM_MP20003" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_POP_MP20003P1" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:ImageButton ID="btn01_POP_MP20003P2" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:TextField   ID="V_PRNO"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_PRNO 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_PRNO_SEQ"        runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_PRNO_SEQ 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_SEQ"             runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_SEQ 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_BIZCD"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_BIZCD 값을 팝업에 넘기기 위해서 사용--%>    
    <ext:TextField   ID="V_ATT_FILENM"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_ATT_FILENM 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_VENDCD"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_VENDCD 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="CodeCol" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col index (사용하지 않으나 차후 필요할지 몰라서)--%>
    <ext:TextField ID="CodeColName" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col Name--%>
    <ext:TextField   ID="UserHelpURL"         runat="server" Hidden="true" Text="../SRM_MP/SRM_MP20003P1.aspx"></ext:TextField> 
    <ext:TextField   ID="PopupWidth"          runat="server" Hidden="true" Text="760"></ext:TextField> 
    <ext:TextField   ID="PopupHeight"         runat="server" Hidden="true" Text="400"></ext:TextField> 

    <ext:ImageButton ID="btnDownload" runat="server" Hidden="true" Cls="btn">
        <DirectEvents>
            <Click OnEvent="Cell_DoubleClick" IsUpload="true" >                
                <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want to downLoad file?"></Confirmation>                
            </Click>
        </DirectEvents>
    </ext:ImageButton>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MP20003" runat="server" Cls="search_area_title_name" />
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" /><%--Text="Vender Code" />--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" OnAfterValidation="changeCondition"/>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" /><%--Text="Business Code" />--%>
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
                                    <DirectEvents>
                                        <Select OnEvent="changeCondition" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td>
                            <th class="ess"> 
                                <ext:Label ID="lbl01_MRO_PO_TYPE" runat="server"/>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_MRO_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
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
                                        <Select OnEvent="changeCondition" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">                                
                                <ext:Label ID="lbl01_ETMT_DATE2" runat="server" /> <%--Text="견적서 작성일" --%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_ETMT_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true" >
                                    <DirectEvents>
                                        <Change OnEvent="changeCondition" />
                                    </DirectEvents>
                                </ext:DateField>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_QUOT_CNT" runat="server" /><%--Text="Vendor Plant" />--%>
                            </th>
                            <td>
                                <table>
                                    <tr>
                                        <td width="260">
                                            <ext:SelectBox ID="cbo01_QUOT_CNT" runat="server"  Mode="Local" ForceSelection="true"
                                                DisplayField="CDNM" ValueField="CD" TriggerAction="All" Width="150">
                                                <Store>
                                                    <ext:Store ID="Store3" runat="server" >
                                                        <Model>
                                                            <ext:Model ID="Model5" runat="server">
                                                                <Fields>
                                                                    <ext:ModelField Name="CD" />
                                                                    <ext:ModelField Name="CDNM" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>
                                                <DirectEvents> <Select OnEvent="cbo01_QUOT_CNT_Change" /> </DirectEvents> 
                                                <Listeners>                                            
                                                    <Change Fn="EditChange"/>
                                                </Listeners>
                                            </ext:SelectBox>
                                        </td>
                                    </tr>
                                </table>       
                            </td>
                            <td colspan="2" align="left">
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="175" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:Button ID="btn01_ALL_RGST" runat="server" TextAlign="Center" StyleSpec="float:left; width:80px;" > <%--Text="일괄등록"--%>
                                            <Listeners>
                                                <Click Fn="cellclick" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btn01_PRESENT" runat="server" TextAlign="Center" StyleSpec="float:left; margin-left:5px; width:80px;"><%--Text="제출" >--%>
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" >
                                                    <ExtraParams>
                                                        <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({dirtyRowsOnly: true})" Mode="Raw" Encode="true" />
                                                    </ExtraParams>
                                                </Click>
                                            </DirectEvents>
                                        </ext:Button> 
                                        <ext:Button StyleSpec="float:left; margin-left:5px; width:80px;" ID="btn01_PRESENT_CANCLE" runat="server" TextAlign="Center"><%--Text="제출취소" >--%>
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
                                <ext:Label ID="lbl01_MP_MSG005" runat="server" />  <%--Text="☞ 견적작성일은 "Save"시 오늘 일자로 자동 저장되며, 상단의 "견적작성일(Search전용)" 조건은 "Search"시 사용되는 조건입니다."--%>
                            </td>    
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>

            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="250">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server" Name ="ModelGrid">
                                        <Fields>
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>

                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="QUOT_REQ_DATE" />
                                            <ext:ModelField Name="MRO_PO_TYPE"/>
                                            <ext:ModelField Name="MRO_PO_TYPENM"/>
                                            <ext:ModelField Name="PRNO"/>
                                            <ext:ModelField Name="PRNO_SEQ"/>
                                            <ext:ModelField Name="QUOT_NO"/>
                                            <ext:ModelField Name="VAN_PROCESS_CODE"/>
                                            <ext:ModelField Name="VAN_PROCESS_TYPE"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="STANDARD"/>
                                            <ext:ModelField Name="MAKER"/>                                            
                                            <ext:ModelField Name="UNIT"/>
                                            <ext:ModelField Name="QTY"/>
                                            <ext:ModelField Name="QUOT_UCOST"/>
                                            <ext:ModelField Name="QUOT_DATE"/>
                                            <ext:ModelField Name="QUOT_MGR_NAME"/>
                                            <ext:ModelField Name="QUOT_MGR_TELNO"/>
                                            <ext:ModelField Name="QUOT_DELI_DATE"/>
                                            <ext:ModelField Name="ATT_FILENM"/>
                                            <ext:ModelField Name="REMARK"/>
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="QU_PARTNM"/>
                                            <ext:ModelField Name="QU_STANDARD"/>
                                            <ext:ModelField Name="QU_MAKER"/>
                                            <ext:ModelField Name="QU_QTY"/>
                                            <ext:ModelField Name="SEQ"/>
                                            <ext:ModelField Name="QUOT_TYPE"/>
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
                            <%-- buffred view를 사용하기 위한 plugin. --%>
                            <ext:BufferedRenderer ID="BufferedRenderer1" runat="server" />
                            <%-- 2.X버전부터는 그리드에서 edtior를 활성화 시키기위해서 cellEditing Plugin을 추가 하여 사용하고 자바스크립트에서 grid.editingPlugin 형태로 사용할수 있다. --%>
                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                <Listeners>                                    
                                    <BeforeEdit fn="BeforeEdit" />
                                    <Edit fn ="AfterEdit" />                                    
                                </Listeners> 
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:CheckColumn runat="server" ID ="D_CHECK" Text=""  DataIndex="CHECK_VALUE" Width="35" 
                                                 StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true" HeaderCheckbox="true">                                        
                                </ext:CheckColumn>
                                <ext:Column ID="QUOT_REQ_DATE"  ItemID="QUOTATION_DATE" runat="server"  DataIndex="QUOT_REQ_DATE"  Width="80" Align="Center" />  <%--Text="견적의뢰일"--%>                                 
                                <ext:Column ID="MRO_PO_TYPENM"  ItemID="MRO_PO_TYPE"    runat="server"  DataIndex="MRO_PO_TYPENM"  MinWidth="100" Align="Left" /><%--Text="일반구매유형"--%>
                                <ext:Column ID="PRNO"           ItemID="REQNO"          runat="server"  DataIndex="PRNO"           Width="100" Align="Center" /> <%--Text="의뢰번호"  --%>
                                <ext:Column ID="PRNO_SEQ"       ItemID="SEQ_NO"         runat="server"  DataIndex="PRNO_SEQ"       Width="50"  Align="Center" /> <%--Text="순번"      --%>
                                <ext:Column ID="VAN_PROCESS_TYPE"    ItemID="VAN_PROCESS_TYPE"      runat="server"  DataIndex="VAN_PROCESS_TYPE"    Width="80" Align="Center" />  <%--Text="견적상태"--%> 
                                <ext:CheckColumn runat="server" ID ="chk01_QUOT_NO" ItemID="QUOT_NO" DataIndex="QUOT_NO" Width="65"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >  <%--Text="견적불가" --%>    
                                </ext:CheckColumn> 
                                <ext:Column ID="PARTNM" runat="server" ItemID="PARTNM" DataIndex="PARTNM" Width="320" Align="Left"> <%--Text="품명"--%> 
                                    <Editor>
                                        <ext:TextField ID="txt02_PARTNM" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <ext:Column ID="MAKER" runat="server" ItemID="MAKER" DataIndex="MAKER" Width="100" Align="Left"> <%--Text="MAKER"--%> 
                                    <Editor>
                                        <ext:TextField ID="txt02_MAKER" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                <ext:Column  ID="UNIT"  ItemID="UNIT"  runat="server" DataIndex="UNIT" Width="60" Align="Center"/>  <%--Text="단위"--%> 
                                <%-- 숫자를 위한 컬럼: editor에서 format을 주더라도 그리드 바인딩시점에서 NumberColumn에 format을 주지 않는 다면 format이 적용되지 않음. 따라서 컬럼과 editor 모두 format지정해야함--%>
                                <ext:NumberColumn ID="QTY" runat="server" ItemID="QTY" DataIndex="QTY" Width="70" Align="Right" Format="#,###"> <%--Text="수량"--%> 
                                    <Editor>
                                        <ext:NumberField ID="txt02_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" AllowBlank="false" />
                                    </Editor>
                                </ext:NumberColumn>
                                <ext:NumberColumn ID="QUOT_UCOST" runat="server" ItemID="QUOT_UCOST" DataIndex="QUOT_UCOST" Width="90" Align="Right" Format="#,###"> <%--Text="견적단가"--%> 
                                    <Editor>
                                        <ext:NumberField ID="txt02_QUOT_UCOST" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" AllowBlank="false" />
                                    </Editor>
                                </ext:NumberColumn>
                                <ext:Column ID="QUOT_DATE" ItemID="QUWT_DATE" runat="server" DataIndex="QUOT_DATE" Width="80" Align="Center" />  <%--Text="견적작성일"--%> 

                                <ext:Column ID="QUOT_MGR_NAME" ItemID="QUOT_DUTY" runat="server" DataIndex="QUOT_MGR_NAME" Width="80" Align="Center">  <%--Text="견적작성자"--%> 
                                    <Editor>
                                        <ext:TextField ID="txt02_QUOT_MGR_NAME" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>

                                </ext:Column>
                                <ext:Column ID="QUOT_MGR_TELNO" ItemID="QUOT_TEL" runat="server" DataIndex="QUOT_MGR_TELNO" Width="100" Align="Center">  <%--Text="작성자연락처"--%> 
                                    <Editor>
                                        <ext:TextField ID="txt02_QUOT_MGR_TELNO" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <%-- 데이터 컬럼 : editor는 DateField로써 date picker임--%>
                                <ext:DateColumn ID="QUOT_DELI_DATE" ItemID="DELI_DATE02" runat="server" DataIndex="QUOT_DELI_DATE" Width="100" Align="Center"> <%--Text="납기가능일" --%>
                                    <Editor> 
                                        <ext:DateField ID="df02_DELI_DATE" Type="Date" runat="server"  SelectOnFocus="true" > 
                                        </ext:DateField>
                                    </Editor>                                                                
                                </ext:DateColumn>    
                                <ext:Column ID="ATT_FILENM" ItemID="ATT_FILENM" runat="server" DataIndex="ATT_FILENM" Width="80" Align="Center" />  <%--Text="상세견적첨부"--%> 
                                <ext:Column ID="REMARK" runat="server" ItemID="REMARK" DataIndex="REMARK" Width="100" Align="Left"> <%--Text="MAKER"--%> 
                                    <Editor>
                                        <ext:TextField ID="txt02_REMARK" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                <ext:Column ID="QU_PARTNM" ItemID="QU_PARTNM" runat="server" DataIndex="QU_PARTNM" Width="320" Align="Left" />  <%--Text="의뢰품명"--%> 
                                
                                <ext:Column ID="QU_MAKER" ItemID="QU_MAKER" runat="server" DataIndex="QU_MAKER" Width="80" Align="Center" />  <%--Text="의뢰MAKER"--%> 
                                <ext:NumberColumn ID="QU_QTY" runat="server" ItemID="OU_REQT_QTY" DataIndex="QU_QTY" Width="70" Align="Right" Format="#,###"/> <%--Text="의뢰수량"--%> 
                                <ext:Column ID="ADD_FILENM"     ItemID="ATTACH"         runat="server"  DataIndex="ADD_FILENM"     Width="200" Align="Left" />                       <%--Text="첨부파일"  --%>                                            
                                <ext:Column ID="STANDARD" runat="server" ItemID="STANDARD" DataIndex="STANDARD" Width="120" Align="Left" Hidden="true"> <%--Text="규격"--%> 
                                    <Editor>
                                        <ext:TextField ID="txt02_STANDARD" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                <ext:Column ID="QU_STANDARD" ItemID="QU_STANDARD" runat="server" DataIndex="QU_STANDARD" Width="100" Align="Left" Hidden="true" />  <%--Text="의뢰규격"--%> 
                            </Columns>
                            <%-- 그리드에서 editor에서 키를 다운했을 경우에 발생되는 핸들러가 막혀있어서 차후에 필요하다면 아래와 같이 사용
                            <Listeners>
                                <Render Handler="this.el.on('keydown', startEditing);" />
                            </Listeners>
                            --%>
                            <Listeners>
                                <%--<HeaderClick Fn="onSelectionCheckHeaderChange" />--%> <%--그리드 헤더의 체크박스를 클릭할 경우 발생--%>
                            </Listeners>
                        </ColumnModel>

                        <%-- 그리드 검색시 보이는 progress--%>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">
                                <GetRowClass Fn="getRowClass"/>
                            </ext:GridView>
                        </View>
                        <%-- SelectionModel은 checkbox, cell, row가 존재하고 그리드를 클릭시 그리드의 선택된 행의값이 json형태로 넘어감 (EP20S01참고)--%>
                        <SelectionModel>
<%--4.X CHANGE -> SELECT (화면 로딩전에 사용 NULL오류로 인해서--%>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">                             
                                <Listeners><Select Fn="CellFocus"></Select></Listeners>
                            </ext:CellSelectionModel >
                            <%--<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server"><Listeners><Select Fn="CellFocus"></Select></Listeners></ext:CheckboxSelectionModel>--%>
                        </SelectionModel>
                            <Listeners>
                                <CellDblClick Fn ="CellDbClick"></CellDblClick>
                            </Listeners>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
            <%--그리드와 내용사이에 하단 버튼영역이 필요할경우 아래 패널 사용(Hidden = "false") --%>
            <ext:Panel ID="BottomButtonPanel" runat="server" Region="South" Height="23" Cls="bottom_area_btn" Hidden="true">
                <Items>
                    <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5" ID="btnRowAdd">
                        <Listeners>
                            <Click Handler = "addNewRow(App.Grid01)" />
                        </Listeners>
                    </ext:ImageButton>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_deleterow.gif" ID="btnRowDelete">
                        <Listeners>
                            <Click Handler = "removeRow(App.Grid01,'ISNEW')" />
                        </Listeners>
                    </ext:ImageButton>
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
