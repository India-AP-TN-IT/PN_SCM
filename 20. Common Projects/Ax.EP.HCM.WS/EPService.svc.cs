using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
//using Ax.EP.Utility;
//using Ax.EP.Utility.Security;
using HE.Framework.ServiceModel;
using HE.Framework.Core;

namespace Ax.EP.HCM.WS
{
    public class EPService : TheOne.ServiceModel.ServiceBase, IHEService
    {
        public EPService() : base(false)
        {
        }

        public byte[] ExecuteDataSet(ServiceOption option, SelectCommand command)
        {
            using (EPServiceBiz biz = new EPServiceBiz(option.DatabaseName))
            {
                DataSet ds;
                if (option.TransactionType == TransactionType.Required)
                {
                    ds = biz.ExecuteDataSetTx(command);
                }
                else
                {

                    ds = biz.ExecuteDataSet(command);
             
                }
                return DataSetSerializer.ToArray(ds);
            }
        }

        public byte[] ExecuteDataSet(ServiceOption option, List<SelectCommand> commands)
        {
            using (EPServiceBiz biz = new EPServiceBiz(option.DatabaseName))
            {
                DataSet ds;
                if (option.TransactionType == TransactionType.Required)
                {
                    ds = biz.ExecuteDataSetTx(commands);
                }
                else
                {

                    ds = biz.ExecuteDataSet(commands);

                }
                return DataSetSerializer.ToArray(ds);
            }
        }

        public int ExecuteNonQuery(ServiceOption option, List<SaveCommand> commands)
        {
            using (EPServiceBiz biz = new EPServiceBiz(option.DatabaseName))
            {
                if (option.TransactionType == TransactionType.Required)
                {
                    return biz.ExecuteNonQueryTx(commands);
                }
                else
                {

                    return biz.ExecuteNonQuery(commands);
                }
            }
        }

        public int ExecuteNonQuery(ServiceOption option, List<DataSetSaveCommand> commands)
        {
            using (EPServiceBiz biz = new EPServiceBiz(option.DatabaseName))
            {
                if (option.TransactionType == TransactionType.Required)
                {
                    return biz.ExecuteNonQueryTx(commands);
                }
                else
                {

                    return biz.ExecuteNonQuery(commands);
                }
            }
        }

        public object ExecuteScalar(ServiceOption option, SelectCommand command)
        {
            using (EPServiceBiz biz = new EPServiceBiz(option.DatabaseName))
            {
                if (option.TransactionType == TransactionType.Required)
                {
                    return biz.ExecuteScalarTx(command);
                }
                else
                {

                    return biz.ExecuteScalar(command);
                }
            }
        }
    }
}
