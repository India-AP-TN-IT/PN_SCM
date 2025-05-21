<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_PS20001P1.aspx.cs" Inherits="Ax.EP.WP.Home.SRM_PS.SRM_PS20001P1" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico" itemprop="image">
<meta name="apple-mobile-web-app-title" content="HE.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="HE.POTAL" />

    <title>SUB KD 포장 사양서</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

<%--    <style type="text/css">
    .bottom_area_title_name2 {
        clear: both;
        margin-top: 10px;
        height: 18px;        
        background: url(../../images/common/title_icon_s.gif) 0 8px no-repeat;
        padding-left: 10px;
        font-size: 12px;
        color: #010101;
        text-align: left;
        font-weight: bold;
        };
        
    </style>
    <style type="text/css">
    .x-grid-cell-TRANS_VENDNM1 DIV,	    
        .x-grid-cell-TRANS_AMT1 DIV,	    
        .x-grid-cell-TRANS_RATE1 DIV,	    
	    .x-grid-cell-TRANS_VENDNM2 DIV,	    
	    .x-grid-cell-TRANS_AMT2 DIV,	    
        .x-grid-cell-TRANS_RATE2 DIV,	    
	    .x-grid-cell-TRANS_VENDNM3 DIV,	    
	    .x-grid-cell-TRANS_AMT3 DIV,	    
        .x-grid-cell-TRANS_RATE3 DIV,	    
	    .x-grid-cell-VENDNM DIV,
	    .x-grid-cell-MAIN_ITEM DIV,
	    .x-grid-cell-YEAR_PURCAMT DIV,
	    .x-grid-cell-VIN DIV,
	    .x-grid-cell-INJECTION DIV,
	    .x-grid-cell-FORMING DIV,
	    .x-grid-cell-PRESS DIV,
	    .x-grid-cell-ETC1 DIV,
	    .x-grid-cell-FACILNM DIV,
	    .x-grid-cell-FACIL_MAKER DIV,
	    .x-grid-cell-FACILCNT DIV,
	    .x-grid-cell-FACIL_REMARK DIV,
	    .x-grid-cell-EQUIPNM DIV,
	    .x-grid-cell-EQUIP_MAKER DIV,
	    .x-grid-cell-EQUIPCNT DIV,
	    .x-grid-cell-EQUIP_REMARK DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    };
    </style>--%>
    <style type="text/css">
            #cdx01_VENDCD_TYPECD-inputEl, #cdx01_VINCD_TYPECD-inputEl, #cdx01_VENDCD_TYPENM-inputEl, #cdx01_VINCD_TYPENM-inputEl
            {
                background-color:Yellow;
            }
            
	        /* 4.X에 이미지 보이도록 수정 */
	        #Panel6-bodyWrap,#Panel7-bodyWrap		    
	        {
	            overflow :visible;
	        }      
	        
	        /* 4.X에 text border없애기 */
	        #txt01_percentLabel-triggerWrap
	        {
	            border :0px;
	        }
	        
	        /* 4.X에 text height 변경 */
	        #txt01_LARGE_LOAD_RATE-inputEl,#txt01_SEOYON_CHARGER-inputEl,#txt01_SEOYON_APPLY-inputEl, #txt01_CUST_APPLY-inputEl, #txt01_GLOBAL_CHECK-inputEl
	        ,#txt01_LARGE_LOAD_RATE-triggerWrap,#txt01_SEOYON_CHARGER-triggerWrap,#txt01_SEOYON_APPLY-triggerWrap, #txt01_CUST_APPLY-triggerWrap, #txt01_GLOBAL_CHECK-triggerWrap
	        {
	            height:50px !important;
	        }
	        
	        
	        #txt01_VEND_CHARGER-inputEl,#txt01_VEND_CHARGER-triggerWrap,#txt01_VEND_APPLY-inputEl,#txt01_VEND_APPLY-triggerWrap
	        {	        
	            height:50px !important;
	            background:yellow !important;
	        }		    
	        
	        #txt01_VEND_CHARGER-inputWrap,
	        #txt01_VEND_APPLY-inputWrap,	        
	        #txt01_LARGE_LOAD_RATE-inputWrap,
	        #txt01_SEOYON_CHARGER-inputWrap,
	        #txt01_SEOYON_APPLY-inputWrap,
	        #txt01_CUST_APPLY-inputWrap,
	        #txt01_GLOBAL_CHECK-inputWrap
	        {
	            height:48px !important; padding:0 !important;	        
	        }	        
	        
	        #txt01_NOTE-inputEl,#txt01_NOTE-triggerWrap
	        {	        
	            height:314px !important;
	        }		    
	        
	        #txt01_NOTE-inputWrap
	        {
	            height:310px !important; padding:0 !important;	        
	        }
	        	        
              
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">


        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            //            App.InputPanel.setHeight(App.Panel1.getHeight() +
            //                                    App.Panel2.getHeight() +
            //                                    App.Panel3.getHeight() +
            //                                    App.Panel4.getHeight() +
            //                                    App.pnl01_GEN.getHeight() + App.Panel4.getHeight() + 50);
            App.InputPanel.setHeight(1300);
        }

        var PrintReport = function (btn) {
            if (btn == "yes")
                App.direct.Print();
        }

        //중포장 적입수량 (중포장 1단수량 * 중포장 적재단수)
        function fn_mid_load_qty_change() {

            var mid_f_qty = ((App.txt01_MID_F_QTY.getValue() == null) ? 0 : parseFloat(App.txt01_MID_F_QTY.getValue(), 10));
            var mid_load_depth = ((App.txt01_MID_LOAD_DEPTH.getValue() == null) ? 0 : parseFloat(App.txt01_MID_LOAD_DEPTH.getValue(), 10));
            App.txt01_LARGE_PO_MIN_QTY.setValue(mid_f_qty * mid_load_depth); // 최소발주
            App.txt01_MID_LOAD_QTY.setValue(mid_f_qty * mid_load_depth);
            fn_setLarge_load_qty_ea();
        }

        //대포장 적입수량 (대포장 1단수량 * 대포장 적재단수)
        function fn_large_load_qty_change() {
            var large_f_qty = ((App.txt01_LARGE_F_QTY.getValue() == null) ? 0 : parseFloat(App.txt01_LARGE_F_QTY.getValue(), 10));
            var large_load_depth = ((App.txt01_LARGE_LOAD_DEPTH.getValue() == null) ? 0 : parseFloat(App.txt01_LARGE_LOAD_DEPTH.getValue(), 10));
            App.txt01_LARGE_LOAD_QTY.setValue(large_f_qty * large_load_depth);
            fn_setLarge_load_qty_ea();
        }

        //대포장 적입수량 (EA)
        function fn_setLarge_load_qty_ea() {
            App.txt01_LARGE_LOAD_QTY_EA.setValue(App.txt01_MID_LOAD_QTY.getValue() * App.txt01_LARGE_LOAD_QTY.getValue());
            fn_largebox_weight_change(); //대포장 박스 중량
            fn_larg_load_rate_change(); // 대포장 적입율
        }

        //대포장 박스중량 (중포장 박스중량 * 대포장박스 적입수량)
        function fn_largebox_weight_change() {
            var mid_box_weight = ((App.txt01_MID_BOX_WEIGHT.getValue() == null) ? 0 : parseFloat(App.txt01_MID_BOX_WEIGHT.getValue(), 10));
            var large_load_qty = ((App.txt01_LARGE_LOAD_QTY.getValue() == null) ? 0 : parseFloat(App.txt01_LARGE_LOAD_QTY.getValue(), 10));

            App.txt01_LARGE_BOX_WEIGHT.setValue(mid_box_weight * large_load_qty);
        }

        //대포장 적입율  ((중포장 외측 x * y * z)/1000000000 * 대포장 적입수량) / ((대포장 내측 x * y * z)/ 1000000000)
        function fn_larg_load_rate_change() {
            var mid_pack_x = ((App.txt01_MID_PACK_X.getValue() == null) ? 0 : parseFloat(App.txt01_MID_PACK_X.getValue(), 10));
            var mid_pack_y = ((App.txt01_MID_PACK_Y.getValue() == null) ? 0 : parseFloat(App.txt01_MID_PACK_Y.getValue(), 10));
            var mid_pack_z = ((App.txt01_MID_PACK_Z.getValue() == null) ? 0 : parseFloat(App.txt01_MID_PACK_Z.getValue(), 10));

            var large_load_qty = ((App.txt01_LARGE_LOAD_QTY.getValue() == null) ? 0 : parseFloat(App.txt01_LARGE_LOAD_QTY.getValue(), 10));

            var large_pack_x = ((App.txt01_LARGE_PACK_X.getValue() == null) ? 0 : parseFloat(App.txt01_LARGE_PACK_X.getValue(), 10));
            var large_pack_y = ((App.txt01_LARGE_PACK_Y.getValue() == null) ? 0 : parseFloat(App.txt01_LARGE_PACK_Y.getValue(), 10));
            var large_pack_z = ((App.txt01_LARGE_PACK_Z.getValue() == null) ? 0 : parseFloat(App.txt01_LARGE_PACK_Z.getValue(), 10));
            //alert(mid_pack_x + ',' + mid_pack_y + ',' + mid_pack_z + ',' + large_load_qty + ',' + large_pack_x + ',' + large_pack_y + ',' + large_pack_z);
            var first = (mid_pack_x * mid_pack_y * mid_pack_z) / 1000000000 * large_load_qty;
            var second = (large_pack_x * large_pack_y * large_pack_z) / 1000000000;
            //alert(second);
            var sum = (second == 0) ? 0 : first / second;
            App.txt01_LARGE_LOAD_RATE.setValue(sum * 100);
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            if (typeCD == 'L') {
                // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.            
                App.txt01_LARGE_PACK_X.setValue(record["CASE_SIZEX"]);
                App.txt01_LARGE_PACK_Y.setValue(record["CASE_SIZEY"]);
                App.txt01_LARGE_PACK_Z.setValue(record["CASE_SIZEZ"]);
                App.txt01_LARGE_PACKCODE.setValue(record["CASE_CD"]);
            } else {
                // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.            
                App.txt01_MID_PACK_X.setValue(record["CASE_SIZEX"]);
                App.txt01_MID_PACK_Y.setValue(record["CASE_SIZEY"]);
                App.txt01_MID_PACK_Z.setValue(record["CASE_SIZEZ"]);
                App.txt01_MID_PACKCODE.setValue(record["CASE_CD"]);
            }

            var CtlPopup = Ext.getCmp(popupID);
            CtlPopup.hide();

        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }
        var image;
        function test(value) {
            image = value;
            alert(image.imageUrl);
            //alert(this); App.img01_PHOTO1.ImageUrl = this.value;
        }
        
    </script>


</head>
<body>
    <form id="SRM_PS20001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
                
                
    <ext:Hidden ID="hid01_PHOTO1" runat="server" />
    <ext:Hidden ID="hid01_PHOTO2" runat="server" />
    <ext:Hidden ID="hid01_MAIN_PARTNO" runat="server" />
        
    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="CodeCol" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col index (사용하지 않으나 차후 필요할지 몰라서)--%>    
    <%-- 숨겨 사용하기 ^^;;; --%>
    <ext:TextField ID="txt01_ID" runat="server" Hidden="true" />    
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>           
        </Listeners>
        <Items>
            <%--타이틀 및 공통버튼 영역--%>
            <ext:Panel ID="TitlePanel" Region="North" runat="server" Height="30">
                <Items>
                    
                    <ext:Label ID="lbl01_SRM_PS20001" runat="server" Cls="search_area_title_name" Text="SUB KD 포장사양서"/>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                                <ext:Button StyleSpec="margin-left:5px; width:80px;" ID="btn01_SAVE_T" runat="server" TextAlign="Center" Text ="임시저장">
                                    <DirectEvents>                                        
                                        <Click OnEvent="etc_Button_Click" >                                                                                        
                                        </Click>
                                    </DirectEvents>
                                </ext:Button>         
                                <ext:Button StyleSpec="margin-left:5px;margin-right:5px; width:80px;" ID="btn01_SAVE_L" runat="server" TextAlign="Center" Text ="최종저장">
                                    <DirectEvents>                                        
                                        <Click OnEvent="etc_Button_Click" >
                                            <Confirmation ConfirmRequest="true" Title="Confirm" Message="최종저장 하시겠습니까??" />                                            
                                        </Click>
                                    </DirectEvents>
                                </ext:Button>         
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>

            <%--입력 영역
            4.X에서 overflow:scroll -> auto, Scrollable추가, region 추가--%>
            <ext:Panel ID="InputPanel" runat="server" Width="1300" Height="2630"  Scrollable="Both" StyleSpec="overflow:auto;"  Region="Center">
                <Items>

                    <%--1.일반정보--%>
                    <ext:Label ID="lbl01_TIT_GEN" runat="server" Cls="bottom_area_title_name" Text="기본정보" />
                    <ext:Panel ID="pnl01_GEN" Cls="excel_upload_area_table" runat="server" StyleSpec="width:1300px !important;">
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 140px;" />
                                    <col style="width: 185px;" />
                                    <col style="width: 185px;" />
                                    <col style="width: 140px;" />
                                    <col style="width: 140px;" />
                                    <col style="width: 185px;" />
                                    <col style="width: 140px;" />
                                    <col style="width: 140px;" />
                                    <col />
                                </colgroup>
                                
                                <tr >
                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label41" runat="server" Text="등록일자" />                                        
                                    </th>
                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="lbl01_CORNM" runat="server" Text="법인명" />                                        
                                    </th>

                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="lbl01_VINNM" runat="server" Text="차종"/>
                                    </th>  
                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="lbl01_TYPENM" runat="server" Text="사양"/>
                                    </th>  
                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label75" runat="server" Text="포장처"/>
                                    </th>  
                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label76" runat="server" Text="공급업체(포장업체)"/>
                                    </th>  
                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label77" runat="server" Text="적용요구시점"/>
                                    </th>  
                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label78" runat="server" Text="실적용시점"/>
                                    </th>  
                                </tr>        
                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:DateField ID="dte01_REG_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true" AllowBlank="true"   FieldStyle="background:yellow !important;" />
                                    </td>
                                    <td class="line">
                                        <%--<epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="80" WidthTYPENM="80"  />--%>
                                        <%--임의로 하드코딩 sapp 변경으로 인해서 어떻게 될지 모름.--%>                                     
     <%--                                   <ext:ComboBox ID="cbo01_CUSTCD" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="172" Editable="false" FieldStyle="background:yellow !important;">
                                            <Items>                                                         
                                                <ext:ListItem Value="20000" Text="강소서연이화" />
                                                <ext:ListItem Value="20001" Text="북경서연" />
                                                <ext:ListItem Value="20003" Text="요녕서연이화" />
                                                <ext:ListItem Value="20004" Text="서연이화인디아" />
                                                <ext:ListItem Value="20005" Text="서연이화첸나이" />
                                                <ext:ListItem Value="20006" Text="서연이화슬로박" />
                                                <ext:ListItem Value="20007" Text="서연이화알라바마" />
                                                <ext:ListItem Value="20008" Text="서연이화조지아" />
                                                <ext:ListItem Value="20009" Text="서연이화브라질" />
                                                <ext:ListItem Value="20010" Text="앗싼한일" />
                                                <ext:ListItem Value="20393" Text="서연이화폴란드" />
                                                <ext:ListItem Value="20412" Text="서연이화멕시코" />
                                                <ext:ListItem Value="20732" Text="북기한일(창주)" />
                                                <ext:ListItem Value="20733" Text="북기한일(중경)" />
                                            </Items>
                                        </ext:ComboBox>--%>
                                        <ext:SelectBox ID="cbo01_CUSTCD" runat="server"  Mode="Local" ForceSelection="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="172" FieldStyle="background:yellow !important;">
                                            <Store>
                                                <ext:Store ID="Store6" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model5" runat="server">
                                                            <Fields>
                                                                <ext:ModelField Name="ID" />
                                                                <ext:ModelField Name="NAME" />
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                         </ext:SelectBox> 
                                    </td>      
                                    <td class="line">
                                        <epc:EPCodeBox ID="cdx01_VINCD" runat="server" HelperID="HELP_TYPECD" PopupMode="Search" PopupType="CodeWindow" ClassID="A3" WidthTYPECD="80" WidthTYPENM="80" />
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo01_SPEC" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="135" Editable="false" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="정규" Text="정규" />
                                                <ext:ListItem Value="비정규" Text="비정규" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                       <ext:ComboBox ID="cbo01_TYPE" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="135" Editable="false" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="업체" Text="업체" />
                                                <ext:ListItem Value="포장장" Text="포장장" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>      
                                    <td class="line">
                                        <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="80" WidthTYPENM="80" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte01_B_REQUEST_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true" AllowBlank="true"   FieldStyle="background:yellow !important;" />                                        
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte01_B_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true" AllowBlank="true"   FieldStyle="background:yellow !important;" />
                                    </td>
                                </tr>                                                            
                            </table>
                        </Content>
                    </ext:Panel>

                    <%--포장사진 및 포장방법--%>
                    <ext:Label ID="Label79" runat="server" Cls="bottom_area_title_name" Text="포장사진 및 포장방법" />
                    <ext:Panel ID="Panel5" Cls="excel_upload_area_table" runat="server" Height="357px" StyleSpec="width:1300px !important;">
                        <Content>
                            <table>
                                <colgroup> 
                                    <col style="width: 380px;" />
                                    <col style="width: 380px;" />                                   
                                    <col />
                                </colgroup>
                                
                                <tr>
                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label80" runat="server" Text="부품사진" />
                                    </th>

                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label81" runat="server" Text="포장사진"/>
                                    </th>  
                                    <th class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label82" runat="server" Text="NOTE(포장방법에 대해 설명하시오)"/>
                                    </th>                                      
                                </tr>        
                                <tr>
                                    <td class="vt_am line" style="padding:3px 3px 3px 3px !important;">
                                        <ext:FieldContainer ID="FieldContainer9" runat="server" Width="380" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                            <Items>   
                                                <ext:FileUploadField ID="fuf01_PHOTO1" runat="server" ButtonText="Upload" 
                                                                    Width="310" Regex="\.(jpg|jpeg|jpe|jfif|gif|bmp|dib|png|tif|tiff|ico?)$" RegexText="Only image files are allowed."
                                                                     FieldStyle="background:yellow !important;">
                                                        <DirectEvents>                
                                                            <Change OnEvent="FileSelected" />
                                                        </DirectEvents>
                                                </ext:FileUploadField> 
                                                <ext:ImageButton ID="btn01_REMOVE_PHOTO1" runat="server" ToggleGroup="Group1" ImageUrl="../../images/btn/btn_upload_delete.gif"
                                                    OverImageUrl="../../images/btn/btn_upload_delete.gif" DisabledImageUrl="../../images/btn/btn_upload_delete.gif"
                                                    PressedImageUrl="../../images/btn/btn_upload_delete.gif">
                                                    <DirectEvents>
                                                        <Click OnEvent="etc_Button_Click" />
                                                    </DirectEvents>
                                                </ext:ImageButton>    
                                            </Items>
                                        </ext:FieldContainer>  
                                        <ext:Panel ID="Panel6" runat="server"  Region="South" Width="380px" Border="True" BodyStyle="overflow-y:auto;" Height="294px">
                                            <Items>
                                                <ext:Image ID="img01_PHOTO1" runat="server">
                                                    <Listeners><Click Handler="ImageZoomPopup(this);"></Click></Listeners>
                                                </ext:Image>
                                            </Items>
                                        </ext:Panel>
                                    </td>       
                                    <td class="vt_am line" style="padding:3px 3px 3px 3px !important;">
                                        <ext:FieldContainer ID="FieldContainer1" runat="server" Width="380" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                            <Items>   
                                                <ext:FileUploadField ID="fuf01_PHOTO2" runat="server" ButtonText="Upload" 
                                                                    Width="310" Regex="\.(jpg|jpeg|jpe|jfif|gif|bmp|dib|png|tif|tiff|ico?)$" RegexText="Only image files are allowed."
                                                                     FieldStyle="background:yellow !important;"> 
                                                        <DirectEvents>                
                                                            <Change OnEvent="FileSelected" />
                                                        </DirectEvents>                                                                                                                                                          
                                                </ext:FileUploadField> 
                                                <ext:ImageButton ID="btn01_REMOVE_PHOTO2" runat="server" ToggleGroup="Group1" ImageUrl="../../images/btn/btn_upload_delete.gif"
                                                    OverImageUrl="../../images/btn/btn_upload_delete.gif" DisabledImageUrl="../../images/btn/btn_upload_delete.gif"
                                                    PressedImageUrl="../../images/btn/btn_upload_delete.gif">
                                                    <DirectEvents>
                                                        <Click OnEvent="etc_Button_Click" />
                                                    </DirectEvents>
                                                </ext:ImageButton>    
                                            </Items>
                                        </ext:FieldContainer>  
                                        <ext:Panel ID="Panel7" runat="server"  Region="South" Width="380px" Border="True" BodyStyle="overflow-y:auto;" Height="294px">
                                            <Items>
                                                <ext:Image ID="img01_PHOTO2" runat="server">
                                                    <Listeners><Click Handler="ImageZoomPopup(this);"></Click></Listeners>
                                                </ext:Image>
                                            </Items>
                                        </ext:Panel>
                                    </td>
                                    <td>
                                       <ext:TextArea  ID="txt01_NOTE"  runat="server" Width="523" Cls="inputTextAr" Height="314px"  />
                                    </td>                                    
                                </tr>                                                            
                            </table>
                        </Content>
                    </ext:Panel>

                     <%--부품/중포장/대포장 정보--%>
                    <ext:Label ID="Label83" runat="server" Cls="bottom_area_title_name" Text="부품/중포장/대포장 정보" />
                    <ext:Panel ID="Panel8" Cls="excel_upload_area_table" runat="server" StyleSpec="width:1300px !important;">
                        <Content>
                            <table>
                                <colgroup> 
                                    <col style="width: 100px;" />
                                    <col style="width: 300px;" />
                                    <col style="width: 100px;" />
                                    <col style="width: 300px;" />                                   
                                    <col style="width: 100px;" />
                                    <col style="width: 300px;" />
                                    <col style="width: 150px;" />
                                    <col />
                                </colgroup>
                                
                                <tr>
                                    <th colspan="2" class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label84" runat="server" Text="부품정보" />
                                    </th>

                                    <th colspan="2" class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label85" runat="server" Text="중포장 정보"/>
                                    </th>  
                                    <th colspan="3" class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label91" runat="server" Text="대포장 정보"/>
                                    </th>                                      
                                </tr>        
                                <tr>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label92" runat="server" Text="대표품번"/>
                                    </th>      
                                    <td class="line">
                                        <ext:TextField ID="txt01_MAIN_PARTNO"  runat="server" Width="280" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label93" runat="server" Text="중포장코드"/>
                                    </th>      
                                    <td class="line">
                                        <%--<ext:TextField ID="txt01_MID_PACKCODE"  runat="server" Width="280" Cls="inputText" />--%>
                                        <ext:FieldContainer ID="FieldContainer17" runat="server" Width="280" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                            <Items>   
                                                <ext:TextField ID="txt01_MID_PACKCODE"  runat="server" Width="200" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                                <ext:Button ID="btn01_GET_MID_PACKINFO" runat="server" TextAlign="Center" Text="불러오기" >
                                                    <DirectEvents>
                                                       <Click OnEvent="etc_Button_Click" /> 
                                                    </DirectEvents>
                                                </ext:Button>  
                                            </Items>
                                        </ext:FieldContainer>
                                    </td>      
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label94" runat="server" Text="대포장코드"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer16" runat="server" Width="280" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                            <Items>   
                                                <ext:TextField ID="txt01_LARGE_PACKCODE"  runat="server" Width="200" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                                <ext:Button ID="btn01_GET_LAGE_PACKINFO" runat="server" TextAlign="Center" Text="불러오기" >
                                                    <DirectEvents>
                                                       <Click OnEvent="etc_Button_Click" /> 
                                                    </DirectEvents>
                                                </ext:Button>  
                                            </Items>
                                        </ext:FieldContainer>
                                    </td>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label95" runat="server" Text="발주단위"/>
                                    </th>      
                                </tr>   
                                <tr>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label96" runat="server" Text="대표품명"/>
                                    </th>      
                                    <td class="line">
                                        <ext:TextField ID="txt01_MAIN_PARTNM"  runat="server" Width="280" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label97" runat="server" Text="외측사이즈"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer6" runat="server" MsgTarget="Side" Flex="1" Width="185" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_MID_PACK_X"  runat="server" Width="50" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_larg_load_rate_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label42" runat="server" Text="mm" Padding="0"/>
                                            <ext:Label ID="Label43" runat="server" Text="X" Padding="10"/>
                                            <ext:NumberField ID="txt01_MID_PACK_Y"  runat="server" Width="50" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_larg_load_rate_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label44" runat="server" Text="mm" Padding="0"/>
                                            <ext:Label ID="Label45" runat="server" Text="X" Padding="10"/>
                                            <ext:NumberField ID="txt01_MID_PACK_Z"  runat="server" Width="50" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_larg_load_rate_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label46" runat="server" Text="mm" Padding="0"/>
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>      
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label98" runat="server" Text="내측사이즈"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer7" runat="server" MsgTarget="Side" Flex="1" Width="185" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_LARGE_PACK_X"  runat="server" Width="50" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_larg_load_rate_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label47" runat="server" Text="mm" Padding="0"/>
                                            <ext:Label ID="Label48" runat="server" Text="X" Padding="10"/>
                                            <ext:NumberField ID="txt01_LARGE_PACK_Y"  runat="server" Width="50" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_larg_load_rate_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label49" runat="server" Text="mm" Padding="0"/>
                                            <ext:Label ID="Label50" runat="server" Text="X" Padding="10"/>
                                            <ext:NumberField ID="txt01_LARGE_PACK_Z"  runat="server" Width="50" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_larg_load_rate_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label51" runat="server" Text="mm" Padding="0"/>
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line">
                                         <ext:ComboBox ID="cbo01_LARGE_PO_MEASURE" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="160" Editable="false" >
                                            <Items>                                                
                                                <ext:ListItem Value="중포장" Text="중포장" />
                                                <ext:ListItem Value="대포장" Text="대포장" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>     
                                </tr>   
                                <tr>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label99" runat="server" Text="주원재료"/>
                                    </th>      
                                    <td class="line">
                                        <ext:TextField ID="txt01_MAIN_INGRIDIENT"  runat="server" Width="280" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label100" runat="server" Text="1단수량"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer8" runat="server" MsgTarget="Side" Flex="1" Width="240" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_MID_F_QTY"  runat="server" Width="205" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_mid_load_qty_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:ComboBox ID="cbo01_MID_F_QTY_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 5px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                            <ext:Label ID="Label52" runat="server" Text="/단" Padding="2"/>
                                            </Items>
                                        </ext:FieldContainer>
                                    </td>      
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label101" runat="server" Text="1단수량"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer10" runat="server" MsgTarget="Side" Flex="1" Width="240" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_LARGE_F_QTY"  runat="server" Width="210" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_large_load_qty_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:ComboBox ID="cbo01_LARGE_F_QTY_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="50" Editable="false" PaddingSpec="0px 0px 0px 5px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="BOX" Text="BOX" />
                                                    <ext:ListItem Value="PL" Text="PL" />                                                    
                                                </Items>
                                            </ext:ComboBox>
                                            <ext:Label ID="Label53" runat="server" Text="/단" Padding="2"/>
                                            </Items>
                                        </ext:FieldContainer>
                                    </td>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label102" runat="server" Text="최소발주"/>
                                    </th>      
                                </tr>   
                                <tr>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label103" runat="server" Text="표면처리"/>
                                    </th>      
                                    <td class="line">
                                         <ext:ComboBox ID="cbo01_SURFACE" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="115" Editable="false" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="유" Text="유" />
                                                <ext:ListItem Value="무" Text="무" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label104" runat="server" Text="적재단수"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer11" runat="server" MsgTarget="Side" Flex="1" Width="240" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_MID_LOAD_DEPTH"  runat="server" Width="240" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_mid_load_qty_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label54" runat="server" Text="단" Padding="10"/>
                                            </Items>
                                        </ext:FieldContainer>
                                    </td>      
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label105" runat="server" Text="적재단수"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer12" runat="server" MsgTarget="Side" Flex="1" Width="185" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_LARGE_LOAD_DEPTH"  runat="server" Width="240" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_large_load_qty_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label55" runat="server" Text="단" Padding="10"/>
                                            </Items>
                                        </ext:FieldContainer>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt01_LARGE_PO_MIN_QTY"  runat="server" Width="160" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                    </td>     
                                </tr>   
                                <tr>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label106" runat="server" Text="부품무게"/>
                                    </th>      
                                    <td class="line">
                                    <ext:FieldContainer ID="cdx_CodeBox" runat="server" MsgTarget="Side" Flex="1" Width="185" Layout="TableLayout">
                                        <Items>                                        
                                        <ext:NumberField ID="txt01_PART_WEIGHT"  runat="server" Width="240" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                        <ext:Label ID="Label33" runat="server" Text="g/EA" Padding="10"/>
                                        </Items>
                                    </ext:FieldContainer>
                                    </td>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label107" runat="server" Text="적입수량"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer2" runat="server" MsgTarget="Side" Flex="1" Width="240" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_MID_LOAD_QTY"  runat="server" Width="165" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" FieldStyle="background:yellow !important;" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_setLarge_load_qty_ea();"></KeyUp>
                                                </Listeners>                                                
                                            </ext:NumberField>
                                            <ext:ComboBox ID="cbo01_MID_LOAD_QTY_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 5px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                            <ext:Label ID="Label34" runat="server" Text="/" Padding="0"/>
                                            <ext:ComboBox ID="cbo01_MID_LOAD_QTY_UNIT2" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="55" Editable="false" PaddingSpec="0px 0px 0px 5px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="BOX" Text="BOX" />
                                                    <ext:ListItem Value="BAG" Text="BAG" />                                                    
                                                </Items>
                                            </ext:ComboBox>
                                            </Items>
                                        </ext:FieldContainer>
                                    </td>      
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label108" runat="server" Text="적입수량"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer13" runat="server" MsgTarget="Side" Flex="1" Width="240" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_LARGE_LOAD_QTY"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_setLarge_load_qty_ea();"></KeyUp>
                                                </Listeners>       
                                            </ext:NumberField>
                                            <ext:Label ID="Label56" runat="server" Text="BOX" Padding="5"/>
                                            <ext:Label ID="Label58" runat="server" Text="/" Padding="2"/>
                                            <ext:NumberField ID="txt01_LARGE_LOAD_QTY_EA"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
<%--                                                <Listeners>
                                                    <KeyUp Handler="fn_setLarge_load_qty_ea();"></KeyUp>
                                                </Listeners>       --%>
                                            </ext:NumberField>
                                            <ext:ComboBox ID="cbo01_LARGE_LOAD_QTY_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 5px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                            <%--<ext:Label ID="Label57" runat="server" Text="EA" Padding="10"/>--%>
                                            </Items>
                                        </ext:FieldContainer>
                                    </td>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label109" runat="server" Text="대포장 적입율"/>
                                    </th>      
                                </tr>   
                                <tr>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label110" runat="server" Text="부품사이즈"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer3" runat="server" MsgTarget="Side" Flex="1" Width="185" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_PART_SIZE_X"  runat="server" Width="50" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                            <ext:Label ID="Label35" runat="server" Text="mm" Padding="0"/>
                                            <ext:Label ID="Label39" runat="server" Text="X" Padding="10"/>
                                            <ext:NumberField ID="txt01_PART_SIZE_Y"  runat="server" Width="50" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                            <ext:Label ID="Label37" runat="server" Text="mm" Padding="0"/>
                                            <ext:Label ID="Label40" runat="server" Text="X" Padding="10"/>
                                            <ext:NumberField ID="txt01_PART_SIZE_Z"  runat="server" Width="50" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                            <ext:Label ID="Label38" runat="server" Text="mm" Padding="0"/>
                                            </Items>
                                        </ext:FieldContainer>                                        
                                    </td>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label111" runat="server" Text="박스중량"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer4" runat="server" MsgTarget="Side" Flex="1" Width="240" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_MID_BOX_WEIGHT"  runat="server" Width="240" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;">
                                                <Listeners>
                                                    <Change Fn="fn_largebox_weight_change"></Change>
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label36" runat="server" Text="Kg" Padding="10"/>
                                            </Items>
                                        </ext:FieldContainer>                                        
                                    </td>      
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label112" runat="server" Text="대박스중량"/>
                                    </th>      
                                    <td class="line">
                                        <ext:FieldContainer ID="FieldContainer14" runat="server" MsgTarget="Side" Flex="1" Width="240" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_LARGE_BOX_WEIGHT"  runat="server" Width="240" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                            <ext:Label ID="Label59" runat="server" Text="Kg" Padding="10"/>
                                            </Items>
                                        </ext:FieldContainer>  
                                    </td>
                                    <td rowspan="2" class="line" style="text-align:right;">                                        
                                        <ext:FieldContainer ID="FieldContainer15" runat="server" MsgTarget="Side" Flex="1" Width="150" Height="50" Layout="TableLayout" StyleSpec="vertical-align:middle;">
                                            <Items>                                        
                                                <ext:TextField ID="txt01_LARGE_LOAD_RATE"  runat="server" Width="135" Height="50" Cls="inputText" ReadOnly="true" FieldStyle="text-align: right;" >
                                                    <Listeners>
                                                        <Change Handler="this.setValue(Ext.util.Format.number(this.getValue().replace(/[,]/g, ''), '0,000'));"></Change>
                                                    </Listeners>
                                                </ext:TextField>                                           
                                                <ext:TextField ID="txt01_percentLabel"  runat="server" Width="25" Height="50"  Text="%" ReadOnly="true" />
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>     
                                </tr>   
                                <tr>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label113" runat="server" Text="U/S"/>
                                    </th>      
                                    <td class="line" align="right">
                                        <ext:FieldContainer ID="FieldContainer5" runat="server" MsgTarget="Side" Flex="1" Width="240" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_PART_USAGE"  runat="server" Width="230" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                            <ext:ComboBox ID="cbo01_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="50" Editable="false" PaddingSpec="0px 0px 0px 5px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label114" runat="server" Text="방청여부"/>
                                    </th>      
                                    <td class="line">
                                         <ext:ComboBox ID="cbo01_MID_ANTI_RUST" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="115" Editable="false" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="유" Text="유" />
                                                <ext:ListItem Value="무" Text="무" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>      
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label115" runat="server" Text="방청여부"/>
                                    </th>      
                                    <td class="line">
                                         <ext:ComboBox ID="cbo01_LARGE_ANTI_RUST" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="115" Editable="false" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="유" Text="유" />
                                                <ext:ListItem Value="무" Text="무" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>                                    
                                </tr>                                                                                                                                                                                                  
                            </table>
                        </Content>
                    </ext:Panel>

                    <%--동일포장사양/포장재료/변경내역 정보--%>
                    <ext:Label ID="Label116" runat="server" Cls="bottom_area_title_name" Text="동일포장사양/포장재료/변경내역 정보" />
                    <ext:Panel ID="Panel9" Cls="excel_upload_area_table" runat="server" StyleSpec="width:1300px !important;">
                        <Content>
                            <table>
                                <colgroup> 
                                    <col style="width: 35px;" />
                                    <col style="width: 150px;" />
                                    <col style="width: 150px;" />
                                    <col style="width: 35px;" />                                   
                                    <col style="width: 150px;" />
                                    <col style="width: 100px;" />
                                    <col style="width: 200px;" />                                    
                                    <col style="width: 80px;" />                                   
                                    <col style="width: 100px;" />
                                    <col style="width: 35px;" />
                                    <col style="width: 150px;" />
                                    <col />
                                </colgroup>
                                
                                <tr>
                                    <th colspan="3" class="line" style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label117" runat="server" Text="동일포장사양 정보" />
                                    </th>

                                    <th colspan="6" class="line" style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#EDE7F6;">
                                        <ext:Label ID="Label118" runat="server" Text="포장재료 정보"/>
                                    </th>  
                                    <th colspan="3" class="line" style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#C8E6C9;">
                                        <ext:Label ID="Label119" runat="server" Text="변경내역"/>
                                    </th>                                      
                                </tr>        
                                <tr>
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label120" runat="server" Text="NO"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label121" runat="server" Text="PART NO"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label122" runat="server" Text="적용시점"/>
                                    </th>          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#EDE7F6;">
                                        <ext:Label ID="Label1" runat="server" Text="NO"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#EDE7F6;">
                                        <ext:Label ID="Label2" runat="server" Text="포장재"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#EDE7F6;">
                                        <ext:Label ID="Label3" runat="server" Text="재질"/>
                                    </th>  
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#EDE7F6;">
                                        <ext:Label ID="Label4" runat="server" Text="규격"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#EDE7F6;">
                                        <ext:Label ID="Label5" runat="server" Text="단위"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#EDE7F6;">
                                        <ext:Label ID="Label6" runat="server" Text="소요량"/>
                                    </th>  
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#C8E6C9;">
                                        <ext:Label ID="Label7" runat="server" Text="NO"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#C8E6C9;">
                                        <ext:Label ID="Label8" runat="server" Text="변경내용"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;background-color:#C8E6C9;">
                                        <ext:Label ID="Label9" runat="server" Text="적용시점"/>
                                    </th>                                                                                                                                              
                                </tr>   
                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:NumberField ID="txt01_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt01_PARTNO"  runat="server" Width="135" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte01_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true" />
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt01_MID_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                      <ext:ComboBox ID="cbo01_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="140" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" />                         
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <DirectEvents>
                                                <Select OnEvent="MATERIAL_SELECT"></Select>
                                            </DirectEvents>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt01_MATERIAL"  runat="server" Width="95" Cls="inputText" FieldStyle="background:yellow !important;" />
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt01_STANDARD"  runat="server" Width="195" Cls="inputText" FieldStyle="background:yellow !important;" />
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo01_MAT_UNIT" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" PaddingSpec="0px 0px 0px 0px" FieldStyle="background:yellow !important;" >
                                            <Items>                                                
                                                <ext:ListItem Value="EA" Text="EA" />
                                                <ext:ListItem Value="RL" Text="RL" />
                                                <ext:ListItem Value="KG" Text="KG" />
                                                <ext:ListItem Value="SH" Text="SH" />
                                                <ext:ListItem Value="M" Text="M" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt01_PACK_USAGE"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt01_CHG_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt01_CHG_REASON"  runat="server" Width="145" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte01_CHG_DATE" Width="95" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                </tr>  
                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:NumberField ID="txt02_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt02_PARTNO"  runat="server" Width="135" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte02_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt02_MID_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                      <ext:ComboBox ID="cbo02_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="140" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" />     
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />   
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />                                                                     
                                            </Items>
                                            <DirectEvents>
                                                <Select OnEvent="MATERIAL_SELECT"></Select>
                                            </DirectEvents>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt02_MATERIAL"  runat="server" Width="95" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt02_STANDARD"  runat="server" Width="195" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo02_MAT_UNIT" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" PaddingSpec="0px 0px 0px 0px"  FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="EA" Text="EA" />
                                                <ext:ListItem Value="RL" Text="RL" />
                                                <ext:ListItem Value="KG" Text="KG" />
                                                <ext:ListItem Value="SH" Text="SH" />
                                                <ext:ListItem Value="M" Text="M" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt02_PACK_USAGE"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt02_CHG_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt02_CHG_REASON"  runat="server" Width="145" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte02_CHG_DATE" Width="95" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                </tr>  


                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:NumberField ID="txt03_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt03_PARTNO"  runat="server" Width="135" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte03_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt03_MID_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                      <ext:ComboBox ID="cbo03_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="140" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" />      
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                                                                    
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <DirectEvents>
                                                <Select OnEvent="MATERIAL_SELECT"></Select>
                                            </DirectEvents>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt03_MATERIAL"  runat="server" Width="95" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt03_STANDARD"  runat="server" Width="195" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo03_MAT_UNIT" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" PaddingSpec="0px 0px 0px 0px"  FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="EA" Text="EA" />
                                                <ext:ListItem Value="RL" Text="RL" />
                                                <ext:ListItem Value="KG" Text="KG" />
                                                <ext:ListItem Value="SH" Text="SH" />
                                                <ext:ListItem Value="M" Text="M" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt03_PACK_USAGE"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt03_CHG_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt03_CHG_REASON"  runat="server" Width="145" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte03_CHG_DATE" Width="95" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                </tr>  

                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:NumberField ID="txt04_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt04_PARTNO"  runat="server" Width="135" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte04_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt04_MID_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                      <ext:ComboBox ID="cbo04_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="140" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" />  
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                                                                        
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <DirectEvents>
                                                <Select OnEvent="MATERIAL_SELECT"></Select>
                                            </DirectEvents>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt04_MATERIAL"  runat="server" Width="95" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt04_STANDARD"  runat="server" Width="195" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo04_MAT_UNIT" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" PaddingSpec="0px 0px 0px 0px"  FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="EA" Text="EA" />
                                                <ext:ListItem Value="RL" Text="RL" />
                                                <ext:ListItem Value="KG" Text="KG" />
                                                <ext:ListItem Value="SH" Text="SH" />
                                                <ext:ListItem Value="M" Text="M" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt04_PACK_USAGE"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt04_CHG_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt04_CHG_REASON"  runat="server" Width="145" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte04_CHG_DATE" Width="95" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                </tr>  

                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:NumberField ID="txt05_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt05_PARTNO"  runat="server" Width="135" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte05_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt05_MID_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                      <ext:ComboBox ID="cbo05_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="140" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" />    
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                                                                      
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <DirectEvents>
                                                <Select OnEvent="MATERIAL_SELECT"></Select>
                                            </DirectEvents>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt05_MATERIAL"  runat="server" Width="95" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt05_STANDARD"  runat="server" Width="195" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo05_MAT_UNIT" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" PaddingSpec="0px 0px 0px 0px"  FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="EA" Text="EA" />
                                                <ext:ListItem Value="RL" Text="RL" />
                                                <ext:ListItem Value="KG" Text="KG" />
                                                <ext:ListItem Value="SH" Text="SH" />
                                                <ext:ListItem Value="M" Text="M" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt05_PACK_USAGE"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt05_CHG_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt05_CHG_REASON"  runat="server" Width="145" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte05_CHG_DATE" Width="95" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                </tr>  

                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:NumberField ID="txt06_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt06_PARTNO"  runat="server" Width="135" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte06_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt06_MID_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                      <ext:ComboBox ID="cbo06_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="140" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                                                                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <DirectEvents>
                                                <Select OnEvent="MATERIAL_SELECT"></Select>
                                            </DirectEvents>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt06_MATERIAL"  runat="server" Width="95" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt06_STANDARD"  runat="server" Width="195" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo06_MAT_UNIT" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" PaddingSpec="0px 0px 0px 0px"  FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="EA" Text="EA" />
                                                <ext:ListItem Value="RL" Text="RL" />
                                                <ext:ListItem Value="KG" Text="KG" />
                                                <ext:ListItem Value="SH" Text="SH" />
                                                <ext:ListItem Value="M" Text="M" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt06_PACK_USAGE"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt06_CHG_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt06_CHG_REASON"  runat="server" Width="145" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte06_CHG_DATE" Width="95" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                </tr>  

                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:NumberField ID="txt07_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt07_PARTNO"  runat="server" Width="135" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte07_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt07_MID_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                      <ext:ComboBox ID="cbo07_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="140" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" />     
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                                                                     
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <DirectEvents>
                                                <Select OnEvent="MATERIAL_SELECT"></Select>
                                            </DirectEvents>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt07_MATERIAL"  runat="server" Width="95" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt07_STANDARD"  runat="server" Width="195" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo07_MAT_UNIT" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" PaddingSpec="0px 0px 0px 0px"  FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="EA" Text="EA" />
                                                <ext:ListItem Value="RL" Text="RL" />
                                                <ext:ListItem Value="KG" Text="KG" />
                                                <ext:ListItem Value="SH" Text="SH" />
                                                <ext:ListItem Value="M" Text="M" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt07_PACK_USAGE"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt07_CHG_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt07_CHG_REASON"  runat="server" Width="145" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte07_CHG_DATE" Width="95" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                </tr>  

                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:NumberField ID="txt08_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt08_PARTNO"  runat="server" Width="135" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte08_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt08_MID_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                      <ext:ComboBox ID="cbo08_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="140" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" />     
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                                                                     
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <DirectEvents>
                                                <Select OnEvent="MATERIAL_SELECT"></Select>
                                            </DirectEvents>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt08_MATERIAL"  runat="server" Width="95" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt08_STANDARD"  runat="server" Width="195" Cls="inputText" FieldStyle="background:yellow !important;" />
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo08_MAT_UNIT" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" PaddingSpec="0px 0px 0px 0px" FieldStyle="background:yellow !important;" >
                                            <Items>                                                
                                                <ext:ListItem Value="EA" Text="EA" />
                                                <ext:ListItem Value="RL" Text="RL" />
                                                <ext:ListItem Value="KG" Text="KG" />
                                                <ext:ListItem Value="SH" Text="SH" />
                                                <ext:ListItem Value="M" Text="M" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt08_PACK_USAGE"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt08_CHG_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt08_CHG_REASON"  runat="server" Width="145" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte08_CHG_DATE" Width="95" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                </tr>  

                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:NumberField ID="txt09_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt09_PARTNO"  runat="server" Width="135" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte09_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt09_MID_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                      <ext:ComboBox ID="cbo09_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="140" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" />   
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                                                                       
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <DirectEvents>
                                                <Select OnEvent="MATERIAL_SELECT"></Select>
                                            </DirectEvents>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt09_MATERIAL"  runat="server" Width="95" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt09_STANDARD"  runat="server" Width="195" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo09_MAT_UNIT" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" PaddingSpec="0px 0px 0px 0px"  FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="EA" Text="EA" />
                                                <ext:ListItem Value="RL" Text="RL" />
                                                <ext:ListItem Value="KG" Text="KG" />
                                                <ext:ListItem Value="SH" Text="SH" />
                                                <ext:ListItem Value="M" Text="M" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt09_PACK_USAGE"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt09_CHG_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt09_CHG_REASON"  runat="server" Width="145" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte09_CHG_DATE" Width="95" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                </tr>  

                                <tr style="height:30px;">
                                    <td class="line">
                                        <ext:NumberField ID="txt10_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt10_PARTNO"  runat="server" Width="135" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte10_APPLY_DATE" Width="135" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt10_MID_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                      <ext:ComboBox ID="cbo10_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="140" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <DirectEvents>
                                                <Select OnEvent="MATERIAL_SELECT"></Select>
                                            </DirectEvents>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt10_MATERIAL"  runat="server" Width="95" Cls="inputText" FieldStyle="background:yellow !important;" />
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt10_STANDARD"  runat="server" Width="195" Cls="inputText"  FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:ComboBox ID="cbo10_MAT_UNIT" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" PaddingSpec="0px 0px 0px 0px" FieldStyle="background:yellow !important;">
                                            <Items>                                                
                                                <ext:ListItem Value="EA" Text="EA" />
                                                <ext:ListItem Value="RL" Text="RL" />
                                                <ext:ListItem Value="KG" Text="KG" />
                                                <ext:ListItem Value="SH" Text="SH" />
                                                <ext:ListItem Value="M" Text="M" />
                                            </Items>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt10_PACK_USAGE"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:NumberField ID="txt10_CHG_NO"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt10_CHG_REASON"  runat="server" Width="145" Cls="inputText" />
                                    </td>
                                    <td class="line">
                                        <ext:DateField ID="dte10_CHG_DATE" Width="95" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                </tr>  

                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                                                                                                     
                            </table>
                        </Content>
                    </ext:Panel>



                    <%--검토 및 승인 정보
                     4.X height적용--%>
                    <ext:Label ID="Label10" runat="server" Cls="bottom_area_title_name" Text="검토 및 승인 정보" />
                    <ext:Panel ID="Panel1" Cls="excel_upload_area_table" runat="server" Height="100" StyleSpec="width:1300px !important;"> 
                        <Content>
                            <table>
                                <colgroup> 
                                    <col style="width: 60px;" />
                                    <col style="width: 112px;" />
                                    <col style="width: 112px;" />
                                    <col style="width: 112px;" />
                                    <col style="width: 60px;" />                                   
                                    <col style="width: 112px;" />                                    
                                    <col style="width: 112px;" />
                                    <col style="width: 112px;" />
                                    <col style="width: 60px;" />
                                    <col style="width: 112px;" />                                   
                                    <col style="width: 112px;" />    
                                    <col style="width: 60px;" />
                                    <col style="width: 112px;" />                                                                                                                                            
                                    <col />
                                </colgroup>                                        
                                <tr>
                                    <th rowspan="2" class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label14" runat="server" Text="공"/><br />
                                        <ext:Label ID="Label11" runat="server" Text="급"/><br />
                                        <ext:Label ID="Label12" runat="server" Text="업"/><br />
                                        <ext:Label ID="Label13" runat="server" Text="체"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label15" runat="server" Text="작성일"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label16" runat="server" Text="담당"/>
                                    </th>          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label17" runat="server" Text="승인"/>
                                    </th>                                                                              
                                    <th rowspan="2" class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label18" runat="server" Text="서"/><br />
                                        <ext:Label ID="Label26" runat="server" Text="연"/><br />
                                        <ext:Label ID="Label27" runat="server" Text="이"/><br />
                                        <ext:Label ID="Label28" runat="server" Text="화"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label22" runat="server" Text="접수일"/>
                                    </th>  
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label19" runat="server" Text="담당"/>
                                    </th>                                         
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label21" runat="server" Text="승인"/>
                                    </th>                                                                              
                                    <th rowspan="2" class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label23" runat="server" Text="해"/><br />
                                        <ext:Label ID="Label24" runat="server" Text="외"/><br />
                                        <ext:Label ID="Label25" runat="server" Text="법"/><br />
                                        <ext:Label ID="Label29" runat="server" Text="인"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label30" runat="server" Text="접수일"/>
                                    </th>                                          
<%--                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label31" runat="server" Text="담당"/>
                                    </th>  --%>        
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label32" runat="server" Text="승인"/>
                                    </th>    
                                    <th rowspan="2" class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label31" runat="server" Text="글"/><br />
                                        <ext:Label ID="Label57" runat="server" Text="로"/><br />
                                        <ext:Label ID="Label60" runat="server" Text="벌"/><br />
                                        <ext:Label ID="Label64" runat="server" Text="품"/><br />
                                        <ext:Label ID="Label61" runat="server" Text="질"/>
                                    </th>                                          
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label62" runat="server" Text="접수일"/>
                                    </th>                                            
                                    <th class="line"style="font-weight:bold;text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label63" runat="server" Text="확인"/>
                                    </th>                                                                                                                                                                              
                                </tr>   
                                <tr style="height:30px;">
                                    <td class="line" style="vertical-align:middle;">                                        
                                        <ext:DateField ID="dte01_VEND_WRITE_DATE" Width="105" Cls="inputDate" Type="Date" runat="server" Editable="true"   FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt01_VEND_CHARGER"  runat="server" Width="100"  Height="60" Cls="inputText" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt01_VEND_APPLY"  runat="server" Width="100"  Height="60" Cls="inputText" FieldStyle="background:yellow !important;"/>
                                    </td>
                                    <td class="line"style="vertical-align:middle;">
                                        <ext:DateField ID="dte01_SEOYON_ACCEPT_DATE" Width="105" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                    <td class="line">
                                        <ext:TextField ID="txt01_SEOYON_CHARGER"  runat="server" Width="100"  Height="60" Cls="inputText"/>
                                    </td>
<%--                                    <td class="line">
                                        <ext:TextField ID="txt01_SEOYON_CHECK"  runat="server" Width="85"  Height="60" Cls="inputText"/>
                                    </td>--%>
                                    <td class="line">
                                        <ext:TextField ID="txt01_SEOYON_APPLY"  runat="server" Width="100"  Height="60" Cls="inputText"/>
                                    </td>
                                    <td class="line"style="vertical-align:middle;">
                                        <ext:DateField ID="dte01_CUST_ACCEPT_DATE" Width="105" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
<%--                                    <td class="line">
                                        <ext:TextField ID="txt01_CUST_CHECK"  runat="server" Width="85"  Height="60" Cls="inputText"/>
                                    </td>--%>
                                    <td class="line">
                                        <ext:TextField ID="txt01_CUST_APPLY"  runat="server" Width="100"  Height="60" Cls="inputText"/>
                                    </td>           
                                   <td class="line"style="vertical-align:middle;">
                                        <ext:DateField ID="dte01_GLOBAL_ACCEPT_DATE" Width="105" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                    
                                    <td class="line">
                                        <ext:TextField ID="txt01_GLOBAL_CHECK"  runat="server" Width="85"  Height="60" Cls="inputText"/>
                                    </td>                                                                                                  
                                </tr>                                                                                                                                                                                                                                                                                                                                                                                                                              
                            </table>
                        </Content>
                    </ext:Panel>


                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
