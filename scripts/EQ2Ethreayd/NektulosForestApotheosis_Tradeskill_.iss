#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	do
	{
		do
		{
			call RepairRift
			wait 20
			call IsPresent "crack in barrier"
		}
		while (${Return})
		wait 200
		call IsPresent "Ullkorruuk" 5000
	}
	while (${Return})
	call DMove -1356 21 -1389 3
}
function RepairRift()
{
	call DMove -1393 31 -1345 3
	wait 5
	oc !c -Special ${Me.Name}
	wait 20
	oc !c -Special ${Me.Name}
	wait 20
	call DMove -1381 25 -1379 3
	call IsPresent "crack in barrier"
	if (${Return})
		call MoveCloseTo "crack in barrier"
	wait 5
	call ActivateVerbOn "crack in barrier" "Repair Rift"
}