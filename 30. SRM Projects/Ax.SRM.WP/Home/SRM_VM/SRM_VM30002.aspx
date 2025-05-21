<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_VM30002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_VM.SRM_VM30002" %>
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
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
    <style type="text/css">
        .bottom_area_title_name2 { clear:both;  margin-top:0px; height:20px; display:block; background:url(../../images/common/title_icon_s.gif) 0 8px no-repeat; padding-left:10px;font-size:12px;color:#010101;text-align:left;font-weight:bold;}
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.GridPanel.setHeight(App.Panel1.getHeight() - 30);
            App.Grid01.setHeight(App.GridPanel.getHeight());
            App.BottomGridPanel.setHeight(App.pnl01_FIN_GRP.getHeight() - 30);
            App.Grid02.setHeight(App.BottomGridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

            var userID = grid.getStore().getAt(rowIndex).data["VENDCD"];
            App.direct.Cell_DoubleClick(userID);
        }


        var CellClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {

            var grid = grid.ownerCt;

            var SRM2090_STD_YEAR = grid.getStore().getAt(rowIndex).data["SRM2090_STD_YEAR"];
            var SRM2100_STD_YEAR = grid.getStore().getAt(rowIndex).data["SRM2100_STD_YEAR"];
            var SRM2160_STD_YEAR = grid.getStore().getAt(rowIndex).data["SRM2160_STD_YEAR"];
            var vendcd = grid.getStore().getAt(rowIndex).data["VENDCD"];

            
            App.direct.Cell_DoubleClick(vendcd, SRM2090_STD_YEAR, SRM2100_STD_YEAR, SRM2160_STD_YEAR);
        }

    </script>
</head>
<body>
    <form id="SRM_VM30002" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="hidVENDCD" runat="server" Hidden="true" /> 
     <ext:TextField ID="hidASRM2090_STD_YEAR" runat="server" Hidden="true" />
     <ext:TextField ID="hidASRM2100_STD_YEAR" runat="server" Hidden="true" />
     <ext:TextField ID="hidASRM2160_STD_YEAR" runat="server" Hidden="true" />
     


    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_VM30002" runat="server" Cls="search_area_title_name" /><%--Text="업체정보 종합 조회" />--%>
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
                            <col style="width: 100px;" />
                            <col style="width: 300px;" />
                            <col style="width: 100px;" />
                            <col style="width: 250px;" />
                            <col style="width: 100px;" />
                            <col style="width: 250px;" />
                            <col style="width: 100px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>   
                            <th>
                                <ext:Label ID="lbl01_VENDNM" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_VENDNM" Width="150" Cls="inputText" runat="server" />      
                            </td>
                            <th>
                                <ext:Label ID="lbl01_SQ_CATEGORY" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_SQ_CATEGORY" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="200">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
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
                                <ext:Label ID="lbl01_VEND_CHASU" runat="server" /><%--Text="업체차수(HKMC기준)" />--%>
                            </th>  
                            <td>
                                <ext:SelectBox ID="cbo01_VEND_TIER" runat="server"  Mode="Local" ForceSelection="true" DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="100">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_NM" />
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
            <ext:Panel ID="Panel1" Region="Center" runat="server" StyleSpec="margin-bottom:10px;">
                <Items>
                    <ext:Label ID="lbl01_TIT_BASIC" runat="server" Cls="bottom_area_title_name2" Text="업체기본현황"/><%--Text="업체기본현황"--%>
                    <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area" >
                        <Items>                    
                            <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store1" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="GridModel1" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="UPDATE_DATE" />
                                                    <ext:ModelField Name="VENDCD" />
                                                    <ext:ModelField Name="VENDNM" />
                                                    <ext:ModelField Name="VAATZCD" />
                                                    <ext:ModelField Name="RESI_NO" />
                                                    <ext:ModelField Name="VEND_TIER" />  
                                                    <ext:ModelField Name="UP_VEND" />  
                                                    <ext:ModelField Name="UP_VENDNM" />  
                                                    <ext:ModelField Name="ADDR" />
                                                    <ext:ModelField Name="TEL" />
                                                    <ext:ModelField Name="EMP_COUNT" />
                                                    <ext:ModelField Name="REP_NAME" />
                                                    <ext:ModelField Name="PHOTO_YN" />
                                                    <ext:ModelField Name="UNIT" />
                                                    <ext:ModelField Name="AREA" />
                                                    <ext:ModelField Name="BUILDING" />
                                                    <ext:ModelField Name="FOUND_DATE" />
                                                    <ext:ModelField Name="SRM2050_CNT" /><%--품목정보등록수--%>
                                                    <ext:ModelField Name="SRM2160_CNT" /><%--SQ업종별 HKMC 1차사 거래현황 등록수--%>
                                                    <ext:ModelField Name="STD_YEAR" />
                                                    <ext:ModelField Name="SRM2100_CNT" /><%--주요공급업체 매입현황 등록수--%>
                                                    <ext:ModelField Name="MOLD_CNT" /><%--금형보유 합계 수량--%>
                                                    <ext:ModelField Name="SRM2130_CNT" /><%--주요설비현황(생산설비)등록수 --%>
                                                    <ext:ModelField Name="SRM2140_CNT" /><%--주요설비현황(실험및측정설비)등록수 --%>
                                                    <ext:ModelField Name="CREDIT_EVAL_FILE_YN" />
                                                    <ext:ModelField Name="CREDIT_EVAL_FILE" />
                                                    <ext:ModelField Name="INSERT_DATE" />
                                                    <ext:ModelField Name="SQ_CERTI_FILE_YN" />
                                                    <ext:ModelField Name="SQ_CERTI_FILE" />
                                                    <ext:ModelField Name="SRM2060_CNT" /><%--주주현황등록수--%>
                                                    <ext:ModelField Name="SHAREHOLDER1" />
                                                    <ext:ModelField Name="SHARE_RATE1" />
                                                   
                                                    <ext:ModelField Name="SQ_CATEGORY1" />
                                                    <ext:ModelField Name="SQ_YN" />
                                                    <ext:ModelField Name="SQ_GRADE1" />
                                                    <ext:ModelField Name="MAIN_CHARGE1" />  
                                                    <ext:ModelField Name="SQ_CATEGORY2" />
                                                    <ext:ModelField Name="SQ_YN2" />
                                                    <ext:ModelField Name="SQ_GRADE2" />
                                                    <ext:ModelField Name="MAIN_CHARGE2" />  
                                                    <ext:ModelField Name="SQ_CATEGORY3" />
                                                    <ext:ModelField Name="SQ_YN3" />
                                                    <ext:ModelField Name="SQ_GRADE3" />
                                                    <ext:ModelField Name="MAIN_CHARGE3" />  

                                                    <ext:ModelField Name="ASSETS" />
                                                    <ext:ModelField Name="DEBT" />
                                                    <ext:ModelField Name="QUITY" />
                                                    <ext:ModelField Name="TOTAL_SALES" />
                                                    <ext:ModelField Name="BUSINESS_PROFITS" />
                                                    <ext:ModelField Name="PERSON_SALES" />
                                                    <ext:ModelField Name="HKMC_TRADE_RATE" />        
                                                                                                
                                                    <ext:ModelField Name="CHECK_VALUE" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>
                                                    <ext:ModelField Name="CHECK_VALUE2" DefaultValue="false" Type="Boolean" /> <%--선택체크박스--%>                                          
                                                    
                                                    <ext:ModelField Name="SRM2090_STD_YEAR" />
                                                    <ext:ModelField Name="SRM2100_STD_YEAR" />
                                                    <ext:ModelField Name="SRM2160_STD_YEAR" />       

                                                    
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
                                        <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                        <ext:DateColumn ID="UPDATE_DATE" ItemID="FNLUPDATEDT" runat="server" DataIndex="UPDATE_DATE" Width="80" Align="Center" /><%--Text="최종수정일"--%>
                                        <ext:Column ID="VENDCD" ItemID="T1_VENDCD" runat="server" DataIndex="VENDCD" Width="80" Align="Center" /><%--Text="업체코드"--%>
                                        <ext:Column ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="180" Align="Left" /><%--Text="업체명"--%>
                                        <ext:Column ID="VAATZCD" ItemID="VAATZCD" runat="server" DataIndex="VAATZCD" Width="70" Align="Center" /><%--Text="바츠코드"--%>
                                        <ext:Column ID="RESI_NO" ItemID="CMPNO" runat="server" DataIndex="RESI_NO" Width="120" Align="Center" /><%--Text="사업자등록번호"--%>
                                        <ext:Column ID="VEND_CHASU" ItemID="VEND_CHASU" runat="server" DataIndex="VEND_TIER" Width="130" Align="Center" /><%--Text="업체차수"--%>
                                        <ext:Column ID="UP_VENDNM" ItemID="UP_VENDNM" runat="server" DataIndex="UP_VENDNM" Width="120" Align="Left" /><%--Text="상위업체"--%>
                                        <ext:Column ID="ADDR" ItemID="ADDR" runat="server" DataIndex="ADDR" Width="180" Align="Left" /><%--Text="주소"--%>
                                        <ext:Column ID="TEL" ItemID="TEL" runat="server" DataIndex="TEL" Width="120" Align="Center" /><%--Text="전화번호"--%>
                                        <ext:NumberColumn ID="EMP_COUNT" ItemID="EMP_COUNT2" runat="server" DataIndex="EMP_COUNT" Width="100" Align="Right" Format="#,##0"/><%--Text="종업원수(합계)"--%>
                                        <ext:Column ID="REP_NAME" ItemID="REPRESENM" runat="server" DataIndex="REP_NAME" Width="100" Align="Left" /><%--Text="대표자성명"--%>
                                        <ext:Column ID="PHOTO_YN" ItemID="PHOTO_YN2" runat="server" DataIndex="PHOTO_YN" Width="80" Align="Center" /><%--Text="대표자(사진)"--%>
                                        <ext:Column ID="UNIT" ItemID="UNIT" runat="server" DataIndex="UNIT" Width="70" Align="Left"/><%--Text="단위"--%>  
                                        <ext:NumberColumn ID="AREA" ItemID="AREA2" runat="server" DataIndex="AREA" Width="80" Align="Right" Format="#,##0"/><%--Text="대지(평)"--%>  
                                        <ext:NumberColumn ID="BUILDING" ItemID="BUILDING2" runat="server" DataIndex="BUILDING" Width="80" Align="Right" Format="#,##0"/><%--Text="건물(평)"--%>
                                        <ext:DateColumn ID="FOUND_DATE" ItemID="FOUND_DATE" runat="server" DataIndex="FOUND_DATE" Width="80" Align="Center" /><%--Text="개업년월일"--%>  
                                        <ext:NumberColumn ID="SRM2050_CNT" ItemID="SRM2050_CNT" runat="server" DataIndex="SRM2050_CNT" Width="100" Align="Right" Format="#,##0"/><%--Text="품목정보등록수">--%>
                                        <ext:NumberColumn ID="SRM2160_CNT" ItemID="SRM2160_CNT" runat="server" DataIndex="SRM2160_CNT" Width="100" Align="Right" Format="#,##0"/><%--Text="SQ업종별 HKMC 1차사 거래현황 등록수">SRM2160_CNT--%>
                                        <ext:Column ID="TIT_FIN2" ItemID="TIT_FIN2" runat="server" DataIndex="STD_YEAR" Width="70" Align="Center"/><%--Text="재무제표현황" TIT_FIN2>--%>
                                        <ext:NumberColumn ID="SRM2100_CNT" ItemID="SRM2100_CNT" runat="server" DataIndex="SRM2100_CNT" Width="100" Align="Right" Format="#,##0"/><%--Text="주요공급업체 매입현황 등록수">SRM2100_CNT--%>
                                        <ext:NumberColumn ID="MOLD_CNT" ItemID="MOLD_CNT" runat="server" DataIndex="MOLD_CNT" Width="100" Align="Right" Format="#,##0"/><%--Text="서연이화 금형보유현황">MOLD_CNT--%>
                                        <ext:NumberColumn ID="SRM2130_CNT" ItemID="SRM2130_CNT" runat="server" DataIndex="SRM2130_CNT" Width="100" Align="Right" Format="#,##0"/><%--Text="주요설비현황(생산설비)등록수"SRM2130_CNT>--%>
                                        <ext:NumberColumn ID="SRM2140_CNT" ItemID="SRM2140_CNT" runat="server" DataIndex="SRM2140_CNT" Width="100" Align="Right" Format="#,##0"/><%--Text="주요장비현황(실험및측정설비)등록수SRM2140_CNT">--%>


                                        <%--Text="신용평가서">--%>
                                        <ext:Column ID="CREDIT_EVAL" ItemID="CREDIT_EVAL" runat="server" >
                                            <Columns>
                                                <ext:Column ID="CREDIT_EVAL_FILE_YN" ItemID="ATTACHMENT" runat="server" DataIndex="CREDIT_EVAL_FILE_YN" Width="40" Align="Center" Sortable="true" /><%--Text="첨부"--%>
                                                <ext:DateColumn ID="INSERT_DATE" ItemID="REG_DATE" runat="server" DataIndex="INSERT_DATE" Width="80" Align="Center" Sortable="true" /><%--Text="등록일"--%> 
                                                <ext:CheckColumn runat="server" ID ="CHECK" itemID="CHK" DataIndex="CHECK_VALUE" Width="35" 
                                                    StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true" Sortable="false" Editable="true"/>  
                                            </Columns>
                                        </ext:Column>
                                        <%--Text="SQ인증서">--%>
                                        <ext:Column ID="SQ_CERTI" ItemID="SQ_CERTI" runat="server" >
                                            <Columns>
                                                <ext:Column ID="SQ_CERTI_FILE_YN" ItemID="ATTACHMENT2" runat="server" DataIndex="SQ_CERTI_FILE_YN" Width="70" Align="Center" /><%--Text="첨부"--%>
                                                <ext:CheckColumn runat="server" ID ="CHECK2" itemID="SEL_CHK" DataIndex="CHECK_VALUE2" Width="35" 
                                                    StopSelection="false" MenuDisabled="true" Resizable="false" Selectable="true" Sortable="false" Editable="true"/>   
                                            </Columns>
                                        </ext:Column>      
                                                                  
                                        <%--Text="주주현황등록수">--%>
                                        <ext:NumberColumn ID="SRM2060_CNT" ItemID="SRM2060_CNT" runat="server" DataIndex="SRM2060_CNT" Width="100" Align="Right" Format="#,##0"/>
                                        <ext:Column ID="SHAREHOLDER1" ItemID="STOCK1" runat="server" DataIndex="SHAREHOLDER1" Width="70" Align="Left"/><%--Text="대주주1"--%>  
                                        <ext:NumberColumn ID="SHARE_RATE1" ItemID="STOCK_RATE2" runat="server" DataIndex="SHARE_RATE1" Width="110" Align="Right" Format="#,##0"/><%--Text="대주주1(지분율)"--%>  
                                        
                                        <%--Text="SQ마크인증1">--%>                                        
                                        <ext:Column ID="TIT_SQ" ItemID="TIT_SQ" runat="server" ><%--Text="SQ마크인증">--%>
                                            <Columns>
                                                <ext:Column ID="SQ_CATEGORY1" ItemID="COND_TYPE" runat="server" DataIndex="SQ_CATEGORY1" Width="70" Align="Center"/><%--Text="업종"--%>
                                                <ext:Column ID="SQ_GRADE1" ItemID="GRADE2" runat="server" DataIndex="SQ_GRADE1" Width="50" Align="Center" Sortable="true"/><%--Text="등급"--%>
                                                <ext:Column ID="SQ_YN" ItemID="SQ_YN" runat="server" DataIndex="SQ_YN" Width="70" Align="Center" Sortable="true"/><%--Text="인증구분"--%>
                                                <ext:Column ID="MAIN_CHARGE1" ItemID="MAIN_CHARGE" runat="server" DataIndex="MAIN_CHARGE1" Width="140" Align="Left" Sortable="true"/><%--Text="주관장사"--%>
                                            </Columns>
                                        </ext:Column>

                                        <%--Text="SQ마크인증2">--%>                                        
                                        <ext:Column ID="TIT_SQ2" ItemID="TIT_SQ2" runat="server" ><%--Text="SQ마크인증">--%>
                                            <Columns>
                                                <ext:Column ID="SQ_CATEGORY2" ItemID="SQ_CATEGORY2" runat="server" DataIndex="SQ_CATEGORY2" Width="70" Align="Center"/><%--Text="업종"--%>
                                                <ext:Column ID="SQ_GRADE2" ItemID="GRADE_2" runat="server" DataIndex="SQ_GRADE2" Width="50" Align="Center" Sortable="true"/><%--Text="등급"--%>
                                                <ext:Column ID="SQ_YN2" ItemID="SQ_YN2" runat="server" DataIndex="SQ_YN2" Width="70" Align="Center" Sortable="true"/><%--Text="인증구분"--%>
                                                <ext:Column ID="MAIN_CHARGE2" ItemID="MAIN_CHARGE2" runat="server" DataIndex="MAIN_CHARGE2" Width="140" Align="Left" Sortable="true"/><%--Text="주관장사"--%>
                                            </Columns>
                                        </ext:Column>

                                        <%--Text="SQ마크인증3">--%>                                        
                                        <ext:Column ID="TIT_SQ3" ItemID="TIT_SQ3" runat="server" ><%--Text="SQ마크인증">--%>
                                            <Columns>
                                                <ext:Column ID="SQ_CATEGORY3" ItemID="SQ_CATEGORY3" runat="server" DataIndex="SQ_CATEGORY3" Width="70" Align="Center"/><%--Text="업종"--%>
                                                <ext:Column ID="SQ_GRADE3" ItemID="GRADE_3" runat="server" DataIndex="SQ_GRADE3" Width="50" Align="Center" Sortable="true"/><%--Text="등급"--%>
                                                <ext:Column ID="SQ_YN3" ItemID="SQ_YN3" runat="server" DataIndex="SQ_YN3" Width="70" Align="Center" Sortable="true"/><%--Text="인증구분"--%>
                                                <ext:Column ID="MAIN_CHARGE3" ItemID="MAIN_CHARGE3" runat="server" DataIndex="MAIN_CHARGE3" Width="140" Align="Left" Sortable="true"/><%--Text="주관장사"--%>
                                            </Columns>
                                        </ext:Column>
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
                                <Listeners>
                                       <%-- <CellDblClick Fn ="CellDbClick"></CellDblClick>--%>
                                        <CellClick Fn="CellClick"></CellClick>
                                </Listeners>                     
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                </BottomBar>
                            </ext:GridPanel>
                        </Items>
                    </ext:Panel>  
                </Items>
            </ext:Panel>
            <ext:Panel ID="pnl01_FIN_GRP" Region="South" runat="server" Height="250">
                <Items>
                    <ext:Panel ID="ButtonPanel05" runat="server" Region="North" Height="23" Hidden="false" >
                        <Items> 
                            <ext:Panel ID="Panel15" runat="server" StyleSpec="margin-right:10px; float:left;" Width="150" Hidden="false">
                                <Items>
                                    <ext:Label ID="lbl01_TIT_FIN" runat="server" Cls="bottom_area_title_name2" Text="재무제표현황"/><%--Text="재무제표현황"--%>
                                </Items>
                            </ext:Panel>
                            <ext:Panel ID="Panel16" runat="server" Width="108" Height="26px"  Hidden="false" Cls="bottom_area_btn" >
                                <Items>
                                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_exceldl.gif" Cls="pr5" ID="ButtonExcel" StyleSpec="margin-bottom:5px;">
                                        <DirectEvents>
                                            <Click OnEvent="etc_Button_Click" IsUpload="true" >
                                                <ExtraParams>
                                                    <ext:Parameter Name="Values" Value="App.Grid02.getRowsValues(false)" Mode="Raw" Encode="true" />
                                                </ExtraParams>
                                            </Click>
                                        </DirectEvents>
                                    </ext:ImageButton>
                                   
                                </Items>
                            </ext:Panel>      
                        </Items> 
                    </ext:Panel>
                    <ext:Panel ID="BottomGridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                        <Items>                     
                            <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store2" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="Model1" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="VENDCD" />
                                                    <ext:ModelField Name="STD_YEAR" />
                                                    <ext:ModelField Name="ASSETS" />
                                                    <ext:ModelField Name="DEBT" />
                                                    <ext:ModelField Name="QUITY" />
                                                    <ext:ModelField Name="TOTAL_SALES" />
                                                    <ext:ModelField Name="BUSINESS_PROFITS" />
                                                    <ext:ModelField Name="PERSON_SALES" />
                                                    <ext:ModelField Name="HKMC_TRADE_RATE" />    
                                                    <ext:ModelField Name="BIZ_PROFITS_RATE" />                                       
                                                    <ext:ModelField Name="DEBT_RATE" />                                       
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
                                    <ext:BufferedRenderer ID="BufferedRenderer2"  runat="server"/>
                                </Plugins>  
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:RowNumbererColumn ID="RowNumbererColumn1" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                        <ext:Column ID="Column13" ItemID="STD_YEAR" runat="server" DataIndex="STD_YEAR" Width="100" Align="Center"/><%--Text="재무년도"--%> 
                                        <ext:NumberColumn ID="NumberColumn5" ItemID="ASSETS" runat="server" DataIndex="ASSETS" Width="160" Align="Right" Format="#,##0"/><%--Text="자산(원)"--%> 
                                        <ext:NumberColumn ID="NumberColumn6" ItemID="DEBT2" runat="server" DataIndex="DEBT" Width="160" Align="Right" Format="#,##0"/><%--Text="부채(원)"--%>
                                        <ext:NumberColumn ID="NumberColumn7" ItemID="QUITY" runat="server" DataIndex="QUITY" Width="160" Align="Right" Format="#,##0"/><%--Text="자기자본(원)"--%>
                                        <ext:NumberColumn ID="NumberColumn8" ItemID="TOTAL_SALES" runat="server" DataIndex="TOTAL_SALES" Width="160" Align="Right" Format="#,##0"/><%--Text="매출액(원)"--%>
                                        <ext:NumberColumn ID="NumberColumn9" ItemID="BUSINESS_PROFITS" runat="server" DataIndex="BUSINESS_PROFITS" Width="160" Align="Right" Format="#,##0"/><%--Text="영업이익(원)"--%>
                                        <ext:NumberColumn ID="NumberColumn10" ItemID="PERSON_SALES2" runat="server" DataIndex="PERSON_SALES" Width="160" Align="Right" Format="#,##0"/><%--Text="인당매출(원)"--%>
                                        <ext:NumberColumn ID="NumberColumn1" ItemID="BIZ_PROFITS_RATE" runat="server" DataIndex="BIZ_PROFITS_RATE" Width="160" Align="Right" Format="#,##0.00"/><%--Text="영업이익률(%)"--%>
                                        <ext:NumberColumn ID="NumberColumn2" ItemID="DEBT_RATE" runat="server" DataIndex="DEBT_RATE" Width="160" Align="Right" Format="#,##0.00"/><%--Text="부채비율(%)"--%>
                                        <ext:NumberColumn ID="NumberColumn11" ItemID="HKMC_TRADE_RATE" runat="server" DataIndex="HKMC_TRADE_RATE" Width="110" Align="Right" Format="#,##0"/><%--Text="HKMC거래비율(%)"--%>                     
                                
                                    </Columns>
                                </ColumnModel>
                                <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                    <LoadMask ShowMask="true" />
                                </Loader>
                                <View>
                                    <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true"/>
                                </View>
                                <SelectionModel>                            
                                    <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"/>
                                </SelectionModel>                       
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                </BottomBar>
                            </ext:GridPanel>   
                        </Items>
                    </ext:Panel>             
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
