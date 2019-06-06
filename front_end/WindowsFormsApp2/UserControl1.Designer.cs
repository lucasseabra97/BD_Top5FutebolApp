namespace WindowsFormsApp2
{
    partial class UserControl1
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.txtID = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.txtName = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.listBox1 = new System.Windows.Forms.ListBox();
            this.txtEmail = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.txtDateFun = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.txtCampeonato = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.txtPresi = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.txtStadium = new System.Windows.Forms.TextBox();
            this.label9 = new System.Windows.Forms.Label();
            this.txtPoints = new System.Windows.Forms.TextBox();
            this.button3 = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.loadDataTeam = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(77, 12);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(18, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "ID";
            // 
            // txtID
            // 
            this.txtID.Location = new System.Drawing.Point(80, 41);
            this.txtID.Name = "txtID";
            this.txtID.Size = new System.Drawing.Size(58, 20);
            this.txtID.TabIndex = 1;
            this.txtID.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(229, 11);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(35, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "Nome";
            // 
            // txtName
            // 
            this.txtName.Location = new System.Drawing.Point(232, 41);
            this.txtName.Name = "txtName";
            this.txtName.Size = new System.Drawing.Size(138, 20);
            this.txtName.TabIndex = 3;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(401, 12);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(32, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "Email";
            // 
            // listBox1
            // 
            this.listBox1.FormattingEnabled = true;
            this.listBox1.Location = new System.Drawing.Point(80, 279);
            this.listBox1.Name = "listBox1";
            this.listBox1.Size = new System.Drawing.Size(472, 160);
            this.listBox1.TabIndex = 5;
            this.listBox1.SelectedIndexChanged += new System.EventHandler(this.listBox1_SelectedIndexChanged);
            // 
            // txtEmail
            // 
            this.txtEmail.Location = new System.Drawing.Point(404, 41);
            this.txtEmail.Name = "txtEmail";
            this.txtEmail.Size = new System.Drawing.Size(151, 20);
            this.txtEmail.TabIndex = 6;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(77, 87);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(96, 13);
            this.label4.TabIndex = 7;
            this.label4.Text = "Data de Fundação";
            // 
            // txtDateFun
            // 
            this.txtDateFun.Location = new System.Drawing.Point(80, 121);
            this.txtDateFun.Name = "txtDateFun";
            this.txtDateFun.Size = new System.Drawing.Size(100, 20);
            this.txtDateFun.TabIndex = 8;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(229, 87);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(67, 13);
            this.label5.TabIndex = 9;
            this.label5.Text = "Campeonato";
            // 
            // txtCampeonato
            // 
            this.txtCampeonato.Location = new System.Drawing.Point(232, 121);
            this.txtCampeonato.Name = "txtCampeonato";
            this.txtCampeonato.Size = new System.Drawing.Size(100, 20);
            this.txtCampeonato.TabIndex = 10;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(401, 87);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(57, 13);
            this.label6.TabIndex = 11;
            this.label6.Text = "Presidente";
            this.label6.Click += new System.EventHandler(this.label6_Click);
            // 
            // txtPresi
            // 
            this.txtPresi.Location = new System.Drawing.Point(404, 121);
            this.txtPresi.Name = "txtPresi";
            this.txtPresi.Size = new System.Drawing.Size(100, 20);
            this.txtPresi.TabIndex = 12;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(77, 158);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(42, 13);
            this.label7.TabIndex = 13;
            this.label7.Text = "Estádio";
            // 
            // txtStadium
            // 
            this.txtStadium.Location = new System.Drawing.Point(80, 189);
            this.txtStadium.Name = "txtStadium";
            this.txtStadium.Size = new System.Drawing.Size(100, 20);
            this.txtStadium.TabIndex = 14;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(226, 158);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(59, 13);
            this.label9.TabIndex = 16;
            this.label9.Text = "Pontuação";
            // 
            // txtPoints
            // 
            this.txtPoints.Location = new System.Drawing.Point(229, 189);
            this.txtPoints.Name = "txtPoints";
            this.txtPoints.Size = new System.Drawing.Size(100, 20);
            this.txtPoints.TabIndex = 17;
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(480, 233);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(75, 23);
            this.button3.TabIndex = 21;
            this.button3.Text = "Delete";
            this.button3.UseVisualStyleBackColor = true;
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(358, 233);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(75, 23);
            this.button2.TabIndex = 20;
            this.button2.Text = "Edit";
            this.button2.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(232, 233);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 19;
            this.button1.Text = "Add";
            this.button1.UseVisualStyleBackColor = true;
            // 
            // loadDataTeam
            // 
            this.loadDataTeam.Location = new System.Drawing.Point(80, 250);
            this.loadDataTeam.Name = "loadDataTeam";
            this.loadDataTeam.Size = new System.Drawing.Size(75, 23);
            this.loadDataTeam.TabIndex = 22;
            this.loadDataTeam.Text = "Load Data";
            this.loadDataTeam.UseVisualStyleBackColor = true;
            this.loadDataTeam.Click += new System.EventHandler(this.loadDataTeam_Click);
            // 
            // UserControl1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.LightSkyBlue;
            this.Controls.Add(this.loadDataTeam);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.txtPoints);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.txtStadium);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.txtPresi);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.txtCampeonato);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.txtDateFun);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.txtEmail);
            this.Controls.Add(this.listBox1);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtName);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.txtID);
            this.Controls.Add(this.label1);
            this.Name = "UserControl1";
            this.Size = new System.Drawing.Size(587, 489);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtID;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtName;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ListBox listBox1;
        private System.Windows.Forms.TextBox txtEmail;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtDateFun;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox txtCampeonato;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox txtPresi;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox txtStadium;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.TextBox txtPoints;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button loadDataTeam;
    }
}
