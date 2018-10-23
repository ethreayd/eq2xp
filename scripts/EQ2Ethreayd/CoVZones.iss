function ExitCoV()
{	
	if (${Zone.Name.Equal["Coliseum of Valor"]})
		{
			call DMove -2 5 4 3 30 TRUE
			call DMove 94 3 162 3 30 TRUE
			call ActivateVerb "zone_to_pom" 94 3 162 "Enter the Plane of Magic"
			wait 50
			OgreBotAPI:ZoneDoorForWho["${Me.Name}",1]
		}
	call waitfor_Zone "Plane of Magic"
}
function ExitZone()
{
	string ZoneName
	ZoneName:Set["${Zone.Name}"]
	if (!${Zone.Name.Left[40].Equal["Torden, Bastion of Thunder: Tower Breach"]})
	{
		call DMove 0 0 -1 3 30 TRUE
	}
	do
	{
		wait 50
		oc !c -Zone
	}
	while (${Zone.Name.Equal["${ZoneName}"]})
}
function GetCoVQuests(string ZoneName, string version)
{
	variable string NPCName
	call DMove -2 5 4 3 30 TRUE
	call DMove -109 0 1 3 30 TRUE
	call DMove -117 0 -90 3 30 TRUE
	switch ${ZoneName}
	{
		case Guk
		{
			call DMove -132 0 -108 3 30 TRUE
			NPCName:Set["Griv, of the Knights of Marr"]
			OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
			wait 20
			OgreBotAPI:ConversationBubble["${Me.Name}",7]
			wait 20
			call DMove -117 0 -90 3 30 TRUE
			break
		}
		case SoH
		{
			switch ${version}
			{
				case Solo
				{
					call DMove -145 0 -93 3 30 TRUE
					wait 20
					NPCName:Set["Syr'Vala, of The Academy of Arcane Sciences"]
					OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
					wait 20
					OgreBotAPI:ConversationBubble["${Me.Name}",1]
					wait 20
					OgreBotAPI:ConversationBubble["${Me.Name}",9]
					wait 20
					call DMove -117 0 -90 3 30 TRUE
					break
				}
				case default
				{
					call DMove -145 0 -93 3 30 TRUE
					break
				}
			}
			break
		}
		case Heroic
		{
			call DMove -132 0 -108 3 30 TRUE
			wait 20
			NPCName:Set["Rayna, Concordium Mage"]
			OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
			wait 20
			OgreBotAPI:ConversationBubble["${Me.Name}",2]
			wait 20
			call DMove -117 0 -90 3 30 TRUE
			break
		}
		Default
		{
			call DMove -145 0 -93 3 30 TRUE
			call Converse "Rynzon, of The Spurned" 10
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3	
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3	
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3	
			call Converse "Syr'Vala, of The Academy of Arcane Sciences" 3
			call DMove -130 0 -84 3 30 TRUE
			call MoveCloseTo "a Planar Chronicler"
			call Converse "a Planar Chronicler" 3
			call Converse "a Planar Chronicler" 3
			call Converse "a Planar Chronicler" 3
			call Converse "a Planar Chronicler" 3
			call DMove -117 0 -90 3	30 TRUE
			break
		}
	}
	call DMove -109 0 1 3 30 TRUE
}	
function GoBoT(string ZoneName, string version)
{
	variable int offset=0
	variable string offsetQN
	offsetQN:Set["A Stitch in Time, Part II: Lightning Strikes"]
	echo Debug going to Torden, Bastion of Thunder: ${ZoneName} [${version}]
	call check_quest "${offsetQN}"
	if (${Return})
		offset:Inc
	
	if (!${Zone.Name.Equal["Torden, Bastion of Thunder: ${ZoneName} [${version}]"]})
	{
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3 30 TRUE
		call DMove -92 3 -158 3 30 TRUE
		wait 50		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_bot","Enter Torden, Bastion of Thunder"]
		wait 100
		
		switch ${ZoneName}
		{
			case Lightning Strikes
			{
				do
				{
					OgreBotAPI:ZoneDoorForWho["${Me.Name}",1]
					wait 50
				}
				while (${Zone.Name.Equal["Coliseum of Valor"]})
				break
			}
			case Tower Breach
			{
				switch ${version}
				{
					case Solo
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",${Math.Calc64[7+${offset}]}]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
					case Heroic
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",${Math.Calc64[6+${offset}]}]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
				}
				break
			}
			case Winds of Change
			{
				switch ${version}
				{
					case Solo
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",${Math.Calc64[10+${offset}]}]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
				}
				break
			}
		}
	}
	wait 50
	call waitfor_Zone "Torden, Bastion of Thunder: ${ZoneName} [${version}]"
	echo Debug end of BoT ${ZoneName} [${version}]
}
function goCoV()
{	
	if (${Zone.Name.Right[10].Equal["Guild Hall"]})
	{
		call IsPresent "Mechanical Travel Gear"
		if (${Return})
		{
			call MoveCloseTo "Mechanical Travel Gear"
			wait 20
			OgreBotAPI:ApplyVerbForWho["${Me.Name}","Mechanical Travel Gear","Travel to the Planes"]
			wait 20
			OgreBotAPI:ZoneDoorForWho["${Me.Name}",1]
			wait 300
		}
		call IsPresent "Large Ulteran Spire"
		if (${Return})
		{
			call MoveCloseTo "Large Ulteran Spire"
			wait 20
			OgreBotAPI:ApplyVerbForWho["${Me.Name}","Large Ulteran Spire","Voyage Through Norrath"]
			wait 50
			OgreBotAPI:Travel["${Me.Name}", "Plane of Magic"]
			wait 300
		}
	}
	
	if (${Zone.Name.Left[14].Equal["Plane of Magic"]})
	{
		call ActivateVerb "zone_to_pov" -785 345 1116 "Enter the Coliseum of Valor"
		call DMove -2 5 4 3
	}
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]} && !${Zone.Name.Left[14].Equal["Plane of Magic"]} && !${Zone.Name.Equal["Coliseum of Valor"]})
	{
		call goto_GH
		wait 600
		call goCoV
	}
	call waitfor_Zone "Coliseum of Valor"
}	
function GoPoD(string ZoneName, string version)
{
	echo Debug going to "Plane of Disease: ${ZoneName} [${version}]"
	if (!${Zone.Name.Equal["Plane of Disease: ${ZoneName} [${version}]"]})
	{
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3 30 TRUE
		call DMove -193 3 0 3 30 TRUE
		wait 50		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_pod","Enter the Plane of Disease"]
		wait 100
		switch ${ZoneName}
		{
			case Outbreak
			{
				switch ${version}
				{
					case Solo
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",6]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
				}
				break
			}
			case the Source
			{
				switch ${version}
				{
					case Solo
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",9]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
				}
				break
			}
		}
	}
	wait 50
	call waitfor_Zone "Plane of Disease: ${ZoneName} [${version}]"
	echo Debug end of PoD ${ZoneName} [${version}]
}
function GoPoI(string ZoneName, string version)
{
	variable int offset=0
	variable string offsetQN
	echo Debug going to "Plane of Innovation: ${ZoneName} [${version}]"
	offsetQN:Set["A Stitch in Time, Part I: Security Measures"]
	call check_quest "${offsetQN}"
	if (${Return})
		offset:Inc
	
	if (!${Zone.Name.Equal["Plane of Innovation: ${ZoneName} [${version}]"]})
	{
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3 30 TRUE
		call DMove -94 3 163 3 30 TRUE
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_poi","Enter the Plane of Innovation"]
		wait 100
		switch ${ZoneName}
		{
			case Masks of the Marvelous
			{
				switch ${version}
				{
					case Solo
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",6]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
					case Heroic
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",5]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
				}
				break
			}
			case Gears in the Machine
			{
				switch ${version}
				{
					case Solo
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
					case Heroic
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",2]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
				}
				break
			}
			case Security Measures
			{
				switch ${version}
				{
					case Tradeskill
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",10]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
				}
				break
			}
		}
	}
	wait 50
	call waitfor_Zone "Plane of Innovation: ${ZoneName} [${version}]"
	echo Debug end of GoPoI ${ZoneName} [${version}]
}
function GoSoH(string ZoneName, string version)
{
	echo Debug going to "Shard of Hate: ${ZoneName} [${version}]"
	call goCoV
	call ExitCoV
	call DMove -762 347 1047 3 30 TRUE
	if (!${Zone.Name.Equal["ShardofHate: ${ZoneName} [${version}]"]})
	{
		call waitfor_Zone "Plane of Magic"
		
		wait 100
		switch ${ZoneName}
		{
			case Utter Contempt
			{
				switch ${version}
				{
					case Solo
					{
						do
						{
							OgreBotAPI:ApplyVerbForWho["${Me.Name}","Shard of Hate Portal","Step through the portal"]
							wait 50
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",4]
							wait 50
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
							wait 50
						}
						while (${Zone.Name.Equal["Plane of Magic"]})
						break
					}
				}
				break
			}
		}
	}
	wait 50
	call waitfor_Zone "Shard of Hate: ${ZoneName} [${version}]"
	echo Debug end of SoH ${ZoneName} [${version}]
}
function GoSRT(string ZoneName, string version)
{
	echo Debug going to "Solusek Ro's Tower: ${ZoneName} [${version}]"
	if (!${Zone.Name.Equal["Solusek Ro's Tower: ${ZoneName} [${version}]"]})
	{
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3 30 TRUE
		call DMove 95 3 -164 3 30 TRUE
		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_ro_tower","Enter Solusek Ro's Tower"]
		wait 100
		switch ${ZoneName}
		{
			case Monolith of Fire
			{
				switch ${version}
				{
					case Solo
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",4]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
				}
				break
			}
			case The Obsidian Core
			{
				switch ${version}
				{
					case Solo
					{
						do
						{
							OgreBotAPI:ZoneDoorForWho["${Me.Name}",8]
							wait 50
						}
						while (${Zone.Name.Equal["Coliseum of Valor"]})
						break
					}
				}
				break
			}
		}
	}
	wait 50
	call waitfor_Zone "Solusek Ro's Tower: ${ZoneName} [${version}]"
	echo Debug end of SRT ${ZoneName} [${version}]
}
function GoThrone()
{
	echo Debug going to The Molten Throne
	if (!${Zone.Name.Equal["The Molten Throne"]})
	{
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3 30 TRUE
		call DMove 95 3 -149 3 30 TRUE
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_molten_throne","Enter the Molten Throne"]
		wait 20
		call waitfor_Zone "The Molten Throne"
	}
	echo Debug end of The Molten Throne
}
function GoVarig()
{
	call DMove -2 5 4 3
	call DMove 66 0 116 3
	do
	{
		wait 10
		call IsPresent "Varig Ro" 30
	}
	while (!${Return})
	call PKey "Page Up" 3
	call PKey ZOOMOUT 20
	call MoveCloseTo "Varig Ro"
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
function PrepareToon()
{
	variable string sQN
	call waitfor_Zone "Coliseum of Valor"
	call GetCoVQuests
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