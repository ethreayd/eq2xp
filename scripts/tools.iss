#define AUTORUN "num lock"
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
#define PAGEUP "Page Up"
#define PAGEDOWN "Page Down"
#define WALK shift+r
#define ZOOMIN MouseWheelUp
#define ZOOMOUT MouseWheelDown

function 2DNav(float X, float Z, bool ForceWalk)
{
	variable float loc0 
	variable int Stucky=0
	variable bool WasRunning
	
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
			call CheckWalking
			if (${ForceWalk} && !${Return})
				{
					WasRunning:Set[TRUE]
					press WALK
				}
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
			call CheckWalking
			if (${ForceWalk} && !${Return})
				{
					WasRunning:Set[TRUE]
					press WALK
				}
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
	if (${WasRunning})
		press WALK
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
	call TestArrivalCoord  ${X} ${Y} ${Z}
	if (!${Return})
		call Move "${ActorName}" ${X} ${Y} ${Z}
	OgreBotAPI:Special["${Me.Name}"]
	wait 50
}

function ActivateVerb(string ActorName, float X, float Y, float Z, string verb)
{
	echo Looking to ${verb} ${ActorName} at ${X},${Y},${Z}
	call TestArrivalCoord  ${X} ${Y} ${Z}
	if (!${Return})
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

function AutoHunt(int distance)
{
	
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${distance}]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	EQ2:QueryActors[Actors, Type  =- "NPC" && Distance <= ${distance}]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			Count:Inc	
		}	
		while ${ActorIterator:Next(exists)}
	}
	
	echo "There is ${Count} NPC within ${distance}m"
	if (${Count}>0)
	{
		if ${ActorIterator:First(exists)}
		{
			do
			{
				do
				{	
					wait 5
				}
				while (${Me.InCombatMode})
				eq2execute waypoint ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
				echo going to ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
				call 2DNav ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
				wait 10
			}
			while ${ActorIterator:Next(exists)}
		}		
	}
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
				echo already on ${questname}
				return TRUE
        	}
		}
        while ${It:Next(exists)}
	}
	return FALSE
}    

function CheckQuestStep(int step)
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
					echo ${DetailsCounter}==${step} && ${DetailsIterator.Value.CurrentKey.Equal["Check"]} && ${DetailsIterator.Value.CurrentValue.Equal["true"]}
					if (${DetailsCounter}==${step} && ${DetailsIterator.Value.CurrentKey.Equal["Check"]} && ${DetailsIterator.Value.CurrentValue.Equal["true"]})
                    {
						echo step ${step} is done
						return TRUE
					}
                }
                while (${DetailsIterator.Value.NextKey(exists)})
            }
            DetailsCounter:Inc
        }
        while ${DetailsIterator:Next(exists)}
		return FALSE
    }
}

function CheckCombat()
{
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

function CheckWalking()
{

			if (${Math.Calc64[${Me.Velocity.X} * ${Me.Velocity.X} + ${Me.Velocity.Y} * ${Me.Velocity.Y} + ${Me.Velocity.Z} * ${Me.Velocity.Z} ]}>100)
				return FALSE
			else
				return TRUE
}				

function Converse(string NPCName, int bubbles, bool giant)
{
	echo Conversing with ${NPCName} (${bubbles} bubbles to validate)
	if (${giant})
	{
		echo ${NPCName} is really a big fellow
		call PKey "MOVEBACKWARD" 5
		call PKey "Page Up" 5
		call PKey "ZOOMOUT" 20		
	}
	
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 10
	variable int x
   	for ( x:Set[0] ; ${x} <= ${bubbles} ; x:Inc )
	{
		OgreBotAPI:ConversationBubble["${Me.Name}",1]
		wait 15
	}
}

function ConversetoNPC(string NPCName, int bubbles, float X, float Y, float Z, bool giant)
{
	target ${Me.Name}
	call TestArrivalCoord ${X} ${Y} ${Z}
	if (!${Return})
		call Move "${NPCName}" ${X} ${Y} ${Z}
	wait 20
	call waitfor_NPC "${NPCName}"
	call Converse "${NPCName}" ${bubbles} ${giant}
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

function DMove(float X, float Y, float Z, int speed)
{
	eq2execute waypoint ${X}, ${Y}, ${Z}
	call waitfor_Health 90
	call waitfor_Combat
	call Get2DDirection ${X} ${Z}
	call Go2D ${X} ${Y} ${Z} ${Return} ${speed} 
}

function Follow2D(string ActorName,float X, float Y, float Z, float RespectDistance, bool Walk)
{
	variable index:actor Actors
	variable iterator ActorIterator
	
	EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= 50]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			if  (${ActorIterator.Value.Distance}> ${RespectDistance})
				call 2DNav ${ActorIterator.Value.X} ${ActorIterator.Value.Z} ${Walk}
			wait 5
			call TestArrivalCoord ${X} ${Y} ${Z}
		}	
		while (!${Return})
	}
}

function Get2DDirection(float X, float Z)
{
	if (((${X} < ${Me.X}) && (${Z} < ${Me.Z})) || ((${X} > ${Me.X}) && (${Z} > ${Me.Z})))
		return "STRAFERIGHT"
	else
		return "STRAFELEFT"
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
function Go2D(float X, float Y, float Z, string strafe, int speed)
{
	variable float loc0 
	variable int Stucky
	variable bool There
	if (${speed}==0)
		speed:Set[1]
	do
	{
		Stucky:Set[0]
		do
		{
			face ${X} ${Z}
			call CheckCombat
			call waitfor_Health 99
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			press -hold MOVEFORWARD
			wait ${speed}
			press -release MOVEFORWARD
			wait 1
			press -hold MOVEFORWARD
			wait ${speed}
			press -release MOVEFORWARD
			call CheckStuck ${loc0}
			if (${Return})
				Stucky:Inc
			echo Stucky=${Stucky}
			call TestArrivalCoord ${X} ${Y} ${Z} 5
			There:Set[${Return}]
		}
		while (${Stucky}<10 && !${There})
		if (!${There})
		{
			press -hold ${strafe}
			wait 5
			press -release ${strafe}
		}		
		call TestArrivalCoord ${X} ${Y} ${Z} 5
	}
	while (!${Return})
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

function HarvestItem(string ItemName, int number)
{
    variable int Counter=0
	
	call Harvest "${ItemName}" ${number}
	call CountItem "${ItemName}"
	Counter:Set[${Return}]
	if (${Counter}>=${number})
		echo Found ${Counter} ${ItemName}/${number} in Inventory - Stop Harvesting
}


function Hunt(string ActorName, int distance, int number, bool nofly)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	
	EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= ${distance}]
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
			call waitfor_Health 90
			echo ${ActorIterator.Value.Name} found at ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
			if (!${nofly})
				call navwrap ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
			else
				call 2DNav ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
		}	
		while ${ActorIterator:Next(exists)}
	}
}

function HuntItem(string ActorName, string ItemName, float X, float Y, float Z, int number, int distance)
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
			
			call Hunt "${ActorName}" ${distance} ${number}
			call CountItem "${ItemName}"
			Counter:Set[${Return}]
		}	
		while (${Counter}<${number})
	}
	echo Found ${Counter} ${ItemName}/${number} in Inventory - Stop Hunting
	call StopHunt
}
function IsPresent(string ActorName)
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
	if (${Count}>0)
		return TRUE
	else
		return FALSE
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

function OpenDoor(string ActorName)
{
	variable index:actor Actors
	variable iterator ActorIterator
	
	echo searching ${ActorName}
	
	EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= 20]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			echo Found ${ActorIterator.Value.Name} 
			Actor[name,"${ActorIterator.Value.Name}"]:DoubleClick
		}	
		while ${ActorIterator:Next(exists)}
	}
}


function PKey(string KName, int ntime)
{
	press -hold "${KName}"
	wait ${ntime}
	press -release "${KName}"
}
function StopHunt()
{
	Ob_AutoTarget:Clear
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","FALSE","FALSE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","FALSE","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius","0"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]
}
function strip_QN(string questname)
{
	variable string sQN
	echo IN:${questname}
	sQN:Set[${questname.Replace[",",""]}]
	sQN:Set[${sQN.Replace[":",""]}]
	sQN:Set[${sQN.Replace["'",""]}]
	sQN:Set[${sQN.Replace[" ",""]}]
	echo OUT:${sQN}
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
function TestArrivalCoord(float X, float Y, float Z, int Precision)
{
	variable float Ax
	variable float Ay
	variable float Az
	
	if (${Precision}<1)
		Precision:Set[10]
	
	call Abs ${Math.Calc64[${Me.Loc.X}-${X}]}
	Ax:Set[${Return}]
	call Abs ${Math.Calc64[${Me.Loc.Y}-${Y}]}
	Ay:Set[${Return}]
	call Abs ${Math.Calc64[${Me.Loc.Z}-${Z}]}
	Az:Set[${Return}]
	echo Debug : Me (${Me.Loc.X},${Me.Loc.Y},${Me.Loc.Z} must go ${X},${Y},${Z} - Test found ${Ax},${Ay},${Az}
	if (${Ax}<${Precision} && ${Ay}<${Precision} && ${Az}<${Precision})
	{
		return TRUE
	}
	else
	{
		return FALSE
	}
}

function WaitByPass(string ActorName, float GLeft, float GRight)
{
	variable index:actor Actors
	variable iterator ActorIterator
	
	
	EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= 200]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		echo waiting for named to go left
		do
		{
			wait 10 
		}	
		while (${ActorIterator.Value.Z}<${GLeft})
		echo waiting for named to go right
		do
		{
			wait 10 
		}	
		while (${ActorIterator.Value.Z}>${GRight})
		echo "${ActorName}" has bypassed ${GLeft}) and ${GRight}
	}		
}

function waitfor_Combat()
{
	do
	{
		wait 5
	} 
	while (${Me.InCombatMode})
}

function waitfor_Health(int health)
{
	do
	{
		wait 5
	} 
	while (${Me.Health} <${Health})
	
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

function waitfor_Zone(string ZoneName)
{
	do
	{
		wait 5
	}
	while (!${Zone.Name.Equal["${ZoneName}"]})
	echo I am in ${ZoneName}
}



