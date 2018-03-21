#define AUTORUN "num lock"
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
variable(script) iterator ActorIterator
variable(script) int Stucky=0

function main(string rtarget, float DistStop)
{
	ogre harvestlite
	radar on
	variable float Precision=3
	variable int meters
	variable index:actor Actors
	variable float LastDistance
	variable int MyIndex=0
	variable int Nb=0
	variable bool stuck=FALSE  
	variable bool excluded=FALSE
	variable float xyz=0
	variable float loc0=0
	do 
	{
		Stucky:Set[0]		
	do 
	{
		if (${DistStop}<4)
		{	
			DistStop:Set[4]
		}

		do
		{	
			wait 5
		}
		while (${Me.InCombatMode})
		
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
		echo Found ${Nb} ressources within range
		if ${ActorIterator:First(exists)}
		{
			MyIndex:Set[0]
			do
			{
				if (${Me.FlyingUsingMount})
				{
					press -hold FLYDOWN
					do
					{	
						wait 5
					}
					while (${Me.FlyingUsingMount})
					press -release FLYDOWN
				}
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
					do
					{
						echo harvesting ${ActorIterator.Value.Name} node at ${ActorIterator.Value.Distance}m
						wait 10
					}
					while (${ActorIterator.Value.Distance(exists)} && ${ActorIterator.Value.Distance}<${DistStop})
				}
				else
				{
					echo ${ActorIterator.Value.Name} at ${meters}m is blocked
					if (${Nb}==${MyIndex})
					{
						echo "All ressources are blocked"
						stuck:Set[FALSE]
						loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
						press -hold MOVEFORWARD
						wait 50
						press -release MOVEFORWARD
						call CheckStuck ${loc0}
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
	while (1==1 && ${Stucky}<10)
	echo really stuck (${Stucky}) going UP!!!
	call unstuck
	}
	while (1==1)
	echo harvest script shutdown
	eq2execute "quit login"
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
			echo ${Return}
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
function unstuck()
{
		
		press -hold FLYUP	
		wait 100
		press -release FLYUP
		press -hold MOVEFORWARD
		wait 50
		press -release MOVEFORWARD
		press -hold FLYDOWN
		do
		{	
			wait 5
		}
		while (${Me.FlyingUsingMount})
		press -release FLYDOWN
}

function CheckStuck(float loc)
{
	if (${Math.Calc64[${loc} - ${Me.Loc.X} * ${Me.Loc.X} - ${Me.Loc.Y} * ${Me.Loc.Y} - ${Me.Loc.Z} * ${Me.Loc.Z}]} < 10)
	{
		
		press -hold MOVEFORWARD
		wait 5
		press -release MOVEFORWARD
		if (${Math.Calc64[${loc} - ${Me.Loc.X} * ${Me.Loc.X} - ${Me.Loc.Y} * ${Me.Loc.Y} - ${Me.Loc.Z} * ${Me.Loc.Z}]} < 10)
		{
			echo "I stuck!"
			Stucky:Inc
			return TRUE
		}
	}
	else
	{
		Stucky:Set[0]
		return FALSE
	}
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