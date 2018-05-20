#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool ShardOn
variable(script) bool BrazierOn
variable(script) bool Firelord
variable(script) bool ShieldOff
variable(script) bool MirageQueued

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=9
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
			
	echo speed set to ${speed}
	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 50 ${speed} 
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Solusek Ro's Tower: Monolith of Fire [Solo]"

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
	
	
	if (${stepstart}==0)
	{
		call IsPresent "Jiva" 500
		if (${Return})
		{
			stepstart:Set[1]
		}
	}
	OgreBotAPI:Resume["${Me.Name}"]
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["Shard of Obsidian"]
	eq2execute merc resume
	
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove 0 -6 -52 2
	call DMove 19 -6 -55 ${speed} ${FightDistance}
	call DMove 23 -6 -100 ${speed} ${FightDistance}
	call DMove -18 -6 -104 ${speed} ${FightDistance}
	call DMove -23 -6 -56 ${speed} ${FightDistance}
	call DMove 19 -6 -55 3
	call DMove 21 -6 -98 3
	call DMove -18 -6 -104 3
	call DMove -23 -6 -56 3
	call DMove 19 -6 -55 3
	call DMove 27 -6 -101 3
	call DMove 97 -6 -101 3
	wait 20
	call OpenDoor "Door - Floor 1 Left 1"
	call AutoPassDoor "Door - Floor 1 Right 1" 110 -6 -101
	call DMove 108 -6 -98 3
	call IsPresent "Emitter - Giant Flaming Eyeball" 50
	if (${Return})
	{
	do
	{
		ShardOn:Set[FALSE]
		call DMove 137 -6 -72 3
		call DMove 139 -6 -60 ${speed} ${FightDistance}
		call DMove 140 -5 0 ${speed} ${FightDistance}
		call TanknSpank "${Named}" 30
		do
		{
			if (!${ShardOn})
				call DMove 138 -4 7 3
			wait 20
			if (!${ShardOn})
				call PetitPas 138 -4 7 3
			call DMove 139 -6 -5 3
		}
		while (!${BrazierOn} && !${ShardOn})
		call DMove 139 -6 -42 3
		call DMove 138 -6 -60 3
		call DMove 138 -6 -77 3
		ShardOn:Set[FALSE]
		call DMove 170 -6 -100 3
		call DMove 183 -6 -100 3
		call DMove 246 -4 -102 ${speed} ${FightDistance}
		call TanknSpank "${Named}" 30
		do
		{
			if (!${ShardOn})
				call DMove 250 -4 -101 3
			wait 20
			if (!${ShardOn})
				call PetitPas 250 -4 -101 3
			call DMove 235 -6 -102 3
		}
		while (!${BrazierOn} && !${ShardOn})
		call DMove 196 -6 -102 3
		call DMove 165 -6 -102 3
		call DMove 140 -6 -135 3
		ShardOn:Set[FALSE]
		call DMove 140 -6 -145 3
		call DMove 139 -5 -205 ${speed} ${FightDistance}
		call TanknSpank "${Named}" 30
		do
		{
			if (!${ShardOn})
				call DMove 139 -4 -211 3
			wait 20
			if (!${ShardOn})
				call PetitPas 139 -4 -211 3
			call DMove 138 -6 -196 3
		}
		while (!${BrazierOn} && !${ShardOn})
		call DMove 138 -6 -156 3
		call DMove 138 -6 -130 3
		ShardOn:Set[FALSE]
		call DMove 139 -7 -112 3
		call DMove 110 -6 -103 3
		call IsPresent "Brazier Floor 1 West"
		if (${Return})
			BrazierOn:Set[TRUE]
	}
	while (!${BrazierOn})
	}
	call DMove 60 -5 -101 3
	call DMove -1 -6 -104 3
	ShardOn:Set[FALSE]
	call DMove -37 -6 -101 3
	call DMove -98 -6 -102 3
	BrazierOn:Set[FALSE]
	wait 20	
	call OpenDoor "Door - Floor 1 Left 2"
	call AutoPassDoor "Door - Floor 1 Right 2" -114 -6 -102
	call DMove -108 -6 -98
	call IsPresent "Emitter - Giant Flaming Eyeball" 50
	if (${Return})
	{
	do
	{
		call DMove -138 -6 -132 3
		call DMove -138 -6 -145 3
		call DMove -138 -5 -205 ${speed} ${FightDistance}
		call TanknSpank "${Named}" 30
		do
		{
			if (!${ShardOn})
				call DMove -139 -4 -210 3
			wait 20
			if (!${ShardOn})
				call PetitPas -139 -4 -210 3
			call DMove -140 -6 -195 3
		}
		while (!${BrazierOn} && !${ShardOn})
		call DMove -140 -6 -159 3
		call DMove -139 -6 -128 3
		call DMove -165 -6 -104 3
		ShardOn:Set[FALSE]
		call DMove -182 -6 -102 3
		call DMove -240 -6 -102 3
		call TanknSpank "${Named}" 30
		do
		{
			if (!${ShardOn})
				call DMove -253 -4 -102 3
			wait 20
			if (!${ShardOn})
				call PetitPas -249 -4 -102 3
			call DMove -234 -6 -102 3
		}
		while (!${BrazierOn} && !${ShardOn})
		call DMove -198 -6 -102 3
		call DMove -171 -6 -101 3
		call DMove -140 -6 -75 3
		ShardOn:Set[FALSE]
		call DMove -139 -6 -59 3
		call DMove -139 -5 0 ${speed} ${FightDistance}
		call DMove -139 -6 -41 3
		call DMove -139 -5 0 3
		call TanknSpank "${Named}" 30
		do
		{
			if (!${ShardOn})
				call DMove -139 -4 8 3
			wait 20
			if (!${ShardOn})
				call PetitPas -139 -4 8 3
			call DMove -138 -6 -7 3
		}
		while (!${BrazierOn} && !${ShardOn})
		call DMove -138 -6 -43 3
		call DMove -138 -6 -72 3
		call DMove -111 -6 -102 3
		call IsPresent "Brazier Floor 1 East"
		if (${Return})
			BrazierOn:Set[TRUE]
	}
	while (!${BrazierOn})
	}
	call DMove -48 -6 -101 3
	call DMove 19 -6 -103 3
	call DMove 22 -6 -55 3
	ogre navtest -loc 0 -6 -54
}	

function step001()
{
	variable string Named
	Named:Set["Jiva"]
	eq2execute merc resume
	call DMove 0 -6 -54 2	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	echo must kill "${Named}"
	
	wait 50
	target "${Named}"
	wait 50
	call TanknSpank "${Named}" 50 TRUE
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	
	ogre navtest -loc 0 -6 -54
}

function step002()
{
	variable string Named
	Named:Set["Shard of Obsidian"]
	eq2execute merc resume
	
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 0 -6 -54 2
	call DMove 20 -6 -54 3
	call DMove 20 -6 -97 3
	call DMove 27 -6 -102 3
	call DMove 78 -5 -102 3
	call DMove 97 -6 -101 3
	wait 20
	call OpenDoor "Door - Floor 1 Left 1"
	call AutoPassDoor "Door - Floor 1 Right 1" 110 -6 -101
	call DMove 135 -8 -102 3
	call ActivateVerb "Brazier Floor 1 West" 135 -8 -102 "Touch"
	wait 50
	call DMove 224 103 -108 ${speed} ${FightDistance}
	call DMove 224 103 -125 ${speed} ${FightDistance}
	call DMove 244 103 -125 ${speed} ${FightDistance}
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call TanknSpank "${Named}" 30	
	call DMove 224 103 -125 3
	call DMove 224 103 -164 3
	call DMove 224 103 -200 ${speed} ${FightDistance}
	call DMove 186 103 -200 3
	call DMove 149 103 -201 ${speed} ${FightDistance}
	call DMove 149 104 -185 3
	call OpenDoor "Door - Floor 2 Left 1"
	call AutoPassDoor "Door - Floor 2 Right 1" 149 102 -171
}
function step003()
{
	variable string mob
	variable string Named
	call IsPresent Xuzl 500 TRUE
	if (!${Return})
	{
		Named:Set["Estryxia"]
		eq2execute merc resume
		OgreBotAPI:AutoTarget_SetScanHeight["${Me.Name}",30]
		mob:Set["a cinderspawn phoenix"]
		call StopHunt
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
		Ob_AutoTarget:AddActor["${mob}",0,TRUE,FALSE]
		call DMove 151 102 -151 3
		call DMove 116 102 -170 3
		wait 20
		call CheckCombat
		call DMove 157 102 -155 3
		call DMove 164 102 -130 3
		wait 20
		call CheckCombat
		call DMove 165 102 -62 3
		wait 20
		call CheckCombat
		call DMove 159 102 0 3
		call DMove 124 102 1 3
		wait 20
		call CheckCombat
		call DMove 158 102 -10 3
		call DMove 153 102 -123 3
		call DMove 132 102 -114 3
		oc !c -CampSpot ${Me.Name}
		oc !c -joustout ${Me.Name}
		eq2execute merc resume
		wait 10
		call TanknSpank "${Named}"
		wait 20
		call TanknSpank "${Named}"
		wait 20
		call TanknSpank "${Named}"
		wait 20
		call TanknSpank "${Named}"
		wait 20
	
		OgreBotAPI:AcceptReward["${Me.Name}"]
		eq2execute summon
		wait 50
		OgreBotAPI:AcceptReward["${Me.Name}"]
		wait 20
		oc !c -letsgo ${Me.Name}
	}
	call DMove 182 103 -94 3
	call OpenDoor "Door - Floor 2 Right 2"
	call AutoPassDoor "Door - Floor 2 Left 2" 190 103 -94
	call DMove 197 103 -94 3
	call ActivateVerb "Brazier Floor 2 West 2" 197 103 -94 "Touch"
	wait 20
	call IsPresent Xuzl 500 TRUE
	if (${Return})
		ReplyDialog:Choose[2]
	wait 50
}
function step004()
{
	variable string Named
	call IsPresent Xuzl 500 TRUE
	if (!${Return})
	{
		Named:Set["Shard of Obsidian"]
		eq2execute merc resume
	
		call StopHunt
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
		call DMove -224 103 -74 3
		call DMove -224 103 -37 ${speed} ${FightDistance}
		call DMove -246 103 -38 ${speed} ${FightDistance}
		call TanknSpank "${Named}" 30
		
		call DMove -224 103 -37 3
		call DMove -223 103 1 3
		call DMove -224 103 37 ${speed} ${FightDistance}
		call DMove -184 103 37 3
		call DMove -149 103 37 ${speed} ${FightDistance}
		call DMove -149 104 22 3
		call CountItem "efreeti sunlord pendant"
		if (${Return}<1)
		{
			do
			{
				call DMove -149 103 37 3
				call DMove -184 103 37 3
				call DMove -224 103 37 3
				call DMove -224 103 1 3
				call DMove -224 103 -37 3
				call DMove -224 103 -74 3
				call DMove -224 103 -37 3
				call DMove -224 103 1 3
				call DMove -224 103 37 3
				call DMove -184 103 37 3
				call DMove -149 103 37 3
				call DMove -149 104 22 3
				call CountItem "an efreeti sun lord pendant"
			}
			while (${Return}<1)
		}
		call OpenDoor "Door - Floor 2 Right 3"
		call AutoPassDoor "Door - Floor 2 Left 3" -149 102 12 
	}
}	
function step005()
{
	variable string mob
	variable string Named
	call IsPresent Xuzl 500 TRUE
	if (!${Return})
	{
		Named:Set["So'Valiz"]
		eq2execute merc resume
	
		mob:Set["an emberscale hunter"]
		call StopHunt
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
		call DMove -149 102 8 3
		Ob_AutoTarget:AddActor["${mob}",0,TRUE,FALSE]
		call DMove -130 102 9 3
		call DMove -108 102 -3 3
		wait 20
		call DMove -122 102 14 3
		call DMove -163 102 9 3
		call DMove -164 102 -11 3
		wait 20
		if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
		
		eq2execute merc resume
		wait 10
		Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
		echo must kill "${Named}"
		oc !c -MarkToon ${Me.Name}
		eq2execute gsay Set up for ${Named}
		call DMove -173 102 -25 3
		call DMove -168 102 -116 3
		call DMove -159 102 -130 3
		wait 20
		oc !c -MarkToon ${Me.Name}
		eq2execute gsay Set up for ${Named}
		call DMove -161 102 -171 3
		call DMove -127 102 -178 3
		call DMove -101 102 -153 3
		wait 20
		oc !c -MarkToon ${Me.Name}
		eq2execute gsay Set up for ${Named}
		call DMove -110 102 -79 3
		call DMove -132 102 -53 3
		eq2execute gsay Set up for ${Named}
		wait 100
		oc !c -MarkToon ${Me.Name}
		eq2execute gsay Set up for ${Named}
		call TanknSpank "${Named}"
	
		OgreBotAPI:AcceptReward["${Me.Name}"]
		eq2execute summon
		wait 50
		OgreBotAPI:AcceptReward["${Me.Name}"]
		wait 20
		if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
		call DMove -183 103 -71 3
		call OpenDoor "Door - Floor 2 Right 4"
		call AutoPassDoor "Door - Floor 2 Left 4" -190 103 -70
		call DMove -198 103 -70 3
		call ActivateVerb "Brazier Floor 2 East 2" -198 103 -70 "Touch"
		wait 20
		ReplyDialog:Choose[2]
		wait 50
	}
}
function step006()
{
	variable string mob
	variable string Named
	Named:Set["Xuzl"]
	eq2execute merc resume
	
	mob:Set["Shard of Obsidian"]
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	Ob_AutoTarget:AddActor["${mob}",0,TRUE,FALSE]	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]	
	ogre navtest -loc 0 103 -84
	wait 20
	call DMove 0 103 -84 3 30 TRUE 
	oc !c -CampSpot ${Me.Name}
	oc !c -joustout ${Me.Name}
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	echo "must kill ${Named}"
	call IsPresent "${Named}"
	if (${Return})
	{
		target "${Named}"
		wait 200
		do
		{
			wait 50
			call IsPresent "Shard" 100
			if (${Return})
			{
				echo "Shard is present"
				oc !c -joustin ${Me.Name}
				OgreBotAPI:Pause["${Me.Name}"]
				target ${Me.Name}
				if (${Me.Loc.Y}<125)
				{
					call MoveCloseTo "a fissure vent"
				}
				if (${Me.Loc.Y}<125)
				{
					call PKey MOVEFORWARD 4
				}
				wait 10
				face 0 -84
				if (${Me.Loc.Y}<125)
				{
					call PKey MOVEFORWARD 2
				}
				OgreBotAPI:Resume["${Me.Name}"]
				if (${Me.Loc.Y}>125)
				{
					echo "i am on the pentagram"
					target "${mob}"
					do
					{
						wait 10
						call IsPresent "${mob}" 100
					}
					while (${Return})
				}
				oc !c -joustout ${Me.Name}
			}
			
			echo "looping"
			ExecuteQueued
			call IsPresent "${Named}" 100 TRUE
		}
		while (${Return} || ${Me.InCombatMode})
		echo exiting loop
	}
	oc !c -letsgo ${Me.Name}
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	call DMove 0 103 -68 3
	call DMove 0 103 12 3
	call ActivateVerb "Brazier Floor 2 Center Lava Room" 0 103 12 "Touch"
	wait 50
	
}	
function step007()
{
	eq2execute merc resume
	
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	call DMove 0 224 -185 ${speed} ${FightDistance}
	call DMove -105 224 -185 ${speed} ${FightDistance}
	call DMove -105 224 25 ${speed} ${FightDistance}
	call DMove 104 224 26 ${speed} ${FightDistance}
	call DMove 103 224 -185 ${speed} ${FightDistance}
	call DMove -54 224 -185 3
	call DMove -54 225 -214 3
	call ActivateVerb "Sun Ray Button 1" -54 225 -214 "Press"
	wait 20
	call DMove -54 224 -185 3
	call DMove -105 224 -185 3
	call DMove -105 224 -135 3
	call DMove -135 225 -133 3
	call ActivateVerb "Sun Ray Button 2" -135 225 -133 "Press"
	wait 20
	call DMove -105 224 -135 3
	call DMove -105 224 -25 3
	call DMove -135 225 -25	3
	call ActivateVerb "Sun Ray Button 3" -135 225 -25 "Press"
	wait 20
	call DMove -105 224 -25 3
	call DMove -105 224 25 3
	call DMove -55 224 25 3
	call DMove -55 225 52 3
	call ActivateVerb "Sun Ray Button 4" -55 225 52 "Press"
	wait 20
	call DMove -55 224 25 3
	call DMove 55 224 25 3
	call DMove 55 225 50 3
	call ActivateVerb "Sun Ray Button 5" 55 225 50 "Press"
	wait 20
	call DMove 55 224 25 3
	call DMove 105 224 25 3
	call DMove 105 224 -25 3
	call DMove 130 224 -25 3
	call ActivateVerb "Sun Ray Button 6" 130 224 -25 "Press"
	wait 20
	call DMove 105 224 -25 3
	call DMove 105 224 -130 3
	call DMove 130 225 -130 3
	call ActivateVerb "Sun Ray Button 7" 130 225 -130 "Press"
	wait 20
	call DMove 105 224 -130 3
	call DMove 105 224 -185 3
	call DMove 55 224 -185 3
	call DMove 55 224 -210 3
	call ActivateVerb "Sun Ray Button 8" 55 225 -210 "Press"
	wait 20
	call DMove 55 224 -185 3
	call DMove -105 224 -185 3
	call DMove -105 224 -80 3
	call DMove -80 225 -80 3
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call ActivateVerb "Brazier Floor 3 East" -80 225 -80 "Touch"
	wait 20
}
function step008()
{
	variable string Named
	Named:Set["Solusek Ro"]
	eq2execute merc resume
	
	call DMove -36 239 -114 3
	call DMove 0 239 -126 3
	call PetitPas 0 239 -128 2
	wait 20
	oc !c -CampSpot ${Me.Name}
	oc !c -joustout ${Me.Name}
	oc !c -MarkToon ${Me.Name}
	wait 20
	eq2execute gsay "Set up for"
	wait 50
	call Converse "${Named}" 10
	do
	{
		wait 10
		call IsPresent "Avatar of the Sun"
	}
	while (!${Return})
	oc !c -letsgo ${Me.Name}
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
}		
function step009()
{
	call StopHunt
	{
		call ActivateVerb "zone_to_valor" 0 239 -90 "Coliseum of Valor" TRUE
		wait 300
	}
}
function DoSwords()
{
	variable string Named
	Named:Set["Xuzl"]
	echo launching DoSwords
	do
	{
		echo "no more shards"
		echo Getting in place
		oc !c -joustout ${Me.Name}
		wait 20
		oc !c -joustin ${Me.Name}
		echo fighting with swords !
		OgreBotAPI:Pause["${Me.Name}"]
		wait 20
		target ${Me.Name}
		call MoveCloseTo "Flame Sword Sign 1"
		call ClickOn "Flame Sword Sign"
		wait 20
		call DMove 0 103 -84 3 30 TRUE
		target ${Me.Name}
		call MoveCloseTo "Flame Sword Sign 2"
		call ClickOn "Flame Sword Sign"
		wait 20
		call DMove 0 103 -84 3 30 TRUE
		target ${Me.Name}
		call MoveCloseTo "Flame Sword Sign 3"
		call ClickOn "Flame Sword Sign"
		wait 20
		call DMove 0 103 -84 3 30 TRUE
		target ${Me.Name}
		call MoveCloseTo "Flame Sword Sign 4"
		call ClickOn "Flame Sword Sign"
		wait 20
		call DMove 0 103 -84 3 30 TRUE
		target ${Me.Name}
		call MoveCloseTo "Flame Sword Sign 5"
		call ClickOn "Flame Sword Sign"
		wait 20
		OgreBotAPI:Resume["${Me.Name}"]
		oc !c -joustout ${Me.Name}
		target ${Named}
		wait 300
	}
	while (${Me.InCombatMode})
}		
function GotoRedGargoyle()
{
	variable index:actor Actors
    variable iterator ActorIterator
    variable bool Found
	variable int Counter
	
		EQ2:QueryActors[Actors]
		Actors:GetIterator[ActorIterator]
		if ${ActorIterator:First(exists)}
		{       
			do
			{
				echo checking Actor ID : ${ActorIterator.Value.ID}
				if (${ActorIterator.Value.Name.Equal[""]} && ${ActorIterator.Value.Overlay.Equal["result_ghost_forced_shader_4_red"]} && ${ActorIterator.Value.Distance}>10)
				{
					echo Found an empty Actor (ID:${ActorIterator.Value.ID}) at ${ActorIterator.Value.Distance} m
					Found:Set[TRUE]
					echo Going to Phantom Actor at ${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}
					eq2execute way ${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}
					ogre navtest -loc ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z}
					wait 100
					if (!${ShieldOff})
					{
						if (${ActorIterator.Value.Distance}<10)
						{
							do
							{
								OgreBotAPI:Pause["${Me.Name}"]
								Counter:Set[0]
								call PetitPas ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} 5
								face ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
								call PKey MOVEBACKWARD 2
								wait 10
								face ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
								call PKey MOVEFORWARD 1
								face ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
								call PKey JUMP 1
								wait 5
								face ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
								call PKey MOVEFORWARD 1
								wait 10
								Counter:Inc
								OgreBotAPI:Resume["${Me.Name}"]
								echo destination is at ${ActorIterator.Value.Distance} m
								echo this is the ${Counter} try
							}
							while (!${ShieldOff} && ${Counter}<4)
						}
					}
				}
			}
			while (${ActorIterator:Next(exists)} && !${Found})
		}
	call IsPresent "Jiva"
	if (!${ShieldOff} && ${Return})
	{
		QueueCommand call GotoRedGargoyle
	}
	else
	{
		ShieldOff:Set[FALSE]
		MirageQueued:Set[FALSE]
	}
}

atom HandleAllEvents(string Message)
{
	;echo Catch Event ${Message}
	if (${Message.Find["rises from the floor"]} > 0 || ${Message.Find["as you stand upon"]} > 0 || ${Message.Find["as you step off"]} > 0)
	{
		ShardOn:Set[TRUE]
	}
	if (${Message.Find["rises from the floor"]} > 0)
	{
		BrazierOn:Set[TRUE]
	}
	if (${Message.Find["ready to avenge"]} > 0)
	{
		Firelord:Set[TRUE]
	}
	if (${Message.Find["Shield is now vulnerable"]} > 0)
	{
		ShieldOff:Set[TRUE]
	}
	if (${Message.Find["is seared into your mind"]} > 0 || ${Message.Find["most distinct memory"]} > 0)
	{
		if (!${MirageQueued})
		{
			QueueCommand call GotoRedGargoyle
			MirageQueued:Set[TRUE]
		}
	}
	if (${Message.Find["failed me once again"]} > 0)
	{
		echo queueing DoSwords
		QueueCommand call DoSwords
	}	
 }
 
 atom HandleAnnounces(string Text, string SoundType, float Timer)
 {
	if ${Text.Find["Mirage"]} > 0
		echo ${Text} ${SoundType} ${Timer} 
 }