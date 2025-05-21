using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Ax.EP.UI
{
    /// <summary>
    /// IEPCodeBox
    /// </summary>
    public interface IEPCodeBox
    {
        /// <summary>
        /// HelperID
        /// </summary>
        string HelperID
        {
            get;
            set;
        }

        string ClassID
        {
            get;
            set;
        }

        string Value
        {
            get;
            set;
        }

        string Text
        {
            get;
            set;
        }

        bool VisiableValue
        {
            set;
            get;
        }

        bool VisiableText
        {
            set;
            get;
        }
        bool VisiableHelper
        {
            set;
            get;
        }
        bool isValid
        {
            set;
            get;
        }
        bool isEditable
        {
            set;
            get;
        }

        /// <summary>
        /// TextField_ObjectID
        /// </summary>
        Ext.Net.TextField InnerTextField_ObjectID
        {
            get;
        }

        /// <summary>
        /// TextField_TypeCD
        /// </summary>
        Ext.Net.TextField InnerTextField_TypeCD
        {
            get;
        }

        /// <summary>
        /// TextField_TypeNM
        /// </summary>
        Ext.Net.TextField InnerTextField_TypeNM
        {
            get;
        }

        /// <summary>
        /// ImageButton_Helper
        /// </summary>
        Ext.Net.ImageButton InnerImageButton_Helper
        {
            get;
        }

        void SetValue(object value);
    }
}
