#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"

function main(string Loop)
{
	variable int Counter
	variable bool LR
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]

	do
	{
		Counter:Set[0]
		if (${Me.IsDead})
		{
			echo I am dead
			do 
			{
				wait 10
				Counter:Inc
			}
			while (${Me.IsDead} && ${Counter}<100)
		}
		;echo oopsimdead counter : ${Counter}
		if (!${Me.IsDead} && ${Me.IsIdle} )
		{
			echo I am not dead but idle
			do 
			{
				wait 40
				Counter:Inc
			}
			while (${Me.IsIdle} && ${Counter}<100)
		}
		;echo oopsimdead counter : ${Counter}
		if (${Me.InCombatMode})
		{
			if (${Me.IsIdle} && ${Counter}>99)
			{
				echo I am stuck in Combat
				call Unstuck ${LR}
				LR:Set[${Return}]
				call CheckCombat
			}
			;echo resetting counter
			Counter:Set[0]
		}
		if (${Me.IsIdle} && ${Counter}>99)
		{
			echo rebooting session
			call StopHunt
			run killall
			call PKey MOVEFORWARD 1
			OgreBotAPI:Revive[${Me.Name}]
			wait 300
			OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
	
			call goto_GH
			wait 100
			OgreBotAPI:RepairGear[${Me.Name}]
			wait 100
			ogre depot -allh -hda -llda -cda
			wait 100
			OgreBotAPI:RepairGear[${Me.Name}]
			wait 100
			OgreBotAPI:ApplyVerbForWho["${Me.Name}","Large Ulteran Spire","Voyage Through Norrath"]
			wait 100
			OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
			OgreBotAPI:RepairGear[${Me.Name}]
			OgreBotAPI:Travel["${Me.Name}", "Plane of Magic"]
			call waitfor_Zone "Plane of Magic"
			run ${Loop}
		}
	}
	while (1==1)
}

atom HandleAllEvents(string Message)
 {
	;echo Catch Event ${Message}
	if (${Message.Find["in need of repair"]} > 0 || ${Message.Find["is worn out and will not be effective until repaired"]} > 0)
	{
		echo "I am broken"
		if ${Script["livedierepeat"](exists)}
			endscript livedierepeat
		if (!${Script["killall"](exists)})
			run killall
	}
 }