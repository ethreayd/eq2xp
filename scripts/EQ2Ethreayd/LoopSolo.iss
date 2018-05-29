#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"

function main(int speed, bool NoShiny)
{
	variable int MyTime
	
	call goCoV
	do
	{	
		OgreBotAPI:ZoneResetAll["${Me.Name}"]
		if (${Zone.Name.Equal["Coliseum of Valor"]})
			call PrepareToon
		
		call check_quest "The Tyrant's Throne [Solo]"
		if (${Return})
		{
			call GoThrone
			call RunZone 0 0 ${speed} ${NoShiny}
			call waitfor_RunZone
		}
		call GoPoI "Masks of the Marvelous" Solo
		call RunZone 0 0 ${speed} ${NoShiny}
		call waitfor_RunZone
		
		MyTime:Set[${Time.Timestamp}]		
		call MendToon
		
		call GoPoI "Gears in the Machine" Solo]
		call RunZone 0 0 ${speed} ${NoShiny}
		call waitfor_RunZone
		call MendToon
		
		call GoPoI "Outbreak" Solo
		call RunZone 0 0 ${speed} ${NoShiny}
		call waitfor_RunZone
		call MendToon
		
		call GoPoI "the Source" Solo
		call RunZone 0 0 ${speed} ${NoShiny}
		call waitfor_RunZone
		call MendToon
		
		call GoBoT "Tower Breach" Solo
		call RunZone 0 0 ${speed} ${NoShiny}
		call waitfor_RunZone
		call MendToon
		
		call GoBoT "Winds of Change" Solo
		call RunZone 0 0 ${speed} ${NoShiny}
		call waitfor_RunZone
		call MendToon
		
		call GoSRT "The Obsidian Core" Solo
		call RunZone 0 0 ${speed} ${NoShiny}
		call waitfor_RunZone
		call MendToon
		
		call GoSRT "Monolith of Fire" Solo
		call RunZone 0 0 ${speed} ${NoShiny}
		call waitfor_RunZone
		
		call waitfor_Zone "Coliseum of Valor"
		call logout_login ${Math.Calc[(6000-(${Time.Timestamp}-${MyTime}))]}
	}
	while (1==1)
}
