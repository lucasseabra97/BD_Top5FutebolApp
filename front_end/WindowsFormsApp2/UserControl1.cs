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
    public partial class UserControl1 : UserControl
    {
        private SqlConnection cn;
        private int currentTeam;
        public UserControl1()
        {
            InitializeComponent();
        }


        private void UserControl1_Load(object sender, EventArgs e)
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

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBox1.SelectedIndex > 0)
            {
                currentTeam = listBox1.SelectedIndex;
                showTeam();
            }
        }


        private void label6_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            
        }

        private void loadDataTeam_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("SELECT * FROM gestao_futebol.equipa", cn);
            SqlDataReader reader = cmd.ExecuteReader();
            listBox1.Items.Clear();


            while (reader.Read())
            {
                Team t = new Team();
                t.TeamID       = Convert.ToInt32(reader["id"]);
                t.TeamName     = reader["nome"].ToString();
                t.Email        = reader["email"].ToString();
               // t.Telefone     = Convert.ToInt32(reader["telefone"]);
                t.DataFundacao = Convert.ToDateTime(reader["data_fund"]);
                t.Campeonato   = Convert.ToInt32(reader["campeonato"]);
                listBox1.Items.Add(t);
            }
            cn.Close();
            currentTeam = 0;
            showTeam();
        }

        public void showTeam()
        {
            if (listBox1.Items.Count == 0 | currentTeam < 0)
                return;
            Team team = new Team();
            team = (Team)listBox1.Items[currentTeam];
            txtID.Text         = Convert.ToString(team.TeamID);
            txtName.Text       = team.TeamName;
            txtEmail.Text      = team.Email;
            txtDateFun.Text    = Convert.ToString(team.DataFundacao);
            txtCampeonato.Text = Convert.ToString(team.Campeonato);
        }
    }
}
