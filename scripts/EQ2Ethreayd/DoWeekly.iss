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
	relay all run EQ2Ethreayd/endsafe Churns
	relay all run EQ2Ethreayd/endsafe BoLLoop
	oc !c -Revive
	wait 100
	relay all run EQ2Ethreayd/endsafe Churns
	relay all run EQ2Ethreayd/endsafe BoLLoop
	wait 10
	relay all run EQ2Ethreayd/endsafe wrap
	wait 10
	relay all run EQ2Ethreayd/endsafe BoLLoop
	relay all run wrap goto_GH
	
	call waitfor_Zoning
	
	relay all run EQ2Ethreayd/endsafe Churns
	wait 100
	oc !c -Repair
	wait 100
	relay all run EQ2Ethreayd/endsafe Churns

	oc !c -GetFlag
	echo waiting for all toons to log in
	wait 300
	relay all run EQ2Ethreayd/endsafe Churns
	oc !c -Disband
	wait 20
	call ForceGroup
	wait 100
	call "${QNx}"
	echo ${QNx} must be done - doing ${SNx} in 30s
	wait 300
	relay all run "${SNx}"
}