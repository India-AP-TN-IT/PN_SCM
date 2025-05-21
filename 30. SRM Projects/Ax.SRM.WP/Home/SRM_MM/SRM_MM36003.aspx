<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM36003.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM36003" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" />
<meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
<meta content="/images/favicon/SCM.ico" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
    <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    <meta content="/images/favicon/SCM.ico" itemprop="image"/>
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

        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            //var grid = selectionModel.view.ownerCt;
            //grid.editingPlugin.startEdit(rowIndex, colIndex);
        }

    </script>
</head>
<body>
    <form id="SRM_MM36003" runat="server">
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
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MM36003" runat="server" Cls="search_area_title_name" /><%--Text="사급 PART NO 정보" />--%>
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
                                <ext:Label ID="lbl01_CUST" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="80"/>
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
                            <th>         
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" /><%--Text="구매조직" /> --%>                      
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
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
                            <th>         
                                <ext:Label ID="lbl01_VIN" runat="server" />                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="80" />
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                 
                            </th>
                            <td colspan="3">
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" />                             
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
                                            <ext:ModelField Name="VENDORCD" />
                                            <ext:ModelField Name="VENDORNM" />
                                            <ext:ModelField Name="PURC_ORGNM" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="UNITNM" />
                                            <ext:ModelField Name="UNIT_PACK_QTY" />
                                            <ext:ModelField Name="BEG_DATE" />
                                            <ext:ModelField Name="END_DATE" />
                                            <ext:ModelField Name="VTWEGNM" />
                                            <ext:ModelField Name="SCM_REQ_YN" />
                                            <ext:ModelField Name="MAT_GRPNM" />
                                            <ext:ModelField Name="MAT_STATUSNM" />
                                            <ext:ModelField Name="USE_YN" />
                                            <ext:ModelField Name="PURC_ORG" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="VTWEG" />
                                            <ext:ModelField Name="MAT_GRP" />
                                            <ext:ModelField Name="MAT_STATUS" />
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
                                <ext:RowNumbererColumn ID="RowNumbererColumn1" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:Column ID="VENDORCD" ItemID="VENDORCD" runat="server" DataIndex="VENDORCD" Width="70" Align="Center" /><%--Text="거래처코드"--%>
                                <ext:Column ID="VENDORNM" ItemID="VENDORNM" runat="server" DataIndex="VENDORNM" Width="100" Align="Left" /><%--Text="거래처명"--%>
                                <ext:Column ID="PURC_ORGNM" ItemID="PURC_ORG" runat="server" DataIndex="PURC_ORGNM" Width="65" Align="Center" /><%--Text="구매조직"--%>
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="50" Align="Center" /><%--Text="차종"--%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="PARTNO"--%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="180" Align="Left" Flex="1" /><%--Text="PART NAME"--%>
                                <ext:Column ID="UNITNM" ItemID="UNIT" runat="server" DataIndex="UNITNM" Width="50" Align="Center" /><%--Text="단위"--%>
                                <ext:NumberColumn ID="UNIT_PACK_QTY" ItemID="UNIT_PACK_QTY_SIM" runat="server" DataIndex="UNIT_PACK_QTY" Width="65" Align="Right" Format="#,##0.###" Sortable="true" /><%--Text="용기적입량"--%>
                                <ext:Column ID="BEG_DATE" ItemID="BEG_DATE" runat="server" DataIndex="BEG_DATE" Width="80" Align="Center" /><%--Text="적용시작일"  --%>
                                <ext:Column ID="END_DATE" ItemID="END_DATE" runat="server" DataIndex="END_DATE" Width="80" Align="Center" /><%--Text="적용종료일"  --%>
                                <ext:Column ID="VTWEGNM" ItemID="VTWEG" runat="server" DataIndex="VTWEGNM" Width="80" Align="Center" /><%--Text="유통경로"  --%>
                                <%--<ext:Column ID="SCM_REQ_YN" ItemID="SCM_REQ_YN" runat="server" DataIndex="SCM_REQ_YN" Width="80" Align="Center" />--%><%--Text="사급신청대상"  --%>
                                <ext:CheckColumn ID ="SCM_REQ_YN" ItemID="SCM_REQ_YN" runat="server" DataIndex="SCM_REQ_YN" Width="80" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Sortable="false" Selectable="true" Hidden="true"><%--Text="사급신청대상"--%>
                                </ext:CheckColumn>                                    
                                <ext:Column ID="MAT_GRPNM" ItemID="MAT_GRP" runat="server" DataIndex="MAT_GRPNM" Width="80" Align="Left" /><%--Text="자재그룹"  --%>
                                <ext:Column ID="MAT_STATUSNM" ItemID="MAT_STATUS" runat="server" DataIndex="MAT_STATUSNM" Width="80" Align="Left" /><%--Text="자재상태"  --%>
                                <ext:Column ID="USE_YN" ItemID="USE_YN" runat="server" DataIndex="USE_YN" Width="80" Align="Center" /><%--Text="사용여부"  --%>
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
                        <%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">
                                <Listeners>
                                    <Select Fn="CellFocus"></Select>
                                </Listeners>
                            </ext:CellSelectionModel >
                        </SelectionModel>                    
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>

                </Items>
            </ext:Panel>                 
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
