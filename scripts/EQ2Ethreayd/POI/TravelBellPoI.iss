function goto_HrathEverstill(bool Direct)
{
	call CheckZone "Timorous Deep"
	if (${Return})
	{
		if (!${Direct})
			call goto_ParserTalaklaDihdi
		call DMove 2612 120 1157 3
		call DMove 2602 120 1127 3
		call DMove 2612 120 1116 3 30 FALSE FALSE 5
		call DMove 2598 120 1111 3 30 FALSE FALSE 5
		call DMove 2590 120 1094 3 30 FALSE FALSE 5
		call DMove 2541 114 1056 3 
		call DMove 2585 118 1031 3
		call DMove 2621 118 1046 3
		call DMove 2629 116 1075 3
		call DMove 2644 117 1085 3
		call DMove 2634 121 1108 3
		call DMove 2638 121 1114 3 30 FALSE FALSE 3
	}
}
function goto_GorowynGrotto(bool Direct)
{
	call CheckZone "Timorous Deep"
	if (${Return})
	{
		call 3DNav 2373 28 1363
		call GoDown
		call DMove 2414 22 1330 3
	}
}
function goto_EralokRizrok(bool Direct)
{
	call CheckZone "Timorous Deep"
	if (${Return})
	{
		if (!${Direct})
			call goto_GorowynGrotto
		call DMove 2437 21 1354 3 30 FALSE FALSE 5
		call DMove 2452 27 1367 3
		call DMove 2463 27 1339 3
		call DMove 2477 29 1328 3
		call DMove 2493 34 1342 3
		call DMove 2486 34 1345 3 30 FALSE FALSE 5
	}
}
function goto_ParserTalaklaDihdi(bool Direct)
{
	call CheckZone "Timorous Deep"
	if (${Return})
	{
		if (!${Direct})
			call goto_TD_TeleporterDown
		call 3DNav 2603 65 1219
		call 3DNav 2630 65 1200
		call 3DNav 2661 150 1143
		call GoDown
		call DMove 2632 120 1141 3
		call DMove 2631 120 1162 3
		call DMove 2627 120 1176 3
		call DMove 2610 120 1181 3
	}
}
function goto_ParserVoldikMylisok(bool Direct)
{
	call CheckZone "Timorous Deep"
	if (${Return})
	{
		if (!${Direct})
			call goto_ParserTalaklaDihdi
		call 3DNav 2696 139 1174
		call GoDown
		call DMove 2699 107 1196 3
		call DMove 2704 107 1187 3 30 FALSE FALSE 5
	}
}		
function goto_PrimeParserTolokKuele(bool Direct)
{
	call CheckZone "Timorous Deep"
	if (${Return})
	{
		if (!${Direct})
			call goto_ParserTalaklaDihdi
		call DMove 2600 120 1181 3
	}
}		
		
		
		
function goto_TD_TeleporterDown(bool Direct)
{
	call CheckZone "Timorous Deep"
	if (${Return})
	{
		if (!${Direct})
			call goto_GorowynGrotto
		call DMove 2481 12 1235 3
		call DMove 2523 11 1233 3
		call DMove 2526 11 1225 3
	}
}