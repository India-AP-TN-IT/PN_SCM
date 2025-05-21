<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP20S01.aspx.cs" Inherits="Ax.EP.WP.Home.EPSample.EP20S01" %>
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

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
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
    <form id="EP20S01" runat="server">
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
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="35">
                <Items>
                    <ext:Label ID="lbl01_EP20S01" runat="server" Cls="search_area_title_name" Text="테스트" />
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" Height="65">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col />
                            <col style="width: 150px;" />
                            <col />                        
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th >
                                <ext:Label ID="lbl01_BIZCD" runat="server" Text="Business Code" />
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" Width="260">
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
                            <th>
                                <ext:Label ID="lbl01_VENDCD" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_VINCD" runat="server" Text="Vehicle Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_PARTNO" runat="server" Text="Part No." />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_PARTNO" runat="server" HelperID="HELP_PARTNO" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01"  runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="BIZCD" />
                                            <ext:ModelField Name="BIZNM" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="ITEMCD" />
                                            <ext:ModelField Name="ITEMNM" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="WEIGHT" />
                                            <ext:ModelField Name="PACK_QTY" />
                                            <ext:ModelField Name="BEG_DATE"/>
                                            <ext:ModelField Name="END_DATE" />
                                            <ext:ModelField Name="EMPNO" />
                                            <ext:ModelField Name="UPDATE_ID" />
                                            <ext:ModelField Name="UPDATE_DATE" Type="Date" />
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
                            <ext:BufferedRenderer ID="BufferedRenderer1" runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />
                                <ext:Column ID="BIZNM" ItemID="BIZNM2"  runat="server" Text="사업장" DataIndex="BIZNM" Width="90" Align="Center"/>
                                <ext:Column ID="VENDCD" runat="server" Text="업체코드" DataIndex="VENDCD" Width="65"  Align="Center" />
                                <ext:Column ID="VENDNM" runat="server" Text="업체명" DataIndex="VENDNM" MinWidth="200" Align="Left" Flex="1"  />
                                <ext:Column ID="PARTNO" ItemID="PARTNOTITLE" runat="server" Text="품번" DataIndex="PARTNO" Width="100" Align="Left" />
                                <ext:Column ID="PARTNM" ItemID="PARTNMTITLE" runat="server" Text="품명" DataIndex="PARTNM"  MinWidth="220" Align="Left" Flex="1" />
                                <ext:Column ID="VINNM"  runat="server" Text="차종명" DataIndex="VINNM" Width="100" Align="Left" />
                                <ext:Column ID="ITEMNM" ItemID="ITEMNM3" runat="server" Text="" DataIndex="ITEMNM" Width="100" Align="Left" />
                                <ext:Column ID="STANDARD" runat="server" Text="규격" DataIndex="STANDARD" Width="85" Align="Center" />
                                <ext:NumberColumn ID="WEIGHT"   runat="server" Text="무게" DataIndex="WEIGHT" Width="60" Align="Right"  Format="#,##0.00000" />
                                <ext:NumberColumn ID="PACK_QTY" runat="server" Text="포장수량" DataIndex="PACK_QTY" Width="65" Align="Right" Format="#,##0"/>
                                <ext:DateColumn ID="BEG_DATE" ItemID="BEG_DATE3" runat="server" Text="시작일자" DataIndex="BEG_DATE" Width="80" Align="Center" />
                                <ext:DateColumn ID="END_DATE" runat="server" Text="종료일자" DataIndex="END_DATE" Width="80" Align="Center" />
                                <ext:Column ID="EMPNO"  ItemID="EMPNO3"  runat="server" Text="담당자사번" DataIndex="EMPNO" Width="75" Align="Center" />
                                <ext:Column ID="UPDATE_ID" ItemID="UPDATE_ID2"  runat="server" Text="수정자ID" DataIndex="UPDATE_ID" Width="70" Align="Center" />
                                <ext:DateColumn ID="UPDATE_DATE"  ItemID="UPDATE_DATE2" format="yyyy-MM-dd HH:mm:ss" runat="server" Text="수정일시" DataIndex="UPDATE_DATE" Width="150" Align="Center" />
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
                        <DirectEvents>                         
                            <Select OnEvent="RowSelect">
                                <ExtraParams>
                                    <ext:Parameter Name="Values" Value="this.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                </ExtraParams>
                            </Select>
                        </DirectEvents>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
            <%--그리드와 내용사이에 하단 버튼영역이 필요할경우 아래 패널 사용(Hidden = "false") --%>
            <ext:Panel ID="BottomButtonPanel" runat="server" Region="South" Height="23" Cls="bottom_area_btn" Hidden="true">
                <Items>
                    <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5" ID="btnRowAdd"></ext:ImageButton>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_deleterow.gif" ID="btnRowDelete"></ext:ImageButton>
                </Items>
            </ext:Panel>
            <%--ContentPanel 의 Width, StyleSpec 내용은 Region 이 South 일 경우 필요 없음--%>
            <ext:Panel ID="ContentPanel" Cls="bottom_area_table" runat="server" Region="South" Height="154">
                <Content>
                    <table id="tableContent" style="height:0px;">
                        <colgroup>
                            <col style="width: 100px;" />
                            <col style="width: 225px;" />
                            <col style="width: 100px;" />
                            <col style="width: 225px;" />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_BIZCD" runat="server" Text="Business Code" />
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox02_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
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
                                <ext:Label ID="lbl02_VENDCD" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx02_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_PARTNO" runat="server" Text="Part No." />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx02_PARTNO" runat="server" HelperID="HELP_PARTNO" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl02_VINCD" runat="server" Text="Vehicle Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx02_VINCD" runat="server" ClassID="A3" PopupMode="Input" PopupType="CodeWindow"/>
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_ITEMCD" runat="server" Text="Item Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx02_ITEMCD" runat="server" ClassID="A4" PopupMode="Input" PopupType="CodeWindow"/>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl02_STANDARD" runat="server" Text="규격" />
                            </th>
                            <td>
                                <ext:TextField ID="txt02_STANDARD" Width="260" Cls="inputText" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_WEIGHT" runat="server" Text="무게" /><!-- 소수점 5자리 -->
                            </th>
                            <td>
                                <ext:NumberField ID="txt02_WEIGHT" Width="260" Cls="inputText_Num" FieldCls="inputText_Num" AllowExponential="true" AllowDecimals="true" DecimalPrecision="5" Step="0.00001" MinValue="0" runat="server" />
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl02_PACK_QTY" runat="server" Text="포장수량" /><!-- 소수점 5자리 -->
                            </th>
                            <td>
                                <ext:NumberField ID="txt02_PACK_QTY" Width="260" Cls="inputText_Num" FieldCls="inputText_Num" runat="server"  />
                            </td>
                        </tr>
                        <tr>     
                            <th class="ess">
                                <ext:Label ID="lbl02_START_END_DATE" runat="server"  Text="시작일자/종료일자" />
                            </th>
                            <td>
                                <ext:FieldContainer ID="CompositeField3" runat="server" Width="260" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:DateField ID="df02_BEG_DATE"  Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                                        <ext:DisplayField ID="DisplayField1" Width="30"  Flex="1" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:DateField ID="df02_END_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true" />
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl02_EMPNO3" runat="server" Text="담당자사번" />
                            </th>
                            <td>
                                <ext:TextField ID="txt02_EMPNO" Width="260" Cls="inputText" runat="server" />
                            </td>
                        </tr>                       
                    </table>
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
