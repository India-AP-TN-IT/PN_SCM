<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP30008.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MP.SRM_MP30008" %>
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

        function fn_PopupHandler(rowIndex, CORCD, BIZCD, VENDCD, TEAM_DIV, PARTNO) {

            App.CodeRow.setValue(rowIndex);
            App.V_CORCD.setValue(CORCD);
            App.V_BIZCD.setValue(BIZCD);
            App.V_VENDCD.setValue(VENDCD);
            App.V_TEAM_DIV.setValue(TEAM_DIV);
            App.V_PARTNO.setValue(PARTNO);
            PopUpFire();
        }

        var PopUpFire = function () {

            App.btn01_POP_MP30008P1.fireEvent('click');
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

            var CORCD = grid.getStore().getAt(rowIndex).data["CORCD"];
            var BIZCD = grid.getStore().getAt(rowIndex).data["BIZCD"];
            var VENDCD = grid.getStore().getAt(rowIndex).data["VENDCD"];
            var TEAM_DIV = grid.getStore().getAt(rowIndex).data["TEAM_DIV"];
            var PARTNO = grid.getStore().getAt(rowIndex).data["PARTNO"];

            fn_PopupHandler(rowIndex, CORCD, BIZCD, VENDCD, TEAM_DIV, PARTNO);
        }
             
    </script>
</head>
<body>
    <form id="SRM_MP30008" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_POP_MP30008P1" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:TextField   ID="CodeRow"             runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField   ID="V_CORCD"             runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 V_CORCD 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_BIZCD"             runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_BIZCD 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_VENDCD"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_VENDCD 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_TEAM_DIV"          runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_TEAM_DIV 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_PARTNO"          runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_PARTNO 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="UserHelpURL"         runat="server" Hidden="true" Text="../SCM_MP/SCM_MP30008P1.aspx"></ext:TextField> 
    <ext:TextField   ID="PopupWidth"          runat="server" Hidden="true" Text="960"></ext:TextField> 
    <ext:TextField   ID="PopupHeight"         runat="server" Hidden="true" Text="500"></ext:TextField> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MP30008" runat="server" Cls="search_area_title_name" /><%--Text="월납품현황" --%>
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
                        <tr>
							<th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>    
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" Text="Business Code" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
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
                                <ext:Label ID="lbl01_TGUBUN" runat="server"  /> <%--Text="업무구분"--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_TEAM_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="260">
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
                        </tr> 
                        <tr>
                            <th class="ess">                                
                                <ext:Label ID="lbl01_DELI_YYMM" runat="server" /> <%--Text="납품년월" --%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_DELI_DATE" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />
                            </td>
                            <td colspan="4">                           
                            </td>
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>

            <ext:Panel ID="Panel1" runat="server" Region="North" Height="27" >
                <Content>
                    <table style="height:0px; margin-bottom: 10px;">
                        <tr>
                            <td align="center" style="color:#555;">
                                <ext:Label ID="lbl01_MP_MSG001" runat="server" />  <%--Text="☞ 그리드를 더블클릭하면 상세정보를 팝업으로 나타냅니다."--%>
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
                                            <ext:ModelField Name="PARTNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="STANDARD"/>
                                            <ext:ModelField Name="UNIT"/>
                                            <ext:ModelField Name="DELI_QTY"/>
                                            <ext:ModelField Name="DELI_AMT"/>
                                            <ext:ModelField Name="ARRIV_QTY"/>
                                            <ext:ModelField Name="ARRIV_AMT"/>
                                            <ext:ModelField Name="CORCD"/>
                                            <ext:ModelField Name="BIZCD"/>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="TEAM_DIV"/>
                                            <ext:ModelField Name="MGRT_NAME"/>
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
                                <ext:RowNumbererColumn ID="NO"            ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center"  />
                                <ext:Column ID="PARTNO"           ItemID="PARTNOTITLE" runat="server" DataIndex="PARTNO" Width="100" Align="Left" />  <%--Text="품번"--%> 
                                <ext:Column ID="PARTNM"           ItemID="PARTNMTITLE" runat="server" DataIndex="PARTNM" MinWidth="200" Align="Left" Flex="1" />  <%--Text="품명"--%> 
                                <ext:Column ID="STANDARD"         ItemID="STANDARD" runat="server" DataIndex="STANDARD" MinWidth="100" Align="Left" Flex="1" />  <%--Text="규격"--%> 
                                <ext:Column ID="UNIT"             ItemID="UNIT" runat="server" DataIndex="UNIT" Width="60" Align="Center" />  <%--Text="단위"--%> 
                                <ext:NumberColumn ID="DELI_QTY"   ItemID="DELI_QTY02" runat="server" DataIndex="DELI_QTY" Width="80" Align="Right" Format="#,##0" />  <%--Text="월납품수량"--%> 
                                <ext:NumberColumn ID="DELI_AMT"   ItemID="AMT" runat="server" DataIndex="DELI_AMT" Width="80" Align="Right" Format="#,##0" />  <%--Text="금액"--%> 
                                <ext:NumberColumn ID="ARRIV_QTY"  ItemID="ARRIV_QTY02" runat="server" DataIndex="ARRIV_QTY" Width="80" Align="Right" Format="#,##0" />  <%--Text="월입하수량"--%> 
                                <ext:NumberColumn ID="ARRIV_AMT"  ItemID="ARRIV_AMT02" runat="server" DataIndex="ARRIV_AMT" Width="80" Align="Right" Format="#,##0" />  <%--Text="월입하금액"--%> 
                                <ext:Column ID="CORCD" ItemID="CORCD" runat="server" DataIndex="CORCD" Width="80" Align="Left" Hidden="true" />  <%--Text="법인코드"--%> 
                                <ext:Column ID="BIZCD" ItemID="SAUP" runat="server" DataIndex="BIZCD" Width="80" Align="Left" Hidden="true" />  <%--Text="사업장코드"--%> 
                                <ext:Column ID="VENDCD" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="80" Align="Left" Hidden="true" />  <%--Text="업체"--%> 
                                <ext:Column ID="TEAM_DIV" ItemID="TEAM_DIV" runat="server" DataIndex="TEAM_DIV" Width="80" Align="Left" Hidden="true" />  <%--Text="업체구분"--%> 
                                <ext:Column ID="MGRT_NAME" ItemID="MGRT_NAME" runat="server" DataIndex="MGRT_NAME" Width="100" Align="Left" />  <%--Text="청구자"--%> 
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
                                <CellDblClick Fn ="CellDbClick"></CellDblClick>
                        </Listeners>                                                    
                                          
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
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
