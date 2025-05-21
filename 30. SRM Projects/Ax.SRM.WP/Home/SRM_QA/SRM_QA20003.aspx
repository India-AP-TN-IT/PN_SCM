<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA20003.aspx.cs" Inherits="Ax.QA.WP.Home.SRM_MP.SRM_QA20003" %>
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

    <title>입고불량 대책서 등록</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        // 그리드에서 선택된 Action Object
        var currentCellObject;

        //다이렉트 메서드 호출
        //App.direct.Cell_Click(position.row, position.column);

        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
            App.Grid02.setHeight(App.GridPanel.getHeight());
        }

        // editor가 포함된 cell에서 tab을 누를경우에 실행되는 메소드를 override해서 원하는 방향으로 변경
        Ext.override(Ext.selection.CellModel, {
            onEditorTab: function (editingPlugin, e) {
                var me = this, direction = e.shiftKey ? 'left' : 'right', position = me.move(direction, e);

                if (position) {
                    // 만약 다음 셀이 editor가 되지 않는 셀이라면 한번더 tab을 누르는 효과를 준다.
                    //var isEditing = editingPlugin.getActiveEditor() == null || (editingPlugin.getActiveEditor().editing == false);

                    if (!editingPlugin.startEdit(position.row, position.column)) {
                        if (!(this.selection.columnHeader.id == 'D_CHECK_VALUE')) { //체크박스라면 멈춘다.
                            me.onEditorTab(editingPlugin, e);
                        }
                    }
                    else {
                        if (this.selection.columnHeader.id == 'NO') { //만약 No컬럼이면 한번더 tab을 누른효과를 준다.
                            me.onEditorTab(editingPlugin, e);
                        }
                    }
                }
            }
        });

        // 그리드의 cell에 포커스가 갈 경우에 자동으로 editor가 실행이 되도록 한다. 
        // 원인: 그리드 내의 콤보박스는 editor을 포함하지 않아 eiditorTab 이벤트가 실행이되지 않음. 따라서 콤보박스에서 tab을 눌렀을 경우에 
        // editor가 포함된 cell에 포커스가 가면 editor가 실행이 되고 이후에 tab을 클릭하면 editor가 포함된 cell로 자동으로 이동이 된다.
        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            var grid = selectionModel.view.ownerCt;

            grid.editingPlugin.startEdit(rowIndex, colIndex);
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
            var codeName, textName;

            var grid = App.Grid01;
            var rowIdx = App.CodeRow.getValue();

            grid.getStore().getAt(App.CodeRow.getValue()).set(textName, typeNM);
            grid.getStore().getAt(App.CodeRow.getValue()).set(codeName, objectID);


            // 필수코드 ( 반드시 )
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", false);
            grid.getStore().getAt(rowIdx).set("CHECK_VALUE", grid.getStore().getAt(rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드의 editor를 활성화시키는 시점에서 작동        
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        // 그리드를 editor한 후에 발생되는 이벤트
        var AfterEdit = function (rowEditor, e) {
            if (e.column.dataIndex != "CHECK_VALUE") {
                e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", false);
                e.grid.getStore().getAt(e.rowIdx).set("CHECK_VALUE", e.grid.getStore().getAt(e.rowIdx).dirty); // 수정후에 no에도 행의 값을 넣어준다.
            } else {
                e.grid.getStore().getAt(e.rowIdx).dirty = e.grid.getStore().getAt(e.rowIdx).data["CHECK_VALUE"];
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 첨부파일 팝업창
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/

        var fn_QA20002P2 = function (id, chr_nm, chr_tel, deli_date, chk) {
            var count = Ext.getCmp("Grid01").store.getCount();
            var dirty = App.Grid01.getRowsValues({ dirtyRowsOnly: true });
            App.direct.GridUpdate(chr_nm, chr_tel, deli_date, chk, count, dirty);

            Ext.getCmp(id).hide();
        };

        function fn_PopupHandler(BIZCD, VENDCD, DOCNO, RCV_DATE, DEFNO, DOCNO2) {
            App.V_BIZCD.setValue(BIZCD);
            App.V_VENDCD.setValue(VENDCD);
            App.V_DOCNO.setValue(DOCNO);
            App.V_RCV_DATE.setValue(RCV_DATE);
            App.V_DEFNO.setValue(DEFNO);
            App.V_DOCNO2.setValue(DOCNO2);

            App.btn01_POP_QA20003P1.fireEvent('click');
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 그리드 cell 더블 클릭 시
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var CellDbClick = function (grid, obj1, obj0, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;
            var cellIndex = obj4.target.offsetParent.cellIndex;

            if (grid.id == "Grid01-normal") {
                if (cellIndex != 3) {
                    var VENDCD = grid.getStore().getAt(rowIndex).data["VENDCD"];
                    var DOCNO = grid.getStore().getAt(rowIndex).data["DOCNO"];
                    var RCVDATE = grid.getStore().getAt(rowIndex).data["RCVDATE"];
                    var DEFNO = grid.getStore().getAt(rowIndex).data["DEFNO"];
                    var DOCNO2 = grid.getStore().getAt(rowIndex).data["DOCNO2"];
                    var BIZCD = grid.getStore().getAt(rowIndex).data["BIZCD"];

                    var VEND_STATUS = grid.getStore().getAt(rowIndex).data["VEND_STATUS_CD"];

                    if (DOCNO == null || DOCNO == "") {
                        App.direct.MsgCodeAlert("SRMQA00-0005");
                        return;
                    }
                    if (VEND_STATUS == "FHY") {
                        App.direct.MsgCodeAlert("SRMQA00-0006");
                        return;
                    }
                    if (VEND_STATUS == "") {
                        App.direct.MsgCodeAlert("SRMQA00-0007");
                        return;
                    }

                    fn_PopupHandler(BIZCD, VENDCD, DOCNO, RCV_DATE, DEFNO, DOCNO2);
                }
                else {
                    if (cellIndex == 3) {
                        //사진 뜨는 팝업 구현해야 됨.
                    }
                }
            }
            else {
                if (cellIndex == 3) {
                    //사진 뜨는 팝업 구현해야 됨.
                }
            }
        }

        // 체크박스 유효성처리
        var chkMethod = function (column, rowIdx, checked, eOpts) {

            var grid = App.Grid01;
            var DOCNO = "";

            if (grid.getStore().getAt(rowIdx).data["DOCNO"] != null && grid.getStore().getAt(rowIdx).data["DOCNO"] != "") {
                DOCNO = grid.getStore().getAt(rowIdx).data["DOCNO"];
            }

            if (DOCNO == "") {
            }
            else {
                App.direct.MsgCodeAlert("SRMMP00-0014");
                grid.getStore().getAt(rowIdx).set("SCHK", false);
            }
        }

    </script>
</head>
<body>
    <form id="SRM_QA20003" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:ImageButton ID="btn01_POP_QA20003P1" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:TextField   ID="V_BIZCD"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_BIZCD 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_VENDCD"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_VENDCD 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_DOCNO"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_DOCNO 값을 팝업에 넘기기 위해서 사용--%>
    <ext:DateField   ID="V_RCV_DATE"            runat="server" Hidden="true" ></ext:DateField> <%--팝업호출시 그리드의 V_RCV_DATE 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_DEFNO"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_DEFCD 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_DOCNO2"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_DOCNO2 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="CodeCol" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col index (사용하지 않으나 차후 필요할지 몰라서)--%>
    <ext:TextField ID="CodeColName" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col Name--%>
    <ext:TextField   ID="UserHelpURL"         runat="server" Hidden="true" Text="../SRM_QA/SRM_QA20003P1.aspx"></ext:TextField> 
    <ext:TextField   ID="PopupWidth"          runat="server" Hidden="true" Text="800"></ext:TextField> 
    <ext:TextField   ID="PopupHeight"         runat="server" Hidden="true" Text="600"></ext:TextField> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_QA20003" runat="server" Cls="search_area_title_name" Text="테스트" />
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
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"
                                                OnAfterValidation="CodeBox_AfterValidation"/>
                            </td>
                            <th>                                
                                <ext:Label ID="lbl01_DEAD_STD" runat="server" /> <%--Text="마감기준" --%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_RCV_DATE" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <!-- 차종 -->
                                <ext:Label ID="lbl01_VIN" Text="Vehicle" Width="110" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow"/>
                            </td>
                            <th>
                                <!-- 품목 -->
                                <ext:Label ID="lbl01_ITEM" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_ITEM" OnDirectEventChange="Button_Click" runat="server" ClassID="E0" PopupMode="Search" PopupType="CodeWindow"/>                                
                            </td>
                            <th>
                                <ext:Label ID="lbl01_SEARCH_OPT" runat="server" Text="Vendor Plant" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_INSPECT_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="CDNM" ValueField="CD" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model5" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="CD" />
                                                        <ext:ModelField Name="CDNM" />
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
                    <ext:GridPanel ID="Grid01" runat="server" TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="250" >
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server" Name ="ModelGrid">
                                        <Fields>
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="VENDNM"/>
                                            <ext:ModelField Name="DOCNO"/>
                                            <ext:ModelField Name="VEND_STATUS"/>
                                            <ext:ModelField Name="FIRM_STATUS"/>
                                            <ext:ModelField Name="VEND_MGR"/>
                                            <ext:ModelField Name="RECEIPT_DATE"/>
                                            <ext:ModelField Name="DEFNO"/>
                                            <ext:ModelField Name="RCV_DATE"/>
                                            <ext:ModelField Name="VINCD"/>
                                            <ext:ModelField Name="PARTNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="DEF_QTY"/>
                                            <ext:ModelField Name="DEFNM"/>
                                            <ext:ModelField Name="DEF_PLACENM"/>
                                            <ext:ModelField Name="INSPECT_NM"/>
                                            <ext:ModelField Name="REPLY_DEM_DATE"/>
                                            <ext:ModelField Name="RECEIPT_YN"/>
                                            <ext:ModelField Name="RECEIPT_TIME"/>
                                            <ext:ModelField Name="CONF_YN"/>
                                            <ext:ModelField Name="CONF_MGRNM"/>
                                            <ext:ModelField Name="CONF_DATE"/>
                                            <ext:ModelField Name="CONF_TIME"/>
                                            <ext:ModelField Name="CORCD"/>
                                            <ext:ModelField Name="BIZCD"/>
                                            <ext:ModelField Name="DOCNO2"/>
                                            <ext:ModelField Name="IMG_LEN"/>
                                            <ext:ModelField Name="VEND_STATUS_CD"/>
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
                            <%-- buffred view를 사용하기 위한 plugin. --%>
                            <%--<ext:BufferedRenderer ID="BufferedRenderer1" runat="server" />--%>
                            <%-- 2.X버전부터는 그리드에서 edtior를 활성화 시키기위해서 cellEditing Plugin을 추가 하여 사용하고 자바스크립트에서 grid.editingPlugin 형태로 사용할수 있다. --%>
                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center"  Locked="true">
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:Column ID="VENDCD" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="100" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="150" Align="Left" Locked="true"/>  <%--Text="업체명"--%> 
                                <ext:Column ID="DOCNO" ItemID="DOCNO02" runat="server" DataIndex="DOCNO" Width="130" Align="Center" Locked="true" />  <%--Text="문서발생번호"--%> 
                                <ext:Column ID="VEND_STATUS" ItemID="VENDCDSTATUSNM" runat="server" DataIndex="VEND_STATUS" Width="60" Align="Center" Locked="true" />  <%--Text="업체상태"--%> 
                                <ext:Column ID="FIRM_STATUS" ItemID="FIRM_STATUS02" runat="server" DataIndex="FIRM_STATUS" Width="60" Align="Center" Locked="true" />  <%--Text="당사상태"--%> 
                                <ext:Column ID="VEND_MGR" ItemID="VEND_MGR" runat="server" DataIndex="VEND_MGR" Width="80" Align="Center" Locked="true" />  <%--Text="업체담당"--%> 
                                <ext:DateColumn ID="RECEIPT_DATE" ItemID="WKDATE" runat="server" DataIndex="RECEIPT_DATE" Width="80" Align="Center" />  <%--Text="수신일자"--%> 
                                <ext:Column ID="DEFNO" ItemID="DEFNO" runat="server" DataIndex="DEFNO" Width="100" Align="Center" />  <%--Text="불량번호"--%> 
                                <ext:DateColumn ID="RCV_DATE" ItemID="RCV_DATE" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" />  <%--Text="입고일자"--%> 
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="60" Align="Center" />  <%--Text="차종"--%> 
                                <ext:Column ID="PARTNO" ItemID="PARTNO5" runat="server" DataIndex="PARTNO" Width="120" Align="Left" />  <%--Text="Part-No"--%> 
                                <ext:Column ID="PARTNM" ItemID="PARTNM2" runat="server" DataIndex="PARTNM" MinWidth="200" Align="Left" Flex="1" />  <%--Text="Part-Name"--%> 
                                <ext:NumberColumn ID="DEF_QTY" ItemID="DEF_QTY" runat="server" DataIndex="DEF_QTY" Width="80" Align="Right" Format="#,###" />  <%--Text="불량수량"--%> 
                                <ext:Column ID="DEFNM" ItemID="DEF_CNTT" runat="server" DataIndex="DEFNM" Width="120" Align="Left" />  <%--Text="불량내용"--%> 
                                <ext:Column ID="DEF_PLACENM" ItemID="DEF_PLACE" runat="server" DataIndex="DEF_PLACENM" Width="120" Align="Left" />  <%--Text="불량장소"--%> 
                                <ext:Column ID="INSPECT_NM" ItemID="GA_INPUT_NM" runat="server" DataIndex="INSPECT_NM" Width="80" Align="Center" />  <%--Text="작성자"--%> 
                                <ext:DateColumn ID="REPLY_DEM_DATE" ItemID="REPLY_DEM_DATE" runat="server" DataIndex="REPLY_DEM_DATE" Width="80" Align="Center" />  <%--Text="회신요구일"--%> 
                                <ext:Column ID="RECEIPT_YN" ItemID="RECEIPT_YN02" runat="server" DataIndex="RECEIPT_YN" Width="60" Align="Center" />  <%--Text="수신확인"--%> 
                                <ext:Column ID="RECEIPT_TIME" ItemID="TIME" runat="server" DataIndex="RECEIPT_TIME" Width="60" Align="Center" />  <%--Text="시간"--%> 
                                <ext:Column ID="CONF_YN" ItemID="CONF_YN" runat="server" DataIndex="CONF_YN" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="CONF_MGRNM" ItemID="EMPNAME" runat="server" DataIndex="CONF_MGRNM" Width="80" Align="Center" />  <%--Text="사원명"--%> 
                                <ext:DateColumn ID="CONF_DATE" ItemID="CONF_DATE" runat="server" DataIndex="CONF_DATE" Width="80" Align="Center" />  <%--Text="확인일자"--%> 
                                <ext:Column ID="CONF_TIME" ItemID="CONF_TIME" runat="server" DataIndex="CONF_TIME" Width="60" Align="Center" />  <%--Text="확인시간"--%> 
                                <ext:Column ID="CORCD" ItemID="CORCD" runat="server" DataIndex="CORCD" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="BIZCD" ItemID="SAUP" runat="server" DataIndex="BIZCD" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="DOCNO2" ItemID="DOCNO2" runat="server" DataIndex="DOCNO2" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="IMG_LEN" ItemID="IMG_LEN" runat="server" DataIndex="IMG_LEN" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="VEND_STATUS_CD" ItemID="VEND_STATUS_CD" runat="server" DataIndex="VEND_STATUS_CD" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                            </Columns>
                            <%-- 그리드에서 editor에서 키를 다운했을 경우에 발생되는 핸들러가 막혀있어서 차후에 필요하다면 아래와 같이 사용
                            <Listeners>
                                <Render Handler="this.el.on('keydown', startEditing);" />
                            </Listeners>
                            --%>
                        </ColumnModel>

                        <%-- 그리드 검색시 보이는 progress--%>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">
                            </ext:GridView>
                        </View>
                        <%-- SelectionModel은 checkbox, cell, row가 존재하고 그리드를 클릭시 그리드의 선택된 행의값이 json형태로 넘어감 (EP20S01참고)--%>
                        <SelectionModel>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">
                                <%-- 아래와 같이 리스너(자바스크립트 호출), DIRECT EVENT(서버단의 directMethod호출) 형태로 사용가능
                                <Listeners>
                                    <Select Handler=""></Select>
                                </Listeners>
                                <DirectEvents>
                                        <Select OnEvent="Cell_Click" />                        
                                </DirectEvents>
                                --%>
                            </ext:CellSelectionModel >
                            <%--<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server"><Listeners><Select Fn="CellFocus"></Select></Listeners></ext:CheckboxSelectionModel>--%>
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

            <ext:Panel ID="GridPanel02" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid02" runat="server" TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store2" runat="server" PageSize="250" >
                                <Model>
                                    <ext:Model ID="Model2" runat="server" Name ="ModelGrid">
                                        <Fields>
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="VENDNM"/>
                                            <ext:ModelField Name="DEFNO"/>
                                            <ext:ModelField Name="RCV_DATE"/>
                                            <ext:ModelField Name="VINCD"/>
                                            <ext:ModelField Name="DEF_PNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="IMPUT_DIVCDNM"/>
                                            <ext:ModelField Name="DEFNM"/>
                                            <ext:ModelField Name="DEF_PLACECD"/>
                                            <ext:ModelField Name="DEF_UCOST"/>
                                            <ext:ModelField Name="DEF_QTY"/>
                                            <ext:ModelField Name="NAME_KOR"/>
                                            <ext:ModelField Name="LINECD"/>
                                            <ext:ModelField Name="ALCCD"/>
                                            <ext:ModelField Name="YPNO"/>
                                            <ext:ModelField Name="PROD_REG_DATE"/>
                                            <ext:ModelField Name="PROD_REG_EMPNO"/>
                                            <ext:ModelField Name="DEF_IMPUT_VENDCD"/>
                                            <ext:ModelField Name="MAT_REUSE_YN"/>
                                            <ext:ModelField Name="DN_DIV"/>
                                            <ext:ModelField Name="OCCUR_DIV"/>
                                            <ext:ModelField Name="REF_NOTENO"/>
                                            <ext:ModelField Name="RECEIPT_DATE"/>
                                            <ext:ModelField Name="RECEPT_TIME"/>
                                            <ext:ModelField Name="CORCD"/>
                                            <ext:ModelField Name="BIZCD"/>
                                            <ext:ModelField Name="GUBUN"/>
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
                            <%-- buffred view를 사용하기 위한 plugin. --%>
                            <%--<ext:BufferedRenderer ID="BufferedRenderer2" runat="server" />--%>
                            <%-- 2.X버전부터는 그리드에서 edtior를 활성화 시키기위해서 cellEditing Plugin을 추가 하여 사용하고 자바스크립트에서 grid.editingPlugin 형태로 사용할수 있다. --%>
                            <ext:CellEditing ID="CellEditing2" runat="server" ClicksToEdit="1" >
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel2" runat="server">
                            <Columns>
                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                <ext:Column ID ="Column1" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center"  Locked="true">
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                    <ext:Column ID="VENDCD02" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="100" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                    <ext:Column ID="VENDNM02" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="150" Align="Center" Locked="true" />  <%--Text="업체명"--%> 
                                    <ext:Column ID="DEFNO02" ItemID="DOCNO02" runat="server" DataIndex="DEFNO" Width="130" Align="Center" Locked="true" />  <%--Text="문서발생번호"--%> 
                                    <ext:DateColumn ID="RCV_DATE02" ItemID="EQUIP_DATE" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" Locked="true" />  <%--Text="반입일자"--%> 
                                    <ext:Column ID="VINCD02" ItemID="VIN" runat="server" DataIndex="VINCD" Width="60" Align="Center" Locked="true" />  <%--Text="차종"--%> 
                                    <ext:Column ID="DEF_PNO" ItemID="DEF_PNO" runat="server" DataIndex="DEF_PNO" Width="120" Align="Left" Locked="true" />  <%--Text="불량품번"--%> 
                                    <ext:Column ID="PARTNM02" ItemID="PARTNM2" runat="server" DataIndex="PARTNM" MinWidth="200" Align="Left" Flex="1" />  <%--Text="Part-Name"--%> 
                                    <ext:Column ID="IMPUT_DIVCDNM" ItemID="RESPONSTITLE" runat="server" DataIndex="IMPUT_DIVCDNM" Width="100" Align="Left" />  <%--Text="귀책구분"--%> 
                                    <ext:Column ID="DEFNM02" ItemID="DEF_CNTT" runat="server" DataIndex="DEFNM" Width="150" Align="Left" />  <%--Text="불량내용"--%> 
                                    <ext:Column ID="DEF_PLACECD" ItemID="DEF_PLACE" runat="server" DataIndex="DEF_PLACECD" Width="80" Align="Left" />  <%--Text="불량장소"--%> 
                                    <ext:NumberColumn ID="DEF_UCOST" ItemID="DEF_UCOST" runat="server" DataIndex="DEF_UCOST" Width="100" Align="Right" Format="#,###" />  <%--Text="불량단가"--%> 
                                    <ext:NumberColumn ID="DEF_QTY02" ItemID="DEF_QTY" runat="server" DataIndex="DEF_QTY" Width="80" Align="Right" Format="#,###"/>  <%--Text="불량수량"--%> 
                                    <ext:Column ID="NAME_KOR" ItemID="INSPECT_NAME" runat="server" DataIndex="NAME_KOR" Width="80" Align="Center" />  <%--Text="검사원"--%> 
                                    <ext:Column ID="LINECD" ItemID="LINECD" runat="server" DataIndex="LINECD" Width="100" Align="Center" />  <%--Text="라인코드"--%> 
                                    <ext:Column ID="ALCCD" ItemID="E_ALCCD" runat="server" DataIndex="ALCCD" Width="120" Align="Center" />  <%--Text="ALC코드"--%> 
                                    <ext:Column ID="YPNO" ItemID="ASSYPNO02" runat="server" DataIndex="YPNO" Width="80" Align="Center" />  <%--Text="완제품 품번"--%> 
                                    <ext:DateColumn ID="PROD_REG_DATE" ItemID="PROD_REG_DATE02" runat="server" DataIndex="PROD_REG_DATE" Width="80" Align="Center" />  <%--Text="생산등록일"--%> 
                                    <ext:Column ID="PROD_REG_EMPNO" ItemID="PROD_REG_EMPNO02" runat="server" DataIndex="PROD_REG_EMPNO" Width="80" Align="Center" />  <%--Text="생산등록자"--%> 
                                    <ext:Column ID="DEF_IMPUT_VENDCD" ItemID="DEF_IMPUT_VENDCD02" runat="server" DataIndex="DEF_IMPUT_VENDCD" Width="80" Align="Center" />  <%--Text="불량귀책업체"--%> 
                                    <ext:Column ID="MAT_REUSE_YN" ItemID="MAT_REUSE_YN02" runat="server" DataIndex="MAT_REUSE_YN" Width="60" Align="Center" />  <%--Text="자재사용유무"--%> 
                                    <ext:Column ID="DN_DIV" ItemID="DN_DIV" runat="server" DataIndex="DN_DIV" Width="80" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                    <ext:Column ID="OCCUR_DIV" ItemID=" " runat="server" DataIndex="OCCUR_DIV" Width="60" Align="Center" />  <%--Text="발생구분"--%> 
                                    <ext:Column ID="REF_NOTENO" ItemID="REF_NOTENO" runat="server" DataIndex="REF_NOTENO" Width="130" Align="Center" />  <%--Text="원본참조전표번호"--%> 
                                    <ext:DateColumn ID="RECEIPT_DATE02" ItemID="CONF_DATE" runat="server" DataIndex="RECEIPT_DATE" Width="80" Align="Left" />  <%--Text="확인일자"--%> 
                                    <ext:Column ID="RECEPT_TIME" ItemID="CONF_TIME" runat="server" DataIndex="RECEPT_TIME" Width="80" Align="Left" />  <%--Text="확인시간"--%> 
                                    <ext:Column ID="CORCD02" ItemID="CORCD" runat="server" DataIndex="CORCD" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                    <ext:Column ID="BIZCD02" ItemID="SAUP" runat="server" DataIndex="BIZCD" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                    <ext:Column ID="GUBUN" ItemID="GUBUN" runat="server" DataIndex="GUBUN" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                                    <ext:Column ID="IMG_LEN02" ItemID="IMG_LEN" runat="server" DataIndex="IMG_LEN" Width="60" Align="Left" Hidden="true" />  <%--Text=""--%> 
                            </Columns>
                            <%-- 그리드에서 editor에서 키를 다운했을 경우에 발생되는 핸들러가 막혀있어서 차후에 필요하다면 아래와 같이 사용
                            <Listeners>
                                <Render Handler="this.el.on('keydown', startEditing);" />
                            </Listeners>
                            --%>
                        </ColumnModel>

                        <%-- 그리드 검색시 보이는 progress--%>
                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true">
                            </ext:GridView>
                        </View>
                        <%-- SelectionModel은 checkbox, cell, row가 존재하고 그리드를 클릭시 그리드의 선택된 행의값이 json형태로 넘어감 (EP20S01참고)--%>
                        <SelectionModel>
                            <ext:CellSelectionModel  ID="CellSelectionModel1" runat="server">
                                <%-- 아래와 같이 리스너(자바스크립트 호출), DIRECT EVENT(서버단의 directMethod호출) 형태로 사용가능
                                <Listeners>
                                    <Select Handler=""></Select>
                                </Listeners>
                                <DirectEvents>
                                        <Select OnEvent="Cell_Click" />                        
                                </DirectEvents>
                                --%>
                            </ext:CellSelectionModel >
                            <%--<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server"><Listeners><Select Fn="CellFocus"></Select></Listeners></ext:CheckboxSelectionModel>--%>
                        </SelectionModel>
                            <Listeners>
                                <CellDblClick Fn ="CellDbClick"></CellDblClick>
                            </Listeners>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="StatusBar1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>

            <%--그리드와 내용사이에 하단 버튼영역이 필요할경우 아래 패널 사용(Hidden = "false") --%>
            <ext:Panel ID="BottomButtonPanel" runat="server" Region="South" Height="23" Cls="bottom_area_btn" Hidden="true">
                <Items>
                    <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5" ID="btnRowAdd">
                        <Listeners>
                            <Click Handler = "addNewRow(App.Grid01)" />
                        </Listeners>
                    </ext:ImageButton>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_deleterow.gif" ID="btnRowDelete">
                        <Listeners>
                            <Click Handler = "removeRow(App.Grid01,'ISNEW')" />
                        </Listeners>
                    </ext:ImageButton>
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
