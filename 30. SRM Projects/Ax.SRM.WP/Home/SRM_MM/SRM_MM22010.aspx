<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM22010.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM22010" %>
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
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
        .x-grid-cell-UNIT_PACK_QTY_SIM DIV,
	    .x-grid-cell-DELI_QTY DIV,
	    .x-grid-cell-VEND_LOTNO DIV,
	    .x-grid-cell-CHANGE_4M DIV,
	    .x-grid-cell-PRDT_DATE DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }
	    
	    /* word-wrap 적용 */
	    #FTA_CERTI-titleEl
	    {
            padding-top:11px;
	    }
	    #FTA_CERTI-textEl
	    {
           white-space: initial;
        }
    </style>
    <style type="text/css">
        .font-color-blue .x-grid-cell-CHECK_CERT
        {
            color:#0000FF;
            text-decoration: underline;
        }
        
        .font-color-black .x-grid-cell-CHECK_CERT
        {
            color:#FF0000;
            text-decoration: none;
        }
    </style>
    <style type="text/css">
        .bottom_area_title_name2 { clear:both;  margin-top:0px; height:20px; display:block; background:url(../../images/common/title_icon_s.gif) 0 8px no-repeat; padding-left:10px;font-size:12px;color:#010101;text-align:left;font-weight:bold;}
    </style>
    <!--그리드 필수 입력필드-->
    <style type="text/css">
        #DELI_QTY, #PRDT_DATE
        {
            background: url(../../images/common/point_icon.png) right 10px no-repeat;
        }
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
            //(입고 완료된 납품서는 조회되지 않습니다.)
            //App.ConditionPanel.setHeight(App.ConditionPanel.getHeight() + 5);
            //document.getElementById('ConditionPanel').style.marginTop = 5 + 'px';
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

        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        var AfterEdit = function (rowEditor, e) {
            // true 일 때만 반대편 값을 false 시킴
            var column = '';
            if (e.value) {
                switch (e.column.dataIndex) {
                    case 'DATA_APPLY': column = 'DATA_CANCEL'; break;
                    case 'DATA_CANCEL': column = 'DATA_APPLY'; break;
                }
                e.grid.getStore().getAt(e.rowIdx).set(column, false);
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드에서 실행 버튼을 클릭했을때
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var gridRightButton_Handler = function (editor, command, row, rowIndex, colIndex) {
            var grd = App.Grid01; // editor.grid; 4.X

            var bukrs = grd.getStore().getAt(rowIndex).data["BUKRS"];
            var werks = grd.getStore().getAt(rowIndex).data["WERKS"];
            var deliNote = grd.getStore().getAt(rowIndex).data["DELI_NOTE"].split('-')[0];
            var deliNoteSeq = grd.getStore().getAt(rowIndex).data["DELI_NOTE"].split('-')[1];
            var ifDate = grd.getStore().getAt(rowIndex).data["IF_DATE"];
            var ifTime = grd.getStore().getAt(rowIndex).data["IF_TIME"];

            App.direct.Grid01_Excute_Click(bukrs, werks, deliNote, deliNoteSeq, ifDate, ifTime);
        }

    </script>
</head>
<body>
    <form id="SRM_MM22010" runat="server">
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
    <%--<ext:TextField ID="hidMODE" runat="server" Hidden="true" Text="Regist" /> 등록 또는 수정 모드 기록용--%>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MM22010" runat="server" Cls="search_area_title_name" /><%--Text="납품서 수정 및 재발행" />--%>
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
                            <col style="width: 300px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="80" 
                                 OnAfterValidation="changeCondition"/>
                            </td>   
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
                                        <Select OnEvent="changeCondition" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td>  
                            <th  class="ess">         
                                <ext:Label ID="lbl01_PURC_PO_TYPE" runat="server" /><%--Text="구매오더유형" /> --%>                      
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PURC_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="160">
                                    <Store>
                                        <ext:Store ID="Store6" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model6" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_PURC_PO_TYPE_Change" />
                                    </DirectEvents>                          
                                </ext:SelectBox>
                            </td>
                            <th  class="ess">         
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" /><%--Text="구매조직" /> --%>                      
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
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
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_PURC_ORG_Change" />
                                    </DirectEvents>                                    
                                </ext:SelectBox>
                            </td>  
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_STR_LOC" runat="server" /><%--Text="저장위치" /> --%>                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_STR_LOC" runat="server" HelperID="HELP_STR_LOC" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="80" 
                                 OnBeforeDirectButtonClick="cdx01_STR_LOC_BeforeDirectButtonClick" OnAfterValidation="changeCondition"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_DELI_NOTE2" runat="server" /><%--Text="PART NO" />--%>                       
                            </th>
                            <td>
                                <ext:TextField ID="txt01_DELI_NOTE2" Width="120" Cls="inputText" runat="server" />    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_ZRSLT_SAP" runat="server" /><%--Text="SAP 처리상태" />--%>                       
                            </th>
                            <td colspan="3">
                                <ext:ComboBox ID="cbo01_ZRSLT_SAP" runat="server"  Mode="Local" 
                                    TriggerAction="All" Width="150" Editable="false" >
                                    <Items>                                    
                                        <ext:ListItem Value="S" Text="성공(Success)" />
                                        <ext:ListItem Value="" Text="NULL" />
                                    </Items>
                                </ext:ComboBox>
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area" StyleSpec="margin-bottom:10px;">
                <Items>                   
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>                                       
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="DELI_DATE" />
                                            <ext:ModelField Name="DELI_CNT" />                                            
                                            <ext:ModelField Name="DELI_NOTE" />
                                            <ext:ModelField Name="STR_LOCNM" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="DELI_TYPE" />
                                            <ext:ModelField Name="BUKRS" />
                                            <ext:ModelField Name="WERKS" />
                                            <ext:ModelField Name="IF_DATE" />
                                            <ext:ModelField Name="IF_TIME" />
                                            <ext:ModelField Name="DATA_APPLY" Type="Boolean" />
                                            <ext:ModelField Name="DATA_CANCEL" Type="Boolean" />
                                            <ext:ModelField Name="PONO_S" />                                            
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />
                                            <ext:ModelField Name="QTY" />
                                            <ext:ModelField Name="UNIT" />
                                            <ext:ModelField Name="RESULT_MSG" />
                                            <ext:ModelField Name="INSERT_DATE" />
                                            <ext:ModelField Name="INSERT_USERID" />
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
                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                <Listeners>                                    
                                    <BeforeEdit fn="BeforeEdit" />
                                    <Edit fn ="AfterEdit" />
                                </Listeners>
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:Column ID="VENDCD" ItemID="VENDCD6" runat="server" DataIndex="VENDCD" Width="80"  Align="Center" /><%--Text="업체코드"--%>
                                <ext:Column ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="100" Align="Left" /><%--Text="업체명"--%>
                                <ext:Column ID="DELI_DATE" ItemID="DELI_DATE" runat="server" DataIndex="DELI_DATE" Width="80" Align="Center" /><%--Text="납품일자"--%>
                                <ext:Column ID="DELI_CNT" ItemID="DELI_CNT" runat="server" DataIndex="DELI_CNT" Width="65" Align="Center" /><%--Text="납품차수"--%>
                                <ext:Column ID="DELI_NOTE" ItemID="DELI_NOTE" runat="server" DataIndex="DELI_NOTE" Width="180" Align="Left" /><%--Text="납품서번호"--%>
                                <ext:Column ID="STR_LOCNM" ItemID="STR_LOCNM" runat="server" DataIndex="STR_LOCNM" Width="120" Align="Left" /><%--Text="저장위치" --%>
                                <ext:Column ID="CUSTNM" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="120" Align="Left" /><%--Text="고객사"--%>
                                <ext:Column ID="DELI_TYPE" ItemID="DELI_TYPE" runat="server" DataIndex="DELI_TYPE" Width="80" Align="Center" /><%--Text="납품서유형"--%>
                                <%-- 그리드에 이미지를 클릭할 수 있는 column--%>
                                <ext:ImageCommandColumn ID="ImageCommandColumn1" ItemID="PROCESS" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="50" Align="Center" Hidden="true" >
                                   <Commands>
                                      <ext:ImageCommand Icon="ScriptGo" ToolTip-Text="Excute" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                   </Commands>
                                   <Listeners>
                                      <Command Fn="gridRightButton_Handler" />                                         
                                   </Listeners>
                                </ext:ImageCommandColumn>

                                <ext:CheckColumn runat="server" ID ="DATA_APPLY" ItemID="DATA_APPLY" Text="적용확정"  DataIndex="DATA_APPLY" Width="75"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >
                                </ext:CheckColumn>
                                <ext:CheckColumn runat="server" ID ="DATA_CANCEL" ItemID="DATA_CANCEL" Text="미처리"  DataIndex="DATA_CANCEL" Width="75"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >
                                </ext:CheckColumn>

                                <ext:Column ID="PONO_S" ItemID="PONO" runat="server" DataIndex="PONO_S" Width="110" Align="Left" Text="PONO"  />
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" Text="Part No"  />
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="140" Align="Left" Flex="1" Text="Part Name" />
                                <ext:NumberColumn ID="QTY" ItemID="QTY" runat="server" DataIndex="QTY" Width="80" Align="Right" Format="#,##0.###" Sortable="true" Text="Quantity" />
                                <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="55" Align="Center" Text="Unit" />
                                <ext:Column ID="RESULT_MSG" ItemID="RESULT_MSG" runat="server" DataIndex="RESULT_MSG" MinWidth="140" Flex="1" Align="Left" Text="Result Message" />
                                <ext:Column ID="INSERT_DATE" ItemID="INSERT_DATE" runat="server" DataIndex="INSERT_DATE" MinWidth="120" Align="Left" Text="Insert Date" />
                                <ext:Column ID="INSERT_USERID" ItemID="INSERT_USERID" runat="server" DataIndex="INSERT_USERID" MinWidth="80" Align="Left" Text="Insert User" />

                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server"  EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
                        <%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server" />
                        </SelectionModel>
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
