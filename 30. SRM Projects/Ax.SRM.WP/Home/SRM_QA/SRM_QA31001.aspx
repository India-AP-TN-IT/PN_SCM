<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA31001.aspx.cs" Inherits="HE.MP.WP.Home.SRM_QA.SRM_QA31001" %>
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

    <title>claim 통보서 조회</title>

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
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        };

    </script>
</head>
<body>
    <form id="SRM_QA31001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField   ID="txt01_CLAIM_OCCUR_DIV" runat="server" Hidden="true" ></ext:TextField> 
    <ext:TextField   ID="txt01_CUST_DOCRPTNO" runat="server" Hidden="true" ></ext:TextField> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_QA31001" runat="server" Cls="search_area_title_name" Text="테스트" />
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
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" Text="Vender Code" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">                                
                                <ext:Label ID="lbl01_STD_YYMM" runat="server" /> <%--Text="기준년월" --%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_STD_YYMM" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_OCCUR_DIV" runat="server" Text="Vendor Plant" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_ClAIM" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model5" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <DirectEvents> <Select OnEvent="cbo01_QUOT_CNT_Change" /> </DirectEvents> 
                                </ext:SelectBox>
                            </td>
                            <th>
                                <ext:Label ID="lbl02_OCCUR_DIV" runat="server" Text="Vendor Plant" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_OCCUR" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
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
                                            <ext:ModelField Name="JOBGB"/>
                                            <ext:ModelField Name="CORCD"/>
                                            <ext:ModelField Name="BIZCD"/>
                                            <ext:ModelField Name="CLAIM_OCCUR_DIV"/>
                                            <ext:ModelField Name="CLAIM_OCCUR_DIVNM"/>
                                            <ext:ModelField Name="DOCRPTNO"/>
                                            <ext:ModelField Name="DOCRPT_DATE"/>
                                            <ext:ModelField Name="VENDCD"/>
                                            <ext:ModelField Name="CUST_DOCRPTNO"/>
                                            <ext:ModelField Name="PROC_DATE"/>
                                            <ext:ModelField Name="COM_YN"/>
                                            <ext:ModelField Name="DOCCNT"/>
                                            <ext:ModelField Name="SUMTOT"/>
                                            <ext:ModelField Name="SUMTOT2"/>
                                            <ext:ModelField Name="ACC_DATE" />
                                            <ext:ModelField Name="ADJUST_DATE"/>
                                            <ext:ModelField Name="PROG_DIV"/>
                                            <ext:ModelField Name="SHARATE"/>
                                            <ext:ModelField Name="DOCRPTNO2"/>
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
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo"></Renderer>
                                </ext:Column>
                                <ext:CheckColumn runat="server" ID ="chk01_JOBGB" ItemID="CHK" DataIndex="JOBGB" Width="65"
                                                 StopSelection="false" Editable="true" Align ="Center" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" >  <%--Text="견적불가" --%>    
                                </ext:CheckColumn> 
                                <ext:Column ID="CORCD" ItemID="CORCD" runat="server" DataIndex="CORCD" Width="80" Align="Center" Hidden="true"/>  <%--Text="법인"--%> 
                                <ext:Column ID="BIZCD" ItemID="SAUP" runat="server" DataIndex="BIZCD" Width="80" Align="Center" Hidden="true"/>  <%--Text="사업장"--%> 
                                <ext:Column ID="CLAIM_OCCUR_DIV" ItemID="CLAIM_OCCUR_DIV" runat="server" DataIndex="CLAIM_OCCUR_DIV" Width="80" Align="Center" Hidden="true"/>  <%--Text="구분코드"--%> 
                                <ext:Column ID="CLAIM_OCCUR_DIVNM" ItemID="DIVISION" runat="server" DataIndex="CLAIM_OCCUR_DIVNM" Width="100" Align="Center" />  <%--Text="구분"--%> 
                                <ext:Column ID="DOCRPTNO" ItemID="DOCRPTNO" runat="server" DataIndex="DOCRPTNO" Width="80" Align="Center" />  <%--Text="통보서번호"--%> 
                                <ext:DateColumn ID="DOCRPT_DATE" ItemID="DOCRPT_DATE" runat="server" DataIndex="DOCRPT_DATE" Width="80" Align="Center" />  <%--Text="통보일자"--%> 
                                <ext:Column ID="VENDCD" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="80" Align="Center" Hidden="true" />  <%--Text="업체"--%> 
                                <ext:Column ID="CUST_DOCRPTNO" ItemID="CUST_DOCRPTNO02" runat="server" DataIndex="CUST_DOCRPTNO" Width="60" Align="Right" Hidden="true" />  <%--Text=""--%> 
                                <ext:DateColumn ID="PROC_DATE" ItemID="PROC_DATE" runat="server" DataIndex="PROC_DATE" Width="80" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                <ext:Column ID="COM_YN" ItemID="COM_YN" runat="server" DataIndex="COM_YN" Width="80" Align="Center" Hidden="true" />  <%--Text=""--%> 
                                <ext:NumberColumn ID="DOCCNT" ItemID="CUST_DOCRPTNO02" runat="server" DataIndex="DOCCNT" Width="80" Align="Right" Format="#,###" /> <%--Text="통보건수"--%> 
                                <ext:NumberColumn ID="SUMTOT" ItemID="CUST_AMT" runat="server" DataIndex="SUMTOT" Width="80" Align="Right" Format="#,###"/>  <%--Text="통보금액"--%> 
                                <ext:NumberColumn ID="SUMTOT2" ItemID="SETTLE_AMT" runat="server" DataIndex="SUMTOT2" Width="100" Align="Right" Format="#,###"/>  <%--Text="정산금액"--%> 
                                <ext:DateColumn ID="ACC_DATE" ItemID="ACC_DATE02" runat="server" DataIndex="ACC_DATE" Width="100" Align="Center" />  <%--Text="이의신청기한"--%> 
                                <ext:DateColumn ID="ADJUST_DATE" ItemID="SETTLE_DATE" runat="server" DataIndex="ADJUST_DATE" Width="80" Align="Center" />  <%--Text="정산일자"--%> 
                                <ext:Column ID="PROG_DIV" ItemID="PROG_DIV" runat="server" DataIndex="PROG_DIV" Width="80" Align="Center" Hidden="true"/>  <%--Text=""--%> 
                                <ext:Column ID="SHARATE" ItemID="SHARATE" runat="server" DataIndex="SHARATE" Width="80" Align="Center" Hidden="true"/>  <%--Text=""--%> 
                                <ext:Column ID="DOCRPTNO2" ItemID="DOCRPTNO2" runat="server" DataIndex="DOCRPTNO2" Width="80" Align="Center" Hidden="true"/>  <%--Text=""--%> 
                                <ext:Column ID="Column1" ItemID="Column1" runat="server" DataIndex="Column1" MinWidth="80" Align="Center" Flex="1"/>  <%--Text=""--%>

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
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                        </View>
                        <%-- SelectionModel은 checkbox, cell, row가 존재하고 그리드를 클릭시 그리드의 선택된 행의값이 json형태로 넘어감 (EP20S01참고)--%>
                        <SelectionModel>
                        <%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
                            <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">                           
                            </ext:CellSelectionModel >
                            <%--<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server"><Listeners><Select Fn="CellFocus"></Select></Listeners></ext:CheckboxSelectionModel>--%>
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
                                    <ext:Model ID="Model2" runat="server" Name ="ModelGrid">
                                        <Fields>
                                            <%--임의로 생성--%>
                                            <ext:ModelField Name="NO" /> 
                                            <%--실제 디비에서 가져와서 사용함.--%>
                                            <ext:ModelField Name="RONO"/>
                                            <ext:ModelField Name="DOCRPTNO"/>
                                            <ext:ModelField Name="CMP_DIV"/>
                                            <ext:ModelField Name="OCCUR_DIVCD"/>
                                            <ext:ModelField Name="RO_YYMM"/>
                                            <ext:ModelField Name="VINNO"/>
                                            <ext:ModelField Name="CTYPE"/>
                                            <ext:ModelField Name="NO_CASE"/>
                                            <ext:ModelField Name="VINCD_NM"/>
                                            <ext:ModelField Name="ITEM_NM"/>
                                            <ext:ModelField Name="APPLI_PART"/>
                                            <ext:ModelField Name="PARTNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="MWORKCD"/>
                                            <ext:ModelField Name="APPLICD"/>
                                            <ext:ModelField Name="PRESCD"/>
                                            <ext:ModelField Name="PROD_DATE"/>
                                            <ext:ModelField Name="REPAIR_DATE"/>
                                            <ext:ModelField Name="SAL_DATE"/>
                                            <ext:ModelField Name="USE_TERM"/>
                                            <ext:ModelField Name="TRAVEL_DST"/>
                                            <ext:ModelField Name="SHA_RATE"/>
                                            <ext:ModelField Name="PART_COST"/>
                                            <ext:ModelField Name="WAGE_COST"/>
                                            <ext:ModelField Name="SUBCON_COST"/>
                                            <ext:ModelField Name="SUMTOT"/>
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
                                <ext:Column ID="RONO" ItemID="RONO" runat="server" DataIndex="RONO" Width="0" Align="Left" />  <%--Text="RO번호"--%> 
                                <ext:Column ID="Column2" ItemID="DOCRPTNO" runat="server" DataIndex="DOCRPTNO" Width="0" Align="Left" />  <%--Text="회사구분"--%> 
                                <ext:Column ID="CMP_DIV" ItemID="COMP_DIV" runat="server" DataIndex="CMP_DIV" Width="0" Align="Left" />  <%--Text="발생구분"--%> 
                                <ext:Column ID="OCCUR_DIVCD" ItemID="OCCUR_DIV" runat="server" DataIndex="OCCUR_DIVCD" Width="0" Align="Left" />  <%--Text="발생구분"--%> 
                                <ext:Column ID="RO_YYMM" ItemID="RO_YYMM02" runat="server" DataIndex="RO_YYMM" Width="0" Align="Left" />  <%--Text="RO발생년월"--%> 
                                <ext:Column ID="VINNO" ItemID="VINNO" runat="server" DataIndex="VINNO" Width="0" Align="Left" />  <%--Text="VIN번호"--%> 
                                <ext:Column ID="CTYPE" ItemID="CTYPE02" runat="server" DataIndex="CTYPE" Width="0" Align="Left" />  <%--Text="클레입TYPE"--%> 
                                <ext:Column ID="NO_CASE" ItemID="NO_CASE" runat="server" DataIndex="NO_CASE" Width="0" Align="Left" />  <%--Text="건수"--%> 
                                <ext:Column ID="VINCD_NM" ItemID="VINM" runat="server" DataIndex="VINCD_NM" Width="0" Align="Left" />  <%--Text="차명"--%> 
                                <ext:Column ID="ITEM_NM" ItemID="PARTNONM" runat="server" DataIndex="ITEM_NM" Width="0" Align="Left" />  <%--Text="품명"--%> 
                                <ext:Column ID="APPLI_PART" ItemID="APPLI_PNO" runat="server" DataIndex="APPLI_PART" Width="0" Align="Left" />  <%--Text="원인부품(1)"--%> 
                                <ext:Column ID="PARTNO" ItemID="APPLI_PNO02" runat="server" DataIndex="PARTNO" Width="0" Align="Left" />  <%--Text="원인부품(2)"--%> 
                                <ext:Column ID="PARTNM" ItemID="APPLY_PARTNM" runat="server" DataIndex="PARTNM" Width="0" Align="Left" />  <%--Text="원인품명"--%> 
                                <ext:Column ID="MWORKCD" ItemID="MWORKCD" runat="server" DataIndex="MWORKCD" Width="0" Align="Left" />  <%--Text="주작업코드"--%> 
                                <ext:Column ID="APPLICD" ItemID="APPLI_CNTT" runat="server" DataIndex="APPLICD" Width="0" Align="Left" />  <%--Text="원인"--%> 
                                <ext:Column ID="PRESCD" ItemID="PRESENT_SIT" runat="server" DataIndex="PRESCD" Width="0" Align="Left" />  <%--Text="현상"--%> 
                                <ext:Column ID="PROD_DATE" ItemID="PROD_DATE" runat="server" DataIndex="PROD_DATE" Width="0" Align="Left" />  <%--Text="생산일자"--%> 
                                <ext:Column ID="REPAIR_DATE" ItemID="REPAIR_DATE" runat="server" DataIndex="REPAIR_DATE" Width="0" Align="Left" />  <%--Text="수리일자"--%> 
                                <ext:Column ID="SAL_DATE" ItemID="SAL_DATE" runat="server" DataIndex="SAL_DATE" Width="0" Align="Left" />  <%--Text="판매일자"--%> 
                                <ext:Column ID="USE_TERM" ItemID="USE_TERM" runat="server" DataIndex="USE_TERM" Width="0" Align="Left" />  <%--Text="사용기간"--%> 
                                <ext:Column ID="TRAVEL_DST" ItemID="TRAVEL_DST" runat="server" DataIndex="TRAVEL_DST" Width="0" Align="Left" />  <%--Text="주행거리"--%> 
                                <ext:Column ID="SHA_RATE" ItemID="SHA_RATE" runat="server" DataIndex="SHA_RATE" Width="0" Align="Left" />  <%--Text="분담률"--%> 
                                <ext:Column ID="PART_COST" ItemID="PART_COST" runat="server" DataIndex="PART_COST" Width="0" Align="Left" />  <%--Text="부품비"--%> 
                                <ext:Column ID="WAGE_COST" ItemID="WAGE_COST" runat="server" DataIndex="WAGE_COST" Width="0" Align="Left" />  <%--Text="공임비"--%> 
                                <ext:Column ID="SUBCON_COST" ItemID="SUBCON_COST02" runat="server" DataIndex="SUBCON_COST" Width="0" Align="Left" />  <%--Text="외주비"--%> 
                                <ext:Column ID="Column3" ItemID="SUMTOT" runat="server" DataIndex="SUMTOT" Width="0" Align="Left" />  <%--Text="합계"--%> 
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
                        <%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
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
