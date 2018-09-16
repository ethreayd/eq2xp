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
variable(script) bool Windy

function main()
{
	call Loot
}

atom HandleAllEvents(string Message)
{
	;echo Catch Event ${Message}
	if (${Message.Find["has killed you"]} > 0 || ${Message.Find["you have died"]} > 0)
	{
		echo "I am dead"
		if ${Script["livedierepeat"](exists)}
			endscript livedierepeat
		run EQ2Ethreayd/livedierepeat
	}
	if (${Message.Find["feel unsteady on your feet"]} > 0)
	{
		Windy:Set[TRUE]
	}
}