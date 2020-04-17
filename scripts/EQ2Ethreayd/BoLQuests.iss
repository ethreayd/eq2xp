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

function LuclinLandscapingTheBlinding(bool DoNotWait)
{
	variable index:string NamedToHunt
	variable index:string NamedCoordinates
	variable index:bool NamedDone
	variable int i
	variable int x
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
	call CheckQuest "${QN}"
	if (${Return})
	{
		echo Doing "${QN}"
		call goZone "The Blinding"
		do
		{
			Echo looking for Quest Named...
			
			for ( i:Set[1] ; ${i} <= ${NamedToHunt.Used} ; i:Inc )
			{
					call WhereIs "${NamedToHunt[${i}]}" TRUE
					echo testing "${NamedToHunt[${i}]}" (${NamedDone[${i}]}) : ${Return}
					wait 10
					if (${Return} && !${NamedDone[${i}]})
					{
						echo Found "${NamedToHunt[${i}]}" at ${NamedCoordinates[${i}]} 
						call Hunt "${NamedToHunt[${i}]}"
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
			call CheckQuest "${QN}"
			if (${Return} && !${DoNotWait})
			{
				x:Set[${Math.Calc64[${Math.Rand[${NamedToHunt.Used}]}]}]
				echo got ${x}
				if (!${NamedDone[${x}]})
				{
					echo Going to location of ${NamedToHunt[${x}]} at ${NamedCoordinates[${x}]} for camp 
					call navwrap ${NamedCoordinates[${x}]}
					call Campfor_NPC "${NamedToHunt[${x}]}"
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
			call CheckQuest "${QN}"
		}
		while (${Return} && !${DoNotWait})
	}
}