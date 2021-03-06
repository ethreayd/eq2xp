#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=8
	variable bool nocheckquest
	questname:Set["${qn}"]
	QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
	wait 20
	if (!${QuestJournalWindow.ActiveQuest["${questname}"](exists)})
		nocheckquest:Set[TRUE]
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	NPCName:Set["Druzzil Ro"]
	echo doing step ${stepstart} to ${stepstop} (${qn})
	
	call StartQuest ${stepstart} ${stepstop} ${nocheckquest} 
	
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
		call DMove -167 3 7 3
		call ActivateVerbOnPhantomActor "Activate E-POD" 5 5
		wait 50
		OgreBotAPI:Special["${Me.Name}"]
		wait 50
		call DMove -193 3 0 3
		
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_pod","Enter the Plane of Disease"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
		wait 50
	}
	call waitfor_Zone "Plane of Disease: Outbreak [Solo]"
	echo will clear zone "${Zone.Name}" Now !
    	call RunZone 0 0 0 TRUE
}
function step002()
{
	call goCoV
	call waitfor_Zone "Coliseum of Valor"
	call CheckQuestStep 2
	if (!${Return})
	{
		call CheckQuestStep 5
		if (!${Return})
			call step001
	}
	echo zone "${Zone.Name}" Cleared !
	call DMove -2 5 4 3
	call DMove -167 3 7 3
	OgreBotAPI:Special["${Me.Name}"]
	wait 50
		
}
function step003()
{	
	call step002
	call DMove -6 6 2 3
	call Converse "${NPCName}" 10 TRUE
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call DMove -167 3 7 3
	OgreBotAPI:Special["${Me.Name}"]
	wait 50
		
}
function step004()
{
	call goCoV
	call waitfor_Zone "Coliseum of Valor"
	wait 50
	call DMove -6 6 2 3
	call DMove -167 3 7 3
	OgreBotAPI:Special["${Me.Name}"]
	wait 50
	call DMove -193 3 0 3
	OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_pod","Enter the Plane of Disease"]
	wait 20
	OgreBotAPI:ZoneDoorForWho["${Me.Name}",6]
	wait 50	
	call waitfor_Zone "Plane of Disease: The Source [Solo]"
	
}
function step005()
{
	if (!${Zone.Name.Equal["Plane of Disease: The Source [Solo]"]})
	{	
		call step004
	}
		
	echo will clear zone "${Zone.Name}" Now !
	call RunZone 0 0 0 TRUE
	echo zone "${Zone.Name}" Cleared !
}

function step006()
{
	call step005
}

function step007()
{
	call step005
}

function step008()
{
	call goCoV
	call waitfor_Zone "Coliseum of Valor"
	call DMove -2 5 4 3
	call Converse "${NPCName}" 10 TRUE
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
