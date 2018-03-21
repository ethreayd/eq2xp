function main(float MaxDistance)
{
    variable index:actor Actors
    variable iterator ActorIterator
    
    EQ2:QueryActors[Actors, Distance <= ${MaxDistance} ]
    Actors:GetIterator[ActorIterator]
  
    if ${ActorIterator:First(exists)}
    {
        do
        {
            echo "${ActorIterator.Value.Name}"
        }
        while ${ActorIterator:Next(exists)}
    }
}