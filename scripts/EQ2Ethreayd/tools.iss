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
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/BoLQuests.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreCommon/EQ2OgreObjects/Object_Get_SpewStats.iss"

;BoolPoll1 must be used to see if anyone is at TRUE, only one TRUE will put that global variable at TRUE
variable(globalkeep) bool BoolPoll1
variable(globalkeep) bool ExpertZone
variable(globalkeep) int PollCounter
variable(globalkeep) int ISNotLogged
variable(globalkeep) bool FORCEPOTIONS=${FORCEPOTIONS}
variable(globalkeep) bool NODEBUG
variable(global) bool NoNavWrap 

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
	Y:Set[${Return}]
	
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
			Y:Set[${Return}]
			call CheckStuck ${loc0}
			if (${Return})
			{
				Stucky:Inc
			}
		}
		while (${Me.Loc.X}>${X} && ${Stucky}<10)
		press -release MOVEFORWARD
		call Ascend ${Y} ${Swim}
		Y:Set[${Return}]
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
			Y:Set[${Return}]
			call CheckStuck ${loc0}
			if (${Return})
			{
				Stucky:Inc
			}
		}
		while (${Me.Loc.X}<${X} && ${Stucky}<10 )
		press -release MOVEFORWARD
		call Ascend ${Y} ${Swim}
		Y:Set[${Return}]
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
				Y:Set[${Return}]
				call CheckStuck ${loc0}
				if (${Return})
				{
					Stucky:Inc
				}
			}
			while (${Me.Loc.Z}>${Z} && ${Stucky}<10 )
			press -release MOVEFORWARD
			call Ascend ${Y} ${Swim}
			Y:Set[${Return}]
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
				Y:Set[${Return}]
				call CheckStuck ${loc0}
				if (${Return})
				{
					Stucky:Inc
				}
			}
			while (${Me.Loc.Z}<${Z} && ${Stucky}<10 )
			press -release MOVEFORWARD
			call Ascend ${Y} ${Swim}
			Y:Set[${Return}]
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
function AcceptReward(bool OnlyMe)
{
 	if (${OnlyMe})
		oc !c -AcceptReward ${Me.Name}
	else
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
function ActionOnItemTier(string Tier, string Action, bool ExtractFirst)
{
	variable index:item Items
    variable iterator ItemIterator
	variable int i=0
	
	Me:QueryInventory[Items, IsInventoryContainer]
	Items:GetIterator[ItemIterator]
	echo I will ${Action} everything that has a ${Tier} Tier
	if ${ItemIterator:First(exists)}
	{
		echo found some stuff in my bags
		do
		{
			
			for ( i:Set[0] ; ${i} <  ${ItemIterator.Value.NumSlots} ; i:Inc )
			{
				echo ${i} <  ${ItemIterator.Value.NumSlots} (looking into ${ItemIterator.Value.Name} bag) '${ItemIterator.Value.ToItemInfo.Type}'
				if (${ItemIterator.Value.ItemInSlot[${i}](exists)} && ${Me.Inventory["${ItemIterator.Value.ItemInSlot[${i}].Name}"].ToItemInfo.Tier.Equal[${Tier}]} && ${Me.Inventory["${ItemIterator.Value.ItemInSlot[${i}].Name}"].ToItemInfo.Type.Equal["Armor"]})
				{
					echo ${ItemIterator.Value.ItemInSlot[${i}].Name} ${Me.Inventory["${ItemIterator.Value.ItemInSlot[${i}].Name}"].ToItemInfo.Tier}
					if (${ExtractFirst})
					{
						echo trying extract essence on ${ItemIterator.Value.ItemInSlot[${i}].Name} first (I should optimize that to only do it for primary, secondary or ranged items)
						Me.Ability[id, 406528868]:Use
						wait 10
						do
						{
							waitframe
						}
						while ${Me.CastingSpell}
						echo Me.Inventory[Query, Name =- "${ItemIterator.Value.ItemInSlot[${i}].Name}"]:Salvage
						wait 5
					}	
					call UseAbility ${Action}
					;wait 10
					do
					{
						waitframe
					}
					while ${Me.CastingSpell}
					echo Me.Inventory[Query, Name =- "${ItemIterator.Value.ItemInSlot[${i}].Name}"]:${Action}
					;wait 10
				}
			}		
		}	
		while ${ItemIterator:Next(exists)}
	}	
}
function ActionOnPrimaryAttributeValue(int Value, string Action, bool ExtractFirst)
{
	variable index:item Items
    variable iterator ItemIterator
	variable int i=0
	
	Me:QueryInventory[Items, IsInventoryContainer]
	Items:GetIterator[ItemIterator]
	echo I will ${Action} everything that has a PA at ${Value}
	if ${ItemIterator:First(exists)}
	{
		echo found some stuff in my bags
		do
		{
			
			for ( i:Set[0] ; ${i} <  ${ItemIterator.Value.NumSlots} ; i:Inc )
			{
				echo ${i} <  ${ItemIterator.Value.NumSlots} (looking into ${ItemIterator.Value.Name} bag) 
				if (${ItemIterator.Value.ItemInSlot[${i}](exists)} && ${Me.Inventory["${ItemIterator.Value.ItemInSlot[${i}].Name}"].ToItemInfo.Modifier[1](exists)} && ${Me.Inventory["${ItemIterator.Value.ItemInSlot[${i}].Name}"].ToItemInfo.Modifier[1].Value}==${Value})
				{
					echo ${ItemIterator.Value.ItemInSlot[${i}].Name} ${Me.Inventory["${ItemIterator.Value.ItemInSlot[${i}].Name}"].ToItemInfo.Modifier[1].Value}
					if (${ExtractFirst})
					{
						echo trying extract essence on ${ItemIterator.Value.ItemInSlot[${i}].Name} first (I should optimize that to only do it for primary, secondary or ranged items)
						Me.Ability[id, 406528868]:Use
						wait 10
						do
						{
							waitframe
						}
						while ${Me.CastingSpell}
						Me.Inventory[Query, Name =- "${ItemIterator.Value.ItemInSlot[${i}].Name}"]:Salvage
						wait 5
					}	
					call UseAbility ${Action}
					wait 10
					do
					{
						waitframe
					}
					while ${Me.CastingSpell}
					Me.Inventory[Query, Name =- "${ItemIterator.Value.ItemInSlot[${i}].Name}"]:${Action}
					wait 10
				}
			}		
		}	
		while ${ItemIterator:Next(exists)}
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

function ActivateSpire(string AltName)
{
	variable string ActorName
	
	if (${AltName.Equal[""]})
		AltName:Set["Spire"]
	call IsPresent "${AltName}" 30 FALSE TRUE
	ActorName:Set["${Return}"]
	if (!${ActorName.Equal["FALSE"]})
	{
		call MoveCloseTo "${ActorName}"
		wait 20
		call ActivateVerbOn "${ActorName}" "Voyage Through Norrath" TRUE
		wait 10
	}
	else
		echo no ${AltName} in 30m reach
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
function AltTSUp(int Timeout)
{
	variable int Counter=0
	variable bool DoAltTSUp
	
	echo checking if I am at max Adorning/Tinkering/Transmuting
	call CheckIfMaxAdorning
	if (${Return})
	{
		echo Adorning at max - skipping
	}
	else
		DoAltTSUp:Set[TRUE]
	
	call CheckIfMaxTinkering
	if (${Return})
	{
		echo Tinkering at max - skipping
	}
	else
		DoAltTSUp:Set[TRUE]
	
	call CheckIfMaxTransmuting
	if (${Return})
	{
		echo Transmuting at max - skipping
	}
	else
		DoAltTSUp:Set[TRUE]
	
	if (!${DoAltTSUp})
		return FALSE
	
	if (${Timeout}<1)
		Timeout:Set[600]
	echo Starting Alternate TradeSkill Upgrade (using Myrist locations)
	echo cleaning Quests journal and related inventory items
	QuestJournalWindow.ActiveQuest["All Purporse Sprockets"]:Delete
	QuestJournalWindow.ActiveQuest["Daily Adorning"]:Delete
	Me.Inventory["Box of Old Boots"]:Destroy
	Me.Inventory["Box of Tinkering Materials"]:Destroy
	Me.Inventory["Box of Adorning Materials"]:Destroy
	Me.Inventory["Metal Sheeting"]:Destroy
	Me.Inventory["Conducting Diode"]:Destroy
	Me.Inventory["Crystalline Fillament"]:Destroy
	Me.Inventory["Protective Fragment"]:Destroy
	Me.Inventory["Warding Powder"]:Destroy
	call goDercin_Marrbrand ${Timeout}
	if (!${Return})
		return TRUE
	wait 50
	call Converse "Dercin Marrbrand" 4
	wait 20
	call Converse "Dercin Marrbrand" 4
	wait 20
	call Converse "Dercin Marrbrand" 4
	wait 20

	call CheckIfMaxTransmuting
	if (!${Return})
	{
		Me.Inventory["Box of Old Boots"]:Unpack
		wait 50
		call TransmuteAll "A worn pair of boots"
		wait 50
		call Converse "Dercin Marrbrand" 2
		wait 20
	}
	call CheckIfMaxAdorning
	if (!${Return})
	{
		Me.Inventory["Box of Adorning Materials"]:Unpack
		wait 50
		call AutoCraft "Work Bench" "Adornment of Guarding (Greater)" 10 TRUE TRUE "Daily Adorning"
		wait 20
		call goDercin_Marrbrand ${Timeout}
		wait 20
		call Converse "Dercin Marrbrand" 2
		wait 20
	}
	call CheckIfMaxTinkering
	if (!${Return})
	{
		Me.Inventory["Box of Tinkering Materials"]:Unpack
		wait 50
		call AutoCraft "Work Bench" "All Purpose Sprocket" 10 TRUE TRUE "All Purpose Sprockets"
		wait 20
		call goDercin_Marrbrand ${Timeout}
		wait 20
		call Converse "Dercin Marrbrand" 2
		wait 20
	}
	echo go to Guild Hall (with auto fix of stay forever there bug)
	do
	{
		Counter:Inc	
		wait 10
		if (${Counter}>${Timeout})
		{
			call UseAbility "Call to Guild Hall"
			return
		}	
		echo if (${Counter}>${Timeout})
	}
	while (!${Me.Ability["Call to Guild Hall"].IsReady} || ${Counter}>${Timeout})
	call goto_GH TRUE
	echo AltTSUp done
	return TRUE
}
function NavRegroup(bool Force)
{
	call GroupDistance
	if (${Return}>20)
	{
		do
		{
			if (${Force})
				relay all ogre navtest -loc ${Me.X} ${Me.Y} ${Me.Z}
			else
				eq2execute gsay "Please nav to me now !"
			wait 600
			call GroupDistance
		}
		while (${Return}>20)
	}
}
function Ascend(float Y, bool Swim)
{
	variable float loc0 
	variable int Stucky=0
	variable int SuperStuck=0
	variable int YStuck=0
	variable float Ymax=0
	call CheckCombat
	call CheckFlyingZone
	if (!${Return})
	{
		echo Not a flying zone
		return
	}
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
				;echo setting Ymax at ${Me.Loc.Y}
				YStuck:Set[0]
			}
			else
				YStuck:Inc
			call CheckStuck ${loc0}
			if (${Return} || ${YStuck}>0)
				Stucky:Inc
			if (${Stucky}>2)
			{	
				ExecuteQueued
				echo stucked when ascending
				press -release FLYUP
				call CheckCombat
				call UnstuckR
				Stucky:Set[0]
				SuperStuck:Inc
				Y:Set[${Math.Calc64[${Ymax}-10]}]
				echo while (${Me.Loc.Y}<${Y} && ${SuperStuck}<5)
			}
		}
		while (${Me.Loc.Y}<${Y} && ${SuperStuck}<5)
	}
	press -release FLYUP
 	eq2execute loc
	echo exiting function Ascend
	return ${Y}
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
		echo targetting "${ActorIterator.Value.Name}" [${ActorIterator.Value.ID}] (${ActorIterator.Value.Distance} m) (from AttackClosest)
	
        target ${ActorIterator.Value.ID}
    }
}
function AutoAddAgent(bool EraseDuplicate)
{
	variable index:item Items
	variable iterator ItemIterator
    variable int Counter=0
	variable int Counter2=0
	variable int Counter3=0
		echo Auto Adding Agent (${EraseDuplicate})
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
					
					Me.Inventory[Query, Name == "${ItemIterator.Value.Name}"]:ConvertAgent[confirm]
					if ${EraseDuplicate}
						Me.Inventory[Query, Name == "${ItemIterator.Value.Name}"]:Destroy[confirm]
				}
			}	
			while ${ItemIterator:Next(exists)}
		}
		
	echo found ${Counter} Agents, ${Counter2} seems to be duplicate (scanned ${Counter3} items)
	if (${Counter2} > 0 && ${EraseDuplicate})
		call AutoAddAgent TRUE
}
function AutoAddQuest(bool EraseDuplicate)
{
	variable index:item Items
	variable iterator ItemIterator
    variable int Counter=0
	variable int Counter2=0
	variable int Counter3=0
		echo Auto Adding Quest (${EraseDuplicate})
		Me:QueryInventory[Items, Location == "Inventory"]
		Items:GetIterator[ItemIterator]
		if ${ItemIterator:First(exists)}
		{
			
			do
			{
				Counter3:Inc
				if (${ItemIterator.Value.Name(exists)})
				{
					call IsOverseerQuest "${ItemIterator.Value.Name}"
					if ${Return}
					{
						echo adding "${ItemIterator.Value.Name}"
						Me.Inventory[Query, Name == "${ItemIterator.Value.Name}"]:Use
						Counter:Inc
						wait 10
					}
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
				call IsOverseerQuest "${ItemIterator.Value.Name}"
				if ${Return}
				{
					Counter2:Inc
					if ${EraseDuplicate}
					{
						Me.Inventory[Query, Name == "${ItemIterator.Value.Name}"]:Destroy[confirm]
						wait 10
					}
				}
			}	
			while ${ItemIterator:Next(exists)}
		}
		
	echo found ${Counter} Quests, ${Counter2} seems to be duplicate (scanned ${Counter3} items)
	if (${Counter2} > 0 && ${EraseDuplicate})
		call AutoAddQuest TRUE
}
function AutoBuyItemFrom(string ItemName, string MerchantName, int Quantity, bool DoNotManageMerchantWindow)
{
	echo inspired from https://forums.ogregaming.com/viewtopic.php?f=15&t=140 (ty Kannkor)
	
	variable bool StopLooping=FALSE
	variable int Bought=0
	variable int RandomDelay
	
	if (${ItemName.Equal[""]})
		return FALSE
	
	if (${MerchantName.Equal[""]})
		return FALSE
	
	if (${Quantity}<1)
		Quantity:Inc
		
	if !${Actor["${MerchantName}"](exists)}
	{
		echo ${Time}: No city merchant called ${MerchantName} found.
		return FALSE
	}
   if ${Actor["${MerchantName}"].Distance} > 10
   {
      echo ${Time}: ${MerchantName} too far away ( ${Actor["${MerchantName}"].Distance} ). Needs to be less than 10 meters away.
	  call MoveCloseTo "${MerchantName}"
   }
	if ${Me.InventorySlotsFree} <= 0
	{
		echo ${Time}: You don't have any inventory slots free! You need at least 10 to start
		return FALSE
	}
	if (!${DoNotManageMerchantWindow})
	{
		Actor["${MerchantName}"]:DoTarget
		Actor["${MerchantName}"]:DoubleClick
		wait 5
	}
	while (${Bought} < ${Quantity})
	{
		
		echo Buying 1 "${ItemName}"
		MerchantWindow.MerchantInventory["${ItemName}"]:Buy[1]
		RandomDelay:Set[ ${Math.Rand[3]} ]
		RandomDelay:Inc[5]
        wait ${RandomDelay}
		Bought:Inc
	}
	call CountItem "${ItemName}"
	echo Bought ${Bought}/${Return} ${ItemName} from ${MerchantName}
	if (!${DoNotManageMerchantWindow})
	{
		EQ2UIPage[Inventory,Merchant].Child[button,Merchant.WindowFrame.Close]:LeftClick   
		EQ2UIPage[Inventory,Merchant].Child[button,Merchant.WC_CloseButton]:LeftClick
		wait 5
	}
	return TRUE
}
function AutoCraft(string tool, string myrecipe, int quantity, bool IgnoreRessources, bool QuestCraft, string QuestName)
{
	if (${Me.Recipe["${myrecipe}"](exists)})
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
	else
		echo Error in function AutoCraft ${myrecipe} does not exist
}
function AutoGroup(float Distance)
{
	variable index:actor Actors
	variable iterator ActorIterator
	if (${Distance}<1)
		Distance:Set[40]
	EQ2:QueryActors[Actors, Type  = "PC" && Guild = "${Me.Guild}" && Distance <= ${Distance}]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			eq2execute invite ${ActorIterator.Value.Name}
		}	
		while ${ActorIterator:Next(exists)}
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
	wait 30
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
	oc !c -Pause ${Me.Name}
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
	oc !c -resume ${Me.Name}
} 
function CastAbility(string AbilityName, bool NoWait)
{
	if (!${NoWait})
	{
		if !${Me.Ability["${AbilityName}"].IsReady}
			echo Ability ${AbilityName} is not ready, I will wait until it is
		do
		{
			wait 20
		}
		while (!${Me.Ability["${AbilityName}"].IsReady})
	}
	call UseAbility "${AbilityName}"
}
function Campfor_NPC(string NPCName, int Duration)
{
	variable int Counter=0
	
	if (${Duration}<1)
		Duration:Set[3600]
	
	echo Camping ${NPCName} for ${Duration}s 
	do
	{
		wait 10
		Counter:Inc
		call WhereIs "${NPCName}" TRUE
		echo We are in Campfor_NPC "${NPCName}" loop, he is ${Return} spawn - (${Counter}<=${Duration})
	} 
	while (!${Return} && ${Counter}<=${Duration})
	echo Debug: ${NPCName} is spawned
	call WhereIs "${NPCName}" TRUE
	if (${Return})
	{
		call Hunt "${NPCName}" 5000
		return TRUE
	}
	else
		return FALSE
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
function AutoLogin(string T1, string T2,string T3, string T4,string T5, string T6,string ScriptName)
{
	variable int i=0
	variable index:string ToonName
	;echo ZoneName is ${Zone.Name}

	for ( i:Set[1] ; ${i} <= 6 ; i:Inc )
	{
		if ${T${i}(exists)}
		{
			ToonName:Insert["${T${i}}"]
			relay is${i} ogre -noredirect "${ToonName[${i}]}"
			wait 100
			;relay is${i} run EQ2Ethreayd/Watchdog "${ToonName[${i}]}"
			;wait 100
		}
	}
	if (${ScriptName(exists)})
	{
		for ( i:Set[1] ; ${i} <= ${ToonName.Used}; i:Inc )
		{
			relay is${i} run "${ScriptName}" "${ToonName[${i}]}"
		}
	}
}

function ChargeOverseer()
{
	variable int i
	variable int j
	variable int max=10
	variable string ItemName
	variable string MerchantName
	
	MerchantName:Set["Stanley Parnem"]
	call goStanleyParnem
	wait 5
	Actor["${MerchantName}"]:DoTarget
	Actor["${MerchantName}"]:DoubleClick
	wait 5
	
	for ( i:Set[1] ; ${i} <= ${MerchantWindow.NumMerchantItemsForSale} ; i:Inc )
	{
		ItemName:Set["${MerchantWindow.MerchantInventory[${i}]}"]
		echo counting number of "${ItemName}" in bags
		call CountItem "${ItemName}"
		
		if (${Return}<${max})
			call AutoBuyItemFrom "${ItemName}" "Stanley Parnem" ${Math.Calc64[${max}-${Return}]} TRUE
		echo AutoAddQuest Now !
		call AutoAddQuest TRUE
	}
	EQ2UIPage[Inventory,Merchant].Child[button,Merchant.WindowFrame.Close]:LeftClick   
	EQ2UIPage[Inventory,Merchant].Child[button,Merchant.WC_CloseButton]:LeftClick
	wait 5
	call AutoAddQuest TRUE
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

function GetNodeType(string ActorName)
{
	if ${ActorName.Find["Blight Blossom"]}>0
		return "Quest"
	if ${ActorName.Find["blightbloom blossom"]}>0
		return "Quest"
	if ${ActorName.Find["kaboritic tephra"]}>0
		return "Quest"
	if ${ActorName.Find["blooded mushroom"]}>0
		return "Quest"
	if ${ActorName.Find["bracket fungus"]}>0
		return "Quest"
	if ${ActorName.Find["cargo crate"]}>0
		return "Quest"
	if ${ActorName.Find["churnfish"]}>0
		return "Quest"
	if ${ActorName.Find["curious ore"]}>0
		return "Quest"
	if ${ActorName.Find["Danak"]}>0
		return "Quest"
	if ${ActorName.Find["draconic idol"]}>0
		return "Quest"
	if ${ActorName.Find["excavated debris"]}>0
		return "Quest"
	if ${ActorName.Find["fetidthorn spore"]}>0
		return "Quest"
	if ${ActorName.Find["frostberry bush"]}>0
		return "Quest"
	if ${ActorName.Find["Glacier Shrub"]}>0
		return "Quest"
	if ${ActorName.Find["Growzzat"]}>0
		return "Quest"
	if ${ActorName.Find["gnoll supplies"]}>0
		return "Quest"
	if ${ActorName.Find["grub-rich soil"]}>0
		return "Quest"
	if ${ActorName.Find["Karana"]}>0
		return "Quest"
	if ${ActorName.Find["Klixie"]}>0
		return "Quest"
	if ${ActorName.Find["Mudcorpse"]}>0
		return "Quest"
	if ${ActorName.Find["owlbear egg"]}>0
		return "Quest"
	if ${ActorName.Find["pipe reed"]}>0
		return "Quest"
	if ${ActorName.Find["Ryjesium Leek"]}>0
		return "Quest"
	if ${ActorName.Find["Sul Sphere"]}>0
		return "Quest"
	if ${ActorName.Find["tortoise egg"]}>0
		return "Quest"
	if ${ActorName.Find["Teren"]}>0
		return "Quest"
	if ${ActorName.Find["Trythec"]}>0
		return "Quest"
	if ${ActorName.Find["Velious Pine"]}>0
		return "Quest"
	if ${ActorName.Find["bed of "]}>0
		return "Bush"
	if ${ActorName.Find["brambles"]}>0
		return "Bush"
	if ${ActorName.Find[" briar"]}>0
		return "Bush"
	if ${ActorName.Find["brush"]}>0
		return "Bush"
	if ${ActorName.Find["bush"]}>0
		return "Bush"
	if ${ActorName.Find["foliage"]}>0
		return "Bush"
	if ${ActorName.Find["fungal"]}>0
		return "Bush"
	if ${ActorName.Find["garden"]}>0
		return "Bush"
	if ${ActorName.Find["nettle"]}>0
		return "Bush"
	if ${ActorName.Find["nursery"]}>0
		return "Bush"
	if ${ActorName.Find["patch"]}>0
		return "Bush"
	if ${ActorName.Find["shrub"]}>0
		return "Bush"
	if ${ActorName.Find["thistle"]}>0
		return "Bush"
	if ${ActorName.Find["burrow"]}>0
		return "Den"
	if ${ActorName.Find[" den"]}>0
		return "Den"
	if ${ActorName.Find["lair"]}>0
		return "Den"
	if ${ActorName.Find["nest"]}>0
		return "Den"
	if ${ActorName.Find["carp"]}>0
		return "Fish"
	if ${ActorName.Find["catch weed"]}>0
		return "Root"
	if ${ActorName.Find["catch"]}>0
		return "Fish"
	if ${ActorName.Find["coral"]}>0
		return "Fish"
	if ${ActorName.Find["fish"]}>0
		return "Fish"
	if ${ActorName.Find["school"]}>0
		return "Fish"
	if ${ActorName.Find["shiver"]}>0
		return "Fish"
	if ${ActorName.Find["shoal"]}>0
		return "Fish"
	if ${ActorName.Find["trout"]}>0
		return "Fish"
	if ${ActorName.Find["reef"]}>0
		return "Stone"
	if ${ActorName.Find["cluster"]}>0
		return "Stone"
	if ${ActorName.Find["geode"]}>0
		return "Stone"
	if ${ActorName.Find["lode"]}>0
		return "Stone"
	if ${ActorName.Find["mass"]}>0
		return "Stone"
	if ${ActorName.Find["ore"]}>0
		return "Stone"
	if ${ActorName.Find["rock"]}>0
		return "Stone"
	if ${ActorName.Find["deposit"]}>0
		return "Stone"
	if ${ActorName.Find["formation"]}>0
		return "Stone"
	if ${ActorName.Find["stone"]}>0
		return "Stone"
	if ${ActorName.Find["ryjesium"]}>0
		return "Stone"	
	if ${ActorName.Find[" foot"]}>0
		return "Root"
	if ${ActorName.Find["root"]}>0
		return "Root"
	if ${ActorName.Find["sprout"]}>0
		return "Root"
	if ${ActorName.Find["weed"]}>0
		return "Root"
	if (${ActorName.Equal["!"]} || ${ActorName.Equal["?"]})
		return "Shiny"
	if ${ActorName.Find["page"]}>0
		return "Shiny"
	if ${ActorName.Find["arbor"]}>0
		return "Wood"
	if ${ActorName.Find["wood"]}>0
		return "Wood"
	if ${ActorName.Find["branch"]}>0
		return "Wood"
	if ${ActorName.Find["timber"]}>0
		return "Wood"
	if ${ActorName.Find["Tizmak"]}>0
		return "Quest"
	if ${ActorName.Equal["NULL"]}
		return "Buggy"
	else
		return "Unknown"
}

function CheckCombat(int MyDistance)
{
	variable bool WasHarvesting
	if (${MyDistance}<1)
		MyDistance:Set[30]
	
	if (${Me.InCombatMode})
	{
		OgreBotAPI:NoTarget[${Me.Name}]
		echo In CheckCombat (TRUE)
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
	return FALSE
}
function MarkAsNotDone(string Filename)
{
	variable file File="${LavishScript.HomeDirectory}/Scripts/tmp/${Filename}-${Me.Name}.dat"
	File:Open
	File:Write[0]
	File:Close
}
function CheckAlreadyDone(int timeout, string Filename)
{
	variable file File="${LavishScript.HomeDirectory}/Scripts/tmp/${Filename}-${Me.Name}.dat"
	variable int TimeStamp
	declare FP filepath "${LavishScript.HomeDirectory}/Scripts"
	if (!${FP.FileExists["tmp"]})
		FP:MakeSubdirectory["tmp"]
	
	File:Open
	TimeStamp:Set[${File.Read.Replace[\n,]}]
	echo TimeStamp : ${TimeStamp}
	File:Close 
	TimeStamp:Inc[${timeout}]
	echo TimeStamp+${timeout} : ${TimeStamp}
	echo if (${TimeStamp}<${Time.Timestamp}) will answer TRUE for ${Filename}
	if (${TimeStamp}<${Time.Timestamp})
	{
		; Not done
		File:Open
		File:Write["${Time.Timestamp}"]
		File:Close
		return FALSE
		
	}
	else
	{
		; Already done
		return TRUE
	}
}
function WardValue(string WardName, int timeout)
{
	variable int Counter
	do
	{
		echo ${Me.Maintained["${WardName}"].DamageRemaining} 
		wait 10
		Counter:Inc
	}
	while (${Counter}<${timeout})
}
function MysticWardValue(int timeout)
{
	variable index:string AbilityNames
    variable int iCounter
    variable int64 WardValue
    AbilityNames:Insert["Ancestral Balm VI"]
    AbilityNames:Insert["Ancestral Savior VIII"]
    AbilityNames:Insert["Ancestral Ward XI"]
    AbilityNames:Insert["Ebbing Spirit IV"]
	AbilityNames:Insert["Eidolic Ward"]
	AbilityNames:Insert["Oberon VII"]
	AbilityNames:Insert["Prophetic Ward VIII"]
	AbilityNames:Insert["Runic Armor X"]
	AbilityNames:Insert["Spirit Aegis"]
	AbilityNames:Insert["Torpor VI"]
	AbilityNames:Insert["Umbral Barrier"]
	AbilityNames:Insert["Wards of the Eidolon"]		

    while ${timeout:Dec} > 0
    {
        WardValue:Set[0]
        for ( iCounter:Set[1] ; ${iCounter} <= ${AbilityNames.Used} ; iCounter:Inc )
        {
            if ${Me.Maintained["${AbilityNames[${iCounter}]}"](exists)}
                WardValue:Inc[${Me.Maintained["${AbilityNames[${iCounter}]}"].DamageRemaining}]
        }
        echo Ward value: ${WardValue}
        wait 10
    }
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
	if ${Me.FlyingUsingMount}
		return TRUE
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
function CheckItem(string ItemName, int Quantity, bool ForAll)
{
	PollCounter:Set[0]
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
function CheckIfRepairIsNeeded(int MinCondition)
{
	if (${MinCondition}<1)
		MinCondition:Set[10]
	call waitfor_Zoning
	call ReturnEquipmentSlotHealth Primary
	;echo Gear at ${Return}% (min is ${MinCondition})
	wait 10
	if (${Return}<${MinCondition})
		return TRUE
	else
		return FALSE
}
function AutoRepair(int Damaged)
{
	if ${Damaged}<10
		Damaged:Set[10]
	call CheckIfRepairIsNeeded ${Damaged}
	if (${Return})
	{
		oc !c -Repair ${Me.Name}
		wait 100
	}
	call CheckIfRepairIsNeeded ${Damaged}
	if (${Return})
	{	
		call UseRepairRobot
	}
	call CheckIfRepairIsNeeded ${Damaged}
	return !${Return}
}
function AutoGetFlag()
{
	do
	{
		call PKey ZOOMOUT 25
		oc !c -GetFlag
		wait 30
		call CountItem "Tactical Rally Banner"
	}
	while (${Return}<1 && ${Zone.Name.Right[10].Equal["Guild Hall"]})
}
function CheckPlayer(float Distance)
{
	variable index:actor Actors
	variable iterator ActorIterator
	if (${Distance}<1)
		Distance:Set[40]
	EQ2:QueryActors[Actors, Type  = "PC" && Guild != "${Me.Guild}" && Distance <= ${Distance}]
	;EQ2:QueryActors[Actors, Type  = "PC" && Distance <= ${Distance}]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		echo ${ActorIterator.Value.Name} (${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}) at ${ActorIterator.Value.Distance}m found
		return TRUE
	}
	else
		return FALSE
}
function CheckPlayerAtCoordinates(float X, float Y, float Z, float Distance)
{
	variable index:actor Actors
	variable iterator ActorIterator
	
	echo calling CheckPlayerAtCoordinates ${X} ${Y} ${Z} ${Distance}
	if (${Distance}<1)
		Distance:Set[30]
	
	EQ2:QueryActors[Actors, Type  = "PC" && Guild != "${Me.Guild}"]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			echo Found ${ActorIterator.Value.Name} (${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z})
			if (${Math.Distance[${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z},${X},${Y},${Z}]}<${Distance})
				return TRUE
		}
		while (${ActorIterator:Next(exists)})
	}
	return FALSE
}
function Poll(string ToolFunction, string arg1, string arg2, string arg3)
{
/*
	BoolPoll1:Set[FALSE]
	echo Polling for ${ToolFunction} ${arg1}
		PollCounter:Set[0]
		relay all BoolPoll1:Set[FALSE]
		wait 20
		if (!${Script["wrap"](exists)})
			relay all run EQ2Ethreayd/wrap CheckQuest "${questname}" FALSE
		else
		{
			echo wrap already used... trying with wrap2
			if (!${Script["wrap2"](exists)})
				relay all run EQ2Ethreayd/wrap2 CheckQuest "${questname}" FALSE
			else
			{
				echo CheckQuest use wrap or wrap2 as function relay wrapper - Do not use them in parallel
				relay all PollCounter:Inc
				echo Can't RUN CheckQuest : PollCounter at ${PollCounter}
				return FALSE
			}
		}
		*/
}
function CheckQuest(string questname, bool ForAll, bool Approximate)
{
	variable index:quest Quests
	variable iterator It
	variable int NumQuests
	BoolPoll1:Set[FALSE]
	
	if (${ForAll})
	{
		echo doing CheckQuest ForAll
		PollCounter:Set[0]
		relay all BoolPoll1:Set[FALSE]
		wait 20
		if (!${Script["wrap"](exists)})
			relay all run EQ2Ethreayd/wrap CheckQuest "${questname}" FALSE
		else
		{
			echo wrap already used... trying with wrap2
			if (!${Script["wrap2"](exists)})
				relay all run EQ2Ethreayd/wrap2 CheckQuest "${questname}" FALSE
			else
			{
				echo CheckQuest use wrap or wrap2 as function relay wrapper - Do not use them in parallel
				relay all PollCounter:Inc
				echo Can't RUN CheckQuest : PollCounter at ${PollCounter}
				return FALSE
			}
		}
	}
	else
	{
		echo Starting CheckQuest : PollCounter at ${PollCounter}
		NumQuests:Set[${QuestJournalWindow.NumActiveQuests}]
    
		if (${NumQuests} < 1)
		{
			echo "No active quests found."
			relay all PollCounter:Inc
			echo No active Quest in CheckQuest : PollCounter at ${PollCounter}
			return FALSE
		}
		QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
		QuestJournalWindow:GetActiveQuests[Quests]
		Quests:GetIterator[It]
		if ${It:First(exists)}
		{
        	do
        	{
				if (${Approximate})
				{
					if (${It.Value.Name.Find["${questname}"]}>0)
					{
		;				echo already on ${questname} (${Approximate} : it's ${It.Value.Name})
						
						if (${ForAll})
						{
							relay all BoolPoll1:Set[TRUE]
						}
						else
						{
							BoolPoll1:Set[TRUE]
						}
					}
				}
				else
				{
					if (${It.Value.Name.Equal["${questname}"]})
					{
		;				echo already on ${questname}
						
						if (${ForAll})
							relay all BoolPoll1:Set[TRUE]
						else
							BoolPoll1:Set[TRUE]
					}
				}
			}
			while ${It:Next(exists)}
		}
		relay all PollCounter:Inc
	}
	wait 100
	echo End of CheckQuest : PollCounter at ${PollCounter}
	if (${BoolPoll1} && ${ForAll})
		eq2execute g I need to do ${questname} today (${PollCounter}) :p
	
	return ${BoolPoll1}
}
function CheckQuestDone(string questname)
{ 
	;Thanks to Pork for the quest check

	if (${QuestJournalWindow.CompletedQuest["${questname}"](exists)})
		return TRUE
	else
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
		
		do
		{
			press -hold MOVEFORWARD 
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
				call Abs ${ItemIterator.Value.Quantity}]
				Counter:Inc[${Return}]
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
function DescribeActorbyName(string ActorName, bool Exact)
{
	variable index:actor Actors
	variable iterator ActorIterator
	if (${Exact})
		EQ2:QueryActors[Actors, Name  = "${ActorName}"]
	else
		EQ2:QueryActors[Actors, Name  =- "${ActorName}"]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		call DescribeActor ${ActorIterator.Value.ID}
		return TRUE
	}
	else
		return FALSE
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
			echo "${Counter}. ${ItemIterator.Value.Name} : Tier : '${ItemIterator.Value.ToItemInfo.Tier}'"
			echo "${Counter}. ${ItemIterator.Value.Name} : Description : '${ItemIterator.Value.ToItemInfo.Description}'"
			echo "${Counter}. ${ItemIterator.Value.Name} : Type : '${ItemIterator.Value.ToItemInfo.Type}'"
			call IsOverseerQuest "${ItemIterator.Value.Name}"
			echo "${Counter}. ${ItemIterator.Value.Name} : IsOverseerQuest : '${Return}'"
            Counter:Inc
        }
        while ${ItemIterator:Next(exists)}
    }
    else
	echo no item "${ItemName}" in Inventory
}
function Destroy(string ItemName)
{
	echo in Destroy
	Me.Inventory[Query, Name =- "${ItemName}"]:Destroy[confirm]	
	echo out Destroy
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
	if (${Me.IsDead})
		return TRUE
	
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
function EndScript(string ScriptName)
{
	if ${Script["${ScriptName}"](exists)}
	{
		end ${ScriptName}
	}
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
				default
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
function FreeportToon()
{
; to be implemented with something better
	call waitfor_Zoning
	return ${Me.GetGameData[Self.BindLocation].Label.Equal["The City of Freeport"]}
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
function goDown()
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
			if (${Return})
				call UnstuckR 20
		}
		while (${Me.FlyingUsingMount})
		press -release FLYDOWN
	}
	wait 10
	echo "I am down"
}
function GoDown()
{
	call goDown
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
function CorrectZone(string ZoneName)
{
	if (${ZoneName.Equal["Freeport"]})
		return "The City of Freeport"	
	return "${ZoneName}"
}
function goZone(string ZoneName, string Transport)
{
	variable string AltZoneName
	
	call CorrectZone "${ZoneName}"
	AltZoneName:Set["${Return}"]
	
	if (!${Transport(exists)})
		Transport:Set["Globe"]
	call IsPresent ${Transport}
	if (!${Return})
	{
		if (${Transport.Equal["Globe"]})
		{
			call IsPresent "Pirate Captain"
			if (${Return})
			{
				call goZone "${ZoneName}" "Pirate Captain"
				return
			}	
		}
		call Log "Can't find ${Transport} in ${Zone.Name} to go to ${ZoneName}" WARNING
		return
	}
	if (${ZoneName.Equal["Aurelian Coast"]})
	{
		call goAurelianCoast
		return TRUE
	}
	if (${ZoneName.Right[12].Equal["Sanctus Seru"]})
	{
		call goSanctusSeru
		return TRUE
	}
	if (${ZoneName.Equal["Wracklands"]})
	{
		call goWracklands
		return TRUE
	}
	echo Going to Zone: ${ZoneName} (${AltZoneName}) (inside goZone in tools)
	if (${Zone.Name.Right[10].Equal["Guild Hall"]})
	{
		call ActivateSpire "${Transport}"
		wait 30
		OgreBotAPI:Travel["${Me.Name}", "${ZoneName}"]
		;wait 50
		;RIMUIObj:TravelMap["${Me.Name}","${ZoneName}",1,2]
		wait 300
		echo I am in ${ZoneName} ((${Zone.Name.Right[10].Equal["Guild Hall"]})) / ${Zone.Name.Left[${ZoneName.Length}].Equal["${ZoneName}"]}
	}
	call waitfor_Zoning
	
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]} && !${Zone.Name.Left[${AltZoneName.Length}].Equal["${AltZoneName}"]})
	{
		call goto_GH
		wait 300
		call goZone "${ZoneName}" "${Transport}"
	}
	if (!${Zone.Name.Left[${AltZoneName.Length}].Equal["${AltZoneName}"]})
	{
		call goZone "${ZoneName}" "${Transport}"
	}
	echo I am in ${ZoneName} (${AltZoneName}) (end of goZone)
}
function goto_GH()
{
	variable int Counter=0
	call GoDown
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]})
	{
		call GoDown
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
			echo waiting to go in GH (${Counter}<300)
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
		wait 50
		call AutoAddAgent TRUE
		call AutoAddQuest TRUE
		echo should I skip Autoplant ? ${NoPlant}
		if (!${NoPlant})
			call AutoPlant
		wait 100
		echo Repair
		OgreBotAPI:RepairGear[${Me.Name}]
		RIMUIObj:Repair[${Me.Name}]
		wait 100
		call GetHarvest
		wait 30
		echo transmuting stones
		call AutoAddAgent TRUE
		call TransmuteAll "Transmutation Stone"
		wait 50
		call Hireling Hunter
		call Hireling Gatherer
		call Hireling Miner
		call UnpackItem "A bushel of harvests" 3
		wait 30
		echo First Depot
		ogre im -Depot
		wait 600
		ogre end im
		wait 20
		echo restocking !
		ogre im -restock
		wait 150
		ogre end im
		call AutoAddAgent TRUE
		call AutoAddQuest TRUE
		
		echo buffing with altars
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
function GetHarvest()
{
	if ${Zone.Name.Right[10].Equal["Guild Hall"]}
	{
		echo getting harvest and harvest quests
	
		call Converse Gatherer 0
		call Converse Hunter 0
		call Converse Miner 0
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
	EQ2:QueryActors[Actors, Name  =- "${ItemName}" && Type == "Resource" && Distance <= ${Distance}]
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
						call 3DNav ${ActorIterator.Value.X} ${Math.Calc64[${ActorIterator.Value.Y}+50]} ${ActorIterator.Value.Z}
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
	call StopHunt
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
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","FALSE","FALSE"]
	if (!${IgnoreFight})
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","TRUE"]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			if (!${IgnoreFight})
				call waitfor_Health 90
			echo ${ActorIterator.Value.Name} found at ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
			call TestArrivalCoord ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
			if (!${Return})
			{
				if (!${nofly})
					call navwrap ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z}
				else
					call DMove ${ActorIterator.Value.X}  ${ActorIterator.Value.Y}  ${ActorIterator.Value.Z} 3 30 ${IgnoreFight}
			}	
			call AutoGroup
			eq2execute merc resume
			
			do
			{
				call CheckPlayer
				echo in Hunt loop - CheckPlayer at ${Return} - Waiting for ${ActorName} to spawn here (${ActorIterator.Value.Name(exists)})
				wait 10
			}
			while (${Return} && ${ActorIterator.Value.Name(exists)})
			call CheckPlayer
			if (!${Return} && ${ActorIterator.Value.Name(exists)})
			{
				OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
				oc !c -CampSpot ${Me.Name}
				wait 200
				do
				{
					wait 10
					call CheckCombat
				}
				while (${Return})
				oc !c -Letsgo ${Me.Name}
			}
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
function IsOverseerQuest(string ItemName, string ItemLocation)
{
    variable index:item Items
    variable iterator ItemIterator
    
    Me:QueryInventory[Items, Location =- "${ItemLocation}" && Name == "${ItemName}"]
    Items:GetIterator[ItemIterator]
 
 
    if ${ItemIterator:First(exists)}
    {
        do
        {
            if (!${ItemIterator.Value.IsItemInfoAvailable})
            {
                do
                {
                    waitframe
                }
                while (!${ItemIterator.Value.IsItemInfoAvailable})
            }
			if (${ItemIterator.Value.ToItemInfo.Description.Find[overseer quest]}>0)
				return TRUE
			else
				return FALSE
        }
        while ${ItemIterator:Next(exists)}
    }
    else
	{
		echo no item "${ItemName}" in Inventory (from function IsOverseerQuest)
		return FALSE
	}
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
			return "${FullActorName}"
		else
			return TRUE
	}
	else
	{
		return FALSE
	}
}
function IsPublicZone()
{
	if ${Zone.Name.Right[8].Equal[\[Heroic\]]}
		return FALSE
	if ${Zone.Name.Right[8].Equal[\[Expert\]]}
		return FALSE
	if ${Zone.Name.Right[13].Equal[\[ExpertEvent\]]}
		return FALSE
	if ${Zone.Name.Right[14].Equal[\[Expert Event\]]}
		return FALSE
	if ${Zone.Name.Right[13].Equal[\[EventHeroic\]]}
		return FALSE
	if ${Zone.Name.Right[14].Equal[\[Event Heroic\]]}
		return FALSE
	if ${Zone.Name.Right[6].Equal[\[Solo\]]}
		return FALSE
	return TRUE
}
function IsZoning()
{
	if ${Me.IsIdle(exists)}
		return FALSE
	else
		return TRUE
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
function JoustWaitBack(int ActorID, float Distance, bool IsGroup, int towait)
{
	variable float X0=${Me.X}
	variable float Y0=${Me.Y}
	variable float Z0=${Me.Z}
	
	call JoustOut ${ActorID} ${Distance} ${IsGroup}
	wait ${towait}
	oc !c -letsgo
	call DMove ${X0} ${Y0} ${Z0} 3 30 TRUE TRUE
	oc !c -CampSpot
	
}
function ForceLogin(string ToonName)
{
	while (${Zone.Name.Equal["LoginScene"]} || ${Zone.Name.Equal["Unknown"]})
	{
		wait 600
		if (${Zone.Name.Equal["LoginScene"]} || ${Zone.Name.Equal["Unknown"]})
		{
			call Log "Seems to be stuck at ${Zone.Name} - Restarting Ogre for ${ToonName} (${Me.Name})" PROBLEM
			if (!${Script["ogreconsole"](exists)})
			{
				do
				{
					call Log "ISXOgre not loaded for ${ToonName} - looping it" PROBLEM
					ext ISXOgre
					wait 1200
				}
				while (!${Script["ogreconsole"](exists)})
			}
			ogre -noredirect "${ToonName}"
		}
	}
	wait 600
	do
	{
		if (!${Script["Buffer:OgreBot"](exists)})
		{
			call Log "--- Starting Ogre (should be started but it is not, why ?)" PROBLEM
			call waitfor_Zoning
			ogre
			wait 300
		}
	}
	while (!${Script["Buffer:OgreBot"](exists)})
	call waitfor_Zoning
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
	
	echo calling function JoustOut with ActorID:${Actor[${ActorID}]} (at ${Actor[${ActorID}].Distance} m and Distance ${Distance} m)
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
	wait 10
	if (${Actor[${ActorID}].Distance}<${Distance})
		call JoustOut ${ActorID} ${Distance} ${IsGroup}
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
function NavPull(string ActorName, float Distance)
{
	variable float loc0=0
	variable int Stucky=0
	variable string strafe
	variable float GlobalX0
	variable float GlobalY0
	variable float GlobalZ0
	variable index:actor Actors
	variable iterator ActorIterator
	
	GlobalX0:Set[${Me.X}]
	GlobalY0:Set[${Me.Y}]
	GlobalZ0:Set[${Me.Z}]
	echo registering ${GlobalX0} ${GlobalY0} ${GlobalZ0} as my NavPull coordinates
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]
	if (${Distance}<1)
		Distance:Set[50]
	
	echo looking for "${ActorName}" 
	EQ2:QueryActors[Actors, Name  =- "${ActorName}" && Distance <= ${Distance}]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		echo Pulling ${ActorIterator.Value.Name} (${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z}) [${Distance}]
		;oc !c -Pause ${Me.Name}
		press F1
		wait 10
		ogre navtest -loc ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z}
		do
		{
			wait 10
			target "${ActorIterator.Value.Name}"
		}
		while (!${Me.InCombatMode})

		do
		{
			if (!${Script["Buffer:OgreNavTest"](exists)})
			{
				echo going back to ${GlobalX0} ${GlobalY0} ${GlobalZ0}
				press F1
				wait 10
				ogre navtest -loc ${GlobalX0} ${GlobalY0} ${GlobalZ0}
			}
			wait 10
			call TestArrivalCoord ${GlobalX0} ${GlobalY0} ${GlobalZ0} 5
		}
		while (!${Return})
		;oc !c -Resume ${Me.Name}
		target "${ActorName}"
		do
		{
			wait 10
		}
		while (${Me.InCombatMode})
		do
		{
			if (${Me.IsIdle} && !${Script["Buffer:OgreNavTest"](exists)})
			{
				echo going back to ${GlobalX0} ${GlobalY0} ${GlobalZ0}
				press F1
				wait 10
				ogre navtest -loc ${GlobalX0} ${GlobalY0} ${GlobalZ0}
			}
			wait 10
			call TestArrivalCoord ${GlobalX0} ${GlobalY0} ${GlobalZ0} 5
		}
		while (!${Return})
	}
}
function NavPullAll(string ActorName)
{
	variable float loc0=0
	variable int Stucky=0
	variable string strafe
	variable float GlobalX0
	variable float GlobalY0
	variable float GlobalZ0
	variable index:actor Actors
	variable iterator ActorIterator
	
	GlobalX0:Set[${Me.X}]
	GlobalY0:Set[${Me.Y}]
	GlobalZ0:Set[${Me.Z}]
	echo registering ${GlobalX0} ${GlobalY0} ${GlobalZ0} as my NavPull coordinates
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]
	if (${Distance}<1)
		Distance:Set[50]
	
	echo looking for "${ActorName}" 
	EQ2:QueryActors[Actors, Name  =- "${ActorName}"]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		do
		{
			echo Pulling ${ActorIterator.Value.Name} (${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z}) [${Distance}]
			press F1
			wait 10
			ogre navtest -loc ${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z}
			do
			{
				wait 10
				target "${ActorIterator.Value.Name}"
			}
			while (!${Me.InCombatMode})
		}	
		while ${ActorIterator:Next(exists)}
		do
		{
			if (!${Script["Buffer:OgreNavTest"](exists)})
			{
				echo going back to ${GlobalX0} ${GlobalY0} ${GlobalZ0}
				press F1
				wait 10
				ogre navtest -loc ${GlobalX0} ${GlobalY0} ${GlobalZ0}
			}
			wait 10
			call TestArrivalCoord ${GlobalX0} ${GlobalY0} ${GlobalZ0} 5
		}
		while (!${Return})
		target "${ActorName}"
		do
		{
			wait 10
		}
		while (${Me.InCombatMode})
		do
		{
			if (${Me.IsIdle} && !${Script["Buffer:OgreNavTest"](exists)})
			{
				echo going back to ${GlobalX0} ${GlobalY0} ${GlobalZ0}
				press F1
				wait 10
				ogre navtest -loc ${GlobalX0} ${GlobalY0} ${GlobalZ0}
			}
			wait 10
			call TestArrivalCoord ${GlobalX0} ${GlobalY0} ${GlobalZ0} 5
		}
		while (!${Return})
	}
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
function NavCamp(float MaxDistance)
{
	variable float GlobalX0
	variable float GlobalY0
	variable float GlobalZ0
	GlobalX0:Set[${Me.X}]
	GlobalY0:Set[${Me.Y}]
	GlobalZ0:Set[${Me.Z}]
	if (${MaxDistance}<1)
	MaxDistance:Set[25]
	echo registering ${GlobalX0} ${GlobalY0} ${GlobalZ0} as my NavCamp coordinates
	
	while (1)
	{
		if (${Math.Distance[${Me.X},${Me.Y},${Me.Z},${GlobalX0},${GlobalY0},${GlobalZ0}]}>${MaxDistance} && !${Me.IsDead} && !${Script["Buffer:OgreNavTest"](exists)})
		{
			eq2execute gsay coming back to ${GlobalX0} ${GlobalY0} ${GlobalZ0} (${Math.Distance[${Me.X},${Me.Y},${Me.Z},${GlobalX0},${GlobalY0},${GlobalZ0}]}>${MaxDistance})
			oc !c -Pause ${Me.Name}
			press F1
			wait 10
			ogre navtest -loc ${GlobalX0} ${GlobalY0} ${GlobalZ0}
			oc !c -Resume ${Me.Name}
			press F2
		}
	}
}

function Check_ISLogged()
{
	if (${Zone.Name.Equal[LoginScene]})
		ISNotLogged:Set[${Session.Right[1]}]
	else
		ISNotLogged:Set[0]
	return ${ISNotLogged}
}

function navwrap(string XS, string YS, string ZS)
{
	variable float loc0=0
	variable int Stucky=0
	variable float X=${XS}
	variable float Y=${YS}
	variable float Z=${ZS}
	variable float FlyingZone
	
	call CheckFlyingZone
	FlyingZone:Set[${Return}]
	
	if (${X}==0 && ${Y}==0 && ${Z}==0)
	{
		echo something wrong is happening, cancelling movement
		return
	}
	if (${XS.Find[","]}>0)
	{	
		call navwrap ${XS.Replace[","," "]}
		return
	}
	
	wait 10
	
	if (${Script["Buffer:OgreNavTest"](exists)} || ${NoNavWrap})
	{
		echo ogre navtest is already running
		return
	}
	call TestArrivalCoord ${X} ${Y} ${Z}
	if (${Return})
	{
		echo already there
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
		oc !c -HoldUp ${Me.Name}
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
		NoNavWrap:Set[TRUE]
		ExecuteQueued
		echo NoNavWrap is set as ${NoNavWrap}
		eq2execute loc
		if (${FlyingZone})
		{
			echo using 3DNav ${X} ${Math.Calc64[${Y}+200]} ${Z}
			call 3DNav ${X} ${Math.Calc64[${Y}+200]} ${Z}
			call GoDown
		}
		else
		{
			call DMove ${X} ${Y} ${Z} 3 30 TRUE TRUE
			call TestArrivalCoord ${X} ${Y} ${Z}
			if (!${Return})
			{
				call UnstuckR 50
				call navwrap ${X} ${Y} ${Z}
			}
		}
	}
	OgreBotAPI:NoTarget[${Me.Name}]
	eq2execute loc
	NoNavWrap:Set[FALSE]
	oc !c -Letsgo ${Me.Name}
	echo End of navwrap
}
function OgreICRun(string Dir, string Iss)
{
	ogre ic
	wait 50
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
function PauseIC()
{
	variable string sQN
	call strip_IC "${Zone.Name}"
	sQN:Set[${Return}]
	if ${Script[${sQN}](exists)}
	{
		Script[${sQN}]:Pause
		oc !c -Pause
		echo Clearing of zone "${Zone.Name}" is paused (${sQN})
	}
	else
		echo can't find IC running iss file...
}
function ResumeIC()
{
	variable string sQN
	call strip_IC "${Zone.Name}"
	sQN:Set[${Return}]
	if ${Script[${sQN}](exists)}
	{
		Script[${sQN}]:Resume
		oc !c -Resume
		echo Clearing of zone "${Zone.Name}" is resumed (${sQN})
	}
	else
		echo can't find IC running iss file...
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
function RebootLoop(string DefaultScriptName)
{
	variable string ScriptName
	variable int Counter
	echo RebootLoop called...
	if ${DefaultScriptName.Equal[""]}
		DefaultScriptName:Set["BoLLoop"]
	ScriptName:Set["${DefaultScriptName}"]
	
	echo rebooting loop named ${DefaultScriptName}
	call RIStop
	call RZStop
	if (${Script["CDLoop"](exists)})
	{
		ScriptName:Set["CDLoop"]
		end ${ScriptName}
	}
	if (${Script["BoLLoop"](exists)})
	{
		ScriptName:Set["BoLLoop"]
		end ${ScriptName}
	}
	if (${Script["ToonAssistant"](exists)})
	{
		end ToonAssistant
	}
	if (${Script["ISXRIAssistant"](exists)})
	{
		end ISXRIAssistant
	}
	if (${Script["OgreICAssistant"](exists)})
	{
		end OgreICAssistant
	}
	I am doing ${ScriptName} after going back to the Guild
	
	if (${Me.InCombat})
	{
		echo Call for Suicide - Pausing Ogre
		oc !c -Pause ${Me.Name}
		do
		{
			eq2execute merc attack
			eq2execute autoattack 0
			wait 100
			Counter:Inc
			echo (!${Me.IsDead} && ${Me.InCombat} && ${Counter} < 60) in function RebootLoop
		}
		while (!${Me.IsDead} && ${Me.InCombat} && ${Counter} < 60)
		
		eq2execute merc suspend
		wait 10
		ChoiceWindow:DoChoice1
		wait 20
		echo Resuming Ogre
		oc !c -Resume ${Me.Name}
	}
	echo --- Reviving (from RebootLoop)
	RIMUIObj:Revive[${Me.Name}]
	oc !c -Revive ${Me.Name}
	wait 400
	call goto_GH
	wait 100
	call GuildH
	echo Launching EQ2Ethreayd/${ScriptName}
	if (!${Script["${ScriptName}"](exists)})
		run EQ2Ethreayd/${ScriptName}
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
	variable int ItemHealth=100
	call waitfor_Zoning
	
	ItemHealth:Set[${Me.Equipment["${ItemSlot}"].ToItemInfo.Condition}]
	waitframe
	ItemHealth:Set[${Me.Equipment["${ItemSlot}"].ToItemInfo.Condition}]
	if ${ItemHealth}<1
	{
		wait 600
		call waitfor_Zoning
		ItemHealth:Set[${Me.Equipment["${ItemSlot}"].ToItemInfo.Condition}]
		wait 100
		ItemHealth:Set[${Me.Equipment["${ItemSlot}"].ToItemInfo.Condition}]
	}	
	;echo checking ${ItemSlot} gear at ${ItemHealth}%
	return ${ItemHealth}
}
function RIRestart(bool IsDead)
{
	echo Pausing RZ
	RZObj:Pause
	call RIStop
	RIMUIObj:Revive[${Me.Name}]
	oc !c -letsgo ${Me.Name} 
	oc !c -revive ${Me.Name}
	if (!${IsDead})
		call Evac
	wait 400
	call RIStart
	echo Resuming RZ
	RZObj:Resume
}
function RIStart()
{
	RI
	wait 100
	UIElement[RI].FindUsableChild[Start,button]:LeftClick
}	
function RIStop()
{
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RIMovement.xml"
	if (${Script["Buffer:RIMovement"](exists)})
		end Buffer:RIMovement
}
function ISXRIPause()
{
	if (${Script["Buffer:RI"](exists)})
		Script["Buffer:RI"]:Pause
	if (${Script["Buffer:RIMovement"](exists)})
		Script["Buffer:RIMovement"]:Pause
	if (${Script["Buffer:RZ"](exists)})
		Script["Buffer:RZ"]:Pause
	if (${Script["Buffer:RunInstances"](exists)})
		Script["Buffer:RunInstances"]:Pause
	if (!${RI_Var_Bool_Paused})
		UIElement[RI].FindUsableChild[Start,button]:LeftClick
}
function ISXRIResume()
{
	if (${Script["Buffer:RI"](exists)})
		Script["Buffer:RI"]:Resume
	if (${Script["Buffer:RIMovement"](exists)})
		Script["Buffer:RIMovement"]:Resume
	if (${Script["Buffer:RZ"](exists)})
		Script["Buffer:RZ"]:Resume
	if (${Script["Buffer:RunInstances"](exists)})
		Script["Buffer:RunInstances"]:Resume
	if (${RI_Var_Bool_Paused})
		UIElement[RI].FindUsableChild[Start,button]:LeftClick
}
function RunInstance()
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

function EndICZone()
{
	variable string sQN
	
	call strip_IC "${Zone.Name}"
	sQN:Set[${Return}]
	echo ending "${Zone.Name}" (${sQN})
	end "${sQN}"
}
function RunICZone()
{
	variable string sQN
	
	call strip_IC "${Zone.Name}"
	sQN:Set[${Return}]
	echo will clear zone "${Zone.Name}" (${sQN}) Now !
	if (${sQN.Right[6].Equal["Heroic"]})
		run "EQ2Ethreayd/IC/Blood_of_Luclin/Heroic/${sQN}.iss"
	else
		run "EQ2Ethreayd/IC/Blood_of_Luclin/Solo/${sQN}.iss"
}
function RZStop()
{
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RZ.xml"
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RZm.xml"
	if (${Script["Buffer:RZ"](exists)})
		end Buffer:RZ
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
         RandomDelay:Set[${Math.Rand[3]}]
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
function strip_IC(string questname, bool HeroicExpert)
{
	variable string sQN
	echo IN:"${questname}"
	sQN:Set["${questname.Replace["\]",""]}"]
	sQN:Set["${sQN.Replace["\[",""]}"]
	sQN:Set["${sQN.Replace[",","_"]}"]
	sQN:Set["${sQN.Replace[":",""]}"]
	sQN:Set["${sQN.Replace["'",""]}"]
	sQN:Set["${sQN.Replace[" ","_"]}"]
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
function Toggle_FORCEPOTIONS()
{
	echo FORCEPOTIONS set at ${FORCEPOTIONS}
	relay all FORCEPOTIONS:Set[!${FORCEPOTIONS}]
	wait 10
	echo FORCEPOTIONS set at ${FORCEPOTIONS}
	if ${FORCEPOTIONS}
		eq2execute gsay Use your Potions when needed !
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
function UseItem((string ItemName, bool NoWait)
{
	call UseInventory "${ItemName}" ${NoWait}
}
function UseInventory(string ItemName, bool NoWait)
{
	;echo in function UseInventory ${ItemName} ${NoWait}
	if (!${NoWait})
	{
		do
		{
			wait 20
		}
		while (!${Me.Inventory["${ItemName}"].IsReady})
	}
	;echo should use potion "${ItemName} now !
	Me.Inventory[Query, Name =- "${ItemName}"]:Use

}
function UseRepairRobot()
{
	call CountItem "Mechanized Platinum Repository of Reconstruction"
	if (${Return}>0)
	{
		Me.Inventory[Query, Name =- "Mechanized Platinum Repository of Reconstruction"]:Use
		wait 50
		oc !c -Repair ${Me.Name}
		return TRUE
	}
		return FALSE
}
function UsePotions(bool Everytime, bool NoWait)
{
	;echo in function UsePotions
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
			eq2execute gsay "glou glou ${Detriment} Potion"
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
	call Waitfor_Combat
}
function Waitfor_Combat()
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
function waitfor_Group()
{
	variable int Counter
	variable int i
	
	do
	{
		Counter:Set[0]
		for ( i:Set[1] ; ${i} < ${Me.GroupCount} ; i:Inc )
		{
			echo  ${i}:${Me.Group[${i}].Distance}
			if (!${Me.Group[${i}].Distance(exists)})
				Counter:Inc
		}
		wait 50
		echo in waitfor_Group() loop with ${Counter} missing member
	}
	while (${Counter}>0)
		
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
function waitfor_Zoning()
{
	;echo pausing if Zoning
	do
	{
		wait 10
		call IsZoning
	}
	while (${Return})
	;echo not Zoning (anymore)
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
function WhereIs(string ActorName, bool Exact, bool ReturnActorLoc)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable string ActorLoc
	if (${Exact})
		EQ2:QueryActors[Actors, Name  = "${ActorName}"]
	else
		EQ2:QueryActors[Actors, Name  =- "${ActorName}"]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		echo ${ActorIterator.Value.Name} (${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}) at ${ActorIterator.Value.Distance}m
		echo I am at ${Me.Loc.X} ${Me.Loc.Y} ${Me.Loc.Z}
		eq2execute way ${ActorIterator.Value.X},${ActorIterator.Value.Y},${ActorIterator.Value.Z}
		ActorLoc:Set[${ActorIterator.Value.X} ${ActorIterator.Value.Y} ${ActorIterator.Value.Z}]
		if ${ReturnActorLoc}
			return ${ActorLoc}
		else
			return TRUE
	}
	else
		return FALSE
}
function IsNamedEngaged(string ActorName, bool Exact)
{
	variable index:actor Actors
	variable iterator ActorIterator
	if (${Exact})
		EQ2:QueryActors[Actors, Name  = "${ActorName}"]
	else
		EQ2:QueryActors[Actors, Name  =- "${ActorName}"]
	Actors:GetIterator[ActorIterator]
	if ${ActorIterator:First(exists)}
	{
		if (${ActorIterator.Value.Health}<100)
		{
			echo ${ActorName} (${Exact}) at ${ActorIterator.Value.Health}% Health seems engaged
			return TRUE
		}
		else
			return FALSE
	}
	else
	{
		echo can't find ${ActorName} (${Exact})
		return TRUE
	}
}
function WeeklyQuest(string QNw, string SNw, bool Expert)
{
	variable int Counter=0
	relay all BoolPoll1:Set[FALSE]
	PollCounter:Set[0]
	call CheckQuest "${QNw}" TRUE
	while (${PollCounter}<6 && ${Counter}<60)
	{
		wait 10
		Counter:Inc
		echo Waiting for PollCounter at ${PollCounter}/6 (${Counter})
	}	
	if (${Return})
	{
		echo I am on main and must do "${QNw}" Grouped Quest
		call strip_QN "${QNw}"
		run EQ2Ethreayd/DoWeekly "${Return}" "${SNw}" ${Expert}
		wait 10
		relay all run EQ2Ethreayd/endsafe "${SNw}" 
	}
	else
		relay all run "${SNw}"
}
function KillIS(int lastis)
{
	variable int i
	for ( i:Set[2] ; ${i} <= ${lastis} ; i:Inc )
	{
		echo relay is${i} run killall
		relay is${i} run killall
	}
}
function DailyQuest()
{
	echo I am on main and must do daily ogre ic Grouped Quest
	relay is7 exit
	run EQ2Ethreayd/DoDaily Churns
	wait 10
	relay all run endscript Churns
}
function ForceGroup()
{
	variable bool Grouped
	variable int Counter
	do
	{
		relay all eq2execute merc suspend
		wait 20
		relay all ChoiceWindow:DoChoice1
		oc !c -Disband
		wait 50
	}
	while (${Me.GroupCount}>1 && ${Counter}<50)
	do
	{
		wait 200
		oc !c -Disband
		wait 100
		call AutoGroup 500
		wait 100
		if (${Me.GroupCount}<6)
			relay all run wrap goto_GH
		else
			Grouped:Set[TRUE]
		call AutoGroup 500
		wait 10
		relay is2 ChoiceWindow:DoChoice1
		relay is3 ChoiceWindow:DoChoice1
		relay is4 ChoiceWindow:DoChoice1
		relay is5 ChoiceWindow:DoChoice1
		relay is6 ChoiceWindow:DoChoice1
		wait 100
		relay all run endscript Churns
		Counter:Inc
	}
	while (!${Grouped} && ${Counter}<50)
}
function HelloWorld()
{
	echo Hello World !!!
}
function GroupToFlag(bool UseToonAssistant)
{
	variable int Counter
	variable int i
	
	Me.Inventory[Query, Name =- "Tactical Rally Banner"]:Use
	wait 50
	echo All group should now come here
	echo waiting for the group to zone
	do
	{
		echo relay all press -hold ZOOMOUT
		relay all press -hold ZOOMOUT
		wait 25
		relay all press -release ZOOMOUT
		oc !c -UseFlag
		Counter:Set[0]
		for ( i:Set[1] ; ${i} < ${Me.GroupCount} ; i:Inc )
		{
			echo  ${i}:${Me.Group[${i}].Distance}
			if (!${Me.Group[${i}].Distance(exists)})
				Counter:Inc
		}
		wait 50
		echo in waiting for group ready loop with ${Counter} missing member
	}
	while (${Counter}>0)

	if (${UseToonAssistant})
	{
		wait 50
		relay all run EQ2Ethreayd/safescript ToonAssistant
		wait 10
		do
		{
			call GroupDistance
			if (${Return}>20 && !${Me.FlyingUsingMount})
			{
				eq2execute gsay "Please nav to me now !"
				wait 300
			}	
		}
		while (${Return}>20)
		wait 100
		oc !c -letsgo
		oc !c -OgreFollow All ${Me.Name}
	}
}
function EquipHeroic()
{
	if (${Me.Archetype.Equal["fighter"]} || ${Me.Archetype.Equal["priest"]})
	{
		Me.Inventory[Query, Name =- "Stonesgrabber"]:Equip
		Me.Inventory[Query, Name =- "Grimling Gumbo"]:Equip
	}
	else
	{
		Me.Inventory[Query, Name =- "Sambata Sangria"]:Equip
		Me.Inventory[Query, Name =- "Festering Mushroom Mash"]:Equip
	}
}
function PotPotion()
{
	Me.Inventory[Query, Name =- "Elixir of Intellect"]:Use
}
function CheckIfLeader(string ActorName)
{
    variable int GroupCounter = 1
    variable int NumChildren
    variable string GMName
    variable string GMType
    variable string RBGAColor
    
    ; Thanks to Amadeus documentation that I have adapted to my need : https://forge.isxgames.com/projects/isxeq2/knowledgebase/articles/19
    if (${Me.Name.Equal[${ActorName}]} && ${Me.IsGroupLeader})
        return TRUE
       
    do
    {
        ; If the MemberInfo page doesn't have 8 children, then it's not valid (i.e., there is no group member in this slot or the structure of the file has changed.)
        NumChildren:Set[${EQ2UIPage[MainHUD,GroupMembers].Child[Page,GroupMember${GroupCounter}.MemberInfoPage.MemberInfo].NumChildren}]
        if (${NumChildren} < 8)
            continue
        
        ; Sanity Check (if this fails, then the structure of the xml file has changed)
        if (!${EQ2UIPage[MainHUD,GroupMembers].Child[Page,GroupMember1.MemberInfoPage.MemberInfo].ChildType[2].Equal["Text"]})
        {
            echo "CRITICAL ERROR - the eq2ui_mainhud_groupmembers.xml file must have changed."
            return
        }
        
        ; We should ignore mercenaries
        GMType:Set[${Me.Group[${GroupCounter}].Type}]
        if (${GMType.Equal["Mercenary"]})
            continue
            
        GMName:Set[${EQ2UIPage[MainHUD,GroupMembers].Child[Page,GroupMember${GroupCounter}.MemberInfoPage.MemberInfo].Child[Text,2].GetProperty[Text]}]
        RBGAColor:Set[${EQ2UIPage[MainHUD,GroupMembers].Child[Page,GroupMember${GroupCounter}.MemberInfoPage.MemberInfo].Child[Text,2].GetProperty[TextColor].Right[6]}]
        
        ; if the TexTColor is ffff (bright yellow) or 7f7f (faded yellow or olive) then the player is the group leader
        if ((${RBGAColor.Equal["ffff00"]} || ${RBGAColor.Equal["7f7f00"]}) && ${GMName.Equal[${ActorName}]}) 
            return TRUE
    }
    while ${GroupCounter:Inc} <= 5
	return FALSE
}

function CheckIfMaxAdorning()
{
	if (${OgreBotAPI.SpewStat[currentadorning]}<${OgreBotAPI.SpewStat[maxadorning]})
		return FALSE
	else
		return TRUE
}
function CheckIfMaxTinkering()
{
	if (${OgreBotAPI.SpewStat[currenttinkering]}<${OgreBotAPI.SpewStat[maxtinkering]})
		return FALSE
	else
		return TRUE
}
function CheckIfMaxTransmuting()
{
	if (${OgreBotAPI.SpewStat[currenttransmuting]}<${OgreBotAPI.SpewStat[maxtransmuting]})
		return FALSE
	else
		return TRUE
}
function Hireling(string NPCName)
{
	;NPC should be Miner, Gatherer or Hunter	
	echo Hireling script for ${NPCName}
	call MoveCloseTo "${NPCName}"
	
	target "${NPCName}"
	eq2execute hail "${NPCName}"
	wait 50
	OgreBotAPI:ConversationBubble["${Me.Name}",3]
	wait 50
	OgreBotAPI:ConversationBubble["${Me.Name}",3]	
	wait 50
}
function CleanBags()
{
	call AutoAddAgent TRUE
	call AutoAddQuest TRUE
	call ActionOnPrimaryAttributeValue 897 Salvage
	call ActionOnPrimaryAttributeValue 996 Salvage
	call ActionOnPrimaryAttributeValue 1040 Salvage
	call ActionOnPrimaryAttributeValue 1062 Salvage
	call ActionOnPrimaryAttributeValue 1142 Salvage
	call ActionOnPrimaryAttributeValue 1195 Salvage
	call ActionOnPrimaryAttributeValue 1248 Salvage
	call ActionOnPrimaryAttributeValue 1325 Salvage
	call ActionOnPrimaryAttributeValue 1353 Salvage
	call ActionOnPrimaryAttributeValue 1381 Salvage
	call ActionOnPrimaryAttributeValue 1446 Salvage
	call ActionOnPrimaryAttributeValue 2650 Salvage
	call ActionOnPrimaryAttributeValue 2706 Salvage
	call TransmuteAll "Planar Transmutation Stone"
	call TransmuteAll "Celestial Transmutation Stone"
	call TransmuteAll "Veilwalker's Transmutation Stone"
}

function ListActors(float MaxDistance, bool Detail)
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
			if ${Detail}
				call DescribeActor ${ActorIterator.Value.ID}

        }
        while ${ActorIterator:Next(exists)}
    }
}

objectdef WebLog
{
	variable webrequest WR

	method Initialize()
	{
		WR:SetURL["${SERVERLOG}"]
	}
	method Send()
	{
		variable uint lastState
		lastState:Set[${WR.State.Value}]
		;echo WR.State=${lastState(ewebrequeststate)}
		WR:InterpretAs[json]
		WR:Begin
		lastState:Set[${WR.State.Value}]
		;echo WR.State=${lastState(ewebrequeststate)}
		;echo WR.URL=${WR.URL}  WR.InterpretAs=${WR.InterpretAs}
		;echo WR.POST=${WR.POST}
		while 1
		{
			if ${WR.State.Value}!=${lastState}
			{
				lastState:Set[${WR.State.Value}]
		;		echo WR.State=${lastState(ewebrequeststate)}

				if ${WR.Result(exists)}
				{
		;			echo Result=${WR.Result.AsJSON}
					WR:Reset
					This:Initialize
					break
				}
			}
		}	
	}
	method Add(string Criticity, string Message)
	{
		; WR.POST:Add["$$[{"${Criticity}":"${Message}"}]$$"]
		;WR.POST:Add["$$[{"name":"post_param_1","value":"post_param_1 value"}]$$"]
		WR.POST:Add["$$>
		{
			"name":"criticity",
			"value":"${Criticity}"
		}
		<$$"]
		WR.POST:Add["$$>
		{
			"name":"message",
			"value":"${Message}"
		}
		<$$"]
	}
}
function Log(string Message,string Criticity)
{
	variable WebLog WL
	Message:Set["${Message.Replace["\,",""]}"]
	if (${NODEBUG})
		return
	if (${Criticity.Length}==0)
		Criticity:Set["DEBUG"]
	WL:Add["${Criticity}","${Message}"]
	WL:Send
	echo "${Message}"
}
objectdef WikiaQuest
{
	variable string OriginalName=""
	variable string QuestName=""
	variable string JournalCategory=""
	variable string QuestCategory=""
	variable string JournalDifficulty=""
	variable string StartingZone=""
	variable string QuestCurrentZone=""
	variable string HowtoStart=""
	variable string StartLoc=""
	variable string PartOf=""
	variable string PrecededBy=""
	variable string FollowedBy=""
	variable string StartAction=""
	variable string StartActor=""
	variable jsonvalue QuestSteps
	variable int QuestID
	variable int QuestLevel
	variable bool RequestDone
	variable bool QuestStatus
	variable bool QuestDone
	variable webrequest QD
	variable webrequest QI
	
	; This method is called automatically, hence I put it here first
	method Initialize(string newName)
	{
		if ${newName.Length}>0
		{
			OriginalName:Set["${newName}"]
			This:SetName["${newName}"]
		}
	}
	
	; Other Public Methods are here alphabetically
	method Describe()
	{
		This:UpdateStatus
		echo Quest "${OriginalName}" [${QuestID}]
		echo -------------------- FROM EQ2 WIKIA WITH LOVE --------------------
		echo Category : ${JournalCategory}
		echo Difficulty : ${JournalDifficulty}
		echo Level : ${QuestLevel}
		echo Starting Zone : ${StartingZone}
		echo How to Start : ${HowtoStart}
		echo Start Location : ${StartLoc}
		echo Part of ${PartOf} sigline
		echo TBD after ${PrecededBy}
		echo Required by ${FollowedBy}
		echo Already done : ${QuestDone}
		echo Ongoing : ${QuestStatus}
	}
	method DescribeDetails()
	{
		variable jsonvalue QDResults=${QD.Result.Get["jsonResult"].Get["sections"]}
		
		This:Describe
		echo ------------------------ QUEST DETAILS ---------------------------
		echo ${QuestSteps}
	}
	method FindStartAction()
	{
		if ${HowtoStart.Find["Talk to"]} > 0
			StartAction:Set["Talk"]
	}
	method Lookup()
	{
		variable uint lastState
		RequestDone:Set[FALSE]

		lastState:Set[${QD.State.Value}]
			
		QD:SetURL["http://ows-171-33-87-167.eu-west-2.compute.outscale.com/cgi-bin/eq2json.py?${QuestName}"]
		QD:InterpretAs[json]
		QD:Begin
		lastState:Set[${QD.State.Value}]
		while 1
		{
			if ${QD.State.Value}!=${lastState}
			{
				lastState:Set[${QD.State.Value}]
				if ${QD.Result(exists)}            
				{
					;echo QD.Result=${QD.Result}
				}
				if ${QD.State.Name.Equal[Completed]}
					break
			}
;			waitframe
		}
		lastState:Set[${QI.State.Value}]
		QI:SetURL["http://ows-171-33-87-167.eu-west-2.compute.outscale.com/cgi-bin/table2json.py?${QuestName}"]
		;echo ${QI.URL}
		QI:InterpretAs[json]
		QI:Begin
		lastState:Set[${QI.State.Value}]
		while 1
		{
			if ${QI.State.Value}!=${lastState}
			{
				lastState:Set[${QI.State.Value}]
				if ${QI.Result(exists)}            
				{
					;echo QI.Result=${QI.Result}
				}
				if ${QI.State.Name.Equal[Completed]}
				{
					
					break
				}	
			}
;			waitframe
		}
		RequestDone:Set[TRUE]
		This:Populate
	}
	method NextQuest()
	{
		return ${FollowedBy}
	}
	method Populate()
	{
		variable jsonvalue QDResults=${QD.Result.Get["jsonResult"].Get["sections"]}
		variable jsonvalue QIResults=${QI.Result.Get["jsonResult"]}
		variable int i=1
		
		JournalCategory:Set["${QIResults.Get["Journal Category"]}"]
		JournalDifficulty:Set["${QIResults.Get["Journal Difficulty"]}"]
		StartingZone:Set["${QIResults.Get["Starting Zone"]}"]
		if (${StartingZone.Right[5].Equal[" more"]})
			StartingZone:Set["${StartingZone.Left[${Math.Calc64[${StartingZone.Length}-5]}]}"]
		HowtoStart:Set["${QIResults.Get["How to Start"]}"]
		StartLoc:Set["${QIResults.Get["waypoint"].Replace[","," "]}"]
		PartOf:Set["${QIResults.Get["part of"]}"]
		PrecededBy:Set["${QIResults.Get["Preceded by"]}"]
		FollowedBy:Set["${QIResults.Get["Followed by"]}"]
		
		do
		{
			if (${QDResults[${i}].Get["title"].Equal["Steps"]})
			{
				QuestSteps:SetValue["${QDResults[${i}]~}"]
				break
			}
			else
				i:Inc
		}
		while (${i}<20)	
		This:UpdateStatus
		This:FindStartAction
		This:UpdateStartActor
	}
	method PreviousQuest()
	{
		return ${PrecededBy}
	}
	method SetName(string newName)
    {
        QuestName:Set["${newName.Replace[" ","_"]}"]
		;QueueCommand call WikiaLookup "${QuestName}"
		This:Lookup
    }
	method UpdateStartActor(string ActorName)
	{
		if ${ActorName.Length}>0
		{
			StartActor:Set["${ActorName}"]
		}
		else
		{
			StartActor:Set[${HowtoStart.Replace["(",","].ReplaceSubstring["Talk to",""]}]
		}
	}
	method UpdateStatus()
	{
		variable index:quest Quests
		variable iterator It
		variable int NumQuests
		
		NumQuests:Set[${QuestJournalWindow.NumActiveQuests}]
    
		if (${NumQuests} > 0)
		{
			QuestJournalWindow.ActiveQuest["${OriginalName}"]:MakeCurrentActiveQuest
			QuestJournalWindow:GetActiveQuests[Quests]
			Quests:GetIterator[It]
			if ${It:First(exists)}
			{
				do
				{
					if (${It.Value.Name.Equal["${OriginalName}"]})
					{
						QuestStatus:Set[TRUE]
						QuestID:Set[${It.Value.ID}]
						QuestLevel:Set[${It.Value.Level}]
						QuestCategory:Set["${It.Value.Category}"]
						QuestCurrentZone:Set["${It.Value.CurrentZone}"]
						break
					}
					else
						QuestStatus:Set[FALSE]

				}
				while ${It:Next(exists)}
			}
		}
		else
			QuestStatus:Set[FALSE]
			
		if (${QuestJournalWindow.CompletedQuest["${OriginalName}"](exists)})
			QuestDone:Set[TRUE]
		else
			QuestDone:Set[FALSE]
	}
}
function AutoQuest(string questname, bool ForceAlreadyDone, bool DoNotContinue)
{
	echo Doing automatically Quest ${questname} !
	echo I am kidding ! But this will be a great feature !!!
	variable WikiaQuest WQ="${questname}"
	variable int i=3
	WQ:DescribeDetails
	if (!${WQ.QuestDone} || ${ForceAlreadyDone})
	{
		if (!${WQ.QuestStatus})
		{
			
			echo I must go to ${WQ.StartingZone}
			call goZone "${WQ.StartingZone}"
			
			if (${OgreBotAPI.KWAble})
				call KannkorRulez ${WQ.StartLoc}
			else
				call navwrap ${WQ.StartLoc}
			echo I must ${WQ.HowtoStart} Action is ${WQ.StartAction} on Actor ${WQ.StartActor}
			
			call FindActor ${WQ.HowtoStart}
			WQ:UpdateStartActor["${Return}"]
			echo need to ${WQ.StartAction} to ${WQ.StartActor}
			do
			{
				if (${WQ.StartAction.Equal["Talk"]})
					call Converse "${WQ.StartActor}" ${i}
				else
					oc !c -Special ${Me.Name}
				i:Inc
				call CheckQuest "${questname}"
			}
			while (!${Return} && ${i} < 25) 
		}
		echo doing steps : TO BE IMPLEMENTED
	}
	else
	{
		if (!${DoNotContinue} && ${WQ.FollowedBy(exists)})
			call AutoQuest "${WQ.FollowedBy}" ${ForceAlreadyDone} ${DoNotContinue}
	}
}
function FindActor(string x1, string x2, string x3, string x4, string x5, string x6, string x7, string x8, string x9)
{
	variable int i
	for ( i:Set[1] ; ${i} <= 9 ; i:Inc )
	{
		if (!${x${i}.Equal[""]})
			call IsPresent "${x${i}}" 10 FALSE TRUE
		if (!${Return.Equal[FALSE]})
			return ${Return}
	}
}
function DoEpic(weakref Quests)
{
	variable int i
	for ( i:Set[1] ; ${i} <= ${Quests.Used} ; i:Inc )
	{
		call CheckQuest "${Quests[${i}]}"
		if (${Return})
		{
			call AutoQuest "${Quests[${i}]}"
			break
		}
		else
		{
			call CheckQuestDone "${Quests[${i}]}"
			if (!${Return})
			{
				call AutoQuest "${Quests[${i}]}"
				break
			}
		}
	}
}
