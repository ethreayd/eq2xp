#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"

variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=7
	variable int stopquest=0
	variable int multiple=0
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
	
	call CheckQuestStep 2
	if (!${Return})
	{
		call CheckQuestStep 4
		if (!${Return})
		{
			echo Checking Quest Requirements
			call CheckItem "etherium" 100
			stopquest:Set[${Math.Calc64[${stopquest}+${Return}]}]
			call CheckItem "gnarled entwood" 100
			stopquest:Set[${Math.Calc64[${stopquest}+${Return}]}]
			call CheckItem "golden ember" 100
			stopquest:Set[${Math.Calc64[${stopquest}+${Return}]}]
			call CheckItem "plumewit hide" 100
			stopquest:Set[${Math.Calc64[${stopquest}+${Return}]}]
			call CheckItem "storm stalk" 100
			stopquest:Set[${Math.Calc64[${stopquest}+${Return}]}]
			call CheckItem "Celestial Coal" 125
			stopquest:Set[${Math.Calc64[${stopquest}+${Return}]}]
			call CheckItem "Celestial Filament" 25
			stopquest:Set[${Math.Calc64[${stopquest}+${Return}]}]
		}
	}
	
	call CountItem "Electric Manaetic Device (EMD)"
	if (${Return}<11)
	{
		call CheckItem "Celestial Coal" 50
		stopquest:Set[${Math.Calc64[${stopquest}+${Return}]}]
	}
	
	if (${stopquest}>0)
	{
		echo not enough craft materials - stopping quest
		return
	}
	echo doing step ${stepstart} to ${stepstop} (${qn})
	
	call StartQuest ${stepstart} ${stepstop} ${nocheckquest} 
	
	echo End of Quest reached
}

function step000()
{
	
	echo DESCRIPTION : ${questname}
	echo QUESTGIVER : ${NPCName}
	
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{
		echo mending gear if necessary
		call ReturnEquipmentSlotHealth Primary
		if (${Return}<100)
		{
			call CoVMender
		}
	}
	else
		call goCoV
	call ExitCoV
	do
	{
		call MoveTo "${NPCName}" -776 343 1090
		call TestArrivalCoord -776 343 1090 10
	}
	while (!${Return})
	wait 100
	call CheckCombat
	do
	{
		call Converse "${NPCName}" 10 TRUE
		wait 20
		QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
		wait 10
		call check_quest "${questname}"
	}
	while (!${Return})
	call goCoV
	echo Mending Toon
	call MendToon
	call GoPoI "Security Measures" Tradeskill
	call RunZone 0 0 ${speed} ${NoShiny}
	echo waiting for end of Zone
	call waitfor_RunZone
} 
	
function step001()
{	
	call goCoV
	echo Mending Toon
	call MendToon
	call GoPoI "Security Measures" Tradeskill
	call RunZone 0 0 ${speed} ${NoShiny}
	echo waiting for end of Zone
	call waitfor_RunZone
}
function step002()
{	
	call step001
}
function step003()
{	
	call step001
}
function step004()
{	
	call step001
}
function step005()
{	
	call step001
}
function step006()
{	
	call step001
}
function step007()
{	
	call waitfor_Zone "Coliseum of Valor"
	call 2DNav 5 5
	call Converse "Druzzil Ro" 5 TRUE
	wait 20
	call GoVarig
	call Converse "Varig Ro" 8 TRUE
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]	
}
