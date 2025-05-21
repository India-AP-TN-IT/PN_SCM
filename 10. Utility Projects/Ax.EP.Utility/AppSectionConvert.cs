using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TheOne.Configuration;

namespace Ax.EP.Utility
{
    /// <summary>
    /// EPAppSection
    /// daedong.configtion 의 appSection 항목의 값을 읽어옵니다.
    /// </summary>
    public static class EPAppSection
    {
        public const string ErrorStackTrace = "ErrorStackTrace";
        public const string ErrorLogging = "ErrorLogging";
        public const string ActionLogging = "ActionLogging";

        /// <summary>
        /// ToBoolean 
        /// 지정한 이름의 값을 bool 타입으로 반환합니다.
        /// 지정한 이름이 있고 bool 타입으로 변환할 수 있으면 변환된 값을 반환하고,
        /// 그렇지 않으면 false를 반환합니다.
        /// </summary>
        /// <param name="name">appSection 에서 읽어올 키 이름입니다.</param>
        /// <returns>
        /// 지정한 이름이 있고 bool 타입으로 변환할 수 있으면 변환된 값이고,
        /// 그렇지 않으면 false 입니다.
        /// </returns>
        public static bool ToBoolean(string name)
        {
            string valueString = AppSectionFactory.AppSection[name];
            bool result = false;
            if (Boolean.TryParse(valueString, out result))
            {
                return result;
            }

            return false;
        }

        public static int ToInteger(string name)
        {
            string valueString = AppSectionFactory.AppSection[name];
            int result = 0;
            if (int.TryParse(valueString, out result))
            {
                return result;
            }
            return 0;
        }

        /// <summary>
        /// ToString
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static string ToString(string name)
        {
            string valueString = AppSectionFactory.AppSection[name];

            return valueString;
        }
    }
}
