#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"


function main(float MaxDistance, bool Detail)
{
    variable index:actor Actors
    variable iterator ActorIterator
    
    EQ2:QueryActors[Actors, Distance <= ${MaxDistance} ]
    Actors:GetIterator[ActorIterator]
  
    if ${ActorIterator:First(exists)}
    {
        do
        {
            echo "${ActorIterator.Value.Name}" [${ActorIterator.Value.ID}] (${ActorIterator.Value.Distance} m)
			if ${Detail}
				call DescribeActor ${ActorIterator.Value.ID}

        }
        while ${ActorIterator:Next(exists)}
    }
}