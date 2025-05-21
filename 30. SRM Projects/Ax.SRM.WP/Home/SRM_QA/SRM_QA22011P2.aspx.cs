using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Ax.EP.Utility;
using HE.Framework.Core;
using System.Data;
using System.IO;

namespace Ax.EP.WP.Home.SRM_QA
{
    /// <summary>
    /// <b>팝업 > 측정 데이터 등록/조회 상세등록 </b>
    /// - 작 성 자 : 배명희<br />
    /// - 작 성 일 : 2014-09-02<br />
    /// </summary>
    public partial class SRM_QA22011P2 : BasePage
    {
        #region [초기설정]
        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_QA22011P2()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.AutoVisibleByAuthority = false;
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
                this.hiddenLANG_SET.Text = this.UserInfo.LanguageShort;

                if (!IsPostBack)
                {
                    string sQuery = Request.Url.Query;
                    
                    //부모창으로부터 전달받은 값 숨김필드 및 각종필드에 저장                
                    this.hiddenBIZCD.Value = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");         //사업장
                    this.hiddenVENDCD.Value = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");       //업체코드
                    this.hiddenYM.Value = HttpUtility.ParseQueryString(sQuery).Get("YM");               //작성년월 YYYY-MM형태
                    this.hiddenCARTYPE.Value = HttpUtility.ParseQueryString(sQuery).Get("CARTYPE");     //차종
                    this.hiddenITEMCODE.Value = HttpUtility.ParseQueryString(sQuery).Get("ITEMCODE");   //품목
                    this.hiddenMEASCD.Value = HttpUtility.ParseQueryString(sQuery).Get("MEASCD");       //품명(검사분류코드)
                    this.hiddenSEARCHGB.Value = HttpUtility.ParseQueryString(sQuery).Get("SEARCHGB");   //사용여부(YES/NO)
                    this.hiddenSERIAL.Value = HttpUtility.ParseQueryString(sQuery).Get("SERIAL");       //SERIAL
                    this.txt01_WRITE_MONTH.Text = HttpUtility.ParseQueryString(sQuery).Get("YM");       //작성년월 화면 표시용
                   
                    //데이터 조회하여 표시
                    this.GridDataBind();

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
        /// BuildButtons
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton(ButtonID.Reset, ButtonImage.Reset, "Reset", this.ButtonPanel);
            MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);            
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
            if (id.Equals(ButtonID.Save)) 
            {
                //저장할것인지 확인 메시지 추가.
                ibtn.DirectEvents.Click.Confirmation.ConfirmRequest = true;
                ibtn.DirectEvents.Click.Confirmation.Title = "Confirm";
                ibtn.DirectEvents.Click.Confirmation.Message = "Do you want save?";
                //저장시 GRID02 그리드의 모든 데이터 넘겨받도록함.
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid02.getRowsValues(false)", Mode = ParameterMode.Raw, Encode = true });
            }
            container.Add(ibtn);

        }


        /// <summary>
        /// 공정능력/X-BAR R관리 측정치 입력컨트롤 표시/비표시 설정.
        /// 측정단위가 OK/NG로 선택할수 있는 경우에는 화면에 콤보상자 표시.
        /// 측정단위가 수치인 경우에는 화면에 텍스트필드 표시.
        /// 샘플링수만큼만 입력 컨트롤 표시(나머지는 숨김 처리)
        /// </summary>
        /// <param name="inp_count"></param>
        private void SetControlDisplay(DataSet source)
        {
            string MEAS_UNIT = "";  //측정단위
            int SAMPLE_CNT = 0;     //샘플링수

            if (source.Tables[0].Rows.Count > 0)
            {
                MEAS_UNIT = source.Tables[0].Rows[0]["MEAS_UNIT"].ToString();
                hiddenMEAS_UNIT.SetValue(MEAS_UNIT);
                SAMPLE_CNT = Convert.ToInt32(source.Tables[0].Rows[0]["SAMPLE_CNT"]);
            }

            for (int i = 1; i <= 20; i++)
            {
                if (i > SAMPLE_CNT)
                {
                    this.FindControl("lbl01_X" + i.ToString()).Visible = false;
                    this.FindControl("txt01_DATA" + i.ToString()).Visible = false;
                    this.FindControl("cbo01_DATA" + i.ToString()).Visible = false;
                    this.FindControl("tf01_MEAS_TIME" + i.ToString()).Visible = false;
                }
                else
                {
                    if (MEAS_UNIT.Equals("IUOKNG"))
                    {
                        this.FindControl("txt01_DATA" + i.ToString()).Visible = false;
                    }
                    else
                    {
                        this.FindControl("cbo01_DATA" + i.ToString()).Visible = false;
                    }
                }
            }
        }

        #endregion

        #region [이벤트]
        /// <summary>
        /// Button_Click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public override void Button_Click(object sender, DirectEventArgs e)
        {
            Ext.Net.ImageButton ibtn = (Ext.Net.ImageButton)sender;
            switch (ibtn.ID)
            {
                case ButtonID.Save:
                    Save(e);
                    break;
                case ButtonID.Reset:
                    Reset();
                    break;   
                default: break;
            }
        }

        /// <summary>
        /// 초기화 버튼 클릭시 모든 입력값 초기화 및 편집허용
        /// </summary>
        private void Reset()
        {
            this.df01_WRITE_MONTH.SetValue(string.Empty);
            for (int i = 1; i <= 20; i++)
            {
                TextField txt = (TextField)this.FindControl("txt01_DATA" + i.ToString());
                txt.SetValue(string.Empty);
                txt.ReadOnly = false;
                SelectBox cbo = (SelectBox)this.FindControl("cbo01_DATA" + i.ToString());
                cbo.SelectedItem.Value = string.Empty;
                cbo.UpdateSelectedItems(); //꼭 해줘야한다.
                cbo.ReadOnly = false;
            }
        }

      

        #endregion

        #region [기능]

        /// <summary>
        ///
        /// </summary>
        public void GridDataBind()
        {
            try
            {
                DataSet result = null;

                //공정능력/X-BAR R관리  정보 조회(상단 그리드에 표시)
                HEParameterSet param = new HEParameterSet();
                param.Add("YYYYMM", ((DateTime)this.hiddenYM.Value).ToString("yyyy-MM"));
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.hiddenBIZCD.Value);
                param.Add("VINCD", this.hiddenCARTYPE.Value);
                param.Add("ITEMCD", this.hiddenITEMCODE.Value);
                param.Add("MEAS_ITEMCD", this.hiddenMEASCD.Value);
                param.Add("USE_YN", this.hiddenSEARCHGB.Value);
                param.Add("VENDCD", this.hiddenVENDCD.Value);
                param.Add("SERIAL", this.hiddenSERIAL.Value);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);

                result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_QA22011", "INQUERY"), param);
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();

                //샘플링수와 측정단위를 참조하여 값 입력 컨트롤 표시/비표시 처리
                this.SetControlDisplay(result);

                //공정능력/X-BAR R관리 측정치 HISTORY 조회(하단 그리드에 표시)
                param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.hiddenBIZCD.Value);
                param.Add("YYYYMM", ((DateTime)this.hiddenYM.Value).ToString("yyyy-MM"));
                param.Add("SERIAL", this.hiddenSERIAL.Value);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);
                result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_QA22011", "INQUERY_MEAS_LIST"), param);
                this.Store2.DataSource = result.Tables[0];
                this.Store2.DataBind();


                //공정능력/X-BAR R관리 기준사진 정보
                param = new HEParameterSet();
                param.Add("CORCD", this.UserInfo.CorporationCode);
                param.Add("BIZCD", this.hiddenBIZCD.Text);
                param.Add("SERIAL", this.hiddenSERIAL.Text);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);
                result = EPClientHelper.ExecuteDataSet("APG_SRM_QA22011.INQUERY_MEAS_PHOTO", param);

                if (result.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = result.Tables[0].Rows[0];
                    if (dr["STD_PHOTO"] != DBNull.Value)
                        img01_PARTNO.ImageUrl = Util.FileEncoding((byte[])dr["STD_PHOTO"], true);
                    else
                    {
                        img01_PARTNO.ImageUrl = "/images/etc/no_image.gif";                         //180 x 144
                        //img01_PARTNO.SetSize("180", "144");                       
                        ImagePanel.Height = 170; //높이 사이즈 자동으로 조정되지 않아...왜...?? ㅡ.ㅜ 
                    }
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
        /// 공정능력/X-BAR R관리 측정값 저장
        /// </summary>
        /// <param name="e"></param>
        public void Save(DirectEventArgs e)
        {
            string json = e.ExtraParams["Values"];
            Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

            if (parameters.Length > 0)
            {
                if (!IsSaveValid(parameters[0])) return;
            }
            else
            {
                if (!IsSaveValid(null)) return;
            }
                      
            //저장용 데이터셋 생성
            DataSet save = Util.GetDataSourceSchema
            (
                "CORCD", "BIZCD", "MEAS_DATE",
                "SERIAL", "MEAS_SEQ", "MEAS_METER",
                "LANG_SET", "USER_ID", "MEAS_NAME", "MEAS_TIME"
            );

            for (int i = 1; i <= 20; i++)
            {
                string meas_meter = "";
                string meas_time = "";
                //측정단위에 따른 값 가져오는 컨트롤 찾는 로직 분기
                if (hiddenMEAS_UNIT.Value.Equals("IUOKNG"))
                {
                    SelectBox cbo = (SelectBox)this.FindControl("cbo01_DATA" + i.ToString());
                    if(!cbo.IsEmpty) meas_meter = cbo.Value.ToString();

                    TimeField tfk = (TimeField)this.FindControl("tf01_MEAS_TIME" + i.ToString());
                    meas_time = tfk.Value.ToString();                    
                }
                else
                {                    
                    TextField txt = (TextField)this.FindControl("txt01_DATA" + i.ToString());
                    if(!txt.IsEmpty) meas_meter = txt.Value.ToString();

                    TimeField tfk = (TimeField)this.FindControl("tf01_MEAS_TIME" + i.ToString());
                    meas_time = tfk.Value.ToString();                    
                }

                if (!meas_meter.Equals(string.Empty))
                {
                    save.Tables[0].Rows.Add
                    (
                        this.UserInfo.CorporationCode,
                        this.hiddenBIZCD.Value,
                        ((DateTime)this.df01_WRITE_MONTH.Value).ToString("yyyy-MM-dd"),
                        this.hiddenSERIAL.Value,
                        i.ToString(),
                        meas_meter,
                        this.UserInfo.LanguageShort,
                        this.UserInfo.UserID,
                        this.txt01_MEAS_NAME.Value,
                        meas_time.Substring(0,5).Replace(":", "")
                    );
                }        
            }
                   
            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx("APG_SRM_QA22011.SAVE_MEAS", save);

                this.MsgCodeAlert("COM-00902");
                this.GridDataBind();
                this.Reset();
            }
        }


        #endregion

        #region [ 유효성 검사 ]

        /// <summary>
        /// 
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="actionRow"></param>
        /// <returns></returns>
        public bool IsSaveValid(Dictionary<string, string> param)
        {

            if (this.df01_WRITE_MONTH.IsEmpty)
            {
                this.MsgCodeAlert_ShowFormat("SRMQA00-0001", "df01_WRITE_MONTH");
                return false;
            }

            string meas_year = ((DateTime)this.df01_WRITE_MONTH.Value).ToString("yyyy");
            string meas_date = ((DateTime)this.df01_WRITE_MONTH.Value).ToString("MM-dd");
            string meas_name = this.txt01_MEAS_NAME.Text.ToString().Trim();
            if (meas_year != ((DateTime)this.hiddenYM.Value).ToString("yyyy"))
            {
                //측정 데이터 등록 년도를 다시 확인하세요.
                this.MsgCodeAlert_ShowFormat("SRMQA00-0004", "df01_WRITE_MONTH");
                return false;
            }

            if (meas_name.Length == 0)
            {
                //측정 데이터 등록 년도를 다시 확인하세요.
                this.MsgCodeAlert_ShowFormat("SRMQA00-0045", "txt01_MEAS_NAME", this.lbl01_MEAS_POINT.Text);
                return false;
            }

            //오늘 날짜의 측정값은 수정가능함. 오늘이 아닌 과거나, 미래의 데이터인 경우 기존 데이터 존재하는지 체크함. 수정 불가임. only등록만 가능함. 
            // 20151207 등록된 데이터 외 수정할 수 있도록 변경
            //if (!DateTime.Now.ToString("yyyy-MM-dd").Equals(((DateTime)this.df01_WRITE_MONTH.Value).ToString("yyyy-MM-dd")))
            //{
            //    HEParameterSet set = new HEParameterSet();
            //    set.Add("CORCD", this.UserInfo.CorporationCode);
            //    set.Add("BIZCD", this.hiddenBIZCD.Text);
            //    set.Add("MEAS_DATE", ((DateTime)this.df01_WRITE_MONTH.Value).ToString("yyyy-MM-dd"));
            //    set.Add("SERIAL", this.hiddenSERIAL.Text);
            //    set.Add("LANG_SET", Util.UserInfo.LanguageShort);
            //    set.Add("USER_ID", Util.UserInfo.UserID);
            //    DataSet result = EPClientHelper.ExecuteDataSet("APG_SRM_QA22011.INQUERY_MEAS_EXISTS", set);

            //    if (result.Tables[0].Rows.Count > 0 && Convert.ToInt32(result.Tables[0].Rows[0][0]) > 0)
            //    {                    
            //        //이미 해당 일자에 데이터가 존재합니다. 수정할 수 없습니다.
            //        this.MsgCodeAlert_ShowFormat("SRMQA00-0003", "df01_WRITE_MONTH");
            //        return false;                   
            //    }
            //}

            //if (param != null)
            //{
            //    int isExist = 0;
            //    for (int i = 1; i < 31; i++)
            //    {
            //        if (meas_date == param["D_" + i.ToString().PadLeft(2, '0')].ToString())
            //            isExist++;
            //    }

            //    if (isExist > 0)
            //    {
            //        //이미 해당 일자에 데이터가 존재합니다. 수정할 수 없습니다.
            //        this.MsgCodeAlert_ShowFormat("SRMQA00-0003", "df01_WRITE_MONTH");
            //        return false;

            //    }
            //}

            bool input_cnt =false;

            if (this.hiddenMEAS_UNIT.Value.Equals("IUOKNG"))
            {
                for (int i = 1; i <= 20; i++)
                {
                    SelectBox cbo = (SelectBox)this.FindControl("cbo01_DATA" + i.ToString());
                    if (cbo.Visible && !cbo.IsEmpty)
                    {
                        input_cnt=true;
                        break;
                    }
                   
                }

                if (!input_cnt)
                {
                    //측정 데이터 값을 입력하세요.
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0002", "cbo01_DATA1");
                    return false;
                }
            }
            else
            {                
                for (int i = 1; i <= 20; i++)
                {
                    TextField txt = (TextField)this.FindControl("txt01_DATA" + i.ToString());
                    if (txt.Visible && !txt.IsEmpty)
                    {
                        input_cnt = true;
                        break;
                           
                    }
                    
                }

                if (!input_cnt)
                {
                    //측정 데이터 값을 입력하세요.
                    this.MsgCodeAlert_ShowFormat("SRMQA00-0002", "txt01_DATA1");
                    return false;
                }
                
            }
            
            return true;
        }

        #endregion

        /// <summary>
        /// 더블클릭시 
        /// </summary>
        /// <param name="qty"></param>
        /// <param name="partno"></param>
        /// <param name="barcode"></param>
        /// <param name="deli_date"></param>
        /// <param name="deli_cnt"></param>
        [DirectMethod]
        public void Cell_DoubleClick(string mm_dd)
        {             

            HEParameterSet set = new HEParameterSet();
            
            set.Add("CORCD", this.UserInfo.CorporationCode);
            set.Add("BIZCD", this.hiddenBIZCD.Value);
            set.Add("SERIAL", this.hiddenSERIAL.Value);
            set.Add("MEAS_DATE", ((DateTime)this.hiddenYM.Value).ToString("yyyy-MM") + mm_dd.Substring(2,3));
            set.Add("LANG_SET", this.UserInfo.LanguageShort);
            set.Add("USER_ID", this.UserInfo.UserID);
           
            DataSet result = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", "APG_SRM_QA22011", "INQUERY_MEAS"), set);
           
            if (result.Tables[0].Rows.Count <= 0) return;           
           
            DataRow dr = result.Tables[0].Rows[0];
           
            this.df01_WRITE_MONTH.SetValue(((DateTime)this.hiddenYM.Value).ToString("yyyy-MM") + mm_dd.Substring(2, 3));
            this.txt01_MEAS_NAME.SetValue(dr["MEAS_NAME"]);


           if (hiddenMEAS_UNIT.Value.ToString().Equals("IUOKNG"))
           {
               //콤보상자 값 표시, 값 변경 불가처리
               for (int i = 1; i <= 20; i++)
               {
                   SelectBox cbo = (SelectBox)this.FindControl("cbo01_DATA" + i.ToString());
                   TimeField tf = (TimeField)this.FindControl("tf01_MEAS_TIME" + i.ToString());

                   cbo.SetValue(dr["MEAS_METER" + i.ToString().PadLeft(2, '0')]);

                   Int32 hh = 0;
                   Int32 mm = 0;

                   if (dr["MEAS_TIME" + i.ToString().PadLeft(2, '0')] != null && !dr["MEAS_TIME" + i.ToString().PadLeft(2, '0')].ToString().Equals(""))
                   {
                       hh = Convert.ToInt32(dr["MEAS_TIME" + i.ToString().PadLeft(2, '0')].ToString().Substring(0, 2));
                       mm = Convert.ToInt32(dr["MEAS_TIME" + i.ToString().PadLeft(2, '0')].ToString().Substring(2, 2));
                   }

                   tf.SelectedTime = new TimeSpan(hh, mm, 0);

                   //if (DateTime.Now.ToString("yyyy-MM-dd").Equals(((DateTime)this.df01_WRITE_MONTH.Value).ToString("yyyy-MM-dd")))
                   //{
                   //    cbo.ReadOnly = false; //오늘 날짜의 측정값 수정은 가능함.
                   //    tf.ReadOnly = false;
                   //}
                   //else
                   //{
                   //    cbo.ReadOnly = true; //오늘 이외의 날짜인 경우 측정값 수정 불가.
                   //    tf.ReadOnly = true;
                   //}

                   if (dr["MEAS_METER" + i.ToString().PadLeft(2, '0')].ToString().Trim().Equals(""))
                   {
                       cbo.ReadOnly = false; //오늘 날짜의 측정값 수정은 가능함.
                       tf.ReadOnly = false;
                   }
                   else
                   {
                       cbo.ReadOnly = true; //데이터 없으면 수정가능
                       tf.ReadOnly = true;
                   }
               }            
           }
           else
           {
               //텍스트박스에 값 표시, 값 변경 불가처리
               for (int i = 1; i <= 20; i++)
               {
                   TextField txt = (TextField)this.FindControl("txt01_DATA" + i.ToString());
                   TimeField tf = (TimeField)this.FindControl("tf01_MEAS_TIME" + i.ToString());

                   txt.SetValue(dr["MEAS_METER" + i.ToString().PadLeft(2, '0')].ToString().Trim());

                   Int32 hh = 0;
                   Int32 mm = 0;

                   if (dr["MEAS_TIME" + i.ToString().PadLeft(2, '0')] != null && !dr["MEAS_TIME" + i.ToString().PadLeft(2, '0')].ToString().Equals(""))
                   {
                       hh = Convert.ToInt32(dr["MEAS_TIME" + i.ToString().PadLeft(2, '0')].ToString().Substring(0, 2));
                       mm = Convert.ToInt32(dr["MEAS_TIME" + i.ToString().PadLeft(2, '0')].ToString().Substring(2, 2));
                   }

                   tf.SelectedTime = new TimeSpan(hh, mm, 0);

                   //if (DateTime.Now.ToString("yyyy-MM-dd").Equals(((DateTime)this.df01_WRITE_MONTH.Value).ToString("yyyy-MM-dd")))
                   //{
                   //    txt.ReadOnly = false; //오늘 날짜의 측정값 수정은 가능함.
                   //    tf.ReadOnly = false;
                   //}
                   //else
                   //{
                   //    txt.ReadOnly = true; //오늘 이외의 날짜인 경우 측정값 수정 불가.
                   //    tf.ReadOnly = true;
                   //}
                   if (dr["MEAS_METER" + i.ToString().PadLeft(2, '0')].ToString().Trim().Equals(""))
                   {
                       txt.ReadOnly = false; //데이터 있으면 수정불가
                       tf.ReadOnly = false;
                   }
                   else
                   {
                       txt.ReadOnly = true; //데이터 없으면 수정가능
                       tf.ReadOnly = true;
                   }
               }
           }
        }
    }
}