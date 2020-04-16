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

variable(script) bool StoneSkin
variable(script) int Stucky
variable(script) int SuperStucky
variable(script) bool CantSeeTarget
variable(script) int ScriptIdleTime
variable(script) int ZoneTime

function main(string questname)
{
	variable int IdleTime
	variable int BlindingStuck
	variable int AurelianCoastStuck
	variable float loc0 
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	

	do
	{
		if (${Script["ToonAssistant"](exists)})
			end ToonAssistant
		echo Zone is ${Zone.Name} (${BlindingStuck} | ${AurelianCoastStuck} | ${IdleTime} | ${ZoneTime})
		ZoneTime:Set[0]
		loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			
		if (!${Me.Grouped} &&!${Me.InCombatMode})
			eq2execute merc resume
		
		if ${Zone.Name.Equal["Sanctus Seru: Echelon of Order \[Solo\]"]}
			call Zone_SanctusSeruEchelonofOrderSolo
		if ${Zone.Name.Equal["Sanctus Seru: Arx Aeturnus \[Solo\]"]}
			call Zone_SanctusSeruArxAeturnusSolo
		if ${Zone.Name.Equal["Aurelian Coast: Reishi Rumble \[Solo\]"]}
			call Zone_AurelianCoastReishiRumbleSolo
		if ${Zone.Name.Equal["Aurelian Coast: Maiden's Eye \[Solo\]"]}
			call Zone_AurelianCoastMaidensEyeSolo
		else
			call MainChecks
		if (${Me.IsIdle} && !${Me.InCombat})
			IdleTime:Inc
		Else
			IdleTime:Set[0]
		
		if (${Zone.Name.Left[12].Equal["The Blinding"]})
		{
			BlindingStuck:Inc
			call CheckStuck ${loc0}
			if (${Return})
			{
				echo seems stuck in the Blinding
				BlindingStuck:Inc
				BlindingStuck:Inc
				BlindingStuck:Inc
				BlindingStuck:Inc
			}
		}
		else
			BlindingStuck:Set[0]
		if (${Zone.Name.Left[14].Equal["Aurelian Coast"]})
		{
			AurelianCoastStuck:Inc
			call CheckStuck ${loc0}
			if (${Return})
			{
				echo seems stuck in ${Zone.Name}
				AurelianCoastStuck:Inc
				AurelianCoastStuck:Inc
				AurelianCoastStuck:Inc
				AurelianCoastStuck:Inc
			}
		}
		else
			AurelianCoastStuck:Set[0]	
		ExecuteQueued
		wait 300
	}
	while (TRUE)
}
function MainChecks()
{
	variable float loc0=${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z}]}
	echo in MainChecks Loop (${ScriptIdleTime})
	
	if (!${Me.Grouped} && !${Me.InCombatMode})
	{
		eq2execute merc resume
		wait 100
	}
	if (${ScriptIdleTime}>60 && ${Me.IsDead})
	{
		eq2execute merc suspend
		wait 10
		ChoiceWindow:DoChoice1
	}
	if (${Me.IsDead} && !${Me.Grouped})
	{
		wait 100
		echo Dead and Alone --- Reviving
		ogre end ic
		wait 100
		oc !c ${Me.Name} -letsgo 
		oc !c ${Me.Name} -revive 
		oc !c ${Me.Name} -pause
		wait 400
		oc !c ${Me.Name} -resume		
		wait 100
		call RunICZone FALSE
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
	if ${SuperStucky}>30
	{
		SuperStucky:Set[0]
		echo should deal with that
	}	
	call ReturnEquipmentSlotHealth Primary
	if ((${Me.InventorySlotsFree}<5 && !${Me.IsDead} && !${Me.InCombatMode}) && ${Me.IsDead(exists)} || (${Return}<11 && ${Return}>=0))
	{
		echo RebootLoop if ((${Me.InventorySlotsFree}<5 && !${Me.IsDead} && !${Me.InCombatMode}) && ${Me.IsDead(exists)} || (${Return}<11 && ${Return}>0))
		call RebootLoop
	}
	if (${Me.IsIdle} && !${Me.InCombat})
		ScriptIdleTime:Inc
	Else
		ScriptIdleTime:Set[0]
	if (${ScriptIdleTime} > 100)
	{
		echo I am Idle (${ScriptIdleTime}) and I don't know why
	}
	if (${TimeZone} > 7200)
	{
		echo more than 2 hours in the same zone - rebooting loop (from RebootLoop) 
		echo deactivated until I know what to do here
		;call RebootLoop
	}
}

function Zone_SanctusSeruEchelonofOrderSolo()
{
	ScriptIdleTime:Set[0]
	if (!${Script["ToonAssistant"](exists)})
		run EQ2Ethreayd/ToonAssistant
	do
	{
		call MainChecks
	}
	while (${Zone.Name.Equal["Sanctus Seru: Echelon of Order \[Solo\]"]})
}
function Zone_SanctusSeruArxAeturnusSolo()
{
	ScriptIdleTime:Set[0]
	if (!${Script["ToonAssistant"](exists)})
		run EQ2Ethreayd/ToonAssistant
	do
	{
		call MainChecks
	}
	while (${Zone.Name.Equal["Sanctus Seru: Arx Aeturnus \[Solo\]"]})
}
function Zone_AurelianCoastReishiRumbleSolo()
{
	ScriptIdleTime:Set[0]
	
	if (!${Script["ToonAssistant"](exists)})
		run EQ2Ethreayd/ToonAssistant
	do
	{
		call MainChecks
	}
	while (${Zone.Name.Equal["Aurelian Coast: Reishi Rumble \[Solo\]"]})
}
function Zone_AurelianCoastMaidensEyeSolo()
{
	
	ScriptIdleTime:Set[0]
	if (!${Script["ToonAssistant"](exists)})
		run EQ2Ethreayd/ToonAssistant
	do
	{
		call MainChecks
	}
	while (${Zone.Name.Equal["Aurelian Coast: Maiden's Eye \[Solo\]"]})
}

atom HandleAllEvents(string Message)
{
	if (${Message.Equal["Can't see target"]})
	{
		eq2execute gsay ${Message}
		CantSeeTarget:Set[TRUE]
	}
	if (${Message.Equal["Too far away"]})
	{
		 eq2execute gsay ${Message}
	}
	if (${Message.Find["ve got better things to do"]}>0)
	{
		QueueCommand call RebootLoop
	}
	if (${Message.Find["must first be taken down"]}>0)
	{
		oc !c ${Me.Name} -Special
	}
	if (${Message.Find["Saperlipopette"]}>0 && !${RI_Var_Bool_Paused})
	{
		UIElement[RI].FindUsableChild[Start,button]:LeftClick
		QueueCommand UIElement[RI].FindUsableChild[Start,button]:LeftClick
	}
}
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
}