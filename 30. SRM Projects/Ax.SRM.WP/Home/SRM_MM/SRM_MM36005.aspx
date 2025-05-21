<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM36005.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM36005" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" >
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="HE.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="HE.POTAL" />

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <style type="text/css">	  
	    .total-reportno .x-grid-td
	    {			    
		    background:orange !important;
	    } 
	    
	    .sub_total-reportno .x-grid-td
	    {	
		    background:pink !important;
	    }
	    
        .total_vendor .x-grid-td
	    {			    
		    background:#FFFFAA !important;
	    }	    	           
    </style>
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

        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;
            var GRID_PARTNO = grid.getStore().getAt(rowIndex).data["PARTNO"];
            var GRID_SUM_QTY = grid.getStore().getAt(rowIndex).data["SUM_QTY"];
            var GRID_SUM_AMT = grid.getStore().getAt(rowIndex).data["SUM_AMT"];

            fn_PopupHandler(GRID_PARTNO, GRID_SUM_QTY, GRID_SUM_AMT);
        }

        function fn_PopupHandler(GRID_PARTNO, GRID_SUM_QTY, GRID_SUM_AMT) {
            App.GRID_PARTNO.setValue(GRID_PARTNO);
            App.GRID_SUM_QTY.setValue(GRID_SUM_QTY);
            App.GRID_SUM_AMT.setValue(GRID_SUM_AMT);
            
            App.btn01_POP_MM36005P1.fireEvent('click');
        }

        var getRowClass = function (record) {
            if (record.data["ORDER_SEQ"] == 0) {
                return "total_vendor";
            }            
        }; 
    </script>
</head>
<body>
    <form id="SRM_MM36005" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_POP_MM36005P1" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:TextField ID="GRID_PARTNO" runat="server" Hidden="true" /> <%--팝업호출시 그리드의 PART NO 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="GRID_SUM_QTY" runat="server" Hidden="true" /> <%--팝업호출시 그리드의 합계수량 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="GRID_SUM_AMT" runat="server" Hidden="true" /> <%--팝업호출시 그리드의 합계금액 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="UserHelpURL" runat="server" Hidden="true" Text="../SCM_MM/SRM_MM36005P1.aspx" /> 
    <ext:TextField ID="PopupWidth" runat="server" Hidden="true" Text="800" /> 
    <ext:TextField ID="PopupHeight" runat="server" Hidden="true" Text="600" /> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MM36005" runat="server" Cls="search_area_title_name" /><%--Text="월별 사급 검수현황" />--%>
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
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD_FIX" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>   
                            <th>
                                <ext:Label ID="lbl01_SAUP" runat="server" /><%--Text="사업장" />--%>
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
                                <ext:Label ID="lbl01_STD_YYMM" runat="server" /><%--Text="기준년월" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_SETTLE_DATE" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />                                
                            </td>
                        </tr> 
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_MAT_ITEM" runat="server" />                    
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_MAT_ITEM" OnDirectEventChange="Button_Click" runat="server" ClassID="E0" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" /><%--Text="PART NO(%)" />--%>                       
                            </th>
                            <td colspan="3">
                                <ext:TextField ID="txt01_PARTNO" Width="150" Cls="inputText" runat="server" />    
                            </td>                                                      
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="250">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="MAT_ITEM" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="UNIT" />                                            
                                            <ext:ModelField Name="UCOST" />
                                            <ext:ModelField Name="SUM_QTY" />
                                            <ext:ModelField Name="SUM_AMT" />
                                            <ext:ModelField Name="OUT_QTY" />
                                            <ext:ModelField Name="OUT_AMT" />
                                            <ext:ModelField Name="RTN_QTY" />
                                            <ext:ModelField Name="RTN_AMT" />
                                            <ext:ModelField Name="SETTLE_QTY" />
                                            <ext:ModelField Name="SETTLE_AMT" />
                                            <ext:ModelField Name="ORDER_SEQ" />
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
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Width="40" Align="Center" Text="No" />
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left"  /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME" --%>
                                <ext:Column ID="MAT_ITEM" ItemID="MAT_ITEM" runat="server" DataIndex="MAT_ITEM" Width="120" Align="Left" /><%--Text="자재품목"  --%>
                                <ext:Column ID="STANDARD" ItemID="STANDARD"  runat="server" DataIndex="STANDARD" Width="120" Align="Left"/><%--Text="규격"      --%>
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="60" Align="Center"/><%--Text="단위"--%>
                                <ext:NumberColumn ID="UCOST" ItemID="RESALCOST" runat="server" DataIndex="UCOST" Width="80" Align="Right" Format="#,##0"/><%--Text="사급단가"--%>                                
                                <ext:Column ID="TOTAL" ItemID="TOTAL" runat="server" ><%--Text="합계">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="SUM_QTY" ItemID="QTY" runat="server" DataIndex="SUM_QTY" Width="80" Align="Right" Format="#,##0" Sortable="true"/><%--수량--%>
                                        <ext:NumberColumn ID="SUM_AMT" ItemID="AMT" runat="server" DataIndex="SUM_AMT" Width="110" Align="Right" Format="#,##0" Sortable="true"/><%--금액--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="OUT" ItemID="OUT" runat="server" ><%--Text="출고">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="OUT_QTY" ItemID="QTY" runat="server" DataIndex="OUT_QTY" Width="80" Align="Right" Format="#,##0" Sortable="true"/><%--수량--%>
                                        <ext:NumberColumn ID="OUT_AMT" ItemID="AMT" runat="server" DataIndex="OUT_AMT" Width="110" Align="Right" Format="#,##0" Sortable="true" /><%--금액--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="RTN" ItemID="RTN" runat="server" ><%--Text="반품">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="RTN_QTY" ItemID="QTY" runat="server" DataIndex="RTN_QTY" Width="80" Align="Right" Format="#,##0" Sortable="true" /><%--수량--%>
                                        <ext:NumberColumn ID="RTN_AMT" ItemID="AMT" runat="server" DataIndex="RTN_AMT" Width="110" Align="Right" Format="#,##0" Sortable="true" /><%--금액--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="SETTLE2" ItemID="SETTLE2" runat="server" ><%--Text="소급">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="SETTLE_QTY" ItemID="QTY" runat="server" DataIndex="SETTLE_QTY" Width="80" Align="Right" Format="#,##0" Sortable="true" /><%--수량--%>
                                        <ext:NumberColumn ID="SETTLE_AMT" ItemID="AMT" runat="server" DataIndex="SETTLE_AMT" Width="110" Align="Right" Format="#,##0" Sortable="true" /><%--금액--%>
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
                        <SelectionModel>                            
                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single"/>
                        </SelectionModel>
                        <Listeners>
                            <CellDblClick Fn ="CellDbClick"></CellDblClick>
                        </Listeners>                       
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
