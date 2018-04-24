#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"

function main(string ScriptName)
{
	variable bool GroupDead
	variable bool GroupAlive
	do
	{
		wait 50
		call isGroupDead
		GroupDead:Set[${Return}]
		call isGroupAlive
		GroupAlive:Set[${Return}]
	}
	while (!${GroupAlive} && !${GroupDead} )
	
	call isGroupDead
	if (${Return})
	{
		call StopHunt
		endscript ${ScriptName}
		OgreBotAPI:Revive[${Me.Name}]
		wait 600
		run ${ScriptName}
	}
}