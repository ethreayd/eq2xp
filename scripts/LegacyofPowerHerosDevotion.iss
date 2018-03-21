#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=2
	questname:Set["${qn}"]
	QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	call StartQuest ${stepstart} ${stepstop}
	
	echo End of Quest reached
}

function step000()
{
	NPCName:Set["Druzzil Ro"]
	echo DESCRIPTION : ${questname}
	echo QUESTGIVER : ${NPCName}

	call check_quest "${questname}"
	if (!${Return})
	{
		call ConversetoNPC "${NPCName}" 5 58 368 -179 TRUE
	}
	OgreBotAPI:UseItem[${Me.Name},"Totem of the Otter"]
	call navwrap 34 312 -291
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call ActivateVerb "zone_to_pov" -785, 345, 1116 "Enter the Coliseum of Valor"
} 
	
function step001()
{	
	call waitfor_Zone "Coliseum of Valor: Hero's Devotion"
	do
	{
		call AutoHunt 200
		call 2DNav 62 111
		wait 50
		call 2DNav 0 0
		call AutoHunt 200
		call 2DNav -60 100
		wait 50
		call 2DNav 0 0
		call AutoHunt 200
		call CheckQuestStep 2
	}
	while (!${Return})
	call StopHunt
	call 2DNav 0 0
	call ConversetoNPC "Mithaniel Marr" 5 0 5 0 TRUE
}

function step002()
{	
	if (${Zone.Name.Equal["Coliseum of Valor: Hero's Devotion"]})
	{	
		call ActivateVerb "sig_x2_pov_zone_exit - click to zone to the true Coliseum of Valor or back to Plane of Magic" 0 0 0 "Leave the Coliseum of Valor"
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",1]
		wait 50
	}
	call waitfor_Zone "Coliseum of Valor"
	call 2DNav 0 0
	call ConversetoNPC "Druzzil Ro" 5 0 5 0 TRUE
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]	
}
