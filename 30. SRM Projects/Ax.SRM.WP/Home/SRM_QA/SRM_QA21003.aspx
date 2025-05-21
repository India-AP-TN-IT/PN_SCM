<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA21003.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_QA.SRM_QA21003" %>
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

    <title>Claim 이의제기 의뢰</title>

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
//            App.Grid02.setHeight(App.GridPanel.getHeight());
        }

        var fn_ClaimOccurDivChange = function () {
            App.direct.SetComboVisibleClaimOccurDiv();
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        그리드의 editor를 활성화시키는 시점에서 작동        
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var BeforeEdit = function (rowEditor, e) {
            currentCellObject = e;
        }

        var AfterEdit = function (rowEditor, e) {

//            if (e.record.data.DOCRPT_DATE != null && e.record.data.DOCRPT_DATE != "") {
//                var nowDate = new Date();
//                var date = nowDate.getFullYear() + "-" + ("00" + (nowDate.getMonth() + 1)).slice(-2) + "-" + ("00" + nowDate.getDate()).slice(-2);

//                var docrptDate = (e.record.data.DOCRPT_DATE).toString();

//                if (date < docrptDate) {
//                    if (e.record.data.FORMOBJNO != "" && e.record.data.FORMOBJNO != null) {
//                        e.grid.getStore().getAt(e.rowIdx).set("NO02", "U");
//                    } else {
//                        e.grid.getStore().getAt(e.rowIdx).set("NO02", "N");
//                    }
//                }
//                else {
//                    e.grid.getStore().getAt(e.rowIdx).set("FORMOBJ_TYPE", "");
//                    //Ext.Msg.alert("경고", "이의제기 기간을 초과하여 의뢰가 불가능합니다.");
//                    App.direct.MsgCodeAlert("SRMQA00-0012");
//                }
//            }
//            else {
//                e.grid.getStore().getAt(e.rowIdx).set("FORMOBJ_TYPE", "");
//                //Ext.Msg.alert("경고", "기한일자 누락하여 의뢰가 불가능합니다.");
//                App.direct.MsgCodeAlert("SRMQA00-0013");
//            }
        };

        /*---------------------------------------------------------------------------------------------------------------------------------------------------
        // 그리드 cell 더블 클릭 시
        ---------------------------------------------------------------------------------------------------------------------------------------------------*/
        var CellDbClick = function (grid, obj1, obj0, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;
            

            var CORCD = grid.getStore().getAt(rowIndex).data["CORCD"];     //사업장
            var BIZCD = grid.getStore().getAt(rowIndex).data["BIZCD"];     //사업장
            var DOCRPTNO = grid.getStore().getAt(rowIndex).data["DOCRPTNO"];     //통보서 번호
            var FORMOBJNO = grid.getStore().getAt(rowIndex).data["FORMOBJNO"];     //이의제기 번호
            var RROG_DIV = grid.getStore().getAt(rowIndex).data["RROG_DIV"];     //공문진행구분

            fn_PopupHandler(CORCD, BIZCD, DOCRPTNO, FORMOBJNO, RROG_DIV);
        }

        function fn_PopupHandler(CORCD, BIZCD, DOCRPTNO, FORMOBJNO, RROG_DIV) {
            App.V_CORCD.setValue(CORCD);
            App.V_BIZCD.setValue(BIZCD);
            App.V_DOCRPTNO.setValue(DOCRPTNO);
            App.V_FORMOBJNO.setValue(FORMOBJNO);
            App.V_RROG_DIV.setValue(RROG_DIV);

            App.btn01_POP_QA21003P1.fireEvent('click');
        }

    </script>
</head>
<body>
    <form id="SRM_QA21003" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_POP_QA21003P1" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="V_CORCD" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 CORCD값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="V_BIZCD" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 BIZCD값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="V_DOCRPTNO" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 DOCRPTNO값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="V_FORMOBJNO" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 FORMOBJNO값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="V_RROG_DIV" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 RROG_DIV값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="UserHelpURL" runat="server" Hidden="true" Text="SRM_QA21003P1.aspx"></ext:TextField> 
    <ext:TextField ID="PopupWidth" runat="server" Hidden="true" Text="600"></ext:TextField> 
    <ext:TextField ID="PopupHeight" runat="server" Hidden="true" Text="650"></ext:TextField> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_QA21003" runat="server" Cls="search_area_title_name" /><%--Text="X-bar R관리 조회/등록" />--%>
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
                                <ext:Label ID="lbl01_VEND" runat="server"  /> <%--Text="업체"--%>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>   
                            <th class="ess">
                                <ext:Label ID="lbl01_OCCUR_MONTH" runat="server"  /> <%--Text="발생년월"--%>
                            </th>
                            <td>                               
                                <ext:DateField ID="df01_OCCUR_MONTH" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />                                    
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
                               <ext:Label ID="lbl02_OCCUR_DIV" runat="server" Hidden="true" /> <%--Text="발생구분"--%>
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
                            <td colspan="2">
                                <ext:RadioGroup ID="RadioGroup1" runat="server" Width="500" Cls="inputText" ColumnsWidths="100,100,100,100,100">
                                    <Items>
                                        <ext:Radio ID="rdo01_ALLS" Cls="inputText" runat="server" InputValue="1" Checked="true" />
                                        <ext:Radio ID="rdo01_NONE_RECEIPT" Cls="inputText" runat="server" InputValue="2" />
                                        <ext:Radio ID="rdo01_PROCESSING" Cls="inputText" runat="server" InputValue="3" />
                                        <ext:Radio ID="rdo01_REJECT" Cls="inputText" runat="server" InputValue="4" />
                                        <ext:Radio ID="rdo01_QM_APPLY" Cls="inputText" runat="server" InputValue="5" />
                                    </Items>       
                                    <Listeners>
                                        <Change Handler="App.direct.SetQueryDiv(this.getChecked()[0].inputValue.toString());"  Delay="500"/>
                                    </Listeners>                             
                                </ext:RadioGroup>
                            </td>                                                       
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ContentPanel1" runat="server" Cls="search_area_table" Region="North" >
                <Content>
                    <table style="height:0px;"/>
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
                            <th>
                                <ext:Label ID="lbl01_ACC_CNT" runat="server" /><%--Text="이의건수" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_CNT" runat="server" ReadOnly="true" Width="260" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_ACC_AMT" runat="server" /><%--Text="이의금액"/>--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_TOT_AMT" runat="server" ReadOnly="true" Width="260" />
                            </td>
                             <th>
                                <ext:Label ID="lbl01_APP_CNT02" runat="server" /><%--Text="승인건수" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_Y_CNT" runat="server" ReadOnly="true" Width="260" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_APP_AMT" runat="server" /><%--Text="승인금액" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_Y_TOT_AMT" runat="server" ReadOnly="true" Width="260" />
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
                                            <ext:ModelField Name="JOBGB" /> <%--선택체크박스--%>
                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="CORCD"/>
                                            <ext:ModelField Name="BIZCD"/>
                                            <ext:ModelField Name="CLAIM_OCCUR_DIV"/>
                                            <ext:ModelField Name="CLAIM_OCCUR_DIVNM"/>
                                            <ext:ModelField Name="DOCRPTNO"/>
                                            <ext:ModelField Name="FORMOBJNO"/>
                                            <ext:ModelField Name="OFFDOC_DIVNM"/>
                                            <ext:ModelField Name="OFFDOC_DIV"/>
                                            <ext:ModelField Name="CNT"/>
                                            <ext:ModelField Name="TOT_AMT"/>
                                            <ext:ModelField Name="SUMTOT2"/>
                                            <ext:ModelField Name="REQT_DATE"/>
                                            <ext:ModelField Name="FORMOBJ_TYPENM"/>
                                            <ext:ModelField Name="FORMOBJ_TYPE"/>
                                            <ext:ModelField Name="DOCRPT_DATE"/>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="CUST_DOCRPTNO"/>
                                            <ext:ModelField Name="PROC_DATE"/>
                                            <ext:ModelField Name="COM_YN"/>
                                            <ext:ModelField Name="RROG_DIVNM"/>
                                            <ext:ModelField Name="PROG_DIVNM"/>
                                            <ext:ModelField Name="PROG_DIV"/>
                                            <ext:ModelField Name="RROG_DIV"/>
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
                                <ext:CheckColumn runat="server" ID ="JOBGB" ItemID="CHK" DataIndex="JOBGB" Width="65"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >  <%--Text="견적불가" --%>    
<%--                                        <Listeners>
                                            <CheckChange Fn="chkMethod" />
                                        </Listeners>      
--%>                                </ext:CheckColumn> 
                                <ext:Column ID="CORCD" ItemID="CORCD" runat="server" DataIndex="CORCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="BIZCD" ItemID="SAUP" runat="server" DataIndex="BIZCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="CLAIM_OCCUR_DIV" ItemID="CLAIM_OCCUR_DIV" runat="server" DataIndex="CLAIM_OCCUR_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="CLAIM_OCCUR_DIVNM" ItemID="CLAIM_OCCUR_DIVNM" runat="server" DataIndex="CLAIM_OCCUR_DIVNM" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="DOCRPTNO" ItemID="DOCRPTNO" runat="server" DataIndex="DOCRPTNO" Width="130" Align="Center" />  <%--Text="통보서번호"--%> 
                                <ext:Column ID="FORMOBJNO" ItemID="FORMOBJNO" runat="server" DataIndex="FORMOBJNO" Width="130" Align="Center" />  <%--Text="이의제기번호"--%> 
                                <ext:Column ID="OFFDOC_DIVNM" ItemID="DOC_STAT" runat="server" DataIndex="OFFDOC_DIVNM" Width="80" Align="Center" />  <%--Text="공문상태"--%> 
                                <ext:Column ID="OFFDOC_DIV" ItemID="OFFDOC_DIV" runat="server" DataIndex="OFFDOC_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:NumberColumn ID="CNT" ItemID="QM_CNT" runat="server" DataIndex="CNT" Width="60" Align="Right"  Format="#,###"/>  <%--Text="건수"--%> 
                                <ext:NumberColumn ID="TOT_AMT" ItemID="AMT" runat="server" DataIndex="TOT_AMT" Width="80" Align="Right" Format="#,###"/>  <%--Text="금액"--%> 
                                <ext:Column ID="SUMTOT2" ItemID="SUMTOT2" runat="server" DataIndex="SUMTOT2" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:DateColumn ID="REQT_DATE" ItemID="REQT_DATE" runat="server" DataIndex="REQT_DATE" Width="80" Align="Center" />  <%--Text="의뢰일자"--%> 
                                <ext:Column ID="FORMOBJ_TYPENM" ItemID="JUST_TYPENM" runat="server" DataIndex="FORMOBJ_TYPENM" Width="80" Align="Left" />  <%--Text="유형"--%> 
                                <ext:Column ID="FORMOBJ_TYPE" ItemID="FORMOBJ_TYPE" runat="server" DataIndex="FORMOBJ_TYPE" Width="0" Align="Center" />  <%--Text=""--%> 
                                <ext:DateColumn ID="DOCRPT_DATE" ItemID="DOCRPT_DATE" runat="server" DataIndex="DOCRPT_DATE" Width="0" Align="Center" />  <%--Text=""--%> 
                                <ext:Column ID="VENDCD" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="CUST_DOCRPTNO" ItemID="CUST_DOCRPTNO" runat="server" DataIndex="CUST_DOCRPTNO" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:DateColumn ID="PROC_DATE" ItemID="PROC_DATE" runat="server" DataIndex="PROC_DATE" Width="80" Align="Center" />  <%--Text="처리일자"--%> 
                                <ext:Column ID="COM_YN" ItemID="COM_YN" runat="server" DataIndex="COM_YN" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RROG_DIVNM" ItemID="REP_STAT" runat="server" DataIndex="RROG_DIVNM" Width="80" Align="Center" />  <%--Text="의뢰상태"--%> 
                                <ext:Column ID="PROG_DIVNM" ItemID="PROC_DIV" runat="server" DataIndex="PROG_DIVNM" Width="80" Align="Center" />  <%--Text="처리구분"--%> 
                                <ext:Column ID="PROG_DIV" ItemID="PROG_DIV" runat="server" DataIndex="PROG_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="RROG_DIV" ItemID="RROG_DIV" runat="server" DataIndex="RROG_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="Column1" ItemID="Column1" runat="server" DataIndex="Column1" MinWidth="10" Align="Left" Flex="1" />  <%--Text=""--%> 
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
