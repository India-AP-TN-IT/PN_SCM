using System;
using System.Data;
using System.Web;
using Ax.EP.Utility;
using HE.Framework.Core;

namespace Ax.EP.WP.Home.EPBase
{
    public partial class EPContact : BasePage
    {
        /// <summary>
        /// <b>현업정보</b>
        /// - 작 성 자 : 박의곤<br />
        /// - 작 성 일 : 2017-11-15<br />
        /// </summary>
        public EPContact()
        {
            //버튼 아이디와 권한에 따라 버튼의 Visible을 설정하는 기능 활성화
            this.RequireAuthentication = false;
            this.RequireAuthority = false;
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
                    if (!Request.Headers["Accept-Language"].Substring(0, 2).ToUpper().Equals("KO"))
                    {
                        this.NO.Text = "No";
                        this.DEPART.Text = "Department";
                        this.NAME.Text = "Name";
                        this.CHARGE_JOB.Text = "Business Role";
                        this.CHR_TEL.Text = "Tel No";
                        this.lbl01_EPCONTACT.Text = "Business Manager";
                    }

                    DataSet ds = null;

                    HEParameterSet param = new HEParameterSet();
                    ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.CHARGE_JOB", param, "OUT_CURSOR");

                    this.Store1.DataSource = ds.Tables[0];
                    this.Store1.DataBind();
                }
            }
            catch (Exception ex)
            {
                
                //this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
                Util.Alert("Error", ex.ToString(), Ext.Net.MessageBox.Icon.ERROR);
            }
            finally
            {
            }
        }
    }
}