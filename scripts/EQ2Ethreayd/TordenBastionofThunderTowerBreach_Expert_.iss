#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool InRing
variable(script) int MyStep
variable(script) bool NoShinyGlobal

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=9
	NoShinyGlobal:Set[${NoShiny}]
	MyStep:Set[${stepstart}]
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
	
	if (${setspeed}==0)
		speed:Set[3]
	else
		speed:Set[${setspeed}]
		
	FightDistance:Set[30]
	
	echo speed set to ${speed}
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 50 1
 
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Torden, Bastion of Thunder: Tower Breach [Expert]"
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_ActorStanceChange]:AttachAtom[StanceChange]

	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_setup_moveintomeleerangemaxdistance",25]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	oc !c -UplinkOptionChange All checkbox_settings_forcenamedcatab TRUE

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
			
			stepstart:Set[4]
		}
	}
	oc !c -OgreFollow All ${Me.Name}
	echo starting at step ${stepstart}
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["Gatekeeper Karatil"]
	call StopHunt
	MyStep:Set[0]
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
	MyStep:Set[1]
	call StopHunt
	oc !c -UplinkOptionChange All checkbox_settings_movemelee FALSE
	oc !c -UplinkOptionChange All checkbox_settings_movebehind FALSE
	oc !c -UplinkOptionChange All checkbox_settings_moveinfront FALSE
	call DMove 190 10 -643 3
	call Go2D 212 12 -643 10 TRUE
	call Go2D 231 11 -637 10 TRUE
	call Go2D 288 2 -637  10 TRUE
	oc !c -CampSpot
	oc !c -joustout
	wait 100
	oc !c -letsgo
	call Go2D 296 0 -637 10 TRUE
	call Go2D 398 -1 -637 10 TRUE
	oc !c -CampSpot
	oc !c -joustout
	wait 100
	oc !c -letsgo
	call Go2D 550 -17 -637 10 TRUE
	call Go2D 551 -17 -587 10 TRUE
	oc !c -CampSpot
	oc !c -joustout
	wait 100
	oc !c -letsgo
	call Go2D 593 -17 -554 10 TRUE
	call Go2D 620 -17 -536 10 TRUE
	oc !c -CampSpot
	oc !c -joustout
	wait 100
	oc !c -letsgo
	call Go2D 648 -17 -528 10 TRUE
	call Go2D 713 -17 -550 10 TRUE
	oc !c -CampSpot
	oc !c -joustout
	wait 100
	oc !c -letsgo
	call Go2D 759 -17 -569 10 TRUE
	call Go2D 772 -17 -647 10 TRUE
	oc !c -CampSpot
	oc !c -joustout
	wait 100
	oc !c -letsgo
	call Go2D 760 -17 -689 10 TRUE
	call Go2D 736 -17 -723 10 TRUE
	oc !c -CampSpot
	oc !c -joustout
	call WaitforGroupDistance 30
	oc !c -letsgo
	call Go2D 704 3 -748 10 TRUE
	oc !c -CampSpot
	oc !c -joustout
	call WaitforGroupDistance 30
	oc !c -letsgo
	call DMove 694 9 -749 3 30
	
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call DMove 625 37 -748 3 30
	
	call Go2D 587 38 -718 10 TRUE
	oc !c -CampSpot
	oc !c -joustout
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
	oc !c -UplinkOptionChange All checkbox_settings_forcenamedcatab TRUE

}	
	
function step002()
{
	variable string Named
	Named:Set["Auliffe Chaoswind"]
	call StopHunt
	
	Ob_AutoTarget:Clear
	
	call DMove 580 38 -712 3
	call DMove 540 54 -680 3
	call DMove 530 73 -634 3
	call DMove 535 84 -596 3
	call DMove 554 89 -563 3
	call Go2D 599 90 -514 10 TRUE 
	call DMove 632 107 -494 3
	call DMove 678 128 -496 3
	call DMove 715 144 -525 3
	call Go2D 768 145 -566 10 TRUE
	call DMove 793 165 -605 3
	call DMove 788 193 -671 3
	call DMove 766 198 -691 3
	
	oc !c -pause
	relay all run EQ2Ethreayd/TBoTTBH_C2
	wait 100
	while ${Script[TBoTTBH_C2](exists)}
		wait 100
	oc !c -resume
	call WaitforGroupDistance 20
	
	call DMove 712 310 -683 3
	call DMove 657 309 -635 3 30 TRUE TRUE
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
	call StopHunt
	call DMove 642 309 -615 3
	eq2execute summon
	wait 50
	oc !c -AcceptReward
	wait 50
	oc !c -revive All 0
	oc !c -Evac	
}

function step004()
{
	call StopHunt
	call DMove -1 -20 -120 3
	call DMove -1 10 -440 3
	call DMove 3 10 -458 3
	call DMove 15 11 -511 3
	call DMove 6 10 -552 3
	call DMove -19 10 -543 3
	call DMove -59 10 -639 3
	call DMove -202 10 -646 3
}
	
function step005()
{
	call StopHunt
	MyStep:Set[5]
	call DMove -167 10 -649 3
	call DMove -238 11 -641 3
	call DMove -541 -17 -635 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	
	call DMove -578 -17 -565 3
	call DMove -641 -17 -519 3
	call DMove -738 -17 -542 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	call DMove -781 -17 -623 3
	call DMove -766 -17 -672 3
	call DMove -745 -17 -712 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	call DMove -706 12 -752 3
	call DMove -653 34 -758 3
	call DMove -588 38 -723 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	call DMove -537 61 -683 3
	call DMove -525 84 -615 3
	call DMove -560 90 -554 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	call DMove -577 90 -529 3
	call DMove -626 114 -489 3
	call DMove -718 145 -517 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	call DMove -736 145 -539 3
	call DMove -755 145 -551 3
	call DMove -800 174 -604 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	call DMove -763 198 -703 3
	call DMove -781 199 -723 3
	call DMove -881 213 -795 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	call DMove -1023 255 -896 3
	call DMove -1045 256 -905 3
	call DMove -1118 255 -955 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	call DMove -1162 256 -1018 3
	call DMove -1188 256 -1039 3
	call DMove -1275 295 -1235 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	call DMove -1352 290 -1288 3
}

function step006()
{
	variable string Named
	Named:Set["Keeper of Past Lore"]
	call StopHunt
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	
	call IsPresent "${Named}" 200
	if (${Return})
	{
		oc !c -pause
		relay all run EQ2Ethreayd/TBoTTBH_C1
		wait 100
		while ${Script[TBoTTBH_C1](exists)}
			wait 100
		oc !c -resume
		call WaitforGroupDistance 20
		wait 100
		call DMove -1261 295 -1386 3
		oc !c -Come2Me ${Me.Name} All 3
		;oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_namedca TRUE
		oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_ca TRUE
	
		call TanknSpank "${Named}"
	
		oc !c -AcceptReward
		eq2execute summon
		wait 50
		oc !c -AcceptReward
		;oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_namedca FALSE
		oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_ca FALSE
		if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
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
	call DMove -943 353 -835 3
	call CheckCombat
	call DMove -917 347 -820 3 30 TRUE TRUE 5
}
	
function step008()
{
	echo "waiting for best moment to move on"
	if ${Script["livedierepeat"](exists)}
		Script["livedierepeat"]:Pause
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Pause
	oc !c -CampSpot
	oc !c -joustout all
	do
	{
		wait 10
		echo ${Actor["a virulent sandstorm"].X} [-770|-750] ${Actor["a virulent sandstorm"].Z} [-900|-880]
	}
	while (${Actor["a virulent sandstorm"].Z} > -750 || ${Actor["a virulent sandstorm"].Z} < -770 || ${Actor["a virulent sandstorm"].X} < -900 || ${Actor["a virulent sandstorm"].X} > -880)
	echo "GO GO GO"	
	oc !c -CS_Set_ChangeCampSpotBy all 60 0 0
	wait 40
	oc !c -CS_Set_ChangeCampSpotBy all 30 0 70
	wait 40
	oc !c -CS_Set_ChangeCampSpotBy all 20 0 20
	
	call WaitforGroupDistance 20
	wait 100
	oc !c -letsgo 
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
	call DMove -658 309 -634 ${speed} ${FightDistance} TRUE
	oc !c -ofol---
	oc !c -ofol---
	oc !c -ofol---
	wait 100
	oc !c -CampSpot
	oc !c -joustout
	oc !c -joustin ${Me.Name}
	call DMove -622 309 -600 ${speed} ${FightDistance} TRUE
	

	Ob_AutoTarget:Clear
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	oc !c -joustout
	call TanknSpank "${Named}"
		
	oc !c -AcceptReward
	eq2execute summon
	wait 50
	oc !c -AcceptReward
	oc !c -letsgo
	oc !c -AcceptReward
	oc !c -AcceptReward
	oc !c -AcceptReward
	oc !c -letsgo
	call DMove -643 309 -638 3
	eq2execute summon
	call DMove -660 309 -630 3
	eq2execute summon
	
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
	if ${Script["livedierepeat"](exists)}
		endscript livedierepeat
	relay all ogre
	wait 200
	
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
	if (${Message.Find["see how well you scramble"]} > 0)
	{
		echo moving out of the ring (must be done by Ogre)
		InRing:Set[FALSE]

		
	}
	if (${Message.Find["not locked in here with you"]} > 0)
	{
		if (!${InRing})
		{
			echo moving back in the ring (must be done by Ogre)
			InRing:Set[TRUE]
		}
	}
	if (${Message.Find["eathMate!!!"]} > 0)
	{
		echo group seems dead - restarting zone
		if ${Script["RestartZone"}](exists)}
			endscript RestartZone
		runscript EQ2Ethreayd/RestartZone ${MyStep} 0 ${speed} ${NoShinyGlobal}
	}
}
atom HandleAllEvents(string Message)
{
	if (${Message.Find["keep his power drained"]} > 0)
	{
		echo "Launching massive drain power sequence"
		QueueCommand call DrainPower "Inquisitor Barol"
	}
}