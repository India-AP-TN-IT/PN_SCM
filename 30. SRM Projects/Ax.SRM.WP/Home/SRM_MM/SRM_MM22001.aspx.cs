#region ▶ Description & History
/* 
 * 프로그램명 : 납품서 등록
 * 설      명 : 자재관리 > 납품관리 > 납품서등록
 * 최초작성자 : 이재우
 * 최초작성일 : 2017-07-20
 * 수정  내용 :
 *  
 *				날짜			작성자		이슈
 *				---------------------------------------------------------------------------------------------
 *				
 *
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
using System.Threading;

using System.Configuration;
using System.ServiceModel.Configuration;

namespace Ax.SRM.WP.Home.SRM_MM
{
	public partial class SRM_MM22001 : BasePage
	{
		private string pakageName = "SIS.APG_SRM_MM22001";
		private bool isUseSAPPO = true;
		
		#region [ 초기설정 ]

		/// <summary>
		/// SRM_MM22001
		/// </summary>
		public SRM_MM22001()
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
					// Ajax Timeout 설정
					this.ResourceManager1.AjaxTimeout = Util.GetSendTimeOut(Server.MapPath("/"));

					Library.GetBIZCD(this.cbo01_BIZCD, this.UserInfo.CorporationCode, false);

					//구매오더유형
					DataTable source = Library.GetTypeCode("1K").Tables[0];
					source.DefaultView.RowFilter = "TYPECD NOT IN ('NI')";
					//Library.ComboDataBind(this.cbo01_PURC_PO_TYPE, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "");
					Library.ComboDataBind(this.cbo01_PURC_PO_TYPE, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true);
					this.cbo01_PURC_PO_TYPE.UpdateSelectedItems(); //꼭 해줘야한다.
					

					//구매조직
					source = Library.GetTypeCode("1A").Tables[0];
					Library.ComboDataBind(this.cbo01_PURC_ORG, source.DefaultView.ToTable(), true, "OBJECT_NM", "OBJECT_ID", true, "");
					if (source.Rows.Count > 0) //SORT_SEQ가 가장 빠른 것 디폴트값으로 강제 선택함. (0번째가 가장빠른값임. DB에서 가져올때부터 ORDER BY SORT_SEQ로 가져옴.)
					{
						this.cbo01_PURC_ORG.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
					}
					this.cbo01_PURC_ORG.UpdateSelectedItems(); //꼭 해줘야한다.
					Reset();

					//if ((this.UserInfo.UserDivision.Equals("T10") || this.UserInfo.UserDivision.Equals("T12")) && int.Parse(DateTime.Now.ToString("yyyyMMdd")) <= 20190131)
					//{
					//    // 한시적으로 내년 19년 1월 31일까지   내부 사용자에 한하여 납품일자 변경 가능토록 함  ( 박진한 요청  2018-12-17 )
					//    df01_DELI_DATE.Editable = true;
					//    df01_DELI_DATE.ReadOnly = false;
					//}
					//else
					//{
						df01_DELI_DATE.Editable = false;
						df01_DELI_DATE.ReadOnly = true;
                    //}

                    source = new DataTable();
                    source.Columns.Add("OBJECT_ID");
                    source.Columns.Add("OBJECT_NM");
                    source.Rows.Add("", "Normal");
                    source.Rows.Add("S", "Small");
                    Library.ComboDataBind(this.cbo01_PRINT_SIZE, source.DefaultView.ToTable(), false, "OBJECT_NM", "OBJECT_ID", true);
                    this.cbo01_PRINT_SIZE.SelectedItem.Value = source.Rows[0]["OBJECT_ID"].ToString();
                    this.cbo01_PRINT_SIZE.UpdateSelectedItems(); //꼭 해줘야한다.

                    chk01_BOX_TAG.BoxLabel = "";                    
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
			//MakeButton(ButtonID.Regist, ButtonImage.New, "New", this.ButtonPanel);
			//MakeButton(ButtonID.Modify, ButtonImage.Modify, "Modify", this.ButtonPanel);
			MakeButton(ButtonID.Save, ButtonImage.Save, "Save", this.ButtonPanel);            
			MakeButton(ButtonID.ExcelDL, ButtonImage.ExcelDL, "Excel Down", this.ButtonPanel, true);
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
			if (id.Equals(ButtonID.Save)) //저장시 수정된 데이터만 저장한다.
			{
				//if (this.hidMODE.Value.ToString().Equals("Regist"))
				//{
				//    ibtn.DirectEvents.Click.ExtraParams.Add(
				//        new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
				//    //new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues(false)", Mode = ParameterMode.Raw, Encode = true });
				//}
				//else
				//{
					ibtn.DirectEvents.Click.ExtraParams.Add(
					//new Ext.Net.Parameter { Name = "Values", Value = "App.Grid01.getRowsValues({dirtyRowsOnly: true})", Mode = ParameterMode.Raw, Encode = true });
                    new Ext.Net.Parameter { Name = "Values", Value = "GetData()", Mode = ParameterMode.Raw, Encode = true });   

				//}
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

			// 버튼 이벤트가 발생할 때 마다 납품일자는 현재일을 업데이트 해야함
			//if ((this.UserInfo.UserDivision.Equals("T10") || this.UserInfo.UserDivision.Equals("T12")) && int.Parse(DateTime.Now.ToString("yyyyMMdd")) <= 20190131)
			//{
			//    // 한시적으로 내년 19년 1월 31일까지   내부 사용자에 한하여 납품일자 변경 가능토록 함  ( 박진한 요청  2018-12-17 )
			//}
			//else
			//{
				this.df01_DELI_DATE.SetValue(this.getCurrentDate());
			//}

			switch (ibtn.ID)
			{
				case ButtonID.Search:
					Search();
					break;
				case ButtonID.Reset:
					Reset();
					break;
				//case ButtonID.Regist:
				//    SetButton("ButtonRegist");
				//    break;
				//case ButtonID.Modify:
				//    SetButton("ButtonModify");
				//    break;
				case ButtonID.Save:
					//Save(sender, e);
					PrintConfirm(sender, e);
					break;
				case ButtonID.ExcelDL:
					Excel_Export();
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
		public void etc_Button_Click(object sender, EventArgs e)
		{
			Ext.Net.Button btn = (Ext.Net.Button)sender;
			switch (btn.ID)
			{
				case "btn01_PRINT_REPORT":
					//납품전표 출력 버튼
					//printReport("0");
					break;

				case "btn01_BLANK_REPORT":
					//백지전표 출력 버튼
					//printBlankReport();
					break;

				default:
					break;
			}
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
				//유효성 검사
				if (!IsQueryValidation())
				{
					return;
				}

                //CHANGE_4M필드 사용 안함. 2019.09.19 김도연차장 요청.
                /*
				// 4M변경내역. 구매조직 = '수출' 일때만 보이도록 할 것.
				if (cbo01_PURC_ORG.Value.Equals("1A1110"))
				{
					Util.SetHeaderColumnHidden(Grid01, "CHANGE_4M", false);
				}
				else
				{
					Util.SetHeaderColumnHidden(Grid01, "CHANGE_4M", true);
				}
                */
				DataSet result = getDataSet();

				this.Store1.DataSource = result.Tables[0];
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
		/// Reset
		/// </summary>
		public void Reset()
		{
			this.cbo01_BIZCD.SelectedItem.Value = Util.UserInfo.BusinessCode;
			this.cbo01_BIZCD.UpdateSelectedItems(); //꼭 해줘야한다.

			//this.cbo01_PURC_PO_TYPE.SelectedItem.Value = "";
			//this.cbo01_PURC_PO_TYPE.UpdateSelectedItems();

			//this.cbo01_PURC_ORG.SelectedItem.Value = "";
			//this.cbo01_PURC_ORG.UpdateSelectedItems();

			this.df01_ARRIV_DATE.SetValue(DateTime.Now);

			this.df01_DELI_DATE.SetValue(this.getCurrentDate());

			if (this.UserInfo.UserDivision.Equals("T12") || this.UserInfo.UserDivision.Equals("T10"))
			{
				this.cdx01_VENDCD.SetValue(string.Empty);
				this.cdx01_VENDCD.ReadOnly = false;
			}
			else
			{
				this.cdx01_VENDCD.SetValue(this.UserInfo.VenderCD);
				this.cdx01_VENDCD.ReadOnly = true;
			}

			txt01_ARRIV_TIME.Value = string.Empty;

			cbo01_PURC_PO_TYPE_Change(null, null);            

			cdx01_VINCD.SetValue(string.Empty);

			this.txt01_PONO.SetValue(string.Empty);

			txt01_FPARTNO.Value = string.Empty;
			txt01_TRUCK_NO.Value = string.Empty;
            txt01_INVOICE.Value = string.Empty;


            this.Store1.RemoveAll();
		}

		/// <summary>
		/// getCurrentDate
		/// </summary>
		/// <returns></returns>
		private string getCurrentDate()
		{
			HEParameterSet param = new HEParameterSet();
			string procedure = "GET_CURRENT_DATE";
			return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param).Tables[0].Rows[0][0].ToString();
		}

		/// <summary>
		/// getDeliNote
		/// </summary>
		/// <returns></returns>
		private int getDeliCnt()
		{
			HEParameterSet param = new HEParameterSet();
			param.Add("BIZCD", this.cbo01_BIZCD.Value);
			param.Add("VENDCD", this.cdx01_VENDCD.Value);
			param.Add("NOTE_CRT_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));

			string procedure = "GET_DELI_CNT";
			return Convert.ToInt32(EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param).Tables[0].Rows[0]["DELI_CNT"].ToString());
		}

		/// <summary>
		/// getDataSet
		/// </summary>
		/// <returns></returns>
		private DataSet getDataSet()
		{
			HEParameterSet param = new HEParameterSet();
			//param.Add("CORCD", Util.UserInfo.CorporationCode);
			param.Add("BIZCD", this.cbo01_BIZCD.Value);
			param.Add("VENDCD", this.cdx01_VENDCD.Value);
			param.Add("PURC_PO_TYPE", this.cbo01_PURC_PO_TYPE.Value);
			param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
			param.Add("STR_LOC", this.cdx01_STR_LOC.Value);
			param.Add("VINCD", this.cdx01_VINCD.Value);
			param.Add("PONO", this.txt01_PONO.Value);
			param.Add("PARTNO", this.txt01_FPARTNO.Value);
			param.Add("DELI_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
			param.Add("LANG_SET", this.UserInfo.LanguageShort);

			string procedure = "INQUERY";

			//상품매출 입고검사표는 별도의 조회쿼리를 이용한다.
			if(this.cbo01_PURC_PO_TYPE.Value.Equals("1K10"))
			{
				procedure = "INQUERY_GOODS";
			}

			return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param);
		}

		/// <summary>
		/// 저장 후 출력 여부 묻기
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		/// <param name="status"></param>
		public void PrintConfirm(object sender, DirectEventArgs e)
		{
			try
			{
                //20190801 LYZ Vendor Invoice 필수 입력 추가
                //AMM9010.INVOICE_NO 
                if (this.txt01_INVOICE.IsEmpty)
                {
                    //{0}를(을) 입력해주세요.
                    this.MsgCodeAlert_ShowFormat("EP20S01-003", "txt01_INVOICE", lbl01_INVOICE.Text);
                    return;
                }

                string json = e.ExtraParams["Values"];

				CheckSaveValidation(json.Replace("'", "\\'"));

                /*
				//저장 후 전표를 출력 하시겠습니까?
				string[] msg = Library.getMessageWithTitle("SRMMM-0012");

				Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
				{
					Yes = new MessageBoxButtonConfig
					{
						Handler = "App.direct.Save_SAPIF_2('" + json.Replace("'", "\\'") + "', 'YES')",
						Text = "YES"
					},
					No = new MessageBoxButtonConfig
					{
						Handler = "App.direct.Save_SAPIF_2('" + json.Replace("'", "\\'") + "', 'NO')",
						Text = "NO"
					}
				}).Show();
				*/

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
        /// 메뉴추가
        /// </summary>
        private void Vendor_Invoice()
        {
            HEParameterSet set = new HEParameterSet();

            Util.UserPopup(this, this.UserHelpURL.Text, set, "HELP_XM20002P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
        }

        /// <summary>
        /// 저장 Validation 체크 및 출력 여부 묻기
        /// </summary>
        /// <param name="json"></param>
        public void CheckSaveValidation(string json)
		{
			try
			{
				Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

				if (parameters.Length == 0)
				{
					//저장할 대상 Data가 없습니다.
					this.MsgCodeAlert("COM-00020");
					return;
				}

				DataSet param = Util.GetDataSourceSchema
				(
					"PONO", "PONO_SEQ", "UNIT_PACK_QTY", "DELI_QTY", "VEND_LOTNO", "PRDT_DATE", "CHANGE_4M"
				);

				for (int i = 0; i < parameters.Length; i++)
				{
					if ((parameters[i]["DELI_QTY"] == null || parameters[i]["DELI_QTY"] == string.Empty) //&&
						//(parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty)         // 김건우 주석처리 2018.11.27
						//(parameters[i]["DELI_DATE"] == null || parameters[i]["DELI_DATE"] == string.Empty) &&
						//(parameters[i]["ARRIV_DATE"] == null || parameters[i]["ARRIV_DATE"] == string.Empty) &&
						//(parameters[i]["ARRIV_TIME"] == null || parameters[i]["ARRIV_TIME"] == string.Empty)
						)
					{
						continue;
					}

					param.Tables[0].Rows.Add
					(
						parameters[i]["PONO"]
						, parameters[i]["PONO_SEQ"]
						, parameters[i]["UNIT_PACK_QTY"]
						, parameters[i]["DELI_QTY"]
						, parameters[i]["VEND_LOTNO"]
						, ((parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty) ? string.Empty : DateTime.Parse(parameters[i]["PRDT_DATE"].ToString()).ToString("yyyy-MM-dd"))
						, parameters[i]["CHANGE_4M"].ToString()
					);

					//유효성 검사 (그리드에서 넘어오는 행의값 NO는 0부터 시작된다.)
					if (!IsSaveValid_2(
							param.Tables[0].Rows[param.Tables[0].Rows.Count - 1], 
							parameters[i]["CORCD"].ToString(),
							Convert.ToInt32(parameters[i]["NO"])))
					{
						return;
					}
				}

				if (param.Tables[0].Rows.Count == 0)
				{
					//저장할 대상 Data가 없습니다.
					this.MsgCodeAlert("COM-00020");
					return;
				}
				else
				{
					//도착시간 한번 더 확인
					if (!IsArriveTimeValid())
					{
						return;
					}

					//저장 후 전표를 출력 하시겠습니까?
					string[] msg = Library.getMessageWithTitle("SRMMM-0012");

					//처리중
					string processing = Library.getLabel("SRM_QA21003", "PROCESSING", UserInfo.LanguageShort);

					Ext.Net.X.Msg.Confirm(msg[0], msg[1], new MessageBoxButtonsConfig
					{
						Yes = new MessageBoxButtonConfig
						{
							Handler = "Ext.net.Mask.show({ msg: '" + processing + "' }); App.direct.Save('" + json + "', 'YES', { success: function (result) { Ext.net.Mask.hide(); } });",
							Text = "YES"
						},
						No = new MessageBoxButtonConfig
						{
							Handler = "Ext.net.Mask.show({ msg: '" + processing + "' }); App.direct.Save('" + json + "', 'NO', { success: function (result) { Ext.net.Mask.hide(); } }); ",
							Text = "NO",
						},
						Cancel = new MessageBoxButtonConfig
						{

							Text = "CANCEL"
						}
					}).Show();
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
		/// 저장
		/// </summary>
		/// <param name="json"></param>
		/// <param name="printYN"></param>
		[DirectMethod]
		public void Save(string json, string printYN)
		{
			try
			{
				//상품매출 입고검사표는 SAP I/F를 하지 않고 바로 저장한다.--사용안할 예정
				if (this.cbo01_PURC_PO_TYPE.Value.Equals("1K10"))
				{
					Save_GOODS(json, printYN);
					return;
				}

				Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

				if (parameters.Length == 0)
				{
					//저장할 대상 Data가 없습니다.
					this.MsgCodeAlert("COM-00020");
					return;
				}

				// 납품차수 시퀀스 및 IF_DATE, IF_TIME 설정
				HEParameterSet param3 = new HEParameterSet();
				string procedure = "GET_DELI_CNT_SEQ";
				DataTable dt = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param3).Tables[0];
				int deliCntSeq = Convert.ToInt32(dt.Rows[0]["DELI_CNT_SEQ"]);
				string ifDate = dt.Rows[0]["IF_DATE"].ToString();
				string ifTime = dt.Rows[0]["IF_TIME"].ToString();

				string udid = "";
				string udids = "";
				
				DataSet param = Util.GetDataSourceSchema
				(
					"BIZCD", "DELI_CNT_SEQ", "PONO", "PONO_SEQ",
					"UNIT_PACK_QTY", "DELI_QTY", "VEND_LOTNO", "PRDT_DATE", "CHANGE_4M",
					"DELI_DATE", "ARRIV_DATE", "ARRIV_TIME", "USER_ID",
					"UDID", "IF_DATE", "IF_TIME",
                    "INVOICE_NO"
                );

				for (int i = 0; i < parameters.Length; i++)
				{
					//if ((parameters[i]["DELI_QTY"] == null || parameters[i]["DELI_QTY"] == string.Empty || parameters[i]["DELI_QTY"] == "0") &&
					//(parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty))
					if ((parameters[i]["DELI_QTY"] == null || parameters[i]["DELI_QTY"] == string.Empty || parameters[i]["DELI_QTY"] == "0"))
					{
						continue;
					}

					udid = DateTime.Now.Ticks.ToString("X") + Guid.NewGuid().ToString().GetHashCode().ToString("X");
					udids += (udids.Length == 0 ? "" : ",") + udid;

					param.Tables[0].Rows.Add
					(
						this.cbo01_BIZCD.Value
						, deliCntSeq
						, parameters[i]["PONO"]
						, parameters[i]["PONO_SEQ"]
						, parameters[i]["UNIT_PACK_QTY"]
						, parameters[i]["DELI_QTY"]
						, parameters[i]["VEND_LOTNO"]
						, ((parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty) ? string.Empty : DateTime.Parse(parameters[i]["PRDT_DATE"].ToString()).ToString("yyyy-MM-dd"))
						, parameters[i]["CHANGE_4M"].ToString()
						, ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd")
						, ((DateTime)this.df01_ARRIV_DATE.Value).ToString("yyyy-MM-dd")
						, this.txt01_ARRIV_TIME.Value
						, this.UserInfo.UserID
						, udid
						, ifDate
						, ifTime
                        , this.txt01_INVOICE.Value
                    );
				}

				using (EPClientProxy proxy = new EPClientProxy())
				{
					proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_SAPIF_4"), param);
				}

				int deliCnt;
				// SAP IF 테이블에서 데이터를 읽어와 웹서비스 호출 후 응답받음
				string result = Inquery_SAPIF_2(udids, deliCntSeq, out deliCnt);

				//저장 후 전표출력을 하겠다고 했으면 출력루틴
				if (result.Equals("S") && printYN.Equals("YES"))
				{
					//2018.01.23 글로벌표준 검사성적서 입력여부 체크하지 않음. 
					//출력여부 판단
					bool isPrint = true; //무조건 true처리.                    
					//for (int i = 0; i < parameters.Length; i++)
					//{
					//    if (parameters[i]["CHECK_CERT"].ToString().Equals("YES"))
					//    {
					//        isPrint = false;
					//        break;
					//    }
					//}

					// corcd, bizcd, delidate, delicnt
					if (isPrint)
					{
						//저장되었습니다.
						//this.MsgCodeAlert("COM-00001");

						string deliDate = ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd");
						HEParameterSet param2 = new HEParameterSet();
						//param2.Add("CORCD", this.UserInfo.CorporationCode);
						//param2.Add("BIZCD", this.cbo01_BIZCD.Value);
						//param2.Add("DELI_DATE", deliDate);
						//param2.Add("DELI_CNT", deliCnt);
						param2.Add("UDIDS", udids);

						DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "GET_DELI_NOTE_2"), param2);

						if (source.Tables.Count == 0) return;
						if (source.Tables[0].Rows.Count == 0) return;

						DataTable dt2 = source.Tables[0];
						int cnt = dt2.Rows.Count;
						for (int i = 0; i < cnt; i++)
						{
							string sourcingDiv = dt2.Rows[i]["SOURCING_DIV"].ToString();
							string purcOrg = dt2.Rows[i]["PURC_ORG"].ToString();
							string purcPoType = dt2.Rows[i]["PURC_PO_TYPE"].ToString();
							string zgrtyp = dt2.Rows[i]["ZGRTYP"].ToString();

							printReport(deliDate, deliCnt, sourcingDiv, purcOrg, purcPoType, zgrtyp);
						}
					}
					else
					{
						//저장은 하였으나, 검사성적서가 입력되지 않은 건이 있어 출력할 수 없습니다.
						this.MsgCodeAlert("SRMMM-0039");
					}
				}
				else if (result.Equals("S"))
				{
					//저장되었습니다.
					this.MsgCodeAlert("COM-00001");
				}

				if (result.Equals("S"))
				{
					//저장이후 도착예정시간 초기화
					txt01_ARRIV_TIME.Value = string.Empty;
					txt01_TRUCK_NO.Value = string.Empty;

					//현재 차수로 조회
					this.Search();
                    txt01_INVOICE.Value = string.Empty;
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
		/// OEM 직납상품 저장
		/// </summary>
		/// <param name="json"></param>
		/// <param name="printYN"></param>
		public void Save_GOODS(string json, string printYN)
		{
			try
			{
				Dictionary<string, string>[] parameters = JSON.Deserialize<Dictionary<string, string>[]>(json);

				if (parameters.Length == 0)
				{
					//저장할 대상 Data가 없습니다.
					this.MsgCodeAlert("COM-00020");
					return;
				}

				// 납품차수 및 IF_DATE, IF_TIME 설정
				HEParameterSet param3 = new HEParameterSet();
				param3.Add("BIZCD", this.cbo01_BIZCD.Value);
				param3.Add("VENDCD", this.cdx01_VENDCD.Value);
				param3.Add("DELI_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
				string procedure = "GET_DELI_CNT_GOODS";
				DataTable dt = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param3).Tables[0];
				int deliCnt = Convert.ToInt32(dt.Rows[0]["DELI_CNT"]);
				int deliCntSeq = Convert.ToInt32(dt.Rows[0]["DELI_CNT_SEQ"]);

				DataSet param = Util.GetDataSourceSchema
				(
					"BIZCD", "VENDCD", "PURC_ORG", "PARTNO", "VINCD",
					"DELI_CNT", "DELI_CNT_SEQ", 
					"DELI_QTY", "PRDT_DATE", "VEND_LOTNO", 
					"DELI_DATE", "ARRIV_DATE", "ARRIV_TIME", "USER_ID",
                    "INVOICE_NO"
                );

				for (int i = 0; i < parameters.Length; i++)
				{
					if ((parameters[i]["DELI_QTY"] == null || parameters[i]["DELI_QTY"] == string.Empty || parameters[i]["DELI_QTY"] == "0"))
					{
						continue;
					}

                    param.Tables[0].Rows.Add
                    (
                        this.cbo01_BIZCD.Value
                        , this.cdx01_VENDCD.Value
                        , this.cbo01_PURC_ORG.Value
                        , parameters[i]["PARTNO"]
                        , parameters[i]["VINCD"]
                        , deliCnt
                        , deliCntSeq
                        , parameters[i]["DELI_QTY"]
                        , ((parameters[i]["PRDT_DATE"] == null || parameters[i]["PRDT_DATE"] == string.Empty) ? string.Empty : DateTime.Parse(parameters[i]["PRDT_DATE"].ToString()).ToString("yyyy-MM-dd"))
                        , parameters[i]["VEND_LOTNO"]
                        , ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd")
                        , ((DateTime)this.df01_ARRIV_DATE.Value).ToString("yyyy-MM-dd")
                        , this.txt01_ARRIV_TIME.Value
                        , this.UserInfo.UserID
                        , this.txt01_INVOICE.Value
                    );
                }

				using (EPClientProxy proxy = new EPClientProxy())
				{
					proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_GOODS"), param);
				}

				//저장 후 전표출력을 하겠다고 했으면 출력루틴
				if (printYN.Equals("YES"))
				{
					//출력여부 판단
					bool isPrint = true;

					// corcd, bizcd, delidate, delicnt
					if (isPrint)
					{
						//저장되었습니다.
						//this.MsgCodeAlert("COM-00001");

						string deliDate = ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd");
						printReport(deliDate, deliCnt, "", "", "1K10", "");
					}
				}
				else
				{
					//저장되었습니다.
					this.MsgCodeAlert("COM-00001");
				}

				//저장이후 도착예정시간 초기화
				txt01_ARRIV_TIME.Value = string.Empty;
				txt01_TRUCK_NO.Value = string.Empty;

				//현재 차수로 조회
				this.Search();
                txt01_INVOICE.Value = string.Empty;

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
		/// SAP PO 웹서비스 호출 및 성공시 저장, 실패시 메시지 처리
		/// </summary>
		/// <param name="udids"></param>
		/// <param name="deliCnt"></param>
		private string Inquery_SAPIF_2(string udids, int deliCntSeq, out int deliCnt)
		{
			// 납품차수 초기화
			deliCnt = 0;

			HEParameterSet param = new HEParameterSet();
			param.Add("UDIDS", udids);

			string procedure = "INQUERY_SAPIF_2";
			string[] cursorNames = new string[] { "OUT_CURSOR_H", "OUT_CURSOR_D" };

			DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, procedure), param, cursorNames);

			Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM pomm0030 = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM();

			// 납품서 정보
			DataTable dt = ds.Tables[0];
			int count = dt.Rows.Count;

			pomm0030.ZMMS0200 = new SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200[count];
			Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200 data;

			string deliNotes = "";

			for (int i = 0; i < count; i++)
			{
				data = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0200();

				data.BUKRS = dt.Rows[i]["BUKRS"].ToString();
				data.WERKS = dt.Rows[i]["WERKS"].ToString();
				data.DELI_NOTE = dt.Rows[i]["DELI_NOTE"].ToString();
				data.DELI_NOTE_CNT = dt.Rows[i]["DELI_NOTE_CNT"].ToString();
				data.IF_DATE = dt.Rows[i]["IF_DATE"].ToString();
				data.IF_TIME = dt.Rows[i]["IF_TIME"].ToString();
				data.LFDAT = dt.Rows[i]["LFDAT"].ToString();
				data.CRDAT = dt.Rows[i]["CRDAT"].ToString();
				data.LIFNR = dt.Rows[i]["LIFNR"].ToString();
				data.EKORG = dt.Rows[i]["EKORG"].ToString();
				data.DELI_TYPE = dt.Rows[i]["DELI_TYPE"].ToString();
				data.EBELN = dt.Rows[i]["EBELN"].ToString();
				data.EBELP = dt.Rows[i]["EBELP"].ToString();
				data.MATNR = dt.Rows[i]["MATNR"].ToString();
				data.LGORT = dt.Rows[i]["LGORT"].ToString();
				data.LFIMG = dt.Rows[i]["LFIMG"].ToString();
				data.MEINS = dt.Rows[i]["MEINS"].ToString();
				data.BARCODE = dt.Rows[i]["BARCODE"].ToString();
				data.NATION_CD = dt.Rows[i]["NATION_CD"].ToString();
				data.LOT_NO = dt.Rows[i]["LOT_NO"].ToString();
				data.VEND_LOTNO = dt.Rows[i]["VEND_LOTNO"].ToString();
				data.CHANGE_NOTE = dt.Rows[i]["CHANGE_NOTE"].ToString();

				pomm0030.ZMMS0200.SetValue(data, i);

				deliNotes += (deliNotes.Length == 0 ? "" : ",") + data.DELI_NOTE;
			}

			// 부품식별표 정보
			dt = ds.Tables[1];
			count = dt.Rows.Count;

			pomm0030.ZMMS0202 = new SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0202[count];
			Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0202 data2;

			for (int i = 0; i < count; i++)
			{
				data2 = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCMZMMS0202();

				data2.BUKRS = dt.Rows[i]["BUKRS"].ToString();
				data2.WERKS = dt.Rows[i]["WERKS"].ToString();
				data2.DELI_NOTE = dt.Rows[i]["DELI_NOTE"].ToString();
				data2.DELI_NOTE_CNT = dt.Rows[i]["DELI_NOTE_CNT"].ToString();
				data2.BOX_BARCODE = dt.Rows[i]["BOX_BARCODE"].ToString();
				data2.EBELN = dt.Rows[i]["EBELN"].ToString();
				data2.EBELP = dt.Rows[i]["EBELP"].ToString();
				data2.MATNR = dt.Rows[i]["MATNR"].ToString();
				data2.BARCODE = dt.Rows[i]["BARCODE"].ToString();
				data2.SEQ_NO = dt.Rows[i]["SEQ_NO"].ToString();
				data2.IDENTI_NO = dt.Rows[i]["IDENTI_NO"].ToString();
				data2.MENGE = dt.Rows[i]["MENGE"].ToString();
				data2.MEINS = dt.Rows[i]["MEINS"].ToString();

				pomm0030.ZMMS0202.SetValue(data2, i);
			}

			Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SORequest request = new Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SORequest();
			request.MT_POMM0030_SCM = pomm0030;

			Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SOClient soap = new Ax.SRM.WP.POMM0030_Service.POMM0030_SCM_SOClient();
			soap.ClientCredentials.UserName.UserName = TheOne.Configuration.AppSectionFactory.AppSection["UserName"].ToString();
			soap.ClientCredentials.UserName.Password = TheOne.Configuration.AppSectionFactory.AppSection["Password"].ToString();

			Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_response response = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_response();

			#region [if (isUseSAPPO)] (SAP I/F 사용시 - 웹서비스 호출)
			if (isUseSAPPO)
			{
				try
				{
					// SAP PO를 사용하면 웹서비스 실행
					response = soap.POMM0030_SCM_SO(request.MT_POMM0030_SCM);
				}
				catch(Exception e)
				{
					Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);

					DataSet param4 = Util.GetDataSourceSchema
					(
					   "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME", "MESSAGE"

					);

					int cnt = ds.Tables[0].Rows.Count;

					for (int i = 0; i < count; i++)
					{
						param4.Tables[0].Rows.Add
						(
							ds.Tables[0].Rows[i]["BUKRS"].ToString()
							, ds.Tables[0].Rows[i]["WERKS"].ToString()
							, ds.Tables[0].Rows[i]["DELI_NOTE"].ToString()
							, ds.Tables[0].Rows[i]["DELI_NOTE_CNT"].ToString()
							, ds.Tables[0].Rows[i]["IF_DATE"].ToString()
							, ds.Tables[0].Rows[i]["IF_TIME"].ToString()
							, e.Message
						);
					}

					try
					{
						using (EPClientProxy proxy = new EPClientProxy())
						{
							proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_SERVER_ERROR"), param4);
						}
					}
					catch (Exception e2)
					{
						Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e2);
						//SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.관리자에게 문의하십시오.
						this.MsgCodeAlert("SRMMM-0042");

						return "E";
					}

					//SAP IF 중 Server Error가 발생하였습니다. 관리자에게 문의하십시오.
					this.MsgCodeAlert("SRMMM-0040");
					return "E";
				}
			}
			#endregion
			#region [else] (SAP PO를 사용안할시 웹서비스가 성공했다는 가정으로 진행)
			else
			{
				// SAP PO를 사용안할시 웹서비스가 성공했다는 가정으로 진행
				dt = ds.Tables[0];
				count = dt.Rows.Count;

				response.ZMMS0200 = new POMM0030_Service.DT_POMM0030_SCM_responseZMMS0200[count];
				response.ResHeader = new POMM0030_Service.ResHeader();
				response.ResHeader.zResultCd = "S";
				Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_responseZMMS0200 data3;

				for (int i = 0; i < count; i++)
				{
					data3 = new Ax.SRM.WP.POMM0030_Service.DT_POMM0030_SCM_responseZMMS0200();

					data3.BUKRS = dt.Rows[i]["BUKRS"].ToString();
					data3.WERKS = dt.Rows[i]["WERKS"].ToString();
					data3.DELI_NOTE = dt.Rows[i]["DELI_NOTE"].ToString();
					data3.DELI_NOTE_CNT = dt.Rows[i]["DELI_NOTE_CNT"].ToString();
					data3.IF_DATE = dt.Rows[i]["IF_DATE"].ToString();
					data3.IF_TIME = dt.Rows[i]["IF_TIME"].ToString();
					data3.ZRSLT_SAP = "M";  // 웹서비스를 이용안한 데이터는 Manual로 저장
					data3.ZMSG_SAP = "";
					data3.ZDATE_SAP = "";
					data3.ZTIME_SAP = "";
					data3.ZDATE_PO = "";

					response.ZMMS0200.SetValue(data3, i);
				}
			}
			#endregion



			#region [SAP i/f 결과 리턴 오류시 상태값 업데이트]
			try
			{
				count = response.ZMMS0200.Length;
			}
			catch (NullReferenceException e)
			{
				Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);

				// ZMMS0200가 NULL 이더라도 헤더정보의 ZRESULTCD가 존재한다면 E인 경우에만 DB에 저장
				if (response != null && response.ResHeader != null && response.ResHeader.zResultCd != null && !response.ResHeader.zResultCd.Equals("S"))
				{
					DataSet param4 = Util.GetDataSourceSchema
					(
					   "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME", "MESSAGE"

					);

					int cnt = ds.Tables[0].Rows.Count;

					for (int i = 0; i < count; i++)
					{
						param4.Tables[0].Rows.Add
						(
							ds.Tables[0].Rows[i]["BUKRS"].ToString()
							, ds.Tables[0].Rows[i]["WERKS"].ToString()
							, ds.Tables[0].Rows[i]["DELI_NOTE"].ToString()
							, ds.Tables[0].Rows[i]["DELI_NOTE_CNT"].ToString()
							, ds.Tables[0].Rows[i]["IF_DATE"].ToString()
							, ds.Tables[0].Rows[i]["IF_TIME"].ToString()
							, e.Message
						);
					}

					try
					{
						using (EPClientProxy proxy = new EPClientProxy())
						{
							proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_NULL_ERROR"), param4);
						}
					}
					catch (Exception e2)
					{
						Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e2);
						//SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.관리자에게 문의하십시오.
						this.MsgCodeAlert("SRMMM-0042");

						return "E";
					}
				}

				//SAP에서 응답이 NULL로 왔습니다. 관리자에게 문의하시기바랍니다.
				this.MsgCodeAlert("SRMMM-0059");

				return "E";
			}
			#endregion


			#region [SAP I/F 정상 종료시 - 응답값 저장 처리]
			DataSet param2 = Util.GetDataSourceSchema
				(
				   "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME",
				   "ZRSLT_SAP", "ZMSG_SAP", "ZDATE_SAP", "ZTIME_SAP", "ZDATE_PO"
				);

			for (int i = 0; i < count; i++)
			{
				param2.Tables[0].Rows.Add
					(
						response.ZMMS0200[i].BUKRS
						, response.ZMMS0200[i].WERKS
						, response.ZMMS0200[i].DELI_NOTE
						, response.ZMMS0200[i].DELI_NOTE_CNT
						, response.ZMMS0200[i].IF_DATE
						, response.ZMMS0200[i].IF_TIME
						, response.ZMMS0200[i].ZRSLT_SAP
						, response.ZMMS0200[i].ZMSG_SAP
						, response.ZMMS0200[i].ZDATE_SAP
						, response.ZMMS0200[i].ZTIME_SAP
						, response.ZMMS0200[i].ZDATE_PO
					);
			}

			try
			{
				using (EPClientProxy proxy = new EPClientProxy())
				{
					// 웹서비스 호출 후 응답값 저장
					proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "UPDATE_SAPIF"), param2);
				}
			}
			catch (Exception e)
			{
				Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);
				//SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.관리자에게 문의하십시오.
				this.MsgCodeAlert("SRMMM-0042");

				return "E";
			}

			#endregion



			// 실패면 메시지 처리, 성공이면 AMM9010 데이터 저장
			if (!response.ResHeader.zResultCd.Equals("S"))
			{
				//SAP I/F 정상 종료되었으나 결과값이 "성공"이 아니면 오류 메시지 표시함.
				//SAP IF 중 오류가 발생하였습니다. {0}
				this.MsgCodeAlert_ShowFormat("SRMMM-0033", "", "\r\n" + response.ResHeader.zResultMsg);

				return "E";
			}
			else
			{
				////SAP I/F 정상 종료되었으나 결과값이 "성공"이면, SRM 데이터 생성
				// 납품차수 가져오기
				HEParameterSet param4 = new HEParameterSet();
				param4.Add("BIZCD", this.cbo01_BIZCD.Value);
				param4.Add("VENDCD", this.cdx01_VENDCD.Value);
				param4.Add("DELI_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
				param4.Add("DELI_CNT_SEQ", deliCntSeq);
				dt = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "GET_DELI_CNT_3"), param4).Tables[0];
				deliCnt = Convert.ToInt32(dt.Rows[0]["DELI_CNT"]);

				DataSet param3 = Util.GetDataSourceSchema
				(
				   "BUKRS", "WERKS", "DELI_NOTE", "DELI_NOTE_CNT", "IF_DATE", "IF_TIME",
				   "DELI_CNT", "USER_ID", "TRUCK_NO", "INVOICE_NO"
				);

				for (int i = 0; i < count; i++)
				{
					param3.Tables[0].Rows.Add
						(
							response.ZMMS0200[i].BUKRS
							, response.ZMMS0200[i].WERKS
							, response.ZMMS0200[i].DELI_NOTE
							, response.ZMMS0200[i].DELI_NOTE_CNT
							, response.ZMMS0200[i].IF_DATE
							, response.ZMMS0200[i].IF_TIME
							, deliCnt
							, this.UserInfo.UserID
							, txt01_TRUCK_NO.Value.ToString()
                            , txt01_INVOICE.Value
						);
				}

				try
				{
					using (EPClientProxy proxy = new EPClientProxy())
					{
						//웹서비스 호출 후 응답이 'S'로 오면 SRM에 저장함
						proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", pakageName, "SAVE_SUCCESS_4"), param3);
					}
					return "S";
				}
				catch(Exception e)
				{
					Ax.EP.Utility.ExceptionHandler.ErrorHandle(this, e);
					//SAP에서는 처리되었으나, SRM저장시 오류가 발생했습니다.SAP IF 미처리현황에서 확인하십시오.
					this.MsgCodeAlert("SRMMM-0041");

					return "E";
				}
			}
		}

		/// <summary>
		/// Excel_Export
		/// </summary>
		private void Excel_Export()
		{
			try
			{
				DataSet result = getDataSet();

				if (result == null) return;

				if (result.Tables[0].Rows.Count == 0)
					// 출력 또는 내보낼 데이터가 없습니다. 
					this.MsgCodeAlert("COM-00807"); 
				else
				{
					ExcelHelper.ExportExcel(this.Page, result.Tables[0], Grid01);
				}
			}
			catch (Exception ex)
			{
				this.ErrorMessageAlert(this, ex);
			}
			finally
			{

			}
		}
		
		#endregion

		#region [ 전표 출력 ]

		private void printReport(string deliDate, int deliCnt, string sourcingDiv, string purcOrg, string purcPoType, string zgrtyp)
		{
			//1A1100:내수, 1A1110:수출
			if (purcOrg.Equals("1A1110"))
			{
				//CKD 리포트 호출
				printReportCKD(deliDate, deliCnt);
			}
			else if (purcPoType.Equals("1K10"))
			{
				//상품매출 입고검사표 리포트 호출 (EYG)
				printReportEYG(deliDate, deliCnt);
			}
			else if (purcPoType.Equals("1KMA"))
			{
				//AS/SP/KD
				//입고정산구분, 10:검수기준, NULL:입고기준
				//if (zgrtyp.Equals("10"))
				//{
				//    //납품명세서 호출 (E2C) (고객사 라벨 포함)
				//    //리포트 2장 : 제출용, 회수용
				//    printReportE2C(deliDate, deliCnt);
				//}
				//else
				//{
					//거래명세표 리포트 호출 (E2A)
					//리포트 3장 : 제출용, 수부용, 회수용
					printReportE2A(deliDate, deliCnt, "ASK");
				//}
			}
			else if (sourcingDiv.Equals("1I120") || sourcingDiv.Equals("1I200"))
			{
				//1I120:비서열-실적, 1I200:직서열-실적
				//납품명세표 리포트 호출 (E2B) (고객사 라벨 없음)
				printReportE2B(deliDate, deliCnt);
			}
			else// if (sourcingDiv.Equals("1I100"))
			{
				//1I100:입고
				//거래명세표 리포트 호출 (E2A)
				printReportE2A(deliDate, deliCnt, "");
			}

            //BOX BARCOD PRINT
            if (this.chk01_BOX_TAG.Checked) 
                Box_Barcode_Print(deliDate, deliCnt);

		}

		private DataSet getDataSetSealImage()
		{
			HEParameterSet param = new HEParameterSet();
			param.Add("CORCD", Util.UserInfo.CorporationCode);
			param.Add("VENDCD", this.cdx01_VENDCD.Value);
			return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_SEAL_IMAGE"), param);
		}


		/// <summary>
		/// 납품전표 출력용 DATASET
		/// </summary>
		/// <returns></returns>
		private DataSet getDataSetReport(string deliDate, int deliCnt, string reportType)
		{
			HEParameterSet param = new HEParameterSet();

			param.Add("CORCD", Util.UserInfo.CorporationCode);
			param.Add("BIZCD", this.cbo01_BIZCD.Value);
			param.Add("DELI_DATE", deliDate);
			param.Add("DELI_CNT", deliCnt);
			param.Add("VENDCD", this.cdx01_VENDCD.Value);
			param.Add("PURC_PO_TYPE", this.cbo01_PURC_PO_TYPE.Value);
			param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
			param.Add("LANG_SET", this.UserInfo.LanguageShort);

			if (reportType.Equals("CKD"))
			{
				string[] cursorNames = new string[] { "OUT_CURSOR_H", "OUT_CURSOR_D", "OUT_CURSOR_C" };
				return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT_" + reportType + "_CALL"), param, cursorNames);
			}
			else
			{
				return EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT_" + reportType + "_CALL"), param);
			}
		}

		/// <summary>
		/// 거래명세표 출력
		/// </summary>
		private void printReportE2A(string deliDate, int deliCnt, string ZGRTYP)
		{
			try
			{
				HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
				report.ReportName = "1000/SRM_MM/SRM_MM22001_E2A";

				HERexSection mainSection = new HERexSection();
				mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
				mainSection.ReportParameter.Add("DELI_DATE", deliDate);
				mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
				mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
				mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);
                mainSection.ReportParameter.Add("INVOICE_NO", this.txt01_INVOICE.Value);

                report.Sections.Add("MAIN", mainSection);

				DataSet ds;

				//// ASK의 경우에는 입고구분의 전표들만 출력해야함
				//if (ZGRTYP.Equals("ASK"))
				//{
				//    ds = getDataSetReport(deliDate, deliCnt, "E2A_ASK");
				//    // 리포트는 E2C(납품서)와 공유 (리포트 타이틀은 쿼리에서 '거래명세서'로 고정)
				//    report.ReportName = "1000/SRM_MM/SRM_MM22001_E2C";
				//}
				//else
				//{
					ds = getDataSetReport(deliDate, deliCnt, "E2A");
				//}

				DataSet sealImage = getDataSetSealImage();
				if (ds.Tables[0].Rows.Count == 0)
				{
					this.MsgCodeAlert_ShowFormat("COM-00022"); //출력할 대상 Data가 없습니다.
					return;
				}
				HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
				HERexSection xmlSection2 = new HERexSection(sealImage, new HEParameterSet());
				report.Sections.Add("XML", xmlSection);
				report.Sections.Add("XML2", xmlSection2);


				// DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
				// 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
				//ds.Tables[0].TableName = "DATA";
				//ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
				//sealImage.Tables[0].TableName = "DATA";
				//sealImage.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "_SEAL.xml", XmlWriteMode.WriteSchema);


				AxReportForm.ShowReport(report);
			}
			catch (Exception ex)
			{
				this.ErrorMessageAlert(this, ex);
			}
			finally
			{

			}
		}

		/// <summary>
		/// 납품명세표 출력
		/// </summary>
		private void printReportE2B(string deliDate, int deliCnt)
		{
			try
			{
				HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
				report.ReportName = "1000/SRM_MM/SRM_MM22001_E2B";

				HERexSection mainSection = new HERexSection();
				mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
				mainSection.ReportParameter.Add("DELI_DATE", deliDate);
				mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
				mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
				mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);

				report.Sections.Add("MAIN", mainSection);

				DataSet ds = getDataSetReport(deliDate, deliCnt, "E2B");
				DataSet sealImage = getDataSetSealImage();
				if (ds.Tables[0].Rows.Count == 0)
				{
					this.MsgCodeAlert_ShowFormat("COM-00022"); //출력할 대상 Data가 없습니다.
					return;
				}
				HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
				HERexSection xmlSection2 = new HERexSection(sealImage, new HEParameterSet());
				report.Sections.Add("XML", xmlSection);
				report.Sections.Add("XML2", xmlSection2);

				AxReportForm.ShowReport(report);
			}
			catch (Exception ex)
			{
				this.ErrorMessageAlert(this, ex);
			}
			finally
			{

			}
		}

		/// <summary>
		/// 거래명세표 출력 (고객사 표기)
		/// </summary>
		private void printReportE2C(string deliDate, int deliCnt)
		{
			try
			{
				HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
				report.ReportName = "1000/SRM_MM/SRM_MM22001_E2C";

				HERexSection mainSection = new HERexSection();
				mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
				mainSection.ReportParameter.Add("DELI_DATE", deliDate);
				mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
				mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
				mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);

				report.Sections.Add("MAIN", mainSection);

				DataSet ds = getDataSetReport(deliDate, deliCnt, "E2C");
				DataSet sealImage = getDataSetSealImage();
				if (ds.Tables[0].Rows.Count == 0)
				{
					this.MsgCodeAlert_ShowFormat("COM-00022"); //출력할 대상 Data가 없습니다.
					return;
				}
				HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
				HERexSection xmlSection2 = new HERexSection(sealImage, new HEParameterSet());
				report.Sections.Add("XML", xmlSection);
				report.Sections.Add("XML2", xmlSection2);


				// DataSet 으로 부터 XML 파일 생성용 코드 ( 디자인용 )
				// 생성된 XML 파일은 추후 디자인 유지보수를 위해 추가 또는 수정시마다 소스제어에 포함시켜 주세요. ( /Report 폴더 아래 )
				//ds.Tables[0].TableName = "DATA";
				//ds.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + ".xml", XmlWriteMode.WriteSchema);
				//sealImage.Tables[0].TableName = "DATA";
				//sealImage.Tables[0].WriteXml(Server.MapPath("/Report") + "/" + report.ReportName + "_SEAL.xml", XmlWriteMode.WriteSchema);


				AxReportForm.ShowReport(report);
			}
			catch (Exception ex)
			{
				this.ErrorMessageAlert(this, ex);
			}
			finally
			{

			}
		}

		/// <summary>
		/// 상품매출 입고검사표(OEM상품)
		/// </summary>
		private void printReportEYG(string deliDate, int deliCnt)
		{
			try
			{
				HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
				report.ReportName = "1000/SRM_MM/SRM_MM22001_EYG";

				HERexSection mainSection = new HERexSection();
				mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
				mainSection.ReportParameter.Add("DELI_DATE", deliDate);
				mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
				mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);
				mainSection.ReportParameter.Add("ARRIV_DATE", this.df01_ARRIV_DATE.Value);

				report.Sections.Add("MAIN", mainSection);

				DataSet ds = getDataSetReport(deliDate, deliCnt, "EYG");
				DataSet sealImage = getDataSetSealImage();
				if (ds.Tables[0].Rows.Count == 0)
				{
					//출력할 대상 Data가 없습니다.
					this.MsgCodeAlert_ShowFormat("COM-00022"); 
					return;
				}
				HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
				HERexSection xmlSection2 = new HERexSection(sealImage, new HEParameterSet());
				report.Sections.Add("XML", xmlSection);
				report.Sections.Add("XML2", xmlSection2);

				AxReportForm.ShowReport(report);
			}
			catch (Exception ex)
			{
				this.ErrorMessageAlert(this, ex);
			}
			finally
			{

			}
		}

		/// <summary>
		/// 거래명세서(CKD)
		/// </summary>
		private void printReportCKD(string deliDate, int deliCnt)
		{
			try
			{
				DataSet ds = getDataSetReport(deliDate, deliCnt, "CKD");
				if (ds.Tables[0].Rows.Count == 0)
				{
					//출력할 대상 Data가 없습니다.
					this.MsgCodeAlert_ShowFormat("COM-00022");
					return;
				}

				string deliNote = "";
				string freeCharge = "N";
				if (ds.Tables[0].Rows.Count > 0)
				{
					deliNote = ds.Tables[0].Rows[0]["DELI_NOTE"].ToString();
					freeCharge = ds.Tables[0].Rows[0]["FREE_CHARGE_YN"].ToString();
				}
				string[] Charge = new string[12] { "", "", "", "", "", "", "", "", "", "", "", "" };
				if (ds.Tables[2].Rows.Count > 0)
				{
					int i = 0;
					foreach (DataRow row in ds.Tables[2].Rows)
					{
						for (int j = 0; j < ds.Tables[2].Columns.Count; j++)
						{
							Charge[i] = String.IsNullOrEmpty(row[j].ToString()) ? "" : row[j].ToString();
							i++;
						}
					}
				}

				HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
				report.ReportName = "1000/SRM_MM/SRM_MM22001_CKD";

				HERexSection mainSection = new HERexSection();
				mainSection.ReportParameter.Add("TransNo", deliNote);
				mainSection.ReportParameter.Add("FreeCharge", freeCharge);
				mainSection.ReportParameter.Add("ChargeNo1", Charge[0]);
				mainSection.ReportParameter.Add("ChargeName1", Charge[1]);
				mainSection.ReportParameter.Add("ChargeJob1", Charge[2]);
				mainSection.ReportParameter.Add("ChargePhone1", Charge[3]);
				mainSection.ReportParameter.Add("ChargeNo2", Charge[4]);
				mainSection.ReportParameter.Add("ChargeName2", Charge[5]);
				mainSection.ReportParameter.Add("ChargeJob2", Charge[6]);
				mainSection.ReportParameter.Add("ChargePhone2", Charge[7]);
				mainSection.ReportParameter.Add("ChargeNo3", Charge[8]);
				mainSection.ReportParameter.Add("ChargeName3", Charge[9]);
				mainSection.ReportParameter.Add("ChargeJob3", Charge[10]);
				mainSection.ReportParameter.Add("ChargePhone3", Charge[11]);

                report.Sections.Add("MAIN", mainSection);


				DataSet ds1 = new DataSet();
				ds1.Tables.Add(ds.Tables[0].Copy());
				ds1.Tables[0].TableName = "DATA";
				DataSet ds2 = new DataSet();
				ds2.Tables.Add(ds.Tables[1].Copy());
				ds2.Tables[0].TableName = "DATA";


				HERexSection xmlSection = new HERexSection(ds1, new HEParameterSet());
				HERexSection xmlSection2 = new HERexSection(ds2, new HEParameterSet());
				report.Sections.Add("XML1", xmlSection);
				report.Sections.Add("XML2", xmlSection2);

				AxReportForm.ShowReport(report);
			}
			catch (Exception ex)
			{
				this.ErrorMessageAlert(this, ex);
			}
			finally
			{

			}
		}

		/// <summary>
		/// 백지전표 출력
		/// </summary>
		private void printBlankReport()
		{
			try
			{
				HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
				report.ReportName = "1000/SRM_MM/SRM_MM22001_BLANK"; 

				HERexSection mainSection = new HERexSection();
				mainSection.ReportParameter.Add("PRINT_USER", this.UserInfo.UserID + "(" + this.UserInfo.UserName + ")");
				mainSection.ReportParameter.Add("DELI_DATE", this.df01_DELI_DATE.Value);
				mainSection.ReportParameter.Add("VEND", this.cdx01_VENDCD.Value + " " + this.cdx01_VENDCD.Text);
				mainSection.ReportParameter.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Text);

				report.Sections.Add("MAIN", mainSection);

				HEParameterSet param = new HEParameterSet();
				param.Add("CORCD", Util.UserInfo.CorporationCode);
				param.Add("BIZCD", this.cbo01_BIZCD.Value);
				param.Add("VENDCD", this.cdx01_VENDCD.Value);
				param.Add("LANG_SET", this.UserInfo.LanguageShort);
				param.Add("USER_ID", this.UserInfo.UserID);

				DataSet ds = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_REPORT_BLANK"), param);
				HERexSection xmlSection = new HERexSection(ds, new HEParameterSet());
				report.Sections.Add("XML", xmlSection); 

				AxReportForm.ShowReport(report);
			}
			catch (Exception ex)
			{
				this.ErrorMessageAlert(this, ex);
			}
			finally
			{

			}
		}

		#endregion

		#region [ 유효성 검사 ]
		public bool IsArriveTimeValid()
		{
			
			//도착시간 확인
			if (this.txt01_ARRIV_TIME.IsEmpty)
			{
				//도착시간은 NULL 혀용
				return true;

				//도착시간을 확인 바랍니다.
				//this.MsgCodeAlert_ShowFormat("SRMMM-0013");
				//return false;
			}
			
			if (this.txt01_ARRIV_TIME.Value.ToString().Trim() == string.Empty || 
				this.txt01_ARRIV_TIME.Value.ToString().Length < 4 || 
				this.txt01_ARRIV_TIME.Value.ToString().Length > 5)
			{
				//도착시간을 확인 바랍니다.
				this.MsgCodeAlert_ShowFormat("SRMMM-0013");
				return false;
			}


			if (Convert.ToInt16(this.txt01_ARRIV_TIME.Value.ToString()) < 0)
			{
				//도착시간을 확인 바랍니다.
				this.MsgCodeAlert_ShowFormat("SRMMM-0013");
				return false;
			}

			if (Convert.ToInt16(this.txt01_ARRIV_TIME.Value.ToString()) > 2400)
			{
				//도착시간을 확인 바랍니다.
				this.MsgCodeAlert_ShowFormat("SRMMM-0013");
				return false;
			}

			return true;
		}

		/// <summary>
		/// 저장 Validation
		/// </summary>
		/// <param name="parameter"></param>
		/// <param name="corcd"></param>
		/// <param name="actionRow"></param>
		/// <returns></returns>
		public bool IsSaveValid_2(DataRow parameter, string corcd, int actionRow = -1)
		{
			decimal deliQty;
			decimal unitPackQty;

			if (System.Text.Encoding.UTF8.GetByteCount(parameter["VEND_LOTNO"].ToString()) > 30)
			{
				//{0}번째 행에 {1}는 {2}bytes이상 입력할 수 없습니다.
				this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "VEND_LOTNO"), 30);
				return false;
			}
			if (System.Text.Encoding.UTF8.GetByteCount(parameter["CHANGE_4M"].ToString()) > 4000)
			{
				//{0}번째 행에 {1}는 {2}bytes이상 입력할 수 없습니다.
				this.MsgCodeAlert_ShowFormat("SRMVM-0016", actionRow, Util.GetHeaderColumnName(Grid01, "CHANGE_4M"), 4000);
				return false;
			}

			if (this.df01_ARRIV_DATE.IsEmpty)
			{
				//도착일자를 확인 바랍니다.
				this.MsgCodeAlert_ShowFormat("SRMMM-0021"); 
				return false;
			}

			//등록모드일 경우 도착시간 확인
			//if (this.txt01_ARRIV_TIME.IsEmpty || this.txt01_ARRIV_TIME.Value.ToString().Length < 4 || this.txt01_ARRIV_TIME.Value.ToString().Length > 5)
			if (this.txt01_ARRIV_TIME.IsEmpty)
			{
				//도착시간  NULL 허용
			}
			else if (this.txt01_ARRIV_TIME.Value.ToString().Length < 4 || this.txt01_ARRIV_TIME.Value.ToString().Length > 5)
			{
				//도착시간을 확인 바랍니다.
				this.MsgCodeAlert_ShowFormat("SRMMM-0013");
				return false;
			}
			else
			{
				if (Convert.ToInt16(this.txt01_ARRIV_TIME.Value.ToString()) < 0)
				{
					//도착시간을 확인 바랍니다.
					this.MsgCodeAlert_ShowFormat("SRMMM-0013");
					return false;
				}
				if (Convert.ToInt16(this.txt01_ARRIV_TIME.Value.ToString()) > 2400)
				{
					//도착시간을 확인 바랍니다.
					this.MsgCodeAlert_ShowFormat("SRMMM-0013");
					return false;
				}
			}

			// 적입량 필수 입력값
			if (parameter["UNIT_PACK_QTY"].ToString().Equals(""))
			{
				//{0}번째 행의 {1}를(을) 입력해주세요.
				this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "UNIT_PACK_QTY"));
				return false;
			}

			// 적입량은 0이 될 수 없다.
			if (parameter["UNIT_PACK_QTY"].ToString().Equals("0"))
			{
				//{0}번째 행의 {1} 값은 0보다 커야 합니다.
				this.MsgCodeAlert_ShowFormat("SRMMM-0038", actionRow, Util.GetHeaderColumnName(Grid01, "UNIT_PACK_QTY"));
				return false;
			}

			// 제조일자 필수 입력값
			if (parameter["PRDT_DATE"].ToString().Equals(""))
			{
				//{0}번째 행의 {1}를(을) 입력해주세요.
				this.MsgCodeAlert_ShowFormat("COM-00904", actionRow, Util.GetHeaderColumnName(Grid01, "PRDT_DATE"));
				return false;
			}

			// 납품량 필수 입력값
			if (parameter["DELI_QTY"].ToString().Equals(""))
			{
				//{0}행의 납품 수량을 입력 하세요.
				this.MsgCodeAlert_ShowFormat("SRMMM-0014", actionRow);
				return false;
			}

			// 납품량은 0이 될 수 없다.
			if (parameter["DELI_QTY"].ToString().Equals("0"))
			{
				//{0}번째 행의 {1} 값은 0보다 커야 합니다.
				this.MsgCodeAlert_ShowFormat("SRMMM-0038", actionRow, Util.GetHeaderColumnName(Grid01, "DELI_QTY"));
				return false;
			}

			unitPackQty = Convert.ToDecimal(parameter["UNIT_PACK_QTY"].ToString());
			deliQty = Convert.ToDecimal(parameter["DELI_QTY"].ToString());

			
			// 국내&내수는 납품량=적입량. 그 외는 납품량/적입량 = 최대 1,000
			if (!(corcd.Equals("1000") && cbo01_PURC_ORG.Value.Equals("1A1100")))
			{
				if (deliQty / unitPackQty > 1000)
				{
					//{0}행의 박스수량은 1000보다 작아야 합니다.
					this.MsgCodeAlert_ShowFormat("SRMMM-0037", actionRow);
					return false;
				}
			}
			

			//2015-02-25 도착일자, 납품일자 체크로직 추가함. 도착일자는 납품일자와 같거나 늦어야 함.
			DateTime DELI_DATE = Convert.ToDateTime(this.df01_DELI_DATE.Value);
			DateTime ARRIV_DATE = Convert.ToDateTime(this.df01_ARRIV_DATE.Value);

			if (DateTime.Compare(ARRIV_DATE, DELI_DATE) < 0)
			{
				//도착일자는 납품일자보다 늦거나 같아야 합니다.
				this.MsgCodeAlert("SRMMM-0020");
				return false;
			}

			//상품매출 입고검사표는 잔량확인을 하지 않는다.
			if (!this.cbo01_PURC_PO_TYPE.Value.Equals("1K10"))
			{
				//잔량 확인
				string vendCd = this.cdx01_VENDCD.Value;
				string deliDate = ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd");
				string pono = parameter["PONO"].ToString();
				string ponoSeq = parameter["PONO_SEQ"].ToString();
				if (!IsSaveValidRemainQty(pono, ponoSeq, vendCd, deliDate, deliQty)) return false;
			}

			return true;
		}

		/// <summary>
		/// 잔량정보 확인
		/// </summary>
		/// <param name="pono"></param>
		/// <param name="ponoSeq"></param>
		/// <param name="vendcd"></param>
		/// <param name="noteCrtDate"></param>
		/// <param name="deliQty"></param>
		/// <returns></returns>
		public bool IsSaveValidRemainQty(string pono, string ponoSeq, string vendcd, string deliDate, decimal deliQty)
		{
			HEParameterSet param = new HEParameterSet();
			param.Add("PONO", pono);
			param.Add("PONO_SEQ", ponoSeq);
			param.Add("VENDCD", vendcd);
			param.Add("DELI_DATE", deliDate);

			DataSet source = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "GET_REMAIN_QTY"), param);

			if (source.Tables.Count == 0)
			{
				//선택한 발주번호에 대한 잔량정보가 존재하지 않습니다.
				this.MsgCodeAlert("SRMMM-0029");
				return false;
			}
			if (source.Tables[0].Rows.Count == 0)
			{
				//선택한 발주번호에 대한 잔량정보가 존재하지 않습니다.
				this.MsgCodeAlert("SRMMM-0029");
				return false;
			}

			decimal remainQty = Convert.ToDecimal(source.Tables[0].Rows[0]["REMAIN_QTY"]);

			if (deliQty > remainQty)
			{
				//잔량이 부족합니다.
				this.MsgCodeAlert("SRMMM-0030");
				return false;
			}

			return true;
		}

		/// <summary>
		/// 조회 Validation
		/// </summary>
		/// <returns></returns>
		public bool IsQueryValidation()
		{            
			// 조회용 Validation
			if (this.cdx01_VENDCD.IsEmpty)
			{
				//{0}를(을) 입력해주세요.
				this.MsgCodeAlert_ShowFormat("EP20S01-003", "cdx01_VENDCD", lbl01_VEND.Text);
				return false;
			}
			if (this.df01_DELI_DATE.IsEmpty)
			{
				//{0}를(을) 입력해주세요.
				this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_DELI_DATE", lbl01_DELI_DATE.Text);
				return  false;
			}
			if (this.df01_ARRIV_DATE.IsEmpty)
			{
				//{0}를(을) 입력해주세요.
				this.MsgCodeAlert_ShowFormat("EP20S01-003", "df01_ARRIV_DATE", lbl01_ARRIV_DATE.Text);
				return false;
			}
			//if (this.cbo01_PURC_PO_TYPE.IsEmpty)
			//{
			//    //{0}를(을) 입력해주세요.
			//    this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_PO_TYPE", lbl01_PURC_PO_TYPE.Text);
			//    return false;
			//}
			if (this.cbo01_PURC_ORG.IsEmpty)
			{
				//{0}를(을) 입력해주세요.
				this.MsgCodeAlert_ShowFormat("EP20S01-003", "cbo01_PURC_ORG", lbl01_PURC_ORG.Text);
				return false;
			}

			return true;
		}

		#endregion

		#region [ 이벤트 ]

		protected void cbo01_PURC_PO_TYPE_Change(object sender, DirectEventArgs e)
		{
			this.initGrid();
		}

		protected void cbo01_PURC_ORG_Change(object sender, DirectEventArgs e)
		{
			if (cbo01_PURC_ORG.SelectedItem.Value.Equals("1A1110"))
			{
				this.cbo01_PURC_PO_TYPE.SelectedItem.Value = "1KMA";
				this.cbo01_PURC_PO_TYPE.UpdateSelectedItems();
			}

			this.initGrid();
		}

		//2018.01.23 글로벌표준 검사성적서 입력 팝업 사용하지 않음.
		///// <summary>
		///// 더블클릭시 검사성적서 등록 팝업 표시한다.
		///// </summary>
		///// <param name="qty"></param>
		///// <param name="partno"></param>
		///// <param name="barcode"></param>
		//[DirectMethod]
		//public void Cell_DoubleClick(string qty, string partno, string barcode)
		//{
		//    // 그리드의 경우 ID 를 앞에 "GRID_" 를 붙여서 사용
		//    HEParameterSet set = new HEParameterSet();
		//    set.Add("BIZCD", this.cbo01_BIZCD.Value);
		//    set.Add("BARCODE", barcode);
		//    set.Add("PARTNO", partno);
		//    set.Add("VENDCD", this.cdx01_VENDCD.Value);
		//    set.Add("QTY", qty);            
		//    set.Add("DELI_DATE", ((DateTime)this.df01_DELI_DATE.Value).ToString("yyyy-MM-dd"));
		//    set.Add("DELI_CNT", "0");
		//    set.Add("NOTE_TYPE", "T");           
		//    set.Add("VINNM", "");

		//    Util.UserPopup(this, this.UserHelpURL.Text, set, "HELP_QA23001P1", "Popup", Convert.ToInt32(this.PopupWidth.Text), Convert.ToInt32(this.PopupHeight.Text));
		//}


		#endregion

		#region [ 헬프,콤보상자 관련 처리 ]

		//검색조건을 바꾸면 그리드 초기화 및 입력필드 초기화
		public void changeCondition(object sender, DirectEventArgs e)
		{
			this.initGrid();
		}
	   
		// 초기화
		private void initGrid()
		{
			this.txt01_ARRIV_TIME.Value = string.Empty;
			this.df01_ARRIV_DATE.SetValue(DateTime.Now);
			this.txt01_TRUCK_NO.Value = string.Empty;

			this.Store1.RemoveAll();
		}

		/// <summary>
		/// CodeBox_Click
		/// 코드박스 Before 버튼클릭 핸들러(버튼 클릭시 사업장 정보 넘겨줌)
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		public void cdx01_STR_LOC_BeforeDirectButtonClick(object sender, DirectEventArgs e)
		{
			// UserPopup 일 경우 넘어가는 파라메터 샘플코드 
			EP.UI.EPCodeBox cdx = (EP.UI.EPCodeBox)sender;

			cdx.UserParamSet = new HEParameterSet();
			if (this.cbo01_BIZCD.Value == null)
				cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.SelectedItem.Value);
			else
				cdx.UserParamSet.Add("BIZCD", this.cbo01_BIZCD.Value);
		}
		#endregion


        private void Box_Barcode_Print(string deliDate, int deliCnt)
        {
            try
            {
                HEParameterSet param = new HEParameterSet();

                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("BIZCD", this.cbo01_BIZCD.Value);
                param.Add("DELI_DATE", deliDate);
                param.Add("DELI_CNT", deliCnt);
                param.Add("VENDCD", this.cdx01_VENDCD.Value);
                param.Add("PURC_PO_TYPE", this.cbo01_PURC_PO_TYPE.Value);
                param.Add("PURC_ORG", this.cbo01_PURC_ORG.Value);
                param.Add("LANG_SET", this.UserInfo.LanguageShort);

                DataSet srcDs = EPClientHelper.ExecuteDataSet(string.Format("{0}.{1}", pakageName, "INQUERY_BOX_PRINT"), param);


                string PRINT_SIZE = cbo01_PRINT_SIZE.Value.ToString();
                HERexReport report = new HERexReport(this.UserInfo.UserID, this.UserInfo.UserName, true);
                report.ReportName = "1000/SRM_MM/SRM_MM22011" + PRINT_SIZE;

                HERexSection mainSection = new HERexSection();
                mainSection.ReportParameter.Add("TYPE", "1"); //SET 수
                report.Sections.Add("MAIN", mainSection);

                HERexSection xmlSection = new HERexSection(srcDs, new HEParameterSet());
                report.Sections.Add("XML", xmlSection); 

                AxReportForm.ShowReport(report);
            }
            catch (Exception ex)
            {
                this.ErrorMessageAlert(this, ex);
            }
            finally
            {

            }
        }
	}
}
