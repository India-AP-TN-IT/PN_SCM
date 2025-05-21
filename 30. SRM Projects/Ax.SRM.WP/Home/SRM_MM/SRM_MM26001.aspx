<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeBehind="SRM_MM26001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM26001" %>
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
	    .x-grid-cell-REQ_QTY DIV,
	    .x-grid-cell-REQ_QTY1 DIV,
	    .x-grid-cell-REQ_QTY2 DIV,
	    .x-grid-cell-REQ_QTY3 DIV,
	    .x-grid-cell-REQ_QTY4 DIV,
	    .x-grid-cell-REQ_QTY5 DIV,
	    .x-grid-cell-REQ_QTY6 DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }	    
    </style>
    <!--그리드 필수 입력필드-->
    <style type="text/css">
        #D0_REQ_QTY, #D1_REQ_QTY, #D2_REQ_QTY, #D3_REQ_QTY, #D4_REQ_QTY, #D5_REQ_QTY, #D6_REQ_QTY
        {
            background: url(../../images/common/point_icon.png) right 10px no-repeat;
        }
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        var divCol = 4; //틀고정 뒤의 첫번째 신청수량 위치

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }

        var getRowClass = function (record) {
            return "edit-row";
        };
        
        var linkRenderer = function (value, meta, record, index, cellIndex) {
            var param = "Ext.getStore('" + record.store.storeId + "')";

            if (value == '0') //수량이 0인 경우 링크를 걸지 않음
                return Ext.String.format("<a>{0}</a>", value);
            else
                return Ext.String.format("<a style='color:blue;text-decoration:underline;' href='#' onclick=\"linkClick({0},{1},{2});\">{3}</a>", param, index, cellIndex, numberWithCommas(value));
        };

        var linkClick = function (store, rowIndex, cellIndex) {

            var idx = parseInt((cellIndex - divCol) / 4); //몇일째인지 계산하기 위한 컬럼

            var param = new Array(idx, store.getAt(rowIndex).data["PARTNO"], store.getAt(rowIndex).data["PARTNM"], store.getAt(rowIndex).data["UNIT"]);
            App.direct.MakePopUp(param, (cellIndex - divCol) % 4 == 0 ? 'N' : 'C');
        };

        function numberWithCommas(x) {
            var parts = x.toString().split(".");
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            return parts.join(".");
        }

        function uncomma(str) {
            str = String(str);
            return str.replace(/[^\d]+/g, '');
        }

        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        var AfterEdit = function (rowEditor, e) {
            var row = e.rowIdx;
            var col = e.colIdx;
            var idx = parseInt((col - (divCol - 1)) / 4); //몇일째인지 계산하기 위한 컬럼

            var req_qty = Number(uncomma(App.Grid01.store.getAt(row).data['D' + idx + '_REQ_QTY']));
            var fore_qty = Number(uncomma(App.Grid01.store.getAt(row).data['D' + idx + '_FORE_QTY']));
            var conf_qty = Number(uncomma(App.Grid01.store.getAt(row).data['D' + idx + '_CONF_QTY']));
            App.Grid01.getStore().getAt(row).set('D' + idx + '_TOTAL', req_qty + fore_qty + conf_qty);
        }

        var moveFocus = function (o, e) {
            var grd = o.ownerCt.grid;

            if (e.getKey() === 40) {
                grd.editingPlugin.startEdit(currentCellObject.rowIdx + 1, currentCellObject.colIdx); // DOwn
            }
            else if (e.getKey() === 38) {
                grd.editingPlugin.startEdit(currentCellObject.rowIdx - 1, currentCellObject.colIdx); // Up
            }            
        }

    </script>
</head>
<body>
    <form id="SRM_MM26001" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM26001" runat="server" Cls="search_area_title_name" /><%--Text="사급신청 등록" />--%>
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
                            <col style="width: 200px;" />
                            <col style="width: 150px;" />
                            <col style="width: 200px;" />
                            <col style="width: 150px;" />
                            <col style="width: 200px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_CUST" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD_FIX" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60" OnAfterValidation="changeCondition"/>
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
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_PURC_ORG_Change" />
                                    </DirectEvents>      
                                </ext:SelectBox>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_REQ_DATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_GETDATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  >
                                    <DirectEvents>
                                        <Select OnEvent="df01_GETDATE_Change" />
                                    </DirectEvents>
                                </ext:DateField>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_PURC_ORG_VTWEG" runat="server" />
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer1" runat="server" MsgTarget="Side" Layout="TableLayout" Width="200px">
                                    <Items>
                                    <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                        DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150" MarginSpec="0px 10px 0px 0px">
                                        <Store>
                                            <ext:Store ID="Store33" runat="server" >
                                                <Model>
                                                    <ext:Model ID="Model33" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="OBJECT_ID" />
                                                            <ext:ModelField Name="OBJECT_NM" />
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                            </ext:Store>
                                        </Store>
                                        <DirectEvents>
                                            <Select OnEvent="cbo01_PURC_ORG_Change" />
                                        </DirectEvents>                                    
                                    </ext:SelectBox>
                                
                                    <ext:Label ID="lbl99_VTWEG_70" runat="server" />
                                    <ext:Label ID="lbl99_VTWEG_72" runat="server" Hidden="true"/>
                                    </Items>
                                </ext:FieldContainer>
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
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                 
                            </th>
                            <td colspan="5">
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" />                              
                            </td>
                        </tr>                        
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="EmpRegistPanel" Region="North" Cls="excel_upload_area_table" runat="server">
                <Content>
                    <table style="height:0px;" >
                        <colgroup>
                            <col style="width: 150px;" />
                            <col />
                            <col style="width: 80px;" />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_REQ_MGRNM" runat="server" /><%--신청담당자명--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_MGRNM" Width="150" Cls="inputText" runat="server" />
                            </td>
                            <td>                                
                                <ext:Button ID="btn01_CONFIRM_PROC" runat="server" TextAlign="Center" Cls="mg_r4" Width="72px"><%--Text="확정처리" >--%>
                                    <DirectEvents>
                                        <Click OnEvent="etc_Button_Click" >
                                            <ExtraParams>
                                                <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues(true)" Mode="Raw" Encode="true" />
                                            </ExtraParams>
                                        </Click>
                                    </DirectEvents>
                                </ext:Button>
                            </td>
                        </tr>                                                             
                    </table>
                </Content>
            </ext:Panel>
            
            <ext:Panel ID="Panel2" runat="server" Region="North" Height="27" >
                <Content>
                    <table style="height:0px; margin-bottom: 10px;">
                        <tr>
                            <td align="left" style="color:#555;">
                                <ext:Label ID="lbl01_MM26001_MSG001" runat="server" />
                                <ext:Label ID="lbl01_MM26001_MSG002" runat="server" />
                                <ext:Label ID="lbl01_MM26001_MSG003" runat="server" />
                            </td>    
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>

            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>                                        
                    <ext:GridPanel ID="Grid01" runat="server" TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." SortableColumns="false">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50" >
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VINCD" />                                            
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="D0_TOTAL" />
                                            <ext:ModelField Name="D0_REQ_QTY" />
                                            <ext:ModelField Name="D0_FORE_QTY" />
                                            <ext:ModelField Name="D0_CONF_QTY" />
                                            <ext:ModelField Name="D1_TOTAL" />
                                            <ext:ModelField Name="D1_REQ_QTY" />
                                            <ext:ModelField Name="D1_FORE_QTY" />
                                            <ext:ModelField Name="D1_CONF_QTY" />
                                            <ext:ModelField Name="D2_TOTAL" />
                                            <ext:ModelField Name="D2_REQ_QTY" />
                                            <ext:ModelField Name="D2_FORE_QTY" />
                                            <ext:ModelField Name="D2_CONF_QTY" />
                                            <ext:ModelField Name="D3_TOTAL" />
                                            <ext:ModelField Name="D3_REQ_QTY" />
                                            <ext:ModelField Name="D3_FORE_QTY" />
                                            <ext:ModelField Name="D3_CONF_QTY" />
                                            <ext:ModelField Name="D4_TOTAL" />
                                            <ext:ModelField Name="D4_REQ_QTY" />
                                            <ext:ModelField Name="D4_FORE_QTY" />
                                            <ext:ModelField Name="D4_CONF_QTY" />
                                            <ext:ModelField Name="D5_TOTAL" />
                                            <ext:ModelField Name="D5_REQ_QTY" />
                                            <ext:ModelField Name="D5_FORE_QTY" />
                                            <ext:ModelField Name="D5_CONF_QTY" />
                                            <ext:ModelField Name="D6_TOTAL" />
                                            <ext:ModelField Name="D6_REQ_QTY" />
                                            <ext:ModelField Name="D6_FORE_QTY" />
                                            <ext:ModelField Name="D6_CONF_QTY" />
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
                                <ext:RowNumbererColumn ID="NO"      ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center" Locked="true" Draggable="false"  Lockable="false"/>                                
                                <ext:Column ID="VINCD"  ItemID="VIN" runat="server" DataIndex="VINCD" Width="60" Align="Center" Locked="true" Draggable="false" Lockable="false" Hideable="false"/>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" Locked="true" Draggable="false" Lockable="false" Hideable="false"/>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="200" Align="Left" Draggable="false" Lockable="false" Hideable="false"/>
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="50" Align="Center" Draggable="false" Lockable="false" Hideable="false"/>
                                <ext:Column ID="D0" ItemID="D0" runat="server" Draggable="false" Lockable="false" Hideable="false">
                                    <Columns>
                                    <ext:NumberColumn      ID="D0_TOTAL"         ItemID="SUB_TOTAL"         runat="server" DataIndex="D0_TOTAL"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false"/>
                                    <ext:NumberColumn ID="D0_REQ_QTY" ItemID="REQ_QTY" runat="server" DataIndex="D0_REQ_QTY" Width="80" Align="Right" Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                    <Editor>
                                        <ext:NumberField ID="txt02_D0_REQ_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" SelectOnFocus="true" MinValue="0" >
                                            <Listeners>
                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                            </Listeners>
                                        </ext:NumberField>
                                    </Editor>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D0_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D0_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D0_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D0_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D1" ItemID="D1" runat="server" Draggable="false" Lockable="false" Hideable="false">
                                    <Columns>
                                    <ext:NumberColumn      ID="D1_TOTAL"         ItemID="SUB_TOTAL1"         runat="server" DataIndex="D1_TOTAL"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false"/>
                                    <ext:NumberColumn ID="D1_REQ_QTY" ItemID="REQ_QTY1" runat="server" DataIndex="D1_REQ_QTY" Width="80" Align="Right" Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                    <Editor>
                                        <ext:NumberField ID="txt02_D1_REQ_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" SelectOnFocus="true" MinValue="0" >
                                            <Listeners>
                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                            </Listeners>
                                        </ext:NumberField>
                                    </Editor>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D1_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D1_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D1_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D1_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D2" ItemID="D2" runat="server" Draggable="false" Lockable="false" Hideable="false">
                                    <Columns>
                                    <ext:NumberColumn      ID="D2_TOTAL"         ItemID="SUB_TOTAL2"         runat="server" DataIndex="D2_TOTAL"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false"/>
                                    <ext:NumberColumn ID="D2_REQ_QTY" ItemID="REQ_QTY2" runat="server" DataIndex="D2_REQ_QTY" Width="80" Align="Right" Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                    <Editor>
                                        <ext:NumberField ID="txt02_D2_REQ_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" SelectOnFocus="true" MinValue="0" >
                                            <Listeners>
                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                            </Listeners>
                                        </ext:NumberField>
                                    </Editor>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D2_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D2_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D2_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D2_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D3" ItemID="D3" runat="server" Draggable="false" Lockable="false" Hideable="false">
                                    <Columns>
                                    <ext:NumberColumn      ID="D3_TOTAL"         ItemID="SUB_TOTAL3"         runat="server" DataIndex="D3_TOTAL"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false"/>
                                    <ext:NumberColumn ID="D3_REQ_QTY" ItemID="REQ_QTY3" runat="server" DataIndex="D3_REQ_QTY" Width="80" Align="Right" Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                    <Editor>
                                        <ext:NumberField ID="txt02_D3_REQ_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" SelectOnFocus="true" MinValue="0" >
                                            <Listeners>
                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                            </Listeners>
                                        </ext:NumberField>
                                    </Editor>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D3_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D3_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D3_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D3_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D4" ItemID="D4" runat="server" Draggable="false" Lockable="false" Hideable="false">
                                    <Columns>
                                    <ext:NumberColumn      ID="D4_TOTAL"         ItemID="SUB_TOTAL4"         runat="server" DataIndex="D4_TOTAL"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false"/>
                                    <ext:NumberColumn ID="D4_REQ_QTY" ItemID="REQ_QTY4" runat="server" DataIndex="D4_REQ_QTY" Width="80" Align="Right" Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                    <Editor>
                                        <ext:NumberField ID="txt02_D4_REQ_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" SelectOnFocus="true" MinValue="0" >
                                            <Listeners>
                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                            </Listeners>
                                        </ext:NumberField>
                                    </Editor>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D4_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D4_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D4_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D4_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D5" ItemID="D5" runat="server" Draggable="false" Lockable="false" Hideable="false">
                                    <Columns>
                                    <ext:NumberColumn      ID="D5_TOTAL"         ItemID="SUB_TOTAL5"         runat="server" DataIndex="D5_TOTAL"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false"/>
                                    <ext:NumberColumn ID="D5_REQ_QTY" ItemID="REQ_QTY5" runat="server" DataIndex="D5_REQ_QTY" Width="80" Align="Right" Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                    <Editor>
                                        <ext:NumberField ID="txt02_D5_REQ_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" SelectOnFocus="true" MinValue="0" >
                                            <Listeners>
                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                            </Listeners>
                                        </ext:NumberField>
                                    </Editor>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D5_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D5_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D5_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D5_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D6" ItemID="D6" runat="server" Draggable="false" Lockable="false" Hideable="false">
                                    <Columns>
                                    <ext:NumberColumn      ID="D6_TOTAL"         ItemID="SUB_TOTAL6"         runat="server" DataIndex="D6_TOTAL"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false"/>
                                    <ext:NumberColumn ID="D6_REQ_QTY" ItemID="REQ_QTY6" runat="server" DataIndex="D6_REQ_QTY" Width="80" Align="Right" Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                    <Editor>
                                        <ext:NumberField ID="txt02_D6_REQ_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" SelectOnFocus="true" MinValue="0" >
                                            <Listeners>
                                                <SpecialKey Fn="moveFocus"></SpecialKey>
                                            </Listeners>
                                        </ext:NumberField>
                                    </Editor>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D6_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D6_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    <ext:NumberColumn      ID="D6_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D6_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0" Draggable="false" Lockable="false" Hideable="false">
                                        <Renderer Fn="linkRenderer"/>
                                    </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">                                
                                <GetRowClass Fn="getRowClass" />
                            </ext:GridView>
                        </View>                        
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
