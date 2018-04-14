#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"

function main(string qn, int stepstart, int stepstop)
{
	variable string sQN
	variable int MyTime
	
	variable string ToonName
	call goCoV
	do
	{	
		call waitfor_Zone "Coliseum of Valor"
		call DMove -2 5 4 3
		call DMove -94 3 163 3
		OgreBotAPI:ZoneResetAll["${Me.Name}"]
		wait 50		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_poi","Enter the Plane of Innovation"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",4]
		wait 50
		call waitfor_Zone "Plane of Innovation: Masks of the Marvelous [Solo]"
		sQN:Set["PoI-MotM_Solo"]
		echo will clear zone "${Zone.Name}" Now !
		runscript ${sQN} 
		wait 5
		while ${Script[${sQN}](exists)}
			wait 5
		echo MotM terminated
		call waitfor_Zone "Coliseum of Valor"
		
		call DMove -2 5 4 3
		call DMove -94 3 163 3
		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_poi","Enter the Plane of Innovation"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",2]
		wait 50
	
		call waitfor_Zone "Plane of Innovation: Gears in the Machine [Solo]"
		MyTime:Set[${Time.Timestamp}]
		sQN:Set["PoI-GitM_Solo"]
		echo will clear zone "${Zone.Name}" Now !
		runscript ${sQN} 
		wait 5
		while ${Script[${sQN}](exists)}
			wait 5
		echo GitM terminated 
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

function goCoV()
{	
	if (${Zone.Name.Equal["Plane of Magic"]})
		{
			call ActivateVerb "zone_to_pov" -785 345 1116 "Enter the Coliseum of Valor"
			call waitfor_Zone "Coliseum of Valor"
			call DMove -2 5 4 3
		}
}