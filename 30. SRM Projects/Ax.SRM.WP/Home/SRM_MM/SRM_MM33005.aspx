<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM33005.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM33005" %>
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

        var getRowClass = function (record) {
            if (record.data["COLS"] == 2) {
                return "total_vendor";
            } else if (record.data["COLS"] == 1) {
                return "sub_total-reportno";
            }
        }; 

    </script>
</head>
<body>
    <form id="SRM_MM33002" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM33005" runat="server" Cls="search_area_title_name" />
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
                            <th >
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
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
                                <ext:Label ID="lbl01_STD_YYMM" runat="server" /><%--Text="기준년월" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_CLS_YYMM" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true" />                                
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
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="DOM_DIV" />                                            
                                            <ext:ModelField Name="PARTNO1" />
                                            <ext:ModelField Name="UCOST" />
                                            <ext:ModelField Name="RCV_QTY" />
                                            <ext:ModelField Name="RCV_AMT" />
                                            <ext:ModelField Name="RCVNO" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="JOB_TYPE" />
                                            <ext:ModelField Name="PARTNO2" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="CLS_QTY" />
                                            <ext:ModelField Name="COINCD" />
                                            <ext:ModelField Name="RECEIPT_UCOSTNO" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="COLS" />                                            
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
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center"  />
                                <ext:Column ID="VENDNM" ItemID="PROD_VENDOR" runat="server" DataIndex="VENDNM" Width="180" Align="Left"  /><%--Text="거래처"  --%>
                                <ext:Column ID="RCV_MAT_INFO" ItemID="RCV_MAT_INFO" runat="server" >
                                    <Columns>
                                        <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="50" Align="Center"  /><%--Text="차종"  --%>
                                        <ext:Column ID="DOM_DIV" ItemID="LV_DIV" runat="server" DataIndex="DOM_DIV" Width="60" Align="Center"  /><%--Text="내수/수출 구분"  --%>
                                        <ext:Column ID="PARTNO1" ItemID="SUBCON_PNO" runat="server" DataIndex="PARTNO1" Width="130" Align="Left"  /><%--Text="외작 PART NO"   --%>
                                        <ext:NumberColumn ID="UCOST" ItemID="PURCFUCOST" runat="server" DataIndex="UCOST" Width="70" Align="Right" Format="#,##0"/><%--Text="매입단가"--%>                                
                                        <ext:NumberColumn ID="RCV_QTY" ItemID="RCV_QTY" runat="server" DataIndex="RCV_QTY" Width="70" Align="Right" Format="#,##0"/><%--Text="입고수량"--%>                                
                                        <ext:NumberColumn ID="RCV_AMT" ItemID="RCV_AMT" runat="server" DataIndex="RCV_AMT" Width="100" Align="Right" Format="#,##0"/><%--Text="입고금액"--%>                                
                                        <ext:NumberColumn ID="RCVNO" ItemID="RCVNO" runat="server" DataIndex="RCVNO" Width="150" Align="Center" Format="###0"/><%--Text="입고번호"--%>  
                                    </Columns>
                                </ext:Column>                         
                                <ext:Column ID="CUST_CLS_INFO" ItemID="CUST_CLS_INFO" runat="server" >
                                    <Columns>     
                                        <ext:Column ID="CUSTNM" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="180" Align="Left"  /><%--Text="고객사"  --%>
                                        <ext:Column ID="JOB_TYPE" ItemID="JOB_TYPE" runat="server" DataIndex="JOB_TYPE" Width="60" Align="Center"  /><%--Text="업무유형"  --%>
                                        <ext:Column ID="PARTNO2" ItemID="ASSY_PNO" runat="server" DataIndex="PARTNO2" Width="130" Align="Left"  /><%--Text="제품 P/NO"   --%>
                                        <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME" --%>
                                        <ext:Column ID="STANDARD" ItemID="STANDARD"  runat="server" DataIndex="STANDARD" Width="120" Align="Left"/><%--Text="규격"      --%>
                                        <ext:Column ID="UNIT" ItemID="UNITNM" runat="server" DataIndex="UNIT" Width="60" Align="Center"/><%--Text="단위"--%>
                                        <ext:NumberColumn ID="CLS_QTY" ItemID="ACP_QTY" runat="server" DataIndex="CLS_QTY" Width="70" Align="Right" Format="#,##0"/><%--Text="검수수량"--%> 
                                    </Columns>
                                </ext:Column>    
                                <ext:Column ID="COINCD" ItemID="COINCD" runat="server" DataIndex="COINCD" Width="80" Align="Center"/><%--Text="통화코드"--%>
                                <ext:NumberColumn ID="RECEIPT_UCOSTNO" ItemID="RECEIPT_UCOSTNO" runat="server" DataIndex="RECEIPT_UCOSTNO" Width="150" Align="Center" Format="###0"/><%--Text="매입단가번호"--%>                                
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
                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single">                                
                            </ext:RowSelectionModel>
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
