<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM23002.aspx.cs" Inherits="Ax.EP.WP.Home.EPAdmin.EP_XM23002" %>
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

    <title>Notice Management</title>

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

            if (App.heb02_CONTENTS) {
                // 내용창의 리사이징을 위해 기본값인 22로 복구했다가 다시 리사이징 처리
                App.heb02_CONTENTS.setHeight(22);
                App.heb02_CONTENTS.setHeight(App.ContentPanel.getHeight() - document.getElementById("tableContent").clientHeight + 22 - 3);
            }
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        var Popup;

        var newWindowPop = function (param, width, height) {
            Popup = new Ext.Window({
                id: "Popup_" + param + "_" + (new Date()).getTime(),
                renderTo: Ext.getBody(),
                modal: true,
                layout: 'absolute',
                width: width - 40,
                height: height,
                title: "Notice",
                closable: true,
                minimizable: false,
                resizable: true,
                maximizable: true,
                moveable: false,
                hidden: false,
                loader: {
                    loadMask: {
                        showMask: true,
                        msg: "Loading……"
                    },
                    autoLoad: true,
                    renderer: "frame",
                    encode: true,
                    url: "../EPAdmin/EP_XM23001P1.aspx?param1=" + param
                }
            });
        }




        //최근 일주일 내에 등록된 공지는 제목 옆에 "N"이미지 표시
        var TitleNew = function (value, meta, record) {
            var template = '{0}<span class="new_icon"><img  src="../../images/main/new_icon.gif" /></span>';

            if (getDateDiff(getEPTimeStamp(), record.data['FNL_UPDATE_DTTM']) < 7) {

                return Ext.String.format(template, value);

            }
            else {
                return value;
            }
          
        }

      
    </script>
</head>
<body>
    <form id="EP_XM23002" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:Hidden ID="hid02_FILEID1" runat="server" />
    <ext:Hidden ID="hid02_FILEID2" runat="server" />
    <ext:Hidden ID="hid02_FILEID3" runat="server" />
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_EP_XM23002" runat="server" Cls="search_area_title_name" Text="공지사항" />
                    <ext:Panel ID="ButtonPanel" runat="server" StyleSpec="width:100%" Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>           
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model runat="server">
                                        <Fields>
                                            <ext:ModelField Name="NOTICE_SEQ" />
                                            <ext:ModelField Name="SUBJECT" />
                                            <ext:ModelField Name="IMPT_DIVNM" />
                                            <ext:ModelField Name="NOTICE_DATE" />
                                            <ext:ModelField Name="STATUS" />
                                            <ext:ModelField Name="FNL_UPDATE_DTTM" />
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
                                <ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />
                                <ext:Column ID="NOTICE_SEQ" runat="server" Text="Seq" DataIndex="NOTICE_SEQ" Hidden="true" />
                                <ext:Column ID="SUBJECT" ItemID="SUBJECT" runat="server" Text="Subject" DataIndex="SUBJECT" Flex="1" Align="Left" MinWidth="150" >
                                    <Renderer Fn="TitleNew" />
                                </ext:Column>
                                <ext:Column ID="IMPT_DIVNM" ItemID="IMPT_DIV" runat="server" Text="Important" DataIndex="IMPT_DIVNM" Width="70" Align="Center" />
                                <ext:DateColumn ID="NOTICE_DATE" runat="server" Text="Date" DataIndex="NOTICE_DATE" Width="85" Align="Center" />
                                <ext:Column ID="STATUS" runat="server" Text="Status" DataIndex="STATUS" Width="65" Align="Center" />
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView runat="server" EnableTextSelection="true"/>
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
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."/>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
            
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
