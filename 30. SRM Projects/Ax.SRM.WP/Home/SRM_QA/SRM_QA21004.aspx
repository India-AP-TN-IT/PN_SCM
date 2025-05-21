<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA21004.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_QA.SRM_QA21004" %>
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
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">    
	    .x-grid-cell-OUT_TYPENM DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }
	    
    </style>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.

        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        };

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
            App.Grid02.setHeight(App.GridPanel.getHeight());
        }

        var fn_ClaimOccurDivChange = function () {
            App.direct.SetComboVisibleClaimOccurDiv();
        };

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

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드의 editor를 활성화시키는 시점에서 작동        
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        var AfterEdit = function (rowEditor, e) {
            // 그리드를 editor한 후에 발생되는 이벤트
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
    <form id="SRM_QA21004" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="UserHelpURL" runat="server" Hidden="true" Text="SRM_QA21004P1.aspx"></ext:TextField> 
    <ext:TextField ID="UserHelpURL02" runat="server" Hidden="true" Text="SRM_QA21004P2.aspx"></ext:TextField> 
    <ext:TextField ID="PopupWidth" runat="server" Hidden="true" Text="500"></ext:TextField> 
    <ext:TextField ID="PopupHeight" runat="server" Hidden="true" Text="450"></ext:TextField> 
    <ext:TextField ID="PopupWidth02" runat="server" Hidden="true" Text="600"></ext:TextField> 
    <ext:TextField ID="PopupHeight02" runat="server" Hidden="true" Text="650"></ext:TextField> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_QA21004" runat="server" Cls="search_area_title_name" /><%--Text="X-bar R관리 조회/등록" />--%>
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
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_SAUP" runat="server" /> <%--Text="사업장"--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
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
                                <ext:Label ID="lbl01_INQ_YYMM" runat="server"  /> <%--Text="조회년월"--%>
                            </th>
                            <td>
                                <table>
                                    <tr>
                                        <td width="115">
                                            <ext:DateField ID="df01_INQ_YYMM_BEG" Width="115" Type="Month" runat="server" Editable="true" Cls="data2" />                                     
                                        </td>
                                        <td align="center" width="20">~</td>
                                        <td width="115">
                                            <ext:DateField ID="df01_INQ_YYMM_TO" Width="115" Type="Month" runat="server" Editable="true" Cls="data2" />                                    
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_VEND" runat="server"  /> <%--Text="업체"--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>                                                  
                        </tr>                        
                        <tr>     
                            <th class="ess">
                                <ext:Label ID="lbl01_DOCRPTNO" runat="server"  /> <%--Text="통보서번호"--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_DOCRPTNO" runat="server" HelperID="USER_DOCRPTNO" PopupMode="Search" PopupType="UserWindow"
                                                OnBeforeDirectButtonClick="CodeBox_BeforeDirectButtonClick"
                                                OnCustomRemoteValidation="CodeBox_CustomRemoteValidation"
                                                UserHelpURL="SRM_QA21004P1.aspx"
                                                VisiableText="false"
                                                WidthTYPECD="120px"/>
                            </td>    
                            <th class="ess">
                                <ext:Label ID="lbl01_FORMOBJNO" runat="server"  /> <%--Text="이의제기번호"--%>
                            </th>       
                            <td>                               
                                <ext:TextField ID="txt01_FORMOBJNO" Width="115"  Cls="inputText" runat="server" Editable="true" MaskRe="/[0-9]/"  />                                     
                            </td>                                                                          
                        </tr>
                        <tr>        
                            <th>
                               <ext:Label ID="lbl01_OCCUR_DIV" runat="server"  /> <%--Text="발생구분"--%>
                            </th>
                            <td >
                              <ext:SelectBox ID="cbo01_OCCUR_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPENM" ValueField="OBJECT_ID" TriggerAction="All" Width="260" >
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="TYPENM" />
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <Listeners>
                                    <%--4.X CHANGE -> SELECT (화면 로딩전에 사용 NULL오류로 인해서--%>
                                        <Select Fn="fn_ClaimOccurDivChange"></Select>
                                    </Listeners>
                                </ext:SelectBox>
                            </td>     
                            <th>
                               <ext:Label ID="lbl02_OCCUR_DIV" runat="server" Hidden="true"  /> <%--Text="발생구분"--%>
                            </th>
                            <td >
                              <ext:SelectBox ID="cbo02_OCCUR_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="DIVNM" ValueField="DIVCD" TriggerAction="All" Width="260" Hidden="true" >
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="DIVNM" />
                                                        <ext:ModelField Name="DIVCD" />
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
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="CORCD"/>
                                            <ext:ModelField Name="BIZCD"/>
                                            <ext:ModelField Name="DOCRPTNO"/>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="FORMOBJNO"/>
                                            <ext:ModelField Name="PROG_DIVNM"/>
                                            <ext:ModelField Name="PROG_DIV"/>
                                            <ext:ModelField Name="VINCDCD"/>
                                            <ext:ModelField Name="VINCD"/>
                                            <ext:ModelField Name="PARTNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="SHA_RATE"/>
                                            <ext:ModelField Name="NATIONNM"/>
                                            <ext:ModelField Name="CLAIM_NATIONCD"/>
                                            <ext:ModelField Name="PROD_DATE"/>
                                            <ext:ModelField Name="APPLICD"/>
                                            <ext:ModelField Name="PRESCD"/>
                                            <ext:ModelField Name="STATUS"/>
                                            <ext:ModelField Name="RROG_DIVNM"/>
                                            <ext:ModelField Name="RROG_DIV"/>
                                            <ext:ModelField Name="OFFDOC_DIVNM"/>
                                            <ext:ModelField Name="OFFDOC_DIV"/>
                                            <ext:ModelField Name="REQT_DATE"/>
                                            <ext:ModelField Name="RECEIPT_DATE"/>
                                            <ext:ModelField Name="RECEIPT_TIME"/>
                                            <ext:ModelField Name="RECEIPT_EMPNO"/>
                                            <ext:ModelField Name="COM_YN"/>
                                            <ext:ModelField Name="CLAIM_OCCUR_DIVNM"/>
                                            <ext:ModelField Name="CLAIM_OCCUR_DIV"/>
                                            <ext:ModelField Name="DOCRPT_SEQ"/>
                                            <ext:ModelField Name="PROC_DATE"/>
                                            <ext:ModelField Name="PROG_TIME"/>
                                            <ext:ModelField Name="DOCRPT_SEQ02"/>
                                        </Fields>
                                    </ext:Model>
                                </Model>
                                <Listeners>
                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                    <Load Delay="1" Handler="GridStoreReady(App.GridStatus1, this.getTotalCount());  "></Load>
                                </Listeners>
                            </ext:Store>
                        </Store>
<%--                        <Plugins>
                            <ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>
                        </Plugins>  --%>
                        <Plugins>
                            <%-- buffred view를 사용하기 위한 plugin. --%>
                            <ext:BufferedRenderer ID="BufferedRenderer1" runat="server" />
                            <%-- 2.X버전부터는 그리드에서 edtior를 활성화 시키기위해서 cellEditing Plugin을 추가 하여 사용하고 자바스크립트에서 grid.editingPlugin 형태로 사용할수 있다. --%>
                            <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                <Listeners>                                    
                                    <%--<BeforeEdit fn="BeforeEdit" />--%>
                                    <Edit fn ="AfterEdit" />                                    
                                </Listeners>
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                <ext:Column ID ="Column2" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center"  >
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:Column ID="CORCD" ItemID="CORCD" runat="server" DataIndex="CORCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="BIZCD" ItemID="SAUP" runat="server" DataIndex="BIZCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="DOCRPTNO" ItemID="DOCRPTNO" runat="server" DataIndex="DOCRPTNO" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="VENDCD" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="FORMOBJNO" ItemID="FORMOBJNO" runat="server" DataIndex="FORMOBJNO" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="PROG_DIVNM" ItemID="PROG_DIVNM" runat="server" DataIndex="PROG_DIVNM" Width="0" Align="Center" />  <%--Text=""--%> 
                                <ext:Column  ID="PROG_DIV"  ItemID="OUT_TYPENM"  runat="server" DataIndex="PROG_DIV" Width="80" Align="Center" > <%--Text="의뢰유형"--%>                                 
                                    <Renderer Fn="gridComboRenderer" />
                                    <Editor>                                        
                                       <ext:ComboBox ID="cbo02_PROG_DIV" runat="server"  DisplayField="TYPENM" ValueField="OBJECT_ID" QueryMode="Local" AllowBlank = "false" Editable="true">                                                                        
                                            <Store>
                                                <ext:Store ID="Store_PROG_DIV" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model5" runat="server" IDProperty="OBJECT_ID">
                                                            <Fields>
                                                                <ext:ModelField Name="TYPENM" />
                                                                <ext:ModelField Name="OBJECT_ID" />                                                                
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                        </ext:ComboBox>
                                    </Editor>
                                </ext:Column>
                                <ext:Column ID="VINCDCD" ItemID="VIN" runat="server" DataIndex="VINCDCD" Width="60" Align="Center" />  <%--Text="차종"--%> 
                                <ext:Column ID="VINCD" ItemID="VINCD" runat="server" DataIndex="VINCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="PARTNO" ItemID="PARTNOTITLE" runat="server" DataIndex="PARTNO" Width="120" Align="Left" />  <%--Text="품번"--%> 
                                <ext:Column ID="PARTNM" ItemID="PARTNMTITLE" runat="server" DataIndex="PARTNM" Width="200" Align="Left" />  <%--Text="품명"--%> 
                                <ext:Column ID="SHA_RATE" ItemID="SHA_RATE" runat="server" DataIndex="SHA_RATE" Width="0" Align="Center" />  <%--Text=""--%> 
                                <ext:Column ID="NATIONNM" ItemID="NATION" runat="server" DataIndex="NATIONNM" Width="100" Align="Center" />  <%--Text="국가"--%> 
                                <ext:Column ID="CLAIM_NATIONCD" ItemID="CLAIM_NATIONCD" runat="server" DataIndex="CLAIM_NATIONCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="PROD_DATE" ItemID="PROD_DATE" runat="server" DataIndex="PROD_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="APPLICD" ItemID="APPLICD" runat="server" DataIndex="APPLICD" Width="60" Align="Center" />  <%--Text="원인코드"--%> 
                                <ext:Column ID="PRESCD" ItemID="PRESCD" runat="server" DataIndex="PRESCD" Width="60" Align="Center" />  <%--Text="현상코드"--%> 
                                <ext:Column ID="STATUS" ItemID="DOC_ING" runat="server" DataIndex="STATUS" Width="100" Align="Center" />  <%--Text="공문진행"--%> 
                                <ext:Column ID="RROG_DIVNM" ItemID="RROG_DIVNM" runat="server" DataIndex="RROG_DIVNM" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RROG_DIV" ItemID="RROG_DIV" runat="server" DataIndex="RROG_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="OFFDOC_DIVNM" ItemID="OFFDOC_DIVNM" runat="server" DataIndex="OFFDOC_DIVNM" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="OFFDOC_DIV" ItemID="OFFDOC_DIV" runat="server" DataIndex="OFFDOC_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="REQT_DATE" ItemID="REQT_DATE" runat="server" DataIndex="REQT_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RECEIPT_DATE" ItemID="RECEIPT_DATE" runat="server" DataIndex="RECEIPT_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RECEIPT_TIME" ItemID="RECEIPT_TIME" runat="server" DataIndex="RECEIPT_TIME" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RECEIPT_EMPNO" ItemID="RECEIPT_EMPNO" runat="server" DataIndex="RECEIPT_EMPNO" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="COM_YN" ItemID="COM_YN" runat="server" DataIndex="COM_YN" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="CLAIM_OCCUR_DIVNM" ItemID="CLAIM_OCCUR_DIVNM" runat="server" DataIndex="CLAIM_OCCUR_DIVNM" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="CLAIM_OCCUR_DIV" ItemID="CLAIM_OCCUR_DIV" runat="server" DataIndex="CLAIM_OCCUR_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="DOCRPT_SEQ" ItemID="DOCRPT_SEQ" runat="server" DataIndex="DOCRPT_SEQ" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="PROC_DATE" ItemID="PROC_DATE" runat="server" DataIndex="PROC_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="PROG_TIME" ItemID="PROG_TIME" runat="server" DataIndex="PROG_TIME" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="DOCRPT_SEQ02" ItemID="DOCRPT_SEQ02" runat="server" DataIndex="DOCRPT_SEQ02" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="Column3" ItemID="Column3" runat="server" DataIndex="Column3" MinWidth="1" Align="Left" Flex="1" />  <%--Text=""--%> 
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">
                                <GetRowClass Fn="getRowClass" />
                            </ext:GridView>
                        </View>
                        <SelectionModel>                            
                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single"/>
                        </SelectionModel>                                                         
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>         
            <ext:Panel ID="GridPanel02" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store4" runat="server" PageSize="250">
                                <Model>
                                    <ext:Model ID="Model4" runat="server" Name ="ModelGrid">
                                        <Fields>
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="CORCD"/>
                                            <ext:ModelField Name="BIZCD"/>
                                            <ext:ModelField Name="DOCRPTNO"/>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="FORMOBJNO"/>
                                            <ext:ModelField Name="PROG_DIVNM"/>
                                            <ext:ModelField Name="PROG_DIV"/>
                                            <ext:ModelField Name="VINCDCD"/>
                                            <ext:ModelField Name="VINCD"/>
                                            <ext:ModelField Name="PARTNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="ASSY_PNO"/>
                                            <ext:ModelField Name="DEF_DET_DESC"/>
                                            <ext:ModelField Name="NATIONCD"/>
                                            <ext:ModelField Name="INSTALL_POS"/>
                                            <ext:ModelField Name="MAN_AMOUNT"/>
                                            <ext:ModelField Name="DIS_AMONT"/>
                                            <ext:ModelField Name="STATUS"/>
                                            <ext:ModelField Name="RROG_DIVNM"/>
                                            <ext:ModelField Name="RROG_DIV"/>
                                            <ext:ModelField Name="OFFDOC_DIVNM"/>
                                            <ext:ModelField Name="OFFDOC_DIV"/>
                                            <ext:ModelField Name="REQT_DATE"/>
                                            <ext:ModelField Name="RECEIPT_DATE"/>
                                            <ext:ModelField Name="RECEIPT_TIME"/>
                                            <ext:ModelField Name="RECEIPT_EMPNO"/>
                                            <ext:ModelField Name="COM_YN"/>
                                            <ext:ModelField Name="CLAIM_OCCUR_DIVNM"/>
                                            <ext:ModelField Name="CLAIM_OCCUR_DIV"/>
                                            <ext:ModelField Name="DOCRPT_SEQ"/>
                                            <ext:ModelField Name="PROC_DATE"/>
                                            <ext:ModelField Name="PROG_TIME"/>
                                            <ext:ModelField Name="DOCRPT_SEQ02"/>
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
                            <ext:BufferedRenderer ID="BufferedRenderer2" runat="server" />
                            <%-- 2.X버전부터는 그리드에서 edtior를 활성화 시키기위해서 cellEditing Plugin을 추가 하여 사용하고 자바스크립트에서 grid.editingPlugin 형태로 사용할수 있다. --%>
                            <ext:CellEditing ID="CellEditing2" runat="server" ClicksToEdit="1" >
                            </ext:CellEditing>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel2" runat="server">
                            <Columns>
                                <%--<ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />--%>   <%-- 자동으로 numbering을 해줌. --%>
                                <ext:Column ID ="Column1" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center"  >
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:Column ID="CORCD02" ItemID="CORCD" runat="server" DataIndex="CORCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="BIZCD02" ItemID="SAUP" runat="server" DataIndex="BIZCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="DOCRPTNO02" ItemID="DOCRPTNO" runat="server" DataIndex="DOCRPTNO" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="VENDCD02" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="FORMOBJNO02" ItemID="FORMOBJNO" runat="server" DataIndex="FORMOBJNO" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="PROG_DIVNM02" ItemID="PROG_DIVNM" runat="server" DataIndex="PROG_DIVNM" Width="0" Align="Center" />  <%--Text=""--%> 
                                <ext:Column  ID="PROG_DIV02"  ItemID="OUT_TYPENM"  runat="server" DataIndex="PROG_DIV02" Width="80" Align="Center" > <%--Text="의뢰유형"--%>                                 
                                    <Renderer Fn="gridComboRenderer" />
                                    <Editor>                                        
                                       <ext:ComboBox ID="cbo02_PROG_DIV02" runat="server"  DisplayField="TYPENM" ValueField="OBJECT_ID" QueryMode="Local" AllowBlank = "false" Editable="true">                                                                        
                                            <Store>
                                                <ext:Store ID="Store6" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model6" runat="server" IDProperty="OBJECT_ID">
                                                            <Fields>
                                                                <ext:ModelField Name="TYPENM" />
                                                                <ext:ModelField Name="OBJECT_ID" />                                                                
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                        </ext:ComboBox>
                                    </Editor>
                                </ext:Column>
                                <ext:Column ID="VINCDCD02" ItemID="VIN" runat="server" DataIndex="VINCDCD" Width="60" Align="Center" />  <%--Text="차종"--%> 
                                <ext:Column ID="VINCD02" ItemID="VINCD" runat="server" DataIndex="VINCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="PARTNO02" ItemID="PARTNO6" runat="server" DataIndex="PARTNO" Width="120" Align="Left" />  <%--Text="부품P/NO"--%> 
                                <ext:Column ID="PARTNM02" ItemID="PARTNMTITLE" runat="server" DataIndex="PARTNM" Width="200" Align="Left" />  <%--Text="품명"--%> 
                                <ext:Column ID="ASSY_PNO02" ItemID="ASSYPNO03" runat="server" DataIndex="ASSY_PNO" Width="120" Align="Left" />  <%--Text="완제품P/NO"--%> 
                                <ext:Column ID="DEF_DET_DESC02" ItemID="DEF_DETAIL" runat="server" DataIndex="DEF_DET_DESC" Width="0" Align="Left" />  <%--Text="불량세부현황"--%> 
                                <ext:Column ID="NATIONCD02" ItemID="NATIONCD" runat="server" DataIndex="NATIONCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="INSTALL_POS02" ItemID="POSTITLE" runat="server" DataIndex="INSTALL_POS" Width="80" Align="Center" />  <%--Text="장착위치"--%> 
                                <ext:Column ID="MAN_AMOUNT02" ItemID="MAN_AMOUNT" runat="server" DataIndex="MAN_AMOUNT" Width="0" Align="Center" />  <%--Text=""--%> 
                                <ext:Column ID="DIS_AMONT02" ItemID="DIS_AMONT" runat="server" DataIndex="DIS_AMONT" Width="0" Align="Center" />  <%--Text=""--%> 
                                <ext:Column ID="STATUS02" ItemID="DOC_ING" runat="server" DataIndex="STATUS" Width="100" Align="Center" />  <%--Text="공문진행"--%> 
                                <ext:Column ID="RROG_DIVNM02" ItemID="RROG_DIVNM" runat="server" DataIndex="RROG_DIVNM" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RROG_DIV02" ItemID="RROG_DIV" runat="server" DataIndex="RROG_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="OFFDOC_DIVNM02" ItemID="OFFDOC_DIVNM" runat="server" DataIndex="OFFDOC_DIVNM" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="OFFDOC_DIV02" ItemID="OFFDOC_DIV" runat="server" DataIndex="OFFDOC_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="REQT_DATE02" ItemID="REQT_DATE" runat="server" DataIndex="REQT_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RECEIPT_DATE02" ItemID="RECEIPT_DATE" runat="server" DataIndex="RECEIPT_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RECEIPT_TIME02" ItemID="RECEIPT_TIME" runat="server" DataIndex="RECEIPT_TIME" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RECEIPT_EMPNO02" ItemID="RECEIPT_EMPNO" runat="server" DataIndex="RECEIPT_EMPNO" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="COM_YN02" ItemID="COM_YN" runat="server" DataIndex="COM_YN" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="CLAIM_OCCUR_DIVNM02" ItemID="CLAIM_OCCUR_DIVNM" runat="server" DataIndex="CLAIM_OCCUR_DIVNM" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="CLAIM_OCCUR_DIV02" ItemID="CLAIM_OCCUR_DIV" runat="server" DataIndex="CLAIM_OCCUR_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="DOCRPT_SEQ03" ItemID="DOCRPT_SEQ" runat="server" DataIndex="DOCRPT_SEQ" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="PROC_DATE02" ItemID="PROC_DATE" runat="server" DataIndex="PROC_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="PROG_TIME02" ItemID="PROG_TIME" runat="server" DataIndex="PROG_TIME" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="DOCRPT_SEQ04" ItemID="DOCRPT_SEQ02" runat="server" DataIndex="DOCRPT_SEQ02" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="Column4" ItemID="Column3" runat="server" DataIndex="Column3" MinWidth="1" Align="Left" Flex="1" />  <%--Text=""--%> 
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
                                <GetRowClass Fn="getRowClass" />
                            </ext:GridView>
                        </View>
                        <%-- SelectionModel은 checkbox, cell, row가 존재하고 그리드를 클릭시 그리드의 선택된 행의값이 json형태로 넘어감 (EP20S01참고)--%>
                        <SelectionModel>
                        <%--4.X CHANGE -> SELECT (화면 로딩전에 사용 NULL오류로 인해서--%>
                            <ext:CellSelectionModel  ID="CellSelectionModel1" runat="server">
                            </ext:CellSelectionModel >
                            <%--<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server"><Listeners><Select Fn="CellFocus"></Select></Listeners></ext:CheckboxSelectionModel>--%>
                        </SelectionModel>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="StatusBar1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>                    
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
