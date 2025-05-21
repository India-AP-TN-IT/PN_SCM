<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM33004.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM33004" %>
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
            if (record.data["COLOR"] == 1) {
                return "total_vendor";
            }
            else if (record.data["COLOR"] == 2) {
                return "sub_total-reportno";
            }
            else if (record.data["COLOR"] == 3) {
                return "total-reportno";
            }
        };        
    </script>
</head>
<body>
    <form id="SRM_MM33003" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM33004" runat="server" Cls="search_area_title_name" /><%--Text="단가정산 조회" />--%>
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
                                <ext:Label ID="lbl01_VEND_DIV" runat="server" /><%--Text="업체구분" />--%>
                            </th>
                            <td colspan="8">
                                <ext:RadioGroup ID="RadioGroup1" runat="server" Width="200" Cls="inputText" ColumnsWidths="100,100">
                                    <Items>
                                        <ext:Radio ID="rdo01_OPT11" Cls="inputText" runat="server" InputValue="1" Checked="true" />
                                        <ext:Radio ID="rdo01_OPT12" Cls="inputText" runat="server" InputValue="2" Visible="false" />
                                    </Items>       
                                    <Listeners>
                                        <Change Handler="App.direct.SetCustVendVisible(this.getChecked()[0].inputValue.toString());"  Delay="500"/>
                                    </Listeners>                             
                                </ext:RadioGroup>
                            </td>
                        </tr>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_CUST" runat="server" />
                                <ext:Label ID="lbl01_VEND" runat="server" Hidden="true" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD_FIX" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>   
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" />
                            </th>
                            <td colspan="3">
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
                                <ext:Label ID="lbl01_SETTLE_DATE2" runat="server" /><!-- 소급일자 -->     
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer2" runat="server" Width="250" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:DateField ID="df01_FROM_DATE" Width="115"  Cls="inputDate" Type="Month" Format="yyyy-MM"  runat="server" Editable="true"  />
                                        <ext:DisplayField ID="DisplayField1" Width="20"  Flex="1" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:DateField ID="df01_TO_DATE" Width="115"  Cls="inputDate" Type="Month" Format="yyyy-MM" runat="server" Editable="true"  />
                                    </Items>
                                </ext:FieldContainer>
                            </td>                                              
                        </tr> 
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO" runat="server" />                       
                            </th>  
                            <td colspan="8">
                                <ext:TextField ID="txt01_PARTNO" Width="250" Cls="inputText" runat="server" />     
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
                                            <ext:ModelField Name="CORCD" />
                                            <ext:ModelField Name="BIZCD" />
                                            <ext:ModelField Name="VENDORCD" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="REPORT_NO" />
                                            <ext:ModelField Name="COLOR" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="BEG_DATE" />
                                            <ext:ModelField Name="END_DATE" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="SETTLE_QTY" />
                                            <ext:ModelField Name="OLD_PART_UCOST" />
                                            <ext:ModelField Name="NEW_PART_UCOST" />
                                            <ext:ModelField Name="PART_GAP_UCOST" />
                                            <ext:ModelField Name="SETTLE_AMT" />
                                            <ext:ModelField Name="APP_YM" />                                            
                                            <ext:ModelField Name="REPORT_REASON" />
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
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" ><%--Text="PART NO"   --%>
                                    <%--<Renderer Fn="change"></Renderer>--%>
                                </ext:Column>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="250" Align="Left" /><%--Text="PART NAME" --%>
                                <ext:Column ID="VINCD"  ItemID="VINTYPE" runat="server" DataIndex="VINCD"  Width="60" Align="Center" /><%--Text="차종"  --%>
                                <ext:Column ID="ACP_TERM" ItemID="ACP_TERM" runat="server" ><%--Text="검수기간">--%>
                                    <Columns>
                                        <ext:DateColumn ID="BEG_DATE" ItemID="BEG_DATE" runat="server" DataIndex="BEG_DATE" Width="80" Align="Center" />  <%--Text="시작일"--%> 
                                        <ext:DateColumn ID="END_DATE" ItemID="END_DATE6" runat="server" DataIndex="END_DATE" Width="80" Align="Center" />  <%--Text="종료일"--%> 
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="60" Align="Center"/><%--Text="단위"--%>
                                <ext:NumberColumn ID="SETTLE_QTY" ItemID="SETTLE_QTY" runat="server" DataIndex="SETTLE_QTY" Width="80" Align="Right" Format="#,##0"/><%--Text="소급수량"--%>
                                <ext:NumberColumn ID="OLD_UCOST" ItemID="OLD_UCOST" runat="server" DataIndex="OLD_PART_UCOST" Width="80" Align="Right" Format="#,##0"/><%--Text="기존단가"--%>
                                <ext:NumberColumn ID="SD20501_TPG3" ItemID="SD20501_TPG3" runat="server" DataIndex="NEW_PART_UCOST" Width="80" Align="Right" Format="#,##0"/><%--Text="결정단가"--%>
                                <ext:NumberColumn ID="DIFFUCOST2" ItemID="DIFFUCOST2" runat="server" DataIndex="PART_GAP_UCOST" Width="80" Align="Right" Format="#,##0"/><%--Text="차액단가"--%>
                                <ext:NumberColumn ID="SETAMT" ItemID="SETAMT" runat="server" DataIndex="SETTLE_AMT" Width="80" Align="Right" Format="#,##0"/><%--Text="소급금액"--%>
                                <ext:DateColumn ID="RETROYYMM2" ItemID="RETROYYMM2" runat="server" DataIndex="APP_YM" Width="80" Align="Center" Format="yyyy-MM" />  <%--Text="소급적용년월"--%> 
                                <ext:Column ID="REMARK" ItemID="REMARK" runat="server" DataIndex="REPORT_REASON" MinWidth="180" Align="Left" Flex="1"/><%--Text="비고" --%>                            
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

                </Items>
            </ext:Panel>                 
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
