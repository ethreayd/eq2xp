#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

variable(script) int speed
variable(script) int FightDistance
variable(script) bool NoShinyGlobal
variable(script) bool ExpertZone

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{
	variable int laststep=4
	variable int count
	relay all ogre
	wait 200
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
	if (!${Script["ToonAssistant"](exists)})
		relay all run EQ2Ethreayd/ToonAssistant
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	if (${setspeed}==0)
		speed:Set[3]
	else
		speed:Set[${setspeed}]
		
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	if (${NoShiny})
		NoShinyGlobal:Set[TRUE]
		
	echo zone is ${Zone.Name}
	call isExpert "${Zone.Name}"
	ExpertZone:Set[${Return}]
	call waitfor_Zone "Plane of Disease: Infested Mesa" TRUE
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	
	oc !c -UplinkOptionChange All checkbox_settings_loot FALSE
	oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_loot TRUE
	if (${ExpertZone})
		oc !c -UplinkOptionChange All checkbox_settings_forcenamedcatab TRUE
	echo setting speed at ${speed}/3 and Fight Distance at ${FightDistance}m
	oc !c -OgreFollow All ${Me.Name}

	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	call StopHunt
	wait 20
	call DMove 30 246 -54 3
	wait 50
	call DMove -25 241 -55 3 30 TRUE
	oc !c -Come2Me ${Me.Name} All 3
	call DMove -55 252 -54 3 30 TRUE
	oc !c -Come2Me ${Me.Name} All 3
	call DMove -102 248 -55 3 30 TRUE
	oc !c -Come2Me ${Me.Name} All 3
	call DMove -166 240 -53 3 30 TRUE
	oc !c -Come2Me ${Me.Name} All 3
	
	if (!${Actor[Grimror].IsAggro})
	{
		call CheckCombat
		wait 100
		call GroupDistance
		if (${Return}>30)
		{
			oc !c -Revive All 0
			oc !c -Evac
			wait 600
			call step000
		}
	}
}
function step001()
{
	variable string Named
	variable int Counter
	Named:Set["Deathbone"]
	Ob_AutoTarget:AddActor["a bone parasite",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["a deadly contagion",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["a marrow worm",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Deathbone",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["pus-filled boil",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["a pusling mucoid",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["The Carrion Walker",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["a revenant of death",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Grimror",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call IsPresent "The Carrion Walker"
	if (!${Actor[Grimror].IsAggro} || ${Return})
	{
		oc !c -SetUpFor
		echo Grimror not here going to Deathbone step
		call DMove -188 240 -69 3 TRUE
		wait 20
		call IsPresent "pus-filled boil"
		if (!${Return})
			call CheckCombat
		call DMove -156 240 -50 3 TRUE
		call IsPresent "pus-filled boil"
		if (!${Return})
			call CheckCombat
		call DMove -199 242 -32 3 TRUE
		call IsPresent "pus-filled boil"
		if (!${Return})
			call CheckCombat
		
		oc !c -cs-jo-ji All Casters
		oc !c -SetUpFor
		oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_movemelee TRUE
		wait 100
		call IsPresent "pus-filled boil"
		if (!${Return})
			call CheckCombat
		do
		{
			wait 10
			call IsPresent "${Named}"
			Counter:Inc
			echo waiting for "${Named}" ${Counter}/200
		}
		while (!${Return} && ${Counter}<200)
		wait 100
		do
		{
			wait 10
			call IsPresent "${Named}"
		}
		while (${Return})
		oc !c -acceptreward
		oc !c -acceptreward
		eq2execute summon
		oc !c -acceptreward
		oc !c -joustin
		call Loot
		wait 50
		call DMove -199 242 -32 3 30 TRUE
	}
}	

function step002()
{
	variable string Named
	variable int Counter
	Named:Set["The Carrion Walker"]
	call IsPresent "${Named}"
	if (!${Actor[Grimror].IsAggro} || ${Return})
	{
		echo Grimror not here going to Carrion step
		oc !c -letsgo
		oc !c -OgreFollow All ${Me.Name}
	
		call DMove -147 265 -21 3 30 TRUE
		do
		{
			wait 100
			call IsPresent "pus-filled boil" 15
		}
		while (${Return})
		call DMove -191 256 9 3 30 TRUE
		do
		{
			wait 100
			call IsPresent "pus-filled boil" 15
		}
		while (${Return})
		oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_movemelee FALSE
		call DMove -200 242 -27 3 30 TRUE
		call DMove -224 240 16 3 30 TRUE
		call DMove -242 238 7 3 30 TRUE
		call DMove -250 249 -18 3 30 TRUE
		oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_movemelee TRUE
		do
		{
			wait 100
			call IsPresent "pus-filled boil" 15
		}
		while (${Return})
		call DMove -251 251 -50 3 30 TRUE
		do
		{
			wait 100
			call IsPresent "pus-filled boil" 15
		}
		while (${Return})
		oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_movemelee FALSE
		call DMove -241 244 -6 3 30 TRUE
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","FALSE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","FALSE"]
		do
		{
			wait 100
			call IsPresent "pusling mucoid" 15
		}
		while (${Return})
		call DMove -237 240 18 3 30 TRUE
		do
		{
			wait 100
			call IsPresent "pusling mucoid" 15
		}
		while (${Return})
		call DMove -198 241 -36 3 30 TRUE
		do
		{
			wait 100
			call IsPresent "pusling mucoid" 15
		}
		while (${Return})
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
		call DMove -198 241 -36 3 
	}
	call DMove -198 241 -36 3 30 TRUE
	oc !c -CampSpot
	if (!${Actor[Grimror].IsAggro})
	{
		call IsPresent "${Named}"
		if (!${Return})
		{
			wait 100
			call CheckCombat
		}
		do
		{
			wait 10
			call IsPresent "${Named}"
			Counter:Inc
			echo waiting for "${Named}" ${Counter}/100
		}
		while (!${Return} && ${Counter}<100)
		oc !c -SetUpFor
		wait 100
		
		call IsPresent "${Named}"
		if (!${Return})
		{
			oc !c -letsgo
			call step002
		}
		do
		{
			wait 10
			call IsPresent "${Named}"
		}
		while (${Return})
		oc !c -acceptreward
		oc !c -acceptreward
		eq2execute summon
		oc !c -acceptreward
		wait 50
	}
}

function step003()
{
	variable string Named
	variable int Counter
	oc !c -ChangeCastStackListBoxItemByTag ALL wards TRUE
	Named:Set["Grimror"]
	call StopHunt
	Ob_AutoTarget:AddActor["Grimror",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	eq2execute gsay Set up for ${Named}
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",40]
	wait 100
	do
	{
		wait 10
		Counter:Inc
		echo waiting for "${Named}" ${Counter}/200
		call IsPresent "${Named}"
	}
	while (!${Return} && ${Counter}<200)
	oc !c -joustout
	wait 100
	
	oc !c -SetUpFor
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	oc !c -ChangeCastStackListBoxItemByTag ALL wards FALSE
	oc !c -acceptreward
	oc !c -acceptreward
	eq2execute summon
	oc !c -acceptreward
	oc !c -letsgo
	call Loot
	wait 50
	call Loot
}

function step004()
{
	if (!${NoShinyGlobal})
		run EQ2Ethreayd/autoshinies 100 ${speed} 
	wait 100
	
	relay all ogre
	wait 200
	oc !c -Evac
	wait 200
	oc !c -letsgo
	oc !c -OgreFollow All ${Me.Name}
	oc !c -ofol---
	oc !c -ofol---
	oc !c -ofol---
	
	do
	{
		if (!${Zone.Name.Equal["Coliseum of Valor"]})
		{
			call MoveCloseTo "Zone Exit"
			oc !c -Zone	
		}
		wait 200
	}
	while (!${Zone.Name.Equal["Coliseum of Valor"]})
}

atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
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
	if (${Message.Find["t see target"]} > 0 || ${Message.Find["oo far away"]} > 0)
	{
		 oc !c -Come2Me ${Me.Name} ${Speaker} 3
	}
}