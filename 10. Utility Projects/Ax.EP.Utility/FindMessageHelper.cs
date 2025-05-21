extern alias dnlibpkg;

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;

using System.Reflection;

using dnlibpkg.dnlib.DotNet;
using dnlibpkg.dnlib.DotNet.Emit;

using HE.Framework.Core;
using System.Data;


namespace Ax.EP.Utility
{
    public class FindMessageHelper
    {
        public static void init(string serverPath){

            //string exePath = "C:\\Work\\Ax_SRM\\30. SRM Projects\\Ax.SRM.WP\\bin\\Ax.SRM.WP.dll";
            string moduleName = "Ax.SRM.WP";
            string exePath = serverPath + "bin\\"+moduleName+".dll";
            string pdbPath = serverPath + "bin\\"+moduleName+".pdb";

            // dll 및 pdb 둘중 하나가 없으면 그냥 pass 한다.
            if (!System.IO.File.Exists(exePath) || !System.IO.File.Exists(pdbPath)) return;

            ModuleDefMD module = ModuleDefMD.Load(exePath);
            module.LoadPdb();

            List<string> messageList = new List<string>();

            string[] message = { "GetCodeMessage", "MsgCodeAlert", "MsgCodeAlert", "MsgCodeAlert_ShowFormat", "getMessage" };

            try
            {
                string programName = "";
                foreach (TypeDef type in module.GetTypes())
                {
                    // 모바일은 제외
                    if (type.FullName.Contains("Mobile")) continue;

                    programName = type.Name.ToString();

                    if (programName.Equals("EPMain"))
                    {
                        //int a = 0;
                    }

                    int methodCount = 0;

                    foreach (MethodDef method in type.Methods)
                    {
                        methodCount++;

                        bool ismessageCode = false;
                        string messageCodeFirst = "";
                        string messageCodeLast = "";

                        if (method.Body == null) continue;
                        if (!method.Body.HasInstructions) continue;

                        int targetsequence = 0;
                        int currentSequence = 0;

                        int instructionCount = 0;

                        foreach (Instruction inst in method.Body.Instructions)
                        {
                            instructionCount++;

                            if (inst.OpCode == null) continue;
                            if (inst.OpCode.Name == null) continue;

                            if (inst.OpCode.Name.Equals("ldarg.0") && messageCodeFirst.Length.Equals(0))
                            {
                                targetsequence = 0;
                                ismessageCode = true;
                            }
                            else if (inst.OpCode.Name.Equals("call") && messageCodeFirst.Length.Equals(0))
                            {
                                
                                if (inst.Operand.ToString().Contains("get_MessageBox") || inst.Operand.ToString().Contains("get_Msg"))
                                {
                                    targetsequence = 1;
                                    ismessageCode = true;
                                }
                                
                            }
                            else if (inst.OpCode.Name.Equals("ldstr") && ismessageCode)
                            {
                                if (targetsequence == currentSequence)
                                {
                                    messageCodeFirst = inst.Operand.ToString();
                                    ismessageCode = false;
                                    currentSequence = 0;
                                    messageCodeLast = "";
                                }
                                else currentSequence++;
                            }
                            else if (inst.OpCode.Name.Equals("ldstr"))
                            {
                                messageCodeLast = inst.Operand.ToString();
                            }
                            else if (inst.OpCode.Name == "call" && messageCodeFirst.Length > 0)
                            {
                                foreach (string text in message)
                                {
                                    if (inst.Operand.ToString().Contains(text))
                                    {
                                        if (text.Equals("getMessage") && !messageCodeLast.Equals(String.Empty))
                                        {
                                            messageList.Add(programName + "," + messageCodeLast);
                                        }
                                        else
                                        {
                                            messageList.Add(programName + "," + messageCodeFirst);
                                        }
                                        messageCodeFirst = "";
                                        break;
                                    }
                                }
                            }
                            else if (inst.OpCode.Name.Equals("nop") || inst.OpCode.Name.Equals("pop") || inst.OpCode.Name.Equals("ceq")) messageCodeFirst = "";
                            else if (inst.OpCode.Name.Equals("stloc.0") || inst.OpCode.Name.Equals("brtrue.s"))// || inst.OpCode.Name.Equals("callvirt"))
                            {
                                messageCodeFirst = "";
                                ismessageCode = true;
                                targetsequence = 0;
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
                System.Diagnostics.Debug.Print(e.ToString());
            }

            //파일로 저장
            //File.WriteAllLines(exePath + ".txt", messageList.Select(str => CSStringConverter.Convert(str)));

            DataSet param = Util.GetDataSourceSchema("SYSTEMCODE", "MENUID", "CODE", "UDID");
            int count = messageList.Count;
            string udid = udid = DateTime.Now.Ticks.ToString();
            for (int i = 0; i < count; i++)
            {
                string[] item = messageList[i].Split(',');
                param.Tables[0].Rows.Add("SIS", item[0], item[1], udid);
            }

            using (EPClientProxy proxy = new EPClientProxy())
            {
                proxy.ExecuteNonQueryTx(string.Format("{0}.{1}", "APG_EPSERVICE", "SET_AXD1505"), param);
            }
        }
    }

    static class CSStringConverter
    {
        public static string Convert(string value)
        {
            var sb = new StringBuilder(value.Length + 10);

            sb.Append('"');

            for (int i = 0; i < value.Length; i++)
            {
                switch (value[i])
                {
                    //case '\'':
                    //    b.Append("\\'");
                    //    break;

                    case '\\':
                        sb.Append("\\\\");
                        break;

                    case '\x2028':
                    case '\x2029':
                        sb.Append(EscapeChar(value[i]));
                        break;

                    case char.MinValue:
                        sb.Append("\\0");
                        break;

                    case '\t':
                        sb.Append("\\t");
                        break;

                    case '\n':
                        sb.Append("\\n");
                        break;

                    case '\r':
                        sb.Append("\\r");
                        break;

                    case '"':
                        sb.Append("\\\"");
                        break;

                    default:
                        sb.Append(value[i]);
                        break;
                }
            }

            sb.Append('"');

            return sb.ToString();
        }

        private static string EscapeChar(char value)
        {
            return "\\u" + ((int)value).ToString("X4", CultureInfo.InvariantCulture);
        }
    }
}
