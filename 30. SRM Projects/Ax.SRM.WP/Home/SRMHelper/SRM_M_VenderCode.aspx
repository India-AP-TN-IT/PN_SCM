<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_M_VenderCode.aspx.cs" Inherits="Ax.SRM.WP.Home.SRMHelper.SRM_M_VenderCode" %>
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

    <title>Vender Search Popup</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--<link rel="Stylesheet" type="text/css" href="../Mobile/css/mobile.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />--%>
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <style type="text/css">
	    .x-grid-rowbody {font: normal 13px/15px helvetica,arial,verdana,sans-serif; padding:10px 0 !important; border-right:1px solid #ededed !important;}
	    .x-grid-rowbody td    { padding:2px;}
	    .x-grid-rowbody .x-panel-default-outer-border-trbl { padding:10px !important;}	    
	    
	    
	    .search_area_title_btn .x-panel-body-default {
            /* background:#efefef !important;*/
            padding-top:8px;
            }
            
        .x-grid-row .x-grid-cell-selected { background-color:#FFFFFF !important; color:inherit !important;  /* cell selected 색상 */ }
        
        /*.x-grid-cell-last { border-right:1px solid #000 !important;}*/
    </style>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
            App.txt01_VENDCD.focus();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
            this.Closable = false;
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        function gridStore() {
            return App.PagingToolbar1.getStore();
        }

        var fn_sendParentWindow = function (popupID, objectID, typeNM, typeCD, record) {
            parent.fn_SetValues(popupID, objectID, typeNM, typeCD, Ext.decode(record));
        }

//        var linkRenderer = function (value, meta, record, index) {
////            grid = App.PagingToolbar1.getStore();
//            //            return Ext.String.format("<a style='color:blue;text-decoration:underline;' href='#' onclick=\"App.direct.GridPanel_RowClick(Ext.encode(App.Grid01().getRowsValues({selectedOnly:true})));\">{0}</a>", value);

//        };

        var linkRenderer = function (value, meta, record, index) {
            return Ext.String.format("<a style='color:blue;text-decoration:underline;' href='#' onclick=\"onSelect({0});\">{1}</a>", record.index, value);
        };

        // 그리드의 셀을 클릭시 사용하는 메서드
        var onSelect = function (index) {
            var record = gridStore().getAllRange()[index];

            if (record) {
                App.direct.GridPanel_RowClick(record.data['VENDCD'], record.data['VENDNM']);
            }
        }

    </script>
</head>
<body>
    <form id="SRM_M_VenderCode" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="0" Cls="pdb10">
        <Listeners>
            <Resize Fn="UI_Resize" />
        </Listeners>
        <Items>
            <ext:Panel ID="ButtonPanel" runat="server" Height="40" Region="North" Cls="search_area_title_btn lrmargin10">
                <Items>
                    <%-- 상단 이미지버튼 --%>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table lrmargin10" runat="server">
                <Content>
                    <table style="height:0px">
                        <colgroup>
                            <col style="width:80px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <ext:TextField ID="txt01_VENDCD" runat="server" Width="80" Hidden="true">
                                <Listeners>
                                    <Change Handler="App.txt01_VENDNM.setValue('');" />
                                </Listeners>
                            </ext:TextField>
 
                            <th>
                                <ext:Label ID="lbl01_VENDNM" runat="server" Width="80" /> <%--Text="Vender Name"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_VENDNM" runat="server" Width="200" />
                            </td>
                        </tr>
                    </table>
                    <%-- 숨겨 사용하기 ^^;;; --%>
                    <ext:TextField ID="txt01_ID" runat="server" Hidden="true" />
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel"  Region="Center" Border="True" runat="server" Cls="grid_area lrmargin10">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server"  ColumnLines="true" StripeRows="true" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="5">
                                <Model>
                                    <ext:Model runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="ADDRESS" />
                                            <ext:ModelField Name="TRANS_END_DATE" />
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
                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="45" Text="No" Align="Center" />--%>
                                <ext:Column ID="VENDNM" ItemID="VENDNM" runat="server"  DataIndex="VENDNM" Width="145" Align="Left" ><%--Text="VendName"--%>
                                    <Renderer Fn="linkRenderer"/>
                                </ext:Column>
                                <ext:Column ID="TRANS_END_DATE" ItemID="TRANS_END_DATE" runat="server" DataIndex="TRANS_END_DATE" Width="70" Align="Center" />
                                <ext:Column ID="VENDCD" ItemID="VENDCD" runat="server" DataIndex="VENDCD" Width="55" Align="Left" /><%--Text="VendCd"--%> 
                                <%--<ext:Column ID="ADDRESS" ItemID="ADDRESS" runat="server"  DataIndex="ADDRESS" fLEX="1" Align="Left" />--%><%--Text="Address"--%>
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
                            <%--<ext:RowSelectionModel ID="RowSelectionModel" Mode="Single" runat="server" />--%>
                            <ext:CellSelectionModel></ext:CellSelectionModel>
                        </SelectionModel>
                        <%--<DirectEvents>
                            <CellClick OnEvent="GridPanel_RowDblClick">
                                <ExtraParams>
                                    <ext:Parameter Name="Values" Value="this.getRowsValues({selectedOnly:true})" Encode="true" Mode="Raw" />
                                </ExtraParams>
                            </CellClick>
                        </DirectEvents>--%>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <%--<ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..." />--%>
                            <ext:PagingToolbar ID="PagingToolbar1" HideRefresh="true" runat="server" />
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    <ext:KeyMap ID="KeyMap1" runat="server" Target="App.txt01_VENDCD">
        <Binding>
            <ext:KeyBinding DefaultEventAction="StopEvent" Handler="App.ButtonSearch.fireEvent('click');">
                <Keys>
                    <ext:Key Code="ENTER"/>
                </Keys>
            </ext:KeyBinding>
        </Binding>
    </ext:KeyMap>
    <ext:KeyMap ID="KeyMap2" runat="server" Target="App.txt01_VENDNM">
        <Binding>
            <ext:KeyBinding DefaultEventAction="StopEvent" Handler="App.ButtonSearch.fireEvent('click');">
                <Keys>
                    <ext:Key Code="ENTER" />
                </Keys>
            </ext:KeyBinding>
        </Binding>
    </ext:KeyMap>
    </form>
</body>
</html>
