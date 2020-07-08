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

function main(string QNx, string SNx, bool Expert)
{
	variable bool Grouped
	wait 10
	oc !c -Revive
	wait 100
	relay all run wrap goto_GH
	call waitfor_Zoning
	wait 10
	oc !c -Repair
	wait 50
	oc !c -GetFlag
	call GroupDistance
	if (${Return}>10)
	{
		echo waiting for all toons to log in
		wait 300
	}
	oc !c -Disband
	wait 20
	call ForceGroup
	
	wait 100
	if (${Me.GroupCount}>5)
	{
		call "${QNx}" ${Expert}
		echo ${QNx} must be done - doing ${SNx} in 30s
	}
	else
	{
		echo can't got a full group
	}
	wait 300
	relay all run "${SNx}"
}