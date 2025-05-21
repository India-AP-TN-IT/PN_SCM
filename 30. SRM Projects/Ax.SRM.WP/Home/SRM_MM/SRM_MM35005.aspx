<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM35005.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM35005" %>
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
    <style type="text/css">
        .font-bold .x-grid-cell-inner 
        {
            font-weight:bold;
        }
        .font-normal .x-grid-cell-inner 
        {
            font-weight:normal;
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

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        function getRowClass(record, b, c, d) {
            if (record.data['GA']=="1") return 'font-bold';
            else return 'font-normal';
        }

    </script>
</head>
<body>
    <form id="SRM_MM35005" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM35005" runat="server" Cls="search_area_title_name" /><%--Text="서열투입계획(직/준서열)" />--%>
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
                            <col style="width: 300px;" />
                            <col style="width: 150px;" />
                            <col style="width: 300px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
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
                                    <DirectEvents>
                                        <Select OnEvent="changeCondition" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_INPUT_DATE" runat="server" /><%--Text="투입일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_INPUT_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true">
                                    <DirectEvents>
                                        <Select OnEvent="changeCondition" />
                                    </DirectEvents>
                                </ext:DateField>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_CONTCD" runat="server" /><%--Text="물류용기코드" />   --%>                    
                            </th>
                            <td colspan="3">
                                <epc:EPCodeBox ID="cdx01_CONTCD" runat="server" HelperID="HELP_CONTCD_SEQ" PopupMode="Search" PopupType="HelpWindow"
                                 OnBeforeDirectButtonClick="cdx01_CONTCD_BeforeDirectButtonClick" WidthTYPECD="60"/>
                            </td>  
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" /><%--차종--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_LINECD" runat="server" /><%--Text="라인코드" />--%>                       
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_LINECD" runat="server" HelperID="HELP_LINE_SEQ" PopupMode="Search" PopupType="HelpWindow" 
                                    OnBeforeDirectButtonClick="cdx01_LINECD_BeforeDirectButtonClick" WidthTYPECD="60" />    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_INSTALL_POS" runat="server" /><%--Text="위치" /> --%>                      
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_INSTALL_POS" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPECD" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="TYPECD" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td> 
                            <th>         
                                <ext:Label ID="lbl01_SUBCON_PNO_PER" runat="server" />                       
                            </th>
                            <td colspan="3">
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" FieldStyle="text-transform:uppercase;" />
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
                                            <ext:ModelField Name="LINECD" />           
                                            <ext:ModelField Name="VINCD" />           
                                            <ext:ModelField Name="INSTALL_POS" />
                                            <ext:ModelField Name="CONTCD" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="LOG_DIV" />
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="JOB_TYPE" />
                                            <ext:ModelField Name="DESC_YN" />
                                            <ext:ModelField Name="PLAN_QTY" />
                                            <ext:ModelField Name="DN_DIV_DAY" />
                                            <ext:ModelField Name="DN_DIV_NIGHT" />
                                            <ext:ModelField Name="INPUT_QTY" />
                                            <ext:ModelField Name="QTY01" />
                                            <ext:ModelField Name="QTY02" />
                                            <ext:ModelField Name="QTY03" />
                                            <ext:ModelField Name="QTY04" />
                                            <ext:ModelField Name="QTY05" />
                                            <ext:ModelField Name="QTY06" />
                                            <ext:ModelField Name="QTY07" />
                                            <ext:ModelField Name="QTY08" />
                                            <ext:ModelField Name="QTY09" />
                                            <ext:ModelField Name="QTY10" />
                                            <ext:ModelField Name="QTY11" />
                                            <ext:ModelField Name="QTY12" />
                                            <ext:ModelField Name="QTY13" />
                                            <ext:ModelField Name="QTY14" />
                                            <ext:ModelField Name="QTY15" />
                                            <ext:ModelField Name="QTY16" />
                                            <ext:ModelField Name="QTY17" />
                                            <ext:ModelField Name="QTY18" />
                                            <ext:ModelField Name="QTY19" />
                                            <ext:ModelField Name="QTY20" />
                                            <ext:ModelField Name="QTY21" />
                                            <ext:ModelField Name="QTY22" />
                                            <ext:ModelField Name="QTY23" />
                                            <ext:ModelField Name="QTY24" />
                                            <ext:ModelField Name="QTY25" />
                                            <ext:ModelField Name="QTY26" />
                                            <ext:ModelField Name="QTY27" />
                                            <ext:ModelField Name="QTY28" />
                                            <ext:ModelField Name="QTY29" />
                                            <ext:ModelField Name="QTY30" />
                                            <ext:ModelField Name="QTY31" />
                                            <ext:ModelField Name="QTY32" />
                                            <ext:ModelField Name="QTY33" />
                                            <ext:ModelField Name="QTY34" />
                                            <ext:ModelField Name="QTY35" />
                                            <ext:ModelField Name="QTY36" />
                                            <ext:ModelField Name="QTY37" />
                                            <ext:ModelField Name="QTY38" />
                                            <ext:ModelField Name="QTY39" />
                                            <ext:ModelField Name="QTY40" />
                                            <ext:ModelField Name="QTY41" />
                                            <ext:ModelField Name="QTY42" />
                                            <ext:ModelField Name="QTY43" />
                                            <ext:ModelField Name="QTY44" />
                                            <ext:ModelField Name="QTY45" />
                                            <ext:ModelField Name="QTY46" />
                                            <ext:ModelField Name="QTY47" />
                                            <ext:ModelField Name="QTY48" />
                                            <ext:ModelField Name="QTY49" />
                                            <ext:ModelField Name="QTY50" />
                                            <ext:ModelField Name="QTY51" />
                                            <ext:ModelField Name="QTY52" />
                                            <ext:ModelField Name="QTY53" />
                                            <ext:ModelField Name="QTY54" />
                                            <ext:ModelField Name="QTY55" />
                                            <ext:ModelField Name="QTY56" />
                                            <ext:ModelField Name="QTY57" />
                                            <ext:ModelField Name="QTY58" />
                                            <ext:ModelField Name="QTY59" />
                                            <ext:ModelField Name="QTY60" />
                                            <ext:ModelField Name="GA" /> <%-- 그룹핑 변수 --%>
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
                                <ext:Column ID="LINECD" ItemID="LINECD" runat="server" DataIndex="LINECD"  Width="80" Align="Center"  /><%--Text="라인코드"  --%>
                                <ext:Column ID="INSTALL_POS" ItemID="INSTALL_POS" runat="server" DataIndex="INSTALL_POS"  Width="50" Align="Center"  /><%--Text="위치"  --%>
                                <ext:Column ID="CONTCD" ItemID="CONTCD" runat="server" DataIndex="CONTCD"  Width="60" Align="Center"  /><%--Text="자재품목"  --%>
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD"  Width="60" Align="Center"  /><%--Text="차종"  --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left"  /><%--Text="PART NO"   --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="PART NAME" --%>
                                <ext:Column ID="ALCCD" ItemID="ALCCD_REP" runat="server" DataIndex="ALCCD" Width="60" Align="Center"/> <%--Text="대표ALC"--%>   
                                <ext:Column ID="JOB_TYPE" ItemID="JOB_TYPE" runat="server" DataIndex="JOB_TYPE" Width="60" Align="Center"/> <%--Text="업무유형"--%>  
                                
                                <ext:Column ID="PRD_QTY" ItemID="PRD_QTY" runat="server" ><%--Text="생산수량">--%>
                                    <Columns>                                        
                                        <ext:NumberColumn ID="PLAN_QTY" ItemID="TOTAL" runat="server" DataIndex="PLAN_QTY" Width="55" Align="Right" Format="#,##0.###" Sortable="true"/> <%--Text="합계"--%>
                                        <ext:NumberColumn ID="DN_DIV_DAY" ItemID="DTIME_CNT" runat="server" DataIndex="DN_DIV_DAY" Width="55" Align="Right" Format="#,##0.###" Sortable="true"/> <%--Text="주간"--%>
                                        <ext:NumberColumn ID="DN_DIV_NIGHT" ItemID="NTIME_CNT" runat="server" DataIndex="DN_DIV_NIGHT" Width="55" Align="Right" Format="#,##0.###" Sortable="true"/> <%--Text="야간"--%>
                                    </Columns>
                                </ext:Column>  
                                 
                                <ext:Column ID="INPUT_PLAN_QTY" ItemID="INPUT_PLAN_QTY" runat="server" ><%--Text="투입계획수량">--%>
                                    <Columns> 
                                        <ext:NumberColumn ID="INPUT_QTY" ItemID="TOTAL" runat="server" DataIndex="INPUT_QTY" Width="55" Align="Right" Format="#,##0.###" Sortable="true" /><%--합계--%>
                                        <ext:NumberColumn ID="QTY01" ItemID="QTY01" runat="server" DataIndex="QTY01" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY02" ItemID="QTY02" runat="server" DataIndex="QTY02" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY03" ItemID="QTY03" runat="server" DataIndex="QTY03" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY04" ItemID="QTY04" runat="server" DataIndex="QTY04" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY05" ItemID="QTY05" runat="server" DataIndex="QTY05" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY06" ItemID="QTY06" runat="server" DataIndex="QTY06" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY07" ItemID="QTY07" runat="server" DataIndex="QTY07" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY08" ItemID="QTY08" runat="server" DataIndex="QTY08" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY09" ItemID="QTY09" runat="server" DataIndex="QTY09" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY10" ItemID="QTY10" runat="server" DataIndex="QTY10" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY11" ItemID="QTY11" runat="server" DataIndex="QTY11" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY12" ItemID="QTY12" runat="server" DataIndex="QTY12" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY13" ItemID="QTY13" runat="server" DataIndex="QTY13" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY14" ItemID="QTY14" runat="server" DataIndex="QTY14" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY15" ItemID="QTY15" runat="server" DataIndex="QTY15" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY16" ItemID="QTY16" runat="server" DataIndex="QTY16" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY17" ItemID="QTY17" runat="server" DataIndex="QTY17" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY18" ItemID="QTY18" runat="server" DataIndex="QTY18" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY19" ItemID="QTY19" runat="server" DataIndex="QTY19" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY20" ItemID="QTY20" runat="server" DataIndex="QTY20" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY21" ItemID="QTY21" runat="server" DataIndex="QTY21" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY22" ItemID="QTY22" runat="server" DataIndex="QTY22" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY23" ItemID="QTY23" runat="server" DataIndex="QTY23" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY24" ItemID="QTY24" runat="server" DataIndex="QTY24" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY25" ItemID="QTY25" runat="server" DataIndex="QTY25" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY26" ItemID="QTY26" runat="server" DataIndex="QTY26" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY27" ItemID="QTY27" runat="server" DataIndex="QTY27" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY28" ItemID="QTY28" runat="server" DataIndex="QTY28" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY29" ItemID="QTY29" runat="server" DataIndex="QTY29" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY30" ItemID="QTY30" runat="server" DataIndex="QTY30" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY31" ItemID="QTY31" runat="server" DataIndex="QTY31" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY32" ItemID="QTY32" runat="server" DataIndex="QTY32" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY33" ItemID="QTY33" runat="server" DataIndex="QTY33" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY34" ItemID="QTY34" runat="server" DataIndex="QTY34" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY35" ItemID="QTY35" runat="server" DataIndex="QTY35" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY36" ItemID="QTY36" runat="server" DataIndex="QTY36" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY37" ItemID="QTY37" runat="server" DataIndex="QTY37" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY38" ItemID="QTY38" runat="server" DataIndex="QTY38" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY39" ItemID="QTY39" runat="server" DataIndex="QTY39" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY40" ItemID="QTY40" runat="server" DataIndex="QTY40" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY41" ItemID="QTY41" runat="server" DataIndex="QTY41" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY42" ItemID="QTY42" runat="server" DataIndex="QTY42" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY43" ItemID="QTY43" runat="server" DataIndex="QTY43" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY44" ItemID="QTY44" runat="server" DataIndex="QTY44" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY45" ItemID="QTY55" runat="server" DataIndex="QTY55" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY46" ItemID="QTY46" runat="server" DataIndex="QTY46" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY47" ItemID="QTY47" runat="server" DataIndex="QTY47" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY48" ItemID="QTY48" runat="server" DataIndex="QTY48" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY49" ItemID="QTY49" runat="server" DataIndex="QTY49" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY50" ItemID="QTY50" runat="server" DataIndex="QTY50" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY51" ItemID="QTY51" runat="server" DataIndex="QTY51" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY52" ItemID="QTY52" runat="server" DataIndex="QTY52" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY53" ItemID="QTY53" runat="server" DataIndex="QTY53" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY54" ItemID="QTY54" runat="server" DataIndex="QTY54" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY55" ItemID="QTY55" runat="server" DataIndex="QTY55" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY56" ItemID="QTY56" runat="server" DataIndex="QTY56" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY57" ItemID="QTY57" runat="server" DataIndex="QTY57" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY58" ItemID="QTY58" runat="server" DataIndex="QTY58" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY59" ItemID="QTY59" runat="server" DataIndex="QTY59" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
                                        <ext:NumberColumn ID="QTY60" ItemID="QTY60" runat="server" DataIndex="QTY60" Width="55" Align="Right" Format="#,##0.###" Sortable="true" />
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
