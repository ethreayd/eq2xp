#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=9
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
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 50 ${speed} 

		
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Plane of Innovation: Gears in the Machine [Solo]"
	
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_ActorStanceChange]:AttachAtom[StanceChange]

	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_moveinfront","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	
	call check_quest "Legacy of Power: An Innovative Approach"
	
	if (${stepstart}==0 && !${Return})
	{
		call IsPresent "Repair Bot 5000" 1000
		if (!${Return})
		{
			stepstart:Set[2]
			call IsPresent "Powered Mechanization" 1000
			if  (!${Return})
			{
				call IsPresent "Toa the Shiny" 1000
				if  (!${Return})
				{
					call IsPresent "The Junk Beast" 1000
					if  (!${Return})
					{
						call IsPresent "The Manaetic Behemoth" 1000
						if  (!${Return})
						{
							echo zone empty :( EXITING
							OgreBotAPI:Special["${Me.Name}"]
							stepstart:Set[99]
							return
						}
						else
						{
							stepstart:Set[5]
							call step002
						}
					}
				}
			}
		}
	}
	
	
	echo doing step ${stepstart} to ${stepstop}
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Zone reached
}

function step000()
{
	eq2execute merc resume

	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	wait 20
	call DMove 109 -10 142 ${speed} ${FightDistance}
	call DMove 116 3 3 ${speed} ${FightDistance}
	call DMove 78 3 -42 ${speed} ${FightDistance}
}
function step001()
{
	variable string Named
	
	Named:Set["Repair Bot 5000"]
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","TRUE"]
	
	call DMove 36 4 -31 ${speed} ${FightDistance}
	wait 100
	call Hunt "${named}" 50 1 TRUE
	wait 100
	call CheckCombat
	do
	{
		wait 10
		call IsPresent "${named}"
	}
	while (${Return})
	eq2execute summon
	wait 20
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 113 3 -29 ${speed} ${FightDistance}
	call DMove 111 -10 131 ${speed} ${FightDistance}
	call DMove -9 -10 144 ${speed} ${FightDistance}
}
function step002()
{
	variable string Named
	
	Named:Set["Powered Mechanization"]
	
	eq2execute merc resume
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	
	call DMove -66 -10 99 ${speed} ${FightDistance}
	call DMove -50 3 25 ${speed} ${FightDistance}
	call DMove -31 3 -87 ${speed} ${FightDistance}
	call DMove -28 3 -98 ${speed} ${FightDistance}
	wait 30
	call DMove -28 3 -98 ${speed} ${FightDistance}
	
	call AutoPassDoor "Junkyard East Door 01" -27 3 -112
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","TRUE"]
	wait 20
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]

	call DMove -1 4 -116 ${speed} ${FightDistance}
	
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	eq2execute summon
	wait 20
}

function step003()
{
	variable string Named
	Named:Set["Toa the Shiny"]
	
	eq2execute merc resume
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
		
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]

	call DMove -44 4 -111 3 ${FightDistance}
	call OpenDoor "Junkyard East Door 03"
	call DMove -55 3 -111 3 ${FightDistance}
	call DMove -94 4 -108 ${speed} ${FightDistance}
	call DMove -121 3 -93 ${speed} ${FightDistance}
	call DMove -128 4 -35 ${speed} ${FightDistance}
	
	call check_quest "Legacy of Power: An Innovative Approach"
	if (${Return})
	{
		do
		{
			call ActivateVerb "Magnetic	Ether Compensator" -128 4 -35 "Gather" TRUE
			wait 20
			call CheckQuestStep 5
		}
		while (!${Return})
	}
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call DMove -161 4 -81 2 ${FightDistance}
	call DMove -175 4 -96 ${speed} ${FightDistance}
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove -191 4 -143 ${speed} ${FightDistance}
	call DMove -193 4 -184 ${speed} ${FightDistance}
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]

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
}

function step004()
{

	variable string Named
	Named:Set["The Junk Beast"]
	
	eq2execute merc resume
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
		
	call StopHunt
	
	call DMove -158 4 -198 3 ${FightDistance}
	call DMove -159 7 -197 1
	call AutoPassDoor "Junkyard East Door 04" -137 4 -197
	call DMove -137 4 -197 3 ${FightDistance}
	call AutoPassDoor "Junkyard East Door 05" -130 4 -199
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove -63 5 -200 3 ${FightDistance}
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	
	call DMove -48 4 -186 ${speed} ${FightDistance}
	call DMove -19 12 -170 ${speed}	${FightDistance}
	
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	eq2execute summon
	
	call ActivateVerb "Maelin's Talismanic Whirlgurt" -19 12 -170 "Gather" TRUE
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call StopHunt
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -130 4 -197 2 ${FightDistance}
	call AutoPassDoor "Junkyard East Door 05" -155 4 -196
	wait 50
	call AutoPassDoor "Junkyard East Door 04" -166 4 -196
	call DMove -188 4 -107 3 ${FightDistance}
	call DMove -153 3 -72 3 ${FightDistance}
	call DMove -74 3 -111 3 ${FightDistance}
	call DMove -47 4 -111 3 ${FightDistance}
	call AutoPassDoor "Junkyard East Door 03" -18 4 -110
}
	
function step005()
{		
	eq2execute merc resume

	call DMove -17 4 -121 3 ${FightDistance}
	call DMove -15 4 -126 3 ${FightDistance}
	call Converse "Meldrath the Marvelous" 12
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step006()
{	
	variable string Named
	variable float nb=-1
	Named:Set["Manaetic Behemoth"]
	call StopHunt
	eq2execute merc resume
	call DMove -16 4 -117 3 ${FightDistance}
	call DMove 5 4 -122 3 ${FightDistance}
	call AutoPassDoor "Junkyard East Door 02" 25 4 -122
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 26 4 -180 2 ${FightDistance}
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","FALSE"]
	
	oc !c -CampSpot ${Me.Name}
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 0 0 -60
	
	Ob_AutoTarget:AddActor["prodding gearlet",0,FALSE,FALSE]
	Ob_AutoTarget:AddActor["clockwork scanner",0,FALSE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,FALSE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	do
	{
		wait 10
	}
	while (!${Me.InCombatMode})

	do
	{
		wait 10
		echo Avoid Red Circles function launched
		call AvoidRedCircles 30
		call IsPresent "${Named}" 200
	}
	while (${Return})
	
	call PKey "ZOOMOUT" 20	
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	oc !c -letsgo ${Me.Name}
	
}	
	
function step007()
{	
	variable string Named
	Named:Set["Glitching clockwork"]
	call StopHunt
	call check_quest "Legacy of Power: An Innovative Approach"
	echo ${Return}
	if (${Return})
	{
		eq2execute merc resume	
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
		call DMove 25 21 -287 ${speed} ${FightDistance}
	
		Ob_AutoTarget:AddActor["${Named}",0,FALSE,FALSE]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
		wait 200
		call CheckCombat ${FightDistance}
		call Converse "The Great Gear" 16 TRUE
		do
		{
			wait 10
			call IsPresent "${Named}"
		}
		while (!${Return})
		if (!${Me.Archetype.Equal["fighter"]})
			OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","TRUE"]
		do
		{
			wait 10
			call IsPresent "The Great Gear"
		}
		while (${Return})
	
		eq2execute summon
		call StopHunt
	}
}

function step008()
{	
	call check_quest "Legacy of Power: An Innovative Approach"
	if (${Return})
	{
		call DMove 46 4 -191 3 ${FightDistance}
		call ActivateVerb "Gyro-stabilized Sorcerous Generator" 46 4 -191 "Gather" TRUE
		OgreBotAPI:AcceptReward["${Me.Name}"]
		call DMove 26 4 -212 3 ${FightDistance}
		call DMove 23 4 -123 3 ${FightDistance}
		call DMove 12 4 -122 1 ${FightDistance}
		call OpenDoor "Junkyard East Door 02"
		call DMove 8 4 -121 3 ${FightDistance}
		call DMove -16 4 -110 3 ${FightDistance}
		call DMove -16 4 -122 2 ${FightDistance}
		call Converse "Meldrath the Marvelous" 16 
		OgreBotAPI:AcceptReward["${Me.Name}"]
	}
}
function step009()
{
	call check_quest "Legacy of Power: An Innovative Approach"
	if (${Return})
	{
		call DMove 8 4 -121 3 ${FightDistance}
		call OpenDoor "Junkyard East Door 02"
		call DMove 25 4 -122 3 ${FightDistance}
	}
	call DMove 26 4 -230 3 ${FightDistance}
	call ActivateVerb "zone_to_valor" 26 4 -230 "Coliseum of Valor" TRUE
	OgreBotAPI:Special["${Me.Name}"]
}

atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
 {
	;echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
    if (${Message.Find["gains an electric charge"]} > 0)
	{
		target ${Me.Name}
		QueueCommand call TargetAfterTime "${Speaker}" 200
	}
 }
atom StanceChange(string ActorID, string ActorName, string ActorType, string OldStance, string NewStance, string TargetID, string Distance, string IsInGroup, string IsInRaid)
{
    if (${NewStance.Equal["DEAD"]})
	{
		echo "I am dead"
	}
}