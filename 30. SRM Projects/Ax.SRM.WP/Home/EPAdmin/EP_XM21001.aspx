<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM21001.aspx.cs" Inherits="Ax.EP.WP.Home.EP_XM.EP_XM21001" %>
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
	    .x-grid-cell-CODE DIV,	 
	    .x-grid-cell-DESCRIPTION DIV,
	    .x-grid-cell-CODENAME DIV,
	    .x-grid-cell-DIVISION DIV,
	    .x-grid-cell-LANGUAGE DIV,
	    .x-grid-cell-SYSTEMCODE DIV,
	    .x-grid-cell-MESSAGE DIV,
	    .x-grid-cell-TITLE DIV,
	    .x-grid-cell-TARGET_CODENAME DIV,
	    .x-grid-cell-TARGET_MESSAGE DIV,
	    .x-grid-cell-TARGET_TITLE DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    } 
	    .x-panel-default-outer-border-trbl {
        /*border-color: #c0c0c0!important;
        border-width: 1px!important;
        border-left: 1px solid #c0c0c0 !important;
        border-right: 1px solid #c0c0c0 !important;
        border-bottom: 1px solid #c0c0c0 !important;
        border-top: 1px solid #c0c0c0 !important;
        */
        border: 0 !important;
        }
        .grid_area  {border-left:1px solid #c0c0c0; border-right:1px solid #c0c0c0; border-bottom:1px solid #c0c0c0;}
	    .x-panel-body { padding:0 !important;}
	    .bottom_area_btn { text-align:right;height:27px !important;float:right;background:none; /* width:100%;position:absolutefloat:right;*/}
	    .tab_grid { border:1px solid #c0c0c0; padding:10px !important}	    
	    /*
	    .tab_grid { border:1px solid #c0c0c0; padding:10px !important}	    
	    */
        
        
        /* 탭 */
        
        .x-tab-bar-default  {  background:#fff; padding-top:3px;}
        .x-tab-bar-strip-default {border-width: 0;border-style: solid;border-color:#0056b6;background-color: #0056b6;height:1px  !important;}                        
        .x-tab-bar .x-tab-bar-body .x-box-inner .x-tab{z-index:500;}
        .x-tab-bar-body-default {padding-bottom: 0px !important;padding-top: 0px !important;}
        .x-tab.x-tab-active.x-tab-default .x-tab-inner-default{color:Black;}
        
        .x-tab-default .x-tab-inner {color: #a1a1a1; font-weight:normal !important; line-height:13px !important; }

        .x-tab-wrap {text-align:center; }
        .x-tab-active .x-tab-default .x-tab-inner-default{font-weight:bold !important;}
        
        .x-tab-bar .x-tab-bar-body .x-box-inner .x-tab {height: 27px !important;}
         a.x-tab {text-decoration: none;}
        .x-tab-default-top-active, .x-tab-default-left-active, .x-tab-default-right-active {border-bottom: 0 solid #0056b6 !important;}
        .x-tab-active{border-bottom: 0 solid #0056b6 !important;}
        .x-tab-active {background:url(../../images/common/tab_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;} /*4.X x-tab-default-active =>x-tab-active */
        /*.x-tab-default-active .x-tab-inner { color:#231f20; font-weight:bold !important;}*/
        .x-tab-active .x-tab-inner{ color:#231f20; font-weight:bold !important;}               
        
        
        .x-tab-inner-center { color:#000;}
        .x-tab-default-top, .x-tab-default-left, .x-tab-default-right {border-bottom: 0 solid #157fcc;}
        .x-tab-default {border-color: #838383 !important;margin: 0 0 0 3px;cursor: pointer;}
        .x-tab-default-top {-moz-border-radius-topleft: 3px;
                            -webkit-border-top-left-radius: 3px;                            
                            -moz-border-radius-topright: 3px;
                            -webkit-border-top-right-radius: 3px;                            
                            -moz-border-radius-bottomright: 0;
                            -webkit-border-bottom-right-radius: 0;                            
                            -moz-border-radius-bottomleft: 0;
                            -webkit-border-bottom-left-radius: 0;                            
                            padding: 7px 12px 7px 12px !important;
                            border-width: 0;
                            border-style: solid;
                            background-color:#f3f3f3;                                                        
                            border-bottom:1px solid silver !important;                            
                            border-left:1px solid #b1b1b1 !important;
                            border-right:1px solid #b1b1b1 !important;
                            border-top:1px solid #b1b1b1 !important;                            
                            }
        .x-tab-default:hover{background-color:#e3e3e3 !important}
        
    </style>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Tab1.setHeight(App.TabPanel1.getHeight());
            App.GridPanel.setHeight(App.Tab1.getHeight() - 50); //50 = 행추가취소버튼높이 27 + 위아래패딩값 20 + 기타3(뭔지모르겠음)    
            App.GridPanel2.setHeight(App.Tab1.getHeight() - 50);
            App.GridPanel3.setHeight(App.Tab1.getHeight() - 50);
            App.GridPanel4.setHeight(App.Tab1.getHeight() - 50);      
            App.Grid01.setHeight(App.GridPanel.getHeight());
            App.Grid02.setHeight(App.GridPanel.getHeight());
            App.Grid03.setHeight(App.GridPanel.getHeight());
            App.Grid04.setHeight(App.GridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        function ExtraParamAdd() {
            if (App.TabPanel1.activeTab.id == "Tab1") {
                return App.Grid01.getRowsValues({ dirtyRowsOnly: true });
            }
            else if (App.TabPanel1.activeTab.id == "Tab2") {
                return App.Grid02.getRowsValues({ dirtyRowsOnly: true });
            }
            else if (App.TabPanel1.activeTab.id == "Tab3") {
                return App.Grid03.getRowsValues({ dirtyRowsOnly: true });
            }
            else if (App.TabPanel1.activeTab.id == "Tab4") {
                return App.Grid04.getRowsValues({ dirtyRowsOnly: true });
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드 신규행 추가/취소
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var addNewRow = function (grid) {
            grid.editingPlugin.cancelEdit();
            
            if (grid.id == "Grid01") {
                var r = Ext.create('ModelGrid', {
                    NO: 1,
                    CODE: '',
                    LANGUAGE: App.cbo01_LANG.getValue(),
                    CODENAME: '',
                    TYPENM2: '',
                    DESCRIPTION: '',
                    ISNEW: true
                });
            }
            else if (grid.id == "Grid02") {
                var r = Ext.create('ModelGrid2', {
                    NO: 1,
                    SYSTEMCODE: App.cbo01_SYSTEMCODE.getValue(),
                    LANGUAGE: App.cbo01_LANG.getValue(),
                    CODE: '',
                    MESSAGE: '',
                    TITLE: '',
                    ISNEW: true
                });
            }

            grid.store.insert(0, r);
            grid.getSelectionModel().select(0, 2);
        };

        var removeRow = function (grid, checkColumn) {
            var sm = grid.getSelectionModel();

            if (!sm.getSelection()[0].data[checkColumn]) return;

            Ext.Msg.confirm('Confirm', 'Do you want to cancel selected row? ', function (btn, text) {
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

        // 그리드의 cell에 포커스가 갈 경우에 자동으로 editor가 실행이 되도록 한다. 
        // 원인: 그리드 내의 콤보박스는 editor을 포함하지 않아 eiditorTab 이벤트가 실행이되지 않음. 따라서 콤보박스에서 tab을 눌렀을 경우에 
        // editor가 포함된 cell에 포커스가 가면 editor가 실행이 되고 이후에 tab을 클릭하면 editor가 포함된 cell로 자동으로 이동이 된다.
        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            var grid = selectionModel.view.ownerCt;

            grid.editingPlugin.startEdit(rowIndex, colIndex);
        }

    </script>
</head>
<body>
    <form id="EP_XM21001" runat="server">
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
                    <ext:Label ID="lbl01_EP_XM21001" runat="server" Cls="search_area_title_name" /><%--Text="다국어관리" />--%>
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
                            <col style="width: 150px;" />
                            <col style="width: 150px;" />
                            <col style="width: 150px;" />
                            <col style="width: 150px;" />
                            <col style="width: 200px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
							<th>
                                <ext:Label ID="lbl01_LANG" runat="server" /><%--Text="언어" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_LANG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPECD2" ValueField="TYPECD" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store11" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model11" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="TYPECD" />
                                                        <ext:ModelField Name="TYPECD2" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_LANG_Change" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td>   
                            <th>
                                <ext:Label ID="lbl01_CODE" runat="server" /><%--Text="코드" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_CODE" Width="120" Cls="inputText" runat="server" />
                            </td>   
                            <th>
                                <ext:Label ID="lbl01_CODENAME" runat="server" /><%--Text="코드명" />--%>
                            </th>
                            <td>                               
                                <ext:TextField ID="txt01_CODENAME" Width="180" Cls="inputText" runat="server" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_SYSTEMCODE" runat="server" /><%--Text="시스템" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SYSTEMCODE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="SYSTENAME" ValueField="SYSTEMCODE" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store10" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model10" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="SYSTEMCODE" />
                                                        <ext:ModelField Name="SYSTENAME" />
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

            <ext:Panel ID="Panel1" Region="Center" Border="false" runat="server" Layout="fit">
                <Items>
                    <ext:TabPanel
                        Region="Center"
                        ID="TabPanel1" 
                        runat="server" 
                        ActiveTabIndex="0" 
                        Width="600" 
                        Height="30" 
                        Border="true"
                        Plain="true"
                        >                       
                        <Items>
                            <ext:Panel 
                                ID="Tab1" 
                                ItemID="XM20101_TAB_1"
                                runat="server"
                                BodyPadding="0" 
                                AutoScroll="true"     
                                Closable="false"     
                                cls="tab_grid"                           
                                ><%--Title="다국어정보(코드)" --%>
                                <Items>                                    
                                    <%--그리드와 내용사이에 하단 버튼영역이 필요할경우 아래 패널 사용(Hidden = "false") --%>
                                    <ext:Panel ID="BottomButtonPanel" runat="server" Region="North" Height="27" cls="bottom_area_btn" Hidden="false">                                        
                                        <Items>                                            
                                            <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                                            <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5 gridbtn" ID="btnRowAdd">
                                                <Listeners>
                                                    <Click Handler = "addNewRow(App.Grid01)" />
                                                </Listeners>
                                            </ext:ImageButton>
                                            <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_cancelrow.gif" ID="btnRowDelete" Cls="gridbtn">
                                                <Listeners>
                                                    <Click Handler = "removeRow(App.Grid01,'ISNEW')" />
                                                </Listeners>
                                            </ext:ImageButton>
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area" >
                                        <Items>                                          
                                            <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                                <Store>
                                                    <ext:Store ID="Store1" runat="server" PageSize="50">
                                                        <Model>
                                                            <ext:Model ID="GridModel1" runat="server" Name="ModelGrid">
                                                                <Fields>
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="LANGUAGE"/>
                                                                    <ext:ModelField Name="CODENAME"/>
                                                                    <ext:ModelField Name="TYPENM2"/>
                                                                    <ext:ModelField Name="DESCRIPTION"/>
                                                                    <%--DELETE ROW가 존재시--%>
                                                                    <ext:ModelField Name="ISNEW" Type="Boolean" />
                                                                    <%--임의로 생성--%>
                                                                    <ext:ModelField Name="NO" /> 
                                                                    <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>
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
                                                        <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center"  >
                                                            <Renderer Fn="rendererNo"></Renderer>
                                                        </ext:Column>                                                        
                                                        <%--선택체크박스--%>
                                                        <ext:CheckColumn runat="server" ID ="CHECK" itemID="CHK" DataIndex="CHECK_VALUE" Width="35" 
                                                            StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true"/>  
                                                        <ext:Column ID="LANGUAGE" ItemID="LANGUAGE" runat="server"  DataIndex="LANGUAGE"   Width="140" Align="Left" >                                                            
                                                            <Renderer Fn="gridComboRenderer" />
                                                            <Editor> 
                                                               <ext:ComboBox ID="cbo02_LANG1" runat="server"  DisplayField="TYPECD2" ValueField="TYPECD" QueryMode="Local" AllowBlank = "false" Editable="false">                         
                                                                   <Store>
                                                                       <ext:Store ID="Store15" runat="server">
                                                                           <Model>
                                                                               <ext:Model ID="Model15" runat="server" IDPropery="TYPECD">
                                                                                   <Fields>                                                                                    
                                                                                       <ext:ModelField Name="TYPECD" />
                                                                                       <ext:ModelField Name="TYPECD2" />
                                                                                   </Fields>
                                                                               </ext:Model>
                                                                           </Model>
                                                                       </ext:Store>
                                                                   </Store>                                            
                                                                </ext:ComboBox>
                                                            </Editor>
                                                        </ext:Column> <%--Text="언어"    --%>
                                                        <ext:Column ID="CODE" ItemID="CODE" runat="server"  DataIndex="CODE"   Width="140" Align="Left" >
                                                            <Editor>
                                                                <ext:TextField ID="txt02_CODE1" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                            </Editor>
                                                        </ext:Column><%--Text="코드"    --%>
                                                        <ext:Column ID="CODENAME" ItemID="CODENAME" runat="server"  DataIndex="CODENAME"   Width="350" Align="Left" >
                                                            <Editor>
                                                                <ext:TextField ID="txt02_CODENAME1" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                            </Editor>
                                                        </ext:Column> <%--Text="코드명"    --%>
                                                        <ext:Column ID="DIVISION" ItemID="DIVISION" runat="server" DataIndex="TYPENM2" MinWidth="100" Align="Left">
                                                            <Editor>
                                                                <ext:TextField ID="txt02_DIVISION1" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                            </Editor>
                                                        </ext:Column><%--Text="구분"    --%>
                                                        <ext:Column ID="DESCRIPTION" ItemID="DESCRIPTION" runat="server" DataIndex="DESCRIPTION" MinWidth="300" Align="Left">
                                                            <Editor>
                                                                <ext:TextField ID="txt02_DESCRIPTION1" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                            </Editor>
                                                        </ext:Column> <%--Text="DESCRIPTION"--%>                                                                                
                                                    </Columns>
                                                </ColumnModel>
                                                <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                                                    <LoadMask ShowMask="true" />
                                                </Loader>
                                                <View>
                                                    <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                                                </View>
                                                <SelectionModel>                            
                                                    <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single"/>
                                                </SelectionModel>    
                                                <BottomBar>
                                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                                    <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                                </BottomBar>
                                            </ext:GridPanel>                                            
                                        </Items>
                                    </ext:Panel>
                                </Items>   
                            </ext:Panel>
                            <ext:Panel 
                                ID="Tab2" 
                                ItemID="XM20101_TAB_2"
                                runat="server" 
                                BodyPadding="0" 
                                AutoScroll="true"     
                                Closable="false" 
                                cls="tab_grid"   
                                ><%--Title="다국어정보(메시지)" --%>                              
                                <Items>
                                    <ext:Panel ID="BottomButtonPanel2" runat="server" Region="North" Height="27" cls="bottom_area_btn" Hidden="false">
                                        <Items>
                                            <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                                            <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5 gridbtn" ID="btnRowAdd2">
                                                <Listeners>
                                                    <Click Handler = "addNewRow(App.Grid02)" />
                                                </Listeners>
                                            </ext:ImageButton>
                                            <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_cancelrow.gif" ID="btnRowDelete2" Cls="gridbtn">
                                                <Listeners>
                                                    <Click Handler = "removeRow(App.Grid02,'ISNEW')" />
                                                </Listeners>
                                            </ext:ImageButton>
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="GridPanel2" Region="Center" Border="True" runat="server" Cls="grid_area" >
                                        <Items>
                                            <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                                <Store>
                                                    <ext:Store ID="Store2" runat="server" PageSize="50">
                                                        <Model>
                                                            <ext:Model ID="GridModel2" runat="server" Name="ModelGrid2">
                                                                <Fields>
                                                                    <ext:ModelField Name="SYSTEMCODE" />
                                                                    <ext:ModelField Name="LANGUAGE"/>
                                                                    <ext:ModelField Name="CODE"/>
                                                                    <ext:ModelField Name="MESSAGE"/>
                                                                    <ext:ModelField Name="TITLE"/>
                                                                    <%--DELETE ROW가 존재시--%>
                                                                    <ext:ModelField Name="ISNEW" Type="Boolean" />
                                                                    <%--임의로 생성--%>
                                                                    <ext:ModelField Name="NO" /> 
                                                                    <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>
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
                                                        <ext:Column ID ="D_NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center"  >
                                                            <Renderer Fn="rendererNo"></Renderer>
                                                        </ext:Column>
                                                        <%--선택체크박스--%>
                                                        <ext:CheckColumn runat="server" ID ="D_CHECK" itemID="CHK" DataIndex="CHECK_VALUE" Width="35" 
                                                            StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true"/>
                                                        <ext:Column ID="D_SYSTEMCODE" ItemID="SYSTEMCODE" runat="server" DataIndex="SYSTEMCODE" Width="80" Align="Left" >
                                                            <Renderer Fn="gridComboRenderer" />
                                                            <Editor>
                                                                <ext:SelectBox ID="cbo02_SYSTEMCODE2" runat="server"  Mode="Local" ForceSelection="true" DisplayField="SYSTENAME" ValueField="SYSTEMCODE" TriggerAction="All" Width="115">
                                                                    <Store>
                                                                        <ext:Store ID="Store6" runat="server" >
                                                                            <Model>
                                                                                <ext:Model ID="Model6" runat="server">
                                                                                    <Fields>
                                                                                        <ext:ModelField Name="SYSTEMCODE" />
                                                                                        <ext:ModelField Name="SYSTENAME" />
                                                                                    </Fields>
                                                                                </ext:Model>
                                                                            </Model>
                                                                        </ext:Store>
                                                                    </Store>
                                                                </ext:SelectBox>
                                                            </Editor>
                                                        </ext:Column> <%--Text="System"  --%>
                                                        <ext:Column ID="D_LANGUAGE" ItemID="LANGUAGE" runat="server"  DataIndex="LANGUAGE" Width="140" Align="Left" >                                                            
                                                            <Renderer Fn="gridComboRenderer" />
                                                            <Editor> 
                                                               <ext:ComboBox ID="cbo02_LANG2" runat="server" DisplayField="TYPECD2" ValueField="TYPECD" QueryMode="Local" AllowBlank = "false" Editable="false">                         
                                                                   <Store>
                                                                       <ext:Store ID="Store5" runat="server">
                                                                           <Model>
                                                                               <ext:Model ID="Model5" runat="server" IDPropery="TYPECD">
                                                                                   <Fields>                                                                                    
                                                                                       <ext:ModelField Name="TYPECD" />
                                                                                       <ext:ModelField Name="TYPECD2" />
                                                                                   </Fields>
                                                                               </ext:Model>
                                                                           </Model>
                                                                       </ext:Store>
                                                                   </Store>                                            
                                                                </ext:ComboBox>
                                                            </Editor>
                                                        </ext:Column> <%--Text="언어"    --%>
                                                        <ext:Column ID="D_CODE" ItemID="CODE" runat="server"  DataIndex="CODE" Width="140" Align="Left" >
                                                            <Editor>
                                                                <ext:TextField ID="txt02_CODE2" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                            </Editor>
                                                        </ext:Column><%--Text="코드"    --%>
                                                        <ext:Column ID="D_MESSAGE" ItemID="MESSAGE" runat="server"  DataIndex="MESSAGE" Width="350" Align="Left" >
                                                            <Editor>
                                                                <ext:TextField ID="txt02_MESSAGE2" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                            </Editor>
                                                        </ext:Column> <%--Text="메시지"    --%>      
                                                        <ext:Column ID="D_TITLE" ItemID="TITLE" runat="server"  DataIndex="TITLE" Width="140" Align="Left" >
                                                            <Editor>
                                                                <ext:TextField ID="txt02_TITLE2" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                            </Editor>
                                                        </ext:Column><%--Text="코드"    --%>                         
                                                    </Columns>
                                                </ColumnModel>
                                                <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                                    <LoadMask ShowMask="true" />
                                                </Loader>
                                                <View>
                                                    <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true"/>
                                                </View>
                                                <SelectionModel>                            
                                                    <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"/>
                                                </SelectionModel>    
                                                <BottomBar>
                                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                                    <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                                </BottomBar>
                                            </ext:GridPanel>
                                        </Items>
                                    </ext:Panel>
                                </Items>
                            </ext:Panel>
                            <ext:Panel 
                                ID="Tab3" 
                                itemID = "XM20101_TAB_3"
                                runat="server" 
                                BodyPadding="0" 
                                AutoScroll="true"     
                                Closable="false" 
                                Cls="tab_grid"
                                ><%--Title="다국어매핑(코드)" --%>
                                <Items>
                                    <ext:Panel ID="BottomButtonPanel3" runat="server" Region="North" Height="27" cls="bottom_area_btn" Hidden="false">
                                        <Items>    
                                            <ext:Panel ID="Panel3" runat="server" Cls="grid_select">
                                                <Content>
                                                    <table>
                                                        <tr>
                                                            <th style="width:100px;" ><ext:Label ID="lbl02_TARGET_LANGSET" runat="server" Cls="grid_area_coment" /><%--Text="저장대상언어" --%></th>
                                                            <td>
                                                                <ext:SelectBox ID="cbo02_LANG3" runat="server"  Mode="Local" ForceSelection="true"
                                                                    DisplayField="TYPECD2" ValueField="TYPECD" TriggerAction="All" Width="115">
                                                                    <Store>
                                                                        <ext:Store ID="Store13" runat="server" >
                                                                            <Model>
                                                                                <ext:Model ID="Model13" runat="server">
                                                                                    <Fields>
                                                                                        <ext:ModelField Name="TYPECD" />
                                                                                        <ext:ModelField Name="TYPECD2" />
                                                                                    </Fields>
                                                                                </ext:Model>
                                                                            </Model>
                                                                        </ext:Store>
                                                                    </Store>
                                                                    <DirectEvents>
                                                                        <Select OnEvent="cbo02_LANG3_Change" />
                                                                    </DirectEvents>
                                                                </ext:SelectBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Content>                                        
                                            </ext:Panel>                                        
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="GridPanel3" Region="Center" Border="True" runat="server" Cls="grid_area" >
                                        <Items>
                                            <ext:GridPanel ID="Grid03" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                                <Store>
                                                    <ext:Store ID="Store3" runat="server" PageSize="50">
                                                        <Model>
                                                            <ext:Model ID="GridModel3" runat="server" Name="ModelGrid3">
                                                                <Fields>
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="SOURCE_CODENAME"/>
                                                                    <ext:ModelField Name="TARGET_CODENAME"/>
                                                                    <ext:ModelField Name="TYPE"/>
                                                                    <ext:ModelField Name="DESCRIPTION"/>
                                                                    <%--임의로 생성--%>
                                                                    <ext:ModelField Name="NO" /> 
                                                                    <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                        <Listeners>
                                                            <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                                            <Load Delay="1" Handler="GridStoreReady(App.GridStatus3, this.getTotalCount());  "></Load>
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
                                                        <ext:Column ID ="S_NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center"  >
                                                            <Renderer Fn="rendererNo"></Renderer>
                                                        </ext:Column>
                                                        <%--선택체크박스--%>
                                                        <ext:CheckColumn runat="server" ID ="S_CHECK" itemID="CHK" DataIndex="CHECK_VALUE" Width="35" 
                                                            StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true"/>                                                        
                                                        <ext:Column ID="S_CODE" ItemID="CD" runat="server"  DataIndex="CODE" Width="140" Align="Left" /><%--Text="코드"    --%>
                                                        <ext:Column ID="S_SOURCE_CODENAME" ItemID="SOURCE_CODENAME" runat="server" DataIndex="SOURCE_CODENAME" Width="350" Align="Left" /><%--Text="원본 코드명"    --%>
                                                        <ext:Column ID="S_TARGET_CODENAME" ItemID="TARGET_CODENAME" runat="server" DataIndex="TARGET_CODENAME" Width="350" Align="Left" >
                                                            <Editor>
                                                                <ext:TextField ID="txt02_TARGET_CODENAME3" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                            </Editor>
                                                        </ext:Column> <%--Text="대상코드명"    --%>   
                                                    </Columns>
                                                </ColumnModel>
                                                <Loader ID="Loader3" runat="server" AutoLoad="false" Mode="Data">
                                                    <LoadMask ShowMask="true" />
                                                </Loader>
                                                <View>
                                                    <ext:GridView ID="GridView3" runat="server" EnableTextSelection="true"/>
                                                </View>
                                                <SelectionModel>                            
                                                    <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" Mode="Single"/>
                                                </SelectionModel>    
                                                <BottomBar>
                                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                                    <ext:StatusBar ID="GridStatus3" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                                </BottomBar>
                                            </ext:GridPanel>
                                        </Items>
                                    </ext:Panel>
                                </Items>
                            </ext:Panel>                            
                            <ext:Panel 
                                ID="Tab4" 
                                itemID = "XM20101_TAB_4"
                                runat="server" 
                                BodyPadding="0" 
                                AutoScroll="true"     
                                Closable="false" 
                                Cls="tab_grid"
                                ><%--Title="다국어매핑(메시지)" --%>   
                                <Items>
                                    <ext:Panel ID="BottomButtonPanel4" runat="server" Region="North" Height="27" cls="bottom_area_btn" Hidden="false">
                                        <Items>    
                                            <ext:Panel ID="Panel4" runat="server" Cls="grid_select">
                                                <Content>
                                                    <table>
                                                        <tr>
                                                            <th style="width:100px;" ><ext:Label ID="lbl03_TARGET_LANGSET" runat="server" Cls="grid_area_coment" /><%--Text="저장대상언어" --%></th>
                                                            <td>
                                                                <ext:SelectBox ID="cbo02_LANG4" runat="server"  Mode="Local" ForceSelection="true"
                                                                    DisplayField="TYPECD2" ValueField="TYPECD" TriggerAction="All" Width="115">
                                                                    <Store>
                                                                        <ext:Store ID="Store14" runat="server" >
                                                                            <Model>
                                                                                <ext:Model ID="Model14" runat="server">
                                                                                    <Fields>
                                                                                        <ext:ModelField Name="TYPECD" />
                                                                                        <ext:ModelField Name="TYPECD2" />
                                                                                    </Fields>
                                                                                </ext:Model>
                                                                            </Model>
                                                                        </ext:Store>
                                                                    </Store>
                                                                    <DirectEvents>
                                                                        <Select OnEvent="cbo02_LANG4_Change" />
                                                                    </DirectEvents>
                                                                </ext:SelectBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Content>                                        
                                            </ext:Panel>                                       
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="GridPanel4" Region="Center" Border="True" runat="server" Cls="grid_area" >
                                        <Items>
                                            <ext:GridPanel ID="Grid04" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                                <Store>
                                                    <ext:Store ID="Store4" runat="server" PageSize="50">
                                                        <Model>
                                                            <ext:Model ID="GridModel4" runat="server" Name="ModelGrid4">
                                                                <Fields>
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="SOURCE_MESSAGE"/>
                                                                    <ext:ModelField Name="SOURCE_TITLE"/>
                                                                    <ext:ModelField Name="TARGET_MESSAGE"/>
                                                                    <ext:ModelField Name="TARGET_TITLE"/>
                                                                    <ext:ModelField Name="SYSTEMCODE"/>
                                                                    <%--임의로 생성--%>
                                                                    <ext:ModelField Name="NO" /> 
                                                                    <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                        <Listeners>
                                                            <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                                            <Load Delay="1" Handler="GridStoreReady(App.GridStatus4, this.getTotalCount());  "></Load>
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
                                                        <ext:Column ID ="T_NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center"  >
                                                            <Renderer Fn="rendererNo"></Renderer>
                                                        </ext:Column>
                                                        <%--선택체크박스--%>
                                                        <ext:CheckColumn runat="server" ID ="T_CHECK" itemID="CHK" DataIndex="CHECK_VALUE" Width="35" 
                                                            StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true"/>                                                        
                                                        <ext:Column ID="T_CODE" ItemID="CD" runat="server"  DataIndex="CODE" Width="140" Align="Left" /><%--Text="코드"--%>
                                                        <ext:Column ID="T_SOURCE_MESSAGE" ItemID="SOURCE_MESSAGE" runat="server" DataIndex="SOURCE_MESSAGE" Width="350" Align="Left" /><%--Text="원본 메시지"--%>
                                                        <ext:Column ID="T_SOURCE_TITLE" ItemID="SOURCE_TITLE" runat="server"  DataIndex="SOURCE_TITLE" Width="140" Align="Left" /><%--Text="TITLE"--%>
                                                        <ext:Column ID="T_TARGET_MESSAGE" ItemID="TARGET_MESSAGE" runat="server" DataIndex="TARGET_MESSAGE" Width="350" Align="Left" >
                                                            <Editor>
                                                                <ext:TextField ID="txt02_TARGET_MESSAGE4" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                            </Editor>
                                                        </ext:Column> <%--Text="대상 메시지"--%>     
                                                        <ext:Column ID="T_TARGET_TITLE" ItemID="TARGET_TITLE" runat="server"  DataIndex="TARGET_TITLE" Width="140" Align="Left">
                                                            <Editor>
                                                                <ext:TextField ID="txt02_TARGET_TITLE4" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                            </Editor>
                                                        </ext:Column><%--Text="TITLE"--%>                
                                                    </Columns>
                                                </ColumnModel>
                                                <Loader ID="Loader4" runat="server" AutoLoad="false" Mode="Data">
                                                    <LoadMask ShowMask="true" />
                                                </Loader>
                                                <View>
                                                    <ext:GridView ID="GridView4" runat="server" EnableTextSelection="true"/>
                                                </View>
                                                <SelectionModel>                            
                                                    <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" Mode="Single"/>
                                                </SelectionModel>    
                                                <BottomBar>
                                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                                    <ext:StatusBar ID="GridStatus4" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                                </BottomBar>
                                            </ext:GridPanel>
                                        </Items>
                                    </ext:Panel>
                                </Items>
                            </ext:Panel>
                        </Items>
                    </ext:TabPanel>    
                </Items>
            </ext:Panel>                          
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
