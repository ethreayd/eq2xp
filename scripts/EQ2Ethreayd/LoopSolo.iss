#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"

function main(int speed, bool NoShiny)
{
	variable int Start
	variable int Quests
	call goCoV
	eq2execute merc resume
	do
	{	
		OgreBotAPI:ZoneResetAll["${Me.Name}"]
		if (${Zone.Name.Equal["Coliseum of Valor"]})
			call PrepareToon
		Start:Set[${Math.Rand[9]:Inc[1]}]
		Quests:Set[0]
		do 
		{
			echo Start=${Start}
			switch ${Start}
			{
				case 1
					call GoPoI "Masks of the Marvelous" Solo
					break
				case 2
					call GoPoI "Gears in the Machine" Solo
					break
				case 3
					call GoPoD "Outbreak" Solo
					break
				case 4
					call GoPoD "the Source" Solo
					break
				case 5
					call GoBoT "Tower Breach" Solo
					break
				case 6
					call GoBoT "Winds of Change" Solo
					break
				case 7
					call GoSRT "The Obsidian Core" Solo
					break
				case 8
					call GoSRT "Monolith of Fire" Solo
					break
				case 9
				{
					call check_quest "The Tyrant's Throne [Solo]"
					if (${Return})
						call GoThrone
					break
				}
			}
			echo launching RunZone
			call RunZone 0 0 ${speed} ${NoShiny}
			echo waiting for end of Zone
			call waitfor_RunZone
			echo Mending Toon
			call MendToon
			Start:Inc
			echo Start=${Start}
			Quests:Inc
			echo ${Quests}/9 Solo Quest(s) done
			if (${Start}>9)
				Start:Set[1]
		}
		while (${Quests}<9)
		call logout_login ${Math.Rand[14400]}
	}
	while (1==1)
}

