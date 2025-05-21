<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA20003P1.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_QA.SRM_QA20003P1" %>
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

    <title>입고불량 대책서 검토결과(업체)</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
            App.txt01_LINECD.focus();
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

    </script>
</head>
<body>
    <form id="SRM_QA20003P1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="txt01_BIZCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_DOCNO2" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_CHKBTN" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_FIRMSTATUSCD" runat="server" Hidden="true"></ext:TextField>
 
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="60">
                <Content>
                    <div class="popup_area">
                        <h1 style="padding-top:11px;">
                            <ext:Label ID="lbl01_SRM_QA20003P1" runat="server" Text="품명조회" />
                            <ext:ImageButton ID="btn01_CLOSE" runat="server" ImageUrl="../../images/main/close.gif" Cls="pop_close" OnDirectClick="Button_Click" />
                        </h1>
                    </div>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ButtonPanel" runat="server" Height="30" Region="North" Cls="search_area_title_btn">
                <Items>
                    <%-- 상단 이미지버튼 --%>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                           <th >
                                <ext:Label ID="lbl01_BIZCD" runat="server" Text="Business Code" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_BIZCD" ItemID="SAUP" runat="server" Cls="inputText"  Mode="Local" ForceSelection="true"
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
                                <ext:Label ID="lbl01_VEND" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                        </tr> 
                        <tr>
                            <th>                                
                                <ext:Label ID="lbl01_MEASURE_DOCNO" runat="server" /> <%--Text="대책서번호" --%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_DOCNO" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_WRITE_EMP" runat="server" /> <%--Text="작성자" --%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_USER_ID" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" />
                            </td>
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>

            <ext:Panel ID="GridPanel"  Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server"  ColumnLines="true" StripeRows="true" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="DEFNO"/>
                                            <ext:ModelField Name="DOCNO"/>
                                            <ext:ModelField Name="VEND_STATUS"/>
                                            <ext:ModelField Name="RCV_DATE"/>
                                            <ext:ModelField Name="INSPECT_DIV"/>
                                            <ext:ModelField Name="INSPECT_DIVNM"/>
                                            <ext:ModelField Name="PARTNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="VINCD"/>
                                            <ext:ModelField Name="DEFCD"/>
                                            <ext:ModelField Name="DEFNM"/>
                                            <ext:ModelField Name="DEF_PLACECD"/>
                                            <ext:ModelField Name="DEF_PLACENM"/>
                                            <ext:ModelField Name="INSPECT_EMPNO"/>
                                            <ext:ModelField Name="INSPECT_NM"/>
                                            <ext:ModelField Name="OCCUR_APPLI"/>
                                            <ext:ModelField Name="IMPROV_MEAS"/>
                                            <ext:ModelField Name="ATT_FILE_NM"/>
                                            <ext:ModelField Name="RSLT_CNTT"/>
                                            <ext:ModelField Name="FIRM_STATUS"/>
                                            <ext:ModelField Name="APR_YN"/>
                                            <ext:ModelField Name="VEND_MGR"/>
                                            <ext:ModelField Name="IMG_LEN"/>
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
                                <ext:Column ID="VENDCD" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="DEFNO" ItemID="DEFNO" runat="server" DataIndex="DEFNO" Width="0" Align="Left" />  <%--Text="발행번호"--%> 
                                <ext:Column ID="DOCNO" ItemID="DOCNO" runat="server" DataIndex="DOCNO" Width="130" Align="Center" />  <%--Text=""--%> 
                                <ext:Column ID="VEND_STATUS" ItemID="VEND_STATUS" runat="server" DataIndex="VEND_STATUS" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:DateColumn ID="RCV_DATE" ItemID="RCV_DATE" runat="server" DataIndex="RCV_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="INSPECT_DIV" ItemID="INSPECT_DIV" runat="server" DataIndex="INSPECT_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="INSPECT_DIVNM" ItemID="INSPECT_DIVNM" runat="server" DataIndex="INSPECT_DIVNM" Width="80" Align="Center" />  <%--Text="구분"--%> 
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" />  <%--Text="Part-No"--%> 
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="200" Align="Left" />  <%--Text="Part-Name"--%> 
                                <ext:Column ID="VINCD" ItemID="VINCD" runat="server" DataIndex="VINCD" Width="60" Align="Center" />  <%--Text="차종"--%> 
                                <ext:Column ID="DEFCD" ItemID="DEFCD" runat="server" DataIndex="DEFCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="DEFNM" ItemID="DEFNM" runat="server" DataIndex="DEFNM" Width="120" Align="Left" />  <%--Text="불량내용"--%> 
                                <ext:Column ID="DEF_PLACECD" ItemID="DEF_PLACECD" runat="server" DataIndex="DEF_PLACECD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="DEF_PLACENM" ItemID="DEF_PLACENM" runat="server" DataIndex="DEF_PLACENM" Width="100" Align="Left" />  <%--Text="불량장소"--%> 
                                <ext:Column ID="INSPECT_EMPNO" ItemID="INSPECT_EMPNO" runat="server" DataIndex="INSPECT_EMPNO" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="INSPECT_NM" ItemID="INSPECT_NM" runat="server" DataIndex="INSPECT_NM" Width="80" Align="Center" />  <%--Text="작성자"--%> 
                                <ext:Column ID="OCCUR_APPLI" ItemID="OCCUR_APPLI" runat="server" DataIndex="OCCUR_APPLI" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="IMPROV_MEAS" ItemID="IMPROV_MEAS" runat="server" DataIndex="IMPROV_MEAS" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="ATT_FILE_NM" ItemID="ATT_FILE_NM" runat="server" DataIndex="ATT_FILE_NM" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RSLT_CNTT" ItemID="RSLT_CNTT" runat="server" DataIndex="RSLT_CNTT" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="FIRM_STATUS" ItemID="FIRM_STATUS" runat="server" DataIndex="FIRM_STATUS" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="APR_YN" ItemID="APR_YN" runat="server" DataIndex="APR_YN" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="VEND_MGR" ItemID="VEND_MGR" runat="server" DataIndex="VEND_MGR" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="IMG_LEN" ItemID="IMG_LEN" runat="server" DataIndex="IMG_LEN" Width="80" Align="Left" />  <%--Text="IMG"--%> 
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel" Mode="Single" runat="server" />
                        </SelectionModel>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..." />
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>

            <ext:Panel ID="Panel1" runat="server" Region="South" Height="15px">
            </ext:Panel>
                    
            <ext:Panel ID="ContentPanel1" runat="server" Cls="search_area_table" Region="South" >
                <Content>
                    <table style="height:0px; border-top:1px solid #0071bd;" >
                        <colgroup>
                            <col style="width: 150px;" />                           
                            <col />
                        </colgroup>
                        <tr>
                            <th style="width:120px;">
                                <ext:Label ID="lbl02_OCCUR_APPLI" runat="server" /><%--Text="발생원인" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_OCCUR_APPLI" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_IMPROV_MEAS" runat="server" /><%--Text="개선대책" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_IMPROV_MEAS" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_ATTACHFILE" runat="server" /><%--Text="첨부파일" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_ATT_FILE_NM" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_ATTACH_FILE_SEE" runat="server" /><%--Text="첨부파일보기" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="TextField4" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_RSLT_CNTT" runat="server" /><%--Text="처리결과" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_RSLT_CNTT" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" />
                            </td>
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>

        </Items>
    </ext:Viewport>
    <ext:KeyMap ID="KeyMap1" runat="server" Target="App.txt01_INSPECT_CLASSCD">
        <Binding>
            <ext:KeyBinding DefaultEventAction="StopEvent" Handler="App.ButtonSearch.fireEvent('click');">
                <Keys>
                    <ext:Key Code="ENTER"/>
                </Keys>
            </ext:KeyBinding>
        </Binding>
    </ext:KeyMap>
    <ext:KeyMap ID="KeyMap2" runat="server" Target="App.txt01_INSPECT_CLASSNM">
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
