function GetCoVQuests(string ZoneName, string version)
{
	call DMove -2 5 4 3
	call DMove -109 0 1 3
	call DMove -145 0 -93 3
	call Converse "Rynzon, of The Spurned" 10
	call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
	call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
	call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3	
	call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
	call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
	call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
	call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3	
	call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
	call MoveCloseTo "a Planar Chronicler"
	call Converse "a Planar Chronicler" 3
	call Converse "a Planar Chronicler" 3
	call Converse "a Planar Chronicler" 3
	call Converse "a Planar Chronicler" 3
	call DMove -109 0 1 3
}	
		
function GoPoI(string ZoneName, string version)
{
	if (!${Zone.Name.Equal["Plane of Innovation: ${zone} [${version}]"]})
	{
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3
		call DMove -94 3 163 3
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_poi","Enter the Plane of Innovation"]
		wait 20
		switch ${ZoneName}
		{
			case Masks of the Marvelous
			{
				switch ${version}
				{
					case Solo
						OgreBotAPI:ZoneDoorForWho["${Me.Name}",6]
					case Heroic
						OgreBotAPI:ZoneDoorForWho["${Me.Name}",5]
				}
			}
			case Gears in the Machine
			{
				switch ${version}
				{
					case Solo
						OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
					case Heroic
						OgreBotAPI:ZoneDoorForWho["${Me.Name}",2]
				}
			}
		}
	}
	wait 50
	call waitfor_Zone "Plane of Innovation: ${ZoneName} [${version}]"
}
function GoPoD(string ZoneName, string version)
{
	if (!${Zone.Name.Equal["Plane of Disease: ${ZoneName} [${version}]"]})
	{
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3
		call DMove -193 3 0 3
		wait 50		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_pod","Enter the Plane of Disease"]
		wait 20
		switch ${ZoneName}
		{
			case Outbreak
			{
				switch ${version}
				{
					case Solo
						OgreBotAPI:ZoneDoorForWho["${Me.Name}",6]
				}
			}
			case the Source
			{
				switch ${version}
				{
					case Solo
						OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
				}
			}
		}
	}
	wait 50
	call waitfor_Zone "Plane of Disease: ${ZoneName} [${version}]"
}
function GoSRT(string ZoneName, string version)
{
	if (!${Zone.Name.Equal["Solusek Ro's Tower: ${ZoneName} [${version}]"]})
	{
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3
		call DMove 95 3 -164 3
		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_ro_tower","Enter Solusek Ro's Tower"]
		wait 20
		switch ${ZoneName}
		{
			case Monolith of Fire
			{
				switch ${version}
				{
					case Solo
						OgreBotAPI:ZoneDoorForWho["${Me.Name}",4]
				}
			}
			case The Obsidian Core
			{
				switch (${version})
				{
					case Solo
						OgreBotAPI:ZoneDoorForWho["${Me.Name}",8]
				}
			}
		}
	}
	wait 50
	call waitfor_Zone "Plane of Disease: ${ZoneName} [${version}]"
}

function GoThrone()
{
	if (!${Zone.Name.Equal["The Molten Throne"]})
	{
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3
		call DMove 95 3 -149 3
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_molten_throne","Enter the Molten Throne"]
		wait 20
		call waitfor_Zone "The Molten Throne"
	}
}	
	
function GoBoT(string ZoneName, string version)
{
	if (!${Zone.Name.Equal["Torden, Bastion of Thunder: ${ZoneName} [${version}]"]})
	{
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3
		call DMove -92 3 -158 3
		wait 50		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_bot","Enter Torden, Bastion of Thunder"]
		wait 20
		
		switch ${ZoneName}
		{
			case Tower Breach
			{
				switch ${version}
				{
					case Solo
						OgreBotAPI:ZoneDoorForWho["${Me.Name}",7]
				}
			}
			case Winds of Change
			{
				switch (${version})
				{
					case Solo
						OgreBotAPI:ZoneDoorForWho["${Me.Name}",10]
				}
			}
		}
	}
	wait 50
	call waitfor_Zone "Torden, Bastion of Thunder: ${ZoneName} [${version}]"
}
function PrepareToon()
{
	variable string sQN
	call waitfor_Zone "Coliseum of Valor"
	call GetCoVQuests
	call MendToon
}
function MendToon()
{
	call waitfor_Zone "Coliseum of Valor"
	call ReturnEquipmentSlotHealth Primary
	if (${Return}<100)
	{
		call CoVMender
	}
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