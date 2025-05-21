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
    /// <b>팝업 > 검사 성적서등록 </b>
    /// - 작 성 자 : 배명희<br />
    /// - 작 성 일 : 2014-09-02<br />
    /// </summary>
    public partial class SRM_QA23001P1 : BasePage
    {
        #region [초기설정]
        /// <summary>
        /// PopCustItemcdGrid 생성자
        /// </summary>
        public SRM_QA23001P1()
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
                    this.hiddenBIZCD.Value = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    this.hiddenBARCODE.Value = HttpUtility.ParseQueryString(sQuery).Get("BARCODE");
                    this.hiddenVENDCD.Value = HttpUtility.ParseQueryString(sQuery).Get("VENDCD");
                    this.hiddenQTY.Value = HttpUtility.ParseQueryString(sQuery).Get("QTY");
                    this.hiddenNOTE_TYPE.Value = HttpUtility.ParseQueryString(sQuery).Get("NOTE_TYPE");
                    if (this.hiddenNOTE_TYPE.Value.Equals("S"))
                        btn01_ALL.Visible = true; //서열데이터인 경우에만 버튼 표시
                    else
                        btn01_ALL.Visible = false;//납품전표 데이터인 경우에는 버튼 표시안함.
                    this.txt01_PARTNO.Text = HttpUtility.ParseQueryString(sQuery).Get("PARTNO");
                    this.txt01_DD.Text = HttpUtility.ParseQueryString(sQuery).Get("DELI_DATE");
                    this.txt01_CHASU.Text = HttpUtility.ParseQueryString(sQuery).Get("DELI_CNT");
                    this.hiddenLINENM.Value = HttpUtility.ParseQueryString(sQuery).Get("LINENM");
                    this.hiddenVINNM.Value = HttpUtility.ParseQueryString(sQuery).Get("VINNM");
                    this.hiddenMAT_ITEMNM.Value = HttpUtility.ParseQueryString(sQuery).Get("MAT_ITEMNM");
                    this.hiddenINSTALL_POSNM.Value = HttpUtility.ParseQueryString(sQuery).Get("INSTALL_POSNM");
                   
                    //데이터 조회하여 표시
                    this.GridDataBind();

                    //샘플검사 수 항목에 값이 없으면 20개로 설정
                    if (this.hiddenINP_COUNT.Text.Equals(string.Empty))
                        this.hiddenINP_COUNT.Text = "20";

                    //this.hiddenINP_COUNT.Text = "20";//★★★★★
                    
                    //검사성적서 입력 건수에 따른 컬럼 및 체크박스 표시/비표시 처리
                    SetGridColumn(Convert.ToInt32(this.hiddenINP_COUNT.Text));
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
                //저장시 모든 데이터 넘겨받도록함.
                ibtn.DirectEvents.Click.ExtraParams.Add(
                new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues(false)", Mode = ParameterMode.Raw, Encode = true });
            }
            container.Add(ibtn);

        }


        /// <summary>
        /// 검사항목수에 따른 불필요한 컬럼&체크박스 안보이게 처리.
        /// </summary>
        /// <param name="inp_count"></param>
        private void SetGridColumn(int inp_count)
        {
            //x1 ~ x20 까지 모두 visible=true상태.
            //inp_count에 따라 불필요한 컬럼 visible=false 처리해준다.
            //(inp_count는 검사항목수, 납품수량 구간에 따라 검사해야할 항목수가 1개부터 20까지 있음. 검사항목수까지만 판정입력할수 있도록 하기 위해)
            //예) inp_count가 5이면 x6~x20 은 visible=false
            //예) inp_count가 3이면 x4~x20 은 visible=false
            if (inp_count < 1) this.chk01_ALL.Visible = false;

            for (int i = inp_count + 1; i <= 20; i++)
            {
                this.FindControl("chk01_X" + i.ToString()).Visible = false;
                this.Grid01.ColumnModel.GetColumnByDataIndex("X" + i.ToString()).Visible = false;
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
              
                default: break;
            }
        }

        /// <summary>
        /// etc_Button_Click
        /// 사용자 정의 버튼 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        [DirectMethod]
        public void etc_Button_Click()
        {         
            SaveAll();                               
        }

        #endregion

        #region [기능]

        /// <summary>
        /// 검사항목 목록 그리드 바인딩
        /// 입고품 불량이력 현황 그리드 바인딩
        /// 제품사진 및 규격사진 display
        /// </summary>
        public void GridDataBind()
        {
            try
            {
                DataSet result = null;
                HEParameterSet param = new HEParameterSet();

                //성적서입력 그리드
                param.Add("BARCODE", this.hiddenBARCODE.Text);
                param.Add("QTY", this.hiddenQTY.Text);
                param.Add("CORCD", this.UserInfo.CorporationCode);
                param.Add("BIZCD", this.hiddenBIZCD.Text);
                param.Add("PARTNO", this.txt01_PARTNO.Text);  
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);
                result = EPClientHelper.ExecuteDataSet("APG_SRM_QA23001.INQUERY_INSPECT_LIST", param);
                this.Store1.DataSource = result.Tables[0];
                this.Store1.DataBind();


                //결과입력건수
                if (result.Tables[0].Rows.Count > 0)
                    hiddenINP_COUNT.Text = result.Tables[0].Rows[0]["INP_COUNT"].ToString();


                //입고품 불량 이력 현황
                param = new HEParameterSet();
                param.Add("CORCD", this.UserInfo.CorporationCode);
                param.Add("BIZCD", this.hiddenBIZCD.Text);
                param.Add("VENDCD", this.hiddenVENDCD.Text);
                param.Add("PARTNO", this.txt01_PARTNO.Text);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);
                result = EPClientHelper.ExecuteDataSet("APG_SRM_QA23001.INQUERY_HISTORY", param);
                this.Store2.DataSource = result.Tables[0];
                this.Store2.DataBind();

                
                //제품사진 정보
                param = new HEParameterSet();
                param.Add("CORCD", this.UserInfo.CorporationCode);
                param.Add("BIZCD", this.hiddenBIZCD.Text);                
                param.Add("PARTNO", this.txt01_PARTNO.Text);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                param.Add("USER_ID", this.UserInfo.UserID);
                result = EPClientHelper.ExecuteDataSet("APG_SRM_QA23001.INQUERY_PHOTO", param);

                if (result.Tables[0].Rows.Count > 0)
                {

                    DataRow dr = result.Tables[0].Rows[0];

                    //1.품명
                    txt01_PARTNM.Text = dr["PARTNM"].ToString();

                    //2.제품사진
                    if (dr["PARTNO_PHOTO"] == DBNull.Value)
                    {
                        img01_PARTNO.ImageUrl = CommonString.NoImage;
                    }
                    else
                    {                        
                        img01_PARTNO.ImageUrl = Util.FileEncoding((byte[])dr["PARTNO_PHOTO"], true);
                    }

                    //3.규격사진
                    if (dr["INSPECT_STD_PHOTO"] == DBNull.Value)
                    {
                        img01_STANDARD.ImageUrl = CommonString.NoImage;
                    }
                    else
                    {
                        img01_STANDARD.ImageUrl = Util.FileEncoding((byte[])dr["INSPECT_STD_PHOTO"], true);
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
        /// 검사 성적서 입력 결과값 입력 및 판정내용 저장
        /// </summary>
        /// <param name="e"></param>
        public void Save(DirectEventArgs e)
        {
            string json = e.ExtraParams["Values"];
            Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

            if (parameters.Length == 0)
            {
                this.MsgCodeAlert("COM-00020");
                return;
            }
            //삭제용 데이터셋 생성
            DataSet remove = Util.GetDataSourceSchema
            (
               "BARCODE", "VENDCD", "LANG_SET", "USER_ID"
            );

            //저장용 데이터셋 생성
            DataSet save = Util.GetDataSourceSchema
            (
                "CORCD", "BIZCD", "INSPECT_CLASSCD", "INSPECT_SEQ", "BARCODE", "VENDCD",
                "PARTNO", "DELI_DATE", "DELI_CNT", "QTY", "SAMPLE_CNT", 
                "X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8", "X9", "X10",
                "X11", "X12", "X13", "X14", "X15", "X16", "X17", "X18", "X19", "X20", "JUD_RESULT",
                "LANG_SET", "USER_ID"
            );

            remove.Tables[0].Rows.Add
            (
                this.hiddenBARCODE.Text,
                this.hiddenVENDCD.Text,
                this.UserInfo.LanguageShort,
                this.UserInfo.UserID
            );

            for (int i = 0; i < parameters.Length; i++)
            {
                save.Tables[0].Rows.Add
                (
                    parameters[i]["CORCD"],    
                    parameters[i]["BIZCD"],
                    parameters[i]["INSPECT_CLASSCD"],
                    parameters[i]["INSPECT_SEQ"],
                    this.hiddenBARCODE.Text,
                    this.hiddenVENDCD.Text,
                    this.txt01_PARTNO.Text,
                    this.txt01_DD.Text,
                    this.txt01_CHASU.Text,
                    this.hiddenQTY.Text,
                    this.hiddenINP_COUNT.Text,
                    parameters[i]["X1"],
                    parameters[i]["X2"],
                    parameters[i]["X3"],
                    parameters[i]["X4"],
                    parameters[i]["X5"],
                    parameters[i]["X6"],
                    parameters[i]["X7"],
                    parameters[i]["X8"],
                    parameters[i]["X9"],
                    parameters[i]["X10"],
                    parameters[i]["X11"],
                    parameters[i]["X12"],
                    parameters[i]["X13"],
                    parameters[i]["X14"],
                    parameters[i]["X15"],
                    parameters[i]["X16"],
                    parameters[i]["X17"],
                    parameters[i]["X18"],
                    parameters[i]["X19"],
                    parameters[i]["X20"],
                    parameters[i]["JUD_RESULT"],
                    this.UserInfo.LanguageShort,
                    this.UserInfo.UserID
                );

                //유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
                if (!IsSaveValid(save.Tables[0].Rows[i], i+1))
                {
                    return;
                }
            }

            string[] procedure = new string[] { string.Format("{0}.{1}", "APG_SRM_QA23001", "REMOVE"),
                                                string.Format("{0}.{1}", "APG_SRM_QA23001", "SAVE")};
            DataSet[] param = new DataSet[] {remove, save};



            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.MultipleExecuteNonQueryTx(procedure, param);

                this.MsgCodeAlert("COM-00902");
                this.GridDataBind();
                X.Js.Call("parent.fn_GridSetInputY");  //부모창의 해당 레코드 입력여부 컬럼의 값을 Y로 변경
            }
        }

        /// <summary>
        /// 검사 성적서 일괄 합격 처리
        /// </summary>
        public void SaveAll()
        {
           
            //해당 차수 성적서 일괄 등록
            HEParameterSet set = new HEParameterSet();
            set.Add("CORCD", this.UserInfo.CorporationCode);
            set.Add("BIZCD", this.hiddenBIZCD.Text);
            set.Add("VENDCD", this.hiddenVENDCD.Text);
            set.Add("INPUT_DATE", this.txt01_DD.Text);
            set.Add("BARCODE", this.hiddenBARCODE.Text);
            set.Add("JIS_CNT", this.txt01_CHASU.Text);
            set.Add("LANG_SET", this.UserInfo.LanguageShort);
            set.Add("USER_ID", this.UserInfo.UserID);


            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx("APG_SRM_QA23001.SAVE_ALL", set);
                this.MsgCodeAlert("COM-00902");
                this.GridDataBind();
                X.Js.Call("parent.fn_GridSetInputYAll");  //부모창의 동일차수 레코드 입력여부 컬럼의 값을 Y로 변경
            }
        }

        #endregion

        #region [ 유효성 검사 ]

        /// <summary>
        /// 샘플입력 갯수(INP_COUNT) 에 맞춰서 해당 컬럼은 반드시 성적입력하도록 
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="actionRow"></param>
        /// <returns></returns>
        public bool IsSaveValid(DataRow parameter, int actionRow)
        {

            int inp_count = Convert.ToInt32(this.hiddenINP_COUNT.Value);
            
            for (int i = 1; i <= inp_count; i++)
            {
                if (String.IsNullOrEmpty(parameter["X" + i.ToString()].ToString()) || parameter["X" + i.ToString()].ToString().Trim().Equals(""))
                {
                    this.MsgCodeAlert_ShowFormat("SRM_QA23001_001", actionRow);
                    return false;
                }
            }

            return true;
        }

        #endregion


    }
}