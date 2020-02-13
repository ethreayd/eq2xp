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
variable(script) int Stucky=0

function main(string rtarget, bool FlyingZone, int radius)
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
	variable float loc2=0
	variable bool Enemy=FALSE
	variable float X0=0
	variable float Y0=${Math.Calc64[${Me.Y}+10]}
	variable float Z0=0
	variable float Y1
	variable float DistStop=4
	if ${radius}<1
		radius:Set[1000]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	echo "Debug: Starting sharvest script - looking for ${rtarget} in a radius of ${radius}m using flying=${FlyingZone}"
	call CheckCombat
	face 0 0
	call CheckSwimming
	call CheckCombat
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",15]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_ignorenonaggro","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	
	do 
	{
		do 
		{
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
			echo "Debug: Querying Actors for ressources (${rtarget})"
			if (${rtarget.Equal[""]})
			{	
				EQ2:QueryActors[Actors, Type  =- "Resource" && Distance <= ${radius}]
			}
			else
			{	
				echo looking only for ${rtarget} node
				EQ2:QueryActors[Actors, Name  =- "${rtarget}" && Distance <= ${radius}]
			}
			Actors:GetIterator[ActorIterator]
			call MyCount
			Nb:Set[${Return}]
			echo Found ${Nb} ressources within range (Blocked counter is at ${Blocked} and stucky counter at ${Stucky})
			call CheckCombat
			if ${ActorIterator:First(exists)}
			{
				MyIndex:Set[0]
				do
				{
					call GoDown
					call CheckCombat
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
						if (${FlyingZone})
						{
							if (${Me.Y} < ${ActorIterator.Value.Y})
								Y1:Set[${ActorIterator.Value.Y}]
							else
								Y1:Set[${Me.Y}]
							
							call 3DNav ${ActorIterator.Value.X} ${Math.Calc64[${Y1}+15]} ${ActorIterator.Value.Z}
							call GoDown
							;face 0 0
							call CheckSwimming
						}
						target ${Me.Name}
						LastDistance:Set[${ActorIterator.Value.Distance}]
						do
						{
							wait 5
						}
						while (!${Me.IsIdle})
						do
						{
							call CheckCombat
							stuck:Set[FALSE]
							loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
							face ${ActorIterator.Value.X} ${ActorIterator.Value.Z}
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
								echo harvesting ${ActorIterator.Value.Name} node at ${ActorIterator.Value.Distance}m (stucky at ${Stucky})
								if (!${rtarget.Equal[""]} && ${Special})
										OgreBotAPI:Special["${Me.Name}"]
								call CheckCombat
								press MOVEFORWARD
								wait 10
							}
							while (${ActorIterator.Value.Distance(exists)} && ${ActorIterator.Value.Distance}<${DistStop} && ${Stucky}<20)
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
							call CheckCombat
							Blocked:Inc
							stuck:Set[FALSE]
							loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
							if (${FlyingZone})
							{
								call 3DNav ${ActorIterator.Value.X} ${Math.Calc64[${ActorIterator.Value.Y}+50]} ${ActorIterator.Value.Z}
								call CheckStuck ${loc0}
								if (!${Return})
								{
									Stucky:Set[0]
									Blocked:Set[0]
								}
							}
							else
							{
								echo can't fly here, trying to do without
								press -hold MOVEFORWARD
								wait 100
								press -release MOVEFORWARD
								call UnstuckR
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

				}	
				while ${ActorIterator:Next(exists)}
			}
			else
			{
				echo "Searching ressources / Flying up to enjoy the view"
				if (${FlyingZone})
				{
					if (!${rtarget.Equal[""]})
					{
						call BaryCenterX "${rtarget}"
						X0:Set[${Return}]
						call BaryCenterY "${rtarget}"
						Y0:Set[${Return}]
						call BaryCenterZ "${rtarget}"
						Z0:Set[${Return}]
					}
					if (${X0} != 0 && ${Z0} != 0)
						call 3DNav ${X0} ${Math.Calc64[${Y0}+10]} ${Z0}
					else
						call 3DNav ${Me.X} ${Math.Calc64[${Me.Y}+10]} ${Me.Z}
				}
				call UnstuckR 100
			}
			wait 5
		}
		while (${Stucky}<10 && !${Me.IsDead} && ${Blocked}<10)
		echo really stuck (${Stucky}-${Blocked}) ! going UP ? ${FlyingZone}!
		call Unstuck_out
	}
	while (${Stucky}<20 && !${Me.IsDead} && ${Blocked}<20)
	echo while (${Stucky}<20 && !${Me.IsDead} && ${Blocked}<20) stucky - not dead - blocked
	call GoDown
	face 0 0
	call CheckSwimming
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
atom HandleAllEvents(string Message)
{
	;echo event catched : ${Message}
	if (${Message.Equal["Can't see target"]})
	{
		Stucky:Inc
		echo ${Stucky}
	}
	if (${Message.Find["ou acquire"]}>0)
	{
		Stucky:Set[0]
		Blocked:Set[0]
	}
}