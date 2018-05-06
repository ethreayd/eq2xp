#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool Windy

function main(int stepstart, int stepstop, int setspeed)
{

	variable int laststep=14
	
	oc !c -letsgo ${Me.Name}
	if (${setspeed}==0)
	{
		if (${Me.Archetype.Equal["fighter"]} || ${Me.Archetype.Equal["priest"]})
		{
			echo I am a fighter
			speed:Set[3]
			FightDistance:Set[15]
		}
		else
		{
			echo I am a healer
			speed:Set[1]
			FightDistance:Set[30]
		}
	}
	else
		speed:Set[${setspeed}]
		
	echo speed set to ${speed}
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Torden, Bastion of Thunder: Winds of Change [Solo]"

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
		;call IsPresent "Auliffe Chaoswind" 1000
		;if (!${Return})
		;{
	;		call IsPresent "Gaukr Sandstorm" 1000
	;		if (!${Return})
	;		{
	;			echo zone empty
	;			call step012
	;			return
	;		}
		
	;		call check_quest "Legacy of Power: Through Storms and Mists"
	;		if (${Return})
	;		{
	;			call CountItem "frostbite crystal"
	;			if (${Return}>0)
	;			{
	;				call DMove 0 10 -502 3
	;				call DMove 15 11 -515 3
	;				call DMove 10 10 -540 3
	;				stepstart:Set[4]
	;			}
	;		}
	;		else
	;		{
	;			call DMove 0 10 -502 3
	;			call DMove 15 11 -515 3
	;			call DMove 10 10 -540 3
	;			stepstart:Set[4]
	;		}
	;	}
	}
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["Elif Whitewind"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove 0 -20 122 3
	call DMove -3 5 312 3
	call DMove -5 10 434 ${speed} ${FightDistance}
	echo must kill "${Named}"
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
		
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	call DMove 0 10 545 3
}	

function step001()
{
	eq2execute merc resume

	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -20 10 557 ${speed} ${FightDistance}
	call DMove -49 10 639  ${speed} ${FightDistance}
	call DMove -210 11 644 ${speed} ${FightDistance}
	call DMove -281 5 641 ${speed} ${FightDistance}
	;you need to have a global bool variable called Windy to use this function
	call WalkWithTheWind -545 -17 634
}	
	
function step002()
{
	variable string Named
	Named:Set["The Hurricane"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	Ob_AutoTarget:Clear
	
	echo must kill "${Named}"
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	do
	{
		wait 10
		call IsPresent "${Named}" 500
	}
	while (${Return})
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step003()
{
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call WalkWithTheWind -273 5 637
}

function step004()
{
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -280 5 665 ${speed} ${FightDistance}
	call DMove -271 9 683 ${speed} ${FightDistance}
	call Converse "Wind Spirit" 2
	wait 200
}
	
function step005()
{
	variable string Named
	Named:Set["Bastion windcaller"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	call DMove -600 38 731 ${speed} ${FightDistance}
	do
	{
		wait 10
		call IsPresent "${Named}" 50
	}
	while (${Return})
	
	call DMove -614 38 737 ${speed} ${FightDistance}
	call Converse "Wind Spirit" 2
	wait 200
	
	call DMove -570 90 539 ${speed} ${FightDistance}
	do
	{
		wait 10
		call IsPresent "${Named}" 50
	}
	while (${Return})
	
	call DMove -565 90 550 ${speed} ${FightDistance}
	call Converse "Wind Spirit" 2
	wait 200
	
	call DMove -729 145 534 ${speed} ${FightDistance}
	do
	{
		wait 10
		call IsPresent "${Named}" 50
	}
	while (${Return})
	
	call Converse "Wind Spirit" 2
	wait 200
	
	call DMove -755 198 709 ${speed} ${FightDistance}
	do
	{
		wait 10
		call IsPresent "${Named}" 50
	}
	while (${Return})
	
	call Converse "Wind Spirit" 2
	wait 1000
	
	
}

function step006()
{
	variable string Named
	Named:Set["Yveti Stormbrood"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	OgreBotAPI:AutoTarget_SetScanHeight["${Me.Name}",30]

	call DMove -662 310 634 3
	call DMove -552 341 521 3
	call DMove -502 341 482 3
	call DMove -527 341 488 3
		
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}" 500 TRUE
		if (${Actor["${ActorName}"].Distance}<50)
			call MoveCloseTo "${ActorName}"
		wait 50
		call DMove -527 341 488 3
	}
	while (${Return})
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step007()
{
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -552 341 521 3
	call DMove -662 310 634 3

	if (${Me.Loc.X}>-680)
	{
		do
		{
			call MoveCloseTo "floor_diode_any_enchanter"
			call PKey MOVEFORWARD 1
			wait 50
		}
		while (${Me.Loc.X}>-680)
	}
	wait 50
	face -699 707
	press -hold MOVEFORWARD
	wait 20
	press JUMP
	wait 10
	press JUMP
	press -release MOVEFORWARD
	wait 100
	call getChest "Yveti Stormbrood's Treasure"
	call DMove -778 -17 678 3
	call getChest "Yveti Stormbrood's Treasure"
	call DMove -776 -17 585 3
	call getChest "Yveti Stormbrood's Treasure"
	call DMove -729 -17 526 3
	call getChest "Yveti Stormbrood's Treasure"
	call DMove -597 -17 526 3
	call getChest "Yveti Stormbrood's Treasure"
	call DMove -539 -17 628 3
	call getChest "Yveti Stormbrood's Treasure"
	call DMove -539 -17 628 3
}
	
function step008()
{
	call WalkWithTheWind -273 5 637
	call DMove -64 11 -657 3
	call DMove -23 10 555 3
}

function step009()
{
	variable string Named
	Named:Set["Laef Windfall"]
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -4 10 546 3
	call DMove 22 10 557 3
	call DMove 47 10 641 3
	call DMove 231 12 646 3
	call DMove 283 5 638 ${speed} ${FightDistance}
	call DMove 553 -17 635 ${speed} ${FightDistance}
	
	oc !c -CampSpot ${Me.Name}
	oc !c -joustout ${Me.Name}
	
	Ob_AutoTarget:Clear
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}" 500
	}
	while (${Return})
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	oc !c -letsgo ${Me.Name}
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step010()
{
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove 578 -17 731 3
	call DMove 674 -17 756 3
	call DMove 725 -17 698 ${speed} ${FightDistance}
	call DMove 752 -17 704 ${speed} ${FightDistance}
	call DMove 729 -12 738 ${speed} ${FightDistance}
	call DMove 642 32 759 ${speed} ${FightDistance}
	call DMove 603 38 727 ${speed} ${FightDistance}
	call DMove 576 38 728 ${speed} ${FightDistance}
	call DMove 521 72 639 ${speed} ${FightDistance}
	call DMove 547 89 562 ${speed} ${FightDistance}
	call DMove 594 90 527 ${speed} ${FightDistance}
	call DMove 636 109 485 ${speed} ${FightDistance}
	call DMove 709 140 503 ${speed} ${FightDistance}
	call DMove 730 145 554 ${speed} ${FightDistance}
	call DMove 789 155 586 ${speed} ${FightDistance}
	call DMove 795 192 670 ${speed} ${FightDistance}
	call DMove 746 198 728 ${speed} ${FightDistance}
	call DMove 725 198 722 3
	
	if (${Me.Loc.X}<800)
	{
		do
		{
			call MoveCloseTo "floor_diode_any_enchanter"
			call PKey MOVEFORWARD 1
			wait 50
		}
		while (${Me.Loc.X}<800)
	}

	call DMove 873 341 797 3
}

function step011()
{
	echo "waiting for best moment to move on"
	do
	{
		wait 10
	}
	while (${Actor["a lightning titan"].X} >820)
	echo "GO GO GO"
	call DMove 813 341 733 3 5 TRUE TRUE 
}
function step012()
{
	variable string Named1
	variable string Named2
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	Named1:Set["Torstien Stoneskin"]
	Named2:Set["Hreidar Lynhillig"]
		
	call DMove 791 341 757 ${speed} ${FightDistance}
	call DMove 692 309 662 ${speed} ${FightDistance}
	Ob_AutoTarget:Clear
	Ob_AutoTarget:AddActor["${Named1}",90,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named2}",90,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named1}",80,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named2}",80,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named1}",70,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named2}",70,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named1}",60,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named2}",60,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named1}",50,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named2}",50,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named1}",40,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named2}",40,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named1}",30,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named2}",30,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named1}",20,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named2}",20,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named1}",10,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named2}",10,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named1}",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named2}",0,TRUE,FALSE]
		
	call DMove 699 309 603 ${speed} ${FightDistance}
	call DMove 686 309 658 3
	call DMove 624 309 661 ${speed} ${FightDistance}
	call DMove 686 309 658 3
	
	oc !c -CampSpot ${Me.Name}
	oc !c -joustout ${Me.Name}
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	
	echo must kill "${Named1}" & ""${Named2}" 
	
	oc !c -CS_Set_ChangeRelativeCampSpotBy ${Me.Name} -60 0 -60
	
	do
	{
		wait 10
		call IsPresent "${Named1}"
	}
	while (${Return})
	
	do
	{
		wait 10
		call IsPresent "${Named2}"
	}
	while (${Return})
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	oc !c -letsgo ${Me.Name}
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
function step013()
{
	call StopHunt
	
	call DMove 634 309 609 3
	call ActivateVerb "Zone to Bottom" 634 309 609 "Return to Bottom of Tower" TRUE
	wait 50
	call DMove 618 -17 708 3
	wait 50
	call DMove 563 -17 695 3
	call DMove 540 -17 640 3
	call DMove 511 -10 634 3
	call DMove 268 5 638 3
	call DMove 46 10 645 3
	call DMove 5 10 545 3
}
function step014()
{
	variable string Named
	
	call DMove -5 10 359 3
	call DMove 0 -3 281 3
	call DMove 0 0 2 3
	call check_quest "Legacy of Power: Through Storms and Mists"
	if (${Return})
	{
		call DMove -63 -16 -7 3
		call DMove -65 -16 -20 3
		wait 50
		call Converse "Klodsag" 10 TRUE
		OgreBotAPI:AcceptReward["${Me.Name}"]
		OgreBotAPI:AcceptReward["${Me.Name}"]
		wait 50
		call DMove -60 -16 0 3
		call DMove -157 -19 -1 3
		call ActivateVerb "teleporter to Tower of the Rainkeeper" -157 -19 -1 "Teleport" TRUE
		wait 100
		Named:Set["Primordial Malice"]
		eq2execute merc resume
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
		Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
		OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
		OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
		
		call DMove -25 995 -144 ${speed} ${FightDistance}
		call DMove -25 992 -88 ${speed} ${FightDistance}
		call DMove -20 992 -25 ${speed} ${FightDistance}
		call DMove -27 995 6 ${speed} ${FightDistance}
		call DMove -62 995 -22 ${speed} ${FightDistance}
		call DMove -78 995 -69 ${speed} ${FightDistance}
		call DMove -99 994 -64 ${speed} ${FightDistance}
		call DMove 22 995 -68 ${speed} ${FightDistance}
		call DMove -25 992 -6 ${speed} ${FightDistance}
		call DMove -29 994 85 ${speed} ${FightDistance}
		wait 1200
		call DMove -24 995 86 ${speed} ${FightDistance}
		call Converse "Karana" 10 TRUE
		wait 1200
	}
	else
	{
		call ActivateVerb Exit" 0 0 -3 "To the Coliseum of Valor" TRUE
		wait 300
	}
}
 
atom HandleAllEvents(string Message)
 {
	;echo Catch Event ${Message}
	if (${Message.Find["has killed you"]} > 0 || ${Message.Find["you have died"]} > 0)
	{
		echo "I am dead"
		if ${Script["livedierepeat"](exists)}
			endscript livedierepeat
		run EQ2Ethreayd/livedierepeat
	}
	if (${Message.Find["feel unsteady on your feet"]} > 0)
	{
		Windy:Set[TRUE]
	}
 }