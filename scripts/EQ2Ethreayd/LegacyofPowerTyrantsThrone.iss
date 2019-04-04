#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=3
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
	call DMove 78 0 -130 3
	call DMove 100 4 -152 3
	call DMove 92 3 -141 2
	call ActivateVerbOnPhantomActor "Activate E-POD"	
	wait 50
	call DMove 95 3 -149 3
	OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_molten_throne","Enter the Molten Throne"]
	wait 20
	call waitfor_Zone "The Molten Throne"
	echo will clear zone "${Zone.Name}" Now !
    call RunZone 0 0 0 TRUE
	echo zone "${Zone.Name}" Cleared !
} 
	
function step001()
{	
	call waitfor_Zone "Coliseum of Valor"
	call DMove -2 5 4 3
	call Converse "${NPCName}" 10 TRUE
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
function step002()
{	
	call step001
}
function step003()
{	
	call step001
}