using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;
using System.Data;
using System.Collections;

namespace Ax.EP.UI
{
    public partial class EPCodeBox : System.Web.UI.UserControl, Ax.EP.UI.IEPCodeBox
    {
        #region Enum 정의
        public enum PopupWindowType
        {
            CodeWindow,
            HelpWindow,
            UserWindow
        }

        #endregion

        #region 일반속성 정의
        public Unit WidthTYPECD
        {
            get { return this.InnerTextField_TypeCD.Width; }
            set { this.InnerTextField_TypeCD.Width = value; Control_Resize(); }
        }

        public Unit WidthTYPENM
        {
            get { return this.InnerTextField_TypeNM.Width; }
            set { this.InnerTextField_TypeNM.Width = value; Control_Resize(); }
        }

        public Unit Width
        {
            get { return this.cdx_CodeBox.Width; }
        }

        public Unit Height
        {
            get { return this.cdx_CodeBox.Height; }
        }

        public int PopupWidth
        {
            get;
            set;
        }

        public int PopupHeight
        {
            get;
            set;
        }

        public bool ReadOnly
        {
            get { return this.InnerTextField_TypeCD.ReadOnly; }
            set { this.InnerTextField_TypeCD.ReadOnly = value; }
        }

        public bool isComponent
        {
            get { return true; }
        }

        public bool Validation
        {
            get;
            set;
        }

        public bool isValid
        {
            get { return bool.Parse(this.VALID.Value.ToString()); }
            set { this.VALID.Value = value.ToString(); }
        }

        public bool isEditable
        {
            get { return bool.Parse(this.EDITABLE.Value.ToString()); }
            set { this.EDITABLE.Value = value.ToString(); }
        }

        public bool IsEmpty
        {
            get { return (string.IsNullOrEmpty(this.ObjectID) ? true : false); }
        }
        #endregion

        #region 주요속성 정의
        public PopupWindowType PopupType
        {
            get;
            set;
        }

        public PopupHelper.HelpType PopupMode
        {
            get;
            set;
        }

        public HEParameterSet UserParamSet
        {
            get;
            set;
        }

        public string HelperID
        {
            get;
            set;
        }

        public string ClassID
        {
            get;
            set;
        }

        public string Division
        {
            get;
            set;
        }

        public string UserHelpURL
        {
            get;
            set;
        }

        // 내부전용
        private string ObjectID
        {
            get { return this.InnerTextField_ObjectID.Text; }
        }

        public string TypeCD
        {
            get { return this.InnerTextField_TypeCD.Text; }
        }

        // 내부전용
        private string TypeNM
        {
            get { return this.InnerTextField_TypeNM.Text; }
        }

        /// <summary>
        /// Value 필드 값만 변경
        /// </summary>
        public string Value
        {
            get { return this.ObjectID; }
            set
            {
                if (!this.isEditable) return;

                this.InnerTextField_ObjectID.SetValue(value);
                this.InnerTextField_TypeCD.SetValue(value);
                if (this.PopupType == PopupWindowType.CodeWindow)
                {
                    if (string.IsNullOrEmpty(value))
                        this.InnerTextField_TypeCD.SetValue(string.Empty);
                    else
                        this.InnerTextField_TypeCD.SetValue(value.Substring(this.ClassID.Length));
                    
                }
                if (string.IsNullOrEmpty(value)) this.Text = string.Empty;
            }
        }

        // 내부전용
        private string ValueOnly
        {
            set
            {
                this.InnerTextField_ObjectID.SetValue(value);
            }
        }

        public bool VisiableValue
        {
            set { this.InnerTextField_TypeCD.Hidden = !value; Control_Resize(); }
            get { return !this.InnerTextField_TypeCD.Hidden; }
        }

        public bool VisiableText
        {
            set { this.InnerTextField_TypeNM.Hidden = !value; Control_Resize(); }
            get { return !this.InnerTextField_TypeNM.Hidden; }
        }
        public bool VisiableHelper
        {
            set { this.InnerImageButton_Helper.Hidden = !value; Control_Resize(); }
            get { return !this.InnerImageButton_Helper.Hidden; }
        }
        public bool VisiableContainer
        {
            set { this.cdx_CodeBox.Hidden = !value; Control_Resize(); }
            get { return !this.cdx_CodeBox.Hidden; }
        }

        /// <summary>
        /// SetValue  Value 필드와 Text 필드값 모두 처리
        /// </summary>
        /// <param name="value"></param>
        public void SetValue(object value)
        {
            string v = (value == null) ? string.Empty : value.ToString();

            this.Value = v;
            this.Field_Validation(this, null);
        }

        public override void Focus()
        {
            this.InnerTextField_TypeCD.Focus();
        }

        /// <summary>
        /// Text 프로퍼티는 읽기 전용 
        /// </summary>
        public string Text
        {
            get { return this.TypeNM; }
            set
            {
                if (!this.isEditable) return;

                this.InnerTextField_TypeNM.SetValue(value);
                if (!string.IsNullOrEmpty(this.ObjectID) && string.IsNullOrEmpty(this.TypeNM))
                {
                    this.Field_Validation(this, null);
                }
            }
        }

        #endregion

        #region 필드 및 버튼 반환 속성 정의
        public Ext.Net.TextField InnerTextField_ObjectID
        {
            get { return this.OBJECTID; }
        }

        public Ext.Net.TextField InnerTextField_TypeCD
        {
            get { return this.TYPECD; }
        }

        public Ext.Net.TextField InnerTextField_TypeNM
        {
            get { return this.TYPENM; }
        }

        public Ext.Net.ImageButton InnerImageButton_Helper
        {
            get { return this.HELPER; }
        }

        public Ax.EP.Utility.BasePage BasePage
        {
            get { return (BasePage)this.Page; }
        }
        #endregion


        #region 이벤트 정의
        /// <summary>
        /// ValidationEventHandler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="rsltSet"></param>
        public delegate void ValidationEventHandler(object sender, EP.UI.EPCodeBox_ValidationResult rsltSet);

        public event ComponentDirectEvent.DirectEventHandler BeforeDirectButtonClick;
        public event ValidationEventHandler CustomRemoteValidation;
        public event ComponentDirectEvent.DirectEventHandler AfterValidation;

        #endregion

        /// <summary>
        /// EPCodeBox
        /// </summary>
        public EPCodeBox()
            : base()
        {
            this.PopupWidth = PopupHelper.defaultPopupWidth;
            this.PopupHeight = PopupHelper.defaultPopupHeight;
            this.PopupMode = PopupHelper.HelpType.Search;
            this.PopupType = PopupWindowType.CodeWindow;
            this.HelperID = string.Empty;
            this.UserHelpURL = string.Empty;
            this.ClassID = string.Empty;
            this.Division = string.Empty;
            this.Validation = true;
            this.UserParamSet = new HEParameterSet();
        }

        /// <summary>
        /// Control_Resize
        /// </summary>
        protected void Control_Resize()
        {
            double ctlSize = 0;
            int viewCount = -1;

            if (!this.InnerTextField_TypeCD.Hidden) { viewCount++; ctlSize += this.InnerTextField_TypeCD.Width.Value; }
            if (!this.InnerTextField_TypeNM.Hidden) { viewCount++; ctlSize += this.InnerTextField_TypeNM.Width.Value; }
            if (!this.InnerImageButton_Helper.Hidden) { viewCount++; ctlSize += this.InnerImageButton_Helper.Width.Value; }

            double padding = viewCount * 4;

            if (padding >= 0)
                this.cdx_CodeBox.Width = Unit.Parse((ctlSize + padding).ToString());
        }

        /// <summary>
        /// CodeBox_HELPER_Click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void CodeBox_HELPER_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            if (this.TYPECD.ReadOnly) return;

            // Before 이벤트가 있을경우 Before 이벤트 처리
            if (BeforeDirectButtonClick != null) BeforeDirectButtonClick(this, e);

            switch (this.PopupType)
            {
                case PopupWindowType.CodeWindow:
                    string popupMode = (this.PopupMode == PopupHelper.HelpType.Search) ? "search" : "input";
                    Util.CodePopup(this.BasePage, this.ID, this.TypeCD, this.TypeNM, this.ClassID, popupMode, this.PopupWidth, this.PopupHeight, this.UserParamSet);
                    break;
                case PopupWindowType.HelpWindow:
                    Util.HelpPopup(this.BasePage, this.HelperID, this.PopupMode, this.ID, this.TypeCD, this.TypeNM, this.Division, this.PopupWidth, this.PopupHeight, this.UserParamSet);
                    break;
                case PopupWindowType.UserWindow:
                    Util.UserPopup(this.BasePage, this.UserHelpURL, this.UserParamSet, this.ID, "Popup", this.PopupWidth, this.PopupHeight);
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// Field_Validation
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Field_Validation(object sender, RemoteValidationEventArgs e)
        {
            if (!this.Validation)
            {
                this.isValid = true;
                if (this.AfterValidation != null) this.AfterValidation(this, null);
                return;
            }

            if (string.IsNullOrEmpty(this.TypeCD))
            {
                // 값이없으면 true 반환
                if (e != null) e.Success = true;

                this.ValueOnly = string.Empty;    // 유효성 검사시에는 ObjectID 필드만 지운다 
                this.Text = string.Empty;
                this.isValid = true;
            }
            else
            {
                EP.UI.EPCodeBox_ValidationResult valRslt = null;

                // 호출전 BeforeDirectButtonClick 이벤트가 있을경우 해당 파라메터 처리 이벤트 먼저 처리
                if (this.BeforeDirectButtonClick != null) this.BeforeDirectButtonClick(this, null);

                // 호출전 CustomRemoteValidation 이벤트가 있을경우 사용자 정의 밸리데이션으로 대체 처리한다.
                if (this.CustomRemoteValidation != null)
                {
                    valRslt = new EPCodeBox_ValidationResult();
                    this.CustomRemoteValidation(this, valRslt);
                }

                if (valRslt == null)
                {
                    // 사용자 정의 Validation 이 없을경우 정상 처리
                    switch (this.PopupType)
                    {
                        case PopupWindowType.CodeWindow:
                            // 공용 코드 유효성 검사용
                            valRslt = this.Common_Validation();
                            break;
                        case PopupWindowType.HelpWindow:
                            // Helper 코드 유효성 검사용
                            switch (this.HelperID)
                            {
                                case "HELP_VENDCD":
                                case "HELP_M_VENDCD": 
                                case "HELP_VENDCD_FREE": valRslt = this.Vender_Validation(); break;
                                case "HELP_CUSTCD": 
                                case "HELP_CUSTCD_FIX": valRslt = this.Customer_Validation(); break;
                                case "HELP_PARTNO": valRslt = this.Partno_Validation(); break;
                                case "HELP_LINE_SEQ":
                                case "HELP_LINE": valRslt = this.Line_Validation(); break;
                                case "HELP_EMPNO": valRslt = this.Empno_Validation(); break;
                                case "HELP_STR_LOC": valRslt = this.StoreLocation_Validation(); break;
                                case "HELP_CONTCD_SEQ":
                                case "HELP_CONTCD": valRslt = this.Container_Validation(); break;
                            }
                            break;
                        case PopupWindowType.UserWindow:
                            // User Popup 는 CodeBox_CustomRemoteValidation 이벤트를 이용하여 해당 프로그램에서 직접 정의 바람
                            valRslt = new EPCodeBox_ValidationResult();
                            valRslt.resultValidation = true;
                            break;
                        default:
                            break;
                    }
                }

                // 유효성 검사값 반환
                if (e != null) e.Success = valRslt.resultValidation;

                this.isValid = valRslt.resultValidation;

                if (!valRslt.resultValidation)
                {
                    this.ValueOnly = string.Empty;    // 유효성 검사시에는 ObjectID 필드만 지운다 
                    this.Text = string.Empty;
                    if (e != null) e.ErrorMessage = "유효한 코드값이 아닙니다.(Not Validated value)";
                }
                else
                {
                    if (valRslt.resultDataSet != null)
                    {
                        if (valRslt.resultDataSet.Tables[0].Columns.Contains(valRslt.returnOBJECTIDFieldName))
                            this.Value = valRslt.resultDataSet.Tables[0].Rows[0][valRslt.returnOBJECTIDFieldName].ToString();
                        else
                            this.Value = valRslt.resultDataSet.Tables[0].Rows[0][valRslt.returnValueFieldName].ToString();

                        this.Text = valRslt.resultDataSet.Tables[0].Rows[0][valRslt.returnTextFieldName].ToString();
                    }
                }
            }
            if (this.AfterValidation != null) this.AfterValidation(this, null);
        }
    }
}