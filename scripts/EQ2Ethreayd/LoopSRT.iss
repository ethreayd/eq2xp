#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main(int speed, bool NoShiny)
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
		runscript EQ2Ethreayd/${sQN} 0 0 ${speed}
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
		call DMove 95 3 -164 3
		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_ro_tower","Enter Solusek Ro's Tower"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",6]
		wait 50
	
		call waitfor_Zone "Solusek Ro's Tower: The Obsidian Core [Solo]"
		echo will clear zone "${Zone.Name}" Now !
		call RunZone 0 0 ${speed} ${NoShiny}
		echo zone "${Zone.Name}" Cleared !		
		call DMove -2 5 4 3
		call DMove 95 3 -164 3
		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_ro_tower","Enter Solusek Ro's Tower"]
		wait 50
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
		wait 50
		call waitfor_Zone "Solusek Ro's Tower: Monolith of Fire [Solo]"
		echo will clear zone "${Zone.Name}" Now !
		call RunZone 0 0 ${speed} ${NoShiny}
		echo zone "${Zone.Name}" Cleared !
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