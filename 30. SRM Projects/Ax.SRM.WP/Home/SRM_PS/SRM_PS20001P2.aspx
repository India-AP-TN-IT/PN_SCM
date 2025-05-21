<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_PS20001P2.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_PS.SRM_PS20001P2" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico" itemprop="image">
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>Customer Search Popup</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
            App.txt01_CUSTCD.focus();
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

        var fn_sendParentWindow = function (popupID, objectID, typeNM, typeCD, record) {
            parent.fn_UserSetValues(popupID, objectID, "", typeCD, Ext.decode(record));
        }
    </script>
</head>
<body>
    <form id="SRM_PS20001P1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="0" Cls="pdb10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <%-- 숨겨 사용하기 ^^;;; --%>
            <ext:TextField ID="txt01_ID" runat="server" Hidden="true" />
            <ext:TextField ID="txt01_TYPE" runat="server" Hidden="true" />
            <ext:Panel ID="TitlePanel" runat="server" Region="North">
                <Content>
                    <div class="popup_area">
                        <h1>
                            <ext:Label ID="lbl01_SRM_PS20001P1" runat="server" Text="대포장코드가져오기" />
                            <ext:ImageButton ID="btn01_CLOSE" runat="server" ImageUrl="../../images/main/close.gif" Cls="pop_close" >
                                <Listeners>
                                    <Click Handler="hidePop()" />
                                </Listeners>
                            </ext:ImageButton>
                        </h1>
                    </div>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ButtonPanel" runat="server" Height="30" Region="North" Cls="search_area_title_btn lrmargin10">
                <Items>
                    <%-- 상단 이미지버튼 --%>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table lrmargin10" runat="server">
                <Content>
                    <table style="height:0px">
                        <colgroup>
                            <col style="width:80px;" />                            
                            <col style="width:110;" />    
                            <col style="width:80px;" />   
                            <col style="width:140;" />     
                            <col style="width:80px;" />   
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_LARGE_PACKCODE" runat="server" Width="80" Text="대포장코드" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_LARGE_PACKCODE" runat="server" Width="105"></ext:TextField>
                            </td>                            
                            <th>
                                <ext:Label ID="Label1" runat="server" Width="80" Text="대포장명" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_LARGE_PACKNM" runat="server" Width="150"></ext:TextField>
                            </td>   
                            <th>
                                <ext:Label ID="Label2" runat="server" Width="80" Text="사용여부" />
                            </th>
                            <td>
                                <ext:ComboBox ID="cbo01_USE_YN" runat="server"  Mode="Local" 
                                    TriggerAction="All" Width="60" Editable="false"  >
                                    <Items>                                    
                                        <ext:ListItem Value="%" Text="전체" />            
                                        <ext:ListItem Value="TZ1" Text="사용" />
                                        <ext:ListItem Value="TZ0" Text="미사용" />
                                    </Items>
                                </ext:ComboBox>
                            </td>                                                       
                        </tr>
                    </table>                    
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area lrmargin10">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server"  ColumnLines="true" StripeRows="true" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="Model1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="CASE_TYPE_NM" />
                                            <ext:ModelField Name="PLT_TYPE_NM" />                                            
                                            <ext:ModelField Name="CASE_CD" />
                                            <ext:ModelField Name="SIZE_FULL" />
                                            <ext:ModelField Name="CASE_SIZEX" />
                                            <ext:ModelField Name="CASE_SIZEY" />
                                            <ext:ModelField Name="CASE_SIZEZ" />
                                            <ext:ModelField Name="CASE_NM" />
                                            <ext:ModelField Name="PREV_CASE_CD" />
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
                        <ColumnModel ID="ColumnModel2" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO" runat="server" Width="45" Text="No" Align="Center" />
                                <ext:Column ID="CASE_CD" ItemID="CASE_CD" runat="server" DataIndex="CASE_CD" Width="80" Align="Center"  Text="포장코드" />
                                <ext:Column ID="CASE_TYPE_NM" ItemID="CASE_TYPE_NM" runat="server" DataIndex="CASE_TYPE_NM" Width="120" Align="left" Text="포장유형" />
                                <ext:Column ID="PLT_TYPE_NM" ItemID="PLT_TYPE_NM" runat="server" DataIndex="PLT_TYPE_NM" Width="120" Align="left" Text="팔레트유형" />                                
                                <ext:Column ID="SIZE_FULL" ItemID="SIZE_FULL" runat="server" DataIndex="SIZE_FULL" Width="140" Align="left"  Text="포장사이즈" Flex="1" />                                
                                <ext:Column ID="PREV_CASE_CD" ItemID="PREV_CASE_CD" runat="server" DataIndex="PREV_CASE_CD" Width="100" Align="Center"  Text="이전포장코드" />
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel" Mode="Single" runat="server" />
                        </SelectionModel>
                        <DirectEvents>
                            <CellDblClick OnEvent="GridPanel_RowDblClick">
                                <ExtraParams>
                                    <ext:Parameter Name="Values" Value="this.getRowsValues({selectedOnly:true})" Encode="true" Mode="Raw" />
                                </ExtraParams>
                            </CellDblClick>
                        </DirectEvents>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..." />
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
