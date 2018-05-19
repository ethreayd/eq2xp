#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=2
	
	oc !c -letsgo ${Me.Name}
	if ${Script["livedierepeat"](exists)}
		endscript livedierepeat
	run EQ2Ethreayd/livedierepeat
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
			
	echo speed set to ${speed}
	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 50 ${speed} 
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "The Molten Throne"

	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_onAnnouncement]:AttachAtom[HandleAnnounces]
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
	
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call Converse "Druzzil Ro" 5 TRUE TRUE
	call DMove -3 -7 -60 3
	echo waiting 90s for cut scene - BE PATIENT
	wait 900
	Ob_AutoTarget:AddActor["Sullonite",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove -9 -5 -43 ${speed} ${FightDistance}
	wait 20
	call DMove 4 -4 -18 ${speed} ${FightDistance}
	wait 20
	call DMove 4 -4 -18 ${speed} ${FightDistance}
	wait 20
	call DMove -28 -1 14 ${speed} ${FightDistance}
	wait 20
	call DMove 20 -3 11 ${speed} ${FightDistance}
	wait 20
	call DMove -6 -1 38 ${speed} ${FightDistance}
	wait 20
	call DMove 18 1 71 ${speed} ${FightDistance}
	wait 20
	call DMove 8 2 96 ${speed} ${FightDistance}
	wait 20
	call DMove 6 3 106 3
	
}

function step001()
{
	variable string Named
	Named:Set["The Blood Primordial"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
	
	call DMove 6 3 106 3
	call MoveCloseTo "${Named}"
	oc !c -CampSpot ${Me.Name}
	oc !c -joustout ${Me.Name}
	Ob_AutoTarget:AddActor["${Named}",0,!${NoCC},FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	echo "must kill ${Named}"
	call IsPresent "${Named}"
	if (${Return})
	{
		target "${Named}"
		do
		{
			wait 100
			if (${Me.Loc.Z}>80)
				oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 0 0 -30
			else
				oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 0 0 30
			if (${Me.Health} > 99 && ${Me.Power} > 99)
				target "${Named}"
			call IsPresent "${Named}"
		}
		while (${Return} || ${Me.InCombatMode})
	}
	oc !c -letsgo ${Me.Name} 
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
function step002()
{
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 6 3 106 3
	call DMove 3 13 140 3
	call DMove 5 24 195 3
	call DMove -19 24 193 3
	call DMove -10 24 175 3
	OgreBotAPI:Special["${Me.Name}"]
	do
	{
		wait 100
	}
	while (${Me.Loc.Z}<200)
	call DMove 1806 710 972 3
	call Converse "Druzzil Ro" 5 TRUE TRUE
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 100
	eq2execute dance
	wait 20
	call DMove 1808 694 794 3
	call ActivateVerb "Zone to Coliseum of Valor" 1808 694 794 "Leave"
}