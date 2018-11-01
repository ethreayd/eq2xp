#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"

function main()
{
	variable int Counter
	variable string ZoneName
	variable string sQN
	do
	{
		ZoneName:Set["${Zone.Name}"]
		wait 300
		if (${Zone.Name.Equal["${ZoneName}"]})
			Counter:Inc
		else
			Counter:Set[0]
		
		if (${Counter}>120)
		{
			Counter:Set[0]
			echo I am in ${ZoneName} for more than an hour > Aborting
			echo Aborting current Zone (${ZoneName}), please wait
			if ${Script["autoshinies"](exists)}
				endscript autoshinies
			if ${Script["livedierepeat"](exists)}
				endscript livedierepeat
			call StopHunt
			run EQ2Ethreayd/killall
			wait 50
			press -release MOVEFORWARD
			call goto_GH
			call GuildH
			wait 100
			call goCoV
			wait 100
			if (!${Script["LoopSolo"](exists)})
				run EQ2Ethreayd/LoopSolo
		}
	}
	while (1==1)
}