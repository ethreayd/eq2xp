#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=6
	variable bool Branch
	
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
		if (!${NoShiny})
			run EQ2Ethreayd/autoshinies 50 ${speed}
	echo speed set to ${speed}
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Solusek Ro's Tower: The Obsidian Core [Solo]"

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
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",50]
	call DMove 0 -6 -51 ${speed} ${FightDistance}
	Ob_AutoTarget:AddActor["construct of flames",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Solitude",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove 21 -6 -57 ${speed} ${FightDistance}
	call DMove 24 -6 -53 ${speed} ${FightDistance}
	
	oc !c -CampSpot ${Me.Name}
	oc !c -joustout ${Me.Name}
	
	oc !c -CS_Set_ChangeRelativeCampSpotBy ${Me.Name} 0 0 -49
	wait 20
	call TanknSpank "${Named}"
	wait 20
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	oc !c -letsgo ${Me.Name}
	call DMove 9 -6 -100 2
	call DMove 22 -6 -102 ${speed} ${FightDistance}
	call DMove 99 -6 -102 3
	
	call OpenDoor "Door - Floor 1 Right 1"
	call OpenDoor "Door - Floor 1 Left 1"
	
	wait 50
	
	call DMove 22 -6 -102 3
	call DMove 21 -6 -55 3
	call DMove 0 -6 -55 3
	call DMove 0 -6 3 3
}	

function step001()
{
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]

	call DMove 0 -6 -55 2
	call DMove 0 -7 -77 1
	call Converse "Operator of Fire" 2
	if (!${NoShiny})
		Script[autoshinies]:Pause
	wait 250
}	
	
function step002()
{
	variable string Named
	Named:Set["The Molten Behemoth"]

	call IsPresent "${Named}" 500
	if (${Return})
	{
		eq2execute merc resume
		call DMove -1 -120 -120 3
		call DMove 0 -122 -151 ${speed} ${FightDistance}
		call DMove 7 -122 -154 ${speed} ${FightDistance}
		call DMove 27 -122 -154 ${speed} ${FightDistance}
		call DMove 33 -122 -154 ${speed} ${FightDistance}
		call DMove 38 -122 -158 ${speed} ${FightDistance}
		call DMove 56 -122 -148 ${speed} ${FightDistance}
		call DMove 66 -122 -159 ${speed} ${FightDistance}
		call DMove 64 -122 -172 1
		eq2execute merc resume
		call StopHunt
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
		oc !c -CampSpot ${Me.Name}
		oc !c -joustout ${Me.Name}
		Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
		oc !c -CS_Set_ChangeRelativeCampSpotBy ${Me.Name} 0 0 -30
		echo must kill "${Named}"
		target "${Named}"
		do
		{
			wait 10
			ExecuteQueued
			call IsPresent "${Named}"
		}
		while (${Return})
		wait 20
		OgreBotAPI:AcceptReward["${Me.Name}"]
		eq2execute summon
		wait 50
		OgreBotAPI:AcceptReward["${Me.Name}"]
		wait 20
		oc !c -letsgo ${Me.Name}
		call DMove 64 -122 -168 3
		call DMove 62 -122 -156 3
		call DMove 3 -122 -153 3
		call DMove -1 -120 -121 3
		call DMove 0 -121 -78 3
	}
}

function step003()
{
	variable string mob
	variable bool isNamed
	variable string Named
	Named:Set["Balrezu"]
	eq2execute merc resume
	
	mob:Set["scorched fiend"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call MoveCloseTo "Operator of Fire"
	OgreBotAPI:HailNPC["${Me.Name}","Operator of Fire"]
	wait 30
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 250
	call IsPresent "${Named}"
	isNamed:Set[${Return}]
	call IsPresent "${mob}" 500
	
	if (${Return} || ${isNamed})
	{
		call DMove -5 -137 -84 1
		call MoveJump 25 -136 -54 5 -136 -74
		Ob_AutoTarget:AddActor["${mob}",0,TRUE,FALSE]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		call DMove 44 -138 -38 ${speed} ${FightDistance}
		call DMove 47 -139 -23 ${speed} ${FightDistance}
		call DMove 36 -138 -14 ${speed} ${FightDistance}
		call DMove 41 -138 -4 ${speed} ${FightDistance}
		call DMove 22 -138 2 ${speed} ${FightDistance}
		call DMove 22 -138 10 ${speed} ${FightDistance}
		call DMove 8 -139 16 ${speed} ${FightDistance}
		call DMove 20 -138 33 ${speed} ${FightDistance}
		call DMove 25 -137 42 ${speed} ${FightDistance}
		call DMove 30 -138 47 ${speed} ${FightDistance}
		call DMove 42 -138 62 ${speed} ${FightDistance}

		call StopHunt
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
		call DMove 42 -138 62 3
		oc !c -CampSpot ${Me.Name}
		oc !c -joustout ${Me.Name}
		oc !c -MarkToon ${Me.Name}
		eq2execute gsay Set up for ${Named}
		Ob_AutoTarget:AddActor["${mob}",0,TRUE,FALSE]
		Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
		echo must kill "${Named}"
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
		wait 20
		OgreBotAPI:AcceptReward["${Me.Name}"]
		eq2execute summon
		wait 50
		OgreBotAPI:AcceptReward["${Me.Name}"]
		wait 20
		oc !c -letsgo ${Me.Name}	
	
		eq2execute merc resume
		call StopHunt
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
		if (!${NoShiny})
			Script[autoshinies]:Resume
		call DMove 9 -139 21 3
		call DMove 14 -139 11 3
		call DMove 35 -138 5 3
		if (!${NoShiny})
			Script[autoshinies]:Pause
		call DMove 46 -139 -25 3
		call DMove 31 -136 -48 3
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
	eq2execute merc resume
	
	call IsPresent "${Named}"
	if (${Return})
	{
		call PetitPas 4 -156 -81 3
		
		echo Prepare to Run and Jump

		wait 20
		call MoveJump -23 -156 -55 -23 -156 -75
	
		call DMove -23 -156 -55 ${speed} ${FightDistance}
		Me.Inventory["Obsidian Sun Disc"]:Use
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
		oc !c -CampSpot ${Me.Name}
		oc !c -joustout ${Me.Name}
		oc !c -MarkToon ${Me.Name}
		eq2execute gsay Set up for ${Named}
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
		OgreBotAPI:AcceptReward["${Me.Name}"]
		eq2execute summon
		wait 50
		OgreBotAPI:AcceptReward["${Me.Name}"]
		wait 20
		oc !c -letsgo ${Me.Name}	
		if (!${NoShiny})
			Script[autoshinies]:Resume
		call StopHunt
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
		call DMove -125 -156 -40 3
		call DMove -105 -158 -60 3
		if (!${NoShiny})
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
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	oc !c -letsgo ${Me.Name}
	OgreBotAPI:AcceptReward["${Me.Name}"]
	if (!${NoShiny})
		Script[autoshinies]:Resume
}

function step006()
{
	call StopHunt
	{
		call ActivateVerb "zone_to_valor" 0 -178 -112 "Coliseum of Valor" TRUE
		wait 300
	}
}

function ReturnToPosition()
{
	wait 300
	oc !c -CS_Set_ChangeRelativeCampSpotBy ${Me.Name} 0 0 30
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
	;echo Catch Event ${Message}
	if (${Message.Find["expelling molten rocks"]} > 0)
	{
		oc !c -CS_Set_ChangeRelativeCampSpotBy ${Me.Name} 0 0 30
		QueueCommand call ReturnToPosition
	}
 }
 
 atom HandleAnnounces(string Text, string SoundType, float Timer)
 {
	if ${Text.Find["Mirage"]} > 0
		echo ${Text} ${SoundType} ${Timer} 
 }