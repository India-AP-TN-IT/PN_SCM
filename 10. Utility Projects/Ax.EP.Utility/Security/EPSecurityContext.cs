using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Ax.EP.Utility.Security
{
    public class EPSecurityContext : TheOne.Security.SecurityContext
    {
        public const string KEY_NAME = "__ACLSTRING";
        private string _aclString;

        /// <summary>
        /// GSCSecurityContext 클래스의 새 인스턴스를 초기화합니다.
        /// </summary>
        /// <param name="aclString">권한 정보 문자열입니다. <br />
        /// "0:0:0"은 권한없음 표시 / "15:2147483647:0"은 모든권한 표시</param>
        public EPSecurityContext(string aclString) : base(aclString)
        {
            _aclString = aclString;
        }

        public EPSecurityContext(int basicACL, int extACL) : base(basicACL, extACL, null)
        {
            _aclString = String.Format("{0}:{1}:0", basicACL, extACL);
        }

        #region 속성  

        // 기본 권한으로 처리
        //CanSelect     조회(ButtonSearch)
        //CanDelete     삭제(ButtonDelete)
        //CanSave       저장(ButtonSave	)

        public new string ACLString
        {
            get { return _aclString; }
        }

        /// <summary>
        /// 초기화
        /// </summary>
        public bool CanReset
        {
            get { return base[1]; }
        }

        /// <summary>
        /// 처리
        /// </summary>
        public bool CanConduct
        {
            get { return base[2]; }
        }

        /// <summary>
        /// 인쇄
        /// </summary>
        public bool CanPrint
        {
            get { return base[3]; }
        }

        /// <summary>
        /// Down
        /// </summary>
        public bool CanDown
        {
            get { return base[4]; }
        }

        /// <summary>
        /// Upload
        /// </summary>
        public bool CanUpload
        {
            get { return base[5]; }
        }

        #endregion
    }
}
