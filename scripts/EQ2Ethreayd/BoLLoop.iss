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

	ScriptsToRun:Insert["livedierepeat"]
	ScriptsToRun:Insert["autoshinies"]
	ScriptsToRun:Insert["ZoneUnstuck"]
	ScriptsToRun:Insert["Buffer:RZ"]
	ScriptsToRun:Insert["wrap1"]
	ScriptsToRun:Insert["wrap2"]
	ScriptsToRun:Insert["wrap"]

	for ( x:Set[1] ; ${x} <= ${ScriptsToRun.Used} ; x:Inc )
	{
        echo Killing script ${ScriptsToRun[${x}]}
		if ${Script["${ScriptsToRun[${x}]}"](exists)}
			endscript "${ScriptsToRun[${x}]}"
	}

	call ReturnEquipmentSlotHealth Primary
	if (${Me.IsDead} || ${Return}<11)
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
 	if (!${Script["ISXRIAssistant"](exists)})
		;run EQ2Ethreayd/ISXRIAssistant
	wait 600
	do
	{
		eq2execute merc resume
		call ReturnEquipmentSlotHealth Primary
		if (!${Script["Buffer:RZ"](exists)} && ${Return}>10)
		{
			echo starting RZ
			RZ
			wait 30
			UIElement[RZm].FindUsableChild[StartButton,button]:LeftClick
		}
		wait 1000
		call ReturnEquipmentSlotHealth Primary
		if (${Return}<11)
		{
			UIElement[RI].FindUsableChild["Custom Close Button",button]:LeftClick
			end Buffer:RZ
			wait 100
			echo --- Reviving (Case 2)
			RIMUIObj:Revive[${Me.Name}]
			wait 400
			call goto_GH
			call GuildH TRUE 
		}
		else
		{
			if (${Me.IsDead})
			{
				UIElement[RI].FindUsableChild["Custom Close Button",button]:LeftClick
				wait 100
				echo --- Reviving
				RIMUIObj:Revive[${Me.Name}]
				wait 900
				RI
				wait 50
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
		}

	}
	while (TRUE)
}