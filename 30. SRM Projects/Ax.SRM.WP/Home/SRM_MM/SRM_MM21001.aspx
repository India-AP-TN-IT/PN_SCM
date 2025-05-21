<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SCM_MM21001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM21001" %>
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
	    .x-grid-cell-SHIP_PLAN_DATE DIV
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

    </script>
</head>
<body>
    <form id="SRM_MM21001" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM21001" runat="server" Cls="search_area_title_name" /><%--Text="A/S, S/P, CKD 자재발주" />--%>
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
                            <col style="width: 300px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60" />
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
                            <th>
                                <ext:Label ID="lbl01_CUST" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>  
                            <th class="ess">
                                <ext:Label ID="lbl01_PO_DATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_PO_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                            </td>                        
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" />                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_JOB_TYPE2" runat="server" /><%--Text="업무유형" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_JOB_TYPE" runat="server"  Mode="Local" ForceSelection="true"
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
                            </td>
                            <th>
                                <ext:Label ID="lbl01_PO_CONCEL_CONFIRM" runat="server" /><%--Text="발주취소확인" />--%>
                            </th>
                            <td colspan="3">
                                <ext:FieldContainer ID="FieldContainer1" runat="server" MsgTarget="Side" Flex="1" Width="160" Layout="TableLayout">
                                    <Items>
                                        <ext:Checkbox ID="chk01_PO_STATUS_DIV" runat="server" Width="18" Cls="inputText" />
                                        <ext:DateField ID="df01_PO_FROM_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                        <ext:Label ID="lbl01_FROM" runat="server" /><%--Text="부터" />--%>
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
                                            <ext:ModelField Name="PO_DATE" />
                                            <ext:ModelField Name="PONO" />                                            
                                            <ext:ModelField Name="YARDNM" />
                                            <ext:ModelField Name="JOB_TYPE" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />                                            
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="UNITNM" />
                                            <ext:ModelField Name="PO_QTY" />                                         
                                            <ext:ModelField Name="PO_SURP_QTY" />                                         
                                            <ext:ModelField Name="HANIL_DELIDATE" />
                                            <ext:ModelField Name="HANIL_BOUTDIV" />
                                            <ext:ModelField Name="HANIL_DELIDIVN" />
                                            <ext:ModelField Name="VENDNM" /> 
                                            <ext:ModelField Name="ORD_DATE" />
                                            <ext:ModelField Name="PMI" />                                            
                                            <ext:ModelField Name="BASISNO" />
                                            <ext:ModelField Name="SAL_PNO" />
                                            <ext:ModelField Name="FST_PO_QTY" />                                            
                                            <ext:ModelField Name="VAN_DELI_DATE" />
                                            <ext:ModelField Name="VAN_OK_YN" DefaultValue="false" Type="Boolean"/>
                                            <ext:ModelField Name="CUSTCD" />
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
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center"  >
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:Column ID="OW_PO_INFO" ItemID="OW_PO_INFO" runat="server" ><%--Text="당사 발주정보">--%>
                                    <Columns>
                                        <ext:DateColumn ID="PO_DATE" ItemID="PO_DATE" runat="server" DataIndex="PO_DATE" Width="80" Align="Center" Sortable="true" /><%--Text="발주일자"      --%>
                                        <ext:Column ID="PONO" ItemID="PONO" runat="server" DataIndex="PONO" Width="120" Align="Center" Sortable="true" /><%--Text="발주번호"      --%>
                                        <ext:Column ID="YARDNM" ItemID="MAT_YARD" runat="server" DataIndex="YARDNM" Width="90" Align="Left" Sortable="true" /><%--Text="자재창고"      --%>
                                        <ext:Column ID="JOB_TYPE" ItemID="JOB_TYPE2" runat="server" DataIndex="JOB_TYPE" Width="80" Align="Left" Sortable="true" /><%--Text="업무유형"      --%>
                                        <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="100" Align="Left" Sortable="true" /><%--Text="차종"  --%>
                                        <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" Sortable="true" /><%--Text="PART NO"   --%>
                                        <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="180" Align="Left" Sortable="true"/><%--Text="PART NAME" --%>
                                        <ext:Column ID="STANDARD" ItemID="STANDARD"  runat="server" DataIndex="STANDARD" Width="120" Align="Left" Sortable="true"/><%--Text="규격"      --%>
                                        <ext:Column ID="UNITNM" ItemID="UNIT" runat="server" DataIndex="UNITNM" Width="60" Align="Center" Sortable="true"/><%--Text="단위"      --%>
                                        <ext:NumberColumn ID="PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="PO_QTY" Width="80" Align="Right" Format="#,##0" Sortable="true"/><%--Text="발주량"  --%>
                                        <ext:NumberColumn ID="PO_SURP_QTY" ItemID="PO_SURP_QTY" runat="server" DataIndex="PO_SURP_QTY" Width="80" Align="Right" Format="#,##0" Sortable="true"/><%--Text="발주잔량"  --%>
                                        <ext:DateColumn ID="HANIL_DELIDATE" ItemID="DELI_DATE" runat="server" DataIndex="HANIL_DELIDATE" Width="80" Align="Center" Sortable="true" /><%--Text="납기일자"      --%>     
                                        <ext:Column ID="HANIL_BOUTDIV" ItemID="BOUT_DIV2" runat="server" DataIndex="HANIL_BOUTDIV" Width="80" Align="Left" Sortable="true"/><%--Text="양/단산 구분"      --%>
                                        <ext:Column ID="HANIL_DELIDIVN" ItemID="DELI_DIV2" runat="server" DataIndex="HANIL_DELIDIVN" Width="80" Align="Left" Sortable="true"/><%--Text="납기구분"      --%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="CUST_PO_INFO" ItemID="CUST_PO_INFO" runat="server" ><%--Text="고객사 발주정보">--%>
                                    <Columns>
                                        <ext:Column ID="VENDNM" ItemID="CUSTOMER" runat="server" DataIndex="VENDNM" Width="120" Align="Left" Sortable="true" /><%--Text="고객사"      --%>
                                        <ext:DateColumn ID="ORD_DATE" ItemID="ORD_DATE" runat="server" DataIndex="ORD_DATE" Width="80" Align="Center" Sortable="true" /><%--Text="수주일자"      --%>
                                        <ext:Column ID="PMI" ItemID="PMI" runat="server" DataIndex="PMI" Text="PMI" Width="120" Align="Left" Sortable="true" />
                                        <ext:Column ID="BASISNO" ItemID="ORDNO" runat="server" DataIndex="BASISNO" Width="120" Align="Left" Sortable="true" /><%--Text="수주번호"      --%>
                                        <ext:Column ID="SAL_PNO" ItemID="VEND_ITEM" runat="server" DataIndex="SAL_PNO" Width="120" Align="Left" Sortable="true" /><%--Text="PART NO"   --%>
                                        <ext:NumberColumn ID="FST_PO_QTY" ItemID="ORD_QTY" runat="server" DataIndex="FST_PO_QTY" Width="80" Align="Right" Format="#,##0" Sortable="true"/><%--Text="수주수량"  --%>
                                    </Columns>
                                </ext:Column>                                                           
                                <ext:DateColumn ID="VAN_DELI_DATE" ItemID="SHIP_PLAN_DATE" runat="server" DataIndex="VAN_DELI_DATE" Width="90" Align="Center" >                                
                                    <Editor> 
                                        <ext:DateField ID="DateField1" runat="server" Type="Date" SelectOnFocus="true" /><%--Text="출하계획일자"--%> 
                                    </Editor>                                                                
                                </ext:DateColumn>
                                <ext:CheckColumn ID ="VAN_OK_YN" ItemID="PO_CONFIRM_YN" runat="server" DataIndex="VAN_OK_YN" Width="90" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="발주확인여부"--%>
                                </ext:CheckColumn>
                                <ext:Column ID="Column1" ItemID="Column1" runat="server" >
                                    <Columns>
                                        <ext:Column ID="CUSTCD" ItemID="CUSTCD" runat="server" DataIndex="CUSTCD" Width="0" Align="Left" Sortable="true" /><%--Text="고객사"      --%>
                                    </Columns>
                                </ext:Column>   
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server"  EnableTextSelection="true" />
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
