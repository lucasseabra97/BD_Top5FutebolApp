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
        private bool adding;
        private SqlConnection cn;
        private int currentTeam;
        public UserControl1()
        {
            InitializeComponent();
            HideDetailsButton();
        }

        private void HideDetailsButton()
        {
            bttnOK.Visible = false;
            bttnCancel.Visible = false;
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

            //SqlCommand cmd = new SqlCommand("SELECT * FROM gestao_futebol.equipa", cn);
            //SqlDataReader reader = cmd.ExecuteReader();

        
            SqlCommand cmd = new SqlCommand("gestao_futebol.GetTeamInfo", cn);
            cmd.CommandType = CommandType.StoredProcedure;


            //cmd.Parameters.AddWithValue("@id", 2);
            cmd.ExecuteNonQuery();
            SqlDataReader reader = cmd.ExecuteReader();

            



            //cmd.CommandType = CommandType.StoredProcedure;
           

            listBox1.Items.Clear();
            Console.WriteLine("1111111111111111111111111");

            Console.WriteLine(reader.HasRows);


            while (reader.Read())
            {
                Team t = new Team();
                Console.WriteLine("22222222222222222222222222");
                t.TeamID       = Convert.ToInt32(reader["id"]);
                Console.WriteLine("ayyyyyyy");
                t.TeamName     = reader["nome"].ToString();
                t.Email        = reader["email"].ToString();
                // t.Telefone     = Convert.ToInt32(reader["telefone"]);
                t.DataFundacao = reader["data_fund"].ToString();
              // t.Campeonato   = Convert.ToInt32(reader["campeonato"]);
                listBox1.Items.Add(t);
            }
            Console.WriteLine("33333333333333333333");
            cn.Close();
            currentTeam = 0;
            showTeam();
        }

        private void UpdateContact(Team t)
        {
            int rows = 0;

            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();


            cmd.CommandText = "UPDATE gestao_futebol.equipa SET nome = @nome, email = @email, data_fund=@data_fund, campeonato=@campeonato WHERE id=@id ";
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@id", t.TeamID);
            cmd.Parameters.AddWithValue("@nome", t.TeamName);
            cmd.Parameters.AddWithValue("@email", t.Email);
            cmd.Parameters.AddWithValue("@data_fund", t.DataFundacao);
            cmd.Parameters.AddWithValue("@campeonato", t.Campeonato);
            cmd.Connection = cn;

            try
            {
                rows = cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Failed to update team in database. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                if (rows == 1)
                    MessageBox.Show("Update OK");
                else
                    MessageBox.Show("Update NOT OK");

                cn.Close();
            }
        }

      
        private void SubmitTeam(Team t)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();
           
            cmd.CommandText = "INSERT INTO gestao_futebol.equipa(nome,email,data_fund,campeonato) VALUES (@nome,@email,@data_fund,@campeonato) ";
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@nome", t.TeamName);
            cmd.Parameters.AddWithValue("@email", t.Email);
            cmd.Parameters.AddWithValue("@data_fund", t.DataFundacao);
            cmd.Parameters.AddWithValue("@campeonato", t.Campeonato);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Failed to create team in database. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }
        public void LockControls()
        {
            txtID.ReadOnly = true;
        }

        public void UnlockControls()
        {
            txtID.ReadOnly         = false;
            txtName.ReadOnly       = false;
            txtEmail.ReadOnly      = false;
            txtDateFun.ReadOnly    = false;
            txtCampeonato.ReadOnly = false;
            txtPresi.ReadOnly      = false;
            txtStadium.ReadOnly    = false;

        }


        public void ClearFields()
        {
            txtID.Text = "";
            txtName.Text = "";
            txtEmail.Text = "";
            txtDateFun.Text = "";
            txtCampeonato.Text = "";
            txtPresi.Text = "";
            txtStadium.Text = "";

        }

        
        public void ShowButtons()
        {
            
            bttnAdd.Visible = true;
            bttnDelete.Visible = true;
            bttnEdit.Visible = true;
            bttnOK.Visible = false;
            bttnCancel.Visible = false;
        }

        public void HideButtons()
        {
            UnlockControls();
            bttnAdd.Visible = false;
            bttnDelete.Visible = false;
            bttnEdit.Visible = false;
            bttnOK.Visible = true;
            bttnCancel.Visible = true;
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
            txtDateFun.Text    = team.DataFundacao;
            txtCampeonato.Text = Convert.ToString(team.Campeonato);
            
        }

        private void RemoveTeam(Int32 teamID)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "DELETE gestao_futebol.equipa WHERE id=@id ";
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@id", teamID);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Failed to delete team in database. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void bttnAdd_Click(object sender, EventArgs e)
        {
            
            adding = true;
            ClearFields();
            HideButtons();
            listBox1.Enabled = false;
        }

        private void bttnEdit_Click(object sender, EventArgs e)
        {
            currentTeam = listBox1.SelectedIndex;
            if (currentTeam <= 0)
            {
                MessageBox.Show("Please select a team to edit");
                return;
            }
            adding = false;
            HideButtons();
            listBox1.Enabled = false;
        }

        private void bttnDelete_Click(object sender, EventArgs e)
        {
            if (listBox1.SelectedIndex > -1)
            {
                try
                {
                    RemoveTeam(((Team)listBox1.SelectedItem).TeamID);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                    return;
                }
                listBox1.Items.RemoveAt(listBox1.SelectedIndex);
                if (currentTeam == listBox1.Items.Count)
                    currentTeam = listBox1.Items.Count - 1;
                if (currentTeam == -1)
                {
                    ClearFields();
                    MessageBox.Show("There are no more teams");
                }
                else
                {
                    showTeam();
                }
            }
        }

        private bool SaveContact()
        {
            Team team = new Team();
            try
            {

              
                team.TeamName = txtName.Text;
                team.Email = txtEmail.Text;
                team.DataFundacao = txtDateFun.Text;
                team.Campeonato = Int32.Parse(txtCampeonato.Text);

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return false;
            }
            if (adding)
            {
                SubmitTeam(team);
                listBox1.Items.Add(team);
            }
            else
            {
                UpdateContact(team);
                listBox1.Items[currentTeam] = currentTeam;
            }
            return true;
        }
        private void bttnOK_Click(object sender, EventArgs e)
        {
            try
            {
                SaveContact();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            listBox1.Enabled = true;
            ShowButtons();
        }

        private void bttnCancel_Click(object sender, EventArgs e)
        {
            listBox1.Enabled = true;
            if (listBox1.Items.Count > 0)
            {
                currentTeam = listBox1.SelectedIndex;
                if (currentTeam < 0)
                    currentTeam = 0;
                showTeam();
            }
            else
            {
                ClearFields();
                LockControls();
            }
            ShowButtons();
        }
    }
}
