using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using TheOne.UIModel;
using Ext.Net;
using Ax.EP.Utility;
using Ax.EP.Utility.Security;
using HE.Framework.Core;

namespace Ax.EP.WP.Mobile.MBase
{
    /// <summary>
    /// 메인화면 EPMain(EPMain)
    /// </summary>
    /// <remarks>메인 화면은 메뉴와 탭으로 구성되어있다.</remarks>
    public partial class EPMain : Ax.EP.Utility.BasePage
    {
        #region 초기화 메서드

        public EPMain()
        {
            this.RequireAuthentication = true;
            this.RequireAuthority = false;
            this.IsMobilePage = true;   
        }

        /// <summary>
        /// Handles the Load event of the Page control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        /// <remarks></remarks>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !X.IsAjaxRequest)
            {
                // 빌어먹을 캐시를 사용하지 않는다.
                //Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
                //Response.Cache.SetNoStore();

                // 로그인후 팝업 공지사항 표시
                ShowNotice();

                //사용자 명 및 로그 카운트 설정

                try
                {
                    HEParameterSet param = new HEParameterSet();
                    param.Add("SYSTEMCODE", Util.SystemCode);

                    DataSet result = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.GET_LOGIN_COUNT", param);

                    //LabelLoginInfo.Text = Util.UserInfo.UserName;
                    //LabelLogCount.Text = result.Tables[0].Rows[0]["CNT"].ToString();
                }
                catch (Exception ex)
                {
                    this.ErrorMessageAlert(this, ex);  // Error message server logging and Display message on UI Screen
                }
                finally
                {
                }

                //TabMain.Loader = new ComponentLoader();
                //TabMain.Loader.Url = "~/Home/" + EPAppSection.ToString("MAIN_CONTENT_PATH") + ".aspx";
                //TabMain.Loader.Mode = LoadMode.Frame;

                //if (Util.UserInfo.CertCourse.Equals("T4A"))
                //    ImageButtonChangePassword.StyleSpec = "display:none;";       // AD유저면 패스워드 변경 메뉴 숨김
                //else
                //    CheckPasswordChange();                          // DB유저면 패스워드 유효기간 확인

                //InitMenu();

                ImageButtonLogout.Listeners.Click.Handler = "logoutHandler('" + Library.getMessage("Logout") + "')";
                ImageButtonHome.Listeners.Click.Handler = "document.location.reload(); ";
            }
        }

        //// 인증 검사 (실패하면 로그인 페이지로 이동함)
        //protected override void Authenticate()
        //{
        //    try
        //    {
        //        base.Authenticate();
        //    }
        //    catch (Exception ex)
        //    {
        //        // 인증되지 않은 사용자는 로그인 페이지로 이동
        //        FormsAuthentication.RedirectToLoginPage();
        //    }
        //}

        /// <summary>
        /// 유효일자 90일 지났을 경우, 패스워드 초기화일 경우, Active Directory가 아닐 경우 비밀번호 변경창이 뜬다.
        /// </summary>
        /// <remarks></remarks>
        private void CheckPasswordChange()
        {
            try
            {
                // 패스워드 유효기간을 가져온다.
                int pwdChangePeriod;
                try { pwdChangePeriod = int.Parse(Ax.EP.Utility.EPAppSection.ToString("PasswordChangePeriod")); }
                catch { pwdChangePeriod = 90; } 

                HEParameterSet param = new HEParameterSet();
                param.Add("USER_ID", Util.UserInfo.UserID);
                param.Add("LANG_SET", Util.UserInfo.LanguageShort);
                param.Add("PWDPERIOD", pwdChangePeriod);
                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EPSERVICE.GET_PWDVALIDATE", param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows[0]["PTYPE"].ToString().Equals("3")) return;

                    ArrayList aVal = new ArrayList();
                    if (ds.Tables[0].Rows[0]["PTYPE"].ToString().Equals("1"))
                    {
                        aVal.Add(ds.Tables[0].Rows[0]["PWD_VALID_DATE"].ToString());
                        aVal.Add(ds.Tables[0].Rows[0]["REST_DATE"].ToString());
                        PopupValid("Popup", "Password expiration guidance", 361, 270, "1", aVal);
                    }
                    else
                        PopupValid("Popup", "Change Password", 361, 470, "0", aVal);
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

        #endregion

        #region DirectMethod

        /// <summary>
        /// 탭을 생성하는 메서드2
        /// 수정작업 2013년 8월 26일 수정
        /// </summary>
        /// <param name="menuUrl">The menu URL.</param>
        /// <param name="fullPath">The full path.</param>
        /// <param name="type">The type.</param>
        /// <param name="prm">The PRM.</param>
        /// <remarks>상단 메뉴를 선택하면 탭이 생성된다.</remarks>
        [DirectMethod]
        public void MakeTap2(string menuId, string fullPath, string type, string prm)
        {
            string menuName = this.GetMenuName2(menuId);
            if (type.Equals("1"))
            {
                //일반 탭 생성               
                Ext.Net.Panel tab = new Ext.Net.Panel();
                tab.ID = menuId;
                tab.Title = menuName;
                tab.Closable = true;
                tab.TabConfig = new Ext.Net.Button();
                tab.TabConfig.ToolTip = "[" + menuId + "] " + menuName;
                tab.TabConfig.Height = Unit.Pixel(28);

                tab.Loader = new ComponentLoader();
                tab.Loader.Url = "~/" + fullPath;

                tab.Loader.LoadMask.ShowMask = true;
                tab.Loader.LoadMask.Msg = "Loading " + "[" + menuId + "] " + menuName + "... ";
                tab.Loader.Mode = LoadMode.Frame;

                //TabPanel1.Items.Add(tab);
                //tab.Render(); // added
                //TabPanel1.SetActiveTab(tab);
            }
            else
            {
                //// order tab 생성
                //char[] delimter1 = { ',' };
                //char[] delimter2 = { ':' };
                //string[] firstParam = prm.Split(delimter1);

                //string[] arrParams = null;
                //StringBuilder sb = new StringBuilder();

                //for (int i = 0; i < firstParam.Count(); i++)
                //{
                //    arrParams = firstParam[i].Split(delimter2);
                //    if (i == 0)
                //        sb.Append("?" + arrParams[0] + "=" + arrParams[1].Replace("_COMMA_", ",").Replace("_COLON_", ":"));
                //    else
                //        sb.Append("&" + arrParams[0] + "=" + arrParams[1].Replace("_COMMA_", ",").Replace("_COLON_", ":"));
                //}

                Ext.Net.Panel tab = new Ext.Net.Panel();
                tab.ID = menuId;
                tab.Title = menuName;
                tab.Closable = true;
                tab.TabConfig = new Ext.Net.Button();
                tab.TabConfig.ToolTip = "[" + menuId + "] " + menuName;

                tab.Loader = new ComponentLoader();
                tab.Loader.Url = "~/" + fullPath + prm;

                tab.Loader.LoadMask.ShowMask = true;
                tab.Loader.LoadMask.Msg = "Loading " + "[" + menuId + "] " + menuName + "... ";
                tab.Loader.Mode = LoadMode.Frame;

                //TabPanel1.Items.Add(tab);
                //tab.Render(); // added

                //TabPanel1.SetActiveTab(tab);
            }
        }


        /// <summary>
        /// 트리뷰 노드 재 생성
        /// </summary>
        /// <returns>JSON</returns>
        [DirectMethod]
        public string RefreshMenu()
        {
            //Panel2.Title = PgmTitle.Text;

            //MenuManager menuManager = CreateMenuManager(GroupCd.Text);
            //if (menuManager.Items.Count == 0) Panel2.Title = "권한없음 (No permission)";

            //Ext.Net.NodeCollection nodes = new NodeCollection();        // v2.x

            //if (menuManager.TopLevelItems.Count > 0)
            //    FillTreeNode(nodes, menuManager.TopLevelItems[0]);

            //return nodes.ToJson();
            return null;
        }

        #endregion

        #region 트리생성, 노드생성 및 노드 재생성

        /// <summary>
        /// 트리뷰 생성 및 메뉴 데이터 가져오기
        /// </summary>
        private void InitMenu()
        {
            try
            {
                MenuManager menuManager = CreateMenuManager();
                MakeButtonPanel(menuManager);

                //활성화된 첫번째 대메뉴를 화면에 펼침
                for (int i = 0; i < menuManager.TopLevelItems.Count; i++)
                {
                    if (menuManager.TopLevelItems[i].Enabled)
                    {
                        MakeTreePanel(menuManager.TopLevelItems[i]);
                        return;
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

        private void MakeTreePanel(MenuItemInfo menuInfo)
        {
            PgmTitle.Text = menuInfo.Title;
            GroupCd.Text = menuInfo.ID;

            Ext.Net.TreePanel tree = new TreePanel();
            tree.ID = "TreePanel1";
            //tree.AutoScroll = true;
            tree.Scrollable = ScrollableOption.Both;

            tree.Split = false;
            tree.Border = false;
            tree.Region = Region.Center;
            tree.Listeners.ItemClick.Handler = "e.stopEvent(); if (record.data.href) { addTab(App.TabPanel1, record,'" + Util.UserInfo.UserID + "', '1', ''); }";
            tree.RootVisible = false;

            Ext.Net.ImageButton btnExpand = new Ext.Net.ImageButton();
            btnExpand.AlternateText = Util.UserInfo.LanguageShort.Equals("KO") ? "모두 펼치기" : "Expand All";
            btnExpand.Listeners.Click.Handler = tree.ClientID + ".expandAll();";
            btnExpand.ImageUrl = "/images/common/folder_open.gif";

            Ext.Net.ImageButton btnCollapse = new Ext.Net.ImageButton();
            btnCollapse.AlternateText = Util.UserInfo.LanguageShort.Equals("KO") ? "모두 접기" : "Collapse All";
            btnCollapse.Listeners.Click.Handler = "firstNodeExpand(" + tree.ClientID + ");";// + ".collapseAll();  ";
            btnCollapse.ImageUrl = "/images/common/folder_close.gif";
            btnCollapse.StyleSpec = "left:26px !important;";


            Toolbar toolBar = new Toolbar();
            toolBar.ID = "Toolbar";
            toolBar.Items.Add(btnExpand);
            toolBar.Items.Add(btnCollapse); 
            tree.TopBar.Add(toolBar);

            //Panel2.Title = menuInfo.Title;
            //this.Panel2.Items.Add(tree);

            FillTreeNode(tree.Root, menuInfo);
        }

        // 지정한 대분류의 메뉴 트리 노드 생성
        private void FillTreeNode(Ext.Net.NodeCollection roots, MenuItemInfo menuInfo)
        {
            if (roots == null)
            {
                roots = new Ext.Net.NodeCollection();
            }

            Ext.Net.Node rootNode = new Ext.Net.Node();
            //rootNode.NodeID = "Root";
            rootNode.Text = "Root";

            roots.Add(rootNode);

            Ext.Net.Node firsthNode = new Ext.Net.Node();
            firsthNode.Text = menuInfo.Title;
            firsthNode.Icon = Icon.FolderHome;
            firsthNode.Expanded = menuInfo.Expanded;
            
            rootNode.Children.Add(firsthNode);

            if (menuInfo.HasChildren)
                this.FillTreeNodeCollection(firsthNode, menuInfo.Children);
            else
                firsthNode.Leaf = true;
        }

        
        // 지정한 대분류의 메뉴 트리 노드 생성
        private void FillTreeNodeCollection(Ext.Net.Node parent, MenuItemInfoCollection menuInfoCollection)
        {
            foreach (MenuItemInfo currentMenuInfo in menuInfoCollection)
            {
                if (currentMenuInfo.Enabled)
                {
                    Ext.Net.Node node = new Ext.Net.Node();
                    node.Text = currentMenuInfo.Title;
                    node.NodeID = currentMenuInfo.ID;
                    node.Expanded = currentMenuInfo.Expanded;
                    node.Icon = Icon.FolderAdd;

                    if (currentMenuInfo.Action == MenuAction.OpenUI)
                    {
                        node.Icon = Icon.Layout;
                        node.Href = currentMenuInfo.Url.ToString();
                        node.Qtip = "[" + currentMenuInfo.ID + "] " + currentMenuInfo.Title;
                        node.Leaf = true;
                        parent.Icon = Icon.FolderTable;
                    }

                    parent.Children.Add(node);

                    if (currentMenuInfo.HasChildren)
                        FillTreeNodeCollection(node, currentMenuInfo.Children);
                    else
                        node.Leaf = true;
                }
            }
        }

        #endregion

        #region 대메뉴의 버튼 생성

        private void MakeButtonPanel(MenuManager menuManager)
        {
            Ext.Net.Panel mainMenuPanel = new Ext.Net.Panel();
            mainMenuPanel.Title = Util.UserInfo.LanguageShort.Equals("KO") ? "대메뉴" : "Main Menu";
            //mainMenuPanel.AutoScroll = true;
            mainMenuPanel.Scrollable = ScrollableOption.Both;
            mainMenuPanel.Split = true;
            mainMenuPanel.SplitterConfig = new BoxSplitter();
            mainMenuPanel.SplitterConfig.Height = 4;
            mainMenuPanel.SplitterConfig.Cls = "splitter_config";
            mainMenuPanel.Region = Region.South;
            mainMenuPanel.HeaderConfig = new PanelHeader();
            mainMenuPanel.HeaderConfig.Height = 30;
            mainMenuPanel.MinHeight = 60;
            mainMenuPanel.HeaderConfig.Padding = 5;

            int cnt = 0;
            for (int i = 0; i < menuManager.TopLevelItems.Count; i++)
            {
                if (menuManager.TopLevelItems[i].Enabled)
                {
                    cnt++;
                }
            }
            //mainMenuPanel.Height = Unit.Pixel(30 + (cnt * 32) - 2);
            mainMenuPanel.Height = Unit.Pixel(30 * (cnt + 1));

            mainMenuPanel.Collapsed = false;
            mainMenuPanel.Collapsible = true;
            mainMenuPanel.CtCls = "south-panel";

            //Session["mnuMENU"] = mainMenuPanel;

            foreach (MenuItemInfo menuInfo in menuManager.TopLevelItems)
            {
                if (menuInfo.Enabled)
                {
                    MakeButton(mainMenuPanel, menuInfo.ID.ToString(), menuInfo.Title, menuInfo.ExtraInfo);
                }

                // 권한이 하나도 없다면
                if (mainMenuPanel.Items.Count == 0)
                {
                    Ext.Net.Button ibtn = new Ext.Net.Button();
                    ibtn.ID = "ButtonNoPerm";
                    ibtn.Text = "권한없음 (No permission)";
                    ibtn.IconCls = "mainMenuIcon";
                    ibtn.Icon = Icon.Exclamation;
                    ibtn.TextAlign = ButtonTextAlign.Left;
                    ibtn.Region = Region.North;
                    ibtn.StyleSpec = "width:100%; height:30px; padding-left:4px; padding-right:4px;";
                    ibtn.Height = 30;
                    mainMenuPanel.Items.Add(ibtn);
                }
            }

            //Panel2.Items.Add(mainMenuPanel);
        }

        // 대 메뉴를 생성한다.
        private void MakeButton(Ext.Net.Panel mainMenuPanel, string groupcd, string title, string extraInfo)
        {
            Ext.Net.Button ibtn = new Ext.Net.Button();
            ibtn.ID = groupcd;
            ibtn.Text = title;
            ibtn.IconCls = "mainMenuIcon";
            
            string iconFileUrl = "/images/menuicon/" + extraInfo + ".png";
            if (System.IO.File.Exists(Server.MapPath(iconFileUrl)))
                ibtn.IconUrl = iconFileUrl;
            else
                ibtn.Icon = Icon.Computer;                
            
            ibtn.TextAlign = ButtonTextAlign.Left;
            ibtn.Region = Region.North;
            ibtn.Listeners.Click.Handler = "refreshTree(App.TreePanel1,'" + groupcd + "','" + title + "');";
            ibtn.StyleSpec = "width:100%; height:30px; padding-left:4px; padding-right:4px;";
            ibtn.Height = 30;
            mainMenuPanel.Items.Add(ibtn);
        }
        #endregion

        #region 트리메뉴 데이터 가져오기

        // 메뉴 트리 생성 (권한 없는 메뉴 항목은 Enabled = false)
        private MenuManager CreateMenuManager(string rootMenuId = null)
        {
            DataSet dsMenuList = GetMenuData(rootMenuId);
            DataSet dsAuthMenu = GetAuthMenu();

            MenuManager menuManager = new MenuManager();
            Dictionary<MenuItemInfo, string> menuItems = new Dictionary<MenuItemInfo, string>();

            foreach (DataRow row in dsMenuList.Tables[0].Rows)
            {
                MenuItemInfo menuItem = new MenuItemInfo();
                menuItem.ID = Convert.ToString(row["MENUID"]);
                menuItem.Title = Convert.ToString(row["MENUNAME"]);
                menuItem.Url = Convert.ToString(row["MENUDLLURL"]);
                menuItem.ExtraInfo = Convert.ToString(row["EXTRAINFO"]);
                menuItem.Hide = (string.Compare(row["MENUHIDE"].ToString(), "0", true) == 0) ? false : true;
                menuItem.Enabled = (string.Compare(row["USEYN"].ToString(), "0", true) == 0) ? false : true;
                menuItem.ForceEnabled = (string.Compare(row["FORCEENABLED"].ToString(), "0", true) == 0) ? false : true;
                menuItem.Action = (string.Compare(row["MENUACTION"].ToString(), "2", true) == 0) ? MenuAction.OpenUI : MenuAction.Expand;
                menuItem.Expanded = (string.Compare(row["EXPANDED"].ToString(), "0", true) == 0) ? false : true;

                string parentID = Convert.ToString(row["PARENTID"]);
                if (string.IsNullOrEmpty(parentID) || parentID.Equals("0"))
                {
                    parentID = null;
                }

                menuItems.Add(menuItem, parentID);
            }

            menuManager.LoadMenuItems<MenuItemInfo>(menuItems);

            foreach (DataRow row in dsAuthMenu.Tables[0].Rows)
            {
                // 권한없을때 오류 방지
                if (menuManager[row["MENUID"].ToString()] != null) menuManager.EnableMenuItem(Convert.ToString(row["MENUID"]));
            }

            return menuManager;
        }

        // 메뉴 트리 구조 데이터 반환
        private DataSet GetMenuData(string rootMenuId)
        {
            if (rootMenuId == null)
            {
                // 전체 메뉴 데이터
                HEParameterSet paramSet = new HEParameterSet();
                paramSet.Add("LANGUAGE", Util.UserInfo.LanguageShort);
                paramSet.Add("SYSTEMCODE", Util.SystemCode);

                return EPClientHelper.ExecuteDataSet("APG_EPSERVICE.INQUERY_MENULISTALL", paramSet);
            }
            else
            {
                // 하나의 대분류 메뉴 데이터                
                HEParameterSet paramSet = new HEParameterSet();
                paramSet.Add("LANGUAGE", Util.UserInfo.LanguageShort);
                paramSet.Add("SYSTEMCODE", Util.SystemCode);
                paramSet.Add("MENUID", rootMenuId);

                return EPClientHelper.ExecuteDataSet("APG_EPSERVICE.INQUERY_MENULIST", paramSet);

            }
        }

        // 권한 있는 메뉴 목록 반환
        private DataSet GetAuthMenu()
        {
            HEParameterSet paramSet = new HEParameterSet();
            paramSet.Add("USERID", Util.UserInfo.UserID);
            paramSet.Add("SYSTEMCODE", Util.SystemCode);

            return EPClientHelper.ExecuteDataSet("APG_EPSERVICE.INQUERY_AUTHMENU", paramSet);
        }

        #endregion

        #region 팝업 ( 공지사항 / 기타 / 등 )

        /// <summary>
        /// 팝업
        /// </summary>
        /// <remarks></remarks>
        private void ShowNotice()
        {
            try
            {
                HEParameterSet param = new HEParameterSet();
                param.Add("CORCD", Util.UserInfo.CorporationCode);
                param.Add("CUSTCD", Util.UserInfo.CustomerCD);
                param.Add("USER_DIV", Util.UserInfo.UserDivision);
                param.Add("USER_ID", Util.UserInfo.UserID);
                DataSet ds = EPClientHelper.ExecuteDataSet("APG_EP_XM23001.INQUERY_MAIN_POPUP", param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    StringBuilder sbCorcd = new StringBuilder();
                    StringBuilder sbSeq = new StringBuilder();

                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        if (i == 0)
                        {
                            sbCorcd.Append(ds.Tables[0].Rows[i]["CORCD"].ToString());
                            sbSeq.Append(ds.Tables[0].Rows[i]["NOTICE_SEQ"].ToString());
                        }
                        else
                        {
                            sbCorcd.Append("," + ds.Tables[0].Rows[i]["CORCD"].ToString());
                            sbSeq.Append("," + ds.Tables[0].Rows[i]["NOTICE_SEQ"].ToString());
                        }
                    }

                    X.Js.Call("noticePopup('" + sbSeq.ToString() + "', '" + sbCorcd.ToString() + "', " + PopupHelper.defaultPopupWidth.ToString() + ", " + PopupHelper.defaultPopupHeight.ToString() + ", 10, 200); dummy");
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
        /// 팝업
        /// </summary>
        /// <param name="sender">sender</param>
        /// <param name="e">e</param>
        /// <remarks>패스워드 변경을 누르면 팝업이 생성된다.</remarks>
        [DirectMethod]
        public void Popup(object sender, DirectEventArgs e)
        {
            if (!Util.UserInfo.CertCourse.Equals("T4D"))
            {
                this.Alert("Alert", "Password 변경은 DB 인증 사용자만 가능합니다.<br>The ability to change the password for database authentication users only.");
            }
            else
            {
                Ext.Net.Window win = new Window
                {
                    ID = "Popup",
                    Title = e.ExtraParams["chagePw"],
                    Width = Unit.Pixel(int.Parse(e.ExtraParams["width"])),
                    Height = Unit.Pixel(int.Parse(e.ExtraParams["height"])),
                    Modal = bool.Parse(e.ExtraParams["modal"]),
                    Collapsible = false,
                    Closable = true,
                    Maximizable = true,
                    Resizable = true,
                    Minimizable = false,
                    Hidden = true
                };

                win.Loader = new ComponentLoader();
                win.Loader.Url = e.ExtraParams["url"] + "?USER_ID=" + Util.UserInfo.UserID + "&type=2";
                win.Loader.Mode = LoadMode.Frame;
                win.Loader.AutoLoad = true;
                win.Loader.LoadMask.ShowMask = true;
                win.Loader.LoadMask.Msg = "Loading...";


                win.Render(this.Form);
                win.Show();
            }
        }

        /// <summary>
        /// 팝업
        /// </summary>
        /// <param name="sender">sender</param>
        /// <param name="e">e</param>
        /// <remarks>매뉴얼 다운을 받는 help창이 실행된다</remarks>
        [DirectMethod]
        public void PopupHelp(object sender, DirectEventArgs e)
        {
            Ext.Net.Window win = new Window
            {
                ID = "Popup",
                Title = e.ExtraParams["chagePw"],
                Width = Unit.Pixel(int.Parse(e.ExtraParams["width"])),
                Height = Unit.Pixel(int.Parse(e.ExtraParams["height"])),
                Modal = bool.Parse(e.ExtraParams["modal"]),
                Collapsible = false,
                Closable = true,
                Maximizable = true,
                Resizable = true,
                Minimizable = false,
                Hidden = true
            };

            win.Loader = new ComponentLoader();
            win.Loader.Url = e.ExtraParams["url"] + "?USER_ID=" + Util.UserInfo.UserID + "&type=2";
            win.Loader.Mode = LoadMode.Frame;
            win.Loader.AutoLoad = true;
            win.Loader.LoadMask.ShowMask = true;
            win.Loader.LoadMask.Msg = "Loading...";
            win.Render(this.Form);
            win.Show();
        }


        /// <summary>
        /// Popups the valid.
        /// </summary>
        /// <param name="popid">The popid.</param>
        /// <param name="poptitle">The poptitle.</param>
        /// <param name="popwidth">The popwidth.</param>
        /// <param name="popheight">The popheight.</param>
        /// <remarks></remarks>
        public void PopupValid(string popid, string poptitle, int popwidth, int popheight, string type, ArrayList aVal)
        {

            Ext.Net.Window win = new Window
            {
                ID = popid,
                Title = poptitle,
                Width = Unit.Pixel(popwidth),
                Height = Unit.Pixel(popheight),
                Modal = type.Equals("0") ? true : false,
                Collapsible = false,
                Closable = false,
                Maximizable = true,
                Minimizable = false,
                Resizable = true,
                Hidden = true
            };

            win.Loader = new ComponentLoader();
            win.Loader.Url = type.Equals("0")
                                ? "EPPwdChange.aspx?USER_ID=" + Util.UserInfo.UserID + "&type=1"
                                : "EPPwdExpire.aspx?Pwd_Date=" + aVal[0].ToString() + "&REST_DATE=" + aVal[1].ToString();
            win.Loader.Mode = LoadMode.Frame;
            win.Loader.AutoLoad = true;
            win.Loader.LoadMask.ShowMask = true;
            win.Loader.LoadMask.Msg = "Loading...";

            win.Render(this.Form);
            win.Show();
        }
        #endregion
    }
}