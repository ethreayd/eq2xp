#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

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

function main()
{
	echo 1
	return
	echo 4
}



atom HandleAllEvents(string Message)
 {
	;echo Catch Event ${Message}
    if (${Message.Find["lord of the festrus returns"]} > 0)
	{
		FestrusLord:Set[TRUE]
		echo Lord of the Festrus detected
	}
 }