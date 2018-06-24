#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main(int stepstart, int stepstop, int speed)
{
	; thanks to Kannkor for the index usage example
	variable index:string ScriptsToRun
	variable string sQN
	ScriptsToRun:Insert["Believe in Me"]
	ScriptsToRun:Insert["Some Testing Required"]
	ScriptsToRun:Insert["Noxiousity"]
	ScriptsToRun:Insert["A Caravan of Death"]
	ScriptsToRun:Insert["The Plaguebringer Cometh"]
	echo "Starting Bertoxxulous Devotion Quests quests"
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
    			runscript EQ2Ethreayd/Deities/${sQN} "${ScriptsToRun[${x}]}" ${stepstart} ${stepstop} ${speed}
        		wait 5
        		while ${Script[${sQN}](exists)}
            		wait 5
			echo ${ScriptsToRun[${x}]} finished
		}
	}
	echo "autopop ended normally" 
}






