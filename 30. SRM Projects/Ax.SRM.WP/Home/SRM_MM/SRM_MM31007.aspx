<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM31007.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM31007" %>
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
            fn_SetYmdDateChange(true);
        }
        
        var fn_SetYmdDateChange = function () {
            App.direct.SetYmdDateChange(true);
        };

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

        var linkRenderer = function (value, meta, record, index, cellIndex) {
            var param = "Ext.getStore('" + record.store.storeId + "')";

            if (value == '0')
                return value;
            else
                return Ext.String.format("<a style='color:blue;text-decoration:underline;' href='#' onclick=\"linkClick({0},{1},{2});\">{3}</a>", param, index, cellIndex, numberWithCommas(value));
        };

        var linkClick = function (store, rowIndex, cellIndex) {
            
            var param1 = new Array(store.getAt(rowIndex).data["VEND"], store.getAt(rowIndex).data["PURC_ORG"], store.getAt(rowIndex).data["PURC_PO_TYPE"], store.getAt(rowIndex).data["VINCD"], store.getAt(rowIndex).data["PARTNO"], store.getAt(rowIndex).data["PARTNM"], store.getAt(rowIndex).data["STR_LOC"], store.getAt(rowIndex).data["PO_UNIT"], store.getAt(rowIndex).data["CUSTCD"], parseInt((cellIndex - 11) / 2));
            App.direct.MakePopUp(param1, cellIndex % 2 == 1 ? 'P' : 'D'); // P : 발주량, D : 납품량
        };

        function numberWithCommas(x) {
            var parts = x.toString().split(".");
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            return parts.join(".");
        }          

    </script>
</head>
<body>
    <form id="SRM_MM31007" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM31007" runat="server" Cls="search_area_title_name" /><%--Text="OEM 자재발주" />--%>
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
                            <col style="width: 200px;" />
                            <col style="width: 100px;" />
                            <col style="width: 200px;" />
                            <col style="width: 100px;" />
                            <col style="width: 200px;" />
                            <col style="width: 100px;" />
                            <col style="width: 200px;" />
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
                                <ext:Label ID="lbl01_PO_STD_DATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_PO_STD_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  >
                                    <Listeners>
                                        <Change Fn="fn_SetYmdDateChange"></Change>
                                    </Listeners>
                                </ext:DateField>
                            </td>
                             <th class="ess">
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" />
                            </th>
                            <td>                                
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
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
                                <ext:Label ID="lbl01_PURC_PO_TYPE" runat="server" />                   
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PURC_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
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
                                <ext:Label ID="lbl01_MM31006_QUERY" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_QUERY_COND" runat="server"  Mode="Local" ForceSelection="true"
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
                               <ext:Label ID="lbl01_STR_LOC" runat="server" />
                            </th>
                            <td>                                                                                                 
                                <epc:EPCodeBox ID="cdx01_STR_LOC" runat="server" HelperID="HELP_STR_LOC" PopupMode="Search" PopupType="HelpWindow" 
                                    OnBeforeDirectButtonClick="cdx01_STR_LOC_BeforeDirectButtonClick" WidthTYPECD="60"/>    
                            </td>
                            <th>
                               <ext:Label ID="lbl01_CUSTNM" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD" PopupMode="Search" PopupType="HelpWindow"/>    
                            </td>
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PONO_PER" runat="server" />
                            </th>
                            <td colspan="5">
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="150" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:TextField ID="txt01_PONO" Width="100" Cls="inputText" runat="server" />    
                                        <ext:DisplayField ID="DisplayField2" Width="10" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" - " />
                                        <ext:TextField ID="txt01_PONO_SEQ" Width="40" Cls="inputText" runat="server" />    
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
                                            <ext:ModelField Name="VEND" /><ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="PURC_ORG" /><ext:ModelField Name="PURC_PO_TYPE" /><ext:ModelField Name="PURC_PO_TYPENM" />
                                            <ext:ModelField Name="VINCD" /><ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="PARTNO" /><ext:ModelField Name="PARTNM" />                                            
                                            <ext:ModelField Name="STR_LOC" /><ext:ModelField Name="STR_LOCNM" />
                                            <ext:ModelField Name="CUSTCD" /><ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="PO_UNIT" /><ext:ModelField Name="UNIT_PACK_QTY" />
                                            <ext:ModelField Name="PO_QTY_D01" /><ext:ModelField Name="DELI_QTY_D01" />
                                            <ext:ModelField Name="PO_QTY_D02" /><ext:ModelField Name="DELI_QTY_D02" />
                                            <ext:ModelField Name="PO_QTY_D03" /><ext:ModelField Name="DELI_QTY_D03" />
                                            <ext:ModelField Name="PO_QTY_D04" /><ext:ModelField Name="DELI_QTY_D04" />
                                            <ext:ModelField Name="PO_QTY_D05" /><ext:ModelField Name="DELI_QTY_D05" />
                                            <ext:ModelField Name="PO_QTY_D06" /><ext:ModelField Name="DELI_QTY_D06" />
                                            <ext:ModelField Name="PO_QTY_D07" /><ext:ModelField Name="DELI_QTY_D07" />
                                            <ext:ModelField Name="PO_QTY_D08" /><ext:ModelField Name="DELI_QTY_D08" />
                                            <ext:ModelField Name="PO_QTY_D09" /><ext:ModelField Name="DELI_QTY_D09" />
                                            <ext:ModelField Name="PO_QTY_D10" /><ext:ModelField Name="DELI_QTY_D10" />
                                            <ext:ModelField Name="PO_QTY_D11" /><ext:ModelField Name="DELI_QTY_D11" />
                                            <ext:ModelField Name="PO_QTY_D12" /><ext:ModelField Name="DELI_QTY_D12" />
                                            <ext:ModelField Name="PO_QTY_D13" /><ext:ModelField Name="DELI_QTY_D13" />
                                            <ext:ModelField Name="PO_QTY_D14" /><ext:ModelField Name="DELI_QTY_D14" />
                                            <ext:ModelField Name="PO_QTY_D15" /><ext:ModelField Name="DELI_QTY_D15" />
                                            <ext:ModelField Name="PO_QTY_D16" /><ext:ModelField Name="DELI_QTY_D16" />
                                            <ext:ModelField Name="PO_QTY_D17" /><ext:ModelField Name="DELI_QTY_D17" />
                                            <ext:ModelField Name="PO_QTY_D18" /><ext:ModelField Name="DELI_QTY_D18" />
                                            <ext:ModelField Name="PO_QTY_D19" /><ext:ModelField Name="DELI_QTY_D19" />
                                            <ext:ModelField Name="PO_QTY_D20" /><ext:ModelField Name="DELI_QTY_D20" />
                                            <ext:ModelField Name="PO_QTY_D21" /><ext:ModelField Name="DELI_QTY_D21" />
                                            <ext:ModelField Name="PO_QTY_D22" /><ext:ModelField Name="DELI_QTY_D22" />
                                            <ext:ModelField Name="PO_QTY_D23" /><ext:ModelField Name="DELI_QTY_D23" />
                                            <ext:ModelField Name="PO_QTY_D24" /><ext:ModelField Name="DELI_QTY_D24" />
                                            <ext:ModelField Name="PO_QTY_D25" /><ext:ModelField Name="DELI_QTY_D25" />
                                            <ext:ModelField Name="PO_QTY_D26" /><ext:ModelField Name="DELI_QTY_D26" />
                                            <ext:ModelField Name="PO_QTY_D27" /><ext:ModelField Name="DELI_QTY_D27" />
                                            <ext:ModelField Name="PO_QTY_D28" /><ext:ModelField Name="DELI_QTY_D28" />
                                            <ext:ModelField Name="PO_QTY_D29" /><ext:ModelField Name="DELI_QTY_D29" />
                                            <ext:ModelField Name="PO_QTY_D30" /><ext:ModelField Name="DELI_QTY_D30" />
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
                                <ext:RowNumbererColumn ID="NO"      ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center"  />
                                <ext:Column            ID="VEND" ItemID="VEND" runat="server" DataIndex="VEND" Width="70"  Align="center"  />
                                <ext:Column            ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="100"  Align="Left"  />
                                <ext:Column ID="PURC_PO_TYPE" ItemID="PURC_PO_TYPE"  runat="server" DataIndex="PURC_PO_TYPENM" Width="90" Align="Left" /><%--Text="구매오더유형(발주구분)"--%>                                
                                <ext:Column ID="VINNM" ItemID="VIN" runat="server" DataIndex="VINNM" Width="70" Align="Center" /><%--Text="차종"--%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="PART NO"--%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="170" Align="Left" /><%--Text="PART NAME"--%>
                                <ext:Column ID="STR_LOC" ItemID="STR_LOC"  runat="server" DataIndex="STR_LOCNM" Width="80" Align="Left"/><%--Text="저장위치"--%>
                                <ext:Column ID="CUSTNM" ItemID="CUSTNM"  runat="server" DataIndex="CUSTNM" Width="100" Align="Left"/><%--Text="고객코드"--%>
                                <ext:Column ID="PO_UNIT" ItemID="PO_UNIT"  runat="server" DataIndex="PO_UNIT" Width="60" Align="Center"/><%--Text="발주단위"--%>
                                <ext:NumberColumn      ID="UNIT_PACK_QTY"         ItemID="UNIT_PACK_QTY"         runat="server" DataIndex="UNIT_PACK_QTY"    Width="80"  Align="Right"  Format="#,##0.###" /><%--Text="용기적입수량"--%>
                                
                                <ext:Column ID="D01" ItemID="D01" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D01"         ItemID="PO_QTY_D01"         runat="server" DataIndex="PO_QTY_D01"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D01"         ItemID="DELI_QTY_D01"         runat="server" DataIndex="DELI_QTY_D01"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D02" ItemID="D02" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D02"         ItemID="PO_QTY_D02"         runat="server" DataIndex="PO_QTY_D02"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D02"         ItemID="DELI_QTY_D02"         runat="server" DataIndex="DELI_QTY_D02"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D03" ItemID="D03" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D03"         ItemID="PO_QTY_D03"         runat="server" DataIndex="PO_QTY_D03"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D03"         ItemID="DELI_QTY_D03"         runat="server" DataIndex="DELI_QTY_D03"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D04" ItemID="D04" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D04"         ItemID="PO_QTY_D04"         runat="server" DataIndex="PO_QTY_D04"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D04"         ItemID="DELI_QTY_D04"         runat="server" DataIndex="DELI_QTY_D04"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D05" ItemID="D05" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D05"         ItemID="PO_QTY_D05"         runat="server" DataIndex="PO_QTY_D05"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D05"         ItemID="DELI_QTY_D05"         runat="server" DataIndex="DELI_QTY_D05"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D06" ItemID="D06" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D06"         ItemID="PO_QTY_D06"         runat="server" DataIndex="PO_QTY_D06"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D06"         ItemID="DELI_QTY_D06"         runat="server" DataIndex="DELI_QTY_D06"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D07" ItemID="D07" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D07"         ItemID="PO_QTY_D07"         runat="server" DataIndex="PO_QTY_D07"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D07"         ItemID="DELI_QTY_D07"         runat="server" DataIndex="DELI_QTY_D07"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D08" ItemID="D08" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D08"         ItemID="PO_QTY_D08"         runat="server" DataIndex="PO_QTY_D08"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D08"         ItemID="DELI_QTY_D08"         runat="server" DataIndex="DELI_QTY_D08"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D09" ItemID="D09" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D09"         ItemID="PO_QTY_D09"         runat="server" DataIndex="PO_QTY_D09"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D09"         ItemID="DELI_QTY_D09"         runat="server" DataIndex="DELI_QTY_D09"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D10" ItemID="D10" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D10"         ItemID="PO_QTY_D10"         runat="server" DataIndex="PO_QTY_D10"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D10"         ItemID="DELI_QTY_D10"         runat="server" DataIndex="DELI_QTY_D10"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D11" ItemID="D11" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D11"         ItemID="PO_QTY_D11"         runat="server" DataIndex="PO_QTY_D11"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D11"         ItemID="DELI_QTY_D11"         runat="server" DataIndex="DELI_QTY_D11"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D12" ItemID="D12" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D12"         ItemID="PO_QTY_D12"         runat="server" DataIndex="PO_QTY_D12"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D12"         ItemID="DELI_QTY_D12"         runat="server" DataIndex="DELI_QTY_D12"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D13" ItemID="D13" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D13"         ItemID="PO_QTY_D13"         runat="server" DataIndex="PO_QTY_D13"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D13"         ItemID="DELI_QTY_D13"         runat="server" DataIndex="DELI_QTY_D13"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D14" ItemID="D14" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D14"         ItemID="PO_QTY_D14"         runat="server" DataIndex="PO_QTY_D14"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D14"         ItemID="DELI_QTY_D14"         runat="server" DataIndex="DELI_QTY_D14"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D15" ItemID="D15" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D15"         ItemID="PO_QTY_D15"         runat="server" DataIndex="PO_QTY_D15"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D15"         ItemID="DELI_QTY_D15"         runat="server" DataIndex="DELI_QTY_D15"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D16" ItemID="D16" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D16"         ItemID="PO_QTY_D16"         runat="server" DataIndex="PO_QTY_D16"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D16"         ItemID="DELI_QTY_D16"         runat="server" DataIndex="DELI_QTY_D16"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D17" ItemID="D17" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D17"         ItemID="PO_QTY_D17"         runat="server" DataIndex="PO_QTY_D17"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D17"         ItemID="DELI_QTY_D17"         runat="server" DataIndex="DELI_QTY_D17"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D18" ItemID="D18" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D18"         ItemID="PO_QTY_D18"         runat="server" DataIndex="PO_QTY_D18"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D18"         ItemID="DELI_QTY_D18"         runat="server" DataIndex="DELI_QTY_D18"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D19" ItemID="D19" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D19"         ItemID="PO_QTY_D19"         runat="server" DataIndex="PO_QTY_D19"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D19"         ItemID="DELI_QTY_D19"         runat="server" DataIndex="DELI_QTY_D19"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D20" ItemID="D20" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D20"         ItemID="PO_QTY_D20"         runat="server" DataIndex="PO_QTY_D20"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D20"         ItemID="DELI_QTY_D20"         runat="server" DataIndex="DELI_QTY_D20"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D21" ItemID="D21" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D21"         ItemID="PO_QTY_D21"         runat="server" DataIndex="PO_QTY_D21"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D21"         ItemID="DELI_QTY_D21"         runat="server" DataIndex="DELI_QTY_D21"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D22" ItemID="D22" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D22"         ItemID="PO_QTY_D22"         runat="server" DataIndex="PO_QTY_D22"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D22"         ItemID="DELI_QTY_D22"         runat="server" DataIndex="DELI_QTY_D22"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D23" ItemID="D23" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D23"         ItemID="PO_QTY_D23"         runat="server" DataIndex="PO_QTY_D23"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D23"         ItemID="DELI_QTY_D23"         runat="server" DataIndex="DELI_QTY_D23"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D24" ItemID="D24" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D24"         ItemID="PO_QTY_D24"         runat="server" DataIndex="PO_QTY_D24"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D24"         ItemID="DELI_QTY_D24"         runat="server" DataIndex="DELI_QTY_D24"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D25" ItemID="D25" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D25"         ItemID="PO_QTY_D25"         runat="server" DataIndex="PO_QTY_D25"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D25"         ItemID="DELI_QTY_D25"         runat="server" DataIndex="DELI_QTY_D25"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D26" ItemID="D26" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D26"         ItemID="PO_QTY_D26"         runat="server" DataIndex="PO_QTY_D26"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D26"         ItemID="DELI_QTY_D26"         runat="server" DataIndex="DELI_QTY_D26"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D27" ItemID="D27" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D27"         ItemID="PO_QTY_D27"         runat="server" DataIndex="PO_QTY_D27"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D27"         ItemID="DELI_QTY_D27"         runat="server" DataIndex="DELI_QTY_D27"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D28" ItemID="D28" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D28"         ItemID="PO_QTY_D28"         runat="server" DataIndex="PO_QTY_D28"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D28"         ItemID="DELI_QTY_D28"         runat="server" DataIndex="DELI_QTY_D28"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D29" ItemID="D29" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D29"         ItemID="PO_QTY_D29"         runat="server" DataIndex="PO_QTY_D29"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D29"         ItemID="DELI_QTY_D29"         runat="server" DataIndex="DELI_QTY_D29"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="D30" ItemID="D30" runat="server" >
                                    <Columns>          
                                        <ext:NumberColumn      ID="PO_QTY_D30"         ItemID="PO_QTY_D30"         runat="server" DataIndex="PO_QTY_D30"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="발주수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
                                        <ext:NumberColumn      ID="DELI_QTY_D30"         ItemID="DELI_QTY_D30"         runat="server" DataIndex="DELI_QTY_D30"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="납품수량"--%>
                                            <Renderer Fn="linkRenderer"/>
                                        </ext:NumberColumn>
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
