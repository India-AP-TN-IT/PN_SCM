<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_ZSD30014.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_SD.SRM_ZSD30014" %>
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

    <title>Weekly(JIS)</title>

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
            var bizcd = "";
            var vincd = "";
            if (App.SelectBox01_BIZCD.getValue() != null) {
                bizcd = App.SelectBox01_BIZCD.getValue().toString();
            }
            if (App.sbox01_VINCD.getValue() != null) {
                vincd = App.sbox01_VINCD.getValue().toString();
            }
            App.direct.SetComboBindItem(bizcd, vincd);
        };

        var fn_PlandateChange = function () {
            var bizcd = "";
            if (App.SelectBox01_BIZCD.getValue() != null) {
                bizcd = App.SelectBox01_BIZCD.getValue().toString();
            }
            App.direct.SetComboBindWorkDirDiv(bizcd, App.df01_BEG_DATE.getValue());
        };

    </script>
</head>
<body>
    <form id="SRM_ZSD30014" runat="server">
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
                    <ext:Label ID="lbl01_SRM_ZSD30014" runat="server" Cls="search_area_title_name" /><%--Text="서열 부품 상세" />--%>
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
                            <col style="width: 150px;" />
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th >
                                <ext:Label ID="lbl01_BIZCD" runat="server" /><%--Text="Business Code" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="BIZCDTYPE" ValueField="BIZCD" TriggerAction="All" Width="260">
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
                                    <%--<Listeners>
                                        <Change Fn="fn_BizcdChange"></Change>
                                    </Listeners>--%>
                                </ext:SelectBox>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_WORK_DATE3" runat="server" /><%--Text="일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_BEG_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   >
                                    <%--<Listeners>
                                        <Change Fn="fn_PlandateChange"></Change>
                                    </Listeners>--%>
                                </ext:DateField>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_VINCD" runat="server" /><%--Text="Vihicle Code" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="sbox01_VINCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="VINNM" ValueField="MODELCD" TriggerAction="All" Width="146">
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
                                    <%--<Listeners>
                                        <Change Fn="fn_VincdChange"></Change>
                                    </Listeners>--%>
                                </ext:SelectBox>
                            </td>
                        </tr> 
                        <tr>
                            <%--<th>                                
                                <ext:Label ID="lbl01_WORK_DIR_DIV" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="sbox_WORK_DIR_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPENM" ValueField="OBJECT_ID" TriggerAction="All" Width="146">
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
                            </td>--%><%--Text="작업지시구분" />--%>
                            <th>
                                <!-- 품목 -->
                                <ext:Label ID="lbl01_ITEM" runat="server" /><%--Text="품목" />--%>
                            </th>
                            <td colspan="5">
                                <ext:SelectBox ID="sbox_ITEM" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="CUST_ITEMNM" ValueField="CUST_ITEMCD" TriggerAction="All" Width="260">
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
                                            <ext:ModelField Name="PLAN_DATE" />
                                            <%--<ext:ModelField Name="PROC_DIV" />--%>
                                            <%--<ext:ModelField Name="VEND_VINCD" />--%>
                                            <ext:ModelField Name="VINCD" />
                                            <%--<ext:ModelField Name="TYPECD" />--%>
                                            <ext:ModelField Name="VEND_ITEM_TYPECD" />
                                            <%--<ext:ModelField Name="VEND_ITEM_TYPENM" />--%>
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="VEND_PLANTCD" />
                                            <%--<ext:ModelField Name="WORK_DIR_DIV2" />--%>
                                            <ext:ModelField Name="PREVDAY_RSLT_QTY" />
                                            <ext:ModelField Name="WBS_QTY" />
                                            <ext:ModelField Name="PAINT_REJECT_QTY" />
                                            <ext:ModelField Name="PBS_QTY" />
                                            <ext:ModelField Name="WEEK0_QTY" />
                                            <ext:ModelField Name="WEEK1_QTY" />
                                            <ext:ModelField Name="WEEK2_QTY" />
                                            <ext:ModelField Name="WEEK3_QTY" />
                                            <ext:ModelField Name="WEEK4_QTY" />
                                            <ext:ModelField Name="WEEK5_QTY" />
                                            <ext:ModelField Name="WEEK6_QTY" />
                                            <ext:ModelField Name="WEEK7_QTY" />
                                            <ext:ModelField Name="WEEK8_QTY" />
                                            <ext:ModelField Name="WEEK9_QTY" />
                                            <ext:ModelField Name="WEEK10_QTY" />
                                            <ext:ModelField Name="WEEK11_QTY" />
                                            <ext:ModelField Name="WEEK12_QTY" />
                                            <ext:ModelField Name="WEEK12_QTY" />
                                            <ext:ModelField Name="WEEK13_QTY" />
                                            <ext:ModelField Name="WEEK14_QTY" />
                                            <ext:ModelField Name="WEEK15_QTY" />
                                            <ext:ModelField Name="WEEK16_QTY" />
                                            <ext:ModelField Name="WEEK17_QTY" />
                                            <ext:ModelField Name="WEEK18_QTY" />
                                            <ext:ModelField Name="WEEK19_QTY" />
                                            <ext:ModelField Name="WEEK20_QTY" />                                         
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
                            <%--<ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>--%>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:DateColumn ID="PLAN_DATE" ItemID="PLAN_DATE" runat="server" DataIndex="PLAN_DATE" Width="80" Align="Center" Locked="true"/><%--Text="계획일자"--%>   
                                <%--<ext:Column ID="PROC_DIV" ItemID="PROC_DIV" runat="server" DataIndex="PROC_DIV" Width="60" Align="Center" Locked="true"/>--%><%--Text="처리구분"--%>   
                                <%--<ext:Column ID="VEND_VINCD" ItemID="VEND_VIN" runat="server" DataIndex="VEND_VINCD" Width="70" Align="Center" Locked="true"/>--%><%--Text="고객사차종"--%> 
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="70" Align="Center" Locked="true"/><%--Text="당사차종" --%>                                  
                                <ext:Column ID="VEND_PLANTCD"           ItemID="PLANT"         runat="server" DataIndex="VEND_PLANTCD"     Width="50" Align="Center" Locked="true" /><%--Text="공장"--%>       
                                <%--<ext:Column ID="TYPECD" ItemID="TYPECD" runat="server" Text="코드" DataIndex="TYPECD"   Width="100" Align="Center" Locked="true"/>--%>
                                <%--<ext:Column ID="VEND_ITEM" ItemID="VEND_ITEM" runat="server" Locked="true">
                                    <Columns>--%>
                                        <ext:Column ID="VEND_ITEM_TYPECD" ItemID="ITEM" runat="server" DataIndex="VEND_ITEM_TYPECD" Width="40" Align="Center" Sortable="true" Locked="true"/><%--Text="코드"--%>       
                                        <%--<ext:Column ID="VEND_ITEM_TYPENM" ItemID="TYPENM"      runat="server" DataIndex="VEND_ITEM_TYPENM" Width="150"  Align="Left"  Sortable="true"/>--%><%--Text="유형명"--%>     
                                    <%--</Columns>
                                </ext:Column>--%><%--Text="고객사품목" --%>
                                <ext:Column ID="ALCCD"                  ItemID="ALCCD"         runat="server" DataIndex="ALCCD"            Width="50" Align="Center" Locked="true"/> <%--Text="ALC코드" --%>   
                                <%--<ext:Column ID="WORK_DIR_DIV2"          ItemID="WORK_DIR_DIV2" runat="server" DataIndex="WORK_DIR_DIV2"    Width="60" Align="Center" Locked="true" />--%><%--Text="작업지시" --%>  
                                <ext:NumberColumn ID="PREVDAY_RSLT_QTY" ItemID="PREVDAY_RSLT"  runat="server" DataIndex="PREVDAY_RSLT_QTY" Width="85" Align="Right" Format="#,##0"/> <%--Text="전일실적"--%>   
                                <ext:NumberColumn ID="WBS_QTY"          ItemID="WBS"           runat="server" DataIndex="WBS_QTY"          Width="60" Align="Right" Format="#,##0"/> <%--Text="WBS"--%>        
                                <ext:NumberColumn ID="PAINT_REJECT_QTY" ItemID="PAINT_REJECT"  runat="server" DataIndex="PAINT_REJECT_QTY" Width="50" Align="Right" Format="#,##0"/> <%--Text="REJ"--%>        
                                <ext:NumberColumn ID="PBS_QTY"          ItemID="PBS"           runat="server" DataIndex="PBS_QTY"          Width="50" Align="Right" Format="#,##0"/> <%--Text="PBS"--%>        
                                <ext:NumberColumn ID="WEEK0_QTY"        Text="W"              runat="server" DataIndex="WEEK0_QTY"       Width="60" Align="Right" Format="#,##0"/> <%--Text="W" --%>         
                                <ext:NumberColumn ID="WEEK1_QTY"        Text="W+1"            runat="server" DataIndex="WEEK1_QTY"       Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+1"--%>        
                                <ext:NumberColumn ID="WEEK2_QTY"        Text="W+2"            runat="server" DataIndex="WEEK2_QTY"       Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+2" --%>       
                                <ext:NumberColumn ID="WEEK3_QTY"        Text="W+3"            runat="server" DataIndex="WEEK3_QTY"       Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+3"--%>        
                                <ext:NumberColumn ID="WEEK4_QTY"        Text="W+4"            runat="server" DataIndex="WEEK4_QTY"       Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+4" --%>       
                                <ext:NumberColumn ID="WEEK5_QTY"        Text="W+5"            runat="server" DataIndex="WEEK5_QTY"       Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+5"--%>        
                                <ext:NumberColumn ID="WEEK6_QTY"        Text="W+6"            runat="server" DataIndex="WEEK6_QTY"       Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+6"--%>        
                                <ext:NumberColumn ID="WEEK7_QTY"        Text="W+7"            runat="server" DataIndex="WEEK7_QTY"       Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+7"--%>        
                                <ext:NumberColumn ID="WEEK8_QTY"        Text="W+8"            runat="server" DataIndex="WEEK8_QTY"       Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+8" --%>       
                                <ext:NumberColumn ID="WEEK9_QTY"        Text="W+9"            runat="server" DataIndex="WEEK9_QTY"       Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+9" --%>       
                                <ext:NumberColumn ID="WEEK10_QTY"       Text="W+10"           runat="server" DataIndex="WEEK10_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+10"--%>       
                                <ext:NumberColumn ID="WEEK11_QTY"       Text="W+11"           runat="server" DataIndex="WEEK11_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+11"--%>       
                                <ext:NumberColumn ID="WEEK12_QTY"       Text="W+12"           runat="server" DataIndex="WEEK12_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+12"  --%>    
                                <ext:NumberColumn ID="WEEK13_QTY"       Text="W+13"           runat="server" DataIndex="WEEK13_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+13"  --%>
                                <ext:NumberColumn ID="WEEK14_QTY"       Text="W+14"           runat="server" DataIndex="WEEK14_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+14"  --%>
                                <ext:NumberColumn ID="WEEK15_QTY"       Text="W+15"           runat="server" DataIndex="WEEK15_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+15"  --%>
                                <ext:NumberColumn ID="WEEK16_QTY"       Text="W+16"           runat="server" DataIndex="WEEK16_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+16"  --%>
                                <ext:NumberColumn ID="WEEK17_QTY"       Text="W+17"           runat="server" DataIndex="WEEK17_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+17"  --%>
                                <ext:NumberColumn ID="WEEK18_QTY"       Text="W+18"           runat="server" DataIndex="WEEK18_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+18"  --%>
                                <ext:NumberColumn ID="WEEK19_QTY"       Text="W+19"           runat="server" DataIndex="WEEK19_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+19"  --%>
                                <ext:NumberColumn ID="WEEK20_QTY"       Text="W+20"           runat="server" DataIndex="WEEK20_QTY"      Width="60" Align="Right" Format="#,##0"/>  <%--Text="W+20"  --%>                                 
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
