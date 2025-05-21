<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_SD23002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_SD.SRM_SD23002" %>
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
	    .x-grid-cell-ALCCD DIV,	    
	    .x-grid-cell-CUST_ITEMCD DIV,	    
	    .x-grid-cell-BEG_DATE DIV,
	    .x-grid-cell-END_DATE DIV,
	    .x-grid-cell-USAGE DIV
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

        //다이렉트 메서드 호출 방법
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
                    //return;
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

            // 코드명만 다르게 처리(코드 + NAME) 
            if (App.CodeColName.getValue() == "CUST_ITEMCD") textName = "CUST_ITEMNM";
            

            // 코드처리는 동일 (코드 및 name이 같이 들어가는 경우에만 사용
            if (App.CodeColName.getValue() == "CUST_ITEMCD" )
                codeName = App.CodeColName.getValue();

            //set은 속도가 느림 & 모서리에 빨간 삼각형 표시됨.
            grid.getStore().getAt(rowIdx).set(textName, typeNM);
            grid.getStore().getAt(rowIdx).set(codeName, objectID);           
            grid.getStore().getAt(rowIdx).set("WORK_DIR_DIV", record["WORK_DIR_DIV"]);
            grid.getStore().getAt(rowIdx).set("WORK_DIR_DIVNM", record["WORK_DIR_DIVNM"]);
            grid.getStore().getAt(rowIdx).set("VINCD", record["VINCD"]);
            grid.getStore().getAt(rowIdx).set("VINNM", record["VINNM"]);
            grid.getStore().getAt(rowIdx).set("CUSTCD", record["CUSTCD"]);
            grid.getStore().getAt(rowIdx).set("CUSTNM", record["CUSTNM"]);

//            grid.getStore().getAt(rowIdx).data["WORK_DIR_DIV"] = record["WORK_DIR_DIV"];
//            grid.getStore().getAt(rowIdx).data["WORK_DIR_DIVNM"] = record["WORK_DIR_DIVNM"];
//            grid.getStore().getAt(rowIdx).data["VINCD"] = record["VINCD"];
//            grid.getStore().getAt(rowIdx).data["VINNM"] = record["VINNM"];
//            grid.getStore().getAt(rowIdx).data["CUSTCD"] = record["CUSTCD"];
//            grid.getStore().getAt(rowIdx).data["CUSTNM"] = record["CUSTNM"];

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
                var colIndex = currentCellObject.colIdx;
                var rowIndex = currentCellObject.rowIdx
                var field = currentCellObject.field;
                var codeValue = editor.getValue();
                var nameValue = grd.getStore().getAt(rowIndex).data.CUST_ITEMNM

                fn_PopupHandler(grd, rowIndex, colIndex, field, codeValue);

            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드에서 버튼을 클릭했을때 팝업을 띄어주는 메서드
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var PopupHandler_button = function (editor, command, row, rowIndex, colIndex) {
            //var grd = editor.grid;
            var grd = editor.ownerCt.grid;
            var field = grd.columns[colIndex - 1].id;
            var codeValue = grd.getStore().getAt(rowIndex).data.CUST_ITEMCD;
            var nameValue = grd.getStore().getAt(rowIndex).data.CUST_ITEMNM;
            fn_PopupHandler(grd, rowIndex, colIndex - 1, field, codeValue, nameValue);
            
        }

        function fn_PopupHandler(grd, rowIndex, colIndex, field, selectedCodeValue, selectedNameValue) {

            App.CodeRow.setValue(rowIndex);
            App.CodeCol.setValue(colIndex ); // 버튼의 이전행이 무조껀 코드가 되어야한다.
            App.CodeColName.setValue(grd.columns[colIndex].id);
          

            //코드 + Name일경우 (NAME에 특정값 지정하여 입력)
            if (App.CodeColName.getValue() == "CUST_ITEMCD") {

                App.CodeValue.setValue(selectedCodeValue);
                App.NameValue.setValue(selectedNameValue);
            }

            PopUpFire();
        }

        var PopUpFire = function () {
            if (App.CodeColName.getValue() == "CUST_ITEMCD") App.btn01_CUST_ITEMCD.fireEvent('click');
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

                //고객사 품목 코드 값 편집시, 고객사품목명을 초기화한다.
                //(고객사품목코드 팝업에서 선택한 값으로 다시 대체되기 전에 초기화시켜줌.)
                if (e.column.dataIndex == "CUST_ITEMCD") {
                    e.grid.getStore().getAt(e.rowIdx).set("CUST_ITEMNM", "");                   
                    e.grid.getStore().getAt(e.rowIdx).set("WORK_DIR_DIV", "");
                    e.grid.getStore().getAt(e.rowIdx).set("WORK_DIR_DIVNM", "");
                    e.grid.getStore().getAt(e.rowIdx).set("VINCD", "");
                    e.grid.getStore().getAt(e.rowIdx).set("VINNM", "");
                    e.grid.getStore().getAt(e.rowIdx).set("CUSTCD", "");
                    e.grid.getStore().getAt(e.rowIdx).set("CUSTNM", "");
                }
                e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", false);
                e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", e.grid.getStore().getAt(e.rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.


            } else {
                e.grid.getStore().getAt(e.rowIdx).dirty = e.grid.getStore().getAt(e.rowIdx).data["CHECK_VALUE"];
            }
        }


    </script>
</head>
<body>
    <form id="SRM_SD23002" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_CUST_ITEMCD" runat="server" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn"  OnDirectClick="etc_Button_Click" Hidden="true"/>
    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="TextField_UpdateId" runat="server" Hidden="true"></ext:TextField>  <%--신규행을 추가시에 수정자를 이용하기 위해서 추가--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="CodeCol" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col index (사용하지 않으나 차후 필요할지 몰라서)--%>
    <ext:TextField ID="CodeColName" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col Name--%>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_SD23002" runat="server" Cls="search_area_title_name" /><%--Text="ALC 마스터 등록" />--%>
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
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>   
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" /><%--Text="Business Code" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
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
                        </tr>  
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_PARTNO" runat="server" /><%--Text="PART-NO" />--%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="CompositeField3" runat="server" Width="260" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:TextField ID="txt01_PARTNO1" Width="120" Cls="inputText" runat="server" />
                                         <ext:DisplayField ID="DisplayField1" Width="20"  Flex="1" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:TextField ID="txt01_PARTNO2" Width="120" Cls="inputText" runat="server" />
                                    </Items>
                                </ext:FieldContainer>                                
                            </td>  
                            <th>         
                                <ext:Label ID="lbl01_VIN_PNO" runat="server" />                      
                            </th>
                            <td colspan="3">
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60" />
                            </td> 
                        </tr>                      
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ExcelUploadPanel" Region="North" Cls="excel_upload_area_table" runat="server" Height="34">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 410px;"/>
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
                                        <ext:FileUploadField ID="fud02_FILEID1" runat="server" Cls="inputText" ButtonText="Browser" Width="400">
                                        </ext:FileUploadField>                                        
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
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="300" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:Label ID="lbl01_ROWCNT"            runat="server" /><%--Text="(적용건수 : " />--%>
                                        <ext:Label ID="lbl01_ROWCNT_EXCEL"      runat="server" /><%--Text="대상건수" />--%>
                                        <ext:TextField ID="txt01_ROWCNT_EXCEL"  runat="server" Width="50" Cls="inputText_Num" ReadOnly="true" />
                                        <ext:Label ID="lbl01_ROWCNT_ADDED"      runat="server" StyleSpec="padding-left:10px;"/><%--Text="처리건수" --%>
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
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="CUST_ITEMCD" />
                                            <ext:ModelField Name="CUST_ITEMNM" />
                                            <ext:ModelField Name="WORK_DIR_DIV" />
                                            <ext:ModelField Name="WORK_DIR_DIVNM" />
                                            <ext:ModelField Name="BEG_DATE" />
                                            <ext:ModelField Name="END_DATE"/>
                                            <ext:ModelField Name="USAGE" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="CORCD_O" />
                                            <ext:ModelField Name="BIZCD_O" />
                                            <ext:ModelField Name="ALCCD_O" />
                                            <ext:ModelField Name="PARTNO_O" />
                                            <ext:ModelField Name="CUST_ITEMCD_O" />
                                            <ext:ModelField Name="WORK_DIR_DIV_O" />
                                            <ext:ModelField Name="BEG_DATE_O" />
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
                                </ext:CheckColumn>    
                                <%-- 편집 안되는 컬럼일 때--%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" DataIndex="PARTNO" runat="server" Width="110" Align="Left" /><%--Text="PART-NO" --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" DataIndex="PARTNM" runat="server" Align="Left" Flex="1" MinWidth="160"/><%--Text="PART-NAME" --%>
                                
                                <%-- 일반 text editor--%>
                                <ext:Column ID="ALCCD" ItemID="ALCCD" DataIndex="ALCCD" runat="server" Width="60" Align="Center"><%--Text="ALC 코드" --%>
                                    <Editor>
                                        <ext:TextField ID="TextField1" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>

                                <%-- 고객사 품목 codebox--%>
                                <ext:Column ID="CUST_ITEMCD" ItemID="CUST_ITEMCD" DataIndex="CUST_ITEMCD" runat="server" Width="105" Align="Center"><%--Text="고객사품목코드" --%>
                                    <Editor>
                                        <ext:TextField ID="TextField_CUST_ITEMCD" ItemID="TextField_CUST_ITEMCD" Cls="inputText" FieldCls="inputText" runat="server" Height ="22">
                                            <Listeners>
                                                <SpecialKey Fn="PopupHandler"></SpecialKey>
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
                                <%--편집 안되는 컬럼--%>                                          
                                <ext:Column ID="CUST_ITEMNM" ItemID="CUST_ITEMNM" DataIndex="CUST_ITEMNM" runat="server" Width="150" Align="Left"  Visible="true" /><%--Text="고객사품목명" --%>

                                <%--편집 안되는 컬럼--%>                                
                                <ext:Column ID="WORK_DIR_DIV" ItemID="WORK_DIR_DIV2" DataIndex="WORK_DIR_DIV" runat="server" Width="70" Align="Center"  Visible="true" /><%--Text="작업지시" --%>


                                <%-- 날짜 컬럼 : editor는 DateField로써 date picker임--%>
                                <%-- 날짜는 포멧지정하지 말것. 다국어 처리를 위해 프레임웍단에서 처리함.--%>
                                <ext:DateColumn ID="BEG_DATE" ItemID="BEG_DATE" DataIndex="BEG_DATE" Width="90" Align="Center" runat="server" ><%--Text="시작일자" --%>         
                                    <Editor> 
                                        <ext:DateField ID="DateField1" runat="server"  SelectOnFocus="true"  > 
                                        </ext:DateField>
                                    </Editor>                                                                
                                </ext:DateColumn>   

                                <%-- 날짜 컬럼 : editor는 DateField로써 date picker임--%>
                                <%-- 날짜는 포멧지정하지 말것. 다국어 처리를 위해 프레임웍단에서 처리함.--%>
                                <ext:DateColumn ID="END_DATE" ItemID="END_DATE" DataIndex="END_DATE" Width="90" Align="Center"  runat="server" ><%--Text="종료일자" --%>
                                    <Editor> 
                                        <ext:DateField ID="DateField2" runat="server"  SelectOnFocus="true"  > 
                                        </ext:DateField>
                                    </Editor>                                                                
                                </ext:DateColumn>   


                                <%-- 숫자를 위한 컬럼: editor에서 format을 주더라도 그리드 바인딩시점에서 NumberColumn에 format을 주지 않는 다면 format이 적용되지 않음. 따라서 컬럼과 editor 모두 format지정해야함--%>                                
                                <ext:NumberColumn ID="USAGE" ItemID="USAGE" DataIndex="USAGE" Width="65" Align="Right" Format="#,###" runat="server" ><%--Text="USAGE" --%>
                                    <Editor>
                                        <ext:NumberField ID="NumberField1" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" AllowBlank="false" />
                                    </Editor>
                                </ext:NumberColumn>

                                <%-- 편집 안되는 컬럼일 때--%>
                                <ext:Column ID="VINNM" ItemID="VIN" DataIndex="VINNM" runat="server" Width="55" Align="Center"  Visible="true" /><%--Text="차종" --%>
                                <ext:Column ID="CUSTNM" ItemID="CUSTNM" DataIndex="CUSTNM" runat="server" Width="160" Align="Left"  Visible="true" /><%--Text="고객사" --%>
                                

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
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
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
                    <%--엑셀업로드용 그리드--%>
                    <ext:GridPanel ID="Grid02" runat="server" Visible="false" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="Model2" runat="server">
                                        <Fields>                                       
                                            <ext:ModelField Name="CORCD" />
                                            <ext:ModelField Name="BIZCD" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="CUST_ITEMCD" />
                                            <ext:ModelField Name="WORK_DIR_DIV" />
                                            <ext:ModelField Name="BEG_DATE"/>
                                            <ext:ModelField Name="END_DATE"/>
                                            <ext:ModelField Name="USAGE" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="ALCCD_O" />
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
                            <ext:BufferedRenderer ID="BufferedRenderer2"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel2" runat="server">
                            <Columns>                                
                                <ext:Column ID="E_CORCD"         ItemID="E_CORCD"        runat="server" Text="사업부코드(편집X)"  DataIndex="CORCD"        Width="90"   Align="Center "/>
                                <ext:Column ID="E_BIZCD"         ItemID="E_BIZCD"        runat="server" Text="사업장코드(편집X)"  DataIndex="BIZCD"        Width="150"  Align="Center "/>
                                <ext:Column ID="E_VENDCD"        ItemID="E_VENDCD"       runat="server" Text="업체코드(편집X)"    DataIndex="VENDCD"       Width="150"  Align="Left" />
                                <ext:Column ID="E_PARTNO"        ItemID="E_PARTNO"       runat="server" Text="PART-NO(편집X)"     DataIndex="PARTNO"        Width="120"  Align="Left" />
                                <ext:Column ID="E_ALCCD"         ItemID="E_ALCCD"        runat="server" Text="ALC코드"            DataIndex="ALCCD"        Width="120"  Align="Left" />
                                <ext:Column ID="E_CUST_ITEMCD"   ItemID="E_CUST_ITEMCD"  runat="server" Text="고객사품목코드"     DataIndex="CUST_ITEMCD"  Width="120"  Align="Left" />
                                <ext:Column ID="E_WORK_DIR_DIV"  ItemID="E_WORK_DIR_DIV" runat="server" Text="작업지시코드"       DataIndex="WORK_DIR_DIV" Width="120"  Align="Left" />
                                <ext:DateColumn ID="E_BEG_DATE"      ItemID="E_BEG_DATE"     runat="server" Text="적용시작일"         DataIndex="BEG_DATE"     Width="120"  Align="Left" />
                                <ext:DateColumn ID="E_END_DATE"      ItemID="E_END_DATE"     runat="server" Text="적용종료일"         DataIndex="END_DATE"     Width="120"  Align="Left" />
                                <ext:Column ID="E_USAGE"         ItemID="E_USAGE"        runat="server" Text="USAGE"              DataIndex="USAGE"        Width="120"  Align="Left" />
                                <ext:Column ID="E_VINCD"         ItemID="E_VINCD"        runat="server" Text="차종코드"           DataIndex="VINCD"        Width="120"  Align="Left" />
                                <ext:Column ID="E_CUSTCD"        ItemID="E_CUSTCD"       runat="server" Text="고객사코드"         DataIndex="CUSTCD"       Width="120"  Align="Left" />
                                <ext:Column ID="E_ALCCD_O"       ItemID="E_ALCCD_O"      runat="server" Text="이전ALC코드(편집X)" DataIndex="ALCCD_O"      Width="120"  Align="Left" />
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
                            <ext:StatusBar ID="StatusBar1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>

            <%--그리드와 내용사이에 하단 버튼영역이 필요할경우 아래 패널 사용(Hidden = "false") --%>
            <ext:Panel ID="BottomButtonPanel" runat="server" Region="North" Height="23" Cls="bottom_area_btn" Hidden="true">
                <Items>
                    <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5" ID="btnRowAdd">
                        <%--<Listeners>
                            <Click Handler = "addNewRow(App.Grid01)" />
                        </Listeners>--%>
                    </ext:ImageButton>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_deleterow.gif" ID="btnRowDelete">
                       <%-- <Listeners>
                            <Click Handler = "removeRow(App.Grid01,'ISNEW')" />
                        </Listeners>--%>
                    </ext:ImageButton>
                </Items>
            </ext:Panel>

        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
