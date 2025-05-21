<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP20001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MP.SRM_MP20001" %>
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
	    .x-grid-cell-CHR_NM DIV,	    
	    .x-grid-cell-CHR_DEPT DIV,	    
	    .x-grid-cell-CHR_DUTY DIV,
	    .x-grid-cell-CHR_TEL DIV,
	    .x-grid-cell-CHR_FAX DIV,
	    .x-grid-cell-CHR_MOBILE DIV,
	    .x-grid-cell-CHR_EMAIL DIV,
	    .x-grid-cell-REMARK DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
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

            //화면 리사이즈까지 완료 후, 조회버튼 클릭 이벤트 발생시킨다. (화면 표시후 디폴트 조회 로직)
            //cs소스의 Page_Load 이벤트에 디폴트 조회 로직을 넣으면 매끄럽게 돌아가지 않음. 이벤트 꼬이는 듯. 
            App.ButtonSearch.fireEvent('click'); //Ext.getCmp('ButtonSearch').fireEvent('click');
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
                        if (!(this.selection.columnHeader.id == 'CHR_CHK')) { //[대표 담당자] 체크박스라면 멈춘다.
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
            

            // 코드처리는 동일 (코드 및 name이 같이 들어가는 경우에만 사용
            if (App.CodeColName.getValue() == "VENDCD" )
                codeName = App.CodeColName.getValue();


            grid.getStore().getAt(App.CodeRow.getValue()).set(textName, typeNM);
            grid.getStore().getAt(App.CodeRow.getValue()).set(codeName, objectID);


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
                App.CodeColName.setValue(currentCellObject.field);

                var selected_CodeValue = '';
                var selected_NameValue = '';

                //코드 + Name일경우 (NAME에 특정값 지정하여 입력) 
                if (App.CodeColName.getValue() == "VENDCD") {
                    selected_CodeValue = editor.getValue();
                    selected_NameValue = grd.getStore().getAt(App.CodeRow.getValue()).data.VENDNM;
                }
               
               
                App.CodeValue.setValue(selected_CodeValue);
                App.NameValue.setValue(selected_NameValue);

                PopUpFire();
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드에서 버튼을 클릭했을때 팝업을 띄어주는 메서드
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var PopupHandler_button = function (editor, command, row, rowIndex, colIndex) {
//            var grd = editor.grid;

//            App.CodeRow.setValue(rowIndex);
//            App.CodeCol.setValue(colIndex - 1); // 버튼의 이전행이 무조껀 코드가 되어야한다.
//            App.CodeColName.setValue(grd.columns[colIndex - 1].id);

//            var selected_CodeValue = '';
//            var selected_NameValue = '';

//            //코드 + Name일경우 (NAME에 특정값 지정하여 입력) 
//            if (App.CodeColName.getValue() == "VENDCD") {
//                selected_CodeValue = grd.getStore().getAt(App.CodeRow.getValue()).data.VENDCD;
//                selected_NameValue = grd.getStore().getAt(App.CodeRow.getValue()).data.VENDNM;
//            }
//            
//            App.CodeValue.setValue(selected_CodeValue);
//            App.NameValue.setValue(selected_NameValue);

//            PopUpFire();
        }

        var PopUpFire = function () {
           // if (App.CodeColName.getValue() == "VENDCD") App.btn02_VENDCD.fireEvent('click');
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드 신규행 추가
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var addNewRow = function (grid) {
            grid.editingPlugin.cancelEdit();

            //유형코드를 제외하면 TYPECD=OBJECTID임. 필수 체크할 때는 OBJECTID를 체크하여야함. (코드입력후 0.5초 이후에 조회하여 명칭 가져오는 타이밍때문에 빈값이 있을수 있음.)
            if (App.cdx01_VENDCD_OBJECTID.getValue() == "") {
                //업체코드를 선택하세요.             
                App.direct.MsgCodeAlert_ShowFormat("COM-00901", "cdx01_VENDCD_TYPECD", [ App.lbl01_VEND.text ]);
                return;
            }
            
            //BIZCD: App.SelectBox01_BIZCD.getValue(),
            // Create a record instance through the ModelManager
//                        var r = Ext.ModelManager.create({
//                            CHR_CHK: false,
//                            CHR_NM: '',
//                            CHR_DEPT: '',
//                            CHR_DUTY: '',
//                            CHR_TEL: '',
//                            CHR_FAX: '',
//                            CHR_MOBILE: '',
//                            CHR_EMAIL: '',
//                            REMARK: '',
//                            VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
//                            VENDNM: App.cdx01_VENDCD_TYPENM.getValue(),
//                            CHR_NO: '',
//                            ISNEW: true
            //                        }, 'ModelGrid');
                        var r = Ext.create('ModelGrid', {
                            CHR_CHK: false,
                            CHR_NM: '',
                            CHR_DEPT: '',
                            CHR_DUTY: '',
                            CHR_TEL: '',
                            CHR_FAX: '',
                            CHR_MOBILE: '',
                            CHR_EMAIL: '',
                            REMARK: '',
                            VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
                            VENDNM: App.cdx01_VENDCD_TYPENM.getValue(),
                            CHR_NO: '',
                            ISNEW: true
                        });

                        grid.store.insert(0, r);
                        grid.getSelectionModel().select(0, 2);
                        //grid.editingPlugin.startEdit(0, 2); 0번째 줄에 2번째 컬럼을 에디트 모드로 설정하는 샘플 코드
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

//        Ext.grid.plugin.CellEditing.override({
//            onEditComplete: function (ed, value, startValue) {

//                var me = this,
//                        activeColumn = me.getActiveColumn(),
//                        context = me.context,
//                        record;

//                if (activeColumn) {
//                    record = context.record;

//                    me.setActiveEditor(null);
//                    me.setActiveColumn(null);
//                    me.setActiveRecord(null);

//                    context.value = value;
//                    if (!me.validateEdit()) {
//                        return;
//                    }

//                    if (!record.isEqual(value, startValue)) {
//                        record.set(activeColumn.dataIndex, value);
//                        //                        record.data[activeColumn.dataIndex] = value;
//                        //                        record.dirty = true;
//                    }

//                    if (!Ext.isIE) { // the fix
//                        context.view.focus(false, true);
//                    }

//                    if (value == null && startValue == null) return;    //값없으면: 값변경 없이 커서만 옮긴 경우 그냥 종료.
//                    if (value == startValue) return;                    //값있으면: 값변경 없이 커서만 옮긴 경우 그냥 종료.

//                    me.fireEvent('edit', me, context);
//                    me.editing = false;
//                }
//            }
//            ,
//            cancelEdit: function () {
//                var me = this, activeEd = me.getActiveEditor();
//                
//                me.setActiveEditor(null);
//                me.setActiveColumn(null);
//                me.setActiveRecord(null);
//                if (activeEd) {
//                    activeEd.cancelEdit();

//                    if (!Ext.isIE) {
//                        me.context.view.focus();
//                    }

//                    me.callSuper(arguments);
//                    return;
//                }
//                // If we aren't editing, return true to allow the event to bubble
//                return true;
//            }
//        });

       
    </script>
</head>
<body>
    <form id="SRM_MP20001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>


   <%-- <ext:ImageButton ID="btn02_VENDCD" runat="server" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn"  OnDirectClick="etc_Button_Click" Hidden="true"/>--%>
    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="TextField_UpdateId" runat="server" Hidden="true"></ext:TextField>  <%--신규행을 추가시에 수정자를 이용하기 위해서 추가--%>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MP20001" runat="server" Cls="search_area_title_name" /><%--Text="담당자관리" />--%>
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
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" /><%--Text="Vender Code" />--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
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
                                    <ext:Model ID="GridModel1" runat="server" Name ="ModelGrid">
                                        <Fields>
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>

                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="CHR_CHK" DefaultValue="false" Type="Boolean"/>                                            
                                            <ext:ModelField Name="CHR_NM" />
                                            <ext:ModelField Name="CHR_DEPT" />
                                            <ext:ModelField Name="CHR_DUTY" />
                                            <ext:ModelField Name="CHR_TEL" />
                                            <ext:ModelField Name="CHR_FAX" />
                                            <ext:ModelField Name="CHR_MOBILE" />
                                            <ext:ModelField Name="CHR_EMAIL" />
                                            <ext:ModelField Name="REMARK" />
                                            <ext:ModelField Name="CHR_NO" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
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
                                <%--NO컬럼--%>
                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo"></Renderer>
<%--                                    <Editor>
                                        <ext:TextField ID="TextField_NO" Cls="inputText_Code_NoBorder" FieldCls="inputText_Code_NoBorder"  ReadOnly="true"  runat="server" Height ="26" Width="100" />
                                    </Editor>--%>
                                </ext:Column>
                                <%--선택체크박스--%>
                                <ext:CheckColumn runat="server" ID ="D_CHECK" Text=""  DataIndex="CHECK_VALUE" Width="35" 
                                                 StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true" HeaderCheckbox="true">
 <%--                                       <RenderTpl ID="RenderTpl1" runat="server">
                                            <Html>
                                                <div id="{id}-titleEl" {tipMarkup}class="x-column-header-inner">
                                                    <span id="{id}-textEl" class="x-column-header-text">
                                                        <input id="my-header-checkbox" type="checkbox" class="my-header-checkbox" style="width:15px;height:15px;" value="false" />
                                                    </span>
                                                    <tpl if="!menuDisabled">
                                                        <div id="{id}-triggerEl" class="x-column-header-trigger"></div>
                                                    </tpl>
                                                </div>
                                                {%this.renderContainer(out,values)%}
                                            </Html>
                                        </RenderTpl>
                                        <CustomConfig>
                                            <ext:ConfigItem Name="onElClick" Value="selectionCheckInitalize" Mode="Raw" />
                                        </CustomConfig>
                                        <Listeners>                                            
                                            <CheckChange Fn="onSelectionCheckContentChange" />
                                        </Listeners>--%>
                                </ext:CheckColumn>    
                                <%-- 체크박스 컬럼--%> 
                                <ext:CheckColumn ID ="CHR_CHK" ItemID="CHR_CHK" DataIndex="CHR_CHK" runat="server" Width="50"
                                    StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="대표" --%>
                                </ext:CheckColumn> 
                                
                                <%-- 일반 text editor--%>
                                <ext:Column ID="CHR_NM" ItemID="CHR_NM" DataIndex="CHR_NM" runat="server" Width="80" Align="Center"><%--Text="담당자명" --%>
                                    <Editor>
                                        <ext:TextField ID="TextField1" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <%-- 일반 text editor--%>
                                <ext:Column ID="CHR_DEPT" ItemID="CHR_DEPT" DataIndex="CHR_DEPT" runat="server" Width="90" Align="Center"><%--Text="부서" --%>
                                    <Editor>
                                        <ext:TextField ID="TextField2" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <%-- 일반 text editor--%>
                                <ext:Column ID="CHR_DUTY" ItemID="CHR_DUTY" DataIndex="CHR_DUTY" runat="server" Width="70" Align="Center"><%--Text="직책" --%>
                                    <Editor>
                                        <ext:TextField ID="TextField3" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <%-- 일반 text editor--%>
                                <ext:Column ID="CHR_TEL" ItemID="CHR_TEL" DataIndex="CHR_TEL" runat="server" Width="140" Align="Center"><%--Text="연락처" --%>
                                    <Editor>
                                        <ext:TextField ID="TextField4" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <%-- 일반 text editor--%>
                                <ext:Column ID="CHR_FAX" ItemID="CHR_FAX" DataIndex="CHR_FAX" runat="server" Width="120" Align="Center"><%--Text="FAX" --%>
                                    <Editor>
                                        <ext:TextField ID="TextField5" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <%-- 일반 text editor--%>
                                <ext:Column ID="CHR_MOBILE" ItemID="CHR_MOBILE" DataIndex="CHR_MOBILE" runat="server" Width="140" Align="Center"><%--Text="핸드폰" --%>
                                    <Editor>
                                        <ext:TextField ID="TextField6" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <%-- 일반 text editor--%>
                                <ext:Column ID="CHR_EMAIL" ItemID="CHR_EMAIL" DataIndex="CHR_EMAIL" runat="server" Width="140" Align="Left"><%--Text="이메일" --%>
                                    <Editor>
                                        <ext:TextField ID="TextField7" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <%-- 일반 text editor--%>
                                <ext:Column ID="REMARK" ItemID="REMARK" DataIndex="REMARK" runat="server" Width="150" Align="Left" Flex="1" MinWidth="150"><%--Text="비고" --%>
                                    <Editor>
                                        <ext:TextField ID="TextField8" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <ext:Column ID="CHR_NO" ItemID="CHR_NO" DataIndex="CHR_NO" runat="server" Width="70" Align="Center" Visible="false"/><%--Text="담당자번호"  --%>
                                <ext:Column ID="VENDCD" ItemID="VEND" DataIndex="VENDCD" runat="server" Width="80" Align="Center" /><%--Text="업체코드" --%>
                                <ext:Column ID="VENDNM" ItemID="VENDNM" DataIndex="VENDNM" runat="server" Width="150" Align="Left" /><%--Text="업체명" --%>
                            </Columns>
                            <%-- 그리드에서 editor에서 키를 다운했을 경우에 발생되는 핸들러가 막혀있어서 차후에 필요하다면 아래와 같이 사용
                            <Listeners>
                                <Render Handler="this.el.on('keydown', startEditing);" />
                            </Listeners>
                            --%>
                            <Listeners>
                                <HeaderClick Fn="onSelectionCheckHeaderChange" /> <%--그리드 헤더의 체크박스를 클릭할 경우 발생--%>
                            </Listeners>
                        </ColumnModel>

                        <%-- 그리드 검색시 보이는 progress--%>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                        </View>
                        <%-- SelectionModel은 checkbox, cell, row가 존재하고 그리드를 클릭시 그리드의 선택된 행의값이 json형태로 넘어감 (EP20S01참고)--%>
                        <SelectionModel>
                        <%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">        
                                <Listeners><Select Fn="CellFocus"></Select></Listeners>
                            </ext:CellSelectionModel >
                            <%--<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server"><Listeners><Select Fn="CellFocus"></Select></Listeners></ext:CheckboxSelectionModel>--%>
                        </SelectionModel>                    
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
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_cancelrow.gif" ID="btnRowDelete">
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
