function EnterZone(int num)
{
	do
	{
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",${num}]
		wait 50
	}
	while (${Zone.Name.Equal["Coliseum of Valor"]})
}
function goPublicZone(string ZoneName)
{
	variable string LongZoneName
	
	if ((${Zone.Name.Left[6].Equal["Myrist"]} || ${Zone.Name.Right[10].Equal["Guild Hall"]}) && (${Me.Y}<400 || ${Me.Y}>430))
		call goEPG
	
	switch ${ZoneName}
	{
		case Doomfire
		{
			LongZoneName:Set["Doomfire, the Burning Lands"]
			echo Going to ${ZoneName} (${LongZoneName})
			call DMove 730 412 -338 3
			call ActivateVerbOn "zone_to_pof" "Enter ${LongZoneName}" TRUE	
		}
		break
		case Vergalson
		{
			LongZoneName:Set["Vegarlson, the Earthen Badlands"]
			echo no Zone selected going to ${ZoneName} (${LongZoneName})
			call DMove 771 412 -338 3
			call ActivateVerbOn "zone_to_poe" "Enter ${LongZoneName}" TRUE
		}
		break
		case default
		{
			LongZoneName:Set["Doomfire, the Burning Lands"]
			echo Going to ${ZoneName} (${LongZoneName})
			call DMove 730 412 -338 3
			call ActivateVerbOn "zone_to_pof" "Enter ${LongZoneName}" TRUE	
		}
		break
	}
	wait 20
	oc !c -ZoneDoor 1
	RUIMObj:Door[${Me.Name},1]
	call waitfor_Zone "${LongZoneName}"
	echo in zone ${ZoneName} (${LongZoneName})
}
function MendToon()
{
	call ReturnEquipmentSlotHealth Primary
	if (${Return}<100)
	{
		echo NOT IMPLEMENTED YET
	}
}
function PrepareToon()
{
	call getQuests
	call MendToon
}

function RebootZones()
{
	variable int Counter
	variable bool LR
	echo rebooting session
	call StopHunt
	oc !c -letsgo ${Me.Name}
	run EQ2Ethreayd/killall
	call PKey MOVEFORWARD 1
	OgreBotAPI:Revive[${Me.Name}]
	wait 300
	OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
	call goto_GH
	wait 100
	OgreBotAPI:RepairGear[${Me.Name}]
	wait 100
	ogre depot -allh -hda -llda -cda
	wait 100
	OgreBotAPI:RepairGear[${Me.Name}]
	wait 100
	OgreBotAPI:ApplyVerbForWho["${Me.Name}","Large Ulteran Spire","Voyage Through Norrath"]
	wait 100
	OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
	OgreBotAPI:RepairGear[${Me.Name}]
	OgreBotAPI:Travel["${Me.Name}", "Plane of Magic"]
	call waitfor_Zone "Plane of Magic"
	call goCoV
	call DMove -2 5 4 3
	run EQ2Ethreayd/autopop
}
