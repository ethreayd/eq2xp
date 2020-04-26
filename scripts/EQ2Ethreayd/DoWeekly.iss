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

function main(string QNx, string SNx)
{
	variable bool Grouped
	wait 100
	relay all run endscript Churns
	oc !c -Revive
	wait 100
	relay all run endscript Churns
	wait 10
	relay all run endscript wrap
	wait 10
	relay all run wrap goto_GH
	
	call Waitfor_Zoning
	
	relay all run endscript Churns
	wait 100
	oc !c -Repair
	wait 100
	relay all run endscript Churns
	oc !c -GetFlag
	echo waiting for all toons to log in
	wait 300
	relay all run endscript Churns
	oc !c -Disband
	wait 20
	call ForceGroup
	wait 100
	call "${QNx}"
	echo ${QNx} must be done - doing ${SNx} in 30s
	wait 300
	relay all run "${SNx}"
}