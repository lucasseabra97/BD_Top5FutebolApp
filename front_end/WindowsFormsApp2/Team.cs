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
        private String _dataFundacao;
        private String _campeonato;
        private String _presidente;
        private String _estadio;


        public String President
        {
            get { return _presidente; }
            set { _presidente = value; }
        }

        public String Stadium
        {
            get { return _estadio; }
            set { _estadio = value; }
        }
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

        public String DataFundacao
        {   
            get { return _dataFundacao; }
            set { _dataFundacao = value; }
        }
        public String Campeonato
        {
            get { return _campeonato; }
            set
            {
                if (value == null | String.IsNullOrEmpty(value))
                {
                    throw new Exception("Campeonato field can’t be empty");
                    return;
                }
                _campeonato = value;
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
