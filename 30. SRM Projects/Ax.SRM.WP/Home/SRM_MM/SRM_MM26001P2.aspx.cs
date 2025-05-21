using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using Ax.EP.Utility;
using Ext.Net;
using HE.Framework.Core;

namespace Ax.SRM.WP.Home.SRM_MM
{
    public partial class SRM_MM26001P2 : BasePage
    {
        /// <summary>
        /// <b>자재관리>사급관리>미확정수량 정보(Popup)</b>
        /// - 작 성 자 : 손창현<br />
        /// - 작 성 일 : 2017-08-28<br />
        /// </summary>
        public SRM_MM26001P2()
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
                if (!IsPostBack)
                {
                    string sQuery = Request.Url.Query;
                    tCORCD.Text = HttpUtility.ParseQueryString(sQuery).Get("CORCD");
                    tBIZCD.Text = HttpUtility.ParseQueryString(sQuery).Get("BIZCD");
                    tCUSTCD.Text = HttpUtility.ParseQueryString(sQuery).Get("CUSTCD");
                    tREQ_DATE.Text = HttpUtility.ParseQueryString(sQuery).Get("REQ_DATE");
                    tDIV.Text = HttpUtility.ParseQueryString(sQuery).Get("DIV");
                    tPARTNO.Text = HttpUtility.ParseQueryString(sQuery).Get("PARTNO");
                    string PARTNM = HttpUtility.ParseQueryString(sQuery).Get("PARTNM");
                    string UNIT = HttpUtility.ParseQueryString(sQuery).Get("UNIT");

                    this.txt01_PARTNO.Text = tPARTNO.Text;
                    this.txt01_PARTNM.Text = PARTNM;
                    this.txt01_UNIT.Text = UNIT;

                    Search();
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

        //조회
        public void Search()
        {
            try
            {
                DataSet ds = null;

                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", tCORCD.Text);
                param.Add("BIZCD", tBIZCD.Text);
                param.Add("CUSTCD", tCUSTCD.Text);
                param.Add("REQ_DATE", tREQ_DATE.Text);
                param.Add("DIV", tDIV.Text);
                param.Add("PARTNO", tPARTNO.Text);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);

                ds = EPClientHelper.ExecuteDataSet("APG_SRM_MM26000.INQUERY_POP2", param, "OUT_CURSOR");

                this.Store1.DataSource = ds.Tables[0];
                this.Store1.DataBind();
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
                case "btn01_DELETE":
                    Delete(sender, e);
                    break;
                default:
                    break;
            }
        }

        //삭제처리
        public void Delete(object sender, DirectEventArgs e)
        {
            try
            {
                string json = e.ExtraParams["Values"];
                Dictionary<string, string>[] parameter = JSON.Deserialize<Dictionary<string, string>[]>(json);

                DataSet param = Util.GetDataSourceSchema
                (
                      "CORCD", "BIZCD", "RESALE_REQNO"
                );

                for (int i = 0; i < parameter.Length; i++)
                {
                    if (parameter[i]["CHK"] == "true" || parameter[i]["CHK"] == "1") //체크박스 선택된 정보만 삭제
                    {
                        param.Tables[0].Rows.Add(
                              tCORCD.Text
                            , tBIZCD.Text
                            , parameter[i]["RESALE_REQNO"]
                        );
                    }
                }

                if (param.Tables[0].Rows.Count == 0)
                {
                    this.MsgCodeAlert("COM-00023"); //삭제할 대상 Data가 없습니다.
                    return;
                }

                using (EPClientProxy proxy = new EPClientProxy())
                {
                    proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", "APG_SRM_MM26000", "REMOVE"), param);
                    X.Js.Call("if (parent != null) parent.App.direct.fnSearch"); //부모창의 조회
                    Search();                    
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
    }
}