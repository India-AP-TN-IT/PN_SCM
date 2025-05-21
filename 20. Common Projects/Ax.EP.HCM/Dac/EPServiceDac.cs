using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using TheOne.Data;
using TheOne.Data.Odp;
using TheOne.Data.SqlClient;
using TheOne.Transactions;
//using Ax.EP.Utility;
//using Ax.EP.Utility.Security;
using HE.Framework.Core;
using HE.Framework.Transactions;

namespace Ax.EP.HCM
{
    public class EPServiceDac : HE.Framework.Transactions.LocalDacBase
    {
        private const string DEFAULT_CURSOR = "OUT_CURSOR";

        public EPServiceDac()
        {
        }

        public EPServiceDac(string dbName)
            : base(dbName)
        {
        }

        public DataSet ExecuteDataSet(string procedureName, HEParameterSet parameterSet, string[] cursorNames)
        {
            DBParamCollection parameters = this.DbAccess.CreateParamCollection(true);
            if (cursorNames == null || cursorNames.Length < 1)
            {
                Populate(parameters, parameterSet, DEFAULT_CURSOR);
            }
            else
            {
                Populate(parameters, parameterSet, cursorNames);
            }

            if (procedureName.StartsWith("$SQL$") == true)
            {
                return this.DbAccess.ExecuteSqlDataSet(procedureName.Replace("$SQL$", ""), parameters);
            }
            else
            {
                return this.DbAccess.ExecuteSpDataSet(procedureName, parameters);
            }
        }

        public void ExecuteDataSet(string procedureName, HEParameterSet parameterSet, DataSet ds, string tableName)
        {
            DBParamCollection parameters = this.DbAccess.CreateParamCollection(true);
            Populate(parameters, parameterSet, DEFAULT_CURSOR);

            this.DbAccess.ExecuteSp(procedureName, tableName, ds, parameters);
        }        

        public int ExecuteNonQuery(string procedureName, HEParameterSet parameterSet)
        {
            DBParamCollection parameters = this.DbAccess.CreateParamCollection(true);
            Populate(parameters, parameterSet);

            return this.DbAccess.ExecuteSpNonQuery(procedureName, parameters);
        }

        public int ExecuteNonQuery(string procedureName, List<HEParameterSet> parameterSetList)
        {
            int count = 0;
            foreach (HEParameterSet parameter in parameterSetList)
            {
                count += ExecuteNonQuery(procedureName, parameter);
            }

            return count;
        }

        public int ExecuteNonQuery(string procedureName, DataTable dt)
        {
            int count = 0;
            foreach (DataRow row in dt.Rows)
            {
                DBParamCollection parameters = this.DbAccess.CreateParamCollection(true);
                Populate(parameters, row);

                count += this.DbAccess.ExecuteSpNonQuery(procedureName, parameters);
            }

            return count;
        }
        
        public object ExecuteScalar(string procedureName, HEParameterSet parameterSet)
        {
            DBParamCollection parameters = this.DbAccess.CreateParamCollection(true);
            Populate(parameters, parameterSet);

            return this.DbAccess.ExecuteSpScalar(procedureName, parameters);
        }

        private void Populate(DBParamCollection parameters, HEParameterSet parameterSet, params string[] cursorNames)
        {
            if (parameters is OdpParamCollection)
            {
                // Oracle (ODP.NET)
                HEDACHelper.SetParameter((OdpParamCollection)parameters, parameterSet, cursorNames);
            }
            else if (parameters is SqlParamCollection)
            {
                // MSSQL
                HEDACHelper.SetParameter((SqlParamCollection)parameters, parameterSet);
            }
            //else if (parameters is DB2ParamCollection)
            //{
            //  // DB2
            //  GDDACHelper.SetParameter((DB2ParamCollection)parameters, parameterSet);
            //}
        }

        private void Populate(DBParamCollection parameters, DataRow row)
        {
            if (parameters is OdpParamCollection)
            {
                // Oracle (ODP.NET)
                HEDACHelper.SetParameter((OdpParamCollection)parameters, row);
            }
            else if (parameters is SqlParamCollection)
            {
                // MSSQL
                HEDACHelper.SetParameter((SqlParamCollection)parameters, row);
            }
            //else if (parameters is DB2ParamCollection)
            //{
            //  // DB2
            //  GDDACHelper.SetParameter((DB2ParamCollection)parameters, row);
            //}
        }
    }
}
