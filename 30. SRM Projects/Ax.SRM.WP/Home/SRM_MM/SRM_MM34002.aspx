<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM34002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM34002" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" />
<meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
<meta content="/images/favicon/SCM.ico" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
    <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    <meta content="/images/favicon/SCM.ico" itemprop="image"/>
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
    <form id="SRM_MM34002" runat="server">
    <ext:ResourceManager ID="ResourceManager1" Locale="pt" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM34002" runat="server" Cls="search_area_title_name" /><%--Text="종합 거래 내역 (SAP)" />--%>
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
                                <ext:DateField ID="df01_YYMM" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />                                
                            </td>
                        </tr> 
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_ACCNAME" runat="server" /><%--계정--%>                   
                            </th>
                            <td colspan="5">
                                <ext:SelectBox ID="cbo01_ACCTCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="NAME" ValueField="CODE" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="CODE" />
                                                        <ext:ModelField Name="NAME" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
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
                                            <ext:ModelField Name="VEND" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="HKONT" />
                                            <ext:ModelField Name="TXT50" />                                            
                                            <ext:ModelField Name="XBLNR" />
                                            <ext:ModelField Name="BELNR" />
                                            <ext:ModelField Name="SGTXT" />
                                            <ext:ModelField Name="BUDAT" />  
                                            <ext:ModelField Name="CARRY1" /> 
                                            <ext:ModelField Name="DEBIT" />          
                                            <ext:ModelField Name="CREDIT" />
                                            <ext:ModelField Name="REMAIN" />                                                                                        
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
                                <ext:Column            ID="VEND" ItemID="VEND" runat="server" DataIndex="VEND" Width="70"  Align="center"  />
                                <ext:Column            ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="100"  Align="Left"  />
                                <ext:Column ID="HKONT" ItemID="HKONT" runat="server" DataIndex="HKONT" Width="100" Align="Center"/><%--Text="G/L계정번호"      --%>
                                <ext:Column ID="TXT50" ItemID="TXT50" runat="server" DataIndex="TXT50" Width="120" Align="Center"/><%--Text="계정명"      --%>
                                <ext:Column ID="XBLNR" ItemID="CHARGENM" runat="server" DataIndex="XBLNR" Width="260" Align="Center"/><%--Text="참조전표번호"      --%>
                                <ext:Column ID="BELNR" ItemID="NOTENO" runat="server" DataIndex="BELNR" Width="100" Align="Center"/><%--Text="전표번호"      --%>
                                <ext:Column ID="SGTXT" ItemID="NOTE_DESC" runat="server" DataIndex="SGTXT" MinWidth="180" Align="Left" Flex="1"/><%--Text="적요" --%>
                                <ext:Column ID="BUDAT" ItemID="BUDAT" runat="server" DataIndex="BUDAT" MinWidth="100" Align="Center" /><%--Text="전표전기일"      --%>                                
                                <ext:NumberColumn ID="CARRY1" ItemID="CARRY1" runat="server" DataIndex="CARRY1" Width="120" Align="Right" Format="#,##0.##"/><%--Text="기초잔액(현지통화)"  --%>
                                <ext:NumberColumn ID="DEBIT" ItemID="DEBIT" runat="server" DataIndex="DEBIT" Width="120" Align="Right" Format="#,##0.##"/><%--Text="차변금액(현지통화)"  --%>  
                                <ext:NumberColumn ID="CREDIT" ItemID="CREDIT1" runat="server" DataIndex="CREDIT" Width="120" Align="Right" Format="#,##0.##"/><%--Text="대변금액(현지통화)"  --%>  
                                <ext:NumberColumn ID="REMAIN" ItemID="REMAIN" runat="server" DataIndex="REMAIN" Width="120" Align="Right" Format="#,##0.##"/><%--Text="잔액(현지통화)"  --%> 
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
