<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM30004.aspx.cs" Inherits="Ax.EP.WP.Home.EP_XM.EP_XM30004" %>
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
            App.Grid01.setHeight(App.GridPanel.getHeight());
            App.Grid02.setHeight(App.GridPanel.getHeight());
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

            var userID = grid.getStore().getAt(rowIndex).data["EMPNO"];
            App.direct.Cell_DoubleClick(userID);
        }
             
    </script>
</head>
<body>
    <form id="EP_XM30004" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    
    <ext:TextField ID="hidUSERID" runat="server" Hidden="true" /> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_EP_XM30004" runat="server" Cls="search_area_title_name" /><%--Text="사용자별 권한 현황" />--%>
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
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
							<th>
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
                            <th>         
                                <ext:Label ID="lbl01_EMPNO" runat="server" />                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_USERID" Width="150" Cls="inputText" runat="server" />  
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_EMPNM" runat="server" />                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_USERNAME" Width="150" Cls="inputText" runat="server" />  
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_SYSTEMCODE" runat="server" /><%--Text="System" />--%>
                            </th>
                            <td colspan="5">
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
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ContentPanel" runat="server" Region="Center" Layout="BorderLayout">
                <Items>
                    <ext:Panel ID="GridPanel" Region="West" Width="400" Border="True" runat="server" Cls="grid_area">
                        <Items>
                            <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store1" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="GridModel1" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="EMPNO" />
                                                    <ext:ModelField Name="EMPNM"/>
                                                    <ext:ModelField Name="LINENAME"/>
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
                                        <ext:Column ID="EMPNO" ItemID="EMPNO" runat="server"  DataIndex="EMPNO"   Width="80" Align="Left" /> <%--Text="사번"    --%>
                                        <ext:Column ID="EMPNM" ItemID="EMPNM" runat="server" DataIndex="EMPNM" Width="80" Align="Left" /> <%--Text="성명"  --%>
                                        <ext:Column ID="LINENAME" ItemID="LINENAME" runat="server" DataIndex="LINENAME" Align="Left" Flex="1"/> <%--Text="라인명"--%>
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
                                                    <ext:ModelField Name="MENUID"/>
                                                    <ext:ModelField Name="MENUID2"/>
                                                    <ext:ModelField Name="MENUNAME"/>
                                                    <ext:ModelField Name="BASICACLC2"/>
                                                    <ext:ModelField Name="BASICACLR2"/>
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
                                        <ext:Column ID="GROUPNAME" ItemID="GROUPNAME" runat="server" DataIndex="GROUPNAME" Align="Left" Width="120" /><%--Text="그룹명"--%>  
                                        <ext:Column ID="MENUID2" ItemID="MENUID2" runat="server" DataIndex="MENUID2" Align="Left" Width="160" /><%--Text="메뉴아이디"--%>  
                                        <ext:Column ID="MENUNAME" ItemID="MENUNAME" runat="server" DataIndex="MENUNAME" Align="Left" minWidth="160" Flex="1" /><%--Text="메뉴이름"--%>  
                                        <ext:CheckColumn ID ="BASICACLC2" ItemID="BASICACLC2" runat="server" DataIndex="BASICACLC2" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="추가"--%>
                                        </ext:CheckColumn>
                                        <ext:CheckColumn ID ="BASICACLR2" ItemID="BASICACLR2" runat="server" DataIndex="BASICACLR2" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="조회"--%>
                                        </ext:CheckColumn>
                                        <ext:CheckColumn ID ="BASICACLU2" ItemID="BASICACLU2" runat="server" DataIndex="BASICACLU2" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="수정"--%>
                                        </ext:CheckColumn>
                                        <ext:CheckColumn ID ="BASICACLD2" ItemID="BASICACLD2" runat="server" DataIndex="BASICACLD2" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="삭제"--%>
                                        </ext:CheckColumn>
                                        <ext:CheckColumn ID ="EXTACL1_2" ItemID="EXTACL1_2" runat="server" DataIndex="EXTACL1_2" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="리셋"--%>
                                        </ext:CheckColumn>
                                        <ext:CheckColumn ID ="EXTACL2_2" ItemID="EXTACL2_2" runat="server" DataIndex="EXTACL2_2" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="처리"--%>
                                        </ext:CheckColumn>
                                        <ext:CheckColumn ID ="EXTACL3_2" ItemID="EXTACL3_2" runat="server" DataIndex="EXTACL3_2" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="출력"--%>
                                        </ext:CheckColumn>
                                        <ext:CheckColumn ID ="EXTACL4_2" ItemID="EXTACL4_2" runat="server" DataIndex="EXTACL4_2" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="다운"--%>
                                        </ext:CheckColumn>
                                        <ext:CheckColumn ID ="EXTACL5_2" ItemID="EXTACL5_2" runat="server" DataIndex="EXTACL5_2" Width="40" Align ="Center" StopSelection="false" 
                                            Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="업"--%>
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
    </ext:Viewport>
    </form>
</body>
</html>
