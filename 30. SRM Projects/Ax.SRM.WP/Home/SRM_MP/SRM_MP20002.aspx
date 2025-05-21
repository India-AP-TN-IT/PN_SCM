<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP20002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MP.SRM_MP20002" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible"/>
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
            App.Grid02.setHeight(App.GridPanel.getHeight());
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

            var V_STATUS = grid.getStore().getAt(rowIndex).data["STATUS"];
            var V_QUOTATION_DATE = grid.getStore().getAt(rowIndex).data["QUOTATION_DATE"];
            var V_MRO_PO_TYPE = grid.getStore().getAt(rowIndex).data["MRO_PO_TYPE"];
            var V_MRO_PO_TYPENM = grid.getStore().getAt(rowIndex).data["MRO_PO_TYPENM"];

            App.V_STATUS.setValue(V_STATUS);
            App.V_QUOTATION_DATE.setValue(V_QUOTATION_DATE);
            App.V_MRO_PO_TYPE.setValue(V_MRO_PO_TYPE);
            App.V_MRO_PO_TYPENM.setValue(V_MRO_PO_TYPENM);
            App.V_ROW.setValue(rowIndex);

            App.btn01_MP20002.fireEvent('click');
        }

        var CellDbClick_attach = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;
            var columnName = grid.columns[cellIndex].id;// grid.columnManager.columns[cellIndex].id;

            if (columnName == "ADD_FILENM_1" && grid.getStore().getAt(rowIndex).data["ADD_FILENM"] != null && grid.getStore().getAt(rowIndex).data["ADD_FILENM"] != '') {
                var prno = grid.getStore().getAt(rowIndex).data["PRNO"];
                var prno_seq = grid.getStore().getAt(rowIndex).data["PRNO_SEQ"];
                var seq = grid.getStore().getAt(rowIndex).data["SEQ"];

                App.V_PRNO.setValue(prno);
                App.V_PRNO_SEQ.setValue(prno_seq);
                App.V_SEQ.setValue(seq);
                App.btnDownload.fireEvent('click');
            }
        }
             
    </script>
</head>
<body>
    <form id="SRM_MP20002" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_MP20002" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:TextField   ID="V_STATUS"         runat="server" Hidden="true" ></ext:TextField> 
    <ext:TextField   ID="V_QUOTATION_DATE" runat="server" Hidden="true"></ext:TextField> 
    <ext:TextField   ID="V_MRO_PO_TYPE"    runat="server" Hidden="true" ></ext:TextField> 
    <ext:TextField   ID="V_MRO_PO_TYPENM"  runat="server" Hidden="true" ></ext:TextField> 
    <ext:TextField   ID="V_ROW"            runat="server" Hidden="true" ></ext:TextField>
    
    <ext:TextField   ID="V_PRNO"           runat="server" Hidden="true" ></ext:TextField>
    <ext:TextField   ID="V_PRNO_SEQ"       runat="server" Hidden="true" ></ext:TextField>
    <ext:TextField   ID="V_SEQ"            runat="server" Hidden="true" ></ext:TextField>

    <ext:ImageButton ID="btnDownload" runat="server" Hidden="true" Cls="btn">
        <DirectEvents>
            <Click OnEvent="Cell_DoubleClick" IsUpload="true" >                
                <Confirmation ConfirmRequest="true" Title="Confirm" Message="Do you want to downLoad file?"></Confirmation>                
            </Click>
        </DirectEvents>
    </ext:ImageButton>

    <ext:TextField   ID="V_PONO"             runat="server" Hidden="true" ></ext:TextField>
    <ext:TextField   ID="V_ROWNO"             runat="server" Hidden="true" ></ext:TextField>


    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MP20002" runat="server" Cls="search_area_title_name" Text="주간 소요량" />
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
							<th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>    
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" Text="Business Code" />
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
                                <ext:Label ID="lbl01_MRO_PO_TYPE" runat="server"/>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_MRO_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
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
                            <th class="ess">                                
                                <ext:Label ID="lbl01_ESMT_DATE" runat="server" Text="일자" />
                            </th>
                            <td colspan="3">
                                <ext:FieldContainer ID="CompositeField3" runat="server" Width="260" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:DateField ID="df01_BEG_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                                        <ext:DisplayField ID="DisplayField1" Width="30"  Flex="1" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:DateField ID="df01_END_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                            <td colspan="2" align="left" style="padding-left:5px;">
                                <ext:Button ID="btn01_ETMT" runat="server"><%--Text="견적서 작성" >--%>
                                        <DirectEvents>
                                            <Click OnEvent="etc_Button_Click" >
                                                <ExtraParams>
                                                    <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                                </ExtraParams>
                                            </Click>
                                        </DirectEvents>
                                    </ext:Button>  
                            </td>
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>

         <ext:Panel ID="ContentPanel" runat="server" Region="Center" Layout="BorderLayout">
                <Items>
                    <ext:Panel ID="GridPanel" Region="West" Width="350" Border="True" runat="server" Cls="grid_area">
                        <Items>
                            <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store1" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="GridModel1" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="STATUS" />
                                                    <ext:ModelField Name="QUOTATION_DATE" />                                                    
                                                    <ext:ModelField Name="MRO_PO_TYPE" />
                                                    <ext:ModelField Name="MRO_PO_TYPENM" />
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
                                        <ext:RowNumbererColumn ID="NO"  ItemID="NO"             runat="server"  Text="No"                  Width="40"     Align="Center" />
                                        <ext:Column ID="STATUS"         ItemID="STATE"          runat="server"  DataIndex="STATUS"         Width="60"     Align="Center" /><%--Text="상태"    --%>
                                        <ext:Column ID="QUOTATION_DATE" ItemID="QUOTATION_DATE" runat="server"  DataIndex="QUOTATION_DATE" Width="90"     Align="Center" /><%--Text="견적일"--%>
                                        <ext:Column ID="MRO_PO_TYPENM"  ItemID="MRO_PO_TYPE"    runat="server"  DataIndex="MRO_PO_TYPENM"  MinWidth="100" Align="Left" Flex="1" /><%--Text="일반구매유형"    --%>
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
                        <Items>
                        </Items>
                    </ext:Panel>

                    <ext:Panel ID="GridPanel2" Region="Center" Border="True" runat="server" Cls="grid_area">
                        <Items>
                            <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store3" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="GridModel2" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="QUOTATION_DATE"/>
                                                    <ext:ModelField Name="PRNO"/>
                                                    <ext:ModelField Name="PRNO_SEQ" />
                                                    <ext:ModelField Name="SEQ" />
                                                    <ext:ModelField Name="PARTNO" />
                                                    <ext:ModelField Name="PARTNM" />
                                                    <ext:ModelField Name="STANDARD" />
                                                    <ext:ModelField Name="MAKER" />
                                                    <ext:ModelField Name="DELI_DATE" />
                                                    <ext:ModelField Name="UNIT" />
                                                    <ext:ModelField Name="QTY" />
                                                    <ext:ModelField Name="DELI_PLACE" />
                                                    <ext:ModelField Name="INPT_PLACE" />
                                                    <ext:ModelField Name="MGR_NAME" />
                                                    <ext:ModelField Name="MGR_TELNO" />
                                                    <ext:ModelField Name="ADD_FILENM" />
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
                                        <ext:RowNumbererColumn ID="NO_1"  ItemID="NO"             runat="server"  Text="No"                  Width="40" Align="Center" />
                                        <ext:Column ID="QUOTATION_DATE_1" ItemID="QUOTATION_DATE" runat="server"  DataIndex="QUOTATION_DATE" Width="90" Align="Center" />              <%--Text="의뢰번호"  --%>
                                        <ext:Column ID="PRNO_1"           ItemID="REQNO"          runat="server"  DataIndex="PRNO"           Width="100" Align="Center" />             <%--Text="의뢰번호"  --%>
                                        <ext:Column ID="PRNO_SEQ_1"       ItemID="SEQ_NO"         runat="server"  DataIndex="PRNO_SEQ"       Width="50"  Align="Center" />             <%--Text="순번"      --%>
                                        <ext:Column ID="PARTNM_1"         ItemID="PARTNMTITLE"    runat="server"  DataIndex="PARTNM"         MinWidth="350" Align="Left"  Flex="1"/>   <%--Text="품명"      --%>
                                        <ext:Column ID="MAKER_1"          ItemID="MAKER"          runat="server"  DataIndex="MAKER"          Width="80" Align="Left" />                <%--Text="MAKER"     --%>
                                        <ext:Column ID="DELI_DATE_1"      ItemID="PO_DELI_DATE"   runat="server"  DataIndex="DELI_DATE"      Width="80" Align="Center" />              <%--Text="납기일자"  --%>
                                        <ext:Column ID="UNIT_1"           ItemID="UNIT"           runat="server"  DataIndex="UNIT"           Width="70" Align="Center" />              <%--Text="단위"      --%>
                                        <ext:NumberColumn ID="QTY_1"      ItemID="QTY"            runat="server"  DataIndex="QTY"            Width="65" Align="Right" Format="#,##0" /><%--Text="수량"      --%>                                        
                                        <ext:Column ID="DELI_PLACE_1"     ItemID="DEL_STAGE"      runat="server"  DataIndex="DELI_PLACE"     Width="100" Align="Left" />               <%--Text="납품장소"  --%>
                                        <ext:Column ID="INPT_PLACE_1"     ItemID="INPT_PLACE"     runat="server"  DataIndex="INPT_PLACE"     Width="100" Align="Left" />               <%--Text="입고장소"  --%>
                                        <ext:Column ID="MGR_NAME_1"       ItemID="CHARGE"         runat="server"  DataIndex="MGR_NAME"       Width="80" Align="Left" />                 <%--Text="담당자"    --%>
                                        <ext:Column ID="MGR_TELNO_1"      ItemID="TELNO"          runat="server"  DataIndex="MGR_TELNO"      Width="120" Align="Left" />                <%--Text="전화번호"  --%>
                                        <ext:Column ID="ADD_FILENM_1"     ItemID="ATTACH"         runat="server"  DataIndex="ADD_FILENM"     Width="200" Align="Left" >                <%--Text="첨부파일"  --%>                                            
                                        </ext:Column>
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
                                <Listeners>
                                        <CellDblClick Fn ="CellDbClick_attach"></CellDblClick>
                                </Listeners>                                              
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                </BottomBar>
                            </ext:GridPanel>
                        </Items>
                    </ext:Panel>

                </Items>
            </ext:Panel>      


            <%--그리드와 내용사이에 하단 버튼영역이 필요할경우 아래 패널 사용(Hidden = "false") --%>
            <ext:Panel ID="BottomButtonPanel" runat="server" Region="South" Height="23" Cls="bottom_area_btn" Hidden="true">
                <Items>
                    <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5" ID="btnRowAdd"></ext:ImageButton>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_deleterow.gif" ID="btnRowDelete"></ext:ImageButton>
                </Items>
            </ext:Panel>            
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
