using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;


namespace WindowsFormsApp2
{
[Serializable()]
public class Team
{
        private Int32 _teamID;
        private String _teamName;
        private String _email;
        private Int32 _telefone;
        private String _dataFundacao;
        private Int32 _campeonatoID;

        public Int32 TeamID
        {
            get { return _teamID; }
            set { _teamID = value;}
        }
        public String TeamName
        {
            get { return _teamName; }
            set
            {
                if (value == null | String.IsNullOrEmpty(value))
                {
                    throw new Exception("Team Name field can’t be empty");
                    return;
                }
                _teamName = value;
            }
        }

        public String Email
        {
            get { return _email; }
            set { _email = value; }
        }

        public Int32 Telefone
        {
            get { return _telefone; }
            set { _telefone = value; }
        }

        public String DataFundacao
        {   
            get { return _dataFundacao; }
            set { _dataFundacao = value; }
        }
        public Int32 Campeonato
        {
            get { return _campeonatoID; }
            set
            {
                if (value == 0)
                {
                    throw new Exception("Campeonato id field can’t be empty");
                    return;
                }
                _campeonatoID = value;
            }
        }

        public override String ToString()
        {
            return _teamID + "   " + _teamName;
        }

        public Team() : base()
        {

        }

}
}
