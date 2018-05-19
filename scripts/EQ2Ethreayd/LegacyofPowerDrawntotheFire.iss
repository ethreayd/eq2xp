#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=2
	questname:Set["${qn}"]
	QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
	wait 20
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	NPCName:Set["Druzzil Ro"]
	echo doing step ${stepstart} to ${stepstop} (${qn})
	
	call StartQuest ${stepstart} ${stepstop}
	
	echo End of Quest reached
}

function step000()
{
	
	echo DESCRIPTION : ${questname}
	echo QUESTGIVER : ${NPCName}
	
	call goCoV
	echo mending gear if necessary
	call ReturnEquipmentSlotHealth Primary
	if (${Return}<100)
	{
		call CoVMender
	}
	
	call check_quest "${questname}"
	if (!${Return})
	{
		do
		{
			ogre qh
			call DMove -2 5 4 3
			call Converse "${NPCName}" 30 TRUE TRUE
			wait 50
			ogre end qh
			wait 20
			call check_quest "${questname}"
			echo check quest "${questname}" : ${Return} 
		}
		while (!${Return})
	}
		
	call DMove -2 5 4 3
	call DMove 95 3 -164 3
		
	OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_ro_tower","Enter Solusek Ro's Tower"]
	wait 20
	OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
	wait 50
	
	call waitfor_Zone "Solusek Ro's Tower: The Obsidian Core [Solo]"
	echo will clear zone "${Zone.Name}" Now !
    call RunZone 0 0 0 TRUE
	echo zone "${Zone.Name}" Cleared !
} 
	
function step001()
{	
	call goCoV
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{	
		call DMove -2 5 4 3
		call DMove 95 3 -164 3
		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_ro_tower","Enter Solusek Ro's Tower"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
		wait 50
	}
	call waitfor_Zone "Solusek Ro's Tower: Monolith of Fire [Solo]"
	echo will clear zone "${Zone.Name}" Now !
    call RunZone 0 0 0 TRUE
	echo zone "${Zone.Name}" Cleared !
}

function step002()
{
	call waitfor_Zone "Coliseum of Valor"
	call DMove -2 5 4 3
	call Converse "${NPCName}" 10 TRUE
	OgreBotAPI:AcceptReward["${Me.Name}"]
}