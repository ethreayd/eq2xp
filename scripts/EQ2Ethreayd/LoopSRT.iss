#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"

function main(int speed, bool NoShiny)
{
	variable int MyTime
		
	call goCoV
	do
	{	
		call waitfor_Zone "Coliseum of Valor"
		call PrepareToon
		OgreBotAPI:ZoneResetAll["${Me.Name}"]
		
		call GoSRT "The Obsidian Core" Solo
		call RunZone 0 0 ${speed} ${NoShiny}
		call waitfor_RunZone
		
		MyTime:Set[${Time.Timestamp}]
		call MendToon
		
		call GoSRT "Monolith of Fire" Solo
		call RunZone 0 0 ${speed} ${NoShiny}
		call waitfor_RunZone
		
		call waitfor_Zone "Coliseum of Valor"
		call logout_login ${Math.Calc[(6000-(${Time.Timestamp}-${MyTime}))]}
	}
	while (1==1)
}
