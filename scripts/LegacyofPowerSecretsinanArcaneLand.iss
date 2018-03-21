#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, int stepstart, int stepstop)
{
	variable int laststep=6
	questname:Set["${qn}"]
	QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	call StartQuest ${startstep} ${stepstop}
	
	echo End of Quest reached
}

function step000()
{
	NPCName:Set["Aunsellus Tishan"]
	echo DESCRIPTION : ${questname}
	echo QUESTGIVER : ${NPCName}

	call check_quest "${questname}"
	if (!${Return})
	{
	call ConversetoNPC "${NPCName}" 16 1171 792 -1582
	}
	call StartQuest ${startstep} ${stepstop}
	
} 
	
function step001()
{	
	call ActivateSpecial "arcane seal" 62 76 -567
	call Ascend 250
	call ActivateSpecial "arcane seal" 44 86 -59
	call Ascend 250
	call ActivateSpecial "arcane seal" -485 215 -477
	call 3DNav 438 600 -506
	call GoDown
	OgreBotAPI:Special["${Me.Name}"]
	wait 50
	call StartQuest ${startstep} ${stepstop}
	
}

function step002()
{	
	call 3DNav -148 600 -743
	call GoDown
	call ActivateVerb "Teleporter to Khali'Vahla's Artisan Terrace" -148 577 -743 "Touch"
	call ActivateSpecial "esoteran reading stone scroll" -132 1263 -753
	Me.Inventory["Esoteran Reading Stone Scroll"]:Scribe
	wait 10
	call ActivateVerb "Teleporter to Khali'Vahla" -149 1263 -740 "Touch"
	call StartQuest ${startstep} ${stepstop}
}

function step003()
{	
	call StopHunt
	call HuntItem "ignus" "Ignus Manaflare" 885 12 -206 1
	call GetSpecialQty "Luminia Sapphire" 212 124 -171 "Gather" 2
	call GetSpecialQty "Luminia Sapphire" 525 24 -875 "Gather" 2
	call GetSpecialQty "Luminia Sapphire" 663 15 -697 "Gather" 2
	OgreBotAPI:UseItem[${Me.Name},"Totem of the Otter"]
	call GetSpecialQty "Cirussean Salt" 558 9 -959 "Gather" 2
	call GetSpecialQty "Cirussean Salt" 888, 9, 211 "Gather" 2
	call GetSpecialQty "Cirussean Salt" 892, 10, 267 "Gather" 2
	call StartQuest ${startstep} ${stepstop}
	
}

function step004()
{
	call navwrap  -148 577 -743
	call ActivateVerb "Teleporter to Khali'Vahla's Artisan Terrace" -148 577 -743 "Touch"
	call AutoCraft "Elaborate Chemistry Table" "Esoteran Reading Stone" 1
}

function step005()
{
	call ActivateVerb "Teleporter to Khali'Vahla" -149 1263 -740 "Touch"
	wait 20
	call step001
}

function step006()
{
	call ZoomOut 20
	call ConversetoNPC "Druzzil Ro" 4 57 369 -176
}
