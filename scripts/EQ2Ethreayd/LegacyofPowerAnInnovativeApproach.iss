#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=4
	variable bool nocheckquest

	questname:Set["${qn}"]
	QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
	if (!${QuestJournalWindow.ActiveQuest["${questname}"](exists)})
		nocheckquest:Set[TRUE]
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	NPCName:Set["Druzzil Ro"]
	echo doing step ${stepstart} to ${stepstop}
	
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
	
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{	
		call DMove -2 5 4 3
		call DMove -94 3 163 3
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","zone_to_poi","Enter the Plane of Innovation"]
		wait 20
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
		wait 50
	}
} 
	
function step001()
{	
	call waitfor_Zone "Plane of Innovation: Masks of the Marvelous [Solo]"
	call RunZone 0 0 0 TRUE
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
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",3]
		wait 50
	}
	call waitfor_Zone "Plane of Innovation: Gears in the Machine [Solo]"
	call RunZone 0 0 0 TRUE
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
function MendToon()
{
	call waitfor_Zone "Coliseum of Valor"
	call ReturnEquipmentSlotHealth Primary
	if (${Return}<100)
	{
		call CoVMender
	}
}
