<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM22001.aspx.cs" Inherits="Ax.EP.WP.Home.EPAdmin.EP_XM22001" %>
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

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

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
        }

        //비밀번호 초기화
        var fn_pwd_btn_click = function () {
            App.btn01_PWD_CHG.fireEvent('click');
        };
        //오류 초기화
        var fn_error_btn_click = function () {
            App.btn01_ERROR_CLEAR.fireEvent('click');
        };
        //사용자구분 변경
        var fn_UserDivComboChange = function () {
            App.direct.SetUserDivComboChange();
        };

        var x1, x2, x3, x4, x5, x6;
        function fn_USERID_Change(ctrl, value) {
         
            var len = App.txt02_USERID.value.length;

            if (len > 10) {
                alert(App.txt02_USERID.value.substring(0, 10));
             //   App.txt02_USERID.value = App.txt02_USERID.value.substring(0, 7);
            }
        }

        function upperID() {
            App.txt01_USERID.setValue(App.txt01_USERID.getValue().toUpperCase());
            App.txt02_USERID.setValue(App.txt02_USERID.getValue().toUpperCase());
        }
    </script>
</head>
<body>
    <form id="EP_XM22001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
            <BeforeAjaxRequest Handler="upperID();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_PWD_CHG" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:ImageButton ID="btn01_ERROR_CLEAR" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:TextField ID="txt01_CHECK_DIV" runat="server" Hidden="true"/>
    <ext:TextField ID="txt01_MODE" runat="server" Hidden="true"/>
    <ext:TextField ID="txt01_GROUP_CD" runat="server" Hidden="true"/>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="35">
                <Items>
                    <ext:Label ID="lbl01_EP_XM22001" runat="server" Cls="search_area_title_name" Text="테스트" />
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" Height="65">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col />
                            <col style="width: 150px;" />
                            <col />                        
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th >
                                <ext:Label ID="lbl01_USERID" runat="server" />  <%--Text="사용자 아이디"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_USERID" FieldStyle="text-transform:uppercase;" Cls="inputText" runat="server" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_USERNM" runat="server" /> <%--Text="사용자명--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_USERNM" Cls="inputText" runat="server" />
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_SYSCD" runat="server" /> <%--Text="시스템코드" --%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SYSCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="SYSTENAME" ValueField="SYSTEMCODE" TriggerAction="All">
                                    <Store>
                                        <ext:Store ID="Store5" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="SYSTEMCODE" />
                                                        <ext:ModelField Name="SYSTENAME" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_USER_DIV" runat="server" /><%-- Text="사용자구분" --%>
                            </th>
                            <td >
                              <ext:SelectBox ID="cbo01_USER_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPENM" ValueField="OBJECT_ID" TriggerAction="All" >
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model1" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="TYPENM" />
                                                        <ext:ModelField Name="OBJECT_ID" />
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
                    <ext:GridPanel ID="Grid01"  runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="USERID"/>
                                            <ext:ModelField Name="USERNAME"/>
                                            <ext:ModelField Name="LINECD"/>
                                            <ext:ModelField Name="LINENM"/>
                                            <ext:ModelField Name="VENDNM"/>
                                            <ext:ModelField Name="CORCD"/>
                                            <ext:ModelField Name="BIZCD"/>
                                            <ext:ModelField Name="CORCDNM"/>
                                            <ext:ModelField Name="BIZCDNM"/>
                                            <ext:ModelField Name="SYSCD"/>
                                            <ext:ModelField Name="SYSNAME"/>
                                            <ext:ModelField Name="TELNO"/>
                                            <ext:ModelField Name="MOB_PHONE_NO"/>
                                            <ext:ModelField Name="EMAIL_ADDR"/>
                                            <ext:ModelField Name="RETIRE_DATE"/>
                                            <ext:ModelField Name="PLANT_DIV"/>
                                            <ext:ModelField Name="PLANT_DIVNM"/>
                                            <ext:ModelField Name="CERT_COURSE"/>
                                            <ext:ModelField Name="CERT_COURSENM"/>
                                            <ext:ModelField Name="USER_DIV" />                                            
                                            <ext:ModelField Name="USER_DIVNM"/>
                                            <ext:ModelField Name="VENDORCD"/>
                                            <ext:ModelField Name="CUSTCD"/>
                                            <ext:ModelField Name="EMPNO"/>
                                            <ext:ModelField Name="PWD_VALID_DATE"/>
                                            <ext:ModelField Name="PWD_CHG_DATE"/>
                                            <ext:ModelField Name="PWD_ERR_COUNT"/>
                                            <ext:ModelField Name="ADMIN_FLAG" DefaultValue="false" Type="Boolean" />
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
                            <ext:BufferedRenderer ID="BufferedRenderer1" runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:Column ID="USERID" ItemID="USERID" runat="server" DataIndex="USERID" Width="100" Align="Center" />  <%--Text="사용자 아이디"--%> 
                                <ext:Column ID="USERNAME" ItemID="USERNAME" runat="server" DataIndex="USERNAME" Width="100" Align="Center" />  <%--Text="사용자명"--%> 
                                <ext:Column ID="LINECD" ItemID="LINECD" runat="server" DataIndex="LINECD" Width="0" Align="Left" />  <%--Text="라인코드"--%> 
                                <ext:Column ID="LINENM" ItemID="LINENM" runat="server" DataIndex="LINENM" Width="140" Align="Left" Hidden="true" />  <%--Text="라인명"--%> 
                                <ext:Column ID="VENDNM" ItemID="VENDORNM" runat="server" DataIndex="VENDNM" Width="140" Align="Left" />  <%--Text="거래처명"--%>
                                <ext:Column ID="CORCD" ItemID="CORCD" runat="server" DataIndex="CORCDNM" Width="80" Align="Center" />  <%--Text="법인코드"--%> 
                                <ext:Column ID="BIZCD" ItemID="BIZCD" runat="server" DataIndex="BIZCDNM" Width="80" Align="Center" />  <%--Text="사업장코드"--%> 
                                <ext:Column ID="SYSCD" ItemID="SYSCD" runat="server" DataIndex="SYSCD" Width="70" Align="Center" />  <%--Text="시스템코드"--%> 
                                <ext:Column ID="SYSNAME" ItemID="SYSNAME" runat="server" DataIndex="SYSNAME" Width="120" Align="Left" />  <%--Text="시스템명"--%> 
                                <ext:Column ID="TELNO" ItemID="TELNO" runat="server" DataIndex="TELNO" Width="100" Align="Left" />  <%--Text="전화번호"--%> 
                                <ext:Column ID="MOB_PHONE_NO" ItemID="MOB_PHONE_NO" runat="server" DataIndex="MOB_PHONE_NO" Width="100" Align="Left" />  <%--Text="휴대전화"--%> 
                                <ext:Column ID="EMAIL_ADDR" ItemID="EMAIL_ADDR" runat="server" DataIndex="EMAIL_ADDR" Width="120" Align="Left" />  <%--Text="전자메일"--%> 
                                <ext:Column ID="RETIRE_DATE" ItemID="RETIRE_DATE" runat="server" DataIndex="RETIRE_DATE" Width="80" Align="Center" />  <%--Text="퇴사일자"--%> 
                                <ext:Column ID="PLANT_DIV" ItemID="PLANT_DIV" runat="server" DataIndex="PLANT_DIV" Width="0" Align="Left" />  <%--Text="공장구분"--%> 
                                <ext:Column ID="PLANT_DIVNM" ItemID="PLANT_DIV" runat="server" DataIndex="PLANT_DIVNM" Width="100" Align="Left" />  <%--Text="공장구분"--%> 
                                <ext:Column ID="CERT_COURSE" ItemID="CERT_COURSE" runat="server" DataIndex="CERT_COURSE" Width="0" Align="Left" />  <%--Text="인증경로"--%> 
                                <ext:Column ID="CERT_COURSENM" ItemID="CERT_COURSE" runat="server" DataIndex="CERT_COURSENM" Width="100" Align="Left" />  <%--Text="인증경로"--%> 
                                <ext:Column ID="USER_DIV" ItemID="USER_DIV" runat="server" DataIndex="USER_DIV" Width="0" Align="Left" />  <%--Text="사용자구분"--%> 
                                <ext:Column ID="USER_DIVNM" ItemID="USER_DIV" runat="server" DataIndex="USER_DIVNM" Width="80" Align="Left" />  <%--Text="사용자구분"--%> 
                                <ext:Column ID="EMPNO" ItemID="EMPNO" runat="server" DataIndex="EMPNO" Width="60" Align="Left" />  <%--Text="사번"--%> 
                                <ext:Column ID="VENDORCD" ItemID="VENDORCD" runat="server" DataIndex="VENDORCD" Width="80" Align="Left" />  <%--Text="거래처코드"--%> 
                                <%--<ext:Column ID="CUSTCD" ItemID="CUSTCD" runat="server" DataIndex="CUSTCD" Width="80" Align="Left" />--%>  <%--Text="고객사코드"--%> 
                                <ext:Column ID="PWD_VALID_DATE" ItemID="PWD_VALID_DATE" runat="server" DataIndex="PWD_VALID_DATE" Width="100" Align="Center" />  <%--Text="패스워드 유효일"--%> 
                                <ext:Column ID="PWD_CHG_DATE" ItemID="PWD_CHG_DATE" runat="server" DataIndex="PWD_CHG_DATE" Width="100" Align="Center" />  <%--Text="패스워드 변경일"--%> 
                                <ext:Column ID="PWD_ERR_COUNT" ItemID="PWD_ERR_COUNT" runat="server" DataIndex="PWD_ERR_COUNT" Width="110" Align="Center" />  <%--Text="패스워드오류 횟수"--%>
                                <ext:CheckColumn ID ="ADMIN_FLAG" ItemID="ADMIN_FLAG" runat="server" DataIndex="ADMIN_FLAG" Width="80" Align ="Center" StopSelection="false" 
                                    Editable="false" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="사용"--%>
                                </ext:CheckColumn>                                 
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
                        <DirectEvents>                         
                            <Select OnEvent="RowSelect">
                                <ExtraParams>
                                    <ext:Parameter Name="Values" Value="this.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                </ExtraParams>
                            </Select>
                        </DirectEvents>
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
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5" ID="btnRowAdd"></ext:ImageButton>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_deleterow.gif" ID="btnRowDelete"></ext:ImageButton>
                </Items>
            </ext:Panel>
            <%--ContentPanel 의 Width, StyleSpec 내용은 Region 이 South 일 경우 필요 없음--%>
            <ext:Panel ID="ContentPanel" Cls="bottom_area_table" runat="server" Region="South" Height="216">
                <Content>
                    <table id="tableContent" style="height:0px;">
                        <colgroup>
                            <col style="width: 100px;" />
                            <col style="width: 150px;" />
                            <col style="width: 100px;" />
                            <col style="width: 150px;" />
                            <col style="width: 100px;" />
                            <col style="width: 150px;" />
                            <col/>
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_USERID" runat="server" />
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer1" runat="server" MsgTarget="Side" Layout="TableLayout" Width="130px">
                                    <Items>
                                        <ext:TextField ID="txt02_USERID" Cls="inputText"  FieldStyle="text-transform:uppercase;" runat="server" MaxLength="10" Width="80px" EnforceMaxLength="true" />   
                                        <ext:Label ID="Label1" runat="server" Text="(10자리)"/>
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl02_USERNAME" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt02_USERNAME" Cls="inputText" runat="server"/>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl02_USER_DIV" runat="server" /><%-- Text="사용자구분" --%>
                            </th>
                            <td>
                              <ext:SelectBox ID="cbo02_USER_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPENM" ValueField="OBJECT_ID" TriggerAction="All">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="TYPENM" />
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <Listeners>
                                    <%--4.X--%>
                                        <Select Fn="fn_UserDivComboChange"></Select>
                                    </Listeners>
                                </ext:SelectBox>
                            </td> 
                            <td rowspan="2" style="border-left:1px solid #b1b1b1; vertical-align:middle !important;">
                                <ext:Button ID="btn01_CLEAR_PWD" runat="server" Height="55" Width="105" TextAlign="Center" > <%--Text="비밀번호 초기화"--%>
                                    <Listeners>
                                        <Click Fn="fn_pwd_btn_click" />
                                    </Listeners>
                                </ext:Button>                               
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_EMPNO" runat="server" /> <%--Text="사번"--%> 
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx02_EMPNO" runat="server" HelperID="HELP_EMPNO" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                            <th >
                                <ext:Label ID="lbl02_TELNO" runat="server" /> <%--Text="전화번호"--%> 
                            </th>
                            <td colspan="3">
                                <ext:TextField ID="txt02_TELNO" Cls="inputText" runat="server"/>
                            </td>                            
                        </tr> 
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_VENDORCD" runat="server" /> <%--Text="업체코드"--%> 
                            </th>
                            <td >
                                <epc:EPCodeBox ID="cdx02_VENDCD" runat="server" HelperID="HELP_VENDCD_FREE" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl02_LINECD" runat="server" /> <%--Text="라인코드"--%> 
                            </th>
                            <td colspan="3">
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD_FREE" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>
                            <td rowspan="2"  style="border-left:1px solid #b1b1b1; vertical-align:middle !important;">
                            <ext:Button ID="btn02_ERROR_CLEAR" runat="server" Height="55" Width="105" TextAlign="Center" > <%--Text="오류 초기화"--%>
                                    <Listeners>
                                        <Click Fn="fn_error_btn_click" />
                                    </Listeners>
                                </ext:Button>     </td>
                        </tr> 
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_CORCD" runat="server" /> <%--Text="법인코드"--%> 
                            </th>
                            <td>
                              <ext:SelectBox ID="cbo02_CORCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPENM" ValueField="OBJECT_ID" TriggerAction="All" >
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
                                </ext:SelectBox>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl02_BIZCD" runat="server" />
                            </th>
                            <td colspan="3">
                                <ext:SelectBox ID="cbo02_BIZCD" ItemID="BIZCD" runat="server" Cls="inputText"  Mode="Local" ForceSelection="true"
                                    DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" >
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
                            
                            <%--<th>
                                <ext:Label ID="lbl02_LINECD" runat="server" /> 
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx02_LINECD" runat="server" HelperID="USER_LINECD" PopupMode="Search" PopupType="UserWindow" 
                                                OnCustomRemoteValidation="CodeBox_LinecdRemoteValidation"
                                                OnBeforeDirectButtonClick="CodeBox_BeforeDirectButtonClick"
                                                UserHelpURL="EP_XM22001P1.aspx"
                                                WidthTYPECD="120px"
                                                 />
                            </td>--%>
                        </tr>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_RETIRE_DATE" runat="server" />  <%--Text="퇴사일자"--%>
                            </th>
                            <td>
                                <ext:DateField ID="df02_RETIRE_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                            </td>

                            <th class="ess">
                                <ext:Label ID="lbl02_PLANT_DIV" runat="server" /> <%--Text="공장구분"--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo02_PLANT_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store7" runat="server" >
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
                                </ext:SelectBox>                            
                            </td> 
                            <th>
                                <ext:Label ID="lbl02_MOB_PHONE_NO" runat="server" /> <%--Text="휴대전화"--%> 
                            </th>
                            <td>
                                <ext:TextField ID="txt02_MOB_PHONE_NO" Cls="inputText" runat="server"/>
                            </td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_SYSCD" runat="server" /> <%--Text="시스템코드" --%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo02_SYSCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="SYSTENAME" ValueField="SYSTEMCODE" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store8" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model7" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="SYSTEMCODE" />
                                                        <ext:ModelField Name="SYSTENAME" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            <th class="ess">
                                <ext:Label ID="lbl02_CERT_COURSE" runat="server" /> <%--Text="인증경로" --%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo02_CERT_COURSE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPENM" ValueField="OBJECT_ID" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store9" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model8" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="TYPENM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>
                            <th>
                                <ext:Label ID="lbl02_EMAIL_ADDR" runat="server" /> <%--Text="전자메일" --%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_EMAIL_ADDR" Cls="inputText" runat="server"/>
                            </td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>     
                            <th>
                                <ext:Label ID="lbl02_ADMIN_FLAG" runat="server"  /> <%--Text="관리자 여부" --%>
                            </th>
                            <td colspan="5">
                                <ext:Checkbox ID="chk02_ADMIN_FLAG" runat="server" Width="150" Cls="inputText" />  <%--Text="관리자 여부"--%>
                            </td>
                            <%--
                            <th>
                                <ext:Label ID="lbl02_USEYN" runat="server"  /> 
                            </th>
                            <td colspan="3">
                                <ext:Checkbox ID="chk02_USEYN" runat="server" Width="150" Cls="inputText" /> 
                            </td>--%>
                            <td>&nbsp;</td>
                        </tr>                       
                    </table>
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
