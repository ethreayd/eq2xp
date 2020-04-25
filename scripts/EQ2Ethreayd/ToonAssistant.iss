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
		
		if (${Me.Power}<10 && !${Me.IsDead})
			eq2execute gsay I really need mana now !
		if (${Me.Health}<10 && !${Me.IsDead})
			eq2execute gsay I really need healing now !
		if (${Me.IsDead})
			eq2execute gsay Can I have a rez please ?
		if (${Solo})
			call UsePotions FALSE TRUE
		if (${Me.InCombatMode})
			CombatDuration:Inc
		else
			CombatDuration:Set[0]
		if (${CombatDuration}>120 && !${Global_DONOTATTACK})
		{
			call FixCombat
			CombatDuration:Set[0]
		}
		ExecuteQueued
		wait 10
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
	}
	else
		call MoveCloseTo "${Me.Target.Name}"
	
	
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
			QueueCommand call navwrap ${Actor[name,${Speaker}].X} ${Actor[name,${Speaker}].Y} ${Actor[name,${Speaker}].Z}
	}
}