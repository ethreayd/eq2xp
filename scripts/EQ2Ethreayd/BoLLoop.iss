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
;#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/BoLZones.iss"

function main()
{
	variable index:string ScriptsToRun
	variable string sQN
	variable int x
	variable bool RION=TRUE

	ScriptsToRun:Insert["livedierepeat"]
	ScriptsToRun:Insert["autoshinies"]
	ScriptsToRun:Insert["ZoneUnstuck"]
	ScriptsToRun:Insert["Buffer:RZ"]
	ScriptsToRun:Insert["Buffer:RIMovement"]
	ScriptsToRun:Insert["wrap1"]
	ScriptsToRun:Insert["wrap2"]
	ScriptsToRun:Insert["wrap"]

	for ( x:Set[1] ; ${x} <= ${ScriptsToRun.Used} ; x:Inc )
	{
        echo Killing script ${ScriptsToRun[${x}]}
		if ${Script["${ScriptsToRun[${x}]}"](exists)}
			endscript "${ScriptsToRun[${x}]}"
	}
	if (!${Script["ISXRIAssistant"](exists)})
		run EQ2Ethreayd/ISXRIAssistant
	if (!${Script["ToonAssistant"](exists)})
		run EQ2Ethreayd/ToonAssistant
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RIMovement.xml"
	
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RZ.xml"
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RZm.xml"
	
	call GoDown
	call ReturnEquipmentSlotHealth Primary
	if (${Me.IsDead} || (${Return}<11 && ${Return}>0))
	{
		wait 100
		echo --- Reviving (Case 1) ReturnEquipmentSlotHealth Primary at ${Return} or/and I am ${Me.IsDead} DEAD
		oc !c -Revive ${Me.Name}
		RIMUIObj:Revive[${Me.Name}]
		wait 400
	}
	call goto_GH
	call GuildH TRUE

	call getBoLQuests Solo
	call goFordelMidst
 	
	wait 600

	do
	{

		eq2execute merc resume
		call ReturnEquipmentSlotHealth Primary
		if (!${Script["Buffer:RZ"](exists)} && ${Return}>10)
		{
			echo starting RZ
			oc !c ${Me.Name} checkbox_settings_forcenamedcatab TRUE
			RZ
			wait 30
			UIElement[RZm].FindUsableChild[StartButton,button]:LeftClick
			RION:Set[TRUE]
		}
		wait 600

		if (${Me.IsDead})
		{
			UIElement[RI].FindUsableChild["Custom Close Button",button]:LeftClick
			UIElement[RIM].FindUsableChild["Custom Close Button",button]:LeftClick
			RION:Set[FALSE]
			wait 100
			echo --- Reviving - RION at ${RION}
			RIMUIObj:Revive[${Me.Name}]
			echo waiting for death sickness to wear off
			wait 900
		}
		call ReturnEquipmentSlotHealth Primary
		wait 10
		if (${Return}<11 && ${Return}>0)
		{
			UIElement[RI].FindUsableChild["Custom Close Button",button]:LeftClick
			RION:Set[FALSE]
			end Buffer:RZ
			wait 100
			echo --- Need to go to guild to repair gear at ${Return}%
			call goto_GH
			call GuildH TRUE
			wait 100
			call goFordelMidst
		}
		else
		{
			if (!${RION})
			{
				RI
				wait 50
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
				RION:Set[TRUE]
			}
		
		}

	}
	while (TRUE)
}