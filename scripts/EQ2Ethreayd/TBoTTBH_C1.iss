#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	do
	{
		call DMove -1352 290 -1288 3
		call DMove -1350 291 -1304 1 30 FALSE FALSE 2
		call DMove -1317 297 -1304 3 30 FALSE TRUE 2
		call DMove -1315 298 -1313 3 30 FALSE TRUE 2
		call DMove -1297 296 -1326 3 30 FALSE TRUE 5
		call TestArrivalCoord -1297 296 -1326
	}
	while (!${Return})
}
