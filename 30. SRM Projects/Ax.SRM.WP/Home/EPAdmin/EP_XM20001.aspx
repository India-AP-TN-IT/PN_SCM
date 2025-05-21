<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM20001.aspx.cs" Inherits="Ax.EP.WP.Home.EP_XM.EP_XM20001" %>
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
            App.Grid03.setHeight(App.GridPanel3.getHeight());
            App.Grid02.setHeight(App.ContentPanel.getHeight() - App.GridPanel3.getHeight() - (App.InputPanel.getHeight()) - App.Panel1.getHeight() -34);
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

            var groupID = grid.getStore().getAt(rowIndex).data["GROUPID"];
            var groupNAME = grid.getStore().getAt(rowIndex).data["GROUPNAME"];
            var groupNOTE = grid.getStore().getAt(rowIndex).data["GROUPNOTE"];
            App.direct.Cell_DoubleClick(groupID, groupNAME, groupNOTE);
        }

//        /*---------------------------------------------------------------------------------------------------------------------------------------------------
//        그리드의 editor를 활성화시키는 시점에서 작동        
//        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
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

        //해당 권한을 아래로 추가
        var fn_addgroup_btn_click = function () {
            Ext.Msg.confirm("ConFirm", getCodeMsg("SRMXM-0026"), function (btn) {
                if (btn == 'yes') {
                    App.direct.btn01_AddGroupId();
                }
            });
        };

        //사용자 권한그룹 조회
        var fn_query_btn_click = function () {
            App.direct.btn01_QueryId();
        };

        //사용자 권한그룹 복사
        var fn_copy_btn_click = function () {
            App.direct.btn01_CopyId();
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 복사대상 사용자ID 입력 팝업에서 입력한 데이터 값
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/

        var fn_XM20001 = function (id, userid, option) {
            Ext.Msg.confirm("ConFirm", getCodeMsg("SRMXM-0023"), function (btn) {
                if (btn == 'yes') {
                    App.direct.CopyID(userid, option);
                    Ext.getCmp(id).hide();
                }
            });
        };

        //사용자 권한그룹 삭제
        var fn_delete_btn_click = function () {
            Ext.Msg.confirm("ConFirm", getCodeMsg("SRMXM-0019"), function (btn) {
                if (btn == 'yes') {
                    App.direct.btn01_DeleteId(Ext.encode(App.Grid02.getRowsValues(true)));
                }
            });
        };

    </script>
</head>
<body>
    <form id="EP_XM20001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="UserHelpURL" runat="server" Hidden="true" Text="../EPAdmin/EP_XM20001P1.aspx"></ext:TextField> 
    <ext:TextField ID="PopupWidth" runat="server" Hidden="true" Text="700"></ext:TextField> 
    <ext:TextField ID="PopupHeight" runat="server" Hidden="true" Text="200"></ext:TextField>

    <ext:TextField ID="txt01_Check" runat="server" Hidden="true" />
    <ext:TextField ID="txt02_GROUPID_CHK" runat="server" Hidden="true" />

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_EP_XM20001" runat="server" Cls="search_area_title_name" /><%--Text="메뉴관리" />--%>
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
                            <col style="width: 100px;" />
                            <col/>
                        </colgroup>
                        <tr>
							<th class="ess">
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
                                <ext:Label ID="lbl01_GROUPID" runat="server" />  <%--Text="그룹ID"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_GROUPID" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_GROUPNAME" runat="server" /> <%--Text="그룹명"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_GROUPNAME" Cls="inputText" runat="server" />
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
                                                    <ext:ModelField Name="SYSTEMCODE"/>
                                                    <ext:ModelField Name="GROUPID"/>
                                                    <ext:ModelField Name="GROUPNAME"/>
                                                    <ext:ModelField Name="GROUPNOTE"/>
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
                                        <ext:Column ID="SYSTEMCODE" ItemID="SYSTEMCODE" runat="server" DataIndex="SYSTEMCODE" Width="70" Align="Center" />  <%--Text="System"--%> 
                                        <ext:Column ID="GROUPID" ItemID="GROUPID" runat="server" DataIndex="GROUPID" Width="50" Align="Center" />  <%--Text="그룹명"--%> 
                                        <ext:Column ID="GROUPNAME" ItemID="GROUPNAME" runat="server" DataIndex="GROUPNAME" Width="130" Align="Left" />  <%--Text="그룹설명"--%> 
                                        <ext:Column ID="GROUPNOTE" ItemID="GROUPNOTE" runat="server" DataIndex="GROUPNOTE" Width="255" Align="Left" />  <%--Text="그룹설명"--%> 
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
                                    <col style="width: 200px;" />
                                    <col style="width: 100px;" />                                     
                                    <col />
                                </colgroup>
                                    <tr>
                                        <th class="ess"><ext:Label ID="lbl02_GROUPID" runat="server" /><%--Text="그룹아이디" />--%></th>
                                        <td><ext:TextField ID="txt02_GROUPID" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/" /></td>
                                        <th class="ess">
                                            <ext:Label ID="lbl02_SYSTEMCODE" runat="server" /><%-- Text="System" />--%>
                                         </th>
                                        <td>
                                            <ext:SelectBox ID="cbo02_SYSTEMCODE" runat="server"  Mode="Local" ForceSelection="true"
                                                DisplayField="SYSTENAME" ValueField="SYSTEMCODE" TriggerAction="All" >
                                                <Store>
                                                    <ext:Store ID="Store4" runat="server" >
                                                        <Model>
                                                            <ext:Model ID="Model2" runat="server">
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
                                        <th class="ess"><ext:Label ID="lbl02_GROUPNAME" runat="server" /><%--Text="그룹명" />--%></th>
                                        <td colspan="3">
                                            <ext:TextField ID="txt02_GROUPNAME" runat="server" />
                                        </td>            
                                    </tr> 
                                    <tr>
                                        <th class="ess"><ext:Label ID="lbl02_GROUPNOTE" runat="server" /><%--Text="그룹설명" />--%></th>
                                        <td colspan="3">
                                            <ext:TextField ID="txt02_GROUPNOTE" runat="server" />
                                        </td>            
                                    </tr>   
                                    <tr style="height:30px;"> <%--4.X--%>
                                        <td colspan="4" align="right" style="padding-bottom:3px; text-align:right;" >
                                            <ext:Button ID="btn01_ADD_GROUP" runat="server" TextAlign="Center" > <%--Text="해당권한을 아래로 추가"--%>
                                                <Listeners>
                                                    <Click Fn="fn_addgroup_btn_click" />
                                                </Listeners>
                                             </ext:Button>  
                                        </td>            
                                    </tr>                   
                                </table>
                                </Content>
                            </ext:Panel>
                            <ext:Panel ID="Panel1" runat="server" Cls="bottom_area_table" StyleSpec="margin-top:0; margin-bottom:10px;">
                                <Content>
                                <table>
                                <colgroup>
                                    <col style="width: 100px;" /> 
                                    <col style="width: 200px;" />
                                    <col style="width: 30px;" />
                                    <col style="width: 30px;" />
                                    <col />
                                </colgroup>
                                    <tr>
                                        <th class="ess"><ext:Label ID="lbl02_USERID" runat="server" /><%--Text="사용자 아이디" />--%></th>
                                        <td>
                                           <epc:EPCodeBox ID="cdx02_EMPNO" runat="server" HelperID="HELP_EMPNO" PopupMode="Search" PopupType="HelpWindow"/>
                                        </td>                                                                         
                                        <td>
                                            <ext:Button ID="btn01_INQUERY" runat="server" TextAlign="Center" > <%--Text="조회"--%>
                                                <Listeners>
                                                    <Click Fn="fn_query_btn_click" />
                                                </Listeners>
                                             </ext:Button>                                                                                               
                                        </td>
                                        <td>
                                            <ext:Button ID="btn01_COPY" runat="server" TextAlign="Center" > <%--Text="복사"--%>
                                                <Listeners>
                                                    <Click Fn="fn_copy_btn_click" />
                                                </Listeners>
                                             </ext:Button>  
                                        </td>                                               
                                        <td>
                                            <ext:Button ID="btn01_REMOVE" runat="server" TextAlign="Center" > <%--Text="삭제"--%>
                                                <Listeners>
                                                    <Click Fn="fn_delete_btn_click" />
                                                </Listeners>
<%--                                                <DirectEvents>
                                                    <Click OnEvent="etc_Button_Click">
                                                        <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want delete?">
                                                        </Confirmation>
                                                        <ExtraParams>
                                                            <ext:Parameter Name="Values" Mode="Raw", Encode="true" Value="App.Grid02.getRowsValues(true)"></ext:Parameter>
                                                        </ExtraParams>
                                                    </Click>
                                                </DirectEvents>--%>
                                             </ext:Button>    
                                        </td>
                                    </tr>                                                                                           
                                </table>
                                </Content>
                            </ext:Panel>
                            <ext:Panel ID="GridPanel2" Border="True" Region="Center" runat="server" Cls="grid_area" StyleSpec="margin-top:0; margin-bottom:10px;">
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
                                                            <ext:ModelField Name="USERID"/>
                                                            <ext:ModelField Name="USERNAME"/>
                                                            <ext:ModelField Name="SYSTEMCODE"/>
                                                            <ext:ModelField Name="GROUPID"/>
                                                            <ext:ModelField Name="GROUPNAME"/>
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
                                                <ext:Column ID="USERID02" ItemID="USERID" runat="server" DataIndex="USERID" Width="120" Align="Center" />  <%--Text="사용자 아이디"--%> 
                                                <ext:Column ID="USERNAME02" ItemID="USERNAME" runat="server" DataIndex="USERNAME" Width="60" Align="Center" />  <%--Text="그룹ID"--%> 
                                                <ext:Column ID="SYSTEMCODE02" ItemID="SYSTEMCODE" runat="server" DataIndex="SYSTEMCODE" Width="70" Align="Center" />  <%--Text="System"--%> 
                                                <ext:Column ID="GROUPID02" ItemID="GROUPID" runat="server" DataIndex="GROUPID" Width="50" Align="Center" />  <%--Text="그룹명"--%> 
                                                <ext:Column ID="GROUPNAME02" ItemID="GROUPNAME" runat="server" DataIndex="GROUPNAME" Width="205" Align="Left" />  <%--Text="그룹명"--%> 
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
                            <ext:Panel ID="GridPanel3" Border="True" runat="server"  Height="250" Cls="grid_area">
                                <Items>
                                    <ext:GridPanel ID="Grid03" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                        <Store>
                                            <ext:Store ID="Store6" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="Model4" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="USERID"/>
                                                            <ext:ModelField Name="USERNAME"/>
                                                            <ext:ModelField Name="TITLENM"/>
                                                            <ext:ModelField Name="RESP_WORKNM"/>
                                                            <ext:ModelField Name="TEAMNM"/>
                                                            <ext:ModelField Name="EMP_DIV"/>
                                                            <ext:ModelField Name="RETIRE_DIV_2"/>
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
                                                <ext:RowNumbererColumn ID="RowNumbererColumn2" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                                <ext:Column ID="USERID03" ItemID="USERID" runat="server" DataIndex="USERID" Width="120" Align="Center" />  <%--Text="사용자 아이디"--%> 
                                                <ext:Column ID="USERNAME03" ItemID="USERNAME" runat="server" DataIndex="USERNAME" Width="60" Align="Center" />  <%--Text="사용자명"--%> 
                                                <ext:Column ID="TITLENM" ItemID="TITLENM4" runat="server" DataIndex="TITLENM" Width="60" Align="Center" />  <%--Text="직급"--%> 
                                                <ext:Column ID="RESP_WORKNM" ItemID="RESP_WORK" runat="server" DataIndex="RESP_WORKNM" Width="60" Align="Center" />  <%--Text="직책"--%> 
                                                <ext:Column ID="TEAMNM" ItemID="TEAMNM2" runat="server" DataIndex="TEAMNM" Width="180" Align="Left" />  <%--Text="팀명"--%> 
                                                <ext:Column ID="EMP_DIV" ItemID="EMP_DIV" runat="server" DataIndex="EMP_DIV" Width="60" Align="Center" />  <%--Text="사원구분"--%> 
                                                <ext:Column ID="RETIRE_DIV_2" ItemID="RETIRE_DIV_2" runat="server" DataIndex="RETIRE_DIV_2" Width="60" Align="Center" />  <%--Text="재직구분"--%> 
                                                <ext:Column ID="Column3" ItemID="Column3" runat="server" DataIndex="Column3" MinWidth="1" Flex="1" Align="Center" />  <%--Text=""--%> 
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
    </form>
</body>
</html>
