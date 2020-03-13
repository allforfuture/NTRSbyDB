using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Configuration;
using System.Windows.Forms;
using System.Drawing;

namespace NTRSbyDB
{
    class Layout
    {
        public static int row = Convert.ToInt16(ConfigurationManager.AppSettings["row"]);
        public static int col = Convert.ToInt16(ConfigurationManager.AppSettings["col"]);
        public static int sum = row * col;
        
        public static Panel paint(Info.TrayList.Tray trayInfo)
        {
            if(trayInfo.message!=null)
                Main.main.lblMessage.Text = trayInfo.message;
            Color panelColor = new Color();
            Color strColor = new Color();
            foreach (Control control in Main.main.gbDetail.Controls)
            {
                if ((trayInfo.type == null ? "" : trayInfo.type) == control.Text)
                {
                    panelColor = control.BackColor;
                    strColor = control.ForeColor;
                    break;
                }
            }
            Panel panel = new Panel();
            panel.Dock = DockStyle.Fill;
            panel.BackColor = panelColor;
            //panel.AutoSize = true;

            Label l1 = new Label();
            l1.Text = trayInfo.type;//l1.Text = trayInfo.result == "0" ? "PASS" : "FAIL";
            //l1.Font = new Font("微软雅黑", 12, FontStyle.Bold);
            l1.Font = new Font("微软雅黑", l1.Font.Size, FontStyle.Bold);
            l1.ForeColor = strColor;
            Label l2 = new Label();
            //绝对位置change动态位置
            l2.Location = new Point(0, 70);
            l2.Text = Regedit.Trajectory[Info.TrayList.trayList.Count - 1];
            l2.ForeColor = strColor;
            Label l3 = new Label();
            l3.BringToFront();
            //l3.AutoSize = true;
            l3.Width = (Main.TlpLayout_Width / Convert.ToInt16(System.Configuration.ConfigurationManager.AppSettings["col"])) - 10;
            l3.Height = 48;//可以显示2行字
            l3.Location = new Point(0, 20);
            l3.ForeColor = strColor;
            panel.Controls.Add(l3);

            l3.Text = trayInfo.value;


            panel.Controls.Add(l1);
            panel.Controls.Add(l2);

            return panel;
        }
    }
}
