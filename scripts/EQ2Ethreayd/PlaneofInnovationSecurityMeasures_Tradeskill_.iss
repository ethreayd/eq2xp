#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool WestPurged
variable(script) bool EastPurged


function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=7
	call StopHunt
	oc !c -letsgo ${Me.Name}

	;if ${Script["livedierepeat"](exists)}
	;	endscript livedierepeat
	;run EQ2Ethreayd/livedierepeat ${NoShiny}
	
	call check_quest "A Stitch in Time, Part I: Security Measures"
	
	if (${setspeed}==0)
	{
		switch ${Me.Archetype}
		{
			case fighter
			{
				echo fighter
				speed:Set[3]
				FightDistance:Set[15]
			}
			break
			case priest
			{
				echo priest
				speed:Set[3]
				FightDistance:Set[15]
			}
			break
			case mage
			{
				echo mage
				speed:Set[1]
				FightDistance:Set[30]
			}
			break
			case scout
			{
				echo scout
				speed:Set[1]
				FightDistance:Set[15]
			}
			break
			default
			{
				echo unknown
				speed:Set[1]
				FightDistance:Set[30]
			}
			break
		}
	}
	else
		speed:Set[${setspeed}]
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	;if (!${NoShiny})
	;	run EQ2Ethreayd/autoshinies 50 ${speed} 
	
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Plane of Innovation: Security Measures [Tradeskill]"
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_ActorStanceChange]:AttachAtom[StanceChange]

	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_moveinfront","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",0]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","FALSE"]
	
	if (${stepstart}==0)
	{
		call CheckQuestStep 1
		if ${Return}
		{
			stepstart:Set[2]
			call CheckQuestStep 2
			if ${Return}
			{
				
			}
		}
	}
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	call DMove -73 -9 92 3
	call Converse "Meldrath the Marvelous" 13
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step001()
{
	variable bool Found
	variable bool NotStuck
	variable float loc0
	
	ogre harvestlite
	call CheckQuestStep 1
	if (!${Return})
	{
		NotStuck:Set[FALSE]
		do
		{
			call CheckQuestStep 2
			if (!${Return})
			{
				do
				{
					loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z}]}]
					echo getting more coiled springs
					call StealthMoveTo "coiled springs" 100 30 5
					Found:Set[${Return}]
					call CheckStuck ${loc0}
					if (${Found} && !${Return})
						NoStuck:Set[TRUE]
					target "coiled springs"
					wait 200
					call CheckQuestStep 2
				}
				while (!${Return} && ${Found} && ${NoStuck})
			}
			call CheckQuestStep 3
			if (!${Return})
			{
				do
				{
					loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z}]}]		
					echo getting more conductive wire
					call StealthMoveTo "conductive wire" 100 30 5
					Found:Set[${Return}]
					call CheckStuck ${loc0}
					if (${Found} && !${Return})
						NoStuck:Set[TRUE]
					target "conductive wire"
					wait 200
					call CheckQuestStep 3
				}
				while (!${Return} && ${Found} && ${NoStuck})
			}
			call CheckQuestStep 4
			if (!${Return})
			{
				do
				{
					loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z}]}]
					echo getting more power node
					call StealthMoveTo "power node" 100 30 5
					Found:Set[${Return}]
					call CheckStuck ${loc0}
					if (${Found} && !${Return})
						NoStuck:Set[TRUE]
					target "power node"
					wait 200
					call CheckQuestStep 4
				}
				while (!${Return} && ${Found} && ${NoStuck})
			}
			if (!${NoStuck})
			{
				call UnstuckR 20
			}
			call CheckQuestStep 1
		}
		while (!${Return})
	}
	ogre end harvestlite
}	

function step002()
{
	call CheckQuestStep 1
	if (${Return})
	{
			call DMove 9 -10 161 3
			call DMove 99 -10 118 3
			call DMove 133 -3 78 3
			call DMove 105 -1 52 3
			call SMove 100 3 21 100 20 5
			call SMove 111 3 -4 100 15 5
			call SMove 121 3 -24 100 20 5
			call DMove 98 11 -68 3
			call SMove 82 3 -74 100 15 5
			call SMove 69 3 -84 100 15 5
			call PetitPas 70 4 -86 2
			call OpenDoor "Junkyard West Door 01"
			call DMove 71 4 -100 3
			call DMove 65 4 -96 3
			call DMove 53 4 -95 3
			call DMove 48 4 -125 3
			call DMove 63 4 -127 3
			call OpenDoor "Junkyard West Door 03"
			call DMove 98 3 -128 3
			call SMove 128 3 -141 100 20 5
			call DMove 218 3 -170 3
			call DMove 228 3 -164 3
			call PetitPas 228 3 -167 3
			wait 100
			call CheckQuestStep 2
			if (!${Return})
				call AutoCraft "an innovative workstation" "Electric Manaetic Device (EMD)" 1
	}
}

function step003()
{
	call DMove 169 3 -153 3
	call SMove 137 3 -184 100 20 5
	call DMove 99 3 -176 3
	call DMove 84 3 -130 3
	call DMove 60 3 -130 3
	call PetitPas 65 3 -127 3
	wait 100
	call OpenDoor "Junkyard West Door 03"
	call DMove 42 4 -122 3
	call WaitByPass "an Innovative protector" -123 -140
	wait 50
	call OpenDoor "Junkyard West Door 02"
	call SMove 23 4 -123 100 12 5
	call SMove 25 4 -161 100 15 5
	wait 50
	Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call DMove 23 4 -130 3
	echo waiting 2 minutes Please be patient
	wait 1200
	call SMove 24 4 -213 100 50 5 
	call DMove 24 21 -281 3
	call Converse "Meldrath the Marvelous" 4
	wait 50
	call DMove 25 21 -297 3
	call OpenDoor "Factory Door 01"
	
}

function step004()
{
	
	call DMove 25 7 -340 3
	wait 10
	call ActivateVerb "West Purge Lever" 25 7 -340 "Purge" TRUE FALSE TRUE
	wait 20
	face 97 -344
	echo waiting for Purge
	do
	{
		wait 5
	}
	while (!${WestPurged})
	call DMove 92 7 -344 3
	WestPurged:Set[False]
	call DMove 97 -7 -405 3
	wait 50
	Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 100
	call PKey STRAFERIGHT 1
	call PKey MOVEFORWARD 1
	call DMove 97 -7 -416 3
	call OpenDoor "Factory Center West Hall Door 01"
	wait 5
	call DMove 97 -7 -405 3
	
	call SMove 97 -7 -430 100 15 5
	call OpenDoor "Factory Center West Hall Door 02"
	call DMove 97 -7 -473 3
	wait 50
	Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 100
	
	call PKey STRAFERIGHT 1
	call PKey MOVEFORWARD 1
	call DMove 97 -7 -488 1
	call DMove 84 -7 -485 3
	face 90 -485
	wait 50
	Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 100
	call SMove 79 -7 -485 100 15 5
	call OpenDoor "Factory Center West Hall Door 03"
	face 90 -485
	call PKey STRAFERIGHT 1
	call PKey MOVEFORWARD 1
	call DMove 94 -7 -486 3
	wait 300
	call SMove 84 -7 -489 100 15 5
	call SMove 75 -7 -484 100 15 5
	call SMove 23 -7 -484 100 15 5
	call DMove 24 -7 -501 3
	call OpenDoor "Factory Center North Hall Door 01"
	call DMove 24 3 -541 3
	call OpenDoor "Factory Control Room Door 01"
	call DMove 23 3 -563 3
	wait 20
	call MoveCloseTo "Meldrath the Marvelous" 
	call Converse "Meldrath the Marvelous" 11
}

	
function step005()
{	
	call DMove 25 3 -545 3
	call DMove 24 -7 -488 3
	call DMove 70 -7 -484 3
	call DMove 96 -7 -484 3
	call DMove 97 -7 -437 3
	call DMove 98 -7 -427 3
	call DMove 107 -6 -423 3
	OgreBotAPI:Special["${Me.Name}"]
	wait 20
	call DMove 98 -7 -427 3
	call DMove 99 -7 -409 3
	call DMove 96 6 -355 3
	call DMove 105 7 -340 3
	call ActivateVerb "West Purge Lever" 94 7 -342 "Purge" TRUE FALSE TRUE
	do
	{
		wait 5
	}
	while (!${WestPurged})
	call DMove 25 7 -345 3
	WestPurged:Set[False]
}
	
function step006()
{	
	call DMove 25 7 -349 1 30 FALSE FALSE 2
	call ActivateVerb "East Purge Lever" 25 7 -345 "Purge" TRUE FALSE TRUE
	wait 20
	face -64 -345
	echo waiting for Purge
	do
	{
		wait 5
	}
	while (!${EastPurged})
	call DMove -64 7 -345 3
	EastPurged:Set[False]
	
	call OpenDoor "Factory East Side Door 01"
	call PetitPas -72 7 -343 1
	face 75 -353
	call DMove -76 -3 -372 3
	call DMove -76 -3 -447 3
	call WaitByPass "an Innovative protector" -70 -90
	call DMove -76 -3 -452 3
	call OpenDoor "Factory East Side Door 02"
	call DMove -73 -3 -463 3
	call DMove -62 -3 -461 3
	OgreBotAPI:Special["${Me.Name}"]
	wait 20
	call DMove -74 -3 -459 3
	call DMove -78 -3 -439 3
	call DMove -77 -3 -378 3
	call DMove -88 -3 -374 3
	call DMove -89 4 -345 3
	call DMove -67 7 -345 3
	call DMove -46 7 -342 3
	call ActivateVerb "East Purge Lever" -46 7 -342 3 "Purge" TRUE FALSE TRUE
	wait 20
	echo waiting for Purge
	do
	{
		wait 5
	}
	while (!${EastPurged})
	call DMove 26 7 -346 3
	EastPurged:Set[False]
	
	call ActivateVerb "West Purge Lever" 25 7 -354 "Purge" TRUE FALSE TRUE
	wait 20
	echo waiting for Purge
	do
	{
		wait 5
	}
	while (!${WestPurged})
	call DMove 114 7 -344 3
	WestPurged:Set[False]
	call OpenDoor "Factory West Side Door 01"
	call DMove 122 7 -342 1
	call DMove 125 -3 -371 3
	call DMove 139 -3 -379 3
	call DMove 136 4 -401 3
	call SMove 157 4 -401 100 20 5
	call DMove 156 4 -415 3
	call DMove 148 4 -417 3
	call DMove 149 4 -427 3
	OgreBotAPI:Special["${Me.Name}"]
	wait 20
	call DMove 148 4 -416 3
	call DMove 157 4 -418 1
}	
	
function step007()
{	
	call CheckQuestStep 5
	if (!${Return})
	{
		call CheckQuestStep 6
		if (!${Return})
			call AutoCraft "an innovative workstation" "Retrofitted Chassis" 1
		call CheckQuestStep 7
		if (!${Return})
			call AutoCraft "an innovative workstation" "Retrofitted Circuitry" 1
		call CheckQuestStep 8
		if (!${Return})
			call AutoCraft "an innovative workstation" "Retrofitted Gears" 1	
	}
}
function OpenChargedDoor()
{
	variable string PrimaryWeapon
	echo open door with charged hand
	PrimaryWeapon:Set["${Me.Equipment[Primary]}"]
	Me.Inventory["Electro-Charged Clockwork Hand"]:Equip
	wait 20
	call AutoPassDoor "door_hand_lock" 145 3 -55 TRUE
	wait 20
	call CheckCombat ${FightDistance}
	Me.Inventory["${PrimaryWeapon}"]:Equip
}	
	
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	;echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
    if (${Message.Find["begins to overheat"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -40 0 0
		eq2execute merc backoff
	
	}
	if (${Message.Find["engaging hostile entities"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 40 0 0
		target "The Glitched Guardian 10101"
		eq2execute merc ranged
	}
	if (${Message.Find["BREACH!!! ALERT"]} > 0)
	{
		Detected:Set[TRUE]
		echo "Detected in tunnel - restarting"
	}
	
	if (${Message.Find["need to turn his key"]} > 0)
	{
		press MOVEFORWARD
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${Speaker}","Turn Key"]
		press MOVEFORWARD
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${Speaker}","Turn Key"]
		press MOVEFORWARD
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${Speaker}","Turn Key"]
		press MOVEFORWARD
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${Speaker}","Turn Key"]
		press MOVEFORWARD
	}
}
 
atom HandleAllEvents(string Message)
{
	;echo Catch Event ${Message}
    if (${Message.Find["western corridor has been purged"]} > 0)
	{
		WestPurged:Set[TRUE]
	}
	if (${Message.Find["West Purge Lever has reset"]} > 0)
	{
		WestPurged:Set[FALSE]
	}
	 if (${Message.Find["eastern corridor has been purged"]} > 0)
	{
		EastPurged:Set[TRUE]
	}
	if (${Message.Find["East Purge Lever has reset"]} > 0)
	{
		EastPurged:Set[FALSE]
	}
}
atom StanceChange(string ActorID, string ActorName, string ActorType, string OldStance, string NewStance, string TargetID, string Distance, string IsInGroup, string IsInRaid)
{
    if (${NewStance.Equal["DEAD"]})
	{
		echo "I am dead"
		
	}
}