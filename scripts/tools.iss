#define AUTORUN "num lock"
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
#define ZOOMIN MouseWheelUp
#define ZOOMOUT MouseWheelDown

function 2DNav(float X, float Z)
{
	variable float loc0 
	variable int Stucky=0
	echo Moving on my own to ${X} ${Z}
	face ${X} ${Z}
	if (${Me.Loc.X}>${X})
	{
		Stucky:Set[0]
		echo "doing X>"
		press -hold MOVEFORWARD
		do
		{	
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 5
			call CheckStuck ${loc0}
			if (${Return})
				Stucky:Inc
		}
		while (${Me.Loc.X}>${X} && ${Stucky}<10 )
		press -release MOVEFORWARD
		eq2execute loc
	}
	else
	{
		Stucky:Set[0]
		echo "doing X<"
	
		press -hold MOVEFORWARD
		do
		{	
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 5
			call CheckStuck ${loc0}
			if (${Return})
				Stucky:Inc
		}
		while (${Me.Loc.X}<${X} && ${Stucky}<10 )
		press -release MOVEFORWARD
		eq2execute loc
	}

	face ${X} ${Z}
	if (${Me.Loc.Z}>${Z})
	{
		Stucky:Set[0]
		echo "doing Z>"
	
		press -hold MOVEFORWARD
		do
		{	
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 5
			call CheckStuck ${loc0}
			if (${Return})
				Stucky:Inc
		}
		while (${Me.Loc.Z}>${Z} && ${Stucky}<10 )
		press -release MOVEFORWARD
		eq2execute loc
	}
	else
	{
		Stucky:Set[0]
		echo "doing Z<"
	
		press -hold MOVEFORWARD
		do
		{	
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 5
			call CheckStuck ${loc0}
			if (${Return})
				Stucky:Inc
		}
		while (${Me.Loc.Z}<${Z} && ${Stucky}<10 )
		press -release MOVEFORWARD
		eq2execute loc
	}
}

function 3DNav(float X, float Y, float Z)
{
	eq2execute waypoint ${X} ${Y} ${Z}
	call Ascend ${Y}
	call 2DNav ${X} ${Z}
}

function Abs(float A)
{
	variable float absv
	if (${A}<0)
		absv:Set[${Math.Calc64[-1*${A}]}]
	else
		absv:Set[${A}]
	return ${absv}
}

function ActivateSpecial(string ActorName, float X, float Y, float Z)
{
	call Move "${ActorName}" ${X} ${Y} ${Z}
	OgreBotAPI:Special["${Me.Name}"]
	wait 50
}

function ActivateVerb(string ActorName, float X, float Y, float Z, string verb)
{
	echo Looking to ${verb} ${ActorName} at ${X},${Y},${Z}
	call Move "${ActorName}" ${X} ${Y} ${Z}
	OgreBotAPI:ApplyVerbForWho["${Me.Name}","${ActorName}","${verb}"]
	wait 50
}

function Ascend(float Y)
{
	variable float loc0 
	variable int Stucky=0
	call CheckCombat
	call CheckSwimming
	echo Beginning Ascension... to ${Y}
	do
	{	
		loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
		press -hold FLYUP
		wait 5
		call CheckStuck ${loc0}
		if (${Return})
			Stucky:Inc
		if (${Stucky}>5)
			{	
				press -hold STRAFELEFT
				wait 5
				press -release STRAFELEFT
				press -hold STRAFERIGHT
				wait 5
				press -release STRAFERIGHT
			}	
	}
	while (${Me.Loc.Y}<${Y})
	press -release FLYUP
 	eq2execute loc
	return ${Me.Loc.Y}
}

function AutoCraft(string tool, string myrecipe, int quantity)
{
	call MoveCloseTo "${tool}"
	ogre craft
	wait 100
	echo adding recipe
	OgreCraft:AddRecipeName[${quantity},"${myrecipe}"]
	wait 100
	if (${OgreCraft.MissingResources})
	{
		echo Missing some ressources ! Something wrong happen on the way :(
	}
	else
	{
		echo Crafting ${quantity} "${myrecipe}"
		OgreCraft:Start[]
		do
		{
			wait 50
			call CountItem "${myrecipe}"
		}
		while (${Return}<${quantity})		
	}
	wait 20
	ogre end craft
}

function check_quest(string questname)
{
	variable index:quest Quests
	variable iterator It
	variable int NumQuests

	NumQuests:Set[${QuestJournalWindow.NumActiveQuests}]
    
	if (${NumQuests} < 1)
	{
		echo "No active quests found."
		return
	}
    
	QuestJournalWindow:GetActiveQuests[Quests]
	Quests:GetIterator[It]
	if ${It:First(exists)}
	{
        do
        {
			if (${It.Value.Name.Equal["${questname}"]})
			{
				echo already on ${questname} - RESUME NOT SUPPORTED YET
				return TRUE
        	}
		}
        while ${It:Next(exists)}
	}
	return FALSE
}    

function check_quest_step(string questname, int step)
{
	if (TRUE)
	{
		return TRUE
	}
	else
	{
		return FALSE
	}
}

function CheckCombat()
{
	echo Looking for mob preventing me to fly up
	OgreBotAPI:NoTarget[${Me.Name}]
	wait 20
	do
	{	
		wait 5
	}
	while (${Me.InCombatMode})
}

function CheckSwimming()
{
	echo trying to not swim anymore
	OgreBotAPI:NoTarget[${Me.Name}]
	if (${Me.IsSwimming})
	{
		echo I am in the water, going on land
		face 0 0
		press -hold MOVEFORWARD 
		do
		{	
			wait 5
		}
		while (${Me.IsSwimming})
		press -release MOVEFORWARD 
	}
}

function CheckStuck(float loc)
{
	variable float loc0=${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z}]}
	if (${loc}==${loc0})
	{
		return TRUE
	}
	else
	{
		return FALSE
	}
}

function Converse(string NPCName, int bubbles)
{
	echo Conversing with ${NPCName} (${bubbles} bubbles to validate)
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 10
	variable int x
   	for ( x:Set[0] ; ${x} <= ${bubbles} ; x:Inc )
	{
		OgreBotAPI:ConversationBubble["${Me.Name}",1]
		wait 15
	}
}

function ConversetoNPC(string NPCName, int bubbles, float X, float Y, float Z)
{
	target ${Me.Name}
	call Move "${NPCName}" ${X} ${Y} ${Z}
	wait 100
	call waitfor_NPC "${NPCName}"
	call Converse "${NPCName}" ${bubbles}
	wait 20
	OgreBotAPI:NoTarget[${Me.Name}]
}

function CountItem(string ItemName)
{
	variable index:item Items
	variable iterator ItemIterator
    variable int Counter=0
    
		Me:QueryInventory[Items, Location == "Inventory" && Name =- "${ItemName}"]
		Items:GetIterator[ItemIterator]
		if ${ItemIterator:First(exists)}
		{
			do
			{
				Counter:Set[${ItemIterator.Value.Quantity}]
			}	
		while ${ActorIterator:Next(exists)}
		}
	echo found ${Counter} ${ItemName} in Inventory
	return ${Counter}
}

function CurrentQuestStep()
{
    variable index:collection:string Details    
    variable iterator DetailsIterator
    variable int DetailsCounter = 0
    
    QuestJournalWindow.CurrentQuest:GetDetails[Details]
    Details:GetIterator[DetailsIterator]
	if (${DetailsIterator:First(exists)})
    {
        do
        {
            if (${DetailsIterator.Value.FirstKey(exists)})
            {
                do
                {
					if (${DetailsIterator.Value.CurrentKey.Equal["Check"]} && ${DetailsIterator.Value.CurrentValue.Equal["false"]})
                    return ${DetailsCounter}
                }
                while (${DetailsIterator.Value.NextKey(exists)} || ${DetailsIterator.Value.CurrentValue.Equal["false"]})
            }
            DetailsCounter:Inc
        }
        while ${DetailsIterator:Next(exists)}
    }
}
function GetSpecialQty(string ActorName, float X, float Y, float Z, string verb, int quantity)
{
	call CountItem "${ActorName}"
	if (${Return}<2)
	{
		call ActivateVerb "${ActorName}" ${X} ${Y} ${Z} ${verb}
	}
	else
	{
		echo Already have ${quantity} ${ActorName} in Inventory
	}
}
function GoDown()
{
	echo "Going Down : 5 5 5"
	if (${Me.FlyingUsingMount})
	{
		do
		{
			press -hold FLYDOWN
			wait 5
		}
		while (${Me.FlyingUsingMount})
		press -release FLYDOWN
	}
	wait 10
}

function goto_GH()
{
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]})
	{
		do
		{
			wait 20
		}
		while (!${Me.Ability[Call to Guild Hall].IsReady})
		OgreBotAPI:CastAbility[${Me.Name},"Call to Guild Hall"]
		do
		{
			wait 5
		}
		while (!${Zone.Name.Right[10].Equal["Guild Hall"]})
	}
}


function HarvestItem(string ItemName, int number)
{
    variable int Counter=0
	
	call Harvest "${ItemName}" ${number}
	call CountItem "${ItemName}"
	Counter:Set[${Return}]
	if (${Counter}>=${number})
		echo Found ${Counter} ${ItemName}/${number} in Inventory - Stop Harvesting
}

function HuntItem(string ActorName, string ItemName, float X, float Y, float Z, int number)
{
    variable int Counter
	call CountItem "${ItemName}"
	Counter:Set[${Return}]
	if (${Counter}<${number})
	{
	    echo looting ${number} ${ItemName} from "${ActorName}" in progress
		call navwrap ${X} ${Y} ${Z}
		do
		{
			Counter:Set[0]
			
			call Hunt "${ActorName}" ${number}
			call CountItem "${ItemName}"
			Counter:Set[${Return}]
		}	
		while (${Counter}<${number})
	}
	echo Found ${Counter} ${ItemName}/${number} in Inventory - Stop Hunting
	call StopHunt
}
function Harvest(string ItemName)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	
	EQ2:QueryActors[Actors, Name  =- "${ItemName}" && Distance <= 100]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			Count:Inc	
		}	
		while ${ActorIterator:Next(exists)}
	}
	
	echo "There is ${Count} ${ItemName}"
	if (${Count}>0)
	{
		if ${ActorIterator:First(exists)}
		{
			do
			{
				eq2execute waypoint ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
				echo going to ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
				call 3DNav ${ActorIterator.Value.X} ${Math.Calc64[${ActorIterator.Value.Y}+200]} ${ActorIterator.Value.Z}
				wait 10
				call GoDown
				eq2execute loc
				wait 20
				ogre harvestlite
				wait 10
				echo trying to harvest ${ItemName}
				wait 200
			}
			while ${ActorIterator:Next(exists)}
		}		
	}
}

function Hunt(string ActorName, int number)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	
	EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= 100]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			Count:Inc	
		}	
		while ${ActorIterator:Next(exists)}
	}
	
	echo "There is ${Count} ${ActorName}/${number}"
	Ob_AutoTarget:AddActor["${ActorName}",0,FALSE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","TRUE"]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			echo ${ActorIterator.Value.Name} found at ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
			call navwrap ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
		}	
		while ${ActorIterator:Next(exists)}
	}
}


	
function Move(string ActorName, float X, float Y, float Z)
{
	eq2execute waypoint ${X} ${Y} ${Z}
	if (${Actor["${ActorName}"].Distance} < 20 && ${Actor["${ActorName}"].Distance(exists)})
		call MoveCloseTo "${ActorName}"
	else
	{
			call TestArrivalCoord ${X} ${Y} ${Z}
			if (!${Return})
				call MoveTo "${ActorName}" ${X} ${Y} ${Z}
			else
				echo I am there but does ${ActorName} exist here ?
	}
	wait 10
}

function MoveCloseTo(string ActorName)
{
	echo Moving closer to ${Actor["${ActorName}"].Name}
	face ${Actor["${ActorName}"].X} ${Actor["${ActorName}"].Z}
	press -hold MOVEFORWARD
	do
	{
		wait 1
	}
	while (${Actor["${ActorName}"].Distance}>5 && ${Actor["${ActorName}"].Distance(exists)})
	press -release MOVEFORWARD
	wait 10
}
					
function MoveTo(string ActorName, float X, float Y, float Z)
{
	target ${Me.Name}
	wait 10
	echo "moving to location ${X} ${Y} ${Z} (${ActorName})"
	do
	{
		call navwrap ${X} ${Y} ${Z}
		echo ${ActorName} is at ${Actor["${ActorName}"].Distance}m (${Actor["${ActorName}"].X},${Actor["${ActorName}"].Y},${Actor["${ActorName}"].Z})
		
		if (${Actor["${ActorName}"].Distance} > 20 && ${Actor["${ActorName}"].Distance(exists)})
		{
			echo getting closer to ${ActorName} (${Actor["${ActorName}"].Distance})
			call navwrap ${Actor["${ActorName}"].X} ${Actor["${ActorName}"].Y} ${Actor["${ActorName}"].Z}
		}
		else
		{
			call MoveCloseTo ${ActorName}
		}
		echo ${ActorName} at ${Actor["${ActorName}"].Distance}m
	}
	while (${Actor["${ActorName}"].Distance} > 10)
	OgreBotAPI:NoTarget[${Me.Name}]
}

function navwrap(float X, float Y, float Z)
{
	variable float loc0=0
	variable int Stucky=0
	wait 10
	if (${X}==0 && ${Y}==0 && ${Z}==0)
	{
		echo something wrong is happening, cancelling movement
		return
	}	
	echo "moving to location ${X} ${Y} ${Z} (wrapping ogre navtest -loc)"
	eq2execute waypoint ${X} ${Y} ${Z}
	do
	{
		Stucky:Inc
		echo "launching ogre navtest (${Stucky}/3)"
		call CheckCombat
		target ${Me.Name}
		ogre navtest -loc ${X} ${Y} ${Z}
		wait 100
		do
 		{
			wait 20
		}
		while (${Script["Buffer:OgreNavTest"](exists)})
		wait 20
		call TestArrivalCoord ${X} ${Y} ${Z}
		echo Destination reached via navwrap : ${Return}
	}
	while (!${Return} && ${Stucky} < 3 )
	if (${Stucky} > 2)
	{
		echo "Seems stuck - Trying to get there anyway"
		call 3DNav ${X} ${Math.Calc64[${Y}+200]} ${Z}
		call GoDown
	}
	OgreBotAPI:NoTarget[${Me.Name}]
	eq2execute loc
}

function StopHunt()
{
	Ob_AutoTarget:Clear
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","FALSE","FALSE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","FALSE","FALSE"]
}
function strip_QN(string questname)
{
	variable string sQN
	sQN:Set[${questname.Replace[",",""]}]
	sQN:Set[${sQN.Replace[":",""]}]
	sQN:Set[${sQN.Replace[" ",""]}]
	return ${sQN}
}

function StartQuest(int stepstart, int stepstop)
{
	variable string n
	variable int i
	
	if (${stepstart}==0)
	{
		call CurrentQuestStep
		stepstart:Set[${Return}]
	}
	if (${stepstart}<=${stepstop})
	{
		for ( i:Set[${stepstart} ] ; ${i} <= ${stepstop} ; i:Inc )
		{
			n:Set["00${i}"]
			echo "Starting step${n.Right[3]} to step${stepstop}"
			call step${n.Right[3]}
			wait 10
		}
	}
}
function TestArrivalCoord(float X, float Y, float Z)
{
	variable float Ax
	variable float Ay
	variable float Az
	
	call Abs ${Math.Calc64[${Me.Loc.X}-${X}]}
	Ax:Set[${Return}]
	call Abs ${Math.Calc64[${Me.Loc.Y}-${Y}]}
	Ay:Set[${Return}]
	call Abs ${Math.Calc64[${Me.Loc.Z}-${Z}]}
	Az:Set[${Return}]
	echo Debug : Me (${Me.Loc.X},${Me.Loc.Y},${Me.Loc.Z} must go ${X},${Y},${Z} - Test found ${Ax},${Ay},${Az}
	if (${Ax}<10 && ${Ay}<10 && ${Az}<10)
	{
		return TRUE
	}
	else
	{
		return FALSE
	}
}


function waitfor_NPC(string NPCName)
{
	do
	{
		wait 5
	} 
	while (${Actor["${NPCName}"].Distance} > 20 || !${Actor["${NPCName}"].Distance(exists)})
	echo Debug: I have reach ${NPCName} 
}

function ZoomOut(int ntime)
{
	variable int i
	for ( i:Set[1] ; ${i} <= ${ntime} ; i:Inc )
	{
		press ZOOMOUT
		wait 5
	}
}

