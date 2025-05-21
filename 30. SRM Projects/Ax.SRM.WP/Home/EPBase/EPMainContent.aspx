<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EPMainContent.aspx.cs" Inherits="Ax.EP.WP.Home.EPBase.EPMainContent" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image">
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>Main Contents Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="/Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {

        }

        function UI_Resize() {

        }

        var newWindowPop2 = function (param1, width, height, pkgId, uiId, helpId) {
            new top.Ext.Window({
                id: pkgId,
                renderTo: top.Ext.getBody(),
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
                    url: "../EPAdmin/" + uiId + ".aspx?NOTICE_SEQ=" + param1 + "&ID=" + helpId + ""
                }
            });
        }

        var newWindowPop = function (param, width, height) {
            new top.Ext.Window({
                id: "Popup_" + param + "_" + (new Date()).getTime(),
                renderTo: top.Ext.getBody(),
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

        var newChartPop = function (param1, param2, param3, param4, width, height) {
            new top.Ext.Window({
                id: "Popup",
                renderTo: top.Ext.getBody(),
                modal: true,
                layout: 'absolute',
                width: width - 40,
                height: height,
                title: param1,
                closable: true,
                resizable: true,
                maximizable: true,
                hidden: false,
                loader: {
                    loadMask: {
                        showMask: true,
                        msg: "Loading……"
                    },
                    renderer: "frame",
                    encode: true,
                    url: "EPMainChart.aspx?BizName=" + param1 + "&BizCode=" + param2 + "&type=" + param3 + "&index=" + param4 + "&expand=1"
                }
            });
        }

        var addTabcontents = function (success, errorMsg, id, url, title, param1, param2, type, index) {
            var tab1 = TabPanel1.getComponent(id);
            if (!tab1) {
                tab1 = TabPanel1.add({
                    id: id,
                    title: title,
                    tabTip: param1,
                    closable: false,
                    loader: {
                        url: url,
                        renderer: "frame",
                        loadMask: {
                            showMask: true,
                            msg: "Data Loading " + title + "..."
                        },
                        params:
                        {
                            "BizName": param1
                            , "BizCode": param2
                            , "type": type
                            , "index": index
                        }
                    }
                });
            }
            TabPanel1.setActiveTab(tab1);
        }

        var addTabcontents2 = function (success, errorMsg, id, url, title, param1, param2, type, index) {
            var tab1 = TabPanel2.getComponent(id);
            if (!tab1) {
                tab1 = TabPanel2.add({
                    id: id,
                    title: title,
                    tabTip: param1,
                    closable: false,
                    loader: {
                        url: url,
                        renderer: "frame",
                        loadMask: {
                            showMask: true,
                            msg: "Data Loading " + title + "..."
                        },
                        params:
                        {
                            "BizName": param1
                            , "BizCode": param2
                            , "type": type
                            , "index": index
                        }
                    }
                });
            }
            TabPanel2.setActiveTab(tab1);
        }

        var addTabChange = function (success, errorMsg, id, url, title, param1, param2) {
            var tab = TabPanel1.getComponent(id);
            tab.body.load({ url: url, params: { containerId: tab.body.id }, scripts: true });
        }

        var showTab = function (type) {
            if (Ext == null) return;
            if (type == '1') {
                App.TabPanel1.show();
                TabPanel1.setActiveTab(0);
            } else {
                App.TabPanel2.show();
                TabPanel2.setActiveTab(0);
            }
        }

        //공지사항 화면 메뉴 열기
        function openNotice() {
            App.direct.OpenNotice();
        }

        //협력업체 게시판 화면 메뉴 열기
        function openVendorNotice() {
            App.direct.OpenVendorNotice();
        }

        //입고품 불량내용 조회 화면 메뉴 열기
        function openQA30001() {
            App.direct.OpenQA30001();
        }

        //최근 일주일 내에 등록된 공지는 제목 옆에 "N"이미지 표시
        var TitleNew = function (value, meta, record) {

            var template = '{0}<span class="new_icon"><img  src="../../images/main/new_icon.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" /></span>';
            style = {};
            style.fontSize = 10;
            style.fontStyle = "";
            style.fontWeight = "";
            style.fontFamily = "";

            if (getDateDiff(getEPTimeStamp(), record.data['FNL_UPDATE_DTTM'].toString().substring(0, 10)) < 7) {

                return Ext.String.format(template, Ext.util.Format.EllipsisPix(style, value, 246));

            }
            else {
                return value;
            }

            //if (getDateDiff(getEPTimeStamp(), record.data['FNL_UPDATE_DTTM'].toString().substring(0, 10)) < 7) {

            //    meta.attr += 'style="color:blue;"';
            //}
            //return value;
        }

        //글자가 영역보다 클 경우 ...(말줄임표)표시하도록 하는 부분 재정의
        //폰트사이즈 지정하여 해당 폰트로 글자를 표시했을 때의 특정 너비이상되면 그 너비까지 글자 자르고 "..." 표시되도록~
        //신규 글일 경우 제목 옆에 "N" 이미지 표시되는데,  N 이미지가 컬럼 너비 바깥에 위치하여 안보이는 경우가 있어서 이 로직 추가함.
        Ext.apply(Ext.util.Format, {
            EllipsisPix: function (style, text, fixedWidth) {

                attributes = {};
                attributes.style = style;
                attributes.tag = 'div';
                attributes.id = 'EllipsisPix'

                Ext.DomHelper.append(document.body, attributes);

                var string_length = Ext.util.TextMetrics.measure(Ext.get('EllipsisPix'), text);
                if (string_length.width > fixedWidth) {
                    var text = text.replace("...", "");
                    var nString = Ext.util.Format.EllipsisPix(style, text.substr(0, (text.length - 2)) + "...", fixedWidth);
                    // please note: I cut off 2 chars each time
                }
                else {
                    var nString = text;
                }
                return nString;
            }
        });


        var getRowClass = function (record) {
            if (record.data["OVERDATED"] == "1") {
                return "over-date-row";
            }
            else {
                //    return "notover-date-row";
            }
        };

        var onShow = function (toolTip, grid) {
            var view = grid.getView(),
                store = grid.getStore(),
                record = view.getRecord(view.findItemByChild(toolTip.triggerElement)),
                column = view.getHeaderByCell(toolTip.triggerElement),
                data = "[" + record.get("VENDCD") + "] " + record.get("VENDNM");

            toolTip.update(data);
        };  
    </script>
    <style type="text/css">
        /*
        .x-grid-body {border-top-color: silver; border-top:0 !important;}
       .x-grid-table {table-layout: fixed;border-collapse: separate; border:0 !important;}
       
       .x-grid-table    {background:url(../../images/main/m_li_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-y !important; height:27px !important;}
       .x-grid-table tr {}
       .x-grid-table td { background:none;}
       */
       .x-grid-cell-inner  { padding-top:6px; padding-left:21px; height:27px !important;}
       .x-grid-row-alt .x-grid-td {background:none;}
       /*.x-grid-item-alt{ background-color: White !important;} /*4.X*/
       .x-grid-item{background:url(../../images/main/m_li_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-y !important;}
       
        
        .x-grid-item-over .x-grid-td {border-top-width:0px;  border-bottom-width:0px;  
                                      border-top-style: solid; border-top-color: #c8c8c8;border-bottom-style: solid; border-bottom-color: #c8c8c8; 
                                      /* over 시 하단라인색 */ }
       .x-grid-item-over .x-grid-td { background-color:#e8e8e8 !important;}   
                                     
       .x-grid-item-selected .x-grid-td {border-top-width:0px;  border-bottom-width:0px;  
                                      border-top-style: solid; border-top-color: #056fbc;border-bottom-style: solid; border-bottom-color: #056fbc;  /* selected 시 하단 라인색 */ }                                                         
       .x-grid-item-selected .x-grid-td { background-color: #309ae8; color:White !important; /* selected 시 배경색 */ }
                  
       .x-grid-with-row-lines .x-grid-item{border-bottom-width:0px !important;border-top-width:0px;}
       .x-grid-cell {font: normal 12px Tahoma, Arial, "돋움","굴림", Gulim, Helvetica, AppleGothic, Sans-serif !important;}
       /*.x-grid-cell {color: null;font: normal 12px/12px helvetica,arial,verdana,sans-serif;background-color: white;border-color: #ededed;border-style: solid;}*/
       .x-grid-td {overflow: hidden;border-width: 0;vertical-align: top;}
       
       .x-grid-row-focused  { background:#309ae8 !important;}
       .x-grid-row-focused .x-grid-cell-inner   { color:#fff !important;}
       /*.x-grid-cell-inner   {color:#222 !important;}*/
       #Panel1{overflow:auto;}
       #RcvDefGrid-body .x-grid-cell-inner  { padding-top:6px; padding-left:2px; height:27px !important;}
       .x-grid-cell-RCV_DATE { padding-left:21px; }
       .over-date-row .x-grid-cell-REPLY_DEM_DATE DIV,
        .over-date-row .x-grid-cell-RCV_DATE DIV,
        .over-date-row .x-grid-cell-VINCD DIV,
        .over-date-row .x-grid-cell-PARTNM DIV,
        .over-date-row .x-grid-cell-DEFNM DIV,
        .over-date-row .x-grid-cell-BIZNM DIV
	    {	
		    color:red;
	    }  
    
       </style>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ResourceManager ID="ResourceManager1" runat="server">
            <Listeners>
                <DocumentReady Handler="ExtDocumentReady();" />
            </Listeners>
        </ext:ResourceManager>
        <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" StyleSpec="overflow:auto;" Width="775" Padding="20" Height="667" >
            <Listeners>
                <Resize Fn="UI_Resize">
                </Resize>
            </Listeners>
            <Items>
                <ext:Panel ID="Panel1" runat="server" Cls="width_size">
                    <Content>
                        <div class="main_content">
	                        <div class="main_v">
                                <img src="../../images/main/main_visual.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>">
                            </div>
                            <!--공지사항-->
                            <div class="m_1"><ext:Label ID="lbl01_NOTICE" runat="server" Cls="m_t" />
                                <div class="m_more">
                                    <ext:ImageButton ID="btn01_OpenNotice" runat="server" ImageUrl="../../images/main/more_icon.gif" >
                                        <Listeners>
                                            <Click Handler="openNotice()" />
                                        </Listeners>
                                    </ext:ImageButton>
                                </div>
    	                        <div class="m_c">
        	                        <ext:GridPanel ID="NoticeGrid" runat="server" Width="375" Height="160" EmptyText="No Records To Display..."
                                        StripeRows="true" TrackMouseOver="true" EnableTheming="true" HideHeaders="true"
                                        ColumnLines="false">
                                        <Store>
                                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="Model1" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="NOTICE_SEQ" />
                                                            <ext:ModelField Name="SUBJECT" />
                                                            <ext:ModelField Name="FNL_UPDATE_DTTM" />
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                                <Listeners>
                                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception', 'Load failed: ' + e.message);" />
                                                </Listeners>
                                            </ext:Store>
                                        </Store>
                                        <Plugins>
                                            <ext:BufferedRenderer ID="BufferedRenderer1" runat="server"/>
                                        </Plugins>
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ID="Column1"  runat="server" Width="285" DataIndex="SUBJECT" Css="text-align:left;"
                                                    Header="Subject">
                                                    <Renderer Fn="TitleNew" />                                                   
                                                </ext:Column>
                                                <ext:DateColumn ID="Column2" runat="server" Width="90" DataIndex="FNL_UPDATE_DTTM" Css="text-align:right;"
                                                    Header="RegDate" />
                                            </Columns>
                                        </ColumnModel>
                                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                                            <LoadMask ShowMask="true" />
                                        </Loader>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"/>
                                        </SelectionModel>
                                        <DirectEvents>
                                            <CellClick OnEvent="RowSelect">
                                                <ExtraParams>
                                                    <ext:Parameter Name="Values" Value="App.NoticeGrid.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                                </ExtraParams>
                                            </CellClick>
                                        </DirectEvents>
                                    </ext:GridPanel>
                                </div>
                            </div>

                            <!--협력업체-->
                            <div class="m_2"><ext:Label ID="lbl01_VENDOR_NOTICE" runat="server" Cls="m_t" />
                                <div class="m_more">
                                    <ext:ImageButton ID="btn01_OpenVendorNotice" runat="server" ImageUrl="../../images/main/more_icon.gif" >
                                        <Listeners>
                                            <Click Handler="openVendorNotice()" />
                                        </Listeners>
                                    </ext:ImageButton>
                                </div>
    	                        <div class="m_c">
        	                        <ext:GridPanel ID="VendorNoticeGrid" runat="server" Width="375" Height="160" EmptyText="No Records To Display..."
                                        StripeRows="true" TrackMouseOver="true" EnableTheming="true" HideHeaders="true"
                                        ColumnLines="false">
                                        <Store>
                                            <ext:Store ID="Store2" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="Model2" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="NOTICE_SEQ" />
                                                            <ext:ModelField Name="SUBJECT" />
                                                            <ext:ModelField Name="FNL_UPDATE_DTTM" />
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                                <Listeners>
                                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception', 'Load failed: ' + e.message);" />
                                                </Listeners>
                                            </ext:Store>
                                        </Store>
                                        <Plugins>
                                            <ext:BufferedRenderer ID="BufferedRenderer2" runat="server"/>
                                        </Plugins>
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ID="Column3"  runat="server" Width="285" DataIndex="SUBJECT" Css="text-align:left;"
                                                    Header="Subject">
                                                    <Renderer Fn="TitleNew" />                                                   
                                                </ext:Column>
                                                <ext:DateColumn ID="DateColumn1" runat="server" Width="90" DataIndex="FNL_UPDATE_DTTM" Css="text-align:right;"
                                                    Header="RegDate" />
                                            </Columns>
                                        </ColumnModel>
                                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                            <LoadMask ShowMask="true" />
                                        </Loader>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single"/>
                                        </SelectionModel>
                                        <DirectEvents>
                                            <CellClick OnEvent="VendorRowSelect">
                                                <ExtraParams>
                                                    <ext:Parameter Name="Values" Value="App.VendorNoticeGrid.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                                </ExtraParams>
                                            </CellClick>
                                        </DirectEvents>
                                    </ext:GridPanel>
                                </div>
                            </div>

                            <!--발주현황-->
                            <div class="m_3"><span class="m_t"><ext:Label ID="lbl01_STATUS_PO" runat="server" /></span>
                                <div class="m_c">
        	                        <table width="100%" border="0" cellspacing="1" cellpadding="0" class="tblue">
                                    <colgroup>
                                        <col />
                                        <col style="width: 110px;" />
                                        <col style="width: 110px;" />
                                    </colgroup>
                                        <tr>
                                            <th><ext:Label ID="lbl01_OBJECT_NM" runat="server" /></th>
                                            <th><ext:Label ID="lbl01_DAY_COUNT" runat="server" /></th>
                                            <th><ext:Label ID="lbl01_UNPAID_TOTAL" runat="server" /></th>
                                        </tr>                                        
                                        <tr>
                                            <td class="tt"><ext:Label ID="lbl01_MAIN_DIV_01" runat="server" /></td>
                                            <td><ext:Label ID="lbl01_DATA_11"   runat="server"  /></td>
                                            <td><ext:Label ID="lbl01_DATA_12"   runat="server"  /></td>
                                        </tr>                                        
                                        <tr>
                                            <td class="tt"><ext:Label ID="lbl01_MAIN_DIV_02" runat="server" /></td>
                                            <td><ext:Label ID="lbl01_DATA_21"   runat="server"  /></td>
                                            <td><ext:Label ID="lbl01_DATA_22"   runat="server"  /></td>
                                        </tr>
                                        <tr>
                                            <td class="tt"><ext:Label ID="lbl01_MAIN_DIV_03" runat="server" /></td>
                                            <td><ext:Label ID="lbl01_DATA_31"   runat="server"  /></td>
                                            <td><ext:Label ID="lbl01_DATA_32"   runat="server"  /></td>
                                        </tr>
                                        <tr>
                                            <td class="tt"><ext:Label ID="lbl01_MAIN_DIV_04" runat="server" /></td>
                                            <td><ext:Label ID="lbl01_DATA_41"  runat="server"  /></td>
                                            <td><ext:Label ID="lbl01_DATA_42"  runat="server"  /></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>

                            <!--불량현황-->
                            <!--CORCD : 1000 서연이화 국내법인 인경우-->
                            <div class="m_4" runat="server" id="div01"><ext:Label ID="lbl01_RCV_DEF_STATUS" runat="server" Cls="m_t" />
                                <div class="m_more">
                                    <ext:ImageButton ID="btn01_OpenQA30001" runat="server" ImageUrl="../../images/main/more_icon.gif" >
                                        <Listeners>
                                            <Click Handler="openQA30001()" />
                                        </Listeners>
                                    </ext:ImageButton>
                                </div>
                                <div class="m_c">
                                    <ext:GridPanel ID="RcvDefGrid" runat="server" Width="375" Height="135" EmptyText="No Records To Display..."
                                        StripeRows="true" TrackMouseOver="true" EnableTheming="true" HideHeaders="true" Scroll="None"
                                        ColumnLines="false">
                                        <Store>
                                            <ext:Store ID="Store3" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="Model3" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="RCV_DATE" />
                                                            <ext:ModelField Name="VINCD" />
                                                            <ext:ModelField Name="PARTNM" />
                                                            <ext:ModelField Name="DEFNM" />
                                                            <ext:ModelField Name="REPLY_DEM_DATE" />
                                                            <ext:ModelField Name="BIZNM" />
                                                            <ext:ModelField Name="CORCD" />
                                                            <ext:ModelField Name="BIZCD" />
                                                            <ext:ModelField Name="STD_YYYYMM" />
                                                            <ext:ModelField Name="VENDCD" />
                                                            <ext:ModelField Name="VENDNM" />
                                                            <ext:ModelField Name="PARTNO" />
                                                            <ext:ModelField Name="DEF_QTY" />
                                                            <ext:ModelField Name="DEFCD" />
                                                            <ext:ModelField Name="OVERDATED" /> <%--현재가 회신요구일 당일이거나 하루라도 지난경우 1, 회신요구일 전이면 0--%>
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                                <Listeners>
                                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception', 'Load failed: ' + e.message);" />
                                                </Listeners>
                                            </ext:Store>
                                        </Store>
                                        <Plugins>
                                            <ext:BufferedRenderer ID="BufferedRenderer3" runat="server"/>
                                        </Plugins>
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ID="RCV_DATE" runat="server" Width="77" DataIndex="RCV_DATE" Align="Center" Header="RCV_DATE" />
                                                <ext:Column ID="VINCD"  runat="server" Width="33" DataIndex="VINCD" Align="Center" Header="VINCD" />
                                                <ext:Column ID="PARTNM"  runat="server" Flex="1" DataIndex="PARTNM" Align="Left" Header="PARTNM" />
                                                <ext:Column ID="DEFNM"  runat="server" Width="65" DataIndex="DEFNM" Align="Left" Header="DEFNM" />
                                                <ext:Column ID="REPLY_DEM_DATE" runat="server" Width="58" DataIndex="REPLY_DEM_DATE" Align="Center" Header="REPLY_DEM_DATE" />
                                                <ext:Column ID="BIZNM"  runat="server" Width="35" DataIndex="BIZNM" Align="Right" Header="BIZNM" />
                                            </Columns>
                                        </ColumnModel>
                                        <Loader ID="Loader3" runat="server" AutoLoad="false" Mode="Data">
                                            <LoadMask ShowMask="true" />
                                        </Loader>
                                        <View>
                                            <ext:GridView ID="GridView1" runat="server"  StripeRows="true" TrackOver="true"  EnableTextSelection="true">
                                                <GetRowClass Fn="getRowClass" />
                                            </ext:GridView>
                                        </View>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" Mode="Single"/>
                                        </SelectionModel>                                 
                                    </ext:GridPanel>
                                    <ext:ToolTip ID="ToolTip1" runat="server" Target="={#{RcvDefGrid}.getView().el}" Delegate=".x-grid-cell" TrackMouse="true">
                                        <Listeners>
                                            <Show Handler="onShow(this, #{RcvDefGrid});" /> 
                                        </Listeners>
                                    </ext:ToolTip>  

                                    <ext:Label ID="lbl01_MSG_SRM_02" runat="server" StyleSpec="margin-left:23px;font-weight:bold;" ></ext:Label>
                                </div>                                
                            </div>
                            <!--CORCD : ELSE 서연이화 국내법인 이외인 경우-->
                            <div class="m_4" runat="server" id="div02"><span class="m_t"><ext:Label ID="lbl01_STATUS_DEF" runat="server" /></span>
    	                        <div class="m_c">
        	                        <table width="100%" border="0" cellspacing="1" cellpadding="0" class="tgreen">
                                          <tr>
                                            <th><ext:Label ID="lbl02_OBJECT_NM" runat="server" Text="항목" /></th>
                                            <th><ext:Label ID="lbl01_DEF_COUNT" runat="server" Text="불량건수" /></th>
                                            <th><ext:Label ID="lbl02_ACP_CNT" runat="server" Text="처리건수" /></th>
                                          </tr>
                                          <tr>
                                            <td class="tt"><ext:Label ID="lbl01_YEAR_COUNT" runat="server" Text="금년건수" /></td>
                                            <td><ext:Label ID="lbl01_TOT_CNT"   runat="server"  /></td>
                                            <td><ext:Label ID="lbl01_TOT_PROC_CNT"   runat="server"  /></td>
                                          </tr>
                                          <tr>
                                            <td class="tt"><ext:Label ID="lbl01_MONTH_COUNT" runat="server" Text="당월건수" /></td>
                                            <td><ext:Label ID="lbl01_MON_CNT"   runat="server"  /></td>
                                            <td><ext:Label ID="lbl01_MON_PROC_CNT"   runat="server"  /></td>
                                          </tr>
                                          <tr>
                                            <td class="tt"><ext:Label ID="lbl02_DAY_COUNT" runat="server" Text="당일건수" /></td>
                                            <td><ext:Label ID="lbl01_DAY_CNT"   runat="server"  /></td>
                                            <td><ext:Label ID="lbl01_DAY_PROC_CNT"   runat="server"  /></td>
                                          </tr>
                                    </table>
                                </div>
                            </div>

                        </div>
                    </Content>
                </ext:Panel>
            </Items>
        </ext:Viewport>
    </form>
</body>
</html>
