#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"
function main(string questname)
{
    variable index:quest Quests
    variable iterator It
    variable int NumQuests
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Active Quests
    NumQuests:Set[${QuestJournalWindow.NumActiveQuests}]
    
    if (${NumQuests} < 1)
    {
        echo "No active quests found."
        return
    }
        
    echo "Your character currently has ${NumQuests} active quests."
    
    QuestJournalWindow:GetActiveQuests[Quests]
    Quests:GetIterator[It]
    if ${It:First(exists)}
    {
		do
        {
			;echo "- ${It.Value.Name}"
			if (${It.Value.Name.Equal["${questname}"]})
			{
				echo "-----"
				echo "- ${It.Value.Name}"
				echo "-- ID: ${It.Value.ID}"
				echo "-- Level: ${It.Value.Level}"
				echo "-- Category: ${It.Value.Category}"
				echo "-- Current Zone: ${It.Value.CurrentZone}"
				QuestJournalWindow.ActiveQuest["${questname}"]:MakeCurrentActiveQuest
            }
        }
        while ${It:Next(exists)}
    }
    ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    echo "==============================="
	call CurrentQuestDetails
    
}

function CurrentQuestDetails()
{
    variable index:collection:string Details    
    variable iterator DetailsIterator
    variable int DetailsCounter = 0
    
    echo "Journal Current Quest:"
    echo "- Name: ${QuestJournalWindow.CurrentQuest.Name.GetProperty["LocalText"]}"
    echo "- Level: ${QuestJournalWindow.CurrentQuest.Level.GetProperty["LocalText"]}"
    echo "- Category: ${QuestJournalWindow.CurrentQuest.Category.GetProperty["LocalText"]}"
    echo "- CurrentZone: ${QuestJournalWindow.CurrentQuest.CurrentZone.GetProperty["LocalText"]}"
    echo "- TimeStamp: ${QuestJournalWindow.CurrentQuest.TimeStamp.GetProperty["LocalText"]}"
    echo "- MissionGroup: ${QuestJournalWindow.CurrentQuest.MissionGroup.GetProperty["LocalText"]}"
    echo "- Status: ${QuestJournalWindow.CurrentQuest.Status.GetProperty["LocalText"]}"
    echo "- ExpirationTime: ${QuestJournalWindow.CurrentQuest.ExpirationTime.GetProperty["LocalText"]}"
    echo "- Body: ${QuestJournalWindow.CurrentQuest.Body.GetProperty["LocalText"]}"
    
    QuestJournalWindow.CurrentQuest:GetDetails[Details]
    Details:GetIterator[DetailsIterator]
    echo "- Details:"
    if (${DetailsIterator:First(exists)})
    {
        do
        {
            if (${DetailsIterator.Value.FirstKey(exists)})
            {
                do
                {
                    echo "-- ${DetailsCounter}::  '${DetailsIterator.Value.CurrentKey}' => '${DetailsIterator.Value.CurrentValue}'"
					if (${DetailsIterator.Value.CurrentKey.Equal["Check"]} && ${DetailsIterator.Value.CurrentValue.Equal["false"]})
						echo I am at step ${DetailsCounter}

                }
                while ${DetailsIterator.Value.NextKey(exists)}
                echo "------"
            }
            DetailsCounter:Inc
        }
        while ${DetailsIterator:Next(exists)}
    }
}

