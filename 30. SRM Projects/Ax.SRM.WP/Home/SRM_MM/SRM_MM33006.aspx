<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM33006.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM33006" %>
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
                    <ext:Label ID="lbl01_SRM_MM33006" runat="server" Cls="search_area_title_name" />
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
                                            <ext:ModelField Name="MAT_TYPE" />
                                            <ext:ModelField Name="PARTNO" />                                            
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="MAT_LC_QTY" />
                                            <ext:ModelField Name="JOB_TYPE" />
                                            <ext:ModelField Name="RCV_UCOST" />
                                            <ext:ModelField Name="RCV_QTY" />
                                            <ext:ModelField Name="RCV_AMT" />
                                            <ext:ModelField Name="MAT_RCV_QTY" />
                                            <ext:ModelField Name="MAT_RCV_AMT" />
                                            <ext:ModelField Name="GAP_QTY" />
                                            <ext:ModelField Name="CORCD" />
                                            <ext:ModelField Name="BIZCD" />
                                            <ext:ModelField Name="VENDCD" />                                                                                  
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
                                <ext:Column ID="VENDNM" ItemID="VENDORNM" runat="server" DataIndex="VENDNM" Width="180" Align="Left"  /><%--Text="거래처명"  --%>
                                <ext:Column ID="DUTY_MAT_INFO" ItemID="DUTY_MAT_INFO" runat="server" >
                                    <Columns>
                                        <ext:Column ID="MAT_TYPE" ItemID="MAT_TYPE" runat="server" DataIndex="MAT_TYPE" Width="60" Align="Center"  /><%--Text="자재유형"  --%>
                                        <ext:Column ID="PARTNO" ItemID="SUBCON_PNO" runat="server" DataIndex="PARTNO" Width="130" Align="Left"  /><%--Text="외작 PART NO"   --%>
                                        <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="220" Align="Left" Flex="1"/><%--Text="PART NAME" --%>                                        
                                        <ext:NumberColumn ID="MAT_LC_QTY" ItemID="MAT_LC_QTY" runat="server" DataIndex="MAT_LC_QTY" Width="90" Align="Right" Format="#,##0"/><%--Text="환급대상량"--%>  
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="RCV_UCOST_INFO" ItemID="RCV_UCOST" runat="server" >
                                    <Columns>                                                                                                              
                                        <ext:Column ID="JOB_TYPE" ItemID="JOB_TYPE" runat="server" DataIndex="JOB_TYPE" Width="60" Align="Center"  /><%--Text="업무유형"  --%>
                                        <ext:NumberColumn ID="RCV_UCOST" ItemID="MAT_RCV_UCOST" runat="server" DataIndex="RCV_UCOST" Width="90" Align="Right" Format="#,##0"/><%--Text="자재단가"--%>                                
                                    </Columns>
                                </ext:Column>  
                                <ext:Column ID="MAT_RCV_INFO_LV_DIV" ItemID="MAT_RCV_INFO_LV_DIV" runat="server" >
                                    <Columns> 
                                        <ext:NumberColumn ID="RCV_QTY" ItemID="RCV_QTY" runat="server" DataIndex="RCV_QTY" Width="70" Align="Right" Format="#,##0"/><%--Text="입고수량"--%>                                
                                        <ext:NumberColumn ID="RCV_AMT" ItemID="RCV_AMT" runat="server" DataIndex="RCV_AMT" Width="100" Align="Right" Format="#,##0"/><%--Text="입고금액"--%>                                
                                    </Columns>
                                </ext:Column>                                
                                <ext:Column ID="DUTY_RCV_INFO_LV_DIV" ItemID="DUTY_RCV_INFO_LV_DIV" runat="server" >
                                    <Columns> 
                                        <ext:NumberColumn ID="MAT_RCV_QTY" ItemID="EXP_QTY" runat="server" DataIndex="MAT_RCV_QTY" Width="70" Align="Right" Format="#,##0"/><%--Text="수출수량"--%>                                
                                        <ext:NumberColumn ID="MAT_RCV_AMT" ItemID="EXP_AMT" runat="server" DataIndex="MAT_RCV_AMT" Width="100" Align="Right" Format="#,##0"/><%--Text="수출금액"--%>                                
                                    </Columns>
                                </ext:Column> 
                                <ext:Column ID="NON_REFLECT_QTY" ItemID="NON_REFLECT_QTY" runat="server" >
                                    <Columns> 
                                        <ext:NumberColumn ID="GAP_QTY" ItemID="LC_EXP" runat="server" DataIndex="GAP_QTY" Width="100" Align="Right" Format="#,##0"/><%--Text="환급-수출"--%>                                
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
