#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main(bool NoShiny)
{
	variable bool GroupDead
	variable bool GroupAlive
	variable int Counter
	variable string sQN
	do
	{
		
		do
		{
			wait 100
			call isGroupDead
			GroupDead:Set[${Return}]
			call isGroupAlive
			GroupAlive:Set[${Return}]
			if ${Me.IsDead}
				Counter:Inc
			else
				Counter:Set[0]
		}
		while (${GroupAlive} && !${GroupDead} &&  ${Counter}<30)
	
		if (${Me.IsDead} && ${Me.InventorySlotsFree}>0)
		{
			wait 300
			if (${Me.IsDead})
			{
				echo I am Dead - Rebooting Instance
				if ${Script["oopsimdead"](exists)}
					endscript oopsimdead
				call StopHunt
				call strip_QN "${Zone.Name}"
				sQN:Set[${Return}]
				if ${Script[${sQN}](exists)}
					endscript ${sQN}
				OgreBotAPI:Revive[${Me.Name}]
				echo waiting 1 min to recover
				wait 10
				press -release MOVEFORWARD
				wait 600
		
				call ReturnEquipmentSlotHealth Primary
				if (${Return}<20)
				{
					echo Gear is too damaged - Ending this RunZone to mend
					run RebootCoVZone ${Zone.Name}
				}
				else
					call RunZone 0 0 0 ${NoShiny}
			}
		}
	}
	while (1==1)
}