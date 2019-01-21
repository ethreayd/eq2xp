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
	variable string ToonName
	ToonName:Set[${Me.Name}]
	if (${Me.IsDead})
	{
		wait 100
		echo --- Reviving
		RIMUIObj:Revive[${Me.Name}]
		OgreBotAPI:Revive[${Me.Name}]
		wait 300
	}
	
	call goto_GH
	wait 100
	echo czlling Ogre plant
	ogre plant -t ${Me.Name}
	wait 20
	UIElement[OgreTaskListTemplateUIXML].FindUsableChild[button_clearerrors,button]:LeftClick
	wait 600
	echo waiting for Login Scene
	do
	{
		wait 5
	}
	while (!${Zone.Name.Equal["LoginScene"]} && !${Zone.Name.Right[10].Equal["Guild Hall"]})
	wait 50
	echo logging as ${ToonName}
	ogre ${ToonName}
	wait 100
	do
	{
		wait 5
	}
	while (${Zone.Name.Equal["LoginScene"]} || ${Zone.Name.Equal[""]})
	wait 100
	echo resuming CDHLoop
	call goto_GH
	call GuildH
	
	do
	{
		if (${Me.IsDead})
		{
			wait 100
			echo --- Reviving
			RIMUIObj:Revive[${Me.Name}]
			OgreBotAPI:Revive[${Me.Name}]
		}
			
		call ReturnEquipmentSlotHealth Primary
		if (${Return}<11)
		{
			wait 400
			call goto_GH
			call GuildH
			call goEPG
		}
		if (${Zone.Name.Left[6].Equal["Myrist"]} || ${Zone.Name.Right[10].Equal["Guild Hall"]})
		{
			if ${Script["harvest"](exists)}
				end harvest
			if (${Me.Y}<400 || ${Me.Y}>430)
				call goEPG
			call DMove 771 412 -338 3
			call ActivateVerbOn "zone_to_poe" "Enter Vegarlson, the Earthen Badlands" TRUE
			wait 20
			oc !c -ZoneDoor 1
			RUIMObj:Door[${Me.Name},1]
			call waitfor_Zone "Vegarlson, the Earthen Badlands"
			if (!${Script["harvest"](exists)})
				run EQ2Ethreayd/harvest
		}
		if (${Zone.Name.Left[31].Equal["Vegarlson, the Earthen Badlands"]})
		{
				if (!${Script["harvest"](exists)})
				run EQ2Ethreayd/harvest
		}
		wait 600
	}
	while (TRUE)
}