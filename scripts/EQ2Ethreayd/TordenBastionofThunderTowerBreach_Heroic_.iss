#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool InRing

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=12
	oc !c -resume
	oc !c -letsgo
	if (!${Script["livedierepeat"](exists)})
		run EQ2Ethreayd/livedierepeat ${NoShiny} TRUE
	if (${setspeed}==0)
		speed:Set[3]
	FightDistance:Set[30]
	
	echo speed set to ${speed}
	;if ${Script["autoshinies"](exists)}
	;	endscript autoshinies
	;if (!${NoShiny})
	;	run EQ2Ethreayd/autoshinies 50 ${speed} 
 
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Torden, Bastion of Thunder: Tower Breach [Heroic]"
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_ActorStanceChange]:AttachAtom[StanceChange]

	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_setup_moveintomeleerangemaxdistance",25]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	

	if (${stepstart}==0)
	{
		call IsPresent "Auliffe Chaoswind" 1000
		if (!${Return})
		{
			call IsPresent "Gaukr Sandstorm" 1000
			if (!${Return})
			{
				echo zone empty
				call step012
				return
			}
			call DMove 0 10 -502 3
			wait 20
			call DMove 15 11 -515 3
			wait 50
			call DMove 8 10 -544 3
			wait 20
			call DMove 11 10 -559 3
			wait 20
			call DMove 10 11 -539 3
			wait 20
			call DMove 2 10 -555 3
			wait 20
			stepstart:Set[4]
		}
	}
	oc !c -OgreFollow All ${Me.Name}
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["Gatekeeper Karatil"]
	eq2execute merc resume
	call StopHunt
	
	Ob_AutoTarget:AddActor["Primordial Malice",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	call DMove -1 -20 -120 3
	call DMove -1 10 -440 3
	call DMove 3 10 -458 3
	call DMove 15 11 -479 3
	call DMove -5 10 -504 3
	do
	{
		wait 10
		call IsPresent "Malice" 30
	}
	while (${Return})
	wait 10
	echo must kill "${Named}"
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	oc !c -AcceptReward
	eq2execute summon
	wait 50
	oc !c -AcceptReward
	wait 20
	call DMove 14 11 -515 ${speed} ${FightDistance}
	call DMove 14 12 -523 ${speed} ${FightDistance}
	call DMove 14 11 -537 ${speed} ${FightDistance}
	call DMove 50 10 -637 ${speed} ${FightDistance}
}	

function step001()
{
	variable string Named
	Named:Set["Inquisitor Barol"]
	eq2execute merc resume

	call StopHunt
	oc !c -UplinkOptionChange All checkbox_settings_movemelee FALSE
	oc !c -UplinkOptionChange All checkbox_settings_movebehind FALSE
	oc !c -UplinkOptionChange All checkbox_settings_moveinfront FALSE
	call DMove 190 10 -643 3
	call DMove 212 12 -643 1
	call DMove 231 11 -637 1
	call DMove 288 2 -637  1
	wait 100
	call DMove 296 0 -637 1
	call DMove 398 -1 -637 1 30 TRUE
	call DMove 550 -17 -637 1 30 TRUE
	call DMove 551 -17 -587 1
	call DMove 593 -17 -554 1
	call DMove 620 -17 -536 1
	call DMove 648 -17 -528 1
	call DMove 713 -17 -550 1
	call DMove 759 -17 -569 1
	call DMove 772 -17 -647 1
	call DMove 760 -17 -689 1
	call DMove 736 -17 -723 1
	
	call DMove 704 3 -748 1
	call DMove 694 9 -749 1
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call DMove 625 37 -748 ${speed} ${FightDistance}
	call DMove 593 38 -720 ${speed} ${FightDistance}
	
	wait 100
	call TanknSpank "${Named}" 50 TRUE  
	
	oc !c -AcceptReward
	eq2execute summon
	wait 50
	oc !c -AcceptReward
	wait 20
	relay all ogre
	wait 300
	oc !c -letsgo
	oc !c -OgreFollow All ${Me.Name}
	wait 50
}	
	
function step002()
{
	variable string Named
	Named:Set["Auliffe Chaoswind"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	Ob_AutoTarget:Clear
	
	call DMove 574 38 -712 1
	call DMove 540 56 -673 1
	call DMove 531 73 -634 ${speed} ${FightDistance}
	call DMove 537 86 -587 ${speed} ${FightDistance}
	call DMove 562 90 -556 1
	call DMove 600 90 -516 1
	call DMove 647 114 -492 ${speed} ${FightDistance} 
	call DMove 719 144 -520 ${speed} ${FightDistance} 
	call DMove 769 145 -564 1
	call DMove 794 169 -612 ${speed} ${FightDistance}
	call DMove 789 193 -668 ${speed} ${FightDistance}
	call DMove 767 198 -690 1
	call DMove 725 198 -717 1
	wait 100
	if (${Me.Loc.X}<800)
	do
	{
		call MoveCloseTo "floor_diode_any_enchanter"
		call PKey MOVEFORWARD 1
		wait 50
	}
	while (${Me.Loc.X}<800)
	call DMove 783 341 -751 ${speed} ${FightDistance}
	call DMove 726 311 -692 ${speed} ${FightDistance}
	call DMove 657 309 -635 ${speed} ${FightDistance}
	oc !c -CampSpot
	oc !c -joustout
	InRing:Set[TRUE]
	eq2execute gsay Set up for ${Named}
	call TanknSpank "${Named}"
	
	oc !c -letsgo
	oc !c -AcceptReward
	eq2execute summon
	wait 50
	oc !c -AcceptReward
	wait 20
	oc !c -AcceptReward
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
}

function step003()
{
	variable bool Loop=FALSE
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove 642 309 -615 3
	call RelayAll ActivateVerb "Zone to Bottom" 642 309 -615 "Return to Bottom of Tower" TRUE
	wait 50
	relay all face 701 -565
	relay all press -hold MOVEFORWARD
	wait 20
	relay all press JUMP
	wait 10
	relay all press JUMP
	relay all press -release MOVEFORWARD
	call DMove 768 -17 -610 1
	wait 100
	do
	{
		call DMove 782 -17 -600 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 757 -17 -551 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 717 -17 -519 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 662 -17 -504 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 582 -17 -533 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 541 -17 -593 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 540 -17 -676 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 575 -17 -726 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 618 -17 -757 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 677 -17 -758 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 711 -17 -705 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 763 -17 -711 1
		call getChest "Auliffe Chaoswind's Treasure"
		call DMove 785 -17 -652 1
		call getChest "Auliffe Chaoswind's Treasure"
	}
	while (${Loop})
	call DMove 782 -17 -600 1
	call DMove 757 -17 -551 1
	call DMove 717 -17 -519 1
	call DMove 662 -17 -504 1
	call DMove 582 -17 -533 1
	call DMove 543 -17 -637 1
	call DMove 524 -12 -637 1
	call DMove 472 -4 -636 1
	call DMove 362 5 -635 1
	call DMove 262 5 -636 1
	call DMove 230 11 -636 3
	call DMove 49 10 -628 3
	call DMove 8 10 -545 3
	call DMove -10 10 -378 3
	call DMove -9 5 -324 3
	call DMove -1 -2 -282 3
	call DMove 0 -20 -124 3
	call DMove -1 -2 -12 3
	oc !c -revive
	wait 100
	call DMove -1 -20 -120 3
	call DMove -1 10 -440 3
	call DMove 3 10 -458 3
	call DMove 15 11 -479 3
	call DMove -5 10 -504 3
	call DMove 15 11 -511 3
	call DMove 6 10 -552 3
}

function step004()
{
	eq2execute merc resume
	call StopHunt
	call DMove -19 10 -543 3
	call DMove -59 10 -639 3
	call DMove -202 10 -646 3
	
}
	
function step005()
{
	eq2execute merc resume
	call StopHunt
	
	call DMove -239 12 -634 ${speed} ${FightDistance}
	call DMove -541 -17 -635 ${speed} ${FightDistance}
	wait 100
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
	call DMove -1352 290 -1288 3
}

function step006()
{
	variable string Named
	Named:Set["Keeper of Past Lore"]
	eq2execute merc resume
	call StopHunt
	call IsPresent "${Named}" 200
	if (${Return})
	{
		oc !c -pause
		relay all run EQ2Ethreayd/TBoTTBH_C1
		wait 100
		while ${Script[TBoTTBH_C1](exists)}
			wait 100
		oc !c -resume
		echo waiting for all toons to come to this place, I need a group distance function, I will do it later
		wait 600
		
		call DMove -1261 295 -1386 3
		oc !c -Come2Me ${Me.Name} All 3
		oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_namedca TRUE
		oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_ca TRUE
	
		call TanknSpank "${Named}"
	
		oc !c -AcceptReward
		eq2execute summon
		wait 50
		oc !c -AcceptReward
		oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_namedca FALSE
		oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_ca FALSE
		call DMove -1281 295 -1329 3
		call DMove -1326 300 -1301 3
	}
}

function step007()
{
	call DMove -1352 290 -1288 3
	call DMove -1417 289 -1297 3
	call DMove -1520 290 -1257 3
	call DMove -1494 296 -1147 3
	call DMove -1505 298 -1107 3
	call DMove -1467 306 -1082 3
	wait 100
	call DMove -1425 314 -1051 3
	call DMove -1283 321 -1003 3
	wait 100
	call DMove -1178 346 -977 3
	call DMove -1106 363 -942 3
	wait 100
	call DMove -1066 367 -933 3
	call DMove -1033 366 -903 3
	call DMove -917 347 -820 3
}
	
function step008()
{
	echo "waiting for best moment to move on"
	if ${Script["livedierepeat"](exists)}
		Script["livedierepeat"]:Pause
	do
	{
		wait 10
	}
	while (${Actor["a virulent sandstorm"].Z} < -748 && ${Actor["a virulent sandstorm"].Z} > -790)
	echo "GO GO GO"
	call DMove -813 345 -740 3 5 TRUE TRUE 
	if ${Script["livedierepeat"](exists)}
		Script["livedierepeat"]:Resume
	call DMove -717 310 -672 3
	call DMove -678 309 -643 3
	call DMove -689 309 -603 3
	wait 100
	call DMove -635 309 -678 3
	wait 100
	call DMove -667 309 -628 3
}

function step009()
{
	variable string Named
	Named:Set["Gaukr Sandstorm"]
	call DMove -652 309 -626 ${speed} ${FightDistance}
	
	oc !c -CampSpot 
	oc !c -joustout 
	oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_namedca TRUE
	oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_ca TRUE
	
	Ob_AutoTarget:Clear
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	echo must kill "${Named}"
	oc !c -CS_Set_ChangeRelativeCampSpotBy all 20 0 20
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	
	oc !c -AcceptReward
	eq2execute summon
	wait 50
	oc !c -AcceptReward
	oc !c -letsgo
	oc !c -AcceptReward
	oc !c -AcceptReward
	oc !c -AcceptReward
	oc !c -letsgo
	oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_namedca FALSE
	oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_ca FALSE
	
	call DMove -617 309 -600 3
	call RelayAll ActivateVerb "Zone to Bottom" -617 309 -600 "Return to Bottom of Tower" TRUE
	wait 50
}
function step010()
{
	variable bool Loop=FALSE
	
	do
	{
		call DMove -618 -17 -709 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -648 -17 -754 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -685 -17 -738 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -720 -17 -709 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -757 -17 -683 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -779 -17 -643 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -773 -17 -595 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -728 -17 -558 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -706 -17 -562 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -669 -17 -523 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -633 -17 -527 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -594 -17 -563 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -566 -17 -588 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -545 -17 -627 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -553 -17 -664 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
		call DMove -576 -17 -701 ${speed} ${FightDistance}
		call getChest "Gaukr Sandstorm's Treasure"
	}
	while (${Loop})
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
	call RelayAll ActivateVerb "Exit" 0 0 -3 "To the Coliseum of Valor" TRUE
	wait 50
	if ${Script["livedierepeat"](exists)}
		endscript livedierepeat
}
function DrainPower(string Named)
{
	do
	{
		if (${Actor[name,${Named}].Power}>15)
		{
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_namedca TRUE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_nonnamedca TRUE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_items TRUE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_ca TRUE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_combat TRUE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_heal TRUE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_nameddebuff TRUE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_buffs TRUE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_powerheal TRUE
		}
		else
		{
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_namedca FALSE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_nonnamedca FALSE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_items FALSE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_ca FALSE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_combat FALSE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_heal FALSE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_nameddebuff FALSE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_buffs FALSE
			oc !c -UplinkOptionChange Mages checkbox_settings_disablecaststack_powerheal FALSE
		}
		
		wait 30
		call IsPresent "${Named}"
	}
	while (${Return})
}

atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	;echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
	if (${Message.Find["see how well you scramble"]} > 0)
	{
		echo moving out of the ring (must be done by Ogre)
		;oc !c -CS_Set_ChangeRelativeCampSpotBy all 35 0 -35
		InRing:Set[FALSE]

		
	}
	if (${Message.Find["not locked in here with you"]} > 0)
	{
		if (!${InRing})
		{
			echo moving back in the ring (must be done by Ogre)
			;oc !c -CS_Set_ChangeRelativeCampSpotBy all -35 0 35
			InRing:Set[TRUE]
		}
	}
}
atom HandleAllEvents(string Message)
{
	;echo Catch Event ${Message}
    if (${Message.Find["keep his power drained"]} > 0)
	{
		echo "Launching massive drain power sequence"
		QueueCommand call DrainPower "Inquisitor Barol"
	}
}
atom StanceChange(string ActorID, string ActorName, string ActorType, string OldStance, string NewStance, string TargetID, string Distance, string IsInGroup, string IsInRaid)
{
	echo ${ActorID} ${ActorName} ${ActorType} ${OldStance} ${NewStance} ${TargetID} ${Distance} ${IsInGroup} ${IsInRaid}
}