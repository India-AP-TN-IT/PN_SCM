<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM33001.aspx.cs" Inherits="HE.SCM.WP.Home.SCM_MM.SRM_MM33001" %>
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

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
            App.Grid02.setHeight(App.GridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        var fn_GridDisplay = function () {
            App.direct.SetGridDisplay(App.cbo01_SEARCH_OPT.getValue().toString());            
        };

        var getRowClass = function (record) {            
            if (record.data["ORDER_SEQ"] == 0) {
                return "total_vendor";
            }
        }; 
    </script>
</head>
<body>
    <form id="SRM_MM33001" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM33001" runat="server" Cls="search_area_title_name" /><%--Text="일별 검수 실적" />--%>
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
                                <ext:Label ID="lbl01_VEND" runat="server" /><%--Text="업체" />--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
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
                            <th>
                                <ext:Label ID="lbl01_STD_DATE" runat="server" /><%--Text="일자" />--%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="CompositeField3" runat="server" Width="250" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:DateField ID="df01_BEG_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                                        <ext:DisplayField ID="DisplayField1" Width="20"  Flex="1" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:DateField ID="df01_END_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                        </tr> 
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" /><%--Text="차종" /> --%>                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>
                            <th>
                               <ext:Label ID="lbl01_ACP_DIV" runat="server" /><%--Text="검수구분" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_ACP_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
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
                            <th>         
                                <ext:Label ID="lbl01_MAT_TYPE" runat="server" /><%--Text="자재유형" />--%>                       
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_MAT_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
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
                        </tr> 
                        <tr>
                            <th>
                               <ext:Label ID="lbl01_SEARCH_OPT" runat="server" /><%--Text="조회구분" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SEARCH_OPT" runat="server"  Mode="Local" ForceSelection="true"
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
                                    <Listeners>
                                        <Change Fn="fn_GridDisplay"></Change>                                              
                                    </Listeners>
                                </ext:SelectBox>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" /><%--Text="PART NO" />--%>                       
                            </th>
                            <td colspan="3">
                                <ext:TextField ID="txt01_PARTNO1" Width="120" Cls="inputText" runat="server" />    
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <%-- 집계내역 그리드 --%>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="MAT_TYPE" />
                                            <ext:ModelField Name="MAT_ITEM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="UNITNM" />
                                            <ext:ModelField Name="TOT_AMT" />
                                            <ext:ModelField Name="RCV_QTY" />
                                            <ext:ModelField Name="RCV_UCOST" />
                                            <ext:ModelField Name="RCV_AMT" />
                                            <ext:ModelField Name="RTN_QTY" />
                                            <ext:ModelField Name="RTN_UCOST" />
                                            <ext:ModelField Name="RTN_AMT" />
                                            <ext:ModelField Name="SETTLE_QTY" />
                                            <ext:ModelField Name="SETTLE_AMT" />                                           
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
                                <ext:RowNumbererColumn ID="NO"            ItemID="NO"        runat="server" Width="40" Align="Center" Text="No" />
                                <ext:Column ID="VINCD"                    ItemID="VIN"       runat="server" DataIndex="VINCD"      Width="50" Align="Center" Sortable="true"/>                  <%--Text="차종"--%>        
                                <ext:Column ID="MAT_TYPE"                 ItemID="MAT_TYPE"  runat="server" DataIndex="MAT_TYPE"   Width="60" Align="Center" Sortable="true"/>                  <%--Text="자재유형"--%>      
                                <ext:Column ID="MAT_ITEM"                 ItemID="MAT_ITEM"  runat="server" DataIndex="MAT_ITEM"   Width="120" Align="Left" Sortable="true" />                 <%--Text="자재품목"--%>  
                                <ext:Column ID="PARTNO"                   ItemID="PARTNO"    runat="server" DataIndex="PARTNO"     Width="120" Align="Left" Sortable="true" />      <%--Text="PART NO"--%>  
                                <ext:Column ID="PARTNM"                   ItemID="PARTNM"    runat="server" DataIndex="PARTNM"     MinWidth="150" Align="Left" Flex="1" Sortable="true"/>       <%--Text="PART NAME"--%>   
                                <ext:Column ID="STANDARD"                 ItemID="STANDARD"  runat="server" DataIndex="STANDARD"   Width="120" Align="Left" Sortable="true" Hidden="true"/>                  <%--Text="규격" --%>
                                <ext:Column ID="UNITNM"                   ItemID="UNIT"      runat="server" DataIndex="UNITNM"     Width="60" Align="Center" Sortable="true"/>                  <%--Text="단위"--%>      
                                <ext:NumberColumn ID="TOT_AMT"            ItemID="TOTAL_AMT" runat="server" DataIndex="TOT_AMT"    Width="120" Align="Right" Format="#,##0" Sortable="true"/>    <%--Text="합계금액"--%>     
                                                                                                                                                                                
                                <ext:Column ID="RCV"                      ItemID="RCV"       runat="server" ><%--Text="입고">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="RCV_QTY"    ItemID="QTY"       runat="server" DataIndex="RCV_QTY"    Width="70" Align="Right" Format="#,##0" Sortable="true" /><%--Text="수량"--%>      
                                        <ext:NumberColumn ID="RCV_UCOST"  ItemID="UCOST"     runat="server" DataIndex="RCV_UCOST"  Width="70" Align="Right" Format="#,##0" Sortable="true" /><%--Text="단가"--%>      
                                        <ext:NumberColumn ID="RCV_AMT"    ItemID="AMT"       runat="server" DataIndex="RCV_AMT"    Width="110" Align="Right" Format="#,##0" Sortable="true" /><%--Text="금액"--%>      
                                    </Columns>
                                </ext:Column>

                                <ext:Column ID="RTN"                      ItemID="RTN"       runat="server" ><%--Text="반품">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="RTN_QTY"    ItemID="QTY"       runat="server" DataIndex="RTN_QTY"    Width="70" Align="Right" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="RTN_UCOST"  ItemID="UCOST"     runat="server" DataIndex="RTN_UCOST"  Width="70" Align="Right" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="RTN_AMT"    ItemID="AMT"       runat="server" DataIndex="RTN_AMT"    Width="110" Align="Right" Format="#,##0" Sortable="true" />
                                    </Columns>
                                </ext:Column>

                                <ext:Column ID="SETTLE"                   ItemID="SETTLE"    runat="server" ><%--Text="단가정산">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="SETTLE_QTY" ItemID="QTY"       runat="server" DataIndex="SETTLE_QTY" Width="70" Align="Right" Format="#,##0" Sortable="true" />
                                        <ext:NumberColumn ID="SETTLE_AMT" ItemID="AMT"       runat="server" DataIndex="SETTLE_AMT" Width="110" Align="Right" Format="#,##0" Sortable="true" />
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
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>

                     <%-- 상세내역 그리드 --%>
                    <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." Hidden="true">
                        <Store>
                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="Model2" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="RCV_DATE"/>
                                            <ext:ModelField Name="MAT_TYPE" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="MAT_ITEM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="RCV_DIV" />
                                            <ext:ModelField Name="LV_DIV" />
                                            <ext:ModelField Name="JOB_TYPE" />
                                            <ext:ModelField Name="RCV_UCOST" />
                                            <ext:ModelField Name="RCV_QTY" />
                                            <ext:ModelField Name="RCV_AMT" />
                                            <ext:ModelField Name="RCVNO" />
                                            <ext:ModelField Name="DELI_DATE" />
                                            <ext:ModelField Name="DELI_CNT" />
                                            <ext:ModelField Name="DELI_QTY" />
                                            <ext:ModelField Name="YARDNM" />
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
                            <ext:BufferedRenderer ID="BufferedRenderer2"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel2" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="D_NO"           ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center" />
                                <ext:DateColumn ID="D_RCV_DATE"                ItemID="STD_DATE"  runat="server" DataIndex="RCV_DATE"   Width="80" Align="Center" />            <%--Text="기준일자"--%>  
                                <ext:Column ID="D_MAT_TYPE"                ItemID="MAT_TYPE"  runat="server" DataIndex="MAT_TYPE"   Width="60" Align="Center" />            <%--Text="자재유형"--%>  
                                <ext:Column ID="D_VINCD"                   ItemID="VIN"       runat="server" DataIndex="VINCD"      Width="50" Align="Center" />            <%--Text="차종"--%>      
                                <ext:Column ID="D_MAT_ITEM"                ItemID="MAT_ITEM"  runat="server" DataIndex="MAT_ITEM"   Width="120" Align="Left" />              <%--Text="자재품목"--%>  
                                <ext:Column ID="D_PARTNO"                  ItemID="PARTNO"    runat="server" DataIndex="PARTNO"     Width="120" Align="Left" /> <%--Text="PART NO" --%>  
                                <ext:Column ID="D_PARTNM"                  ItemID="PARTNM"    runat="server" DataIndex="PARTNM"     MinWidth="150" Align="Left"  Flex="1"/> <%--Text="PART NAME" --%>
                                <ext:Column ID="D_STANDARD"                ItemID="STANDARD"  runat="server" DataIndex="STANDARD"   Width="120" Align="Left"/>             <%--Text="규격"--%>      
                                <ext:Column ID="D_UNIT"                    ItemID="UNIT"      runat="server" DataIndex="UNIT"       Width="60" Align="Center"/>             <%--Text="단위"--%>      
                                <ext:Column ID="D_RCV_DIV"                 ItemID="RCV_DIV"   runat="server" DataIndex="RCV_DIV"    Width="60" Align="Center"/>             <%--Text="입고구분"--%>  
                                <ext:Column ID="D_LV_DIV"                  ItemID="ACP_DIV"   runat="server" DataIndex="LV_DIV"     Width="60" Align="Center"/>             <%--Text="검수구분"  --%>                              
                                <ext:Column ID="D_ACP_INFO"                ItemID="ACP_INFO"  runat="server" ><%--Text="검수정보">--%>
                                    <Columns>
                                        <ext:Column ID="D_JOB_TYPE"        ItemID="JOB_TYPE"  runat="server" DataIndex="JOB_TYPE"   Width="70" Align="Center" Sortable="true"/>                 <%--Text="업무"    --%>  
                                        <ext:NumberColumn ID="D_RCV_UCOST" ItemID="UCOST"     runat="server" DataIndex="RCV_UCOST"  Width="70" Align="Right" Format="#,##0" Sortable="true" />   <%--Text="단가" --%>     
                                        <ext:NumberColumn ID="D_RCV_QTY"   ItemID="QTY"       runat="server" DataIndex="RCV_QTY"    Width="70" Align="Right" Format="#,##0" Sortable="true" />   <%--Text="수량"--%>      
                                        <ext:NumberColumn ID="D_RCV_AMT"   ItemID="AMT"       runat="server" DataIndex="RCV_AMT"    Width="70" Align="Right" Format="#,##0"/>   <%--Text="금액"--%>      
                                        <ext:Column ID="D_RCVNO"           ItemID="ACPNO"     runat="server" DataIndex="RCVNO"      Width="70" Align="Center" Sortable="true"/>                 <%--Text="검수번호"--%>  
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D_DELI_INFO"               ItemID="DELI_INFO" runat="server" ><%--Text="납품정보">--%>
                                    <Columns>
                                        <ext:DateColumn ID="D_DELI_DATE"       ItemID="DD"        runat="server" DataIndex="DELI_DATE"  Width="80" Align="Center" Sortable="true"/>                 <%--Text="일자"--%>      
                                        <ext:NumberColumn ID="D_DELI_CNT"  ItemID="CHASU"     runat="server" DataIndex="DELI_CNT"   Width="70" Align="Right" Format="#,##0" Sortable="true"/>   <%--Text="차수"--%>      
                                        <ext:NumberColumn ID="D_DELI_QTY"  ItemID="QTY"       runat="server" DataIndex="DELI_QTY"   Width="70" Align="Right" Format="#,##0" Sortable="true"/>   <%--Text="수량"--%>      
                                        <ext:Column ID="D_YARDNM"          ItemID="MAT_YARD"  runat="server" DataIndex="YARDNM"     Width="90" Align="Left" Sortable="true"/>                   <%--Text="자재창고"--%>  
                                    </Columns>
                                </ext:Column>                             
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true">
                                
                            </ext:GridView>
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
