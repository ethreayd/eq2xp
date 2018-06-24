#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/POI/TravelBellPoI.iss"
variable(script) string QuestName
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=0
	variable bool nocheckquest
	questname:Set["${qn}"]
	
	QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
	if (!${QuestJournalWindow.ActiveQuest["${questname}"](exists)})
		nocheckquest:Set[TRUE]
		
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	
	call StartQuest ${stepstart} ${stepstop} ${nocheckquest} 
	
	echo End of Quest reached
}

function step000()
{
	variable string ZoneName
	variable string POI
	
	ZoneName:Set["Timorous Deep"]
	NPCName:Set["Hrath Everstill"]
	echo DESCRIPTION : ${QuestName}
	echo QUESTGIVER : ${NPCName}
	echo STARTING ZONE : ${ZoneName}
	
	call strip_QN "${NPCName}"
	POI:Set[${Return}]
	
	call BelltoZone "${ZoneName}"
	call goto_${POI}
	
	call Converse "${NPCName}" 5
	wait 10
	ChoiceWindow:DoChoice1
	call Converse "${NPCName}" 15
	wait 10
	ChoiceWindow:DoChoice1
	
	NPCName:Set["Eralok Riz'rok"]
	call strip_QN "${NPCName}"
	POI:Set[${Return}]
	call goto_GH
	call BelltoZone "${ZoneName}"
	call goto_${POI}
	call Converse "${NPCName}" 7
	call DMove 2448 18 1291 3
	call DMove 2344 14 1389 3
	
	NPCName:Set["Parser Talakla Dih'di"]
	call strip_QN "${NPCName}"
	POI:Set[${Return}]
	call BelltoZone "${ZoneName}"
	call goto_${POI}
	call Converse "${NPCName}" 4
	call DMove 2609 101 1228 3
	call 3DNav 2551 66 1191
	call GoDown
	call DMove 2501 12 1243 3
	call DMove 2493 12 1262 3
	call DMove 2453 17 1264 3
	call DMove 2381 22 1355 3
	call DMove 2338 14 1394 3
	
	NPCName:Set["Parser Voldik Myli'sok"]
	call strip_QN "${NPCName}"
	POI:Set[${Return}]
	call goto_${POI} TRUE
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 10
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 15
	OgreBotAPI:ConversationBubble["${Me.Name}",2]
	wait 15
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 15
	OgreBotAPI:ConversationBubble["${Me.Name}",1]
	wait 15
	call DMove 2669 98 1126 3
	call DMove 2630 66 1150 3
	call DMove 2652 66 1171 3
	call DMove 2654 66 1190 3
	call DMove 2676 66 1193 3
	call DMove 2716 86 1244 3
	call DMove 2696 83 1278 3
	call DMove 2656 83 1295 3
	call DMove 2682 83 1317 3
	call DMove 2662 83 1347 3
	call DMove 2667 83 1362 3
	call ActivateVerb "deity_bertoxxulous_tome" 2662 84 1358 "take the tome"
	wait 20
	call goto_GH
	
	NPCName:Set["Prime Parser Tolok Ku'ele"]
	call strip_QN "${NPCName}"
	POI:Set[${Return}]
	call BelltoZone "${ZoneName}"
	call goto_${POI}
	call Converse "${NPCName}" 5
	call 3DNav 2573 110 1238
	call GoDown
	call DMove 2515 12 1229 3
	call DMove 2501 12 1243 3
	call DMove 2493 12 1262 3
	call DMove 2453 17 1264 3
	call DMove 2381 22 1355 3
	call DMove 2338 14 1394 3
	call 3DNav 2438 33 1446 3
	call GoDown
	call DMove 2400 3 1387 3
	call DMove 2408 3 1375 3
	call Converse "a parser disciple" 3
	target "a parser disciple"
	call DMove 2420 0 1425 3
	call 3DNav 2420 37 1425
	call 3DNav 2354 28 1375
	call GoDown
	
	NPCName:Set["Hrath Everstill"]
	call strip_QN "${NPCName}"
	POI:Set[${Return}]
	
	call BelltoZone "${ZoneName}"
	call goto_${POI}
	call Converse "${NPCName}" 4
	oc !c -acceptreward ${Me.Name}
}