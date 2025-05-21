<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM20006.aspx.cs" Inherits="Ax.EP.WP.Home.EP_XM.EP_XM20006" %>
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
	    .x-grid-cell-AUTHNAME DIV,	 
	    .x-grid-cell-DESCRIPTION DIV
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
            //화면 리사이즈까지 완료 후, 조회버튼 클릭 이벤트 발생시킨다. (화면 표시후 디폴트 조회 로직)
            App.ButtonSearch.fireEvent('click');
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
             
    </script>
</head>
<body>
    <form id="EP_XM20006" runat="server">
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
                    <ext:Label ID="lbl01_EP_XM20006" runat="server" Cls="search_area_title_name" /><%--Text="확장버튼권한설정" />--%>
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
                            <col />
                        </colgroup>
                        <tr>
							<th>
                                <ext:Label ID="lbl01_SYSTEMCODE" runat="server" /><%--Text="System" />--%>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SYSTEMCODE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="SYSTENAME" ValueField="SYSTEMCODE" TriggerAction="All" Width="115">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
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
                                            <ext:ModelField Name="NO" /> 
                                            <ext:ModelField Name="AUTHINDEX" />
                                            <ext:ModelField Name="SYSTEMCODE"/>
                                            <ext:ModelField Name="AUTHNAME"/>
                                            <ext:ModelField Name="DESCRIPTION"/>
                                            <ext:ModelField Name="USE_YN"/>
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
                                <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                    <Renderer Fn="rendererNo" />
                                </ext:Column>
                                <ext:Column ID="AUTHINDEX" ItemID="AUTHINDEX" runat="server" DataIndex="AUTHINDEX" Width="100" Align="Center"/> <%--Text="확장권한순번"--%>
                                <ext:Column ID="SYSTEMCODE" ItemID="SYSTEMCODE" runat="server" DataIndex="SYSTEMCODE" Width="80" Align="Left" /> <%--Text="System"  --%>
                                <ext:Column ID="AUTHNAME" ItemID="AUTHNAME" runat="server"  DataIndex="AUTHNAME"   Width="140" Align="Left" >
                                    <Editor>
                                        <ext:TextField ID="txt02_AUTHNAME" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column> <%--Text="확장권한명"    --%>
                                <ext:Column ID="DESCRIPTION" ItemID="DESCRIPTION" runat="server" DataIndex="DESCRIPTION" MinWidth="300" Align="Left">
                                    <Editor>
                                        <ext:TextField ID="txt02_DESCRIPTION" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" />
                                    </Editor>
                                </ext:Column> <%--Text="DESCRIPTION"--%>
                                <ext:CheckColumn ID ="USE_YN" ItemID="USE_YN" runat="server" DataIndex="USE_YN" Width="80" Align ="Center" StopSelection="false" 
                                    Editable="true" MenuDisabled="true" Resizable="false" Sortable="false" Selectable="true" ><%--Text="적용유무"--%>
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
