#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=4
	questname:Set["${qn}"]
	QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
	NPCName:Set["Druzzil Ro"]
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	
	call StartQuest ${stepstart} ${stepstop}
	
	echo End of Quest reached
}

function step000()
{
	NPCName:Set["Druzzil Ro"]
	echo DESCRIPTION : ${questname}
	echo QUESTGIVER : ${NPCName}
	
	
	call check_quest "${questname}"
	
	if (!${Return})
	{
		call goCoV
		do
		{
			ogre qh
			call 2DNav -2 4
			call ConversetoNPC "${NPCName}" 0 -2 6 4 TRUE
			wait 100
			ogre end qh
			wait 20
			call check_quest "${questname}"
		}
		while (!${Return})	
	}
	
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{	
		call 2DNav -94 163
		call ActivateVerb "zone_to_poi" -94 3 163 "Enter the Plane of Innovation"
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",2]
		wait 50
	}
	call waitfor_Zone "Plane of Innovation: Masks of the Marvelous [Solo]"
} 
	
function step001()
{	
	variable string sQN="PoI-MotM_Solo"
	
	echo will clear zone "${Zone.Name}" Now !
    runscript ${sQN}
    wait 5
    while ${Script[${sQN}](exists)}
		wait 5
	echo zone "${Zone.Name}" Cleared !
}
function step002()
{
	call waitfor_Zone "Coliseum of Valor"
	call TestArrivalCoord -94 3 163
	if (!${Return})
	{	
		call 2DNav 0 0
		call 2DNav -94 163
	}
}
function step003()
{	
	call goCoV
	call waitfor_Zone "Coliseum of Valor"
	
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{	
		call TestArrivalCoord -94 3 163
		if (!${Return})
			call step002
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_poi","Enter the Plane of Innovation"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",2]
		wait 50
	}
	call waitfor_Zone "Plane of Innovation: Gears in the Machine [Solo]"
		
	variable string sQN="PoI-GitM_Solo"
	echo will clear zone "${Zone.Name}" Now !
    runscript ${sQN} 
    wait 5
    while ${Script[${sQN}](exists)}
		wait 5
	echo zone "${Zone.Name}" Cleared !
}
function step004()
{
	call waitfor_Zone "Coliseum of Valor"
	wait 50
		call 2DNav -6 2
		call ConversetoNPC "${NPCName}" 10 -6 6 2 TRUE
			
}
function goCoV()
{	
	if (${Zone.Name.Equal["Plane of Magic"]})
		{
			call ActivateVerb "zone_to_pov" -785, 345, 1116 "Enter the Coliseum of Valor"
			call waitfor_Zone "Coliseum of Valor"
			call 2DNav -2 4
		}
}