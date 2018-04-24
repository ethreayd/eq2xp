#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"

function main(string Loop)
{
	variable int Counter
	variable bool LR
	
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
		echo oopsimdead counter : ${Counter}
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
		echo oopsimdead counter : ${Counter}
		if (${Me.InCombatMode})
		{
			if (${Me.IsIdle} && ${Counter}>99)
			{
				call Unstuck ${LR}
				LR:Set[${Return}]
			}
			echo resetting counter
			Counter:Set[0]
		}
		if (${Me.IsIdle} && ${Counter}>99)
		{
			echo rebooting session
			run killall
			OgreBotAPI:Revive[${Me.Name}]
			wait 300
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
			OgreBotAPI:Travel["${Me.Name}", "Plane of Magic"]
			call waitfor_Zone "Plane of Magic"
			run ${Loop}
		}
	}
	while (1==1)
}