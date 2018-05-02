#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool InRing

function main(int stepstart, int stepstop, int setspeed)
{

	variable int laststep=2
	
	oc !c -letsgo ${Me.Name}
	if (${setspeed}==0)
	{
		if (${Me.Archetype.Equal["fighter"]} || ${Me.Archetype.Equal["priest"]})
		{
			echo I am a fighter
			speed:Set[3]
			FightDistance:Set[15]
		}
		else
		{
			echo I am a healer
			speed:Set[1]
			FightDistance:Set[30]
		}
	}
	else
		speed:Set[${setspeed}]
		
	echo speed set to ${speed}
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Torden, Bastion of Thunder: Winds of Change [Solo]"
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
		;call IsPresent "Auliffe Chaoswind" 1000
		;if (!${Return})
		;{
	;		call IsPresent "Gaukr Sandstorm" 1000
	;		if (!${Return})
	;		{
	;			echo zone empty
	;			call step012
	;			return
	;		}
		
	;		call check_quest "Legacy of Power: Through Storms and Mists"
	;		if (${Return})
	;		{
	;			call CountItem "frostbite crystal"
	;			if (${Return}>0)
	;			{
	;				call DMove 0 10 -502 3
	;				call DMove 15 11 -515 3
	;				call DMove 10 10 -540 3
	;				stepstart:Set[4]
	;			}
	;		}
	;		else
	;		{
	;			call DMove 0 10 -502 3
	;			call DMove 15 11 -515 3
	;			call DMove 10 10 -540 3
	;			stepstart:Set[4]
	;		}
	;	}
	}
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["Elif Whitewind"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	;Ob_AutoTarget:AddActor["Primordial Malice",0,TRUE,FALSE]
	
	call DMove 0 -20 122 3
	call DMove -3 5 312 3
	call DMove -5 10 434 ${speed} ${FightDistance}
	echo must kill "${Named}"
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
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
	call DMove 0 10 545 3
}	

function step001()
{
	variable string Named
	Named:Set["Inquisitor Barol"]
	eq2execute merc resume

	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]

	call DMove 231 11 -637 ${speed} ${FightDistance}
	call DMove 288 2 -631  ${speed} ${FightDistance}
	wait 100
	call DMove 296 0 -637 ${speed} ${FightDistance}
	call DMove 538 -17 -635 ${speed} ${FightDistance}
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
	
	call DMove 704 3 -748 ${speed} ${FightDistance}
	call DMove 625 37 -748 ${speed} ${FightDistance}
	call DMove 593 38 -720 ${speed} ${FightDistance}
	
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
	
	call DMove 574 38 -712 ${speed} ${FightDistance}
	call DMove 540 56 -673 ${speed} ${FightDistance}
	call DMove 531 73 -634 ${speed} ${FightDistance}
	call DMove 537 86 -587 ${speed} ${FightDistance}
	call DMove 562 90 -556 ${speed} ${FightDistance}
	call DMove 600 90 -516 ${speed} ${FightDistance}
	call DMove 647 114 -492 ${speed} ${FightDistance}
	call DMove 719 144 -520 ${speed} ${FightDistance}
	
	call DMove 769 145 -564 1
	
	call DMove 794 169 -612 ${speed} ${FightDistance}
	call DMove 789 193 -668 ${speed} ${FightDistance}
	call DMove 767 198 -690 ${speed} ${FightDistance}
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
	call DMove 783 341 -751 ${speed} ${FightDistance}
	call DMove 726 311 -692 ${speed} ${FightDistance}
	call DMove 657 309 -635 ${speed} ${FightDistance}
	oc !c -CampSpot ${Me.Name}
	oc !c -joustout ${Me.Name}
	InRing:Set[TRUE]
	echo must kill "${Named}"
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
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
			call DMove 845 341 -809 1 30 FALSE TRUE
			wait 50
		}
		if (!${Me.Loc.X}<800)
		{
			call DMove 858 341 -825 1 30 FALSE TRUE
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
	
	call DMove -19 10 -543 ${speed} ${FightDistance}
	call DMove -59 10 -639 ${speed} ${FightDistance}
}
	
function step005()
{
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -239 12 -634 ${speed} ${FightDistance}
	call DMove -541 -17 -635 ${speed} ${FightDistance}
	call DMove -578 -17 -565 ${speed} ${FightDistance}
	call DMove -641 -17 -519 ${speed} ${FightDistance}
	call DMove -738 -17 -542 ${speed} ${FightDistance}
	call DMove -781 -17 -623 ${speed} ${FightDistance}
	call DMove -766 -17 -672 ${speed} ${FightDistance}
	call DMove -745 -17 -712 ${speed} ${FightDistance}
	call DMove -706 12 -752 ${speed} ${FightDistance}
	call DMove -653 34 -758 ${speed} ${FightDistance}
	call DMove -588 38 -723 ${speed} ${FightDistance}
	call DMove -537 61 -683 ${speed} ${FightDistance}
	call DMove -525 84 -615 ${speed} ${FightDistance}
	call DMove -560 90 -554 ${speed} ${FightDistance}
	call DMove -577 90 -529 ${speed} ${FightDistance}
	call DMove -626 114 -489 ${speed} ${FightDistance}
	call DMove -718 145 -517 ${speed} ${FightDistance}
	call DMove -736 145 -539 ${speed} ${FightDistance}
	call DMove -755 145 -551 ${speed} ${FightDistance}
	call DMove -800 174 -604 ${speed} ${FightDistance}
	call DMove -763 198 -703 ${speed} ${FightDistance}
	call DMove -781 199 -723 ${speed} ${FightDistance}
	call DMove -881 213 -795 ${speed} ${FightDistance}
	call DMove -1023 255 -896 ${speed} ${FightDistance}
	call DMove -1045 256 -905 ${speed} ${FightDistance}
	call DMove -1118 255 -955 ${speed} ${FightDistance}
	call DMove -1162 256 -1018 ${speed} ${FightDistance}
	call DMove -1188 256 -1039 ${speed} ${FightDistance}
	call DMove -1275 295 -1235 ${speed} ${FightDistance}
	call DMove -1352 290 -1288 ${speed} ${FightDistance}
}

function step006()
{
	variable string Named
	Named:Set["Keeper of Past Lore"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove -1417 289 -1297 3
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}" 500
	}
	while (${Return})
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step007()
{
	call DMove -1508 289 -1242 ${speed} ${FightDistance}
	call DMove -1524 295 -1125 ${speed} ${FightDistance}
	call DMove -1476 307 -1071 ${speed} ${FightDistance}
	call DMove -1449 309 -1071 ${speed} ${FightDistance}
	call DMove -1370 315 -1037 ${speed} ${FightDistance}
	call DMove -1291 321 -999 ${speed} ${FightDistance}
	call DMove -1178 346 -977 ${speed} ${FightDistance}
	call DMove -1082 366 -935 ${speed} ${FightDistance}
	call DMove -1064 367 -931 ${speed} ${FightDistance}
	call DMove -1033 366 -903 ${speed} ${FightDistance}
	call DMove -917 347 -820 ${speed} ${FightDistance}
}
	
function step008()
{
	echo "waiting for best moment to move on"
	do
	{
		wait 10
	}
	while (${Actor["a virulent sandstorm"].X} > -900 || ${Actor["a virulent sandstorm"].Z}<-770)
	echo "GO GO GO"
	call DMove -813 345 -740 3 5 TRUE TRUE 
}

function step009()
{
	variable string Named
	Named:Set["Gaukr Sandstorm"]
	call DMove -652 309 -626 ${speed} ${FightDistance}
	
	oc !c -CampSpot ${Me.Name}
	oc !c -joustout ${Me.Name}
	
	Ob_AutoTarget:Clear
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	echo must kill "${Named}"
	oc !c -CS_Set_ChangeRelativeCampSpotBy ${Me.Name} 20 0 20
	do
	{
		wait 10
		call IsPresent "${Named}" 500
	}
	while (${Return})
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	oc !c -letsgo ${Me.Name}
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
	oc !c -letsgo ${Me.Name}
}
function step010()
{
	call DMove -617 309 -600 3
	call ActivateVerb "Zone to Bottom" -617 309 -600 "Return to Bottom of Tower" TRUE
	wait 50
	do
	{
		call DMove -618 -17 -709 ${speed} ${FightDistance}
		call CountItem "bead of polished krendicite"
	}
	while (${Return}<1)
}
function step011()
{
	call DMove -566 -17 -697 ${speed} ${FightDistance}
	call DMove -540 -17 -637 ${speed} ${FightDistance}
	call DMove -386 2 -632 3
	call DMove -269 5 -638 3
	call DMove -230 12 -645 3
	call DMove -47 10 -647 3
	call DMove -16 10 -555 3
	call DMove 5 11 -537 3
	call DMove -3 10 -380 3
	call DMove -2 5 -302 3
	call DMove 0 -2 -13 3
}
function step012()
{
	call DMove 0 0 -3 
	call ActivateVerb Exit" 0 0 -3 "To the Colisseum of Valor" TRUE
	wait 50
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
	if (${Message.Find["has killed you"]} > 0 || ${Message.Find["you have died"]} > 0)
	{
		echo "I am dead"
		if ${Script["livedierepeat"](exists)}
			endscript livedierepeat
		run EQ2Ethreayd/livedierepeat
	}
 }