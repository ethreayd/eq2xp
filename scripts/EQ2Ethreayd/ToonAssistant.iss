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
	eq2execute spend_deity_point 2282608707 1
	eq2execute spend_deity_point 2282608707 1
	do
	{
		if (${Me.Power}<10 && !${Me.IsDead})
			eq2execute gsay I really need mana now !
		if (${Me.Health}<10 && !${Me.IsDead})
			eq2execute gsay I really need healing now !
		if (${Me.IsDead})
			eq2execute gsay Can I have a rez please ?
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
		if (!${Script["wrap"](exists)})
			run EQ2Ethreayd/wrap UnstuckR 20
	}
}