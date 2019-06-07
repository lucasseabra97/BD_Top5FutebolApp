using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WindowsFormsApp2
{
    [Serializable()]
    public class Player
    {
        private Int32 _playerID;
        private String _playerName;
        private String _dataNascimento;
        private String  _salario;
        private Int32 _altura;
        private Int32 _peso;
        private String _posicao;




        public Int32 PlayerID
        {
            get { return _playerID; }
            set { _playerID = value; }
        }

        public String PlayerName
        {
            get { return _playerName; }
            set
            {
                if (value == null | String.IsNullOrEmpty(value))
                {
                    throw new Exception("Player Name field can’t be empty");
                    return;
                }
                _playerName = value;
            }
        }

        public String DataNascimento
        {
            get { return _dataNascimento; }
            set { _dataNascimento = value; }
        }


        public String Salario
        {
            get { return _salario; }
            set { _salario = value; }
        }

        public Int32 Altura
        {
            get { return _altura; }
            set { _altura = value; }
        }
        

        public Int32 Peso
        {
            get { return _peso; }
            set { _peso = value; }
        }

        public String Posicao
        {
            get { return _posicao; }
            set { _posicao = value; }
        }

        public override String ToString()
        {
            return _playerID + "   " + _playerName;
        }

        public Player() : base()
        {

        }
    }
}
