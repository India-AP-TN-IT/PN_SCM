<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM32006.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM32006" %>
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
    <form id="SRM_MM32006" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM32006" runat="server" Cls="search_area_title_name" /><%--Text="가입하 정보 조회" />--%>
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
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="BIZCDTYPE" ValueField="BIZCD" TriggerAction="All" Width="150">
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
                                <ext:Label ID="lbl01_DELIVERYDATE" runat="server" /><%--Text="납품일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_DELI_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />                                
                            </td>
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" />     
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_DELI_CNT" runat="server" /><%--Text="납품차수" /> --%>                      
                            </th>
                            <td colspan="3">
                                <ext:FieldContainer ID="FieldContainer3" runat="server" MsgTarget="Side" Flex="1" Width="50" Layout="TableLayout">
                                    <Items>
                                        <ext:TextField ID="txt01_DELI_CNT" Width="50" Cls="inputText" runat="server" />
                                        <ext:Label ID="lbl01_CHA" runat="server" />
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
                                            <ext:ModelField Name="DELI_CNT" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="UNITNM" />
                                            <ext:ModelField Name="YARDNM" />
                                            <ext:ModelField Name="ARRIV_TIME" />
                                            <ext:ModelField Name="NOTENO" />
                                            <ext:ModelField Name="DELI_QTY" />
                                            <ext:ModelField Name="TEMP_ARRIV_DATE" />
                                            <ext:ModelField Name="TEMP_ARRIV_TIME" />
                                            <ext:ModelField Name="TEMP_ARRIV_QTY" />
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
                                <ext:Column ID="VENDCD" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="70"  Align="Center" />
                                <ext:Column ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="100"  Align="Left" />
                                <ext:Column ID="DELI_CNT" ItemID="DELI_CNT" runat="server" DataIndex="DELI_CNT"  Width="70" Align="Center"  /><%--Text="납품차수"  --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left"  /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME" --%>
                                <ext:Column ID="STANDARD" ItemID="STANDARD" runat="server" DataIndex="STANDARD" MinWidth="100" Align="Left" Flex="1"/> <%--Text="규격" --%>
                                <ext:Column ID="UNITNM" ItemID="UNIT" runat="server" DataIndex="UNITNM" Width="60" Align="Center"/> <%--Text="단위"--%>   
                                <ext:Column ID="YARDNM" ItemID="MAT_YARD" runat="server" DataIndex="YARDNM" Width="120" Align="Left" /><%--Text="자재창고"      --%>
                                <ext:Column ID="DELI_INFO" ItemID="DELI_INFO" runat="server" ><%--Text="납품정보">--%>
                                    <Columns>
                                        <ext:Column ID="ARRIV_TIME" ItemID="SHIP_TIME" runat="server" DataIndex="ARRIV_TIME"  Width="70" Align="Center"  Sortable="true" /><%--Text="출하시간"  --%>
                                        <ext:Column ID="NOTENO" ItemID="NOTENO" runat="server" DataIndex="NOTENO" Width="150" Align="Center" Sortable="true"/><%--Text="전표번호"    --%>
                                        <ext:NumberColumn ID="DELI_QTY" ItemID="DELI_QTY" runat="server" DataIndex="DELI_QTY" Width="80" Align="Right" Format="#,##0" Sortable="true"/> <%--Text="납품수량"--%>
                                    </Columns>
                                </ext:Column>   
                                <ext:Column ID="TEMP_ARRIVE_INFO" ItemID="TEMP_ARRIVE_INFO" runat="server" ><%--Text="수량정보">--%>
                                    <Columns> 
                                        <ext:DateColumn ID="TEMP_ARRIV_DATE" ItemID="TEMP_ARRIV_DATE" runat="server" DataIndex="TEMP_ARRIV_DATE"  Width="100" Align="Center"  Sortable="true" /><%--가입하일자--%>
                                        <ext:Column ID="TEMP_ARRIV_TIME" ItemID="TEMP_ARRIV_TIME" runat="server" DataIndex="TEMP_ARRIV_TIME"  Width="100" Align="Center"  Sortable="true" /><%--가입하시간--%>
                                        <ext:NumberColumn ID="TEMP_ARRIV_QTY" ItemID="TEMP_ARRIV_QTY" runat="server" DataIndex="TEMP_ARRIV_QTY" Width="80" Align="Right" Format="#,##0" Sortable="true"/><%--가입하수량--%>
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
