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
    /// EPCodeBox_Validation
    /// </summary>
    public static class EPCodeBox_Validation
    {
        /// <summary>
        /// Partno_Validation 유효성 검사용 로직 ( 확장 메소드 )
        /// </summary>
        /// <param name="cdx"></param>
        /// <returns></returns>
        public static EPCodeBox_ValidationResult Partno_Validation(this Ax.EP.UI.EPCodeBox cdx)
        {
            EPCodeBox_ValidationResult valRslt = new EPCodeBox_ValidationResult();

            // 값이 없으면 true
            if (string.IsNullOrEmpty(cdx.TypeCD))
            {
                valRslt.resultValidation = true;
            }
            else
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.SystemCode);
                param.Add("BIZCD", Util.UserInfo.BusinessCode);
                param.Add("PARTNO", cdx.TypeCD);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_PARTNO_VALIDATION", param);

                // 동일한 데이터가 있으면 true 없으면 false
                valRslt.resultDataSet = ds;
                valRslt.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true;
            }

            return valRslt;
        }

        /// <summary>
        /// Vender_Validation 유효성 검사용 로직 ( 확장 메소드 )
        /// </summary>
        /// <param name="cdx"></param>
        /// <returns></returns>
        public static EPCodeBox_ValidationResult Vender_Validation(this Ax.EP.UI.EPCodeBox cdx)
        {
            EPCodeBox_ValidationResult valRslt = new EPCodeBox_ValidationResult();

            // 값이 없으면 true
            if (string.IsNullOrEmpty(cdx.TypeCD))
            {
                valRslt.resultValidation = true;
            }
            else
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("VENDCD", cdx.TypeCD);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_VENDER_VALIDATION", param);

                // 동일한 데이터가 있으면 true 없으면 false
                valRslt.resultDataSet = ds;
                valRslt.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true;
            }

            return valRslt;
        }


        /// <summary>
        /// Customer_Validation 유효성 검사용 로직 ( 확장 메소드 )
        /// </summary>
        /// <param name="cdx"></param>
        /// <returns></returns>
        public static EPCodeBox_ValidationResult Customer_Validation(this Ax.EP.UI.EPCodeBox cdx)
        {
            EPCodeBox_ValidationResult valRslt = new EPCodeBox_ValidationResult();

            // 값이 없으면 true
            if (string.IsNullOrEmpty(cdx.TypeCD))
            {
                valRslt.resultValidation = true;
            }
            else
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CUSTCD", cdx.TypeCD);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_CUSTOMER_VALIDATION", param);

                // 동일한 데이터가 있으면 true 없으면 false
                valRslt.resultDataSet = ds;
                valRslt.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true;
            }

            return valRslt;
        }


        /// <summary>
        /// 저장위치_Validation 유효성 검사용 로직 ( 확장 메소드 )
        /// </summary>
        /// <param name="cdx"></param>
        /// <returns></returns>
        public static EPCodeBox_ValidationResult StoreLocation_Validation(this Ax.EP.UI.EPCodeBox cdx)
        {
            EPCodeBox_ValidationResult valRslt = new EPCodeBox_ValidationResult();

            // 값이 없으면 true
            if (string.IsNullOrEmpty(cdx.TypeCD))
            {
                valRslt.resultValidation = true;
            }
            else
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", cdx.UserParamSet["BIZCD"]);
                param.Add("STR_LOC", cdx.TypeCD);                

                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_STR_LOC_VALIDATION", param);

                // 동일한 데이터가 있으면 true 없으면 false
                valRslt.resultDataSet = ds;
                valRslt.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true;
            }

            return valRslt;
        }

        /// <summary>
        /// 저장위치_Validation 유효성 검사용 로직 ( 확장 메소드 )
        /// </summary>
        /// <param name="cdx"></param>
        /// <returns></returns>
        public static EPCodeBox_ValidationResult Container_Validation(this Ax.EP.UI.EPCodeBox cdx)
        {
            EPCodeBox_ValidationResult valRslt = new EPCodeBox_ValidationResult();

            // 값이 없으면 true
            if (string.IsNullOrEmpty(cdx.TypeCD))
            {
                valRslt.resultValidation = true;
            }
            else
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", cdx.UserParamSet["BIZCD"]);
                param.Add("CONTCD", cdx.TypeCD);

                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_CONTCD_VALIDATION", param);

                // 동일한 데이터가 있으면 true 없으면 false
                valRslt.resultDataSet = ds;
                valRslt.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true;
            }

            return valRslt;
        }

        /// <summary>
        /// Common_Validation 유효성 검사용 로직 ( 확장 메소드 )
        /// </summary>
        /// <param name="cdx"></param>
        /// <returns></returns>
        public static EPCodeBox_ValidationResult Common_Validation(this Ax.EP.UI.EPCodeBox cdx)
        {
            EPCodeBox_ValidationResult valRslt = new EPCodeBox_ValidationResult();

            // 값이 없으면 true
            if (string.IsNullOrEmpty(cdx.TypeCD))
            {
                valRslt.resultValidation = true;
            }
            else
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CLASS_ID", cdx.ClassID);
                param.Add("CODE", cdx.TypeCD);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_TYPECODE_VALIDATION", param);

                // 동일한 데이터가 있으면 true 없으면 false
                valRslt.resultDataSet = ds;
                valRslt.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true;
            }

            return valRslt;
        }


        /// <summary>
        /// Line_Validation 유효성 검사용 로직 ( 확장 메소드 )
        /// </summary>
        /// <param name="cdx"></param>
        /// <returns></returns>
        public static EPCodeBox_ValidationResult Line_Validation(this Ax.EP.UI.EPCodeBox cdx)
        {
            EPCodeBox_ValidationResult valRslt = new EPCodeBox_ValidationResult();

            // 값이 없으면 true
            if (string.IsNullOrEmpty(cdx.TypeCD))
            {
                valRslt.resultValidation = true;
            }
            else
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD",  Util.UserInfo.CorporationCode);
                param.Add("BIZCD", cdx.UserParamSet["BIZCD"]);
                param.Add("LINECD", cdx.TypeCD);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_LINE_VALIDATION", param);

                // 동일한 데이터가 있으면 true 없으면 false
                valRslt.resultDataSet = ds;
                valRslt.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true;
            }

            return valRslt;
        }

        /// <summary>
        /// Line_Validation 유효성 검사용 로직 ( 확장 메소드 )
        /// </summary>
        /// <param name="cdx"></param>
        /// <returns></returns>
        public static EPCodeBox_ValidationResult Empno_Validation(this Ax.EP.UI.EPCodeBox cdx)
        {
            EPCodeBox_ValidationResult valRslt = new EPCodeBox_ValidationResult();

            // 값이 없으면 true
            if (string.IsNullOrEmpty(cdx.TypeCD))
            {
                valRslt.resultValidation = true;
            }
            else
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", Util.UserInfo.BusinessCode);
                param.Add("EMPNO", cdx.TypeCD);
                param.Add("RET_EXCLUDE", string.Empty);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                param.Add("USER_ID", Util.UserInfo.UserID);

                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_EMPLOYEE_VALIDATION", param);

                // 동일한 데이터가 있으면 true 없으면 false
                valRslt.resultDataSet = ds;
                valRslt.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true;
            }

            return valRslt;
        }
    }
}