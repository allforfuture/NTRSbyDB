using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Configuration;
using System.Text.RegularExpressions;

namespace NTRSbyDB
{
    class CheckSN
    {
        List<string> PPP = new List<string>(ConfigurationManager.AppSettings["checkPPP"].Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries));
        public bool IsPass(string sn, ref string errMessage)
        {
            if (CheckDupli(sn, ref errMessage))
                return false;
            else if (!IsMatchPPP(sn, ref errMessage))
                return false;
            return true;
        }

        /// <summary>
        /// 检查SN是否重复
        /// </summary>
        /// <param name="sn"></param>
        /// <param name="errMessage"></param>
        /// <returns></returns>
        bool CheckDupli(string sn,ref string errMessage)
        {
            foreach (Info.TrayList.Tray var in Info.TrayList.trayList)
            {
                if (sn == var.sn && sn != "ERROR")
                {
                    errMessage = "DUPLICATE";
                    return true;
                }
            }
            return false;
        }


        /// <summary>
        /// PPP检查
        /// </summary>
        /// <param name="sn"></param>
        /// <param name="errMessage"></param>
        /// <returns></returns>
        bool IsMatchPPP(string sn, ref string errMessage)
        {
            if (PPP[0] != "N/A")
            {
                foreach (string PPPstr in PPP)
                {
                    if (Regex.IsMatch(sn, $"^{PPPstr}"))
                        return true;
                }
                errMessage = "MISS PPP";
                return false;
            }
            return true;
        }
    }
}
