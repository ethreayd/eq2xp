#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=0
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
		}
		while (!${Return})
	}
} 
	
function step001()
{	
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{
		call DMove 92 3 163 3
		OgreBotAPI:Special["${Me.Name}"]
	}
	call waitfor_Zone "Plane of Magic"
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
	do
	{
		call CheckQuestStep 3
		if (!${Return})
		{
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
	do
	{
		call MoveTo "Enchantress W." 598 37 544
		call TestArrivalCoord 598 37 544 10
	}
	while (!${Return})
	wait 100
	call CheckCombat
	call Converse "Enchantress W." 18
}
function step004()
{
	do
	{
		call Hunt "Arcstone miner golem" 50 12 TRUE
		call CheckQuestStep 4
	}
	while (!${Return})
}
function step005()
{	
	call step003
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
}