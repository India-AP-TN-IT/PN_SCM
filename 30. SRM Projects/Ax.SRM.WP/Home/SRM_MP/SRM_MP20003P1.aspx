<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP20003P1.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MP.SRM_MP20003P1" %>
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

    <title>일괄등록</title>

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

        var fn_sendParentWindow = function (popupID, objectID, typeNM, typeCD, record) {
            parent.fn_SetValues(popupID, objectID, typeNM, typeCD, Ext.decode(record));
        }

        // 체크박스 하나만 선택 시
        var chkMethod = function (column, rowIdx, checked, eOpts) {

            var grid = App.Grid01;
            var count = App.Grid01.getStore().getTotalCount();

            var grid = column.grid;

            var flag = true;
            for (i = 0; i < grid.store.count(); i++) {
                if (i != rowIdx) {
                    flag = false;
                    grid.getStore().getAt(i).set("CHR_CHK", flag);
                }
            }
        }

    </script>
</head>
<body>
    <form id="SRM_PopCustItemcdGrid" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <%-- 숨겨진 데이터  --%>
    <ext:TextField runat="server" ID="txt01_ID" Hidden="true" />
    <ext:TextField runat="server" ID="txt01_VENDCD" Hidden="true" />

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MP20003P1" runat="server" Cls="search_area_title_name" /><%--Text="" />--%>
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
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_MGRT_NAME02" runat="server"  /> <%--Text="담당자"--%>
                            </th>
                            <td>
                                <ext:Checkbox ID="chk01_EMPNO" runat="server" Width="18" Cls="inputText" />
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
                                            <ext:ModelField Name="CHR_NO"/>
                                            <ext:ModelField Name="CHR_CHK" />
                                            <ext:ModelField Name="CHR_NM"/>
                                            <ext:ModelField Name="CHR_DEPT"/>
                                            <ext:ModelField Name="CHR_DUTY"/>
                                            <ext:ModelField Name="CHR_TEL"/>
                                            <ext:ModelField Name="CHR_FAX"/>
                                            <ext:ModelField Name="CHR_MOBILE"/>
                                            <ext:ModelField Name="CHR_EMAIL"/>
                                            <ext:ModelField Name="REMARK"/>
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
                                <ext:RowNumbererColumn ID="RowNumbererColumn1"            ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center"/>
                                <ext:Column ID="CHR_NO" ItemID="CHR_NO" runat="server" DataIndex="CHR_NO" Width="60" Align="Center" Hidden="true"/>  <%--Text=""--%> 
                                <ext:CheckColumn runat="server" ID ="CHK"  DataIndex="CHR_CHK" Width="65"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >  
                                <Listeners>
                                    <CheckChange Fn="chkMethod" />
                                </Listeners>                                                                                                                     
                                </ext:CheckColumn> <%--Text="선택" --%>
                                <ext:Column ID="CHR_NM" ItemID="MGRT_NAME02" runat="server" DataIndex="CHR_NM" Width="80" Align="Center" />  <%--Text="담당자명"--%> 
                                <ext:Column ID="CHR_DEPT" ItemID="DEPART" runat="server" DataIndex="CHR_DEPT" Width="80" Align="Center" />  <%--Text="부서"--%> 
                                <ext:Column ID="CHR_DUTY" ItemID="CHR_DUTY" runat="server" DataIndex="CHR_DUTY" Width="80" Align="Center" />  <%--Text="직책"--%> 
                                <ext:Column ID="CHR_TEL" ItemID="CHR_TEL" runat="server" DataIndex="CHR_TEL" Width="100" Align="Left" />  <%--Text="연락처"--%> 
                                <ext:Column ID="CHR_FAX" ItemID="CHR_FAX" runat="server" DataIndex="CHR_FAX" Width="100" Align="Left" Hidden="true"/>  <%--Text="팩스"--%> 
                                <ext:Column ID="CHR_MOBILE" ItemID="CHR_MOBILE" runat="server" DataIndex="CHR_MOBILE" Width="200" Align="Left" Hidden="true"/>  <%--Text="휴대폰번호"--%> 
                                <ext:Column ID="CHR_EMAIL" ItemID="CHR_EMAIL" runat="server" DataIndex="CHR_EMAIL" Width="150" Align="Left" />  <%--Text="이메일"--%> 
                                <ext:Column ID="REMARK" ItemID="REMARK" runat="server" DataIndex="REMARK" MinWidth="100" Align="Left" Flex="1" />  <%--Text="비고"--%> 
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
                                          
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>

            <ext:Panel ID="Panel1" Region="South" Cls="search_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_DELI_DATE02" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <ext:Checkbox ID="chk01_DELI_DATE" runat="server" Width="5" Cls="inputText" />
                            </td>
                            <td>
                                <ext:DateField ID="df01_DELI_DATE" Width="220" Cls="inputDate" runat="server" Type="Date"  />
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
