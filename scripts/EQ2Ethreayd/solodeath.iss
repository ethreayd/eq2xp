#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main(bool NoShiny)
{
	variable int Counter
	variable string sQN
	do
	{
		do
		{
			wait 600
			
			if ${Me.IsDead}
			{
				Counter:Inc
				echo Counter: ${Counter}
			}
			else
				Counter:Set[0]
		}
		while (${Counter}<10)
		
		echo Restarting Zone ${Zone.Name}
		wait 50
		oc !c -revive ${Me.Name} 0
		echo waiting 1 min for death sickness
		wait 600
		call strip_QN "${Zone.Name}"
		sQN:Set[${Return}]
		if ${Script[${sQN}](exists)}
			endscript ${sQN}
		call RunZone 0 0 0 ${NoShiny}
		Counter:Set[0]
		wait 3000
	}
	while (TRUE)
}