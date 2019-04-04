#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"

function main(int speed, bool NoShiny)
{
	variable int Start
	variable int Quests
	variable int WaitTime
	echo Starting LoopSoH Now
	
	
	do
	{
		ogre
		wait 300
		call goCoV
		OgreBotAPI:ZoneResetAll["${Me.Name}"]
		call GetCoVQuests SoH Solo
		call MendToon
		call GoSoH "Utter Contempt" Solo
		call RunZone
		wait 50
		oc !c -revive ${Me.Name}
		call goto_GH
		wait 600
		oc !c -RepairGear ${Me.Name}
		wait 50
		oc !c -RepairGear ${Me.Name}
		wait 50
		oc !c -RepairGear ${Me.Name}
		
		WaitTime:Set[${Math.Calc64[${Math.Rand[3600]}+3600]}]
		echo will call logout_login ${WaitTime} now using ${Me.Name}
		call logout_login ${WaitTime}
		wait ${WaitTime}
	}
	while (1==1)
}

