<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_VM20004.aspx.cs" Inherits="Ax.EP.WP.Home.SRM_VM.SRM_VM20004" %>
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

    <title>협력업체 정보 관리</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <style type="text/css">
    .bottom_area_title_name2 {
        clear: both;
        margin-top: 10px;
        height: 18px;        
        background: url(../../images/common/title_icon_s.gif) 0 8px no-repeat;
        padding-left: 10px;
        font-size: 12px;
        color: #010101;
        text-align: left;
        font-weight: bold;
        };
        
    </style>
    <style type="text/css">
 
    .x-grid-cell-TITLE_NM DIV,	    
        .x-grid-cell-NAME DIV,	    
        .x-grid-cell-SYS_CODE DIV,	    
	    .x-grid-cell-OFFICETEL2 DIV,	    
	    .x-grid-cell-CHR_MOBILE DIV,	    
        .x-grid-cell-E_MAIL DIV,	    
        .x-grid-cell-AS_CHK,	    
        .x-grid-cell-SP_CHK,	  
        .x-grid-cell-CKD_CHK,	      
	    .x-grid-cell-REMARK DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
		    
	    };
	    
    </style>
    <style type="text/css">
        .merge-row .x-grid-cell-JOBDIV,
        .merge-row .x-grid-cell-SEQNO3
        {
            border-bottom-color:silver;
            border-bottom-width:0px;   
        };
    </style>
    <style type="text/css">
        .none-merge-row .x-grid-cell-JOBDIV,
        .none-merge-row .x-grid-cell-SEQNO3
        {
            border-bottom-color:darkgray;
            border-bottom-width:1px;   
        };
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
       

        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }




        /*-------------------------------------------
        --------------------------------------------------------------------------------------------------------
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

        // 그리드의 cell에 포커스가 갈 경우에 자동으로 editor가 실행이 되도록 한다. 
        // 원인: 그리드 내의 콤보박스는 editor을 포함하지 않아 eiditorTab 이벤트가 실행이되지 않음. 따라서 콤보박스에서 tab을 눌렀을 경우에 
        // editor가 포함된 cell에 포커스가 가면 editor가 실행이 되고 이후에 tab을 클릭하면 editor가 포함된 cell로 자동으로 이동이 된다.
        var CellFocus = function (selectionModel, record, rowIndex, colIndex) {
            var grid = selectionModel.view.ownerCt;

            grid.editingPlugin.startEdit(rowIndex, colIndex);
        }

        var getRowClass = function (record) {
            if (record.data["SEQNO"] == record.data["COL_CNT"]) {
                return "none-merge-row";
            }
            else {
                return "merge-row";
            }
        };

        //화면 로딩시 업체로 로그인한 경우 기본으로 해당 업체코드가 박혀 있으므로 자동 조회되도록 함.
        function DefaultSearch() {
            if (App.cdx01_VENDCD_TYPECD.value != undefined && App.cdx01_VENDCD_TYPECD.value != "") {
                App.ButtonSearch.fireEvent('click');
            }
        }
    </script>
</head>
<body>
    <form id="SRM_VM20004" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();DefaultSearch();" />
        </Listeners>
    </ext:ResourceManager>

    

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>           
        </Listeners>
        <Items>
            <%--타이틀 및 공통버튼 영역--%>
            <ext:Panel ID="TitlePanel" Region="North" runat="server" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_VM20004" runat="server" Cls="search_area_title_name"/><%--Text="업체 기본현황 작성" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>

            <%--조회조건 영역--%>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />    
                            <col style="width: 400px;" />                        
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" Text="Vender Code"/><%--Text="Vender Code" />--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"
                                                OnAfterValidation="cdx01_VENDCD_AfterValidation"/>
                            </td>   
                            <td >                               
                              
                            </td>
                        </tr>                        
                    </table>
                </Content>
            </ext:Panel>

   

            <%--1.기본정보--%>
            <ext:Label ID="lbl01_BASE_INFO" runat="server" Cls="bottom_area_title_name" Region="North"/><%--Text="기본정보"--%>
            <ext:Panel ID="pnl01_BASE_INFO" Region="North" Cls="excel_upload_area_table" runat="server" >
                <Content>
                    <table>
                        <colgroup>
                            <col style="width: 150px;" />                          
                            <col style="width: 200px;" />
                            <col style="width: 150px;"/>
                            <col style="width: 200px;"/>
                            <col style="width: 150px;"/>     
                            <col />
                        </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_REPNM" runat="server" /><%--Text="대표자"--%>
                            </th>
                            <td >
                                 <ext:Label ID="LABEL_REP_NAME" runat="server"  StyleSpec="margin-left:6px;"/>
                            </td>
                            <th >
                                <ext:Label ID="lbl01_REP_TELNO" runat="server" /><%--Text="대표전화번호"--%>
                            </th>
                            <td >
                                <ext:Label ID="LABEL_TEL" runat="server" StyleSpec="margin-left:6px;"/>
                            </td>
                            <th >
                                <ext:Label ID="lbl01_FAXNO" runat="server" /><%--Text="FAX"--%>
                            </th>
                            <td >
                                <ext:Label ID="LABEL_FAX" runat="server" StyleSpec="margin-left:6px;"/>
                            </td>
                                
                        </tr>
                        <tr>
                            <th >
                                <ext:Label ID="lbl01_BIZ_ADDR" runat="server" /><%--Text="사업장 주소"--%>
                            </th>
                           
                            <td colspan="5">
                                <ext:Label ID="LABEL_ADDR" runat="server" StyleSpec="margin-left:6px;"/>
                            </td>                                    
                        </tr>
                       
                    </table>
                </Content>
            </ext:Panel>
                   

            <%--2.비상연락망--%>
            <ext:Label ID="lbl01_EMERGENCY" runat="server" Cls="bottom_area_title_name" Region="North"/><%--Text="비상연락망"--%>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area" >
                <Items>  
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." >
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="Model22" runat="server" Name="ModelGrid03">
                                        <Fields>
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>

                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="TEAM_DIVCD" />
                                            <ext:ModelField Name="TEAM_DIVNM" />
                                            <ext:ModelField Name="COL_CNT" />
                                            <ext:ModelField Name="SEQNO" />
                                            <ext:ModelField Name="TITLE_NM" />
                                            <ext:ModelField Name="NAME" />
                                            <ext:ModelField Name="CHARGE_JOB" />      
                                            <ext:ModelField Name="TELNO" />      
                                            <ext:ModelField Name="CELLNO" />      
                                            <ext:ModelField Name="E_MAIL" />      
                                            <ext:ModelField Name="AS_CHK" />      
                                            <ext:ModelField Name="SP_CHK" />      
                                            <ext:ModelField Name="CKD_CHK" />      
                                            <ext:ModelField Name="REMARK" />      

                                            <%--DELETE ROW가 존재시--%>
                                            <ext:ModelField Name="ISNEW" Type="Boolean" />                               
                                        </Fields>
                                    </ext:Model>
                                </Model>
                                <Listeners>
                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                    <Load Delay="1" Handler="GridStoreReady(App.GridStatus3, this.getTotalCount()); "></Load>
                                </Listeners>
                            </ext:Store>
                        </Store>
                        <Plugins>
                            <ext:BufferedRenderer ID="BufferedRenderer3"  runat="server"/>
                            <ext:CellEditing ID="CellEditing3" runat="server" ClicksToEdit="1" >
                                <Listeners>                                    
                                    <BeforeEdit fn="BeforeEdit" />
                                    <Edit fn ="AfterEdit" />                                    
                                </Listeners> 
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel3" runat="server">
                            <Columns>
                                <%--NO컬럼--%>
                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="0" Align="Center">
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <%--선택체크박스--%>
                                <ext:CheckColumn runat="server" ID ="CheckColumn2" Text=""  DataIndex="CHECK_VALUE" Width="35" 
                                                    StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true"  Sortable="false"  Editable="true" Visible="false">
                                                        
                                </ext:CheckColumn>                                                 
                                <%-- 일반 LABEL--%>
                                <ext:Column ID="TEAM_DIVNM" ItemID="JOBDIV" DataIndex="TEAM_DIVNM" runat="server" Width="130" Align="Center" /><%--Text="업무구분" --%>
                                <ext:Column ID="SEQNO" ItemID="SEQNO3" DataIndex="SEQNO" runat="server" Width="45" Align="Center" /><%--Text="업무구분" --%>
                                        
                                <%-- 업무담당(직책/성명) --%>
                                <ext:Column ID="WORK_CHARGE" ItemID="WORK_CHARGE" runat="server">
                                    <Columns>
                                        <%-- 직위 --%>
                                        <ext:Column ID="TITLE_NM" ItemID="TITLE_NM" DataIndex="TITLE_NM" runat="server" Width="110" Align="Left" >
                                            <Editor>
                                                <ext:TextField ID="TextField8" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                            </Editor>
                                        </ext:Column>
                                        <%-- 성명 --%>
                                        <ext:Column ID="NAME" ItemID="NAME" DataIndex="NAME" runat="server" Width="120" Align="Left">
                                            <Editor>
                                                <ext:TextField ID="TextField9" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                            </Editor>
                                        </ext:Column>
                                    </Columns>
                                </ext:Column> 

                                <%-- 업무 --%>
                                <ext:Column ID="CHARGE_JOB" ItemID="SYS_CODE" DataIndex="CHARGE_JOB" runat="server" Width="120" Align="Left" >
                                    <Editor>
                                        <ext:TextField ID="TextField3" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>
                                        
                                <%-- 연락처 OFFICETEL2 CHR_MOBILE E_MAIL--%>
                                <ext:Column ID="CHR_TEL" ItemID="CHR_TEL" runat="server">
                                    <Columns>
                                        <%-- 사무실 전화번호 --%>
                                        <ext:Column ID="TELNO" ItemID="OFFICETEL2" DataIndex="TELNO" runat="server" Width="120" Align="Left" >
                                            <Editor>
                                                <ext:TextField ID="TextField4" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                            </Editor>
                                        </ext:Column>

                                        <%-- HP --%>
                                        <ext:Column ID="CELLNO" ItemID="CHR_MOBILE" DataIndex="CELLNO" runat="server" Width="150" Align="Left" >
                                            <Editor>
                                                <ext:TextField ID="TextField5" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                            </Editor>
                                        </ext:Column>

                                        <%-- E-MAIL --%>
                                        <ext:Column ID="E_MAIL" ItemID="E_MAIL" DataIndex="E_MAIL" runat="server" Width="150" Align="Left" >
                                            <Editor>
                                                <ext:TextField ID="TextField6" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                            </Editor>
                                        </ext:Column>
                                    </Columns>
                                </ext:Column>

                                <%-- 납품 업무 구분--%>
                                <ext:Column ID="DELI_WORK" ItemID="DELI_WORK" runat="server">
                                    <Columns>
                                        <%--AS --%>
                                        <ext:CheckColumn runat="server" ID ="chk02_AS" ItemID="AS_CHK" DataIndex="AS_CHK" Width="65"
                                                         StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >  <%--Text="CKD" --%>    
                                        </ext:CheckColumn> 

                                        <%-- SP --%>
                                        <ext:CheckColumn runat="server" ID ="chk02_SP" ItemID="SP_CHK" DataIndex="SP_CHK" Width="65"
                                                         StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >  <%--Text="CKD" --%>    
                                        </ext:CheckColumn> 

                                        <%-- CKD --%>
                                        <ext:CheckColumn runat="server" ID ="chk02_CKD" ItemID="CKD_CHK" DataIndex="CKD_CHK" Width="65"
                                                         StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >  <%--Text="CKD" --%>    
                                        </ext:CheckColumn> 
                                    </Columns>
                                </ext:Column>

                                <%-- 비고 --%>
                                <ext:Column ID="REMARK" ItemID="REMARK" DataIndex="REMARK" runat="server" Width="500" Align="Left" Flex="1" MinWidth="200">
                                    <Editor>
                                        <ext:TextField ID="TextField7" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column>


                            </Columns>                                           
                        </ColumnModel>
                        <Loader ID="Loader3" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView3" runat="server"  EnableTextSelection="true">
                                <GetRowClass Fn="getRowClass" />
                            </ext:GridView>
                        </View>
                        <SelectionModel>                            
                            <ext:CellSelectionModel  ID="CellSelectionModel2" runat="server">
                                <Listeners><Select Fn="CellFocus"></Select></Listeners>
                            </ext:CellSelectionModel >
                        </SelectionModel>                                                   
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus3" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>  
               
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
