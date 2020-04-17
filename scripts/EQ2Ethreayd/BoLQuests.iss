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
function LuclinLandscapingTheBlinding()
{
	variable index:string NamedToHunt
	variable int i
	
	QN:Set["Luclin Landscaping: The Blinding"]
	call CheckQuest "${QN}"
	if (${Return})
	{
		echo Doing "${QN}"
		call goZone "The Blinding"
		do
		{
			Echo looking for Quest Named...
			NamedToHunt:Insert["Novilog"]
			NamedToHunt:Insert["An Ancient Spectre"]
			NamedToHunt:Insert["A Greater Lightcrawler"]
			NamedToHunt:Insert["Cluster"]
			NamedToHunt:Insert["Cobblerock"]
			NamedToHunt:Insert["Ripperback"]
			NamedToHunt:Insert["Deathpetal"]
			for ( i:Set[1] ; ${i} <= ${NamedToHunt.Used} ; i:Inc )
			{
					call WhereIs ${NamedToHunt[${x}]} TRUE
					wait 10
					if (${Return})
					{
						
						call Hunt ${NamedToHunt[${x}]}
					}
			}
			call CheckQuest "${QN}"
		}
		while (${Return})
	}
}