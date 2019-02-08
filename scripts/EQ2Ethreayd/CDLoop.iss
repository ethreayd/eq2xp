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
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CDZones.iss"

function main()
{
	call ReturnEquipmentSlotHealth Primary
	if (${Me.IsDead} || ${Return}<11)
	{
		wait 100
		echo --- Reviving
		RIMUIObj:Revive[${Me.Name}]
		wait 400
		call goto_GH
	}
	call GuildH
	call getQuests
	if (!${Script["ISXRIAssistant"](exists)})
		run EQ2Ethreayd/ISXRIAssistant
	do
	{
		call ReturnEquipmentSlotHealth Primary
		
		if (!${Script["Buffer:RZ"](exists)} && ${Return}>10 && ${Zone.Name.Left[6].Equal["Myrist"]})
		{
			echo starting RZ
			RZ
			wait 30
			UIElement[RZm].FindUsableChild[StartButton,button]:LeftClick
		}
		wait 1000
		if ((${Me.IsDead}||${Return}<11) && ${Zone.Name.Left[6].Equal["Myrist"]})
		{
			wait 100
			echo --- Reviving
			RIMUIObj:Revive[${Me.Name}]
			wait 400
			call goto_GH
			call GuildH
			call getQuests
		}
	}
	while (TRUE)
}