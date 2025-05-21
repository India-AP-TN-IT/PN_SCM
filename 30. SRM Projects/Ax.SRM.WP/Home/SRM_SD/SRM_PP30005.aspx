<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_PP30005.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_SD.SRM_PP30005" %>
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

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }
          
    </script>
</head>
<body>
    <form id="SRM_PP30005" runat="server">
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
                    <ext:Label ID="lbl01_SRM_PP30005" runat="server" Cls="search_area_title_name" /><%--Text="조립 작업지시 조회" />--%>
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
                            <th class="ess">
                                <ext:Label ID="lbl01_BIZCD" runat="server" /><%--Text="Business Code" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="SelectBox01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
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
                                <ext:Label ID="lbl01_WORK_DATE3" runat="server" /><%--Text="일자" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_BEG_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">
                               <ext:Label ID="lbl01_LINECD" runat="server" /><%--Text="라인코드" />--%>
                            </th>
                            <td> 
                                <%--<epc:EPCodeBox ID="cdx01_LINECD" runat="server" HelperID="HELP_LINE" PopupMode="Search" PopupType="UserWindow" 
                                                OnBeforeDirectButtonClick="CodeBox_BeforeDirectButtonClick"
                                                OnCustomRemoteValidation="CodeBox_CustomRemoteValidation"
                                                UserHelpURL="../SCMHelper/SCM_PopLine.aspx"
                                                 />--%>
                                <epc:EPCodeBox ID="cdx01_LINECD" runat="server" HelperID="HELP_LINE" PopupMode="Search" PopupType="HelpWindow"
                                                OnBeforeDirectButtonClick="CodeBox_BeforeDirectButtonClick"/>
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_INSTALL_POS" runat="server" /><%--Text="위치" />   --%>                    
                            </th>
                            <td>
                                <%--<epc:EPCodeBox ID="cdx01_INSTALL_POS" OnDirectEventChange="Button_Click" runat="server" ClassID="A7" PopupMode="Search" PopupType="CodeWindow"/>--%>
                                <ext:SelectBox ID="SelectBox01_INSTALL_POS" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPENM" ValueField="OBJECT_ID" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="TYPENM" />
                                                        <ext:ModelField Name="TYPECD" />
                                                        <ext:ModelField Name="SORT_SEQ" />
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
                                            <ext:ModelField Name="RN" />
                                            <ext:ModelField Name="PLAN_DATE" />                                            
                                            <ext:ModelField Name="INSTALL_POS" />
                                            <ext:ModelField Name="JOB_TYPE" />
                                            <ext:ModelField Name="DN" />
                                            <ext:ModelField Name="ALCCD" />
                                            <ext:ModelField Name="PLAN_QTY" />
                                            <ext:ModelField Name="LEVCD" />
                                            <ext:ModelField Name="KEY_COL" />
                                            <ext:ModelField Name="ASSY_COLOR" />
                                            <ext:ModelField Name="ETC_COLOR1" />
                                            <ext:ModelField Name="TIMECD" />
                                            <ext:ModelField Name="WORK_SEQ" />
                                            <ext:ModelField Name="SPEC" />
                                            <ext:ModelField Name="BGCOLOR" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="MAP_PKT_YN" />
                                            <ext:ModelField Name="IMPACT_PAD" />
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
                                <ext:RowNumbererColumn ID="NO"          ItemID="NO"          runat="server" Text="No"                           Width="40"     Align="Center" />
                                <ext:DateColumn        ID="DD"          ItemID="DD"   runat="server" DataIndex="PLAN_DATE"   Width="100" Align="Center" /><%--Text="일자"--%>    
                                <ext:Column            ID="INSTALL_POS" ItemID="POS1" runat="server" DataIndex="INSTALL_POS" Width="70"  Align="Center" /><%--Text="POS"--%>
                                <ext:Column            ID="JOB_TYPE"    ItemID="DIVISION"    runat="server" DataIndex="JOB_TYPE"    Width="70"  Align="Left" /><%--Text="구분"--%> 
                                <ext:Column            ID="DN"          ItemID="DN"          runat="server" DataIndex="DN"          Width="70"  Align="Left" /><%--Text="DN"--%>  
                                <ext:Column            ID="ALC"         ItemID="ALC"         runat="server" DataIndex="ALCCD"       Width="80"  Align="Left" /><%--Text="ALC"--%>
                                <ext:NumberColumn      ID="QTY"         ItemID="QTY"         runat="server" DataIndex="PLAN_QTY"    Width="90"  Align="Right"  Format="#,##0.###"/><%--Text="수량"--%>                              
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
