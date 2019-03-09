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

function main(string ZoneName)
{
	echo "Debug : waiting 12s"
	if (${ZoneName.Equal[""]})
		ZoneName:Set["Vegarlson"]
	wait 120
	if (${Me.IsDead})
	{
		echo "I am dead - waiting for 10s before reviving and stuff"
		wait 100
		echo --- Reviving
		RIMUIObj:Revive[${Me.Name}]
		OgreBotAPI:Revive[${Me.Name}]
		wait 300
	}
	call goto_GH
	echo "Debug : waiting 10s"
	wait 100
	
	echo I am in Zone ${Zone.Name}
	call UnpackItem "A bushel of harvests" 1
	echo calling AutoPlant
	call AutoPlant
	echo resuming CDHLoop
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]})
		call goto_GH
	echo I am in Zone ${Zone.Name}
	call GuildH
	echo I am in Zone ${Zone.Name}
	call GuildHarvest
	ogre depot -allh -hda -llda -cda
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
		if ((${Zone.Name.Left[6].Equal["Myrist"]} || ${Zone.Name.Right[10].Equal["Guild Hall"]}) && ${Script["harvest"](exists)})
			end harvest
		call goPublicZone "${ZoneName}"
		if (!${Script["harvest"](exists)})
			run EQ2Ethreayd/harvest
		
		if (${Zone.Name.Find["${ZoneName}"]}==0)
		{
			echo already in harvesting zone
			if (!${Script["harvest"](exists)})
				run EQ2Ethreayd/harvest
		}
		wait 600
	}
	while (TRUE)
}
