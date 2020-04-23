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

function LuclinLandscapingTheBlinding(bool DoNotWait)
{
	NamedToHunt:Insert["Novilog"]
	NamedCoordinates:Insert["-106 307 -811"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["An Ancient Spectre"]
	NamedCoordinates:Insert["434 348 -505"]
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
	call TheHunt ${DoNotWait}
}


function LuclinLandscapingAurelianCoast(bool DoNotWait)
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
	NamedToHunt:Insert["The Great Sensate"]
	NamedCoordinates:Insert["354 43 556"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Va Din Ra"]
	NamedCoordinates:Insert["-559 34 766"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Xi Xaui"]
	NamedCoordinates:Insert["-496 61 946"]
	NamedDone:Insert[FALSE]
	QN:Set["Luclin Landscaping: Aurelian Coast"]
	QZ:Set["Aurelian Coast"]
	call TheHunt ${DoNotWait}
}
function TheHunt(bool DoNotWait, int Timeout)
{
	variable int i
	variable int x
	variable int Counter
	variable bool GoHunt
	variable bool Grouped
	if (${Timeout}<1)
		Timeout:Set[10]
	if (${Me.GroupCount}>2)
		Grouped:Set[TRUE]
	else
		Grouped:Set[FALSE]
		
	echo call CheckQuest "${QN}" ${Grouped}

	call CheckQuest "${QN}" ${Grouped}
	
	if (${Return})
	{
		echo Doing "${QN} (Grouped : ${Grouped})"
		call goZone "${QZ}"
		wait 50
		if (${Me.GroupCount}>2)
		{
			echo I am doing a Group Hunt
			Grouped:Set[TRUE]
			Me.Inventory[Query, Name =- "Tactical Rally Banner"]:Use
			wait 50
			echo All group should now come here
			oc !c -UseFlag
			echo waiting 30s for the group to zone
			wait 300
			call waitfor_Group
			wait 50
			call WaitforGroupDistance 20
			oc !c -letsgo
			oc !c -OgreFollow All ${Me.Name}
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
					}
					else
						GoHunt:Set[TRUE]
				}
				else
					GoHunt:Set[FALSE]
				wait 10
				if (${GoHunt} && !${NamedDone[${i}]})
				{
					echo Found "${NamedToHunt[${i}]}" at ${NamedCoordinates[${i}]}
					if (${Grouped})
						oc !c -Resume
					else
						oc !c -Resume ${Me.Name}
					call navwrap ${NamedCoordinates[${i}]}
					call Campfor_NPC "${NamedToHunt[${i}]}"
					NamedDone[${i}]:Set[TRUE]
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
				x:Set[${Math.Calc64[${Math.Rand[${NamedToHunt.Used}]}+1]}]
				echo got ${x}
				if (!${NamedDone[${x}]})
				{
					echo Going to location of ${NamedToHunt[${x}]} at ${NamedCoordinates[${x}]} for camp 
					call navwrap ${NamedCoordinates[${x}]}
					call Campfor_NPC "${NamedToHunt[${x}]}" 1200
					NamedDone[${x}]:Set[${Return}]
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
}
