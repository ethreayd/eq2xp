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
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/EQ2Travel.iss"

function main()
{
	call ReturnEquipmentSlotHealth Primary
	if (${Me.IsDead} || ${Return}<11)
	{
		wait 100
		echo --- Reviving
		oc !c -Revive ${Me.Name}
		RIMUIObj:Revive[${Me.Name}]
		wait 400
		call goto_GH
	}
	call GuildH
	call getBoLQuests
	if (!${Script["ISXRIAssistant"](exists)})
		run EQ2Ethreayd/ISXRIAssistant
	do
	{
		call ReturnEquipmentSlotHealth Primary
		
		if (!${Script["Buffer:RZ"](exists)} && ${Return}>10)
		{
			echo starting RZ
			RZ
			wait 30
			UIElement[RZm].FindUsableChild[StartButton,button]:LeftClick
		}
		wait 1000
		if ((${Me.IsDead}||${Return}<11))
		{
			wait 100
			echo --- Reviving
			RIMUIObj:Revive[${Me.Name}]
			wait 400
			call goto_GH
			call GuildH
			call getBoLQuests
		}
	}
	while (TRUE)
}