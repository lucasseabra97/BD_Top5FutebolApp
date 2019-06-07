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
    public partial class UserControl2 : UserControl
    {

        private bool adding;
        private SqlConnection cn;
        private int currentPlayer;

        public UserControl2()
        {
            InitializeComponent();
            HideDetailsButton();
        }

        private void UserControl2_Load(object sender, EventArgs e)
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

        public void LockControls()
        {
            txtID.ReadOnly = true;
            txtName.ReadOnly = true;
            txtDataNasc.ReadOnly = true;
            txtSalario.ReadOnly = true;
            txtAltura.ReadOnly = true;
            txtPeso.ReadOnly = true;
            txtPosicao.ReadOnly = true;
     
        }

        private void HideDetailsButton()
        {
            bttOK.Visible = false;
            bttCancel.Visible = false;
        }
        public void ShowButtons()
        {

            bttAdd.Visible = true;
            bttDelete.Visible = true;
            bttEdit.Visible = true;
            bttOK.Visible = false;
            bttCancel.Visible = false;
        }

        public void UnlockControls()
        {
            txtID.ReadOnly = false;
            txtName.ReadOnly = false;
            txtDataNasc.ReadOnly = false;
            txtSalario.ReadOnly = false;
            txtAltura.ReadOnly = false;
            txtPeso.ReadOnly = false;
            txtPosicao.ReadOnly = false;
        }


        public void ClearFields()
        {
            txtID.Text = "";
            txtName.Text = "";
            txtDataNasc.Text = "";
            txtSalario.Text = "";
            txtAltura.Text = "";
            txtPeso.Text = "";
            txtPosicao.Text = "";

        }
        public void HideButtons()
        {
            UnlockControls();
            bttAdd.Visible = false;
            bttDelete.Visible = false;
            bttEdit.Visible = false;
            bttOK.Visible = true;
            bttCancel.Visible = true;
        }

        private void listBox1_SelectedIndexChanged_1(object sender, EventArgs e)
        {
            if (listBox1.SelectedIndex > 0)
            {
                currentPlayer = listBox1.SelectedIndex;
                showTeam();
            }
        }


        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        
        private void label9_Click(object sender, EventArgs e)
        {

        }


        public void showTeam()
        {
            if (listBox1.Items.Count == 0 | currentPlayer < 0)
                return;
            Player p = new Player();

            p = (Player)listBox1.Items[currentPlayer];
            txtID.Text          = Convert.ToString(p.PlayerID);
            txtName.Text        = p.PlayerName;
            txtDataNasc.Text    = p.DataNascimento;
            txtSalario.Text     = p.Salario;
            txtAltura.Text      = Convert.ToString(p.Altura);
            txtPeso.Text        = Convert.ToString(p.Peso);
            txtPosicao.Text     = p.Posicao;
        }

        private void bttAdd_Click(object sender, EventArgs e)
        {
            adding = true;
            ClearFields();
            HideButtons();
            listBox1.Enabled = false;
        }

        private void loadDataPlayer_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("gestao_futebol.GetPlayerInfo", cn);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.ExecuteNonQuery();
            SqlDataReader reader = cmd.ExecuteReader();

            listBox1.Items.Clear();

            while (reader.Read())
            {
                Player p = new Player();

                p.PlayerID       = Convert.ToInt32(reader["id"]);
                p.PlayerName     = reader["nome"].ToString();
                p.DataNascimento = reader["data_nasc"].ToString();
                p.Salario        = reader["salario"].ToString();
                p.Altura         = Convert.ToInt32(reader["altura"]);
                p.Peso           = Convert.ToInt32(reader["peso"]);
                p.Posicao        = reader["posicao"].ToString();

                listBox1.Items.Add(p);
            }

            cn.Close();
            currentPlayer = 0;
            showTeam();
        }

        private bool SaveContact()
        {
            Player p = new Player();
            try
            {
                
                p.PlayerName     = txtName.Text;
                p.DataNascimento = txtDataNasc.Text;
                p.Altura         = Convert.ToInt32(txtAltura.Text);
                p.Peso           = Convert.ToInt32(txtPeso.Text);
                p.Posicao        = txtPosicao.Text;

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return false;
            }
            if (adding)
            {
                SubmitPlayer(p);
                listBox1.Items.Add(p);
            }
            //else
            //{
            //    UpdateContact(contact);
            //    listBox1.Items[currentContact] = contact;
            //}
            return true;
        }

        private void SubmitPlayer(Player p)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("gestao_futebol.CriaJogadorSimples", cn);
            //cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Clear();



            cmd.Parameters.AddWithValue("@nome", p.PlayerName);
            cmd.Parameters.AddWithValue("@data_nasc", p.DataNascimento);
            cmd.Parameters.AddWithValue("@altura", p.Altura);
            cmd.Parameters.AddWithValue("@peso", p.Peso);
            cmd.Parameters.AddWithValue("@posicao", p.Posicao);
            cmd.Parameters.AddWithValue("@salario", p.Salario);
          
            cmd.CommandType = CommandType.StoredProcedure;
            
            //cmd.Parameters.AddWithValue("@nome", p.PlayerName);
            //cmd.Parameters.AddWithValue("@data_nasc", p.DataNascimento);
            //cmd.Parameters.AddWithValue("@altura", p.Altura);
            //cmd.Parameters.AddWithValue("@peso", p.Peso);
            //cmd.Parameters.AddWithValue("@posicao", p.Posicao);
            //cmd.Parameters.AddWithValue("@salario", p.Salario);
            //cmd.Connection = cn;

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

        private void bttEdit_Click(object sender, EventArgs e)
        {

        }

        private void bttDelete_Click(object sender, EventArgs e)
        {

        }

        private void bttOK_Click(object sender, EventArgs e)
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
            int idx = listBox1.FindString(txtID.Text);
            listBox1.SelectedIndex = idx;
            ShowButtons();
        }

        private void bttCancel_Click(object sender, EventArgs e)
        {
            listBox1.Enabled = true;
            if (listBox1.Items.Count > 0)
            {
                currentPlayer = listBox1.SelectedIndex;
                if (currentPlayer < 0)
                    currentPlayer = 0;
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
