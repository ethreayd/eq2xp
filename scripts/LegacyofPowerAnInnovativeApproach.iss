#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=4
	questname:Set["${qn}"]
	QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	NPCName:Set["Druzzil Ro"]
	echo doing step ${stepstart} to ${stepstop}
	
	call StartQuest ${stepstart} ${stepstop}
	
	echo End of Quest reached
}

function step000()
{
	
	echo DESCRIPTION : ${questname}
	echo QUESTGIVER : ${NPCName}
	
	call goCoV
	call check_quest "${questname}"
	if (!${Return})
	{
		
		do
		{
			ogre qh
			call DMove -2 5 4 3
			call Converse "${NPCName}" 1 TRUE
			wait 100
			ogre end qh
			wait 20
			call check_quest "${questname}"
		}
		while (!${Return})	
	}
	
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{	
		call DMove -2 5 4 3
		call DMove -94 3 163 3
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_poi","Enter the Plane of Innovation"]
		wait 20
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
	call DMove -2 5 4 3
	call DMove -94 3 163 3
}
function step003()
{	
	call goCoV
	call waitfor_Zone "Coliseum of Valor"
	
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{	
		call DMove -2 5 4 3
		call DMove -94 3 163 3
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
	call goCoV
	call waitfor_Zone "Coliseum of Valor"
	wait 50
	call DMove -6 6 2 3
	call Converse "${NPCName}" 10 TRUE
	OgreBotAPI:AcceptReward["${Me.Name}"]
			
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