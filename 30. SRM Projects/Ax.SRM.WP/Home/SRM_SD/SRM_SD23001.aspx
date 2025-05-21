<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_SD23001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_SD.SRM_SD23001" %>
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
	    .x-grid-cell-CUSTCD DIV,	 
	    .x-grid-cell-CUST_PLANT DIV,
	    .x-grid-cell-VIN DIV,
	    .x-grid-cell-WORK_DIR_DIV2 DIV,
	    .x-grid-cell-CUST_ITEMCD DIV,	    
	    .x-grid-cell-CUST_ITEMNM DIV,
	    .x-grid-cell-JIS_DIV DIV,
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
                    if (!editingPlugin.startEdit(position.row, position.column)) {

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
            if (App.CodeColName.getValue() == "CUSTCD")
                codeName = App.CodeColName.getValue();
            else if (App.CodeColName.getValue() == "PLANTNM")
                codeName = "PLANTCD";
            else
                codeName = "VINCD";
            
            if (codeName == "CUSTCD")
                grid.getStore().getAt(rowIdx).set("CUSTNM", typeNM);
            else
                grid.getStore().getAt(rowIdx).set(App.CodeColName.getValue(), typeNM);

            grid.getStore().getAt(rowIdx).set(codeName, objectID);

            // 필수코드 ( 반드시 )
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", false);
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", grid.getStore().getAt(rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        텍스트에서 enter키를 누를경우(버튼과 동일하나 넘어오는 파라메터가 달라서 찾기 버튼이벤트는 PopupHandler_button으로 하단에 구현
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var PopupHandler = function (editor, e) {
            var grd = editor.ownerCt.grid;

            if (e.getKey() === e.ENTER) {
                // BeforeEdit에서 param e를 전역 currentCellObject에 담아두고 Enter Key시에 사용한다. 
                // 이유 : 팝업창 뜬이후에 포커스가 바뀌면 row, col index가 변경되는 현상이 생겼음.
                var colIndex = currentCellObject.colIdx;
                var rowIndex = currentCellObject.rowIdx
                var field = currentCellObject.field;
                var codeValue = "";
                var nameValue = "";

                //코드 + Name일경우 (NAME에 특정값 지정하여 입력) 
                if (App.CodeColName.getValue() == "CUSTCD") {
                    codeValue = editor.getValue();
                    nameValue = grd.getStore().getAt(rowIndex).data.CUSTNM
                }
                //Only Name일 경우 (CODE에 특정값 지정하여 입력)
                else { 
                    codeValue = grd.getStore().getAt(App.CodeRow.getValue()).data.VINCD;
                    nameValue = editor.getValue();
                }

                fn_PopupHandler(grd, rowIndex, colIndex, field, codeValue);
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        1. 그리드에서 버튼을 클릭했을때 팝업을 띄어주는 메서드
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var PopupHandler_button = function (editor, command, row, rowIndex, colIndex) {
            var grd = editor.ownerCt.grid; //4.X 그리드는 한단계더 위에 존재
            var field = grd.columns[colIndex - 1].id;

            var codeValue = "";
            var nameValue = "";
            
            //코드 + Name일경우 (NAME에 특정값 지정하여 입력) 
            if (field == "CUSTCD") {
                codeValue = grd.getStore().getAt(rowIndex).data.CUSTCD;
                nameValue = grd.getStore().getAt(rowIndex).data.CUSTNM;
            }
            else if (field == "PLANTNM") {
                codeValue = grd.getStore().getAt(rowIndex).data.PLANTCD;
                nameValue = grd.getStore().getAt(rowIndex).data.PLANTNM;

                App.CurrentRowCustCD.setValue(grd.getStore().getAt(rowIndex).data.CUSTCD);
            }
            else {
                codeValue = grd.getStore().getAt(rowIndex).data.VINCD;
                nameValue = grd.getStore().getAt(rowIndex).data.VINNM;
            }

            fn_PopupHandler(grd, rowIndex, colIndex - 1, field, codeValue, nameValue);
        }

        //2.POPUP FIREEVENT 
        function fn_PopupHandler(grd, rowIndex, colIndex, field, selectedCodeValue, selectedNameValue) {
            App.CodeRow.setValue(rowIndex);
            App.CodeCol.setValue(colIndex); // 버튼의 이전행이 무조껀 코드가 되어야한다.
            App.CodeColName.setValue(grd.columns[colIndex].id);
                        
            App.CodeValue.setValue(selectedCodeValue);
            App.NameValue.setValue(selectedNameValue);
                                    
            if (App.CodeColName.getValue() == "CUSTCD") {
                App.btn01_CUSTCD.fireEvent('click');
            }
            else if (App.CodeColName.getValue() == "PLANTNM") {
                App.btn01_PLANTCD.fireEvent('click');
            }
            else{
                App.btn01_VINCD.fireEvent('click');
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        //그리드의 editor를 활성화시키는 시점에서 작동        
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;

        }
        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 그리드를 editor한 후에 발생되는 이벤트
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var AfterEdit = function (rowEditor, e) {
            if (e.column.dataIndex != "CHECK_VALUE") {
                e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", false);
                e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", e.grid.getStore().getAt(e.rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
            } else {
                e.grid.getStore().getAt(e.rowIdx).dirty = e.grid.getStore().getAt(e.rowIdx).data["CHECK_VALUE"];
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드 신규행 추가/취소
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var addNewRow = function (grid) {
            grid.editingPlugin.cancelEdit();

            //유형코드를 제외하면 TYPECD=OBJECTID임. 필수 체크할 때는 OBJECTID를 체크하여야함. (코드입력후 0.5초 이후에 조회하여 명칭 가져오는 타이밍때문에 빈값이 있을수 있음.)
            if (App.cdx01_VENDCD_OBJECTID.getValue() == "") {
                //업체코드를 선택하세요.             
                App.direct.MsgCodeAlert_ShowFormat("COM-00901", "cdx01_VENDCD_TYPECD", [App.lbl01_VEND.text]);
                return;
            }

//            var r = Ext.ModelManager.create({
//                CHR_CHK: false,
//                CUSTCD: '',
//                CUSTNM: '',
//                PLANTCD: '',
//                PLANTNM: '',
//                VINCD: '',
//                VINNM: '',
//                WORK_DIR_DIV: '',
//                CUST_ITEMCD: '',
//                CUST_ITEMNM: '',
//                JIS_DIV: '',                
//                REMARK: '',
//                VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
//                ISNEW: true
//            }, 'ModelGrid');
            var r = Ext.create('ModelGrid', {
                CHR_CHK: false,
                CUSTCD: '',
                CUSTNM: '',
                PLANTCD: '',
                PLANTNM: '',
                VINCD: '',
                VINNM: '',
                WORK_DIR_DIV: '',
                CUST_ITEMCD: '',
                CUST_ITEMNM: '',
                JIS_DIV: '',
                REMARK: '',
                VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
                ISNEW: true
            });
            grid.store.insert(0, r);
            grid.getSelectionModel().select(0, 2);
        };

        var removeRow = function (grid, checkColumn) {
            var sm = grid.getSelectionModel();

            if (!sm.getSelection()[0].data[checkColumn]) return;

            Ext.Msg.confirm('Confirm', 'Do you want to cancle selected row? ', function (btn, text) {
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

    </script>
</head>
<body>
    <form id="SRM_SD23001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
           <ext:Store ID="StoreCombo" runat="server">
            <Model>
                <ext:Model ID="Model4" runat="server" IDProperty="ID">
                    <Fields>
                        <ext:ModelField Name="OBJECT_NM" />
                        <ext:ModelField Name="OBJECT_ID" />
                    </Fields>
                </ext:Model>
            </Model>
        </ext:Store>
    <ext:ImageButton ID="btn01_CUSTCD" runat="server" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn"  OnDirectClick="etc_Button_Click" Hidden="true"/>
    <ext:ImageButton ID="btn01_PLANTCD" runat="server" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn"  OnDirectClick="etc_Button_Click" Hidden="true"/>
    <ext:ImageButton ID="btn01_VINCD" runat="server" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn"  OnDirectClick="etc_Button_Click" Hidden="true"/>
    <ext:TextField ID="CodeValue" runat="server" Hidden="true" /> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true" /> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true" /> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="CodeCol" runat="server" Hidden="true" /> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col index (사용하지 않으나 차후 필요할지 몰라서)--%>
    <ext:TextField ID="CodeColName" runat="server" Hidden="true" /> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col Name--%>
    <ext:TextField ID="CurrentRowCustCD" runat="server" Hidden="true" />  <%--선택된 행의 고객사 코드를 담는 숨김 필드 --%>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_SD23001" runat="server" Cls="search_area_title_name" /><%--Text="업체품목등록" />--%>
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
                            <col style="width: 300px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" /><%--Text="Vender Code" />--%>
                            </th>
                            <td>
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
                                </ext:SelectBox>
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
                                            <ext:ModelField Name="CORCD" />
                                            <ext:ModelField Name="BIZCD" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="PLANTCD" />
                                            <ext:ModelField Name="PLANTNM" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="WORK_DIR_DIV" />
                                            <ext:ModelField Name="CUST_ITEMCD" />
                                            <ext:ModelField Name="CUST_ITEMNM"/>
                                            <ext:ModelField Name="JIS_DIV" />
                                            <ext:ModelField Name="REMARK" />

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
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo" />
                                </ext:Column>
                                <%--선택체크박스--%>
                                <ext:CheckColumn runat="server" ID ="D_CHECK" Text=""  DataIndex="CHECK_VALUE" Width="35" 
                                                 StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true" HeaderCheckbox="true">
                                    <%--<RenderTpl ID="RenderTpl1" runat="server">
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
                                <%-- 고객사 codebox--%>
                                <ext:Column ID="CUSTCD" ItemID="CUSTCD" DataIndex="CUSTCD" runat="server" Width="70" Align="Center">
                                    <Editor>
                                        <ext:TextField ID="txt02_CUSTCD" ItemID="txt02_CUSTCD" Cls="inputText" FieldCls="inputText" runat="server" Height ="22">
                                            <Listeners>
                                                <SpecialKey Fn="PopupHandler" />
                                                <Change Handler="" />
                                            </Listeners>
                                        </ext:TextField>
                                    </Editor>
                                </ext:Column>                                
                                <%--조회버튼(팝업표시용)--%>   
                                <ext:ImageCommandColumn ID="ImageCommandColumn1" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="22" Align="Center" >
                                   <Commands>
                                      <ext:ImageCommand Icon="Magnifier" ToolTip-Text="Search Popup" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                   </Commands>
                                   <Listeners>
                                      <Command Fn="PopupHandler_button" />                                         
                                   </Listeners>
                                </ext:ImageCommandColumn> 
                                <%-- 편집 안되는 컬럼일 때--%>
                                <ext:Column ID="CUSTNM" ItemID="CUSTNM" DataIndex="CUSTNM" runat="server" Width="140" Align="Left" Visible="true" />
                                <ext:Column ID="PLANTNM" ItemID="CUST_PLANT" DataIndex="PLANTNM" runat="server" Width="150" Align="Left">
                                    <Editor>
                                        <ext:TextField ID="txt02_PLANTNM" ItemID="txt02_PLANTNM" Cls="inputText" FieldCls="inputText" runat="server" Height ="22">
                                            <Listeners>
                                                <SpecialKey Fn="PopupHandler" />
                                                <Change Handler="" />
                                            </Listeners>
                                        </ext:TextField>
                                    </Editor>
                                </ext:Column>                                
                                <%--조회버튼(팝업표시용)--%>   
                                <ext:ImageCommandColumn ID="ImageCommandColumn3" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="22" Align="Center" >
                                   <Commands>
                                      <ext:ImageCommand Icon="Magnifier" ToolTip-Text="Search Popup" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                   </Commands>
                                   <Listeners>
                                      <Command Fn="PopupHandler_button" />                                         
                                   </Listeners>
                                </ext:ImageCommandColumn>                                
                                <%-- 차종 codebox--%>
                                <ext:Column ID="VINNM" ItemID="VIN" DataIndex="VINNM" runat="server" Width="120" Align="Left">
                                    <Editor>
                                        <ext:TextField ID="txt02_VINNM" ItemID="txt02_VINNM" Cls="inputText" FieldCls="inputText" runat="server" Height ="22">
                                            <Listeners>
                                                <SpecialKey Fn="PopupHandler" />
                                                <Change Handler="" />
                                            </Listeners>
                                        </ext:TextField>
                                    </Editor>
                                </ext:Column>                                
                                <%--조회버튼(팝업표시용)--%>   
                                <ext:ImageCommandColumn ID="ImageCommandColumn2" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="22" Align="Center" >
                                   <Commands>
                                      <ext:ImageCommand Icon="Magnifier" ToolTip-Text="Search Popup" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                   </Commands>
                                   <Listeners>
                                      <Command Fn="PopupHandler_button" />                                         
                                   </Listeners>
                                </ext:ImageCommandColumn> 
                                <%-- 선택상자 컬럼일 때--%>
                                <ext:Column  ID="WORK_DIR_DIV"  ItemID="WORK_DIR_DIV2"  runat="server" DataIndex="WORK_DIR_DIV" Width="100" Align="Left" > <%--Text="작업지시"--%>                                 
                                    <Renderer Fn="gridComboRenderer" />                                    
                                    <Editor>                                        
                                       <ext:ComboBox ID="cbo02_WORK_DIR_DIV" runat="server"  DisplayField="OBJECT_NM" ValueField="OBJECT_ID" QueryMode="Local" AllowBlank = "false" Editable="true">                                                                        
                                            <Store>
                                                <ext:Store ID="Store3" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model3" runat="server" IDProperty="OBJECT_ID">
                                                            <Fields>
                                                                <ext:ModelField Name="OBJECT_NM" />
                                                                <ext:ModelField Name="OBJECT_ID" />                                                                
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                        </ext:ComboBox>
                                    </Editor>
                                </ext:Column>                                                         
                                <%-- 일반 text editor--%>
                                <ext:Column ID="CUST_ITEMCD" ItemID="CUST_ITEMCD" DataIndex="CUST_ITEMCD" runat="server" Width="100" Align="Left"><%--Text="고객사품목코드" --%>
                                    <Editor>
                                        <ext:TextField ID="txt02_CUST_ITEMCD" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                <ext:Column ID="CUST_ITEMNM" ItemID="CUST_ITEMNM" DataIndex="CUST_ITEMNM" runat="server" Width="140" Align="Left"><%--Text="고객사품목명" --%>
                                    <Editor>
                                        <ext:TextField ID="txt02_CUST_ITEMNM" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                <ext:Column  ID="JIS_DIV"  ItemID="JIS_DIV"  runat="server" DataIndex="JIS_DIV" Width="100" Align="Left" > <%--Text="서열구분"--%>                                 
                                    <Renderer Fn="gridComboRenderer" />                                    
                                    <Editor>                                        
                                       <ext:ComboBox ID="cbo02_JIS_DIV" runat="server"  DisplayField="OBJECT_NM" ValueField="OBJECT_ID" QueryMode="Local" AllowBlank = "false" Editable="true">                                                                        
                                            <Store>
                                                <ext:Store ID="Store2" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model2" runat="server" IDProperty="OBJECT_ID">
                                                            <Fields>
                                                                <ext:ModelField Name="OBJECT_NM" />
                                                                <ext:ModelField Name="OBJECT_ID" />                                                                
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                        </ext:ComboBox>
                                    </Editor>
                                </ext:Column>
                                <ext:Column ID="REMARK" ItemID="REMARK" DataIndex="REMARK" runat="server" MinWidth="140" Align="Left" Flex="1"><%--Text="비고" --%>
                                    <Editor>
                                        <ext:TextField ID="txt02_REMARK" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                            </Columns>
                            <Listeners>
                                <%--<HeaderClick Fn="onSelectionCheckHeaderChange" />--%> <%--그리드 헤더의 체크박스를 클릭할 경우 발생--%>
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
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">                                
                                <Listeners>
                                    <Select Fn="CellFocus"  />
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
