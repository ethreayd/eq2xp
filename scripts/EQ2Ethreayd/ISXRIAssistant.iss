#define AUTORUN "num lock"
#define CENTER p
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
#define PAGEUP "Page Up"
#define PAGEDOWN "Page Down"
#define WALK shift+r
#define ZOOMIN "Num +"
#define ZOOMOUT "Num -"
#define JUMP Space
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CDZones.iss"
variable(script) bool RIStart
variable(script) bool StoneSkin
variable(script) int RICrashed
variable(script) int Stucky
variable(script) bool DoDrones
variable(script) bool DoSlurp
variable(script) bool DoMiniMud
variable(script) bool MeltingMud
variable(script) bool Mudwalker

function main(string questname)
{
	variable int IdleTime
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	RIStart:Set[TRUE]
	do
	{
		if (!${Me.Grouped} &&!${Me.InCombatMode})
			eq2execute merc resume
		if ${Zone.Name.Equal["Vegarlson: Ruins of Rathe \[Solo\]"]}
			call Zone_VegarlsonRuinsofRatheSolo
		if ${Zone.Name.Equal["Awuidor: The Nebulous Deep \[Solo\]"]}
			call Zone_AwuidorTheNebulousDeepSolo
		if ${Zone.Name.Equal["Eryslai: The Bixel Hive \[Solo\]"]}
			call Zone_EryslaiTheBixelHiveSolo
		if ${Zone.Name.Equal["Doomfire: The Enkindled Towers \[Solo\]"]}
			call Zone_DoomfireTheEnkindledTowersSolo
		if ${Me.IsIdle}
			IdleTime:Inc
		Else
			IdleTime:Set[0]
		ExecuteQueued
		if ${IdleTime} > 36
			call RebootLoop
		wait 1000
		
	}
	while (TRUE)
}
function MainChecks()
{
	variable float loc0=${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z}]}
		
	echo in MainChecks Loop
	if (!${Me.Grouped} && !${Me.InCombatMode})
	{
		eq2execute merc resume
		wait 100
	}	
	if (!${Script["Buffer:RunInstances"](exists)} && !${Me.InCombatMode})
	{
		RICrashed:Inc
		echo RI seems crashed (test N=${RICrashed})
		if (${RICrashed}>1)
		{
			echo RI crashed (${RICrashed}) - restarting zone
			RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
			wait 100
			call Evac
			wait 600
			call IsPresent Exit 15
			if (!${Return} && !${Me.IsDead})
			{
				RI
				wait 100
				RICrashed:Set[0]
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			else
			{
				call MoveCloseTo Exit
				call ActivateVerbOn Exit Exit TRUE
				wait 20
				RIMUIObj:Door[${Me.Name},1]
				wait 300
				echo restart RZ if needed
			}
		}
	}
	if (${Me.IsDead} && !${Me.Grouped})
	{
		wait 100
		echo Dead and Alone --- Reviving
		RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
		wait 100
		RIMUIObj:Revive[${Me.Name}]
		wait 400
		RI
		wait 100
		UIElement[RI].FindUsableChild[Start,button]:LeftClick
	}
	call CheckS
	if (!${Return} && !${Me.IsDead})
		echo must be stunned or stifled
	wait 20
	call CheckStuck ${loc0}
	if (${Return} && !${Me.InCombatMode})
		Stucky:Inc
	else
		Stucky:Set[0]
	
	if ${Stucky}>10
	{
		call UnstuckR 10
		Stucky:Set[0]
	}	
	call ReturnEquipmentSlotHealth Primary
	if ((${Me.InventorySlotsFree}<5 && !${Me.IsDead} && !${Me.InCombatMode}) || ${Return}<20)
		call RebootLoop	
}
function Zone_AwuidorTheNebulousDeepSolo()
{
	do
	{
		call MainChecks
		call CloseCombat "Pontis Aqueous" 35
		if (${Me.X} < -1350 && ${Me.X} > -1365 &&  ${Me.Y} < 615 && ${Me.Y} > 600 && ${Me.Z} < 30 && ${Me.Z} > 15)
		{
			echo correcting ISXRI Bug with stuck
			call DMove -1376 610 19 2
		}
		if (${Me.X} < 1370 && ${Me.X} > -1355 &&  ${Me.Y} < 620 && ${Me.Y} > 600 && ${Me.Z} < 30 && ${Me.Z} > 15)
		{
			echo correcting ISXRI Bug with stuck
			call DMove 1376 610 19 2
		}
		if (${Me.X} < 10 && ${Me.X} > -10 &&  ${Me.Y} < 615 && ${Me.Y} > 600 && ${Me.Z} < -1300 && ${Me.Z} > -1315)
		{
			echo correcting ISXRI Bug with stuck
			call DMove 1 611 -1323 2
		}
		if (${Me.X} < 10 && ${Me.X} > -10 &&  ${Me.Y} < 615 && ${Me.Y} > 600 && ${Me.Z} > 1295 && ${Me.Z} < 1310)
		{
			echo correcting ISXRI Bug with stuck
			call DMove 0 611 1314 2
		}
		wait 1000
	}
	while (${Zone.Name.Equal["Awuidor: The Nebulous Deep \[Solo\]"]})
}
function Zone_DoomfireTheEnkindledTowersSolo()
{
	echo Entering Doomfire Solo loop
	do
	{
		call MainChecks
		call CloseCombat "Ra-Sekjet, the Molten" 60 TRUE
		wait 1000
	}
	while (${Zone.Name.Equal["Doomfire: The Enkindled Towers \[Solo\]"]})
}
function Zone_EryslaiTheBixelHiveSolo()
{
	variable string Named
	do
	{
		call MainChecks
		Named:Set["Daishani"]
		
		call IsPresent "${Named}" 50
		if (${Return} && ${Actor["${Named}"].IsAggro})
		{
			echo correcting ISXRI Bug with ${Named} fight...
			face "${Named}"
			target "${Named}"
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			call DMove -634 403 -161 3 30 TRUE TRUE 10
			eq2execute merc attack
			wait 600
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		call IsPresent "?" 5
		if (${Return} && ${Me.X} < -540 && ${Me.X} > -550 &&  ${Me.Y} < 650 && ${Me.Y} > 640 && ${Me.Z} < -180 && ${Me.Z} > -190)
		{
			echo correcting ISXRI Bug with shiny
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			wait 20
			call DMove -530 643 -179 1
			call DMove -520 642 -176 1 30 FALSE FALSE 3
			call DMove -530 644 -170 1 30 FALSE FALSE 3
			call DMove -544 648 -179 1 30 FALSE FALSE 3
			wait 10
			ogre hl
			wait 100
			ogre end hl
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		call IsPresent "?" 10
		if (${Return} && ${Me.X} < -665 && ${Me.X} > -675 &&  ${Me.Y} < 410 && ${Me.Y} > 395 && ${Me.Z} < -185 && ${Me.Z} > -200)
		{
			echo correcting ISXRI Bug with shiny
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			wait 20
			call DMove -665 403 -190 2 30 FALSE FALSE 3
			call DMove -670 403 -197 2 30 FALSE FALSE 3
			call DMove -676 403 -197 2 30 FALSE FALSE 3
			wait 20
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			ogre hl
			wait 100
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			ogre hl
			wait 100
			ogre end hl
			call DMove -676 403 -197 2 30 FALSE FALSE 3
			call DMove -670 403 -197 2 30 FALSE FALSE 3
			call DMove -665 403 -190 2 30 FALSE FALSE 3
			wait 20
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		wait 1000
	}
	while (${Zone.Name.Equal["Eryslai: The Bixel Hive \[Solo\]"]})
}
function Zone_VegarlsonRuinsofRatheSolo()
{
	do
	{
		call MainChecks
		call IsPresent "Runic Stone" 2000
		eq2execute loc
		if (${Me.InCombatMode} && ${Me.Target.Distance}>30)
			press F1
		if (!${Return} && ${Me.X} < -230 && ${Me.X} > -320 &&  ${Me.Y} < 45 && ${Me.Y} > 25 && ${Me.Z} < -180 && ${Me.Z} > -270)
		{
			call IsPresent "Living Stone" 100
			if (!${Return})
			{
				echo killing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				RIStart:Set[FALSE]
				RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
				call DMove -291 37 -224 3 30 TRUE TRUE 10
				call gotoSlurpgaloop
			}
		}
		call IsPresent "Glimmerstone" 20
		if (${Return})
		{
			echo killing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
			RIStart:Set[FALSE]
			RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
			call DMove -291 37 -224 3 30 TRUE TRUE 10
			call FightGlimmerstone
		}
		call IsPresent "Runic Stone" 20
		if (${Return})
		{
			do
			{
				call MoveCloseTo "Runic Stone"
				call ActivateVerbOn "Runic Stone" Push TRUE
				wait 10
				call IsPresent "Runic Stone" 20
			}
			while (${Return})
		}
		call IsPresent "vekerchiki mound" 50
		if (${Return} && ${Me.X} < 280 && ${Me.X} > 250 &&  ${Me.Y} < 115 && ${Me.Y} > 100 && ${Me.Z} < 200 && ${Me.Z} > 180)
		{
			echo going to mound
			RIStart:Set[FALSE]
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			do
			{
				call MoveCloseTo "vekerchiki mound"
				call TanknSpank "vekerchiki mound" 25
				wait 50
				call IsPresent "vekerchiki mound" 20
			}
			while (${Return})
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			RIStart:Set[TRUE]
		}
		call IsPresent "vekerchiki mound" 50
		if (${Return} && ${Me.X} < 240 && ${Me.X} > 210 &&  ${Me.Y} < 115 && ${Me.Y} > 100 && ${Me.Z} < 210 && ${Me.Z} > 180)
		{
			echo going to mound
			RIStart:Set[FALSE]
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			do
			{
				call MoveCloseTo "vekerchiki mound"
				call TanknSpank "vekerchiki mound" 25
				wait 50
				call IsPresent "vekerchiki mound" 20
			}
			while (${Return})
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			RIStart:Set[TRUE]
		}
		call IsPresent "muddite lurcher" 10
		if (${Return} && !${Mudwalker})
		{
			echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			RIStart:Set[FALSE]
			call DMove -68 24 577 3 30 TRUE
			call DoMud
			call DMove -53 15 601 3 30 TRUE
			call DoMud
			call DMove -52 17 625 3 30 TRUE
			call DoMud
			call DMove -48 18 670 3 30 TRUE
			call DoMud
			call DMove -77 15 685 3 30 TRUE
			call DoMud
			call DMove -68 24 577 3 30 TRUE
			call DoMud
			call DMove -63 22 738 3 30 TRUE
			call DoMud
			call DMove -68 24 577 3 30 TRUE
			call DoMud
			call DMove -77 15 685 3 30 TRUE
			call DoMud
			call DMove -48 18 670 3 30 TRUE
			call DoMud
			call DMove -52 17 625 3 30 TRUE
			call DoMud
			call DMove -53 15 601 3 30 TRUE
			call DoMud
			call DMove -68 24 577 3 30 TRUE
			call DoMud
			RIStart:Set[TRUE]
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		ExecuteQueued
		wait 10
	}
	while (${Zone.Name.Equal["Vegarlson: Ruins of Rathe \[Solo\]"]})
}
function DoMud()
{
	variable int Counter
	echo starting DoMud function
	wait 20
	if (!${Me.InCombatMode})
	{
		call IsPresent "muddite lurcher" 20 TRUE
		if (${Return})
		{
			call MoveCloseTo "muddite lurcher"
			call ActivateVerbOn "muddite lurcher" "Apply sticky vekerchiki mud" TRUE
			wait 20
			if ${DoMiniMud}
			{
				do
				{
					wait 50		
					call IsPresent "minimud" 30
				}
				while (!${Return})
				call TanknSpank "minimud" 30
				DoMiniMud:Set[FALSE]
			}
		}
	}
	else
		call DoMud
}
function RebootLoop()
{
	echo rebooting loop
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RZ.xml"
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RZm.xml"
	if (${Script["CDLoop"](exists)})
		end CDLoop
	if (${Script["Buffer:RZ"](exists)})
		end Buffer:RZ
	
	call goto_GH
	call GuildH
	if (!${Script["CDLoop"](exists)})
		run EQ2Ethreayd/CDLoop
}
function FightGlimmerstone()
{
	variable string Named
	Named:Set[Glimmerstone]
	echo starting ${Named} fight script
	do
	{
		wait 10
		call IsPresent "${Named}" 20
	}
	while (!${Return})
	StoneSkin:Set[TRUE]
	do
	{
		face "${Named}" 
		target "${Named}"
		wait 10
		call IsPresent "${Named}" 200	
	}
	while (!${StoneSkin} && ${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	call DMove -314 38 -234 3 30 TRUE FALSE 10
	call DMove -340 37 -235 3 30 TRUE FALSE 5
	call PKey "Page Up" 3
	call PKey ZOOMOUT 20
	call ActivateAggro "Runic Stone" Activate 10
	StoneSkin:Set[FALSE]
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		target "Runic Stone"
		wait 10
		call IsPresent "Runic Stone" 10
	}
	while (${Return})
	call DMove -340 37 -235 3 30 TRUE FALSE 5
	call DMove -314 38 -234 3 30 TRUE FALSE 10
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	do
	{
		call PullNamed "${Named}"
		wait 10
		call IsPresent "${Named}" 200	
	}
	while (!${StoneSkin} && ${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	call DMove -309 37 -176 3 30 TRUE FALSE 10
	call DMove -323 36 -172 3 30 TRUE FALSE 5
	call ActivateAggro "Runic Stone" Activate 10
	StoneSkin:Set[FALSE]
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		target "Runic Stone"
		wait 10
		call IsPresent "Runic Stone" 10
	}
	while (${Return})
	call DMove -323 36 -172 3 30 TRUE FALSE 5
	call DMove -309 37 -176 3 30 TRUE FALSE 10
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	do
	{
		call PullNamed "${Named}"
		wait 10
		call IsPresent "${Named}" 200	
	}
	while (!${StoneSkin} && ${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	call DMove -271 38 -215 3 30 TRUE FALSE 10
	call DMove -236 32 -242 3 30 TRUE FALSE 5
	call ActivateAggro "Runic Stone" Activate 10
	StoneSkin:Set[FALSE]
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		target "Runic Stone"
		wait 10
		call IsPresent "Runic Stone" 10
	}
	while (${Return})
	call DMove -236 32 -242 3 30 TRUE FALSE 5
	call DMove -268 38 -213 3 30 TRUE FALSE 10
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	do
	{
		call PullNamed "${Named}"
		wait 10
		call IsPresent "${Named}" 200		
	}
	while (!${StoneSkin} && ${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	call DMove -304 35 -196 3 30 TRUE FALSE 10
	call DMove -271 32 -155 3 30 TRUE FALSE 10
	call DMove -243 33 -157 3 30 TRUE FALSE 5
	if (!${DoSlurp})
		call ActivateAggro "Runic Stone" Activate 10
	StoneSkin:Set[FALSE]
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		target "Runic Stone"
		wait 10
		call IsPresent "Runic Stone" 10
	}
	while (${Return})
	call DMove -243 33 -157 3 30 TRUE FALSE 5
	call DMove -284 32 -160 3 30 TRUE FALSE 10
	call DMove -278 37 -213 3 30 TRUE FALSE 10
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	do
	{
		call PullNamed "${Named}"
		wait 10
		call IsPresent "${Named}" 200		
	}
	while (!${StoneSkin} && ${Return})
	call TanknSpank "${Named}"
	wait 20
	call PKey "Page Down" 3
	call gotoSlurpgaloop
}
function gotoSlurpgaloop()
{
	variable string Named
	Named:Set[Slurpgaloop]
	echo Glimmerstone is done
	call DMove -295 37 -232 3
	call DMove -270 37 -213 3
	call DMove -253	39 -219 3
	call DMove -193 32 -172 3
	call DMove -182 31 -149 3
	call DMove -118 33 -123 3
	call DMove -123 39 -84 3
	call DMove -93 50 -50 3
	call DMove -4 97 -19 3
	call DMove -10 106 16 3
	call DMove -24 106 16 3
	call DMove -20 111 27 2
	call DMove -8 88 60 3
	call DMove 4 104 58 3
	call DMove 1 111 86 3
	call DMove 44 94 164 3
	call DMove 91 93 158 3
	call DMove 113 92 174 3
	call DMove 156 89 180 3
	call DMove 202 107 157 2
	call DMove 235 109 193 3
	call DMove 259 109 200 3
	wait 20
	call IsPresent "${Named}" 2000
	if (${Return})
	{
		RI
		wait 50
		UIElement[RI].FindUsableChild[Start,button]:LeftClick
		RIStart:Set[TRUE]
		do
		{
			wait 10
			call IsPresent "${Named}" 500
		}
		while (${Return})
		echo Slurpgaloop is done
		DoDrones:Set[TRUE]
		echo activating DoDrones variable at ${DoDrones}
		;if (${Me.Y} < 50)
		call gotoForrestBarrens
	}
	else
	{
		call DMove 255 110 196 3
		call DMove 255 76 271 3
		call TanknSpank "vekerchiki mound" 25
		call DMove 280 77 312 3
		call gotoHeaper
	}
}
function gotoForrestBarrens()
{
	echo killing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
	RIStart:Set[FALSE]
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
	call DMove 407 18 325 3
	call DMove 383 22 324 3
	call DMove 375 26 307 2
	call DMove 383 23 284 3
	call DMove 395 41 221 3
	call DMove 445 37 161 2
	ogre hl
	wait 100
	ogre end hl
	call DMove 401 40 224 3
	call DMove 381 30 267 3
	call DMove 365 42 287 3
	call DMove 353 47 312 3
	call DMove 310 77 309 3
	call gotoHeaper
}
function gotoHeaper()
{	
	call DMove 275 78 317 3
	call DMove 230 76 297 3
	call TanknSpank "vekerchiki mound" 25
	call DMove 193 70 307 3
	call DMove 137 57 286 3
	call DMove 119 57 318 3
	call TanknSpank "vekerchiki mound" 25
	call DMove 145 61 344 3
	call DMove 130 44 377 3
	call TanknSpank "vekerchiki mound" 25
	call DMove 223 41 396 3
	call TanknSpank "vekerchiki mound" 25
	call DMove 204 40 413 3
	call TanknSpank "vekerchiki mound" 25
	call DMove 266 48 481 3
	call TanknSpank "vekerchiki mound" 25
	call DMove 234 39 445 3
	call DMove 195 47 472 3
	call TanknSpank "vekerchiki mound" 25
	wait 20
	RI
	wait 50
	UIElement[RI].FindUsableChild[Start,button]:LeftClick
	RIStart:Set[TRUE]
}

atom HandleAllEvents(string Message)
{
	if (${Message.Equal["Can't see target"]})
	{
		 eq2execute gsay ${Message}
	}
	if (${Message.Equal["Too far away"]})
	{
		 eq2execute gsay ${Message}
	}
	if (${Message.Find["seeks protection within the stones"]}>0)
	{
		echo Named has stoneskin on
		StoneSkin:Set[TRUE]
	}
	if (${Message.Find["deafening,"]}>0)
	{
		echo Named Slurpgaloop is spawned
		DoSlurp:Set[TRUE]
	}
	if (${Message.Find["disturbance of the hive has caused an enormous"]}>0)
	{
		echo Named Heaper is spawned
		DoDrones:Set[FALSE]
	}
	if (${Message.Find["stirs in the center of one of the mud"]}>0)
	{
		echo Named Mudwalker is spawned
		Mudwalker:Set[TRUE]
	}
	if (${Message.Find["dodrones"]}>0)
	{
		echo manual DoDrones set at TRUE
		DoDrones:Set[TRUE]
	}
	if (${Message.Find["flows out of the Muddy Lagoon"]}>0)
	{
		echo MiniMud is spawned
		DoMiniMud:Set[TRUE]
	}
	if (${Message.Find["Get out of the water"]}>0)
	{
		echo Melting in mud
		MeltingMud:Set[TRUE]
	}
}
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
}