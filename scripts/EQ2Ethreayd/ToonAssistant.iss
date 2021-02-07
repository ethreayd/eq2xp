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
	variable int Counter
	variable int GroupCounter=0
	variable int ZoneCounter=0
	variable string ToonName=${Me.Name}
	variable float loc0 
		
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	
	echo Starting ToonAssistant (Force Potions : ${FORCEPOTIONS})
	eq2execute spend_deity_point 2282608707 1
	eq2execute spend_deity_point 2282608707 1
	if (${Zone.Name.Equal["Unknown"]})
	{
		ZoneCounter:Inc
	}
	else
		ZoneCounter:Set[0]
	if (${Zone.Name.Equal["Unknown"]} && ${ZoneCounter}>120)
	{
		call Log "back on login screen - trying to log on" WARNING
		ZoneCounter:Set[0]
		call ForceLogin ${ToonName}
	}
	if (!${Me.Grouped} &&!${Me.InCombatMode})
			eq2execute merc resume
	if (${Me.Group}<3)
	{
		Solo:Set[TRUE]
		;oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_forcenamedcatab TRUE
	}
	if (${Me.Group}>2 && ${Me.Group}<5)
	{	
		echo Incomplete Group (${GroupCounter})
		GroupCounter:Inc
	}
	else
		GroupCounter:Set[0]
	do
	{
		ExecuteQueued
		call waitfor_Zoning
		loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
		;echo into ToonAssistant : Power at ${Me.Power} - Health at ${Me.Health} - Dead at ${Me.IsDead}
		if (${Me.Power}<10 && !${Me.IsDead})
			eq2execute gsay I really need mana now !
		if (${Me.Health}<10 && !${Me.IsDead})
			eq2execute gsay I really need healing now !
		if (${Me.IsDead})
		{
			eq2execute gsay Can I have a rez please ?
			wait 100
		}
		if (!${Zone.Name.Right[10].Equal["Guild Hall"]})
		{
			if (${Solo} || ${FORCEPOTIONS})
				call UsePotions FALSE TRUE
			if (!${Me.Grouped} &&!${Me.InCombatMode})
				eq2execute merc resume
			if (!${Solo})
			{
				;echo not in Solo instance --> Heroic
				if (${Session.Equal["is1"]} && ${Script["Buffer:OgreInstanceController"](exists)} && !${Script["OgreICAssistant"](exists)})
					run EQ2Ethreayd/OgreICAssistant
				call IsPublicZone
				;echo Pot Potion at ${Me.Effect["Elixir of Intellect"].Duration} seconds
				;echo if (!${Me.Effect["Elixir of Intellect"].Duration(exists)} && !${Return}) --> PotPotion
				if (!${Me.Effect["Elixir of Intellect"].Duration(exists)} && !${Return})
				{
					Counter:Set[0]
					call PotPotion
					wait 300
					echo Pot Potion at ${Me.Effect["Elixir of Intellect"].Duration} seconds (Dead:${Me.IsDead})
					while (!${Me.Effect["Elixir of Intellect"].Duration(exists)} && ${Counter}<10 && !${Me.IsDead})
					{
						wait 30
						Counter:Inc
						echo ${Me.Effect["Elixir of Intellect"].Duration} (${Counter}/10)
					}	
				}
			}
		}
		;call IsPublicZone
		;if (${Me.IsIdle} && ${Return})
		;	call CleanBags
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
		if (${CombatDuration}>30 && !${Global_DONOTATTACK})
		{
			call FixCombat
			CombatDuration:Set[25]
		}
		if (${GroupCounter}>300)
		{
			oc !c -Disband
			relay all run wrap RebootLoop
		}	
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
		end ToonAssistant
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
	;echo ChatType : ${ChatType}
	;echo Message : ${Message}
	;echo Speaker : ${Speaker}
	;echo TargetName : ${TargetName}
	;echo SpeakerIsNPC : ${SpeakerIsNPC}
	;echo ChannelName : ${ChannelName}
	call CheckIfLeader "${Speaker}"
	if (${Return} && ${Me.Name.Equal["${TargetName}"]} && ${Message.Left[7].Equal["execute"]})
		QueueCommand ${Message.Right[${Math.Calc64[${Message.Length}-8]}]}
	if (${Message.Find["Can I have a rez please"]} > 0)
	{
		if (!${Me.InCombatMode} && ${Me.Archetype.Equal["priest"]} && !${Me.IsDead})
		{
			oc !c -CastAbilityOnPlayer ${Me.Name} "Gather Remains" ${Actor[Name,${Speaker}].ID}
		}
	}
	if (${Message.Find["nav to me now"]} > 0)
	{
		if (!${Session.Equal["is1"]})
		{
			if (!${Me.IsDead})
			{
				echo QueueCommand call navwrap ${Actor[name,${Speaker}].X} ${Actor[name,${Speaker}].Y} ${Actor[name,${Speaker}].Z}
				QueueCommand call navwrap ${Actor[name,${Speaker}].X} ${Actor[name,${Speaker}].Y} ${Actor[name,${Speaker}].Z}
			}
			else
			{
				echo Leader is at ${Actor[name,${Speaker}].Distance} m - Reviving
				if ${Actor[name,${Speaker}].Distance} < 50
					eq2execute gsay Can I have a rez please ?
				else
					oc !c -Revive ${Me.Name}
			}
		}
	}
	if (${Message.Find["your equipment is broken"]} > 0)
	{
		QueueCommand call AutoRepair
	}
	
}