<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EPMainChart.aspx.cs" Inherits="Ax.EP.WP.Home.EPBase.EPMainChart" %>
<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>
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

    <title>Chart Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        //프린트
        var NewChart = function (user_id, success, errorMsg, getValues) {
            parent.App.direct.NewChartImage(getValues[0], getValues[1], getValues[2], getValues[3]);
            //parent.newChartPop(getValues[0], getValues[1], getValues[2], getValues[3]);

        }
        var NewWindChart = function (size_width, size_height, position_width, position_height) {
            var LeftPosition = (screen.width) ? (screen.width - size_width) / 2 : 0;
            var TopPosition = (screen.height) ? (screen.height - size_height) / 2 : 0
            wint1 = window.open('EPMainChart.aspx?BizName=' + document.getElementById('TextFieldTitle').value
                                                                      + '&BizCode=' + +document.getElementById('TextFieldCode').value
                                                                      + '&type=' + +document.getElementById('TextFieldType').value
                                                                      + '&index=' + +document.getElementById('TextFieldIndex').value
                                 , 'chk_'
                                 , 'menubar=no,width=' + size_width + ',height=' + size_height + ',left=' + LeftPosition + ',top=' + TopPosition + ',toolbar=no');
            wint1.opener = self;
        }


        function UI_Shown() {

        }

    </script>    
</head>
<body leftmargin="0" topmargin="5" rightmargin="0" bottommargin="0" onclick="NewWindChart('500','450','10','200');" >
    <form id="form1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server"><Listeners><DocumentReady Handler="ExtDocumentReady();" /></Listeners></ext:ResourceManager>
    <div align="center" >
        <asp:Chart ID="ChartAll" runat="server" width="367" Height="210" 
            > 
            <Series> 
                    <asp:Series  Font="Microsoft Sans Serif, 8pt"
                        Name="SeriesBizName" 
                        XValueMember="BizName" 
                        YValueMembers="BizRatio" 
                        IsVisibleInLegend="true"  Color="DodgerBlue" BorderColor="Black"> 
                </asp:Series> 
            </Series> 
            <Chartareas> 
                <asp:ChartArea
                    BorderColor="64, 64, 64, 64" 
                    BackSecondaryColor="Transparent" BackColor="Transparent" 
                    ShadowColor="Transparent" BorderWidth="0"
                        Name="ChartAreaRatio"
                        Area3DStyle-Enable3D="true" Visible="True" BackImageAlignment="TopLeft" Area3DStyle-Perspective="0" Area3DStyle-PointDepth="100"> 
                    <Axisy LineColor="64, 64, 64, 64" Interval="10">
                        <LabelStyle Font="Microsoft Sans Serif" />
                        <MajorGrid LineColor="64, 64, 64, 64" />
                            <MajorGrid Enabled="true" />
	                </Axisy>
	                <Axisx LineColor="64, 64, 64, 64" Interval="1" IsInterlaced="False">
	                    <LabelStyle Font="Microsoft Sans Serif" />
	                    <MajorGrid LineColor="64, 64, 64, 64" />
                        <MajorGrid Enabled="false" />
	                </Axisx>                                
                </asp:ChartArea> 
            </Chartareas> 
        </asp:Chart> 
    </div>

    <ext:TextField ID ="TextFieldTitle" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID ="TextFieldCode" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID ="TextFieldType" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID ="TextFieldIndex" runat="server" Hidden="true"></ext:TextField>
    </form>
</body>
</html>
