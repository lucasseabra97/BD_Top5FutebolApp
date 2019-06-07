using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace WindowsFormsApp2
{
    public partial class UserControl3 : UserControl
    {
        private SqlConnection cn;
        private int currentPlayer;
        public UserControl3()
        {
            InitializeComponent();
        }

        private void toolStripMenuItem1_Click(object sender, EventArgs e)
        {

        }
        private void UserControl3_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
        }

        private SqlConnection getSGBDConnection()
        {
            return new SqlConnection("data source=DESKTOP-AFNGAVC\\SQLEXPRESS;integrated security=true;initial catalog=top_5_futebol");
        }

        private bool verifySGBDConnection()
        {
            if (cn == null)
                cn = getSGBDConnection();

            if (cn.State != ConnectionState.Open)
                cn.Open();

            return cn.State == ConnectionState.Open;
        }



        private void resultToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("gestao_futebol.TabelaResultados", cn);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.ExecuteNonQuery();
            SqlDataReader reader = cmd.ExecuteReader();
            listBox1.Items.Clear();
            //listBox1.Items.Clear();

            while (reader.Read())
            {
                GameResult r = new GameResult();

                r.ResultID = Convert.ToInt32(reader["id"].ToString());
                r.ATeam = reader["a_name"].ToString();
                r.HTeam = reader["h_team"].ToString();
                r.AScore = Convert.ToInt32(reader["a_score"].ToString());
                r.HScore = Convert.ToInt32(reader["h_score"].ToString());
                listBox1.Items.Add(r);
            }

            cn.Close();
            currentPlayer = 0;
            
        }
    }
}
