#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"


function main(float MaxDistance, bool Detail)
{
    call ListActors ${MaxDistance} ${Detail}
}