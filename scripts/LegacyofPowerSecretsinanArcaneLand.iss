#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"
variable(script) string questname
variable(script) string NPCName

function main(string qn, string step)
{
	variable int nbsteps=9
	questname:Set["${qn}"]
	call StartQuest ${nbsteps} ${step}
	echo End of Quest reached
}

function step000()
{
	NPCName:Set["Aunsellus Tishan"]
	echo DESCRIPTION : ${questname}
	echo QUESTGIVER : ${NPCName}
} 

function step001()
{
	call check_quest "${questname}"
	if (!${Return})
	{
	call ConversetoNPC "${NPCName}" 16 1171 792 -1582
	}
} 
	
function step002()
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
}

function step003()
{	
	call 3DNav -148 600 -743
	call GoDown
	call ActivateVerb "Teleporter to Khali'Vahla's Artisan Terrace" -148 577 -743 "Touch"
	call ActivateSpecial "esoteran reading stone scroll" -132 1263 -753
	Me.Inventory["Esoteran Reading Stone Scroll"]:Scribe
	wait 10
	call ActivateVerb "Teleporter to Khali'Vahla" -149 1263 -740 "Touch"
}

function step004()
{	
	call StopHunt
	call navwrap 885 12 -206
	call HuntItem "ignus" "Ignus Manaflare" 1
}

function step005()
{	
	call CountItem "Luminia Sapphire"
	if (${Return}<2)
	{
		do
		{
			call ActivateVerb "Luminia Sapphire" 212 124 -171 "Gather"
			call ActivateVerb "Luminia Sapphire" 525 24 -875 "Gather"
			call ActivateVerb "Luminia Sapphire" 663 15 -697 "Gather"
			call CountItem "Luminia Sapphire"
		}
		while (${Return}<2)
	}
}

function step006()
{	
	call CountItem "Cirussean Salt"
	if (${Return}<2)
	{
		OgreBotAPI:UseItem[${Me.Name},"Totem of the Otter"]
		do
		{
			call ActivateVerb "Cirussean Salt" 558 9 -959 "Gather" 
			call ActivateVerb "Cirussean Salt" 888, 9, 211 "Gather"
			call ActivateVerb "Cirussean Salt" 892, 10, 267 "Gather"
			call CountItem "Cirussean Salt"
		}
		while (${Return}<2)
	}
}

function step007()
{
	call navwrap  -148 577 -743
	call ActivateVerb "Teleporter to Khali'Vahla's Artisan Terrace" -148 577 -743 "Touch"
	call AutoCraft "Elaborate Chemistry Table" "Esoteran Reading Stone" 1
}

function step008()
{
	call ActivateVerb "Teleporter to Khali'Vahla" -149 1263 -740 "Touch"
	wait 20
	call step002
}

function step009()
{
	call ZoomOut 20
	call ConversetoNPC "Druzzil Ro" 4 57 369 -176
}
