#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main(float Distance)
{
	variable index:actor Actors
    variable iterator ActorIterator
    EQ2:QueryActors[Actors]
    Actors:GetIterator[ActorIterator]
	if (${Distance}<1)
		Distance:Set[5000]
    if ${ActorIterator:First(exists)}
    {       
		do
		{
			if (${ActorIterator.Value.Name.Equal[""]} && ${ActorIterator.Value.Distance}<${Distance})
				{
					echo Found an empty Actor (ID:${ActorIterator.Value.ID}) at ${ActorIterator.Value.Distance} m
					call DescribeActor ${ActorIterator.Value.ID}
				}	
		}
        while (${ActorIterator:Next(exists)})
	}	
}