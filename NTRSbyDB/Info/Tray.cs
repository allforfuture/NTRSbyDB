using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Data;

namespace NTRSbyDB.Info
{
    class TrayList
    {
        public static List<Tray> trayList = new List<Tray>();
        public class Tray
        {
            internal string sn { get; set; }

            internal string value { get; set; }
            internal string type { get; set; }
            internal string message { get; set; }
        }
    }
   

    class DB
    {
        static string sql0 = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory+ @"DB.sql");
        public static TrayList.Tray GetTrayInfo(string sn)
        {
            string sql = sql0.Replace("{0}", sn);
            System.Data.DataTable dt = new System.Data.DataTable();
            new DBFactory().ExecuteDataTable(sql, ref dt);
            TrayList.Tray tray = new TrayList.Tray() { sn = sn };
            Dictionary<string, int> dic = new Dictionary<string, int>();
            if (dt.Rows.Count == 3)
            {
                //tray.value= dt.Rows[0]["data_value"].ToString();
                //tray.type= dt.Rows[0]["data_type"].ToString();
                //try { tray.message = dt.Rows[0]["data_message"].ToString(); } catch { }

                //信息存放
                string info = "";
                foreach (DataRow dr in dt.Rows)
                {
                    info +=  dr["process_cd"].ToString() + ":" + dr["v_result"].ToString() + "\r\n" ;
                    string[] listNG = dr["v_result"].ToString().Split(new string[] { "0" }, StringSplitOptions.RemoveEmptyEntries);
                    int maxNG_count = 0;
                    foreach (string str in listNG)
                    {
                        maxNG_count = str.Length > maxNG_count ? str.Length : maxNG_count;
                    }
                    int count = maxNG_count;
                    dic.Add(dr["process_cd"].ToString(), count);
                }

                if ((dic["LOAD"] <= 5) && (dic["VMT"] <= 2) && (dic["TRAP1"] <= 2))
                {
                    tray.type = "LOAD";
                    tray.value = info;
                    tray.message = info;
                }
                else if ((dic["LOAD"] <= 2) && (dic["VMT"] <= 5) && (dic["TRAP1"] <= 2))
                {
                    tray.type = "VMT";
                    tray.value = info;
                    tray.message = info;
                }
                else if ((dic["LOAD"] <= 2) && (dic["VMT"] <= 2) && (dic["TRAP1"] <= 5))
                {
                    tray.type = "TRAP1";
                    tray.value = info;
                    tray.message = info;
                }
                else
                {
                    tray.type = "NG";
                    tray.value = info;
                    tray.message = info;
                }

                //tray.value = "value";
                //tray.type = "Bin A";
                //tray.message = "MESSAGE";
                return tray;
            }
            else
            {
                return tray;
            }
        }
    }
}