<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_SD30011.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_SD.SRM_SD30011" %>
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

    <title>서열부품 종합(P7)</title>

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

        var fn_BizcdChange = function () {
            var bizcd = "";
            if (App.SelectBox01_BIZCD.getValue() != null) {
                bizcd = App.SelectBox01_BIZCD.getValue().toString();
            }
            App.direct.SetComboBindVincd(bizcd);
        };

        var fn_VincdChange = function () {
            /*
            var bizcd = "";
            var vincd = "";
            if (App.SelectBox01_BIZCD.getValue() != null) {
                bizcd = App.SelectBox01_BIZCD.getValue().toString();
            }
            if (App.sbox01_VINCD.getValue() != null) {
                vincd = App.sbox01_VINCD.getValue().toString();
            }
            App.direct.SetComboBindItem(bizcd, vincd);
            */
        };

        var fn_PlandateChange = function () {
            var bizcd = "";
            if (App.SelectBox01_BIZCD.getValue() != null) {
                bizcd = App.SelectBox01_BIZCD.getValue().toString();
            }
            var str = App.df01_BEG_DATE.getValue();
            var pattern = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;

            if (!pattern.test(str))
                return;

            App.direct.SetComboBindWorkDirDiv(bizcd, App.df01_BEG_DATE.getValue());
        };

    </script>
</head>
<body>
    <form id="SRM_SD30011" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server" AjaxTimeout="60000">
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
                    <ext:Label ID="lbl01_SRM_SD30011" runat="server" Cls="search_area_title_name" /><%--Text="서열 부품 상세" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 100px;" />
                            <col style="width: 180px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 180px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 180px;"/>
                            <col style="width: 100px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_BIZCD" runat="server" /><%--Text="Business Code" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
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
                                    <Listeners>
                                        <Change Fn="fn_BizcdChange"></Change>
                                    </Listeners>
                                </ext:SelectBox>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_WORK_DATE3" runat="server" /><%--Text="일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_BEG_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   >
                                    <Listeners>
                                        <Change Fn="fn_PlandateChange"></Change>
                                    </Listeners>
                                </ext:DateField>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_HANIL_VIN" runat="server" />                 
                            </th>
                            <td>
                                <ext:TextField ID="txt01_VINCD" Width="120" Cls="inputText" runat="server" />                             
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_ALCCD" runat="server" Text="ALC" />                 
                            </th>
                            <td>
                                <ext:TextField ID="txt01_ALCCD" Width="120" Cls="inputText" runat="server" />                             
                            </td>
                            <th style="display:none";>
                                <ext:Label ID="lbl01_VINCD" runat="server" /><%--Text="Vihicle Code" />--%>
                            </th>
                            <td style="display:none";>
                                <ext:SelectBox ID="sbox01_VINCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="VINNM" ValueField="MODELCD" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>                                                       
                                                        <ext:ModelField Name="MODELCD" />
                                                        <ext:ModelField Name="VINNM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <Listeners>
                                        <Change Fn="fn_VincdChange"></Change>
                                    </Listeners>
                                </ext:SelectBox>
                            </td>
                        </tr> 
                        <tr style="display:none;">
                            <th>                                
                                <ext:Label ID="lbl01_WORK_DIR_DIV" runat="server" /><%--Text="작업지시구분" />--%>
                            </th>
                            <td colspan="5">
                                <ext:SelectBox ID="sbox_WORK_DIR_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPENM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="TYPENM" />
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>

                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>
                            <%-- SRM 사용안함
                            <th>
                                <!-- 품목 -->
                                <ext:Label ID="lbl01_ITEM" runat="server" />
                            </th>
                            <td colspan="3">
                                <ext:SelectBox ID="sbox_ITEM" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="CUST_ITEMNM" ValueField="CUST_ITEMCD" TriggerAction="All" Width="146">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="CUST_ITEMNM" />
                                                        <ext:ModelField Name="CUST_ITEMCD" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>

                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>
                            --%>                         
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50" >
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="PLAN_DATE" />
                                            <ext:ModelField Name="PROC_DIV" />
                                            <ext:ModelField Name="VEND_VINCD" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="TYPECD" />
                                            <ext:ModelField Name="VEND_ITEM_TYPECD" />
                                            <ext:ModelField Name="VEND_ITEM_TYPENM" />
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="VEND_PLANTCD" />
                                            <ext:ModelField Name="WORK_DIR_DIV2" />
                                            <ext:ModelField Name="PREVDAY_RSLT_QTY" />
                                            <ext:ModelField Name="PBS_QTY" />
                                            <ext:ModelField Name="PAINT_REJECT_QTY" />
                                            <ext:ModelField Name="WBS_QTY" />
                                            <ext:ModelField Name="DDAY_QTY" />
                                            <ext:ModelField Name="D1DAY_QTY" />
                                            <ext:ModelField Name="D2DAY_QTY" />
                                            <ext:ModelField Name="D3DAY_QTY" />
                                            <ext:ModelField Name="D4DAY_QTY" />
                                            <ext:ModelField Name="D5DAY_QTY" />
                                            <ext:ModelField Name="D6DAY_QTY" />
                                            <ext:ModelField Name="D7DAY_QTY" />
                                            <ext:ModelField Name="D8DAY_QTY" />
                                            <ext:ModelField Name="D9DAY_QTY" />
                                            <ext:ModelField Name="D10DAY_QTY" />
                                            <ext:ModelField Name="D11DAY_QTY" />
                                            <ext:ModelField Name="D12DAY_QTY" />

                                            <ext:ModelField Name="D13DAY_QTY" />
                                            <ext:ModelField Name="D14DAY_QTY" />
                                            <ext:ModelField Name="D15DAY_QTY" />
                                            <ext:ModelField Name="D16DAY_QTY" />
                                            <ext:ModelField Name="D17DAY_QTY" />
                                            <ext:ModelField Name="D18DAY_QTY" />
                                            <ext:ModelField Name="D19DAY_QTY" />
                                            <ext:ModelField Name="D20DAY_QTY" />
                                            <ext:ModelField Name="D21DAY_QTY" />
                                            <ext:ModelField Name="D22DAY_QTY" />
                                            <ext:ModelField Name="D23DAY_QTY" />
                                            <ext:ModelField Name="D24DAY_QTY" />
                                            <ext:ModelField Name="D25DAY_QTY" />
                                            <ext:ModelField Name="D26DAY_QTY" />
                                            <ext:ModelField Name="D27DAY_QTY" />
                                            <ext:ModelField Name="D28DAY_QTY" />
                                            <ext:ModelField Name="D29DAY_QTY" />
                                            <ext:ModelField Name="D30DAY_QTY" />

                                            <ext:ModelField Name="P7_REMAIN_QTY" />
                                            <ext:ModelField Name="FULL_TOT_QTY" />
                                            <ext:ModelField Name="MITU" />
                                            <ext:ModelField Name="PRE_SEQ" />
                                            <ext:ModelField Name="TMONTH_SURP_QTY" />
                                            <ext:ModelField Name="OSTAND_ORDER_QTY" />
                                            <ext:ModelField Name="P7_FULL_TOT_QTY" />                                            
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
                            <%--<ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>--%>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO"          ItemID="NO"            runat="server" Text="No"                                     Width="40" Align="Center" />
                                <ext:DateColumn ID="PLAN_DATE"          ItemID="PLAN_DATE"     runat="server" DataIndex="PLAN_DATE"       Width="80" Align="Center" Locked="true"/><%--Text="계획일자"--%>   
                                <ext:Column ID="PROC_DIV"               ItemID="PROC_DIV"      runat="server" DataIndex="PROC_DIV"        Width="60" Align="Center" Locked="true"/><%--Text="처리구분"--%>   
                                <ext:Column ID="VEND_VINCD"             ItemID="VEND_VIN"      runat="server" DataIndex="VEND_VINCD"      Width="70" Align="Center" Locked="true"/><%--Text="고객사차종"--%> 
                                <ext:Column ID="VINCD"                  ItemID="HANIL_VIN"     runat="server" DataIndex="VINCD"           Width="60" Align="Center" Locked="true"/><%--Text="당사차종" --%>                                  
                                <%--<ext:Column ID="TYPECD"              ItemID="TYPECD"      runat="server" Text="코드"    DataIndex="TYPECD"   Width="100" Align="Center" Locked="true"/>--%>
                                <ext:Column ID="VEND_ITEM"              ItemID="VEND_ITEM"     runat="server" Locked="true"><%--Text="고객사품목" --%>
                                    <Columns>
                                        <ext:Column ID="VEND_ITEM_TYPECD" ItemID="CODE"        runat="server" DataIndex="VEND_ITEM_TYPECD" Width="40"   Align="Center"  Sortable="true"/><%--Text="코드"--%>       
                                        <ext:Column ID="VEND_ITEM_TYPENM" ItemID="TYPENM"      runat="server" DataIndex="VEND_ITEM_TYPENM" Width="150"  Align="Left"  Sortable="true"/><%--Text="유형명"--%>     
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="ALCCD"                  ItemID="ALCCD"         runat="server" DataIndex="ALCCD"            Width="50" Align="Center" Locked="true"/> <%--Text="ALC코드" --%>   
                                <ext:Column ID="VEND_PLANTCD"           ItemID="PLANT"         runat="server" DataIndex="VEND_PLANTCD"     Width="40" Align="Center" Locked="true" /><%--Text="공장"--%>       
                                <ext:Column ID="WORK_DIR_DIV2"          ItemID="WORK_DIR_DIV2" runat="server" DataIndex="WORK_DIR_DIV2"    Width="60" Align="Center" Locked="true" /><%--Text="작업지시" --%>  
                                <ext:NumberColumn ID="PREVDAY_RSLT_QTY" ItemID="PREVDAY_RSLT"  runat="server" DataIndex="PREVDAY_RSLT_QTY" Width="80" Align="Right" Format="#,##0.###"/> <%--Text="전일실적"--%>   
                                <ext:NumberColumn ID="PBS_QTY"          ItemID="PBS"           runat="server" DataIndex="PBS_QTY"          Width="50" Align="Right" Format="#,##0.###"/> <%--Text="PBS"--%>        
                                <ext:NumberColumn ID="PAINT_REJECT_QTY" ItemID="PAINT_REJECT"  runat="server" DataIndex="PAINT_REJECT_QTY" Width="50" Align="Right" Format="#,##0.###"/> <%--Text="REJ"--%>        
                                <ext:NumberColumn ID="WBS_QTY"          ItemID="WBS"           runat="server" DataIndex="WBS_QTY"          Width="55" Align="Right" Format="#,##0.###"/> <%--Text="WBS"4.X사이즈조절--%>        
                                <ext:NumberColumn ID="DDAY_QTY"         ItemID="D"             runat="server" DataIndex="DDAY_QTY"         Width="40" Align="Right" Format="#,##0.###"/> <%--Text="D" 4.X사이즈조절--%>         
                                <ext:NumberColumn ID="D1DAY_QTY"        ItemID="D1"            runat="server" DataIndex="D1DAY_QTY"       Width="55" Align="Right" Format="#,##0.###"/>  <%--Text="D+1"4.X사이즈조절--%>        
                                <ext:NumberColumn ID="D2DAY_QTY"        ItemID="D2"            runat="server" DataIndex="D2DAY_QTY"       Width="55" Align="Right" Format="#,##0.###"/>  <%--Text="D+2" 4.X사이즈조절--%>       
                                <ext:NumberColumn ID="D3DAY_QTY"        ItemID="D3"            runat="server" DataIndex="D3DAY_QTY"       Width="55" Align="Right" Format="#,##0.###"/>  <%--Text="D+3"4.X사이즈조절--%>        
                                <ext:NumberColumn ID="D4DAY_QTY"        ItemID="D4"            runat="server" DataIndex="D4DAY_QTY"       Width="55" Align="Right" Format="#,##0.###"/>  <%--Text="D+4" 4.X사이즈조절--%>       
                                <ext:NumberColumn ID="D5DAY_QTY"        ItemID="D5"            runat="server" DataIndex="D5DAY_QTY"       Width="55" Align="Right" Format="#,##0.###"/>  <%--Text="D+5"4.X사이즈조절--%>        
                                <ext:NumberColumn ID="D6DAY_QTY"        ItemID="D6"            runat="server" DataIndex="D6DAY_QTY"       Width="55" Align="Right" Format="#,##0.###"/>  <%--Text="D+6"4.X사이즈조절--%>        
                                <ext:NumberColumn ID="D7DAY_QTY"        ItemID="D7"            runat="server" DataIndex="D7DAY_QTY"       Width="55" Align="Right" Format="#,##0.###"/>  <%--Text="D+7"4.X사이즈조절--%>        
                                <ext:NumberColumn ID="D8DAY_QTY"        ItemID="D8"            runat="server" DataIndex="D8DAY_QTY"       Width="55" Align="Right" Format="#,##0.###"/>  <%--Text="D+8" 4.X사이즈조절--%>       
                                <ext:NumberColumn ID="D9DAY_QTY"        ItemID="D9"            runat="server" DataIndex="D9DAY_QTY"       Width="55" Align="Right" Format="#,##0.###"/>  <%--Text="D+9" 4.X사이즈조절--%>       
                                <ext:NumberColumn ID="D10DAY_QTY"       ItemID="D10"           runat="server" DataIndex="D10DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+10"4.X사이즈조절--%>       
                                <ext:NumberColumn ID="D11DAY_QTY"       ItemID="D11"           runat="server" DataIndex="D11DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+11"4.X사이즈조절--%>       
                                <ext:NumberColumn ID="D12DAY_QTY"       ItemID="D12"           runat="server" DataIndex="D12DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+12"  4.X사이즈조절--%>                                 

                                <ext:NumberColumn ID="D13DAY_QTY"       ItemID="D13"           runat="server" DataIndex="D13DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+13"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D14DAY_QTY"       ItemID="D14"           runat="server" DataIndex="D14DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+14"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D15DAY_QTY"       ItemID="D15"           runat="server" DataIndex="D15DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+15"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D16DAY_QTY"       ItemID="D16"           runat="server" DataIndex="D16DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+16"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D17DAY_QTY"       ItemID="D17"           runat="server" DataIndex="D17DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+17"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D18DAY_QTY"       ItemID="D18"           runat="server" DataIndex="D18DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+18"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D19DAY_QTY"       ItemID="D19"           runat="server" DataIndex="D19DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+19"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D20DAY_QTY"       ItemID="D20"           runat="server" DataIndex="D20DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+20"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D21DAY_QTY"       ItemID="D21"           runat="server" DataIndex="D21DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+21"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D22DAY_QTY"       ItemID="D22"           runat="server" DataIndex="D22DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+22"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D23DAY_QTY"       ItemID="D23"           runat="server" DataIndex="D23DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+23"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D24DAY_QTY"       ItemID="D24"           runat="server" DataIndex="D24DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+24"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D25DAY_QTY"       ItemID="D25"           runat="server" DataIndex="D25DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+25"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D26DAY_QTY"       ItemID="D26"           runat="server" DataIndex="D26DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+26"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D27DAY_QTY"       ItemID="D27"           runat="server" DataIndex="D27DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+27"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D28DAY_QTY"       ItemID="D28"           runat="server" DataIndex="D28DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+28"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D29DAY_QTY"       ItemID="D29"           runat="server" DataIndex="D29DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+29"  4.X사이즈조절--%>                                 
                                <ext:NumberColumn ID="D30DAY_QTY"       ItemID="D30"           runat="server" DataIndex="D30DAY_QTY"      Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="D+30"  4.X사이즈조절--%>      

                                <ext:NumberColumn ID="P7_REMAIN_QTY"    ItemID="P7_REM"        runat="server" DataIndex="P7_REMAIN_QTY"   Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="REM"  --%>      
                                <ext:NumberColumn ID="FULL_TOT_QTY"     ItemID="STOT"          runat="server" DataIndex="FULL_TOT_QTY"    Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="STOT"--%>       
                                <ext:NumberColumn ID="MITU"             ItemID="MITU"          runat="server" DataIndex="MITU"            Width="70" Align="Right" Format="#,##0.###"/>  <%--Text="MITU"--%>       
                                <ext:NumberColumn ID="PRE_SEQ"          ItemID="PRE_SEQ"       runat="server" DataIndex="PRE_SEQ"         Width="60" Align="Right" Format="#,##0.###"/>  <%--Text="PRE-SEQ"--%>    
                                <ext:NumberColumn ID="TMONTH_SURP_QTY"  ItemID="TMONTH"        runat="server" DataIndex="TMONTH_SURP_QTY" Width="70" Align="Right" Format="#,##0.###"/>  <%--Text="M" --%>         
                                <ext:NumberColumn ID="OSTAND_ORDER_QTY" ItemID="OSTAND"        runat="server" DataIndex="OSTAND_ORDER_QTY" Width="70" Align="Right" Format="#,##0.###"/> <%--Text="M+1"--%>        
                                <ext:NumberColumn ID="P7_FULL_TOT_QTY"  ItemID="P7_TOTAL"      runat="server" DataIndex="P7_FULL_TOT_QTY"  Width="70" Align="Right" Format="#,##0.###"/> <%--Text="P7 TOTAL"--%>   
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
