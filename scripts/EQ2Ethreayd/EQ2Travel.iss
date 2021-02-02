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



function CorrectZone(string ZoneName)
{
	if (${ZoneName.Equal["Freeport"]})
		return "The City of Freeport"	
	if (${ZoneName.Equal["The Great Divide"]})
		return "Great Divide"
	if (${ZoneName.Equal["The Sundered Frontier"]})
		return "Sundered Frontier"
	if (${ZoneName.Equal["Sanctus Seru"]})
		return "Sanctus Seru \[City\]"	
	return "${ZoneName}"
}
; Main goZone script (entry point) run wrap goZone "Zone Name"
function goZone(string ZoneName, string Transport)
{
	variable string AltZoneName
	
	call CorrectZone "${ZoneName}"
	AltZoneName:Set["${Return}"]
	call Log "goZone called for ${ZoneName} (changed to ${Return})" with ${Transport}
	
	if (!${Transport(exists)})
		Transport:Set["Spire"]
	if (${ZoneName.Equal["Freeport"]})
		Transport:Set["Globe"]
	if (${ZoneName.Equal["Tranquil Sea"]})
		Transport:Set["Globe"]
	if (${ZoneName.Equal["Butcherblock"]} || ${ZoneName.Equal["Butcherblock Mountains"]})
	{
		ZoneName:Set["Butcherblock Mountains"]
		Transport:Set["Globe"]
	}
	if (${Transport.Equal["Globe"]})
	{
		call IsPresent "mariners_bell"
		if (${Return})
		{
			Transport:Set["mariners_bell"]
		}
		call IsPresent "Pirate Captain"
		if (${Return})
		{
			Transport:Set["Pirate Captain"]
		}
	}
	call IsPresent ${Transport}
	if (!${Return})
	{
		call Log "Can't find ${Transport} in ${Zone.Name} to go to ${ZoneName}" WARNING
	}

	if (${ZoneName.Equal["Fallen Gate"]})
	{
		call goFallenGate
		return TRUE
	}
	if (${ZoneName.Equal["Temple of Scale"]} || ${ZoneName.Equal["The Temple of Scale"]})
	{
		call goTempleofScale
		return TRUE
	}
	if (${ZoneName.Equal["Sanctum of the Scaleborn"]})
	{
		call goSanctumoftheScaleborn
		return TRUE
	}
	if (${ZoneName.Equal["Castle Mistmoore"]})
	{
		call goCastleMistmoore
		return TRUE
	}
	if (${ZoneName.Equal["Karnor's Castle"]})
	{
		call goKarnorsCastle
		return TRUE
	}
	if (${ZoneName.Equal["Kaladim"]})
	{
		call goKaladim
		return TRUE
	}
	if (${ZoneName.Equal["Hold of Rime: The Ascent"]})
	{
		call goHoldofRime_TheAscent
		return TRUE
	}
	if (${ZoneName.Equal["The Temple of Cazic-Thule"]})
	{
		call goCazicThule
		return TRUE
	}
	if (${ZoneName.Equal["Wayward Manor"]})
	{
		call goWaywardManor
		return TRUE
	}
	if (${ZoneName.Equal["Nye'Caelona"]})
	{
		call Log "in Nye'Caelona goZone condition. calling goNyeCaelona in EQ2Travel" INFO
		call goNyeCaelona
		return TRUE
	}
	if (${ZoneName.Equal["Obulus Frontier"]})
	{
		call goObulusFrontier
		return TRUE
	}
	if (${ZoneName.Equal["Fordel Midst"]})
	{
		call goFordelMidst
		return TRUE
	}
	if (${ZoneName.Equal["Aurelian Coast"]})
	{
		call goAurelianCoast
		return TRUE
	}
	if (${ZoneName.Right[12].Equal["Sanctus Seru"]})
	{
		call goSanctusSeru
		return TRUE
	}
	if (${ZoneName.Equal["Wracklands"]} || ${ZoneName.Equal["The Wracklands"]})
	{
		call goWracklands
		return TRUE
	}
	if (${ZoneName.Equal["The Hole"]} || ${ZoneName.Equal["Hole"]})
	{
		call goTheHole
		return TRUE
	}
	if (${ZoneName.Equal["Maj'Dul"]})
	{
		call goMajDul
		return TRUE
	}
	echo Going to Zone: ${ZoneName} (${AltZoneName}) with ${Transport} (inside goZone in tools)
	if (${Zone.Name.Right[10].Equal["Guild Hall"]})
	{
		call MoveCloseTo "${Transport}"
		call ActivateSpire "${Transport}"
		wait 30
		OgreBotAPI:Travel["${Me.Name}", "${ZoneName}"]
		wait 300
		echo I am in ${ZoneName} ((${Zone.Name.Right[10].Equal["Guild Hall"]})) / ${Zone.Name.Left[${ZoneName.Length}].Equal["${ZoneName}"]}
	}
	call waitfor_Zoning
	
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]} && !${Zone.Name.Left[${AltZoneName.Length}].Equal["${AltZoneName}"]})
	{
		echo Something is wrong : (!${Zone.Name.Right[10].Equal["Guild Hall"]} && !${Zone.Name.Left[${AltZoneName.Length}].Equal["${AltZoneName}"]}) ${Zone.Name}/${AltZoneName}
		call goto_GH
		wait 300
		call goZone "${ZoneName}" "${Transport}"
	}
	if (!${Zone.Name.Left[${AltZoneName.Length}].Equal["${AltZoneName}"]})
	{
		call goZone "${ZoneName}" "${Transport}"
	}
	echo I am in ${ZoneName} (${AltZoneName}) (end of goZone)
}
function IsFlyingZone()
{	
	variable index:string FlyingZone
	variable int i
	FlyingZone:Insert["The Blinding"]
	FlyingZone:Insert["Aurelian Coast"]
	FlyingZone:Insert["The Wracklands"]
	for ( i:Set[1] ; ${i} <= ${FlyingZone.Used} ; i:Inc )
	{
		 
		if ${Zone.Name.Left[${FlyingZone[${i}].Length}].Equal["${FlyingZone[${i}]}"]}
			return TRUE
	}
	return FALSE
}
function goRecusoTor(bool Force)
{
	call goZone "The Blinding"	
	call TestArrivalCoord -584 34 363
	if (!${Return})
	{
		call TestArrivalCoord 623 428 -582
		if (!${Return})
		{
			echo I am somewhere in the middle of the Blinding...
			if (!${Force})
				call navwrap -584 34 363
			else
			{
				call goto_GH
				call goRecusoTor
			}
		}
		else
		{
			call DMove 594 429 -582 3 
			call MoveCloseTo "a tamed Shik'Nar drone"
			do
			{
				call ActivateVerbOn "a tamed Shik'Nar drone" "Ride Shik'Nar To Recuso Tor"
				wait 100
				call TestArrivalCoord -584 34 363
			}
			while (!${Return})
		}
	}
	call GoDown
	echo I am already in Recuso Tor
}
function goDainitheWright(bool Force)
{

	call goRecusoTor ${Force}
	call DMove -601 32 393 3
	call DMove -605 38 463 3
	call DMove -586 38 463 3
	call DMove -585 38 453 3 30 FALSE FALSE 5
}
function goAc()
{
	call goAurelianCoast
}
function goAurelianCoast()
{
	if (!${Zone.Name.Left[14].Equal["Aurelian Coast"]})
	{
		echo Going to Aurelian Coast
		call goZone "The Blinding"
		if (!${OgreBotAPI.KWAble})
		{
			;call goRecusoTor
			if (${Me.Y}>250)
			{
				call 3DNav 85 400 -184
				call GoDown
				call 3DNav -269 125 132
				call GoDown
			}
			call 3DNav 516 120 532
			call GoDown
		}
		call DMove 754 38 624 3
		wait 20
		call GoDown
		face 879 590
		press -hold MOVEFORWARD
		wait 30
		press -release MOVEFORWARD
	}
	else
		call navwrap 500 145 -591
}
function goFreeport()
{
	if (!${Zone.Name.Left[8].Equal["Freeport"]})
	{
		call goZone "Freeport" "Globe"
	}
	else
		echo already in Freeport (${Zone.Name})
}
function goQeynos()
{
	if (!${Zone.Name.Left[6].Equal["Qeynos"]})
	{
		call goZone "Qeynos" "Globe"
	}
	else
		echo already in Qeynos (${Zone.Name})
}
function goMasterofCoins()
{
	call goNPCBarnabyBlunderbuss
}
function goNPCBarnabyBlunderbuss()
{
	call goZone "Butcherblock Mountains"
	call navwrap 636 26 596
}
function goStanleyParnem()
{
	call goNPCStanleyParnem
}
function goNPCStanleyParnem()
{
	if (${Actor["Stanley Parnem"].Distance} > 10 || !${Actor["Stanley Parnem"].Distance(exists)})
	{
		
		call FreeportToon
		wait 50
		if ${Return}
		{
			call goZone Freeport Globe
			wait 50
			call DMove -192 -57 169 3
			call DMove -188 -57 108 3
			call DMove -201 -56 78 3
			call DMove -242 -56 60 3
		}
		else
		{
			call goZone Qeynos Globe
			wait 50
			call DMove 972 -26 89 3
		}
		wait 50
		call goNPCStanleyParnem
	}
	call MoveCloseTo "Stanley Parnem"
}	
function goWracklands()
{
	if (${Zone.Name.Left[10].Equal["Wracklands"]})
		return
	else
	{
		call goZone "The Blinding"
		call navwrap -275 219 -825
		call DMove -285 218 -900 3
		face -290 -920
		press -hold MOVEFORWARD
		wait 30
		press -release MOVEFORWARD
	}
}
function goSs()
{
	call goSsraeshzaPortal
}

function goSsraeshzaPortal()
{
	call goWracklands
	call navwrap 724 77 679
}
function goSanctusSeru()
{
	if (!${Zone.Name.Left[19].Equal["Sanctus Seru \[City\]"]})
	{
		if (${Zone.Name.Left[15].Equal["Aurelian Coast"]})
		{
			if (!${OgreBotAPI.KWAble})
			{
				if (${Me.X} < 120 && ${Me.X} > 100 &&  ${Me.Y} < 75 && ${Me.Y} > 45 && ${Me.Z} < -600 && ${Me.Z} > -670)
				{
					call DMove 113 67 -622 3
					call DMove 94 72 -596 3
					call DMove 120 83 -545 3
					call DMove 121 85 -526 3 30 FALSE FALSE 3
					call DMove 162 82 -463 3
					call 3DNav 160 151 -453
					call 3DNav 231 151 -329
					call 3DNav 270 151 -263
					call 3DNav 402 160 -194
					call 3DNav 549 160 -377
					call 3DNav 647 160 -446
					call GoDown
					call DMove 633 96 -512 3
					call DMove 576 119 -533 3
					call DMove 468 132 -480 3
					call DMove 453 133 -484 3 30 FALSE FALSE 3
				}
				else
				{
					call goto_GH
					call goSanctusSeru
					return
				}
			}
			else
			{
				call KWMove 453 133 -484
				wait 10
				call goDown
				wait 10
				oc !c -Zone ${Me.Name}
				wait 50
				call waitfor_Zoning
			}	
		}
		else
		{
			call goZone "The Blinding"
			if (!${OgreBotAPI.KWAble})
			{
				if (${Me.Y}>250)
				{
					call 3DNav 85 400 -184
					call GoDown
					call 3DNav -269 125 132
					call GoDown
				}
				call 3DNav 516 120 532
				call GoDown
				call DMove 616 43 593 3
				call DMove 722 58 708 3
			}
			else
			{
				call KWMove 722 58 708
				wait 150
			}	
			oc !c -Zone ${Me.Name}
			do
			{
				wait 10
			}
			while (!${Zone.Name.Left[19].Equal["Sanctus Seru \[City\]"]})
			call goSanctusSeru
			return
		}
	}
	else
	{
		if (${OgreBotAPI.KWAble})
			call KWMove -276 181 0
		call TestArrivalCoord -276 181 0
		if ${Return}
			echo I am in Sanctus Seru (${Zone.Name})
		else
		{
			call waitfor_Zone "Sanctus Seru \[City\]"
			call TestArrivalCoord -399 88 2
			if ${Return}
			{
				call DMove -328 90 -16 3
				call DMove -307 88 -105 3
				call DMove -322 88 -164 3
				do
				{
					call MoveCloseTo "Teleporter Base"
					wait 10
				}
				while (${Me.Y}<100 && !${OgreBotAPI.KWAble})
				call DMove -230 180 -46 3
				call DMove -258 181 -1 3
				call DMove -276 181 0 3
			}
			else
			{
				call waitfor_Zone "Sanctus Seru \[City\]"
				call Evac
				call waitfor_Zone "Sanctus Seru \[City\]"
				call goSanctusSeru
				return
			}
		}
	}	
}
function goObulusFrontier()
{
	call Log "in function goObulusFrontier(${NoTotem})"
	if ${Zone.Name.Left[15].Equal["Obulus Frontier"]}
		return TRUE
	call CheckIfItemPresent "Twark Transport Totem" 1
	
	if (${Return})
	{
		call Log "Using Twark Teleport"
		call UseInventory "Twark Transport Totem"
	}
	else
	{
		call Log "Going there by foot"
		call goZone "Kylong Plains" Globe
		call navwrap 2141 141 -3002
		face 90
		press -hold MOVEFORWARD
		wait 30
		press -release MOVEFORWARD
	}
	call waitfor_Zone "Obulus Frontier"
	call Log "end of goObulusFrontier(${NoTotem}) function"
}
function goHate()
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
			call waitfor_Zone "Coliseum of Valor"
		}
		call IsPresent "Large Ulteran Spire"
		if (${Return})
		{
			call MoveCloseTo "Large Ulteran Spire"
			wait 20
			OgreBotAPI:ApplyVerbForWho["${Me.Name}","Large Ulteran Spire","Voyage Through Norrath"]
			wait 50
			OgreBotAPI:Travel["${Me.Name}", "Plane of Magic"]
			wait 600
		}
	}
	if (${Zone.Name.Left[14].Equal["Plane of Magic"]})
	{
		;call ActivateVerb "zone_to_pov" -785 345 1116 "Enter the Coliseum of Valor"
		;call DMove -2 5 4 3
	}
	if (${Zone.Name.Left[17].Equal["Coliseum of Valor"]})
	{
		call DMove -2 5 4 3
		call ExitCoV
		call goHate
	}
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]} && !${Zone.Name.Left[14].Equal["Plane of Magic"]} && !${Zone.Name.Equal["Coliseum of Valor"]})
	{
		call goto_GH
		wait 600
		call goHate
	}
	call waitfor_Zone "Plane of Magic"
}
function goNyeCaelona()
{
	call Log "in function goNyeCaelona"
	call goObulusFrontier
	wait 50
	call navwrap -215 91 -186
}

function goArtisanTrainer()
{
	call goZone "Timorous Deep" Globe
	call navwrap 2508 12 1221
	face 45
	press -hold MOVEFORWARD
	wait 20
	press -release MOVEFORWARD
	call waitfor_Zoning
	call navwrap 2817 121 1240
}
function goFallenGate()
{
	;Level 20 Zone
	call CheckZone "Fallen Gate"
	if (!${Return})
	{
		call SetMentorLevel 20
		call goZone "The Commonlands" Globe
		wait 50
		call navwrap 1485 -39 -408
		wait 50
		call ZoneIn "Fallen Gate"
		wait 50
		return TRUE
	}
	return FALSE
}
function goKaladim()
{
	;Level 30 Zone
	call CheckZone "Kaladim"
	if (!${Return})
	{
		call SetMentorLevel 30
		call goZone "Butcherblock Mountains" Globe
		wait 50
		call navwrap -170 165 -567
		wait 50
		face -175 -575
		wait 10
		do
		{
			oc !c -Zone ${Me.Name}
			wait 10
			call IsZoning
		}
		while (!${Return} && !${Zone.Name.Equal["Kaladim"]})
		call waitfor_Zone "Kaladim"
		wait 50
		call DMove -4 -2 -20 3
		return TRUE
	}
	return FALSE
}
function goCazicThule()
{
	;Level 40 Zone
	call CheckZone "The Temple of Cazic-Thule"
	if (!${Return})
	{
		call SetMentorLevel 40
		call goZone "The Feerrott" Globe
		wait 20
		call navwrap -1702 -8 816
		wait 30
		oc !c -Zone ${Me.Name}
		wait 10
		OgreBotAPI:ZoneDoorForWho["${Me.Name}","The Temple of Cazic-Thule"]
		call waitfor_Zone "The Temple of Cazic-Thule"
		return TRUE
	}
	return FALSE
}
function goSanctumoftheScaleborn()
{
	;Level 60 Zone
	call CheckZone "Sanctum of the Scaleborn"
	if (!${Return})
	{
		call SetMentorLevel 60
		call goZone "Tenebrous Tangle" Spire
		wait 50
		call navwrap 214 21 -185
		wait 50
		call ZoneIn "Sanctum of the Scaleborn"
		wait 50
		return TRUE
	}
	return FALSE
}
function goTempleofScale()
{
	;Level 65 Zone
	call CheckZone "The Temple of Scale"
	if (!${Return})
	{
		call SetMentorLevel 65
		call goZone "Tenebrous Tangle" Spire
		wait 50
		call navwrap -11 48 -203
		wait 50
		do
		{
			face -11 -203
			call ClickZone 250 250 1250 1250 100 TRUE
			wait 5
			call IsZoning
		}
		while (!${Return} && !${Zone.Name.Equal["The Temple of Scale"]})
		return TRUE
	}
	return FALSE
}
function goCastleMistmoore()
{
	;Level 70 Zone
	call CheckZone "Castle Mistmoore"
	if (!${Return})
	{
		call SetMentorLevel 70
		call goZone "Loping Plains" Spire
		wait 50
		call navwrap 515 210 182
		wait 50
		do
		{
			oc !c -Zone ${Me.Name}
			wait 10
			call IsZoning
		}
		while (!${Return} && !${Zone.Name.Equal["Castle Mistmoore"]})
		call waitfor_Zone "Castle Mistmoore"
		wait 50
		return TRUE
	}
	return FALSE
}
function goKarnorsCastle()
{
	;Level 70 Zone
	call CheckZone "Karnor's Castle"
	if (!${Return})
	{
		call SetMentorLevel 70
		call goZone "Kylong Plains" Globe
		wait 50
		call navwrap 449 65 -388
		wait 50
		oc !c -Zone ${Me.Name}
		call waitfor_Zone "Karnor's Castle"
		wait 50
		return TRUE
	}
	return FALSE
}
function goWaywardManor()
{
	;Level 120 Zone
	call CheckZone "Wayward Manor"
	if (!${Return})
	{
		call goZone "Fordel Midst"
		wait 50
		call navwrap 169 62 -680
		wait 50
		oc !c -Zone ${Me.Name}
		wait 10
		OgreBotAPI:ZoneDoorForWho["${Me.Name}","Fordel Midst: Wayward Manor \[Solo\]"]
		wait 50
		call waitfor_Zone "Wayward Manor"
		return TRUE
	}
	return FALSE
}
function goKraytoc()
{
	call goZone "Great Divide" Globe
	wait 50
	call navwrap -47 -322 424	
}
function goMajDul()
{
	call CheckZone "Maj'Dul"
	if (!${Return})
	{
		call SetMentorLevel 55
		call goZone "The Sinking Sands" Globe
		wait 50
		call navwrap -1446 -223 -379
		wait 20
		call Converse "a nomadic carpet keeper" 1
		wait 20
		OgreBotAPI:Travel["${Me.Name}", "Maj'Dul"]
		call waitfor_Zone "Maj'Dul"
	}
}
function goHoldofRime_TheAscent()
{
	call CheckZone "Hold of Rime: The Ascent"
	if (!${Return})
	{
		call goZone "Great Divide" Globe
		wait 50
		call navwrap 309 -316 1159
		wait 50
		face 0 0
		call ClickZone 250 250 1250 1250 100 TRUE
		call waitfor_Zone "Hold of Rime: The Ascent"
		wait 50
		return TRUE
	}
	return FALSE
}
function goForgottenPools()
{
	call CheckZone "Forgotten Pools"
	if (!${Return})
	{
		call goZone "Great Divide" Globe
		wait 50
		call navwrap 366 -339 1073
		wait 50
		call ClickOn Enter
		call waitfor_Zone "Forgotten Pools"
		wait 50
		return TRUE
	}
	return FALSE
}
function goOssuary()
{
	call goZone "Phantom Sea" Globe
	wait 50
	call navwrap 697 53 771
}
function goPoM()
{
	call goZone "Plane of Magic" Spire
}
function goValorsRoost()
{
	call goPoM
	call navwrap -780 343 1091
}


function goCoV()
{
	call CheckZone "Colisseum of Valor"
	if (!${Return})
	{
		call goZone "Plane of Magic" Spire
		wait 50
		call navwrap -789 345 1120
		do
		{
			oc !c -Zone ${Me.Name}
			wait 10
			call IsZoning
		}
		while (!${Return} && !${Zone.Name.Equal["Colisseum of Valor"]})
		return TRUE
	}
	return FALSE
}
function goFordelMidst()
{
	echo going to Fordel Midst
	if (${Zone.Name.Left[15].Equal["Aurelian Coast"]} && ${OgreBotAPI.KWAble})
		call KWMove 112 68 -616
	
	wait 20
	
	if (${Zone.Name.Left[15].Equal["Aurelian Coast"]} && ${Me.X} < 120 && ${Me.X} > 100 &&  ${Me.Y} < 75 && ${Me.Y} > 45 && ${Me.Z} < -600 && ${Me.Z} > -670)
	{
		echo Already in Fordel Midst
	}
	else
	{
		call goZone "Aurelian Coast"
		wait 50
		call DMove 623 99 -512 3 30 TRUE FALSE 5
		call DMove 643 92 -473 3 30 TRUE FALSE 5
		call 3DNav 591 110 -386
		call 3DNav 399 155 -239
		call 3DNav 219 122 -244
		call 3DNav 156 144 -449
		call GoDown
		call DMove 141 87 -494 3 30 TRUE FALSE
		call DMove 119 85 -525 3 30 TRUE FALSE
		call DMove 126 85 -540 3 30 TRUE FALSE 5
		call DMove 89 73 -595 3 30 TRUE FALSE
		call DMove 112 68 -616 3 30 TRUE FALSE 3
	}	
}
function goTheHole()
{
	call goZone "The Sundered Frontier" Spire
	call navwrap 1894 -373 3452
}
function goLondiar_Inygad(int Timeout)
{
	variable int Counter
	variable float loc0
	if (${Timeout}<1)
		Timeout:Set[600]
	call goZone "Timorous Deep" Globe
	wait 50
	if ${OgreBotAPI.KWAble}
	{
		call KWMove 2792 121 1240
		return ${Return}
	}
	else
	{
		echo need to write regular path for this NPC
		return FALSE
	}
	call MoveCloseTo "Londiar Inygad"
	return TRUE
}
function goDercin_Marrbrand(int Timeout)
{
	call goNPCDercinMarrbrand ${Timeout}
	return ${Return}
}
function goNPCDercinMarrbrand(int Timeout)
{
	variable int Counter
	variable float loc0
	if (${Timeout}<1)
		Timeout:Set[600]
	call goMyrist
	wait 50
	if (!${OgreBotAPI.KWAble})
	{
		if (${Me.Y}<15)
		{
			press F1
			wait 20
			ogre nav "Bottom Lift"
			do
			{
				
				loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
				wait 10
				Counter:Inc
				
				call CheckStuck ${loc0}
				if (${Return})
				{
					press F1
					wait 20
					ogre nav "Bottom Lift"
				}
				call TestArrivalCoord 414 -5 -14
			}
			while (!${Return} || ${Counter}>${Timeout})
			if (${Counter}>${Timeout})
				return FALSE
			else
				Counter:Set[0]
			call DMove 420 -5 -13 3 30 FALSE FALSE 2
			do
			{
				call DMove 418 -5 -15 3 30 FALSE FALSE 2
				call ActivateVerbOn "Lift Switch Main Floor" "use"
				wait 10
			}
			while (${Me.Y}<15 || ${Counter}>${Timeout})
			if (${Counter}>${Timeout})
				return FALSE
			else
				Counter:Set[0]
		}
		if (${Me.Y}<410 && ${Me.Y}>15)
		{
			press F1
			wait 5
			ogre nav "Teleporter to Smiths' Gallery"
			do
			{
				wait 10
				call TestArrivalCoord 389 16 170
			}
			while ((!${Return} && ${Me.Y}>15)|| ${Counter}>${Timeout})
			if (${Counter}>${Timeout})
				return FALSE
			else
				Counter:Set[0]
			if (${Me.Y}<15)
			{
				echo oops I must have gone down again
				call goDercin_Marrbrand ${Timeout}
			}
			
			do
			{
				call ActivateVerbOn "Teleporter to Smiths' Gallery" "Touch"
				wait 100
			}
			while (${Me.Y}<410 || ${Counter}>${Timeout} )
			if (${Counter}>${Timeout})
				return FALSE
			else
				Counter:Set[0]
		}
	}
	else
	{
		call KWMove 649 411 20
		wait 150
	}
	if (${Me.Y}>410)
		call MoveCloseTo "Dercin Marrbrand"
	else 
		call goDercin_Marrbrand ${Timeout}
	return TRUE
}
function goMyrist()
{
	call goZone "Myrist, the Great Library"
}


function goNPCDruzzilRo_PoM()
{
	call goValorsRoost
	call DMove -766 343 1092 3
}
function goNPCEvaniaValSara(bool NoTotem)
{
	call Log "in function goNPCEvaniaValSara(${NoTotem})"
	call goObulusFrontier ${NoTotem}
	wait 50
	call navwrap -117 92 -270
}
function goNPCVarigRo()
{
	call goCoV
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
function goNPCYunZi()
{
	call goZone "Sundered Frontier" Spire
	call navwrap 2299 -200 2500
}	

function RunIC(bool Loop)
{
	call goFordelMidst
	call RunACIC TRUE
	echo I need to wait here for the IC to run !
	
	;call goSanctusSeru
	;call RunSSIC
	;if ${Loop}
	;	call RunIC
}
function RunACIC(bool Loop)
{
	ogre ic
	wait 50
    Obj_FileExplorer:Change_CurrentDirectory["ICEthreayd/Blood_of_Luclin/Solo"]
    Obj_FileExplorer:Scan
    Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Aurelian_Coast_Maidens_Eye_Solo.iss"]
	Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Aurelian_Coast_Sambata_Village_Solo.iss"]
	Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Aurelian_Coast_Reishi_Rumble_Solo.iss"]
	Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Fordel_Midst_The_Listless_Spires_Solo.iss"]
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["loop_list_checkbox",${Loop}]
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",TRUE]
}
function RunSSIC(bool Loop)
{
	ogre ic
	wait 50
    Obj_FileExplorer:Change_CurrentDirectory["ICEthreayd/Blood_of_Luclin/Solo"]
    Obj_FileExplorer:Scan
    Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Sanctus_Seru_Arx_Aeturnus_Solo.iss"]
	Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Sanctus_Seru_Echelon_of_Order_Solo.iss"]
	;Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["The_Venom_of_Ssraeshza_Solo.iss"]
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["loop_list_checkbox",${Loop}]
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",TRUE]
}
function goEPG()
{
	call goMyrist
	call DMove 71 -20 -13 3
	call DMove 134 -5 -11 3
	call DMove 170 -5 -101 3
	call DMove 221 -5 -138 3
	call DMove 217 -5 -158 3
	call DMove 204 -20 -196 3
	call DMove 204 -20 -254 3
	call DMove 249 -20 -256 3
	call DMove 257 -20 -286 3
	wait 20
	call ActivateVerbOn "Teleporter to Elemental Portal Gallery" Touch TRUE
	wait 100
}
function goCDPublicZone(string ZoneName)
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

;get quests script per xpac
function GetCDQuests()
{
	variable string NPCName
	if (${Me.Y}<400 || ${Me.Y}>430)
		call goEPG
	call DMove 751 411 -364 3
	
	switch ${ZoneName}
	{
		default
		{
			call MoveCloseTo "Researcher Tulvina"
			target "Researcher Tulvina"
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			target "Quillion Frain"
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			call MoveCloseTo "Vazgron the Loremonger"
			target "Vazgron the Loremonger"
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			target "a Planar Chronicler Vol. 2"
			call MoveCloseTo "a Planar Chronicler Vol. 2"
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,5]:LeftClick
			
			target "a Planar Chronicler Vol. 2"
			call MoveCloseTo "a Planar Chronicler Vol. 2"
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
		}
		break
	}
}
function getBoLTSQuests(string version)
{
	variable string NPCName
	NPCName:Set["Daini the Wright"]
	call goDainitheWright
	wait 50
	call Converse "${NPCName}" 1
}	

function getBoLQuests()
{
	variable string NPCName
	variable int MissingQuest

	call goRecusoTor TRUE
	
	call 3DNav -644 47 353
	call navwrap -689 45 362 3
	call DMove -638 58 258 3
	call DMove -580 60 261 3
	call DMove -542 62 261 3
	call DMove -545 61 285 3
	call GoDown
	echo Getting all Solo Quests
	NPCName:Set["Sage Ayzuku"]
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 20
	NPCName:Set["Sage Ayzuku"]
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 20
	NPCName:Set["Master Enzelan"]
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 20
	NPCName:Set["Master Enzelan"]
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 20
	NPCName:Set["Apprentice Tansya"]
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	NPCName:Set["Researcher Felquist"]
	call MoveCloseTo "${NPCName}"
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 20
	
	call DMove -532 62 261 3 30 FALSE FALSE 5
	call DMove -580 60 260 3 30 FALSE TRUE 5
	call DMove -620 58 256 3 30
}


;Need to rationalize following functions
/*
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
function goBoT(string ZoneName, string version)
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
						call EnterZone ${Math.Calc64[7+${offset}]}
						break
					}
					case Heroic
					{
						call EnterZone ${Math.Calc64[6+${offset}]}
						break
					}
					case Expert
					{
						call EnterZone ${Math.Calc64[5+${offset}]}
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
						call EnterZone ${Math.Calc64[10+${offset}]}
						break
					}
					case Heroic
					{
						call EnterZone ${Math.Calc64[9+${offset}]}
						break
					}
					case Expert
					{
						call EnterZone ${Math.Calc64[8+${offset}]}
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
		wait 600
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
function goPoD(string ZoneName, string version)
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
						call EnterZone 7
						break
					}
					case Heroic
					{
						call EnterZone 6
						break
					}
					case Expert
					{
						call EnterZone 5
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
						call EnterZone 9
						break
					}
					case Heroic
					{
						call EnterZone 8
						break
					}
					case Expert
					{
						call EnterZone 7
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
function goPoI(string ZoneName, string version)
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
						call EnterZone 6
						break
					}
					case Heroic
					{
						call EnterZone 5
						break
					}
					case Expert
					{
						call EnterZone 4
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
						call EnterZone 3
						break
					}
					case Heroic
					{
						call EnterZone 2
						break
					}
					case Expert
					{
						call EnterZone 1
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
function goSoH(string ZoneName, string version)
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
function goSRT(string ZoneName, string version)
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
						
						call EnterZone 4
						break
					}
					case Heroic
					{
						call EnterZone 3
						break
					}
					case Expert
					{
						call EnterZone 2
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
						call EnterZone 8
						break
					}
					case Heroic
					{
						call EnterZone 7
						break
					}
					case Expert
					{
						call EnterZone 6
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
function goThrone()
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

*/
