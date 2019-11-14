#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
;variable(script) int GravelDoor
;variable(script) string DoorArray[3]
;variable(script) bool Killed = FALSE



function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{
	variable int laststep=5
	
	oc !c -letsgo ${Me.Name}
	;if (!${Script["livedierepeat"](exists)})
	;	run EQ2Ethreayd/livedierepeat ${NoShiny}
	if (${setspeed}==0)
	{
		speed:Set[3]
		FightDistance:Set[15]
	}
	else
		speed:Set[${setspeed}]
		
	echo speed set to ${speed}
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	;if (!${NoShiny})
	;	run EQ2Ethreayd/autoshinies 50 ${speed} 
 
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name} starting at step ${stepstart}/${stepstop}
	call waitfor_Zone "Awuidor: Marr's Ascent [Solo]"
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
	

	if (${stepstart}==0)
	{
		echo stepstart is zero - nothing to do
	}
	call check_quest "Elements of Destruction: Layers of Order"
	if (${Return})
	{
		OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",25]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
		Ob_AutoTarget:AddActor["Stone of Thudos",0,FALSE,FALSE]
	}
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["Hirpo the Frosted Spine"]
	eq2execute merc resume
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove 201 322 -128 3
	call KBMove "${Me.Name}" 30 338 -129 3
	call KBMove "${Me.Name}" 6 338 -156 3
	call KBMove "${Me.Name}" -46 335 -129 3
	call KBMove "${Me.Name}" -201 322 -128 3
	call KBMove "${Me.Name}" -181 322 -151 3
	call KBMove "${Me.Name}" -227 322 -123 3
	call DMove -3 338 -129 3
	call DMove 9 510 -130 3 30 TRUE
	call DMove 39 490 -129 3 30 TRUE
	call KBMove "${Me.Name}" 165 490 -123 3
	call TanknSpank "${Named}"
	
}	
function step001()
{
	variable string Named
	Named:Set["Torrent of Awuidor"]
	eq2execute merc resume
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call KBMove "${Me.Name}" 108 490 -110 3
	call DMove 104 491 -129 3
	call DMove 21 496 -129 3
	call DMove 5 496 -110 3
	call KBMove "${Me.Name}" -38 491 -128 3
	call KBMove "${Me.Name}" -178 490 -131 3
	call DMove -123 490 -107 3
	call DMove -85 490 -127 3
	call DMove 0 495 -129 3
	call DMove -5 667 -135 3
	call KBMove "${Me.Name}" -32 668 -124 3
	call KBMove "${Me.Name}" -4 668 -79 3
	call KBMove "${Me.Name}" 62 668 -131 3
	call KBMove "${Me.Name}" 0 668 -187 3
	call TanknSpank "${Named}"
}	
function step002()
{
	variable string Named
	Named:Set["Etrigon Icefist"]
	eq2execute merc resume
	call DMove -1 668 -50 3
	call IsPresent "Leaving Boss02 To Floor"
	while (${Return})
	{
		wait 10
		call IsPresent "Leaving Boss02 To Floor"
	}
	oc !c -Special All
	while (${Me.Z} < 0)
	{
		wait 10
	}
	call KBMove "${Me.Name}" 12 355 22 3
	call KBMove "${Me.Name}" 48 349 -30 3
	call KBMove "${Me.Name}" 42 349 59 3
	call KBMove "${Me.Name}" 54 333 112 3
	call KBMove "${Me.Name}" 95 322 136 3
	call KBMove "${Me.Name}" 248 322 135 3
	call KBMove "${Me.Name}" 180 322 167 3
	call KBMove "${Me.Name}" 156 323 136 3
	call KBMove "${Me.Name}" 32 337 136 3
	call KBMove "${Me.Name}" 4 338 164 3
	call KBMove "${Me.Name}" -70 327 135 3
	call KBMove "${Me.Name}" -237 322 135 3
	call KBMove "${Me.Name}" -36 337 135 3
	call DMove -5 338 111 3
	call DMove 55 332 137 3
	call KBMove "${Me.Name}" 228 322 143 3
	call TanknSpank "${Named}"
}

function step003()
{
	variable string Named
	Named:Set["Grobnor the Elder Orb"]
	call StopHunt
	eq2execute merc resume
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	call DMove 18 338 137 3
	call DMove -1 338 136 3
	call DMove -6 510 137 3
	call DMove -55 490 136 3
	call KBMove "${Me.Name}" -169 490 133 3
	call DMove -21 496 136 3
	call DMove -11 496 118 3
	call DMove 29 493 130 3
	call KBMove "${Me.Name}" 79 490 137 3
	call KBMove "${Me.Name}" 175 490 136 3
	call DMove 20 496 138 3
	call DMove 2 496 159 3
	call DMove -32 493 139 3
	call KBMove "${Me.Name}" -156 490 136 3
	call TanknSpank "${Named}"
}
function step004()
{
	variable string Named
	Named:Set["Tethys All-Mother"]
	call StopHunt
	eq2execute merc resume
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove -87 491 137 3
	call DMove -26 495 137 3
	call DMove -2 496 136 3
	call DMove -7 667 140 3
	call DMove 19 668 117 3
	call KBMove "${Me.Name}" 61 668 127 3
	call KBMove "${Me.Name}" 33 668 164 3
	call KBMove "${Me.Name}" -32 668 162 3
	call KBMove "${Me.Name}" -27 668 98 3
	call KBMove "${Me.Name}" -13 668 209 3
	call DMove 0 668 60 3
	call IsPresent "TO FLOOR BOSS 05"
	while (${Return})
	{
		wait 10
		call IsPresent "TO FLOOR BOSS 05"
	}
	oc !c -Special All
	while (${Me.Y} > 600)
	{
		wait 10
	}
	call KBMove "${Me.Name}" 4 356 3 3
	
	call TanknSpank "${Named}"

}
function step005()
{
	call check_quest "Elements of Destruction: Waves of Order"
	if (${Return})
	{
		Me.Inventory[Query, Name =- "Inert Awuidor Purifying Rune"]:Use
		wait 50
		call DMove -43 351 4 3
		oc !c -Special "${Me.Name}"
		wait 30
		call DMove -1118 390 786 3
		call DMove -1117 393 806 3 30 FALSE FALSE 3
		oc !c -Special "${Me.Name}"
		call DMove -1118 390 783 3 30 FALSE FALSE 3
		call DMove -1154 387 716 3
		call DMove -1164 386 712 3 30 FALSE FALSE 5
		oc !c -Special "${Me.Name}"
	}
	
	call DMove -45 350 30 3
	
	do
	{
		if (!${Zone.Name.Equal["Myrist, the Great Library"]})
		{
			call MoveCloseTo Exit
			oc !c -Zone	
		}
		wait 200
	}
	while (!${Zone.Name.Equal["Myrist, the Great Library"]})
}
function FightinMud(string ActorName)
{
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]
	call CountAdds "${ActorName}" 200
	if (${Return}>0)
	{
		Killed:Set[FALSE]
		do
		{
			oc !c -pause
			call DMove 1263 465 20 3
			call DMove 1295 465 28 3 30 TRUE 
			call DMove 1308 465 30 3 30 TRUE FALSE 3
			call DMove 1310 465 38 3 30 TRUE FALSE 3
			call DMove 1332 465 32 3 30 TRUE FALSE 3
			call CountAdds "${ActorName}" 200
			if (${Return} > 2 && !${Me.InCombat})
				target "${ActorName}"
			Killed:Set[FALSE]
			oc !c -resume
			do
			{
				wait 10
			}
			while (!${Killed})
			Killed:Set[FALSE]
			oc !c -pause
			call DMove 1332 465 66 3 30 TRUE FALSE 3
			oc !c -resume
			do
			{
				wait 10
			}
			while (!${Killed})
			Killed:Set[FALSE]
			oc !c -pause
			call DMove 1382 465 64 3 30 TRUE
			call DMove 1388 465 29 3 30 TRUE FALSE 3
			oc !c -resume
			do
			{
				wait 10
			}
			while (!${Killed})
			Killed:Set[FALSE]
			call DMove 1370 465 40 3
			call DMove 1311 465 38 3
			call DMove 1282 465 19 3
	
			call CountAdds "${ActorName}" 200
			echo "Return is ${Return}"
		}
		while (${Return}>0)
	}
}
atom HandleAllEvents(string Message)
{
	;echo event catched : ${Message}
}