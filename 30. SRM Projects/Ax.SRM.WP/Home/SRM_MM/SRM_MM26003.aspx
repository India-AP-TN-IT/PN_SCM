<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM26003.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM26003" %>
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
            
            var grid = grid.ownerCt;

            // cellIndex는 Hidden된 컬럼은 제외한 index 임
            // grid.columns은 Hidden 포함
            // grid.columnManager.columns은 Hidden 제외
            // console.log(grid.columns[cellIndex].id, grid.columnManager.columns[cellIndex].id);


            var yymm = grid.getStore().getAt(rowIndex).data["STD_YYMM"];
            var date = grid.getStore().getAt(rowIndex).data["CLS_DATE"];
            var time = grid.getStore().getAt(rowIndex).data["CLS_TIME"];

            App.direct.Grid01_Cell_DoubleClick(yymm, date, time);
            
        }

        function changeEND_TIME(obj, value) {
            document.getElementById('txt02_END_TIME-inputEl').value = checkEndTime(value);
        }

        var checkEndTime = function (value) {
            var length = String(value).length;
            var temp = "";
            switch (length) {
                case 0: return temp;
                case 1: temp = value < 3 ? value : ""; break;
                case 2: temp = value < 24 ? value : ""; break;
                case 3:
                    var temp12 = Number(String(value).substr(0, 2));
                    var temp3 = Number(String(value).substr(2, 1));
                    temp = temp12 < 24 && temp3 < 6 ? value : ""; break;
                case 4:
                    var temp12 = Number(String(value).substr(0, 2));
                    var temp34 = Number(String(value).substr(2, 2));
                    temp = temp12 < 24 && temp34 < 60 ? value : ""; break;
            }
            if (temp == "") return checkEndTime(String(value).substr(0, length - 1));
            else return temp;
        }

    </script>
</head>
<body>
    <form id="SRM_MM26003" runat="server">
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
                    <ext:Label ID="lbl01_CLS_DATE_INQUERY" runat="server" Cls="search_area_title_name" /><%--Text="마감일자 조회" />--%>
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
                                    <DirectEvents>
                                        <Change OnEvent="cbo01_BIZCD_Change" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_SER_YEAR" runat="server" /><%--Text="조회년도" /> --%>
                            </th>
                                <td>
                                    <ext:NumberField ID="txt01_SER_YEAR" Width="150" Cls="inputText_Code" FieldCls="inputText_Code" AllowDecimals="true" Step="1" MinValue="1900" MaxValue="9999" runat="server" />
                                </td>
                            <th class="ess">        
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
                                    <DirectEvents>
                                        <Change OnEvent="cbo01_PURC_ORG_Change" />
                                    </DirectEvents>
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
                                            <ext:ModelField Name="STD_YYMM" />
                                            <ext:ModelField Name="CLS_DATE" />
                                            <ext:ModelField Name="CLS_TIME" />
                                            <ext:ModelField Name="UPDATE_DATE" />
                                            <ext:ModelField Name="UPDATE_ID" />
                                            <ext:ModelField Name="CORCD" />
                                            <ext:ModelField Name="BIZCD" />
                                            <ext:ModelField Name="PURC_ORG" />
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
                                <ext:Column ID="STD_YYMM" ItemID="CLS_YYMM" runat="server" DataIndex="STD_YYMM" Width="100" Align="Center" /><%--Text="마감년월"--%>
                                <ext:Column ID="CLS_DATE" ItemID="END_DATE" runat="server" DataIndex="CLS_DATE" Width="100" Align="Center" /><%--Text="종료일자"--%>
                                <ext:Column ID="CLS_TIME" ItemID="END_TIME" runat="server" DataIndex="CLS_TIME" Width="65" Align="Center" /><%--Text="종료시간"--%>
                                <ext:Column ID="UPDATE_DATE" ItemID="FNLUPDATEDTTM" runat="server" DataIndex="UPDATE_DATE" Width="150" Align="Center" /><%--Text="최종수정일시"--%>
                                <ext:Column ID="UPDATE_ID" ItemID="UPDATE_ID3" runat="server" DataIndex="UPDATE_ID" Width="120" Align="Left" /><%--Text="최종수정ID"--%>
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
                        <Listeners>
                            <CellDblClick Fn ="Grid01_CellDbClick"></CellDblClick>
                        </Listeners>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>

                </Items>
            </ext:Panel>
            <%--마감일자 등록/수정/삭제 제목 영역--%>
            <ext:Panel ID="SaveTitlePanel" runat="server" Region="South" Height="30" StyleSpec="margin-top:10px;">
                <Items>
                    <ext:Label ID="lbl02_CLS_DATE_SAVE" runat="server" Cls="search_area_title_name" /><%--Text="마감일자 등록/수정/삭제" />--%>
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
                            <th class="ess">
                                <ext:Label ID="lbl02_SAUP" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo02_BIZCD" runat="server"  Mode="Local" ForceSelection="true" ReadOnly="true" FieldCls="readonly pb5"
                                    DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
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
                                <ext:Label ID="lbl02_PURC_ORG" runat="server" /><%--Text="구매조직" /> --%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo02_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true" ReadOnly="true" FieldCls="readonly pb5"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
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
                            <th class="ess">
                                <ext:Label ID="lbl02_CLS_YYMM" runat="server" /><%--Text="기준년월" /> --%>
                            </th>
                            <td>
                                <ext:DateField ID="df02_STD_YYMM" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true" />
                            </td>
                        </tr>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_END_DATE" runat="server" /><%--Text="종료일자" /> --%>
                            </th>
                            <td>
                                <ext:DateField ID="df02_END_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true" />
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl02_END_TIME" runat="server" /><%--Text="종료시간" /> --%>
                            </th>
                            <td colspan="3">
                                <div style="float:left">
                                    <ext:TextField ID="txt02_END_TIME" Width="115" Cls="inputText_Num" runat="server" MaskRe="/[0-9]/" MaxLengthText="4" MaxLength="4" EnforceMaxLength="true"> 
                                        <Listeners>
                                            <Change Fn="changeEND_TIME"></Change>
                                        </Listeners>
                                    </ext:TextField>
                                </div>
                                <div>&nbsp;(0000~2359)</div>
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>

            <ext:Panel ID="Panel2" runat="server" Region="South" Height="30" StyleSpec="margin-top:10px">
                <Items>
                    <ext:Label ID="lbl03_RESALE_LIMIT_DAY" runat="server" Cls="search_area_title_name" /> <%--Text="사급신청등록 제한일수 등록"--%>
                </Items>
            </ext:Panel>
             
            <ext:Panel ID="Panel1" Region="South" Cls="search_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 300px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl03_SAUP" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo03_BIZCD" runat="server"  Mode="Local" ForceSelection="true" ReadOnly="true" FieldCls="readonly pb5"
                                    DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store6" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model5" runat="server">
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
                                <ext:Label ID="lbl03_RESALE_LIMIT_DAY_CNT" runat="server" /><%--Text="제한일수" /> --%>
                            </th>
                            
                            <td>
                                <ext:NumberField ID="txt03_MIN_REQ_DAY" Width="115" Cls="inputText_Num" FieldCls="inputText_Num" AllowDecimals="false" Step="1" MinValue="0" MaxValue="9999" EmptyText="0" EmptyNumber="0" runat="server" />
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
