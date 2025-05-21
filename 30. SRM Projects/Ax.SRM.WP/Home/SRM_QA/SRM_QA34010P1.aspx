<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA34010P1.aspx.cs" Inherits="Ax.EP.WP.Home.SRM_QA.SRM_QA34010P1" %>
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

    <title>열람사유입력 팝업</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
           App.btn01_SAVE.disable();
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }
        
        //동의 체크박스 체크한 경우에만 저장 버튼 활성화
        var AgreeChange = function () {
            var btn = Ext.getCmp("btn01_SAVE");

            if (App.chk01_AGREE.checked) {
                btn.enable();
                btn.setImageUrl("/images/btn/btn_save.gif");
            }
            else {

                btn.setImageUrl("/images/btn/btn_save_h.gif");
                btn.disable();

            }

        }

        //스펙 열람 확인 메시지
        var isConfirm = function () {
            var langset = App.hiddenLANG_SET.getValue();
            var caption = "";
            var msg = "";

            if (langset == "KO") {
                caption = "확인";
                msg = "스펙을 열람 하시겠습니까?";
            }
            else {
                caption = "confirm";
                msg = "Do you want to view the pdf file?";
            }

            Ext.Msg.confirm(caption, msg, function (btn) {

                if (btn == 'yes') {
                    // FIRE click DIRECT EVENT OF BUTTON
                    App.direct.etc_Button_Click();
                }
            });
        }
    </script>
    <style type="text/css">
        .search_area_table table th 
        {
            height:27px;
        }
        .search_area_table table td {border-bottom:0px;color:#000;vertical-align:middle;vertical-align:top;padding:3px 0 0 2px;}
        .search_area_table div > div > table  {border-bottom:0px;}
    </style>
</head>
<body>
    <form id="SRM_QA34010P1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="txt01_FILEID" runat="server" Hidden="true" />
    <ext:TextField ID="txt01_DOCNO" runat="server" Hidden="true" />
    <ext:TextField ID="hiddenLANG_SET" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_ID" runat="server" Hidden="true" />

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_QA34010P1" runat="server" Cls="search_area_title_name" /> <%--Text="열람 사유 입력" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server" StyleSpec="width:100%" Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>            
            <ext:Panel ID="ContentPanel1" runat="server" Cls="search_area_table" Region="Center" >
                <Content>
                    <table style="height:0px;" border="0px"/>
                        <tr height="35px">
                            <td align="left" style="padding:10px 0 0 2px; width:330px;">
                                <ext:Label ID="lbl01_QA34010_MSG1" runat="server" /><%--Text="본 스펙을 동의 없이 배포하지 않을 것임을 서약합니다." />--%>    
                            </td>
                            <td style="padding:10px 0 0 2px;">
                                <ext:Checkbox ID="chk01_AGREE" runat="server" >
                                    <Listeners>
                                        <Change Fn="AgreeChange" />
                                    </Listeners>
                                </ext:Checkbox>        <%--Text="동의" />--%>                   
                            </td> 
                        </tr>
                       
                        <tr>
                            <td align="left" colspan="2"><ext:Label ID="lbl01_INPUT_REASON" runat="server" /><%--Text="◈ 열람 사유 입력" />--%></td>
                        </tr>
                        <tr>
                            <td align="left" colspan="2"><ext:TextField ID="txt01_ACCESS_REASON"  runat="server" Width="350" Cls="inputText" /></td>
                        </tr>
                        <tr height="35px">
                            <td align="left" colspan="2" style="color:Red;">
                                <ext:Label ID="lbl01_QA34010_MSG2" runat="server"/><%--Text="※사유가 불분명할 경우 예고없이 스펙조회가 차단될 수 있습니다." />--%>
                            </td> 
                        </tr>
                        <tr>
                            
                            <td align="right" colspan="2">
                                <table style="width:380px;">
                                    <tr>
                                        <td style="width:230px;"></td>
                                        <td style="width:75px;"><ext:ImageButton ID="btn01_SAVE"  runat="server" ImageUrl="../../images/btn/btn_save_h.gif">                                   
                                                <Listeners>
                                                    <Click Handler="isConfirm();"></Click>
                                                </Listeners>   
                                            </ext:ImageButton></td>
                                        <td style="width:75px;"><ext:ImageButton ID="btn01_CLOSE" runat="server" ImageUrl="../../images/btn/btn_close.gif">                                   
                                                <DirectEvents>
                                                    <Click OnEvent="Close_Button_Click" />
                                                </DirectEvents>
                                            </ext:ImageButton>
                                        </td>                                      
                                    </tr>
                                </table>                                
                            </td> 
                        </tr>
                    </table>                   
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
