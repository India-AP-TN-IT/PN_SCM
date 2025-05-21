<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP30004.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MP.SRM_MP30004" %>
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

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }
             
    </script>
</head>
<body>
    <form id="SRM_MP30004" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MP30004" runat="server" Cls="search_area_title_name"/>
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
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <tr>
							<th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server"/>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>    
                            <th class="ess">
                                <ext:Label ID="lbl01_SAUP" runat="server"/>
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
                                </ext:SelectBox>
                            </td>
                            <th> 
                                <ext:Label ID="lbl01_MRO_PO_TYPE" runat="server"/>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_MRO_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
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
                        </tr> 
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_QUT_DATE_MP30004" runat="server" Text="견적작성일" />
                            </th>
                            <td>
                                <ext:DateField ID="df01_QUT_DATE" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />                                
                            </td>
                            <th>
                                <ext:Label ID="lbl01_VAN_PROCESS_TYPE_MP30004" runat="server" Text="견적상태" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_QUT_CODE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
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
                            <td></td>
                            <td></td>
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
                                            <ext:ModelField Name="MRO_PO_TYPE"/>
                                            <ext:ModelField Name="VAN_PROCESS_TYPE"/>
                                            <ext:ModelField Name="PONO"/>
                                            <ext:ModelField Name="ROWNO"/>
                                            <ext:ModelField Name="PARTNM"/>
                                            <ext:ModelField Name="STANDARD"/>
                                            <ext:ModelField Name="MAKER"/>
                                            <ext:ModelField Name="UNIT"/>
                                            <ext:ModelField Name="QUOT_QTY"/>
                                            <ext:ModelField Name="QUOT_UCOST"/>
                                            <ext:ModelField Name="QUOTATION_DATE" />
                                            <ext:ModelField Name="QUWT_DATE" />
                                            <ext:ModelField Name="QUSM_DATE"/>
                                            <ext:ModelField Name="OK_DATE" />
                                            <ext:ModelField Name="QUOT_CNT"/>
                                            <ext:ModelField Name="REQT_DATE"/>
                                            <ext:ModelField Name="MGRT_NAME"/>
                                            <ext:ModelField Name="MGRT_TELNO"/>
                                            <ext:ModelField Name="DELI_DATE" />
                                            <ext:ModelField Name="ATT_FILENM"/>
                                            <ext:ModelField Name="REMARK"/>
                                            <ext:ModelField Name="QU_PARTNM"/>
                                            <ext:ModelField Name="QU_STANDARD"/>
                                            <ext:ModelField Name="QU_MAKER"/>
                                            <ext:ModelField Name="REQT_UNIT"/>
                                            <ext:ModelField Name="REQT_QTY"/>

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
                                <ext:RowNumbererColumn ID="NO"            ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center" />
                                <ext:Column ID="MRO_PO_TYPE"         ItemID="MRO_PO_TYPE"         runat="server" DataIndex="MRO_PO_TYPE" Width="100" Align="Left" />                   <%--Text="일반구매유형" --%>
                                <ext:Column ID="VAN_PROCESS_TYPE" ItemID="VAN_PROCESS_TYPE_MP30004" runat="server" DataIndex="VAN_PROCESS_TYPE" Width="80" Align="Center" />            <%--Text="견적상태"   --%>
                                <ext:Column ID="PONO"             ItemID="PONO_MP30004"             runat="server" DataIndex="PONO" Width="80" Align="Center" />                        <%--Text="의뢰번호"   --%>
                                <ext:Column ID="ROWNO"            ItemID="ROWNO_MP30004"            runat="server" DataIndex="ROWNO" Width="60" Align="Center" />                       <%--Text="순번"       --%>
                                <ext:Column ID="PARTNM"           ItemID="PARTNM_MP30004"           runat="server" DataIndex="PARTNM" MinWidth="250" Align="Left" Flex="1" />           <%--Text="품명"       --%>
                                <ext:Column ID="MAKER"            ItemID="MAKER_MP30004"            runat="server" DataIndex="MAKER" Width="80" Align="Left" />                         <%--Text="MAKER"      --%>
                                <ext:Column ID="UNIT"             ItemID="UNIT_MP30004"             runat="server" DataIndex="UNIT" Width="60" Align="Center" />                        <%--Text="단위"       --%>
                                <ext:NumberColumn ID="QUOT_QTY"   ItemID="QUOT_QTY_MP30004"         runat="server" DataIndex="QUOT_QTY" Width="80" Align="Right" Format="#,##0" />      <%--Text="발주수량"   --%>
                                <ext:NumberColumn ID="QUOT_UCOST" ItemID="QUOT_UCOST_MP30004"       runat="server" DataIndex="QUOT_UCOST" Width="80" Align="Right" Format="#,##0" />    <%--Text="견적단가"   --%>
                                <ext:DateColumn ID="QUOTATION_DATE"   ItemID="QUOTATION_DATE_MP30004"   runat="server" DataIndex="QUOTATION_DATE" Width="80" Align="Center" />              <%--Text="견적의뢰일" --%>
                                <ext:DateColumn ID="QUWT_DATE"        ItemID="QUWT_DATE_MP30004"        runat="server" DataIndex="QUWT_DATE" Width="80" Align="Center" />                   <%--Text="견적작성일" --%>
                                <ext:DateColumn ID="QUSM_DATE"        ItemID="QUSM_DATE_MP30004"        runat="server" DataIndex="QUSM_DATE" Width="80" Align="Center" />                   <%--Text="견적제출일" --%>
                                <ext:DateColumn ID="OK_DATE"          ItemID="OK_DATE_MP30004"          runat="server" DataIndex="OK_DATE" Width="80" Align="Center" />                     <%--Text="견적승인일" --%>
                                <ext:Column ID="QUOT_CNT"         ItemID="QUOT_CNT_MP30004"         runat="server" DataIndex="QUOT_CNT" Width="80" Align="Right" />                     <%--Text="견적차수"   --%>
                                <ext:DateColumn ID="REQT_DATE"        ItemID="REQT_DATE_MP30004"        runat="server" DataIndex="REQT_DATE" Width="80" Align="Center" />                   <%--Text="납기요청일" --%>
                                <ext:Column ID="MGRT_NAME"        ItemID="MGRT_NAME_MP30004"        runat="server" DataIndex="MGRT_NAME" Width="80" Align="Center" />                   <%--Text="청구자"     --%>
                                <ext:Column ID="MGRT_TELNO"       ItemID="MGRT_TELNO_MP30004"       runat="server" DataIndex="MGRT_TELNO" Width="80" Align="Center" />                  <%--Text="전화번호"   --%>
                                <ext:DateColumn ID="DELI_DATE"        ItemID="DELI_DATE_MP30004"        runat="server" DataIndex="DELI_DATE" Width="80" Align="Center" />                   <%--Text="납기가능일" --%>
                                <ext:Column ID="ATT_FILENM"       ItemID="ATT_FILENM_MP30004"       runat="server" DataIndex="ATT_FILENM" Width="80" Align="Center" />                  <%--Text="상세견적첨부"--%>
                                <ext:Column ID="REMARK"           ItemID="REMARK_MP30004"           runat="server" DataIndex="REMARK" MinWidth="80" Align="Left" Flex="1" />            <%--Text="비고"       --%>
                                <ext:Column ID="QU_PARTNM"        ItemID="QU_PARTNM_MP30004"        runat="server" DataIndex="QU_PARTNM" Width="180" Align="Left" />                    <%--Text="의뢰품명"   --%>
                                <ext:Column ID="QU_MAKER"         ItemID="QU_MAKER_MP30004"         runat="server" DataIndex="QU_MAKER" Width="80" Align="Left" />                      <%--Text="의뢰MAKER"  --%>
                                <ext:Column ID="REQT_UNIT"        ItemID="REQT_UNIT_MP30004"        runat="server" DataIndex="REQT_UNIT" Width="80" Align="Center" />                   <%--Text="의뢰단위"   --%>
                                <ext:NumberColumn ID="REQT_QTY"   ItemID="REQT_QTY_MP30004"         runat="server" DataIndex="REQT_QTY" Width="80" Align="Right" Format="#,##0" />      <%--Text="의뢰수량"   --%>
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

            <%--그리드와 내용사이에 하단 버튼영역이 필요할경우 아래 패널 사용(Hidden = "false") --%>
            <ext:Panel ID="BottomButtonPanel" runat="server" Region="South" Height="23" Cls="bottom_area_btn" Hidden="true">
                <Items>
                    <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5" ID="btnRowAdd"></ext:ImageButton>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_deleterow.gif" ID="btnRowDelete"></ext:ImageButton>
                </Items>
            </ext:Panel>            
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
