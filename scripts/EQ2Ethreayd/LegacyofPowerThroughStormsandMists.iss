#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=6
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
			call Converse "${NPCName}" 1 TRUE
			wait 100
			ogre end qh
			wait 20
			call check_quest "${questname}"
		}
		while (!${Return})	
	}
	
	
} 
	
function step001()
{	
	call goCoV
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{	
		call DMove -2 5 4 3
		call DMove -92 3 -158 3
		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_bot","Enter Torden, Bastion of Thunder"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
		wait 50
	}
	call waitfor_Zone "Torden, Bastion of Thunder: Tower Breach [Solo]"
	echo will clear zone "${Zone.Name}" Now !
    call RunZone 0 0 0 TRUE
	echo zone "${Zone.Name}" Cleared !
}
function step002()
{
	call goCoV
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{	
		call DMove -2 5 4 3
		call DMove -92 3 -158 3
		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_bot","Enter Torden, Bastion of Thunder"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",7]
		wait 50
	}
	call waitfor_Zone "Torden, Bastion of Thunder: Winds of Change [Solo]"
	echo will clear zone "${Zone.Name}" Now !
    call RunZone 0 0 0 TRUE
	echo zone "${Zone.Name}" Cleared !	
}
function step003()
{	
	call CurrentQuestStep
	echo I am at step ${Return}
	if (${Return}< 6
		call step002
}
function step004()
{
	call CurrentQuestStep
	echo I am at step ${Return}
	if (${Return}< 6
		call step002
	
}
function step005()
{
	call CurrentQuestStep
	echo I am at step ${Return}
	if (${Return}< 6
		call step002
}

function step006()
{
	call goCoV
	call waitfor_Zone "Coliseum of Valor"
	call DMove -2 5 4 3
	call Converse "Karana" 10 TRUE
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
