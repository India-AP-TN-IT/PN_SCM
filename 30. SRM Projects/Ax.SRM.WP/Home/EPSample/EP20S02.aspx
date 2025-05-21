<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP20S02.aspx.cs" Inherits="Ax.EP.WP.Home.EPSample.EP20S02" %>
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

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>

    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
	    .x-grid-cell-PARTNO DIV,	    
	    .x-grid-cell-BIZNM2 DIV,	    
	    .x-grid-cell-VENDCD DIV,	    
	    .x-grid-cell-VINNM DIV,
	    .x-grid-cell-ITEMNM3 DIV,
	    .x-grid-cell-STANDARD DIV,
	    .x-grid-cell-PACK_QTY DIV,
	    .x-grid-cell-BEG_DATE3 DIV,
	    .x-grid-cell-END_DATE DIV,
	    .x-grid-cell-EMPNO3 DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    };
	    
    </style>


    <script type="text/javascript">

        // 그리드에서 선택된 Action Object
        var currentCellObject;

        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
            var codeName, textName;

            var grid = App.Grid01;
            var rowIdx = App.CodeRow.getValue();

            // 코드명만 다르게 처리(코드 + NAME) 
            if (App.CodeColName.getValue() == "VENDCD") textName = "VENDNM";
            else if (App.CodeColName.getValue() == "PARTNO") textName = "PARTNM";
            //ONLY NAME만 그리드에 들어갈경우에 NM에 맞게 값을 설정
            else if (App.CodeColName.getValue() == "VINNM" || App.CodeColName.getValue() == "ITEMNM")
                textName = App.CodeColName.getValue();

            // 코드처리는 동일 (코드 및 name이 같이 들어가는 경우에만 사용
            if (App.CodeColName.getValue() == "VENDCD" || App.CodeColName.getValue() == "PARTNO")
                codeName = App.CodeColName.getValue();
            // ONLY NAME만 그리드에 들어갈 경우에(STORE강제 변경)
            else if (App.CodeColName.getValue() == "VINNM")
                codeName = 'VINCD';
            else if (App.CodeColName.getValue() == "ITEMNM")
                codeName = 'ITEMCD';

            grid.getStore().getAt(App.CodeRow.getValue()).set(textName, typeNM);
            grid.getStore().getAt(App.CodeRow.getValue()).set(codeName, objectID);


            // 필수코드 ( 반드시 )
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", false);
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", grid.getStore().getAt(rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
        };

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
        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            var grid = selectionModel.view.ownerCt;

            grid.editingPlugin.startEdit(rowIndex, colIndex);
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        텍스트에서 enter키를 누를경우(버튼과 동일하나 넘어오는 파라메터가 달라서 찾기 버튼이벤트는 PopupHandler_button으로 하단에 구현
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var PopupHandler = function (editor, e) {
            
            var grd = editor.ownerCt.grid;

            if (e.getKey() === e.ENTER) {
                // BeforeEdit에서 param e를 전역 currentCellObject에 담아두고 Enter Key시에 사용한다. 
                // 이유 : 팝업창 뜬이후에 포커스가 바뀌면 row, col index가 변경되는 현상이 생겼음.
                App.CodeRow.setValue(currentCellObject.rowIdx);
                App.CodeCol.setValue(currentCellObject.colIdx);
                App.CodeColName.setValue(currentCellObject.field);

                var selected_CodeValue = '';
                var selected_NameValue = '';

                //코드 + Name일경우 (NAME에 특정값 지정하여 입력) 
                if (App.CodeColName.getValue() == "VENDCD") {
                    selected_CodeValue = editor.getValue();
                    selected_NameValue = grd.getStore().getAt(App.CodeRow.getValue()).data.VENDNM;
                }
                else if (App.CodeColName.getValue() == "PARTNO") {
                    selected_CodeValue = editor.getValue();
                    selected_NameValue = grd.getStore().getAt(App.CodeRow.getValue()).data.PARTNM;
                }
                //Only Name일 경우 (CODE에 특정값 지정하여 입력)
                else if (App.CodeColName.getValue() == "VINNM") {
                    selected_CodeValue = grd.getStore().getAt(App.CodeRow.getValue()).data.VINCD;
                    selected_NameValue = editor.getValue();
                }
                else {
                    selected_CodeValue = grd.getStore().getAt(App.CodeRow.getValue()).data.ITEMCD;
                    selected_NameValue = editor.getValue();
                }

                App.CodeValue.setValue(selected_CodeValue);
                App.NameValue.setValue(selected_NameValue);

                PopUpFire();
            }
            else if (e.getKey() === 40) {                          
                grd.editingPlugin.startEdit(currentCellObject.rowIdx + 1, currentCellObject.colIdx);
            }
            else if (e.getKey() === 38) {
                grd.editingPlugin.startEdit(currentCellObject.rowIdx -1, currentCellObject.colIdx);
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드에서 버튼을 클릭했을때 팝업을 띄어주는 메서드
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var PopupHandler_button = function (editor, command, row, rowIndex, colIndex) {
            var grd = editor.ownerCt.grid;

            App.CodeRow.setValue(rowIndex);
            App.CodeCol.setValue(colIndex - 1); // 버튼의 이전행이 무조껀 코드가 되어야한다.
            App.CodeColName.setValue(grd.columns[colIndex - 1].id);

            var selected_CodeValue = '';
            var selected_NameValue = '';

            //코드 + Name일경우 (NAME에 특정값 지정하여 입력) 
            if (App.CodeColName.getValue() == "VENDCD") {
                selected_CodeValue = grd.getStore().getAt(App.CodeRow.getValue()).data.VENDCD;
                selected_NameValue = grd.getStore().getAt(App.CodeRow.getValue()).data.VENDNM;
            }
            else if (App.CodeColName.getValue() == "PARTNO") {
                selected_CodeValue = grd.getStore().getAt(App.CodeRow.getValue()).data.PARTNO;
                selected_NameValue = grd.getStore().getAt(App.CodeRow.getValue()).data.PARTNM;
            }
            //Only Name일 경우 (CODE에 특정값 지정하여 입력)
            else if (App.CodeColName.getValue() == "VINNM") {
                selected_CodeValue = grd.getStore().getAt(App.CodeRow.getValue()).data.VINCD;
                selected_NameValue = grd.getStore().getAt(App.CodeRow.getValue()).data.VINNM;
            }
            else {
                selected_CodeValue = grd.getStore().getAt(App.CodeRow.getValue()).data.ITEMCD;
                selected_NameValue = grd.getStore().getAt(App.CodeRow.getValue()).data.ITEMNM;
            }

            App.CodeValue.setValue(selected_CodeValue);
            App.NameValue.setValue(selected_NameValue);

            PopUpFire();
        }

        var PopUpFire = function () {
            if (App.CodeColName.getValue() == "VENDCD") App.btn02_VENDCD.fireEvent('click');
            else if (App.CodeColName.getValue() == "PARTNO") App.btn02_PARTNO.fireEvent('click');
            else if (App.CodeColName.getValue() == "VINNM") App.btn02_VINNM.fireEvent('click');
            else if (App.CodeColName.getValue() == "ITEMNM") App.btn02_ITEMNM.fireEvent('click');
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드 신규행 추가
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var addNewRow = function (grid) {
            grid.editingPlugin.cancelEdit();

            // Create a record instance through the ModelManager
            var r = Ext.create('ModelGrid', {
                BIZCD: App.SelectBox01_BIZCD.getValue(),
                VENDCD: '',
                VENDNM: '',
                PARTNO: '',
                PARTNM: '',
                VINCD: '',
                VINNM: '',
                ITEMCD: '',
                ITEMNM: '',
                STANDARD: '',
                WEIGHT: 0,
                PACK_QTY: 0,
                BEG_DATE: Ext.Date.clearTime(new Date()),
                END_DATE: Ext.Date.clearTime(new Date()),
                EMPNO: App.TextField_UpdateId.getValue(),
                UPDATE_ID: App.TextField_UpdateId.getValue(),
                UPDATE_DATE: '',
                ISNEW: true
            });

            grid.store.insert(0, r);
            grid.getSelectionModel().select(0, 2);
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

        // 그리드를 editor한 후에 발생되는 이벤트
       var AfterEdit = function (rowEditor, e) {
            if (e.column.dataIndex != "CHECK_VALUE") {
                e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", false);
                e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", e.grid.getStore().getAt(e.rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
            } else {
                e.grid.getStore().getAt(e.rowIdx).dirty = e.grid.getStore().getAt(e.rowIdx).data["CHECK_VALUE"];
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 그리드의 컬럼에서 링크 눌렀을 경우
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var linkClick = function (store, rowIndex) {
            alert("PARTNO: " + store.getAt(rowIndex).data["PARTNO"]);
        };

        var linkRenderer = function (value, meta, record, index) {
            var param = "Ext.getStore('" + record.store.storeId + "')";
            return Ext.String.format("<a style='color:blue;text-decoration:underline;' href='#' onclick=\"linkClick({0},{1});\">{2}</a>", param, index, value);
        };

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            //CellDbClick이벤트의 파라메터중 3번째로 넘어오는 cellIndex는 
            //더블클릭한 셀의 인덱스를 가져오도록 되어 있는데
            //ItemId가 동일한 여러 컬럼이 존재하는 경우에는(다국어) 제대로 값이 넘어오지 않음.
            //그래서 7번째 파라메터인 obj4의 하위속성을 이용하여 cellIndex값 제대로 추출함.
            cellIndex = obj4.target.offsetParent.cellIndex;
            var grid = grid.ownerCt;
            var columnName = grid.columns[cellIndex].dataIndex;
            if (columnName == 'PARTNM') {
                /* 참고: cs단에서 메서드 생성시 public으로  */
                App.direct.Cell_Click(grid.store.getAt(rowIndex).data[columnName], rowIndex, cellIndex);
            }
        }
    </script>
</head>
<body>
    <form id="EP20S02" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>


    <ext:ImageButton ID="btn02_VENDCD" runat="server" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn"  OnDirectClick="etc_Button_Click" Hidden="true"/>
    <ext:ImageButton ID="btn02_PARTNO" runat="server" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn"  OnDirectClick="etc_Button_Click" Hidden="true"/>
    <ext:ImageButton ID="btn02_VINNM" runat="server" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn"  OnDirectClick="etc_Button_Click" Hidden="true"/>
    <ext:ImageButton ID="btn02_ITEMNM" runat="server" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn"  OnDirectClick="etc_Button_Click" Hidden="true"/>
    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="CodeCol" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col index (사용하지 않으나 차후 필요할지 몰라서)--%>
    <ext:TextField ID="CodeColName" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col Name--%>
    <ext:TextField ID="TextField_UpdateId" runat="server" Hidden="true"></ext:TextField>  <%--신규행을 추가시에 수정자를 이용하기 위해서 추가--%>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="35">
                <Items>
                    <ext:Label ID="lbl01_EP20S02" runat="server" Cls="search_area_title_name" Text="테스트" />
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" Height="65">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 100px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th >
                                <ext:Label ID="lbl01_BIZCD" runat="server" Text="Business Code" />
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox01_BIZCD" ItemID="SelectBox01_BIZCD" runat="server" Cls="inputText"  Mode="Local" ForceSelection="true"
                                    DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" Width="260">
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
                            <th>
                                <ext:Label ID="lbl01_VENDCD" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_VINCD" runat="server" Text="Vihicle Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_PARTNO" runat="server" Text="Part No." />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_PARTNO" runat="server" HelperID="HELP_PARTNO" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>

            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" Height="50" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server" Name ="ModelGrid">
                                        <Fields>
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>

                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="BIZCD" />                                            
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="ITEMCD" />
                                            <ext:ModelField Name="ITEMNM" />
                                            <ext:ModelField Name="STANDARD" Type ="String" />
                                            <ext:ModelField Name="WEIGHT" Type ="Float"  />
                                            <ext:ModelField Name="PACK_QTY" Type ="Int" />
                                            <ext:ModelField Name="USE_YN" Type="Boolean" />
                                            <ext:ModelField Name="BEG_DATE"    />
                                            <ext:ModelField Name="END_DATE"   />
                                            <ext:ModelField Name="EMPNO" />
                                            <ext:ModelField Name="UPDATE_ID" />
                                            <ext:ModelField Name="UPDATE_DATE" Type="Date" />

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
                                <%--선택체크박스--%>
                                <ext:CheckColumn runat="server" ID ="D_CHECK" Text=""  DataIndex="CHECK_VALUE" Width="35" 
                                                 StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true">

                                        <CustomConfig>
                                            <ext:ConfigItem Name="onElClick" Value="selectionCheckInitalize" Mode="Raw" />
                                        </CustomConfig>
                                </ext:CheckColumn>                                   
                                <ext:Column  ID="BIZCD"  ItemID="BIZNM2"  runat="server" Text="사업장" DataIndex="BIZCD" Width="120" Align="Center">
                                    <Editor> 
                                       <ext:ComboBox ID="SelectBox_Bizcd" runat="server"  DisplayField="BIZNM" ValueField="BIZCD" QueryMode="Local" AllowBlank = "false" Editable="false">                         
                                           <Store>
                                               <ext:Store ID="Store_Bizcd" runat="server">
                                                   <Model>
                                                       <ext:Model ID="Model3" runat="server" IDPropery="BIZCD">
                                                           <Fields>                                                                                    
                                                               <ext:ModelField Name="BIZCD" />
                                                               <ext:ModelField Name="BIZNM" />
                                                           </Fields>
                                                       </ext:Model>
                                                   </Model>
                                               </ext:Store>
                                           </Store>                                            
                                        </ext:ComboBox>
                                    </Editor>
                                </ext:Column >
                                <ext:Column ID="VENDCD" runat="server"  Text="업체코드" DataIndex="VENDCD" Width="70" Align="Center">
                                    <Editor>
                                        <ext:TextField ID="TextField_VENDCD" ItemID="TextField_VENDCD" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22"  > 
                                            <Listeners>
                                                <SpecialKey Fn="PopupHandler"></SpecialKey>                                                
                                            </Listeners>
                                        </ext:TextField>                                        
                                    </Editor>
                                </ext:Column>
                                <%-- 그리드에 이미지를 클릭할 수 있는 column (팝업을 위한 그리드의 돋보기 버튼)--%>
                                <ext:ImageCommandColumn ID="ImageCommandColumn1" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="22" Align="Center" >
                                   <Commands>
                                      <ext:ImageCommand Icon="Magnifier" ToolTip-Text="Search Popup" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                   </Commands>
                                   <Listeners>
                                      <Command Fn="PopupHandler_button" />                                         
                                   </Listeners>
                                </ext:ImageCommandColumn>                                
                                <ext:Column ID="VENDNM" runat="server" Text="업체명" DataIndex="VENDNM" MinWidth="150" Align="Left" Flex="1" >                                
                                    <Renderer Fn="linkRenderer" />
                                </ext:Column>
                                <ext:Column ID="PARTNO" runat="server" Text="품번" DataIndex="PARTNO" Width="100" Align="Left">
                                    <Editor>
                                        <ext:TextField ID="TextField_PARTNO" ItemID="TextField_PARTNO" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22"  > 
                                            <Listeners>
                                                <SpecialKey Fn="PopupHandler"></SpecialKey>
                                            </Listeners>
                                        </ext:TextField>       
                                    </Editor>                                    
                                </ext:Column>    

                                <ext:ImageCommandColumn ID="ImageCommandColumn2" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="22" Align="Center" >
                                   <Commands>
                                      <ext:ImageCommand Icon="Magnifier" ToolTip-Text="Search Popup" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                   </Commands>
                                   <Listeners>
                                      <Command Fn="PopupHandler_button" />                                         
                                   </Listeners>
                                </ext:ImageCommandColumn>

                                <ext:Column ID="PARTNM" ItemID="PARTNMTITLE" runat="server" Text="품명" DataIndex="PARTNM"  MinWidth="180" Align="Left" Flex="1" >
                                </ext:Column>

                                <ext:Column ID="VINNM"  runat="server" Text="차종명" DataIndex="VINNM" Width="100" Align="Left">
                                    <Editor>
                                        <ext:TextField ID="TextField_VINNM" ItemID="TextField_VINNM" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22"  > 
                                            <Listeners>
                                                <SpecialKey Fn="PopupHandler"></SpecialKey>
                                            </Listeners>
                                        </ext:TextField>
                                    </Editor>
                                </ext:Column>  
                                <ext:ImageCommandColumn ID="ImageCommandColumn4" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="22" Align="Center" >
                                   <Commands>
                                      <ext:ImageCommand Icon="Magnifier" ToolTip-Text="Search Popup" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                   </Commands>
                                   <Listeners>
                                      <Command Fn="PopupHandler_button" />                                         
                                   </Listeners>
                                </ext:ImageCommandColumn>
                                <ext:Column ID="ITEMNM" ItemID="ITEMNM3" runat="server" Text="품목" DataIndex="ITEMNM" Width="100" Align="Left">
                                    <Editor>
                                        <ext:TextField ID="TextField_ITEMNM" ItemID="TextField_ITEMNM" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22"  > 
                                            <Listeners>
                                                <SpecialKey Fn="PopupHandler"></SpecialKey>
                                            </Listeners>
                                        </ext:TextField>
                                    </Editor>
                                </ext:Column>  
                                <ext:ImageCommandColumn ID="ImageCommandColumn3" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="22" Align="Center" >
                                   <Commands>
                                      <ext:ImageCommand Icon="Magnifier" ToolTip-Text="Search Popup" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                   </Commands>
                                   <Listeners>
                                      <Command Fn="PopupHandler_button" />                                         
                                   </Listeners>
                                </ext:ImageCommandColumn>

                                <%-- 일반 text editor--%>
                                <ext:Column ID="STANDARD" runat="server" Text="규격" DataIndex="STANDARD" Width="110" Align="Center">
                                    <Editor>
                                        <ext:TextField ID="TextField1" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" >
                                        </ext:TextField>
                                    </Editor>
                                </ext:Column>

                                <%-- 숫자를 위한 컬럼: editor에서 format을 주더라도 그리드 바인딩시점에서 NumberColumn에 format을 주지 않는 다면 format이 적용되지 않음. 따라서 컬럼과 editor 모두 format지정해야함--%>
                                <ext:NumberColumn ID="WEIGHT"   runat="server" Text="무게" DataIndex="WEIGHT" Width="100" Align="Right" AllowBlank="false"  AllowDecimals="true" Format="#,###.00000" DecimalPrecision="5" Step="0.00001" MinValue="0"/>
            
                                <ext:NumberColumn ID="PACK_QTY" runat="server" Text="포장수량" DataIndex="PACK_QTY" Width="70" Align="Right" Format="#,##0">               
                                    <Editor>
                                        <ext:NumberField ID="NumberField1" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" AllowBlank="false" />
                                    </Editor>
                                </ext:NumberColumn>

                                <ext:CheckColumn runat="server" ID ="USE_YM" Text="사용유무"  DataIndex="USE_YN" Width="65"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >                                        
                                </ext:CheckColumn> 

                                <%-- 데이터 컬럼 : editor는 DateField로써 date picker임--%>
                                <ext:DateColumn ID="BEG_DATE" ItemID="BEG_DATE3" runat="server" Text="시작일자" DataIndex="BEG_DATE" Width="105" Align="Center" >                                
                                    <Editor> 
                                        <ext:DateField ID="DateField1" runat="server"  SelectOnFocus="true"  > 
                                        </ext:DateField>
                                    </Editor>                                                                
                                </ext:DateColumn>    

                                <ext:DateColumn ID="END_DATE" runat="server" Text="종료일자" DataIndex="END_DATE" Width="105" Align="Center" >
                                    <Editor>
                                        <ext:DateField ID="DateField2" runat="server"  SelectOnFocus="true"  > 
                                        </ext:DateField>
                                    </Editor>
                                </ext:DateColumn>

                                <ext:Column  ID="EMPNO"  ItemID="EMPNO3"  runat="server" Text="담당자사번" DataIndex="EMPNO" Width="90" Align="Center" >                                    
                                    <Editor>                                        
                                       <ext:ComboBox ID="SelectBox_Empno" runat="server"  DisplayField="TYPENM" ValueField="OBJECT_ID" QueryMode="Local" AllowBlank = "false" Editable="false">                                                                        
                                            <Store>
                                                <ext:Store ID="Store_Empno" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model2" runat="server" IDProperty="OBJECT_ID">
                                                            <Fields>
                                                                <ext:ModelField Name="TYPENM" />
                                                                <ext:ModelField Name="OBJECT_ID" />                                                                
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                        </ext:ComboBox>
                                    </Editor>
                                </ext:Column>

                                <ext:Column ID="UPDATE_ID" ItemID="UPDATE_ID2"  runat="server" Text="수정자ID" DataIndex="UPDATE_ID" Width="70" Align="Center" />
                                <ext:DateColumn ID="UPDATE_DATE" ItemID="UPDATE_DATE2" runat="server" Text="수정일시"  DataIndex="UPDATE_DATE" Width="130" Align="Center" Format="yyyy-MM-dd HH:mm:ss" />
                                
                            </Columns>

                        </ColumnModel>

                        <%-- 그리드 검색시 보이는 progress--%>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true" />
                        </View>
                        <%-- SelectionModel은 checkbox, cell, row가 존재하고 그리드를 클릭시 그리드의 선택된 행의값이 json형태로 넘어감 (EP20S01참고)--%>
                        <SelectionModel>
                            <ext:CellSelectionModel ID="RowSelectionModel1" runat="server">
                            </ext:CellSelectionModel >
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
            <ext:Panel ID="BottomButtonPanel" runat="server" Region="North" Height="23" Cls="bottom_area_btn" Hidden="false">
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
            <%--ContentPanel 의 Width, StyleSpec 내용은 Region 이 South 일 경우 필요 없음--%>
            <ext:Panel ID="ContentPanel" Cls="bottom_area_table" runat="server" Region="South" Height="154" Visible="false">

            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
