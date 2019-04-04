#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=5
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
	NPCName:Set["Karana"]
	echo doing step ${stepstart} to ${stepstop} (${qn})
	
	call StartQuest ${stepstart} ${stepstop} ${nocheckquest} 
	
	echo End of Quest reached
}

function step000()
{
	
	echo DESCRIPTION : ${questname}
	echo QUESTGIVER : ${NPCName}
	call StopHunt

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
		}
		while (!${Return})
		do
		{
			ogre qh
			call DMove -2 5 4 3
			call Converse "Druzzil Ro" 10 TRUE TRUE
			wait 50
			ogre end qh
			wait 20
			call CurrentQuestStep
		}
		while (${Return}<1)
	}
} 
	
function step001()
{	
	call ExitCoV
	do
	{
		call MoveTo "Enchantress W." 598 37 544
		call TestArrivalCoord 598 37 544 10
	}
	while (!${Return})
	wait 100
	call CheckCombat
	do
	{
		call Converse "Enchantress W." 18
		call CurrentQuestStep
	}
	while (${Return}<2)
}

function step002()
{
	call ExitCoV
	do
	{
		call CheckQuestStep 3
		if (!${Return})
		{
			call waitfor_Zone "Plane of Magic"
			call navwrap -890 297 990
			call Hunt "planar earth elemental" 100 1
			wait 100
			call StopHunt
		}
		call CheckQuestStep 3
		if (!${Return})
		{
			call navwrap -1174 214 -672
			call Hunt "planar earth elemental" 100 1
			wait 100
			call StopHunt
		}
		call CheckQuestStep 3
		if (!${Return})
		{
			call navwrap -1278 356 -848
			call Hunt "planar earth elemental" 100 1
			wait 100
			call StopHunt
		}
		call CheckQuestStep 3
		if (!${Return})
		{
			call navwrap -576 169 72
			call Hunt "planar earth elemental" 100 1
			wait 100
			call StopHunt
		}
		call CheckQuestStep 3
		if (!${Return})
		{
			call navwrap -157 765 90
			call Hunt "planar earth elemental" 100 1
			wait 100
			call StopHunt
		}
		call CheckQuestStep 3
	}
	while (!${Return})
	call CheckQuestStep 4
	if (!${Return})
		call navwrap 306 -153 930
	do
	{
		call CheckQuestStep 4
		if (!${Return})
		{
			call MoveCloseTo "Song-Polished Sand"
			wait 50
			OgreBotAPI:ApplyVerbForWho["${Me.Name}", "Song-Polished Sand","Gather Sand"]
			wait 50
		}
		call CheckQuestStep 4	
	}
	while (!${Return})
	do
	{
		call CheckQuestStep 5
		if (!${Return})
		{
			call navwrap -681 124 -457
			wait 50
			OgreBotAPI:ApplyVerbForWho["${Me.Name}", "Pendant of the Elder Scrykin","Gather Pendant"]
			wait 50
		}
		call CheckQuestStep 5	
		if (!${Return})
		{
			call navwrap -504 129 -677
			wait 50
			OgreBotAPI:ApplyVerbForWho["${Me.Name}", "Pendant of the Elder Scrykin","Gather Pendant"]
			wait 50
		}
		call CheckQuestStep 5	
		if (!${Return})
		{
			call navwrap -471 163 -771
			wait 50
			OgreBotAPI:ApplyVerbForWho["${Me.Name}", "Pendant of the Elder Scrykin","Gather Pendant"]
			wait 50
		}
		call CheckQuestStep 5	
		if (!${Return})
		{
			call navwrap -588 132 -819
			wait 50
			OgreBotAPI:ApplyVerbForWho["${Me.Name}", "Pendant of the Elder Scrykin","Gather Pendant"]
			wait 50
		}
		call CheckQuestStep 5	
		if (!${Return})
		{
			call navwrap -786 132 -422
			wait 50
			OgreBotAPI:ApplyVerbForWho["${Me.Name}", "Pendant of the Elder Scrykin","Gather Pendant"]
			wait 50
		}
		call CheckQuestStep 4
	}
	while (${Return})
}

function step003()
{	
	call ExitCoV
	do
	{
		call MoveTo "Enchantress W." 601 38 543
		call TestArrivalCoord 601 38 543 10
	}
	while (!${Return})
	wait 100
	call PKey STRAFELEFT 2
	call CheckCombat
	call Converse "Enchantress W." 18
}
function step004()
{
	call ExitCoV
	do
	{
		call Hunt "Arcstone miner golem" 50 12 TRUE
		call CheckQuestStep 4
	}
	while (!${Return})
	call StopHunt
}
function step005()
{	
	call step003
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
}