<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM21001.aspx.cs" Inherits="Ax.SRM.WP.Mobile.SRM_MM.SRM_MM21001" %>
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
            if ((no + 1) % 10 == 1 && gridStore().currentPage > 1) { alert(no); gridStore().previousPage(); }
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
                App.txt02_PARTNM.setValue(record.data['PARTNM']);
                App.txt02_DELI_DATE.setValue(record.data['HANIL_DELIDATE']);
                App.txt02_JOB_TYPE.setValue(record.data['JOB_TYPE']);
                App.txt02_VENDNM.setValue(record.data['VENDNM']);
                App.txt02_ORD_DATE.setValue(record.data['ORD_DATE']);
                App.txt02_BASISNO.setValue(record.data['BASISNO']);
                App.txt02_FST_PO_QTY.setValue(record.data['FST_PO_QTY']);
                App.txt02_PMI.setValue(record.data['PMI']);
                App.txt02_PONO.setValue(record.data['PONO']);
                App.df02_VAN_DELI_DATE.setValue(record.data['VAN_DELI_DATE']);
                App.chk02_VAN_OK_YN.setValue(record.data['VAN_OK_YN']);

                no = record.index;

                App.DetailWindow.show();
                App.DetailWindow.setTitle("Info [" + (record.index + 1) + "] : " + record.data['PO_DATE'] + " / " + record.data["VINCD"] + " / : " + record.data['PARTNO']);
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
                    <div class="title_bg"><ext:Label ID="lbl01_SRM_MM21001" runat="server" Cls="search_area_title_name" /><%--Text="A/S, S/P, CKD 자재발주" />--%></div>                    
                    <div style="padding:10px; background:#efefef;">
                        <ext:Panel ID="ButtonPanel" runat="server" Height="26"  Cls="search_area_title_btn">
                            <Items>
                                <%-- 상단 이미지버튼 --%>
                            </Items>
                        </ext:Panel>
                        <ext:SelectBox ID="cbo01_JOB_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                            DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115" Hidden="true">
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
                        <ext:FieldContainer ID="FieldContainer1" runat="server" MsgTarget="Side" Flex="1" Width="160" Layout="TableLayout" Hidden="true">
                        <Items>
                            <ext:Checkbox ID="chk01_PO_STATUS_DIV" runat="server" Width="18" Cls="inputText" />
                            <ext:DateField ID="df01_PO_FROM_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                            <ext:Label ID="lbl01_FROM" runat="server" /><%--Text="부터" />--%>
                        </Items>
                    </ext:FieldContainer>
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
                                    <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_M_VENDCD" PopupMode="Search" PopupType="HelpWindow" PopupWidth="300" PopupHeight="335"/>
                                    <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" Visible="false"/>                  
                                </td>                           
                            </tr>
                            <tr>
                                <th class="ess">
                                    <ext:Label ID="lbl01_BASE_DATE" runat="server" /><%--Text="기준일자" />--%>
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
                                                        <%--<ext:ModelField Name="NO" /> --%>
                                                        <ext:ModelField Name="PO_DATE" />
                                                        <ext:ModelField Name="PONO" />                                            
                                                        <%--<ext:ModelField Name="YARDNM" />--%>
                                                        <ext:ModelField Name="JOB_TYPE" />
                                                        <ext:ModelField Name="VINCD" />
                                                        <ext:ModelField Name="PARTNO" />
                                                        <ext:ModelField Name="PARTNM" />                                            
                                                        <%--<ext:ModelField Name="STANDARD" />--%>
                                                        <%--<ext:ModelField Name="UNITNM" />--%>
                                                        <ext:ModelField Name="PO_QTY" />                                         
                                                        <ext:ModelField Name="HANIL_DELIDATE" />
                                                        <ext:ModelField Name="VENDNM" /> 
                                                        <ext:ModelField Name="ORD_DATE" />
                                                        <ext:ModelField Name="PMI" />                                            
                                                        <ext:ModelField Name="BASISNO" />
                                                        <%--<ext:ModelField Name="SAL_PNO" />--%>
                                                        <ext:ModelField Name="FST_PO_QTY" />                                            
                                                        <ext:ModelField Name="VAN_DELI_DATE" />
                                                        <ext:ModelField Name="VAN_OK_YN" DefaultValue="false" Type="Boolean"/>
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                            <Listeners>
                                                <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                                <Load Delay="1" Handler="GridStoreReady(App.GridStatus1, this.getTotalCount());  "></Load>
                                                <%--<TotalCountChange Handler=" if (App.Store1.currentPage == 1) App.Store1.loadPage(1,null);"></TotalCountChange>--%>
                                            </Listeners>
                                        </ext:Store>
                                    </Store>
                                    <Plugins>
                                        <ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>
                                        <%--<ext:RowExpander ID="RowExpander1" runat="server" HiddenColumn="true" ExpandOnDblClick="false" SingleExpand="true">

                                             <Component>
                                                <ext:FormPanel ID="FormPanel1" runat="server" Border="true">                            
                                                    <Items>
                                                        <ext:TextField ID="txt02_PARTNM" runat="server" Name="PARTNM" FieldLabel="Part Name" ReadOnly="true"/>
                                                        <ext:TextField ID="txt02_JOB_TYPE" runat="server" Name="JOB_TYPE" FieldLabel="업무유형" ReadOnly="true"/>
                                                        <ext:TextField ID="txt02_VENDNM" runat="server" Name="VENDNM" FieldLabel="고객사" ReadOnly="true"/>
                                                        <ext:TextField ID="txt02_ORD_DATE" runat="server" Name="ORD_DATE" FieldLabel="수주일자" ReadOnly="true"/>
                                                        <ext:TextField ID="txt02_BASISNO" runat="server" Name="BASISNO" FieldLabel="수주번호" ReadOnly="true"/>
                                                        <ext:TextField ID="txt02_FST_PO_QTY" runat="server" Name="FST_PO_QTY" FieldLabel="수주수량" ReadOnly="true"/>
                                                        <ext:TextField ID="txt02_PMI" runat="server" Name="PMI" FieldLabel="PMI" ReadOnly="true"/>
                                                        <ext:TextField ID="txt02_PONO" runat="server" Name="PONO" ReadOnly="true" Hidden="true"/>
                                                        <ext:DateField ID="df02_VAN_DELI_DATE" runat="server" Name="VAN_DELI_DATE" FieldLabel="출하계획일자" ReadOnly="false" Hidden="false"/>
                                                        <ext:Checkbox ID="chk02_VAN_OK_YN" runat="server" Name="VAN_OK_YN" FieldLabel="발주확인여부" ReadOnly="false" Hidden="false"/>
                                                    </Items>
                                                    <Buttons>
                                                        <ext:Button ID="Button1" runat="server" Text="Save" Icon="Disk">
                                                            <DirectEvents>
                                                                <Click OnEvent='GridDetailSave'/>                                                         
                                                            </DirectEvents>
                                                        </ext:Button>
                                                    </Buttons>
                                                </ext:FormPanel>
                                            </Component>
                                            <Listeners>
                                                <Expand Fn="onExpand" />
                                            </Listeners>
                                        </ext:RowExpander>--%>
                                    </Plugins>  
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <%--모바일은 Excel 다운로드 알할꺼라서 NO 컬럼은 그냥 OrwNumbererColumn으로 대체 사용해도 무방--%>
                                            <ext:RowNumbererColumn ID="NO" Text="NO" runat="server" MenuDisabled="true" Width="40" Align="Center"  /><%--Text="NO"      --%>
                                            <ext:DateColumn ID="PO_DATE" ItemID="PO_DATE" runat="server" DataIndex="PO_DATE" Width="70" Align="Center" /><%--Text="발주일자"      --%>
                                            <%--<ext:Column ID="PONO" ItemID="PONO" runat="server" DataIndex="PONO" Hidden="true" Align="Center" />--%><%--Text="발주번호"      --%>
                                            <%--<ext:Column ID="YARDNM" ItemID="MAT_YARD" runat="server" DataIndex="YARDNM" Hidden="true" Align="Left" />--%><%--Text="자재창고"      --%>
                                            <%--<ext:Column ID="JOB_TYPE" ItemID="JOB_TYPE2" runat="server" DataIndex="JOB_TYPE" Hidden="true" Align="Left" />--%><%--Text="업무유형"      --%>
                                            <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="50" Align="Left" /><%--Text="차종"  --%>
                                            <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" MinWidth="100" Flex="1" Align="Left" >
                                                <Renderer Fn="linkRenderer" />
                                            </ext:Column>
                                            <%--Text="PART NO"   --%>
                                            <%--<ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Hidden="true" Align="Left"/>--%><%--Text="PART NAME" --%>
                                            <%--<ext:Column ID="STANDARD" ItemID="STANDARD"  runat="server" DataIndex="STANDARD" Hidden="true" Align="Left"/>--%><%--Text="규격"      --%>
                                            <%--<ext:Column ID="UNITNM" ItemID="UNIT" runat="server" DataIndex="UNITNM" Hidden="true" Align="Center"/>--%><%--Text="단위"      --%>
                                            <ext:NumberColumn ID="PO_QTY" ItemID="ORDER_QTY" runat="server" DataIndex="PO_QTY" Align="Right" Format="#,##0"/><%--Text="발주수량"  --%>
                                            <ext:DateColumn ID="HANIL_DELIDATE" ItemID="DELI_DATE" runat="server" DataIndex="HANIL_DELIDATE" Hidden="true" Align="Center" /><%--Text="납기일자"      --%>     
<%--                                            <ext:DateColumn ID="VAN_DELI_DATE" ItemID="SHIP_PLAN_DATE" runat="server" DataIndex="VAN_DELI_DATE" Hidden="true" Align="Center" >                                
                                                <Editor> 
                                                    <ext:DateField ID="DateField1" runat="server"  SelectOnFocus="true" Text="출하계획일자"/> 
                                                </Editor>                                                                
                                            </ext:DateColumn>--%>
<%--                                            <ext:CheckColumn ID ="VAN_OK_YN" ItemID="PO_CONFIRM_YN" runat="server" DataIndex="VAN_OK_YN" Hidden="true" Align ="Center" StopSelection="false" 
                                                Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" Text="발주확인여부"/>
                                            </ext:CheckColumn>--%>
                                            <%--<ext:Column ID="VENDNM" ItemID="CUSTOMER" runat="server" DataIndex="VENDNM" Hidden="true" Align="Left" />--%><%--Text="고객사"      --%>
                                            <%--<ext:DateColumn ID="ORD_DATE" ItemID="ORD_DATE" runat="server" DataIndex="ORD_DATE" Hidden="true" Align="Center" />--%><%--Text="수주일자"      --%>
                                            <%--<ext:Column ID="PMI" ItemID="PMI" runat="server" DataIndex="PMI" Text="PMI" Hidden="true" Align="Left" />--%>
                                            <%--<ext:Column ID="BASISNO" ItemID="ORDNO" runat="server" DataIndex="BASISNO" Hidden="true" Align="Left" />--%><%--Text="수주번호"      --%>
                                            <%--<ext:Column ID="SAL_PNO" ItemID="VEND_ITEM" runat="server" DataIndex="SAL_PNO" Hidden="true" Align="Left" />--%><%--Text="PART NO"   --%>
                                            <ext:NumberColumn ID="FST_PO_QTY" ItemID="ORD_QTY" runat="server" DataIndex="FST_PO_QTY" Width="60" Align="Center" Hidden="true" Format="#,##0"/><%--Text="수주수량"  --%>                                          
                                            <%--<ext:Column ID="Column1" ItemID="Column1" runat="server" DataIndex="Column1" MinWidth="1" Flex="1" Align="Left" />--%><%--Text=""   --%>
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
                        <ext:Window ID="DetailWindow" RenderTo="Grid01" ToFrontOnShow="true" Resizable="false" runat="server" Hidden="true" HideMode="Display" Maximizable="false" Minimizable="false" Closable="false" Title="Information" Modal="true" Width="300" >
                            <Content>
                                <table ID="table01" class="mp_t">
                                    <colgroup>
                                        <col />
                                        <col />
                                    </colgroup>
                                    <tr>
                                    
                                        <th style="width:140px;" >
                                            <ext:Label ID="lbl02_PARTNONM" runat="server" /><%--Text="PartName" />--%>
                                        </th>
                                        <td style="width:150px;" >
                                            <ext:TextField Width="150" ID="txt02_PARTNM" runat="server" Name="PARTNM" ReadOnly="true"/>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_DELI_DATE_TYPE" runat="server" /><%--Text="납기일자/유형" />--%>
                                        </th>
                                        <td>
                                            <ext:FieldContainer runat="server" StyleSpec="border:0px;" Width="150" Flex="1" Layout="TableLayout">
                                                <Items>
                                                    <ext:TextField ID="txt02_DELI_DATE" runat="server" Width="85" Name="DELI_DATE" ReadOnly="true"/>
                                                    <ext:TextField ID="txt02_JOB_TYPE" runat="server" Width="64" Name="JOB_TYPE" MarginSpec="1px 1px 1px 1px" ReadOnly="true"/>
                                                </Items>
                                            </ext:FieldContainer>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_CUSTOMER" runat="server" /><%--Text="고객사" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_VENDNM" runat="server" Name="VENDNM" ReadOnly="true"/>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_ORD_DATE" runat="server" /><%--Text="수주일자" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_ORD_DATE" runat="server" Name="ORD_DATE" ReadOnly="true"/>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_ORDNO" runat="server" /><%--Text="수주번호" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_BASISNO" runat="server" Name="BASISNO" ReadOnly="true"/>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_ORD_QTY" runat="server" /><%--Text="수주수량" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_FST_PO_QTY" runat="server" Name="FST_PO_QTY" ReadOnly="true"/>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_PMI" runat="server" Text="PMI" /><%--Text="PMI" />--%>
                                        </th>
                                        <td>
                                            <ext:TextField ID="txt02_PMI" runat="server" Name="PMI" ReadOnly="true"/>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_SHIP_PLAN_DATE" runat="server" /><%--Text="출하계획일자" />--%>
                                        </th>
                                        <td>
                                            <ext:DateField ID="df02_VAN_DELI_DATE" runat="server" Name="VAN_DELI_DATE" ReadOnly="false" Hidden="false"/>
                                        </td>   
                                    </tr>
                                    <tr>
                                        <th>
                                            <ext:Label ID="lbl02_PO_CONFIRM_YN" runat="server" /><%--Text="발주확인여부" />--%>
                                        </th>
                                        <td>
                                            <ext:Checkbox ID="chk02_VAN_OK_YN" runat="server" Name="VAN_OK_YN" ReadOnly="false" Hidden="false"/>
                                        </td>   
                                    </tr>
                                </table>
                                
                                <ext:TextField ID="txt02_PONO" runat="server" Name="PONO" ReadOnly="true" Hidden="true"/>
                                
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

                                    <ext:Button ID="Button2" runat="server" Text="Save" Icon="Disk" StyleSpec=" width:66px; float:right;margin-right:4px;">
                                        <DirectEvents>
                                            <Click OnEvent='GridDetailSave'/>                                                         
                                        </DirectEvents>
                                    </ext:Button>  
                                </div>
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
