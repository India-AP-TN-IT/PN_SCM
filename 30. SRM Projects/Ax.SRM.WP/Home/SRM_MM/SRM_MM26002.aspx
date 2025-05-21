<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM26002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM26002" %>
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
	    .x-grid-cell-OK_QTY2 DIV,
	    .x-grid-cell-DEF_QTY DIV,
	    .x-grid-cell-LOSS_QTY DIV,
	    .x-grid-cell-REMARK DIV
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
        
        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            var grid = selectionModel.view.ownerCt;

            grid.editingPlugin.startEdit(rowIndex, colIndex);
        }

        var fn_CustVendToggle = function () {
            if (App.cbo01_VEND_INV_DIV.getValue() != null)
                App.direct.SetCustVendVisible(App.cbo01_VEND_INV_DIV.getValue().toString());
        };

    </script>
</head>
<body>
    <form id="SRM_MM26002" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM26002" runat="server" Cls="search_area_title_name" /><%--Text="협력사 재고 등록" />--%>
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
                                <ext:Label ID="lbl01_CUST" runat="server" />
                                <ext:Label ID="lbl01_VEND" runat="server" Hidden="true" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD_FIX" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>   
                            <th>
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
                                <ext:Label ID="lbl01_INV_STD_DATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_GETDATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                            </td>                        
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" />                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_DIVISION" runat="server" Hidden="true"/><%--Text="구분" /> --%>                      
                                <ext:Label ID="lbl01_SOURCING_DIVISION" runat="server" /><%--Text="Sourcing구분" /> --%>    
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SOURCING_DIVISION" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150" >
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
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
                                <ext:SelectBox ID="cbo01_VEND_INV_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115" Hidden="true">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <Listeners>
                                        <Change Fn="fn_CustVendToggle"></Change>                                              
                                    </Listeners>
                                </ext:SelectBox>
                            </td>
                            <%--<th>
                                <ext:Label ID="lbl01_MAT_TYPE" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_MAT_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
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
                            </td> --%>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                 
                            </th>
                            <td >
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" />                             
                            </td>
                        </tr>
                        <%--<tr>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                 
                            </th>
                            <td colspan="5">
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" />                             
                            </td>
                        </tr>   --%>                                              
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="EmpRegistPanel" Region="North" Cls="excel_upload_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_REG_MGRNM" runat="server" /><%--등록담당자명--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_MGRNM" Width="150" Cls="inputText" runat="server" />
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
                                <ext:FieldContainer ID="FieldContainer2" runat="server" Width="350" Flex="1" MsgTarget="Side" Layout="TableLayout">
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
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="OK_INV_QTY" />                                                                                      
                                            <ext:ModelField Name="DEF_INV_QTY" />                                         
                                            <ext:ModelField Name="LOSS_QTY" />
                                            <ext:ModelField Name="REMARK" />
                                            <ext:ModelField Name="MAT_TYPE" />
                                            <ext:ModelField Name="VEND_INVNO" />                                            
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
                                </Listeners>
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true" Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="40" Align="Center" /><%--Text="차종"  --%>
                                <ext:Column ID="PART_NO_INFO" ItemID="PART_NO_INFO" runat="server" >
                                    <Columns>
                                        <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" Sortable="true" /><%--Text="PART NO"   --%>
                                        <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="200" Align="Left" Sortable="true" /><%--Text="PART NAME" --%>
                                        <ext:Column ID="STANDARD" ItemID="STANDARD"  runat="server" DataIndex="STANDARD" Width="140" Align="Left" Sortable="true" /><%--Text="규격"      --%>
                                        <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="40" Align="Center" Sortable="true"/><%--Text="단위"      --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="REAL_INV_QTY" ItemID="REAL_INV_QTY" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="OK_INV_QTY" ItemID="OK_QTY2" runat="server" DataIndex="OK_INV_QTY"  Width="80" Align="Right" Format="#,##0" Sortable="true"><%--Text="양품"  --%>
                                            <Editor>
                                                <ext:NumberField ID="txt02_OK_INV_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" />
                                            </Editor>
                                        </ext:NumberColumn> 
                                        <ext:NumberColumn ID="DEF_INV_QTY" ItemID="DEF_QTY" runat="server" DataIndex="DEF_INV_QTY"  Width="80" Align="Right" Format="#,##0" Sortable="true"><%--Text="불량"  --%>  
                                            <Editor>
                                                <ext:NumberField ID="txt02_DEF_INV_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" />
                                            </Editor>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn ID="LOSS_QTY" ItemID="LOSS_QTY" runat="server" DataIndex="LOSS_QTY"  Width="80" Align="Right" Format="#,##0" Sortable="true"><%--Text="손망실"  --%>  
                                            <Editor>
                                                <ext:NumberField ID="txt02_LOSS_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" />
                                            </Editor>
                                        </ext:NumberColumn>                           
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="REMARK" ItemID="REMARK" runat="server" DataIndex="REMARK" MinWidth="180" Align="Left" Flex="1">
                                    <Editor>
                                        <ext:TextField ID="txt02_REMARK" Cls="inputText" FieldCls="inputText" runat="server" Height="22"/>
                                    </Editor>
                                </ext:Column><%--Text="비고" --%>
                                <ext:Column ID="MAT_TYPE" DataIndex="MAT_TYPE" runat="server" Hidden="true" />
                                <ext:Column ID="VEND_INVNO" DataIndex="VEND_INVNO" runat="server" Hidden="true" />
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
