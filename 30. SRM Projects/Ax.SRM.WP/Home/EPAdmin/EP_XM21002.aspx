<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM21002.aspx.cs" Inherits="Ax.EP.WP.Home.EP_XM.EP_XM21002" %>
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
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
	    .x-grid-cell-CODE DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    };
	    
    </style>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        // 그리드에서 선택된 Action Object
        var currentCellObject;

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
            App.Grid02.setHeight(App.GridPanel.getHeight() - App.InputPanel.getHeight() - 15);
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
            var menuNAME = grid.getStore().getAt(rowIndex).data["MENUNM"];
            App.direct.Cell_DoubleClick(menuID, menuNAME);
        }

        //언어코드 조회
        var fn_query_btn_click = function () {
            App.btn01_QUERY.fireEvent('click');
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드의 editor를 활성화시키는 시점에서 작동        
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        // 그리드를 editor한 후에 발생되는 이벤트
        var AfterEdit = function (rowEditor, e) {
            if (e.column.dataIndex != "CHK") {
                e.grid.getStore().getAt(e.rowIdx).set("CHK", false);
                e.grid.getStore().getAt(e.rowIdx).set("CHK", e.grid.getStore().getAt(e.rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
            } else {
                e.grid.getStore().getAt(e.rowIdx).dirty = e.grid.getStore().getAt(e.rowIdx).data["CHK"];
            }
        }
             
    </script>
</head>
<body>
    <form id="EP_XM21002" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_QUERY" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_EP_XM21002" runat="server" Cls="search_area_title_name" /><%--Text="메뉴관리" />--%>
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
                            <col style="width: 100px;" />
                            <col/>
                        </colgroup>
                        <tr>
							<th class="ess">
                                <ext:Label ID="lbl01_SYSTEMCODE" runat="server" /><%--Text="System" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SYSTEMCODE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="SYSTENAME" ValueField="SYSTEMCODE" TriggerAction="All" >
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
                                    DisplayField="MENUNAME" ValueField="MENUID" TriggerAction="All" >
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
                                                    <ext:ModelField Name="MENUID"/>
                                                    <ext:ModelField Name="MENUNM"/>
                                                    <ext:ModelField Name="PARENTID"/>
                                                    <ext:ModelField Name="USEYN"/>
                                                    <ext:ModelField Name="MENUORDER"/>
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
                                        <ext:Column ID="MENUID" ItemID="MENUID" runat="server" DataIndex="MENUID" Width="70" Align="Left" />  <%--Text="메뉴아이디"--%> 
                                        <ext:Column ID="MENUNM" ItemID="MENUNM" runat="server" DataIndex="MENUNM" Width="280" Align="Left" />  <%--Text=""--%> 
                                        <ext:Column ID="PARENTID" ItemID="PARENTID" runat="server" DataIndex="PARENTID" Width="0" Align="Left" />  <%--Text=""--%> 
                                        <ext:Column ID="USEYN" ItemID="USEYN" runat="server" DataIndex="USEYN" Width="0" Align="Center" />  <%--Text=""--%> 
                                        <ext:Column ID="MENUORDER" ItemID="MENUORDER" runat="server" DataIndex="MENUORDER" Width="0" Align="Center" />  <%--Text=""--%> 
                                        <ext:Column ID="Column1" ItemID="Column1" runat="server" DataIndex="Column1" MinWidth="1" Align="Center" Flex="1" />  <%--Text=""--%> 
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
                                    <col style="width: 100px;" /> 
                                    <col style="width: 150px;" />
                                    <col style="width: 100px;" />                                     
                                    <col />
                                </colgroup>
                                    <tr>
                                        <th class="ess"><ext:Label ID="lbl02_MENUID" runat="server" /><%--Text="메뉴아이디" />--%></th>
                                        <td ><ext:TextField ID="txt02_MENUID" runat="server" /></td>
                                        <th><ext:Label ID="lbl02_MENUNAME" runat="server" /><%-- Text="메뉴이름" />--%></th>
                                        <td ><ext:TextField ID="txt02_MENUNAME" runat="server" /></td>            
                                    </tr>                      
                                </table>
                                </Content>
                            </ext:Panel>
                            <ext:Panel ID="Panel1" runat="server" Cls="bottom_area_table" StyleSpec="margin-top:0; margin-bottom:10px;">
                                <Content>
                                <table>
                                <colgroup>
                                    <col style="width: 100px;" /> 
                                    <col style="width: 150px;" />
                                    <col style="width: 100px;" />
                                    <col style="width: 150px;" />
                                    <col />
                                </colgroup>
                                    <tr>
                                        <th><ext:Label ID="lbl02_LANGUAGE" runat="server" /><%--Text="언어" />--%></th>
                                        <td>
                                           <ext:SelectBox ID="cbo02_LANGUAGE" runat="server"  Mode="Local" ForceSelection="true"
                                                DisplayField="OBJECT_NM" ValueField="TYPECD" TriggerAction="All" >
                                                <Store>
                                                    <ext:Store ID="Store5" runat="server" >
                                                        <Model>
                                                            <ext:Model ID="Model1" runat="server">
                                                                <Fields>
                                                                    <ext:ModelField Name="TYPECD" />
                                                                    <ext:ModelField Name="OBJECT_NM" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>
                                            </ext:SelectBox>
                                        </td> 
                                        <th><ext:Label ID="lbl02_INCLUDE_LANG" runat="server" /><%--Text="포함된 다국어" />--%></th>
                                        <td><ext:Checkbox ID="chk02_INCLUDE_MSG" runat="server" /></td>                                        
                                        <td>
                                            <ext:Button ID="btn01_INQUERY" runat="server" >
                                                <Listeners>
                                                    <Click Fn="fn_query_btn_click" />
                                                </Listeners>
                                            </ext:Button>
                                        </td>
                                    </tr>          
                                    <tr>
                                        <th><ext:Label ID="lbl02_CODE" runat="server" /><%--Text="코드" />--%></th>
                                        <td><ext:TextField ID="txt02_CODE" runat="server" /></td> 
                                        <th><ext:Label ID="lbl02_CODENM" runat="server" /><%--Text="코드명" />--%></th>
                                        <td><ext:TextField ID="txt02_CODENAME" runat="server" /></td>                                       
                                        <td>&nbsp;</td> 
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
                                                            <ext:ModelField Name="NO" /> 
                                                            <%--실제 디비에서 가져와서 사용함.--%>
                                                            <ext:ModelField Name="CHK" DefaultValue="false" Type="Boolean"/>                                            
                                                            <ext:ModelField Name="CODE"/>
                                                            <ext:ModelField Name="CODENAME"/>
                                                            <ext:ModelField Name="INCLUDE"/>
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
                                            <%-- 2.X버전부터는 그리드에서 edtior를 활성화 시키기위해서 cellEditing Plugin을 추가 하여 사용하고 자바스크립트에서 grid.editingPlugin 형태로 사용할수 있다. --%>
                                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                                <Listeners>                                    
                                                    <BeforeEdit fn="BeforeEdit" />
                                                    <Edit fn ="AfterEdit" />                                    
                                                </Listeners> 
                                            </ext:CellEditing>
                                        </Plugins>  
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns> 
                                                <%--Text="해당 메뉴에 포함된 것만 보여집니다."--%>
                                                <ext:RowNumbererColumn ID="RowNumbererColumn1" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                                <ext:CheckColumn ID ="CHK" ItemID="CHK" DataIndex="CHK"  runat="server" Width="50"
                                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >                                        
                                                </ext:CheckColumn> 
                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="CODE" ItemID="CODE" DataIndex="CODE" runat="server" Width="100" Align="Left"> <%--코드--%>
                                                    <Editor>
                                                        <ext:TextField ID="txt03_CODE" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>
                                                </ext:Column>

                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="CODENAME" ItemID="CODENAME" DataIndex="CODENAME"  runat="server" Width="400" Align="Left"> <%--Text="코드명"--%>
                                                    <%--<Editor>
                                                        <ext:TextField ID="txt03_CODENAME" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>--%>
                                                </ext:Column>

                                                <%-- 일반 text editor--%>
                                                <ext:Column ID="INCLUDE" ItemID="REMARK" DataIndex="INCLUDE"  runat="server" Width="70" Align="Left"> <%--Text="비고"--%>
                                                   <%-- <Editor>
                                                        <ext:TextField ID="txt03_INCLUDE" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                                    </Editor>--%>
                                                </ext:Column>
                                                <ext:Column ID="Column2" ItemID="Column2" DataIndex="Column2"  runat="server" MinWidth="1" Flex="1" Align="Center" /> <%--Text=""--%>
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
