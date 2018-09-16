#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

variable(script) int speed
variable(script) int FightDistance

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{
	variable int laststep=4
	variable int count
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
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	if (${setspeed}==0)
		speed:Set[3]
	else
		speed:Set[${setspeed}]
	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 100 ${speed} 
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	
	echo zone is ${Zone.Name}
	call waitfor_Zone "Plane of Disease: Infested Mesa [Expert Event]"
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	
	oc !c -UplinkOptionChange All checkbox_settings_loot FALSE
	oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_loot TRUE
	
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
	oc !c -CampSpot
	oc !c -joustin ${Me.Name}
	call DMove -25 241 -55 3 30 TRUE
	call DMove -55 252 -54 3 30 TRUE
	wait 20
	call DMove -25 241 -55 3 30 TRUE
	call DMove 15 245 -54 2 30 TRUE
	wait 50
	call CheckCombat
	oc !c -letsgo
	call DMove -25 241 -55 2 30 TRUE
	oc !c -Come2Me ${Me.Name} All 3
	call DMove -55 252 -54 2 30 TRUE
	oc !c -Come2Me ${Me.Name} All 3
	call DMove -102 248 -55 2 30 TRUE
	oc !c -Come2Me ${Me.Name} All 3
	call DMove -166 240 -53 3 30 TRUE
	oc !c -Come2Me ${Me.Name} All 3
	call CheckCombat
}
function step001()
{
	variable string Named
	Named:Set["Deathbone"]
	Ob_AutoTarget:AddActor["a bone parasite",0,TRUE,FALSE]
	call DMove -188 240 -69 3
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	wait 20
	call DMove -156 240 -50 3
	call DMove -199 242 -32 3
	oc !c -cs-jo-ji All Casters
	Ob_AutoTarget:AddActor["a deadly contagion",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_movemelee TRUE
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
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

function step002()
{
	variable string Named
	Named:Set["The Carrion Walker"]
	
	Ob_AutoTarget:AddActor["pus-filled boil",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["a pusling mucoid",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
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
	call DMove -237 240 18 3 30 TRUE
	call DMove -198 241 -36 3 30 TRUE
	call DMove -198 241 -36 3 
	oc !c -CampSpot
	
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
	wait 100
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	
	Ob_AutoTarget:AddActor["a revenant of death",0,TRUE,FALSE]
	
	oc !c -acceptreward
	oc !c -acceptreward
	eq2execute summon
	oc !c -acceptreward
	wait 50
}

function step003()
{
	variable string Named
	Named:Set["Grimror"]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	eq2execute gsay Set up for ${Named}
	
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
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
	oc !c -letsgo
	call Loot
	wait 50
	call Loot
}

function step004()
{
	relay all ogre
	wait 200
	oc !c -Evac
	oc !c -OgreFollow All ${Me.Name}
	call DMove 101 250 -93 3
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
}