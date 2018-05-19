#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreCommon/EQ2OgreObjects/Object_Get_SpewStats.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(global) Object_Get_SpewStats MyFaction_Get_SpewStats
variable(script) int64 iFaction
;You need OGRE IN DEV VERSION FOR THE FACTION CHECK (HENCE THIS WHOLE SCRIPT) TO WORK !!!!
function main(int stepstart, int stepstop, int speed)
{
	; thanks to Kannkor for the index usage example
	variable index:string ScriptsToRun
	variable string sQN
	ScriptsToRun:Insert["Legacy of Power: Secrets in an Arcane Land"]
	ScriptsToRun:Insert["Legacy of Power: Hero's Devotion"]
	ScriptsToRun:Insert["Legacy of Power: An Innovative Approach"]
	ScriptsToRun:Insert["Legacy of Power: Realm of the Plaguebringer"]
	ScriptsToRun:Insert["Legacy of Power: Through Storms and Mists"]
	ScriptsToRun:Insert["Legacy of Power: Glimpse of the Hereother"]
	ScriptsToRun:Insert["Legacy of Power: Drawn to the Fire"]
	ScriptsToRun:Insert["Legacy of Power: Deep Trouble"]
	echo "Starting PoP quests"
	echo " ${ScriptsToRun.Used} are supported"
	
	
	variable int x
	for ( x:Set[1] ; ${x} <= ${ScriptsToRun.Used} ; x:Inc )
	{
        	echo Running script ${ScriptsToRun[${x}]}
		;Thanks to Pork for the quest check
		if (${QuestJournalWindow.CompletedQuest["${ScriptsToRun[${x}]}"](exists)})
		{
			echo "Quest ${ScriptsToRun[${x}]} already done"
		}
		else
		{
			call strip_QN "${ScriptsToRun[${x}]}"
			sQN:Set[${Return}]
			echo will run "${ScriptsToRun[${x}]}" step ${stepstart} Now !
    			runscript EQ2Ethreayd/${sQN} "${ScriptsToRun[${x}]}" ${stepstart} ${stepstop} ${speed}
        		wait 5
        		while ${Script[${sQN}](exists)}
            		wait 5
			echo ${ScriptsToRun[${x}]} finished
		}
	}
	echo "autopop ended normally" 
}






