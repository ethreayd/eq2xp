#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool NoShinyGlobal
variable(script) bool ExpertZone

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=6
	variable bool Branch
	oc !c -resume
	oc !c -letsgo
	
	call StopHunt
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
	echo speed set to ${speed}
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call isExpert "${Zone.Name}"
	ExpertZone:Set[${Return}]
	call waitfor_Zone "Solusek Ro's Tower: The Obsidian Core" TRUE
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
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_setup_moveintomeleerangemaxdistance",25]
	
	oc !c -UplinkOptionChange All checkbox_settings_loot FALSE
	oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_loot TRUE
	if (${ExpertZone})
		oc !c -UplinkOptionChange All checkbox_settings_forcenamedcatab TRUE
	echo setting speed at ${speed}/3 and Fight Distance at ${FightDistance}m
	oc !c -OgreFollow All ${Me.Name}
	call IsPresent "Operator of Fire" 65
	if (${Return} && ${stepstart}<1)
	{
		call ResetLift
	}
	if (${stepstart}==0)
	{
		call IsPresent "Cindrax" 500
		if (!${Return})
		{
			stepstart:Set[1]
		}
	}
	call StartQuest ${stepstart} ${stepstop} TRUE
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["Cindrax"]
	
	oc !c -UplinkOptionChange Not:${Me.Name} checkbox_settings_movemelee FALSE
	oc !c -UplinkOptionChange Not:${Me.Name} checkbox_settings_movebehind FALSE
	oc !c -UplinkOptionChange Not:${Me.Name} checkbox_settings_moveinfront FALSE
	
	oc !c -ofol---
	oc !c -ofol---
	oc !c -ofol---
	
	call StopHunt
	call DMove 0 -6 -40 3 30 FALSE FALSE 5
	wait 20
	call DMove 0 -6 -50 3 30 TRUE FALSE 5
	oc !c -CampSpot 
	oc !c -joustout
	;Ob_AutoTarget:AddActor["construct of flames",0,TRUE,FALSE]
	;Ob_AutoTarget:AddActor["Solitude",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	wait 20
	call CheckCombat
	oc !c -letsgo
	call DMove 21 -6 -57 ${speed} ${FightDistance} TRUE
	wait 20
	oc !c -CampSpot 
	oc !c -joustout
	call CheckCombat
	oc !c -letsgo
	call DMove 24 -6 -53 ${speed} ${FightDistance} TRUE
	wait 20
	oc !c -CampSpot 
	oc !c -joustout
	call CheckCombat
	wait 50
	
	oc !c -CS_Set_ChangeRelativeCampSpotBy All 0 0 -49
	wait 100
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",40]
	call TanknSpank "${Named}"
	wait 20
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	oc !c -AcceptReward
	eq2execute summon
	wait 50
	oc !c -AcceptReward
	wait 20
	oc !c -letsgo
	call Loot
	call DMove 9 -6 -100 2 30 TRUE TRUE 
	call DMove 22 -6 -102 3 30 TRUE TRUE
	call DMove 99 -6 -102 3 30 TRUE TRUE
	
	call OpenDoor "Door - Floor 1 Right 1"
	call OpenDoor "Door - Floor 1 Left 1"
	
	wait 50
	
	call DMove 22 -6 -102 3 30 TRUE TRUE
	call DMove 21 -6 -55 3 30 TRUE TRUE
	call DMove 0 -6 -55 3 30 TRUE 
	call DMove -21 -6 -54 3 30 TRUE
	call DMove -23 -6 -105 3 30 TRUE 
	oc !c -CampSpot 
	oc !c -joustout
	call CheckCombat
	wait 20
	oc !c -letsgo
	call DMove -21 -6 -54 3 30 TRUE
	call DMove 0 -6 -55 3 30 TRUE
	call DMove 0 -6 3 3 30 TRUE
	call StopHunt
	call GroupDistance
	if (${Return}>20)
	{
		echo Debugging group apart issue
		oc !c -letsgo
		oc !c -Revive All 0
		wait 100
		oc !c -letsgo
		oc !c -Come2Me ${Me.Name} All 3
		wait 20
		oc !c -letsgo
		wait 20
	}
	call GroupDistance
	if (${Return}>20)
	{
		oc !c -Evac
		wait 100
		oc !c -letsgo
		oc !c -Come2Me ${Me.Name} All 3
		wait 20
		oc !c -letsgo
		wait 20
	}
	call GroupDistance
	if (${Return}>20)
	{
		do
		{
			oc !c -pause
			wait 600
			oc !c -Revive All 0
			wait 100
			call GroupDistance
		}
		while (${Return}>20)
		oc !c -resume
	}
	
}	

function step001()
{
	if ${Script["autoshinies"](exists)}
		Script[autoshinies]:Pause
		
	call DMove 0 -7 -77 2 30 TRUE TRUE 3
	call Converse "Operator of Fire" 2
	wait 250
}	
	
function step002()
{
	variable string Named
	Named:Set["The Molten Behemoth"]
; Must do the correct fight
	call IsPresent "${Named}" 500
	if (${Return})
	{
		call DMove -1 -120 -120 3
		call DMove 0 -122 -137 3
		oc !c -UplinkOptionChange All checkbox_settings_loot FALSE
		oc !c -UplinkOptionChange ${Me.Group[5].Name} checkbox_settings_loot TRUE
		oc !c -CampSpot 
		oc !c -joustout
		call StartHunt "magma slug"
		wait 20
		call CheckCombat
		oc !c -letsgo
		call DMove 0 -122 -151 3 30 TRUE TRUE 3
		oc !c -CampSpot 
		oc !c -joustout
		wait 20
		call CheckCombat
		oc !c -letsgo
		call DMove 33 -122 -154 3 30 TRUE TRUE 3
		oc !c -CampSpot 
		oc !c -joustout
		wait 20
		call CheckCombat
		oc !c -letsgo
		call DMove 49 -122 -158 3 30 TRUE TRUE 3
		oc !c -CampSpot 
		oc !c -joustout
		wait 20
		call CheckCombat
		oc !c -letsgo
		call DMove 53 -122 -147 3 30 TRUE TRUE 3
		oc !c -CampSpot 
		oc !c -joustout
		wait 20
		call CheckCombat
		oc !c -letsgo
		call DMove 65 -122 -157 3 30 TRUE TRUE 3
		oc !c -CampSpot 
		oc !c -joustout
		wait 20
		call CheckCombat
		oc !c -letsgo
		call DMove 64 -121 -177 2 30 TRUE TRUE 3
		relay is6 run EQ2Ethreayd/SRTTOC_C1
		oc !c -CampSpot 
		oc !c -joustout 
		oc !c -CS_Set_ChangeRelativeCampSpotBy All 0 0 -30
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
		
		Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
		
		echo must kill "${Named}"
		target "${Named}"
		do
		{
			wait 10
			ExecuteQueued
			call IsPresent "${Named}"
		}
		while (${Return})
		oc !c -UplinkOptionChange All checkbox_settings_loot FALSE
		oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_loot TRUE
		relay is6 end SRTTOC_C1
		call PKey MouseWheelDown 20
		oc !c -resume
		wait 20
		oc !c -AcceptReward
		eq2execute summon
		wait 50
		oc !c -AcceptReward
		wait 20
		oc !c -letsgo
		call Loot
		call DMove 64 -122 -168 3
		call DMove 62 -122 -156 3
		call DMove 3 -122 -153 3
		call DMove -1 -120 -121 3
		call DMove 0 -121 -78 3
	}
	call StopHunt
	call MoveCloseTo "Operator of Fire"
	OgreBotAPI:HailNPC["${Me.Name}","Operator of Fire"]
	wait 30
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 250
}

function step003()
{
	variable string mob
	variable bool isNamed
	variable string Named
	Named:Set["Balrezu"]
	mob:Set["scorched fiend"]
	
	call IsPresent "Verlixa" 5000
	if (!${Return})
	{
		echo recentering toons
		call DMove -3 -137 -82 1 30 FALSE FALSE 2
		oc !c -Come2Me ${Me.Name} All 3
		wait 20
		oc !c -letsgo
		call DMove 24 -137 -55 3 30 TRUE TRUE 5
		oc !c -Come2Me ${Me.Name} All 3
		wait 20
		oc !c -letsgo
		
		Ob_AutoTarget:AddActor["${mob}",0,TRUE,FALSE]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		call DMove 44 -138 -38 ${speed} ${FightDistance}
		call DMove 47 -139 -23 ${speed} ${FightDistance}
		call DMove 36 -139 -2 ${speed} ${FightDistance}
		call DMove 9 -139 17 ${speed} ${FightDistance}
		call DMove 24 -137 39 ${speed} ${FightDistance}
		
		call StopHunt
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
		call DMove 42 -138 62 3 TRUE FALSE 10
		oc !c -CampSpot 
		oc !c -joustout
		oc !c -MarkToon ${Me.Group[5].Name}
		eq2execute gsay Set up for ${Named}
		oc !c -SetUpFor
		Ob_AutoTarget:AddActor["${mob}",0,TRUE,FALSE]
		Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
		echo must kill "${Named}"
		OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",50]
		do
		{
			wait 10
			call IsPresent "${mob}"
		}
		while (${Return})
		wait 100
		target ${Named}
		wait 100
		do
		{
			wait 10
			call IsPresent "${Named}"
		}
		while (${Return} || ${Me.InCombatMode})
		OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
		wait 20
		oc !c -AcceptReward
		eq2execute summon
		wait 50
		oc !c -AcceptReward
		wait 20
		oc !c -letsgo 
		call Loot
		call StopHunt
		if ${Script["autoshinies"](exists)}
			Script[autoshinies]:Resume
		call DMove 42 -138 61 3
		call DMove 26 -137 43 3
		call DMove 8 -138 22 3
		call DMove 14 -139 6 3
		call DMove 42 -139 12 3
		call DMove 38 -137 -42 3
		if ${Script["autoshinies"](exists)}
			Script[autoshinies]:Pause
		call DMove 22 -136 -58 3
		call DMove 1 -137 -77 3
	}	
	call MoveCloseTo "Operator of Fire"
	OgreBotAPI:HailNPC["${Me.Name}","Operator of Fire"]
	wait 30
	OgreBotAPI:ConversationBubble["${Me.Name}",3]
	wait 250
}
function step004()
{
	variable string Named
	Named:Set["Verlixa"]
	call StopHunt
	
	call IsPresent "${Named}"
	if (${Return})
	{
		call DMove 2 -156 -80 1 30 FALSE FALSE 2
		wait 20
		oc !c -Come2Me ${Me.Name} All 3
		wait 20
		oc !c -letsgo
		oc !c -OgreFollow All ${Me.Name}
		oc !c -ofol---
		oc !c -ofol---
		oc !c -ofol---
		call DMove -4 -156 -73 2 30 FALSE FALSE 2
		wait 20
		call DMove 2 -156 -80 1 30 FALSE FALSE 2
		wait 20
		call DMove -19 -155 -59 2 30 TRUE TRUE 5
		oc !c -Come2Me ${Me.Name} All 3
		wait 20
		oc !c -letsgo
		
		call DMove -28 -155 -51 3 30 TRUE FALSE 5
		relay all Me.Inventory["Obsidian Sun Disc"]:Use
		call DMove -40 -156 -41 3
		do
		{
			wait 10
		}
		while (${Me.Health}<90)
		call DMove -64 -157 -28 3
		do
		{
			wait 10
		}
		while (${Me.Health}<90)
		call DMove -84 -157 -44 3
		call DMove -103 -157 -62 3
		do
		{
			wait 10
		}
		while (${Me.Health}<99)
		call DMove -116 -157 -49 ${speed} ${FightDistance}
		call DMove -130 -157 -35 ${speed} ${FightDistance}
		call StopHunt
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
		call DMove -140 -157 -26 3
		oc !c -CampSpot 
		oc !c -joustout 
		oc !c -MarkToon ${Me.Group[5].Name}
		eq2execute gsay Set up for ${Named}
		oc !c -SetUpFor
		Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
		echo must kill "${Named}"
		target "${Named}"
		do
		{
			wait 10
			call IsPresent "${Named}"
		}
		while (${Return} || ${Me.InCombatMode})
		wait 20
		oc !c -AcceptReward
		eq2execute summon
		wait 50
		oc !c -AcceptReward
		wait 20
		oc !c -letsgo
		call Loot
		if ${Script["autoshinies"](exists)}
			Script[autoshinies]:Resume
		call StopHunt
	
		call DMove -125 -156 -40 3
		call DMove -105 -158 -60 3
		if ${Script["autoshinies"](exists)}
			Script[autoshinies]:Pause
		call DMove -67 -157 -32 3
		call DMove -39 -157 -40 3
		call DMove 0 -156 -77 3
	}	
	call MoveCloseTo "Operator of Fire"

	OgreBotAPI:HailNPC["${Me.Name}","Operator of Fire"]
	wait 30
	OgreBotAPI:ConversationBubble["${Me.Name}",4]
	wait 250
}
	
function step005()
{
	variable string Named
	Named:Set["Galremos"]
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	Ob_AutoTarget:Clear
	Ob_AutoTarget:AddActor["living obsidian",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	call DMove -1 -178 -109 ${speed} ${FightDistance}
	
	do
	{
		wait 10
		call MoveCloseTo "a mass of living obsidian"
		call IsPresent "${Named}" 500
	}
	while (!${Return})
	call DMove -1 -178 -109 ${speed} ${FightDistance}
	echo must kill "${Named}"
	wait 100
	target "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}" 500
	}
	while (${Return})
	
	oc !c -AcceptReward
	eq2execute summon
	wait 50
	oc !c -AcceptReward
	oc !c -letsgo
	oc !c -AcceptReward
	call Loot

	if ${Script["autoshinies"](exists)}
		Script[autoshinies]:Resume
}

function step006()
{
	call StopHunt
	{
		call ActivateVerb "zone_to_valor" 0 -178 -112 "Coliseum of Valor" TRUE
		oc !c -Special
		wait 300
	}
}

function ReturnToPosition()
{
	wait 300 
	oc !c -CS_Set_ChangeRelativeCampSpotBy All 0 0 -30
}
function ResetLift()
{
	call DMove 1 -6 -50 2
	call Converse "Operator of Fire" 2
	call DMove 0 -6 0 3
	wait 200
}


atom HandleAllEvents(string Message)
 {
	if (${Message.Find["expelling molten rocks"]} > 0)
	{
		oc !c -CS_Set_ChangeRelativeCampSpotBy All 0 0 30
	}
	if (${Message.Find["searing hot magma"]} > 0)
	{
		oc !c -CS_Set_ChangeRelativeCampSpotBy All 0 0 -30
	}
 }
 atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	if (${Message.Find["eathMate!!!"]} > 0)
	{
		echo group seems dead - restarting zone
		do
		{
			if (${Script["RestartZone"}](exists)})
				endscript RestartZone
		}
		while (${Script["RestartZone"}](exists)})
		runscript EQ2Ethreayd/RestartZone 0 0 ${speed} ${NoShinyGlobal}
	}
	if (${Message.Find["t see target"]} > 0 || ${Message.Find["oo far away"]} > 0)
	{
		 oc !c -Come2Me ${Me.Name} ${Speaker} 3
	}
}