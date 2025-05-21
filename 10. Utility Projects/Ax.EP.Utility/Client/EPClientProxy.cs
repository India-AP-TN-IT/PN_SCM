using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HE.Framework.ServiceModel;

namespace Ax.EP.Utility
{
    /// <summary>
    /// EPClientProxy
    /// </summary>
    public class EPClientProxy : HEClientProxy
    {
        /// <summary>
        /// EPClientProxy
        /// </summary>
        public EPClientProxy() //: base()
            : base(Ax.EP.Utility.EPAppSection.ToString("SYSTEM_DBNAME"), "EP", "EPService.svc", "customBindingMap")
        {
        }

        /// <summary>
        /// EPClientProxy
        /// </summary>
        /// <param name="dbName"></param>
        public EPClientProxy(string dbName)
            : base(dbName, "EP", "EPService.svc", "customBindingMap")
        {
        }
    }
}
