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

namespace Ax.EP.WP.Home.EPSample
{
    /// <summary>
    /// <b>샘플프로그램</b>
    /// - 작 성 자 : 박의곤<br />
    /// - 작 성 일 : 2010-07-25<br />
    /// </summary>
    public partial class EPCodeBoxTest : BasePage
    {
        /// <summary>
        /// EP20S01
        /// </summary>
        public EPCodeBoxTest()
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

        }

        #region [ 버튼설정 ]

        /// <summary>
        /// BuildButtons
        /// 기본 버튼생성
        /// </summary>
        protected override void BuildButtons()
        {
            MakeButton("ButtonCheck", "", "Check", this.ButtonPanel);
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
            Ext.Net.Button ibtn = CreateButton(id, alt);

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
            //Ext.Net.Button ibtn = (Ext.Net.Button)sender;

            string VINCD, ITEMCD, ETC, VENDCD, CUSTCD, PARTNO;

            VINCD = "CONTROL ID : " + cdx01_VINCD.ID + " / OBJECT_ID : " + cdx01_VINCD.Value + " / TYPECD : " + cdx01_VINCD.TypeCD + " / TYPENM : " + cdx01_VINCD.Text + " / VALID : " + cdx01_VINCD.isValid.ToString() + "<br>";
            ITEMCD = "CONTROL ID : " + cdx01_ITEMCD.ID + " / OBJECT_ID : " + cdx01_ITEMCD.Value + " / TYPECD : " + cdx01_ITEMCD.TypeCD + " / TYPENM : " + cdx01_ITEMCD.Text + " / VALID : " + cdx01_ITEMCD.isValid.ToString() + "<br>";
            ETC = "CONTROL ID : " + cdx01_ETC.ID + " / OBJECT_ID : " + cdx01_ETC.Value + " / TYPECD : " + cdx01_ETC.TypeCD + " / TYPENM : " + cdx01_ETC.Text + " / VALID : " + cdx01_ETC.isValid.ToString() + "<br>";
            VENDCD = "CONTROL ID : " + cdx01_VENDCD.ID + " / OBJECT_ID : " + cdx01_VENDCD.Value + " / TYPECD : " + cdx01_VENDCD.TypeCD + " / TYPENM : " + cdx01_VENDCD.Text + " / VALID : " + cdx01_VENDCD.isValid.ToString() + "<br>";
            CUSTCD = "CONTROL ID : " + cdx01_CUSTCD.ID + " / OBJECT_ID : " + cdx01_CUSTCD.Value + " / TYPECD : " + cdx01_CUSTCD.TypeCD + " / TYPENM : " + cdx01_CUSTCD.Text + " / VALID : " + cdx01_CUSTCD.isValid.ToString() + "<br>";
            PARTNO = "CONTROL ID : " + cdx01_PARTNO.ID + " / OBJECT_ID : " + cdx01_PARTNO.Value + " / TYPECD : " + cdx01_PARTNO.TypeCD + " / TYPENM : " + cdx01_PARTNO.Text + " / VALID : " + cdx01_PARTNO.isValid.ToString() + "<br>";

            lblResult.Html = VINCD + ITEMCD + ETC + VENDCD + CUSTCD + PARTNO;
        }

        #endregion

        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Bofore 버튼클릭 핸들러
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void CodeBox_BeforeDirectButtonClick(object sender, DirectEventArgs e)
        {
            // UserPopup 일 경우 넘어가는 파라메터 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            cdx.UserParamSet = new HEParameterSet();
            cdx.UserParamSet.Add("TYPE", "search");
            cdx.UserParamSet.Add("TEXT", cdx.Text);
            cdx.UserParamSet.Add("DIV", "");
        }
        
        /// <summary>
        /// CodeBox_Click
        /// 코드박스 Before 벨리데이션
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void CodeBox_CustomRemoteValidation(object sender, EP.UI.EPCodeBox_ValidationResult rsltSet)
        {
            // 커스텀시 샘플코드 
            EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

            /* DB 의 코드를 통한 검증 로직 작성 및 결과 값 리턴 - 여기부터 */
            HEParameterSet param = new HEParameterSet();
            param.Add("VENDCD", cdx.TypeCD);
            param.Add("LANG_SET", Util.UserInfo.LanguageShort);
            DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPHELPWINDOW.INQUERY_VENDER_VALIDATION", param);

            rsltSet.resultDataSet = ds;                                             //  결과 데이터셋
            rsltSet.resultValidation = ds.Tables[0].Rows.Count == 0 ? false : true; // 동일한 데이터가 있으면 true 없으면 false
            rsltSet.returnValueFieldName = "TYPECD";       
            rsltSet.returnTextFieldName = "TYPENM";
        }
    }
}
