using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WindowsFormsApp2
{
    [Serializable()]
    public class Points
    {
        private Int32 _pointID;
        private String _pointName;
        private Int32 _ponto;


        public Int32 PointID
        {
            get { return _pointID; }
            set { _pointID = value; }
        }

        public String PointName
        {
            get { return _pointName; }
            set { _pointName = value; }
        }
        public Int32 Ponto
        {
            get { return _ponto; }
            set { _ponto = value; }
        }

        public override String ToString()
        {
            return _pointID + "   " + _pointName + " :  " + _ponto;
        }

        public Points() : base()
        {

        }
    }
}
