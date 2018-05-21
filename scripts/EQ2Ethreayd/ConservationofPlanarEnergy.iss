#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=5
	questname:Set["${qn}"]
	QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
	wait 20
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	NPCName:Set["Brehita the Weaponbreaker"]
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
			
			call DMove -2 5 4 3
			call DMove 117 0 0 3
			call DMove 112 0 34 3
			call Converse "${NPCName}" 11
			wait 50
			call check_quest "${questname}"
			echo check quest "${questname}" : ${Return} 
		}
		while (!${Return})
	}
	
	call ActivateVerb "Soulbound Portal" 107 0 31 "Travel to the Soulbound Chamber"
	wait 20
	call waitfor_Zone "Soulbound Chamber"
} 
	
function step001()
{	
	call waitfor_Zone "Soulbound Chamber"
	call DMove 4 103 10
	call Converse "${NPCName}" 8
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
}
function step002()
{	
	call MoveCloseTo "Solusek's Forge"
	call ActivateVerb "Solusek's Forge" -3 103 10 "Extract Essence"
	wait 20
	ReplyDialog:Choose[1]
	wait 20
	Me.Inventory[Query, Name =- "Soulbound Slice"]:Salvage
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
function step003()
{	
	call MoveCloseTo "${NPCName}"
	call Converse "${NPCName}" 6
}
function step004()
{	
	call ActivateVerbOnPhantomActor "Imbue Essence"
	wait 20
	ReplyDialog:Choose[1]
	wait 20
	ReplyDialog:Choose[1]
	wait 20
	ReplyDialog:Choose[1]
}
function step005()
{	
	call Converse "${NPCName}" 6
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	call DMove 0 104 -5
	call ActivateVerb "Exit" 0 104 -5 "Return to Coliseum of Valor" 
}
