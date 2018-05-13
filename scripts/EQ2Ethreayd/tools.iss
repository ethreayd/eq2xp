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

function 2DNav(float X, float Z, bool IgnoreFight)
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
			face ${X} ${Z}
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 5
			
			call CheckStuck ${loc0}
			if (${Return})
			{
				Stucky:Inc
			}
			if (!${IgnoreFight})
				call CheckCombat
				
		}
		while (${Me.Loc.X}>${X} && ${Stucky}<10)
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
			face ${X} ${Z}
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 5
			
			call CheckStuck ${loc0}
			if (${Return})
			{
				Stucky:Inc
			}
			if (!${IgnoreFight})
				call CheckCombat
		}
		while (${Me.Loc.X}<${X} && ${Stucky}<10 )
		press -release MOVEFORWARD
		eq2execute loc
	}
	call TestArrivalCoord ${X} 0 ${Z} 10 TRUE
}
function 2DWalk(float X, float Z)
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
			face ${X} ${Z}
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 3
			call CheckWalking
			if (!${Return})
			{
				WasRunning:Set[TRUE]
				press WALK
			}
			call CheckStuck ${loc0}
			if (${Return})
			{
				Stucky:Inc
			}
			call CheckCombat
		}
		while (${Me.Loc.X}>${X} && ${Stucky}<10)
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
			face ${X} ${Z}
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 3
			call CheckWalking
			if (!${Return})
			{
				WasRunning:Set[TRUE]
				press WALK
			}
			call CheckStuck ${loc0}
			if (${Return})
			{
				Stucky:Inc
			}
			call CheckCombat
		}
		while (${Me.Loc.X}<${X} && ${Stucky}<10 )
		press -release MOVEFORWARD
		eq2execute loc
	}
	call TestArrivalCoord ${X} 0 ${Z} 10 TRUE
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
				call CheckStuck ${loc0}
				if (${Return})
				{
					Stucky:Inc
				}
				call CheckCombat
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
				face ${X} ${Z}
				loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
				wait 2
				call CheckStuck ${loc0}
				if (${Return})
				{
					Stucky:Inc
				}
				call CheckCombat
			}
			while (${Me.Loc.Z}<${Z} && ${Stucky}<10 )
			press -release MOVEFORWARD
			eq2execute loc
		}
	}
	call TestArrivalCoord ${X} 0 ${Z} 10 TRUE

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
function AcceptReward(bool AcceptAll)
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
function ActivateSpecial(string ActorName, float X, float Y, float Z)
{
	call TestArrivalCoord  ${X} ${Y} ${Z}
	if (!${Return})
		call Move "${ActorName}" ${X} ${Y} ${Z}
	OgreBotAPI:Special["${Me.Name}"]
	wait 50
}

function ActivateVerb(string ActorName, float X, float Y, float Z, string verb, bool is2D, bool triggerFight)
{
	echo Looking to ${verb} ${ActorName} at ${X},${Y},${Z}
	call TestArrivalCoord  ${X} ${Y} ${Z}
	if (!${Return})
		call Move "${ActorName}" ${X} ${Y} ${Z} ${is2D}
	echo "${Me.Name}" "${verb}" "${ActorName}" now
	OgreBotAPI:ApplyVerbForWho["${Me.Name}","${ActorName}","${verb}"]
	wait 50
	if (${triggerFight} && ${is2D})
	{
		wait 50
		call waitfor_Combat
		call DMove ${X} ${Y} ${Z} 3
	}
}

function ActivateVerbOnPhantomActor(string verb, float RespectDistance, float Precision)
{
	variable index:actor Actors
    variable iterator ActorIterator
    variable bool Found
	variable bool Hit
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
					Found:Set[TRUE]
				}
		}
        while (${ActorIterator:Next(exists)} && !${Found})
	}	
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
				echo stucked when ascending
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

function AvoidRedCircles(float Distance)
{
	variable index:actor Actors
    variable iterator ActorIterator
    variable float AvoidDistance
	if (${Distance}<0)
		AvoidDistance:Set[30]
	else
		AvoidDistance:Set[${Distance}]
		
	EQ2:QueryActors[Actors, Distance <=${AvoidDistance} && Aura =- "design_circle_warning_zone"]
	EQ2:QueryActors[Actors, Distance <=${AvoidDistance} && Aura =- "design_circle_warning_zone"]
	
    Actors:GetIterator[ActorIterator]
	
    if ${ActorIterator:First(exists)}
    {
		echo Red Circle (${ActorIterator.Value.ID}) detected at ${ActorIterator.Value.Distance}m
		call JoustOut ${ActorIterator.Value.ID} ${AvoidDistance}
	}
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



function CheckCombat(int MyDistance)
{
	if (${MyDistance}<1)
		MyDistance:Set[30]
	OgreBotAPI:NoTarget[${Me.Name}]
	if (${Me.InCombatMode})
	{
		do
		{	
			wait 5
			if (${Target.Distance} > ${MyDistance})
				press -hold MOVEFORWARD
			else
				press -release MOVEFORWARD
		}
		while (${Me.InCombatMode})
	}
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
	
	OgreBotAPI:HailNPC["${Me.Name}","${NPCName}"]
	wait 10
	variable int x
   	for ( x:Set[0] ; ${x} <= ${bubbles} ; x:Inc )
	{
		if (!${OgreQH})
			OgreBotAPI:ConversationBubble["${Me.Name}",1]
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
}
function DescribeItemInventory(string ItemName)
{
	variable index:item Items
    variable iterator ItemIterator
    variable int Counter = 1
    
    Me:QueryInventory[Items, Location == "Inventory" && Name == "${ItemName}"]
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
            echo "${Counter}. ${ItemIterator.Value.Name} : Index : '${ItemIterator.Value.ToItemInfo.Index}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : ID : '${ItemIterator.Value.ToItemInfo.ID}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : SerialNumber : '${ItemIterator.Value.ToItemInfo.SerialNumber}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : Name : '${ItemIterator.Value.ToItemInfo.Name}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : Location : '${ItemIterator.Value.ToItemInfo.Location}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : ToLink : '${ItemIterator.Value.ToItemInfo.ToLink}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : LinkID : '${ItemIterator.Value.ToItemInfo.LinkID}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IconID : '${ItemIterator.Value.ToItemInfo.IcondID}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : Quantity : '${ItemIterator.Value.ToItemInfo.Quantity}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : EffectiveLevel : '${ItemIterator.Value.ToItemInfo.EffectiveLevel}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : Slot : '${ItemIterator.Value.ToItemInfo.Slot}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsReady : '${ItemIterator.Value.ToItemInfo.IsReady}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : TimeUntilReady : '${ItemIterator.Value.ToItemInfo.TimeUntilReady}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : InInventorySlot : '${ItemIterator.Value.ToItemInfo.InInventorySlot}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsInventoryContainer : '${ItemIterator.Value.ToItemInfo.IsInventoryContainer}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsBankConatainer : '${ItemIterator.Value.ToItemInfo.IsBankContainer}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsSharedBankContainer : '${ItemIterator.Value.ToItemInfo.IsSharedBankContainer}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsAutoConsumeable : '${ItemIterator.Value.ToItemInfo.IsAutoConsumeable}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : AutoConsumeOn : '${ItemIterator.Value.ToItemInfo.AutoConsumeOn}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : CanBeRedeemed : '${ItemIterator.Value.ToItemInfo.CanBeRedeemed}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsFoodOrDrink : '${ItemIterator.Value.ToItemInfo.IsFoodOrDrink}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsScribeable : '${ItemIterator.Value.ToItemInfo.IsScribeable}'"
            echo "${Counter}. ${ItemIterator.Value.Name} : IsUsable : '${ItemIterator.Value.ToItemInfo.IsUsable}'"
            Counter:Inc
        }
        while ${ItemIterator:Next(exists)}
    }
}
function DMove(float X, float Y, float Z, int speed, int MyDistance, bool IgnoreFight, bool StuckZone)
{
	variable float loc0
	variable int Stucky
	variable int SuperStucky=0
	variable bool LR
	eq2execute waypoint ${X}, ${Y}, ${Z}
	
	call TestNullCoord ${X} ${Y} ${Z}
	if (!${Return})
		call TestArrivalCoord ${X} ${Y} ${Z}
	
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
				call Get2DDirection ${X} ${Z}
				call Go2D ${X} ${Y} ${Z} ${Return}
			}
			if (${speed} == 2)
				call 2DWalk ${X} ${Z}
			if (${speed} > 2)
				call 2DNav ${X} ${Z} ${IgnoreFight}
			call CheckStuck ${loc0}
			if (${Return})
			{
				Stucky:Inc
				SuperStucky:Inc
				echo Stucky=${Stucky} / ${SuperStucky}
			}
			if (${Stucky}>2)
			{
				call Unstuck ${LR}
				LR:Set[${Return}]
				Stucky:Set[0]
			}
			call TestArrivalCoord ${X} ${Y} ${Z}
			
		}
		while (!${Return} && ${SuperStucky}<100 && !${StuckZone})
	}
	return ${SuperStucky}
}

function Evac()
{
	echo not implemented yet
	switch ${Me.Class}
	{
		case scout
			echo evac of scout
		break
		case warrior
			echo evac
		break
		case cleric
			echo evac
		break
		case brawler
			echo evac
		break
		case druid
			echo evac
		break
		case sorcerer
			echo evac
		break
		case enchanter
			echo evac
		break
		case summoner
			echo evac
		break
		default
			echo evac
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
			call PKey ${KeytoPress} ${PressTime}
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

function Get2DDirection(float X, float Z)
{
	if (((${X} < ${Me.X}) && (${Z} < ${Me.Z})) || ((${X} > ${Me.X}) && (${Z} > ${Me.Z})))
		return "STRAFERIGHT"
	else
		return "STRAFELEFT"
}	
function getChest(string ChestName)
{
	call IsPresent "${ChestName}" 30
	if (${Return})
	{
		call MoveCloseTo "${ChestName}"
	}
}
function GetObject(string ObjectName, string ObjectVerb)
{
	variable index:actor Actors
	variable iterator ActorIterator
	variable int Count=0
	
	ObjectName:Set[ActorIterator
	
	EQ2:QueryActors[Actors, Name  =- "${ObjectName}" && Distance <= 100]
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

function Go2D(float X, float Y, float Z, string strafe)
{
	variable float loc0 
	variable int Stucky
	variable bool There
	echo enter function Go2D
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
			call TestArrivalCoord ${X} ${Y} ${Z} 5
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
		call TestArrivalCoord ${X} ${Y} ${Z} 10
	}
	while (!${Return})
	echo exit function go2D
}
function goCoV()
{	
	if (${Zone.Name.Equal["Plane of Magic"]})
		{
			call ActivateVerb "zone_to_pov" -785 345 1116 "Enter the Coliseum of Valor"
			call waitfor_Zone "Coliseum of Valor"
			call DMove -2 5 4 3
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
		call CastAbility "Call to Guild Hall"
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
				if (${ActorIterator.Value.X(exists)})
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

function IsPresent(string ActorName, int Distance, bool Exact)
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
	if (${Count}>0)
		return TRUE
	else
		return FALSE
}


function JoustOut(int ActorID, float Distance)
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
		Z2:Set[${Math.Calc64[(${JoustDistance}/(${Slope}+1))]}]
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
	
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} ${X2} 0 ${Z2}]
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

function MoveCloseTo(string ActorName)
{
	variable float loc0=0
	variable int Stucky=0
	variable string strafe
	echo Moving closer to ${Actor["${ActorName}"].Name}
	face ${Actor["${ActorName}"].X} ${Actor["${ActorName}"].Z}
	call Get2DDirection ${Actor["${ActorName}"].X} ${Actor["${ActorName}"].Z}
	strafe:Set[${Return}]
	
	press -hold MOVEFORWARD
	do
	{
		loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
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
	while (${Actor["${ActorName}"].Distance}>5 && ${Actor["${ActorName}"].Distance(exists)} && ${Stucky}<300)
	press -release MOVEFORWARD
	wait 10
	if (${Stucky}>299)
		call Unstuck ${strafe}
	echo quitting MoveCloseTo function
}
function MoveJump(float X, float Y, float Z, float X0, float X1, float X2)
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
		call 3DNav ${X} ${Math.Calc64[${Y}+200]} ${Z}
		call GoDown
		call TestArrivalCoord ${X} ${Y} ${Z}
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

function PetitPas(float X, float Y, float Z, float Precision)
{
	variable float Ax
	variable float Az
	echo "Enter PetitPas"
	call Abs ${Math.Calc64[${Me.Loc.X}-${X}]}
	Ax:Set[${Return}]
	
	call Abs ${Math.Calc64[${Me.Loc.Z}-${Z}]}
	Az:Set[${Return}]

	if ((${X}!=0 || ${Y}!=0 || ${Z}!=0) && (${Ax}<20 && ${Az}<20))
	{
		do
		{
			face ${X} ${Z}
			press MOVEFORWARD
			call TestArrivalCoord ${X} ${Y} ${Z} ${Precision}
		}
		while (!${Return})
	}
	echo Exit PetitPas
}
function PKey(string KName, int ntime)
{
	press -hold "${KName}"
	wait ${ntime}
	press -release "${KName}"
}

function ReturnEquipmentSlotHealth(string ItemSlot)
{
	variable int ItemHealth=0
	
	ItemHealth:Set[${Me.Equipment["${ItemSlot}"].ToItemInfo.Condition}]
	wait 10
	ItemHealth:Set[${Me.Equipment["${ItemSlot}"].ToItemInfo.Condition}]
	return ${ItemHealth}
}


function RunZone(int qstart, int qstop)
{
	variable string sQN
	call strip_QN "${Zone.Name}"
	sQN:Set[${Return}]
	echo will clear zone "${Zone.Name}" Now !
    runscript EQ2Ethreayd/${sQN} ${qstart} ${qstop}
    wait 5
    while ${Script[${sQN}](exists)}
		wait 5
	echo zone "${Zone.Name}" Cleared !
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
function StopHunt()
{
	Ob_AutoTarget:Clear
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","FALSE","FALSE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","FALSE","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]
	oc !c -letsgo ${Me.Name}
}
function strip_QN(string questname)
{
	variable string sQN
	echo IN:"${questname}"
	sQN:Set["${questname.Replace["\]","_"]}"]
	sQN:Set["${sQN.Replace["\[","_"]}"]
	sQN:Set["${sQN.Replace[",",""]}"]
	sQN:Set["${sQN.Replace[":",""]}"]
	sQN:Set["${sQN.Replace["'",""]}"]
	sQN:Set["${sQN.Replace[" ",""]}"]
	echo OUT:"${sQN}"
	return "${sQN}"
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
	call UseAbility Transmute
	wait 5
	Me.Inventory[Query, Name =- "${ItemName}"]:Transmute
	wait 5
	call AcceptReward TRUE
}
		
function Unstuck(bool LR)
{
	press PKey JUMP 1
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

function UseAbility(string MyAbilityName)
{
Me.Ability[Query, ID==${Me.Ability["${MyAbilityName}"].ID}]:Use
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
	wait 50
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
	echo Zoning to ${ZoneName}, please be patient
	do
	{
		wait 5
	}
	while (!${Zone.Name.Equal["${ZoneName}"]})
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



