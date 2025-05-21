using System;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;
using Ext.Net;
using HE.Framework.Core;
using TheOne.Configuration;

namespace Ax.EP.Utility
{
    /// <summary>
    /// Util
    /// </summary>
    /// <remarks>2014.07.01 Edited by KGW</remarks>
    public static class Library
    {
        #region 유효성검사 ActionType
        /// <summary>
        /// ActionType 유효성 검사시 사용 모드
        /// </summary>
        public enum ActionType
        {
            Search,
            Save,
            Delete,
            Process,
            Write,
            Send,
            Receive, 
            SendBack,
            Request,
            ExcelDL
        }
        #endregion

        #region ComboBox Type Define
        /// <summary>
        /// 콤보박스 DisplayField로 지정할 명칭
        /// </summary>
        public enum DISPLAY_FIELD_TYPE
        {
            OBJECT_NM,
            TYPENM,             // 공통코드(기본)
            TYPECD,

            CODE_NM             // 일반 (사용자 지정)
        }

        /// <summary>
        /// 콤보박스에 ValueField로 지정할 명칭
        /// </summary>
        public enum VALUE_FIELD_TYPE
        {
            OBJECT_ID,          // 공통코드(기본)
            CODE                // 일반 (사용자 지정)
        }
        #endregion

        #region Date, Time Method
        /// <summary>
        /// GetCurrentTime 시간 포맷 23:59:01  HH:mm:ss
        /// </summary>
        /// <param name="Bar">매개변수 0=HHmmss, 1=HH:mm:ss</param>
        /// <returns></returns>
        /// <remarks></remarks>
        public static string GetCurrentTime(string Bar)
        {
            //SYSTEM DATE 가져오기
            HEParameterSet param = new HEParameterSet();
            param.Add("BAR", Bar);

            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPCOMMON.GET_CURRENT_TIME", param);

            string curTime = (Bar == "0" ? DateTime.Now.ToString("HHmmss") : DateTime.Now.ToString("HH:mm:ss"));

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                curTime = ds.Tables[0].Rows[0]["CUR_TIME"].ToString();

            return curTime;
        }
        /// <summary>
        /// GetCurrentDate 서버의 오늘 날짜=SYSTEM DATE 가져오기
        /// </summary>
        /// <param name="Bar">매개변수 0=YYYYMMDD, 1=YYYY-MM-DD</param>
        /// <returns>string</returns>
        /// <remarks></remarks>
        public static string GetCurrentDate(string Bar)
        {
            //SYSTEM DATE 가져오기
            HEParameterSet param = new HEParameterSet();
            param.Add("BAR", Bar);

            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPCOMMON.GET_CURRENT_DATE", param);

            string curDate = (Bar == "0" ? DateTime.Now.ToString("yyyyMMdd") : DateTime.Now.ToString("yyyy-MM-dd"));

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                curDate =  ds.Tables[0].Rows[0]["TODAY"].ToString();

            return curDate;
        }
        /// <summary>
        /// 현재 월의 첫번째 일의 DateTime 반환
        /// </summary>
        /// <returns>DateTime</returns>
        /// <remarks></remarks>
        public static DateTime GetFirstDayOfMonth()
        {
            string date = DateTime.Now.ToString("yyyy-MM-dd").Substring(0, 8) + "01";
            return DateTime.Parse(date);
        }
        #endregion

        #region Build ComboBox 로그인
        /// <summary>
        /// 콤보 박스 데이터 초기화 (로그인 콤보박스)
        /// </summary>
        /// <param name="sbox">콤보박스</param>
        /// <param name="query">쿼리(패키지명.프로시져명)</param>
        /// <param name="lang">언어</param>
        /// <param name="isSearch">검색용 여부</param>
        /// <param name="isRequired">필수여부</param>
        /// <returns></returns>
        /// <remarks></remarks>
        public static string setLoginLanguageBox(ComboBox sbox, string lang, bool isSearch, bool isRequired)
        {
            sbox.DisplayField = "CODE";
            sbox.ValueField = "ID";
            int selectedIndex = 0;
            string selectedValue = string.Empty;

            HEParameterSet param = new HEParameterSet();
            param.Add("CLASS_ID", "T2");
            param.Add("LANG_SET", lang);

            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.INQUERY_LANGUAGE_LIST", param); //데이터 베이스 조회

            if (ds.Tables.Count > 0)
            {
                Store sbStore = sbox.GetStore();
                sbStore.DataSource = ds.Tables[0];
                sbStore.DataBind();

                int index = 0;
                bool isDault = false;
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    if (item["COMBO_VALUE"].ToString() == "1") { isDault = true; break; }
                    index++;
                }
                selectedIndex = isDault ? index : -1;


                if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0 && selectedIndex != -1)
                {
                    selectedValue = ds.Tables[0].Rows[selectedIndex].ItemArray[0].ToString();
                }
                else if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        selectedValue = ds.Tables[0].Rows[0].ItemArray[0].ToString();
                    }
                }

                if (isSearch)
                {
                    Ext.Net.ListItem item = null;
                    if (isRequired)
                    {
                        if (lang.Equals("KO")) item = new Ext.Net.ListItem("선    택", "-");
                        else item = new Ext.Net.ListItem("Select", "-");
                    }
                    else
                    {
                        if (lang.Equals("KO")) item = new Ext.Net.ListItem("전    체", "%");
                        else item = new Ext.Net.ListItem("All", "%");
                    }
                    sbox.Items.Insert(0, item);
                    selectedIndex++;
                    sbox.SelectedItem.Index = selectedIndex;
                }
                else
                {
                    if (selectedIndex == -1) selectedIndex = 0;
                    sbox.SelectedItem.Index = selectedIndex;
                }

            }
            return selectedValue;
        }
        #endregion

        #region # 콤보 데이터 바인딩 #

        /// <summary>
        /// 콤보박스에 클래스ID에 따른 유형코드를 콤보박스에 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="classID"></param>
        public static void ComboDataBind(ComboBox combo, string classID)
        {
            ComboDataBind(combo, classID, false, DISPLAY_FIELD_TYPE.TYPENM, VALUE_FIELD_TYPE.OBJECT_ID, true);
        }

        /// <summary>
        /// 콤보박스에 클래스ID에 따른 유형코드를 콤보박스에 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="classID"></param>
        /// <param name="isEmptyRow"></param>
        public static void ComboDataBind(ComboBox combo, string classID, bool isEmptyRow)
        {
            ComboDataBind(combo, classID, isEmptyRow, DISPLAY_FIELD_TYPE.TYPENM, VALUE_FIELD_TYPE.OBJECT_ID, true);
        }

        /// <summary>
        /// /// 콤보박스에 클래스ID에 따른 유형코드를 콤보박스에 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="classID"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="firstRowSelection"></param>
        public static void ComboDataBind(ComboBox combo, string classID, bool isEmptyRow, bool firstRowSelection)
        {
            ComboDataBind(combo, classID, isEmptyRow, DISPLAY_FIELD_TYPE.TYPENM, VALUE_FIELD_TYPE.OBJECT_ID, firstRowSelection);
        }

        /// <summary>
        /// 콤보박스에 클래스ID에 따른 유형코드를 콤보박스에 바인딩한다.
        /// </summary>
        /// <param name="combo">대상 콤보박스(ComboBox)</param>
        /// <param name="classID">클래스ID</param>
        /// <param name="isEmptyRow">첫번째 행에 비어 있는 데이터를 추가할지 여부</param>
        /// <param name="dft">콤보박스에 보여줄 항목 지정(선택항목, 기본:TYPENM)</param>
        /// <param name="vft">콤보박스에 가져갈 값 항목 지정(선택항목, 기본:OBJECT_ID)</param>
        public static void ComboDataBind(ComboBox combo, string classID, bool isEmptyRow, DISPLAY_FIELD_TYPE dft, VALUE_FIELD_TYPE vft)
        {
            ComboDataBind(combo, classID, isEmptyRow, dft, vft, true);
        }

        /// <summary>
        /// 콤보박스에 클래스ID에 따른 유형코드를 콤보박스에 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="classID"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="dft">콤보박스에 보여줄 항목 지정(선택항목, 기본:TYPENM)</param>
        /// <param name="vft">콤보박스에 가져갈 값 항목 지정(선택항목, 기본:OBJECT_ID)</param>
        /// <param name="firstRowSelection"></param>
        public static void ComboDataBind(ComboBox combo, string classID, bool isEmptyRow, DISPLAY_FIELD_TYPE dft, VALUE_FIELD_TYPE vft, bool firstRowSelection)
        {
            DataTable source = GetTypeCode(classID).Tables[0];
            ComboDataBind(combo, source, isEmptyRow, dft, vft, firstRowSelection);
        }

        /// <summary>
        /// 콤보박스에 데이터소스를 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="source"></param>
        public static void ComboDataBind(ComboBox combo, DataTable source)
        {
            ComboDataBind(combo, source, false, DISPLAY_FIELD_TYPE.TYPENM, VALUE_FIELD_TYPE.OBJECT_ID, true);
        }

        /// <summary>
        /// 콤보박스에 데이터소스를 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="source"></param>
        /// <param name="isEmptyRow"></param>
        public static void ComboDataBind(ComboBox combo, DataTable source, bool isEmptyRow)
        {
            ComboDataBind(combo, source, isEmptyRow, DISPLAY_FIELD_TYPE.TYPENM, VALUE_FIELD_TYPE.OBJECT_ID, true);
        }

        /// <summary>
        /// 콤보박스에 데이터소스를 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="source"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="firstRowSelection"></param>
        public static void ComboDataBind(ComboBox combo, DataTable source, bool isEmptyRow, bool firstRowSelection)
        {
            ComboDataBind(combo, source, isEmptyRow, DISPLAY_FIELD_TYPE.TYPENM, VALUE_FIELD_TYPE.OBJECT_ID, firstRowSelection);
        }

        /// <summary>
        /// 콤보박스에 데이터소스를 바인딩한다.
        /// </summary>
        /// <param name="combo">대상 콤보박스(ComboBox)</param>
        /// <param name="source">바인딩할 소스</param>
        /// <param name="isEmptyRow">첫번째 행에 비어 있는 데이터를 추가할지 여부(선택항목, 기본:false)</param>
        /// <param name="dft">콤보박스에 보여줄 항목 지정(선택항목, 기본:TYPENM)</param>
        /// <param name="vft">콤보박스에 가져갈 값 항목 지정(선택항목, 기본:OBJECT_ID)</param>
        public static void ComboDataBind(ComboBox combo, DataTable source, bool isEmptyRow, DISPLAY_FIELD_TYPE dft, VALUE_FIELD_TYPE vft)
        {
            ComboDataBind(combo, source, isEmptyRow, Enum.GetName(typeof(DISPLAY_FIELD_TYPE), dft), Enum.GetName(typeof(VALUE_FIELD_TYPE), vft), true);
        }

        /// <summary>
        /// 콤보박스에 데이터소스를 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="source"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="dft">콤보박스에 보여줄 항목 지정(선택항목, 기본:TYPENM)</param>
        /// <param name="vft">콤보박스에 가져갈 값 항목 지정(선택항목, 기본:OBJECT_ID)</param>
        /// <param name="firstRowSelection"></param>
        public static void ComboDataBind(ComboBox combo, DataTable source, bool isEmptyRow, DISPLAY_FIELD_TYPE dft, VALUE_FIELD_TYPE vft, bool firstRowSelection)
        {
            ComboDataBind(combo, source, isEmptyRow, Enum.GetName(typeof(DISPLAY_FIELD_TYPE), dft), Enum.GetName(typeof(VALUE_FIELD_TYPE), vft), firstRowSelection, "ALL");
        }

        /// <summary>
        /// ComboDataBind
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="source"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="dft"></param>
        /// <param name="vft"></param>
        /// <param name="firstRowSelection"></param>
        /// <param name="emptyRowText"></param>
        public static void ComboDataBind(ComboBox combo, DataTable source, bool isEmptyRow, DISPLAY_FIELD_TYPE dft, VALUE_FIELD_TYPE vft, bool firstRowSelection, string emptyRowText)
        {
            ComboDataBind(combo, source, isEmptyRow, Enum.GetName(typeof(DISPLAY_FIELD_TYPE), dft), Enum.GetName(typeof(VALUE_FIELD_TYPE), vft), firstRowSelection, emptyRowText);
        }

        /// <summary>
        /// 콤보박스에 데이터소스를 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="source"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="displayFieldName">콤보박스에 보여질 항목 필드 이름 지정</param>
        /// <param name="valueFieldName">콤보박스에 가져갈 항목 필드 이름 지정</param>
        public static void ComboDataBind(ComboBox combo, DataTable source, bool isEmptyRow, string displayFieldName, string valueFieldName)
        {
            ComboDataBind(combo, source, isEmptyRow, displayFieldName, valueFieldName, true);
        }

        /// <summary>
        /// 콤보박스에 데이터소스를 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="source"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="displayFieldName">콤보박스에 보여질 항목 필드 이름 지정</param>
        /// <param name="valueFieldName">콤보박스에 가져갈 항목 필드 이름 지정</param>
        /// <param name="firstRowSelection"></param>
        public static void ComboDataBind(ComboBox combo, DataTable source, bool isEmptyRow, string displayFieldName, string valueFieldName, bool firstRowSelection)
        {
            ComboDataBind(combo, source, isEmptyRow, displayFieldName, valueFieldName, firstRowSelection, "ALL");
        }

        /// <summary>
        /// 콤보박스에 데이터소스를 바인딩한다.
        /// </summary>
        /// <param name="combo"></param>
        /// <param name="source"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="displayFieldName">콤보박스에 보여질 항목 필드 이름 지정</param>
        /// <param name="valueFieldName">콤보박스에 가져갈 항목 필드 이름 지정</param>
        /// <param name="firstRowSelection"></param>
        /// <param name="emptyRowText"></param>
        public static void ComboDataBind(ComboBox combo, DataTable source, bool isEmptyRow, string displayFieldName, string valueFieldName, bool firstRowSelection, string emptyRowText)
        {
            DataTable dt = source.Copy();

            combo.DisplayField = displayFieldName;
            combo.ValueField = valueFieldName;

            if (isEmptyRow)
            {
                dt.Rows.InsertAt(dt.NewRow(), 0);
                for (int i = 0; i < dt.Columns.Count; i++)
                    dt.Rows[0][i] = dt.Columns[i].Caption == "SORT_SEQ" ? "0" : string.Empty;

                //추가된 사항 2013년 08월 21일
                dt.Rows[0][displayFieldName] = emptyRowText;

            }
            Store sbStore = combo.GetStore();
            sbStore.DataSource = dt;
            sbStore.DataBind();

            if (firstRowSelection)
            {
                if (emptyRowText.Equals("ALL"))
                    combo.SelectedItem.Index = 0;
                else
                    combo.SelectedItem.Index = (isEmptyRow ? 1 : 0);     // 임프티로우를 탑재할경우 퍼트트 로우가 2행이 선택되도록 변경  2018.11.27
                
                combo.UpdateSelectedItems();
            }
        }

        /// <summary>
        /// 클래스ID를 가지고 해당하는 유형코드를 반환한다.
        /// </summary>
        /// <param name="classID">클래스ID</param>
        /// <returns>유형코드|유형코드명 세트 반환</returns>
        public static DataSet GetTypeCode(string classID)
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                HEParameterSet paramSet = new HEParameterSet();
                paramSet.Add("CLASS_ID", classID);
                paramSet.Add("CODE", "");
                paramSet.Add("CODE_NAME", "");
                paramSet.Add("LANG_SET", Util.UserInfo.LanguageShort);

                return proxy.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_TYPECODE_USING", paramSet);
            }
        }

        public static DataSet GetTypeCode(string classID, string groupCD)
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                HEParameterSet paramSet = new HEParameterSet();
                paramSet.Add("CLASS_ID", classID);
                paramSet.Add("CODE", "");
                paramSet.Add("CODE_NAME", "");
                paramSet.Add("GROUPCD", groupCD);
                paramSet.Add("LANG_SET", Util.UserInfo.LanguageShort);

                return proxy.ExecuteDataSet("APG_EPCOMMON.INQUERY_TYPECODE", paramSet);
            }
        }

        /// <summary>
        /// 지정한 콤보박스에 법인코드 정보를 반환
        /// </summary>
        /// <param name="sb"></param>
        public static void GetCORCD(ComboBox sb)
        {
            GetCORCD(sb, false, true);
        }

        /// <summary>
        /// 지정한 콤보박스에 법인코드 정보를 반환
        /// </summary>
        /// <param name="sb"></param>
        /// <param name="corcd"></param>
        /// <param name="isEmptyRow"></param>
        public static void GetCORCD(ComboBox sb, bool isEmptyRow)
        {
            GetCORCD(sb, isEmptyRow, true);
        }

        /// <summary>
        /// 지정한 콤보박스에 법인코드 정보를 반환
        /// </summary>
        /// <param name="sb"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="firstRowSelection"></param>
        public static void GetCORCD(ComboBox sb, bool isEmptyRow, bool firstRowSelection)
        {
            GetCORCD(sb, isEmptyRow, firstRowSelection, "CORCDTYPE", "CORCD");
        }

        /// <summary>
        /// 지정한 콤보박스에 법인코드 정보를 반환
        /// </summary>
        /// <param name="sb"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="firstRowSelection"></param>
        /// <param name="displayField"></param>
        /// <param name="valueField"></param>
        public static void GetCORCD(ComboBox sb, bool isEmptyRow, bool firstRowSelection, string displayField, string valueField)
        {
            GetCORCD(sb, isEmptyRow, firstRowSelection, displayField, valueField, "ALL");
        }

        /// <summary>
        /// GetCORCD
        /// </summary>
        /// <param name="sb"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="firstRowSelection"></param>
        /// <param name="displayField"></param>
        /// <param name="valueField"></param>
        /// <param name="emptyRowText"></param>
        public static void GetCORCD(ComboBox sb, bool isEmptyRow, bool firstRowSelection, string displayField, string valueField, string emptyRowText)
        {
            sb.DisplayField = displayField;
            sb.ValueField = valueField;

            using (EPClientProxy proxy = new EPClientProxy())
            {
                HEParameterSet paramSet = new HEParameterSet();
                paramSet.Add("LANG_SET", Util.UserInfo.LanguageShort);

                DataTable dt = proxy.ExecuteDataSet("APG_EPCOMMON.INQUERY_CORCD", paramSet).Tables[0];

                if (isEmptyRow)
                {
                    dt.Rows.InsertAt(dt.NewRow(), 0);

                    dt.Rows[0][valueField] = "";
                    dt.Rows[0][displayField] = emptyRowText;
                }

                Store sbStore = sb.GetStore();
                sbStore.DataSource = dt;
                sbStore.DataBind();

                if (firstRowSelection)
                {
                    sb.SelectedItem.Index = 0;
                    sb.SelectedItem.Value = Util.UserInfo.CorporationCode;       // 최초
                    sb.UpdateSelectedItems();
                }
            }
        }

        /// <summary>
        /// 지정한 콤보박스에 사업장코드 정보를 반환
        /// </summary>
        /// <param name="sb"></param>
        /// <param name="corcd"></param>
        public static void GetBIZCD(ComboBox sb, string corcd)
        {
            GetBIZCD(sb, corcd, false, true);
        }

        /// <summary>
        /// 지정한 콤보박스에 사업장코드 정보를 반환
        /// </summary>
        /// <param name="sb"></param>
        /// <param name="corcd"></param>
        /// <param name="isEmptyRow"></param>
        public static void GetBIZCD(ComboBox sb, string corcd, bool isEmptyRow)
        {
            GetBIZCD(sb, corcd, isEmptyRow, true);
        }

        /// <summary>
        /// 지정한 콤보박스에 사업장코드 정보를 반환
        /// </summary>
        /// <param name="sb"></param>
        /// <param name="corcd"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="firstRowSelection"></param>
        public static void GetBIZCD(ComboBox sb, string corcd, bool isEmptyRow, bool firstRowSelection)
        {
            GetBIZCD(sb, corcd, isEmptyRow, firstRowSelection, (string.IsNullOrEmpty(sb.DisplayField) ? "BIZCDTYPE" : sb.DisplayField), (string.IsNullOrEmpty(sb.ValueField) ? "BIZCD" : sb.ValueField));
        }

        /// <summary>
        /// 지정한 콤보박스에 사업장코드 정보를 반환
        /// </summary>
        /// <param name="sb"></param>
        /// <param name="corcd"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="firstRowSelection"></param>
        /// <param name="displayField"></param>
        /// <param name="valueField"></param>
        public static void GetBIZCD(ComboBox sb, string corcd, bool isEmptyRow, bool firstRowSelection, string displayField, string valueField)
        {
            GetBIZCD(sb, corcd, isEmptyRow, firstRowSelection, displayField, valueField, "ALL");
        }

        /// <summary>
        /// GetBIZCD
        /// </summary>
        /// <param name="sb"></param>
        /// <param name="corcd"></param>
        /// <param name="isEmptyRow"></param>
        /// <param name="firstRowSelection"></param>
        /// <param name="displayField"></param>
        /// <param name="valueField"></param>
        /// <param name="emptyRowText"></param>
        public static void GetBIZCD(ComboBox sb, string corcd, bool isEmptyRow, bool firstRowSelection, string displayField, string valueField, string emptyRowText)
        {
            sb.DisplayField = displayField;
            sb.ValueField = valueField;

            using (EPClientProxy proxy = new EPClientProxy())
            {
                HEParameterSet paramSet = new HEParameterSet();
                paramSet.Add("CORCD", corcd);
                paramSet.Add("LANG_SET", Util.UserInfo.LanguageShort);

                DataTable dt = proxy.ExecuteDataSet("APG_EPCOMMON.INQUERY_BIZCD", paramSet).Tables[0];

                if (isEmptyRow)
                {
                    dt.Rows.InsertAt(dt.NewRow(), 0);

                    dt.Rows[0][valueField] = "";
                    dt.Rows[0][displayField] = emptyRowText;
                }

                // 2017.08.24 사업장의 경우 코드 안보이고 이름만 보이도록 강제 처리 ( 2017.08.24 - 김도연 과장 요구 ) - 각 화면에 설정된 설정값 무시
                if (displayField.Equals("BIZCDTYPE") && valueField.Equals("BIZCD") && dt.Columns.Contains("BIZNM"))
                    sb.DisplayField = "BIZNM";

                Store sbStore = sb.GetStore();
                sbStore.DataSource = dt;
                sbStore.DataBind();

                if (firstRowSelection)
                {
                    sb.SelectedItem.Index = 0;
                    sb.SelectedItem.Value = Util.UserInfo.BusinessCode;       // 최초
                    sb.UpdateSelectedItems();
                }
            }
        }
        #endregion

        #region 메지지 코드 데이터 가져오기

        /// <summary>
        /// getMenuName 메뉴명을 반환한다.
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static string getMenuName(string id)
        {
            string IN_LANG_SET = string.Empty;

            if (Util.UserInfo != null)
                IN_LANG_SET = Util.UserInfo.LanguageShort;
            else
                IN_LANG_SET = "KO";

            HEParameterSet param = new HEParameterSet();
            param.Add("CODE", id);
            param.Add("SYSTEMCODE", Util.SystemCode);
            param.Add("LANG_SET", IN_LANG_SET);
            DataSet result = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.INQUERY_MENUNAME", param);

            string menuName = "";

            if (result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
                menuName = result.Tables[0].Rows[0][0].ToString();

            return menuName;
        }

        /// <summary>
        /// getMenuName 메뉴명을 반환한다.
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static string getMenuUrl(string id)
        {
            HEParameterSet param = new HEParameterSet();
            param.Add("CODE", id);
            param.Add("SYSTEMCODE", Util.SystemCode);
            DataSet result = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.INQUERY_MENUURL", param);

            string menuUrl = "";

            if (result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
                menuUrl = result.Tables[0].Rows[0][0].ToString();

            return menuUrl;
        }

        /// <summary>
        /// getMessage
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public static string getMessage(string code)
        {
            string lang = "KO";
            if (Util.UserInfo != null) lang = Util.UserInfo.LanguageShort.ToUpper();

            return getMessage(code, lang);
        }

        /// <summary>
        /// getMessage
        /// </summary>
        /// <param name="code"></param>
        /// <param name="lang"></param>
        /// <returns></returns>
        public static string getMessage(string code, string lang)
        {
            string system_code = AppSectionFactory.AppSection["SYSTEM_CODE"];
            string result = string.Empty;

            HEParameterSet param = new HEParameterSet();
            param.Add("SYSTEMCODE", system_code);
            param.Add("CODE", code);
            param.Add("LANGUAGE", lang);

            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.SELECTMESSAGEINFOBYCODE", param);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                result = ds.Tables[0].Rows[0]["MESSAGE"].ToString();

            return result;
        }

        /// <summary>
        /// getLabel
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public static string getLabel(string menuid, string code)
        {
            string lang = "KO";
            if (Util.UserInfo != null) lang = Util.UserInfo.LanguageShort.ToUpper();

            return getLabel(menuid, code, lang);
        }

        /// <summary>
        /// getLabel
        /// </summary>
        /// <param name="code"></param>
        /// <param name="lang"></param>
        /// <returns></returns>
        public static string getLabel(string menuid, string code, string lang)
        {
            string system_code = AppSectionFactory.AppSection["SYSTEM_CODE"];
            string result = string.Empty;

            HEParameterSet param = new HEParameterSet();
            param.Add("SYSTEMCODE", system_code);
            param.Add("MENUID", menuid);
            param.Add("CODE", code);
            param.Add("LANGUAGE", lang);

            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.SELECTLABELINFOBYCODE", param);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                result = ds.Tables[0].Rows[0]["CODENAME"].ToString();

            return result;
        }


        /// <summary>
        /// getMessageWithTitle
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public static string[] getMessageWithTitle(string code)
        {
            string lang = "KO";
            if (Util.UserInfo != null) lang = Util.UserInfo.LanguageShort.ToUpper();

            return getMessageWithTitle(code, lang);
        }

        /// <summary>
        /// getMessageWithTitle
        /// </summary>
        /// <param name="code"></param>
        /// <param name="lang"></param>
        /// <returns></returns>
        public static string[] getMessageWithTitle(string code, string lang)
        {
            string system_code = AppSectionFactory.AppSection["SYSTEM_CODE"];
            string[] result = new string[2];

            HEParameterSet param = new HEParameterSet();
            param.Add("SYSTEMCODE", system_code);
            param.Add("CODE", code);
            param.Add("LANGUAGE", lang);

            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.SELECTMESSAGEINFOBYCODE", param);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                result[0] = ds.Tables[0].Rows[0]["TITLE"].ToString();
                result[1] = ds.Tables[0].Rows[0]["MESSAGE"].ToString();
            }
            else
            {
                result[0] = "Message";
                result[1] = code;
            }

            return result;
        }
        #endregion

        #region 환경변수 처리
        public static string GetSysEnviroment(string section, string envname)
        {
            string result = string.Empty;

            HEParameterSet param = new HEParameterSet();
            param.Add("SECTION", section);
            param.Add("ENVNAME", envname);

            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.GET_SYS_ENVIROMENT", param);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                result = ds.Tables[0].Rows[0]["ENVVALUE"].ToString();

            return result;
        }

        /// <summary>
        /// 사용자 환경정보를 반환합니다.
        /// </summary>
        public static string GetUserEnviroment(string userid, string envname)
        {
            string result = string.Empty;

            HEParameterSet param = new HEParameterSet();
            param.Add("USERID", userid);
            param.Add("ENVNAME", envname);

            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.GET_USER_ENVIROMENT", param);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                result = ds.Tables[0].Rows[0]["ENVVALUE"].ToString();

            return result;
        }

        #endregion
        #region 협력사 권한 2610 존재 여부 확인
        /// <summary>
        /// 협력사, 해당 권한이 2610인 경우 업체 비활성화 
        /// </summary>
        /// <param name="authID"></param>
        /// <returns></returns>
        public static bool checkAuth(string authID)
        {
            bool result = false;

            DataSet ds = new DataSet();
            try
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", Util.UserInfo.BusinessCode);
                param.Add("USERID", Util.UserInfo.UserID);
                param.Add("SYSTEMCODE", Util.SystemCode);
                param.Add("GROUPID", authID);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_VM20001", "INQUERY_AUTH"), param);

                if (ds.Tables.Count > 0 && int.Parse(ds.Tables[0].Rows[0]["CNT"].ToString()) > 0)
                    result = true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.Print(ex.ToString());
            }

            return result;
        }
        #endregion
    }
}
