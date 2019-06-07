using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WindowsFormsApp2
{
    [Serializable()]
    public class Marcadores
    {
        private Int32 _goloID;
        private String _goloName;
        private Int32 _golo;

        public Int32 GoloID
        {
            get { return _goloID; }
            set { _goloID = value; }
        }

        public String GoloName
        {
            get { return _goloName; }
            set { _goloName = value; }
        }
        public Int32 Golo
        {
            get { return _golo; }
            set { _golo = value; }
        }

        public override String ToString()
        {
            return _goloID + "   " + _goloName + " :  " + _golo;
        }

        public Marcadores() : base()
        {

        }
    }
}
