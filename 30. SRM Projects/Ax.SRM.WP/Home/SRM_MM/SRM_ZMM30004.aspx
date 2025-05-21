<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_ZMM30004.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_ZMM30004" %>
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
    <style type="text/css">
      
       <%-- .x-column-header-inner {
            line-height: 40px;
        }--%>
        
      
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

        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        //날짜 조건 변경시 그리드 헤더 설정.
        var fn_SetDateChange = function () {
            App.direct.SetDateChange();
        };

        // 0이면 숫자표시 안함.      
        function Renderer(value, meta, record, rowIndex, colIndex, store) {

            if (value != 0)
                return Ext.util.Format.number(value, '#,##0');

            else
                return '';
        }


    </script>
</head>
<body>
    <form id="SRM_ZMM30004" runat="server">
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
                    <ext:Label ID="lbl01_SRM_ZMM30004" runat="server" Cls="search_area_title_name" /><%--Text="Vendor Shortage Forecast Information" />--%>
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
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" /><%--Text="업체" />--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>   
                            <%--<th>
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
                            </td>--%>
                            <th class="ess">
                                <ext:Label ID="lbl01_STD_DATE" runat="server" /><%--Text="기준일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_DELI_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true" >                                
                                    <%--<Listeners>
                                        <Change Fn="fn_SetDateChange"></Change>
                                    </Listeners>--%>
                                </ext:DateField>
                            </td>
                        </tr>                       
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
            
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="250">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="PARTNO2" />
                                            <ext:ModelField Name="PARTNM" />                                            
                                            <ext:ModelField Name="BAS_INV" />
                                            <%--<ext:ModelField Name="VENDOR_INV" />--%>
                                            <%--<ext:ModelField Name="NCOME_QTY" />--%>
                                            <%--<ext:ModelField Name="UNIT_PACK_QTY" />--%>
                                            <ext:ModelField Name="W00" />
                                            <ext:ModelField Name="W01" />
                                            <ext:ModelField Name="W02" />
                                            <ext:ModelField Name="W03" />
                                            <ext:ModelField Name="W04" />
                                            <ext:ModelField Name="W05" />
                                            <ext:ModelField Name="W06" />
                                            <ext:ModelField Name="W07" />
                                            <ext:ModelField Name="W08" />
                                            <ext:ModelField Name="W09" />
                                            <ext:ModelField Name="W10" />
                                            <ext:ModelField Name="W11" />
                                            <ext:ModelField Name="W12" />
                                            <ext:ModelField Name="W12" />
                                            <ext:ModelField Name="W14" />
                                            <ext:ModelField Name="W15" />
                                            <ext:ModelField Name="W16" />
                                            <ext:ModelField Name="W17" />
                                            <ext:ModelField Name="W18" />
                                            <ext:ModelField Name="W19" />
                                            <ext:ModelField Name="W20" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PACK_QTY" />
                                            <ext:ModelField Name="UNIT" />
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
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Width="40" Align="Center" Text="No" Locked="false"/>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO2" Width="120" Align="Left" Locked="false"/> <%--Text="PART NO"--%>  
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="220" Align="Left" Locked="false"/> <%--Text="PART NAME"--%>   
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="50" Align="Center" Locked="false" Text="UNIT" />
                             <%--   <ext:NumberColumn ID="UNIT_PACK_QTY" ItemID="UNIT_PACK_QTY" runat="server" DataIndex="UNIT_PACK_QTY" Width="100" Align="Right" Format="#,##0" Locked="false"> --%> <%--Text="기초재고수량"--%>     
                                   <%-- <Renderer Fn="Renderer" />
                                </ext:NumberColumn>--%>

                                <ext:NumberColumn ID="BAS_INV" ItemID="BAS_INV" runat="server" DataIndex="BAS_INV" Width="100" Align="Right" Format="#,##0" Locked="false"> <%--Text="기초재고수량"--%>     
                                    <Renderer Fn="Renderer" />
                                </ext:NumberColumn>

                                <%--<ext:NumberColumn ID="VENDOR_INV" ItemID="VENDOR_INV" runat="server" DataIndex="VENDOR_INV" Width="100" Align="Right" Format="#,##0" Locked="false">--%> <%--Text="기초재고수량"--%>     
                                    <%--<Renderer Fn="Renderer" />
                                </ext:NumberColumn>--%>
                                <%-- 
                                <ext:NumberColumn ID="NCOME_QTY" ItemID="NCOME_QTY" runat="server" DataIndex="NCOME_QTY" Width="100" Align="Right" Format="#,##0" Locked="false"> 
                                    <Renderer Fn="Renderer" />
                                </ext:NumberColumn>
                                 --%>
                                <ext:Column ID="HW00" ItemID="HW00" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W00" ItemID="W00" runat="server" DataIndex="W00" Width="80" Align="Right" Format="#,##0"><Renderer Fn="Renderer" /></ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW01" ItemID="HW01" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W01" ItemID="W01" runat="server" DataIndex="W01" Width="80" Align="Right" Format="#,##0"><Renderer Fn="Renderer" /></ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW02" ItemID="HW02" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W02" ItemID="W02" runat="server" DataIndex="W02" Width="80" Align="Right" Format="#,##0"><Renderer Fn="Renderer" /></ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW03" ItemID="HW03" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W03" ItemID="W03" runat="server" DataIndex="W03" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW04" ItemID="HW04" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W04" ItemID="W04" runat="server" DataIndex="W04" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW05" ItemID="HW05" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W05" ItemID="W05" runat="server" DataIndex="W05" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW06" ItemID="HW06" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W06" ItemID="W06" runat="server" DataIndex="W06" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW07" ItemID="HW07" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W07" ItemID="W07" runat="server" DataIndex="W07" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW08" ItemID="HW08" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W08" ItemID="W08" runat="server" DataIndex="W08" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW09" ItemID="HW09" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W09" ItemID="W09" runat="server" DataIndex="W09" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW10" ItemID="HW10" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W10" ItemID="W10" runat="server" DataIndex="W10" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW11" ItemID="HW11" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W11" ItemID="W11" runat="server" DataIndex="W11" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW12" ItemID="HW12" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W12" ItemID="W12" runat="server" DataIndex="W12" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW13" ItemID="HW13" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W13" ItemID="W13" runat="server" DataIndex="W13" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW14" ItemID="HW14" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W14" ItemID="W14" runat="server" DataIndex="W14" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW15" ItemID="HW15" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W15" ItemID="W15" runat="server" DataIndex="W15" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW16" ItemID="HW16" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W16" ItemID="W16" runat="server" DataIndex="W16" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW17" ItemID="HW17" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W17" ItemID="W17" runat="server" DataIndex="W17" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW18" ItemID="HW18" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W18" ItemID="W18" runat="server" DataIndex="W18" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW19" ItemID="HW19" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W19" ItemID="W19" runat="server" DataIndex="W19" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="HW20" ItemID="HW20" runat="server" >
                                    <Columns>
                                        <ext:NumberColumn ID="W20" ItemID="W20" runat="server" DataIndex="W20" Width="80" Align="Right" Format="#,##0"> <%--Text="기초재고수량"--%>     
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
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
