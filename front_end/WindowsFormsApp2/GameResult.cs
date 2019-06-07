using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WindowsFormsApp2
{
    [Serializable()]
    public class GameResult
    {
        private Int32 _resultID;
        private String _h_team;
        private String _a_team;
        private Int32 _h_score;
        private Int32 _a_score;


        public Int32 ResultID
        {
            get { return _resultID; }
            set { _resultID = value; }
        }

        public String HTeam
        {
            get { return _h_team; }
            set { _h_team = value; }
        }

        public String ATeam
        {
            get { return _a_team; }
            set { _a_team = value; }
        }
        public Int32 HScore
        {
            get { return _h_score; }
            set { _h_score = value; }
        }

        public Int32 AScore
        {
            get { return _a_score; }
            set { _a_score = value; }
        }

        public override String ToString()
        {
            return _resultID + "   " + _h_team + "   " + _a_team + ":" + "   " + _h_score + "  - " + _a_score;
        }

        public GameResult() : base()
        {

        }
    }
}
