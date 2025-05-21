<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM30410.aspx.cs" Inherits="Ax.EP.WP.Home.EP_XM.EP_XM30410" %>
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
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=20150710133500"  />

    <script src="../../Script/Common.js?v=20150710133500" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();                        
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
            //ChagnePanel(true);
        }

        function ChagnePanel(check) {
            if (check) {                
                App.GridPanel3.Visible = false;
                App.Panelbtn2.Visible = false;
                App.Grid02.setHeight(App.Panel3.getHeight() - 27);
                App.Detail_Excel.Hidden = true;
            } else {
                App.GridPanel3.Visible = true;
                App.Panelbtn2.Visible = true;
                App.Detail_Excel.Hidden = false;
                App.Grid02.setHeight(App.Panel3.getHeight() / 2 - 15);
                App.Grid03.setHeight(App.Panel3.getHeight() / 2 - 15);
            }            
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
    <form id="EP_XM30410" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    
    <ext:TextField ID="hidUSERID" runat="server" Hidden="true" /> 
    <ext:TextField ID="txt01_QUERY" runat="server" Hidden="true" />
    <ext:TextField ID="txt02_QUERY" runat="server" Hidden="true" />
    <ext:TextField ID="txt01_LINK_COLUMN" runat="server" Hidden="true" />
    <ext:TextField ID="txt01_CORCD" runat="server" Hidden="true" />
    <ext:TextField ID="txt01_DOCNO" runat="server" Hidden="true" />
    <ext:TextField ID="txt01_APPLY_LANGUAGE" runat="server" Hidden="true" />

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_EP_XM30410" runat="server" Cls="search_area_title_name" /><%--Text="사용자별 권한 현황" />--%>
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
                            <col style="width: 100px;" />                            
                            <col style="width: 260px;" />                            
                            <col style="width: 70px;" />
                            <col style="width: 100px;" />   
                            <col style="width: 70px;" />
                            <col style="width: 100px;" />                                                      
                            <col />
                        </colgroup>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_SUBJECT" runat="server" />                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_TITLE" Width="238" Cls="inputText" runat="server" />  
                            </td> 
                            <th>
                                <ext:Label ID="Category" runat="server" Text="Category" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_CATEGORY" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store5" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="ID" />
                                                        <ext:ModelField Name="NAME" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                 </ext:SelectBox>                                 
                            </td>                                                       
                            <td>                                
                                <ext:Button ID="btn01_SEARCH" runat="server" TextAlign="Center" Cls="mg_r4" Text="FIND">
                                    <DirectEvents>
                                        <Click OnEvent="etc_Button_Click" />
                                    </DirectEvents>
                                </ext:Button>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60" />
                            </td> 
 

                        </tr>                       
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ContentPanel" runat="server" Region="Center" Layout="BorderLayout">
                <Items>
                    <ext:Panel ID="Panel1" Region="West" Width="400" Border="True" runat="server">
                        <Items>
                            <ext:Panel ID="GridPanel" Region="North" Width="400" Border="True" runat="server" Cls="grid_area" Height="500">
                                <Items>
                                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                        <Store>
                                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="GridModel1" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="TITLE" />
                                                            <ext:ModelField Name="DOC_NO"/>                                                    
                                                            <ext:ModelField Name="CORCD"/>  
                                                            <ext:ModelField Name="APPLY_LANGUAGE"/>  
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
                                                <ext:Column ID="TITLE_G" ItemID="SUBJECT" runat="server"  DataIndex="TITLE"   Width="80" Align="Left"  Flex="1"/> 
                                                <ext:Column ID="DOC_NO_G" ItemID="DOCCD" runat="server" DataIndex="DOC_NO" Width="80" Align="Center" />
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
                            <ext:Panel ID="Panel2" Region="North" Width="400" Border="false" runat="server" Height="1000">
                                <Items> 

                                                                                                             
                                </Items>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>

                    <ext:Panel ID="MarginPanel" runat="server" Region="West" Width="10px">
                        <Items></Items>
                    </ext:Panel>

                    <ext:Panel ID="Panel3" Region="Center" Width="400" Border="False" runat="server">
                        <Items>           
                            <ext:Panel ID="Panelbtn1" runat="server" Height="23" Hidden="false" Region="North" >
                                <Items>
                                    <ext:Panel ID="Panel8" runat="server" StyleSpec="margin-left:5px; float:left;" Width="150" Hidden="false">
                                        <Items>
                                            <ext:Label ID="Label11" runat="server" Cls="bottom_area_title_name2" Width="150px" Text="Master Area" /> 
                                        </Items>
                                    </ext:Panel>

                                    <ext:Panel ID="Panel9" runat="server" Width="300" Hidden="false" Cls="bottom_area_btn" >
                                        <Items>
                                            <ext:Button ID="Master_Excel" runat="server" TextAlign="Center" Cls="mg_r4" Text="Master Excel Down" >
                                                <DirectEvents>
                                                    <Click OnEvent="etc_Button_Click" IsUpload="true">
                                                        <ExtraParams>
                                                            <ext:Parameter Name="Values" Value="App.Grid02.getRowsValues({selectedOnly:false})" Mode="Raw" Encode="true" />
                                                        </ExtraParams>
                                                    </Click>
                                                </DirectEvents>
                                            </ext:Button>   
                                        </Items>
                                    </ext:Panel>                                       
                                </Items>
                            </ext:Panel>                                                                                                       
                            <ext:Panel ID="GridPanel2" Region="North" Border="True" runat="server" Cls="grid_area">
                                <Items>                                                
                                    <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                        <Store>
                                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="GridModel2" runat="server">
                                                        <Fields>                                                            
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
                                        <DirectEvents>                         
                                            <Select OnEvent="RowSelect2">
                                                <ExtraParams>
                                                    <ext:Parameter Name="Values" Value="this.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                                </ExtraParams>
                                            </Select>
                                        </DirectEvents>                                                          
                                        <BottomBar>
                                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                            <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                        </BottomBar>
                                    </ext:GridPanel>
                                </Items>
                            </ext:Panel>
                            <ext:Panel ID="MarginPanel2" runat="server" Region="North" Height="10px" Visible="false">
                                <Items></Items>
                            </ext:Panel>
                            <ext:Panel ID="Panelbtn2" runat="server" Height="23" Hidden="false" Region="North" Border="False"  Visible="true">
                                <Items>
                                    <ext:Panel ID="Panel13" runat="server" StyleSpec="margin-left:5px; float:left;" Width="150" Hidden="false">
                                        <Items>
                                            <ext:Label ID="Label111" runat="server" Cls="bottom_area_title_name2" Width="150px" Text="Detail Area" /> 
                                        </Items>
                                    </ext:Panel>

                                    <ext:Panel ID="Panel14" runat="server" Width="300" Hidden="false" Cls="bottom_area_btn" >
                                        <Items>
                                            <ext:Button ID="Detail_Excel" runat="server" TextAlign="Center" Cls="mg_r4" Text="Detail Excel Down">  
                                                <DirectEvents>
                                                    <Click OnEvent="etc_Button_Click" IsUpload="true">
                                                        <ExtraParams>
                                                            <ext:Parameter Name="Values" Value="App.Grid03.getRowsValues({selectedOnly:false})" Mode="Raw" Encode="true" />
                                                        </ExtraParams>
                                                    </Click>
                                                </DirectEvents>
                                            </ext:Button>                                                                                      
                                        </Items>
                                    </ext:Panel>                                       
                                </Items>
                            </ext:Panel>
                            <ext:Panel ID="GridPanel3" Region="North" Border="True" runat="server" Cls="grid_area" Visible="true">
                                <Items>                                                
                                    <ext:GridPanel ID="Grid03" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                        <Store>
                                            <ext:Store ID="Store3" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="Model1" runat="server">
                                                        <Fields>                                                            
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
                                                <ext:RowNumbererColumn ID="RowNumbererColumn2" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />                                                
                                            </Columns>
                                        </ColumnModel>
                                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                            <LoadMask ShowMask="true" />
                                        </Loader>
                                        <View>
                                            <ext:GridView ID="GridView3" runat="server" EnableTextSelection="true"/>
                                        </View>
                                        <SelectionModel>                            
                                            <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" Mode="Single"/>
                                        </SelectionModel>                    
                                        <BottomBar>
                                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                            <ext:StatusBar ID="StatusBar1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
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
    <%--디자인 때문에 임의로 생성한다. 조회조건에서 사용하는 alert 및 validation--%>
    <ext:Panel ID="Panel4" Region="North" Width="400" Border="false" runat="server" StyleSpec="display:none;">
        <Items>                                                                                              
        </Items>
    </ext:Panel>
    </form>
</body>
</html>
