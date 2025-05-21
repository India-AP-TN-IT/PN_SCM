<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM33002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM33002" %>
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
    <style type="text/css">
        .font-color-red_all 
        {
            color:#FF0000;
        }          
    </style>
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
            App.Grid03.setHeight(App.BottomGridPanel.getHeight());
            App.Grid04.setHeight(App.BottomGridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        var loadmask = null;

        // 그리드의 셀 클릭시 사용하는 메서드
        var CellClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            //소계            
            if (grid.getStore().getAt(rowIndex).data["FLAG"] == "1") {
                App.Grid02.store.removeAll();
                return;
            }
            var a = navigator.userAgent;
            function is(s, t) {
                return ((s || "").indexOf(t) > -1)
            };
            var isIE = is(a.toLowerCase(), "msie") || is(a.toLowerCase(), "rv:");



            var grid = grid.ownerCt;

            if (loadmask) return;

            var rcvType = grid.getStore().getAt(rowIndex).data["RCV_TYPE"];
            var target;
            if (rcvType == '1MA') {
                target = App.Grid02;
                App.Grid02.setHidden(false);
                App.Grid03.setHidden(true);
                App.Grid04.setHidden(true);

            } else if (rcvType == '1MB') {
                target = App.Grid03;
                App.Grid03.setHidden(false);
                App.Grid02.setHidden(true);
                App.Grid04.setHidden(true);
            } else {
                target = App.Grid04;
                App.Grid04.setHidden(false);
                App.Grid02.setHidden(true);
                App.Grid03.setHidden(true);
            }

            loadmask = new Ext.LoadMask(target, { msg: "Please wait..." });
            loadmask.show();

            var htmlGrid = document.getElementById("Grid01-bodyWrap");
            //var oldStyle = htmlGrid.style;
            htmlGrid.style = "pointer-events: none;";
            if (isIE) App.Grid01.setDisabled(true);

            var vendCd = grid.getStore().getAt(rowIndex).data["VENDCD"];
            var rcvMonth = grid.getStore().getAt(rowIndex).data["RCV_MONTH"];
            var purcOrg = grid.getStore().getAt(rowIndex).data["PURC_ORG"];
            var vatCd = grid.getStore().getAt(rowIndex).data["VATCD"];
            var rcvBizcd = grid.getStore().getAt(rowIndex).data["RCV_BIZCD"];

            App.ACC_VENDCD.setValue(vendCd);
            App.ACC_MONTH.setValue(rcvMonth);
            App.ACC_RCV_TYPE.setValue(rcvType);
            App.ACC_PURC_ORG.setValue(purcOrg);
            App.ACC_VATCD.setValue(vatCd);
            App.ACC_RCV_BIZCD.setValue(rcvBizcd);

            App.direct.Grid01_Cell_Click(vendCd, rcvMonth, rcvType, purcOrg, vatCd, rcvBizcd, { success: function (result) { loadmask.hide(); loadmask = null; htmlGrid.style = "pointer-events: default;"; if (isIE) App.Grid01.setDisabled(false); }, error: function (result) { loadmask.hide(); loadmask = null; htmlGrid.style = "pointer-events: default;"; if (isIE) App.Grid01.setDisabled(false); } });

            //            Ext.net.Mask.show({ msg: 'Please waiting...' });
            //            App.direct.Grid01_Cell_Click(vendCd, rcvMonth, rcvType, purcOrg, vatCd, rcvBizcd, { success: function (result) { Ext.net.Mask.hide(); } });
        }

        //상단그리드
        var getRowClass_grd01 = function (record, rowIndex, rowParams, store) {
            var amt = record.data['RCV_AMT'];
            if (amt < 0) return 'font-color-red_all';
        }

        var getRowClass_grd02 = function (record, rowIndex, rowParams, store) {
            var amt = record.data['RCV_AMT'];
            if (amt < 0) return 'font-color-red_all';
        }

        var getRowClass_grd03 = function (record, rowIndex, rowParams, store) {
            var amt = record.data['RETROACT_AMT'];
            if (amt < 0) return 'font-color-red_all';
        }
        //관세환급
        var getRowClass_grd04 = function (record, rowIndex, rowParams, store) {
            var amt = record.data['REFUND_AMT'];
            if (amt < 0) return 'font-color-red_all';            
        }
             
    </script>
</head>
<body>
    <form id="SRM_MM33002" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM33002" runat="server" Cls="search_area_title_name" /><%--Text="월납품현황" --%>
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
                            <th class="ess">         
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" /><%--Text="구매조직" /> --%>                      
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_PURC_ORG_Change" />
                                    </DirectEvents>                                    
                                </ext:SelectBox>
                            </td>  
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_RCV_TYPE2" runat="server" /><%--Text="마감유형" /> --%>                      
                            </th>
                            <td >
                                <ext:SelectBox ID="cbo01_RCV_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
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
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_RCV_TYPE_Change" />
                                    </DirectEvents>                                    
                                </ext:SelectBox>
                            </td>  
                            <th>         
                                <ext:Label ID="lbl01_VIN_PER" runat="server" />                      
                            </th>
                            <td>
                                <ext:TextField ID="txt01_VINCD" Width="150" Cls="inputText" runat="server" />    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />
                            </th>
                            <td colspan="3">
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />    
                            </td>
                        </tr>
                    </table>
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
                                            <ext:ModelField Name="FLAG"/>
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
                                <ext:Column ID="VENDNM" ItemID="VENDORNM" runat="server" DataIndex="VENDNM" Width="180" Align="Left" />  <%--Text="거래처명"--%> 
                                <ext:Column ID="RCV_MONTH" ItemID="RCV_DATE2" runat="server" DataIndex="RCV_MONTH" Width="100" Align="Center" />  <%--Text="전기일자"--%> 
                                <ext:Column ID="RCV_TYPENM" ItemID="RCV_TYPE2" runat="server" DataIndex="RCV_TYPENM" Width="80" Align="Left" />  <%--Text="마감유형"--%> 
                                <ext:Column ID="PURC_ORGNM" ItemID="PURC_ORG" runat="server" DataIndex="PURC_ORGNM" Width="65" Align="Center" />  <%--Text="구매조직"--%> 
                                <ext:Column ID="VATNM" ItemID="STAXCD" runat="server" DataIndex="VATNM" Width="250" Align="Left" />  <%--Text="부가세코드"--%> 
                                <ext:Column ID="COINCD" ItemID="REC_WAERS" runat="server" DataIndex="COINCD" Width="40" Align="Center" />  <%--Text="통화"--%> 
                                <ext:NumberColumn ID="AMT" ItemID="SUPPLY_SUM_AMT_A" runat="server" DataIndex="AMT" Width="120" Align="Right" Format="#,##0.##" />  <%--Text="공급가 총액(A)"--%> 
                                <ext:NumberColumn ID="VAT" ItemID="SURTAXAMT_B" runat="server" DataIndex="VAT" Width="120" Align="Right" Format="#,##0.##" />  <%--Text="부가세액(B)"--%> 
                                <ext:NumberColumn ID="RCV_AMT" ItemID="TOTALAMT_AB" runat="server" DataIndex="RCV_AMT" Width="120" Align="Right" Format="#,##0.##" />  <%--Text="총금액(A+B)"--%> 
                                <ext:NumberColumn ID="PREPAY_AMT" ItemID="PREPAY_AMT_C" runat="server" DataIndex="PREPAY_AMT" Width="120" Hidden="true" Align="Right" Format="#,##0.##" />  <%--Text="(기)지급선급금"--%> 
                                <%--<ext:NumberColumn ID="PAY_TOT_AMT" ItemID="SUPPLYAMT_AC" runat="server" DataIndex="PAY_TOT_AMT" Width="130" Align="Right" Format="#,##0" /> %>  <%--Text="공급가 총액(A+C)"--%> 
                                <ext:Column ID="RCV_BIZNM" ItemID="RCV_BIZCD" runat="server" DataIndex="RCV_BIZNM" Width="100" Align="Left" />  <%--Text="발행사업장"--%> 
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">
                                <GetRowClass Fn="getRowClass_grd01" />
                            </ext:GridView>
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
            <ext:Panel ID="pnl01_Bottom" Region="Center" runat="server" Flex="2">
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
                            <ext:GridPanel ID="Grid02" runat="server" Hidden="false" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store7" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="Model4" runat="server">
                                                <Fields>                                       
                                                    <ext:ModelField Name="NO_2" />
                                                    <ext:ModelField Name="RCV_DATE" />
                                                    <ext:ModelField Name="RCV_NO" />
													<ext:ModelField Name="RCV_SEQ" />
													<ext:ModelField Name="PARTNO" />
                                                    <ext:ModelField Name="PARTNM" />
                                                    <ext:ModelField Name="DELI_QTY" />
                                                    <ext:ModelField Name="UNIT" />
													<ext:ModelField Name="DELI_AMT" />
													<ext:ModelField Name="JIS_AMT" />
													<ext:ModelField Name="PACK_AMT" />
													<ext:ModelField Name="DUTY_AMT" />
                                                    <ext:ModelField Name="ETC_AMT" />
													<ext:ModelField Name="PURC_AMT" />
													<ext:ModelField Name="GL_AMT" />
													<ext:ModelField Name="RCV_AMT" />
                                                    <ext:ModelField Name="COINCD" />
                                                    <ext:ModelField Name="PURC_ORG" />
                                                    <ext:ModelField Name="PURC_GRP" />
                                                    <ext:ModelField Name="PONO" />
                                                    <ext:ModelField Name="RCV_NAME" />
                                                    <ext:ModelField Name="GRN_DATE" /> <%--입고일자--%>
                                                    <ext:ModelField Name="GRN_NO" /> <%--입고번호--%>
                                                    <ext:ModelField Name="CUSTNM" /> <%--고객사--%>
                                                    <ext:ModelField Name="PART_UCOST" /> <%--부품단가--%>
                                                    <ext:ModelField Name="PACK_UCOST" /> <%--포장단가--%>
                                                    <ext:ModelField Name="VINCD" /> <%--차종--%>
                                                    <ext:ModelField Name="STR_LOC" /> <%--저장위치--%>
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
                                        <ext:Column ID ="NO_2" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                            <Renderer Fn="rendererNo"></Renderer>
                                        </ext:Column>
                                        <ext:Column ID="RCV_DATE_2" ItemID="RCV_DATE2" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" /><%--Text="전기일자"--%>
                                        <ext:Column ID="RCV_NO_2" ItemID="RCV_NO" runat="server" DataIndex="RCV_NO" Width="100" Align="Center" /><%--Text="송장문서번호"--%>
										<ext:Column ID="RCV_SEQ_2" ItemID="SEQ_NO" runat="server" DataIndex="RCV_SEQ" Width="40" Align="Center" /><%--Text="순번"--%>
                                        <ext:Column ID="VINCD_2" ItemID="VIN" runat="server" DataIndex="VINCD" Width="70" Align="Center" /> <%--Text="차종"--%>
										<ext:Column ID="PARTNO_2" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /> <%--Text="PART NO"--%>
                                        <ext:Column ID="PARTNM_2" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1" /> <%--Text="PART NM"--%>
                                        <ext:NumberColumn ID="DELI_QTY_2" ItemID="SRM_MM33002_QTY" runat="server" DataIndex="DELI_QTY" Width="65" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="수량"--%>
										<ext:Column ID="UNIT_2" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="40" Align="Center" /> <%--Text="단위"--%>
                                        <ext:NumberColumn ID="DELI_AMT_2" ItemID="SUPPLYAMT_A" runat="server" DataIndex="DELI_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="공급가액(A)"--%>
										<ext:NumberColumn ID="JIS_AMT_2" ItemID="JIS_AMT_B" runat="server" DataIndex="JIS_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="서열비(B)"--%>
										<ext:NumberColumn ID="PACK_AMT_2" ItemID="PACK_AMT_C" runat="server" DataIndex="PACK_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="포장비(C)"--%>
										<ext:NumberColumn ID="DUTY_AMT_2" ItemID="DUTY_AMT_D" runat="server" DataIndex="DUTY_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="관세(D)"--%>
										<ext:NumberColumn ID="ETC_AMT_2" ItemID="ETC_AMT_E" runat="server" DataIndex="ETC_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="기타(E)"--%>
										<ext:NumberColumn ID="PURC_AMT_2" ItemID="PURC_AMT_AB" runat="server" DataIndex="PURC_AMT" Width="120" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="매입금액(A+B)"--%>
										<ext:NumberColumn ID="GL_AMT_2" ItemID="GL_AMT_CDE" runat="server" DataIndex="GL_AMT" Width="120" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="G/L 금액(C+D+E)"--%>
										<ext:NumberColumn ID="RCV_AMT_2" ItemID="SUPPLY_SUM_AMT_ABCDE" runat="server" DataIndex="RCV_AMT" Width="120" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="공급가 총액"--%>
                                        <ext:NumberColumn ID="PART_UCOST_2" ItemID="SRM_MM33002_PART_UCOST" runat="server" DataIndex="PART_UCOST" Width="100" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="부품단가"--%>
                                        <ext:NumberColumn ID="PACK_UCOST_2" ItemID="PACK_UCOST" runat="server" DataIndex="PACK_UCOST" Width="100" Align="Right" Format="#,##0.###" Sortable="true"/><%--Text="포장단가"--%>
                                        <ext:Column ID="COINCD_2" ItemID="REC_WAERS" runat="server" DataIndex="COINCD" Width="40" Align="Center" /><%--Text="통화"--%>
                                        <ext:Column ID="PURC_ORG_2" ItemID="PURC_ORG" runat="server" DataIndex="PURC_ORG" Width="65" Align="Center" /><%--Text="구매조직"--%>
                                        <ext:Column ID="PURC_GRP_2" ItemID="PURC_GRP" runat="server" DataIndex="PURC_GRP" Width="100" Align="Left" Locked="false" /><%--Text="구매그룹"--%>
                                        <ext:Column ID="PONO_2" ItemID="PONO" runat="server" DataIndex="PONO" Width="100" Align="Center" /><%--Text="발주번호"--%>
                                        <ext:Column ID="GRN_DATE" ItemID="RCV_DATE" runat="server" DataIndex="GRN_DATE" Width="100" Align="Center" /><%--Text="입고일자"--%>
                                        <ext:Column ID="GRN_NO" ItemID="RCVNO" runat="server" DataIndex="GRN_NO" Width="120" Align="Center" /><%--Text="입고번호"--%>
                                        <ext:Column ID="STR_LOC" ItemID="STR_LOC" runat="server" DataIndex="STR_LOC" Width="100" Align="Left" /><%--Text="저장위치"--%>
                                        <ext:Column ID="CUSTNM" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="150" Align="Left" /><%--Text="고객사"--%>
                                        <ext:Column ID="RCV_NAME_2" ItemID="MGRT_NAME02" runat="server" DataIndex="RCV_NAME" Width="120" Align="Left" /> <%--Text="담당자"--%>    
                                    </Columns>                            
                                </ColumnModel>
                                <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                    <LoadMask ShowMask="true" />
                                </Loader>
                                <View>
                                    <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true" >
                                        <GetRowClass Fn="getRowClass_grd02" />
                                    </ext:GridView>
                                </View>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"/>
                                </SelectionModel>
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                </BottomBar>
                            </ext:GridPanel>
                            <ext:GridPanel ID="Grid03" runat="server" Hidden="true" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store8" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="Model5" runat="server">
                                                <Fields>                                       
                                                    <ext:ModelField Name="NO_3" />
                                                    <ext:ModelField Name="RCV_DATE" />
                                                    <ext:ModelField Name="RCV_NO" />
                                                    <ext:ModelField Name="RETROACT_TYPE" />
                                                    <ext:ModelField Name="RETROACT_DATE" />
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
                                                    <ext:ModelField Name="PURC_ORG" />
                                                    <ext:ModelField Name="PURC_GRP" />
                                                    <ext:ModelField Name="RCV_NAME" />
                                                    <ext:ModelField Name="VINCD" /> <%--차종--%>
                                                </Fields>
                                            </ext:Model>
                                        </Model>
                                        <Listeners>
                                            <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                            <Load Delay="1" Handler="GridStoreReady(App.GridStatus3, this.getTotalCount());  "></Load>
                                        </Listeners>
                                    </ext:Store>
                                </Store>
                                <Plugins>
                                    <ext:BufferedRenderer ID="BufferedRenderer3"  runat="server"/>
                                </Plugins>  
                                <ColumnModel ID="ColumnModel3" runat="server">
                                    <Columns>
                                        <ext:Column ID ="NO_3" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                            <Renderer Fn="rendererNo"></Renderer>
                                        </ext:Column>
                                        <ext:Column ID="RCV_DATE_3" ItemID="RCV_DATE2" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" /><%--Text="전기일자"--%>
                                        <ext:Column ID="RCV_NO_3" ItemID="RCV_NO" runat="server" DataIndex="RCV_NO" Width="100" Align="Center" /><%--Text="송장문서번호"--%>
										<ext:Column ID="RETROACT_TYPE_3" ItemID="RETROACT_TYPE" runat="server" DataIndex="RETROACT_TYPE" Width="100" Align="Left" Locked="false" /><%--Text="소급유형"--%>
										<ext:Column ID="RETROACT_DATE" ItemID="RETROACT_DATE" runat="server" DataIndex="RETROACT_DATE" Width="100" Align="Center" Locked="false" /><%--Text="소급반영일자"--%>
                                        <ext:Column ID="VINCD_3" ItemID="VIN" runat="server" DataIndex="VINCD" Width="70" Align="Center" /> <%--Text="차종"--%>
										<ext:Column ID="PARTNO_3" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /> <%--Text="PART NO"--%>
                                        <ext:Column ID="PARTNM_3" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1" /> <%--Text="PART NM"--%>
										<ext:Column ID="BEG_DATE_3" ItemID="RETROACT_BEG_DATE" runat="server" DataIndex="BEG_DATE" Width="100" Align="Center" Locked="false" /><%--Text="소급시작일"--%>
										<ext:Column ID="END_DATE_3" ItemID="RETROACT_END_DATE" runat="server" DataIndex="END_DATE" Width="100" Align="Center" Locked="false" /><%--Text="소급종료일"--%>
										<ext:NumberColumn ID="RETROACT_QTY_3" ItemID="RETROACT_QTY" runat="server" DataIndex="RETROACT_QTY" Width="65" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="소급수량"--%>
										<ext:Column ID="UNIT_3" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="40" Align="Center" /> <%--Text="단위"--%>
										<ext:NumberColumn ID="RETROACT_UCOST_3" ItemID="RETROACT_UCOST" runat="server" DataIndex="RETROACT_UCOST" Width="65" Align="Right" Format="#,##0.##" Sortable="true" /><%--Text="소급단가"--%>
										<ext:NumberColumn ID="RETROACT_AMT_3" ItemID="RETROACT_AMT" runat="server" DataIndex="RETROACT_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true"/><%--Text="소급금액"--%>
										<ext:Column ID="COINCD_3" ItemID="REC_WAERS" runat="server" DataIndex="COINCD" Width="40" Align="Center" /><%--Text="통화"--%>
										<ext:Column ID="REPORT_NO_3" ItemID="RETROACT_NO" runat="server" DataIndex="REPORT_NO" Width="100" Align="Center" Locked="false" /><%--Text="소급번호"--%>
										<ext:Column ID="RETROACT_REASON_3" ItemID="RETROACT_REASON" runat="server" DataIndex="RETROACT_REASON" Width="100" Align="Left" Locked="false" /><%--Text="소급사유"--%>
                                        <ext:Column ID="PURC_ORG_3" ItemID="PURC_ORG" runat="server" DataIndex="PURC_ORG" Width="65" Align="Center" /><%--Text="구매조직"--%>
                                        <ext:Column ID="PURC_GRP_3" ItemID="PURC_GRP" runat="server" DataIndex="PURC_GRP" Width="100" Align="Left" Locked="false" /><%--Text="구매그룹"--%>
                                        <ext:Column ID="RCV_NAME_3" ItemID="MGRT_NAME02" runat="server" DataIndex="RCV_NAME" Width="120" Align="Left" /> <%--Text="담당자"--%>    
                                    </Columns>                            
                                </ColumnModel>
                                <Loader ID="Loader3" runat="server" AutoLoad="false" Mode="Data">
                                    <LoadMask ShowMask="true" />
                                </Loader>
                                <View>
                                    <ext:GridView ID="GridView3" runat="server" EnableTextSelection="true" >
                                        <GetRowClass Fn="getRowClass_grd03" />
                                    </ext:GridView>
                                </View>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" Mode="Single"/>
                                </SelectionModel>
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus3" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                </BottomBar>
                            </ext:GridPanel>
                            <ext:GridPanel ID="Grid04" runat="server" Hidden="true" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store9" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="Model6" runat="server">
                                                <Fields>                                       
                                                    <ext:ModelField Name="NO_4" />
                                                    <ext:ModelField Name="RCV_DATE" />
                                                    <ext:ModelField Name="RCV_NO" />
                                                    <ext:ModelField Name="REFUND_TYPE" />
                                                    <ext:ModelField Name="CUST_CLS_MONTH" />
                                                    <ext:ModelField Name="CUSTCD" />
                                                    <ext:ModelField Name="CUSTNM" />
                                                    <ext:ModelField Name="PARTNO" />
                                                    <ext:ModelField Name="PARTNM" />
                                                    <ext:ModelField Name="REFUND_AMT" />
                                                    <ext:ModelField Name="COINCD" />
                                                    <ext:ModelField Name="REFUND_NO" />
                                                    <ext:ModelField Name="PURC_ORG" />
                                                    <ext:ModelField Name="RCV_NAME" />
                                                    <ext:ModelField Name="VINCD" /> <%--차종--%>
                                                </Fields>
                                            </ext:Model>
                                        </Model>
                                        <Listeners>
                                            <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                            <Load Delay="1" Handler="GridStoreReady(App.GridStatus4, this.getTotalCount());  "></Load>
                                        </Listeners>
                                    </ext:Store>
                                </Store>
                                <Plugins>
                                    <ext:BufferedRenderer ID="BufferedRenderer4"  runat="server"/>
                                </Plugins>  
                                <ColumnModel ID="ColumnModel4" runat="server">
                                    <Columns>
                                        <ext:Column ID ="NO_4" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                            <Renderer Fn="rendererNo"></Renderer>
                                        </ext:Column>
                                        <ext:Column ID="RCV_DATE_4" ItemID="RCV_DATE2" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" /><%--Text="전기일자"--%>
                                        <ext:Column ID="RCV_NO_4" ItemID="RCV_NO" runat="server" DataIndex="RCV_NO" Width="100" Align="Center" /><%--Text="송장문서번호"--%>
										<ext:Column ID="REFUND_TYPE_4" ItemID="REFUND_TYPE" runat="server" DataIndex="REFUND_TYPE" Width="100" Align="Left" /><%--Text="관세환급유형"--%>
										<ext:Column ID="CUST_CLS_MONTH_4" ItemID="REFUND_MONTH" runat="server" DataIndex="CUST_CLS_MONTH" Width="100" Align="Center" /><%--Text="관세정산월"--%>
										<ext:Column ID="CUSTCD_4" ItemID="CUSTCD" runat="server" DataIndex="CUSTCD" Width="100" Align="Center" /><%--Text="고객사코드"--%>
										<ext:Column ID="CUSTNM_4" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="150" Align="Left" /><%--Text="고객사명"--%>
                                        <ext:Column ID="VINCD_4" ItemID="VIN" runat="server" DataIndex="VINCD" Width="70" Align="Center" /> <%--Text="차종"--%>
										<ext:Column ID="PARTNO_4" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /> <%--Text="PART NO"--%>
                                        <ext:Column ID="PARTNM_4" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1" /> <%--Text="PART NM"--%>
                                        <ext:NumberColumn ID="REFUND_AMT_4" ItemID="REFUND_AMT" runat="server" DataIndex="REFUND_AMT" Width="100" Align="Right" Format="#,##0.##" Sortable="true" /><%--Text="관세환급금액"--%>
                                        <ext:Column ID="COINCD_4" ItemID="REC_WAERS" runat="server" DataIndex="COINCD" Width="40" Align="Center" /><%--Text="통화"--%>
										<ext:Column ID="REFUND_NO_4" ItemID="REFUND_NO" runat="server" DataIndex="REFUND_NO" Width="100" Align="Center" Locked="false" /><%--Text="관세환급번호"--%>
                                        <ext:Column ID="PURC_ORG_4" ItemID="PURC_ORG" runat="server" DataIndex="PURC_ORG" Width="65" Align="Center" /><%--Text="구매조직"--%>
                                        <ext:Column ID="RCV_NAME_4" ItemID="MGRT_NAME02" runat="server" DataIndex="RCV_NAME" Width="120" Align="Left" /> <%--Text="담당자"--%>
                                    </Columns>                            
                                </ColumnModel>
                                <Loader ID="Loader4" runat="server" AutoLoad="false" Mode="Data">
                                    <LoadMask ShowMask="true" />
                                </Loader>
                                <View>
                                    <ext:GridView ID="GridView4" runat="server" EnableTextSelection="true" >
                                        <GetRowClass Fn="getRowClass_grd04" />
                                    </ext:GridView>
                                </View>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" Mode="Single"/>
                                </SelectionModel>
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus4" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
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
