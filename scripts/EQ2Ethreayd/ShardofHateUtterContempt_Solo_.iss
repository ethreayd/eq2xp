#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) int CurrentStep=0
variable(script) int EInc=0
variable(script) bool CallHelestia

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=4
	oc !c -LoadProfile Solo ${Me.Name}
	wait 300
	oc !c -letsgo ${Me.Name}
	if ${Script["solodeath"](exists)}
		endscript solodeath
	run EQ2Ethreayd/solodeath ${NoShiny}
	if (${setspeed}==0)
	{
		speed:Set[3]
		FightDistance:Set[30]
	}
	else
		speed:Set[${setspeed}]
			
	echo speed set to ${speed}
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 50 ${speed} 

	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Shard of Hate: Utter Contempt [Solo]"

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
	OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
		
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["Fuel of Hatred"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 45 1 226 3
	call StartHunt "bubble of hatred"
	call DMove 90 4 180 3
	call DMove 92 3 198 3
	call DMove 159 6 154 3
	call DMove 139 6 143 3
	call DMove 163 6 128 3
	call DMove 139 6 143 3
	call DMove 149 6 190 3
	call DMove 139 6 159 3
	call DMove 52 0 243 3
	call DMove 90 4 180 3
	call DMove 92 3 198 3
	call DMove 159 6 154 3
	call DMove 139 6 143 3
	call DMove 163 6 128 3
	call DMove 139 6 143 3
	call DMove 147 6 143 3
	call waitfor_Power 98
	call waitfor_Health 98
	call DMove 169 8 147 3
	call TanknSpank "${Named}" 100
	CurrentStep:Inc
	call waitfor_Power 50
	oc !c -letsgo ${Me.Name} 
	wait 100
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call DMove 147 6 143 3
	call DMove 139 6 159 3
	call DMove 52 0 243 3
	call waitfor_Health 98
}

function step001()
{
	variable string Named
	Named:Set["Anarchic Obscenity"]
	eq2execute merc resume
	call StopHunt
	;OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove -6 4 223 3
	call DMove -81 8 217 3
	call DMove -155 13 190 3
	call DMove -179 16 137 3
	call DMove -195 11 94 3
	call DMove -214 14 58 3
	call DMove -183 17 14 3
	call DMove -149 15 11 3
	call StartHunt "anarchic lurcher"
	call DMove -143 15 17 3 30 TRUE FALSE 5
	call DMove -148 15 21 3 30 TRUE FALSE 3
	call DMove -146 15 37 3
	wait 100
	call CheckCombat
	
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",15]
	call DMove -149 15 22 3
	call DMove -127 16 -4 3
	call DMove -121 16 -16 3 TRUE FALSE 5
	call DMove -127 16 -4 3 TRUE FALSE 5
	call DMove -118 16 -5 3 30 TRUE FALSE 5
	wait 100
	call CheckCombat
	call DMove -107 16 -37 3
	call DMove -116 16 -98 3
	call DMove -136 17 -95 3
	wait 100
	call CheckCombat
	call DMove -105 15 -90 3
	call DMove -99 15 -97 3
	call DMove -103 15 -78 3
	call DMove -49 9 -62 3
	wait 100
	call CheckCombat 
	call DMove -65 12 -3 3
	wait 100
	call CheckCombat 
	call DMove -63 10 -31 3
	call DMove -98 15 -34 3
	call DMove -107 16 -28 3 30 FALSE FALSE 5
	call DMove -152 15 9 3
	call DMove -202 17 14 3
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	call TanknSpank "${Named}" 100
	CurrentStep:Inc
	call waitfor_Power 50
	oc !c -letsgo ${Me.Name} 
	wait 100
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call DMove -210 19 -4 3
	wait 100
	call CheckCombat
	call DMove -202 17 14 3
}
function step002()
{
	variable string Named
	Named:Set["Helestia"]
	eq2execute merc resume
	call StopHunt
	call DMove -180 17 12 3
	call DMove -136 15 10 3
	call DMove -117 16 -16 3
	call DMove -99 16 -54 3
	call StartHunt "fettered wraith"
	wait 100
	call CheckCombat
	call DMove -108 16 -73 3
	call DMove -88 15 -79 3
	wait 100
	call CheckCombat
	call DMove -54 9 -54 3
	call DMove -43 9 -28 3
	wait 100
	call CheckCombat
	OgreBotAPI:CastAbility["${Me.Name}","Singular Focus"]
	call DMove -11 8 -41 3
	call DMove -7 9 -24 3 30 TRUE FALSE 10
	target "fettered wraith"
	call DMove -11 8 -41 3 30 TRUE FALSE 10
	call DMove 22 8 -48 3 30 TRUE FALSE 10
	OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
	wait 100
	call CheckCombat
	call DMove 48 9 -10 3
	call DMove 48 8 -29 3
	call DMove 49 8 -40 3
	do
	{
		call DMove 32 8 -66 3 30 TRUE FALSE 2
		call DMove 41 8 -62 3 30 TRUE FALSE 2
		OgreBotAPI:Special["${Me.Name}"]
		wait 400
		call TanknSpank "${Named}" 100
	}
	while (!${CallHelestia})
	CurrentStep:Inc
	call waitfor_Power 50
	oc !c -letsgo ${Me.Name} 
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 100
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
function step003()
{
	variable string Named
	Named:Set["The Head of Hate"]
	eq2execute merc resume
	call StopHunt
	call StartHunt "Surrogate"
	call DMove 48 8 -31 3
	wait 20
	call DMove 48 9 6 3
	wait 20
	call DMove -65 11 -12 3 30 TRUE FALSE 10
	wait 100
	call CheckCombat
	call DMove -59 10 -43 3
	call DMove 28 8 -35 3
	call DMove 91 19 22 3
	call DMove 140 20 11 3
	oc !c -CampSpot ${Me.Name}
	wait 100
	call CheckCombat 
	oc !c -letsgo ${Me.Name}
	call DMove 178 33 -41 3
	oc !c -CampSpot ${Me.Name}
	wait 100
	call CheckCombat 
	oc !c -letsgo ${Me.Name}
	call DMove 220 33 -69 3
	call DMove 181 33 -98 3
	oc !c -CampSpot ${Me.Name}
	wait 100
	call CheckCombat 
	oc !c -letsgo ${Me.Name}
	call DMove 141 22 -138 3
	oc !c -CampSpot ${Me.Name}
	wait 100
	call CheckCombat 
	oc !c -letsgo ${Me.Name}
	call DMove 75 20 -155 3
	wait 20
	call CheckCombat 
	call DMove -10 27 -131 3
	do
	{
		echo need to write a loop to hunt missed surrogates
		call IsPresent "${Named}" 100
	}
	while (!${Return})
	call DMove -13 36 -198 3
	call TanknSpank "${Named}" 100
	CurrentStep:Inc
	call waitfor_Power 50
	oc !c -letsgo ${Me.Name}
	wait 100
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	call DMove -15 36 -194 3
	wait 10
	call DMove -14 37 -209 3
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
function step004()
{
	variable string Named
	Named:Set["Estir the Spiteful"]
	
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Pause
	eq2execute merc resume
	call StopHunt
	oc !c -Zone ${Me.Name} 
	wait 200
	call DMove -14 -154 -219 3
	call DMove -33 -154 -253 3
	wait 20
	call CheckCombat 
	call DMove -21 -155 -302 3
	wait 20
	call CheckCombat
	call DMove -22 -155 -255 3
	wait 300
	call waitfor_Power 50
	
	do
	{
		wait 10
		call IsPresent "${Named}" 100
	}
	while (!${Return})
	wait 300

	call MoveCloseTo "${Named}"
	OgreBotAPI:CastAbility["${Me.Name}","Singular Focus"]
	call Converse "${Named}" 2
	call DMove -31 -155 -233 3 30 TRUE TRUE 10
	target "${Named}"
	do
	{
		wait 10
		call CircleFight "${Named}"
		call CountAdds "${Named}" 20
		if (${Return}<1)
			eq2execute merc backoff
		else
			eq2execute merc ranged
		call IsPresent "${Named}" 100
	}
	while (${Return})
	wait 100
	oc !c -letsgo ${Me.Name} 
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
	eq2execute summon
	call DMove -12 -155 -312 3
	wait 10
	eq2execute summon
	wait 10
	call DMove -10 -155 -291 3
	wait 10
	call DMove -12 -155 -312 3
	eq2execute summon
	
	
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Resume
}

function CircleFight(string Named)
{ 
	variable float Distance
	variable int nbAdds
	
	Distance:Set[10]
    call DetectCircles ${Distance} design_circle_warning_zone_gold
	echo ${Return} circles detected
	if (${Return}>0)
	{
		do
		{
			echo moving out of circle
			target ${Me.Name}
			call PKey STRAFERIGHT 1
			echo if ${Me.Loc.X}<5
			if (${Me.Loc.X}<5)
			{
				echo call CMove ${Math.Calc64[${Me.Loc.X}+10]} ${Me.Loc.Z}
				call CMove ${Math.Calc64[${Me.Loc.X}+10]} ${Me.Loc.Z}
			}
			else
			{
				echo call CMove -32 ${Math.Calc64[${Me.Loc.Z}-10]}
				call CMove -32 ${Math.Calc64[${Me.Loc.Z}-10]}
			}
			echo if (${Me.Loc.Z}<-337)
			if (${Me.Loc.Z}<-337)
			{
				echo CMove -31 -233
				call CMove -31 -233
			}
			call DetectCircles ${Distance} design_circle_warning_zone_gold
		}
		while (${Return}>0)
	}
	if (${EInc}<1)
	{
		target "${Named}"
		call GetEffectIncrement "Blood of My Blood"
		wait 5
		call GetEffectIncrement "Blood of My Blood"
		EInc:Set[${Return}]
	}	
	call CountAdds "of spite" 200
	nbAdds:Set[${Return}]
	echo ${EInc} / ${nbAdds}
	if (${EInc}<${nbAdds} || ${EInc}>${nbAdds})
	{ 
		echo  (${EInc}<${nbAdds} || ${EInc}>${nbAdds})
		eq2execute target a lady of spite
		eq2execute target a lord of spite
	}
	else
	{
		target "${Named}"
	}
}

atom HandleAllEvents(string Message)
{
	if (${Message.Find["summons vampires of spite"]} > 0)
	{
		EInc:Set[0]
	}
	if (${Message.Find["chained for all eternity"]} > 0)
	{
		CallHelestia:Set[TRUE]
	}
}
