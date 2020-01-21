using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NTRSbyDB.Info
{
    class TrayList
    {
        public static List<Tray> trayList = new List<Tray>();
        public class Tray
        {
            internal string sn { get; set; }
            internal string result { get; set; }

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
            if (dt.Rows.Count > 0)
            {
                tray.value= dt.Rows[0]["value"].ToString();
                tray.type= dt.Rows[0]["type"].ToString();
                try { tray.message = dt.Rows[0]["message"].ToString(); } catch { }
                return tray;
            }
            else
            {
                tray.type ="NULL";
                tray.result = "1";
                return tray;
            }
        }
    }
}