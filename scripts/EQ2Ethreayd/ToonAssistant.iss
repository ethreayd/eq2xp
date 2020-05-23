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

function main(string questname)
{
	variable bool Solo
	variable int CombatDuration=0
	
	
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	
	echo Starting ToonAssistant
	eq2execute spend_deity_point 2282608707 1
	eq2execute spend_deity_point 2282608707 1
	if (${Me.Group}<3)
	{
		Solo:Set[TRUE]
		oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_forcenamedcatab TRUE
	}
	do
	{
		call waitfor_Zoning
		echo into ToonAssistant : Power at ${Me.Power} - Health at ${Me.Health} - Dead at ${Me.IsDead}
		if (${Me.Power}<10 && !${Me.IsDead})
			eq2execute gsay I really need mana now !
		if (${Me.Health}<10 && !${Me.IsDead})
			eq2execute gsay I really need healing now !
		if (${Me.IsDead})
			eq2execute gsay Can I have a rez please ?
		if (${Solo})
			call UsePotions FALSE TRUE
		else
		{
			echo not in Solo instance --> Heroic
			if (${Session.Equal["is1"]} && ${Script["Buffer:OgreInstanceController"](exists)} && !${Script["OgreICAssistant"](exists)})
				run EQ2Ethreayd/OgreICAssistant
			call IsPublicZone
			echo if (!${Me.Effect["Elixir of Intellect"].Duration(exists)} && !${Return})
			if (!${Me.Effect["Elixir of Intellect"].Duration(exists)} && !${Return})
			{
				call PotPotion
				wait 50
			}
		}
		call IsPublicZone
		if (${Me.IsIdle} && ${Return})
			call CleanBags
		if (${Me.InCombatMode})
		{
			CombatDuration:Inc
			;echo CombatDuration at ${CombatDuration}/120
		}
		else
		{
			CombatDuration:Set[0]
		}
		if (!${Me.Target.IsAggro} && ${CombatDuration}>20)
		{
			press Tab
			wait 10
		}
		if (${CombatDuration}>120 && !${Global_DONOTATTACK})
		{
			call FixCombat
			CombatDuration:Set[0]
		}
		
		call AutoRepair 30
			
		ExecuteQueued
		wait 10
		if (${Zone.Name.Right[10].Equal["Guild Hall"]} && ${Me.Y}>-100)
			call GHStuck
	}
	while (TRUE)
	echo Ending ToonAssistant

}
function FixCombat()
{
	echo this fight is taking too much time...
	if (${Me.Target.Name.Equal["${Me.Name}"]})
	{
		eq2execute merc backoff
		wait 50
		eq2execute merc attack
		call AttackClosest
	}
	if !${Me.Target(exists)}
	{
		eq2execute autoattack 0
		wait 10
		eq2execute autoattack 2
		press Tab
		wait 10
	}
	if !${Me.Target.IsAggro}
	{
		press Tab
		wait 10
	}
	else
	{
		call AttackClosest
		wait 20
		call MoveCloseTo "${Me.Target.Name}"
	}
	wait 10
}
function GHStuck()
{

		variable index:string ScriptsToRun
		variable string ScriptName
		variable int x

		echo I am flying in the guild like Dumbo
		ScriptsToRun:Insert["livedierepeat"]
		ScriptsToRun:Insert["autoshinies"]
		ScriptsToRun:Insert["ZoneUnstuck"]
		ScriptsToRun:Insert["Buffer:RZ"]
		ScriptsToRun:Insert["Buffer:RIMovement"]
		ScriptsToRun:Insert["ISXRIAssistant"]
		ScriptsToRun:Insert["OgreICAssistant"]
		ScriptsToRun:Insert["wrap1"]
		ScriptsToRun:Insert["wrap2"]
		ScriptsToRun:Insert["wrap"]
		ScriptsToRun:Insert["Churns"]
		ScriptsToRun:Insert["DoWeekly"]
		ScriptsToRun:Insert["BoLLoop"]
		ScriptName:Set["BoLLoop"]

		for ( x:Set[1] ; ${x} <= ${ScriptsToRun.Used} ; x:Inc )
		{
			echo Killing script ${ScriptsToRun[${x}]}
			if ${Script["${ScriptsToRun[${x}]}"](exists)}
				endscript "${ScriptsToRun[${x}]}"
		}
		
		if ${Script["CDLoop"](exists)}
		{
			endscript CDLoop
			ScriptName:Set["CDLoop"]
		}
		call goDown
		call CastAbility "Call to Guild Hall"
		run EQ2Ethreayd/${ScriptName}
}
atom HandleAllEvents(string Message)
{
	if (${Message.Equal["Can't see target"]})
	{
		eq2execute gsay ${Message} - Saperlipopette
		if (!${Script["wrap"](exists)})
			run EQ2Ethreayd/wrap UnstuckR 5
	}
	if (${Message.Equal["Too far away"]})
	{
		 eq2execute gsay ${Message}
		 press MOVEFORWARD
		 eq2execute merc attack
	}
	
	if (${Message.Find["Hurry up please, we have things to do"]} > 0)
	{
		if (!${Script["wrap"](exists)})
			run EQ2Ethreayd/wrap UnstuckR 20
	}
}
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	if (${Message.Find["Can I have a rez please"]} > 0)
	{
		if (!${Me.InCombatMode})
		{
			oc !c -CastAbilityOnPlayer ${Me.Name} "Gather Remains" ${Speaker} 
		}
	}
	if (${Message.Find["nav to me now"]} > 0)
	{
		if (!${Session.Equal["is1"]})
		{
			echo QueueCommand call navwrap ${Actor[name,${Speaker}].X} ${Actor[name,${Speaker}].Y} ${Actor[name,${Speaker}].Z}
			QueueCommand call navwrap ${Actor[name,${Speaker}].X} ${Actor[name,${Speaker}].Y} ${Actor[name,${Speaker}].Z}
		}
	}
	if (${Message.Find["your equipment is broken"]} > 0)
	{
		QueueCommand call AutoRepair
	}
}