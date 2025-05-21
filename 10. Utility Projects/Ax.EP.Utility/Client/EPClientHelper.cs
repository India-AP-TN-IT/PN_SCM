using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HE.Framework.Core;
using HE.Framework.ServiceModel;

namespace Ax.EP.Utility
{
    /// <summary>
    /// EPClientHelper
    /// </summary>
    public static class EPClientHelper
    {

        /// <summary>
        /// CleanUpData 데이터 정리 작업
        /// - 특수기호('<','>') 처리 : PARTNM의 내용중에서 특수 기호 부분 태그로 인식 방지
        /// - 모든 컬럼에 대해 특수기호 태그로 인식방지 로 변경
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        private static DataSet CleanUpData(DataSet ds)
        {
            for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
            {
                if (typeof(string).Equals(ds.Tables[0].Columns[i].DataType) && !ds.Tables[0].Columns[i].ColumnName.Equals("CONTENTS") && !ds.Tables[0].Columns[i].ColumnName.Equals("MESSAGE"))
                {
                    for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                    {
                        ds.Tables[0].Rows[j][i] = ds.Tables[0].Rows[j][i].ToString().Replace("<", "&lt;");
                        ds.Tables[0].Rows[j][i] = ds.Tables[0].Rows[j][i].ToString().Replace(">", "&gt;");
                    }

                }
            }

            return ds;
        }

        /// <summary>
        /// ExecuteDataSet 1개 이상의 결과셋을 반환하는 저장 프로시저를 호출합니다. 트랜잭션을 사용하지 않습니다.
        /// </summary>
        /// <param name="procedureName">저장 프로시저명 입니다.</param>
        /// <param name="parameter">키/값의 매개변수 정보입니다.</param>
        /// <param name="cursorNames">결과셋을 받기 위한 RefCursor 이름 배열입니다.(Oracle의 경우에만 사용됩니다.)</param>
        /// <returns>수행 결과가 들어있는 DataSet 입니다.</returns>
        /// <remarks>
        /// Oracle 의 경우 cursorNames가 null 이면, 기본 이름(OUT_CURSOR)이 사용됩니다. 
        /// 그 외 데이터베이스는 cursorNames를 무시합니다.
        /// </remarks>
        public static DataSet ExecuteDataSet(string procedureName, HEParameterSet parameter, params string[] cursorNames)
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                //return proxy.ExecuteDataSet(procedureName, parameter, cursorNames);
                return CleanUpData(proxy.ExecuteDataSet(procedureName, parameter, cursorNames));
            }
        }


        /// <summary>
        /// ExecuteDataSet 1개 이상의 결과셋을 반환하는 저장 프로시저를 호출합니다. 트랜잭션을 사용하지 않습니다.
        /// </summary>
        /// <param name="dbName">저장 프로시저명 입니다.</param>
        /// <param name="procedureName">저장 프로시저명 입니다.</param>
        /// <param name="parameter">키/값의 매개변수 정보입니다.</param>
        /// <param name="cursorNames">결과셋을 받기 위한 RefCursor 이름 배열입니다.(Oracle의 경우에만 사용됩니다.)</param>
        /// <returns>수행 결과가 들어있는 DataSet 입니다.</returns>
        /// <remarks>
        /// Oracle 의 경우 cursorNames가 null 이면, 기본 이름(OUT_CURSOR)이 사용됩니다. 
        /// 그 외 데이터베이스는 cursorNames를 무시합니다.
        /// </remarks>
        public static DataSet ExecuteDataSet(string dbName, string procedureName, HEParameterSet parameter, params string[] cursorNames)
        {
            using (EPClientProxy proxy = new EPClientProxy(dbName))
            {
                //return proxy.ExecuteDataSet(procedureName, parameter, cursorNames);
                return CleanUpData(proxy.ExecuteDataSet(procedureName, parameter, cursorNames));
            }
        }

        /// <summary>
        /// ExecuteDataSetTx 1개 이상의 결과셋을 반환하는 저장 프로시저를 호출합니다. 트랜잭션을 사용합니다.
        /// </summary>
        /// <param name="procedureName">저장 프로시저명 입니다.</param>
        /// <param name="parameter">키/값의 매개변수 정보입니다.</param>
        /// <param name="cursorNames">결과셋을 받기 위한 RefCursor 이름 배열입니다.(Oracle의 경우에만 사용됩니다.)</param>
        /// <returns>수행 결과가 들어있는 DataSet 입니다.</returns>
        /// <remarks>
        /// Oracle 의 경우 cursorNames가 null 이면, 기본 이름(OUT_CURSOR)이 사용됩니다. 
        /// 그 외 데이터베이스는 cursorNames를 무시합니다.
        /// </remarks>
        public static DataSet ExecuteDataSetTx(string procedureName, HEParameterSet parameter, params string[] cursorNames)
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                //return proxy.ExecuteDataSetTx(procedureName, parameter, cursorNames);
                return CleanUpData(proxy.ExecuteDataSetTx(procedureName, parameter, cursorNames));
            }
        }

        /// <summary>
        /// ExecuteDataSetTx 1개 이상의 결과셋을 반환하는 저장 프로시저를 호출합니다. 트랜잭션을 사용합니다.
        /// </summary>
        /// <param name="dbName">저장 프로시저명 입니다.</param>
        /// <param name="procedureName">저장 프로시저명 입니다.</param>
        /// <param name="parameter">키/값의 매개변수 정보입니다.</param>
        /// <param name="cursorNames">결과셋을 받기 위한 RefCursor 이름 배열입니다.(Oracle의 경우에만 사용됩니다.)</param>
        /// <returns>수행 결과가 들어있는 DataSet 입니다.</returns>
        /// <remarks>
        /// Oracle 의 경우 cursorNames가 null 이면, 기본 이름(OUT_CURSOR)이 사용됩니다. 
        /// 그 외 데이터베이스는 cursorNames를 무시합니다.
        /// </remarks>
        public static DataSet ExecuteDataSetTx(string dbName, string procedureName, HEParameterSet parameter, params string[] cursorNames)
        {
            using (EPClientProxy proxy = new EPClientProxy(dbName))
            {
                //return proxy.ExecuteDataSetTx(procedureName, parameter, cursorNames);
                return CleanUpData(proxy.ExecuteDataSetTx(procedureName, parameter, cursorNames));
            }
        }


        /// <summary>
        /// ExecuteNonQuery 결과값이 없는 저장 프로시저를 매개변수를 사용하여 1번 호출합니다. 트랜잭션을 사용합니다.
        /// </summary>
        /// <param name="procedureName">저장 프로시저 이름입니다.</param>
        /// <param name="parameter">키/값의 매개변수 정보입니다.</param>
        /// <returns>처리 결과입니다.</returns>
        public static int ExecuteNonQuery(string procedureName, HEParameterSet parameter)
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                return proxy.ExecuteNonQueryTx(procedureName, parameter);
            }
        }

        /// <summary>
        /// ExecuteNonQuery 결과값이 없는 저장 프로시저를 매개변수를 사용하여 1번 호출합니다. 트랜잭션을 사용합니다.
        /// </summary>
        /// <param name="dbName">저장 프로시저 이름입니다.</param>
        /// <param name="procedureName">저장 프로시저 이름입니다.</param>
        /// <param name="parameter">키/값의 매개변수 정보입니다.</param>
        /// <returns>처리 결과입니다.</returns>
        public static int ExecuteNonQuery(string dbName, string procedureName, HEParameterSet parameter)
        {
            using (EPClientProxy proxy = new EPClientProxy(dbName))
            {
                return proxy.ExecuteNonQueryTx(procedureName, parameter);
            }
        }

        /// <summary>
        /// ExecuteNonQuery 결과값이 없는 저장 프로시저를 매개변수를 사용하여 1번 호출합니다. 트랜잭션을 사용합니다.(여러데이터)
        /// </summary>
        /// <param name="procedureName">저장 프로시저 이름입니다.</param>
        /// <param name="parameter">키/값의 매개변수 정보입니다.</param>
        /// <returns>처리 결과입니다.</returns>
        public static int ExecuteNonQuery(string procedureName, List<HEParameterSet> parameters)
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                return proxy.ExecuteNonQueryTx(procedureName, parameters);
            }
        }

        /// <summary>
        /// ExecuteNonQuery 결과값이 없는 저장 프로시저를 매개변수를 사용하여 1번 호출합니다. 트랜잭션을 사용합니다.(여러데이터)
        /// </summary>
        /// <param name="dbName">저장 프로시저 이름입니다.</param>
        /// <param name="procedureName">저장 프로시저 이름입니다.</param>
        /// <param name="parameter">키/값의 매개변수 정보입니다.</param>
        /// <returns>처리 결과입니다.</returns>
        public static int ExecuteNonQuery(string dbName, string procedureName, List<HEParameterSet> parameters)
        {
            using (EPClientProxy proxy = new EPClientProxy(dbName))
            {
                return proxy.ExecuteNonQueryTx(procedureName, parameters);
            }
        }

        /// <summary>
        /// ExecuteNonQueryTx
        /// </summary>
        /// <param name="procedureName"></param>
        /// <param name="parameter"></param>
        /// <returns></returns>
        public static int ExecuteNonQueryTx(string procedureName, DataSet parameter)
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                return proxy.ExecuteNonQueryTx(procedureName, parameter);
            }
        }


        /// <summary>
        /// ExecuteNonQueryTx
        /// </summary>
        /// <param name="dbName"></param>
        /// <param name="procedureName"></param>
        /// <param name="parameter"></param>
        /// <returns></returns>
        public static int ExecuteNonQueryTx(string dbName, string procedureName, DataSet parameter)
        {
            using (EPClientProxy proxy = new EPClientProxy(dbName))
            {
                return proxy.ExecuteNonQueryTx(procedureName, parameter);
            }
        }

        /// <summary>
        /// MultipleExecuteNonQuery Master/Detail 방식의 저장 프로시저를 호출합니다. 트랜잭션을 사용합니다.
        /// </summary>
        /// <param name="masterProcedureName">Master 저장 프로시저 이름입니다.</param>
        /// <param name="masterParameter">Master 매개변수 정보입니다.</param>
        /// <param name="detailProcedureName">Detail 저장 프로시저 이름입니다.</param>
        /// <param name="detailParameters">Detail 매개변수 정보 컬레션입니다.</param>
        /// <returns>처리 결과입니다.</returns>
        public static int MultipleExecuteNonQuery(string masterProcedureName, HEParameterSet masterParameter,
            string detailProcedureName, List<HEParameterSet> detailParameters)
        {
            using (EPClientProxy proxy = new EPClientProxy())
            {
                ServiceOption option = new ServiceOption(proxy.DBName, TransactionType.Required);

                SaveCommand masterCommand = new SaveCommand(masterProcedureName, new List<HEParameterSet> { masterParameter });
                SaveCommand detailCommand = new SaveCommand(detailProcedureName, detailParameters);

                List<SaveCommand> commands = new List<SaveCommand>();
                commands.Add(masterCommand);
                commands.Add(detailCommand);

                return proxy.ExecuteNonQuery(option, commands);
            }
        }


        /// <summary>
        /// MultipleExecuteNonQuery Master/Detail 방식의 저장 프로시저를 호출합니다. 트랜잭션을 사용합니다.
        /// </summary>
        /// <param name="dbName">Master 저장 프로시저 이름입니다.</param>
        /// <param name="masterProcedureName">Master 저장 프로시저 이름입니다.</param>
        /// <param name="masterParameter">Master 매개변수 정보입니다.</param>
        /// <param name="detailProcedureName">Detail 저장 프로시저 이름입니다.</param>
        /// <param name="detailParameters">Detail 매개변수 정보 컬레션입니다.</param>
        /// <returns>처리 결과입니다.</returns>
        public static int MultipleExecuteNonQuery(string dbName, string masterProcedureName, HEParameterSet masterParameter,
            string detailProcedureName, List<HEParameterSet> detailParameters)
        {
            using (EPClientProxy proxy = new EPClientProxy(dbName))
            {
                ServiceOption option = new ServiceOption(proxy.DBName, TransactionType.Required);

                SaveCommand masterCommand = new SaveCommand(masterProcedureName, new List<HEParameterSet> { masterParameter });
                SaveCommand detailCommand = new SaveCommand(detailProcedureName, detailParameters);

                List<SaveCommand> commands = new List<SaveCommand>();
                commands.Add(masterCommand);
                commands.Add(detailCommand);

                return proxy.ExecuteNonQuery(option, commands);
            }
        }
    }
}
