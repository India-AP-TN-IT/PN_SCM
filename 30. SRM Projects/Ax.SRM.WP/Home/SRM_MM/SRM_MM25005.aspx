<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM25005.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM25005" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" >
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
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
	    .x-grid-cell-DELI_QTY DIV,
	    .x-grid-cell-DELI_QTY1 DIV,
	    .x-grid-cell-DELI_QTY2 DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }	    
    </style>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        var AfterEdit = function (rowEditor, e) {
            var grid = App.Grid01;
            var matInputQty = grid.getStore().getAt(e.rowIdx).data["MAT_INPUT_QTY"] == null ? 0 :  Number(grid.getStore().getAt(e.rowIdx).data["MAT_INPUT_QTY"]);
            var qty1 = grid.getStore().getAt(e.rowIdx).data["VAN_DELI_QTY1"] == null ? 0 : Number(grid.getStore().getAt(e.rowIdx).data["VAN_DELI_QTY1"]);
            var qty2 = grid.getStore().getAt(e.rowIdx).data["VAN_DELI_QTY2"] == null ? 0 : Number(grid.getStore().getAt(e.rowIdx).data["VAN_DELI_QTY2"]);
            var qty3 = grid.getStore().getAt(e.rowIdx).data["VAN_DELI_QTY3"] == null ? 0 : Number(grid.getStore().getAt(e.rowIdx).data["VAN_DELI_QTY3"]);

            if (matInputQty < qty1 + qty2 + qty3) {
                App.direct.MsgCodeAlert_ShowFormat("SCMMM-0001", "txt02_DELI_QTY1", [e.rowIdx + 1]);
            }
        }

        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
//            var grid = selectionModel.view.ownerCt;
//            grid.editingPlugin.startEdit(rowIndex, colIndex);
        }

        var setButtonStatus = function (id) {
            var btnRegist = Ext.getCmp("ButtonRegist");
            var btnModify = Ext.getCmp("ButtonModify");
            var btnDelete = Ext.getCmp("ButtonDelete");
            if (id == "ButtonRegist") {
                btnRegist.setImageUrl("/images/btn/btn_new.gif");
                btnModify.setImageUrl("/images/btn/btn_modify_h.gif");
                btnDelete.setImageUrl("/images/btn/btn_delete_h.gif");
                btnDelete.disabled = true;
                App.hidMODE.setValue("Regist");
            }
            if (id == "ButtonModify") {
                btnRegist.setImageUrl("/images/btn/btn_new_h.gif");
                btnModify.setImageUrl("/images/btn/btn_modify.gif");
                btnDelete.disabled = false;
                btnDelete.setImageUrl("/images/btn/btn_delete.gif");
                
                App.hidMODE.setValue("Modify");
            }
        }
    </script>
</head>
<body>
    <form id="SRM_MM25005" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="hidMODE" runat="server" Hidden="true" Text="Regist" /> <%--등록 또는 수정 모드 기록용--%>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MM25005" runat="server" Cls="search_area_title_name" /><%--Text="서열납품관리(직서열)" />--%>
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
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60" OnAfterValidation="cdx01_VENDCD_AfterValidation"/>
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
                            <th class="ess">
                                <ext:Label ID="lbl01_DELIVERYDATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_INPUT_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                            </td>                      
                        </tr>
                        <tr>
                            <th class="ess">         
                                <ext:Label ID="lbl01_LINECD" runat="server" /><%--Text="라인코드" />--%>                       
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_LINECD" runat="server" HelperID="HELP_LINE_SEQ" PopupMode="Search" PopupType="HelpWindow" 
                                    OnBeforeDirectButtonClick="cdx01_LINECD_BeforeDirectButtonClick" WidthTYPECD="60"/>    
                            </td>
                            <th class="ess">         
                                <ext:Label ID="lbl01_CONTCD" runat="server" /><%--Text="물류용기코드" />   --%>                    
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CONTCD" runat="server" HelperID="HELP_CONTCD_SEQ" PopupMode="Search" PopupType="HelpWindow"
                                 OnBeforeDirectButtonClick="cdx01_CONTCD_BeforeDirectButtonClick" WidthTYPECD="60"/>

                                <%--
                                <ext:SelectBox ID="SelectBox01_CONTCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPECD" ValueField="OBJECT_ID" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="TYPENM" />
                                                        <ext:ModelField Name="TYPECD" />
                                                        <ext:ModelField Name="SORT_SEQ" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                                --%>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_INSTALL_POS" runat="server" /><%--Text="위치" /> --%>                      
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_INSTALL_POS" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPECD" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="TYPECD" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>
                        </tr>
                        <tr>
                            <th class="ess">         
                                <ext:Label ID="lbl01_DELI_CNT" runat="server" /><%--Text="납품차수" />  --%>                     
                            </th>
                            <td colspan="5">
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="420" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:TextField ID="txt01_CHASU1" Width="50" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/" />
                                        <ext:DisplayField ID="DisplayField2" Width="30" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:TextField ID="txt01_CHASU2" Width="50" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/" />
                                        <ext:Label ID="lbl01_CHA" Width="30" runat="server" />  
                                        <ext:Label ID="lbl01_MM_MSG002" Width="200" runat="server" />                                   
                                    </Items>
                                </ext:FieldContainer>     
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="TimeRegistPanel" Region="North" Cls="excel_upload_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_TIME_REGIST" runat="server" /><%--도착예정시간 등록--%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer2" runat="server" Width="330" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:DisplayField ID="DisplayField1" Width="60" runat="server" FieldStyle="text-align:right;padding:3px;" Text="1st " />
                                        <ext:TextField ID="txt01_FIRST" Width="50" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/" MaxLengthText="4" MaxLength="4" EnforceMaxLength="true"/>
                                        <ext:DisplayField ID="DisplayField3" Width="60" runat="server" FieldStyle="text-align:right;padding:3px;" Text="2nd " />
                                        <ext:TextField ID="txt01_SECOND" Width="50" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/" MaxLengthText="4" MaxLength="4" EnforceMaxLength="true"/>
                                        <ext:DisplayField ID="DisplayField4" Width="60" runat="server" FieldStyle="text-align:right;padding:3px;" Text="3rd " />
                                        <ext:TextField ID="txt01_THIRD" Width="50" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/" MaxLengthText="4" MaxLength="4" EnforceMaxLength="true"/>
                                    </Items>
                                </ext:FieldContainer> 
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>                    
                    <ext:GridPanel ID="Grid01" runat="server" TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50" >
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="LINENM" />
                                            <ext:ModelField Name="JIS_CNT" />                                            
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="MAT_INPUT_QTY" />
                                            <ext:ModelField Name="VAN_DELI_QTY1" />                                            
                                            <ext:ModelField Name="VAN_ARRIV_TIME1" />
                                            <ext:ModelField Name="ERM_ARRIV_TIME1" />
                                            <ext:ModelField Name="VAN_DELI_QTY2" />                                            
                                            <ext:ModelField Name="VAN_ARRIV_TIME2" />
                                            <ext:ModelField Name="ERM_ARRIV_TIME2" />
                                            <ext:ModelField Name="VAN_DELI_QTY3" />                                            
                                            <ext:ModelField Name="VAN_ARRIV_TIME3" />
                                            <ext:ModelField Name="ERM_ARRIV_TIME3" />
                                            <ext:ModelField Name="CORCD" />                                         
                                            <ext:ModelField Name="BIZCD" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="INPUT_DATE" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="LINECD" />
                                            <ext:ModelField Name="CONTCD" />
                                            <ext:ModelField Name="INSTALL_POS" />
                                            <ext:ModelField Name="GUBUN" />
                                            <ext:ModelField Name="PUTIN_SEQ" />
                                            <ext:ModelField Name="DN_DIV" />
                                            <ext:ModelField Name="MAT_TYPE" />
                                            <ext:ModelField Name="OLD_QTY1" />
                                            <ext:ModelField Name="OLD_QTY2" />
                                            <ext:ModelField Name="OLD_QTY3" />
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
                            <%--<ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>--%>
                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                <Listeners>                                    
                                    <BeforeEdit fn="BeforeEdit" />
                                    <Edit fn ="AfterEdit" />
                                </Listeners>
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" Locked="true" >
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:Column ID="LINENM" ItemID="DEL_STAGE" runat="server" DataIndex="LINENM" Width="140" Align="Left" Locked="true" /><%--Text="납품장소"      --%>
                                <ext:Column ID="JIS_CNT" ItemID="DELI_CNT" runat="server" DataIndex="JIS_CNT"  Width="60" Align="Center" Locked="true" /><%--Text="납품차수"  --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" Locked="true" /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME" --%>
                                <ext:NumberColumn ID="MAT_INPUT_QTY" ItemID="QUOT_QTY" runat="server" DataIndex="MAT_INPUT_QTY" Width="80" Align="Right" Format="#,##0.###"/><%--Text="발주수량"  --%>                              
                                <ext:Column ID="DEL_INFO1" ItemID="DEL_INFO1" runat="server" ><%--Text="1차 납품정보">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="VAN_DELI_QTY1" ItemID="DELI_QTY" runat="server" DataIndex="VAN_DELI_QTY1" Width="80" Align="Right" Format="#,##0.###" Sortable="true">
                                            <Editor>
                                                <ext:NumberField ID="txt02_DELI_QTY1" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" DecimalPrecision="3" /><%--DecimalPrecision="3" 소수점 3자리 입력 허용.--%>
                                            </Editor>
                                        </ext:NumberColumn>
                                        <ext:Column ID="VAN_ARRIV_TIME1" ItemID="ARVALPLAN" runat="server" DataIndex="VAN_ARRIV_TIME1" Width="80" Align="Center" Sortable="true"/> <%--Text="도착예정"--%>
                                        <ext:Column ID="ERM_ARRIV_TIME1" ItemID="ARRIV_PROC" runat="server" DataIndex="ERM_ARRIV_TIME1" Width="80" Align="Center" Sortable="true"/> <%--Text="입하처리"--%>
                                    </Columns>
                                </ext:Column> 
                                <ext:Column ID="DEL_INFO2" ItemID="DEL_INFO2" runat="server" ><%--Text="2차 납품정보">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="VAN_DELI_QTY2" ItemID="DELI_QTY1" runat="server" DataIndex="VAN_DELI_QTY2" Width="80" Align="Right" Format="#,##0.###" Sortable="true">
                                            <Editor>
                                                <ext:NumberField ID="txt02_DELI_QTY2" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" DecimalPrecision="3"/><%--DecimalPrecision="3" 소수점 3자리 입력 허용.--%>
                                            </Editor>
                                        </ext:NumberColumn>
                                        <ext:Column ID="VAN_ARRIV_TIME2" ItemID="ARVALPLAN2" runat="server" DataIndex="VAN_ARRIV_TIME2" Width="80" Align="Center" Sortable="true"/> <%--Text="도착예정"--%>
                                        <ext:Column ID="ERM_ARRIV_TIME2" ItemID="ARRIV_PROC2" runat="server" DataIndex="ERM_ARRIV_TIME2" Width="80" Align="Center" Sortable="true"/> <%--Text="입하처리"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="DEL_INFO3" ItemID="DEL_INFO3" runat="server" ><%--Text="3차 납품정보">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="VAN_DELI_QTY3" ItemID="DELI_QTY2" runat="server" DataIndex="VAN_DELI_QTY3" Width="80" Align="Right" Format="#,##0.###" Sortable="true">
                                            <Editor>
                                                <ext:NumberField ID="txt02_DELI_QTY3" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" DecimalPrecision="3"/><%--DecimalPrecision="3" 소수점 3자리 입력 허용.--%>
                                            </Editor>
                                        </ext:NumberColumn>
                                        <ext:Column ID="VAN_ARRIV_TIME3" ItemID="ARVALPLAN3" runat="server" DataIndex="VAN_ARRIV_TIME3" Width="80" Align="Center" Sortable="true"/> <%--Text="도착예정"--%>
                                        <ext:Column ID="ERM_ARRIV_TIME3" ItemID="ARRIV_PROC3" runat="server" DataIndex="ERM_ARRIV_TIME3" Width="80" Align="Center" Sortable="true"/> <%--Text="입하처리"--%>
                                    </Columns>
                                </ext:Column>
                                <%--<ext:Column ID="CORCD" DataIndex="CORCD" runat="server" Hidden="true" />
                                <ext:Column ID="BIZCD" DataIndex="BIZCD" runat="server" Hidden="true" />
                                <ext:Column ID="VENDCD" DataIndex="VENDCD" runat="server" Hidden="true" />
                                <ext:DateColumn ID="INPUT_DATE" DataIndex="INPUT_DATE" runat="server" Hidden="true" />
                                <ext:Column ID="VINCD" DataIndex="VINCD" runat="server" Hidden="true" />
                                <ext:Column ID="LINECD" DataIndex="LINECD" runat="server" Hidden="true" />
                                <ext:Column ID="CONTCD" DataIndex="CONTCD" runat="server" Hidden="true" />
                                <ext:Column ID="INSTALL_POS" DataIndex="INSTALL_POS" runat="server" Hidden="true" />
                                <ext:Column ID="GUBUN" DataIndex="GUBUN" runat="server" Hidden="true" />
                                <ext:Column ID="PUTIN_SEQ" DataIndex="PUTIN_SEQ" runat="server" Hidden="true" />
                                <ext:Column ID="DN_DIV" DataIndex="DN_DIV" runat="server" Hidden="true" />
                                <ext:Column ID="MAT_TYPE" DataIndex="MAT_TYPE" runat="server" Hidden="true" />
                                <ext:Column ID="OLD_QTY1" DataIndex="OLD_QTY1" runat="server" Hidden="true" />
                                <ext:Column ID="OLD_QTY2" DataIndex="OLD_QTY2" runat="server" Hidden="true" />
                                <ext:Column ID="OLD_QTY3" DataIndex="OLD_QTY3" runat="server" Hidden="true" />--%>
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server"  EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">
                                <Listeners>
                                    <Select Fn="CellFocus"></Select>
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
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
