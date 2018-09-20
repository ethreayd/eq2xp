#define AUTORUN "num lock"
#define CENTER p
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
#define PAGEUP "Page Up"
#define PAGEDOWN "Page Down"
#define WALK shift+r
#define ZOOMIN "Num +"
#define ZOOMOUT "Num -"
#define JUMP Space
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"


function main(string questname)
{
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	
	do
	{
		if (${Me.Power}<10)
			eq2execute gsay I really need mana now !
		if (${Me.Health}<10)
			eq2execute gsay I really need healing now !
	
		wait 1000
	}
	while (TRUE)
}

 
atom HandleAllEvents(string Message)
{
	if (${Message.Equal["Can't see target"]})
	{
		 eq2execute gsay ${Message}
	}
	if (${Message.Equal["Too far away"]})
	{
		 eq2execute gsay ${Message}
	}
	if (${Message.Find["Hurry up please, we have things to do"]} > 0)
	{
		run EQ2Ethreayd/wrap UnstuckR 20
	}
}