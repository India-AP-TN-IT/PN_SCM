<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM36009.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM36009" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible"/>
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
    <style type="text/css">
        
        .font-color-red 
        {
            color:#FF0000;
        }
	            
    </style>
    <style type="text/css">
        
        .x-column-header-align-right .x-column-header-text
        {
            margin-right:0px;
        }
        
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


        function getRowClass(record, b, c, d) {
            var acpQty = record.data['RETROACT_QTY'];
            var amount = record.data['RETROACT_AMT'];

            if (acpQty < 0 || amount < 0) return 'font-color-red';
        }

    </script>

</head>
<body>
    <form id="SRM_MM36009" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM36009" runat="server" Cls="search_area_title_name" />
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
                            <col style="width: 120px;" />
                            <col style="width: 270px;"/>
                            <col style="width: 120px;" />
                            <col style="width: 200px;"/>
                            <col style="width: 120px;" />
                            <col style="width: 280px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>      
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_CUST" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD_FIX" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" Text="Business Code" /><%--Text="사업장" />--%>
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
                                <ext:Label ID="lbl01_RETROACT_DATE" runat="server" /><%--Text="소급반영일자" />--%>
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
                            <th class="ess">         
                                <ext:Label ID="lbl01_PURC_ORG_VTWEG" runat="server" /><%--Text="구매조직(유통경로)" />--%>
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
                                <ext:Label ID="lbl01_VIN" runat="server" /><%--Text="차종" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_VINCD" Width="100" Cls="inputText" runat="server" />    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" /><%--Text="PART NO(%)" />--%>
                            </th>
                            <td colspan="5">
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />    
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <%--그리드--%>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." SortableColumns="false">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="PURC_ORGNM" />
                                            <ext:ModelField Name="BUDAT" />
                                            <ext:ModelField Name="ZSEQ" />
                                            <ext:ModelField Name="RETROACT_MONTH" />
                                            <ext:ModelField Name="RETROACT_DATE" />
                                            <ext:ModelField Name="RETROACT_TYPE" />
                                            <ext:ModelField Name="VINCD" />                                              
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="BEG_DATE" />
                                            <ext:ModelField Name="END_DATE" />
                                            <ext:ModelField Name="RETROACT_QTY" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="RETROACT_UCOST" />
                                            <ext:ModelField Name="RETROACT_AMT" />
                                            <ext:ModelField Name="COINCD" />
                                            <ext:ModelField Name="REPORT_NO" />
                                            <ext:ModelField Name="RETROACT_REASON" />
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
                                <ext:Column ID="CUSTCD" ItemID="VENDORCD" runat="server" DataIndex="CUSTCD" Width="80"  Align="Center" /><%--Text="거래처코드"--%>
                                <ext:Column ID="CUSTNM" ItemID="VENDORNM" runat="server" DataIndex="CUSTNM" Width="120"  Align="Left" /><%--Text="거래처명"--%> 
                                <ext:Column ID="PURC_ORGNM" ItemID="PURC_ORG" runat="server" DataIndex="PURC_ORGNM" Width="80"  Align="Center" /><%--Text="구매조직"--%> 
                                <ext:Column ID="BUDAT" ItemID="RCV_DATE2" runat="server" DataIndex="BUDAT" Width="100"  Align="Center"  /><%--Text="전기일자"--%> 
                                <ext:Column ID="RETROACT_DATE" ItemID="RETROACT_DATE" runat="server" DataIndex="RETROACT_DATE" MinWidth="100"  Align="Center"  /><%--Text="소급반영일자"--%> 
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="50"  Align="Center"  /><%--Text="차종"--%> 
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120"  Align="Left"  /><%--Text="PART NO"--%> 
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="170"  Align="Left"  /><%--Text="PART NAME"--%> 
                                <ext:Column ID="BEG_DATE" ItemID="RETROACT_BEG_DATE" runat="server" DataIndex="BEG_DATE" Width="100"  Align="Center"  /><%--Text="소급시작일"--%> 
                                <ext:Column ID="END_DATE" ItemID="RETROACT_END_DATE" runat="server" DataIndex="END_DATE" Width="100"  Align="Center"  /><%--Text="소급종료일"--%> 
                                <ext:NumberColumn ID="RETROACT_QTY" ItemID="RETROACT_QTY" runat="server" DataIndex="RETROACT_QTY" Width="80" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="소급수량"--%>
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="50"  Align="Center" /><%--Text="단위"--%> 
                                <ext:NumberColumn ID="RETROACT_UCOST" ItemID="RETROACT_UCOST" runat="server" DataIndex="RETROACT_UCOST" Width="80" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="소급단가"--%>
                                <ext:NumberColumn ID="RETROACT_AMT" ItemID="RETROACT_AMT" runat="server" DataIndex="RETROACT_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="소급금액"--%>
                                <ext:Column ID="COINCD" ItemID="EI27010_COINCD" runat="server" DataIndex="COINCD" Width="50" Align="Center" /><%--Text="통화"--%> 
                                <ext:Column ID="RETROACT_MONTH" ItemID="RETROACT_CLS_MONTH" runat="server" DataIndex="RETROACT_MONTH" Width="80"  Align="Center"  /><%--Text="소급마감월"--%> 
                                <ext:Column ID="ZSEQ" ItemID="RETROACT_DOCNO" runat="server" DataIndex="ZSEQ" Width="100"  Align="Left" /><%--Text="소급문서번호"--%> 
                                <ext:Column ID="RETROACT_TYPE" ItemID="RETROACT_TYPE" runat="server" DataIndex="RETROACT_TYPE" MinWidth="80"  Align="Left"  /><%--Text="소급유형"--%> 
                                <ext:Column ID="REPORT_NO" ItemID="REPORT_NO" runat="server" DataIndex="REPORT_NO" Width="80"  Align="Left"  /><%--Text="품의번호"--%> 
                                <ext:Column ID="RETROACT_REASON" ItemID="RETROACT_REASON" runat="server" DataIndex="RETROACT_REASON" Width="150"  Align="Left"  /><%--Text="소급사유"--%> 
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true" />
                        </View>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single"/>
                        </SelectionModel>
                        <Listeners>
                                <%--<CellDblClick Fn ="CellDbClick"></CellDblClick>--%>
                        </Listeners>                                                  
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
