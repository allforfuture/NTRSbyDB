using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.IO;
using System.Configuration;

namespace NTRSbyDB
{
    class Document
    {

        public static List<string> pathList = new List<string>()
        {
            AppDomain.CurrentDomain.BaseDirectory + "log\\",
        };

        public static void CreateDocument()
        {
            foreach (string path in pathList)
            {
                Directory.CreateDirectory(path);
            }
        }
    }

    class Log : Document
    {
        public static void WriteLog(string SN,string detail,string judge)
        {
            string path = Document.pathList[0] + "log" + DateTime.Now.ToString("yyyyMMdd") + ".txt";
            using (StreamWriter file = new StreamWriter(path, true))//(@"C:\Users\YEYINXU\Desktop\log" + DateTime.Now.ToString("yyyyMMdd") + ".txt", true))
            {
                string str = DateTime.Now.ToString("yyyy/MM/dd,HH:mm:ss,")
                    + SN + ","
                    + detail.Replace("\r\n", "$")+ ","
                    + judge;
                file.WriteLine(str);// 直接追加文件末尾，换行
            }
        }

        public static void WriteError(string SN)
        {
            //string path = Document.pathList[0] +  DateTime.Now.ToString("yyyyMMdd") + "ErrorLog.txt";
            string path = Document.pathList[0] + "log" + DateTime.Now.ToString("yyyyMMdd") + ".txt";
            using (StreamWriter file = new StreamWriter(path, true))
            {
                file.WriteLine(DateTime.Now.ToString("yyyy/MM/dd,HH:mm:ss,@") + SN);// 直接追加文件末尾，换行 
            }
        }
    }
}
