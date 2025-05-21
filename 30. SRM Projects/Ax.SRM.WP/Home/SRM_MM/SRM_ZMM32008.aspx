<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_ZMM32008.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_ZMM32008" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" >
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/common/favicon.ico" itemprop="image">
<meta name="apple-mobile-web-app-title" content="HE.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/common/favicon.ico" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="HE.POTAL" />

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/common/favicon.ico" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=20141226080000"  />
    <style type="text/css">
      
        
        
      
    </style>
    <script src="../../Script/Common.js?v=20141226080000" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
            CheckChange();
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

        // shortage plan이 -값일 경우 배경색:pink, 글자색:빨간색, 0이면 숫자표시 안함.      
        function Renderer(value, meta, record, rowIndex, colIndex, store) {


            if (value < 0)
                meta.style = "background-color:pink;color:red;";
            if (value != 0)
                return Ext.util.Format.number(value, '#,###');

            else
                return '';
        }

        var CheckChange = function () {

            //App.direct.CheckChange();            
            App.DATE_P_D2.setVisible(App.chk01.checked);
            App.DATE_P_D3.setVisible(App.chk01.checked);
            App.DATE_P_D4.setVisible(App.chk01.checked);
            App.DATE_S_D2.setVisible(App.chk01.checked);
            App.DATE_S_D3.setVisible(App.chk01.checked);
            App.DATE_S_D4.setVisible(App.chk01.checked);

        }
    </script>
</head>
<body>
    <form id="SRM_ZMM32008" runat="server">
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
                    <ext:Label ID="lbl01_SRM_ZMM32008" runat="server" Cls="search_area_title_name" /><%--Text="Shortage Mornitoring" />--%>
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
                                <ext:DateField ID="df01_DELI_DATE" ItemID="df01_DELI_DATE" Name="df01_DELI_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true" >                                
                                    <%--<Listeners>
                                        <Change Fn="fn_SetDateChange"></Change>                                        
                                    </Listeners>--%>
                                </ext:DateField>
                            </td>
                            <th class="ess">
                               <ext:Label ID="lbl01_MAT_YARD" runat="server" /><%--Text="자재창고" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_YARDNO" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="YARDNM" ValueField="YARDNO" TriggerAction="All" Width="230">
                                    <Store>
                                        <ext:Store ID="Store6" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model6" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="YARDNO" />
                                                        <ext:ModelField Name="YARDNM" />
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
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                 
                            </th>
                            <td>
                                <ext:TextField ID="txt01_PARTNO" Width="150" Cls="inputText" runat="server" />                                                          
                            </td>
                            <th>
                                <ext:Label ID="lbl01_D2_D4" runat="server" />          
                            </th>
                            <td colspan="3">
                                <ext:Checkbox ID="chk01" Flex="1" runat="server" Width="220" Cls="inputText" >
                                    <Listeners>
                                        <Change Fn="CheckChange" />
                                    </Listeners>
                                </ext:Checkbox>
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
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />                                            
                                            <ext:ModelField Name="BAS_INV_OK_QTY" />
                                            <ext:ModelField Name="D0T1QTY" />
                                            <ext:ModelField Name="D0T2QTY" />
                                            <ext:ModelField Name="D0T3QTY" />
                                            <ext:ModelField Name="D1T1QTY" />
                                            <ext:ModelField Name="D1T2QTY" />
                                            <ext:ModelField Name="D1T3QTY" />
                                            <ext:ModelField Name="D2T1QTY" />
                                            <ext:ModelField Name="D2T2QTY" />
                                            <ext:ModelField Name="D2T3QTY" />
                                            <ext:ModelField Name="D3T1QTY" />
                                            <ext:ModelField Name="D3T2QTY" />
                                            <ext:ModelField Name="D3T3QTY" />
                                            <ext:ModelField Name="D4T1QTY" />
                                            <ext:ModelField Name="D4T2QTY" />
                                            <ext:ModelField Name="D4T3QTY" />

                                            <ext:ModelField Name="S0T1QTY" />
                                            <ext:ModelField Name="S0T2QTY" />
                                            <ext:ModelField Name="S0T3QTY" />
                                            <ext:ModelField Name="S1T1QTY" />
                                            <ext:ModelField Name="S1T2QTY" />
                                            <ext:ModelField Name="S1T3QTY" />
                                            <ext:ModelField Name="S2T1QTY" />
                                            <ext:ModelField Name="S2T2QTY" />
                                            <ext:ModelField Name="S2T3QTY" />
                                            <ext:ModelField Name="S3T1QTY" />
                                            <ext:ModelField Name="S3T2QTY" />
                                            <ext:ModelField Name="S3T3QTY" />
                                            <ext:ModelField Name="S4T1QTY" />
                                            <ext:ModelField Name="S4T2QTY" />
                                            <ext:ModelField Name="S4T3QTY" />
                                            <ext:ModelField Name="DELI_QTY" />
                                            <ext:ModelField Name="NG_QC_QTY" />
                                        </Fields>
                                    </ext:Model>
                                </Model>
                                <Listeners>
                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                    <Load Handler="GridStoreReady(App.GridStatus1, this.getTotalCount());  "></Load>
                                </Listeners>
                            </ext:Store>
                        </Store>
                        <Plugins>
                            <ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Width="40" Align="Center" Text="No" />
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /> <%--Text="PART NO"--%>  
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="320" MinWidth="200" Align="Left" Flex="1"/> <%--Text="PART NAME"--%>   
                                
                                <ext:NumberColumn ID="BAS_INV_OK_QTY" ItemID="BAS_INV_OK_QTY" runat="server" DataIndex="BAS_INV_OK_QTY" Width="80" Align="Right" Format="#,###"> <%--Text="기초재고수량"--%>     
                                    <Renderer Fn="Renderer" />
                                </ext:NumberColumn>
                                <ext:Column ID="PROD_PLAN_QTY" ItemID="PROD_PLAN_QTY" runat="server" ><%--Text="Production Plan">--%>
                                    <Columns>
                                        <ext:Column ID="DATE_P_D0" ItemID="DATE_P_D0" runat="server" ><%--Text="D0">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="D0T1QTY" ItemID="SHIFT1_CNT" runat="server" DataIndex="D0T1QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D0 SHIFT1 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />  
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="D0T2QTY" ItemID="SHIFT2_CNT" runat="server" DataIndex="D0T2QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D0 SHIFT2 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="D0T3QTY" ItemID="SHIFT3_CNT" runat="server" DataIndex="D0T3QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D0 SHIFT3 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column>
                                        <ext:Column ID="DATE_P_D1" ItemID="DATE_P_D1" runat="server" ><%--Text="D1">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="D1T1QTY" ItemID="SHIFT1_CNT" runat="server" DataIndex="D1T1QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT1 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="D1T2QTY" ItemID="SHIFT2_CNT" runat="server" DataIndex="D1T2QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT2 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="D1T3QTY" ItemID="SHIFT3_CNT" runat="server" DataIndex="D1T3QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT3 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column>

                                        <ext:Column ID="DATE_P_D2" ItemID="DATE_P_D2" runat="server" ><%--Text="D2">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="D2T1QTY" ItemID="SHIFT1_CNT" runat="server" DataIndex="D2T1QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT1 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="D2T2QTY" ItemID="SHIFT2_CNT" runat="server" DataIndex="D2T2QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT2 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="D2T3QTY" ItemID="SHIFT3_CNT" runat="server" DataIndex="D2T3QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT3 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column>

                                        <ext:Column ID="DATE_P_D3" ItemID="DATE_P_D3" runat="server" ><%--Text="D3">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="D3T1QTY" ItemID="SHIFT1_CNT" runat="server" DataIndex="D3T1QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT1 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="D3T2QTY" ItemID="SHIFT2_CNT" runat="server" DataIndex="D3T2QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT2 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="D3T3QTY" ItemID="SHIFT3_CNT" runat="server" DataIndex="D3T3QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT3 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column>

                                        <ext:Column ID="DATE_P_D4" ItemID="DATE_P_D4" runat="server" ><%--Text="D4">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="D4T1QTY" ItemID="SHIFT1_CNT" runat="server" DataIndex="D4T1QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT1 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="D4T2QTY" ItemID="SHIFT2_CNT" runat="server" DataIndex="D4T2QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT2 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="D4T3QTY" ItemID="SHIFT3_CNT" runat="server" DataIndex="D4T3QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT3 생산계획수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="SHORTAGE_PLAN" ItemID="SHORTAGE_PLAN" runat="server" ><%--Text="Production Plan">--%>
                                    <Columns>
                                        <ext:Column ID="DATE_S_D0" ItemID="DATE_S_D0" runat="server" ><%--Text="D0">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="S0T1QTY" ItemID="SHIFT1_CNT" runat="server" DataIndex="S0T1QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D0 SHIFT1 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="S0T2QTY" ItemID="SHIFT2_CNT" runat="server" DataIndex="S0T2QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D0 SHIFT2 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="S0T3QTY" ItemID="SHIFT3_CNT" runat="server" DataIndex="S0T3QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D0 SHIFT3 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column>
                                        <ext:Column ID="DATE_S_D1" ItemID="DATE_S_D1" runat="server" ><%--Text="D1">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="S1T1QTY" ItemID="SHIFT1_CNT" runat="server" DataIndex="S1T1QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT1 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="S1T2QTY" ItemID="SHIFT2_CNT" runat="server" DataIndex="S1T2QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT2 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="S1T3QTY" ItemID="SHIFT3_CNT" runat="server" DataIndex="S1T3QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT3 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column>


                                        <ext:Column ID="DATE_S_D2" ItemID="DATE_S_D2" runat="server" ><%--Text="D2">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="S2T1QTY" ItemID="SHIFT1_CNT" runat="server" DataIndex="S2T1QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT1 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="S2T2QTY" ItemID="SHIFT2_CNT" runat="server" DataIndex="S2T2QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT2 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="S2T3QTY" ItemID="SHIFT3_CNT" runat="server" DataIndex="S2T3QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT3 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column>

                                        <ext:Column ID="DATE_S_D3" ItemID="DATE_S_D3" runat="server" ><%--Text="D3">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="S3T1QTY" ItemID="SHIFT1_CNT" runat="server" DataIndex="S3T1QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT1 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="S3T2QTY" ItemID="SHIFT2_CNT" runat="server" DataIndex="S3T2QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT2 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="S3T3QTY" ItemID="SHIFT3_CNT" runat="server" DataIndex="S3T3QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT3 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column>

                                        <ext:Column ID="DATE_S_D4" ItemID="DATE_S_D4" runat="server" ><%--Text="D4">--%>
                                            <Columns>
                                                <ext:NumberColumn ID="S4T1QTY" ItemID="SHIFT1_CNT" runat="server" DataIndex="S4T1QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT1 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="S4T2QTY" ItemID="SHIFT2_CNT" runat="server" DataIndex="S4T2QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT2 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="S4T3QTY" ItemID="SHIFT3_CNT" runat="server" DataIndex="S4T3QTY" Width="90" Align="Right" Format="#,###"> <%--Text="D1 SHIFT3 SHORTAGE수량"--%>
                                                    <Renderer Fn="Renderer" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ext:Column>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="DATE_ETC_D0" ItemID="DATE_ETC_D0" runat="server" ><%--Text="D0">--%>
                                    <Columns>
                                        <ext:NumberColumn ID="DELIVERY" ItemID="DELIVERY" runat="server" DataIndex="DELI_QTY" Width="90" Align="Right" Format="#,###"> <%--Text="DELIVERY수량"--%>
                                            <Renderer Fn="Renderer" />
                                        </ext:NumberColumn>
                                        <ext:NumberColumn ID="NG_QC" ItemID="NG_QC" runat="server" DataIndex="NG_QC_QTY" Width="90" Align="Right" Format="#,###"> <%--Text="NG/QC수량"--%>
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
