<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_ALC20001.aspx.cs" Inherits="Ax.EP.WP.Home.SRM_ALC.SRM_ALC20001" %>
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

    <title>품목 차수량 등록</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
	    .x-grid-cell-PLANT DIV,	    
	    .x-grid-cell-LINE DIV,	    
	    .x-grid-cell-FIELD_NM1 DIV,	    
	    .x-grid-cell-FIELD_NM2 DIV,
	    .x-grid-cell-CHASU_QTY DIV
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

            grid.getStore().getAt(App.CodeRow.getValue()).set(textName, typeNM);
            grid.getStore().getAt(App.CodeRow.getValue()).set(codeName, objectID);


            // 필수코드 ( 반드시 )
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", false);
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", grid.getStore().getAt(rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드 신규행 추가
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var addNewRow = function (grid) {
            grid.editingPlugin.cancelEdit();

            if (App.cdx01_VENDCD_OBJECTID.getValue() == "") {
                //업체코드를 선택하세요.             
                App.direct.MsgCodeAlert_ShowFormat("SRMALC00-0005", "cdx01_VENDCD_TYPECD", [App.lbl01_VEND.text]);
                return;
            }            

            // Create a record instance through the ModelManager
//            var r = Ext.ModelManager.create({
//                PLANT_GB: '',
//                LINE_GB: '',
//                FIELD_NM1: '',
//                FIELD_NM2: '',
//                CHASU_QTY: '',
//                ISNEW: true
            //            }, 'ModelGrid');
            var r = Ext.create('ModelGrid', {
                PLANT_GB: '',
                LINE_GB: '',
                FIELD_NM1: '',
                FIELD_NM2: '',
                CHASU_QTY: '',
                ISNEW: true
            });

            grid.store.insert(0, r);
            grid.getSelectionModel().select(0, 2);
        };

        var removeRow = function (grid, checkColumn) {
            var sm = grid.getSelectionModel();

            if (!sm.getSelection()[0].data[checkColumn]) return;

            grid.editingPlugin.cancelEdit();
            grid.store.remove(sm.getSelection());
            if (grid.store.getCount() > 0) {
                sm.select(0);
            }

//            Ext.Msg.confirm('Confirm', 'Do you want to delete selected row? ', function (btn, text) {
//                if (btn == 'yes') {

//                }
//                return false;
//            })

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
        // 그리드의 입력 형태별 css 유무
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/

        var getRowClass = function (record) {

            return "edit-row";
        };
    </script>
</head>
<body>
    <form id="SRM_ALC20001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

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
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_ALC20001" runat="server" Cls="search_area_title_name" /> <%--품목 차수량 등록--%>
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
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                        </tr> 
                    </table>
                </Content>
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
                                            <ext:ModelField Name="PLANT_GB" />
                                            <ext:ModelField Name="LINE_GB" />
                                            <ext:ModelField Name="FIELD_NM1" />
                                            <ext:ModelField Name="FIELD_NM2" />
                                            <ext:ModelField Name="CHASU_QTY" />
                                            <ext:ModelField Name="VEND_CD" />

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
<%--                                    <Editor>
                                        <ext:TextField ID="TextField_NO" Cls="inputText_Code_NoBorder" FieldCls="inputText_Code_NoBorder"  ReadOnly="true"  runat="server" Height ="26" Width="100" />
                                    </Editor>--%>
                                </ext:Column>
                                <ext:CheckColumn runat="server" ID ="D_CHECK" Text=""  DataIndex="CHECK_VALUE" Width="35" 
                                                 StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true"  HeaderCheckbox="true"><%-- HideTitleEl="true">--%>
                                       <%-- <RenderTpl ID="RenderTpl1" runat="server">
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

                                <ext:Column ID="PLANT_GB" ItemID="PLANT" runat="server" DataIndex="PLANT_GB" Width="60" Align="Center" >  <%--Text="공장"--%> 
                                    <Editor>
                                        <ext:TextField ID="txt02_PLANT" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                <ext:Column ID="LINE_GB" ItemID="LINE" runat="server" DataIndex="LINE_GB" Width="60" Align="Center">   <%--Text="라인"--%> 
                                    <Editor>
                                        <ext:TextField ID="txt02_LINE" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                <ext:Column  ID="FIELD_NM1"  ItemID="FIELD_NM1"  runat="server" DataIndex="FIELD_NM1" Width="90" Align="Center" >   <%--Text="필드명1"--%>                                  
                                    <Renderer Fn="gridComboRenderer" />
                                    <Editor>                                        
                                       <ext:ComboBox ID="cbo02_FILED_NM1" runat="server"  DisplayField="TYPENM" ValueField="OBJECT_ID" QueryMode="Local" AllowBlank = "false" Editable="false">                                                                        
                                            <Store>
                                                <ext:Store ID="Store_FILED_NM1" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model3" runat="server" IDProperty="OBJECT_ID">
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
                               <ext:Column  ID="FIELD_NM2"  ItemID="FIELD_NM2"  runat="server" DataIndex="FIELD_NM2" Width="90" Align="Center" >   <%--Text="필드명2"--%>                                  
                                    <Renderer Fn="gridComboRenderer" />
                                    <Editor>                                        
                                       <ext:ComboBox ID="cbo02_FILED_NM2" runat="server"  DisplayField="TYPENM" ValueField="OBJECT_ID" QueryMode="Local" AllowBlank = "false" Editable="false">
                                            <Store>
                                                <ext:Store ID="Store_FILED_NM2" runat="server" >
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
                                <ext:Column ID="CHASU_QTY" ItemID="CHASU_QTY" runat="server" DataIndex="CHASU_QTY" Width="80" Align="Center" >
                                    <Editor>
                                        <ext:TextField ID="txt02_CHASU_QTY" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>  <%--Text="차수량"--%> 
                                <ext:Column ID="VEND_CD" ItemID="VEND_CD" runat="server" DataIndex="VEND_CD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="Column1" ItemID="Column1" runat="server" DataIndex="Column1" MinWidth="0" Align="Left" Flex="1" />  <%--Text=""--%> 
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
                                <GetRowClass Fn="getRowClass" />
                            </ext:GridView>
                        </View>
                        <%-- SelectionModel은 checkbox, cell, row가 존재하고 그리드를 클릭시 그리드의 선택된 행의값이 json형태로 넘어감 (EP20S01참고)--%>
                        <SelectionModel>
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
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
