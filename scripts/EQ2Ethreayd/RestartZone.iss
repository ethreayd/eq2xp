#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main(int qstart, int qstop, int speed, bool NoShiny)
{
	variable string sQN
	echo Restarting Zone ${Zone.Name}
	wait 50
	oc !c -revive
	echo waiting 1 min for death sickness
	wait 600
	call strip_QN "${Zone.Name}"
	sQN:Set[${Return}]
	if ${Script[${sQN}](exists)}
		endscript ${sQN}
	call RunZone ${qstart} ${qstop} ${speed} ${NoShiny}
}