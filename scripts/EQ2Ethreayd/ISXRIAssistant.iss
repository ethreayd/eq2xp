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
variable(script) int RICrashed

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
function Zone_VegarlsonRuinsofRatheSolo()
{
	do
	{
		call MainChecks
		if (${Me.X}<-270 && ${Me.X}>-300 && ${Me.Z}>-244 && ${Me.Z}<-200 && ${RIStart})
		{
			;UIElement[RI].FindUsableChild[Start,button]:LeftClick
			RIStart:Set[FALSE]
			RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
			echo pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
			call gotoSlupgaloop
		}
		if (${Me.X}<-60 && ${Me.X}>-80 && ${Me.Z}>600 && ${Me.Z}<690 && ${RIStart})
		{
			;UIElement[RI].FindUsableChild[Start,button]:LeftClick
			RIStart:Set[FALSE]
			RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
			echo pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
			call gotoForrestBarrens
		}
		ExecuteQueued
		wait 10
	}
	while (${Zone.Name.Equal["Vegarlson: Ruins of Rathe \[Solo\]"]})
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
			call DMove -634 403 -161 3
			eq2execute merc attack
			wait 600
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		call IsPresent "?" 5
		if (${Return} && ${Me.X} < -540 && ${Me.X} > -550 &&  ${Me.Y} < 650 && ${Me.Y} > 640 && ${Me.Z} < -180 && ${Me.Z} > -190)
		{
			echo correcting ISXRI Bug with shiny
			
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			;call DMove -634 403 -161 3
			;eq2execute merc attack
			;wait 600
			;UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		wait 1000
	}
	while (${Zone.Name.Equal["Eryslai: The Bixel Hive \[Solo\]"]})
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
function MainChecks()
{
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
	call ReturnEquipmentSlotHealth Primary
	if ((${Me.InventorySlotsFree}<5 && !${Me.IsDead} && !${Me.InCombatMode}) || ${Return}<20)
		call RebootLoop	
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
function gotoSlupgaloop()
{
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
	RI
	wait 50
	UIElement[RI].FindUsableChild[Start,button]:LeftClick
	RIStart:Set[TRUE]
}
function CloseCombat(string Named, float Distance, bool MoveIn)
{
	call IsPresent "${Named}" ${Distance}
		
	if (${Return} && ${Actor["${Named}"].IsAggro})
		{
			echo correcting ISXRI Bug with ${Named} fight...
			face "${Named}"
			target "${Named}"
			if ${MoveIn}
				call MoveCloseTo "${Named}"
			else
				eq2execute merc attack
		}
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
}
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
}