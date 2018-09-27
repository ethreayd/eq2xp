#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	variable bool GroupDead
	variable bool GroupAlive
	variable int Counter
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
			{
				Counter:Inc
				echo Counter (deathwatch): ${Counter}
			}
			else
				Counter:Set[0]
			
		}
		while ((${GroupAlive} || !${GroupDead} || ${Counter}<10) && ${Counter}<100)
		if ${Script["RestartZone"}](exists)}
			endscript RestartZone
		wait 100
		eq2execute gsay DeathMate!!!
		Counter:Set[0]
	}
	while (TRUE)
}