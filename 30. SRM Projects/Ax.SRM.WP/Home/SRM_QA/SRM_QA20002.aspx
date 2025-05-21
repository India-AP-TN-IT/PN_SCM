<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA20002.aspx.cs" Inherits="Ax.QA.WP.Home.SRM_MP.SRM_QA20002" %>
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
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">    
	    .x-grid-cell-STD_FILENM DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    } 
    </style>
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

        function fn_PopupHandler(BIZCD, VENDCD, DOCNO, RCV_DATE, INSPECT_DIV, DEFCD, DOCNO2, VENDCDSTATUSCD, FIRMSTATUSCD, CHKBTN) {
            App.V_BIZCD.setValue(BIZCD);
            App.V_VENDCD.setValue(VENDCD);
            App.V_DOCNO.setValue(DOCNO);
            App.V_RCV_DATE.setValue(RCV_DATE);
            App.V_INSPECT_DIV.setValue(INSPECT_DIV);
            App.V_DEFCD.setValue(DEFCD);
            App.V_DOCNO2.setValue(DOCNO2);
            App.V_VENDCDSTATUSCD.setValue(VENDCDSTATUSCD);
            App.V_FIRMSTATUSCD.setValue(FIRMSTATUSCD);
            App.CHKBTN.setValue(CHKBTN);

            App.btn01_POP_QA20002P1.fireEvent('click');
        }

        function fn_PopupHandler2(BIZCD, DEFNO) {
            App.V_BIZCD.setValue(BIZCD);
            App.V_DEFNO.setValue(DEFNO);

            App.btn01_POP_QA20002P2.fireEvent('click');
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 그리드 cell 더블 클릭 시
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;
            //var cellIndex = obj4.target.offsetParent.cellIndex;

            var columnName = grid.columns[cellIndex].dataIndex;
            
            var docno = grid.getStore().getAt(rowIndex).data["DOCNO"];
            var ver2_chkrslt = grid.getStore().getAt(rowIndex).data["VER2_CHKRSLT"];

            if (columnName != "FILENAME") {
                if (docno == null || docno == "") {
                    App.direct.MsgCodeAlert("SRMMP00-0015");
                    return;
                }
                else {
                    if (App.cdx01_VENDCD_OBJECTID.getValue() == "") return;

                    var BIZCD = grid.getStore().getAt(rowIndex).data["BIZCD"];     //사업장
                    var VENDCD = grid.getStore().getAt(rowIndex).data["VENDCD"];     //업체
                    var DOCNO = grid.getStore().getAt(rowIndex).data["DOCNO"];     //문서발행번호
                    var RCV_DATE = grid.getStore().getAt(rowIndex).data["RCV_DATE"];   //일자
                    var INSPECT_DIV = grid.getStore().getAt(rowIndex).data["INSPECT_DIV"];
                    var DEFCD = grid.getStore().getAt(rowIndex).data["DEFCD"];     //불량번호
                    var DOCNO2 = grid.getStore().getAt(rowIndex).data["DOCNO2"];    //문서발행번호
                    var VENDCDSTATUSCD = grid.getStore().getAt(rowIndex).data["VENDCDSTATUSCD"];  //업체상태
                    var FIRMSTATUSCD = grid.getStore().getAt(rowIndex).data["FIRMSTATUSCD"];  //당사상태

                    var CHKBTN = "";

                    if (grid.getStore().getAt(rowIndex).data["VENDCDSTATUSCD"] == "FHY") //업체상태 작성
                        CHKBTN = "CR";

                    if (grid.getStore().getAt(rowIndex).data["VENDCDSTATUSCD"] == "FHN") //업체상태 회신
                        CHKBTN = "SR";

                    fn_PopupHandler(BIZCD, VENDCD, DOCNO, RCV_DATE, INSPECT_DIV, DEFCD, DOCNO2, VENDCDSTATUSCD, FIRMSTATUSCD, CHKBTN);
                }
            }
            else {
                if (ver2_chkrslt == null || ver2_chkrslt == "") {
                    App.direct.MsgCodeAlert("SRMQA00-0051");
                    return;
                }
                else if(ver2_chkrslt == "완료") {
                    if (App.cdx01_VENDCD_OBJECTID.getValue() == "") return;

                    var BIZCD = grid.getStore().getAt(rowIndex).data["BIZCD"];     //사업장
                    var DEFNO = grid.getStore().getAt(rowIndex).data["DEFNO"];     //업체

                    fn_PopupHandler2(BIZCD, DEFNO);
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

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 첨부파일 저장 후
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var fn_QA20002P2_R = function (id) {

            App.direct.FileNmUpdate();

            Ext.getCmp(id).hide();
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 그리드의 입력 형태별 css 유무
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/

        var getRowClass = function (record) {
            return "edit-row";
        };

    </script>
</head>
<body>
    <form id="SRM_QA20002" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:ImageButton ID="btn01_POP_QA20002P1" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:ImageButton ID="btn01_POP_QA20002P2" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:TextField   ID="V_BIZCD"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_DOCNO 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_VENDCD"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_DOCNO 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_DOCNO"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_DOCNO 값을 팝업에 넘기기 위해서 사용--%>
    <ext:DateField   ID="V_RCV_DATE"            runat="server" Hidden="true" ></ext:DateField> <%--팝업호출시 그리드의 V_RCV_DATE 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_INSPECT_DIV"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_INSPECT_DIV 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_DEFCD"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_DEFCD 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_DOCNO2"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_DOCNO2 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_VENDCDSTATUSCD"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_VENDCDSTATUSCD 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_FIRMSTATUSCD"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_FIRMSTATUSCD 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="CHKBTN"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_PONO 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_DEFNO"            runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_DEFNO 값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="CodeCol" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col index (사용하지 않으나 차후 필요할지 몰라서)--%>
    <ext:TextField ID="CodeColName" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col Name--%>
    <ext:TextField   ID="UserHelpURL"         runat="server" Hidden="true" Text="../SRM_QA/SRM_QA20002P1.aspx"></ext:TextField> 
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
                    <ext:Label ID="lbl01_SRM_QA20002" runat="server" Cls="search_area_title_name" Text="테스트" />
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
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"
                                                OnAfterValidation="CodeBox_AfterValidation"/>
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">                                
                                <ext:Label ID="lbl01_DEAD_STD" runat="server" /> <%--Text="마감기준" --%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_REV_DATE" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_MEASURE_DOCNO" runat="server" Text="Vendor Plant" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_DOCNO" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="DOCNONM" ValueField="DOCNO" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model5" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="DOCNO" />
                                                        <ext:ModelField Name="DOCNONM" />
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
                            <ext:Store ID="Store1" runat="server" PageSize="250">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server" Name ="ModelGrid">
                                        <Fields>
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="SCHK" /> <%--선택체크박스--%>

                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="DOCNO"/>
                                            <ext:ModelField Name="VENDCDSTATUSCD"/>
                                            <ext:ModelField Name="VENDCDSTATUSNM"/>
                                            <ext:ModelField Name="FIRMSTATUSCD"/>
                                            <ext:ModelField Name="FIRMSTATUSNM"/>
                                            <ext:ModelField Name="RCV_DATE"/>
                                            <ext:ModelField Name="INSPECT_DIVNM"/>
                                            <ext:ModelField Name="PARTNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="VINCD"/>
                                            <ext:ModelField Name="DEFNM"/>
                                            <ext:ModelField Name="DEF_PLACENM"/>
                                            <ext:ModelField Name="INSPECT_NM"/>
                                            <ext:ModelField Name="BIZCD"/>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="DEFNO"/>
                                            <ext:ModelField Name="INSPECT_DIV"/>
                                            <ext:ModelField Name="DEFCD"/>
                                            <ext:ModelField Name="INSPECT_EMPNO"/>
                                            <ext:ModelField Name="DOCNO2"/>
                                            <ext:ModelField Name="VER2_CHKRSLT"/>
                                            <ext:ModelField Name="FILENAME"/>
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
                            <ext:BufferedRenderer ID="BufferedRenderer1" runat="server" />
                            <%-- 2.X버전부터는 그리드에서 edtior를 활성화 시키기위해서 cellEditing Plugin을 추가 하여 사용하고 자바스크립트에서 grid.editingPlugin 형태로 사용할수 있다. --%>
                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                <Listeners>                                    
                                    <BeforeEdit fn="BeforeEdit" />
                                    <Edit fn ="AfterEdit" />                                    
                                </Listeners> 
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:CheckColumn runat="server" ID ="SCHK" ItemID="CHK" DataIndex="SCHK" Width="65"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >  <%--Text="견적불가" --%>    
                                        <Listeners>
                                            <CheckChange Fn="chkMethod" />
                                        </Listeners>      
                                </ext:CheckColumn> 
                                <ext:Column ID="DOCNO" ItemID="MEASURE_DOCNO" runat="server" DataIndex="DOCNO" Width="130" Align="Center" />  <%--Text="대책서번호"--%> 
                                <ext:Column ID="VENDCDSTATUSCD" ItemID="VENDCDSTATUSCD" runat="server" DataIndex="VENDCDSTATUSCD" Width="0" Align="Center" Hidden="true" />  <%--Text="업체상태 코드"--%> 
                                <ext:Column ID="VENDCDSTATUSNM" ItemID="VENDCDSTATUSNM" runat="server" DataIndex="VENDCDSTATUSNM" Width="60" Align="Center" />  <%--Text="업체상태"--%> 
                                <ext:Column ID="FIRMSTATUSCD" ItemID="FIRMSTATUSCD" runat="server" DataIndex="FIRMSTATUSCD" Width="60" Align="Center" Hidden="true" />  <%--Text="처리상태 코드"--%> 
                                <ext:Column ID="FIRMSTATUSNM" ItemID="PROC_STA" runat="server" DataIndex="FIRMSTATUSNM" Width="60" Align="Center" />  <%--Text="처리상태"--%> 
                                <ext:DateColumn ID="RCV_DATE" ItemID="RCV_DATE" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" />  <%--Text="입고일자"--%> 
                                <ext:Column ID="INSPECT_DIVNM" ItemID="DIVISION" runat="server" DataIndex="INSPECT_DIVNM" Width="80" Align="Center" />  <%--Text="구분"--%> 
                                <ext:Column ID="PARTNO" ItemID="PARTNO5" runat="server" DataIndex="PARTNO" Width="120" Align="Left" />  <%--Text="Part-No"--%> 
                                <ext:Column ID="PARTNM" ItemID="PARTNM2" runat="server" DataIndex="PARTNM" MinWidth="200" Align="Left" Flex="1"/>  <%--Text="Part-Name"--%> 
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="60" Align="Center" />  <%--Text="차종"--%> 
                                <ext:Column ID="DEFNM" ItemID="DEF_CNTT" runat="server" DataIndex="DEFNM" MinWidth="200" Align="Left" Flex="1" />  <%--Text="불량내용"--%> 
                                <ext:Column ID="DEF_PLACENM" ItemID="DEF_PLACE" runat="server" DataIndex="DEF_PLACENM" Width="60" Align="Left" />  <%--Text="불량장소"--%> 
                                <ext:Column ID="INSPECT_NM" ItemID="WRITE_EMP" runat="server" DataIndex="INSPECT_NM" Width="60" Align="Center" />  <%--Text="작성자"--%> 
                                <ext:Column ID="FILENAME" ItemID="STD_FILENM" runat="server" DataIndex="FILENAME" Width="120" Align="Center" />  <%--Text="표준화 및 수평전개"--%> 
                                <ext:Column ID="BIZCD" ItemID="SAUP" runat="server" DataIndex="BIZCD" Width="0" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="VENDCD" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="0" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="DEFNO" ItemID="DEFNO" runat="server" DataIndex="DEFNO" Width="0" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="INSPECT_DIV" ItemID="INSPECT_DIV" runat="server" DataIndex="INSPECT_DIV" Width="60" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="DEFCD" ItemID="DEFCD" runat="server" DataIndex="DEFCD" Width="0" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="INSPECT_EMPNO" ItemID="INSPECT_EMPNO" runat="server" DataIndex="INSPECT_EMPNO" Width="0" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="DOCNO2" ItemID="DOCNO2" runat="server" DataIndex="DOCNO2" Width="0" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="VER2_CHKRSLT" ItemID="VER2_CHK_DATE2" runat="server" DataIndex="VER2_CHKRSLT" Width="100" Align="Center" />  <%--Text=""--%> 
                            </Columns>
                            <%-- 그리드에서 editor에서 키를 다운했을 경우에 발생되는 핸들러가 막혀있어서 차후에 필요하다면 아래와 같이 사용
                            <Listeners>
                                <Render Handler="this.el.on('keydown', startEditing);" />
                            </Listeners>
                            --%>
                            <Listeners>
                                <%--<HeaderClick Fn="onSelectionCheckHeaderChange" />--%> <%--그리드 헤더의 체크박스를 클릭할 경우 발생--%>
                            </Listeners>
                        </ColumnModel>

                        <%-- 그리드 검색시 보이는 progress--%>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">
                                <GetRowClass Fn="getRowClass"/>
                            </ext:GridView>
                        </View>
                        <%-- SelectionModel은 checkbox, cell, row가 존재하고 그리드를 클릭시 그리드의 선택된 행의값이 json형태로 넘어감 (EP20S01참고)--%>
                        <SelectionModel>
                        <%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">                               
                                <Listeners><Select Fn="CellFocus"></Select></Listeners>
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
