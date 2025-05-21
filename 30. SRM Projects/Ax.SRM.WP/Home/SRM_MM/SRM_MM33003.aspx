<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM33003.aspx.cs" Inherits="HE.SCM.WP.Home.SCM_MM.SRM_MM33003" %>
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
                    <ext:Label ID="lbl01_SRM_MM33003" runat="server" Cls="search_area_title_name" /><%--Text="납품전표 검수 실적" />--%>
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
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
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
                                <ext:Label ID="lbl01_ARRIV_YYMM" runat="server" /><%--Text="입하년월" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_ARRIV_DATE" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />                                
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">         
                                <ext:Label ID="lbl01_DELIVERYDATE" runat="server" /><!-- 납품일자 -->     
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer2" runat="server" Width="250" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:DateField ID="df01_FROM_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                        <ext:DisplayField ID="DisplayField1" Width="20"  Flex="1" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:DateField ID="df01_TO_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                            <th>                                
                                <ext:Label ID="lbl01_MAT_TYPE" runat="server" /><!-- 자재유형 -->
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_MAT_TYPE" runat="server"  Mode="Local" ForceSelection="true"
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
                                <ext:Label ID="lbl01_ACP_YYMM" runat="server" /><%--Text="검수년월" /> --%>                      
                            </th>
                            <td>
                                <ext:DateField ID="df01_RCV_DATE" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   /> 
                            </td>                            
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                       
                            </th>
                            <td colspan="5">
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" />     
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
                                            <ext:ModelField Name="DELI_DATE" />
                                            <ext:ModelField Name="DELI_CNT" />
                                            <ext:ModelField Name="MAT_TYPE" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="DELI_QTY" />
                                            <ext:ModelField Name="ARRIV_DATE" />
                                            <ext:ModelField Name="DEF_QTY" />
                                            <ext:ModelField Name="ARRIV_QTY" />
                                            <ext:ModelField Name="LV_DIV" />
                                            <ext:ModelField Name="RCV_DATE" />
                                            <ext:ModelField Name="RCV_QTY" />
                                            <ext:ModelField Name="RCV_UCOST" />
                                            <ext:ModelField Name="RCV_AMT" />
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
                                <ext:DateColumn ID="DELI_DATE" ItemID="DELIVERYDATE" runat="server" DataIndex="DELI_DATE" Width="80" Align="Center" />  <%--Text="납품일자"--%> 
                                <ext:Column ID="DELI_CNT" ItemID="DELI_CNT" runat="server" DataIndex="DELI_CNT"  Width="60" Align="Center" /><%--Text="납품차수"  --%>
                                <ext:Column ID="MAT_TYPE" ItemID="MAT_TYPE" runat="server" DataIndex="MAT_TYPE" Width="70" Align="Center" /><%--Text="자재유형"      --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME" --%>
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="60" Align="Center"/><%--Text="단위"--%>
                                <ext:NumberColumn ID="DELI_QTY" ItemID="DELI_QTY" runat="server" DataIndex="DELI_QTY" Width="80" Align="Right" Format="#,##0"/><%--Text="납품수량"--%>
                                <ext:Column ID="ARRIVE_INFO" ItemID="ARRIVE_INFO" runat="server" ><%--Text="입하정보">--%>
                                    <Columns>
                                        <ext:DateColumn ID="ARRIV_DATE" ItemID="ARRIV_DATE" runat="server" DataIndex="ARRIV_DATE" Width="80" Align="Center" Sortable="true"/><%--Text="입하일자"--%> 
                                        <ext:NumberColumn ID="DEF_QTY" ItemID="DEF_GAP_QTY" runat="server" DataIndex="DEF_QTY" Width="70" Align="Right" Format="#,##0" Sortable="true"/><%--불량+차이--%>
                                        <ext:NumberColumn ID="ARRIV_QTY" ItemID="OK_QTY" runat="server" DataIndex="ARRIV_QTY" Width="80" Align="Right" Format="#,##0" Sortable="true"/><%--Text="합격수량"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="ACP_INFO" ItemID="ACP_INFO" runat="server" ><%--Text="검수정보">--%>
                                    <Columns>
                                        <ext:Column ID="LV_DIV" ItemID="ACP_DIV" runat="server" DataIndex="LV_DIV"  Width="60" Align="Center" Sortable="true" /><%--Text="검수구분"  --%>
                                        <ext:DateColumn ID="RCV_DATE" ItemID="ACP_DATE" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" Sortable="true" /><%--Text="검수일자"--%> 
                                        <ext:NumberColumn ID="RCV_QTY" ItemID="RCV_QTY" runat="server" DataIndex="RCV_QTY" Width="70" Align="Right" Format="#,##0" Sortable="true"/><%--입고수량--%>
                                        <ext:NumberColumn ID="RCV_UCOST" ItemID="RCV_UCOST" runat="server" DataIndex="RCV_UCOST" Width="80" Align="Right" Format="#,##0" Sortable="true"/>  <%--Text="입고단가"--%> 
                                        <ext:NumberColumn ID="RCV_AMT" ItemID="RCV_AMT" runat="server" DataIndex="RCV_AMT" Width="100" Align="Right" Format="#,##0" Sortable="true"/>  <%--Text="입고금액"--%> 
                                    </Columns>
                                </ext:Column>                                
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
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
