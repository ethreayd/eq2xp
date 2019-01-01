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
	call GuildH
	call getQuests
	if (!${Script["ISXRIAssistant"](exists)})
		run EQ2Ethreayd/ISXRIAssistant
	do
	{
		call ReturnEquipmentSlotHealth Primary
		if (!${Script["Buffer:RZ"](exists)} && ${Return}>10 && ${Zone.Name.Left[6].Equal["Myrist"]})
		{
			RZ
			wait 30
			UIElement[RZm].FindUsableChild[StartButton,button]:LeftClick
		}
		wait 1000
	}
	while (TRUE)
}