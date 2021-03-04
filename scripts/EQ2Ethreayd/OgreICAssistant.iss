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
#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

variable(script) int Stucky
variable(script) int SuperStucky
variable(script) bool CantSeeTarget
variable(script) int ScriptIdleTime
variable(script) int ZoneTime
variable(script) bool GiveUp
variable(script) string ZoneName

function main(string questname)
{
	variable int IdleTime
	variable float loc0 
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	
	if (!${Script["ToonAssistant"](exists)})
		relay all run EQ2Ethreayd/ToonAssistant
	oc !c -resume
	do
	{	
		echo Zone is ${Zone.Name} (${IdleTime} | ${ZoneTime})
		if (!${Zone.Name.Equal["${ZoneName}"]}) 
		{
			echo if (!${Zone.Name.Equal["${ZoneName}"]})
			ZoneTime:Set[0]
			ZoneName:Set["${Zone.Name}"]
		}
		else
			ZoneTime:Inc
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
		if (${Zone.Name.Equal["Aurelian Coast: Reishi Rumble \[Event Heroic\]"]})
			call AurelianCoastReishiRumbleEventHeroic
		if (${Zone.Name.Equal["Fordel Midst: The Listless Spires \[Event Heroic\]"]})
			call FordelMidstTheListlessSpiresEventHeroic
		if (${Zone.Name.Equal["Fordel Midst: Bizarre Bazaar \[Heroic\]"]})
			call FordelMidstBizarreBazaarHeroic
		if ${Zone.Name.Equal["Sanctus Seru: Echelon of Divinity \[Heroic\]"]}
			call Zone_SanctusSeruEchelonofDivinityHeroic
		if ${Zone.Name.Equal["Sanctus Seru: Echelon of Order \[Heroic\]"]}
			call Zone_SanctusSeruEchelonofOrderHeroic
		if ${Zone.Name.Equal["The Venom of Ssraeshza \[Event Heroic\]"]}
			call Zone_TheVenomofSsraeshzaEventHeroic
		if ${Zone.Name.Equal["The Vault of Ssraeshza \[Heroic\]"]}
			call Zone_TheVaultofSsraeshzaHeroic
		if (${Zone.Name.Right[10].Equal["Guild Hall"]})
			ogre end ic
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
		call EndIC
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
		call PauseIC
		call UnstuckR 10
		Stucky:Set[0]
		call ResumeIC
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
		call IsPublicZone
		if (${Return} && ${Script["Buffer:OgreInstanceController"](exists)} && ${Me.GroupCount}>2)
			end Buffer:OgreInstanceController
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
	call SelectDifficulty
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
function FordelMidstTheListlessSpiresEventHeroic()
{
	echo in function FordelMidstTheListlessSpiresEventHeroic (${ZoneTime})
	call IsPresent "Aurelian Coast"
	if (!${Me.InCombatMode} && ${Me.X} < 290 && ${Me.X} > 250 &&  ${Me.Y} > -50 && ${Me.Y} < -20 && ${Me.Z} < 750 && ${Me.Z} > 720 && ${Return})
	{
		echo In front of exit as dummies
		call PauseIC
		wait 50
		call ResumeIC
		wait 5
		oc !c -Special
	}
}
function AurelianCoastReishiRumbleEventHeroic()
{
	echo in function AurelianCoastReishiRumbleEventHeroic (${ZoneTime})
}
function FordelMidstBizarreBazaarHeroic()
{
	echo in function FordelMidstBizarreBazaarHeroic (${ZoneTime})
}
function Zone_SanctusSeruEchelonofOrderHeroic()
{
	variable int Counter=1
	echo in function Zone_SanctusSeruEchelonofOrderHeroic (${ZoneTime})
	if (!${Me.InCombatMode} && ${Me.X} < -365 && ${Me.X} > -385 &&  ${Me.Y} > 80 && ${Me.Y} < 95 && ${Me.Z} < 10 && ${Me.Z} > -10)
	{
		echo In front of Level Circle
		wait 50
		Counter:Inc
		if ${Counter}>10
			call SelectDifficulty
	}
}
function Zone_SanctusSeruEchelonofDivinityHeroic()
{
	variable int ArxCounter=1
	echo in function Zone_SanctusSeruEchelonofDivinityHeroic (${ZoneTime})
	
	if (!${Me.InCombatMode} && ${Me.X} < -190 && ${Me.X} > -210 &&  ${Me.Y} > 170 && ${Me.Y} < 190 && ${Me.Z} < 10 && ${Me.Z} > -10 && ${ArxCounter}<3 )
	{
		echo In front of Arx Seru Door (ArxCounter at ${ArxCounter})
		call PauseIC
		wait 50
		oc !c -Special
		wait 50
		relay all run EQ2Ethreayd/wrap ClickOn Door
		wait 50
		if ${Me.Y} < 90
		{
			call GroupDistance
			if ${Return}>15
				relay all run EQ2Ethreayd/wrap ClickOn Door
		}
		call ResumeIC
		ArxCounter:Inc
	}
	if (${ArxCounter}>2)
	{
		echo Trying to do missed step
		call PauseIC
		oc !c -letsgo
		oc !c -Resume
		call DMove -226 180 1 3
		call DMove -170 180 -132 3
		call DMove -120 176 -163 3
		call DMove -143 179 -202 3
		call UseInventory "Horn of the Fallen"
		wait 300
		call Converse "Unhilynd" 10
		call TanknSpank "Unhilynd" 200
		call DMove -92 176 -174 3
		call DMove -158 180 -127 3
		call DMove -222 180 -77 3
		call DMove -248 181 -7 3
		call DMove -196 183 -1 3
		call DMove -244 181 0 3
		oc !c -CSDefault
		call TanknSpank "Prysmerah" 100
		oc !c -letsgo
		call DMove -196 183 -1 3
		oc !c -CSDefault
		call ResumeIC
	}
}
function Zone_TheVenomofSsraeshzaEventHeroic()
{
	echo in function Zone_TheVenomofSsraeshzaEventHeroic (${ZoneTime})
	if (!${Me.InCombatMode} && ${Me.X} < 40 && ${Me.X} > 25 &&  ${Me.Y} > -200 && ${Me.Y} < -175 && ${Me.Z} < 260 && ${Me.Z} > 230)
	{
		echo In front of Level Circle
		call SelectDifficulty
		wait 50
		if (!${Me.InCombatMode} && ${Me.X} < 40 && ${Me.X} > 25 &&  ${Me.Y} > -200 && ${Me.Y} < -175 && ${Me.Z} < 260 && ${Me.Z} > 230)
		{
			call PauseIC
			call DMove 37 -188 269 3
			oc !c -resume
			oc !c -letsgo
			call DMove 35 -188 300 3
			call DMove 35 -188 335 3
			oc !c -CSDefault
			call ResumeIC
		}
	}
}
function Zone_TheVaultofSsraeshzaHeroic()
{
	echo in function Zone_TheVaultofSsraeshzaHeroic (${ZoneTime})
	/*
	if (!${Me.InCombatMode} && ${Me.X} < -250 && ${Me.X} > -275 &&  ${Me.Y} > -150 && ${Me.Y} < -175 && ${Me.Z} < 790 && ${Me.Z} > 760)
	{
		call WaitforAll
		call PauseIC
		oc !c -letsgo
		oc !c -OgreFollow All ${Me.Name}
		call DMove -262 -161 752 3
		oc !c -CSDefault
		call ResumeIC
	}
	*/
}
function SelectDifficulty()
{
	variable string Selector="door entrance - difficulty setting"
	variable string SelectAction="Open"
	variable bool MustSelect
	echo in SelectDifficulty function
	echo Pausing IC from SelectDifficulty function
	call PauseIC
	
	call IsPresent "difficulty setting" 25
	if (${Return})
		MustSelect:Set[TRUE]
	call IsPresent "starting circle - difficulty setting" 25
	if (${Return})
	{
		Selector:Set["starting circle - difficulty setting"]
		SelectAction:Set["Access"]
	}
	call IsPresent "tunnel blocker on - difficulty setting sign" 15
	if (${Return})
	{
		Selector:Set["tunnel blocker on - difficulty setting sign"]
	}
	echo if (!${Me.InCombatMode} && ${MustSelect} && ${ZoneTime}>0)
	if (!${Me.InCombatMode} && ${MustSelect} && ${ZoneTime}>0)
	{
		call ActivateVerbOn "${Selector}" "${SelectAction}"
		wait 20
		OgreBotAPI:ReplyDialog[${Me.Name},1]
		wait 20
		OgreBotAPI:Select_Zone_Version["All"]
		wait 10
		oc !c -Select_Zone_Version all
	}
	wait 50
	call ResumeIC
	oc !c -resume
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
	if (${Message.Equal["I'm bored"]})
	{
		ZoneTime:Inc
	}
}
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
}