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

variable(script) int Stucky
variable(script) int SuperStucky
variable(script) bool CantSeeTarget
variable(script) int ScriptIdleTime
variable(script) int ZoneTime
variable(script) bool GiveUp

function main(string questname)
{
	variable int IdleTime
	variable float loc0 
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	
	if (!${Script["ToonAssistant"](exists)})
		relay all run EQ2Ethreayd/ToonAssistant

	do
	{
		
		echo Zone is ${Zone.Name} (${IdleTime} | ${ZoneTime})
		ZoneTime:Set[0]
		loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			
		if (!${Me.Grouped} &&!${Me.InCombatMode})
			eq2execute merc resume
		
		call MainChecks
		if (${Zone.Name.Find["Heroic"]}>0)
			call InHeroicZone
		if (${Me.IsIdle} && !${Me.InCombat})
			IdleTime:Inc
		Else
			IdleTime:Set[0]
		
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
		end Buffer:OgreInstanceController
		end ToonAssistant
		end OgreICAssistant
	}

	if (${Me.IsDead} && !${Me.Grouped})
	{
		wait 100
		echo Dead and Alone --- Reviving
		ogre end ic
		wait 100
		oc !c -letsgo ${Me.Name}
		oc !c -revive ${Me.Name}
		oc !c -pause ${Me.Name}
		wait 400
		oc !c -resume ${Me.Name}
		wait 100
		runICZone FALSE
	}
	
	call waitfor_Zoning
	call isGroupDead
	if (${Return})
	{
		wait 100
		echo Group wiped --- Reviving
		Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",FALSE]
		wait 10
		oc !c -letsgo
		oc !c -revive
		oc !c -pause
		wait 400
		call AutoRepair 90
		wait 50
		oc !c -repair
		oc !c -resume
		wait 100
		Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",TRUE]
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
	do
	{
		call ReturnEquipmentSlotHealth Primary
		echo in while (!${Me.IsDead(exists)})
		wait 10
	}
	while (!${Me.IsDead(exists)})
	
	if (${Me.IsIdle} && !${Me.InCombat})
		ScriptIdleTime:Inc
	else
		ScriptIdleTime:Set[0]
	if (${ScriptIdleTime} > 100)
	{
		echo I am Idle (${ScriptIdleTime}) and I don't know why
	}
	if (${ZoneTime} > 7200)
	{
		echo more than 2 hours in the same zone - rebooting loop (call RebootLoop from OgreICAssistant) 
		echo deactivated until I know what to do here
		;call RebootLoop
	}
}
function InHeroicZone()
{
	echo in Heroic Zone
	ZoneTime:Inc
	call MainChecks
	if (${Ogre_Instance_Controller.Status.Equal["Idle_NotRunning"]} && !${Me.InCombat})
	{
		echo I got into the ${Ogre_Instance_Controller.Status} condition !
		Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",FALSE]
		oc !c -letsgo
		oc !c -evac
		oc !c -revive
		call AutoRepair 90
		wait 50
		oc !c -repair
		wait 100
		if (!${GiveUp})
			Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",TRUE]
		else
		{
			oc !c -Zone
			wait 600
			GiveUp:Set[FALSE]
			Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",TRUE]
		}
	}
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
}
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
}