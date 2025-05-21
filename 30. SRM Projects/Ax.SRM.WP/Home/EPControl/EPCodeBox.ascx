<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EPCodeBox.ascx.cs" Inherits="Ax.EP.UI.EPCodeBox" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<ext:TextField ID="OBJECTID" runat="server" Hidden="true"/>
<ext:TextField ID="VALID" runat="server" Text="true" Hidden="true"/>
<ext:TextField ID="EDITABLE" runat="server" Text="true" Hidden="true"/>

<ext:FieldContainer ID="cdx_CodeBox" runat="server" MsgTarget="Side" Flex="1" Width="260" Layout="TableLayout">
    <Items>
        <ext:TextField ID="TYPECD" runat="server" Width="80" Hidden="false" Cls="inputText" IsRemoteValidation="true">
            <RemoteValidation OnValidation="Field_Validation" ValidationBuffer="500" />
            <Listeners>
                <SpecialKey Fn="CodeBox_PopupHandler"></SpecialKey>
            </Listeners>
        </ext:TextField>
        <ext:TextField ID="TYPENM" runat="server" Width="150" Hidden="false" Cls="inputText" ReadOnly="true">                                        
            <Listeners>
                <SpecialKey Fn="CodeBox_PopupHandler"></SpecialKey>
            </Listeners>
        </ext:TextField>
        <ext:ImageButton ID="HELPER" runat="server" Width="22" Hidden="false"  ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="CodeBox_HELPER_Click" />
    </Items>
</ext:FieldContainer>



