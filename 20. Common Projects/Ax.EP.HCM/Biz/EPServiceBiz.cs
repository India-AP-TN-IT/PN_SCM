using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using TheOne.Transactions;
//using Ax.EP.Utility;
//using Ax.EP.Utility.Security;
using HE.Framework.Core;

namespace Ax.EP.HCM
{
    public class EPServiceBiz : HE.Framework.Transactions.LocalBizBase, IDisposable
    {
        public EPServiceBiz()
        {
        }

        public EPServiceBiz(string dbName)
            : base(dbName)
        {
        }

        private string GetTableName(int index)
        {
            return String.Format("Table{0}", index);
        }

        #region 트랜잭션 사용 안함

        [Transaction(TransactionOption.Supported)]
        public DataSet ExecuteDataSet(SelectCommand command)
        {
            using (EPServiceDac dac = new EPServiceDac(this.DbName))
            {
                return dac.ExecuteDataSet(command.ProcedureName, command.Parameter, command.CursorNames);
            }
        }

        [Transaction(TransactionOption.Supported)]
        public DataSet ExecuteDataSet(List<SelectCommand> commands)
        {
            using (EPServiceDac dac = new EPServiceDac(this.DbName))
            {
                DataSet ds = new DataSet();
                for (int i = 0; i < commands.Count; i++)
                {
                    SelectCommand command = commands[i];
                    dac.ExecuteDataSet(command.ProcedureName, command.Parameter, ds, GetTableName(i));
                }

                return ds;
            }
        }

        [Transaction(TransactionOption.Supported)]
        public int ExecuteNonQuery(List<SaveCommand> commands)
        {
            using (EPServiceDac dac = new EPServiceDac(this.DbName))
            {
                int count = 0;

                for (int i = 0; i < commands.Count; i++)
                {
                    SaveCommand command = commands[i];
                    count += dac.ExecuteNonQuery(command.ProcedureName, command.ParametersList);
                }

                return count;
            }
        }

        [Transaction(TransactionOption.Supported)]
        public int ExecuteNonQuery(List<DataSetSaveCommand> commands)
        {
            using (EPServiceDac dac = new EPServiceDac(this.DbName))
            {
                int count = 0;

                for (int i = 0; i < commands.Count; i++)
                {
                    DataSetSaveCommand command = commands[i];
                    DataSet ds = DataSetSerializer.ToDataSet(command.DataSetBuffer);
                    count += dac.ExecuteNonQuery(command.ProcedureName, ds.Tables[0]);
                }

                return count;
            }
        }

        [Transaction(TransactionOption.Supported)]
        public object ExecuteScalar(SelectCommand command)
        {
            using (EPServiceDac dac = new EPServiceDac(this.DbName))
            {
                return dac.ExecuteScalar(command.ProcedureName, command.Parameter);
            }
        }

        #endregion

        #region 트랜잭션 사용

        public DataSet ExecuteDataSetTx(SelectCommand command)
        {
            using (EPServiceDac dac = new EPServiceDac(this.DbName))
            {
                return dac.ExecuteDataSet(command.ProcedureName, command.Parameter, command.CursorNames);
            }
        }

        public DataSet ExecuteDataSetTx(List<SelectCommand> commands)
        {
            using (EPServiceDac dac = new EPServiceDac(this.DbName))
            {
                DataSet ds = new DataSet();
                for (int i = 0; i < commands.Count; i++)
                {
                    SelectCommand command = commands[i];
                    dac.ExecuteDataSet(command.ProcedureName, command.Parameter, ds, GetTableName(i));
                }

                return ds;
            }
        }

        public int ExecuteNonQueryTx(List<SaveCommand> commands)
        {
            using (EPServiceDac dac = new EPServiceDac(this.DbName))
            {
                int count = 0;

                for (int i = 0; i < commands.Count; i++)
                {
                    SaveCommand command = commands[i];
                    count += dac.ExecuteNonQuery(command.ProcedureName, command.ParametersList);
                }

                return count;
            }
        }

        public int ExecuteNonQueryTx(List<DataSetSaveCommand> commands)
        {
            using (EPServiceDac dac = new EPServiceDac(this.DbName))
            {
                int count = 0;

                for (int i = 0; i < commands.Count; i++)
                {
                    DataSetSaveCommand command = commands[i];
                    DataSet ds = DataSetSerializer.ToDataSet(command.DataSetBuffer);
                    count += dac.ExecuteNonQuery(command.ProcedureName, ds.Tables[0]);
                }

                return count;
            }
        }

        public object ExecuteScalarTx(SelectCommand command)
        {
            using (EPServiceDac dac = new EPServiceDac(this.DbName))
            {
                return dac.ExecuteScalar(command.ProcedureName, command.Parameter);
            }
        }

        #endregion
    }
}
