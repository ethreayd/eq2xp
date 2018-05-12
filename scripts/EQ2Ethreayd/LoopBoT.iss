#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	variable string sQN
	variable int MyTime
	
	variable string ToonName
		
	call goCoV
	do
	{	
		call waitfor_Zone "Coliseum of Valor"
		
		sQN:Set["GetPoPQuests"]
		echo will get POP Quests Now !
		runscript EQ2Ethreayd/${sQN} 
		wait 5
		while ${Script[${sQN}](exists)}
			wait 5
		echo Quests recovered
		
		echo mending gear if necessary
		call ReturnEquipmentSlotHealth Primary
		if (${Return}<100)
		{
			call CoVMender
		}
		
		call DMove -2 5 4 3
		call DMove -92 3 -158 3
		OgreBotAPI:ZoneResetAll["${Me.Name}"]
		wait 50		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_bot","Enter Torden, Bastion of Thunder"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",5]
		wait 50
		call waitfor_Zone "Torden, Bastion of Thunder: Tower Breach [Solo]"
		wait 50
		call RunZone
		echo BoTTB terminated
		call waitfor_Zone "Coliseum of Valor"
		
		call DMove -2 5 4 3
		call DMove -92 3 -158 3
		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_bot","Enter Torden, Bastion of Thunder"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",7]
		wait 50	
		call waitfor_Zone "Torden, Bastion of Thunder: Winds of Change [Solo]"
		MyTime:Set[${Time.Timestamp}]
		wait 50
		call RunZone
		echo BoTWoC terminated 
		call waitfor_Zone "Coliseum of Valor"
		ToonName:Set["${Me.Name}"]
		echo will now quit and reconnect ${ToonName} in ${Math.Calc[(6000-(${Time.Timestamp}-${MyTime}))]} seconds
		eq2execute quit login
		wait ${Math.Calc[(6000-(${Time.Timestamp}-${MyTime}))*10]}
		wait 600
		ogre ${ToonName}
		wait 600
	}
	while (1==1)
}