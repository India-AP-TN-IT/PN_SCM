<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM20003.aspx.cs" Inherits="Ax.EP.WP.Home.EP_XM.EP_XM20003" %>
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
            //화면 리사이즈까지 완료 후, 조회버튼 클릭 이벤트 발생시킨다. (화면 표시후 디폴트 조회 로직)
            App.ButtonSearch.fireEvent('click');
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight() - 3);
            App.Grid03.setHeight(App.GridPanel.getHeight() - App.InputPanel.getHeight() - 14);
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }
        var test;
        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
            var CtlPopup = Ext.getCmp("HELP_XM20002P1");
            CtlPopup.hide();
                        
            var grid = App.Grid02;
            test = record;
            grid.store.insert(0, record);
            grid.store.getAt(0).data["CHECK_VALUE"] = true;            
            grid.store.getAt(0).data["GROUPID"] = "";
            grid.store.getAt(0).data["BASICACLC"] = false;
            grid.store.getAt(0).data["BASICACLR"] = false;
            grid.store.getAt(0).data["BASICACLU"] = false;
            grid.store.getAt(0).data["BASICACLD"] = false;
            grid.store.getAt(0).data["EXTACL1"] = false;
            grid.store.getAt(0).data["EXTACL2"] = false;
            grid.store.getAt(0).data["EXTACL3"] = false;
            grid.store.getAt(0).data["EXTACL4"] = false;
            grid.store.getAt(0).data["EXTACL5"] = false;   
            grid.store.getAt(0).dirty = true;

            grid.view.refresh();            
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

            if (grid.id == "Grid01") {
                var groupID = grid.getStore().getAt(rowIndex).data["GROUPID"];
                var groupNAME = grid.getStore().getAt(rowIndex).data["GROUPNAME"];

                App.txt02_GROUPNAME.setValue(groupNAME);
                App.direct.Cell_DoubleClick(grid.id, groupID);
            }
            else {
                var userID = grid.getStore().getAt(rowIndex).data["USERID"];
                App.direct.Cell_DoubleClick(grid.id, userID);
            }
        }
             
    </script>
</head>
<body>
    <form id="EP_XM20003" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="hidGROUPID" runat="server" Hidden="true" /> 
    <ext:TextField ID="hidUSERID" runat="server" Hidden="true" /> 
    <ext:TextField ID="UserHelpURL" runat="server" Hidden="true" Text="../EPAdmin/EP_XM20002P1.aspx"></ext:TextField> 
    <ext:TextField ID="PopupWidth" runat="server" Hidden="true" Text="600"></ext:TextField> 
    <ext:TextField ID="PopupHeight" runat="server" Hidden="true" Text="640"></ext:TextField>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_EP_XM20003" runat="server" Cls="search_area_title_name" /><%--Text="사용자메뉴설정" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" >
                <Content>
                    <table>
                        <colgroup>
                            <col style="width: 150px;" />                            
                            <col />
                        </colgroup>
                        <tr>
							<th>
                                <ext:Label ID="lbl01_SYSTEMCODE" runat="server" /><%--Text="System" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SYSTEMCODE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="SYSTENAME" ValueField="SYSTEMCODE" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="SYSTEMCODE" />
                                                        <ext:ModelField Name="SYSTENAME" />
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
            <ext:Panel ID="GridPanel" Region="West" Width="300" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="GROUPID" />
                                            <ext:ModelField Name="GROUPNAME"/>
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
                                <ext:Column ID="GROUPNAME" ItemID="GROUPNAME" runat="server" DataIndex="GROUPNAME" MinWidth="200" Align="Left" Flex="1"/> <%--Text="그룹명"--%>
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
                                  
            <ext:Panel ID="Panel1" runat="server" Region="center" StyleSpec="margin-left:10px;">
                <Items>
                    <ext:Panel ID="InputPanel" runat="server" Cls="bottom_area_table" StyleSpec="margin-top:0; margin-bottom:10px;">
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 150px;" /> 
                                    <col style="width: 300px;" />
                                    <col />
                                </colgroup>
                                <tr>
                                    <th class="ess"><ext:Label ID="lbl02_GROUPNAME" runat="server" /><%--Text="메뉴아이디" />--%></th>
                                    <td><ext:TextField ID="txt02_GROUPNAME" runat="server" Width="200" /></td>   
                                    <td>
                                        <ext:Button ID="btn01_MENUADD" runat="server" TextAlign="Center" Cls="mg_r4"><%--Text="메뉴추가" >--%>
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" />
                                            </DirectEvents>
                                        </ext:Button>
                                    </td>                                      
                                </tr>                                                                      
                            </table>
                        </Content>
                    </ext:Panel>
                    <ext:Panel ID="GridPanel3" Region="Center" Border="True" runat="server" Cls="grid_area">
                        <Items>                                                
                            <ext:GridPanel ID="Grid03" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store3" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="GridModel3" runat="server" Name ="ModelGrid">
                                                <Fields>
                                                    <ext:ModelField Name="USERID"/>
                                                    <ext:ModelField Name="GROUPID"/>
                                                    <ext:ModelField Name="USERNAME"/>
                                                    <ext:ModelField Name="LINENAME"/>
                                                    <ext:ModelField Name="BIZNM"/>                                                            
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
                                        <ext:RowNumbererColumn ID="U_NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />                                           
                                        <ext:Column ID="U_USERID" ItemID="USERID" runat="server" DataIndex="USERID" Width="100" Align="Left" /><%--Text="사용자 아이디"--%>  
                                        <ext:Column ID="U_USERNAME" ItemID="USERNAME" runat="server" DataIndex="USERNAME" Align="Left" Width="80" /><%--Text="사용자명"--%>  
                                        <ext:Column ID="U_LINENAME" ItemID="LINENAME" runat="server" DataIndex="LINENAME" Align="Left" Flex="1"/> <%--Text="라인명"--%>
                                        <ext:Column ID="U_BIZNM" ItemID="BIZNM" runat="server" DataIndex="BIZNM" Align="Left" Width="100"/> <%--Text="사업장명"--%> 
                                    </Columns>                                            
                                </ColumnModel>
                                <Loader ID="Loader3" runat="server" AutoLoad="false" Mode="Data">
                                    <LoadMask ShowMask="true" />
                                </Loader>
                                <View>
                                    <ext:GridView ID="GridView3" runat="server" EnableTextSelection="true"/>
                                </View>
                                <SelectionModel>                            
                                    <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" Mode="Single"/>
                                </SelectionModel>
                                <Listeners>
                                    <CellDblClick Fn ="CellDbClick"></CellDblClick>
                                </Listeners>                    
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus3" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                </BottomBar>
                            </ext:GridPanel>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel> 
                      
            <ext:Panel Region="South" runat="server"  Cls="grid_area" Border="True" StyleSpec="margin-top:10px;">
                <Items>
                    <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." Height="400">
                        <Store>
                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel2" runat="server" Name ="ModelGrid1">
                                        <Fields>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>
                                            <ext:ModelField Name="MENUID"/>
                                            <ext:ModelField Name="MENUNAME"/>
                                            <ext:ModelField Name="GROUPID"/>
                                            <ext:ModelField Name="BASICACLC"/>
                                            <ext:ModelField Name="BASICACLR"/>
                                            <ext:ModelField Name="BASICACLU"/>
                                            <ext:ModelField Name="BASICACLD"/>
                                            <ext:ModelField Name="EXTACL1"/>
                                            <ext:ModelField Name="EXTACL2"/>
                                            <ext:ModelField Name="EXTACL3"/>
                                            <ext:ModelField Name="EXTACL4"/>
                                            <ext:ModelField Name="EXTACL5"/>
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
                                <ext:Column ID ="D_NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo" />
                                </ext:Column>
                                <%--선택체크박스--%>
                                <ext:CheckColumn runat="server" ID ="D_CHECK" itemID="CHK" DataIndex="CHECK_VALUE" Width="35" 
                                    StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false" Editable="true" >
                                </ext:CheckColumn>
                                <ext:Column ID="D_MENUID" ItemID="MENUID" runat="server" DataIndex="MENUID" Width="120" Align="Left" /><%--Text="메뉴아이디"--%>  
                                <ext:Column ID="D_MENUNAME" ItemID="MENUNAME" runat="server" DataIndex="MENUNAME" Align="Left" Flex="1" /><%--Text="메뉴이름"--%>  
                                <ext:CheckColumn ID ="D_BASICACLC" ItemID="BASICACLC" runat="server" DataIndex="BASICACLC" Width="70" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="추가권한"--%>
                                </ext:CheckColumn>
                                <ext:CheckColumn ID ="D_BASICACLR" ItemID="BASICACLR" runat="server" DataIndex="BASICACLR" Width="70" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="조회권한"--%>
                                </ext:CheckColumn>
                                <ext:CheckColumn ID ="D_BASICACLU" ItemID="BASICACLU" runat="server" DataIndex="BASICACLU" Width="70" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="수정권한"--%>
                                </ext:CheckColumn>
                                <ext:CheckColumn ID ="D_BASICACLD" ItemID="BASICACLD" runat="server" DataIndex="BASICACLD" Width="70" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="삭제권한"--%>
                                </ext:CheckColumn>
                                <ext:CheckColumn ID ="D_EXTACL1" ItemID="EXTACL1" runat="server" DataIndex="EXTACL1" Width="70" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="확장권한1"--%>
                                </ext:CheckColumn>
                                <ext:CheckColumn ID ="D_EXTACL2" ItemID="EXTACL2" runat="server" DataIndex="EXTACL2" Width="70" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="확장권한2"--%>
                                </ext:CheckColumn>
                                <ext:CheckColumn ID ="D_EXTACL3" ItemID="EXTACL3" runat="server" DataIndex="EXTACL3" Width="70" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="확장권한3"--%>
                                </ext:CheckColumn>
                                <ext:CheckColumn ID ="D_EXTACL4" ItemID="EXTACL4" runat="server" DataIndex="EXTACL4" Width="70" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="확장권한4"--%>
                                </ext:CheckColumn>
                                <ext:CheckColumn ID ="D_EXTACL5" ItemID="EXTACL5" runat="server" DataIndex="EXTACL5" Width="70" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="확장권한5"--%>
                                </ext:CheckColumn>
                            </Columns>
                            <Listeners>
                                <%--<HeaderClick Fn="onSelectionCheckHeaderChange" />--%> <%--그리드 헤더의 체크박스를 클릭할 경우 발생--%>
                            </Listeners>
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
                            <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
                        
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
