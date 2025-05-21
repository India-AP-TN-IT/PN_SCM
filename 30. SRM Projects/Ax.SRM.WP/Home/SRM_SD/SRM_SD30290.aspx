<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_SD30290.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_SD30290" %>
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

        function fn_cbo01_BIZCD_Change(obj, currentValue, beforeValue, fn) {
            
        }

        function fn_txt01_SER_YEAR_Change() {

        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var Grid01_CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {

            //CellDbClick이벤트의 파라메터중 3번째로 넘어오는 cellIndex는 
            //더블클릭한 셀의 인덱스를 가져오도록 되어 있는데
            //ItemId가 동일한 여러 컬럼이 존재하는 경우에는(다국어) 제대로 값이 넘어오지 않음.
            //그래서 7번째 파라메터인 obj4의 하위속성을 이용하여 cellIndex값 제대로 추출함.
            //cellIndex = obj4.target.offsetParent.cellIndex;
            //var grid = grid.ownerCt;
            var grid = App.Grid01;

            // cellIndex는 Hidden된 컬럼은 제외한 index 임
            // grid.columns은 Hidden 포함
            // grid.columnManager.columns은 Hidden 제외
            // console.log(grid.columns[cellIndex].id, grid.columnManager.columns[cellIndex].id);            
            App.txt02_ASSY_HLOTNO.setValue('');
            App.txt02_PARTNO_TITLE.setValue('');
            App.txt02_ALC.setValue('');
            App.txt02_PROD_DATE.setValue('');
            App.txt02_OUT_DATE.setValue('');
            App.txt02_POSTITLE.setValue('');

            if (grid.columns[cellIndex].id && grid.columns[cellIndex].id.match(/_BARCODE/)) {
                var loadmask = new Ext.LoadMask(App.SavePanel, { msg: "Please wait..." });
                loadmask.show();
                App.direct.Grid01_Cell_DoubleClick(grid.getStore().getAt(rowIndex).data[grid.columns[cellIndex].id], { success: function (result) { loadmask.hide(); } });

            }
        }

    </script>
</head>
<body>
    <form id="SRM_SD30290" runat="server">
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
                    <ext:Label ID="lbl01_SRM_SD30290" runat="server" Cls="search_area_title_name" /><%--Text="사외물류 납품정보조회(KMM)" />--%>
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
                            <th class="ess">
                                <ext:Label ID="lbl01_ISSDATE" runat="server" /><%--Text="발행일자" /> --%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer2" runat="server" Width="250" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:DateField ID="df01_DATE_BEG" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  >
                                        </ext:DateField>
                                        <ext:DisplayField ID="lbl01_PERIOD" Width="20"  Flex="1" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:DateField ID="df01_DATE_TO" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  >
                                        </ext:DateField>
                                    </Items>
                                </ext:FieldContainer>   
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_VID" runat="server" /><%--Text="차대번호"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_VID" Width="150" Cls="inputText" runat="server" />    
                            </td>
                            <th>
                                <ext:Label ID="lbl01_CUST_PLANT" runat="server"  /><%--Text="고객공장"--%>
                            </th>
                            <td>
                                <ext:RadioGroup ID="RadioGroup1" runat="server" Width="400" Cls="inputText"  ColumnsWidths="80,100,100,100">
                                    <Items>
                                        <ext:Radio ID="rdo01_ALL" Flex="1"  Cls="inputText"  runat="server" Checked="true" /><%--Text="전체"--%>
                                        <ext:Radio ID="rdo01_HW_1PLANT" Flex="1"  Cls="inputText"  runat="server" /><%--Text="화성1공장"--%>
                                        <ext:Radio ID="rdo01_HW_2PLANT" Flex="1"  Cls="inputText"  runat="server" /><%--Text="화성2공장"--%>
                                        <ext:Radio ID="rdo01_SS_PLANT" Flex="1"  Cls="inputText"  runat="server" /><%--Text="서산공장"--%>
                                    </Items>
                                </ext:RadioGroup>
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
                                            <ext:ModelField Name="PLANT" />
                                            <ext:ModelField Name="OEM_DT" />
                                            <ext:ModelField Name="CMT_NO" />
                                            <ext:ModelField Name="VIN_CODE" />
                                            <ext:ModelField Name="BODY_NO" />
                                            <ext:ModelField Name="FL_ALC" />
                                            <ext:ModelField Name="FR_ALC" />
                                            <ext:ModelField Name="RR1_ALC" />                              
                                            <ext:ModelField Name="RR2_ALC" />
                                            <ext:ModelField Name="FL_BARCODE" />
                                            <ext:ModelField Name="FR_BARCODE" />
                                            <ext:ModelField Name="RR1_BARCODE" />
                                            <ext:ModelField Name="RR2_BARCODE" />
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
                                <ext:Column ID="PLANT" ItemID="CUST_PLANT2" runat="server" DataIndex="PLANT" Width="80" Align="Left" /><%--Text="공장"--%>
                                <ext:Column ID="OEM_DT" ItemID="TIN_DATE" runat="server" DataIndex="OEM_DT" Width="130" Align="Left" /><%--Text="T/IN 일시"--%>
                                <ext:Column ID="CMT_NO" ItemID="CMT_NO" runat="server" DataIndex="CMT_NO" Width="100" Align="Left" Text="Commit No" /><%--Text=""--%>
                                <ext:Column ID="VIN_CODE" ItemID="VID" runat="server" DataIndex="VIN_CODE" Width="150" Align="Left" /><%--Text="차대번호"--%>
                                <ext:Column ID="BODY_NO" ItemID="BODYNO" runat="server" DataIndex="BODY_NO" Width="80" Align="Left" /><%--Text="바디"--%>
                                <ext:Column ID="FL_ALC" ItemID="FL_ALC" runat="server" DataIndex="FL_ALC" Width="80" Align="Center" Text="FL - ALC"/>
                                <ext:Column ID="FR_ALC" ItemID="FR_ALC" runat="server" DataIndex="FR_ALC" Width="80" Align="Center" Text="FR - ALC"/>
                                <ext:Column ID="RR1_ALC" ItemID="RR1_ALC" runat="server" DataIndex="RR1_ALC" Width="80" Align="Center" Text="R1 - ALC"/>
                                <ext:Column ID="RR2_ALC" ItemID="RR2_ALC" runat="server" DataIndex="RR2_ALC" Width="80" Align="Center" Text="R2 - ALC"/>
                                <ext:Column ID="FL_BARCODE" ItemID="FL_BARCODE" runat="server" DataIndex="FL_BARCODE" Width="150" Align="Left" Text="FL - BARCODE"/>
                                <ext:Column ID="FR_BARCODE" ItemID="FR_BARCODE" runat="server" DataIndex="FR_BARCODE" Width="150" Align="Left" Text="FR - BARCODE"/>
                                <ext:Column ID="RR1_BARCODE" ItemID="RR1_BARCODE" runat="server" DataIndex="RR1_BARCODE" Width="150" Align="Left" Text="R1 - BARCODE"/>
                                <ext:Column ID="RR2_BARCODE" ItemID="RR2_BARCODE" runat="server" DataIndex="RR2_BARCODE" Width="150" Align="Left" Text="R2 - BARCODE"/>
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">
<%--                                <Listeners>
                                    <Select Fn="CellFocus"></Select>
                                </Listeners>--%>
                            </ext:CellSelectionModel >
                        </SelectionModel>
                        <Listeners>
                            <CellClick Fn ="Grid01_CellDbClick"></CellClick>
                        </Listeners>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>

                </Items>
            </ext:Panel>
            <ext:Panel ID="SaveTitlePanel" runat="server" Region="South" Height="25">
                <Items>
                    <ext:Label ID="lbl02_SRM_SD30290_MSG1" runat="server" Cls="search_area_title_name" StyleSpec="color:blue;" Text="LOT를 클릭하면 당사 기준의 제품LOT 정보를 확인할 수 있음." />
                    <ext:Panel ID="SaveButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="SavePanel" Region="South" Cls="search_area_table" runat="server" >
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
                            <th>         
                                <ext:Label ID="lbl02_ASSY_HLOTNO" runat="server" /><%--Text="완제품 LOT NO"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_ASSY_HLOTNO" Width="150" Cls="inputText" runat="server" ReadOnly="true" />    
                            </td>
                            <th>         
                                <ext:Label ID="lbl02_PARTNO_TITLE" runat="server" /><%--Text="품번"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_PARTNO_TITLE" Width="150" Cls="inputText" runat="server" ReadOnly="true" />    
                            </td>
                            <th>         
                                <ext:Label ID="Label3" runat="server" Text="ALC"/><%--Text="ALC"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_ALC" Width="150" Cls="inputText" runat="server"  ReadOnly="true" />    
                            </td>
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl02_PROD_DATE" runat="server" /><%--Text="생산일자"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_PROD_DATE" Width="150" Cls="inputText" runat="server" ReadOnly="true" />     
                            </td>
                            <th>         
                                <ext:Label ID="lbl02_OUT_DATE" runat="server" /><%--Text="출고일자"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_OUT_DATE" Width="150" Cls="inputText" runat="server" ReadOnly="true" />    
                            </td>
                            <th>         
                                <ext:Label ID="lbl02_POSTITLE" runat="server" /><%--Text="장착위치"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_POSTITLE" Width="150" Cls="inputText" runat="server" ReadOnly="true" />     
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
