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
    /// <summary>
    /// EPCodeBox_ValidationResult
    /// </summary>
    public class EPCodeBox_ValidationResult
    {
        private bool _resultValidation = false;
        private DataSet _resultDataSet = null;
        private string _returnOBJECTIDFieldName = "OBJECT_ID";
        private string _returnValueFieldName = "TYPECD";
        private string _returnTextFieldName = "TYPENM";

        /// <summary>
        /// resultValidation
        /// </summary>
        public bool resultValidation
        {
            get { return _resultValidation; }
            set { _resultValidation = value; }
        }
        
        /// <summary>
        /// resultDataSet
        /// </summary>
        public DataSet resultDataSet
        {
            get { return _resultDataSet; }
            set { _resultDataSet = value; }
        }

        /// <summary>
        /// returnOBJECTIDFieldName
        /// </summary>
        public string returnOBJECTIDFieldName
        {
            get { return _returnOBJECTIDFieldName; }
            set { _returnOBJECTIDFieldName = value; }
        }

        /// <summary>
        /// returnValueFieldName
        /// </summary>
        public string returnValueFieldName
        {
            get { return _returnValueFieldName; }
            set { _returnValueFieldName = value; }
        }

        /// <summary>
        /// returnTextFieldName
        /// </summary>
        public string returnTextFieldName
        {
            get { return _returnTextFieldName; }
            set { _returnTextFieldName = value; }
        }

        /// <summary>
        /// CopyTo 복사기능
        /// </summary>
        /// <param name="tarResult"></param>
        public void CopyTo(EP.UI.EPCodeBox_ValidationResult tarResult)
        {
            tarResult.resultDataSet = this.resultDataSet.Copy();
            tarResult.resultValidation = this.resultValidation;
            tarResult.returnOBJECTIDFieldName = this.returnOBJECTIDFieldName;
            tarResult.returnValueFieldName = this.returnValueFieldName;
            tarResult.returnTextFieldName = this.returnTextFieldName;
        }
    }


}