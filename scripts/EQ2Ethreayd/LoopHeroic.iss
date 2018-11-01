#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"

function main(int speed, bool NoShiny)
{
	variable int Start
	variable int Quests
	echo Starting LoopHeroic Now
	call goCoV
	call GetCoVQuests Heroic
	
	do
	{
		
		oc !c -ZoneResetAll
		;if (!${Script["ZoneUnstuck"](exists)})
		;	run EQ2Ethreayd/ZoneUnstuck
	
		
		Start:Set[${Math.Rand[4]:Inc[1]}]
		;Start:Set[1]
		Quests:Set[0]
		relay all run EQ2Ethreayd/wrap goCoV
		do
		{
			wait 10
		}
		while (${Script["wrap"](exists)})
		wait 300
		relay all end wrap
		do 
		{
			relay all end wrap
			echo Start=${Start}
			switch ${Start}
			{
				case 1
					call GoPoI "Masks of the Marvelous" Heroic
					break
				case 2
					call GoBoT "Tower Breach" Heroic
					break
				case 3
					call GoPoD "Outbreak" Heroic
					break
				case 4
					call GoSRT "The Obsidian Core" Heroic
					break
			}
			if (${Script["livedierepeat"](exists)})
				endscript livedierepeat
			echo launching RunZone
			relay all end wrap
			wait 10
			call RunZone 0 0 ${speed} ${NoShiny}
			echo waiting for end of Zone
			call waitfor_RunZone
			do
			{
				wait 10
			}
			while (${Script["wrap"](exists)})
			echo Mending Toon
			relay all run EQ2Ethreayd/wrap MendToon
			do
			{
				wait 10
			}
			while (${Script["wrap"](exists)})
			wait 300
			relay all end wrap
			
			Start:Inc
			echo Start=${Start}
			Quests:Inc
			echo ${Quests}/2 Heroic Quest(s) done
			if (${Start}>2)
				Start:Set[1]
		}
		while (${Quests}<2)
		call logout_login ${Math.Rand[14400]}
	}
	while (1==1)
}

