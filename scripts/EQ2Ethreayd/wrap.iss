#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"

#define AUTORUN "num lock"
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
#define WALK shift+r
#define ZOOMIN "Num +"
#define ZOOMOUT "Num -"

function main(string w0, string w1, string w2, string w3, string w4, string w5, string w6,string w7, string w8, string w9)
{
call ${w0} "${w1}" "${w2}" "${w3}" "${w4}" "${w5}" "${w6}" "${w7}" "${w8}" "${w9}"
echo ${Return}
}
