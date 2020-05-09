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

variable(script) string QN
variable(script) string QZ
variable(script) index:string NamedToHunt
variable(script) index:string NamedCoordinates
variable(script) index:bool NamedDone

function HarvestQuest(string HarvestQ)
{
	call CheckQuest "${HarvestQ}" FALSE TRUE
	if (${Return})
	{
		call goZone "The Blinding"
		do
		{
			call Harvest
			call CheckQuest "Recuso Tor: Stocking Up" FALSE TRUE
		}
		while (${Return})
	}
}
function LuclinLandscapingTheBlinding(bool DoNotWait, int Timeout)
{
	NamedToHunt:Insert["Novilog"]
	NamedCoordinates:Insert["-106 307 -811"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["An Ancient Spectre"]
	NamedCoordinates:Insert["434.86 347.73 -505.35"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["A Greater Lightcrawler"]
	NamedCoordinates:Insert["350 145 927"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Cluster"]
	NamedCoordinates:Insert["-476 72 -36"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Cobblerock"]
	NamedCoordinates:Insert["62 9 533"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Ripperback"]
	NamedCoordinates:Insert["-403 6 750"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Deathpetal"]
	NamedCoordinates:Insert["-794 5 797"]
	NamedDone:Insert[FALSE]
	QN:Set["Luclin Landscaping: The Blinding"]
	QZ:Set["The Blinding"]
	call TheHunt ${DoNotWait} ${Timeout}
}


function LuclinLandscapingAurelianCoast(bool DoNotWait, int Timeout)
{
	NamedToHunt:Insert["Glorgan the Hammer"]
	NamedCoordinates:Insert["-96 82 -709"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Klechin Darkfist"]
	NamedCoordinates:Insert["66 79 -569"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Nremum"]
	NamedCoordinates:Insert["-326 3 -104"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Rockskin"]
	NamedCoordinates:Insert["-543 60 65"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Va Din Ra"]
	NamedCoordinates:Insert["-559 34 766"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Xi Xaui"]
	NamedCoordinates:Insert["-486 7 938"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["The Great Sensate"]
	NamedCoordinates:Insert["354 43 556"]
	NamedDone:Insert[FALSE]
	QN:Set["Luclin Landscaping: Aurelian Coast"]
	QZ:Set["Aurelian Coast"]
	call TheHunt ${DoNotWait} ${Timeout}
}
function TheHunt(bool DoNotWait, int Timeout)
{
	variable int i
	variable int Counter
	variable bool GoHunt
	variable bool Grouped

	echo Launching TheHunt
	if (${Timeout}<1)
		Timeout:Set[5]
	if (${Me.GroupCount}>2)
		Grouped:Set[TRUE]
	else
		Grouped:Set[FALSE]
	
	echo Timeout at ${Timeout}
	echo Grouped at ${Grouped}
	
	echo call CheckQuest "${QN}" ${Grouped}
	call CheckQuest "${QN}" ${Grouped}
	
	if (${Return})
	{
		echo Doing "${QN} (Grouped : ${Grouped})"
		call goZone "${QZ}"
		wait 50
		call waitfor_Zoning
		wait 50
	
		if (${Me.GroupCount}>2)
		{
			echo I am doing a Group Hunt
			Grouped:Set[TRUE]
			
			call GroupToFlag TRUE
		}
		do
		{
			Echo looking for Quest Named (${QN} in ${QZ})
			eq2execute merc resume
			for ( i:Set[1] ; ${i} <= ${NamedToHunt.Used} ; i:Inc )
			{
				call WhereIs "${NamedToHunt[${i}]}" TRUE
				
				echo testing "${NamedToHunt[${i}]}" (${NamedDone[${i}]}) : ${Return}
				if (${Return})
				{
					
					call IsNamedEngaged "${NamedToHunt[${i}]}" TRUE
					if (${Return})
					{
						echo Aborting...
						GoHunt:Set[FALSE]
						call StopHunt
					}
					else
					{
						call CheckPlayerAtCoordinates ${NamedCoordinates[${i}]}
						if (${Return})
						{
							echo ${NamedToHunt[${i}]} is already camped - avoiding it
							return FALSE
							GoHunt:Set[FALSE]
							call StopHunt
						}
						else
						{
							echo hunting ${NamedToHunt[${i}]}
							GoHunt:Set[TRUE]
						}
					}
				}
				else
				{
					GoHunt:Set[FALSE]
					call StopHunt
				}
				wait 10
				call CheckQuest "${QN}" ${Grouped}
				
				if (${GoHunt} && ${Return} && !${NamedDone[${i}]})
				{
					echo Found "${NamedToHunt[${i}]}" at ${NamedCoordinates[${i}]}
					if (${Grouped})
						oc !c -Resume
					else
						oc !c -Resume ${Me.Name}
					call navwrap ${NamedCoordinates[${i}]}
					call GroupDistance
					if (${Return}>20)
						eq2execute gsay "Please nav to me now !"
					call AttackClosest
					call CheckPlayer
					if (!${Return})
					{
						target "${NamedToHunt[${i}]}"
						call Campfor_NPC "${NamedToHunt[${i}]}"
						NamedDone[${i}]:Set[TRUE]
					}
					call StopHunt
				}
			}
			
			echo checking if in Combat (1)
			do
			{
				wait 10
				call CheckCombat
			}
			while (${Return})
			call CheckQuest "${QN}" ${Grouped}
			if (${Return} && !${DoNotWait})
			{
				i:Set[${Math.Calc64[${Math.Rand[${NamedToHunt.Used}]}+1]}]
				echo got ${i}/${NamedToHunt.Used}
				if (!${NamedDone[${i}]})
				{
					echo checking if ${NamedToHunt[${i}]} (${NamedDone[${i}]}) is already camped ?
					call CheckPlayerAtCoordinates ${NamedCoordinates[${i}]}
					if (${Return})
					{
						echo ${NamedToHunt[${i}]} is already camped - avoiding it
						call StopHunt
						return FALSE
					}
					else
					{
						echo Going to location of ${NamedToHunt[${i}]} at ${NamedCoordinates[${i}]} for camp 
						call navwrap ${NamedCoordinates[${i}]}
						if (${Grouped})
						{
							do
							{
								call GroupDistance
								if (${Return}>20)
								{
									eq2execute gsay "Please nav to me now !"
									wait 1200
								}
							}
							while (${Return}>20)
						}
						call CheckQuest "${QN}" ${Grouped}
						if (${Return})
						{	
							if (${Grouped})
								oc !c -CampSpot
							else
								oc !c -CampSpot ${Me.Name}
								
							call Campfor_NPC "${NamedToHunt[${i}]}" 1200
							NamedDone[${i}]:Set[${Return}]
							do
							{
								wait 10
								call CheckCombat
							}
							while (${Return})
							if (${Grouped})
								oc !c -letsgo
							else
								oc !c -letsgo ${Me.Name}
							call StopHunt
						}
					}
				}
			}
			echo checking if in Combat (2)
			do
			{
				wait 10
				call CheckCombat
			}
			while (${Return})
			Counter:Inc
			echo Timeout at ${Counter}/${Timeout}
			call CheckQuest "${QN}" ${Grouped}
		}
		while (${Return} && !${DoNotWait} && ${Counter}<${Timeout})
	}
	for ( i:Set[1] ; ${i} <= ${NamedToHunt.Used} ; i:Inc )
	{
		NamedDone:Remove[${i}]
		NamedToHunt:Remove[${i}]
		NamedCoordinates:Remove[${i}]
	}
	echo TheHunt terminated
}
function TheHarvest(string QuestName, int Timeout)
{

}

