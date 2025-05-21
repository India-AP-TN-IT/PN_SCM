<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM20410.aspx.cs" Inherits="Ax.EP.WP.Home.EPAdmin.EP_XM20410" %>
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
    <style type="text/css">
	    .x-grid-cell-PARAM_NM DIV,	    
	    .x-grid-cell-LANG_CODE DIV,	    	    
	    .x-grid-cell-PARAM_TYPE DIV,	    
	    .x-grid-cell-COMM_CODE DIV,	    
	    .x-grid-cell-INI_DEFAULT DIV,	    
	    
	    .x-grid-cell-SORT_SEQ DIV
	        	    
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }
	    /* 4.X에 text height 변경 */
	    #txt01_QUERY-inputEl,#txt02_QUERY-inputEl,#txt01_QUERY-triggerWrap, #txt02_QUERY-triggerWrap 
	    {	        
	        height:230px !important;
	    }		    
	    #txt01_QUERY-inputWrap, #txt02_QUERY-inputWrap
	    {	        
	        height:220px !important;
	    }		    	    
	    .x-form-item-body
	    {
	        vertical-align:top;
	    }
    </style>    
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());            
            App.Grid02.setHeight(App.ParamPanel.getHeight() - App.ButtonPanel04.getHeight() -18);
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
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

        // 그리드를 editor한 후에 발생되는 이벤트
        var AfterEdit = function (rowEditor, e) {
        
            if (e.column.dataIndex == "PARAM_NM") {
                e.grid.getStore().getAt(e.rowIdx).set("LANG_CODE", e.grid.store.getAt(e.rowIdx).data['PARAM_NM']);                
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드 신규행 추가
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var addNewRow = function (grid) {
            grid.editingPlugin.cancelEdit();
            var sort = 0;

            for (i = 0; i < grid.store.getCount(); i++) {                
                if (grid.store.getAt(i).data['SORT_SEQ'] > sort) {
                    sort = grid.store.getAt(i).data['SORT_SEQ'];
                }
            }

            // Create a record instance through the ModelManager
//            var r = Ext.ModelManager.create({
//                PARAM_NM: '',
//                LANG_CODE: '',
//                IS_VALIDATION: false,
//                PARAM_TYPE: '',
//                COMM_CODE: '',
//                DEFAULT_DATA: '',
//                SORT_SEQ: sort + 1,
//                ISNEW: true
            //            }, 'ModelGrid');
            var r = Ext.create('ModelGrid', {
                PARAM_NM: '',
                LANG_CODE: '',
                IS_VALIDATION: false,
                PARAM_TYPE: '',
                COMM_CODE: '',
                DEFAULT_DATA: '',
                SORT_SEQ: sort + 1,
                ISNEW: true
            });

            grid.store.insert(0, r);
            grid.getSelectionModel().select(0, 2);
        };

        var removeRow = function (grid, checkColumn) {
            var sm = grid.getSelectionModel();
            
            //if (!sm.getSelection()[0].data[checkColumn]) return;

            grid.editingPlugin.cancelEdit();
            grid.store.remove(sm.getSelection());
            if (grid.store.getCount() > 0) {
                sm.select(0);
            }
        };

        //COPY
        var fn_copy = function () {
            App.txt01_DOC_NO.setValue('');
        };

    </script>
</head>
<body>
    <form id="EP_XM20410" runat="server">
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
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="35">
                <Items>
                    <ext:Label ID="lbl01_EP_XM20410" runat="server" Cls="search_area_title_name" Text="테스트" />
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" Height="35">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 250px;" />
                            <col style="width: 150px;" />
                            <col style="width: 250px;" />
                            <col style="width: 150px;" />
                            <col />                        
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th >
                                <ext:Label ID="lbl01_SUBJECT" runat="server" Text="제목" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_TITLE" Cls="inputText" runat="server" Width="240" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_SEARCH_GROUPID" runat="server" Text="조회프로그램 그룹ID" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_GROUPID" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store6" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model5" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="ID" />
                                                        <ext:ModelField Name="NAME" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                 </ext:SelectBox>                                 
                            </td>
                            <th>
                                <ext:Label ID="Label2" runat="server" Text="Category" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_CATEGORY" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store5" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="ID" />
                                                        <ext:ModelField Name="NAME" />
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
            <ext:Panel ID="GridPanel" Region="North" Border="True" runat="server" Cls="grid_area" Height="250">
                <Items>
                    <ext:GridPanel ID="Grid01"  runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="DOC_NO"/>
                                            <ext:ModelField Name="GROUPID"/>
                                            <ext:ModelField Name="GROUPNM"/>
                                            <ext:ModelField Name="TITLE"/>
                                            <ext:ModelField Name="INSERT_ID"/>
                                            <ext:ModelField Name="INSERT_DATE"/>
                                            <ext:ModelField Name="UPDATE_ID"/>
                                            <ext:ModelField Name="UPDATE_DATE"/>
                                            <ext:ModelField Name="CORCD"/>
                                            <ext:ModelField Name="GROUPID"/>  
                                            <ext:ModelField Name="APPLY_LANGUAGE"/>                                            
                                            <ext:ModelField Name="CATEGORY"/>        
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
                            <ext:BufferedRenderer ID="BufferedRenderer1" runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:Column ID="DOC_NO" ItemID="DOCCD" runat="server" DataIndex="DOC_NO" Width="70" Align="Center" Text="문서번호"/>                                 
                                <ext:Column ID="GROUPID" ItemID="GROUPID" runat="server" DataIndex="GROUPID" Width="100" Align="Left" Text="GROUP ID"/> 
                                <ext:Column ID="GROUPNM" ItemID="GROUPNM" runat="server" DataIndex="GROUPNM" Width="150" Align="Left" Text="GROUP NAME"/> 
                                <ext:Column ID="TITLE" ItemID="SUBJECT" runat="server" DataIndex="TITLE" Width="300" Align="Left" Flex="1" Text="제목"/> 
                                <ext:Column ID="APPLY_LANGUAGE" ItemID="APPLY_LANGUAGE" runat="server" DataIndex="APPLY_LANGUAGE" Width="100" Align="Center" Text="다국어적용여부"/> 
                                <ext:Column ID="CATEGORY" ItemID="CATEGORY" runat="server" DataIndex="CATEGORY" Width="100" Align="Center" Text="CATEGORY"/> 

                                <ext:Column ID="INSERT_ID" ItemID="INSERT_ID" runat="server" DataIndex="INSERT_ID" Width="100" Align="Center" Text="최초등록자"/> 
                                <ext:Column ID="INSERT_DATE" ItemID="INSERT_DATE" runat="server" DataIndex="INSERT_DATE" Width="150" Align="Center" Text="최초등록일시"/> 
                                <ext:Column ID="UPDATE_ID" ItemID="UPDATE_ID" runat="server" DataIndex="UPDATE_ID" Width="100" Align="Center" Text="최종등록자"/> 
                                <ext:Column ID="UPDATE_DATE" ItemID="UPDATE_DATE" runat="server" DataIndex="UPDATE_DATE" Width="150" Align="Center" Text="최종등록일시"/>                               
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
                        <DirectEvents>                         
                            <Select OnEvent="RowSelect">
                                <ExtraParams>
                                    <ext:Parameter Name="Values" Value="this.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                </ExtraParams>
                            </Select>
                        </DirectEvents>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="Panel4"  runat="server" Region="North" Height="10"></ext:Panel>
            <%--ContentPanel 의 Width, StyleSpec 내용은 Region 이 South 일 경우 필요 없음--%>
            <ext:Panel ID="Panel3" runat="server" Region="West" Width="880" Border="False" StyleSpec="border-top:0px solid #b1b1b1;border-bottom:0px solid #b1b1b1 !important;">
            <Items>
                <ext:Panel ID="Panel1" runat="server" StyleSpec="margin-right:10px; float:left;" Width="150" Height="23" Hidden="false">
                    <Items>
                        <ext:Label ID="lbl01_XM20410_GRP_1" runat="server" Cls="bottom_area_title_name2" Width="150px" Text="쿼리 영역" /> 
                    </Items>
                </ext:Panel>
                <ext:Panel ID="ContentPanel" Cls="bottom_area_table" runat="server" Region="Center">
                    <Content>
                        <table id="tableContent" style="height:0px;">
                            <colgroup>
                                <col style="width: 100px;" />
                                <col style="width: 150px;" />
                                <col style="width: 100px;" />
                                <col style="width: 150px;" />
                                <col style="width: 100px;" />
                                <col style="width: 150px;" />
                                <col/>
                            </colgroup>
                            <tr>
                                <th >
                                    <ext:Label ID="lbl02_SUBJECT" runat="server" Text="제목" />
                                </th>
                                <td colspan="3">
                                    <ext:TextField ID="txt02_TITLE" Cls="inputText" runat="server" Width="400px" EnforceMaxLength="false" />                                       
                                </td>   
                                <th>
                                    <ext:Label ID="Label5" runat="server" Text="Category" />
                                </th>
                                <td colspan="2">                                    
<%--                                    <ext:SelectBox ID="cbo02_CATEGORY" runat="server"  Mode="Local" ForceSelection="true"
                                        DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="150"  >
                                        <Store>
                                            <ext:Store ID="Store7" runat="server" >
                                                <Model>
                                                    <ext:Model ID="Model6" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="ID" />
                                                            <ext:ModelField Name="NAME" />
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                            </ext:Store>
                                        </Store>
                                     </ext:SelectBox>--%>
                                    <ext:ComboBox ID="cbo02_CATEGORY" runat="server" 
                                                  DisplayField="NAME" ValueField="ID" QueryMode="Local" AllowBlank = "false" Editable="true" TriggerAction="All">                         
                                        <Store>
                                            <ext:Store ID="Store15" runat="server" AutoLoad="true">
                                                <Model>
                                                    <ext:Model ID="Model15" runat="server" IDPropery="ID">
                                                        <Fields>                                                                                    
                                                            <ext:ModelField Name="NAME" />
                                                            <ext:ModelField Name="ID" />
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                            </ext:Store>                                                                      
                                        </Store>
                                    </ext:ComboBox>                                                                      
                                </td>                                                         
                            </tr>  
                            <tr>
                                <th>
                                    <ext:Label ID="Label1" runat="server" Text="Script" />
                                </th>
                                <td>    
                                    <ext:Checkbox ID="chk02_APPLY_LANGUAGE" runat="server" Cls="inputText" Checked="true" />
                                </td>                            
                                <th>
                                    <ext:Label ID="Label3" runat="server" Text="Doc No." />
                                </th>
                                <td> 
                                    <ext:TextField ID="txt01_DOC_NO" Cls="inputText" runat="server" Width="140px" EnforceMaxLength="false" ReadOnly="true" />                                    
                                </td>  
                                <th>
                                    <ext:Label ID="lbl02_SEARCH_GROUPID" runat="server" Text="조회프로그램 그룹ID" />
                                </th>
                                <td>
                                    <ext:SelectBox ID="cbo01_S_GROUPID" runat="server"  Mode="Local" ForceSelection="true"
                                        DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="150">
                                        <Store>
                                            <ext:Store ID="Store3" runat="server" >
                                                <Model>
                                                    <ext:Model ID="Model2" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="ID" />
                                                            <ext:ModelField Name="NAME" />
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                            </ext:Store>
                                        </Store>
                                     </ext:SelectBox>                                 
                                </td>  
                                <td>
                                    <ext:Button ID="btn01_COPY" runat="server" TextAlign="Center" Text="COPY">
                                        <Listeners>
                                            <Click Fn="fn_copy" />
                                        </Listeners>
                                    </ext:Button>                                      
                                </td>                                                     
                            </tr>  
                            <tr Height="235">
                                <td colspan="7">
                                    <ext:TextArea  ID="txt01_QUERY"  runat="server" Width="878" Cls="inputText" Height="230"  />
                                </td>
                            </tr>
                            <tr>
                                <th >
                                    <ext:Label ID="lbl01_LINK_COLUMN" runat="server" Text="Link Column" />
                                </th>
                                <td colspan="5">
                                    <ext:TextField ID="txt01_LINK_COLUMN" Cls="inputText" runat="server" Width="600px" EnforceMaxLength="false" />                                       
                                </td> 
                                <td >
                                    <ext:Label ID="Label4" runat="server" Text="(ex. A,B)" />
                                </td>                                                           
                            </tr>  
                            <tr Height="265">
                                <td colspan="7">
                                    <ext:TextArea  ID="txt02_QUERY"  runat="server" Width="878" Cls="inputText" Height="230"  />
                                </td>
                            </tr>
                                                                                                                              
                        </table>
                    </Content>
                </ext:Panel>
            </Items>
            </ext:Panel>

            <ext:Panel ID="Panel2"  runat="server" Region="West" Width="10"></ext:Panel>

            <ext:Panel ID="ParamPanel"  runat="server" Region="Center" StyleSpec="border-top:0px solid #b1b1b1;">
                <Items>
                <ext:Panel ID="ButtonPanel04" runat="server" Region="North" Height="23" Hidden="false" >
                    <Items> 
                        <ext:Panel ID="Panel13" runat="server" StyleSpec="margin-right:10px; float:left;" Width="150" Hidden="false">
                            <Items>
                                <ext:Label ID="lbl01_XM20410_GRP_2" runat="server" Cls="bottom_area_title_name2" Width="150px" Text="파라메터 영역" /> 
                            </Items>
                        </ext:Panel>

                        <ext:Panel ID="Panel14" runat="server" Width="300" Hidden="false" Cls="bottom_area_btn" >
                            <Items>
                                <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                                <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5" ID="btnRowAdd">
                                    <Listeners>
                                        <Click Handler = "addNewRow(App.Grid02)" />
                                    </Listeners>
                                </ext:ImageButton>
                                <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_cancelrow.gif" ID="btnRowDelete">
                                    <Listeners>
                                        <Click Handler = "removeRow(App.Grid02,'ISNEW')" />
                                    </Listeners>
                                </ext:ImageButton>                                            
                            </Items>
                        </ext:Panel>      
                    </Items>
                </ext:Panel>
                <ext:Panel ID="GridPanel2" Cls="grid_area" runat="server" Region="Center" Border="True">
                    <Items>
                        <ext:GridPanel ID="Grid02"  runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                            <Store>
                                <ext:Store ID="Store2" runat="server" PageSize="50">
                                    <Model>
                                        <ext:Model ID="Model1" runat="server" Name ="ModelGrid">
                                            <Fields>
                                                <%--임의로 생성--%>
                                                <ext:ModelField Name="NO" /> 
                                                <ext:ModelField Name="PARAM_NM"/>
                                                <ext:ModelField Name="LANG_CODE"/>
                                                <ext:ModelField Name="PARAM_TYPE"/>
                                                <ext:ModelField Name="COMM_CODE"/>
                                                <ext:ModelField Name="DEFAULT_DATA"/>
                                                <ext:ModelField Name="SORT_SEQ"/>                                                                                          
                                                <ext:ModelField Name="CORCD"/> 
                                                <ext:ModelField Name="DOC_NO"/> 
                                                <ext:ModelField Name="IS_VALIDATION" DefaultValue="false" Type="Boolean" />
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
                                <%-- buffred view를 사용하기 위한 plugin. --%>
                                <ext:BufferedRenderer ID="BufferedRenderer3" runat="server" />
                                <%-- 2.X버전부터는 그리드에서 edtior를 활성화 시키기위해서 cellEditing Plugin을 추가 하여 사용하고 자바스크립트에서 grid.editingPlugin 형태로 사용할수 있다. --%>
                                <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                    <Listeners>                                    
                                        <%--<BeforeEdit fn="BeforeEdit" />--%>
                                        <Edit fn ="AfterEdit" />                                    
                                    </Listeners> 
                                </ext:CellEditing>
                            </Plugins>  
                        
                            <ColumnModel ID="ColumnModel2" runat="server">
                                <Columns>
                                    <ext:Column ID ="Column1" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                        <Renderer Fn="rendererNo"></Renderer>
                                    </ext:Column>
                                    <ext:Column ID="PARAM_NM" runat="server" ItemID="PARAM_NM"  Text="파라메터" DataIndex="PARAM_NM" Width="150" Align="Left" Flex="1" >
                                        <Editor>
                                            <ext:TextField ID="TextField_PARAM_NM" ItemID="TextField_PARAM_NM" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22"  >                                             
                                            </ext:TextField>                                        
                                        </Editor>
                                    </ext:Column>   
                                    <ext:Column ID="LANG_CODE" runat="server" ItemID="LANG_CODE"  Text="다국어코드" DataIndex="LANG_CODE" Width="120" Align="Left"  >
                                        <Editor>
                                            <ext:TextField ID="TextField_LANG_CODE" ItemID="TextField_LANG_CODE" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22"  >                                             
                                            </ext:TextField>                                        
                                        </Editor>
                                    </ext:Column>   
                                    <ext:CheckColumn runat="server" ID ="IS_VALIDATION" Text="필수여부"  DataIndex="IS_VALIDATION" Width="80" ItemID="IS_VALIDATION"
                                                     StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >                                        
                                    </ext:CheckColumn>
                                    <ext:Column ID="PARAM_TYPE" ItemID="PARAM_TYPE" runat="server" DataIndex="PARAM_TYPE" Width="130" Align="Center" Text="Type">                                     
                                        <Renderer Fn="gridComboRenderer" />
                                        <Editor>
                                            <ext:SelectBox ID="cbo01_PARAM_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                                DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                                <Store>
                                                    <ext:Store ID="Store4" runat="server" >
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
                                             </ext:SelectBox>
                                        </Editor>
                                    </ext:Column>
                                    <ext:Column ID="COMM_CODE" runat="server" ItemID="COMM_CODE"  Text="공통코드" DataIndex="COMM_CODE" Width="100" Align="Center"  >
                                        <Editor>
                                            <ext:TextField ID="TextField_COMM_CODE" ItemID="TextField_COMM_CODE" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22"  >                                             
                                            </ext:TextField>                                        
                                        </Editor>
                                    </ext:Column>   
                                    <ext:Column ID="DEFAULT_DATA" runat="server" ItemID="INI_DEFAULT"  Text="기본값" DataIndex="DEFAULT_DATA" Width="80" Align="Center"  >
                                        <Editor>
                                            <ext:TextField ID="TextField_DEFAULT_DATA" ItemID="TextField_DEFAULT_DATA" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22"  >                                             
                                            </ext:TextField>                                        
                                        </Editor>
                                    </ext:Column>   
                                    <ext:Column ID="SORT_SEQ" runat="server" ItemID="SORT_SEQ"  Text="정렬순서" DataIndex="SORT_SEQ" Width="70" Align="Center"  >
                                        <Editor>
                                            <ext:TextField ID="TextField_SORT_SEQ" ItemID="TextField_SORT_SEQ" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22"  >                                             
                                            </ext:TextField>                                        
                                        </Editor>
                                    </ext:Column>   
                                                                   
                                </Columns>
                            </ColumnModel>
                            <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                <LoadMask ShowMask="true" />
                            </Loader>
                            <View>
                                <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true"/>
                            </View>
                            <SelectionModel>
                            <%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
                                <ext:CellSelectionModel  ID="CellSelectionModel1" runat="server">
                                    <Listeners><Select Fn="CellFocus"></Select></Listeners>
                                </ext:CellSelectionModel >
                            </SelectionModel>                            
                            <BottomBar>
                                <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus2 이름도 같이 변경해주세요 --%>
                                <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                            </BottomBar>
                        </ext:GridPanel>
                    </Items>
                </ext:Panel>
            </Items>
        </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
