<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP30010.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MP.SRM_MP30010" %>
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
        .bottom_area_title_name2 { clear:both;  margin-top:0px; height:20px; display:block; background:url(../../images/common/title_icon_s.gif) 0 8px no-repeat; padding-left:10px;font-size:12px;color:#010101;text-align:left;font-weight:bold;}
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        //        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        //        그리드 스크롤바 있을 때, 포커스 막 이동시 스크롤이 맨앞으로 갔다가 다시 돌아오면서 화면에 잔상 남는 부분때문에 추가
        //        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        Ext.override(Ext.view.Table,
        {
            focusRow: function (rowIdx) {
                var me = this,
                    row,
                    gridCollapsed = me.ownerCt && me.ownerCt.collapsed,
                    record;
                if (me.isVisible(true) && !gridCollapsed && (row = me.getNode(rowIdx, true)) && me.el) {
                    record = me.getRecord(row);
                    rowIdx = me.indexInStore(row);

                    me.selModel.setLastFocused(record);
                    if (!Ext.isIE) {
                        row.focus();
                    }
                    me.focusedRow = row;
                    me.fireEvent('rowfocus', record, row, rowIdx);
                }
            }
        }
        );

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
            App.BottomGridPanel.setHeight(App.pnl01_Bottom.getHeight() - 30);
            App.Grid02.setHeight(App.BottomGridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        // 그리드의 셀 클릭시 사용하는 메서드
        var CellClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

            var vendCd = grid.getStore().getAt(rowIndex).data["VENDCD"];
            var rcvMonth = grid.getStore().getAt(rowIndex).data["RCV_MONTH"];
            var rcvType = grid.getStore().getAt(rowIndex).data["RCV_TYPE"];
            var purcOrg = grid.getStore().getAt(rowIndex).data["PURC_ORG"];
            var vatCd = grid.getStore().getAt(rowIndex).data["VATCD"];
            var rcvBizcd = grid.getStore().getAt(rowIndex).data["RCV_BIZCD"];

            App.ACC_VENDCD.setValue(vendCd);
            App.ACC_MONTH.setValue(rcvMonth);
            App.ACC_RCV_TYPE.setValue(rcvType);
            App.ACC_PURC_ORG.setValue(purcOrg);
            App.ACC_VATCD.setValue(vatCd);
            App.ACC_RCV_BIZCD.setValue(rcvBizcd);

            App.direct.Grid01_Cell_Click(vendCd, rcvMonth, rcvType, purcOrg, vatCd, rcvBizcd);
        }
             
    </script>
</head>
<body>
    <form id="SRM_MP30010" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:TextField ID="ACC_VENDCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="ACC_MONTH" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="ACC_RCV_TYPE" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="ACC_PURC_ORG" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="ACC_VATCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="ACC_RCV_BIZCD" runat="server" Hidden="true"></ext:TextField>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MP30010" runat="server" Cls="search_area_title_name" /><%--Text="월납품현황" --%>
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
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
							<th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
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
                                <ext:Label ID="lbl01_RCV_DATE2" runat="server"/>
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
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>

            <ext:Panel ID="Panel2" runat="server" Region="North" Height="20" >
                <Content>
                    <table style="height:0px;">
                        <tr>
                            <td>
                            </td>    
                        </tr> 
                </Content>
            </ext:Panel>

            <ext:Panel ID="GridPanel" Region="North" Border="True" runat="server" Cls="grid_area" StyleSpec="margin-bottom:10px;" Height="180">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="NO"/>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="VENDNM"/>
                                            <ext:ModelField Name="RCV_MONTH"/>
                                            <ext:ModelField Name="RCV_TYPENM"/>
                                            <ext:ModelField Name="PURC_ORGNM"/>
                                            <ext:ModelField Name="VATNM"/>
                                            <ext:ModelField Name="COINCD"/>
                                            <ext:ModelField Name="AMT"/>
                                            <ext:ModelField Name="VAT"/>
                                            <ext:ModelField Name="RCV_AMT"/>
                                            <ext:ModelField Name="PREPAY_AMT"/>
                                            <ext:ModelField Name="PAY_TOT_AMT"/>
                                            <ext:ModelField Name="RCV_BIZNM"/>
                                            <ext:ModelField Name="RCV_TYPE"/>
                                            <ext:ModelField Name="PURC_ORG"/>
                                            <ext:ModelField Name="VATCD"/>
                                            <ext:ModelField Name="RCV_BIZCD"/>
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
                                <ext:Column ID="VENDCD" ItemID="VENDORCD" runat="server" DataIndex="VENDCD" Width="75" Align="Center" />  <%--Text="거래처코드"--%> 
                                <ext:Column ID="VENDNM" ItemID="VENDORNM" runat="server" DataIndex="VENDNM" Width="200" Align="Left" />  <%--Text="거래처명"--%> 
                                <ext:Column ID="RCV_MONTH" ItemID="RCV_DATE2" runat="server" DataIndex="RCV_MONTH" Width="100" Align="Center" />  <%--Text="전기일자"--%> 
                                <ext:Column ID="RCV_TYPENM" ItemID="RCV_TYPE2" runat="server" DataIndex="RCV_TYPENM" Width="80" Align="Left" />  <%--Text="마감유형"--%> 
                                <ext:Column ID="PURC_ORGNM" ItemID="PURC_ORG" runat="server" DataIndex="PURC_ORGNM" Width="65" Align="Center" />  <%--Text="구매조직"--%> 
                                <ext:Column ID="VATNM" ItemID="STAXCD" runat="server" DataIndex="VATNM" Width="250" Align="Left" />  <%--Text="부가세코드"--%> 
                                <ext:Column ID="COINCD" ItemID="REC_WAERS" runat="server" DataIndex="COINCD" Width="40" Align="Center" />  <%--Text="통화"--%> 
                                <ext:NumberColumn ID="AMT" ItemID="SUPPLYAMT_A" runat="server" DataIndex="AMT" Width="120" Align="Right" Format="#,##0" />  <%--Text="공급가액(A)"--%> 
                                <ext:NumberColumn ID="VAT" ItemID="SURTAXAMT_B" runat="server" DataIndex="VAT" Width="120" Align="Right" Format="#,##0" />  <%--Text="부가세액(B)"--%> 
                                <ext:NumberColumn ID="RCV_AMT" ItemID="TOTALAMT_AB" runat="server" DataIndex="RCV_AMT" Width="120" Align="Right" Format="#,##0" />  <%--Text="총금액(A+B)"--%> 
                                <ext:NumberColumn ID="PREPAY_AMT" ItemID="PREPAY_AMT_C" runat="server" DataIndex="PREPAY_AMT" Width="120" Align="Right" Format="#,##0" />  <%--Text="(기)지급선급금(C)"--%> 
                                <%--<ext:NumberColumn ID="PAY_TOT_AMT" ItemID="SUPPLYAMT_AC" runat="server" DataIndex="PAY_TOT_AMT" Width="130" Align="Right" Format="#,##0" /> %>  <%--Text="공급가 총액(A+C)"--%> 
                                <ext:Column ID="RCV_BIZNM" ItemID="RCV_BIZCD" runat="server" DataIndex="RCV_BIZNM" Width="100" Align="Left" />  <%--Text="발행사업장"--%> 
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
                        
                        <Listeners>
                            <CellClick Fn ="CellClick"></CellClick>
                        </Listeners>                                                    
                                          
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="pnl01_Bottom" runat="server" Region="Center" Flex="2">
                <Items>
                    <ext:Panel ID="ButtonPanel05" runat="server" Region="North" Height="23" Hidden="false" >
                        <Items> 
                            <ext:Panel ID="Panel15" runat="server" StyleSpec="margin-right:10px; float:left;" Width="80" Hidden="false">
                                <Items>
                                    <ext:Label ID="lbl01_DETAIL_INFO" runat="server" Cls="bottom_area_title_name2" Text="상세정보"/><%--Text="* 상세정보"--%>
                                </Items>
                            </ext:Panel>
                            <ext:Panel ID="Panel1" runat="server" StyleSpec="margin-right:10px; float:left;" Width="1000" Hidden="false">
                                <Items>
                                    <ext:Label ID="lbl02_DETAIL_INFO2" runat="server" Text="(상세정보 엑셀 다운로드 방법 : 아래 상세정보를 내용을 클릭하신 후 상단의 'Excel D/L' 버튼을 눌러 주세요)"/><%--Text="* 상세정보"--%>
                                </Items>
                            </ext:Panel>
                        </Items> 
                    </ext:Panel>
                    <ext:Panel ID="BottomGridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                        <Items>  
                            <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store7" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="Model4" runat="server">
                                                <Fields>                                       
                                                    <ext:ModelField Name="NO" />
                                                    <ext:ModelField Name="RCV_DATE" />
                                                    <ext:ModelField Name="RCV_NO" />
                                                    <ext:ModelField Name="RCV_SEQ" />
                                                    <ext:ModelField Name="DELI_QTY" />
                                                    <ext:ModelField Name="UCOST" />
                                                    <ext:ModelField Name="RCV_AMT" />
                                                    <ext:ModelField Name="COINCD" />
                                                    <ext:ModelField Name="PURC_ORG" />
                                                    <ext:ModelField Name="PURC_GRP" />
                                                    <ext:ModelField Name="PONO" />
                                                    <ext:ModelField Name="PARTNO" />
                                                    <ext:ModelField Name="PARTNM" />
                                                    <ext:ModelField Name="UNIT" />
                                                    <ext:ModelField Name="RCV_NAME" />
                                                    <ext:ModelField Name="MRO_PO_TYPE" />
                                                    <ext:ModelField Name="GRN_DATE" /> <%--입고일자--%>
                                                    <ext:ModelField Name="GRN_NO" /> <%--입고번호--%>
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
                                    <ext:BufferedRenderer ID="BufferedRenderer2"  runat="server"/>
                                </Plugins>  
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ID ="NO2" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                            <Renderer Fn="rendererNo"></Renderer>
                                        </ext:Column>
                                        <ext:Column ID="RCV_DATE_2" ItemID="RCV_DATE2" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" /><%--Text="전기일자"--%>
                                        <ext:Column ID="RCV_NO_2" ItemID="RCV_NO" runat="server" DataIndex="RCV_NO" Width="100" Align="Center" /><%--Text="송장문서번호"--%>
                                        <ext:Column ID="RCV_SEQ" ItemID="SEQ_NO" runat="server" DataIndex="RCV_SEQ" Width="40" Align="Center" /><%--Text="순번"--%>
                                        <ext:NumberColumn ID="DELI_QTY_2" ItemID="QTY" runat="server" DataIndex="DELI_QTY" Width="65" Align="Right" Format="#,##0" Sortable="true" /><%--Text="수량"--%>
                                        <ext:Column ID="UNIT_2" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="40" Align="Center" /> <%--Text="단위"--%>
                                        <%--<ext:NumberColumn ID="UCOST_2" ItemID="UCOST" runat="server" DataIndex="UCOST" Width="65" Align="Right" Format="#,##0" Sortable="true" Hidden="true" /> --%><%--Text="단가"--%>
                                        <ext:NumberColumn ID="RCV_AMT_2" ItemID="SUPPLYAMT" runat="server" DataIndex="RCV_AMT" Width="100" Align="Right" Format="#,##0" Sortable="true"/><%--Text="공급가액"--%>
                                        <ext:Column ID="COINCD_2" ItemID="REC_WAERS" runat="server" DataIndex="COINCD" Width="40" Align="Center" /><%--Text="통화"--%>
                                        <ext:Column ID="PURC_ORG_2" ItemID="PURC_ORG" runat="server" DataIndex="PURC_ORG" Width="65" Align="Center" /><%--Text="구매조직"--%>
                                        <ext:Column ID="PURC_GRP_2" ItemID="PURC_GRP" runat="server" DataIndex="PURC_GRP" Width="100" Align="Left" Locked="false" /><%--Text="구매그룹"--%>                                        
                                        <ext:Column ID="PARTNO_2" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /> <%--Text="PART NO"--%>
                                        <ext:Column ID="PARTNM_2" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1" /> <%--Text="PART NM"--%>  
                                        <ext:Column ID="PONO_2" ItemID="PONO" runat="server" DataIndex="PONO" Width="100" Align="Center" /><%--Text="발주번호"--%>
                                        <ext:Column ID="GRN_DATE" ItemID="RCV_DATE" runat="server" DataIndex="GRN_DATE" Width="100" Align="Center" /><%--Text="입고일자"--%>
                                        <ext:Column ID="GRN_NO" ItemID="RCVNO" runat="server" DataIndex="GRN_NO" Width="120" Align="Center" /><%--Text="입고번호"--%>
                                        <ext:Column ID="RCV_NAME_2" ItemID="MGRT_NAME02" runat="server" DataIndex="RCV_NAME" Width="120" Align="Left" /> <%--Text="담당자"--%>    
                                        <ext:Column ID="MRO_PO_TYPE_2" ItemID="MRO_PO_TYPE" runat="server" DataIndex="MRO_PO_TYPE" Width="120" Align="Left" /> <%--Text="일반구매유형"--%>  
                                    </Columns>                            
                                </ColumnModel>
                                <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                    <LoadMask ShowMask="true" />
                                </Loader>
                                <View>
                                    <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true" />
                                </View>
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                </BottomBar>
                            </ext:GridPanel>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
