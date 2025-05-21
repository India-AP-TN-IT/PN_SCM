<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM35003.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM35003" %>
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
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.

        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            //그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        };

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }
        //성적서 입력 여부를 y로 업데이트한다. 
        function fn_GridSetInputY() {
            var rowIdx = App.CodeRow.getValue();
            var grid = App.Grid01;
            grid.getStore().getAt(rowIdx).set("ISOK", "Y");

            //박의곤            
            var chasu = grid.getStore().getAt(rowIdx).data["JIS_CNT"];  //현재행의 납품 차수
            App.direct.SendPopupToSendMM1070(chasu);
        }

        //성적서 입력 여부를 y로 업데이트한다. (해당 차수 모두) - 성적서 일괄 업데이트한 경우에 호출함.
        function fn_GridSetInputYAll() {

            var rowIdx = App.CodeRow.getValue();                        //현재행 index
            var grid = App.Grid01;
            var chasu = grid.getStore().getAt(rowIdx).data["JIS_CNT"];  //현재행의 납품 차수
            var rowcnt = grid.getStore().getTotalCount();               //전체행건수
            var vinnm = grid.getStore().getAt(rowIdx).data["VINNM"];  //현재행의 차종

            for (var i = 0; i < rowcnt; i++) {
                if (chasu == grid.getStore().getAt(i).data["JIS_CNT"] && vinnm == grid.getStore().getAt(i).data["VINNM"])	//납품차수 및 차종이 동일한 데이터 모두 Y로 변경
                {
                    grid.getStore().getAt(i).set("ISOK", "Y");
                }
            }
            //박의곤
            App.direct.SendPopupToSendMM1070(chasu);
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

            var inspectYN = grid.getStore().getAt(rowIndex).data["INSPECT_YN"];
            var partno = grid.getStore().getAt(rowIndex).data["PARTNO"];
            var delicnt = grid.getStore().getAt(rowIndex).data["JIS_CNT"];
            

            if (inspectYN != "●") { //유검사가 아닌 경우
                App.direct.MsgCodeAlert("COM-00907");   //성적서를 등록할 수 없는 항목입니다.
                return;
            }

            App.CodeRow.setValue(rowIndex);

            var qty = grid.getStore().getAt(rowIndex).data["MAT_INPUT_QTY"];
            var barcode = grid.getStore().getAt(rowIndex).data["BARCODE"];
            var delidate = grid.getStore().getAt(rowIndex).data["INPUT_DATE"];
            
            // 차종추가
            var vinnm = grid.getStore().getAt(rowIndex).data["VINNM"];

            App.direct.Cell_DoubleClick(qty, partno, barcode, delidate, delicnt, vinnm);
        }

    </script>
</head>
<body>
    <form id="SRM_MM35003" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="UserHelpURL" runat="server" Hidden="true" Text="../SRM_QA/SRM_QA23001P1.aspx"></ext:TextField> 
    <ext:TextField ID="PopupWidth" runat="server" Hidden="true" Text="900"></ext:TextField> 
    <ext:TextField ID="PopupHeight" runat="server" Hidden="true" Text="500"></ext:TextField> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MM35003" runat="server" Cls="search_area_title_name" /><%--Text="서열지 출력" />--%>
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
                                <ext:Label ID="lbl01_VEND" runat="server" /><%-- Text="업체" />--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>   
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" /><%--Text="사업장" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
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
                            <th class="ess">
                                <ext:Label ID="lbl01_DELIVERYDATE" runat="server" /><%--Text="일자" />--%>
                            </th>
                            <td>                               
                                <ext:DateField ID="df01_DELIVERYDATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />                                    
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">
                               <ext:Label ID="lbl01_LINECD" runat="server" /><%--Text="라인코드" />--%>
                            </th>
                            <td> 
                                <%--<epc:EPCodeBox ID="cdx01_LINECD" runat="server" HelperID="HELP_LINE" PopupMode="Search" PopupType="UserWindow" 
                                                OnBeforeDirectButtonClick="CodeBox_BeforeDirectButtonClick"
                                                OnCustomRemoteValidation="CodeBox_CustomRemoteValidation"
                                                UserHelpURL="../SCMHelper/SCM_PopLine.aspx"
                                                 />--%>
                                <epc:EPCodeBox ID="cdx01_LINECD" runat="server" HelperID="HELP_LINE_SEQ" PopupMode="Search" PopupType="HelpWindow"
                                    OnBeforeDirectButtonClick="CodeBox_LINECD_BeforeDirectButtonClick" WidthTYPECD="60"/>
                            </td>
                            <th class="ess">         
                                <ext:Label ID="lbl01_CONTCD" runat="server" /><%--Text="물류용기코드" />   --%>                    
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CONTCD" runat="server" HelperID="HELP_CONTCD_SEQ" PopupMode="Search" PopupType="HelpWindow"
                                 OnBeforeDirectButtonClick="cdx01_CONTCD_BeforeDirectButtonClick" WidthTYPECD="60"/>
                            </td>
                            <th class="ess">         
                                <ext:Label ID="lbl01_INSTALL_POS" runat="server" /><%--Text="위치" />--%>                       
                            </th>
                            <td>
                                <%--<epc:EPCodeBox ID="cdx01_INSTALL_POS" OnDirectEventChange="Button_Click" runat="server" ClassID="A7" PopupMode="Search" PopupType="CodeWindow"/>--%>
                                <ext:SelectBox ID="SelectBox01_INSTALL_POS" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPENM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="TYPENM" />
                                                        <ext:ModelField Name="TYPECD" />
                                                        <ext:ModelField Name="SORT_SEQ" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>
                        </tr> 
                        <tr>
                            
                             <th class="ess">         
                                <ext:Label ID="lbl01_DELI_CNT" runat="server" /><%--Text="납품차수" />  --%>                     
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="160" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:TextField ID="txt01_CHASU1" Width="50" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/" MaxLengthText="1" MaxLength="1"/>
                                        <ext:DisplayField ID="DisplayField2" Width="30"  runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:TextField ID="txt01_CHASU2" Width="50" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/" MaxLengthText="1" MaxLength="1"/>                                     
                                    </Items>
                                </ext:FieldContainer>     
                            </td>
                            <th class="ess">
                               <ext:Label ID="lbl01_SEQ_TYPE" runat="server" /><%--Text="서열지유형" />--%>
                            </th>
                            <td colspan="3">
                              <ext:SelectBox ID="SelectBox01_SEQ_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="NAME" ValueField="CODE" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
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
                                            <ext:ModelField Name="INPUT_DATE" />
                                            <ext:ModelField Name="LINENM" />
                                            <ext:ModelField Name="JIS_CNT" />
                                            <ext:ModelField Name="JOB_TYPE" />
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="MAT_INPUT_QTY" />
                                            <ext:ModelField Name="INSPECT_YN" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="CHECK_CERT" />
                                            <ext:ModelField Name="INPUT_COUNT" />
                                            <ext:ModelField Name="CHECK_COUNT" />
                                            <ext:ModelField Name="BARCODE" />
                                            <ext:ModelField Name="ISOK" />                                            
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
                                <ext:RowNumbererColumn ID="NO"       ItemID="NO"         runat="server" Text="No"        Width="40"                Align="Center" />
                                <ext:Column ID="LINENM"              ItemID="DEL_STAGE"  runat="server" Text="납품장소"  DataIndex="LINENM"        Width="150" Align="Center"/>
                                <ext:Column ID="JIS_CNT"             ItemID="DELI_CNT"   runat="server" Text="납품차수"  DataIndex="JIS_CNT"       Width="70" Align="Center"/>
                                <ext:Column ID="JOB_TYPE"            ItemID="JOB_TYPE"   runat="server" Text="업무유형"  DataIndex="JOB_TYPE"      Width="70" Align="Center" />
                                <ext:Column ID="ALCCD"               ItemID="ALCCD_REP"  runat="server" Text="대표ALC"   DataIndex="ALCCD"         Width="70" Align="Center" />
                                <ext:Column ID="PARTNO"              ItemID="PARTNO"     runat="server" Text="PART NO"   DataIndex="PARTNO"        MinWidth="120" Align="Left" Flex="1" />
                                <ext:Column ID="PARTNM"              ItemID="PARTNM"     runat="server" Text="PART NAME" DataIndex="PARTNM"        MinWidth="150" Align="Left" Flex="1"/>                                
                                <ext:NumberColumn ID="MAT_INPUT_QTY" ItemID="DELI_QTY"   runat="server" Text="납품수량"  DataIndex="MAT_INPUT_QTY" Width="80" Align="Right" Format="#,##0.###"/>
                                <ext:Column ID="INSPECT_YN"          ItemID="INSPECT_YN" runat="server" Text="유/무검사" DataIndex="INSPECT_YN"    Width="70" Align="Center"/>
                                <ext:Column ID="VINNM"               ItemID="VIN"        runat="server" Text="차종"      DataIndex="VINNM"         Width="70" Align="Center"/>
                                <ext:Column ID="CHECK_CERT"          ItemID="CHECK_CERT" runat="server" Text="관리대상"  DataIndex="CHECK_CERT"    Width="70" Align="Center"/>
                                <ext:Column ID="ISOK"                ItemID="ISOK"       runat="server" Text="입력여부"  DataIndex="ISOK"          Width="70" Align="Center"/>
                                <%--<ext:Column ID="BARCODE"             runat="server" Text="BARCODE"  DataIndex="BARCODE"          Width="150" Align="Center"/>--%>
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
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
