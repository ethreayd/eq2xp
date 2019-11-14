#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) int GravelDoor
variable(script) string DoorArray[3]
variable(script) bool Killed = FALSE



function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{
	variable int laststep=10
	
	oc !c -letsgo ${Me.Name}
	;if (!${Script["livedierepeat"](exists)})
	;	run EQ2Ethreayd/livedierepeat ${NoShiny}
	if (${setspeed}==0)
	{
		speed:Set[3]
		FightDistance:Set[15]
	}
	else
		speed:Set[${setspeed}]
		
	echo speed set to ${speed}
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	;if (!${NoShiny})
	;	run EQ2Ethreayd/autoshinies 50 ${speed} 
 
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name} starting at step ${stepstart}/${stepstop}
	call waitfor_Zone "Vegarlson: Council's Stronghold [Solo]"
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]


	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_moveinfront","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkmana","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkmana",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_setup_moveintomeleerangemaxdistance",25]
	

	if (${stepstart}==0)
	{
		echo stepstart is zero - nothing to do
	}
	call check_quest "Elements of Destruction: Layers of Order"
	if (${Return})
	{
		OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",25]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
		Ob_AutoTarget:AddActor["Stone of Thudos",0,FALSE,FALSE]
	}
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["The Great Gravelly One"]
	eq2execute merc resume
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove 651 63 34 3
	call DMove 872 63 40 3
	call TanknSpank "${Named}"
}	
function step001()
{
	variable string Named
	Named:Set["Guardian of Gravel"]
	eq2execute merc resume
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call IsPresent "${Named}" 5000
	if (${Return})
	{
		eq2execute way ${Actor["${Named}"].X} ${Actor["${Named}"].Y} ${Actor["${Named}"].Z}
		call DMove 866 63 97 3
		call DMove 1022 63 137 3
		call DMove 1028 63 423 3
		call DMove 1410 63 418 3
		call DMove 1704 63 424 3
		call DMove 1843 63 424 3
		call DMove ${Actor["${Named}"].X} ${Actor["${Named}"].Y} ${Actor["${Named}"].Z} 3 30 TRUE
		call TanknSpank "${Named}"
		call DMove 1842 63 -349 3
		call DMove 1693 63 -352 3
		call DMove 1424 63 -349 3
		call DMove 1129 63 -351 3
		call DMove 1029 63 -351 3
		call DMove 1023 63 -190 3
		call DMove 1021 63 -52 3
		call DMove 936 63 -44 3
		call DMove 859 63 -15 3
		call DMove 872 63 40 3
	}
	call StopHunt
}	
function step002()
{
	variable int x
	eq2execute merc resume
	call DMove 872 63 40 1
	call DMove 913 63 39 3
	call ClickOn Door
	call DMove 940 63 40 3
	GravelDoor:Set[0]
	call ClickOn Pedestal
	call IsPresent "Room Portal 1" 100
	while (${GravelDoor}<3 && !${Return})
	{
		wait 10
	}
	call DMove 929 63 19 3
	call DMove 997 63 3 3
	call DMove 1000 63 36 3
	do
	{
		wait 10
		call IsPresent "Room Portal 1" 100
	}
	while (${GravelDoor}<3 && !${Return})
	call IsPresent "Room Portal 1" 100
	if (!${Return})
	{ 
		for ( x:Set[1] ; ${x} <= 3 ; x:Inc )
		{
			echo going to Door ${x} (${DoorArray[${x}]})
			if ${DoorArray[${x}].Equal["N"]}
				call DMove 999 63 0 3
			if ${DoorArray[${x}].Equal["S"]}
				call DMove 999 63 80 3
			if ${DoorArray[${x}].Equal["W"]}
				call DMove 1082 63 40 3
			
			call ClickOn Floor
			wait 20
			call DMove 1000 63 36 3
		}
	
	call DMove 951 63 41 3
	call DMove 947 63 40 1 30 FALSE FALSE 3
	call ClickOn Gravel
	wait 50
	}
	call DMove 1016 63 40 3
	call ClickOn Portal
	wait 30
}

function step003()
{
	variable string Named
	Named:Set["Guardian of Stones"]
	call StopHunt
	eq2execute merc resume
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	call DMove 1014 275 39 3
	call IsPresent "${Named}" 5000
	if (${Return})
	{
		eq2execute way ${Actor["${Named}"].X} ${Actor["${Named}"].Y} ${Actor["${Named}"].Z}
		call DMove 1013 275 79 3
		call check_quest "Elements of Destruction: Layers of Order"
		if (${Return})
		{
			OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
			Ob_AutoTarget:AddActor["Stone of Thudos",0,FALSE,FALSE]
		}
		call DMove 1025 275 85 3
		call DMove 1111 275 97 3
		call DMove 1107c 275 226 3
		call DMove 1113 275 331 3
		call DMove 1293 275 329 3
		call DMove 1327 275 345 3
		call DMove 1549 275 346 3
		call DMove 1744 275 336 3
		
		call DMove ${Actor["${Named}"].X} ${Actor["${Named}"].Y} ${Actor["${Named}"].Z} 3 30 TRUE
		call TanknSpank "${Named}"
		
		call DMove 1741 275 -256 3
		call DMove 1510 275 -265 3
		call DMove 1323 275 -265 3
		call DMove 1116 275 -252 3
		call DMove 1107 275 -126 3
		call DMove 1112 275 -19 3
		call DMove 1016 275 -4 3
		call DMove 1014 275 39 3 30 TRUE
		
	}
}
function step004()
{
	variable string Named
	Named:Set["Aggregahn"]
	call StopHunt
	eq2execute merc resume
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove 1032 275 40 3 30 TRUE
	call DMove 1083 275 40 3
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]
	call TanknSpank "${Named}" 50 FALSE FALSE TRUE
	call DMove 1083 275 40 1
	ogre
	wait 100
	call ClickOn Door
	call DMove 1106 275 40 3

}
function step005()
{
	variable int x
	eq2execute merc resume
	GravelDoor:Set[0]
	call ClickOn Pedestal
	wait 50
	call DMove 1098 275 20 3
	call DMove 1169 275 0 3
	call DMove 1170 275 35 3 
	do
	{
		wait 10
		call IsPresent "Room Portal 2" 100
	}
	while (${GravelDoor}<3 && !${Return})
	
	call IsPresent "Room Portal 2" 100
	if (!${Return})
	{
		for ( x:Set[1] ; ${x} <= 3 ; x:Inc )
		{
			echo going to Door ${x} (${DoorArray[${x}]})
			if ${DoorArray[${x}].Equal["N"]}
				call DMove 1171 275 0 3
			if ${DoorArray[${x}].Equal["S"]}
				call DMove 1171 275 80 3
			if ${DoorArray[${x}].Equal["W"]}
				call DMove 1252 275 39 3
			
			call ClickOn Floor
			wait 20
			call DMove 1170 275 35 3 
		}
		call DMove 1171 275 0 3
		call DMove 1114 275 38 3
		call DMove 1114 275 38 1 30 FALSE FALSE 3
		call ClickOn Stone
		wait 50
	}
	call DMove 1171 275 0 3
	call DMove 1189 275 37 3
	call ClickOn Portal
	wait 30
}
function step006()
{
	variable string Named
	Named:Set["cursed guard"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]
	
	
	call DMove 1131 465 40 3
	call DMove 1134 465 8 3
	call DMove 1210 465 -3 3
	call DMove 1211 465 -161 3
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove 1230 466 -179 3
	call TanknSpank "${Named}"
	ogre
	wait 100
	call check_quest "Elements of Destruction: Layers of Order"
	if (${Return})
	{
		OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",25]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	}
	call DMove 1235 465 -236 3
}
function step007()
{
	variable string Named
	Named:Set["Escargore"]
	eq2execute merc resume
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]

	call DMove 1212 439 -293 3
	call DMove 1156 378 -352 1
	call DMove 1104 319 -385 1
	call DMove 1027 266 -387 1
	call DMove 955 204 -401 3
	call DMove 887 153 -402 3
	call DMove 813 94 -394 3
	call DMove 755 47 -359 3
	call DMove 693 42 -339 3 30 TRUE FALSE 3
	call DMove 652 38 -355 3
	call DMove 641 15 -444 3
	call DMove 629 13 -463 3
	oc !c -CampSpot ${Me.Name} 1 200
	oc !c -joustin ${Me.Name}
	call TanknSpank "${Named}" 500
	call DMove 642 14 -451 3
	call ClickOn Portal
	wait 30
	call DMove 1248 465 40 3
	call ClickOn Door
}
function step008()
{
	variable bool Unfinished
	call StopHunt
	OgreBotAPI:CastAbility["${Me.Name}","Singular Focus"]
	eq2execute merc resume
	call DMove 1271 465 39 3
	call ClickOn Pedestal
	call DMove 1271 465 27 3
	call DMove 1290 465 38 3
	call TanknSpank "Stone of Thudos"
	do
	{
		Unfinished:Set[FALSE]
		call FightinMud "an earthly podwalker"
		call FightinMud "waters of Awuidor"
		call FightinMud "flit of radiance"
		call CountAdds "an earthly podwalker"
		if (${Return}>0)
			Unfinished:Set[TRUE]
		call CountAdds "waters of Awuidor"
		if (${Return}>0)
			Unfinished:Set[TRUE]
		call CountAdds "flit of radiance"
		if (${Return}>0)
			Unfinished:Set[TRUE]
	}
	while (${Unfinished})
	OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
	call DMove 1331 465 11 3
	call DMove 1332 466 24 3 FALSE FALSE 5
	call ActivateVerbOnPhantomActor "Take Ethereal Leaf" 1 5
	call ActivateVerbOnPhantomActor "Take Ethereal Leaf" 1 5
	call DMove 1353 466 39 3
	call ClickOn Portal
	wait 30
}
function step009()
{
	variable string Named
	Named:Set["Lesha Needleleaft"]
	eq2execute merc resume
	ogre
	wait 100
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	call DMove 1336 635 40 3
	call ClickOn Door
	call DMove 1357 635 40 3
	call ClickOn Pedestal
	call DMove 1355 635 33 3 FALSE FALSE 5
	call DMove 1395 635 25 3
	call DMove 1420 635 7 3
	call DMove 1501 635 40 3
	call DMove 1434 635 38 3
	call TanknSpank "${Named}"
	call DMove 1365 635 40 3
	call ClickOn Leaves
	wait 30
	call DMove 1438 635 39 3
	call ClickOn Portal
	wait 30
}
function step010()
{
	variable string Named
	eq2execute merc resume
	Named:Set["Council of Gravel"]
	call DMove 1432 785 41 3 TRUE
	call DMove 1432 785 89 3 TRUE
	target "${Named}"
	do
	{
		Me.Inventory[Query, Name =- "Severed Ethereal Gravel"]:Use
		wait 300
		call IsPresent "${Named}"
	}
	while (${Return})
	
	Named:Set["Council of Stone"]
	target "${Named}"
	do
	{
		Me.Inventory[Query, Name =- "Severed Ethereal Stones"]:Use
		wait 300
		call IsPresent "${Named}"
	}
	while (${Return})
	
	Named:Set["Council of Soil"]
	target "${Named}"
	do
	{
		;Me.Inventory[Query, Name =- "Severed Ethereal Soil"]:Use
		wait 300
		call IsPresent "${Named}"
	}
	while (${Return})
	
	Named:Set["Council of Leaves"]
	target "${Named}"
	do
	{
		Me.Inventory[Query, Name =- "Severed Ethereal Leaves"]:Use
		wait 300
		call IsPresent "${Named}"
	}
	while (${Return})
	eq2execute Summon
	
	call check_quest "Elements of Destruction: Layers of Order"
	if (${Return})
	{
		Me.Inventory[Query, Name =- "Inert Vegarlson Purifying Rune"]:Use
		wait 50
		call DMove 1432 785 41 3
		call DMove 1498 785 41 3
		call ClickOn Portal
		wait 30
		call DMove -37 121 24 3
		call DMove -69 121 22 3
		call DMove -91 121 25 3
		call DMove -120 116 25 3
		call DMove -159 116 28 3
		call DMove -163 116 29 1 30 FALSE FALSE 3
		call DMove -179 114 35 3
		call DMove -194 117 67 3
		call DMove -191 129 98 3
		call DMove -206 111 132 3
		call DMove -214 114 147 1
		call DMove -217 114 161 3 30 FALSE FALSE 5
		oc !c -Special
		call DMove -217 114 161 3 30 FALSE FALSE 5
		call DMove -208 110 123 3
		call DMove -174 122 144 3
		call DMove -197 119 49 3
		call DMove -178 115 36 3 30 FALSE FALSE 5
		call DMove -161 116 25 1 30 FALSE FALSE 5
		call DMove -113 116 24 3 30 FALSE FALSE 5
		do
		{
			wait 10
		}
		while (TRUE)
		
		echo this isn't done yet !!!
	}
	
	
	call DMove 1431 785 99 3
	call DMove 1431 784 109 3
	do
	{
		if (!${Zone.Name.Equal["Myrist, the Great Library"]})
		{
			call MoveCloseTo Exit
			oc !c -Zone	
		}
		wait 200
	}
	while (!${Zone.Name.Equal["Myrist, the Great Library"]})
}
function FightinMud(string ActorName)
{
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","FALSE"]
	call CountAdds "${ActorName}" 200
	if (${Return}>0)
	{
		Killed:Set[FALSE]
		do
		{
			oc !c -pause
			call DMove 1263 465 20 3
			call DMove 1295 465 28 3 30 TRUE 
			call DMove 1308 465 30 3 30 TRUE FALSE 3
			call DMove 1310 465 38 3 30 TRUE FALSE 3
			call DMove 1332 465 32 3 30 TRUE FALSE 3
			call CountAdds "${ActorName}" 200
			if (${Return} > 2 && !${Me.InCombat})
				target "${ActorName}"
			Killed:Set[FALSE]
			oc !c -resume
			do
			{
				wait 10
			}
			while (!${Killed})
			Killed:Set[FALSE]
			oc !c -pause
			call DMove 1332 465 66 3 30 TRUE FALSE 3
			oc !c -resume
			do
			{
				wait 10
			}
			while (!${Killed})
			Killed:Set[FALSE]
			oc !c -pause
			call DMove 1382 465 64 3 30 TRUE
			call DMove 1388 465 29 3 30 TRUE FALSE 3
			oc !c -resume
			do
			{
				wait 10
			}
			while (!${Killed})
			Killed:Set[FALSE]
			call DMove 1370 465 40 3
			call DMove 1311 465 38 3
			call DMove 1282 465 19 3
	
			call CountAdds "${ActorName}" 200
			echo "Return is ${Return}"
		}
		while (${Return}>0)
	}
}
atom HandleAllEvents(string Message)
{
	;echo event catched : ${Message}
	if (${Message.Find["ethereal gravel paths toward the NORTHERN door"]})
	{
		GravelDoor:Inc
		DoorArray[${GravelDoor}]:Set["N"]
		echo DoorArray[${GravelDoor}]:Set["N"]
	}
	if (${Message.Find["ethereal gravel paths toward the SOUTHERN door"]})
	{
		GravelDoor:Inc
		DoorArray[${GravelDoor}]:Set["S"]
		echo DoorArray[${GravelDoor}]:Set["S"]
	}
	if (${Message.Find["ethereal gravel paths toward the WESTERN door"]})
	{
		GravelDoor:Inc
		DoorArray[${GravelDoor}]:Set["W"]
		echo DoorArray[${GravelDoor}]:Set["W"]
	}
	if (${Message.Find["NORTHERN soldier of stone crumbles"]})
	{
		GravelDoor:Inc
		DoorArray[${GravelDoor}]:Set["N"]
		echo DoorArray[${GravelDoor}]:Set["N"]
	}
	if (${Message.Find["SOUTHERN soldier of stone crumbles"]})
	{
		GravelDoor:Inc
		DoorArray[${GravelDoor}]:Set["S"]
		echo DoorArray[${GravelDoor}]:Set["S"]
	}
	if (${Message.Find["WESTERN soldier of stone crumbles"]})
	{
		GravelDoor:Inc
		DoorArray[${GravelDoor}]:Set["W"]
		echo DoorArray[${GravelDoor}]:Set["W"]
	}
	if (${Message.Find["You have killed"]})
	{
		Killed:Set[TRUE]
	}
	if (${Message.Find["can destroy as easily as"]})
	{
		echo building wall of ethereal stones
		Me.Inventory[Query, Name =- "Ethereal Stones"]:Use
	}
}