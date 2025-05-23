﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP20007.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MP20007" %>
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
	    .x-grid-cell-DELI_QTY DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }
    </style>
    <style type="text/css">
        .bottom_area_title_name2 { clear:both;  margin-top:0px; height:20px; display:block; background:url(../../images/common/title_icon_s.gif) 0 8px no-repeat; padding-left:10px;font-size:12px;color:#010101;text-align:left;font-weight:bold;}
    </style>
    <!--그리드 필수 입력필드-->
    <style type="text/css">
        #DELI_QTY
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
            //App.GridPanel.setHeight(Math.floor(SRM_MP20007.offsetHeight * 0.25));
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

            App.direct.Grid01_Cell_DoubleClick(deliNote);
        }

        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        var AfterEdit = function (rowEditor, e) {
            var grid = App.Grid01;
            if (e.column.dataIndex == "DELI_QTY") {

                // 납품금액 = 납품수량 * 발주단가
                var deliQty = e.grid.getStore().getAt(e.rowIdx).data["DELI_QTY"];
                var poUcost = e.grid.getStore().getAt(e.rowIdx).data["PO_UCOST"];
                e.grid.getStore().getAt(e.rowIdx).set("PO_AMT", deliQty * poUcost);
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
            var remainQty = grd.getStore().getAt(rowIndex).data["REMAIN_QTY"];

            grd.getStore().getAt(rowIndex).set("DELI_QTY", remainQty);
        }

    </script>
    <script type="text/javascript" id="FocusHandler">
        var specialKey_KeyDown = function (o, e) {
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
    <form id="SRM_MP20007" runat="server">
    <!-- timeout 2분 설정 -->
    <ext:ResourceManager ID="ResourceManager1" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MP20007" runat="server" Cls="search_area_title_name" /><%--Text="납품서 수정 및 재발행" />--%>
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
                                <ext:Label ID="lbl01_MRO_PO_TYPE" runat="server"  /> <%--Text="일반구매유형"--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_MRO_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
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
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_MRO_PO_TYPE_Change" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td> 
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_DELI_NOTE3" runat="server" /><%--Text="PART NO" />--%>                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_DELI_NOTE3" Width="120" Cls="inputText" runat="server" />    
                            </td>
                            <td>
                                <ext:Button ID="btn01_PRINT_REPORT2" runat="server" TextAlign="Center" StyleSpec="" Cls="mg_r4"><%--Text="거래명세서출력" >--%>
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
                            <td colspan="7">
                                <ext:Label ID="lbl01_DELI_NOTE_MESSAGE1" runat="server" /><%--Text="입고 완료된 납품서는 조회되지 않습니다." />--%>
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
                                            <ext:ModelField Name="MRP_PO_TYPENM" />
                                            <ext:ModelField Name="DELI_DATE" />
                                            <ext:ModelField Name="DELI_CNT" />                                            
                                            <ext:ModelField Name="DELI_NOTE" />
                                            <ext:ModelField Name="DELI_PLACE" />
                                            <ext:ModelField Name="KOSTL_NM" />
                                            <ext:ModelField Name="DELI_TYPE" Type="Boolean" />
                                            <ext:ModelField Name="CANCEL_DELI_NOTE" />

                                            <ext:ModelField Name="SOURCING_DIV" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="DELI_PLACE" />
                                            <ext:ModelField Name="PURC_ORG" />
                                            <ext:ModelField Name="PURC_PO_TYPE" />
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
                                <ext:Column ID="MRP_PO_TYPENM" ItemID="MRO_PO_TYPE" runat="server" DataIndex="MRP_PO_TYPENM" Width="120" Align="Left" /><%--Text="일반구매유형"--%>
                                <ext:Column ID="DELI_DATE" ItemID="DELI_DATE" runat="server" DataIndex="DELI_DATE" Width="80" Align="Center" /><%--Text="납품일자"--%>
                                <ext:Column ID="DELI_CNT" ItemID="DELI_CNT" runat="server" DataIndex="DELI_CNT" Width="65" Align="Center" /><%--Text="납품차수"--%>
                                <ext:Column ID="DELI_NOTE" ItemID="DELINO02" runat="server" DataIndex="DELI_NOTE" Width="120" Align="Left" /><%--Text="거래명세서 번호"--%>
                                <ext:Column ID="DELI_PLACE" ItemID="DEL_STAGE" runat="server" DataIndex="DELI_PLACE" Width="80" Align="Left" /> <%--Text="납품장소"--%>
                                <ext:Column ID="KOSTL_NM" ItemID="INPT_PLACE" runat="server" DataIndex="KOSTL_NM" Width="80" Align="Left" /> <%--Text="입고장소"--%>
                                <ext:CheckColumn runat="server" ID ="DELI_TYPE" ItemID="DELI_CANCEL" Text="납품취소"  DataIndex="DELI_TYPE" Width="75"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >                                        
                                </ext:CheckColumn>
                                <ext:Column ID="CANCEL_DELI_NOTE" ItemID="CANCEL_DELI_NOTE3" runat="server" DataIndex="CANCEL_DELI_NOTE" Width="150" Align="Left" /><%--Text="취소된 거래명세서 번호"--%>
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true" />
                        </View>
                        <SelectionModel>
                        <%--4.X CHANGE -> SELECT (화면 로딩전에 사용 NULL오류로 인해서--%>
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
                                    <ext:Label ID="lbl01_DELI_NOTE_DETAIL2" runat="server" Cls="bottom_area_title_name2" Text="납품서 상세정보"/><%--Text="납품서 상세정보"--%>
                                </Items>
                            </ext:Panel>
                        </Items> 
                    </ext:Panel>
                    <ext:Panel ID="BottomGridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                        <Items>  
                            <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store7" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="Model4" runat="server">
                                                <Fields>                                       
                                                    <ext:ModelField Name="NO" />
                                                    <ext:ModelField Name="PO_DATE" />
                                                    <ext:ModelField Name="PONO" />
                                                    <ext:ModelField Name="PONO_SEQ" />
                                                    <ext:ModelField Name="PARTNM" />
                                                    <ext:ModelField Name="STANDARD" />
                                                    <ext:ModelField Name="MAKER" />
                                                    <ext:ModelField Name="PO_DELI_DATE" />
                                                    <ext:ModelField Name="PO_UNITNM" />
                                                    <ext:ModelField Name="UNIT_PACK_QTY" />
                                                    <ext:ModelField Name="PO_QTY" />
                                                    <ext:ModelField Name="REMAIN_QTY" />
                                                    <ext:ModelField Name="DELI_QTY" />
                                                    <ext:ModelField Name="PO_UCOST" />
                                                    <ext:ModelField Name="PO_AMT" />
                                                    <ext:ModelField Name="DELI_DETAIL_TYPE" />
                                                    <ext:ModelField Name="DELI_PLACE" />
                                                    <ext:ModelField Name="KOSTL_NM" />
                                                    <ext:ModelField Name="MGRT_NAME" />
                                                    <ext:ModelField Name="MGRT_TELNO" />
                                                    <ext:ModelField Name="PARTNO" />
                                                    <ext:ModelField Name="DELI_PLACE" />
                                                    <ext:ModelField Name="DELI_PLACENM" />
                                                    <ext:ModelField Name="PRDT_DATE" />
                                                    <ext:ModelField Name="MRO_PO_TYPE" />
                                                    <ext:ModelField Name="DELI_NOTE" />
                                                    <ext:ModelField Name="DELI_NOTE_SEQ" />
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
                                    <ext:CellEditing ID="CellEditing2" runat="server" ClicksToEdit="1" >
                                        <Listeners>                                    
                                            <BeforeEdit fn="BeforeEdit" />
                                            <Edit fn ="AfterEdit" />
                                        </Listeners>
                                    </ext:CellEditing>
                                </Plugins>  
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ID ="NO2" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" Locked="false" >
                                            <Renderer Fn="rendererNo"></Renderer>
                                        </ext:Column>
                                        <ext:Column ID="PO_DATE" ItemID="PO_DATE" runat="server" DataIndex="PO_DATE" Width="80" Align="Center" Locked="false" /><%--Text="발주일자"--%>
                                        <ext:Column ID="PONO" ItemID="PONO" runat="server" DataIndex="PONO" Width="100" Align="Left" Locked="false" /><%--Text="발주번호"--%>
                                        <ext:Column ID="PONO_SEQ" ItemID="SEQ_NO" runat="server" DataIndex="PONO_SEQ" Width="40" Align="Center" Locked="false" /><%--Text="발주행번호"--%>
                                        <ext:Column ID="PARTNM" ItemID="PARTNMTITLE" runat="server" DataIndex="PARTNM" MinWidth="240" Align="Left" Flex="1" /><%--Text="PART NAME"--%>
                                        <ext:Column ID="MAKER" ItemID="MAKER" runat="server" DataIndex="MAKER" Width="80" Align="Left" /><%--Text="MAKER"--%>
                                        <ext:Column ID="PO_DELI_DATE" ItemID="PO_DELI_DATE" runat="server" DataIndex="PO_DELI_DATE" Width="80" Align="Center" Locked="false" /><%--Text="납기일자"--%>
                                        <ext:Column ID="PO_UNITNM" ItemID="UNIT" runat="server" DataIndex="PO_UNITNM" Width="40" Align="Center" /><%--Text="UNIT"--%>
                                        <ext:NumberColumn ID="PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="PO_QTY" Width="65" Align="Right" Format="#,##0" Sortable="true"/><%--Text="발주량"--%>
                                        <ext:NumberColumn ID="REMAIN_QTY" ItemID="REMAINQTY" runat="server" DataIndex="REMAIN_QTY" Width="65" Align="Right" Format="#,##0" Sortable="true"/><%--Text="잔량"--%>

                                        <%-- 그리드에 이미지를 클릭할 수 있는 column (팝업을 위한 그리드의 돋보기 버튼)--%>
                                        <ext:ImageCommandColumn ID="ImageCommandColumn1" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="22" Align="Center" >
                                           <Commands>
                                              <ext:ImageCommand Icon="ArrowRight" ToolTip-Text="Copy" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                           </Commands>
                                           <Listeners>
                                              <Command Fn="gridRightButton_Handler" />                                         
                                           </Listeners>
                                        </ext:ImageCommandColumn>

                                        <ext:NumberColumn ID="DELI_QTY" ItemID="DELI_QTY" runat="server" DataIndex="DELI_QTY" Width="65" Align="Right" Format="#,##0" Sortable="true"><%--Text="납품량"--%>
                                            <Editor>
                                                <ext:NumberField ID="txt02_DELI_QTY" Cls="inputText_Num" FieldCls="inputText_Num" SelectOnFocus="true" runat="server" MinValue="0">
                                                    <Listeners>
                                                        <SpecialKey Fn="specialKey_KeyDown"></SpecialKey>
                                                    </Listeners>
                                                </ext:NumberField>
                                            </Editor>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn ID="PO_UCOST" ItemID="PO_UCOST" runat="server" DataIndex="PO_UCOST" Width="65" Align="Right" Format="#,##0" Sortable="true"/><%--Text="발주단가"--%>
                                        <ext:NumberColumn ID="PO_AMT" ItemID="DELI_AMT" runat="server" DataIndex="PO_AMT" Width="65" Align="Right" Format="#,##0" Sortable="true"/><%--Text="납품금액"--%>
                                        <ext:CheckColumn runat="server" ID ="DELI_DETAIL_CANCEL" ItemID="DELI_CANCEL" Text="납품취소"  DataIndex="DELI_DETAIL_TYPE" Width="75"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >                                        
                                        </ext:CheckColumn>
                                        <ext:Column ID="DELI_PLACE2" ItemID="DEL_STAGE" runat="server" DataIndex="DELI_PLACE" Width="80" Align="Left" /> <%--Text="납품장소"--%>
                                        <ext:Column ID="KOSTL_NM2" ItemID="INPT_PLACE" runat="server" DataIndex="KOSTL_NM" Width="80" Align="Left" /> <%--Text="입고장소"--%>  
                                        <ext:Column ID="MGRT_NAME" ItemID="MGRT_NAME02" runat="server" DataIndex="MGRT_NAME" Width="80" Align="Left" /> <%--Text="담당자"--%>    
                                        <ext:Column ID="MGRT_TELNO" ItemID="TELNO" runat="server" DataIndex="MGRT_TELNO" Width="100" Align="Left" /> <%--Text="전화번호"--%>  
                                    </Columns>                            
                                </ColumnModel>
                                <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                    <LoadMask ShowMask="true" />
                                </Loader>
                                <View>
                                    <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true" />
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
                            <col style="width: 150px;" />
                            <col style="width: 300px;" />
                            <col style="width: 150px;" />
                            <col style="width: 300px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_DELIVERY_DATE" runat="server" /><%--납품일자--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_DELI_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="false" ReadOnly="true" >
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
                            <th class="ess">
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
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
