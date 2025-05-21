using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Ax.SRM.WP
{
    public partial class ImageView : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 자바스크립트를 통해 이미지 팝업창을 뛰울경우에 사용
            // 사용법1. ImageZoomPopup(this)                    --// 이미지 태그에서 직접 사용시 ( img 태그 zoom 속성="true" 또는 onclick 이벤트 이용 )
            // 사용법2. ImageZoomPopupUrl(실제 이미지 URL)      --// 직접 URL 지정시   ( DownloadImage 모듈과 연계 사용 가능 )

            if (!String.IsNullOrEmpty(Request["imgsrc"]))
            {
                this.SrcImg.Src = Request["imgsrc"];
                this.NewImg.Src = Request["imgsrc"];
            }
        }
    }
}