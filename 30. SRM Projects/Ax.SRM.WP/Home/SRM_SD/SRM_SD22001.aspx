<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_SD22001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_SD.SRM_SD22001" %>
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

    </script>
</head>
<body>
    <form id="SRM_SD22001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:TextField ID="hid01_CUSTCD" runat="server" Hidden="true" />
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_SD22001" runat="server" Cls="search_area_title_name" /><%--Text="납품실적등록" />--%>
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
                                <ext:Label ID="lbl01_STD_DATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_STD_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  />                               
                            </td>
                        </tr> 
                        <tr>                            
                            <th>
                               <ext:Label ID="lbl01_DIVISION" runat="server" /><%--Text="구분" />--%>
                            </th>
                            <td colspan="5">
                                <ext:SelectBox ID="cbo01_CUST_COR" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="CDNM" ValueField="CD" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="CD" />
                                                        <ext:ModelField Name="CDNM" />
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
            <ext:Panel ID="ExcelUploadPanel" Region="North" Cls="excel_upload_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 410px;"/>
                            <col style="width: 100px;"/>
                            <col />
                        </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_EXCEL" runat="server" /><%--Text="Excel Upload" />--%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer3" runat="server" Width="410" MinWidth="410" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:FileUploadField ID="fud02_FILEID1" runat="server" Cls="inputText" ButtonText="Browser" Width="400" />
                                    </Items>
                                </ext:FieldContainer>
                            </td>    
                            <td>
                                <ext:Panel ID="ButtonPanel2" runat="server"  StyleSpec="width:100%;"  Height="30">
                                    <Items>
                                        <%-- 엑셀 파일 업로드 버튼 --%>
                                    </Items>
                                </ext:Panel>
                            </td>  
                            <td>
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="260" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:Label ID="lbl01_ROWCNT"            runat="server" /><%--Text="(적용건수 : " />--%>
                                        <ext:Label ID="lbl01_ROWCNT_EXCEL"      runat="server" /><%--Text="대상건수" />--%>
                                        <ext:TextField ID="txt01_ROWCNT_EXCEL"  runat="server" Width="50" Cls="inputText_Num" ReadOnly="true" />
                                        <ext:Label ID="lbl01_ROWCNT_ADDED"      runat="server" /><%--Text="처리건수"/>--%>
                                        <ext:TextField ID="txt01_ROWCNT_ADDED"  runat="server" Width="50" Cls="inputText_Num" ReadOnly="true" />
                                        <ext:Label ID="lbl01_ROWCNT_E"          runat="server" /><%--Text=" )" />--%>
                                    </Items>
                                </ext:FieldContainer>
                            </td>                                                 
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
                                            <ext:ModelField Name="DELI_PART" />
                                            <ext:ModelField Name="REG_PART" /> 
                                            <ext:ModelField Name="PLAN_PART" /> 
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="PONO" />
                                            <ext:ModelField Name="DELI_DATE" />
                                            <ext:ModelField Name="PO_QTY" />
                                            <ext:ModelField Name="DELI_QTY" />
                                            <ext:ModelField Name="PREV_DELI_DIV" />
                                            <ext:ModelField Name="PREV_DELI_QTY" />
                                            <ext:ModelField Name="GRADE" />
                                            <ext:ModelField Name="LEG_QUALITY" />
                                            <ext:ModelField Name="ISS_DATE" />
                                            <ext:ModelField Name="RCV_DATE" />
                                            <ext:ModelField Name="RCV_QTY" />
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
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" Locked="True"/>
                                <ext:Column ID="DELI_PART" ItemID="DELI_PART" runat="server" DataIndex="DELI_PART" Width="50" Align="Center" Locked="True"/><%--Text="납품처" --%>
                                <ext:Column ID="REG_PART" ItemID="REG_PART" runat="server" DataIndex="REG_PART" Width="50" Align="Center" Locked="True"/><%--Text="저장처" --%>
                                <ext:Column ID="PLAN_PART" ItemID="PLAN_PART" runat="server" DataIndex="PLAN_PART" Width="100" Align="Left" Locked="True"/><%--Text="예매처" --%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" Locked="True"/><%--Text="품번" --%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1"/><%--Text="품명" --%>
                                <ext:Column ID="PONO" ItemID="PONO" runat="server" DataIndex="PONO" Width="140" Align="Center" /><%--Text="발주번호"      --%>
                                <ext:DateColumn ID="DELI_DATE" ItemID="DELI_DATE" runat="server" DataIndex="DELI_DATE" Width="80" Align="Center" /><%--Text="납기일자"      --%> 
                                <ext:NumberColumn ID="PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="PO_QTY" Width="80" Align="Right" Format="#,##0"/><%--Text="발주량"  --%>
                                <ext:NumberColumn ID="DELI_QTY" ItemID="DELIQTY" runat="server" DataIndex="DELI_QTY" Width="80" Align="Right" Format="#,##0"/><%--Text="납품량"  --%>
                                <ext:Column ID="PREV_DELI_DIV" ItemID="PREV_DELI_DIV" runat="server" DataIndex="PREV_DELI_DIV" Width="80" Align="Center" /><%--Text="선납구분"      --%>
                                <ext:NumberColumn ID="PREV_DELI_QTY" ItemID="PREV_DELI_QTY" runat="server" DataIndex="PREV_DELI_QTY" Width="80" Align="Right" Format="#,##0"/><%--Text="선납가능량"  --%>                               
                                <ext:Column ID="GRADE" ItemID="GRADE2" runat="server" DataIndex="GRADE" Width="60" Align="Center"/><%--Text="등급"      --%>
                                <ext:Column ID="LEG_QUALITY" ItemID="LEG_QUALITY" runat="server" DataIndex="LEG_QUALITY" Width="60" Align="Center"/><%--Text="법규품질"      --%>
                                <ext:DateColumn ID="ISS_DATE" ItemID="ISSDATE" runat="server" DataIndex="ISS_DATE" Width="80" Align="Center" /><%--Text="발행일"      --%>
                                <ext:DateColumn ID="RCV_DATE" ItemID="RCV_DATE" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" /><%--Text="입고일"      --%>
                                <ext:NumberColumn ID="RCV_QTY" ItemID="RCVQTY" runat="server" DataIndex="RCV_QTY" Width="80" Align="Right" Format="#,##0"/><%--Text="입고량"  --%>
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
                    <ext:GridPanel ID="Grid02" runat="server" Visible="false" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="Model2" runat="server">
                                        <Fields>                                       
                                            <ext:ModelField Name="CORCD" />
                                            <ext:ModelField Name="BIZCD" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="CUST_ITEMCD" />
                                            <ext:ModelField Name="WORK_DIR_DIV" />
                                            <ext:ModelField Name="BEG_DATE"/>
                                            <ext:ModelField Name="END_DATE"/>
                                            <ext:ModelField Name="USAGE" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="ALCCD_O" />
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
                            <ext:BufferedRenderer ID="BufferedRenderer2"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel2" runat="server">
                            <Columns>
                                <ext:Column ID="E_SEQ" ItemID="SEQ" runat="server" DataIndex="SEQ" Width="40" Align="Right" /><%--Text="SEQ"   --%>                            
                                <ext:Column ID="E_DELI_PART" ItemID="DELI_PART" runat="server" DataIndex="DELI_PART" Width="50" Align="Center" /><%--Text="납품처" --%>
                                <ext:Column ID="E_REG_PART" ItemID="REG_PART" runat="server" DataIndex="REG_PART" Width="50" Align="Center" /><%--Text="저장처" --%>
                                <ext:Column ID="E_PLAN_PART" ItemID="PLAN_PART" runat="server" DataIndex="PLAN_PART" Width="100" Align="Left" /><%--Text="예매처" --%>  
                                <ext:Column ID="E_PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="품번" --%>
                                <ext:Column ID="E_PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="180" Align="Left" /><%--Text="품명" --%>
                                <ext:Column ID="E_PONO" ItemID="PONO" runat="server" DataIndex="PONO" Width="140" Align="Center" /><%--Text="발주번호"      --%>
                                <ext:DateColumn ID="E_DELI_DATE" ItemID="DELI_DATE" runat="server" DataIndex="DELI_DATE" Width="80" Align="Center" /><%--Text="납기일자"      --%> 
                                <ext:NumberColumn ID="E_PO_QTY" ItemID="PO_QTY" runat="server" DataIndex="PO_QTY" Width="80" Align="Right" Format="#,##0"/><%--Text="발주량"  --%>
                                <ext:NumberColumn ID="E_DELI_QTY" ItemID="DELIQTY" runat="server" DataIndex="DELI_QTY" Width="80" Align="Right" Format="#,##0"/><%--Text="납품량"  --%>
                                <ext:Column ID="E_PREV_DELI_DIV" ItemID="PREV_DELI_DIV" runat="server" DataIndex="PREV_DELI_DIV" Width="80" Align="Center" /><%--Text="선납구분"      --%>
                                <ext:NumberColumn ID="E_PREV_DELI_QTY" ItemID="PREV_DELI_QTY" runat="server" DataIndex="PREV_DELI_QTY" Width="80" Align="Right" Format="#,##0"/><%--Text="선납가능량"  --%>                               
                                <ext:Column ID="E_GRADE" ItemID="GRADE2" runat="server" DataIndex="GRADE" Width="60" Align="Center"/><%--Text="등급"      --%>
                                <ext:Column ID="E_LEG_QUALITY" ItemID="LEG_QUALITY" runat="server" DataIndex="LEG_QUALITY" Width="60" Align="Center"/><%--Text="법규품질"      --%>
                                <ext:DateColumn ID="E_ISS_DATE" ItemID="ISSDATE" runat="server" DataIndex="ISS_DATE" Width="80" Align="Center" /><%--Text="발행일"      --%>
                                <ext:DateColumn ID="E_RCV_DATE" ItemID="RCV_DATE" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" /><%--Text="입고일"      --%>
                                <ext:NumberColumn ID="E_RCV_QTY" ItemID="RCVQTY" runat="server" DataIndex="RCV_QTY" Width="80" Align="Right" Format="#,##0"/><%--Text="입고량"  --%>                                      
                                <ext:Column ID="E_TEMP_FILED" ItemID="TEMP_FIELD" runat="server" DataIndex="TEMP_FIELD" Width="120" Align="Left" /><%--Text="공용/WH"  --%>                                
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>                            
                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"/>
                        </SelectionModel>                       
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="StatusBar1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>                 
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
