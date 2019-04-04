#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool WestPurged
variable(script) bool EastPurged
variable(script) bool Doors
variable(script) bool Bot32
variable(script) bool Bot16
variable(script) bool Bot8
variable(script) bool Bot4
variable(script) bool Bot2
variable(script) bool Bot1


function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=14
	call StopHunt
	oc !c -letsgo ${Me.Name}

	;if ${Script["livedierepeat"](exists)}
	;	endscript livedierepeat
	;run EQ2Ethreayd/livedierepeat ${NoShiny}
	
	call check_quest "A Stitch in Time, Part I: Security Measures"
	
	if (${setspeed}==0)
		speed:Set[3]
	else
		speed:Set[${setspeed}]
	FightDistance:Set[30]
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
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_moveinfront","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",0]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","FALSE"]
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable int springs
	variable int wires
	variable int nodes
	
	call CountItem "coiled spring"
	springs:Set[${Return}]
	call CountItem "conductive wire"
	wires:Set[${Return}]
	call CountItem "power node"
	nodes:Set[${Return}]
	call CountItem "Electric Manaetic Device (EMD)"
	
	if ((${nodes}<20 || ${wires}<20 || ${springs}<20) && ${Return}<15)
	{
		call DMove -73 -9 92 3
		call Converse "Meldrath the Marvelous" 13
		wait 20
		OgreBotAPI:AcceptReward["${Me.Name}"]
	}
}

function step001()
{
	variable bool Found
	variable bool NotStuck
	variable float loc0
	variable int springs
	variable int wires
	variable int nodes
	
	
	ogre harvestlite
	call CountItem "coiled spring"
	springs:Set[${Return}]
	call CountItem "conductive wire"
	wires:Set[${Return}]
	call CountItem "power node"
	nodes:Set[${Return}]
	call CountItem "Electric Manaetic Device (EMD)"
	
	if ((${nodes}<20 || ${wires}<20 || ${springs}<20) && ${Return}<15)
	{
		NotStuck:Set[FALSE]
		do
		{
			call CountItem "coiled spring"
			springs:Set[${Return}]
			if (${springs}<20)
			{
				do
				{
					loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z}]}]
					echo getting more coiled springs
					call StealthMoveTo "coiled spring" 100 30 5
					Found:Set[${Return}]
					call CheckStuck ${loc0}
					if (${Found} && !${Return})
						NoStuck:Set[TRUE]
					target "coiled spring"
					wait 200
					call CountItem "coiled spring"
					springs:Set[${Return}]
				}
				while (${springs}<20 && ${Found} && ${NoStuck})
			}
			call CountItem "conductive wire"
			wires:Set[${Return}]
			if (${wires}<20)
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
					call CountItem "conductive wire"
					wires:Set[${Return}]
				}
				while (${wires}<20 && ${Found} && ${NoStuck})
			}
			call CountItem "power node"
			nodes:Set[${Return}]
			if (${nodes}<20)
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
					call CountItem "power node"
					nodes:Set[${Return}]
				}
				while (${nodes}<20 && ${Found} && ${NoStuck})
			}
			if (!${NoStuck})
			{
				call UnstuckR 20
			}
			call CountItem "coiled spring"
			springs:Set[${Return}]
			call CountItem "conductive wire"
			wires:Set[${Return}]
			call CountItem "power node"
			nodes:Set[${Return}]
		}
		while (${nodes}<20 || ${wires}<20 || ${springs}<20)
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
			call CountItem "Electric Manaetic Device (EMD)"
			if (!${Return}<15)
			{
				call OpenDoor "Junkyard West Door 03"
				call DMove 98 3 -128 3
				call SMove 128 3 -141 100 20 5
				call DMove 218 3 -170 3
				call DMove 228 3 -164 3
				call PetitPas 228 3 -167 3
				do
				{
					wait 100
					call AutoCraft "an innovative workstation" "Electric Manaetic Device (EMD)" 1
					wait 50
					call CountItem "Electric Manaetic Device (EMD)"
				}
				while (${Return}<15)
			}
	}
}

function step003()
{
	call CheckQuestStep 2
	if (!${Return})
	{
		call DMove 169 3 -153 3
		call SMove 137 3 -184 100 20 5
		call DMove 99 3 -176 3
		call DMove 84 3 -130 3
		call DMove 60 3 -130 3
		call PetitPas 65 3 -127 3
		wait 20
		call OpenDoor "Junkyard West Door 03"
		call DMove 42 4 -122 3
	}
	
	call DMove 42 4 -122 3
	call WaitByPass "an Innovative protector" -123 -140
	echo an Innovative protector is far enough > going in in 5s
	wait 50
	call OpenDoor "Junkyard West Door 02"
	call SMove 23 4 -123 100 12 5
	call SMove 25 4 -161 100 15 5
	wait 50
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call DMove 23 4 -130 3
	echo waiting 1.5 minutes Please be patient
	face 25 -161
	wait 900
	call SMove 24 4 -213 100 50 5 
	call DMove 24 21 -281 3
	call Converse "Meldrath the Marvelous" 4
	wait 50
	call DMove 25 21 -297 3
	call OpenDoor "Factory Door 01"
	
}

function step004()
{
	;Inside the Manaetic Factory
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
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
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
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 100
	
	call PKey STRAFERIGHT 1
	call PKey MOVEFORWARD 1
	call DMove 97 -7 -488 1
	call DMove 84 -7 -485 3
	face 90 -485
	wait 50
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 100
	face 79 -485
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
	wait 50
	oc !c -acceptreward ${Me.Name}
}

	
function step005()
{	
	call DMove 25 3 -545 3
	call DMove 24 -7 -488 3
	call DMove 70 -7 -484 3
	call DMove 80 -7 -484 3
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	call DMove 96 -7 -484 3
	call DMove 97 -7 -437 3
	call DMove 98 -7 -427 3
	call DMove 107 -6 -423 3 30 FALSE FALSE 5
	do
	{
		OgreBotAPI:Special["${Me.Name}"]
		wait 40
		call CheckItem "shorted circuitry" 1
	}
	while (${Return}>0)
	call DMove 98 -7 -427 3 30 FALSE FALSE 3
	call DMove 99 -7 -409 3
	call DMove 96 6 -355 3
	call DMove 105 7 -340 3
	call ActivateVerb "West Purge Lever" 94 7 -342 "Purge" TRUE FALSE TRUE
	do
	{
		wait 5
	}
	while (!${WestPurged})
	call DMove 40 7 -344 3
	call DMove 26 7 -346 2
	WestPurged:Set[False]
}
	
function step006()
{		
	call DMove 25 7 -345 1 30 FALSE FALSE 2
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
	call SMove -85 4 -344 100 20 5
	call DMove -89 -3 -378 3
	call SMove -88 4 -399 100 12 5
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call DMove -89 -3 -378 3
	call DMove -78 -3 -382 3 30 TRUE FALSE 5
	call DMove -75 -3 -453 3
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call PetitPas -78 -3 -446 3 TRUE
	wait 600
	call OpenDoor "Factory East Side Door 02"
	call PetitPas -76 -3 -453 3 TRUE 
	call ActivateVerb "Electric Manaetic Device (EMD)" -76 -3 -453 "Destroy Device"
	call DMove -73 -3 -463 3
	call PetitPas -62 -3 -461 3 TRUE
	do
	{
		OgreBotAPI:Special["${Me.Name}"]
		wait 40
		call CheckItem "chassis shell" 1
	}
	while (${Return}>0)
	call PetitPas -73 -3 -461 3 TRUE
	call DMove -78 -3 -439 3
	call DMove -77 -3 -378 3
	call DMove -88 -3 -374 3
	
	call SMove -89 4 -345 100 20 5
	call DMove -67 7 -345 3
	call OpenDoor "Factory East Side Door 01"
	call DMove -46 7 -342 3
	
	call ActivateVerb "East Purge Lever" -46 7 -342 "Purge" TRUE FALSE TRUE
	wait 20
	echo waiting for Purge
	do
	{
		wait 5
	}
	while (!${EastPurged})
	call DMove 10 7 -346 3
	call DMove 24 7 -346 2
	EastPurged:Set[False]
}
function step007()
{	
	call ActivateVerb "West Purge Lever" 25 7 -345 "Purge" TRUE FALSE TRUE
	wait 20
	echo waiting for Purge
	do
	{
		wait 5
	}
	while (!${WestPurged})
	call DMove 110 7 -344 3
	WestPurged:Set[False]
	call OpenDoor "Factory West Side Door 01"
	call DMove 122 7 -344 1 30 TRUE FALSE 3
	call SMove 135 4 -345 100 20 5
	call DMove 137 -3 -375 3
	call SMove 139 4 -401 100 20 5
	call SMove 154 4 -400 100 20 5
	call DMove 156 4 -415 3
	call DMove 148 4 -417 3
	call DMove 149 4 -427 3
	do
	{
		OgreBotAPI:Special["${Me.Name}"]
		wait 40
		call CheckItem "misshapen gears" 1
	}
	while (${Return}>0)
	call DMove 148 4 -416 3
	call PetitPas 157 4 -418 3 TRUE
}	
	
function step008()
{	
	variable int ItemCounter
	call CheckQuestStep 5
	if (!${Return})
	{
		call CheckItem "Retrofitted Chassis" 1
		if (${Return}>0)
			call AutoCraft "an innovative workstation" "Retrofitted Chassis" 1
		call CheckItem "Retrofitted Circuitry" 1
		if (${Return}>0)
			call AutoCraft "an innovative workstation" "Retrofitted Circuitry" 1
		call CheckItem "Retrofitted Gears" 1
		if (${Return}>0)
			call AutoCraft "an innovative workstation" "Retrofitted Gears" 1	
	}
	do
	{
		ItemCounter:Set[0]
		call CheckItem "Retrofitted Chassis" 1
		if (${Return}>0)
			ItemCounter:Inc
		call CheckItem "Retrofitted Circuitry" 1
		if (${Return}>0)
			ItemCounter:Inc
		call CheckItem "Retrofitted Gears" 1
		if (${Return}>0)
			ItemCounter:Inc
		If (${ItemCounter}>0)
		{
			echo Something is wrong, some craft are missing resolve manually, quest will autocontinue when done
			wait 100
		}
	}
	while (${ItemCounter}>0)
}
function step009()
{
	call SMove 154 4 -400 100 20 5
	call DMove 139 4 -401 3
	call SMove 139 4 -347 100 20 5
	call DMove 121 7 -344 3
	call OpenDoor "Factory West Side Door 01"
	call DMove 100 7 -344 3
	call DMove 97 -7 -408 3
	call ActivateVerb "Electric Manaetic Device (EMD)" 97 -7 -408 "Destroy Device"
	call DMove 97 -7 -440 3
	call DMove 96 -7 -486 3
	call DMove 29 -7 -485 3
	call DMove 24 -7 -500 3
	call DMove 25 3 -538 3
	call DMove 24 3 -555 3
	call DMove 16 3 -565 3 30 TRUE FALSE 5
	call ActivateVerb "Hackbot 3000" 16 3 -565 "Install the Chassis"
	wait 20
	call ActivateVerb "Hackbot 3000" 16 3 -565 "Install the Circuitry"
	wait 20
	call ActivateVerb "Hackbot 3000" 16 3 -565 "Install the Gears"
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	do
	{
		call UseAbility "Hackbot 3000"
		wait 50
		call IsPresent "Hackbot 3000" 10
	}
	while (!${Return})
}
function step010()
{
	call DMove 24 3 -551 3
	call DMove 25 -7 -487 3
	call DMove -25 -7 -485 3
	call OpenDoor "Factory Center East Hall Door 03"
	call DMove -49 -7 -486 3
	wait 50
	call DMove -23 -7 -486 3
	call DMove 98 -7 -486 3
	call DMove 94 -7 -463 3
	call DMove 85 -7 -463 1 30 TRUE FALSE 3
	call DMove 99 -7 -462 1
	call DMove 97 -7 -436 3
	call DMove 96 7 -348 3
	call DMove 114 7 -345 3
	call OpenDoor "Factory West Side Door 01"
	call DMove 122 7 -344 1 30 TRUE FALSE 3
	call SMove 135 4 -345 100 20 5
	call DMove 137 -3 -375 3
	call DMove 128 -3 -374 2 30 TRUE FALSE 3
	call DMove 127 -3 -362 3
	call DMove 128 -3 -435 3
	call DMove 125 -3 -451 3
	wait 20
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call PetitPas 120 -3 -446 3 TRUE
	call OpenDoor "Factory West Side Door 02"
	call PetitPas 125 -3 -444 3 TRUE
	wait 600
	call PetitPas 124 -3 -452 3 TRUE
	;call ActivateVerb "Electric Manaetic Device (EMD)" 124 -3 -452 "Destroy Device"
	call DMove 125 -3 -463 3 30 TRUE FALSE 5
	call DMove 153 -3 -462 3
	call OpenDoor "Factory West Side Door 03"
	call DMove 154 -3 -482 3
	call DMove 188 -3 -496 3
	wait 50
	call DMove 157 -3 -479 3
	call DMove 150 -3 -461 3
	call DMove 127 -3 -461 3
	call DMove 122 -3 -440 3
	call DMove 132 -3 -379 3
	call DMove 139 -1 -365 3
	call SMove 139 4 -347 100 20 5
	call DMove 121 7 -344 3
	call OpenDoor "Factory West Side Door 01"
	call DMove 100 7 -344 3
	call ActivateVerb "West Purge Lever" 94 7 -342 "Purge" TRUE FALSE TRUE
	do
	{
		wait 5
	}
	while (!${WestPurged})
	call DMove 40 7 -344 3
	call DMove 26 7 -346 2
	WestPurged:Set[FALSE]
}
function step011()
{		
	call DMove 25 7 -345 1 30 FALSE FALSE 2
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
	EastPurged:Set[FALSE]
	
	call OpenDoor "Factory East Side Door 01"
	call SMove -85 4 -344 100 20 5
	call DMove -89 -3 -378 3
	call SMove -89 3 -401 100 12 5
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
	{
		do
		{
			Me.Inventory["Electric Manaetic Device (EMD)"]:Use
			wait 50
			call IsPresent "Electric Manaetic Device (EMD)" 15
		}
		while (!${Return})
	}
	call DMove -89 -3 -378 3
	wait 600
	call DMove -88 3 -401 3
	call DMove -93 4 -445
	wait 20
	call DMove -73 -3 -445 3 30 TRUE FALSE 5
	call DMove -75 -3 -453 3
	call DMove -77 -3 -466 3
	call DMove -102 -3 -460 3
	call OpenDoor "Factory East Side Door 03"
	call DMove -107 -3 -481 3
	call DMove -134 -3 -516 3
	wait 20
	call DMove -106 -3 -477 3
	call DMove -102 -3 -460 3
	call DMove -78 -3 -460 3
	call DMove -74 -3 -450 3
	call DMove -72 -3 -436 3
	call DMove -87 -3 -372
	
	call SMove -86 4 -343 100 20 5
	call DMove -67 7 -345 3
	call OpenDoor "Factory East Side Door 01"
	call DMove -46 7 -342 3
	
	call ActivateVerb "East Purge Lever" -46 7 -342 "Purge" TRUE FALSE TRUE
	wait 20
	echo waiting for Purge
	do
	{
		wait 5
		call ActivateVerb "East Purge Lever" -46 7 -342 "Purge" TRUE FALSE TRUE
	
	}
	while (!${EastPurged})
	call DMove 10 7 -346 3
	call DMove 24 7 -346 2
	EastPurged:Set[False]
}
function step012()
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
		call ActivateVerb "West Purge Lever" 25 7 -340 "Purge" TRUE FALSE TRUE
	}
	while (!${WestPurged})
	call DMove 70 7 -344 3
	call DMove 92 7 -344 2
	WestPurged:Set[False]
	call DMove 97 -7 -405 3
	call DMove 97 -7 -416 3
	call DMove 97 -7 -405 3
	call DMove 97 -7 -430 3
	call DMove 97 -7 -473 3
	call DMove 97 -7 -488 1
	call DMove 84 -7 -485 3
	call DMove 79 -7 -485 3
	call DMove 94 -7 -486 3
	call DMove 84 -7 -489 3
	call DMove 75 -7 -484 3
	call DMove 23 -7 -484 3
	call DMove 24 -7 -501 3
	call DMove 24 3 -541 3
	call DMove 23 3 -563 3
}	

function step013()
{
	call InitBot
	do
	{
		if ${Bot32}
		{
			call DMove 24 3 -561 2
			call DMove 5 3 -548 2 30 TRUE FALSE 3
			echo right click turn clockwise
			wait 200
		}
	
		if ${Bot16}
		{
			call DMove 24 3 -561 2
			call DMove 10 4 -548 2 30 TRUE FALSE 3
			echo right click turn clockwise
			wait 200
		}
	
		if ${Bot8}
		{
			call DMove 24 3 -561 2
			call DMove 18 5 -547 2 30 TRUE FALSE 3
			echo right click turn clockwise
			wait 200
		}
	
		if ${Bot4}
		{
			call DMove 24 3 -561 2
			call DMove 30 3 -547 2 30 TRUE FALSE 3
			echo right click turn clockwise
			wait 200
		}
	
		if ${Bot2}
		{
			call DMove 24 3 -561 2
			call DMove 37 4 -547 2 30 TRUE FALSE 3
			echo right click turn clockwise
			wait 200
		}
	
		if ${Bot1}
		{
			call DMove 24 3 -561 2
			call DMove 47 3 -547 2 30 TRUE FALSE 3
			echo right click turn clockwise
			wait 200
		}
	}
	while (!${Doors})
	call DMove 24 3 -561 2
}
function step014()
{
	call DMove 24 -7 -457 2
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call DMove 68 -7 -455 2
	call DMove 63 -7 -447 2 30 FALSE FALSE 5
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call DMove 72 -7 -412 3
	call DMove 62 -7 -401 2 
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call DMove 70 -7 -413 3
	call DMove 66 -7 -454 3
	call DMove -13 -7 -458 3
	call DMove -13 -7 -446 2
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call DMove -21 -7 -433 3
	call DMove -17 -7 -414 3
	call DMove -17 -7 -398 2
	call IsPresent "Electric Manaetic Device (EMD)" 15
	if (!${Return})
		Me.Inventory["Electric Manaetic Device (EMD)"]:Use
	wait 50
	call DMove -6 -7 -380 3
	call DMove 19 -5 -378 3
	do
	{
		OgreBotAPI:Special["${Me.Name}"]
		wait 20
		call CheckQuestStep 10
	}
	while (!${Return})

	do
	{
		
		if (${Zone.Name.Equal["Plane of Innovation: Security Measures [Tradeskill]"]})
		{
			call DMove 23 -7 -411 3
			OgreBotAPI:Special["${Me.Name}"]
		}
		wait 200
	}
	while (${Zone.Name.Equal["Plane of Innovation: Security Measures [Tradeskill]"]})
	
}
function InitBot()
{
	do
	{
		call UseAbility "Hackbot 3000"
		wait 50
		call IsPresent "Hackbot 3000" 10
	}
	while (!${Return})
	Actor[name,"Hackbot 3000"]:DoubleClick
	wait 20
	echo ${Bot32} ${Bot16} ${Bot8} ${Bot4} ${Bot2} ${Bot1}
	
}	
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	if (${Message.Find["TATUS: True"]} > 0 && ${Speaker.Equal["Binary Control Bot XXXII"]})
	{
		Bot32:Set[TRUE]
	}
	if (${Message.Find["TATUS: True"]} > 0 && ${Speaker.Equal["Binary Control Bot XVI"]})
	{
		Bot16:Set[TRUE]
	}
	if (${Message.Find["TATUS: True"]} > 0 && ${Speaker.Equal["Binary Control Bot VIII"]})
	{
		Bot8:Set[TRUE]
	}
	if (${Message.Find["TATUS: True"]} > 0 && ${Speaker.Equal["Binary Control Bot IV"]})
	{
		Bot4:Set[TRUE]
	}
	if (${Message.Find["TATUS: True"]} > 0 && ${Speaker.Equal["Binary Control Bot II"]})
	{
		Bot2:Set[TRUE]
	}
	if (${Message.Find["TATUS: True"]} > 0 && ${Speaker.Equal["Binary Control Bot I"]})
	{
		Bot1:Set[TRUE]
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
	
	if (${Message.Find["Bot XXXII STATUS: True"]} > 0)
	{
		Bot32:Set[TRUE]
	}
	if (${Message.Find["Bot XVI STATUS: True"]} > 0)
	{
		Bot16:Set[TRUE]
	}
	if (${Message.Find["Bot VIII STATUS: True"]} > 0)
	{
		Bot8:Set[TRUE]
	}
	if (${Message.Find["Bot IV STATUS: True"]} > 0)
	{
		Bot4:Set[TRUE]
	}
	if (${Message.Find["Bot II STATUS: True"]} > 0)
	{
		Bot2:Set[TRUE]
	}
	if (${Message.Find["Bot I STATUS: True"]} > 0)
	{
		Bot1:Set[TRUE]
	}
	if (${Message.Find["metal rubbing against metal"]} > 0)
	{
		Doors:Set[TRUE]
	}
}
