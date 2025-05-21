<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM32005.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM32005" %>
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

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <style type="text/css">        
	    .x-grid-cell-BOX_QTY DIV
	    , .x-grid-cell-PRDT_DATE DIV
	    , .x-grid-cell-LOTNO DIV
	    , .x-grid-cell-CHANGE_4M DIV	
	    , .x-grid-cell-UNIT_PACK_QTY DIV	
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }	
	    .x-grid-row-selected .x-grid-td {background: lightblue;color:black !important;}
	            
    </style>
    <!--그리드 필수 입력필드 (itemid 아니고 control id)-->
    <style type="text/css">
        #D_MEDI_PACK_QTY, #D_PRDT_DATE, #D_BOX_CNT
        {
            background: url(../../images/common/point_icon.png) right 10px no-repeat;
        }
    </style>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel1.getHeight() - 3);            
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {                            
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
        }


        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드의 editor를 활성화시키는 시점에서 작동        
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        // 그리드를 editor한 후에 발생되는 이벤트
        var AfterEdit = function (rowEditor, e) {
        }

    </script>
</head>
<body>
    <form id="SRM_MM32005" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM32005" runat="server" Cls="search_area_title_name" />
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
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col />
                        </colgroup>      
                        <tr>
                            <th class="ess">
                               <ext:Label ID="lbl01_VEND" runat="server" Text="업체" />
                            </th>
                            <td>                                 
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"  />
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" Text="Business Code" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_BIZCD" ItemID="SAUP" runat="server" Cls="inputText"  Mode="Local" ForceSelection="true"
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
                                <ext:Label ID="lbl01_PURC_PO_TYPE" runat="server" />                   
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PURC_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="160">
                                    <Store>
                                        <ext:Store ID="Store6" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model6" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>                                    
                                </ext:SelectBox>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" />
                            </th>
                            <td>                                
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
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
                            </td>
                        </tr> 
                        <tr>
                            <th>
                               <ext:Label ID="lbl01_STR_LOC" runat="server" />
                            </th>
                            <td>                                                                                                 
                                <epc:EPCodeBox ID="cdx01_STR_LOC" runat="server" HelperID="HELP_STR_LOC" PopupMode="Search" PopupType="HelpWindow"/>    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" />                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="80" />
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" /><%--Text="PART NO" />--%>                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="160" Cls="inputText" runat="server" />    
                            </td>
                            <td colspan="2">
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="300" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                <Items>
                                    <ext:Button ID="btn01_PART_PRINT" runat="server" MarginSpec="0px 10px 0px 0px" TextAlign="Center">                                        
                                        <DirectEvents>
                                            <Click OnEvent="etc_Button_Click" >
                                                <ExtraParams>
                                                    <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({dirtyRowsOnly:true})" Mode="Raw" Encode="true" />
                                                </ExtraParams>
                                            </Click>
                                        </DirectEvents>
                                    </ext:Button>
                                    <ext:RadioGroup ID="RadioGroup2" runat="server" Width="160" Cls="inputText" ColumnsWidths="80,80">
                                        <Items>
                                            <ext:Radio ID="rdo01_SET_1ST" Cls="inputText" runat="server" InputValue="1" Checked="true" />
                                            <ext:Radio ID="rdo01_SET_2ST" Cls="inputText" runat="server" InputValue="2" />
                                        </Items>
                                    </ext:RadioGroup>
                                </Items>
                                </ext:FieldContainer>
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel1" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>                                                
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model> 
                                    <ext:Model ID="GridModel2" runat="server" Name ="ModelGrid">
                                        <Fields>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="NATIONCD" />
                                            <ext:ModelField Name="NATIONNM"/>
                                            <ext:ModelField Name="EN_NATIONNM"/>
                                            <ext:ModelField Name="CUSTCD"/>
                                            <ext:ModelField Name="CUSTNM"/>
                                            <ext:ModelField Name="SUM_CUSTCD"/>
                                            <ext:ModelField Name="PARTNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="VINCD"/>
                                            <ext:ModelField Name="PO_UNIT"/>
                                            <ext:ModelField Name="MEDI_PACK_QTY"/>
                                            <ext:ModelField Name="BOX_CNT"/>
                                            <ext:ModelField Name="PRDT_DATE"  type="Date" SubmitEmptyValue="EmptyString" />
                                            <ext:ModelField Name="LOTNO"/>
                                            <ext:ModelField Name="CHANGE_4M"/>
                                            <ext:ModelField Name="VENDNM"/>
                                            <ext:ModelField Name="EXP_VENDNM"/>
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
                            <ext:BufferedRenderer ID="BufferedRenderer1" runat="server" />
                            <%-- 2.X버전부터는 그리드에서 edtior를 활성화 시키기위해서 cellEditing Plugin을 추가 하여 사용하고 자바스크립트에서 grid.editingPlugin 형태로 사용할수 있다. --%>
                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                <Listeners>                                    
                                    <BeforeEdit fn="BeforeEdit" />
                                    <Edit fn ="AfterEdit" />                                    
                                </Listeners> 
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel3" runat="server">
                            <Columns>
                                <ext:Column ID ="D_NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo" />
                                </ext:Column>
                                <ext:Column ID="D_NATIONNM" ItemID="NATIONNM" runat="server" DataIndex="NATIONNM" Width="100" Align="Center" /><%--Text="국가"--%>  
                                <ext:Column ID="D_CUSTNM" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="150" Align="Left" /><%--Text="고객사"--%> 
                                <ext:Column ID="D_SUM_CUSTCD" ItemID="SUM_CUSTCD" runat="server" DataIndex="SUM_CUSTCD" Width="80" Align="center" /><%--Text="식별코드"--%> 
                                <ext:Column ID="D_PARTNO" ItemID="PARTNO3" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="품번"--%>  
                                <ext:Column ID="D_PARTNM" ItemID="PARTNONM" runat="server" DataIndex="PARTNM" Width="200" Align="Left" /><%--Text="품명"--%>  
                                <ext:Column ID="D_VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="60" Align="Center" /><%--Text="차종"--%> 
                                <ext:Column ID="D_PO_UNIT" ItemID="UNIT" runat="server" DataIndex="PO_UNIT" Width="60" Align="Center" /><%--Text="단위"--%>                                  
                                <ext:NumberColumn ID="D_MEDI_PACK_QTY" ItemID="UNIT_PACK_QTY" runat="server" Text="박스수량" DataIndex="MEDI_PACK_QTY" Width="70" Align="Right" Format="#,##0.###">               
                                    <Editor>
                                        <ext:NumberField ID="TextField_UNIT_PACK_QTY" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" AllowBlank="false" SelectOnFocus="true" DecimalPrecision="3"/><%--DecimalPrecision="3" 소수점 3자리 입력 허용.--%>
                                    </Editor>
                                </ext:NumberColumn>                                                          
                                <ext:NumberColumn ID="D_BOX_CNT" ItemID="BOX_QTY" runat="server" Text="박스수량" DataIndex="BOX_CNT" Width="80" Align="Right" Format="#,##0">               
                                    <Editor>
                                        <ext:NumberField ID="TextField_BOX_CNT" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MinValue="0" AllowBlank="false" SelectOnFocus="true" />
                                    </Editor>
                                </ext:NumberColumn>
                                <ext:DateColumn ID="D_PRDT_DATE" ItemID="PRDT_DATE" runat="server" Text="제조일자" DataIndex="PRDT_DATE" Width="105" Align="Center" >                                
                                    <Editor> 
                                        <ext:DateField ID="DateField_PRDT_DATE" runat="server"  SelectOnFocus="true" AllowBlank="true" > 
                                        </ext:DateField>
                                    </Editor>                                                                
                                </ext:DateColumn>  
                                <ext:Column ID="D_LOTNO" runat="server" ItemID="LOTNO"  Text="LOTNO" DataIndex="LOTNO" Width="100" Align="left"  >
                                    <Editor>
                                        <ext:TextField ID="TextField_LOTNO" ItemID="TextField_LOTNO" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22" SelectOnFocus="true" >                                             
                                        </ext:TextField>                                        
                                    </Editor>
                                </ext:Column>   
                                <ext:Column ID="D_CHANGE_4M" runat="server" ItemID="CHANGE_4M" Text="4M변경내역" DataIndex="CHANGE_4M" Width="300" Align="left" Flex="1" >
                                    <Editor>
                                        <ext:TextField ID="TextField_CHANGE_4M" ItemID="TextField_CHANGE_4M" Cls="inputText" FieldCls="inputText" runat="server" Width="120" Height ="22" SelectOnFocus="true" >                                             
                                        </ext:TextField>                                        
                                    </Editor>
                                </ext:Column> 
                                 
                            </Columns>
                            <Listeners>
                                <%--<HeaderClick Fn="onSelectionCheckHeaderChange" />--%> <%--그리드 헤더의 체크박스를 클릭할 경우 발생--%>
                            </Listeners>
                        </ColumnModel>
                        <Loader ID="Loader3" runat="server" AutoLoad="false" Mode="Data">
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
    </ext:Viewport>
    </form>
</body>
</html>
