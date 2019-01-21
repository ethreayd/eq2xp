#define AUTORUN "num lock"
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

variable(script) iterator ActorIterator
variable(script) iterator NPCIterator
variable(script) bool FlyingZone
variable(script) int Stucky=0

function main(string rtarget, float DistStop)
{
	ogre harvestlite
	radar on
	variable float Precision=3
	variable int meters
	variable index:actor Actors
	variable index:actor NPC
	variable float LastDistance
	variable int MyIndex=0
	variable int Nb=0
	variable int Blocked=0
	variable bool stuck=FALSE  
	variable bool excluded=FALSE
	variable float xyz=0
	variable float loc0=0
	variable float loc1=0
	variable bool Enemy=FALSE
	call CheckFlyingZone
	FlyingZone:Set[${Return}]
	if (!${FlyingZone})
		echo No Flying Zone...
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",15]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_ignorenonaggro","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	
	do 
	{
		do 
		{
			if (${DistStop}<4)
				DistStop:Set[4]
			do
			{
				echo in checkCombat loop (Enemy=${Enemy})
				EQ2:QueryActors[NPC, Type  =- "NPC" && Distance <= 30]
				Actors:GetIterator[NPCIterator]
				if ${NPCIterator:First(exists)}
				{
					if ${NPCIterator.Value.IsAggro}
						Enemy:Set[TRUE]
					wait 5
				}
				else
					Enemy:Set[FALSE]
			}	
			while (${Me.InCombatMode} && ${Enemy})
			Enemy:Set[FALSE]
			if (${rtarget.Equal[""]})
			{	
				EQ2:QueryActors[Actors, Type  =- "Resource" && Distance <= 100]
			}
			else
			{	
				echo looking only for ${rtarget} node
				EQ2:QueryActors[Actors, Name  =- "${rtarget}" && Distance <= 100]
			}
			Actors:GetIterator[ActorIterator]
			call MyCount
			Nb:Set[${Return}]
			echo Found ${Nb} ressources within range (Blocked counter is at ${Blocked} and stucky counter at ${Stucky})
			if ${ActorIterator:First(exists)}
			{
				MyIndex:Set[0]
				do
				{
					call GoDown
					eq2execute merc resume
					echo found ${ActorIterator.Value.Name} - check collision
					face ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
					meters:Set[${ActorIterator.Value.Distance}]
					MyIndex:Inc
					wait 10
					call Exclude_Ressources "${ActorIterator.Value.Name}"
					excluded:Set[${Return}]
					if (!${Actor[name,${ActorIterator.Value.Name}].CheckCollision} && !${excluded})
					{	
						echo found ${ActorIterator.Value.Name} at ${meters}m without collision
						Stucky:Set[0]
						target ${Me.Name}
						LastDistance:Set[${ActorIterator.Value.Distance}]
						do
						{
							wait 5
						}
						while (!${Me.IsIdle})
						do
						{
							stuck:Set[FALSE]
							loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
							press -hold MOVEFORWARD
							wait 1
							press -release MOVEFORWARD
							call CheckStuck ${loc0}
							stuck:Set[${Return}]
						}
						while (${ActorIterator.Value.Distance}>${Precision} && ${ActorIterator.Value.Distance}<${LastDistance} && !${stuck})
						wait 10
						target ${ActorIterator.Value.Name}
						if (${ActorIterator.Value.Distance}<10)
						{
							Blocked:Set[0]
							do
							{
								call CheckStuck ${loc1}
								if ${Return}
									Stucky:Inc
								loc1:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
								echo harvesting ${ActorIterator.Value.Name} node at ${ActorIterator.Value.Distance}m
								wait 10
							}
							while (${ActorIterator.Value.Distance(exists)} && ${ActorIterator.Value.Distance}<${DistStop})
						}
						else
							Blocked:Inc
					}
					else
					{
						echo ${ActorIterator.Value.Name} at ${meters}m is blocked
						if (${Nb}==${MyIndex})
						{
							echo "All ressources are blocked"
							stuck:Set[FALSE]
							loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
							if (${FlyingZone})
							{
								press -hold FLYUP
								wait 30
							}
							
							press -hold MOVEFORWARD
							wait 100
							press -release MOVEFORWARD
							if (${FlyingZone})
							{
								press -release FLYUP
								call GoDown
							}	
							call CheckStuck ${loc0}
							if (!${Return})
								Stucky:Set[0]
							stuck:Set[${Return}]
							press -hold TURNRIGHT
							wait 5
							press -release TURNRIGHT
						}
					}

				}	
				while ${ActorIterator:Next(exists)}
			}
			else
			{
				echo "Searching ressources"
				press -hold MOVEFORWARD
				wait 50
				press -release MOVEFORWARD
				press -hold TURNRIGHT
				wait 5
				press -release TURNRIGHT
				
			}
			wait 5
		}
		while (${Stucky}<10 && !${Me.IsDead} && ${Blocked}<10)
		echo really stuck (${Stucky}-${Blocked}) ! going UP ? ${IsFlying}!
		call Unstuck_out
	}
	while (${Stucky}<20 &&  !${Me.IsDead} && ${Blocked}<20)
	echo harvest script shutdown (${Stucky}-${Blocked})
	;eq2execute "quit login"
	;ActorIterator:Reset
}

function mainY(float Distance)
{
	;ogre harvestlite
	variable float Precision=3
	variable int meters
	variable index:actor Actors
	variable float LastDistance
	variable int stuck  
	do 
	{
		EQ2:QueryActors[Actors, Type  =- "Resource" && Distance <= ${Distance}]
		Actors:GetIterator[ActorIterator]
		if ${ActorIterator:First(exists)}
		{
			call MyCount
			echo MyCount replies : ${Return}
		}
		if ${ActorIterator:First(exists)}
		{
			do
			{
			
				echo ${ActorIterator.Value.Name} : ${ActorIterator.Value.Distance}m	
				
			}	
			while ${ActorIterator:Next(exists)}
		}
		else
		{
			
		}
		wait 5
	}
	while (1==1)
	;ActorIterator:Reset
}

function MyCount()
{
	variable int Count=0
	if ${ActorIterator:First(exists)}
	{
		do
		{
			Count:Inc	
		}	
		while ${ActorIterator:Next(exists)}
	}
	return ${Count}
}

function Exclude_Ressources(string ResourceName)
{
	echo check exclusions for ${ResourceName}
	if (${ResourceName.Equal["Karana's promise"]} || ${ResourceName.Equal["a lost cargo crate"]} || ${ResourceName.Equal["tormentil"]} || ${ResourceName.Equal["Creeping Fortune"]} || ${ResourceName.Equal["fetidthorn spore"]})
	{
		return TRUE
		echo ${ResourceName} is excluded from auto harvesting
	}
	else
	{
		return FALSE
	}
}