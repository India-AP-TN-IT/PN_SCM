<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM30010.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM30010" %>
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
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
            fn_SetYmdDateChange(true);
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

        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            //var grid = selectionModel.view.ownerCt;
            //grid.editingPlugin.startEdit(rowIndex, colIndex);
        }

        var fn_SetYmdDateChange = function () {
            App.direct.SetYmdDateChange(true);
        };

    </script>
</head>
<body>
    <form id="SRM_MM30010" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM30010" runat="server" Cls="search_area_title_name" /><%--Text="사급 직납 마감 등록" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" style="margin-top:0px;" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                               <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>                                 
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"  />
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" Text="Business Code" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_BIZCD" ItemID="SAUP" runat="server" Cls="inputText"  Mode="Local" ForceSelection="true"
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
                                <ext:DateField ID="df01_DATE" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true" >                                
                                    <Listeners>
                                        <Change Fn="fn_SetYmdDateChange"></Change>
                                    </Listeners>
                                </ext:DateField>
                            </td>    
                            <th class="ess">
                                <ext:Label ID="lbl01_PLAN_DIV" runat="server"/>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PLAN_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store33" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model33" runat="server">
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
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" />
                            </th>
                            <td>                                
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
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
                                <ext:Label ID="lbl01_VIN" runat="server" />                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>  
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />
                            </th>
                            <td colspan = "3">
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />    
                            </td>
                        </tr>                        
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="Panel1" Region="North" runat="server" Height="20" >
                <Content>
                    <ext:Label ID="lbl01_SRM_MM30010_MSG01" runat="server" /><%--Text="※ 월간 계획은 고객사 계획에 따라 수시로 변하는 자료이므로 참고용으로만 보시기 바라며, 본 정보와 구매계획은 상이할 수 있습니다." />--%>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>                                        
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." SortableColumns="false">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VEND" /> 
                                            <ext:ModelField Name="VENDNM" /> 
                                            <ext:ModelField Name="PURC_ORG" /> 
                                            <ext:ModelField Name="PURC_ORGNM" /> 
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="UNITNM" />
                                            <ext:ModelField Name="M0_QTY" />
                                            <ext:ModelField Name="M1_QTY" />
                                            <ext:ModelField Name="M2_QTY" />
                                            <ext:ModelField Name="M3_QTY" />
                                            <ext:ModelField Name="M4_QTY" />
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
                            <ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO"      ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center"  />
                                <ext:Column            ID="VEND" ItemID="VEND" runat="server" DataIndex="VEND" Width="70"  Align="center"  />
                                <ext:Column            ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="100"  Align="Left"  />
                                <ext:Column            ID="PURC_ORGNM" ItemID="PURC_ORGNM" runat="server" DataIndex="PURC_ORGNM" Width="80"  Align="center"  />
                                <ext:Column ID="VINNM"  ItemID="VIN" runat="server" DataIndex="VINNM" Width="70" Align="Center"  /><%--Text="차종"  --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left"  /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="250" Align="Left" /><%--Text="PART NAME" --%>
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="80" Align="Center" /><%--Text="UNIT"   --%>
                                <ext:Column ID="MONTH_PLAN_QTY" ItemID="MONTH_PLAN_QTY" runat="server" ><%--Text="월 계획 수량">--%>
                                    <Columns>
                                    <ext:NumberColumn      ID="M0_QTY"         ItemID="M0_QTY"         runat="server" DataIndex="M0_QTY"    Width="90"  Align="Right"  Format="#,##0.###" Text="M0"/>
                                    <ext:NumberColumn      ID="M1_QTY"         ItemID="M1_QTY"         runat="server" DataIndex="M1_QTY"    Width="90"  Align="Right"  Format="#,##0.###" Text="M1"/>
                                    <ext:NumberColumn      ID="M2_QTY"         ItemID="M2_QTY"         runat="server" DataIndex="M2_QTY"    Width="90"  Align="Right"  Format="#,##0.###" Text="M2"/>
                                    <ext:NumberColumn      ID="M3_QTY"         ItemID="M3_QTY"         runat="server" DataIndex="M3_QTY"    Width="90"  Align="Right"  Format="#,##0.###" Text="M3"/>
                                    <ext:NumberColumn      ID="M4_QTY"         ItemID="M4_QTY"         runat="server" DataIndex="M4_QTY"    Width="90"  Align="Right"  Format="#,##0.###" Text="M4"/>
                                    </Columns>
                                </ext:Column>
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">                                
<%--                                <GetRowClass Fn="getRowClass" />--%>
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
