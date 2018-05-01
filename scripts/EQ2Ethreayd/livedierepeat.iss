#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	variable bool GroupDead
	variable bool GroupAlive
	variable int Counter
	variable string sQN
	do
	{
		wait 50
		call isGroupDead
		GroupDead:Set[${Return}]
		call isGroupAlive
		GroupAlive:Set[${Return}]
		if ${Me.IsDead}
			Counter:Inc
		else
			Counter:Set[0]
	}
	while (!${GroupAlive} && !${GroupDead} &&  ${Counter}<30)
	
	
	if (${Me.IsDead} && ${Me.InventorySlotsFree}>0)
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
		wait 600
		if (${Zone.Name.Find["Innovation"]} > 0)
			run EQ2Ethreayd/oopsimdead loopPoI
		else
			run EQ2Ethreayd/oopsimdead loopPoD
		call RunZone
		
	}
}