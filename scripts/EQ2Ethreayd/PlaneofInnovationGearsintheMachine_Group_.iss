#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool NoShinyGlobal
variable(script) bool ExpertZone

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=7
	oc !c -letsgo
	if ${Script["livedierepeat"](exists)}
		endscript livedierepeat
	if (!${Script["deathwatch"](exists)})
		run EQ2Ethreayd/deathwatch
	if (${setspeed}==0)
	{
		speed:Set[3]
		FightDistance:Set[30]
	}
	else
		speed:Set[${setspeed}]
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	if (!${Script["ToonAssistant"](exists)})
		relay all run EQ2Ethreayd/ToonAssistant

	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 50 ${speed} 
	NoShinyGlobal:Set[${NoShiny}]
		
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Plane of Innovation: Gears in the Machine" TRUE
	relay all OgreBotAPI:CancelMaintained["All","Singular Focus"]
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]

	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_moveinfront","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkmana","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkmana",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_autotargetwhenhated","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	
	oc !c -UplinkOptionChange All checkbox_settings_loot FALSE
	oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_loot TRUE
	if (${ExpertZone})
		oc !c -UplinkOptionChange All checkbox_settings_forcenamedcatab TRUE
	
	if (${stepstart}==0)
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
							oc !c -Zone
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
	
	oc !c -UplinkOptionChange All checkbox_settings_loot FALSE
	oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_loot TRUE
	
	echo setting speed at ${speed}/3 and Fight Distance at ${FightDistance}m
	oc !c -OgreFollow All ${Me.Name}
	echo doing step ${stepstart} to ${stepstop}
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Zone reached
}

function step000()
{
	
	call StopHunt
	wait 20
	call DMove 109 -10 142 ${speed} ${FightDistance}
	call DMove 116 3 3 ${speed} ${FightDistance}
	call DMove 78 3 -42 ${speed} ${FightDistance}
}
function step001()
{
	variable string Named
	
	Named:Set["Repair Bot 5000"]
	
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
	eq2execute summon
	call StopHunt
	call Loot
	call DMove 113 3 -29 ${speed} ${FightDistance}
	call DMove 111 -10 131 ${speed} ${FightDistance}
	call DMove -9 -10 144 ${speed} ${FightDistance}
}
function step002()
{
	variable string Named
	
	Named:Set["Powered Mechanization"]

	call DMove -66 -10 99 ${speed} ${FightDistance}
	call DMove -50 3 25 ${speed} ${FightDistance}
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Pause
	call DMove -31 3 -87 ${speed} ${FightDistance}
	call DMove -28 3 -98 ${speed} ${FightDistance}
	wait 30
	call DMove -28 3 -98 ${speed} ${FightDistance}
	
	call AutoPassDoor "Junkyard East Door 01" -27 3 -112
	oc !c -Come2Me ${Me.Name} All 3
	oc !c -letsgo
	wait 20
		
	call DMove -1 4 -116 ${speed} ${FightDistance} TRUE
	oc !c -Come2Me ${Me.Name} All 3
	oc !c -letsgo
	oc !c -CampSpot ${Me.Name}
	call TanknSpank "${Named}"
	oc !c -letsgo
	eq2execute summon
	wait 20
	eq2execute summon
	call Loot
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Resume
}

function step003()
{
	variable string Named
	Named:Set["Toa the Shiny"]
	
	call StopHunt
	
	call DMove -44 4 -111 3 ${FightDistance}
	call OpenDoor "Junkyard East Door 03"
	call DMove -55 3 -111 3 ${FightDistance}
	call DMove -94 4 -108 ${speed} ${FightDistance}
	call DMove -121 3 -93 ${speed} ${FightDistance}
	call DMove -128 4 -35 ${speed} ${FightDistance}
	eq2execute summon
	call Loot
	call DMove -161 4 -81 2 ${FightDistance}
	call DMove -175 4 -96 ${speed} ${FightDistance}
		
	call DMove -191 4 -143 ${speed} ${FightDistance} TRUE
	call DMove -193 4 -184 ${speed} ${FightDistance} TRUE
	call TanknSpank "${Named}"
	eq2execute summon
	wait 20	
	eq2execute summon
	call Loot
}

function step004()
{

	variable string Named
	Named:Set["The Junk Beast"]
		
	call StopHunt
	
	call DMove -158 4 -198 3 ${FightDistance}
	call DMove -159 7 -197 1
	call AutoPassDoor "Junkyard East Door 04" -137 4 -197
	call DMove -137 4 -197 3 ${FightDistance}
	wait 20
	call AutoPassDoor "Junkyard East Door 05" -130 4 -199
	call DMove -63 5 -200 3 ${FightDistance}
	eq2execute summon
	
	call DMove -48 4 -186 ${speed} ${FightDistance} TRUE
	call DMove -19 12 -170 ${speed}	${FightDistance} TRUE
	call TanknSpank "${Named}"
	eq2execute summon
	call Loot
	wait 20
	eq2execute summon
	call StopHunt
	
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
	call DMove -17 4 -121 3 ${FightDistance}
}

function step006()
{	
	variable string Named
	variable float nb=-1
	Named:Set["Manaetic Behemoth"]
	call StopHunt
	call DMove -16 4 -117 3
	call DMove 5 4 -122 3
	call AutoPassDoor "Junkyard East Door 02" 25 4 -122
	call DMove 26 4 -180 3
	oc !c -UplinkOptionChange Not:${Me.Name} checkbox_settings_movemelee FALSE
	oc !c -UplinkOptionChange Not:${Me.Name} checkbox_settings_movebehind FALSE
	oc !c -UplinkOptionChange Not:${Me.Name} checkbox_settings_moveinfront FALSE
	oc !c -OgreFollow All ${Me.Name}
	oc !c -ofol---
	oc !c -ofol---
	oc !c -ofol---
	wait 50
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Pause
	oc !c -CampSpot
	oc !c -CS_Set_ChangeCampSpotBy All 0 0 -60
	
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
		call DetectCircles 50 design_circle_warning_zone
		echo seen ${Return} circles
		if (${Return}>0)
		{
			call GoBetweenCircles
		}
		else
		{
			if (${Me.Loc.Z}<-240)
			{
				oc !c -CS_Set_ChangeCampSpotBy All 0 0 50
				wait 40
			}
			if (${Me.Loc.Z}>-130)
			{
				oc !c -CS_Set_ChangeCampSpotBy All 0 0 -50
				wait 40
			}
		}	
		wait 5
		call IsPresent "${Named}" 200
	}
	while (${Return})
	eq2execute summon
	oc !c -letsgo
	eq2execute summon
	call Loot
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Resume
}	
	
function step007()
{	
	variable string Named
	Named:Set["Glitching clockwork"]
	call StopHunt
	
	eq2execute summon
	call Loot

	call DMove 26 4 -230 3 ${FightDistance}
	eq2execute summon
	call ActivateVerb "zone_to_valor" 26 4 -230 "Coliseum of Valor" TRUE
	oc !c -Special
}

function GoBetweenCircles()
{
	variable index:actor Actors
    variable iterator ActorIterator
	variable float R
	variable bool Moved
	
	R:Set[13]
    EQ2:QueryActors[Actors, Aura=="design_circle_warning_zone" && Distance <= ${R}]
    Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
    {
		echo Some circles not far>>>
		do
		{
			echo dealing with Circle ID ${ActorIterator.Value.ID}
			if (${Me.Loc.Z}<=${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}+${R}]} && ${Me.Loc.Z}>=${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${R}]})
			{
				echo I need to move away from ${Actor[${ActorIterator.Value.ID}].Loc.X} ${Actor[${ActorIterator.Value.ID}].Loc.Z}
				if (${Me.Loc.Z}<-260)
				{
					echo to close to border
					oc !c -CS_Set_ChangeCampSpotBy All 0 0 60
					wait 30
				}
				
				if (${Me.Loc.Z}<${Actor[${ActorIterator.Value.ID}].Loc.Z}) 
				{
					call CheckAuraLoc ${Me.Loc.X} ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${R}]} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All 0 0 ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${Me.Loc.Z}-${R}]}
						wait 20
						Moved:Set[TRUE]
					}
				}
				else
				{
					call CheckAuraLoc ${Me.Loc.X} ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}+${R}]} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All 0 0 ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${Me.Loc.Z}+${R}]}
						wait 20
						Moved:Set[TRUE]
					}
				}
				if (${Me.Loc.X}<${Actor[${ActorIterator.Value.ID}].Loc.X}) 
				{
					call CheckAuraLoc ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${R}]} ${Me.Loc.Z} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${Me.Loc.X}-${R}]} 0 0
						wait 20
						Moved:Set[TRUE]
					}
				}
				else
				{
					call CheckAuraLoc ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}+${R}]} ${Me.Loc.Z} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${Me.Loc.X}+${R}]} 0 0
						wait 20
						Moved:Set[TRUE]
					}
				}
				
				if (${Me.Loc.Z}<${Actor[${ActorIterator.Value.ID}].Loc.Z} && ${Me.Loc.X}<${Actor[${ActorIterator.Value.ID}].Loc.X})
				{
					call CheckAuraLoc ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${R}]} ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${R}]} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${Me.Loc.X}-${R}]} 0 ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${Me.Loc.Z}-${R}]}
						wait 20
						Moved:Set[TRUE]
					}
				}
				if (${Me.Loc.Z}<${Actor[${ActorIterator.Value.ID}].Loc.Z} && ${Me.Loc.X}>=${Actor[${ActorIterator.Value.ID}].Loc.X})
				{
					call CheckAuraLoc ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}+${R}]} ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${R}]} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${Me.Loc.X}+${R}]} 0 ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${Me.Loc.Z}-${R}]}
						wait 20
						Moved:Set[TRUE]
					}
				}
				if (${Me.Loc.Z}>=${Actor[${ActorIterator.Value.ID}].Loc.Z} && ${Me.Loc.X}<${Actor[${ActorIterator.Value.ID}].Loc.X}) 
				{
					call CheckAuraLoc ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${R}]} ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}+${R}]} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${Me.Loc.X}-${R}]} 0 ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${Me.Loc.Z}+${R}]}
						wait 20
						Moved:Set[TRUE]
					}
				}
				if (${Me.Loc.Z}>=${Actor[${ActorIterator.Value.ID}].Loc.Z} && ${Me.Loc.X}>=${Actor[${ActorIterator.Value.ID}].Loc.X})
				{
					call CheckAuraLoc ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}+${R}]} ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}+${R}]} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${Me.Loc.X}+${R}]} 0 ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${Me.Loc.Z}+${R}]}
						wait 20
						Moved:Set[TRUE]
					}
				}
				if (${Me.Loc.Z}<${Actor[${ActorIterator.Value.ID}].Loc.Z}) 
				{
					call CheckAuraLoc ${Me.Loc.X} ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-2*${R}]} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All 0 0 ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${Me.Loc.Z}-2*${R}]}
						wait 20
						Moved:Set[TRUE]
					}
				}
				else
				{
					call CheckAuraLoc ${Me.Loc.X} ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}+2*${R}]} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All 0 0 ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.Z}-${Me.Loc.Z}+2*${R}]}
						wait 20
						Moved:Set[TRUE]
					}
				}
				if (${Me.Loc.X}<${Actor[${ActorIterator.Value.ID}].Loc.X}) 
				{
					call CheckAuraLoc ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-2*${R}]} ${Me.Loc.Z} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${Me.Loc.X}-2*${R}]} 0 0
						wait 20
						Moved:Set[TRUE]
					}
				}
				else
				{
					call CheckAuraLoc ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}+2*${R}]} ${Me.Loc.Z} ${R} design_circle_warning_zone
					if (${Return} && !${Moved})
					{
						oc !c -CS_Set_ChangeCampSpotBy All ${Math.Calc64[${Actor[${ActorIterator.Value.ID}].Loc.X}-${Me.Loc.X}+2*${R}]} 0 0
						wait 20
						Moved:Set[TRUE]
					}
				}
			}
		}
        while (${ActorIterator:Next(exists)})
	}
}

atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	;echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
    if (${Message.Find["gains an electric charge"]} > 0)
	{
		target ${Me.Name}
		QueueCommand call TargetAfterTime "${Speaker}" 200
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
 }