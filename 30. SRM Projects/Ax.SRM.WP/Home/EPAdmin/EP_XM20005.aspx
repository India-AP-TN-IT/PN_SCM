<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM20005.aspx.cs" Inherits="Ax.EP.WP.Home.EP_XM.EP_XM20005" %>
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
            App.Grid02.setHeight(App.GridPanel.getHeight() - App.InputPanel.getHeight() - 14);
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

            var menuID = grid.getStore().getAt(rowIndex).data["MENUID"];
            App.direct.Cell_DoubleClick(menuID);
        }
             
    </script>
</head>
<body>
    <form id="EP_XM20005" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="hidMODE" runat="server" Hidden="true" Text="Regist" /> <%--등록 또는 수정 모드 기록용--%>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_EP_XM20005" runat="server" Cls="search_area_title_name" /><%--Text="메뉴관리" />--%>
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
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col style="width: 300px;"/>
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
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
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
                            <th >
                                <ext:Label ID="lbl01_MODULE" runat="server" /><%--Text="모듈종류" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_MODULE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="MENUNAME" ValueField="MENUID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="MENUID" />
                                                        <ext:ModelField Name="MENUNAME" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox> 
                            </td>
                            <td>
                                <ext:Button ID="btn01_CPOY" runat="server" TextAlign="Center" Cls="mg_r4"><%--Text="간편 메뉴 복사" >--%>
                                    <DirectEvents>
                                        <Click OnEvent="etc_Button_Click" />
                                    </DirectEvents>
                                </ext:Button>
                            </td>                            
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ContentPanel" runat="server" Region="Center" Layout="BorderLayout">
                <Items>
                    <ext:Panel ID="GridPanel" Region="West" Width="600" Border="True" runat="server" Cls="grid_area">
                        <Items>
                            <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store1" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="GridModel1" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="MENUID" />
                                                    <ext:ModelField Name="PARENTID_TM"/>
                                                    <ext:ModelField Name="USEYN"/>
                                                    <ext:ModelField Name="MENUORDER"/>
                                                    <ext:ModelField Name="MENUNM"/>
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
                                        <ext:Column ID="MENUID" ItemID="MENUID" runat="server"  DataIndex="MENUID"   Width="120" Align="Left" /> <%--Text="메뉴아이디"    --%>
                                        <ext:Column ID="PARENTID_TM" ItemID="PARENTID_TM" runat="server" DataIndex="PARENTID_TM" Width="80" Align="Left" /> <%--Text="상위메뉴"  --%>
                                        <ext:CheckColumn ID ="USEYN" ItemID="SYSTEM_USE" runat="server" DataIndex="USEYN" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="사용"--%>
                                        </ext:CheckColumn>
                                        <ext:Column ID="MENUORDER" ItemID="SORT_SEQ2" runat="server" DataIndex="MENUORDER" Width="60" Align="Right"/> <%--Text="정렬"--%>
                                        <ext:Column ID="MENUNM" ItemID="MENUNM" runat="server" DataIndex="MENUNM" MinWidth="200" Align="Left" Flex="1"/> <%--Text="메뉴명"--%>
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
                    <ext:Panel ID="MarginPanel" runat="server" Region="West" Width="10px">
                        <Items></Items>
                    </ext:Panel>
                    <ext:Panel runat="server" Region="Center">
                        <Items>
                            <ext:Panel ID="InputPanel" runat="server" Cls="bottom_area_table" StyleSpec="margin-top:0; margin-bottom:10px;">
                                <Content>
                                    <table>
                                        <colgroup>
                                            <col style="width: 150px;" /> 
                                            <col style="width: 150px;" />
                                            <col style="width: 150px;" />                                     
                                            <col />
                                        </colgroup>
                                        <tr>
                                            <th class="ess"><ext:Label ID="lbl02_MENUID" runat="server" /><%--Text="메뉴아이디" />--%></th>
                                            <td colspan="3"><ext:TextField ID="txt02_MENUID" runat="server" Width="400" /></td>                                        
                                        </tr>
                                        <tr>
                                            <th class="ess"><ext:Label ID="lbl02_MENUNAME" runat="server" /><%--Text="메뉴이름" />--%></th>
                                            <td colspan="3"><ext:TextField ID="txt02_MENUNAME" runat="server" Width="400" /></td>                                        
                                        </tr>
                                        <tr>
                                            <th class="ess"><ext:Label ID="lbl02_SYSTEMCODE" runat="server" /><%--시스템--%></th>
                                            <td colspan="3">
                                                <ext:SelectBox ID="cbo02_SYSTEMCODE" runat="server"  Mode="Local" ForceSelection="true"
                                                    DisplayField="SYSTENAME" ValueField="SYSTEMCODE" TriggerAction="All" Width="400">
                                                    <Store>
                                                        <ext:Store ID="Store5" runat="server" >
                                                            <Model>
                                                                <ext:Model ID="Model5" runat="server">
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
                                        <tr>
                                            <th class="ess"><ext:Label ID="lbl02_MENUACTION" runat="server" /><%--메뉴역할--%></th>
                                            <td colspan="3">
                                                <ext:SelectBox ID="cbo02_MENUACTION" runat="server"  Mode="Local" ForceSelection="true"
                                                    DisplayField="NAME" ValueField="CODE" TriggerAction="All" Width="400">
                                                    <Store>
                                                        <ext:Store ID="Store6" runat="server" >
                                                            <Model>
                                                                <ext:Model ID="Model6" runat="server">
                                                                    <Fields>
                                                                        <ext:ModelField Name="CODE" />
                                                                        <ext:ModelField Name="NAME" />
                                                                    </Fields>
                                                                </ext:Model>
                                                            </Model>
                                                        </ext:Store>
                                                    </Store>
                                                </ext:SelectBox>
                                            </td>                                        
                                        </tr>
                                        <tr>
                                            <th><ext:Label ID="lbl02_HIDDEN" runat="server" /><%--숨김--%></th>
                                            <td><ext:Checkbox ID="chk02_MENUHIDE3" runat="server" Cls="inputText" /></td>
                                            <th><ext:Label ID="lbl02_EXPANDED2" runat="server" /><%--확장--%></th>
                                            <td><ext:Checkbox ID="chk02_EXPANDED3" runat="server" Cls="inputText" /></td>                                       
                                        </tr>
                                        <tr>
                                            <th><ext:Label ID="lbl02_FORCEENABLED2" runat="server" /><%--표시--%></th>
                                            <td><ext:Checkbox ID="chk02_FORCEENABLED3" runat="server" Cls="inputText" /></td>
                                            <th><ext:Label ID="lbl02_USEYN" runat="server" /><%--사용여부--%></th>
                                            <td><ext:Checkbox ID="chk02_USEYN2" runat="server" Cls="inputText" /></td>                                       
                                        </tr>
                                        <tr>
                                            <th><ext:Label ID="lbl02_MENUDLLURL" runat="server" /><%--DLL경로--%></th>
                                            <td colspan="3"><ext:TextField ID="txt02_MENUDLLURL" runat="server" Width="400"/></td>                                        
                                        </tr>
                                        <tr>
                                            <th><ext:Label ID="lbl02_MENUCLASS" runat="server" /><%--클래스명--%></th>
                                            <td colspan="3"><ext:TextField ID="txt02_MENUCLASS" runat="server" Width="400"/></td>                                        
                                        </tr>
                                        <tr>
                                            <th><ext:Label ID="lbl02_PARENTID" runat="server" /><%--부모메뉴아이디--%></th>
                                            <td colspan="3"><ext:TextField ID="txt02_PARENTID" runat="server" Width="400"/></td>                                        
                                        </tr>
                                        <tr>
                                            <th class="ess"><ext:Label ID="lbl02_SORT_SEQ" runat="server" /><%--정렬순서--%></th>
                                            <td colspan="3"><ext:TextField ID="txt02_MENUORDER" runat="server" Width="400"/></td>                                        
                                        </tr>
                                        <tr>
                                            <th><ext:Label ID="lbl02_EXTRAINFO2" runat="server" /><%--대메뉴Icon--%></th>
                                            <td colspan="3"><ext:TextField ID="txt02_EXTRAINFO" runat="server" Width="400"/></td>                                        
                                        </tr>                                   
                                    </table>
                                </Content>
                            </ext:Panel>
                            <ext:Panel ID="GridPanel2" Region="Center" Border="True" runat="server" Cls="grid_area">
                                <Items>                                                
                                    <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                        <Store>
                                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="GridModel2" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="GROUPID"/>
                                                            <ext:ModelField Name="GROUPNAME"/>
                                                            <ext:ModelField Name="BASICACLC3"/>
                                                            <ext:ModelField Name="BASICACLR3"/>
                                                            <ext:ModelField Name="BASICACLU2"/>
                                                            <ext:ModelField Name="BASICACLD2"/>
                                                            <ext:ModelField Name="EXTACL1_2"/>
                                                            <ext:ModelField Name="EXTACL2_2"/>
                                                            <ext:ModelField Name="EXTACL3_2"/>
                                                            <ext:ModelField Name="EXTACL4_2"/>
                                                            <ext:ModelField Name="EXTACL5_2"/>
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
                                            <ext:BufferedRenderer ID="BufferedRenderer3"  runat="server"/>
                                        </Plugins>  
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:RowNumbererColumn ID="RowNumbererColumn1" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                                <ext:Column ID="GROUPNAME" ItemID="GROUPNAME" runat="server" DataIndex="GROUPNAME" Align="Left" Flex="1" /><%--Text="그룹명"--%>  
                                                <ext:CheckColumn ID ="BASICACLC3" ItemID="BASICACLC3" runat="server" DataIndex="BASICACLC3" Width="40" Align ="Center" StopSelection="false" 
                                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="생성"--%>
                                                </ext:CheckColumn>
                                                <ext:CheckColumn ID ="BASICACLR3" ItemID="BASICACLR3" runat="server" DataIndex="BASICACLR3" Width="40" Align ="Center" StopSelection="false" 
                                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="읽기"--%>
                                                </ext:CheckColumn>
                                                <ext:CheckColumn ID ="BASICACLU2" ItemID="BASICACLU2" runat="server" DataIndex="BASICACLU2" Width="40" Align ="Center" StopSelection="false" 
                                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="수정"--%>
                                                </ext:CheckColumn>
                                                <ext:CheckColumn ID ="BASICACLD2" ItemID="BASICACLD2" runat="server" DataIndex="BASICACLD2" Width="40" Align ="Center" StopSelection="false" 
                                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="삭제"--%>
                                                </ext:CheckColumn>
                                                <ext:CheckColumn ID ="EXTACL1_2" ItemID="EXTACL1_2" runat="server" DataIndex="EXTACL1_2" Width="40" Align ="Center" StopSelection="false" 
                                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="리셋"--%>
                                                </ext:CheckColumn>
                                                <ext:CheckColumn ID ="EXTACL2_2" ItemID="EXTACL2_2" runat="server" DataIndex="EXTACL2_2" Width="40" Align ="Center" StopSelection="false" 
                                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="처리"--%>
                                                </ext:CheckColumn>
                                                <ext:CheckColumn ID ="EXTACL3_2" ItemID="EXTACL3_2" runat="server" DataIndex="EXTACL3_2" Width="40" Align ="Center" StopSelection="false" 
                                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="출력"--%>
                                                </ext:CheckColumn>
                                                <ext:CheckColumn ID ="EXTACL4_2" ItemID="EXTACL4_2" runat="server" DataIndex="EXTACL4_2" Width="40" Align ="Center" StopSelection="false" 
                                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="다운"--%>
                                                </ext:CheckColumn>
                                                <ext:CheckColumn ID ="EXTACL5_2" ItemID="EXTACL5_2" runat="server" DataIndex="EXTACL5_2" Width="40" Align ="Center" StopSelection="false" 
                                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="업"--%>
                                                </ext:CheckColumn>  
                                            </Columns>
                                        </ColumnModel>
                                        <Loader ID="Loader3" runat="server" AutoLoad="false" Mode="Data">
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
                    </ext:Panel>               
                </Items>
            </ext:Panel>     
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
