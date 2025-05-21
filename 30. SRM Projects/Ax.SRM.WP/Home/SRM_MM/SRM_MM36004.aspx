<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM36004.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM36004" %>
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
        var getRowClass = function (record) {
            if (record.data["SORT_SEQ"] == 0) {
                return "total_vendor";
            }
        }; 
    </script>
</head>
<body>
    <form id="SRM_MM36004" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM36004" runat="server" Cls="search_area_title_name" /><%--Text="일별 사급 현황" />--%>
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
                                <ext:Label ID="lbl01_STD_DATE" runat="server" />
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
                                <ext:Label ID="lbl01_MAT_ITEM" runat="server" />                    
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_MAT_ITEM" OnDirectEventChange="Button_Click" runat="server" ClassID="E0" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" />                               
                            </td>
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
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_SEARCH_OPT_Change" />
                                    </DirectEvents>
                                </ext:SelectBox>                            
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
                            <ext:Store ID="Store1" runat="server" PageSize="250">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="OUT_CNT" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="MIPV_DIV" />
                                            <ext:ModelField Name="MAT_ITEM" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="UNITNM" />                                           
                                            <ext:ModelField Name="OUT_QTY" />
                                            <ext:ModelField Name="YARDNM" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="DELI_DATE" />
                                            <ext:ModelField Name="DELI_CNT" />
                                            <ext:ModelField Name="ARRIV_DATE" />
                                            <ext:ModelField Name="SORT_SEQ" />
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
                                <ext:Column ID="OUT_CNT" ItemID="OUT_CNT" runat="server" DataIndex="OUT_CNT"  Width="60" Align="Center"  /><%--Text="출고차수"  --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left"  /> <%--Text="PART NO"--%>  
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="150" Align="Left" Flex="1"/> <%--Text="PART NAME"--%>   
                                <ext:Column ID="MIPV_DIV" ItemID="MIPV_DIV" runat="server" DataIndex="MIPV_DIV" Width="80" Align="Center"/> <%--Text="내외작구분"--%>   
                                <ext:Column ID="MAT_ITEM" ItemID="MAT_ITEM" runat="server" DataIndex="MAT_ITEM" Width="120" Align="Left" /><%--Text="자재품목"  --%>
                                <ext:Column ID="STANDARD" ItemID="STANDARD" runat="server" DataIndex="STANDARD" MinWidth="100" Align="Left" Flex="1"/> <%--Text="규격" --%>
                                <ext:Column ID="UNITNM" ItemID="UNIT" runat="server" DataIndex="UNITNM" Width="60" Align="Center"/> <%--Text="단위"--%>      
                                <ext:NumberColumn ID="OUT_QTY" ItemID="OUT_QTY" runat="server" DataIndex="OUT_QTY" Width="110" Align="Right" Format="#,##0"/> <%--Text="출고수량"--%>     
                                <ext:Column ID="YARDNM" ItemID="OUT_YARD" runat="server" DataIndex="YARDNM" Width="90" Align="Left" /><%--Text="출고창고"      --%>
                                <ext:Column ID="VENDNM" ItemID="RECEIVE_VEND_NM" runat="server" DataIndex="VENDNM" Width="120" Align="Left" /><%--Text="납품업체"   --%>
                                <ext:DateColumn ID="DELI_DATE" ItemID="DELIVERYDATE" runat="server" DataIndex="DELI_DATE" Width="80" Align="Center" />  <%--Text="납품일자"--%> 
                                <ext:Column ID="DELI_CNT" ItemID="DELI_CNT" runat="server" DataIndex="DELI_CNT"  Width="60" Align="Center" /><%--Text="납품차수"  --%>
                                <ext:DateColumn ID="ARRIV_DATE" ItemID="ARVALDATE" runat="server" DataIndex="ARRIV_DATE" Width="80" Align="Center" />  <%--Text="도착일자"--%> 
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
                            <ext:Store ID="Store2" runat="server" PageSize="250">
                                <Model>
                                    <ext:Model ID="Model2" runat="server">
                                        <Fields>                                            
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="MAT_ITEM"/>
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="UNITNM" />
                                            <ext:ModelField Name="OUT_DATE" />
                                            <ext:ModelField Name="OUT_CNT" />
                                            <ext:ModelField Name="OUT_QTY" />
                                            <ext:ModelField Name="SETTLE_OUT_DATE" />
                                            <ext:ModelField Name="SETTLE_OUT_QTY" />
                                            <ext:ModelField Name="SETTLE_OUT_UCOST" />
                                            <ext:ModelField Name="SETTLE_OUT_AMT" />
                                            <ext:ModelField Name="SORT_SEQ" />
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
                                <ext:RowNumbererColumn ID="D_NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:Column ID="D_PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /> <%--Text="PART NO" --%>  
                                <ext:Column ID="D_PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="150" Align="Left" Flex="1"/> <%--Text="PART NAME" --%>
                                <ext:Column ID="D_MAT_ITEM" ItemID="MAT_ITEM" runat="server" DataIndex="MAT_ITEM" Width="120" Align="Left" /><%--Text="자재품목"--%>  
                                <ext:Column ID="D_STANDARD" ItemID="STANDARD" runat="server" DataIndex="STANDARD" MinWidth="120" Align="Left" Flex="1"/><%--Text="규격"--%>      
                                <ext:Column ID="D_UNITNM" ItemID="UNIT" runat="server" DataIndex="UNITNM" Width="60" Align="Center"/> <%--Text="단위"--%>
                                <ext:Column ID="D_OUT_INFO" ItemID="OUT_INFO" runat="server" ><%--Text="출고정보">--%>
                                    <Columns>
                                        <ext:DateColumn ID="D_OUT_DATE" ItemID="OUT_DATE" runat="server" DataIndex="OUT_DATE"  Width="80" Align="Center"/><%--Text="출고일자"--%>      
                                        <ext:NumberColumn ID="D_OUT_CNT" ItemID="OUT_CNT" runat="server" DataIndex="OUT_CNT" Width="110" Align="Right" Format="#,##0"/> <%--Text="출고차수"--%>      
                                        <ext:NumberColumn ID="D_OUT_QTY" ItemID="OUT_QTY" runat="server" DataIndex="OUT_QTY" Width="110" Align="Right" Format="#,##0"/> <%--Text="출고수량"--%>      
                                    </Columns>
                                </ext:Column>      
                                <ext:Column ID="D_ACP_INFO" ItemID="ACP_INFO"  runat="server" ><%--Text="검수정보">--%>
                                    <Columns>
                                        <ext:DateColumn ID="D_SETTLE_OUT_DATE" ItemID="ACP_DATE" runat="server" DataIndex="SETTLE_OUT_DATE" Width="80" Align="Center"/><%--Text="검수일자"    --%>  
                                        <ext:NumberColumn ID="D_SETTLE_OUT_QTY" ItemID="ACP_QTY" runat="server" DataIndex="SETTLE_OUT_QTY" Width="110" Align="Right" Format="#,##0"/><%--Text="검수수량" --%>     
                                        <ext:NumberColumn ID="D_SETTLE_OUT_UCOST" ItemID="UCOST" runat="server" DataIndex="SETTLE_OUT_UCOST" Width="110" Align="Right" Format="#,##0"/><%--Text="단가"--%>      
                                        <ext:NumberColumn ID="D_SETTLE_OUT_AMT" ItemID="AMT" runat="server" DataIndex="SETTLE_OUT_AMT" Width="110" Align="Right" Format="#,##0"/><%--Text="금액"--%>      
                                    </Columns>
                                </ext:Column>
                                
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true">
                                <GetRowClass Fn="getRowClass" />
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
