#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool FestrusLord

function main(int stepstart, int stepstop, int setspeed)
{

	variable int laststep=7
	
	oc !c -letsgo ${Me.Name}
	if (${setspeed}==0)
	{
		if (${Me.Archetype.Equal["fighter"]})
		{
			speed:Set[3]
			FightDistance:Set[15]
		}
		else
			speed:Set[1]
		{
			FightDistance:Set[30]
		}
	}
	else
		speed:Set[${setspeed}]
		
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Plane of Disease: the Source [Solo]"
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_moveinfront","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_setup_moveintomeleerangemaxdistance",25]

	if (${stepstart}==0)
	{
		if (${Me.Loc.Y}<-400)
		{
			echo I am in Crypt of Decay, starting from there
			stepstart:Set[5]
			call IsPresent "Darwol Adan" 1000
			if  (!${Return})
				stepstart:Set[7]
		}
	}
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["Blighthorn"]
	eq2execute merc resume
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",30]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
  
	Ob_AutoTarget:AddActor["festrus",0,TRUE,FALSE]
	
	call DMove -415 28 239 ${speed}
	call DMove -392 28 273 ${speed}
	call DMove -202 47 254 ${speed}
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	call DMove -195 32 294 ${speed}
	call DMove -202 47 254 ${speed}
	
	
	do
	{
		wait 10
		call Hunt festrus 100 1 TRUE
		call DMove -392 28 273 3
		call Hunt festrus 100 1 TRUE
		call DMove -202 47 254 3
		call IsPresent "${Named}"
		echo !${Return} && !${FestrusLord}
	}
	while (!${Return} && !${FestrusLord})
	echo must kill "${Named}"
	
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	OgreBotAPI:AcceptReward["${Me.Name}"]
}	

function step001()
{
	eq2execute merc resume

	Ob_AutoTarget:Clear
	Ob_AutoTarget:AddActor["pusling",0,TRUE,FALSE]
	
	call DMove -202 47 254 ${speed}
	call DMove -183 23 340 ${speed}
	call DMove -168 21 390 ${speed}
	call DMove -184 23 439 ${speed}
	call DMove -207 21 443 ${speed}
	call DMove -233	20 448 ${speed}
	call DMove -255	22 437 ${speed}
	call DMove -263	21 451 ${speed}
	call DMove -325	21 482 3
	call DMove -333	22 488 ${speed}
	call DMove -312	21 518 ${speed}
	call DMove -269	21 519 ${speed}
	call DMove -254	20 539 ${speed}
	call DMove -197	22 541 3
	call DMove -56 21 549 ${speed}
	call DMove -6 21 545 3
	call DMove 49 21 550 3
	call DMove 98 21 517 3
	call DMove 74 22 468 ${speed}
	call DMove 26 24 408 ${speed}
	call DMove -3 20 396 ${speed}
	call DMove -34 22 373 3
	call DMove -58 21 360 ${speed}
	call DMove -56 26 314 ${speed}
	call DMove -198 46 261 3
}	
	
function step002()
{
	variable string Named
	Named:Set["Rancine"]
	
	do
	{
		call IsPresent "${Named}" 500
		if (!${Return})
			call step001
		call IsPresent "${Named}" 500	
	}
	while (!${Return})
	Ob_AutoTarget:Clear
	Ob_AutoTarget:AddActor["lesion of doom",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	call DMove -159 22 376 3
	call DMove -108 21 445 3
	
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
}

function step003()
{
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -82 22 482 3
	call DMove -21 21 511 3
	call DMove 3 21 548 3
	call DMove 29 21 588 2
	call DMove 29 22 612 2
	call DMove 44 22 622 2
	call DMove 60 23 646 2
	call DMove 68 22 669 2
	call DMove 104 38 706 3
	call DMove 106 46 721 3
	call DMove 123 47 732 3
	do
	{
		call CountItem "Grotesque Visage"
		OgreBotAPI:Special["${Me.Name}"]
		wait 20
	}
	while (${Return}==0)
	
	Me.Inventory["Grotesque Visage"]:Use
}


function step004()
{
	variable string Named
	Named:Set["Gryme"]
	eq2execute merc resume
		
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	
	call DMove 97 33 706 3
	call DMove 81 21 682 2
	call DMove 68 22 669 2
	call DMove 55 22 637 2
	call DMove 44 22 622 2
	call DMove 17 22 606 2
	call DMove 14 21 533 3
	call DMove 6 21 461 3
	call DMove 6 21 387 3
	call DMove -1 28 304 3
	call DMove -125 29 283 3
	call DMove -107 87 93 3
	call DMove -61 95 42 3
	call DMove -55 94 -30 ${speed} ${FightDistance}
	
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call DMove -57 99 -64 ${speed} ${FightDistance}
	OgreBotAPI:Special["${Me.Name}"]
	
}

function step005()
{
	variable string Named
	Named:Set["Darwol Adan"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 366 -474 -89 ${speed} ${FightDistance}
	call DMove 331 -474 -89 ${speed} ${FightDistance}
	call DMove 286 -474 -91 ${speed} ${FightDistance}
	call DMove 226 -475 -90 ${speed} ${FightDistance}
	call DMove 222 -474 -142 ${speed} ${FightDistance}
	call DMove 222 -487 -237 ${speed} ${FightDistance}
	call DMove 223 -492 -293 ${speed} ${FightDistance}
	call DMove 173 -494 -298 ${speed} ${FightDistance}
	call DMove 123 -502 -299 ${speed} ${FightDistance}
	call DMove 73 -510 -299 ${speed} ${FightDistance}
	call DMove -4 -517 -305 ${speed} ${FightDistance}
	
	call StopHunt
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	
	call DMove -28 -517 -244 ${speed} ${FightDistance}
	
	do
	{
		face ${Actor["${Named}"].X} ${Actor["${Named}"].Z}
		if (!${Actor["${Named}"].CheckCollision})
		{
			echo must kill "${Named}"
			call DMove ${Actor["${Named}"].X}  ${Actor["${Named}"].Y} ${Actor["${Named}"].Z} 3 30 TRUE
		}
		wait 10
	}
	while (!${Me.InCombatMode})
	oc !c -CampSpot ${Me.Name}
	do
	{
		wait 10
		ExecuteQueued
		call IsPresent "${Named}" 80
	}
	while (${Return})
	oc !c -letsgo ${Me.Name}
	call PKey ZOOMOUT 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step006()
{
	variable string Named
	variable string Nest
	variable int Counter=0
	
	Named:Set["Wavadozzik Adan"]
	Nest:Set["an arachnae nest"]
	eq2execute merc resume
	call StopHunt
	
	OgreBotAPI:AutoTarget_SetScanHeight["${Me.Name}",40]
	Ob_AutoTarget:AddActor["${Nest}",0,FALSE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_meleeattack","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_rangedattack","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	target ${Me.Name}
	call PKey "Page Up" 5
	call PKey ZOOMOUT 20	
	call DMove -84 -520 163 3 30 TRUE
	target "${Named}"
	wait 20
	do
	{	
		target "${Named}"
		wait 5
	}
	while (!${Me.InCombatMode})
	
	Counter:Set[0]
	do
	{
		call FindLoS "${Nest}" STRAFELEFT 10
		Counter:Inc
		wait 20
		call IsPresent "${Nest}" 40
	}
	while (${Return} && ${Counter}<6)
	
	call DMove -58 -521 113 3 30 TRUE
	Counter:Set[0]
	do
	{
		call FindLoS "${Nest}" STRAFELEFT 10
		Counter:Inc
		wait 20
		call IsPresent "${Nest}" 40
	}
	while (${Return} && ${Counter}<6)
	
	call DMove -80 -521 162 3 30 TRUE
	Counter:Set[0]
	do
	{
		call FindLoS "${Nest}" STRAFELEFT 10
		Counter:Inc
		wait 20
		call IsPresent "${Nest}" 40
	}
	while (${Return} && ${Counter}<6)

	call DMove -55 -521 110 3 30 TRUE
	Counter:Set[0]
	do
	{
		call FindLoS "${Nest}" STRAFELEFT 10
		Counter:Inc
		wait 20
		call IsPresent "${Nest}" 40
	}
	while (${Return} && ${Counter}<6)
		
	call PKey CENTER 5
	call PKey "Page Down" 3
	Ob_AutoTarget:Clear
	Ob_AutoTarget:AddActor["${Named}",0,FALSE,FALSE]
	echo must kill "${Named}"
	call DMove ${Actor["${Named}"].X} ${Actor["${Named}"].Y} ${Actor["${Named}"].Z} 3 30 TRUE
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	eq2execute summon
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -2 -517 122 ${speed} ${FightDistance}
	call DMove 222 -492 125 ${speed} ${FightDistance}
	call DMove 220 -475 -89 ${speed} ${FightDistance}
}
	
function step007()
{
	variable string Named
	
	Named:Set["Bhaly Adan"]
	eq2execute merc resume
	
	call DMove 124 -482 -89 ${speed} ${FightDistance}
	call PKey ZOOMOUT 20	
	call DMove -5 -473 -89 3 30 TRUE
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	Ob_AutoTarget:AddActor["Primordial",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	target "${Named}"
	wait 20
	do
	{	
		target "${Named}"
		wait 5
	}
	while (!${Me.InCombatMode})
	call AlterGenes
	echo must kill "${Named}"
	do
	{
		ExecuteQueued
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	eq2execute summon
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	call DMove 452 -474 -90 3 30
	OgreBotAPI:Special["${Me.Name}"]
	wait 20
	call DMove -82 65 164 3 30
	call DMove -406 49 138 3 30
	call DMove -443	28 225 3 30
	call DMove -462 28 236 3 30
	OgreBotAPI:Special["${Me.Name}"]
}

function FightDarwol()
{
	variable string Named
	Named:Set["Darwol Adan"]	
	oc !c -joustin ${Me.Name}
	Ob_AutoTarget:Clear
	target ${Me.Name}
	call PKey CENTER 1
	call PKey ZOOMIN 20
	call GetObject "Pus Barrel" "Pick up"
	face ${Actor["${Named}"].X} ${Actor["${Named}"].Z}
	oc !c -joustout ${Me.Name}
	wait 10
	face ${Actor["${Named}"].X} ${Actor["${Named}"].Z}
	wait 10
	MouseTo 960,700
	face ${Actor["${Named}"].X} ${Actor["${Named}"].Z}
	wait 20
	
	press Mouse1
	wait 20
	call IsPresent "barrel of volatile pus"
	Ob_AutoTarget:AddActor["Pus Barrel",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	if (!${Return})
	{
		call PKey MOVEFORWARD 20
		QueueCommand call FightDarwol
	}
}

function AlterGenes()
{
	variable string Named
	Named:Set["Bhaly Adan"]
	Ob_AutoTarget:Clear
	target ${Me.Name}
	call DMove 71 -483 -92 3 30 TRUE
	call DMove -5 -483 -29 3 30 TRUE
	{
		call ActivateVerb "Infected Microbe" -5 -483 -29 "Alter genes" TRUE
		wait 10
		call IsPresent "Infected Microbe" 20
	} 
	
	call DMove -84 -483 -90 3 30 TRUE
	{
		call ActivateVerb "Infected Microbe" -84 -483 -90 "Alter genes" TRUE
		wait 10
		call IsPresent "Infected Microbe" 20
	}
	call DMove -10 -483 -147 3 30 TRUE
	{
		call ActivateVerb "Infected Microbe" -10 -483 -147 "Alter genes" TRUE
		wait 10
		call IsPresent "Infected Microbe" 20
	}
	call DMove 71 -483 -92 3 30 TRUE
	{
		call ActivateVerb "Infected Microbe" 71 -483 -92 "Alter genes" TRUE
		wait 10
		call IsPresent "Infected Microbe" 20
	} 
	call DMove -6 -473 -90 3 30 TRUE
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
}

atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	;echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
	if (${Message.Find["prepares to devour"]} > 0)
	{
		echo Catch Event Affliction in HandleEvents
		QueueCommand call FightDarwol
	}
	if (${Message.Find["microbes have mutated"]} > 0)
	{
		echo Catch Event Microbes in HandleEvents
		QueueCommand call AlterGenes
	}
}
 
atom HandleAllEvents(string Message)
 {
	;echo Catch Event ${Message}
    if (${Message.Find["lord of the festrus returns"]} > 0)
	{
		FestrusLord:Set[TRUE]
		echo Lord of the Festrus detected
	}
	if (${Message.Find["has killed you"]} > 0 || ${Message.Find["you have died"]} > 0)
	{
		echo "I am dead"
		if ${Script["livedierepeat"](exists)}
			endscript livedierepeat
		run EQ2Ethreayd/livedierepeat
	}
 }