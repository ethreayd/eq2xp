#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

variable(script) int speed
variable(script) int FightDistance
variable(script) bool Fight
variable(script) int CounterM
variable(script) index:string CurseOrder
variable(script) int IndexCounter=1
variable(script) bool Curing
variable(script) bool WaitCured
variable(script) bool Toggle
variable(script) bool NoShinyGlobal
variable(script) bool ExpertZone

function main(int stepstart, int stepstop, int setspeed, bool NoShiny, bool ForceNamed)
{
	variable int laststep=9
	variable int count
	oc !c -UplinkOptionChange All checkbox_settings_disablecaststack FALSE
	oc !c -resume
	oc !c -letsgo
	if (${Script["LoopHeroic"](exists)})
	{
		if (!${Script["livedierepeat"](exists)})
			run EQ2Ethreayd/livedierepeat ${NoShiny} TRUE
	}
	else
	{
		if (!${Script["deathwatch"](exists)})
			run EQ2Ethreayd/deathwatch
	}
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	if (!${Script["ToonAssistant"](exists)})
		relay all run EQ2Ethreayd/ToonAssistant
	
	if (${setspeed}==0)
		speed:Set[3]
	else
		speed:Set[${setspeed}]
	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 100 ${speed} 
	NoShinyGlobal:Set[${NoShiny}]
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	if (${stepstart}==0 && !${ForceNamed})
		stepstart:Set[3]
	if (${stepstart}==0 && ${ForceNamed} && ${Actor[Felkruk].IsAggro})
		stepstart:Set[2]
	echo FYI IndexCounter is at ${IndexCounter}
	
	echo zone is ${Zone.Name}
	call isExpert "${Zone.Name}"
	ExpertZone:Set[${Return}]
	call waitfor_Zone "Plane of Disease: Outbreak" TRUE
	ISXEQ2:EnableAfflictionEvents
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_onGroupMemberAfflicted]:AttachAtom[HandleCurses]
	Event[EQ2_onMeAfflicted]:AttachAtom[HandleMyCurses]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	
	oc !c -UplinkOptionChange All checkbox_settings_loot FALSE
	oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_loot TRUE
	if (${ExpertZone})
		oc !c -UplinkOptionChange All checkbox_settings_forcenamedcatab TRUE
	echo setting speed at ${speed}/3 and Fight Distance at ${FightDistance}m
	oc !c -OgreFollow All ${Me.Name}

	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	call StopHunt
	wait 20
	call DMove 545 83 43 3
	call DMove 568 82 27 3
	call StopHunt
	call Converse "Velya" 9
	call DMove 562 83 39 3
	call DMove 532 82 35 3
	call StopHunt
}

function step001()
{
	variable string Named
	Named:Set["Springview Healer"]
	
	call ActivateVerb "crypt_1" 548 83 61 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_2" 569 83 55 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_3" 571 83 37 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_4" 564 83 34 "Reach for the crypt" TRUE TRUE
	call DMove 564 83 37 1
	call ActivateVerb "crypt_5" 552 83 34 "Reach for the crypt" TRUE TRUE
	call DMove 535 83 40 3
	call ActivateVerb "crypt_11" 535 76 7 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_16" 524 77 6 "Reach for the crypt" TRUE TRUE
	call DMove 530 75 1 3
	call ActivateVerb "crypt_12" 538 73 -11 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_17" 524 73 -13 "Reach for the crypt" TRUE TRUE
	call DMove 530 70 -24 3
	call ActivateVerb "crypt_13" 539 70 -30 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_18" 521 70 -30 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_14" 537 68 -46 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_15" 530 68 -49 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_20" 518 68 -47 "Reach for the crypt" TRUE TRUE
		
	call StopHunt
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	oc !c -acceptreward
	eq2execute summon
	oc !c -acceptreward
	Call StopHunt
}	

function step002()
{
	variable string Named
	Named:Set["Felkruk"]
	
	call StopHunt
	oc !c -UplinkOptionChange All checkbox_settings_disablecaststack_cure TRUE
	call DMove 534 68 -43 3 30 TRUE 
	relay all run EQ2Ethreayd/Outbreak_C1

	call TanknSpank "${Named}" 50 TRUE
	
	oc !c -acceptreward
	eq2execute summon
	wait 50
	oc !c -acceptreward
	call Loot

	relay all Me.Inventory["Springview Healer Mask"]:Use
	wait 20
	oc !c -acceptreward
	oc !c -UplinkOptionChange All checkbox_settings_disablecaststack_cure FALSE
	
}

function step003()
{
	variable string Named
	Named:Set["Primordial Malice"]
	relay all Me.Inventory["Springview Healer Mask"]:Use
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	 
	call DMove 530 68 -64 3
	call DMove 437 63 -235 3
	call DMove 366 65 -263 3 
	call DMove 328 63 -330 3
	call DMove 293 71 -323 3
}


function step004()
{
	variable string Named
	Named:Set["The Carrion"]
		
	call StopHunt
	call IsPresent "The Carrion" 1000
	if (${Return})
	{
		call DMove 246 63 -353 3
		call DMove 162 72 -355 3
		call DMove 142 74 -341 3
		oc !c -cs-jo-ji All Casters
		Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
		Ob_AutoTarget:AddActor["Malarian Larva",0,TRUE,FALSE]
	
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		call DMove 131 74 -357 ${speed} ${FightDistance}
	
		echo must kill "${Named}"
		do
		{
			wait 10
			call IsPresent "Malarian Larva"
		}
		while (${Return})
		eq2execute summon
		wait 50
		oc !c -AcceptReward
		oc !c -UplinkOptionChange All checkbox_settings_loot TRUE
		wait 50
		oc !c -OgreFollow All ${Me.Name}
		oc !c -ofol---
		oc !c -ofol---
		oc !c -ofol---
		call WaitforGroupDistance 10
		oc !c -UplinkOptionChange All checkbox_settings_loot FALSE
		oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_loot TRUE
		wait 50
		call Loot

		relay all Me.Inventory["Hirudin Extract"]:Use
		wait 20
		oc !c -AcceptReward
		oc !c -OgreFollow All ${Me.Name}
		call DMove 137 74 -344 3 ${FightDistance}
		call DMove 296 71 -323 3 ${FightDistance} TRUE
	}	
}

function step005()
{
	variable string Named
	Named:Set["pusling leaker"]
	call StopHunt
	call IsPresent "High Dragoon V'Aliar" 5000
	if (!${Return})
	{
		Ob_AutoTarget:AddActor["${Named}",0,FALSE,FALSE]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
   	
		call ClimbingFMountain
		CounterM:Set[0]
		do
		{
			wait 10
			ExecuteQueued
			CounterM:Inc
		}
		while (${Me.Loc.Z}<0 && ${CounterM}<60)
		if (${Me.Loc.Z}<0)
			call step005
		eq2execute summon
		wait 100
		oc !c -AcceptReward
	}
}
	
function step006()
{	
	variable string Named
		
	call IsPresent "High Dragoon V'Aliar" 5000
	if (!${Return})
	{
		Named:Set["The Flesh Eater"]
		call StopHunt
		oc !c -UplinkOptionChange All checkbox_settings_forcenamedcatab TRUE
		relay all Me.Inventory["Hirudin Extract"]:Use
		wait 20
		oc !c -ChangeCastStackListBoxItemByTag ALL absorbmagic TRUE
		oc !c -ChangeCastStackListBoxItemByTag ALL autorez TRUE
		Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",50]
		call DMove 224 396 43 2 30 TRUE
		wait 20
		
		relay all end ToonAssistant
		oc !c -cs-jo-ji All Casters
		wait 10
		call DMove 209 392 42 2 30 TRUE
		wait 20
		oc !c -CampSpot ${Me.Name} 1 200
		wait 10
		echo must kill "${Named}"
		oc !c -joustin
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
		
		call DMove 182 393 19 3 30 TRUE
		call DMove 190 394 -3 3 30 TRUE
		oc !c -joustout
		do
		{
			wait 10
			call IsPresent "${Named}"
		}
		while (${Return})
		if (!${Script["ToonAssistant"](exists)})
			relay all run EQ2Ethreayd/ToonAssistant
		oc !c -ChangeCastStackListBoxItemByTag ALL autorez FALSE
		oc !c -ChangeCastStackListBoxItemByTag ALL absorbmagic FALSE
		oc !c -letsgo
		call StopHunt
		eq2execute summon
		wait 30
		oc !c -acceptreward
		eq2execute summon
		wait 20
		oc !c -acceptreward
		wait 100
		eq2execute summon
		call CheckCombat
		call Loot
		oc !c -Come2Me ${Me.Name} All 3
		call DMove 291 360 -41 3 30 TRUE
		oc !c -Come2Me ${Me.Name} All 3
		call DMove 276 333 -102 3 30 TRUE
		oc !c -Come2Me ${Me.Name} All 3
		wait 100
		call CheckCombat
		call DMove 281 377 -17 3
		call DMove 237 392 10 3
		eq2execute summon
		call DMove 217 394 38 3
		eq2execute summon
		call Loot
		call DMove 291 360 -41 3
		call DMove 276 333 -102 3
		call DMove 131 252 -131 3
		eq2execute summon
		call DMove 107 226 -190 3 
		call DMove 165 181 -238 3 
		call DMove 271 118 -205 3 
		call DMove 293 102 -223 3
	}
}
	
function step007()
{	
	variable string Named
	Named:Set["High Dragoon V'Aliar"]
	call StopHunt
	
	call DMove 304 71 -330 3 
	call DMove 130 73 -354 3 ${FightDistance}
	call DMove 65 75 -307 3 ${FightDistance}
	
	Ob_AutoTarget:AddActor["squire",5,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
   		
	call DMove 35 94 -228 ${speed} ${FightDistance}
	call DMove 12 97 -191 ${speed} ${FightDistance} TRUE
	oc !c -Come2Me ${Me.Name} All 3
	wait 50
	oc !c -CampSpot
	oc !c -joustout
	call TanknSpank "${Named}"
	
	oc !c -letsgo
	eq2execute summon
	wait 50
	oc !c -acceptreward
	call Loot

	relay all Me.Inventory["Damaged Rune of Symbiosis"]:Use
	wait 20
	oc !c -acceptreward
}	
	
function step008()
{	
	variable string Named
	Named:Set["Rallius Rattican"]
	call StopHunt
	relay all OgreBotAPI:CastAbility["All","Singular Focus"]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	call DMove -49 126 -223 3 30 TRUE TRUE
	wait 20
	oc !c -CampSpot
	oc !c -joustout
	relay all end ToonAssistant
	if (${Me.Loc.Y}<170)
	{
		eq2execute gsay Set up for ${Named}
		eq2execute gsay Set up for
	}
	do
	{
		wait 150
		call IsPresent "${Named}"
	}
	while (${Return})
	relay all OgreBotAPI:CancelMaintained["All","Singular Focus"]
	oc !c -letsgo
	wait 100
	call CheckCombat
	eq2execute summon
	call Loot
	wait 50
	oc !c -acceptreward
}
function step009()
{
	if (${Me.Loc.Y}<170)
	{
		
		call DMove -176 129 -270 3
		wait 20
		do
		{
			if (!${Zone.Name.Equal["Coliseum of Valor"]})
			{
				call MoveCloseTo "zone_to_valor"
				oc !c -Zone	
			}
			wait 200
		}
		while (!${Zone.Name.Equal["Coliseum of Valor"]})
		
	}
	else
	{
		echo "Instance is bugged - Exiting"
		target ${Me.Name}
		ogre navtest Entrance
		wait 600
		do
		{
			oc !c -Zone
			wait 100
		}
		while (${Zone.Name.Equal["Plane of Disease: Outbreak [Expert]"]})
	}
}
function ClimbingFMountain()
{
	CounterM:Set[0]
	wait 300
	oc !c -Revive All 0
	wait 300
	relay all ogre navtest node1
	wait 200
	relay all ogre navtest node1
	if (!${Fight})
		call DMove 308 97 -243 3 ${FightDistance} FALSE TRUE
	if (!${Fight})
		call DMove 276 113 -217 3 ${FightDistance} FALSE TRUE
	if (!${Fight})
		call DMove 196 159 -219 3 ${FightDistance} FALSE TRUE
	if (!${Fight})
		call DMove 147 188 -235 3 ${FightDistance} FALSE TRUE
	if (!${Fight})
		call DMove 113 218 -199 3 ${FightDistance} FALSE TRUE
	if (!${Fight})
		call DMove 120 246 -141 3 ${FightDistance} FALSE TRUE
	if (!${Fight})
		call DMove 259 325 -102 3 ${FightDistance} FALSE TRUE
	if (!${Fight})
		call DMove 283 338 -84 3 ${FightDistance} FALSE TRUE
	if (!${Fight})
		call DMove 285 371 -24 3 ${FightDistance} FALSE TRUE
	if (!${Fight})
		call DMove 250 392 4 3 ${FightDistance} FALSE TRUE
	if (!${Fight})
		call DMove 239 396 22 3 ${FightDistance} TRUE TRUE
		
	if (!${Fight})
		OgreBotAPI:NoTarget[${Me.Name}]
}
function CureAll()
{
	variable int i
	variable string Curer
	echo launching CureAll (in order) function with IndexCounter at ${IndexCounter}
	for ( i:Set[0] ; ${i} < ${Me.GroupCount} ; i:Inc )
	{
		call get_Archetype Me.Group[${i}].Class}
		if (${Return.Equal["priest"]})
		{
			Curer:Set[${Me.Group[${i}].Name}]
			echo ${Me.Group[${i}].Name} has been selected as Curer
		}
	}
	oc !c -UplinkOptionChange ${Curer} checkbox_settings_disablecaststack TRUE
	for ( i:Set[1] ; ${i} < ${IndexCounter} ; i:Inc )
	{
		WaitCured:Set[TRUE]
		echo curing ${CurseOrder[${i}]} (${i})
		eq2execute gsay need cure for ${CurseOrder[${i}]} (${i})
		oc !c -CastAbilityOnPlayer ${Curer} "cure curse" ${CurseOrder[${i}]}
		echo ${Curer} cure curse on ${CurseOrder[${i}]} now !
		do
		{
			
			wait 5
		}
		while (${WaitCured})
	}
	oc !c -UplinkOptionChange ${Curer} checkbox_settings_disablecaststack FALSE
	Curing:Set[FALSE]
}
function OrderedCures(string ActorName)
{
	variable int i
	variable int Found=0
	echo in OrderedCures function
	if (${IndexCounter}<2)
	{
		CurseOrder:Insert[${ActorName}]
		echo adding ${ActorName} to chain
		IndexCounter:Inc
		echo FYI IndexCounter is at ${IndexCounter}
	}
	else
	{
		if (${IndexCounter}<7)
		{
			Found:Set[0]
			for ( i:Set[1] ; ${i} < ${IndexCounter} ; i:Inc )
			{
				if (${CurseOrder[${i}].Equal["${ActorName}"]})
					Found:Inc
			}
			if (${Found}<1)
			{
				CurseOrder:Insert[${ActorName}]
				echo adding ${ActorName} to chain
				IndexCounter:Inc
			}
		}
	}
	QueueCommand call CureAll
	echo CureAll Queued to stack
}
atom HandleCurses(int ActorID, int TraumaCounter, int ArcaneCounter, int NoxiousCounter, int ElementalCounter, int CursedCounter)
{
	echo ${ActorID} ${TraumaCounter} ${ArcaneCounter} ${NoxiousCounter} ${ElementalCounter} ${CursedCounter}
	if (${CursedCounter}>0 && !${Curing})
		eq2execute gsay ! ${Actor[${ActorID}].Name} check detriment now !
	if (${CursedCounter}<0)
		WaitCured:Set[FALSE]
}	
atom HandleMyCurses(int TraumaCounter, int ArcaneCounter, int NoxiousCounter, int ElementalCounter, int CursedCounter)
{
	echo ${Me.ID} ${TraumaCounter} ${ArcaneCounter} ${NoxiousCounter} ${ElementalCounter} ${CursedCounter}
	if (${CursedCounter}>0 && !${Curing})
		eq2execute gsay ! ${Me.Name} check detriment now !
	if (${CursedCounter}<0)
		WaitCured:Set[FALSE]
}	
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	;echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
    if (${Message.Find["begins to overheat"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -40 0 0
	}
	if (${Message.Find["begins to overheat"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -40 0 0
	}
	if (${Message.Find["eathMate!!!"]} > 0)
	{
		echo group seems dead - restarting zone
		do
		{
			if (${Script["RestartZone"](exists)})
				endscript RestartZone
		}
		while (${Script["RestartZone"](exists)})
		
		run EQ2Ethreayd/RestartZone 0 0 ${speed} ${NoShinyGlobal}
	}
	if (${Message.Find["t see target"]} > 0 || ${Message.Find["oo far away"]} > 0)
	{
		 oc !c -Come2Me ${Me.Name} ${Speaker} 3
	}
	if (${Message.Find["eed ordered cure"]} > 0)
	{
		Curing:Set[TRUE]
		call OrderedCures ${Speaker}
		echo FYI IndexCounter is at ${IndexCounter} and ${Speaker} is requesting a cure
	}
}

atom HandleAllEvents(string Message)
{
	;echo Catch Event ${Message}
	if (${Message.Find["stumbled into a giant latcher"]} > 0)
	{
		Fight:Set[TRUE]
		CounterM:Set[0]
		target ${Me.Name}
		press -release MOVEFORWARD
		relay all ogre navtest hide1
		press -release MOVEFORWARD
		eq2execute merc backoff
	}
	if (${Message.Find["uslings leak out from the giant"]} > 0)
	{
		target "pusling leaker"
		eq2execute merc backoff

	}
	if (${Message.Find["latches onto you"]} > 0)
	{
		target "pusling leaker"
		eq2execute merc backoff

	}
	if (${Message.Find["giant latcher recedes back into"]} > 0)
	{
		target ${Me.Name}
		CounterM:Set[0]
		press -release MOVEFORWARD
		relay all ogre navtest node1
		press -release MOVEFORWARD
		Fight:Set[FALSE]
		QueueCommand call ClimbingFMountain
	}
	if (${Message.Find["power is even more potent"]} > 0)
	{
		if (${Toggle})
			oc !c -CS_Set_ChangeCampSpotBy All 0 0 -40
		else
			oc !c -CS_Set_ChangeCampSpotBy All 0 0 40
		Toggle:Set[(!${Toggle})]
	}
}