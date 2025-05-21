<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA22001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_QA.SRM_QA22001" %>
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
            //            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        };

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }

//        //성적서 입력 여부를 y로 업데이트한다. 
//        function fn_GridSetInputY() {
//            var rowIdx = App.CodeRow.getValue();
//            var grid = App.Grid01;
//            grid.getStore().getAt(rowIdx).set("ISOK", "Y");
//        }

//        //성적서 입력 여부를 y로 업데이트한다. (해당 차수 모두) - 성적서 일괄 업데이트한 경우에 호출함.
//        function fn_GridSetInputYAll() {

//            var rowIdx = App.CodeRow.getValue();                        //현재행 index
//            var grid = App.Grid01;
//            var chasu = grid.getStore().getAt(rowIdx).data["JIS_CNT"];  //현재행의 납품 차수
//            var rowcnt = grid.getStore().getTotalCount();               //전체행건수

//            for (var i = 0; i < rowcnt; i++) {
//                if (chasu == grid.getStore().getAt(i).data["JIS_CNT"])	//납품차수 동일한 데이터 모두 Y로 변경
//                {
//                    grid.getStore().getAt(i).set("ISOK", "Y");
//                }

//            }
//        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

           
            App.CodeRow.setValue(rowIndex);

            var serial = grid.getStore().getAt(rowIndex).data["SERIAL"];

            App.direct.Cell_DoubleClick(serial);
        }

    </script>
</head>
<body>
    <form id="SRM_QA22001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="UserHelpURL" runat="server" Hidden="true" Text="SRM_QA22001P2.aspx"></ext:TextField> 
    <ext:TextField ID="PopupWidth" runat="server" Hidden="true" Text="1000"></ext:TextField> 
    <ext:TextField ID="PopupHeight" runat="server" Hidden="true" Text="640"></ext:TextField> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_QA22001" runat="server" Cls="search_area_title_name" /><%--Text="X-bar R관리 조회/등록" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
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
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_SAUP" runat="server" /><%--Text="사업장"/>--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
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
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" /><%--Text="업체" />--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>   
                            
                            <th class="ess">
                                <ext:Label ID="lbl01_WRITE_MONTH" runat="server" /><%--Text="작성월" />--%>
                            </th>
                            <td>                               
                                <ext:DateField ID="df01_WRITE_MONTH" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"  Format="yyyy-MM" />                                    
                            </td>
                        </tr> 
                        <tr>
                            <th>
                               <ext:Label ID="lbl01_VIN" runat="server" /><%--Text="차종" />--%>
                            </th>
                            <td> 
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_ITEM" runat="server" /><%--Text="품목" /> --%>                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_MAT_TYPE" OnDirectEventChange="Button_Click" runat="server" ClassID="A4" PopupMode="Search" PopupType="CodeWindow"/>
                               
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PARTNONM" runat="server" /><%--Text="품명" />     --%>                  
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_INPSECT_CLASSCD" runat="server" HelperID="USER_INPSECT_CLASSCD" PopupMode="Search" PopupType="UserWindow"
                                                OnBeforeDirectButtonClick="CodeBox_BeforeDirectButtonClick"
                                                OnCustomRemoteValidation="CodeBox_CustomRemoteValidation"
                                                UserHelpURL="SRM_QA22001P1.aspx"/>
                            </td>
                        </tr> 
                        <tr>                            
                            <th>
                               <ext:Label ID="lbl01_USEYN" runat="server" /><%--Text="사용여부" />--%>
                            </th>
                            <td colspan="5">
                              <ext:SelectBox ID="SelectBox01_USEYN" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="NAME" ValueField="CODE" TriggerAction="All" Width="115">
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
                                            <ext:ModelField Name="SERIAL" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="ITEMCD" />
                                            <ext:ModelField Name="ITEMNM" />
                                            <ext:ModelField Name="MEAS_ITEMCD" />
                                            <ext:ModelField Name="MEAS_ITEMNM" />
                                            <ext:ModelField Name="STD_PHOTO" />       
                                            <ext:ModelField Name="MGRT_ITEMNM" />
                                            <ext:ModelField Name="MEAS_INST" />
                                            <ext:ModelField Name="STANDARD" />
                                            <ext:ModelField Name="STD_MIN_MEAS" />
                                            <ext:ModelField Name="STD_MAX_MEAS" />
                                            <ext:ModelField Name="MEAS_UNIT" />
                                            <ext:ModelField Name="MEAS_UNITNM" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="VENDCD2" />
                                            <ext:ModelField Name="VENDNM2" />
                                            <ext:ModelField Name="MEAS_POINT" />
                                            <ext:ModelField Name="GATE_RNR" />
                                            <ext:ModelField Name="CPK" />
                                            <ext:ModelField Name="DECISION" />
                                            
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
                                <ext:RowNumbererColumn ID="NO"      ItemID="NO"           runat="server" Text="No"                Width="40"  Align="Center" />
                                <ext:Column ID="VINNM"              ItemID="VIN"          runat="server" DataIndex="VINNM"        Width="50"  Align="Center"/>                   <%--Text="차종"--%>        
                                <ext:Column ID="ITEMNM"             ItemID="ITEM"         runat="server" DataIndex="ITEMNM"       Width="90"  Align="Left"/>                     <%--Text="품목"--%>      
                                <ext:Column ID="MEAS_ITEMNM"        ItemID="ITEMNM4"      runat="server" DataIndex="MEAS_ITEMNM"  MinWidth="130" Align="Left" Flex="1"/>         <%--Text="품명"--%>      
                                <ext:Column ID="STD_PHOTO"          ItemID="STD_PHOTO"    runat="server" DataIndex="STD_PHOTO"    Width="70"  Align="Center" />                  <%--Text="부위사진"--%>   
                                <ext:Column ID="MGRT_ITEMNM"        ItemID="MGRT_ITEMNM"  runat="server" DataIndex="MGRT_ITEMNM"  Width="150" Align="Left" />                    <%--Text="관리항목"--%>               
                                <ext:Column ID="MEAS_INST"          ItemID="MEAS_INST"    runat="server" DataIndex="MEAS_INST"    Width="70"  Align="Center"/>                   <%--Text="측정기"--%>     
                                <ext:NumberColumn ID="STANDARD"     ItemID="STANDARD"     runat="server" DataIndex="STANDARD"     Width="70"  Align="Right" Format="#,##0.00"/>  <%--Text="규격"--%>       
                                <ext:NumberColumn ID="STD_MIN_MEAS" ItemID="STD_MIN_MEAS" runat="server" DataIndex="STD_MIN_MEAS" Width="70"  Align="Right" Format="#,##0.00"/>  <%--Text="하한치"--%>     
                                <ext:NumberColumn ID="STD_MAX_MEAS" ItemID="STD_MAX_MEAS" runat="server" DataIndex="STD_MAX_MEAS" Width="80"  Align="Right" Format="#,##0.00"/>  <%--Text="상한치"--%>     
                                <ext:Column ID="MEAS_UNITNM"        ItemID="MEAS_UNITNM"  runat="server" DataIndex="MEAS_UNITNM"  Width="70"  Align="Center"/>                   <%--Text="측정단위"--%>   
                                <ext:Column ID="VENDNM"             ItemID="VENDNM"       runat="server" DataIndex="VENDNM"       MinWidth="130" Align="Left" Flex="1"/>         <%--Text="업체명"--%>     
                                <ext:Column ID="VENDNM2"            ItemID="VENDNM2"      runat="server" DataIndex="VENDNM2"      MinWidth="130" Align="Left" Flex="1"/>         <%--Text="측정업체명"--%> 
                                <ext:Column ID="MEAS_POINT"         ItemID="MEAS_POINT"   runat="server" DataIndex="MEAS_POINT"   MinWidth="130" Align="Left" Flex="1"/>         <%--Text="측정자"--%>     
                                <ext:Column ID="GATE_RNR"           ItemID="GATE_RNR"     runat="server" DataIndex="GATE_RNR"     Width="60"  Align="Center"/>                   <%--Text="Gauge"--%>      
                                <ext:NumberColumn ID="CPK"          ItemID="CPK"          runat="server" DataIndex="CPK"          Width="60"  Align="Center" Format="#,##0.000"/><%--Text="cpk"--%>        
                                <ext:Column ID="DECISION"           ItemID="DECISION"     runat="server" DataIndex="DECISION"     Width="60"  Align="Center"/>                   <%--Text="판정"--%>       
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
