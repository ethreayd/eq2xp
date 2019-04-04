#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	echo launching assistant script TBoTTBH_C2 to go to teleporter
	
	call Go2D 710 199 -718 10 TRUE
	wait 100
	if (${Me.Loc.X}<800)
	do
	{
		call MoveCloseTo "floor_diode_any_enchanter"
		call PKey MOVEFORWARD 1
		wait 50
	}
	while (${Me.Loc.X}<800)
}
