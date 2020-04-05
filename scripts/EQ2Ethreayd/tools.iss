#define AUTORUN "num lock"
#define CENTER p
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
#define ZOOMIN "Num +"
#define ZOOMOUT "Num -"
#define JUMP Space

#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/EQ2Travel.iss"

function 2DNav(float X, float Z, bool IgnoreFight, bool ForceWalk, int Precision, bool IgnoreStuck)
{
	variable float loc0 
	variable int Stucky=0
	variable bool WasRunning
	if ${Precision}<1
		Precision:Set[10]
	echo Moving on my own to ${X} ${Z} (entering 2DNav)
	face ${X} ${Z}

	if (${Me.Loc.X}>${X})
	{
		Stucky:Set[0]
		echo "doing X>"
		face ${X} ${Z}
		press -hold MOVEFORWARD
		
		do
		{	
			face ${X} ${Z}
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 5
			
			if (${ForceWalk})
			{
				call CheckWalking
				if (!${Return})
				{
					echo Force Walk
					WasRunning:Set[TRUE]
					press WALK
				}
			}
			if (!${IgnoreStuck})
			{
				call CheckStuck ${loc0}
				if (${Return})
				{
					Stucky:Inc
				}
			}
			if (!${IgnoreFight})
			{
				call CheckCombat
			}	
		}
		while (${Me.Loc.X}>${X} && ${Stucky}<10)
		press -release MOVEFORWARD
		eq2execute loc
	}
	else
	{
		Stucky:Set[0]
		echo "doing X<"
		face ${X} ${Z}
		press -hold MOVEFORWARD
		do
		{
			face ${X} ${Z}
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 5
			if (${ForceWalk})
			{
				call CheckWalking
				if (!${Return})
				{
					echo Force Walk
					WasRunning:Set[TRUE]
					press WALK
				}
			}
			if (!${IgnoreStuck})
			{
				echo Check Stuck
				call CheckStuck ${loc0}
				if (${Return})
				{
					Stucky:Inc
				}
			}
			if (!${IgnoreFight})
			{
				call CheckCombat
			}	
		}
		while (${Me.Loc.X}<${X} && ${Stucky}<10 )
		press -release MOVEFORWARD
		eq2execute loc
	}
	call TestArrivalCoord ${X} 0 ${Z} ${Precision} TRUE
	if (!${Return})
	{
		face ${X} ${Z}
		if (${Me.Loc.Z}>${Z})
		{
			Stucky:Set[0]
			echo "doing Z>"
			face ${X} ${Z}
			press -hold MOVEFORWARD
			do
			{	
				face ${X} ${Z}
				loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
				wait 2
				if (${ForceWalk})
				{	
					call CheckWalking
					if (!${Return})
					{
						WasRunning:Set[TRUE]
						press WALK
					}
				}
				call CheckStuck ${loc0}
				if (${Return})
				{
					Stucky:Inc
				}
				if (!${IgnoreFight})
				{
					call CheckCombat
				}	
			}
			while (${Me.Loc.Z}>${Z} && ${Stucky}<10 )
			press -release MOVEFORWARD
			eq2execute loc
		}
		else
		{
			Stucky:Set[0]
			echo "doing Z<"
			face ${X} ${Z}
			press -hold MOVEFORWARD
			do
			{	
				face ${X} ${Z}
				loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
				wait 2
				if (${ForceWalk})
				{
					call CheckWalking
					if (!${Return})
					{
						WasRunning:Set[TRUE]
						press WALK
					}
				}
				call CheckStuck ${loc0}
				if (${Return})
				{
					Stucky:Inc
				}
				if (!${IgnoreFight})
				{
					call CheckCombat
				}	
			}
			while (${Me.Loc.Z}<${Z} && ${Stucky}<10 )
			press -release MOVEFORWARD
			eq2execute loc
		}
	}
	call TestArrivalCoord ${X} 0 ${Z} ${Precision} TRUE

	if (${WasRunning})
		press WALK
	echo exit from 2DNav
}
function 2DWalk(float X, float Z, int Precision)
{
	echo DEPRECATED use 2DNav with ForceWalk option
	call 2DNav ${X} ${Z} FALSE TRUE ${Precision}
}
function 3DNav(float X, float Y, float Z, int Precision, bool Swim)
{
	variable float loc0 
	variable int Stucky=0
	variable bool WasRunning

	eq2execute waypoint ${X} ${Y} ${Z}
	call Ascend ${Y} ${Swim}

	if ${Precision}<1
		Precision:Set[10]
	echo Moving on my own to ${X} ${Y} ${Z}
	face ${X} ${Z}

	if (${Me.Loc.X}>${X})
	{
		Stucky:Set[0]
		echo "doing X>"
		press -hold MOVEFORWARD
		
		do
		{	
			face ${X} ${Z}
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 5
			call Ascend ${Y} ${Swim}
			call CheckStuck ${loc0}
			if (${Return})
			{
				Stucky:Inc
			}
		}
		while (${Me.Loc.X}>${X} && ${Stucky}<10)
		press -release MOVEFORWARD
		call Ascend ${Y} ${Swim}
		eq2execute loc
	}
	else
	{
		Stucky:Set[0]
		echo "doing X<"
	
		press -hold MOVEFORWARD
		do
		{
			face ${X} ${Z}
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 5
			call Ascend ${Y} ${Swim}
			call CheckStuck ${loc0}
			if (${Return})
			{
				Stucky:Inc
			}
		}
		while (${Me.Loc.X}<${X} && ${Stucky}<10 )
		press -release MOVEFORWARD
		call Ascend ${Y} ${Swim}
		eq2execute loc
	}
	call TestArrivalCoord ${X} 0 ${Z} ${Precision} TRUE
	if (!${Return})
	{
		face ${X} ${Z}
		if (${Me.Loc.Z}>${Z})
		{
			Stucky:Set[0]
			echo "doing Z>"
			press -hold MOVEFORWARD
			do
			{	
				face ${X} ${Z}
				loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
				wait 2
				call Ascend ${Y} ${Swim}
				call CheckStuck ${loc0}
				if (${Return})
				{
					Stucky:Inc
				}
			}
			while (${Me.Loc.Z}>${Z} && ${Stucky}<10 )
			press -release MOVEFORWARD
			call Ascend ${Y} ${Swim}
			eq2execute loc
		}
		else
		{
			Stucky:Set[0]
			echo "doing Z<"
	
			press -hold MOVEFORWARD
			do
			{	
				face ${X} ${Z}
				loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
				wait 2
				call Ascend ${Y} ${Swim}
				call CheckStuck ${loc0}
				if (${Return})
				{
					Stucky:Inc
				}
			}
			while (${Me.Loc.Z}<${Z} && ${Stucky}<10 )
			press -release MOVEFORWARD
			call Ascend ${Y} ${Swim}
			eq2execute loc
		}
	}
	call TestArrivalCoord ${X} 0 ${Z} ${Precision} TRUE
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
function AcceptReward_(bool AcceptAll)
{
	do
	{
		waitframe
	}
	while ${Me.CastingSpell}
	wait 750 ${RewardWindow(exists)}
	do
	{
		RewardWindow:Receive
		wait 10
	}
	while (${RewardWindow(exists)} && ${AcceptAll})
}
function AcceptReward(bool AcceptAll)
{
	oc !c -AcceptReward
}

function ActivateAggro(string ActorName, string verb, float distance)
{
	call MoveCloseTo "${ActorName}" ${distance}
	do
	{
		do
		{
			face ${Actor["${ActorName}"].X} ${Actor["${ActorName}"].Z}
			press MOVEFORWARD -hold
			wait 1
			press MOVEFORWARD -release
		}
		while (${Actor["${ActorName}"].Distance}>5)
		call ActivateVerbOn "${ActorName}" "${verb}" TRUE
	}
	while (!${Actor["${ActorName}"].IsAggro})
	echo ${ActorName} is now aggro
	
}
function ActivateAll(string ActorName, string verb, float MaxDistance)
{
	variable index:actor Actors
    variable iterator ActorIterator
    
    EQ2:QueryActors[Actors, Distance <= ${MaxDistance} ]
    Actors:GetIterator[ActorIterator]
  
    if ${ActorIterator:First(exists)}
    {
        do
        {
            echo "${ActorIterator.Value.Name}" [${ActorIterator.Value.ID}] (${ActorIterator.Value.Distance} m)
			call DMove ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} 3 30 FALSE FALSE 5
			eq2execute apply_verb ${ActorIterator.Value.ID} "${verb}"
        }
        while ${ActorIterator:Next(exists)}
    }
}
function ActivateItemEffect(string EquipSlot, string ItemName, string ItemEffectName)
{
	variable string ItemSwap
	
	if (!${Me.Effect["${ItemEffectName}"]})
	{
		echo Equipping ${ItemName}
		ItemSwap:Set["${Me.Equipment["${EquipSlot}"]}"]
		Me.Inventory["${ItemName}"]:Equip
		wait 20
		echo Using ${ItemName}
		Me.Inventory["${ItemName}"]:Use
		do
		{
			waitframe
		}
		while ${Me.CastingSpell}
		wait 20
		Me.Inventory["${ItemSwap}"]:Equip
	}
}
function ActivateMelee()
{
	switch ${Me.Archetype}
	{
		case fighter
		{
			OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","TRUE"]
		}
		break
		case priest
		{
			OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","TRUE"]
		}
		break
		default
		{
			echo no melee configuration change for ${Me.Archetype}
		}
		break
	}
}
function ActivateSpecial(string ActorName, float X, float Y, float Z)
{
	call TestArrivalCoord  ${X} ${Y} ${Z}
	if (!${Return})
		call Move "${ActorName}" ${X} ${Y} ${Z}
	OgreBotAPI:Special["${Me.Name}"]
	wait 50
}
function ActivateSpire()
{
	variable string ActorName
	call IsPresent Spire 30 FALSE TRUE
	ActorName:Set["${Return}"]
	if (!${ActorName.Equal["FALSE"]})
	{
		call MoveCloseTo "${ActorName}"
		wait 20
		call ActivateVerbOn "${ActorName}" "Voyage Through Norrath" TRUE
		wait 10
	}
	else
		echo no Spire in 30m reach
}
function ActivateVerb(string ActorName, float X, float Y, float Z, string verb, bool is2D, bool triggerFight, bool UseID)
{
	echo Looking to ${verb} ${ActorName} at ${X},${Y},${Z}
	call TestArrivalCoord  ${X} ${Y} ${Z}
	if (!${Return})
		call Move "${ActorName}" ${X} ${Y} ${Z} ${is2D}
	echo "${Me.Name}" "${verb}" "${ActorName}" now
	if ${UseID}
		eq2execute apply_verb ${Actor[Query,Name=="${ActorName}"].ID} "${verb}"
	else
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${ActorName}","${verb}"]
	wait 50
	if (${triggerFight} && ${is2D})
	{
		wait 50
		call waitfor_Combat
		call DMove ${X} ${Y} ${Z} 3
	}
}
function ActivateVerbOn(string ActorName, string verb, bool UseID)
{
	echo do ${verb} on ${ActorName} (${UseID})
	if ${UseID}
		eq2execute apply_verb ${Actor[Query,Name=="${ActorName}"].ID} "${verb}"
	else
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${ActorName}","${verb}"]
	wait 50
}
function ActivateVerbOnPhantomActor(string verb, float RespectDistance, float Precision)
{
	variable index:actor Actors
    variable iterator ActorIterator
    variable bool Found
	variable bool Hit
	variable int ActorID
    EQ2:QueryActors[Actors]
    Actors:GetIterator[ActorIterator]
	if (${Precision}<1)
		Precision:Set[10]
    if ${ActorIterator:First(exists)}
    {       
		do
		{
			if (${ActorIterator.Value.Name.Equal[""]})
				{
					echo Found an empty Actor (ID:${ActorIterator.Value.ID}) at ${ActorIterator.Value.Distance} m
					ActorID:Set[${ActorIterator.Value.ID}]
					Found:Set[TRUE]
					echo Looking to ${verb} on Phantom Actor at ${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}
					call TestArrivalCoord  ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} ${Precision}
					if (!${Return})
					{       
						do
						{
							face ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
							if  (${ActorIterator.Value.Distance}> ${RespectDistance})
								call PKey MOVEFORWARD 1
							call TestArrivalCoord ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} ${Precision}
							if (${ActorIterator.Value.X}==0 && ${ActorIterator.Value.Y}==0 && ${ActorIterator.Value.Z}==0)
								Hit:Set[TRUE]
						}	
						while (!${Return} && !${Hit})
					}
					face ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
					echo "${Me.Name}" "${verb}" on ID ${ActorIterator.Value.ID} now
					eq2execute apply_verb ${ActorIterator.Value.ID} "${verb}"
					wait 20
				}
		}
        while (${ActorIterator:Next(exists)} && !${Found})
	}	
	return ${ActorID}
}
function AltTSUp()
{
	variable int Counter=0
	echo Starting Alternate TradeSkill Upgrade (using Myrist locations)
	call goDercin_Marrbrand
	wait 50
	call Converse "Dercin Marrbrand" 4
	wait 20
	call Converse "Dercin Marrbrand" 4
	wait 20
	call Converse "Dercin Marrbrand" 4
	wait 20
	Me.Inventory["Box of Tinkering Materials"]:Unpack
	wait 50
	Me.Inventory["Box of Adorning Materials"]:Unpack
	wait 50
	Me.Inventory["Box of Old Boots"]:Unpack
	wait 50

	call TransmuteAll "A worn pair of boots"
	wait 50
	call Converse "Dercin Marrbrand" 2
	wait 20
	call AutoCraft "Work Bench" "Adornment of Guarding (Greater)" 10 TRUE TRUE "Daily Adorning"
	wait 50
	call AutoCraft "Work Bench" "All Purpose Sprocket" 10 TRUE TRUE "All Purpose Sprockets"
	wait 20
	call goDercin_Marrbrand
	call Converse "Dercin Marrbrand" 2
	wait 20
	call Converse "Dercin Marrbrand" 2
	wait 20
	echo go to Guild Hall (with auto fix of stay forever there bug)
	do
	{
		Counter:Inc	
		wait 10
		if (${Counter}>500)
			echo I should do something about it
	}
	while (!${Me.Ability["Call to Guild Hall"].IsReady})
	call goto_GH TRUE
}

function Ascend(float Y, bool Swim)
{
	variable float loc0 
	variable int Stucky=0
	variable int SuperStuck=0
	variable int YStuck=0
	variable float Ymax=0
	call CheckCombat
	if (!${Swim})
		call CheckSwimming
	echo Beginning Ascension... to ${Y}
	if  (${Me.Loc.Y}<${Y})
	{	
		do
		{	
		
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			press -hold FLYUP
			wait 5
			if ${Me.Loc.Y}>${Ymax}
			{
				Ymax:Set[${Me.Loc.Y}]
				YStuck:Set[0]
			}
			else
				YStuck:Inc
			call CheckStuck ${loc0}
			if (${Return} || ${YStuck}>0)
				Stucky:Inc
			if (${Stucky}>5)
			{	
				ExecuteQueued
				echo stucked when ascending
				call CheckCombat
				call UnstuckR
				Stucky:Set[0]
				SuperStuck:Inc
			}
		}
		while (${Me.Loc.Y}<${Y} && ${SuperStuck}<5)
	}
	press -release FLYUP
 	eq2execute loc
	return ${Me.Loc.Y}
}
function AttackClosest(float MaxDistance)
{
    variable index:actor Actors
    variable iterator ActorIterator

    if (${MaxDistance}<1)
		MaxDistance:Set[30]

    EQ2:QueryActors[Actors, Type =- "NPC" && Distance <= ${MaxDistance} ]
    Actors:GetIterator[ActorIterator]
  
    if ${ActorIterator:First(exists)}
    {
	echo "${ActorIterator.Value.Name}" [${ActorIterator.Value.ID}] (${ActorIterator.Value.Distance} m)
	
        target ${ActorIterator.Value.ID}
    }
}
function AutoAddAgent()
{
	variable index:item Items
	variable iterator ItemIterator
    variable int Counter=0
	variable int Counter2=0
	variable int Counter3=0
		
		Me:QueryInventory[Items, Location == "Inventory"]
		Items:GetIterator[ItemIterator]
		if ${ItemIterator:First(exists)}
		{
			
			do
			{
				Counter3:Inc
				if ${ItemIterator.Value.IsAgent}
				{
					Me.Inventory[Query, Name == "${ItemIterator.Value.Name}"]:AddAgent[confirm]
					Counter:Inc
				}	
			}	
			while ${ItemIterator:Next(exists)}
		}
		
		Me:QueryInventory[Items, Location == "Inventory"]
		Items:GetIterator[ItemIterator]
		if ${ItemIterator:First(exists)}
		{
			do
			{
				if ${ItemIterator.Value.IsAgent}
				{
					Counter2:Inc
				}
			}	
			while ${ItemIterator:Next(exists)}
		}
		
	echo found ${Counter} Agents, ${Counter2} seems to be duplicate (scanned ${Counter3} items)
}

function AutoCraft(string tool, string myrecipe, int quantity, bool IgnoreRessources, bool QuestCraft, string QuestName)
{
	if (${QuestCraft})
	{
		call CheckQuest "${QuestName}"
		if (${Return})
		{
			call CheckQuestStep
			if (!${Return})
			{
				call MoveCloseTo "${tool}"
				ogre craft
				wait 100
				echo adding recipe
				OgreCraft:AddRecipeName[${quantity},"${myrecipe}"]
				wait 100
				if (${OgreCraft.MissingResources} && !${IgnoreRessources})
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
						call CheckQuestStep
					}
					while (!${Return})		
				}
				wait 20
				ogre end craft
			}
		}
		else
		{
			echo Quest ${QuestName} not in Journal !
		}
	}
	else
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
}

function AutoHunt(int distance)
{
	
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${distance}]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","TRUE"]
	
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
function AutoPassDoor(string DoorName, float X, float Y, float Z, bool ExecuteQueue)
{
	echo autopassing "${DoorName}"
	do
	{
		face ${Actor["${DoorName}"].X} ${Actor["${DoorName}"].Z}
		press -hold MOVEFORWARD
		wait 10
		press -release MOVEFORWARD
		call OpenDoor "${DoorName}"
		wait 10
		call 2DNav ${X} ${Z}
		if (${ExecuteQueue})
			ExecuteQueued
		call TestArrivalCoord ${X} ${Y} ${Z} 8 TRUE
	}
	while (!${Return})
}
function AutoPlant()
{
	echo starting AutoPlant Function
	;UIElement[OgreTaskListTemplateUIXML].FindUsableChild[button_clearerrors,button]:LeftClick
	call goto_GH
	wait 100
	do
	{
		echo I am in zone ${Zone.Name}
		call goto_House
		wait 300
		echo I am in zone ${Zone.Name}
	}
	while (${Zone.Name.Right[10].Equal["Guild Hall"]})
	wait 30
	Actor[name,"An Obulus Frontier Garden"]:DoubleClick
	wait 30
	Actor[name,"An Obulus Frontier Garden"]:DoubleClick
	wait 30
	Actor[name,"An Obulus Frontier Garden"]:DoubleClick
	wait 30
	call UnpackItem "A bushel of harvests" 3
	call goto_GH
}	
function AvoidRedCircles(float Distance, bool IsGroup)
{
	variable index:actor Actors
    variable iterator ActorIterator
    variable float AvoidDistance
	if (${Distance}<0)
		AvoidDistance:Set[30]
	else
		AvoidDistance:Set[${Distance}]
		
	EQ2:QueryActors[Actors, Distance <=${AvoidDistance} && Aura =- "design_circle_warning_zone"]
	
    Actors:GetIterator[ActorIterator]
	
    if ${ActorIterator:First(exists)}
    {
		echo Red Circle (${ActorIterator.Value.ID}) detected at ${ActorIterator.Value.Distance}m (Group=${IsGroup})
		call JoustOut ${ActorIterator.Value.ID} ${AvoidDistance} ${IsGroup}
	}
}
function BaryCenterX(string ActorName)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Counter=0
	variable float Sigma
	
	EQ2:QueryActors[Actors, Name  =- "${ActorName}"]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		
		do
		{
			Sigma:Set[${Math.Calc64[${Sigma}+${ActorIterator.Value.X}]}]
			Counter:Inc
		}
		while (${ActorIterator:Next(exists)})
		return ${Math.Calc64[${Sigma}/${Counter}]}
	}
	else
		return 0
}
function BaryCenterY(string ActorName)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Counter=0
	variable float Sigma=0
	
	EQ2:QueryActors[Actors, Name  =- ""]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		
		do
		{
			if ${Sigma}<${ActorIterator.Value.Y}
				Sigma:Set[${ActorIterator.Value.Y}]
			Counter:Inc
		}
		while (${ActorIterator:Next(exists)})
		if ${Sigma}>${Math.Calc64[${Me.Y}+100]}
			return ${Math.Calc64[${Me.Y}+100]}
		else
			return ${Sigma}
	}
	else
		return 0
}
function BaryCenterZ(string ActorName)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Counter=0
	variable float Sigma
	
	EQ2:QueryActors[Actors, Name  =- "${ActorName}"]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		
		do
		{
			Sigma:Set[${Math.Calc64[${Sigma}+${ActorIterator.Value.Z}]}]
			Counter:Inc
		}
		while (${ActorIterator:Next(exists)})
		return ${Math.Calc64[${Sigma}/${Counter}]}
	}
	else
		return 0
}
function BelltoZone(string ZoneName)
{
	; this function has to be improved to be able to travel using all devices available
	call IsPresent "Explorer's Globe of Norrath"
	
	if ${Return}
	{
		call MoveCloseTo "Explorer's Globe of Norrath"
		Actor[name,"Explorer's Globe of Norrath"]:DoubleClick
		wait 20
		oc !c -travel ${Me.Name} "${ZoneName}"
		call waitfor_Zone "${ZoneName}"
	}
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]} && !${Zone.Name.Left[${ZoneName.Length}].Equal["${ZoneName}"]})
		call goto_GH
}
function Boost()
{
; from THG snacks script
	oc !c -pause
	if ${Me.Inventory[Dolma](exists)}
	{
		Me.Inventory[Dolma]:Use
		wait 10
	}
	if ${Me.Inventory[Atole](exists)}
	{
		Me.Inventory[Atole]:Use
		wait 10
	}
	if ${Me.Inventory[Chebakia](exists)}
	{
		Me.Inventory[Chebakia]:Use
		wait 10
	}
	if ${Me.Inventory[Tejuino](exists)}
	{
		Me.Inventory[Tejuino]:Use
		wait 10
	}
	if ${Me.Inventory[Jaffa](exists)}
	{
		Me.Inventory[Jaffa]:Use
		wait 10
	}
	if ${Me.Inventory["Valorous Elixir of Intellect"](exists)}
	{
		Me.Inventory["Valorous Elixir of Intellect"]:Use
		wait 10
	}
	if ${Me.Inventory["Planar Elixir of Intellect"](exists)}
	{
		Me.Inventory["Planar Elixir of Intellect"]:Use
		wait 10
	}
	oc !c -resume
} 
function CastAbility(string AbilityName, bool NoWait)
{
	if (!${NoWait})
	{
		do
		{
			wait 20
		}
		while (!${Me.Ability["${AbilityName}"].IsReady})
	}
	call UseAbility "${AbilityName}"
}

function CastImmunity(string ToonName, int Health, int Pause)
{

	variable index:string ImmunityStack
	variable int i
	
	ImmunityStack:Insert["Battle Frenzy"]
	ImmunityStack:Insert["Wall of Force"]
	ImmunityStack:Insert["Perfect Counter"]
	ImmunityStack:Insert["Unyielding Will"]
	ImmunityStack:Insert["Tower of Stone"]
	ImmunityStack:Insert["Perfect Counter"]
	ImmunityStack:Insert["Last Man Standing"]
	ImmunityStack:Insert["Unyielding Will"]
	ImmunityStack:Insert["Bob and Weave"]
	ImmunityStack:Insert["Tsunami"]
	ImmunityStack:Insert["Superior Guard"]
	ImmunityStack:Insert["Inner Focus"]
	ImmunityStack:Insert["Brawler's Tenacity"]
	ImmunityStack:Insert["Stonewall"]
	ImmunityStack:Insert["Devout Sacrament"]
	ImmunityStack:Insert["Crusader's Faith"]
	ImmunityStack:Insert["Holy Warding"]
	ImmunityStack:Insert["Faith"]
	ImmunityStack:Insert["Lay on Hands"]
	ImmunityStack:Insert["Divine Aura"]
	ImmunityStack:Insert["Infuriating Thorns]
	ImmunityStack:Insert["Tortoise Shell"]
	ImmunityStack:Insert["Tunare's Watch"]
	ImmunityStack:Insert["Cyclone"]
	ImmunityStack:Insert["Nature's Renewal"]
	ImmunityStack:Insert["Tortoise Shell"]
	ImmunityStack:Insert["Feral Tenacity"]
	ImmunityStack:Insert["Ancestral Avenger"]
	ImmunityStack:Insert["Ancestral Savior"]
	ImmunityStack:Insert["Channeled Protection"]
	ImmunityStack:Insert["Holy Salvation"]
	ImmunityStack:Insert["Coercive Shout"]
	ImmunityStack:Insert["Bladedance"]
	
	for ( i:Set[1] ; ${i} <= ${ImmunityStack.Used} ; i:Inc )
	{
    	if (${Actor[${ToonName}].Health} < ${Health})
		{
			oc !c -CastAbilityOnPlayer All "${ImmunityStack[${i}]}" ${ToonName}
			wait $ {Math.Calc64[${Pause}*10]}
		}
	}

}
function check_quest(string questname)
{
	echo check_quest is deprecated and only preserved for backward compatibility. Please use CheckQuest instead.
	call CheckQuest "${questname}"
	return ${Return} 
}
function CheckAuraLoc(float X, float Z, float R, string AuraColor)
{
	variable index:actor Actors
    variable iterator ActorIterator
	variable int Counter
	
	EQ2:QueryActors[Actors, Aura=="${AuraColor}"]
    Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
    {
		do
		{
			if (${Math.Distance[${Actor[${ActorIterator.Value.ID}].Loc.X}, ${Actor[${ActorIterator.Value.ID}].Loc.Z}, ${X}, ${Z}]}<${R})
				Counter:Inc
		}
		while (${ActorIterator:Next(exists)})
	}
	if ${Counter}>0
		return FALSE
	else
		return TRUE
}
function CheckCombat(int MyDistance)
{
	echo Debug: in function CheckCombat
	variable bool WasHarvesting
	if (${MyDistance}<1)
		MyDistance:Set[30]
	
	if (${Me.InCombatMode})
	{
		OgreBotAPI:NoTarget[${Me.Name}]
		if ${Script["Buffer:OgreHarvestLite"](exists)}
		{
			ogre end harvestlite
			WasHarvesting:Set[TRUE]
		}
		if ${Me.FlyingUsingMount}
		{	
			echo FLYING
			call GoDown
			wait 20
		}
		if ${Me.FlyingUsingMount}
		{	
			do
			{
				echo FLYING : MOVING

				press -hold MOVEFORWARD
				wait 1
				press -release MOVEFORWARD
				call GoDown
				wait 5
			}
			while (${Me.FlyingUsingMount})
		}
		if ${AntiKB}
			oc !c -CampSpot ${Me.Name}
		do
		{	
			wait 5
			if (${MercMan})
			{
				if (!${Target(exists)})
				{
					eq2execute merc backoff
				}
			}
			if (${Target.Distance} > ${MyDistance})
			{
				if (${MercMan})
				{
					eq2execute merc backoff
					eq2execute pet backoff
				}
				press -hold MOVEFORWARD
				if ${AntiKB}
					oc !c -letsgo ${Me.Name}
			}	
			else
			{
				press -release MOVEFORWARD
			}
			if ${AntiKB}
				oc !c -CampSpot ${Me.Name}
			if (${MercMan})
			{
				eq2execute merc ranged
				eq2execute pet attack
			}	
		}
		while (${Me.InCombatMode})
	}
	if ${WasHarvesting}
		ogre harvestlite
	if ${AntiKB}
		oc !c -letsgo ${Me.Name}
	
}
function CheckDetriment(string EffectName)
{
	;on me only
    variable index:effect MyEffects
    variable iterator MyEffectsIterator
    
    Me:RequestEffectsInfo
    
    Me:QueryEffects[MyEffects, Type == "Detrimental", Name == "${EffectName}"]
    MyEffects:GetIterator[MyEffectsIterator]
 
    if ${MyEffectsIterator:First(exists)}
		return TRUE
	else
		return FALSE
}
function CheckEffectOnTarget(string EffectName)
{
	variable int Counter = 1
	variable int NumActorEffects = 0
	if (${Target(exists)})
    {
		
		Target:RequestEffectsInfo
		wait 10
		Target:RequestEffectsInfo
		NumActorEffects:Set[${Target.NumEffects}]  
		 if (${NumActorEffects} > 0)
        {
            do
            {
				if (${Target.Effect[${Counter}].ToEffectInfo.Name.Equal["${EffectName}"]})
				{
					return TRUE
				}
            }
            while (${Counter:Inc} <= ${NumActorEffects})
		}
    }  	
	return FALSE
}
function CheckFlyingZone()
{
	variable bool Flying
	call CheckCombat 30
	press -hold FLYUP
	wait 20
	press -release FLYUP
	if ${Me.FlyingUsingMount}
		Flying:Set[TRUE]
 	else
		Flying:Set[FALSE]
	call GoDown
	return ${Flying}
}
function CheckIfActorGuildPresent(string ActorGuild, float MaxDistance)
{
	variable index:actor Actors
    variable iterator ActorIterator
    
    EQ2:QueryActors[Actors, Guild =- "${ActorGuild}" && Distance <= ${MaxDistance} ]
    Actors:GetIterator[ActorIterator]
  
    if ${ActorIterator:First(exists)}
        return TRUE
    else
		return FALSE
}
function CheckItem(string ItemName, int Quantity)
{
	call CountItem "${ItemName}"
	if (${Return}<${Quantity})
	{
		echo "There is not enough ${ItemName} in inventory (${Return}/${Quantity})"
		echo "You need ${Math.Calc64[${Quantity}-${Return}]} ${ItemName} more to continue"
		return 1
	}
	else
	{
		return 0
	}
}
function CheckQuest(string questname)
{
	variable index:quest Quests
	variable iterator It
	variable int NumQuests

	NumQuests:Set[${QuestJournalWindow.NumActiveQuests}]
    
	if (${NumQuests} < 1)
	{
		echo "No active quests found."
		return FALSE
	}
	QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
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
function CheckS()
{
	variable index:ability MyAbilities
    variable iterator MyAbilitiesIterator
    variable int Timer = 0
	Me:QueryAbilities[MyAbilities, ID =- "4094834160" || ID =- "3812013292"]
    MyAbilities:GetIterator[MyAbilitiesIterator]
	if ${MyAbilitiesIterator:First(exists)}
    {
        do
        {
            if (!${MyAbilitiesIterator.Value.IsAbilityInfoAvailable})
            {
                do
                {
                    wait 2
                }
                while (!${MyAbilitiesIterator.Value.IsAbilityInfoAvailable} && ${Timer:Inc} < 1500)
            }
    
            return ${MyAbilitiesIterator.Value.IsReady}
            Timer:Set[0]
        }
        while ${MyAbilitiesIterator:Next(exists)}
    }
	else
        return FALSE
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
function CheckXZStuck(float loc)
{
	variable float loc0=${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Z} * ${Me.Loc.Z}]}
	if (${loc}==${loc0})
	{
		return TRUE
	}
	else
	{
		return FALSE
	}
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
function CheckWalking()
{

			if (${Math.Calc64[${Me.Velocity.X} * ${Me.Velocity.X} + ${Me.Velocity.Y} * ${Me.Velocity.Y} + ${Me.Velocity.Z} * ${Me.Velocity.Z} ]}>100)
				return FALSE
			else
				return TRUE
}
function CheckZone(string ZoneName, bool Partial)
{
	if (!${Partial})
	{
		if (${Zone.Name.Equal["${ZoneName}"]})
			return TRUE
		else
			return FALSE
	}
	else
	{
		if (${Zone.Name.Left[${ZoneName.Length}].Equal["${ZoneName}"]})
			return TRUE
		else
			return FALSE
	}
	
	
}
function ClickOn(string ActorName)
{
	variable index:actor Actors
	variable iterator ActorIterator
	
	EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= 10]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		echo click on ${ActorIterator.Value.Name}
		Actor[name,"${ActorIterator.Value.Name}"]:DoubleClick
	}
}
function ClickZone(int startX, int startY, int stopX, int stopY, int step)
{
	variable int X
	variable int Y
	
	X:Set[${startX}]
	Y:Set[${startY}]
	do
	{
		echo clicking at ${X},${Y}
		MouseTo ${X},${Y}
		Mouse:LeftClick
		Mouse:LeftClick
		if (${X}>${stopX})
		{
			X:Set[${startX}]
			Y:Set[${Math.Calc[${Y}+${step}]}]
		}
		X:Set[${Math.Calc[${X}+${step}]}]
		wait 5
	}
	while (${Y}<${stopY})
	echo End of ClickZone
}
function CloseCombat(string Named, float Distance, bool MoveIn)
{
	echo CloseCombat with ${Named} ${Distance} (${MoveIn})
	call IsPresent "${Named}" ${Distance}
	if (${Return} && ${Actor["${Named}"].IsAggro})
	{
		face "${Named}"
		target "${Named}"
		if ${MoveIn}
			call MoveCloseTo "${Named}"
		eq2execute merc attack
	}
}
function CMove(float X, float Z)
{
	echo entering CMove ${X} ${Z} 
	face ${X} ${Z}
	press -hold MOVEFORWARD
	do
	{	
		wait 10
		face ${X} ${Z}
		call TestArrivalCoord ${X} 0 ${Z} 10 TRUE
	}
	while (!${Return})
	press -release MOVEFORWARD
	echo exiting CMove ${X} ${Z} 
} 
function Converse(string NPCName, int bubbles, bool giant, bool OgreQH)
{
	echo Conversing with ${NPCName} (${bubbles} bubbles to validate)
	if (${giant})
	{
		echo ${NPCName} is really a big fellow
		press CENTER
		call PKey MOVEBACKWARD 5
		call PKey "Page Up" 3
		call PKey ZOOMOUT 20		
	}
	target "${NPCName}"
	eq2execute hail "${NPCName}"
	
	wait 10
	variable int x
   	for ( x:Set[0] ; ${x} <= ${bubbles} ; x:Inc )
	{
		if (!${OgreQH})
		{
			OgreBotAPI:ConversationBubble["${Me.Name}",1]
			RIMUIObj:HailOption["${Me.Name}",1]
		}	
		wait 15
	}
	if (${giant})
	{
		call PKey "Page Down" 3		
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
	press CENTER
}
function CountAdds(string ActorName, int Distance, bool Exact)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	
	if (${Distance}<1)
		Distance:Set[200]
	
	if (${Exact})
		EQ2:QueryActors[Actors, Name  == "${ActorName}" && Distance <= ${Distance}]
	else
		EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= ${Distance}]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			Count:Inc	
		}	
		while ${ActorIterator:Next(exists)}
	}
	echo There is ${Count} ${ActorName} in a ${Distance}m radius
	return ${Count}
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
				Counter:Set[${Math.Calc64[${Counter}+${ItemIterator.Value.Quantity}]}]
			}	
			while ${ItemIterator:Next(exists)}
		}
	echo found ${Counter} ${ItemName} in Inventory !
	return ${Counter}
}
function CoVMender()
{
	if (${Zone.Name.Equal["Coliseum of Valor"]})
	{
		call DMove -2 5 4 3
		call DMove 107 0 2 3
		call DMove 158 0 64 3
		OgreBotAPI:RepairGear[${Me.Name}]
		wait 20
		OgreBotAPI:RepairGear[${Me.Name}]
		wait 20
		call DMove 107 0 2 3
		call DMove -2 5 4 3
	}
}
function CSGo(string Who, float X, float Y, float Z)
{
	oc !c -CS_Set_ChangeCampSpotBy ${Who} ${Math.Calc64[${X}-${Me.X}]} ${Math.Calc64[${Y}-${Me.Y}]} ${Math.Calc64[${Z}-${Me.Z}]}
	
}
function CureArchetype(string Archetype)
{
	;variable int Counter=0
	variable int i
	for ( i:Set[0] ; ${i} < ${Me.GroupCount} ; i:Inc )
	{
		echo getting Archetype for ${Me.Group[${i}].Class}
		call get_Archetype "${Me.Group[${i}].Class}"
		echo it's ${Return}
		if (${Return.Equal[${Archetype}]})
			oc !c -CastAbilityOnPlayer Priest Cure ${Me.Group[${i}].Name}
	}		
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
function DepositAll(string DepotName)
{
	Actor[Name,"${DepotName}"]:DoubleClick
	wait 10
	EQ2UIPage[Inventory,Container].Child[button,Container.TabPages.Items.CommandDepositAll]:LeftClick
	wait 10
	EQ2UIPage[Inventory,Container].Child[button,Container.WindowFrame.Close]:LeftClick
}
function DescribeActor(int ActorID)
{
	echo ID:				${ActorID}
	echo Name:				${Actor[${ActorID}].Name}
	echo LastName:			${Actor[${ActorID}].LastName}
	echo Health:			${Actor[${ActorID}].Health}
	echo Power:				${Actor[${ActorID}].Power}
	echo Level:				${Actor[${ActorID}].Level}
	echo EffectiveLevel:	${Actor[${ActorID}].EffectiveLevel}
	echo TintFlags:			${Actor[${ActorID}].TintFlags}
	echo VisualVariant:		${Actor[${ActorID}].VisualVariant}
	echo Mood:				${Actor[${ActorID}].Mood}
	echo CurrentAnimation:	${Actor[${ActorID}].CurrentAnimation}
	echo Overlay:			${Actor[${ActorID}].Overlay}
	echo Aura:				${Actor[${ActorID}].Aura}
	echo Gender:			${Actor[${ActorID}].Gender}
	echo Race:				${Actor[${ActorID}].Race}
	echo Class:				${Actor[${ActorID}].Class}
	echo Guild:				${Actor[${ActorID}].Guild}
	echo Type:				${Actor[${ActorID}].Type}
	echo SuffixTitle:		${Actor[${ActorID}].SuffixTitle}
	echo ConColor:			${Actor[${ActorID}].ConColor}
	echo Distance: 			${Actor[${ActorID}].Distance}
	echo X					${Actor[${ActorID}].Loc.X}
	echo Y					${Actor[${ActorID}].Loc.Y}
	echo Z					${Actor[${ActorID}].Loc.Z}
}

function DescribeItemInventory(string ItemName)
{
	call DescribeItem "${ItemName}" "Inventory"
}
function DescribeItem(string ItemName, string ItemLocation)
{
    variable index:item Items
    variable iterator ItemIterator
    variable int Counter = 1
    
    Me:QueryInventory[Items, Location =- "${ItemLocation}" && Name =- "${ItemName}"]
    Items:GetIterator[ItemIterator]
 
 
    if ${ItemIterator:First(exists)}
    {
        do
        {
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            ;; This routine is echoing the item "Description", so we must ensure that the iteminfo 
            ;; datatype is available.
            if (!${ItemIterator.Value.IsItemInfoAvailable})
            {
                ;; When you check to see if "IsItemInfoAvailable", ISXEQ2 checks to see if it's already
                ;; cached (and immediately returns true if so).  Otherwise, it spawns a new thread 
                ;; to request the details from the server.   
                do
                {
                    waitframe
                    ;; It is OK to use waitframe here because the "IsItemInfoAvailable" will simply return
                    ;; FALSE while the details acquisition thread is still running.   In other words, it 
                    ;; will not spam the server, or anything like that.
                }
                while (!${ItemIterator.Value.IsItemInfoAvailable})
            }
            ;;
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            ;; At this point, the "ToItemInfo" MEMBER of this object will be immediately available.  It should
            ;; remain available until the cache is cleared/reset (which is not very often.)
            echo "${Counter}. ${ItemIterator.Value.Name} : Index : '${ItemIterator.Value.Index}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : ID : '${ItemIterator.Value.ID}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : SerialNumber : '${ItemIterator.Value.SerialNumber}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : Name : '${ItemIterator.Value.Name}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : Location : '${ItemIterator.Value.Location}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : ToLink : '${ItemIterator.Value.ToLink}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : LinkID : '${ItemIterator.Value.LinkID}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IconID : '${ItemIterator.Value.IconID}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : Quantity : '${ItemIterator.Value.Quantity}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : EffectiveLevel : '${ItemIterator.Value.EffectiveLevel}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : Slot : '${ItemIterator.Value.Slot}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsReady : '${ItemIterator.Value.IsReady}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : TimeUntilReady : '${ItemIterator.Value.TimeUntilReady}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : InInventorySlot : '${ItemIterator.Value.InInventorySlot}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsInventoryContainer : '${ItemIterator.Value.IsInventoryContainer}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsBankConatainer : '${ItemIterator.Value.IsBankContainer}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsSharedBankContainer : '${ItemIterator.Value.IsSharedBankContainer}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsAutoConsumeable : '${ItemIterator.Value.IsAutoConsumeable}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : AutoConsumeOn : '${ItemIterator.Value.AutoConsumeOn}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : CanBeRedeemed : '${ItemIterator.Value.CanBeRedeemed}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsFoodOrDrink : '${ItemIterator.Value.IsFoodOrDrink}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsScribeable : '${ItemIterator.Value.IsScribeable}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsUsable : '${ItemIterator.Value.IsUsable}'"
	    echo "${Counter}. ${ItemIterator.Value.Name} : IsAgent : '${ItemIterator.Value.IsAgent}'"
	   ;echo "${Counter}. ${ItemIterator.Value.Name} : IsOverseerQuest : '${ItemIterator.Value.IsOverseerQuest}'"
            Counter:Inc
        }
        while ${ItemIterator:Next(exists)}
    }
    else
	echo no item "${ItemName}" in Inventory
}
function DetectCircles(float Distance, string Color)
{ 
	variable index:actor Actors
    variable iterator ActorIterator
	variable int Counter
	;echo in DetectCircles
    if (${Distance}<1)
		Distance:Set[10]
    EQ2:QueryActors[Actors, Distance <= ${Distance}]
    Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
    {       
		do
		{
			if (${Actor[${ActorIterator.Value.ID}].Aura.Equal[${Color}]})
			;if (${ActorIterator.Value.Name.Equal[""]} && ${ActorIterator.Value.Distance}<${Distance})
			{
				;echo ${Actor[${ActorIterator.Value.ID}].Aura.Equal[${Color}]} (${ActorIterator.Value.ID}) spotted
				Counter:Inc
			}
		}
        while (${ActorIterator:Next(exists)})
	}
	return ${Counter}
	;echo out DetectCircles
}
function Dist(float X1, float Y1, float Z1, float X2, float Y2, float Z2)
{
	return ${Math.Distance[${X1},${Y1},${Z1},${X2},${Y2},${Z2}]}
}
function DMove(float X, float Y, float Z, int speed, int MyDistance, bool IgnoreFight, bool StuckZone, int Precision)
{
	variable float loc0
	variable int Stucky
	variable int SuperStucky=0
	variable bool LR
	
	if ${Precision}<1
		Precision:Set[10]
	
	eq2execute waypoint ${X}, ${Y}, ${Z}
	
	call TestNullCoord ${X} ${Y} ${Z} ${Precision}
	if (!${Return})
		call TestArrivalCoord ${X} ${Y} ${Z} ${Precision}
	
	if (!${Return})
	{
		do
		{
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			if (!${IgnoreFight})
			{
				call waitfor_Health 90
				call CheckCombat ${MyDistance}
			}
			if (${speed} < 2)
			{
				call Go2D ${X} ${Y} ${Z} ${Precision}
			}
			if (${speed} == 2)
				call 2DNav ${X} ${Z} ${IgnoreFight} TRUE ${Precision}
			if (${speed} > 2)
				call 2DNav ${X} ${Z} ${IgnoreFight} FALSE ${Precision}
			call CheckStuck ${loc0}
			if (${Return})
			{
				Stucky:Inc
				SuperStucky:Inc
				echo DMove:Stucky=${Stucky} / ${SuperStucky}
			}
			if (${Stucky}>1)
			{
				call ClickOn Door
			}
			if (${Stucky}>2)
			{
				call Unstuck ${LR}
				LR:Set[${Return}]
				Stucky:Set[0]
			}
			call TestArrivalCoord ${X} ${Y} ${Z} ${Precision}
			echo in DMove !${Return} && ${SuperStucky}<100 && !${StuckZone}
		}
		while (!${Return} && ${SuperStucky}<100 && !${StuckZone})
	}
	if (!${IgnoreFight})
		call WaitforGroupDistance 30
	return ${SuperStucky}
}
function EndZone()
{
	variable string sQN
	call strip_QN "${Zone.Name}"
	sQN:Set[${Return}]
	if ${Script[${sQN}](exists)}
		endscript ${sQN}
	press -release MOVEFORWARD
	echo Clearing of zone "${Zone.Name}" is ended
}
function Evac()
{
	echo debugging Evac I am ${Me.Class}/${Me.Archetype}
	switch ${Me.Archetype}
	{
		case scout
			echo debug: in scout case
			Me.Ability["Escape"]:Use
		break
		case priest
			echo debug: in priest case
			switch ${Me.Class}
			{
				case druid
					echo debug: in druid case
					Call UseAbility "Verdurous Journey"
				break
				
					echo debug: in default case
					Me.Inventory["Totem of Escape"]:Use
				break
			}
		break
		default
			echo debug: in default case
			Me.Inventory["Totem of Escape"]:Use
		break
	}
}
function FindLoS(string ActorName, string KeytoPress, float Distance, int PressTime)
{
	if (${PressTime}<5)
		PressTime:Set[5]
	if (${Distance}<1)
		Distance:Set[20]
	do
	{
		face ${Actor["${ActorName}"].X} ${Actor["${ActorName}"].Z}
		if (!${Actor["${ActorName}"].CheckCollision})
		{
			echo found LoS against ${ActorName}
		}
		else
		{
			call PKey "${KeytoPress}" ${PressTime}
		}
		wait 5
	}
	while (${Actor["${ActorName}"].CheckCollision} && ${Actor["${ActorName}"].Distance} < ${Distance})
}
function Follow2D(string ActorName,float X, float Y, float Z, float RespectDistance, bool Walk)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable bool Vanished
	
	EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= 50]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			if  (${ActorIterator.Value.Distance}> ${RespectDistance})
				call 2DNav ${ActorIterator.Value.X} ${ActorIterator.Value.Z} ${Walk}
			wait 5
			call IsPresent "${ActorName}" 50
			Vanished:Set[!${Return}]
			call TestArrivalCoord ${X} ${Y} ${Z}
		}	
		while (!${Return} && !${Vanished} )
	}
}
function Gardener()
{
   variable string MerchantName
   MerchantName:Set["Turns Looted Fertilizer into Shines"]
   if !${Actor["${MerchantName}"](exists)}
   {
      echo ${Time}: ${MerchantName} not found.
      Script:End
   }
   if ${Actor["${MerchantName}"].Distance} > 20
   {
      echo ${Time}: ${MerchantName} too far away ( ${Actor["${MerchantName}"].Distance} ) > 20.
      Script:End
   }
   else
   {
   Actor["${MerchantName}"]:DoFace
   }

   ;// Make sure we have at least ONE inventory slot available.
   if ${Me.InventorySlotsFree} <= 0
   {
      echo ${Time}: You don't have any inventory slots free! You need at least 1 free slot to continue.
      Script:End
   }
   
   ;// We we create a loop to buy. It's possible we will only loop once, or we may have to loop more than once.
   ;// Create a variable, we can stop looping.
   variable int toCollect=0
   toCollect:Set[${Me.InventorySlotsFree}]
   variable int Collected=0
	
   
   ;// Loop as long as we're not suppose to stop (StopLooping) and as long as there are more bags to buy.
   while ${Collected} <= ${toCollect}
   {
      ;// Target the merchant.
      Actor["${MerchantName}"]:DoTarget
      Actor["${MerchantName}"]:DoubleClick
      wait 5
      EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
      variable int RandomDelay
      RandomDelay:Set[ ${Math.Rand[3]} ]
      RandomDelay:Inc[5]
      wait ${RandomDelay}
      Collected:Inc[1]
   }
}
function getChest(string ChestName, bool NoRetry)
{
	echo in function getChest ${ChestName} ${NoRetry}
	call IsPresent "${ChestName}" 30
	if (${Return})
	{
		do
		{
			call GetObject "${ChestName}" Open 20
			wait 20
			oc !c -UplinkOptionChange All checkbox_settings_loot TOGGLE
			oc !c -ofol---
			oc !c -ofol---
			oc !c -ofol---
			wait 50
			oc !c -OgreFollow All ${Me.Name}
			oc !c -UplinkOptionChange All checkbox_settings_loot TOGGLE
			call IsPresent "${ChestName}" 30
		}
		while (${Return} && !${NoRetry})
	}
}		
function GetEffectIncrement(string EffectName)
{
    variable int Counter = 1
    variable int NumActorEffects = 0
  
    Me:RequestEffectsInfo
    if (${Target(exists)})
        Target:RequestEffectsInfo
    if (${Target(exists)})
    {
        NumActorEffects:Set[${Target.NumEffects}]   
        if (${NumActorEffects} > 0)
        {
            do
            {
				if (${Target.Effect[${Counter}].ToEffectInfo.Name.Equal["${EffectName}"]})
				{
					return ${Target.Effect[${Counter}].CurrentIncrements}
				}
            }
            while (${Counter:Inc} <= ${NumActorEffects})
        }
        else
        {
			return 0
		}
    }
    else
	{
	   echo exiting GetEffectIncrement
	   return 0
	}
}
function GetObject(string ObjectName, string ObjectVerb, int Distance)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	
	if (${Distance}<1)
		Distance:Set[100]
	
	EQ2:QueryActors[Actors, Name  =- "${ObjectName}" && Distance <= ${Distance}]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			Count:Inc	
		}	
		while ${ActorIterator:Next(exists)}
	}
	
	echo "There is ${Count} ${ObjectName}"
	if ${ActorIterator:First(exists)}
	{
		echo get the ${ObjectName} at ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
		call DMove ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} 3 30 TRUE
		face ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
		call ActivateVerb "${ObjectName}" ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} "${ObjectVerb}" TRUE
	}	
}
function get_Archetype(string ToonClass)
{
	switch ${ToonClass}
	{
		case warrior
		{
			return fighter
			break
		}
		case berserker
		{
			return fighter
			break
		}
		case guardian
		{
			return fighter
			break
		}
		case paladin
		{
			return fighter
			break
		}
		case shadowknight
		{
			return fighter
			break
		}
		case monk
		{
			return fighter
			break
		}
		case bruiser
		{
			return fighter
			break
		}
		case warden
		{
			return priest
			break
		}
		case mystic
		{
			return priest
			break
		}
		case defiler
		{
			return priest
			break
		}
		case fury
		{
			return priest
			break
		}
		case templar
		{
			return priest
			break
		}
		case inquisitor
		{
			return priest
			break
		}
		case conjuror
		{
			return mage
			break
		}
		case necromancer
		{
			return mage
			break
		}
		case warlock
		{
			return mage
			break
		}
		case wizard
		{
			return mage
			break
		}
		case illusionist
		{
			return mage
			break
		}
		case coercer
		{
			return mage
			break
		}
		Default
		{
			return scout
			break
		}	
	}
}
function get_Potency()
{
	echo checking potency
	variable int64 MyPotency
	variable string sMyPotency=${Me.GetGameData[Stats.Potency].Label}
	sMyPotency:Set[${sMyPotency.Replace[",",""]}]
	sMyPotency:Set[${sMyPotency.Replace["%",""].Left[6]}]
	sMyPotency:Set[${sMyPotency.Replace[".",""]}]
	MyPotency:Set[${sMyPotency}]
	return ${MyPotency}
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

function Go2D(float X, float Y, float Z, int Precision, bool Icy)
{
	variable float loc0 
	variable int Stucky
	variable bool There
	variable string strafe
	echo enter function Go2D
	if (((${X} < ${Me.X}) && (${Z} < ${Me.Z})) || ((${X} > ${Me.X}) && (${Z} > ${Me.Z})))
		strafe:Set["STRAFERIGHT"]
	else
		strafe:Set["STRAFELEFT"]
	
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
			wait 1
			press -release MOVEFORWARD
			wait 1
			press -hold MOVEFORWARD
			wait 1
			press -release MOVEFORWARD
			call CheckStuck ${loc0}
			if (${Return})
				Stucky:Inc
			echo Stucky=${Stucky}
			call TestArrivalCoord ${X} ${Y} ${Z} ${Precision}
			There:Set[${Return}]
		}
		while (${Stucky}<10 && !${There})
		if (!${There})
		{
			face ${X} ${Z}
			press -hold ${strafe}
			wait 5
			press -release ${strafe}
		}		
		call TestArrivalCoord ${X} ${Y} ${Z} ${Precision}
	}
	while (!${Return})
	if (${Icy})
		press JUMP
	echo exit function go2D
}
function GoDown()
{
	variable float loc0=0
	echo "Going Down : 5 5 5"
	if (${Me.FlyingUsingMount})
	{
		do
		{
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			press -hold FLYDOWN
			wait 5
			call CheckStuck ${loc0}
		}
		while (${Me.FlyingUsingMount} && !${Return})
		press -release FLYDOWN
	}
	wait 10
	echo "I am down or stuck"
}
function goHate()
{	
	if (${Zone.Name.Right[10].Equal["Guild Hall"]})
	{
		call IsPresent "Mechanical Travel Gear"
		if (${Return})
		{
			call MoveCloseTo "Mechanical Travel Gear"
			wait 20
			OgreBotAPI:ApplyVerbForWho["${Me.Name}","Mechanical Travel Gear","Travel to the Planes"]
			wait 20
			OgreBotAPI:ZoneDoorForWho["${Me.Name}",1]
			call waitfor_Zone "Coliseum of Valor"
		}
		call IsPresent "Large Ulteran Spire"
		if (${Return})
		{
			call MoveCloseTo "Large Ulteran Spire"
			wait 20
			OgreBotAPI:ApplyVerbForWho["${Me.Name}","Large Ulteran Spire","Voyage Through Norrath"]
			wait 50
			OgreBotAPI:Travel["${Me.Name}", "Plane of Magic"]
			wait 600
		}
	}
	if (${Zone.Name.Left[14].Equal["Plane of Magic"]})
	{
		;call ActivateVerb "zone_to_pov" -785 345 1116 "Enter the Coliseum of Valor"
		;call DMove -2 5 4 3
	}
	if (${Zone.Name.Left[17].Equal["Coliseum of Valor"]})
	{
		call DMove -2 5 4 3
		call ExitCoV
		call goHate
	}
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]} && !${Zone.Name.Left[14].Equal["Plane of Magic"]} && !${Zone.Name.Equal["Coliseum of Valor"]})
	{
		call goto_GH
		wait 600
		call goHate
	}
	call waitfor_Zone "Plane of Magic"
}

function goZone(string ZoneName)
{
	echo Going to Zone: ${ZoneName} (inside goZone in tools)
	if (${Zone.Name.Right[10].Equal["Guild Hall"]})
	{
		call ActivateSpire
		wait 30
		OgreBotAPI:Travel["${Me.Name}", "${ZoneName}"]
		;wait 50
		;RIMUIObj:TravelMap["${Me.Name}","${ZoneName}",1,2]
		wait 300
	}
	
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]} && !${Zone.Name.Left[25].Equal["${ZoneName}"]})
	{
		call goto_GH
		wait 300
		call goZone "${ZoneName}"
	}
	if (!${Zone.Name.Left[25].Equal["${ZoneName}"]})
		call goZone "${ZoneName}"
}
function goto_GH()
{
	variable int Counter=0
	call GoDown
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]})
	{
		call IsPresent "Magic Door to the Guild Hall"
		if (${Return})
		{
			call MoveCloseTo "Magic Door to the Guild Hall"
			call ActivateVerbOn "Magic Door to the Guild Hall" "Go to Guild Hall"				
		}
		else
			call CastAbility "Call to Guild Hall"
		do
		{
			wait 10
			Counter:Inc
		}
		while (!${Zone.Name.Right[10].Equal["Guild Hall"]} && ${Counter}<300)
		if (!${Zone.Name.Right[10].Equal["Guild Hall"]})
			call goto_GH
	}
}
function goto_House()
{
	echo Going to ${Me.Name}'s first House
	Actor[name,"Portal to Housing"]:DoubleClick
	wait 20
	EQ2UIPage[_HUD,omnihouse].Child[composite,_HUD.omnihouse].Child[4].Child[5].Child[7]:SetProperty[text,""]
	EQ2UIPage[_HUD,omnihouse].Child[composite,_HUD.omnihouse].Child[4].Child[5].Child[7]:AppendText[${Me.Name}]
	wait 100
	EQ2UIPage[_HUD,omnihouse].Child[composite,_HUD.omnihouse].Child[4].Child[5].Child[8]:LeftClick
}
function GuildH(bool NoPlant)
{
	if ${Zone.Name.Right[10].Equal["Guild Hall"]}
	{
		echo Starting GH churns
		wait 100
		if (!${NoPlant})
			call AutoPlant
		wait 100
		echo Repair
		OgreBotAPI:RepairGear[${Me.Name}]
		RIMUIObj:Repair[${Me.Name}]
		wait 100
		call TransmuteAll "Planar Transmutation Stone"
		call TransmuteAll "Celestial Transmutation Stone"
		call TransmuteAll "Veilwalker's Transmutation Stone"
		echo First Depot
		ogre im -Depot
		wait 600
		ogre end im
		wait 20
		ogre im -restock
		wait 150
		ogre end im
		call ActivateVerbOn "Altar of the Ancients" "Channel Arcanna'se" TRUE
		call ActivateVerbOn "Arcanna'se Effigy of Rebirth" "Channel Arcanna'se" TRUE
		echo GH churns finished
	}
	else
	{
		call goto_GH
		wait 600
		call GuildH
	}
}
function GuildHarvest()
{
	if ${Zone.Name.Right[10].Equal["Guild Hall"]}
	{
		echo getting harvest and harvest quests
	
		call Converse Gatherer 3
		call Converse Hunter 3
		call Converse Miner 3
	}
}
function GroupDistance(bool Debug)
{
	variable int MaxDistance=0
	variable int i
	for ( i:Set[0] ; ${i} < ${Me.GroupCount} ; i:Inc )
	{
		if (${Debug})
		{
			echo ${i}: ${Me.Group[${i}].Name} ${Me.Group[${i}].Distance}/${MaxDistance}
		}
		if (${Me.Group[${i}].Distance}>${MaxDistance})
			MaxDistance:Set[${Me.Group[${i}].Distance}]
	}
	if (${Debug})
		echo Calculated Max Distance is ${MaxDistance}
	return ${MaxDistance}
}
function Harvest(string ItemName, float Distance, int speed, bool is2D, bool GoBack)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	variable int Counter=0
	variable float X0
	variable float Y0
	variable float Z0
	variable bool HasMoved
	if (${Distance}<1)
		Distance:Set[100]
	if (${speed}<1)
		speed:Set[1]
	echo entering Harvest function ${ItemName} ${Distance} ${speed} ${is2D} ${GoBack}
	EQ2:QueryActors[Actors, Name  =- "${ItemName}" && Distance <= ${Distance}]
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
				HasMoved:Set[FALSE]
				if (${ActorIterator.Value.X(exists)})
				{
					eq2execute waypoint ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
					echo Harvest: going to ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
					if (${GoBack})
					{
						X0:Set[${Me.Loc.X}]
						Y0:Set[${Me.Loc.Y}]
						Z0:Set[${Me.Loc.Z}]
					}
					if (!${is2D})
					{
						echo moving in 3D
						call 3DNav ${ActorIterator.Value.X} ${Math.Calc64[${ActorIterator.Value.Y}+200]} ${ActorIterator.Value.Z}
						wait 10
						call GoDown
					}
					else
					{
						echo moving in 2D
						if (!${Actor["${ActorIterator.Value.Name}"].CheckCollision})
						{
							HasMoved:Set[TRUE]
							call DMove ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} 3 15 FALSE TRUE 5
							wait 10
						}
					}	
					eq2execute loc
					if (${HasMoved} || !${is2D})
					{
						wait 20
						if (${ActorIterator.Value.Distance}<15 && !${Actor["${ActorIterator.Value.Name}"].CheckCollision})
							call DMove ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z}  3 15 TRUE TRUE 5
						wait 50
						ogre harvestlite
						echo trying to harvest ${ItemName}
						wait 50
					}	
					if (${GoBack} && ${HasMoved} )
					{
						echo going back
						if (!${is2D})
						{
							call 3DNav ${X0} ${Math.Calc64[${Y0}+200]} ${Z0}
							wait 10
							call GoDown
						}
						else
						{
							call DMove ${X0} ${Y0} ${Z0} ${speed} 15 FALSE TRUE
							wait 10
						}
					}
				}
				Counter:Inc
				echo Counter in Harvest : ${Counter}
			}
			while (${ActorIterator:Next(exists)})
		}		
	}
	echo exiting Harvest function
}
function HarvestLite(string ItemName, int Quantity, float Distance, int speed, bool is2D)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	variable int Counter=0
	if (${Distance}<1)
		Distance:Set[100]
	if (${speed}<1)
		speed:Set[3]
	echo entering HarvestLite function ${ItemName} ${Quantity} ${Distance} 
	EQ2:QueryActors[Actors, Name  =- "${ItemName}" && Distance <= ${Distance}]
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
				if (${ActorIterator.Value.X(exists)})
				{
					eq2execute waypoint ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
					echo Harvest: going to ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
					if (${Actor[name,${ActorIterator.Value.Name}].CheckCollision} && !${is2D})
					{
						echo moving in 3D
						call 3DNav ${ActorIterator.Value.X} ${Math.Calc64[${ActorIterator.Value.Y}+50]} ${ActorIterator.Value.Z}
						wait 10
						call GoDown
					}
					else
					{
						echo moving in 2D
						call DMove ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} ${speed} 15 FALSE TRUE 5
						wait 10
					}
						
					eq2execute loc
					ogre harvestlite
					echo trying to harvest ${ItemName}
					wait 50
						
				}
				Counter:Inc
				echo Counter in Harvest : ${Counter}
			}
			while (${ActorIterator:Next(exists)} && ${Counter}<${Quantity})
		}		
	}
	echo exiting Harvest function
}
function HarvestItem(string ItemName, int number, int speed, bool is2D)
{
    variable int Counter=0
	call HarvestLite "${ItemName}" ${number} 100 ${speed} ${is2D}
	call CountItem "${ItemName}"
	Counter:Set[${Return}]
	if (${Counter}>=${number})
		echo Found ${Counter} ${ItemName}/${number} in Inventory - Stop Harvesting
}
function Hunt(string ActorName, int distance, int number, bool nofly, bool IgnoreFight)
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
	if (!${IgnoreFight})
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","TRUE"]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			if (!${IgnoreFight})
				call waitfor_Health 90
			echo ${ActorIterator.Value.Name} found at ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
			if (!${nofly})
				call navwrap ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
			else
				call DMove ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z} 3 30 ${IgnoreFight}
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
	echo Found ${Counter}/${number} ${ItemName} in Inventory - Stop Hunting
	call StopHunt
}
function HurryUp(int Distance)
{
	variable int i
	for ( i:Set[0] ; ${i} < ${Me.GroupCount} ; i:Inc )
	{
		if (${Me.Group[${i}].Distance}>${Distance})
		{
			eq2execute tell ${Me.Group[${i}].Name} Hurry up please, we have things to do
			eq2execute merc backoff
			wait 50
			eq2execute merc ranged
		}
	}
}
function isExpert(string ZoneName)
{
	if ${ZoneName.Right[8].Equal[\[Heroic\]]}
		return FALSE
	if ${ZoneName.Right[8].Equal[\[Expert\]]}
		return TRUE
	if ${ZoneName.Right[13].Equal[\[ExpertEvent\]]}
		return TRUE
	if ${ZoneName.Right[13].Equal[\[EventHeroic\]]}
		return FALSE
	if ${ZoneName.Right[6].Equal[\[Solo\]]}
		return FALSE
}
function isGroupAlive()
{
	variable int Counter=0
	variable int i
	for ( i:Set[0] ; ${i} < ${Me.GroupCount} ; i:Inc )
	{
		if (${Me.Group[${i}].IsDead})
			Counter:Inc
	}	
	if (${Counter}>0)
		return FALSE
	else
		return TRUE
}
function isGroupDead()
{
	variable int Counter=0
	variable int i
	for ( i:Set[0] ; ${i} < ${Me.GroupCount} ; i:Inc )
	{
		if (${Me.Group[${i}].IsDead})
			Counter:Inc
	}	
	if (${Me.GroupCount}==${Counter})
		return TRUE
	else
		return FALSE
}
function isMobAround(float Distance)
{
	variable index:actor Mobs
	variable iterator MobIterator
	EQ2:QueryActors[Mobs, Type  =- "NPC" && Distance <= ${Distance}]
	Mobs:GetIterator[MobIterator]
	if ${MobIterator:First(exists)}
		return TRUE
	else
		return FALSE
}
function IsPresent(string ActorName, int Distance, bool Exact, bool ReturnName)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	variable string FullActorName

	if (${Distance}<1)
		Distance:Set[200]
	
	if (${Exact})
		EQ2:QueryActors[Actors, Name  == "${ActorName}" && Distance <= ${Distance}]
	else
		EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= ${Distance}]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			Count:Inc
			FullActorName:Set["${ActorIterator.Value.Name}"]
		}	
		while ${ActorIterator:Next(exists)}
	}
	if (${Count}>0)
	{
		if (${ReturnName})
			return ${FullActorName}
		else
			return TRUE
	}
	else
	{
		return FALSE
	}
}
function KBMove(string Who, float X, float Y, float Z, int speed, int MyDistance, bool IgnoreFight, bool StuckZone, int Precision)
{
	oc !c -CampSpot ${Who}
	oc !c -CS_Set_ChangeCampSpotBy ${Who} ${Math.Calc64[${X}-${Me.X}]} ${Math.Calc64[${Y}-${Me.Y}]} ${Math.Calc64[${Z}-${Me.Z}]}
	wait 50
	call CheckCombat ${MyDistance}
	oc !c -letsgo ${Who}
	call DMove ${X} ${Y} ${Z} ${speed} ${MyDistance} ${IgnoreFight} ${StuckZone} ${Precision}
}
function JoustOut(int ActorID, float Distance, bool IsGroup)
{
	variable float AvoidDistance
	variable float X0
	variable float Z0
	variable float X1
	variable float Z1
	variable float X2
	variable float Z2
	variable float Slope
	variable float JoustDistance
	
	echo calling function JoustOut with ActorID:${Actor[${ActorID}]} and Distance ${Distance} m
	if (${Distance}<1)
		AvoidDistance:Set[30]
	else
		AvoidDistance:Set[${Distance}]
	
	JoustDistance:Set[${Math.Calc64[${AvoidDistance}-${Actor[${ActorID}].Distance}]}]
	if (${JoustDistance}<0)
		Return
	
	X0:Set[${Me.Loc.X}]
	Z0:Set[${Me.Loc.Z}]
	X1:Set[${Math.Calc64[${Actor[${ActorID}].X}-${X0}]}]
	Z1:Set[${Math.Calc64[${Actor[${ActorID}].Z}-${Z0}]}]
	if (!${Z1}==0) 
	{
		Slope:Set[${Math.Calc64[${X1}/${Z1}]}]
		if (!(${Math.Calc64[${Slope}+1]}==0))
			Z2:Set[${Math.Calc64[(${JoustDistance}/(${Slope}+1))]}]
		else
			Z2:Set[1]
		X2:Set[${Math.Calc64[${Slope}*${Z2}]}]
	}
	else 
	{
		X2:Set[0]
		Z2:Set[${JoustDistance}]
	}
	if (${X1}>0)
		X2:Set[${Math.Calc64[(-1)*${X2}]}]
	if (${Y1}>0)
		Z2:Set[${Math.Calc64[(-1)*${Z2}]}]
		
	echo JoustOut function called : ${X0} ${Z0} ${X1} ${Z1} ${X2} ${Z2} ${Slope} ${JoustDistance}
	if (!${IsGroup})
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} ${X2} 0 ${Z2}
	else
		oc !c -CS_Set_ChangeCampSpotBy All ${X2} 0 ${Z2}
		
}
function logout_login(int secs)
{
	variable string ToonName
	ToonName:Set["${Me.Name}"]
	echo will now quit and reconnect ${ToonName} in ${secs} seconds
	eq2execute quit login
	wait ${Math.Calc[${secs}*10]}
	wait 600
	ogre ${ToonName}
	wait 600
}
function Loot(bool NoRetry)
{
	echo Autoloot Running now !
	wait 50
	call getChest "Exquisite Chest" ${NoRetry} 
	wait 10
	call getChest "Small Chest" ${NoRetry} 
	wait 10
	call getChest "Treasure Chest" ${NoRetry} 
	wait 10
	call getChest "Ornate Chest" ${NoRetry} 
	wait 10
	echo End of Autoloot
}
function MineTS()
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable string Verb
	
	EQ2:QueryActors[Actors, Name  =- "loose" && Distance <= 50]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		
			
		do
		{
			echo ${ActorIterator.Value.Name} [${ActorIterator.Value.ID}] (${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}) at ${ActorIterator.Value.Distance}m
			call DMove ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} 2 30 FALSE FALSE 5
			do
			{
				if  ${ActorIterator.Value.Name.Equal["loose rubble"]}
				{
					Me.Inventory["Sturdy Pick"]:Equip
					Verb:Set["Mine Rock"]
				}
				
				if  ${ActorIterator.Value.Name.Equal["loose dirt"]}
				{
					Me.Inventory["Sturdy Shovel"]:Equip
					Verb:Set["Clear Dirt"]
				}
				call ActivateVerbOn "${ActorIterator.Value.Name}" "${Verb}" TRUE
				wait 20
			}
			while (${ActorIterator.Value.ID(exists)})
		}
		while (${ActorIterator:Next(exists)})
	}
}
function Move(string ActorName, float X, float Y, float Z, bool is2D)
{
	eq2execute waypoint ${X} ${Y} ${Z}
	if (${Actor["${ActorName}"].Distance} < 20 && ${Actor["${ActorName}"].Distance(exists)} && !${Actor["${ActorName}"].CheckCollision})
		call MoveCloseTo "${ActorName}"
	else
	{
			call TestArrivalCoord ${X} ${Y} ${Z}
			if (!${Return})
				call MoveTo "${ActorName}" ${X} ${Y} ${Z} ${is2D} 
			else
				echo I am there but does ${ActorName} exist here ?
	}
	wait 10
}
function MoveCloseTo(string ActorName, float Distance)
{
	variable float loc0=0
	variable int Stucky=0
	variable string strafe
	if (${Distance}<1)
		Distance:Set[5]
	echo Moving closer to ${Actor["${ActorName}"].Name}
	face ${Actor["${ActorName}"].X} ${Actor["${ActorName}"].Z}
	if (((${X} < ${Me.X}) && (${Z} < ${Me.Z})) || ((${X} > ${Me.X}) && (${Z} > ${Me.Z})))
		strafe:Set["STRAFERIGHT"]
	else
		strafe:Set["STRAFELEFT"]
	
	press -hold MOVEFORWARD
	do
	{
		loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
		face ${Actor["${ActorName}"].X} ${Actor["${ActorName}"].Z}
		wait 1
		call CheckStuck ${loc0}
		if (${Return})
		{
			Stucky:Inc
			echo Stucky count: ${Stucky}/300
		}
		else
			Stucky:Set[0]
	}
	while (${Actor["${ActorName}"].Distance}>${Distance} && ${Actor["${ActorName}"].Distance(exists)} && ${Stucky}<300)
	press -release MOVEFORWARD
	wait 10
	if (${Stucky}>299)
		call Unstuck ${strafe}
	echo quitting MoveCloseTo function
}
function MoveJump(float X, float Y, float Z, float X0, float Y0, float Z0)
{
	variable bool jumped
	face ${X} ${Z}
	press -hold MOVEFORWARD
	do
	{
		if (${X0}<${X} && ${Me.Loc.X}>${X0})
			call PKey JUMP 1
		if (${X0}>${X} && ${Me.Loc.X}<${X0})
			call PKey JUMP 1
		if (${Z0}>${Z} && ${Me.Loc.Z}<${Z0})
			call PKey JUMP 1
		if (${Z0}<${Z} && ${Me.Loc.Z}>${Z0})
			call PKey JUMP 1
		call TestArrivalCoord ${X} ${Y} ${Z}
	}
	while (!${Return})
}
function MoveTo(string ActorName, float X, float Y, float Z, bool is2D)
{
	target ${Me.Name}
	wait 10
	echo "moving to location ${X} ${Y} ${Z} (${ActorName}) 2D=${is2D}"
	do
	{
		if (!${is2D})
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
		else
		{
			call DMove ${X} ${Y} ${Z} 2
		}
	}	
	while (${Actor["${ActorName}"].Distance} > 10)
	OgreBotAPI:NoTarget[${Me.Name}]
}
function MyTarget(string ActorName)
{
	variable index:actor Actors
	variable iterator ActorIterator
	Distance:Set[200]
	echo looking for "${ActorName}" 
	EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= ${Distance}]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		echo targetting ${ActorIterator.Value.Name} 
		target "${ActorIterator.Value.Name}" 
	}
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
		call CheckCombat
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
		ExecuteQueued
		call 3DNav ${X} ${Math.Calc64[${Y}+200]} ${Z}
		call GoDown
		call TestArrivalCoord ${X} ${Y} ${Z}
	}
	OgreBotAPI:NoTarget[${Me.Name}]
	eq2execute loc
}
function OgreICRun(string Dir, string Iss)
{
	ogre ic
	wait 300
        Obj_FileExplorer:Change_CurrentDirectory["${Dir}"]
        Obj_FileExplorer:Scan
        Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["${Iss}"]
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",TRUE]
}
function OgreTransmute(int Bag)
{
	if (${Bag}<1 || ${Bag}>5)
	{
		echo you must precise bag number 1-6
		return
	}
	variable int i
	echo transmuting content of bag #${Bag}
	ogre im
	wait 100
	for ( i:Set[1] ; ${i} <= 6 ; i:Inc )
		OgreIMAPI.TSE:Set_Settings["-bag",${i},FALSE]
	OgreIMAPI.TSE:Set_Settings["-bag",${Bag},TRUE]
	OgreIMAPI.TSE:Set_Settings["-salvage",FALSE]
	OgreIMAPI.TSE:Set_Settings["-extract",TRUE]
	OgreIMAPI.TSE:Set_Settings["-transmute",TRUE]
	OgreIMAPI.TSE:Start

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
function ScriptAction(string ScriptName, string Action)
{
	if ${Script[${ScriptName}](exists)}
		Script[${ScriptName}]:${Action}
}

function PauseZone(bool Catch22)
{
	variable string sQN
	call strip_QN "${Zone.Name}" TRUE
	sQN:Set[${Return}]
	if ${Script[${sQN}](exists)}
		Script[${sQN}]:Pause
	if ${Script[livedierepeat](exists)}
		Script[livedierepeat]:Pause
	if (${Script[autoshinies](exists)} && !${Catch22})
		Script[autoshinies]:Pause
	press -release MOVEFORWARD
	echo Clearing of zone "${Zone.Name}" is paused (${sQN})
}
function PetitPas(float X, float Y, float Z, float Precision, bool Modified)
{
	variable float Ax
	variable float Az
	variable int Counter=0
	echo "Enter PetitPas"
	call Abs ${Math.Calc64[${Me.Loc.X}-${X}]}
	Ax:Set[${Return}]
	
	call Abs ${Math.Calc64[${Me.Loc.Z}-${Z}]}
	Az:Set[${Return}]

	if ((${X}!=0 || ${Y}!=0 || ${Z}!=0) && (${Ax}<20 && ${Az}<20))
	{
		do
		{
			Counter:Inc
			face ${X} ${Z}
			if ${Modified}
			{
				press -hold MOVEFORWARD
				wait 1
				press -release MOVEFORWARD
			}
			else
				press MOVEFORWARD
			call TestArrivalCoord ${X} ${Y} ${Z} ${Precision}
			
		}
		while (!${Return} && ${Counter}<1000)
	}
	echo Exit PetitPas
}
function PKey(string KName, int ntime)
{
	press -hold "${KName}"
	wait ${ntime}
	press -release "${KName}"
}
function PullNamed(string Named)
{
	variable float X0=${Me.X}
	variable float Y0=${Me.Y}
	variable float Z0=${Me.Z}
	echo Pulling ${Named}...
	face "${Named}"
	target "${Named}"
	wait 50
	if (${Actor["${Named}"].Distance}>20)
	{
		call CloseCombat "${Named}" 50 TRUE
		wait 10
		call DMove ${X0} ${Y0} ${Z0} 2 30 TRUE
		face "${Named}"
		target "${Named}"
	}
}
function RelayAll(string w0, string w1, string w2, string w3, string w4, string w5, string w6,string w7, string w8, string w9)
{
	relay all run EQ2Ethreayd/wrap ${w0} "${w1}" "${w2}" "${w3}" "${w4}" "${w5}" "${w6}" "${w7}" "${w8}" "${w9}"
}

function ReplaceStr(string inputText, string toReplace, string replaceWith)
{
; thanx to user01 for this one
	variable int position = 1
	variable int rposition = 1
	variable string output = ""
	variable string pre = ""
	variable string post = ""
	variable string remainingText = ${inputText}
	while ${remainingText.Find["${toReplace}"](exists)}
	{
		pre:Set[""]
		post:Set[""]
		position:Set[${remainingText.Find["${toReplace}"]}]
		rposition:Set[${Math.Calc[${remainingText.Length}-${position}-${toReplace.Length}+1]}]
		if ${position} > 1
		{
			pre:Set[${remainingText.Left[${Math.Calc[${position}-1]}]}]
		}
		if ${rposition} > 0
		{
			post:Set[]
		}
		output:Set[${output}${pre}${replaceWith}]

		remainingText:Set[${remainingText.Right[${rposition}]}]
	}
	if ${remainingText.Length} > 0 && !${remainingText.Equals[NULL]}
	{
		output:Set[${output}${remainingText}]
	}
	return ${output}
}
function ResumeZone()
{
	variable string sQN
	call strip_QN "${Zone.Name}" TRUE
	sQN:Set[${Return}]
	if ${Script[${sQN}](exists)}
		Script[${sQN}]:Resume
	if ${Script[livedierepeat](exists)}
		Script[livedierepeat]:Resume
	if ${Script[autoshinies](exists)}
		Script[autoshinies]:Resume
	echo Resuming clearing of zone "${Zone.Name}" (${sQN})
}
function ReturnEquipmentSlotHealth(string ItemSlot)
{
	variable int ItemHealth=0
	
	ItemHealth:Set[${Me.Equipment["${ItemSlot}"].ToItemInfo.Condition}]
	wait 10
	ItemHealth:Set[${Me.Equipment["${ItemSlot}"].ToItemInfo.Condition}]
	return ${ItemHealth}
}
function RunZone(int qstart, int qstop, int speed, bool NoShiny, bool NoWait)
{
	variable string sQN
	call strip_QN "${Zone.Name}" TRUE
	sQN:Set[${Return}]
	echo will clear zone "${Zone.Name}" (${sQN}) Now !
	if (!${Script[${sQN}](exists)})
		runscript EQ2Ethreayd/${sQN} ${qstart} ${qstop} ${speed} ${NoShiny}
	else
		Script[${sQN}]:Resume
    wait 5
	if (!${NoWait})
	{
		while ${Script[${sQN}](exists)}
			wait 5
		echo zone "${Zone.Name}" Cleared !
	}
}
function SetAscCS(string mytag)
{
	;local change only
	;oc !c -ChangeCastStackListBoxItemByTag ${Me.Name} eth FALSE
	;oc !c -ChangeCastStackListBoxItemByTag ${Me.Name} elem FALSE
	;oc !c -ChangeCastStackListBoxItemByTag ${Me.Name} geo FALSE
	;oc !c -ChangeCastStackListBoxItemByTag ${Me.Name} thaum FALSE

	oc !c -ChangeCastStackListBoxItemByTag ${Me.Name} ${mytag} TOGGLE FALSE FALSE
}
function SetAscensionCS()
{
	;only needed to run on your main, do not relay
	oc !c -ChangeCastStackListBoxItemByTag All eth FALSE
	oc !c -ChangeCastStackListBoxItemByTag All elem FALSE
	oc !c -ChangeCastStackListBoxItemByTag All geo FALSE
	oc !c -ChangeCastStackListBoxItemByTag All thaum FALSE
	
	oc !c -ChangeCastStackListBoxItemByTag etherealist eth TRUE
	oc !c -ChangeCastStackListBoxItemByTag elementalist elem TRUE
	oc !c -ChangeCastStackListBoxItemByTag geomancer geo TRUE
	oc !c -ChangeCastStackListBoxItemByTag thaumaturgist thaum TRUE
	
	echo you need to restart ogre when changing Ascension Class !!!
}
function SetSoloEnv()
{
	oc !c -ChangeCastStackListBoxItemByTag ${Me.Name} potion TRUE
	oc !c -ChangeCastStackListBoxItemByTag ${Me.Name} solo TRUE
	oc !c -ChangeCastStackListBoxItemByTag ${Me.Name} group FALSE
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkmana","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkmana",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_autotargetwhenhated","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_forcenamedcatab","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_enableonscreenassistant","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_enableogremcp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","text_autotarget_scanradius",20]
}

function ShinyTrade()
{
   variable string MerchantName
   MerchantName:Set["Turns Looted Fertilizer into Shines"]
   if !${Actor["${MerchantName}"](exists)}
   {
      echo ${Time}: ${MerchantName} not found.
      Script:End
   }
   if ${Actor["${MerchantName}"].Distance} > 20
   {
      echo ${Time}: ${MerchantName} too far away ( ${Actor["${MerchantName}"].Distance} ) > 20.
      Script:End
   }
   else
   {
   Actor["${MerchantName}"]:DoFace
   }

   ;// Make sure we have at least ONE inventory slot available.
   if ${Me.InventorySlotsFree} <= 0
   {
      echo ${Time}: You don't have any inventory slots free! You need at least 1 free slot to continue.
      Script:End
   }
   
   ;// We we create a loop to buy. It's possible we will only loop once, or we may have to loop more than once.
   ;// Create a variable, we can stop looping.
   variable int toCollect=0
   toCollect:Set[${Me.InventorySlotsFree}]
   variable int Collected=0
	
   
   ;// Loop as long as we're not suppose to stop (StopLooping) and as long as there are more bags to buy.
   while ${Collected} <= ${toCollect}
   {
      ;// Target the merchant.
      Actor["${MerchantName}"]:DoTarget
      Actor["${MerchantName}"]:DoubleClick
      wait 5
      EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
         variable int RandomDelay
         RandomDelay:Set[ ${Math.Rand[3]} ]
         RandomDelay:Inc[5]
         wait ${RandomDelay}
      Collected:Inc[1]
   }
}
function SmartWait(int WaitTime)
{
	call WaitforGroupDistance 30
	call isMobAround 50
	if (${Return})
		wait ${WaitTime}
}
function StartHunt(string ActorName)
{
	Ob_AutoTarget:AddActor["${ActorName}",0,FALSE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
}
function StartQuest(int stepstart, int stepstop, bool noquest)
{
	variable string n
	variable int i
	
	if (${stepstart}==0 && !${noquest})
	{
		call CurrentQuestStep
		echo I am at step ${Return}
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
function SMove(float X, float Y, float Z, float Distance, float RespectDistance, int Precision, bool CheckCollision)
{

	variable index:actor Mobs
	variable iterator MobIterator
	variable float totaldistance
	variable bool Found
	variable bool Found2
	variable float loc0
	variable int Stucky
	
	if (${Precision}<1)
		Precision:Set[10]
	totaldistance:Set[${Math.Calc64[${Distance}+${RespectDistance}]}]
	
		do
		{
			Found:Set[FALSE]
			Found2:Set[FALSE]
			Stucky:Set[0]
			
			EQ2:QueryActors[Mobs, Type  =- "NPC" && Distance <= ${totaldistance}]
			Mobs:GetIterator[MobIterator]
			if ${MobIterator:First(exists)}
			{
				do
				{
					call Dist ${X} ${Y} ${Z} ${MobIterator.Value.X} ${MobIterator.Value.Y} ${MobIterator.Value.Z} 
					if (${Return}<${RespectDistance} && ${MobIterator.Value.IsAggro})
					{
						echo Found ${MobIterator.Value.Name} at ${Return}m of destination - min is ${RespectDistance}
						echo Aggro of Actor is ${MobIterator.Value.IsAggro} - target is too dangerous to go to, checking next one
						Found:Set[TRUE]
					}
					wait 1
				}	
				while (${MobIterator:Next(exists)} && !${Found})
				if (!${Found})
				{
					call Dist ${X} ${Y} ${Z} ${Me.Loc.X} ${Me.Loc.Y} ${Me.Loc.Z} 
					echo seems that target destination at ${Return}m is safe
					
						press -hold MOVEFORWARD
						do
						{
							loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z}]}]
							face ${X} ${Z}
							wait 1
							call CheckStuck ${loc0}
							if (${Return})
							{
								Stucky:Inc
								echo Stucky count: ${Stucky}/20
							}
							else
								Stucky:Set[0]
							call TestArrivalCoord ${X} ${Y} ${Z} ${Precision}
						}
						while (!${Return} && ${Stucky}<20 && ${MobIterator.Value.Distance} < ${RespectDistance})
						press -release MOVEFORWARD
						if (${Stucky}<20)
							Found2:Set[TRUE]
				}
			}
		}	
		while (!${Found2})
	return ${Found2}
}
function SoloFollow()
{
	if (${Me.GroupCount}==1)
		eq2execute merc resume
	if (${Me.GroupCount}==2)
		oc !c -OgreFollow ${Me.Group[1].Name} ${Me.Name}
}
function SoloLetsgo()
{
	oc !c -letsgo ${Me.Name}
	if (${Me.GroupCount}==2)
		oc !c -letsgo ${Me.Group[1].Name}
}	
function StealthMoveTo(string ItemName, float Distance, float RespectDistance, int Precision, bool CheckCollision)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable index:actor Mobs
	variable iterator MobIterator
	variable float totaldistance
	variable bool Found
	variable bool Found2
	variable float loc0
	variable int Stucky
	
	if (${Precision}<1)
		Precision:Set[10]
	totaldistance:Set[${Math.Calc64[${Distance}+${RespectDistance}]}]
	EQ2:QueryActors[Actors, Name  =- "${ItemName}" && Distance <= ${Distance}]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			Found:Set[FALSE]
			Found2:Set[FALSE]
			Stucky:Set[0]
			
			EQ2:QueryActors[Mobs, Type  =- "NPC" && Distance <= ${totaldistance}]
			Mobs:GetIterator[MobIterator]
			if ${MobIterator:First(exists)}
			{
				do
				{
					call Dist ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} ${MobIterator.Value.X} ${MobIterator.Value.Y} ${MobIterator.Value.Z} 
					if (${Return}<${RespectDistance} && ${MobIterator.Value.IsAggro})
					{
						echo Found ${MobIterator.Value.Name} at ${Return}m of ${ActorIterator.Value.Name} - min is ${RespectDistance}
						echo Aggro of Actor is ${MobIterator.Value.IsAggro} - target is too dangerous to go to, checking next one
						Found:Set[TRUE]
					}	
				}	
				while (${MobIterator:Next(exists)} && !${Found})
				if (!${Found})
				{
					echo seems that target ${ActorIterator.Value.Name} at ${ActorIterator.Value.Distance}m is safe
					if (!${ActorIterator.Value.CheckCollision} || !${CheckCollision})
					{
						press -hold MOVEFORWARD
						do
						{
							loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z}]}]
							face ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
							wait 1
							call CheckStuck ${loc0}
							if (${Return})
							{
								Stucky:Inc
								echo Stucky count: ${Stucky}/20
							}
							else
								Stucky:Set[0]
							call TestArrivalCoord ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z} ${Precision}
						}
						while (!${Return} && ${Stucky}<20 && ${MobIterator.Value.Distance} < ${RespectDistance})
						press -release MOVEFORWARD
						if (${Stucky}<20)
							Found2:Set[TRUE]
					}
					else
					{
						echo aborted - collision detected
					}
				}
			}
		}	
		while (${ActorIterator:Next(exists)} && !${Found2})
	}
	return ${Found2}
}

function StopHunt()
{
	Ob_AutoTarget:Clear
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","FALSE","FALSE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","FALSE","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]
}
function strip_QN(string questname, bool HeroicExpert)
{
	variable string sQN
	echo IN:"${questname}"
	sQN:Set["${questname.Replace["\]","_"]}"]
	sQN:Set["${sQN.Replace["\[","_"]}"]
	sQN:Set["${sQN.Replace[",",""]}"]
	sQN:Set["${sQN.Replace[":",""]}"]
	sQN:Set["${sQN.Replace["'",""]}"]
	sQN:Set["${sQN.Replace[" ",""]}"]
	sQN:Set["${sQN.Replace[" ",""]}"]
	if (${HeroicExpert})
	{
		call ReplaceStr "${sQN}" Expert Group
		sQN:Set["${Return}"]
		call ReplaceStr "${sQN}" Heroic Group
		sQN:Set["${Return}"]
		call ReplaceStr "${sQN}" GroupEvent Group
		sQN:Set["${Return}"]
		call ReplaceStr "${sQN}" EventGroup Group
		sQN:Set["${Return}"]
	}	
	echo OUT:"${sQN}"
	return "${sQN}"
}
function TanknSpank(string Named, float Distance, bool Queue, bool NoCC, bool Immunity)
{
	if (${Distance}<1)
		Distance:Set[50]
	Ob_AutoTarget:AddActor["${Named}",0,!${NoCC},FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	echo "must kill ${Named}"
	call IsPresent "${Named}"
	if (${Return})
	{
		target "${Named}"
		do
		{
			wait 10
			if (${Queue})
				ExecuteQueued
			if (${Actor["${Named}"].Distance} > 30)
				eq2execute merc backoff
			if (${Immunity}) 
				call CastImmunity ${Me.Name} 30 1
			call IsPresent "${Named}" ${Distance} TRUE
		}
		while ((${Return} || ${Me.InCombatMode}) || ${Me.IsDead})
	}
	echo "TanknSpank Debug Return : ${Return}"
	echo "TanknSpank Debug InCombatMode : ${Me.InCombatMode}"
	wait 20
	eq2execute Summon
	wait 50
}
function TargetAfterTime(string mytarget, int ntime)
{
	wait ${ntime}
	target ${mytarget}
}
function TestArrivalCoord(float X, float Y, float Z, int Precision, bool 2D)
{
	variable float Ax
	variable float Ay
	variable float Az
	
	if (${Precision}<1)
		Precision:Set[10]
	
	call Abs ${Math.Calc64[${Me.Loc.X}-${X}]}
	Ax:Set[${Return}]
	call Abs ${Math.Calc64[${Me.Loc.Y}-${Y}]}

	if (${2D})
		Ay:Set[0]
	else
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
function TestNullCoord(float X, float Y, float Z)
{
	if (${X}==0 && ${Y}==0 && ${Z}==0)
		return TRUE
	else
		return FALSE
}	
function Transmute(string ItemName)
{
	echo in Transmute
	call UseAbility Transmute
	wait 5
	Me.Inventory[Query, Name =- "${ItemName}"]:Transmute
	wait 5
	call AcceptReward TRUE
	echo out Transmute
}
function TransmuteAll(string ItemName)
{
	variable int i
	echo in TransmuteAll
	call CountItem "${ItemName}"
	echo transmuting ${Return} ${ItemName} (in TransmuteAll)
	if (${Return}>0)
	{
		do 
		{
			call Transmute "${ItemName}"
			wait 10
			call CountItem "${ItemName}"
		}
		while (${Return}>0)
	}
	echo out of TransmuteAll loop
	call CountItem "${ItemName}"
	echo there is ${Return} ${ItemName} (in TransmuteAll)
	if (${Return}>0)
	{
		echo still !!!!!!!
	}
}
function UnpackItem(string ItemName, int RewardID)
{
	while ${Me.Inventory["${ItemName}"](exists)}
   {
		eq2execute inventory unpack ${Me.Inventory["${ItemName}"].Index}
		wait 5
		RewardWindow:AcceptReward[${RewardWindow.Reward[${RewardID}].LinkID}]
		wait 5
		RewardWindow:Receive
		wait 5
   }
}
function Unstuck(bool LR)
{
	ExecuteQueued
	call PKey JUMP 1
	press -release MOVEFORWARD
	
	if (${LR})
	{
		echo trying to go left
		call PKey STRAFELEFT 5
	}
	else
	{
		echo trying to go right
		call PKey STRAFERIGHT 5
	}
	return !${LR}
}
function UnstuckR(int randomize)
{
	if ${randomize}<1
		randomize:Set[20]
	echo moving random ${randomize}
	press -hold MOVEBACKWARD
	wait ${Math.Rand[${randomize}]}
	press -release MOVEBACKWARD
	press -hold STRAFELEFT
	wait ${Math.Rand[${randomize}]}
	press -release STRAFELEFT
	press -hold STRAFERIGHT
	wait ${Math.Rand[${randomize}]}
	press -release STRAFERIGHT
}
function Unstuck_out(bool FlyingZone)
{
	if ${FlyingZone}
	{
		press -hold FLYUP	
		wait 100
		press -release FLYUP
		press -hold MOVEFORWARD
		wait 50
		press -release MOVEFORWARD
		call GoDown
	}
	else
		call UnstuckR 10
}
function UseAbility(string MyAbilityName)
{
	Me.Ability[Query, ID==${Me.Ability["${MyAbilityName}"].ID}]:Use
}
function UseInventory(string ItemName, bool NoWait)
{
	if (!${NoWait})
	{
		do
		{
			wait 20
		}
		while (!${Me.Inventory["${ItemName}"].IsReady})
	}
	Me.Inventory[Query, Name =- "${ItemName}"]:Use"
}
function UsePotions(bool Everytime, bool NoWait)
{
	if (${Me.InCombat} || ${Everytime})
	{
		if (${Me.Arcane}>0)
			call UseCurePotion Arcane ${NoWait}
		if (${Me.Elemental}>0)
			call UseCurePotion Elemental ${NoWait}
		if (${Me.Noxious}>0)
			call UseCurePotion Noxious ${NoWait}
		if (${Me.Trauma}>0)
			call UseCurePotion Trauma ${NoWait}
		if (${Me.Power}<10)
			call UseInventory "Essence of Power" ${NoWait}
		if (${Me.Health}<10)
			call UseInventory "Essence of Health" ${NoWait}
	}
}
function UseCurePotion(string Detriment, bool NoWait)
{
	if (${Me.${Detriment}}>0)
	{
		do
		{
			call UseInventory "Cure ${Detriment}" ${NoWait}
			wait 10
		}
		while (${Me.${Detriment}}>0)
	}
}

function WaitByPass(string ActorName, float GLeft, float GRight, bool XNOZ)
{
	variable index:actor Actors
	variable iterator ActorIterator
	
	
	EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= 200]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		if (!${XNOZ})
		{
			echo waiting for named to go left
			do
			{
				echo ${ActorIterator.Value.Name} (${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}) at ${ActorIterator.Value.Distance}m
				wait 10 
			}	
			while (${ActorIterator.Value.Z}<${GLeft})
			echo waiting for named to go right
			do
			{
				echo ${ActorIterator.Value.Name} (${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}) at ${ActorIterator.Value.Distance}m
				wait 10 
			}	
			while (${ActorIterator.Value.Z}>${GRight})
		}
		else
		{
			echo waiting for named to go left
			do
			{
				echo ${ActorIterator.Value.Name} (${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}) at ${ActorIterator.Value.Distance}m
				wait 10 
			}	
			while (${ActorIterator.Value.X}<${GLeft})
			echo waiting for named to go right
			do
			{
				echo ${ActorIterator.Value.Name} (${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}) at ${ActorIterator.Value.Distance}m
				wait 10 
			}	
			while (${ActorIterator.Value.X}>${GRight})
		}
		
		echo "${ActorName}" has bypassed ${GLeft}) and ${GRight}
	}		
}
function waitfor_Combat()
{
	wait 50
	do
	{
		wait 5
	} 
	while (${Me.InCombatMode})
}

function waitfor_Corpse()
{
	variable index:actor Actors
	variable iterator ActorIterator
	
	echo searching Corpse
	
	EQ2:QueryActors[Actors, Type  =- "Corpse" && Distance <= 5]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			echo Found ${ActorIterator.Value.Name} corpse
			wait 10
		}	
		while ${ActorIterator:Next(exists)}
	}
}
function WaitforCorpse()
{
	call waitfor_Corpse
}
function waitfor_GroupDistance(int Distance)
{
	variable int Counter
	echo waiting for group to be in a ${Distance}m radius
	do
	{
		wait 10
		Counter:Inc
		if (${Counter}>30)
		{
			call HurryUp ${Distance}
			Counter:Set[0]
		}	
		call GroupDistance
	}
	while (${Return}>${Distance})
}
function WaitforGroupDistance(int Distance)
{
	call waitfor_GroupDistance ${Distance}
}	
function waitfor_Health(int health)
{
	do
	{
		wait 5
	} 
	while (${Me.Health} <${Health})	
}
function waitfor_Login()
{
	variable int LoginScreen=0
	do
	{
		wait 10
		if (${Zone.Name.Equal["LoginScene"]})
			LoginScreen:Inc
		else
			LoginScreen:Set[0]
		echo debug:waitfor_Login ${LoginScreen}
	}
	while (${LoginScreen}<120)
}	
function waitfor_Power(int power)
{
	do
	{
		wait 5
	} 
	while (${Me.Power} <${power})
	
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

function waitfor_RunZone()
{
	echo Waiting for Zone "${Zone.Name}" to be cleared
	wait 5
	call strip_QN "${Zone.Name}"
	sQN:Set[${Return}]
	while ${Script[${sQN}](exists)}
		wait 5
	echo zone "${Zone.Name}" Cleared !
}	
function waitfor_Zone(string ZoneName)
{
	echo Zoning to ${ZoneName}, please be patient
	do
	{
		wait 5
		call CheckZone "${ZoneName}" TRUE
	}
	while (!${Return})
	wait 100
	echo I am in ${ZoneName}
}
function WalkWithTheWind(float X, float Y, float Z)
{
	Windy:Set[FALSE]
	do
	{
		face ${X} ${Z}
		if (!${Windy})
		{
			press -hold MOVEFORWARD
			wait 5
			press -release MOVEFORWARD
		}
		else
		{
			press -release MOVEFORWARD
			wait 100
			Windy:Set[FALSE]
		}
		
		call TestArrivalCoord ${X} ${Y} ${Z} 10 TRUE
	}
	while (!${Return})
}
function WhereIs(string ActorName)
{
	variable index:actor Actors
	variable iterator ActorIterator
	EQ2:QueryActors[Actors, Name  =- "${ActorName}"]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		echo ${ActorIterator.Value.Name} (${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}) at ${ActorIterator.Value.Distance}m
		echo I am at ${Me.Loc.X} ${Me.Loc.Y} ${Me.Loc.Z}
		eq2execute way ${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}
		return TRUE
	}
	else
		return FALSE
}
