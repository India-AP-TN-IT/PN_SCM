<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM31002.aspx.cs" Inherits="Ax.SRM.WP.Mobile.SRM_MM.SRM_MM31002" %>
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
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
    <meta name="format-detection" content="telephone=no, address=no, email=no" />

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <!-- link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" / -->
    <link rel="Stylesheet" type="text/css" href="../css/mobile.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/ext.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
	    .x-grid-cell-SHIP_PLAN_DATE DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }	
	    .x-grid-rowbody {font: normal 13px/15px helvetica,arial,verdana,sans-serif; padding:10px 0 !important; border-right:1px solid #ededed !important;}
	    .x-grid-rowbody td    { padding:2px;}
	    .x-grid-rowbody .x-panel-default-outer-border-trbl { padding:10px !important;}	    
	    
	    
	    .search_area_title_btn .x-panel-body-default {
            background:#efefef !important;            
            }
            
        .x-grid-row .x-grid-cell-selected { background-color:#f8f8f8 !important; color:inherit !important;  /* cell selected 색상 */ }
        
        /*.x-grid-cell-last { border-right:1px solid #000 !important;}*/
    </style>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        function gridStore() {
            return App.PagingToolbar1.getStore();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장

            //ContentPanel
            if (Ext.getCmp("ContentPanel") != null) App.ContentPanel.setWidth(window.innerWidth);
            if (Ext.getCmp("Grid01") != null) App.Grid01.setHeight(App.GridPanel.getHeight());
            if (Ext.getCmp("ButtonPanel") != null) App.ButtonPanel.setWidth(window.innerWidth - 20);
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

        window.onresize = UI_Resize;

        var no;

        var Prev = function () {
            if ((no + 1) % 10 == 1 && gridStore().currentPage > 1) { gridStore().previousPage(); }

            onSelect(no - 1);
        }

        var next = function () {
            if ((no + 1) % 10 == 0) { gridStore().nextPage(); }
            onSelect(no + 1);
        }

        var linkRenderer = function (value, meta, record, index) {
            return Ext.String.format("<a style='color:blue;text-decoration:underline;' href='#' onclick=\"onSelect({0});\">{1}</a>", record.index, value);
        };

        // 그리드의 셀을 클릭시 사용하는 메서드
        var onSelect = function (index) {
            var record = gridStore().getAllRange()[index];
            if (record) {
                App.txt02_PARTNONM.setValue(record.data['PARTNM']);
                App.txt02_DELI_DATE.setValue(record.data['DELI_DATE']);
                App.txt02_LOG_DIV.setValue(record.data['LOG_DIV']);
                App.txt02_YARDNO.setValue(record.data['YARDNO']);
                App.txt02_BAS_INV_QTY.setValue(record.data['BAS_INV_QTY']);
                App.txt02_MAT_REQ_QTY.setValue(record.data['MAT_REQ_QTY']);
                App.txt02_GAP_QTY.setValue(record.data['GAP_QTY']);

                no = record.index;

                App.DetailWindow.show();
                App.DetailWindow.setTitle("Info [" + (record.index + 1) + "] : " + record.data['VINCD'] + " / " + record.data["PARTNO"] + " / : " + record.data['PO_QTY']);
            }
        }

    </script>
</head>
<body>
    <form id="SRM_MM21001" runat="server">
        <ext:ResourceManager ID="ResourceManager1" runat="server">
            <Listeners>
                <DocumentReady Handler="ExtDocumentReady();" />
            </Listeners>
        </ext:ResourceManager>
        <ext:Panel runat="server" ID="ContentPanel" Region="Center" BodyStyle="width:100%;">
          <Content>
            <ext:SelectBox ID="cbo01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
                DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" Width="150" Hidden="true">
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
                <div id="wrap" >
	                <!-- 헤더 -->
                    <div class="header2">
                        <div class="mlogo"><ext:ImageButton ID="ImageButtonHome" runat="server" ImageUrl="../images/mlogo.gif" Height="50">
                            <Listeners>
                                <Click Handler="App.direct.Home();" />
                            </Listeners>
                        </ext:ImageButton></div>
                        <div class="mlogout"><ext:ImageButton ID="ImageButtonLogout" runat="server" ImageUrl="../images/btn/m_btn_logout.gif">
                            <Listeners>
                                <Click Handler="App.direct.Logout();" />
                            </Listeners>
                        </ext:ImageButton></div>
                    </div>
                    <!-- //헤더 -->    
                    <div class="title_bg"><ext:Label ID="lbl01_SRM_MM31002" runat="server" Cls="search_area_title_name" /><%--Text="A/S, S/P, CKD 자재발주" />--%></div>                    
                    <div style="padding:10px; background:#efefef;">
                        <ext:Panel ID="ButtonPanel" runat="server" Height="26"  Cls="search_area_title_btn">
                            <Items>
                                <%-- 상단 이미지버튼 --%>
                            </Items>
                        </ext:Panel>      
                    <div class="search_area_table">
                        <table width="100%">
                            <colgroup>
                                <col/>
                                <col/>
                            </colgroup>
                            <tr>
                                <th class="ess">
                                    <ext:Label ID="lbl01_VEND" runat="server" />
                                </th>
                                <td>
                                    <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_M_VENDCD" PopupMode="Search" PopupType="HelpWindow" PopupHeight="300" PopupWidth="300"/>
                                </td>                           
                            </tr>
                            <tr>
                                <th class="ess">
                                    <ext:Label ID="lbl01_PO_DATE" runat="server" /><%--Text="발주일자" />--%>
                                </th>
                                <td>
                                    <ext:DateField ID="df01_PO_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true" />
                                </td>
                            </tr>                        
                        </table>                     
                        </div>    
                        <ext:Panel ID="GridPanel" Border="True" runat="server" Cls="grid_area" Height="310">
                            <Items>                    
                                <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true"  TrackMouseOver="false" EmptyText="No Records To Display...">
                                    <Store>
                                        <ext:Store ID="Store1" runat="server" PageSize="10">
                                            <Model>
                                                <ext:Model ID="GridModel1" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="VINCD" />
                                                        <ext:ModelField Name="PARTNO" />
                                                        <ext:ModelField Name="PO_QTY" />
                                                        <ext:ModelField Name="PARTNM" />
                                                        <ext:ModelField Name="LOG_DIV" />
                                                        <ext:ModelField Name="YARDNO" />
                                                        <ext:ModelField Name="MAT_ITEM" />                                            
                                                        <ext:ModelField Name="DELI_DATE" />
                                                        <ext:ModelField Name="BAS_INV_QTY" />
                                                        <ext:ModelField Name="MAT_REQ_QTY" />  
                                                        <ext:ModelField Name="GAP_QTY" />
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
                                    </Plugins>  
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:RowNumbererColumn ID="NO" Text="NO" runat="server" MenuDisabled="true" Width="40" Align="Center"  /><%--Text="NO"      --%>
                                            <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="50" Align="Left" /><%--Text="차종"  --%>
                                            <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Flex="1" MinWidth="120" Align="Left" ><%--Text="PART NO"   --%>
                                                <Renderer Fn="linkRenderer" />
                                            </ext:Column>
                                            <ext:NumberColumn ID="PO_QTY" ItemID="ORDER_QTY" runat="server" DataIndex="PO_QTY"  Width="70" Align="Right" Format="#,##0" Sortable="true"/><%--Text="발주수량"  --%>                                
                                            <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1" Hidden="true"/><%--Text="PART NAME" --%>
                                            <ext:DateColumn ID="DELI_DATE" ItemID="DELI_DATE" runat="server" DataIndex="DELI_DATE" Hidden="true" Align="Center" /><%--Text="납기일자"      --%>     
                                            <ext:Column ID="LOG_DIV" ItemID="LOG_DIV" runat="server" DataIndex="LOG_DIV" Width="80" Align="Left" Hidden="true" /><%--Text="물류구분"      --%>
                                            <ext:Column ID="YARDNO" ItemID="MAT_YARD" runat="server" DataIndex="YARDNO" Width="90" Align="Left" Hidden="true" /><%--Text="자재창고"      --%>
                                            <ext:NumberColumn ID="BAS_INV_QTY" ItemID="BAS_INV" runat="server" DataIndex="BAS_INV_QTY" Width="70" Align="Right" Hidden="true" Format="#,##0" Sortable="true"/><%--Text="기초재고"  --%>
                                            <ext:NumberColumn ID="MAT_REQ_QTY" ItemID="PROD_PLAN" runat="server" DataIndex="MAT_REQ_QTY" Width="70" Align="Right" Hidden="true" Format="#,##0" Sortable="true"/><%--Text="생산계획"  --%>  
                                            <ext:NumberColumn ID="GAP_QTY" ItemID="EXC_QTY" runat="server" DataIndex="GAP_QTY"  Width="70" Align="Right" Hidden="true" Format="#,##0" Sortable="true"/><%--Text="과부족"  --%>                            
                                        </Columns>                               
                                    </ColumnModel>
                                    <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                                        <LoadMask ShowMask="true" />
                                    </Loader>
                                    <View>
                                        <ext:GridView ID="GridView1" runat="server"  EnableTextSelection="true"/>
                                    </View>
                                    <SelectionModel>
                                        <ext:CellSelectionModel></ext:CellSelectionModel>
                                    </SelectionModel>
<%--                                    <SelectionModel>
                                        <ext:RowSelectionModel  ID="RowSelectionModel1" runat="server">
                                            <Listeners>
                                                <Select Handler="App.RowExpander1.expandRow(index)"></Select>
                                            </Listeners>
                                        </ext:RowSelectionModel >
                                    </SelectionModel>--%>
<%--                                    <Listeners>
                                        <Select Fn="onSelect" />
                                    </Listeners>     --%>
<%--                                    <Listeners>
                                        <CellClick Fn="onSelect"></CellClick>
                                    </Listeners>--%>
                                    <BottomBar>
                                        <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                        <%--<ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>--%>
                                        <%--<ext:PagingToolbar ID="PagingToolbar1" runat="server" PageSize="13"  DisplayInfo="true" DisplayMsg="Records To Display... {0} - {1} of {2}" EmptyMsg="No Records to display" />--%>
                                        <ext:PagingToolbar ID="PagingToolbar1" HideRefresh="true" runat="server" />
                                    </BottomBar>
                                </ext:GridPanel>
                            </Items>
                        </ext:Panel>  
                        <ext:Window ID="DetailWindow" RenderTo="Grid01" ToFrontOnShow="true" Resizable="false" runat="server" Hidden="true" HideMode="Display" Maximizable="false" Minimizable="false" Closable="false" Title="Information" Modal="false" Width="300">
                            <Content>
                                <table class="mp_t">
                                    <colgroup>
                                        <col />
                                        <col />
                                    </colgroup>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_PARTNONM" runat="server" /><%--Text="PartName" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_PARTNONM" runat="server" ReadOnly="true" /><%--Text="PartName" />--%>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_DELI_DATE" runat="server" /><%--Text="납기일자" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_DELI_DATE" runat="server" ReadOnly="true"/><%--Text="납기일자" />--%>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_LOG_DIV" runat="server" /><%--Text="물류구분" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_LOG_DIV" runat="server" ReadOnly="true"/><%--Text="물류구분" />--%>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_YARDNM" runat="server" /><%--Text="자재창고" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_YARDNO" runat="server" ReadOnly="true"/><%--Text="자재창고" />--%>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_BAS_INV" runat="server" /><%--Text="기초재고" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_BAS_INV_QTY" runat="server" ReadOnly="true"/><%--Text="기초재고" />--%>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_PROD_PLAN" runat="server" /><%--Text="생산계획" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_MAT_REQ_QTY" runat="server" ReadOnly="true" /><%--Text="생산계획" />--%>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_EXC_QTY" runat="server" /><%--Text="과부족" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_GAP_QTY" runat="server" ReadOnly="true" /><%--Text="과부족" />--%>
                                        </td>   
                                    </tr>
                                </table>
                                <div  style="padding-left:6px; padding-top:2px;">
                                    <ext:Button ID="Button4" runat="server" Text="" Icon="PreviousGreen" StyleSpec="float:left; margin-right:4px;">
                                        <Listeners>
                                            <Click Fn='Prev' />                                                         
                                        </Listeners>
                                    </ext:Button>                                                               
                                    <ext:Button ID="Button1" runat="server" Text="" Icon="NextGreen" StyleSpec=" float:left;margin-right:4px;">
                                        <Listeners>
                                            <Click Fn='next' />                                                         
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="Button3" runat="server" Text="Close" Icon="Delete" StyleSpec=" width:66px; float:right;margin-right:4px;">
                                        <Listeners>
                                            <Click Handler="App.DetailWindow.hide();" />                                                         
                                        </Listeners>
                                    </ext:Button>                                                                            
                                </div
                            </Content>
                        </ext:Window>
                    </div>  
                    <!-- 푸터 -->
                    <div class="footer">COPYRIGHT(c) SEOYON E-HWA. ALL RIGHTS RESERVED.</div>
                    <!-- //푸터 -->
                </div>
            </Content>
        </ext:Panel>
    </form>
</body>
</html>
