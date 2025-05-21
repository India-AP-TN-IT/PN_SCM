using System;
using System.Data;
using System.IO;
using System.Linq;
using System.ServiceModel;
using System.Web;
using System.Web.UI;
using Ext.Net;
using Ax.EP.Utility.Security;
using HE.Framework.Core;
using TheOne.Configuration;

namespace Ax.EP.Utility
{
    /// <summary>
    /// LanguageHelper
    /// </summary>
    /// <remarks>2014.07.01 Edited by KGW</remarks>
    class LanguageHelper
    {

        /// <summary>
        /// SettingLangSet_GridColumn
        /// </summary>
        /// <param name="m_Columns"></param>
        /// <param name="m_LangSet"></param>
        protected static void SettingLangSet_GridColumn(Ext.Net.ColumnCollection m_Columns, System.Data.DataTable m_LangSet)
        {
            DataRow[] rows = null;

            // ColumnCollection 을 뒤진다.
            foreach (Ext.Net.ColumnBase m_Col in m_Columns)
            {
                rows = m_LangSet.Select("CODE = '" + m_Col.ItemID + "' ");
                if (rows.Length > 0) m_Col.Text = rows[0]["CODENAME"].ToString();

                // ColumnCollection 을 뒤진다 두번째 부터는 컬렉션이 다름 ( 재귀호출 )
                SettingLangSet_GridColumn(m_Col.Columns, m_LangSet);
            }
        }

        public static string GetGlobalFormat(BasePage page, string srcFormat)
        {
            ResourceManager resourceManager = page.FindControl("ResourceManager1") as ResourceManager;
            string localeDateFormat = string.Empty;
            string localeMonthFormat = string.Empty;
            string localeMonthDateFormat = string.Empty;

            if (resourceManager != null)
            {
                localeDateFormat = page.GlobalLocalFormat_Date;
                localeMonthFormat = page.GlobalLocalFormat_Month;
                localeMonthDateFormat = page.GlobalLocalFormat_MonthDate;
            }

            string tarFormat = srcFormat;

            switch (srcFormat)
            {
                case "yyyy-MM-dd HH:mm:ss":
                case "yyyy-MM-dd hh:mm:ss":
                case "YYYY-MM-dd hh:mm:ss":
                case "YYYY-MM-dd HH:mm:ss":
                    tarFormat = localeDateFormat + " HH:mm:ss";
                    break;
                case "yyyy-MM-dd HH:mm":
                case "yyyy-MM-dd hh:mm":
                case "YYYY-MM-dd HH:mm":
                case "YYYY-MM-dd hh:mm":
                    tarFormat = localeDateFormat + " HH:mm";
                    break;
                case "yyyy-MM-dd HH":
                case "yyyy-MM-dd hh":
                case "YYYY-MM-dd HH":
                case "YYYY-MM-dd hh":
                    tarFormat = localeDateFormat + " HH";
                    break;
                case "yyyy-MM-dd":
                case "YYYY-MM-dd":
                    tarFormat = localeDateFormat;
                    break;
                case "yyyy-MM":
                case "YYYY-MM":
                    tarFormat = localeMonthFormat;
                    break;
                case "MM-dd":
                    tarFormat = localeMonthDateFormat;
                    break;
                case "MM-dd HH:mm:ss":
                case "MM-dd hh:mm:ss":
                    tarFormat = localeMonthDateFormat + " HH:mm:ss";
                    break;
                case "MM-dd HH:mm":
                case "MM-dd hh:mm":
                    tarFormat = localeMonthDateFormat + " HH:mm";
                    break;
                case "MM-dd HH":
                case "MM-dd hh":
                    tarFormat = localeMonthDateFormat + " HH";
                    break;
                case "HH:mm:ss":
                case "hh:mm:ss":
                    tarFormat = "HH:mm:ss";
                    break;
                case "HH:mm":
                case "hh:mm":
                    tarFormat = "HH:mm";
                    break;
            }

            return tarFormat;
        }

        /// <summary>
        /// SettingLangSet Settings the lang set.
        /// </summary>
        /// <param name="page"></param>
        /// <param name="m_Controls"></param>
        /// <param name="m_LangSet"></param>
        public static void SettingLangSet(BasePage page, System.Web.UI.ControlCollection m_Controls, System.Data.DataTable m_LangSet)
        {
            ResourceManager resourceManager = page.FindControl("ResourceManager1") as ResourceManager;

            DataRow[] rows = null;
            foreach (Control a_Control in m_Controls)
            {
                // Date Field 일경우 날짜 Format 적용
                if (a_Control is Ext.Net.DateField && resourceManager != null && !X.IsAjaxRequest && !page.IsPostBack)
                {
                    Ext.Net.DateField df = ((Ext.Net.DateField)a_Control);

                    string oldFormat = df.Format.Trim();
                    

                    if (df.Type == DatePickerType.Month)
                    {
                        if (string.IsNullOrEmpty(oldFormat) || df.SubmitFormat.Equals("d"))
                        {
                            df.Format = page.GlobalLocalFormat_Month;
                            df.SubmitFormat = page.GlobalLocalFormat_Month;     
                        }
                        else
                        {
                            df.Format = GetGlobalFormat(page, oldFormat);
                            df.SubmitFormat = GetGlobalFormat(page, oldFormat);
                        }
                    }
                    else
                    {
                        if (string.IsNullOrEmpty(oldFormat) || df.SubmitFormat.Equals("d"))
                        {
                            df.Format = page.GlobalLocalFormat_Date;
                            df.SubmitFormat = page.GlobalLocalFormat_Date;
                        }
                        else
                        {
                            df.Format = GetGlobalFormat(page, oldFormat);
                            df.SubmitFormat = GetGlobalFormat(page, oldFormat);
                        }
                    }
                }

                // Date Column 일경우 날짜 시간 Format 적용
                if (a_Control is Ext.Net.DateColumn && resourceManager != null && !X.IsAjaxRequest && !page.IsPostBack)
                {
                    Ext.Net.DateColumn df = ((Ext.Net.DateColumn)a_Control);

                    if (!string.IsNullOrEmpty(df.Format)) df.Format = GetGlobalFormat(page, df.Format);
                }

                if (a_Control is Ext.Net.NumberField)
                {
                    Ext.Net.NumberField df = ((Ext.Net.NumberField)a_Control);

                    df.HideTrigger = true;
                    df.SpinDownEnabled = false;
                    df.SpinUpEnabled = false;
                }

                // GridPanel 다국어 처리
                // GridPanel 의 경우 ColumnID 단위로 맵핑한다.
                if (a_Control is Ext.Net.GridPanel)
                {
                    Ext.Net.GridPanel m_Grid = (Ext.Net.GridPanel)a_Control;

                    // 자체적으로 드레그 앤 카피가 되므로 제외
                    //// ctrl + c 기능 공통으로 추가함.
                    //if (m_Grid.GetSelectionModel() != null && m_Grid.GetSelectionModel().SelType.Equals("cellmodel"))
                    //{
                    //    KeyBindItem kbitem = new KeyBindItem("CTRL+C", "copyToClipboard(#{" + m_Grid.ID + "});");
                    //    //kbitem.
                    //    //KeyBinding kbCtrlC = new KeyBinding();
                    //    //kbCtrlC.Ctrl = true;
                    //    //kbCtrlC.Handler = "copyToClipboard(#{" + m_Grid.ID + "});";
                    //    //kbCtrlC.Handler = "copyToClipboard(" + m_Grid.ClientID + ");";
                    //    //kbCtrlC.Keys.Add(new Key() { Code = KeyCode.C });
                    //    if (m_Grid.KeyMap == null)
                    //    {
                    //        //KeyMap ctrlC = new KeyMap();
                    //        //ctrlC.ID =  m_Grid.ID + "_KeyMapCtrlC";
                    //        //ctrlC.Binding.Add(kbCtrlC);

                    //        //KeyBindItemCollection ctrlC = new KeyBindItemCollection();
                    //        //ctrlC.Add(kbCtrlC);
                    //        //ctrlC.Add(kbitem);
                    //        //m_Grid.KeyMap = ctrlC;
                    //        m_Grid.KeyMap.Add(kbitem);
                    //    }
                    //    else
                    //    {
                    //        //m_Grid.KeyMap.Binding.Add(kbCtrlC);
                    //        //m_Grid.KeyMap.Add(kbCtrlC);
                    //        m_Grid.KeyMap.Add(kbitem);
                    //        //ctrlC.Add(kbitem);
                    //    }
                    //}

                    if (m_Grid.Loader == null)
                    {
                        m_Grid.Loader = new ComponentLoader();
                        m_Grid.Loader.AutoLoad = false;
                        m_Grid.Loader.Mode = LoadMode.Data;
                    }
                    m_Grid.Loader.LoadMask.ShowMask = true;
                    m_Grid.Loader.LoadMask.Msg = "Loading Data...";

                    // Items Collection 을 뒤진다 첨에 한번
                    foreach (Ext.Net.ColumnBase m_Col in m_Grid.ColumnModel.Columns)
                    {
                        rows = m_LangSet.Select("CODE = '" + m_Col.ItemID + "' ");
                        if (rows.Length > 0)
                        {
                            m_Col.Text = rows[0]["CODENAME"].ToString();
                        }
                        else
                        {
                            rows = m_LangSet.Select("CODE = '" + m_Col.DataIndex + "' ");
                            if (rows.Length > 0)
                            {
                                m_Col.Text = rows[0]["CODENAME"].ToString();
                            }
                            else
                            {
                                rows = m_LangSet.Select("CODE = '" + m_Col.ID + "' ");
                                if (rows.Length > 0) m_Col.Text = rows[0]["CODENAME"].ToString();
                            }
                        }

                        // ColumnCollection 을 뒤진다 두번째 부터는 컬렉션이 다름
                        SettingLangSet_GridColumn(m_Col.Columns, m_LangSet);
                    }
                }
                else if (a_Control is Ext.Net.TabStrip)
                {
                    // TabStrip 의 다국어 처리
                    // TabStrip의 ITEMID 가지고 매핑한다.
                    for (int i = 0; i < ((Ext.Net.TabStrip)a_Control).Items.Count(); i++)
                    {
                        if (!((Ext.Net.TabStrip)a_Control).Items[i].TabID.Equals(""))
                        {
                            rows = m_LangSet.Select("CODE = '" + ((Ext.Net.TabStrip)a_Control).Items[i].TabID + "' ");
                            if (rows.Length > 0)
                            {
                                ((Ext.Net.TabStrip)a_Control).Items[i].Text = rows[0]["CODENAME"].ToString();
                            }
                        }
                    }
                }
                else if (a_Control is Ext.Net.TabPanel)
                {
                    for (int i = 0; i < ((Ext.Net.TabPanel)a_Control).Items.Count(); i++)
                    {
                        Ext.Net.Panel pan = ((Ext.Net.TabPanel)a_Control).Items[i] as Ext.Net.Panel;

                        if (pan != null)
                        {
                            rows = m_LangSet.Select("CODE = '" + pan.ItemID + "' ");
                            if (rows.Length > 0)
                            {
                                pan.Title = rows[0]["CODENAME"].ToString();
                            }
                         }
                    }
                }
                else
                {
                    // 나머지 컨트롤 다국어 처리
                    // 그외 컨트롤 ( Label, Radio, Checkbox, Button ) 은 직접 맵핑한다.
                    if (a_Control.ID != null)
                    {
                        int n = a_Control.ID.IndexOf("_") + 1;
                        string ctlid = a_Control.ID.Substring(n);

                        rows = m_LangSet.Select("CODE = '" + ctlid + "'");

                        if (rows.Length > 0)
                        {
                            if (a_Control is Ext.Net.Label)
                                ((Ext.Net.Label)a_Control).Text = rows[0]["CODENAME"].ToString();
                            else if (a_Control is Ext.Net.Radio)
                                ((Ext.Net.Radio)a_Control).BoxLabel = rows[0]["CODENAME"].ToString();
                            else if (a_Control is Ext.Net.Checkbox)
                                ((Ext.Net.Checkbox)a_Control).BoxLabel = rows[0]["CODENAME"].ToString();
                            else if (a_Control is Ext.Net.Button)
                                ((Ext.Net.Button)a_Control).Text = rows[0]["CODENAME"].ToString();

                            else if (a_Control is System.Web.UI.WebControls.Label)
                                ((System.Web.UI.WebControls.Label)a_Control).Text = rows[0]["CODENAME"].ToString();
                            else if (a_Control is System.Web.UI.WebControls.RadioButton)
                                ((System.Web.UI.WebControls.RadioButton)a_Control).Text = rows[0]["CODENAME"].ToString();
                            else if (a_Control is System.Web.UI.WebControls.CheckBox)
                                ((System.Web.UI.WebControls.CheckBox)a_Control).Text = rows[0]["CODENAME"].ToString();
                            else if (a_Control is System.Web.UI.WebControls.Button)
                                ((System.Web.UI.WebControls.Button)a_Control).Text = rows[0]["CODENAME"].ToString();

                            //PGM_TITLE 인 경우 웹페에지에 Title 이 없을 경우 Title 에도 함께 써준다.
                            if (a_Control.ID.Equals("PGM_TITLE") && (string.IsNullOrWhiteSpace(page.Title) || page.Title.Trim().Equals("")))
                                page.Title = ((Ext.Net.Label)a_Control).Text;
                        }
                    }
                }
                SettingLangSet(page, a_Control.Controls, m_LangSet);
            }
        }

        /// <summary>
        /// SettingLangSet Settings the lang set.
        /// </summary>
        /// <param name="page"></param>
        public static void SettingLangSet(BasePage page)
        {
            string system_code = AppSectionFactory.AppSection["SYSTEM_CODE"];
            string result = string.Empty;

            HEParameterSet param = new HEParameterSet();
            param.Add("SYSTEMCODE", system_code);
            param.Add("PGMID", page.GetMenuID());
            param.Add("LANGUAGE", (Util.UserInfo != null ? page.UserInfo.LanguageShort : "KO"));

            DataSet m_LangSet = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.SELECTMULTILANGUAGEINFOBYPGMID", param);

            if (m_LangSet.Tables[0].Rows.Count > 0) SettingLangSet(page, page.Controls, m_LangSet.Tables[0]);
        }
    }
}
