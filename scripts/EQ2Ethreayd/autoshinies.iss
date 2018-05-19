#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main(float Distance, int speed, float height)
{
	variable string sQN
	if (${Distance}<1)
		Distance:Set[50]
	if (${speed}<1)
		speed:Set[1]
	if (${height}<1)
		height:Set[10]
	call strip_QN "${Zone.Name}"
	sQN:Set[${Return}]
	echo auto harvest shiny in zone "${Zone.Name}" ACTIVATED
    
    do
	{
		wait 100
		call IsPresent ? ${Distance} TRUE
		if (${Return})
		{
			call Abs ${Math.Calc64[${Me.Loc.Y}-${Actor["?"].Y}]}
			if (${Return}<${height} && ${Actor["?"].Distance}<${Distance})
			{
				echo shiny detected at altitude difference Y=${Return}(<${height})
				Script[${sQN}]:Pause
				press -release MOVEFORWARD
				echo Paused
				do
				{
					wait 10 
				}
				while (!${Me.IsIdle})
				call Abs ${Math.Calc64[${Me.Loc.Y}-${Actor["?"].Y}]}
				if (${Return}<${height} && ${Actor["?"].Distance}<${Distance})
					call Harvest ? ${Distance} ${speed} TRUE TRUE
				wait 10
				Script[${sQN}]:Resume
				echo Resumed
			}
		}
	}
	while (${Script[${sQN}](exists)} && !${Me.IsDead})
	echo End of auto shiny harvesting
}
