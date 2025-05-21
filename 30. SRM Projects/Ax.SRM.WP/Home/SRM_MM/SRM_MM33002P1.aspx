<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM33002P1.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM33002P1" %>
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

    <title>Popup</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
            App.Grid02.setHeight(App.GridPanel.getHeight());
            App.Grid03.setHeight(App.GridPanel.getHeight());
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
    <form id="SRM_MM33002P1" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM33002P1" runat="server" Cls="search_area_title_name" /><%--Text="월별/일별 상세조회" />--%>
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
                            <col style="width: 60px;" />
                            <col style="width: 100px;" />
                            <col style="width: 100px;" />
                            <col style="width: 100px;" />
                            <col />
                        </colgroup>                        
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_MAT_TYPE" runat="server" /><%--Text="자재유형" /> --%>                      
                            </th>
                            <td>
                                <ext:Label ID="MAT_TYPE" runat="server" />
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO" runat="server" /><%--Text="PART NO" /> --%>                      
                            </th>
                            <td>
                                <ext:Label ID="PARTNO" runat="server" />
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNM" runat="server" /><%--Text="PART NAME" /> --%>                      
                            </th>
                            <td>
                                <ext:Label ID="PARTNM" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_UNIT" runat="server" /><%--Text="단위" /> --%>                      
                            </th>
                            <td>
                                <ext:Label ID="UNITNM" runat="server" />
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_UCOST" runat="server" /><%--Text="단가" /> --%>                      
                            </th>
                            <td style="text-align:right;">
                                <ext:Label ID="UCOST" Width="100" runat="server" />
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_STANDARD" runat="server" /><%--Text="규격" /> --%>                      
                            </th>
                            <td>
                                <ext:Label ID="STANDARD" runat="server" />
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
                                            <ext:ModelField Name="DIV"/>
                                            <ext:ModelField Name="RCV_DATE"/>
                                            <ext:ModelField Name="NOTENO"/>
                                            <ext:ModelField Name="LOTNO"/>
                                            <ext:ModelField Name="RCV_QTY"/>
                                            <ext:ModelField Name="RCV_UCOST"/>
                                            <ext:ModelField Name="RCV_AMT"/>
                                            <ext:ModelField Name="DELI_DATE"/>
                                            <ext:ModelField Name="DELI_CNT"/>
                                            <ext:ModelField Name="PONO"/>
                                            <ext:ModelField Name="ORDNO"/>
                                            <ext:ModelField Name="YARDNM"/>
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
                                <ext:Column ID="DIV" ItemID="RCV_DIV" runat="server" DataIndex="DIV" Width="70" Align="Center"/><%--Text="입고구분"    --%>
                                <ext:DateColumn ID="RCV_DATE" ItemID="ACP_DATE" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" />  <%--Text="검수일자"--%> 
                                <ext:Column ID="NOTENO" ItemID="NOTENO" runat="server" DataIndex="NOTENO" Width="70" Align="Center"/><%--Text="전표번호"    --%> 
                                <ext:Column ID="LOTNO" ItemID="LOTNO" runat="server" DataIndex="LOTNO" Width="70" Align="Center" />  <%--Text="LOT NO"--%> 
                                <ext:NumberColumn ID="RCV_QTY" ItemID="RCV_QTY" runat="server" DataIndex="RCV_QTY" Width="80" Align="Right" Format="#,##0.###"/> <%--Text="입고수량"--%>  
                                <ext:NumberColumn ID="RCV_UCOST" ItemID="UCOST" runat="server" DataIndex="RCV_UCOST" Width="80" Align="Right" Format="#,##0.##"/> <%--Text="단가"--%>  
                                <ext:NumberColumn ID="RCV_AMT" ItemID="RCV_AMT" runat="server" DataIndex="RCV_AMT" Width="80" Align="Right" Format="#,##0.##"/> <%--Text="입고금액"--%>
                                <ext:DateColumn ID="DELI_DATE" ItemID="DELIVERYDATE" runat="server" DataIndex="DELI_DATE" Width="80" Align="Center" />  <%--Text="납품일자"--%> 
                                <ext:Column ID="DELI_CNT" ItemID="DELI_CNT" runat="server" DataIndex="DELI_CNT"  Width="60" Align="Center" /><%--Text="납품차수"  --%>  
                                <ext:Column ID="PONO" ItemID="PONO" runat="server" DataIndex="PONO" MinWidth="120" Align="Center" Flex="1"/><%--Text="납품번호"      --%>
                                <ext:Column ID="ORDNO" ItemID="ORDNO" runat="server" DataIndex="ORDNO" Width="120" Align="Center" /><%--Text="고객수주번호"      --%>
                                <ext:Column ID="YARDNM" ItemID="MAT_YARD" runat="server" DataIndex="YARDNM" Width="90" Align="Left" /><%--Text="자재창고"      --%>                                
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
                    <%--반품내용 그리드--%>
                    <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." Hidden="true">
                        <Store>
                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="Model2" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="RTN_DATE"/>
                                            <ext:ModelField Name="RTN_CNT"/>
                                            <ext:ModelField Name="RTN_DIV"/>
                                            <ext:ModelField Name="RTN_QTY"/>
                                            <ext:ModelField Name="RTN_UCOST"/>
                                            <ext:ModelField Name="RTN_AMT"/>                                            
                                            <ext:ModelField Name="SETTLE_RTN_UCOST"/>
                                            <ext:ModelField Name="SETTLE_RTN_AMT"/>
                                            <ext:ModelField Name="YARDNM"/>
                                        </Fields>
                                    </ext:Model>
                                </Model>
                                <Listeners>
                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                    <Load Delay="1" Handler="GridStoreReady(App.StatusBar2, this.getTotalCount());  "></Load>
                                </Listeners>
                            </ext:Store>
                        </Store>
                        <Plugins>
                            <ext:BufferedRenderer ID="BufferedRenderer2"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel2" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="R_NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:DateColumn ID="R_RTN_DATE" ItemID="RTN_DATE" runat="server" DataIndex="RTN_DATE" Width="80" Align="Center" />  <%--Text="반품일자"--%> 
                                <ext:Column ID="R_RTN_CNT" ItemID="RTN_CNT" runat="server" DataIndex="RTN_CNT"  Width="60" Align="Center" /><%--Text="반품차수"  --%>  
                                <ext:Column ID="R_RTN_DIV" ItemID="RTN_DIV" runat="server" DataIndex="RTN_DIV" Width="70" Align="Center"/><%--Text="반품구분"    --%>
                                <ext:NumberColumn ID="R_RTN_QTY" ItemID="RTN_QTY" runat="server" DataIndex="RTN_QTY" Width="80" Align="Right" Format="#,##0.###"/> <%--Text="반품수량"--%>  
                                <ext:NumberColumn ID="R_SETTLE_RTN_UCOST" ItemID="UCOST" runat="server" DataIndex="SETTLE_RTN_UCOST" Width="80" Align="Right" Format="#,##0.##"/> <%--Text="단가"--%>  
                                <ext:NumberColumn ID="R_SETTLE_RTN_AMT" ItemID="RTN_AMT" runat="server" DataIndex="SETTLE_RTN_AMT" Width="80" Align="Right" Format="#,##0.##"/> <%--Text="반품금액"--%>
                                <ext:Column ID="R_YARDNM" ItemID="MAT_YARD" runat="server" DataIndex="YARDNM" MinWidth="90" Align="Left" Flex="1"/><%--Text="자재창고"      --%>                                
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
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
                            <ext:StatusBar ID="StatusBar2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                    <%--소급내용 그리드--%>
                    <ext:GridPanel ID="Grid03" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." Hidden="true">
                        <Store>
                            <ext:Store ID="Store3" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="Model3" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="SETTLE_DATE"/>
                                            <ext:ModelField Name="JOB_TYPE"/>
                                            <ext:ModelField Name="OLD_UCOST"/>
                                            <ext:ModelField Name="NEW_UCOST"/>
                                            <ext:ModelField Name="GAP_UCOST"/>
                                            <ext:ModelField Name="SETTLE_QTY"/>                                            
                                            <ext:ModelField Name="SETTLE_AMT"/>
                                            <ext:ModelField Name="BEG_DATE"/>
                                            <ext:ModelField Name="END_DATE"/>
                                            <ext:ModelField Name="LV_DIV"/>
                                        </Fields>
                                    </ext:Model>
                                </Model>
                                <Listeners>
                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                    <Load Delay="1" Handler="GridStoreReady(App.StatusBar3, this.getTotalCount());  "></Load>
                                </Listeners>
                            </ext:Store>
                        </Store>
                        <Plugins>
                            <ext:BufferedRenderer ID="BufferedRenderer3"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel3" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="S_NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:DateColumn ID="S_SETTLE_DATE" ItemID="SETTLE_DATE" runat="server" DataIndex="SETTLE_DATE" Width="80" Align="Center" />  <%--Text="정산일자"--%> 
                                <ext:Column ID="S_JOB_TYPE" ItemID="JOB_TYPE2" runat="server" DataIndex="JOB_TYPE"  Width="70" Align="Left" /><%--Text="업무유형"  --%>  
                                <ext:NumberColumn ID="S_OLD_UCOST" ItemID="OLD_UCOST" runat="server" DataIndex="OLD_UCOST" Width="80" Align="Right" Format="#,##0.##"/> <%--Text="기존단가"--%>  
                                <ext:NumberColumn ID="S_NEW_UCOST" ItemID="NEW_UCOST" runat="server" DataIndex="NEW_UCOST" Width="80" Align="Right" Format="#,##0.##"/> <%--Text="변경단가"--%>
                                <ext:NumberColumn ID="S_GAP_UCOST" ItemID="GAP_UCOST" runat="server" DataIndex="GAP_UCOST" Width="80" Align="Right" Format="#,##0.##"/> <%--Text="단가차액"--%>
                                <ext:NumberColumn ID="S_SETTLE_QTY" ItemID="SETTLE_QTY" runat="server" DataIndex="SETTLE_QTY" Width="80" Align="Right" Format="#,##0.###"/> <%--Text="정산수량"--%>  
                                <ext:NumberColumn ID="S_SETTLE_AMT" ItemID="SETTLE_AMT" runat="server" DataIndex="SETTLE_AMT" Width="80" Align="Right" Format="#,##0.##"/> <%--Text="정산금액"--%>
                                <ext:DateColumn ID="S_BEG_DATE" ItemID="SETTLE_BEG_DATE" runat="server" DataIndex="BEG_DATE" Width="80" Align="Center" />  <%--Text="정산시작일"--%> 
                                <ext:DateColumn ID="S_END_DATE" ItemID="SETTLE_END_DATE" runat="server" DataIndex="END_DATE" Width="80" Align="Center" />  <%--Text="정산종료일"--%> 
                                <ext:Column ID="S_LV_DIV" ItemID="LV_DIV" runat="server" DataIndex="LV_DIV" Width="90" Align="Center"/><%--Text="내수/수출"    --%>                              
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader3" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView3" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>                            
                            <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" Mode="Single"/>
                        </SelectionModel>                          
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="StatusBar3" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="BottomButtonPanel" runat="server" Region="South" Height="23" Cls="bottom_area_btn">
                <Items>
                    <ext:Label ID="QTY_AMT" runat="server" />
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
