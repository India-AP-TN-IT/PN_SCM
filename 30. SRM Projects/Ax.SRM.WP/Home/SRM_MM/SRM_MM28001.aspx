<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM28001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM28001" %>
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
	    .x-grid-cell-MPNO DIV,	 
	    .x-grid-cell-PARTNM DIV,
	    .x-grid-cell-SCM_VENDNM1 DIV,
	    .x-grid-cell-SCM_VENDNM2 DIV
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
//                MPNO: '',
//                MPNM: '',
//                VENDNM1: '',
//                VENDNM2: '',
//                VENDCD: App.cdx01_VENDCD_OBJECTID.getValue(),
//                ISNEW: true
            //            }, 'ModelGrid');
            var r = Ext.create('ModelGrid', {
                CHR_CHK: false,
                MPNO: '',
                MPNM: '',
                VENDNM1: '',
                VENDNM2: '',
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
    <form id="SRM_MM28001" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM28001" runat="server" Cls="search_area_title_name" /><%--Text="SUB 자재 마스터 등록" />--%>
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
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="260" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:Label ID="lbl01_ROWCNT"            runat="server" /><%--Text="(적용건수 : " />--%>
                                        <ext:Label ID="lbl01_ROWCNT_EXCEL"      runat="server" /><%--Text="대상건수" />--%>
                                        <ext:TextField ID="txt01_ROWCNT_EXCEL"  runat="server" Width="50" Cls="inputText_Num" ReadOnly="true" />
                                        <ext:Label ID="lbl01_ROWCNT_ADDED"      runat="server" /><%--Text="처리건수"/>--%>
                                        <ext:TextField ID="txt01_ROWCNT_ADDED"  runat="server" Width="50" Cls="inputText_Num" ReadOnly="true" />
                                        <ext:Label ID="lbl01_ROWCNT_E"          runat="server" /><%--Text=" )" />--%>
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
                                    <ext:Model ID="GridModel1" runat="server" Name ="ModelGrid">
                                        <Fields>
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>

                                            <%--실제 디비에서 가져와서 사용함.--%>                                                                                   
                                            <ext:ModelField Name="CORCD" />
                                            <ext:ModelField Name="BIZCD" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="MPNO" />
                                            <ext:ModelField Name="MPNM" />
                                            <ext:ModelField Name="VENDNM1" />
                                            <ext:ModelField Name="VENDNM2" />
                                            <ext:ModelField Name="INSERT_DATE" Type="Date"/>
                                            <ext:ModelField Name="INSERT_ID" />
                                            <ext:ModelField Name="UPDATE_DATE" Type="Date"/>
                                            <ext:ModelField Name="UPDATE_ID" />

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
<%--                                    <RenderTpl ID="RenderTpl1" runat="server">
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
                                <%-- 일반 text editor--%>
                                <ext:Column ID="MPNO" ItemID="MPNO" DataIndex="MPNO" runat="server" Width="120" Align="Left"><%--Text="Sub Part No" --%>
                                    <Editor>
                                        <ext:TextField ID="txt02_MPNO" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                <ext:Column ID="MPNM" ItemID="PARTNM" DataIndex="MPNM" runat="server" MinWidth="160" Align="Left" Flex="1"><%--Text="PART NAME" --%>
                                    <Editor>
                                        <ext:TextField ID="txt02_MPNM" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>                                
                                <ext:Column ID="VENDNM1" ItemID="SCM_VENDNM1" DataIndex="VENDNM1" runat="server" Width="140" Align="Left" ><%--Text="자재공급업체명1" --%>
                                    <Editor>
                                        <ext:TextField ID="txt02_VENDNM1" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                <ext:Column ID="VENDNM2" ItemID="SCM_VENDNM2" DataIndex="VENDNM2" runat="server" Width="140" Align="Left" ><%--Text="자재공급업체명1" --%>
                                    <Editor>
                                        <ext:TextField ID="txt02_VENDNM2" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                <ext:DateColumn ID="INSERT_DATE" ItemID="INSERT_DATE" Format="yyyy-MM-dd HH:mm:ss" runat="server" DataIndex="INSERT_DATE" Width="130" Align="Center"/><%--Text="최초등록일시"    --%>  
                                <ext:Column ID="INSERT_ID" ItemID="INSERT_ID" runat="server" DataIndex="INSERT_ID" Width="80" Align="Center"/><%--Text="최초등록자"    --%>  
                                <ext:DateColumn ID="UPDATE_DATE" ItemID="FNLUPDATEDTTM" Format="yyyy-MM-dd HH:mm:ss" runat="server" DataIndex="UPDATE_DATE" Width="130" Align="Center"/><%--Text="최종수정일시"    --%>  
                                <ext:Column ID="UPDATE_ID" ItemID="FNLUPDATEID" runat="server" DataIndex="UPDATE_ID" Width="80" Align="Center"/><%--Text="최종수정자"    --%>  
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
                        <%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
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
