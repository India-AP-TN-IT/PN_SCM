<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA20002P1.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_QA.SRM_QA20002P1" %>
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
    <form id="SRM_QA20002P1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="txt01_BIZCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_DOCNO2" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_CHKBTN" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_FIRMSTATUSCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_RESET" runat="server" Hidden="true"></ext:TextField>
 
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_QA20002P1" runat="server" Cls="search_area_title_name" /> <%--Text="입고불량 대책서 등록" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server" StyleSpec="width:100%" Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>   
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server">
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
                            <th class="ess">
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
                                            <ext:ModelField Name="DOCNO"/>
                                            <ext:ModelField Name="INSPECT_DIVNM"/>
                                            <ext:ModelField Name="PARTNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="VINCD"/>
                                            <ext:ModelField Name="DEFNM"/>
                                            <ext:ModelField Name="DEF_PLACENM"/>
                                            <ext:ModelField Name="INSPECT_NM"/>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="DEFNO"/>
                                            <ext:ModelField Name="VEND_STATUS"/>
                                            <ext:ModelField Name="RCV_DATE"/>
                                            <ext:ModelField Name="INSPECT_DIV"/>
                                            <ext:ModelField Name="DECD"/>
                                            <ext:ModelField Name="DEF_PLACECD"/>
                                            <ext:ModelField Name="INSPECT_EMPNO"/>
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
                                <ext:RowNumbererColumn ID="NO" runat="server" Width="45" Text="No" Align="Center" />
                                <ext:Column ID="DOCNO" ItemID="OCCURNO" runat="server" DataIndex="DOCNO" Width="130" Align="Center"  />  <%--Text="발행번호"--%> 
                                <ext:Column ID="INSPECT_DIVNM" ItemID="DIVISION" runat="server" DataIndex="INSPECT_DIVNM" Width="60" Align="Center" />  <%--Text="구분"--%> 
                                <ext:Column ID="PARTNO" ItemID="PARTNO5" runat="server" DataIndex="PARTNO" Width="120" Align="Left" />  <%--Text="Part-No"--%> 
                                <ext:Column ID="PARTNM" ItemID="PARTNM2" runat="server" DataIndex="PARTNM" MinWidth="200" Align="Left" Flex="1" />  <%--Text="Part-Name"--%> 
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="60" Align="Center" />  <%--Text="차종"--%> 
                                <ext:Column ID="DEFNM" ItemID="DEF_CNTT" runat="server" DataIndex="DEFNM" MinWidth="200" Align="Left" Flex="1" />  <%--Text="불량내용"--%> 
                                <ext:Column ID="DEF_PLACENM" ItemID="DEF_PLACE" runat="server" DataIndex="DEF_PLACENM" Width="100" Align="Left" />  <%--Text="불량장소"--%> 
                                <ext:Column ID="INSPECT_NM" ItemID="WRITE_EMP" runat="server" DataIndex="INSPECT_NM" Width="80" Align="Center" />  <%--Text="작성자"--%> 
                                <ext:Column ID="VENDCD" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="DEFNO" ItemID="DEFNO" runat="server" DataIndex="DEFNO" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="VEND_STATUS" ItemID="VEND_STATUS" runat="server" DataIndex="VEND_STATUS" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:DateColumn ID="RCV_DATE" ItemID="RCV_DATE" runat="server" DataIndex="RCV_DATE" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="INSPECT_DIV" ItemID="INSPECT_DIV" runat="server" DataIndex="INSPECT_DIV" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="DECD" ItemID="DECD" runat="server" DataIndex="DECD" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="DEF_PLACECD" ItemID="DEF_PLACECD" runat="server" DataIndex="DEF_PLACECD" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="INSPECT_EMPNO" ItemID="INSPECT_EMPNO" runat="server" DataIndex="INSPECT_EMPNO" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="OCCUR_APPLI" ItemID="OCCUR_APPLI" runat="server" DataIndex="OCCUR_APPLI" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="IMPROV_MEAS" ItemID="IMPROV_MEAS" runat="server" DataIndex="IMPROV_MEAS" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="ATT_FILE_NM" ItemID="ATT_FILE_NM" runat="server" DataIndex="ATT_FILE_NM" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="RSLT_CNTT" ItemID="RSLT_CNTT" runat="server" DataIndex="RSLT_CNTT" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="FIRM_STATUS" ItemID="FIRM_STATUS" runat="server" DataIndex="FIRM_STATUS" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="APR_YN" ItemID="APR_YN" runat="server" DataIndex="APR_YN" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="VEND_MGR" ItemID="VEND_MGR" runat="server" DataIndex="VEND_MGR" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="IMG_LEN" ItemID="IMG_LEN" runat="server" DataIndex="IMG_LEN" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
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
                    <table>
                         <colgroup>
                            <col width="150" />
                            <col />
                        </colgroup>                        
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_OCCUR_APPLI" runat="server" /><%--Text="발생원인" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_OCCUR_APPLI" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" Width="620" />
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_IMPROV_MEAS" runat="server" /><%--Text="개선대책" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_IMPROV_MEAS" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" Width="620" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_ATTACHFILE" runat="server" /><%--Text="첨부파일" />--%>
                            </th>
                            <td>
                               <ext:FieldContainer ID="FieldContainer3" runat="server" Width="549" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:FileUploadField ID="fud02_FILEID1" runat="server" Flex="1" Cls="inputText" ButtonText="Upload" Width="200">
                                        </ext:FileUploadField>
                                        <ext:ImageButton ID="btn01_FILEID1_DEL" runat="server" ToggleGroup="Group1" ImageUrl="../../images/btn/btn_upload_delete.gif"
                                            OverImageUrl="../../images/btn/btn_upload_delete.gif" DisabledImageUrl="../../images/btn/btn_upload_delete.gif"
                                            PressedImageUrl="../../images/btn/btn_upload_delete.gif">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" />
                                            </DirectEvents>
                                        </ext:ImageButton>
                                        <ext:HyperlinkButton ID="lkb02_FILEID1" runat="server" Icon="Attach" Width="349" StyleSpec="color:#000;float:left;overflow:hidden">
                                            <DirectEvents><Click OnEvent="etc_Button_Click" /></DirectEvents>
                                        </ext:HyperlinkButton>
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_PROC_RSLT" runat="server" /><%--Text="처리결과" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_RSLT_CNTT" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" Width="620"  />
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
