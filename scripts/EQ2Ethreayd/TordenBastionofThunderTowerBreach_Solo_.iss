#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool InRing

function main(int stepstart, int stepstop, int setspeed)
{

	variable int laststep=4
	
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
	call waitfor_Zone "Torden, Bastion of Thunder: Tower Breach [Solo]"
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_moveinfront","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkmana","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkmana",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_setup_moveintomeleerangemaxdistance",25]
	

	if (${stepstart}==0)
	{
		;if (${Me.Loc.Y}<-400)
		;{
		;	echo I am in Crypt of Decay, starting from there
		;	stepstart:Set[5]
		;	call IsPresent "Darwol Adan" 1000
		;	if  (!${Return})
		;		stepstart:Set[7]
		;}
	}
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["Gatekeeper Karatil"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	Ob_AutoTarget:AddActor["Primordial Malice",0,TRUE,FALSE]
	
	call DMove -58 -16 -21 3
	call Converse "Klodsag" 10 TRUE
	call DMove -44 -16 -56 3
	call DMove -54 -20 -99 3
	call DMove -1 -20 -120 3
	call DMove -1 -4 -172 3
	call DMove -1 5 -214 3
	call DMove 1 12 -346 3
	call DMove 3 10 -458 3
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove 0 10 -502 3
	wait 100
	echo must kill "${Named}"
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
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
	call DMove 14 11 -515 3
	call DMove 14 12 -523 3
	call DMove 14 11 -537 3
	call DMove 50 10 -637 3
}	

function step001()
{
	variable string Named
	Named:Set["Inquisitor Barol"]
	eq2execute merc resume

	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]

	call DMove 231 11 -637 3
	call DMove 538 -17 -635 3
	call DMove 529 -14 -633 1
	call DMove 571 -17 -575 1
	call DMove 593 -17 -554 1
	call DMove 620 -17 -536 1
	call DMove 648 -17 -528 1
	call DMove 713 -17 -550 1
	call DMove 759 -17 -569 1
	call DMove 772 -17 -647 1
	call DMove 760 -17 -689 1
	call DMove 736 -17 -723 1
	
	call DMove 704 3 -748 3
	call DMove 625 37 -748 3
	call DMove 593 38 -720 3
	
	wait 100
	echo must kill "${Named}"
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
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
}	
	
function step002()
{
	variable string Named
	Named:Set["Auliffe Chaoswind"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	Ob_AutoTarget:Clear
	
	call DMove 574 38 -712 3
	call DMove 540 56 -673 3
	call DMove 531 73 -634 3
	call DMove 537 86 -587 3
	call DMove 562 90 -556 3
	call DMove 600 90 -516 3
	call DMove 647 114 -492 3
	call DMove 719 144 -520 3
	
	call DMove 769 145 -564 1
	
	call DMove 794 169 -612 3
	call DMove 789 193 -668 3
	call DMove 767 198 -690 3
	call DMove 725 198 -717 1
	wait 100
	if (${Me.Loc.X}<800)
	do
	{
		call DMove 726 198 -719 1
		press MOVEFORWARD
		wait 50
	}
	while (${Me.Loc.X}<800)
	call DMove 783 341 -751 3
	call DMove 726 311 -692 3
	call DMove 657 309 -635 3
	oc !c -CampSpot ${Me.Name}
	oc !c -joustout ${Me.Name}
	InRing:Set[TRUE]
	echo must kill "${Named}"
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	
	oc !c -letsgo ${Me.Name} 
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
	
	call DMove 721 310 -688 3
	call DMove 778 341 -746 3
	call DMove 853 341 -821 3
	wait 50
	if (!${Me.Loc.X}<800)
	do
	{
		
		if (!${Me.Loc.X}<800)
		{
			call DMove 845 341 -809 1
			wait 50
		}
		if (!${Me.Loc.X}<800)
		{
			call DMove 858 341 -825 1
			wait 50
		}
		face 853 -821
		if (!${Me.Loc.X}<800)
			press MOVEFORWARD
		wait 50
	}
	while (!${Me.Loc.X}<800)
	
	call DMove 770 198 -693 3
	call DMove 801 181 -638 3
	call DMove 773 147 -574 3
	call DMove 719 145 -525 1
	
	call DMove 687 132 -495 3
	call DMove 613 97 -502 3
	call DMove 557 90 -562 1
	call DMove 528 82 -602 3
	call DMove 537 56 -675 3
	call DMove 566 38 -702 3
	call DMove 617 38 -744 1
	call DMove 688 12 -755 3
	call DMove 766 -17 -691 1
	call DMove 774 -17 -597 1
	call DMove 755 -17 -549 1
	call DMove 712 -17 -524 1
	call DMove 624 -17 -518 1
	call DMove 535 -17 -640 1
	call DMove 583 -17 -734 1
	wait 100
	call CountItem "frostbite crystal"
	if (${Return}<1)
	{
		do
		{
			call DMove 535 -17 -640 1
			call DMove 624 -17 -518 1
			call DMove 712 -17 -524 1
			call DMove 755 -17 -549 1
			wait 100
			call DMove 712 -17 -524 1
			call DMove 583 -17 -734 1
			call DMove 624 -17 -518 1
			call DMove 535 -17 -640 1
			call DMove 583 -17 -734 1
			call CountItem "frostbite crystal"
		}
		while (${Return}<1)
	}
	call DMove 551 -17 -649 1
	call DMove 520 -11 -635 1
	call DMove 262 5 -636 1
	call DMove 230 11 -636 3
	call DMove 49 10 -628 3
	call DMove 8 10 -545 3
}

function step004()
{
	eq2execute merc resume
		
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -19 10 -543 3
	call DMove -59 10 -639 3
	call DMove -239 12 -634 3
	call DMove -541 -17 -635 3
	call DMove -578 -17 -565 3
	call DMove -641 -17 -519 3
	call DMove -178 -17 -529 3
	call DMove -781 -17 -623 3
	call DMove -766 -17 -672 3
	call DMove -745 -17 -712 3
	call DMove -706 12 -752 3
	call DMove -653 34 -758 3
	call DMove -588 38 -723 3
	call DMove -537 61 -683 3
	call DMove -525 84 -615 3
	call DMove -560 90 -554 3
	call DMove -577 90 -529 3
	call DMove -626 114 -489 3
	call DMove -718 145 -517 3
	call DMove -736 145 -539 3
	call DMove -755 145 -551 3
	call DMove -800 174 -604 3
	call DMove -763 198 -703 3
	call DMove -781 199 -723 3
	call DMove -881 213 -795 3
	call DMove -1023 255 -896 3
	call DMove -1045 256 -905 3
	call DMove -1118 255 -955 3
	call DMove -1162 256 -1018 3
	call DMove -1188 256 -1039 3
	call DMove -1275 295 -1235 3
	call DMove -1352 290 -1288 3
}

function step005()
{
	variable string Named
	Named:Set["Keeper of Past Lore"]
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
	if (${Message.Find["see how well you scramble"]} > 0)
	{
		oc !c -CS_Set_ChangeRelativeCampSpotBy ${Me.Name} 30 0 -30
		InRing:Set[FALSE]

		
	}
	if (${Message.Find["not locked in here with you"]} > 0)
	{
		if (!${InRing})
		{
			oc !c -CS_Set_ChangeRelativeCampSpotBy ${Me.Name} -30 0 30
			InRing:Set[TRUE]
		}
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