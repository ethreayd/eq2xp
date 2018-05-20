#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=0
	
	oc !c -letsgo ${Me.Name}
	if ${Script["livedierepeat"](exists)}
		endscript livedierepeat
	run EQ2Ethreayd/livedierepeat ${NoShiny}
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
	call waitfor_Zone "Brackish Vaults [Solo]"

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
	
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["coral guardian"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove 37 35 28 ${speed} ${FightDistance}
	call DMove 36 35 13 ${speed} ${FightDistance}
	call DMove 30 35 22 3
	
	do
	{
		call ActivateVerbOnPhantomActor "Vapor"
		wait 50
	}
	while (${Me.Loc.Z}>0)
	
	call DMove 10 84 -48 ${speed} ${FightDistance}
	call DMove -28 84 -37 ${speed} ${FightDistance}
	call DMove 9 84 -23 3
	
	do
	{
		call ActivateVerbOnPhantomActor "Ice"
		wait 50
	}
	while (${Me.Loc.X}>0)
	
	call DMove -55 143 38 ${speed} ${FightDistance}
	call DMove -41 143 79 ${speed} ${FightDistance}
	call DMove -59 143 68 3
	call DMove -20 143 31 3
	
	do
	{
		call ActivateVerbOnPhantomActor "Water"
		wait 50
	}
	while (${Me.Loc.Y}<200)
		
	call DMove 8 224 17 ${speed} ${FightDistance}
	call DMove -11 224 -10 ${speed} ${FightDistance}
	call DMove 12 224 -17 ${speed} ${FightDistance}
	wait 20
	do
	{
		wait 10
		call IsPresent "brine wyvern"
	}
	while (!${Return})
	
	call TanknSpank "brine wyvern"
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	call DMove 5 224 -27 3
	do
	{
		call ActivateVerb "Sphere of Coalesced Water" 5 224 -27 "Release the Sphere"
		wait 20
		call ActivateVerb "Sphere of Coalesced Water" 5 224 -27 "Gather"
		wait 20
		call IsPresent "Sphere of Coalesced Water" 20
	}
	while (${Return})
	
	call DMove -18 224 21 3
	
	do
	{
		call ActivateVerbOnPhantomActor "Entrance"
		wait 50
	}
	while (${Me.Loc.Y}>200)
	
	call StopHunt
	wait 100
	call DMove 37 35 28 3
	call DMove 36 35 11 3
	call DMove 30 35 22 3
	do
	{
		call ActivateVerbOnPhantomActor "Return to Coliseum of Valor"
		wait 50
	}
	while (${Zone.Name.Equal["Brackish Vaults [Solo]"]})
	
}
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	;echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
	if (${Message.Find["been teleported to a safe location"]} > 0)
	{
		echo I am a boulet
	}
}