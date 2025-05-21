<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA23001P1.aspx.cs" Inherits="Ax.EP.WP.Home.SRM_QA.SRM_QA23001P1" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible"/>
<meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
<meta content="/images/favicon/SCM.ico" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
    <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    <meta content="/images/favicon/SCM.ico" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>검사성적서 등록 Popup</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
	    .x-grid-cell-X1 DIV,	    
	    .x-grid-cell-X2 DIV,	    
	    .x-grid-cell-X3 DIV,	    
	    .x-grid-cell-X4 DIV,
	    .x-grid-cell-X5 DIV,
	    .x-grid-cell-X6 DIV,
	    .x-grid-cell-X7 DIV,
	    .x-grid-cell-X8 DIV,
	    .x-grid-cell-X9 DIV,
	    .x-grid-cell-X10 DIV,
	    .x-grid-cell-X11 DIV,	    
	    .x-grid-cell-X12 DIV,	    
	    .x-grid-cell-X13 DIV,	    
	    .x-grid-cell-X14 DIV,
	    .x-grid-cell-X15 DIV,
	    .x-grid-cell-X16 DIV,
	    .x-grid-cell-X17 DIV,
	    .x-grid-cell-X18 DIV,
	    .x-grid-cell-X19 DIV,
	    .x-grid-cell-X20 DIV
	    {	
		    border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }
	    
	    .search_area_table table td 
	    {
	        text-align: left;
            border-bottom: 1px solid #b1b1b1;
            color: #000;
            vertical-align: middle;
            vertical-align: top;
            padding: 3px 0 0 10px;
	    }
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            
            //각 패널 사이즈를 계산하여 설정.
            App.BottomGridPanel.setHeight(App.GridPanel.getHeight() - App.TopGridPanel.getHeight());
            App.BottomGridGridPanel.setHeight(App.BottomGridPanel.getHeight() - App.BottomGridTitlePanel.getHeight() - App.BottomGridMarginPanel.getHeight());
            
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.TopGridGridPanel.getHeight());
            App.Grid02.setHeight(App.BottomGridGridPanel.getHeight());
        }



        // 그리드를 editor한 후에 발생되는 이벤트
        //
        var AfterEdit = function (rowEditor, e) {
            SetJudge(e.rowIdx);            
        }

        //판정처리
        function SetJudge(rowIdx) {
            //입력값으로 판정 처리. 하나라도 기준에서 벗어나면 불합격임.
            var grid = App.Grid01;
            var min = grid.getStore().getAt(rowIdx).data["INSPECT_MIN_MEAS"];
            var max = grid.getStore().getAt(rowIdx).data["INSPECT_MAX_MEAS"];
            var inp_count = grid.getStore().getAt(rowIdx).data["INP_COUNT"]; //★★★★★ 20; 
            
            var val = 0; //값
            var rlt = 1; //0:불합격, 1:합격

            for (var i = 1; i <= inp_count; i++) {
                val = grid.getStore().getAt(rowIdx).data["X" + i.toString()];

                if (val == "") {
                    rlt = 0;
                }
                else {
                    if (val < min || val > max) {
                        rlt = 0;
                    }
                }
            }            
            grid.getStore().getAt(rowIdx).set("JUD_RESULT", rlt);
        }

        //체크박스 값 변경시 
        function CheckBoxChange(chk) {
            var col = chk.id.replace("chk01_","");
            var grid = App.Grid01;
            var rowcnt = grid.getStore().getTotalCount();
            var inp_count = parseInt(App.hiddenINP_COUNT.value, 10);
            var val = 0;

            if (chk.value == true) {
                val = 1;
            }
            if (col == "ALL") {
                //전체 체크박스인 경우 현재 표시중인 모든 컬럼의 전체행에 값 적용하고 판정 처리 
                for (var r = 0; r < rowcnt; r++) {
                    for (var c = 1; c <= inp_count; c++) {
                        
                        grid.getStore().getAt(r).set("X" + c.toString(), val);
                        SetJudge(r);
                    }
                }
            }
            else {
                //해당 컬럼의 모든 행에 값 적용하고 판정 처리
                for (var r = 0; r < rowcnt; r++) {
                    grid.getStore().getAt(r).set(col, val);
                    SetJudge(r);
                }
            }

        }

       
       //일괄 성적서 등록 확인 메시지
        var Confirm = function () {

            var langset = App.hiddenLANG_SET.value;
            var caption = "";
            var msg = "";

           
            //전체 일괄 성적서 등록 클릭시
            //해당 업체,날짜, 라인, 품목, 위치, 차수의 모든 item 성적서 자동 입력(합격으로)
            if (langset == "KO") {
                caption = "확인";
                msg = "다음의 검사결과를 일괄 합격처리 하시겠습니까?"      + "<br>";
                msg += "업체코드 : [" + App.hiddenVENDCD.getValue() + "]" + "<br>";
                msg += "투입일자 : [" + App.txt01_DD.text            + "]" + "<br>";
                msg += "투입차수 : [" + App.txt01_CHASU.text         + "]" + "<br>";
                if (App.hiddenLINENM.getValue() != "")
                    msg += "라인 : [" + App.hiddenLINENM.getValue() + "]" + "<br>";
                if (App.hiddenVINNM.getValue() != "")
                    msg += "차종 : [" + App.hiddenVINNM.getValue() + "]" + "<br>";
                msg += "자재품목 : [" + App.hiddenMAT_ITEMNM.getValue() + "]" + "<br>";
                msg += "위치 : [" + App.hiddenINSTALL_POSNM.getValue() + "]";
            }
            else {
                caption = "confirm";
                msg = "Do you want to pass the following items?"           + "<br>";
                msg += "Vendor : [" + App.hiddenVENDCD.getValue() + "]" + "<br>";
                msg += "date : ["     + App.txt01_DD.text            + "]" + "<br>";
                msg += "seq. : ["     + App.txt01_CHASU.text         + "]" + "<br>";
                if (App.hiddenLINENM.getValue() != "")
                    msg += "Line : [" + App.hiddenLINENM.getValue() + "]" + "<br>";
                if (App.hiddenVINNM.getValue() != "")
                    msg += "Car : [" + App.hiddenVINNM.getValue() + "]" + "<br>";
                msg += "Mat.Item : [" + App.hiddenMAT_ITEMNM.getValue() + "]" + "<br>";
                msg += "Position : [" + App.hiddenINSTALL_POSNM.getValue() + "]";
            }
            
            Ext.Msg.confirm(caption, msg, function (btn) {

                if (btn == 'yes') {
                    // FIRE click DIRECT EVENT OF BUTTON
                    App.direct.etc_Button_Click();
                }
            });
        }


    </script>
</head>
<body>
    <form id="SRM_QA23001P1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="hiddenLANG_SET" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenBIZCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenQTY" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenBARCODE" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenVENDCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenNOTE_TYPE" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenINP_COUNT" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenLINENM" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenVINNM" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenMAT_ITEMNM" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenINSTALL_POSNM" runat="server" Hidden="true"></ext:TextField>

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10" Cls="pdb10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_QA23001P1" runat="server" Cls="search_area_title_name" /><%--Text="검사성적서 등록" />--%>
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
                            <col style="width: 90px;" />
                            <col />
                            <col style="width: 90px;"/>
                            <col />
                            <col style="width: 90px;"/>
                            <col />
                            <col style="width: 90px;"/>
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_PARTNO" runat="server" /><%--Text="PART NO" />--%>
                            </th>
                            <td>
                                <ext:Label ID="txt01_PARTNO" Width="130" Cls="inputText" runat="server" />
                            </td>   
                            <th>
                                <ext:Label ID="lbl01_PARTNM" runat="server" /><%--Text="PART NAME" />--%>
                            </th>
                            <td>
                                <ext:Label ID="txt01_PARTNM" Width="250" Cls="inputText" runat="server" />
                            </td>
                            <th >
                                <ext:Label ID="lbl01_DD" runat="server" /><%--Text="일자" />--%>
                            </th>
                            <td>                               
                                <ext:Label ID="txt01_DD" Width="90" Cls="inputText" runat="server" />                                     
                            </td>
                            <th >
                                <ext:Label ID="lbl01_CHASU" runat="server" /><%--Text="차수" />--%>
                            </th>
                            <td>            
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="70" MsgTarget="Side" Layout="TableLayout">
                                    <Items>                   
                                        <ext:Label ID="txt01_CHASU" Width="40" Cls="inputText" runat="server" />        
                                        <ext:ImageButton ID="btn01_ALL" runat="server" ImageUrl="/images/btn/btn_search_s.gif" Cls="btn" >
                                            <Listeners>
                                                <Click Fn="Confirm"></Click>
                                            </Listeners>                                   
                                        </ext:ImageButton>
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                        </tr>
                    </table>
                    <%-- 숨겨 사용하기 ^^;;; --%>
                    <ext:TextField ID="txt01_ID" runat="server" Hidden="true" />
                </Content>
            </ext:Panel>

            <ext:Panel ID="ContentPanel" runat="server" Region="Center" Layout="BorderLayout">
                <Items>
                    <ext:Panel ID="ImagePanel" runat="server" Region="West" Width="224px" BorderSpec="border:1px solid #157fcc;" BodyStyle="overflow-y:auto;">
                        <Items>
                            <ext:Image ID="img01_PARTNO" Region="North" Width="222px" runat="server"><Listeners><Click Handler="ImageZoomPopup(this);"></Click></Listeners></ext:Image>
                            <ext:Panel ID="ImagePanel_MARGIN" runat="server" Region="North" Height="10">
                                <Items>  
                                </Items>
                            </ext:Panel>
                            <ext:Image ID="img01_STANDARD" Region="North" Width="222px" runat="server"><Listeners><Click Handler="ImageZoomPopup(this);"></Click></Listeners></ext:Image>                                                                                 
                        </Items>
                    </ext:Panel>

                    <ext:Panel ID="MarginPanel" runat="server" Region="West" Width="10px">
                        <Items>
                        </Items>
                    </ext:Panel>

                    <ext:Panel ID="GridPanel" Region="Center" Border="False" runat="server" >
                        <Items>
                            <ext:Panel ID="TopGridPanel"  Region="North" Border="False" runat="server" Height="205px">
                                <Items>
                                    <ext:Panel ID="TopGridTitlePanel"  Region="North" Border="False" runat="server" Height="25px">
                                        <Items>
                                            <ext:FieldContainer ID="FieldContainer2" runat="server" Width="260" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                                <Items>
                                                    <ext:Label ID="lbl01_INS_ITEM" runat="server" Cls="pop_t_03"/><%--Text="검사항목 (외관- 1 : OK, 0 : NG)"  --%>
                                                </Items>
                                            </ext:FieldContainer>
                                        </Items>
                                    </ext:Panel>

                                    <ext:Panel ID="TopGridCheckPanel"  Region="North" Border="False" runat="server" Height="25px">
                                        <Items>
                                            <ext:FieldContainer ID="CompositeField3" runat="server" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                                <Items>
                                                    <ext:Checkbox ID="chk01_ALL" runat="server" ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="전체"--%>
                                                    <ext:Checkbox ID="chk01_X1" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X1"  --%>
                                                    <ext:Checkbox ID="chk01_X2" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X2"  --%>
                                                    <ext:Checkbox ID="chk01_X3" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X3"  --%>
                                                    <ext:Checkbox ID="chk01_X4" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X4"  --%>
                                                    <ext:Checkbox ID="chk01_X5" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X5"  --%>
                                                    <ext:Checkbox ID="chk01_X6" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X6"  --%>
                                                    <ext:Checkbox ID="chk01_X7" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X7"  --%>
                                                    <ext:Checkbox ID="chk01_X8" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X8"  --%>
                                                    <ext:Checkbox ID="chk01_X9" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X9"  --%>
                                                    <ext:Checkbox ID="chk01_X10" runat="server" ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X10" --%>
                                                    <ext:Checkbox ID="chk01_X11" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X11"  --%>
                                                    <ext:Checkbox ID="chk01_X12" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X12"  --%>
                                                    <ext:Checkbox ID="chk01_X13" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X13"  --%>
                                                    <ext:Checkbox ID="chk01_X14" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X14"  --%>
                                                    <ext:Checkbox ID="chk01_X15" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X15"  --%>
                                                    <ext:Checkbox ID="chk01_X16" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X16"  --%>
                                                    <ext:Checkbox ID="chk01_X17" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X17"  --%>
                                                    <ext:Checkbox ID="chk01_X18" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X18"  --%>
                                                    <ext:Checkbox ID="chk01_X19" runat="server"  ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X19"  --%>
                                                    <ext:Checkbox ID="chk01_X20" runat="server" ><Listeners><Change Fn="CheckBoxChange"></Change></Listeners></ext:Checkbox><%--BoxLabel="X20" --%>
                                                </Items>
                                            </ext:FieldContainer>
                                        </Items>
                                    </ext:Panel>

                                    <ext:Panel ID="TopGridGridPanel"  Region="North" Border="True" runat="server" Height="155px" Cls="grid_area">
                                        <Items>
                                            <ext:GridPanel ID="Grid01" runat="server"  ColumnLines="true" StripeRows="true" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                                <Store>
                                                    <ext:Store ID="Store1" runat="server" PageSize="50">
                                                        <Model>
                                                            <ext:Model ID="Model1" runat="server">
                                                                <Fields>
                                                                    <ext:ModelField Name="CORCD" />
                                                                    <ext:ModelField Name="BIZCD" />
                                                                    <ext:ModelField Name="INSPECT_CLASSCD" />
                                                                    <ext:ModelField Name="INSPECT_SEQ" />
                                                                    <ext:ModelField Name="KIND" />
                                                                    <ext:ModelField Name="INSPECT_ITEMNM" />
                                                                    <ext:ModelField Name="CYCLENM" />
                                                                    <ext:ModelField Name="INSPECT_STD_MEAS" />
                                                                    <ext:ModelField Name="INSPECT_MIN_MEAS" />
                                                                    <ext:ModelField Name="INSPECT_MAX_MEAS" />
                                                                    <ext:ModelField Name="UNIT" />
                                                                    <ext:ModelField Name="MAND_INPUT_ITEM_YN" />
                                                                    <ext:ModelField Name="ISDEFAULT" />
                                                                    <ext:ModelField Name="INP_COUNT" />
                                                                    <ext:ModelField Name="X1" />
                                                                    <ext:ModelField Name="X2" />
                                                                    <ext:ModelField Name="X3" />
                                                                    <ext:ModelField Name="X4" />
                                                                    <ext:ModelField Name="X5" />
                                                                    <ext:ModelField Name="X6" />
                                                                    <ext:ModelField Name="X7" />
                                                                    <ext:ModelField Name="X8" />
                                                                    <ext:ModelField Name="X9" />
                                                                    <ext:ModelField Name="X10" />
                                                                    <ext:ModelField Name="X11" />
                                                                    <ext:ModelField Name="X12" />
                                                                    <ext:ModelField Name="X13" />
                                                                    <ext:ModelField Name="X14" />
                                                                    <ext:ModelField Name="X15" />
                                                                    <ext:ModelField Name="X16" />
                                                                    <ext:ModelField Name="X17" />
                                                                    <ext:ModelField Name="X18" />
                                                                    <ext:ModelField Name="X19" />
                                                                    <ext:ModelField Name="X20" />
                                                                    <ext:ModelField Name="JUD_RESULT" />
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
                                                    <%-- 2.X버전부터는 그리드에서 edtior를 활성화 시키기위해서 cellEditing Plugin을 추가 하여 사용하고 자바스크립트에서 grid.editingPlugin 형태로 사용할수 있다. --%>
                                                    <ext:CellEditing ID="CellEditing1" runat="server" ClicksToEdit="1" >
                                                        <Listeners>                                                                                               
                                                            <Edit fn ="AfterEdit" />                                                                                                
                                                        </Listeners> 
                                                    </ext:CellEditing>
                                                </Plugins>  
                                                <ColumnModel ID="ColumnModel1" runat="server">
                                                    <Columns>
                                                        <ext:Column ID ="NO" Text="NO" runat="server" MenuDisabled="true"  Width="40" Align="Center" >
                                                            <Renderer Fn="rendererNo"></Renderer>
                                                        </ext:Column>
                                                        <ext:Column ID="KIND"               runat="server" ItemID="DETAIL_NM"         DataIndex="KIND"             Width="60" Align="Center" />           <%--Text="분류"    --%>    
                                                        <ext:Column ID="INSPECT_ITEMNM"     runat="server" ItemID="INSPECT_ITEMNM"    DataIndex="INSPECT_ITEMNM"   fLEX="1" MinWidth="150" Align="Left" /><%--Text="검사항목"--%> 
                                                        <ext:Column ID="CYCLENM"            runat="server" ItemID="DIVISION"          DataIndex="CYCLENM"          Width="60" Align="Center" />           <%--Text="구분"    --%> 
                                                        <ext:Column ID="INSPECT_STD_MEAS"   runat="server" ItemID="INSPECT_STD_MEAS3" DataIndex="INSPECT_STD_MEAS" Width="60" Align="Center" />           <%--Text="SPEC"    --%> 
                                                        <ext:Column ID="INSPECT_MIN_MEAS"   runat="server" ItemID="INSPECT_MIN_MEAS3" DataIndex="INSPECT_MIN_MEAS" Width="60" Align="Center" />           <%--Text="하한"    --%> 
                                                        <ext:Column ID="INSPECT_MAX_MEAS"   runat="server" ItemID="INSPECT_MAX_MEAS3" DataIndex="INSPECT_MAX_MEAS" Width="60" Align="Center" />           <%--Text="상한"    --%> 
                                                        <ext:Column ID="X1" runat="server" ItemID="X1" DataIndex="X1" Width="30" Align="Center"><%--Text="X1" --%>
                                                            <Editor>
                                                                <ext:TextField ID="NumberField1" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X2" runat="server" ItemID="X2" DataIndex="X2" Width="30" Align="Center"><%--Text="X2" --%>               
                                                            <Editor>
                                                                <ext:TextField ID="NumberField2" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X3" runat="server" ItemID="X3" DataIndex="X3" Width="30" Align="Center"><%--Text="X3" --%>
                                                            <Editor>
                                                                <ext:TextField ID="NumberField3" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X4" runat="server" ItemID="X4" DataIndex="X4" Width="30" Align="Center"><%--Text="X4" --%>
                                                            <Editor>
                                                                <ext:TextField ID="NumberField4" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X5" runat="server" ItemID="X5" DataIndex="X5" Width="30" Align="Center"><%--Text="X5" --%>
                                                            <Editor>
                                                                <ext:TextField ID="NumberField5" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X6" runat="server" ItemID="X6" DataIndex="X6" Width="30" Align="Center"><%--Text="X6" --%>               
                                                            <Editor>
                                                                <ext:TextField ID="NumberField6" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X7" runat="server" ItemID="X7" DataIndex="X7" Width="30" Align="Center"><%--Text="X7" --%>               
                                                            <Editor>
                                                                <ext:TextField ID="NumberField7" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X8" runat="server" ItemID="X8" DataIndex="X8" Width="30" Align="Center"><%--Text="X8" --%>
                                                            <Editor>
                                                                <ext:TextField ID="NumberField8" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X9" runat="server" ItemID="X9" DataIndex="X9" Width="30" Align="Center"><%--Text="X9" --%>
                                                            <Editor>
                                                                <ext:TextField ID="NumberField9" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X10" runat="server" ItemID="X10" DataIndex="X10" Width="30" Align="Center" ><%--Text="X10" --%>
                                                            <Editor>
                                                                <ext:TextField ID="NumberField10" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X11" runat="server" ItemID="X11" DataIndex="X11" Width="30" Align="Center"><%--Text="X11" --%>
                                                            <Editor>
                                                                <ext:TextField ID="TextField1" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X12" runat="server" ItemID="X12" DataIndex="X12" Width="30" Align="Center"><%--Text="X12" --%>               
                                                            <Editor>
                                                                <ext:TextField ID="TextField2" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X13" runat="server" ItemID="X13" DataIndex="X13" Width="30" Align="Center"><%--Text="X13" --%>
                                                            <Editor>
                                                                <ext:TextField ID="TextField3" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X14" runat="server" ItemID="X14" DataIndex="X14" Width="30" Align="Center"><%--Text="X14" --%>
                                                            <Editor>
                                                                <ext:TextField ID="TextField4" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X15" runat="server" ItemID="X15" DataIndex="X15" Width="30" Align="Center"><%--Text="X15" --%>
                                                            <Editor>
                                                                <ext:TextField ID="TextField5" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X16" runat="server" ItemID="X16" DataIndex="X16" Width="30" Align="Center"><%--Text="X16" --%>               
                                                            <Editor>
                                                                <ext:TextField ID="TextField6" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X17" runat="server" ItemID="X17" DataIndex="X17" Width="30" Align="Center"><%--Text="X17" --%>               
                                                            <Editor>
                                                                <ext:TextField ID="TextField7" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X18" runat="server" ItemID="X18" DataIndex="X18" Width="30" Align="Center"><%--Text="X18" --%>
                                                            <Editor>
                                                                <ext:TextField ID="TextField8" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X19" runat="server" ItemID="X19" DataIndex="X19" Width="30" Align="Center"><%--Text="X19" --%>
                                                            <Editor>
                                                                <ext:TextField ID="TextField9" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="X20" runat="server" ItemID="X20" DataIndex="X20" Width="30" Align="Center" ><%--Text="X20" --%>
                                                            <Editor>
                                                                <ext:TextField ID="TextField10" Cls="inputText_Num" FieldCls="inputText_Num" runat="server" MaskRe="/[0-1]/" MaxLength="1"/>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ID="JUD_RESULT" runat="server" ItemID="JUDGEMENT" DataIndex="JUD_RESULT" Width="50" Align="Center" /><%--Text="판정" --%>
                                                    </Columns>
                                                </ColumnModel>
                                                <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                                                    <LoadMask ShowMask="true" />
                                                </Loader>
                                                <View>
                                                    <ext:GridView ID="GridView1" runat="server"  EnableTextSelection="true"/>
                                                </View>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel" Mode="Single" runat="server" />
                                                </SelectionModel>                                                
                                                <BottomBar>
                                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                                    <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..." />
                                                </BottomBar>
                                            </ext:GridPanel>
                                        </Items>
                                    </ext:Panel>
                                </Items>
                            </ext:Panel>
                            
                            <ext:Panel ID="BottomGridPanel"  Region="Center" Border="False" runat="server" >
                                <Items>
                                    <ext:Panel ID="BottomGridMarginPanel"  Region="North" Border="False" runat="server" Height="10px">
                                        <Items>                                            
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="BottomGridTitlePanel"  Region="North" Border="False" runat="server" Height="25px">
                                        <Items>
                                             <ext:Label ID="lbl01_IN_DEF_HIS" runat="server" Cls="pop_t_03"/><%--Text="입고품 불량 이력 현황"  --%>
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="BottomGridGridPanel"  Region="Center" Border="True" runat="server" Cls="grid_area">
                                        <Items>
                                            <ext:GridPanel ID="Grid02" runat="server"  ColumnLines="true" StripeRows="true" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                                <Store>
                                                    <ext:Store ID="Store2" runat="server" PageSize="50">
                                                        <Model>
                                                            <ext:Model ID="Model2" runat="server">
                                                                <Fields>
                                                                    <ext:ModelField Name="RCV_DATE" />
                                                                    <ext:ModelField Name="PARTNO" />
                                                                    <ext:ModelField Name="DEFNM" />
                                                                    <ext:ModelField Name="DEF_QTY" />
                                                                    <ext:ModelField Name="MGRT_NM" />
                                                                    <ext:ModelField Name="WORKER_NM" />
                                                                    <ext:ModelField Name="DEFNO" />
                                                                    <ext:ModelField Name="BIZCD" />
                                                                    <ext:ModelField Name="DEF_PHOTO" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                        <Listeners>
                                                            <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                                            <Load Delay="1" Handler="GridStoreReady(App.GridStatus2, this.getTotalCount());  "></Load>
                                                        </Listeners>
                                                    </ext:Store>
                                                </Store>
                                                <Plugins>
                                                    <ext:BufferedRenderer ID="BufferedRenderer2" runat="server"/>
                                                </Plugins>  
                                                <ColumnModel ID="ColumnModel2" runat="server">
                                                    <Columns>
                                                        <ext:RowNumbererColumn ID="RowNumbererColumn1" runat="server" Width="30" Text="No" Align="Center" />
                                                        <ext:DateColumn ID="RCV_DATE"  runat="server" ItemID="OCCUR_DATE" DataIndex="RCV_DATE"   Width="80" Align="Center" /><%--Text="발생일자" --%>
                                                        <ext:Column ID="PARTNO"    runat="server" ItemID="PARTNO"     DataIndex="PARTNO"     fLEX="1" MinWidth="120" Align="Left" />  <%--Text="품번"--%>     
                                                        <ext:Column ID="DEFNM"     runat="server" ItemID="DEF_CNTT"   DataIndex="DEFNM"      fLEX="1" MinWidth="150" Align="Center" /><%--Text="불량내용" --%>
                                                        <ext:Column ID="DEF_QTY"   runat="server" ItemID="DEF_QTY"    DataIndex="DEF_QTY"    Width="60" Align="Center" />             <%--Text="불량수량" --%>
                                                        <ext:Column ID="MGRT_NM"   runat="server" ItemID="MGRT_CNTT"  DataIndex="MGRT_NM"    fLEX="1" MinWidth="150" Align="Center" /><%--Text="조치내용"--%> 
                                                        <ext:Column ID="WORKER_NM" runat="server" ItemID="WORKER_NM"  DataIndex="WORKER_NM"  Width="70" Align="Center" />             <%--Text="검사자"--%>   
                                                        <ext:Column ID="DEF_PHOTO" runat="server" ItemID="DEF_PHOTO"  DataIndex="DEF_PHOTO"  Width="60" Align="Center" />             <%--Text="불량사진"--%> 
                                                    </Columns>
                                                </ColumnModel>
                                                <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                                    <LoadMask ShowMask="true" />
                                                </Loader>
                                                <View>
                                                    <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true"/>
                                                </View>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel1" Mode="Single" runat="server" />
                                                </SelectionModel>                                               
                                                <BottomBar>
                                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                                    <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..." />
                                                </BottomBar>
                                            </ext:GridPanel>
                                        </Items>
                                    </ext:Panel>
                                </Items>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>

                </Items>
            </ext:Panel>            

        </Items>
    </ext:Viewport>

    </form>
</body>
</html>
