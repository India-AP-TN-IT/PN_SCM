#region ▶ Description & History
/* 
 * 프로그램명 : 관리자 > 권한관리 > 사용자별 권한 현황
 * 설      명 : 
 * 최초작성자 : 이명희
 * 최초작성일 : 2014-11-04
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
 * 
*/
#endregion
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
using HE.Framework.Core.Report;

namespace Ax.EP.WP.Home.EP_XM
{
    public partial class EP_XM30411 : BasePage
    {
        private string PAKAGE_NAME = "APG_EP_XM30410";        
        #region [ 초기설정 ]

        /// <summary>
        /// EP_XM30411
        /// </summary>
        public EP_XM30411()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = true;
        }

        /// <summary>
        /// Page_Load
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!X.IsAjaxRequest)
                {
                    HEParameterSet paramSet_Category = new HEParameterSet();
                    DataSet source_Category = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_EP_XM20410", "INQUERY_CATEGORY"), paramSet_Category);
                    Library.ComboDataBind(this.cbo01_CATEGORY, source_Category.Tables[0], true, "NAME", "ID", true, "ALL"); 
                    Reset();
                }
            }
            catch //(Exception ex)
            {
                // excel 다운로드는 메시지 처리 하지 않음
                //this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        #endregion

        #region [ 버튼설정 ]

        /// <summary>
        /// BuildButtons
        /// 기본 버튼생성
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Search, ButtonImage.Search, "Search", this.ButtonPanel);
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);            
            MakeButton(ButtonID.Close, ButtonImage.Close, "Close", this.ButtonPanel);
        }

        /// <summary>
        /// MakeButton
        /// </summary>
        /// <param name="id"></param>
        /// <param name="image"></param>
        /// <param name="alt"></param>
        /// <param name="container"></param>
        /// <param name="isUpload"></param>
        public void MakeButton(string id, string image, string alt, Ext.Net.Panel container, bool isUpload = false)
        {
            Ext.Net.ImageButton ibtn = CreateImageButton(id, image, alt, isUpload);

            if (id == ButtonID.Search || id == ButtonID.M_Search)
            {
                ibtn.DirectEvents.Click.EventMask.ShowMask = true;
                ibtn.DirectEvents.Click.EventMask.Target = MaskTarget.CustomTarget;
                ibtn.DirectEvents.Click.EventMask.CustomTarget = "Grid02";
                ibtn.DirectEvents.Click.EventMask.Msg = "Loading Data...";
            }
            container.Add(ibtn);
        }

        /// <summary>
        /// Button_Click
        /// 기본 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public override void Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.ImageButton ibtn = (Ext.Net.ImageButton)sender;

            switch (ibtn.ID)
            {
                case ButtonID.Search:
                    Search();
                    break;
                case ButtonID.Reset:
                    Reset();
                    break;                                    
                case ButtonID.Close:
                    X.Js.Call("closeTab");
                    break;
                default: break;
            }
        }

        /// <summary>
        /// etc_Button_Click
        /// 사용자 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void etc_Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.Button btn = (Ext.Net.Button)sender;
            switch (btn.ID)
            {
                case "btn01_SEARCH":
                    TitleSearch();
                    break;
                case "Master_Excel":
                    Excel_Export("M",e);
                    break;
                case "Detail_Excel":
                    Excel_Export("D", e);
                    break;                
                default:
                    break;
            }
        }

        private void TitleSearch()
        {
            try
            {
                InputInit();

                HEParameterSet paramSet = new HEParameterSet();
                paramSet.Add("TITLE", this.txt01_TITLE.Value);
                paramSet.Add("GROUPID", GetPageName());
                paramSet.Add("CATEGORY", this.cbo01_CATEGORY.Value);
                DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", PAKAGE_NAME, "INQUERY"), paramSet);

                Store1.DataSource = source;
                Store1.DataBind();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
                
            }
        }
        private void SearchInit()
        {
            X.Js.Call("ChagnePanel", true);
            txt01_TITLE.SetValue(string.Empty);
            cbo01_CATEGORY.SelectedItem.Value = "";
            cbo01_CATEGORY.UpdateSelectedItems();
            Store1.RemoveAll();
            Panel2.ClearContent();
            Panel2.UpdateContent();
            Panel4.ClearContent();
            Panel4.UpdateContent();
        }

        private void InputInit()
        {
            Store2.RemoveAll();
            Store3.RemoveAll();
            this.cdx01_VENDCD.SetValue(string.Empty);            
            txt01_QUERY.SetValue(string.Empty);
            txt02_QUERY.SetValue(string.Empty);
            txt01_LINK_COLUMN.SetValue(string.Empty);
        }

        #endregion

        #region [ 기능 ]

        /// <summary>
        /// Search
        /// </summary>
        public void Search()
        {
            try
            {                
                Store2.RemoveAll();
                Store3.RemoveAll();
                DataSet ds = GetMaster();
                if (ds == null) return;
                SetGrid(ds, Store2, Grid02);
                
 
                //Reset();
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
            }
            finally
            {
            }
        }

        /// <summary>
        /// Reset
        /// </summary>
        public void Reset()
        {
            SearchInit();
            InputInit(); 
        }


        /// <summary>
        /// Excel_Export
        /// </summary>
        private void Excel_Export(string type, DirectEventArgs e)
        {
            try
            {
                DataSet ds = (type.Equals("M")) ? GetMaster() : GetDetail(e.ExtraParams["Values"]);
                                
                if (ds == null || ds.Tables[0].Rows.Count == 0)
                    this.MsgCodeAlert("COM-00807"); // 출력 또는 내보낼 데이터가 없습니다. 
                else
                    ExcelHelper.ExportExcel(this.Page, ds.Tables[0], true);// (type.Equals("M"))?Grid02:Grid03);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {

            }
        }


        private void Inquery_Detail(string corcd, string doc_no)
        {
            Store2.RemoveAll();
            Store3.RemoveAll();
            Grid02.RemoveAllColumns();
            Grid02.Reconfigure();
            Grid03.RemoveAllColumns();
            Grid03.Reconfigure();

//            Panel2.ClearContent();
            Panel2.UpdateContent();
            Panel4.UpdateContent();

            HEParameterSet paramSet = new HEParameterSet();
            paramSet.Add("CORCD", corcd);
            paramSet.Add("DOC_NO", doc_no);
            DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", PAKAGE_NAME, "INQUERY_DETAIL"), paramSet);

            if (source != null)
            {
                int k = 1;
                Control Hctr = new Control();
                foreach (DataRow dr in source.Tables[0].Rows)
                {
                    string name = dr["PARAM_NM"].ToString();
                    string type = dr["PARAM_TYPE"].ToString();
                    string SORT_SEQ = dr["SORT_SEQ"].ToString();
                    string IS_VALIDATION = dr["IS_VALIDATION"].ToString();
                    string COMM_CODE = dr["COMM_CODE"].ToString();
                    string LANG_CODE = dr["LANG_CODE"].ToString();
                    string DEFAULT_DATA = dr["DEFAULT_DATA"].ToString();
                    bool is_validation_bool = (IS_VALIDATION.Equals("1")) ? false : true;                    

                    string text = string.Empty;
                    if (txt01_APPLY_LANGUAGE.Text.Equals("Y"))
                    {
                        text = string.IsNullOrEmpty(Library.getLabel("", LANG_CODE, UserInfo.LanguageShort)) ? LANG_CODE : Library.getLabel("", LANG_CODE, UserInfo.LanguageShort);
                    }
                    else //다국어 적용하지 않는다.
                    {
                        text = name;
                    }


                    txt01_QUERY.SetValue(dr["SCRIPT_QUERY"].ToString());
                    txt02_QUERY.SetValue(dr["SUB_QUERY"].ToString());
                    txt01_LINK_COLUMN.SetValue(dr["LINK_COLUMN"].ToString());

                    if (string.IsNullOrEmpty(txt01_LINK_COLUMN.Value.ToString()))
                    {
                        X.Js.Call("ChagnePanel",true);
                    }
                    else
                    {
                        X.Js.Call("ChagnePanel",false);
                    }
                    
                    if (!string.IsNullOrEmpty(name))
                    {

                        Ext.Net.Label ctr_label = new Ext.Net.Label();
                        Ext.Net.Label ctr_valid_text = new Ext.Net.Label();                        

                        ctr_label.ID = "lbl01_" + name;
                        //ctr_label.ItemID = "lbl01_" + name;
                        ctr_label.Dock = Dock.Left;
                        ctr_label.Text = text;//string.IsNullOrEmpty(Library.getLabel("", LANG_CODE, UserInfo.LanguageShort)) ? LANG_CODE : Library.getLabel("", LANG_CODE, UserInfo.LanguageShort);
                        ctr_label.Width = 200;
                        ctr_label.Height = 25;
                        ctr_label.StyleSpec = "vertical-align: middle;";

                        Ext.Net.TextField ctr_valid = new Ext.Net.TextField
                        {
                            ID = "ctr_vali_" + name,
                            ItemID = "ctr_vali_" + name,
                            Width = 0,
                            Height = 0,
                            X = -100,
                            Visible = true,
                            Cls = "inputText"
                            
                        };

                        Ext.Net.TextField ctr_valid_lbl = new Ext.Net.TextField
                        {
                            ID = "ctr_vali_lbl_" + name,
                            ItemID = "ctr_vali_lbl_" + name,
                            Width = 0,
                            Height = 0,
                            X = -100,
                            Visible = true,
                            Cls = "inputText",
                            Text = string.IsNullOrEmpty(Library.getLabel("", LANG_CODE, UserInfo.LanguageShort)) ? LANG_CODE : Library.getLabel("", LANG_CODE, UserInfo.LanguageShort)

                        };

                        ctr_valid_text.ID = "lbl03_" + name;
                        ctr_valid_text.ItemID = "lbl03_" + name;
                        ctr_valid_text.Dock = Dock.Left;
                        ctr_valid_text.Width = 200;
                        ctr_valid_text.Height = 25;

                        if (IS_VALIDATION.ToString().Equals("1"))
                        {
                            ctr_valid_text.Text = " (*)";
                            ctr_valid_text.StyleSpec = "color:red;vertical-align: middle;";                            
                            ctr_valid.Text = IS_VALIDATION;
                        }

                        Ext.Net.FieldContainer fc = new Ext.Net.FieldContainer();
                        fc.Layout = "TableLayout";
                        fc.ID = "FieldContainer" + k;
                        fc.ItemID = "FieldContainer" + k;
                        fc.MsgTarget = MessageTarget.Side;
                        fc.StyleSpec = "background-color:LightGray;";
                        fc.Width = 400;
                        fc.Height = 25;

                        if (!type.Equals("VENDCD"))
                        {
                            fc.ContentControls.Add(ctr_label); fc.ContentControls.Add(ctr_valid_text);
                            fc.AddTo(Panel2);                                               
                        }
                        
                        ctr_valid.AddTo(Panel4);
                        ctr_valid_lbl.AddTo(Panel4);


                        //동적 생성
                        if (type.Equals("CORCD"))
                        {
                            Ext.Net.ComboBox ctr = new Ext.Net.ComboBox();
                            SetCombobox(ctr, "CORCDTYPE", "CORCD", name, "combo", is_validation_bool, COMM_CODE, type, UserInfo.CorporationCode);                            
                        }
                        else if (type.Equals("BIZCD"))
                        {
                            Ext.Net.ComboBox ctr = new Ext.Net.ComboBox();
                            SetCombobox(ctr, "BIZNM", "BIZCD", name, "combo", is_validation_bool, COMM_CODE, type, UserInfo.BusinessCode);                            

                        }
                        else if (type.Equals("DATE"))
                        {
                            Ext.Net.DateField ctr = new Ext.Net.DateField();
                            ctr.ID = "ctr_" + name;
                            ctr.Width = 395;
                            ctr.Tag = "date";
                            ctr.Format = "yyyy-MM-dd";
                            ctr.Value = DEFAULT_DATA;
                            ctr.AddTo(Panel2);
                        }
                        else if (type.Equals("MONTH"))
                        {
                            Ext.Net.DateField ctr = new Ext.Net.DateField();
                            ctr.ID = "ctr_" + name;
                            ctr.Width = 395;
                            ctr.Tag = "date";
                            ctr.Format = "yyyy-MM";
                            ctr.Value = DEFAULT_DATA;
                            ctr.AddTo(Panel2);
                        }
                        else if (type.Equals("YEAR"))
                        {
                            Ext.Net.DateField ctr = new Ext.Net.DateField();
                            ctr.ID = "ctr_" + name;
                            ctr.Width = 395;
                            ctr.Tag = "date";
                            ctr.Format = "yyyy";
                            ctr.Value = DEFAULT_DATA;
                            ctr.AddTo(Panel2);
                        }
                        else if (type.Equals("CODE_COMBO"))
                        {
                            Ext.Net.ComboBox ctr = new Ext.Net.ComboBox();
                            SetCombobox(ctr, "OBJECT_NM", "OBJECT_ID", name, "combo", is_validation_bool, COMM_CODE, type, DEFAULT_DATA);                            

                        }
                        else if (type.Equals("USER_COMBO"))
                        {
                            Ext.Net.ComboBox ctr = new Ext.Net.ComboBox();
                            SetCombobox(ctr, "VALUE", "CODE", name, "combo", is_validation_bool, COMM_CODE, type, DEFAULT_DATA);                            
                        }
                        else if (type.Equals("TEXT"))
                        {
                            Ext.Net.TextField ctr = new Ext.Net.TextField
                            {
                                ID = "ctr_" + name,
                                ItemID = "ctr_" + name,
                                Width = 395,
                                Height = 25,
                                Visible = true,
                                Cls = "inputText",
                                Text = DEFAULT_DATA
                            };
                            ctr.AddTo(Panel2);
                        }

                    }
                    else
                    {
                        Panel2.ClearContent();
                        Panel4.ClearContent();
                        Panel2.UpdateContent();
                        Panel4.UpdateContent();
                        Search();
                    }
                    k++;
                }                
                
                //Panel2.UpdateContent();
                //Panel4.UpdateContent();
            }
        }

        private void SetCombobox(ComboBox ctr, string NAME, string CODE, string ID, string TAG, bool IS_VALIDATION, string COMM_CODE, string TYPE, string DEFAULT_DATA)
        {
            ctr.ID = "ctr_" + ID;
            ctr.Width = 395;
            ctr.Dock = Dock.Top;
            ctr.Tag = "combo";
            ctr.QueryMode = DataLoadMode.Local;
            ctr.ForceSelection = true;
            ctr.TriggerAction = TriggerAction.All;
            ctr.Cls = "inputText";
            ctr.DisplayField = NAME;
            ctr.ValueField = CODE;
            Ext.Net.Store store = new Ext.Net.Store();
            store.ID = "Sctr_" + ID;
            Ext.Net.Model model = new Ext.Net.Model();
            model.ID = "Mctr_" + ID;
            model.Fields.Add(NAME);
            model.Fields.Add(CODE);
            store.Model.Add(model);
            ctr.Store.Add(store);
            ctr.Tag = TAG;
            if (TYPE.Equals("BIZCD"))
            {
                Library.GetBIZCD(ctr, UserInfo.CorporationCode, IS_VALIDATION);                
            }
            else if (TYPE.Equals("CORCD"))
            {
                Library.GetCORCD(ctr, IS_VALIDATION);                
            }
            else if (TYPE.Equals("CODE_COMBO"))
            {
                Library.ComboDataBind(ctr, Library.GetTypeCode(COMM_CODE).Tables[0], IS_VALIDATION, NAME, CODE, true);                
                
            }
            else
            {
                string[] commonTypeSource = COMM_CODE.Split(',');
                DataTable dt = new DataTable();
                dt.Columns.Add("CODE");
                dt.Columns.Add("VALUE");
                for (int i = 0; i < commonTypeSource.Length; i++)
                {
                    dt.Rows.Add(commonTypeSource[i], commonTypeSource[i]);
                }
                Library.ComboDataBind(ctr, dt, IS_VALIDATION, NAME, CODE, true);
                
            }
            ctr.SelectedItem.Value = DEFAULT_DATA;
            ctr.UpdateSelectedItems();
            ctr.AddTo(Panel2);
            
        }


        private void SetGrid(DataSet source, Store Store, Ext.Net.GridPanel Grid)
        {
            string text = "";

            for (int i = 0; i < source.Tables[0].Columns.Count; i++)
            {
                if (txt01_APPLY_LANGUAGE.Text.Equals("Y")) text = Library.getLabel(GetPageName(), source.Tables[0].Columns[i].ColumnName, this.UserInfo.LanguageShort);
                else text = source.Tables[0].Columns[i].ColumnName;

                ModelField field = new ModelField(source.Tables[0].Columns[i].ColumnName, ModelFieldType.String);

                Store.AddField(field, 0); Store.Model[0].Fields.Insert(0, field);

                Ext.Net.Column col = new Ext.Net.Column();
                if (source.Tables[0].Columns[i].DataType == typeof(decimal) || source.Tables[0].Columns[i].DataType == typeof(int)
                    || source.Tables[0].Columns[i].DataType == typeof(float) || source.Tables[0].Columns[i].DataType == typeof(double)
                    || source.Tables[0].Columns[i].DataType == typeof(long))
                {
                    col.Align = ColumnAlign.End;
                }
                else
                {
                    col.Align = ColumnAlign.Start;
                }
                col.Width = 120;
                col.ID = source.Tables[0].Columns[i].ColumnName;
                col.ItemID = source.Tables[0].Columns[i].ColumnName;
                col.DataIndex = source.Tables[0].Columns[i].ColumnName;
                col.Text =  string.IsNullOrEmpty(text) ? source.Tables[0].Columns[i].ColumnName : text;
                col.Sortable = true;
                Grid.AddColumn(col);
            }
            Store.DataSource = source;
            Store.DataBind();
            Grid.Reconfigure();
        }

        public string GetPageName()
        {
            string path = System.Web.HttpContext.Current.Request.Url.AbsolutePath;
            System.IO.FileInfo info = new System.IO.FileInfo(path);
            return info.Name.Split('.')[0];
        }


        private DataSet GetMaster()
        {
            String query = txt01_QUERY.Value.ToString();
            if (string.IsNullOrEmpty(query))
            {
                Alert("Please select one of subjets.");
                return null;
            }
            
            query = query.Replace(":IN_CORCD", "'" + this.UserInfo.CorporationCode + "'");
            query = query.Replace(":IN_LANG_SET", "'" + this.UserInfo.Language + "'");
            query = query.Replace(":IN_VENDCD", "'" + this.cdx01_VENDCD.Value + "'");

            HEParameterSet paramSet1 = new HEParameterSet();
            paramSet1.Add("CORCD", txt01_CORCD.Value);
            paramSet1.Add("DOC_NO", txt01_DOCNO.Value);
            DataSet source1 = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", PAKAGE_NAME, "INQUERY_DETAIL"), paramSet1);

            HEParameterSet paramSet = new HEParameterSet();
            if (source1 != null)
            {
                foreach (DataRow dr in source1.Tables[0].Rows)
                {
                    if (!string.IsNullOrEmpty(dr["PARAM_NM"].ToString()))
                    {
                        if (dr["PARAM_NM"].Equals("VENDCD"))
                        {
                            if (this.Request["ctr_vali_" + dr["PARAM_NM"]].ToString().Equals("1") && string.IsNullOrEmpty(this.cdx01_VENDCD.Value.ToString()))
                            {
                                MsgCodeAlert_ShowFormat("CD00-0079", "", this.lbl01_VEND.Text);
                                return null;
                            }
                        }
                        else
                        {
                            if (this.Request["ctr_vali_" + dr["PARAM_NM"]].ToString().Equals("1") && string.IsNullOrEmpty(this.Request["ctr_" + dr["PARAM_NM"]].ToString()))
                            {
                                MsgCodeAlert_ShowFormat("CD00-0079", "", this.Request["ctr_vali_lbl_" + dr["PARAM_NM"]].ToString());
                                return null;
                            }
                        }

                        if (query.IndexOf(":IN_" + dr["PARAM_NM"]) >= 0)
                        {
                            //ctr_VEND_TYPE-inputEl
                            //JSON.Deserialize<Dictionary<string, object>[]>(Request["_ctr_"+dr["PARAM_NM"]+"_state"])[0]["value"]
                            if (dr["PARAM_TYPE"].ToString().Equals("CORCD") || dr["PARAM_TYPE"].ToString().Equals("BIZCD") || dr["PARAM_TYPE"].ToString().Equals("CODE_COMBO") || dr["PARAM_TYPE"].ToString().Equals("USER_COMBO"))
                            {
                                paramSet.Add(dr["PARAM_NM"].ToString(), JSON.Deserialize<Dictionary<string, object>[]>(Request["_ctr_" + dr["PARAM_NM"] + "_state"])[0]["value"].ToString());
                            }
                            else if (dr["PARAM_TYPE"].ToString().Equals("DATE") && !string.IsNullOrEmpty(Request["ctr_" + dr["PARAM_NM"]].ToString()))
                            {
                                paramSet.Add(dr["PARAM_NM"].ToString(), DateTime.Parse(Request["ctr_" + dr["PARAM_NM"]].ToString()).ToString("yyyy-MM-dd"));
                            }
                            else if (dr["PARAM_TYPE"].ToString().Equals("MONTH") && !string.IsNullOrEmpty(Request["ctr_" + dr["PARAM_NM"]].ToString()))
                            {
                                paramSet.Add(dr["PARAM_NM"].ToString(), DateTime.Parse(Request["ctr_" + dr["PARAM_NM"]].ToString()).ToString("yyyy-MM"));
                            }
                            //else if (dr["PARAM_TYPE"].ToString().Equals("VENDCD"))
                            //{
                            //    paramSet.Add(dr["PARAM_NM"].ToString(), this.cdx01_VENDCD.Value);
                            //}  
                            else
                            {
                                paramSet.Add(dr["PARAM_NM"].ToString(), Request["ctr_" + dr["PARAM_NM"]]).ToString();
                            }
                        }
                    }
                }
            }
            return EPClientHelper.ExecuteDataSet("$SQL$BEGIN OPEN :OUT_CURSOR FOR " + query.ToUpper().Replace("FROM", " FROM ").Replace("WHERE"," WHERE ").Replace(";","") + ";  END;", paramSet);

        }

        #endregion

        #region [ 유효성 검사 ]

        #endregion

        #region [ 이벤트 ]

        /// <summary>
        /// RowSelect
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RowSelect(object sender, DirectEventArgs e)
        {
            try
            {
                //InputInit();

                string json = e.ExtraParams["Values"];
                Dictionary<string, object>[] parameters = JSON.Deserialize<Dictionary<string, object>[]>(json);

                if (parameters.Length > 0)
                {
                    txt01_CORCD.Text = parameters[0]["CORCD"].ToString();
                    txt01_DOCNO.Text = parameters[0]["DOC_NO"].ToString();
                    txt01_APPLY_LANGUAGE.Text = parameters[0]["APPLY_LANGUAGE"].ToString();
                    this.Inquery_Detail(parameters[0]["CORCD"].ToString(), parameters[0]["DOC_NO"].ToString());
                }

            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen

            }
            finally
            {
            }
        }

        /// <summary>
        /// 상단의 그리드 클릭시
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RowSelect2(object sender, DirectEventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(txt01_LINK_COLUMN.Text))
                {
                    Store3.RemoveAll();
                    string json = e.ExtraParams["Values"];
                    DataSet ds = GetDetail(json);
                    if (ds != null) SetGrid(ds, Store3, Grid03);
                }

            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen

            }
            finally
            {
            }
        }

        private DataSet GetDetail(string json)
        {
            Dictionary<string, object>[] parameters = JSON.Deserialize<Dictionary<string, object>[]>(json);

            if (parameters.Length > 0)
            {

                String query = txt02_QUERY.Value.ToString();
                String link_column = txt01_LINK_COLUMN.Value.ToString();

                if (query.IndexOf(":IN_LANG_SET") >= 0 && link_column.IndexOf("LANG_SET") < 0)
                {   
                    query = query.Replace(":IN_LANG_SET", "'" + this.UserInfo.Language + "'");
                }

                HEParameterSet paramSet = new HEParameterSet();


                for (int i = 0; i < link_column.Split(',').Length; i++)
                {
                    if (query.IndexOf(":IN_" + link_column.Split(',')[i].Trim()) >= 0)
                    {
                        if (json.Contains(link_column.Split(',')[i].Trim()))
                            paramSet.Add(link_column.Split(',')[i].Trim(), parameters[i][link_column.Split(',')[i].Trim()].ToString());
                    }
                }
                return EPClientHelper.ExecuteDataSet("$SQL$BEGIN OPEN :OUT_CURSOR FOR " + query.ToUpper().Replace("FROM", " FROM ").Replace("WHERE", " WHERE ").Replace(";", "") + ";  END;", paramSet);                

            }
            return null;

        }

        #endregion

    }

}
