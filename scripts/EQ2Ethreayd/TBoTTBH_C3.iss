#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	echo launching assistant script TBoTTBH_C3 to get down
	
	do
	{
		face 701 -565
		press -hold MOVEFORWARD
		wait 20
		press JUMP
		wait 10
		press JUMP
		press -release MOVEFORWARD
		wait 100
	}
	while (${Me.Loc.Y}>0)
	press JUMP
}
