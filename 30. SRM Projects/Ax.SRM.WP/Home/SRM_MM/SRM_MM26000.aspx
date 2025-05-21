<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeBehind="SRM_MM26000.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM26000" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" >
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
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
   
    <style>
        .lh_table_div	{ height:55px; width:251px; overflow:hidden; border-bottom :1px solid #c0c0c0; /*border-left:1px solid #c0c0c0;*/ }        
        .rh_table_div	{ height:55px; width:2500px; overflow:hidden; border-bottom:1px solid #c0c0c0; border-left:1px solid #c0c0c0 }
        .ld_table_div	{ height:443px; width:251px; overflow:hidden; border-bottom :0px solid #c0c0c0;}        
        .d_table_div	{ height:443px; width:2500px; overflow:scroll; border-bottom:1px solid #c0c0c0; border-left:1px solid #c0c0c0 }
        
        table.h_table	{ border-collapse:collapse;}
        table.h_table th    
        {
            font: normal 12px Tahoma, Arial, "굴림", Gulim, Helvetica, AppleGothic, Sans-serif;border-right: 1px solid #d0d0d0;color:#222; font-weight:normal; 
            /* background-color: #157fcc;*/ 
            background:url(../../images/common/grid_bg.gif) center repeat-x; 
            }
        table.h_table th.point
        {
            font: normal 12px Tahoma, Arial, "굴림", Gulim, Helvetica, AppleGothic, Sans-serif;border-right: 1px solid #d0d0d0;color:#222; font-weight:normal; 
            /* background-color: #157fcc;*/ 
            background:url(../../images/common/point_icon.png) right 10px no-repeat,url(../../images/common/grid_bg.gif) center repeat-x; 
            }
        table.h_table th	  {padding:0px 0; border-bottom:1px solid #c0c0c0; white-space:normal !important;}        
        table.h_table td	{ border-right:1px solid #ededed; border-bottom:1px solid #ededed; white-space:nowrap; padding:0px 0px 0px 0px; font: normal 12px Tahoma, Arial, "굴림", Gulim, Helvetica, AppleGothic, Sans-serif;}
        table.h_table tr.row2	{ background:#f4f7ff;}
        
        table.h_table td input	{ border:1px solid #c0c0c0;}
        input:disabled, textarea:disabled {
            color: rgb(0, 0, 0);
            }
        .d_table_div input { height:24px; margin:0px -2px 0px -2px; padding:1px  2px 1px 2px; font: normal 12px Tahoma, Arial, "굴림", Gulim, Helvetica, AppleGothic, Sans-serif; }
        .d_table_div table tr td { height:27px; vertical-align:middle; margin:3px -1px 0px 0px; padding:1px  2px 1px 2px; }
        .ld_table_div input { height:24px; margin:0px -2px 0px -2px; padding:1px  2px 1px 2px; font: normal 12px Tahoma, Arial, "굴림", Gulim, Helvetica, AppleGothic, Sans-serif;}
        .ld_table_div table tr td { height:27px; vertical-align:middle; margin:3px -1px 0px 0px; padding:1px  2px 1px 2px; }
        
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        // 숫자타입에서 .formatString()을 사용하면 천단위 구분 문자 ","가 들어간 문자열로 변환
        // 예) var test = 10000; 
        //     alert(test.formatString());  ==> "10,000" 
        Number.prototype.formatString = function () {
            if (this == 0) return "0";

            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (this + '');

            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');

            return n;
        };

        // 문자열 타입에서 .formatNumber()를 사용하면 천단위 구분문자 ","를 제거한 number타입으로 변환
        // 예) var test = "100,000";
        //     alert(test.formatNumber();   ==> 100000
        String.prototype.formatNumber = function () {
            if (this == "") return 0;

            var num = parseFloat(this.replace(/,/g, ''));
            if (isNaN(num)) return 0;

            return num;
        };

        function KeyUp(obj, e) {
            var evt = e || window.event;
            if (evt.keyCode == 13) {
                //getNextElement(obj).focus();
                getDownElement(obj).focus();
                return false;
            }
        }

        function KeyDown(obj, e) {

            e = e || window.event;

            if (e.keyCode == '38') {
                // up arrow 윗줄로 포커스 이동
                getUpElement(obj).focus();
                return false;
            }
            else if (e.keyCode == '40') {
                // down arrow 아랫줄로 포커스 이동
                getDownElement(obj).focus();
                return false;
            }            
            else if (e.keyCode == '37') {
                // left arrow 왼쪽 input으로 포커스 이동
                if (e.preventDefault) {
                    e.preventDefault();
                } else if (e.stopPropagation) {
                    e.stopPropagation();
                } else {
                    e.returnValue = false;
                }

                getPrevElement(obj).focus();
                return false;
            }
            else if (e.keyCode == '39' ) {
                // right arrow 오른쪽 input으로 포커스 이동
                // 39:right arrow
                if (e.preventDefault) {
                    e.preventDefault();
                } else if (e.stopPropagation) {
                    e.stopPropagation();
                } else {
                    e.returnValue = false;
                }
                
                getNextElement(obj).focus();                
                return false;
            }            
            else if (e.keyCode == '9') {
                // 9: tab, 오른쪽 input으로 포커스 이동
                var isShift = e.shiftKey ? true : false;

                if (e.preventDefault) {
                    e.preventDefault();
                } else if (e.stopPropagation) {
                    e.stopPropagation();
                } else {
                    e.returnValue = false;
                }
                if (isShift) {
                    //shift tab인 경우 
                    getPrevElement(obj).focus();
                }
                else {
                    getNextElement(obj).focus();
                }
                return false;
            }
            else {
                //e.keyCode == 8 : back space
                //e.keyCode == 8 : delete
                //e.keyCode >= 48 && e.keyCode <= 57 : 숫자
                //e.keyCode >= 96 && e.keyCode <= 105 : 숫자(num pad)
                //숫자만 입력 
                return e.keyCode == 8 || e.keyCode == 46 ||
                        (e.keyCode >= 48 && e.keyCode <= 57) ||
                        (e.keyCode >= 96 && e.keyCode <= 105) ||
                        (e.keyCode == 110 || e.keyCode == 190); //2018-06-11 bmh 소숫점 추가.
            }
        }

        function getUpElement(field) {

            var arr = field.id.split("__");
            var rowno = parseInt(arr[1], 10);
            if (rowno > 1) {
                rowno = rowno - 1;
                return document.getElementById(arr[0] + "__" + rowno.toString() + "__" + arr[2]);
            }
            else {
                Calculate(field);
                return field;
            }

        }
        function getDownElement(field) {

            var arr = field.id.split("__");
            var rowno = parseInt(arr[1], 10);
            //if (rowno < document.getElementById("Grid01").rows.length) {
            if (rowno < document.getElementById("Grid01").getElementsByTagName("tr").length) {
                rowno = rowno + 1;
                return document.getElementById(arr[0] + "__" + rowno.toString() + "__" + arr[2]);
            }
            else {
                Calculate(field);
                return field;
            }
        }

        function getNextElement(field) {
        
            var arr = field.id.split("__");
            var rowno = parseInt(arr[1], 10);
            //var cnt = document.getElementById("Grid01").rows.length;
            var cnt = document.getElementById("Grid01").getElementsByTagName("tr").length;

            var col = arr[2].split("_");
                        
            //뒤에 갈곳이 없다면 아래 데이터의 처음으로 이동
            //var nextrowno = col[0] == "D6" && rowno == cnt ? rowno : (col[0] == "D6" ? rowno + 1 : rowno);
            //var nextid = (col[0] == "D0" ? "D1" : (col[0] == "D1" ? "D2" : (col[0] == "D2" ? "D3" : (col[0] == "D3" ? "D4" : (col[0] == "D4" ? "D5" : (col[0] == "D5" ? "D6" : (col[0] == "D6" && rowno == cnt ? "D6" : "D0")))))));

            var nextrowno = rowno;
            var nextid = (col[0] == "D0" ? "D1" : (col[0] == "D1" ? "D2" : (col[0] == "D2" ? "D3" : (col[0] == "D3" ? "D4" : (col[0] == "D4" ? "D5" : "D6")))));

            return document.getElementById(arr[0] + "__" + nextrowno + "__" + arr[2].replace(col[0], nextid));
        }

        function getPrevElement(field) {

            var arr = field.id.split("__");
            var rowno = parseInt(arr[1], 10);

            var col = arr[2].split("_");

            //앞에 갈곳이 없다면 위 데이터의 마지막으로 이동
            //var nextrowno = col[0] == "D0" && rowno == 1 ? rowno : (col[0] == "D0" ? rowno - 1 : rowno);
            //var nextid = (col[0] == "D6" ? "D5" : (col[0] == "D5" ? "D4" : (col[0] == "D4" ? "D3" : (col[0] == "D3" ? "D2" : (col[0] == "D2" ? "D1" : (col[0] == "D1" ? "D0" : (col[0] == "D0" && rowno == 1 ? "D0" : "D6")))))));

            var nextrowno = rowno;
            var nextid = (col[0] == "D6" ? "D5" : (col[0] == "D5" ? "D4" : (col[0] == "D4" ? "D3" : (col[0] == "D3" ? "D2" : (col[0] == "D2" ? "D1" : "D0")))));

            if (!document.getElementById(arr[0] + "__" + nextrowno + "__" + arr[2].replace(col[0], nextid)).readOnly) {
                return document.getElementById(arr[0] + "__" + nextrowno + "__" + arr[2].replace(col[0], nextid));
            } else {
                return document.getElementById(field.id);
            }
        }

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            document.getElementById('ld_div').style.height = (App.GridPanel.getHeight() - 55 - 20).toString() + "px";
            document.getElementById('rd_div').style.height = (App.GridPanel.getHeight() - 55).toString() + "px";
            document.getElementById('rd_div').style.width = (App.GridPanel.getWidth() - 250).toString() + "px";
            document.getElementById('rh_div').style.width = (App.GridPanel.getWidth() - 250).toString() + "px";
        }

        //포커스 들어올 때 ","제거 처리함.
        function Focus(input) {
            var val = input.value.formatNumber();
            if (input.value == "")
                return;
            else
                input.value = val;
            input.select();
        }

        //포커스 나갈 때 ","적용 처리함.
        function Format(input) {
            var val = input.value.formatNumber();
            if (input.value == "")
                return;
            else
                input.value = val.formatString();            
        }

        function Calculate(input) {
           
            var arr = input.id.split("__");
            //txt__행번호__컬럼아이디
            //행번호는 1부터 시작
            if (arr.length == 3) {
                var rowIdx = arr[1];
                var colId = arr[2];

                var day = colId.split("_");

                if (input.value == "") return;

                var val = input.value.formatNumber();

                var fore_qty = document.getElementById("txt__" + rowIdx + "__" + day[0] + "_FORE_QTY").textContent.formatNumber();
                var conf_qty = document.getElementById("txt__" + rowIdx + "__" + day[0] + "_CONF_QTY").textContent.formatNumber();

                var total_qty = val + fore_qty + conf_qty;

                document.getElementById("txt__" + rowIdx + "__" + day[0] + "_TOTAL").value = total_qty.formatString();

                input.value = val.formatString();
            }
        }

        function GetRowsValues(changedOnly) {
            
            var Object = [];
            var rowIdx = 1;
             
            //for (var i = 1; i <= document.getElementById("Grid01").rows.length; i++) {
            for (var i = 1; i <= document.getElementById("Grid01").getElementsByTagName("tr").length; i++) {    
                rowIdx = i;

                Object.push({
                    "PARTNO": document.getElementById("txt__" + rowIdx + "__" + "PARTNO").value,
                    "UNIT": document.getElementById("txt__" + rowIdx + "__" + "UNIT").value,
                    "UNIT_PACK_QTY": document.getElementById("txt__" + rowIdx + "__" + "UNIT_PACK_QTY").value,
                    "D0_REQ_QTY": document.getElementById("txt__" + rowIdx + "__" + "D0_REQ_QTY").value.formatNumber(),
                    "D1_REQ_QTY": document.getElementById("txt__" + rowIdx + "__" + "D1_REQ_QTY").value.formatNumber(),
                    "D2_REQ_QTY": document.getElementById("txt__" + rowIdx + "__" + "D2_REQ_QTY").value.formatNumber(),
                    "D3_REQ_QTY": document.getElementById("txt__" + rowIdx + "__" + "D3_REQ_QTY").value.formatNumber(),
                    "D4_REQ_QTY": document.getElementById("txt__" + rowIdx + "__" + "D4_REQ_QTY").value.formatNumber(),
                    "D5_REQ_QTY": document.getElementById("txt__" + rowIdx + "__" + "D5_REQ_QTY").value.formatNumber(),
                    "D6_REQ_QTY": document.getElementById("txt__" + rowIdx + "__" + "D6_REQ_QTY").value.formatNumber(),
                    "D0_FORE_QTY": document.getElementById("txt__" + rowIdx + "__" + "D0_FORE_QTY").textContent.formatNumber(),
                    "D1_FORE_QTY": document.getElementById("txt__" + rowIdx + "__" + "D1_FORE_QTY").textContent.formatNumber(),
                    "D2_FORE_QTY": document.getElementById("txt__" + rowIdx + "__" + "D2_FORE_QTY").textContent.formatNumber(),
                    "D3_FORE_QTY": document.getElementById("txt__" + rowIdx + "__" + "D3_FORE_QTY").textContent.formatNumber(),
                    "D4_FORE_QTY": document.getElementById("txt__" + rowIdx + "__" + "D4_FORE_QTY").textContent.formatNumber(),
                    "D5_FORE_QTY": document.getElementById("txt__" + rowIdx + "__" + "D5_FORE_QTY").textContent.formatNumber(),
                    "D6_FORE_QTY": document.getElementById("txt__" + rowIdx + "__" + "D6_FORE_QTY").textContent.formatNumber(),
                    "NO": rowIdx             
                });
            }

            return Object;
        }

        var linkClick = function (rowIdx, id) {

            var partno = document.getElementById("txt__" + rowIdx + "__PARTNO").value;
            var partnm = document.getElementById("txt__" + rowIdx + "__PARTNM").value;
            var unit = document.getElementById("txt__" + rowIdx + "__UNIT").value;
            var unit_pack_qty = document.getElementById("txt__" + rowIdx + "__UNIT_PACK_QTY").value;

            var val = id.split("__")[2].substr(1,1);

            var param = new Array(val, partno, partnm, unit);
            App.direct.MakePopUp(param, (id.indexOf('FORE') > -1 ? 'N' : 'C'));
        };
       
    </script>
</head>
<body>
    <form id="SRM_MM26000" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="hidREQ_MIN_DATE" runat="server" Hidden="true" /> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MM26000" runat="server" Cls="search_area_title_name" /><%--Text="사급신청 등록" />--%>
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
                            <col style="width: 200px;" />
                            <col style="width: 150px;" />
                            <col style="width: 200px;" />
                            <col style="width: 150px;" />
                            <col style="width: 200px;" />
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_CUST" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD_FIX" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60" OnAfterValidation="changeCondition"/>
                            </td>   
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" Width="150">
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
                                    <DirectEvents>
                                        <Select OnEvent="cbo01_PURC_ORG_Change" />
                                    </DirectEvents>      
                                </ext:SelectBox>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_INQUERY_STD_DATE" runat="server" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_GETDATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  >
                                    <DirectEvents>
                                        <Select OnEvent="df01_GETDATE_Change" />
                                    </DirectEvents>
                                </ext:DateField>
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl01_PURC_ORG_VTWEG" runat="server" />
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer1" runat="server" MsgTarget="Side" Layout="TableLayout" Width="200px">
                                    <Items>
                                    <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                        DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150" MarginSpec="0px 10px 0px 0px">
                                        <Store>
                                            <ext:Store ID="Store33" runat="server" >
                                                <Model>
                                                    <ext:Model ID="Model33" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="OBJECT_ID" />
                                                            <ext:ModelField Name="OBJECT_NM" />
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                            </ext:Store>
                                        </Store>
                                        <DirectEvents>
                                            <Select OnEvent="cbo01_PURC_ORG_Change" />
                                        </DirectEvents>                                    
                                    </ext:SelectBox>
                                
                                    <ext:Label ID="lbl99_VTWEG_70" runat="server"/>
                                    <ext:Label ID="lbl99_VTWEG_72" runat="server"/>
                                    </Items>
                                </ext:FieldContainer>
                            </td>                        
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_VIN" runat="server" />                      
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" OnDirectEventChange="Button_Click" runat="server" ClassID="A3" PopupMode="Search" PopupType="CodeWindow" WidthTYPECD="60"/>
                            </td>                            
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />                 
                            </th>
                            <td colspan="5">
                                <ext:TextField ID="txt01_FPARTNO" Width="120" Cls="inputText" runat="server" />                              
                            </td>
                        </tr>                        
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="EmpRegistPanel" Region="North" Cls="excel_upload_area_table" runat="server">
                <Content>
                    <table style="height:0px;" >
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 170px;" />
                            <col />
                            <col style="width: 80px;" />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_REQ_MGRNM" runat="server" /><%--신청담당자명--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_MGRNM" Width="150" Cls="inputText" runat="server" />
                            </td>
                            <td>
                                <ext:Label ID="lblMsg" runat="server" /><%--부터 신청 가능합니다.--%>
                            </td>
                            <td>                                
                                <ext:Button ID="btn01_CONFIRM_PROC" runat="server" TextAlign="Center" Cls="mg_r4" Width="72px"><%--Text="확정처리" >--%>
                                    <DirectEvents>
                                        <Click OnEvent="etc_Button_Click" >
                                            <ExtraParams>
                                                <ext:Parameter Name="Values" Value="GetRowsValues(true)" Mode="Raw" Encode="true" />
                                            </ExtraParams>
                                        </Click>
                                    </DirectEvents>
                                </ext:Button>
                            </td>
                        </tr>                                                             
                    </table>
                </Content>
            </ext:Panel>
            
            <ext:Panel ID="Panel2" runat="server" Region="North" Height="27" >
                <Content>
                    <table style="height:0px; margin-bottom: 10px;">
                        <tr>
                            <td align="left" style="color:#555;">
                                <ext:Label ID="lbl01_MM26001_MSG001" runat="server" />
                                <ext:Label ID="lbl01_MM26001_MSG002" runat="server" />
                                <ext:Label ID="lbl01_MM26001_MSG003" runat="server" />
                            </td>    
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>

            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server">  
                <Content>
                    <table border="0" style="border-spacing: 0px;width:100%; height:100%;" runat="server" id="tbl01_GridPanel">
                        <tr style="height:55px">
                            <td style="margin:0px; padding:0px; ">
                                <div class="lh_table_div" id="lh_div">
                                    <table id="Grid01_LH" runat="server"   border="0" cellspacing="0" cellpadding="0" class="h_table" width="251">
                                    <tr style="height:55px;" >
                                        <th style="width:41px">NO</th>
                                        <th style="width:60px"><ext:Label ID="lbl02_VIN" runat="server" /></th>
                                        <th style="width:150px"><ext:Label ID="lbl02_PARTNO" runat="server" /></th>
                                    </tr>
                                    </table>
                                </div>
                            
                            </td>
                            <td  style="height:55px">
                                <div class="rh_table_div" id="rh_div">
                                    <table id="Grid01_RH" runat="server" border="0" cellspacing="0" cellpadding="0" class="h_table" width="2590"><%--width="5040"--%>
                                        <tr style="height:27px">
                                            <th rowspan="2" style="width:200px;"><ext:Label ID="lbl02_PARTNM" runat="server" Width="200px"/></th>
                                            <th rowspan="2" style="width:50px;"><ext:Label ID="lbl02_UNIT" runat="server" Width="50px"/></th>
                                            <th rowspan="2" style="width:80px;"><ext:Label ID="lbl02_UNIT_PACK_QTY" runat="server" Width="80px"/></th>
                                            <th colspan="4"><ext:Label ID="lbl02_D0" runat="server" /></th>
                                            <th colspan="4"><ext:Label ID="lbl02_D1" runat="server" /></th>
                                            <th colspan="4"><ext:Label ID="lbl02_D2" runat="server" /></th>
                                            <th colspan="4"><ext:Label ID="lbl02_D3" runat="server" /></th>
                                            <th colspan="4"><ext:Label ID="lbl02_D4" runat="server" /></th>
                                            <th colspan="4"><ext:Label ID="lbl02_D5" runat="server" /></th>
                                            <th colspan="4"><ext:Label ID="lbl02_D6" runat="server" /></th>
                                            <th rowspan="2" style="width:20px;">&nbsp;</th>
                                        </tr>
                                        <tr style="height:28px">
                                            <th style="width:80px;"><ext:Label ID="lbl21_SUB_TOTAL" runat="server" Width="80px"/></th>   
                                            <th style="width:80px;" class="point"><ext:Label ID="lbl21_REQ_QTY" runat="server" Width="80px"/></th>  
                                            <th style="width:80px;"><ext:Label ID="lbl21_FORE_QTY" runat="server" Width="80px"/></th>    
                                            <th style="width:80px;"><ext:Label ID="lbl21_CONF_QTY" runat="server" Width="80px"/></th> 
                                            <th style="width:80px;"><ext:Label ID="lbl22_SUB_TOTAL" runat="server" Width="80px"/></th>   
                                            <th style="width:80px;" class="point"><ext:Label ID="lbl22_REQ_QTY" runat="server" Width="80px"/></th>  
                                            <th style="width:80px;"><ext:Label ID="lbl22_FORE_QTY" runat="server" Width="80px"/></th>    
                                            <th style="width:80px;"><ext:Label ID="lbl22_CONF_QTY" runat="server" Width="80px"/></th> 
                                            <th style="width:80px;"><ext:Label ID="lbl23_SUB_TOTAL" runat="server" Width="80px"/></th>   
                                            <th style="width:80px;" class="point"><ext:Label ID="lbl23_REQ_QTY" runat="server" Width="80px"/></th>  
                                            <th style="width:80px;"><ext:Label ID="lbl23_FORE_QTY" runat="server" Width="80px"/></th>    
                                            <th style="width:80px;"><ext:Label ID="lbl23_CONF_QTY" runat="server" Width="80px"/></th> 
                                            <th style="width:80px;"><ext:Label ID="lbl24_SUB_TOTAL" runat="server" Width="80px"/></th>   
                                            <th style="width:80px;" class="point"><ext:Label ID="lbl24_REQ_QTY" runat="server" Width="80px"/></th>  
                                            <th style="width:80px;"><ext:Label ID="lbl24_FORE_QTY" runat="server" Width="80px"/></th>    
                                            <th style="width:80px;"><ext:Label ID="lbl24_CONF_QTY" runat="server" Width="80px"/></th> 
                                            <th style="width:80px;"><ext:Label ID="lbl25_SUB_TOTAL" runat="server" Width="80px"/></th>   
                                            <th style="width:80px;" class="point"><ext:Label ID="lbl25_REQ_QTY" runat="server" Width="80px"/></th>  
                                            <th style="width:80px;"><ext:Label ID="lbl25_FORE_QTY" runat="server" Width="80px"/></th>    
                                            <th style="width:80px;"><ext:Label ID="lbl25_CONF_QTY" runat="server" Width="80px"/></th> 
                                            <th style="width:80px;"><ext:Label ID="lbl26_SUB_TOTAL" runat="server" Width="80px"/></th>   
                                            <th style="width:80px;" class="point"><ext:Label ID="lbl26_REQ_QTY" runat="server" Width="80px"/></th>  
                                            <th style="width:80px;"><ext:Label ID="lbl26_FORE_QTY" runat="server" Width="80px"/></th>    
                                            <th style="width:80px;"><ext:Label ID="lbl26_CONF_QTY" runat="server" Width="80px"/></th> 
                                            <th style="width:80px;"><ext:Label ID="lbl27_SUB_TOTAL" runat="server" Width="80px"/></th>   
                                            <th style="width:80px;" class="point"><ext:Label ID="lbl27_REQ_QTY" runat="server" Width="80px"/></th>  
                                            <th style="width:80px;"><ext:Label ID="lbl27_FORE_QTY" runat="server" Width="80px"/></th>    
                                            <th style="width:80px;"><ext:Label ID="lbl27_CONF_QTY" runat="server" Width="80px"/></th> 
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="ld_table_div" id="ld_div" runat="server">
                                    <table id="Grid01_LD" runat="server" border="0" cellspacing="0" cellpadding="0" class="h_table">
                                        
                                    </table>
                                </div>
                            </td>
                            <td >
                                <div class="d_table_div" id="rd_div" runat="server" onscroll="document.getElementById('rh_div').scrollLeft = this.scrollLeft;document.getElementById('ld_div').scrollTop = this.scrollTop;">
                                    <table id="Grid01" runat="server" border="0" cellspacing="0" cellpadding="0" class="h_table">
                                
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>                        
                </Content>          
            </ext:Panel> 
            
            <%--엑셀 헤더용 그리드 (숨김)--%>
            <ext:GridPanel ID="Grid01_Excel" Visible="false" runat="server" TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                <Store>
                    <ext:Store ID="Store1" runat="server" PageSize="50" >
                        <Model>
                            <ext:Model ID="GridModel1" runat="server">
                                <Fields>
                                    <ext:ModelField Name="NO" /> 
                                    <ext:ModelField Name="VINCD" />                                            
                                    <ext:ModelField Name="PARTNO" />
                                    <ext:ModelField Name="PARTNM" />
                                    <ext:ModelField Name="UNIT" />
                                    <ext:ModelField Name="UNIT_PACK_QTY" />
                                    <ext:ModelField Name="D0_TOTAL" />
                                    <ext:ModelField Name="D0_REQ_QTY" />
                                    <ext:ModelField Name="D0_FORE_QTY" />
                                    <ext:ModelField Name="D0_CONF_QTY" />
                                    <ext:ModelField Name="D1_TOTAL" />
                                    <ext:ModelField Name="D1_REQ_QTY" />
                                    <ext:ModelField Name="D1_FORE_QTY" />
                                    <ext:ModelField Name="D1_CONF_QTY" />
                                    <ext:ModelField Name="D2_TOTAL" />
                                    <ext:ModelField Name="D2_REQ_QTY" />
                                    <ext:ModelField Name="D2_FORE_QTY" />
                                    <ext:ModelField Name="D2_CONF_QTY" />
                                    <ext:ModelField Name="D3_TOTAL" />
                                    <ext:ModelField Name="D3_REQ_QTY" />
                                    <ext:ModelField Name="D3_FORE_QTY" />
                                    <ext:ModelField Name="D3_CONF_QTY" />
                                    <ext:ModelField Name="D4_TOTAL" />
                                    <ext:ModelField Name="D4_REQ_QTY" />
                                    <ext:ModelField Name="D4_FORE_QTY" />
                                    <ext:ModelField Name="D4_CONF_QTY" />
                                    <ext:ModelField Name="D5_TOTAL" />
                                    <ext:ModelField Name="D5_REQ_QTY" />
                                    <ext:ModelField Name="D5_FORE_QTY" />
                                    <ext:ModelField Name="D5_CONF_QTY" />
                                    <ext:ModelField Name="D6_TOTAL" />
                                    <ext:ModelField Name="D6_REQ_QTY" />
                                    <ext:ModelField Name="D6_FORE_QTY" />
                                    <ext:ModelField Name="D6_CONF_QTY" />
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
                    <%--<ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>--%>
                    <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                        <Listeners>                                    
                            <%-- <BeforeEdit fn="BeforeEdit" />--%>
                            <Edit fn ="AfterEdit" />
                        </Listeners>
                    </ext:CellEditing>
                </Plugins>  
                <ColumnModel ID="ColumnModel1" runat="server">
                    <Columns>
                        <ext:RowNumbererColumn ID="NO_EXCEL"      ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center" Locked="true" Draggable="false"  Lockable="false"/>                                
                        <ext:Column ID="VINCD"  ItemID="VIN" runat="server" DataIndex="VINCD" Width="60" Align="Center" Locked="true" Draggable="false" Lockable="false" Hideable="false"/>
                        <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" Locked="true" Draggable="false" Lockable="false" Hideable="false"/>
                        <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="200" Align="Left" Draggable="false" Lockable="false" Hideable="false"/>
                        <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="50" Align="Center" Draggable="false" Lockable="false" Hideable="false"/>
                        <ext:NumberColumn      ID="UNIT_PACK_QTY"         ItemID="UNIT_PACK_QTY"         runat="server" DataIndex="UNIT_PACK_QTY"    Width="80"  Align="Right"  Format="#,##0.###" /><%--Text="용기적입수량"--%>
                        <ext:Column ID="D0" ItemID="D0" runat="server" Draggable="false" Lockable="false" Hideable="false">
                            <Columns>
                            <ext:NumberColumn      ID="D0_TOTAL"         ItemID="SUB_TOTAL"         runat="server" DataIndex="D0_TOTAL"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn ID="D0_REQ_QTY" ItemID="REQ_QTY" runat="server" DataIndex="D0_REQ_QTY" Width="80" Align="Right" Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D0_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D0_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D0_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D0_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="D1" ItemID="D1" runat="server" Draggable="false" Lockable="false" Hideable="false">
                            <Columns>
                            <ext:NumberColumn      ID="D1_TOTAL"         ItemID="SUB_TOTAL1"         runat="server" DataIndex="D1_TOTAL"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn ID="D1_REQ_QTY" ItemID="REQ_QTY1" runat="server" DataIndex="D1_REQ_QTY" Width="80" Align="Right" Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D1_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D1_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D1_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D1_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="D2" ItemID="D2" runat="server" Draggable="false" Lockable="false" Hideable="false">
                            <Columns>
                            <ext:NumberColumn      ID="D2_TOTAL"         ItemID="SUB_TOTAL2"         runat="server" DataIndex="D2_TOTAL"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn ID="D2_REQ_QTY" ItemID="REQ_QTY2" runat="server" DataIndex="D2_REQ_QTY" Width="80" Align="Right" Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D2_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D2_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D2_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D2_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="D3" ItemID="D3" runat="server" Draggable="false" Lockable="false" Hideable="false">
                            <Columns>
                            <ext:NumberColumn      ID="D3_TOTAL"         ItemID="SUB_TOTAL3"         runat="server" DataIndex="D3_TOTAL"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn ID="D3_REQ_QTY" ItemID="REQ_QTY3" runat="server" DataIndex="D3_REQ_QTY" Width="80" Align="Right" Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D3_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D3_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D3_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D3_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="D4" ItemID="D4" runat="server" Draggable="false" Lockable="false" Hideable="false">
                            <Columns>
                            <ext:NumberColumn      ID="D4_TOTAL"         ItemID="SUB_TOTAL4"         runat="server" DataIndex="D4_TOTAL"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn ID="D4_REQ_QTY" ItemID="REQ_QTY4" runat="server" DataIndex="D4_REQ_QTY" Width="80" Align="Right" Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D4_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D4_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D4_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D4_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="D5" ItemID="D5" runat="server" Draggable="false" Lockable="false" Hideable="false">
                            <Columns>
                            <ext:NumberColumn      ID="D5_TOTAL"         ItemID="SUB_TOTAL5"         runat="server" DataIndex="D5_TOTAL"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn ID="D5_REQ_QTY" ItemID="REQ_QTY5" runat="server" DataIndex="D5_REQ_QTY" Width="80" Align="Right" Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D5_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D5_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D5_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D5_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="D6" ItemID="D6" runat="server" Draggable="false" Lockable="false" Hideable="false">
                            <Columns>
                            <ext:NumberColumn      ID="D6_TOTAL"         ItemID="SUB_TOTAL6"         runat="server" DataIndex="D6_TOTAL"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn ID="D6_REQ_QTY" ItemID="REQ_QTY6" runat="server" DataIndex="D6_REQ_QTY" Width="80" Align="Right" Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D6_FORE_QTY"         ItemID="FORE_QTY"         runat="server" DataIndex="D6_FORE_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            <ext:NumberColumn      ID="D6_CONF_QTY"         ItemID="CONF_QTY"         runat="server" DataIndex="D6_CONF_QTY"    Width="80"  Align="Right"  Format="#,##0.###" Draggable="false" Lockable="false" Hideable="false"/>
                            </Columns>
                        </ext:Column>
                    </Columns>                            
                </ColumnModel>
                <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                    <LoadMask ShowMask="true" />
                </Loader>
                <View>
                    <ext:GridView ID="GridView1" runat="server"  EnableTextSelection="true"/>
                </View>
                <SelectionModel>
                <%--4.X CELLSELECTIONMODE Inherits 오류 문제--%>
                    <ext:CellSelectionModel  ID="RowSelectionModel1" runat="server">                        
                    </ext:CellSelectionModel >
                </SelectionModel>                       
                <BottomBar>
                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                    <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                </BottomBar>
            </ext:GridPanel>
                        
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
