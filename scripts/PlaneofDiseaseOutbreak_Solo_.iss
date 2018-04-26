#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"

variable(script) int speed
variable(script) int FightDistance

function main(int stepstart, int stepstop, int setspeed)
{
	variable int laststep=9
	
	oc !c -letsgo ${Me.Name}
	if (${setspeed}==0)
	{
		if (${Me.Archetype.Equal["fighter"]})
		{
			speed:Set[3]
			FightDistance:Set[15]
		}
		else
			speed:Set[1]
		{
			FightDistance:Set[30]
		}
	}
	else
		speed:Set[${setspeed}]
		
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Plane of Disease: Outbreak [Solo]"
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_moveinfront","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_setup_moveintomeleerangemaxdistance",25]

	
	if (${stepstart}==0)
	{
		;Trying to auto start at the right step
		call IsPresent "Felkruk" 500
		if  (!${Return})
		{
			echo "No Felkruk detected"
			Me.Inventory["Springview Healer Mask"]:Use
			stepstart:Set[3]
			call IsPresent "The Carrion Larva" 500
			if  (!${Return})
			{
				echo "No Carrion detected"
				Me.Inventory["Hirudin Extract"]:Use
				call DMove 526 63 -92 3 ${FightDistance}
				stepstart:Set[5]
			}
		}
	}
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	wait 20
	eq2execute merc resume
	call DMove 545 83 43 3
	call DMove 568 82 27 3
	call StopHunt
	call Converse "Velya" 9
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 562 83 39 3
	call DMove 532 82 35 3
	call StopHunt
	call Converse "Felkruk" 16
}

function step001()
{
	variable string Named
	Named:Set["Springview Healer"]
	eq2execute merc resume
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call ActivateVerb "crypt_1" 548 83 61 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_2" 569 83 55 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_3" 571 83 37 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_4" 564 83 34 "Reach for the crypt" TRUE TRUE
	call DMove 564 83 37 1
	call ActivateVerb "crypt_5" 552 83 34 "Reach for the crypt" TRUE TRUE
	call DMove 535 83 40 3
	call ActivateVerb "crypt_11" 535 76 7 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_16" 524 77 6 "Reach for the crypt" TRUE TRUE
	call DMove 530 75 1 3
	call ActivateVerb "crypt_12" 538 73 -11 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_17" 524 73 -13 "Reach for the crypt" TRUE TRUE
	call DMove 530 70 -24 3
	call ActivateVerb "crypt_13" 539 70 -30 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_18" 521 70 -30 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_14" 537 68 -46 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_15" 537 68 -46 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_20" 518 68 -47 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_19" 518 68 -47 "Reach for the crypt" TRUE TRUE
	call DMove 530 67 -50 3
	call DMove 530 83 44 3
	call ActivateVerb "crypt_10" 508 83 36 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_9" 499 83 34 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_8" 489 83 41 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_7" 487 83 48 "Reach for the crypt" TRUE TRUE
		
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","TRUE"]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	call ActivateVerb "crypt_6" 510 83 63 "Reach for the crypt" TRUE TRUE
	
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	OgreBotAPI:AcceptReward["${Me.Name}"]
	Call StopHunt
}	

function step002()
{
	variable string Named
	Named:Set["Felkruk"]
	eq2execute merc resume

	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove 533 82 34 ${speed} ${FightDistance}
	call DMove 534 68 -43 ${speed} ${FightDistance}
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	echo must kill "${Named}"
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
	Me.Inventory["Springview Healer Mask"]:Use
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step003()
{
	variable string Named
	Named:Set["Primordial Malice"]
	eq2execute merc resume
	Me.Inventory["Springview Healer Mask"]:Use
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	
	call DMove 531 83 53 ${speed} ${FightDistance}
	call DMove 524 67 -113 ${speed} ${FightDistance}
	call DMove 570 72 -62 ${speed} ${FightDistance}
	call DMove 524 67 -113 ${speed} ${FightDistance}
	call DMove 495 63 -152 ${speed} ${FightDistance}
	call DMove 500 66 -110 ${speed} ${FightDistance}
	call DMove 509 69 -71 ${speed} ${FightDistance} 
	call DMove 487 63 -187 ${speed} ${FightDistance} 
	call DMove 437 63 -235 ${speed} ${FightDistance} 
	call DMove 366 65 -263 ${speed} ${FightDistance} 
	call DMove 328 63 -330 ${speed} ${FightDistance} 
	call DMove 293 71 -323 ${speed} ${FightDistance} 
}


function step004()
{
	variable string Named
	Named:Set["The Carrion"]
	eq2execute merc resume
		
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove 246 63 -353 ${speed} ${FightDistance}
	call DMove 162 72 -355 ${speed} ${FightDistance}
	call DMove 150 78 -336 ${speed} ${FightDistance}
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Malarian Larva",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	call DMove 125 72 -363 ${speed} ${FightDistance}
	
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "Malarian Larva"
	}
	while (${Return})
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	Me.Inventory["Hirudin Extract"]:Use
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call DMove 296 71 -323 3 ${FightDistance} TRUE
}

function step005()
{
	variable string Named
	Named:Set["pusling leaker"]
	eq2execute merc resume
	call StopHunt
	
	Ob_AutoTarget:AddActor["${Named}",0,FALSE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
   	
	
	call DMove 308 97 -243 3 ${FightDistance} TRUE
	call DMove 276 113 -217 3 ${FightDistance} TRUE
	call DMove 271 176 -146 3 ${FightDistance} TRUE
	wait 100
	call CheckCombat
	call DMove 196 159 -219 3 ${FightDistance} TRUE
	call DMove 147 188 -235 3 ${FightDistance} TRUE
	call DMove 113 218 -199 3 ${FightDistance} TRUE
	call DMove 120 246 -141 3 ${FightDistance} TRUE
	call DMove 257 321 -111 3 ${FightDistance} TRUE
	call DMove 283 338 -84 3 ${FightDistance} TRUE
	call DMove 285 371 -24 3 ${FightDistance} TRUE
	call DMove 250 392 4 3 ${FightDistance} TRUE

	eq2execute summon
	wait 600
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
	
function step006()
{	
	variable string Named
	Named:Set["The Flesh Eater"]
	eq2execute merc resume
	call StopHunt
	
	Me.Inventory["Hirudin Extract"]:Use
	wait 20
	;Ob_AutoTarget:AddActor["putrid pile of flesh",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
   
	call DMove 227 392 10 2
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
   	echo must kill "${Named}"
	call DMove 193 394 -4 3
	oc !c -CampSpot ${Me.Name}
	oc !c -joustin ${Me.Name}
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	oc !c -letsgo ${Me.Name}
	call StopHunt
	eq2execute summon
	wait 300
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 291 360 -41 3 ${FightDistance}
	call DMove 276 333 -102 3 ${FightDistance}
	call DMove 131 252 -131 3 ${FightDistance}
	call DMove 107 226 -190 3 ${FightDistance}
	call DMove 165 181 -238 3 ${FightDistance}
	call DMove 271 118 -205 3 ${FightDistance}
	call DMove 304 71 -330 3 ${FightDistance}
}
	
function step007()
{	
	variable string Named
	Named:Set["High Dragoon V'Aliar"]
	eq2execute merc resume	
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove 130 73 -354 3 ${FightDistance}
	call DMove 65 75 -307 3 ${FightDistance}
	
	Ob_AutoTarget:AddActor["squire",5,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
   		
	call DMove 35 94 -228 ${speed} ${FightDistance}
	call DMove 12 97 -191 ${speed} ${FightDistance}
	oc !c -CampSpot ${Me.Name}
	oc !c -joustin ${Me.Name}
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	oc !c -letsgo ${Me.Name}
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	Me.Inventory["Damaged Rune of Symbiosis"]:Use
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}	
	
function step008()
{	
	variable string Named
	Named:Set["Rallius Rattican"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:CastAbility["${Me.Name}","Singular Focus"]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	call DMove -86 127 -285 3
	call DMove -52 126 -279 3
	
	do
	{
		call ActivateVerbOnPhantomActor Grab 1 5
		call ActivateVerbOnPhantomActor Grab 1 5
		call DMove -52 126 -279 3
		call CountItem "Bileburn Spore"
	}
	while (${Return}<6)
	echo got all spores
	call DMove -92 126 -293 3
	oc !c -CampSpot ${Me.Name}
	oc !c -joustin ${Me.Name}
	OgreBotAPI:Pause["${Me.Name}"]
	target ${Me.Name}
	face "${Named}"
	echo cooling plagues
	if (${Actor["a patron of plagues"].Distance} > 20 && ${Actor["${Named}"].Distance} > 20)
	{
		do
		{
			call PKey MOVEFORWARD 1
		}
		while (${Actor["a patron of plagues"].Distance} > 20 && ${Actor["${Named}"].Distance} > 20)
	} 
	face "${Named}"
	target "a patron of plagues"
	wait 20
	if (${Target.IsAggro})
	{
		OgreBotAPI:UseItem["${Me.Name}","BileBurn Spore"]
		wait 20
	}
	face "${Named}"
	press Tab
	wait 20
	if (${Target.IsAggro})
	{
		OgreBotAPI:UseItem["${Me.Name}","BileBurn Spore"]
		wait 20
	}
	press Tab
	wait 20
	face "${Named}"
	call PKey MOVEFORWARD 2
	if (${Target.IsAggro})
	{
		OgreBotAPI:UseItem["${Me.Name}","BileBurn Spore"]
		wait 20
	}
	face "${Named}"
	press Tab
	wait 20
	if (${Target.IsAggro})
	{
		OgreBotAPI:UseItem["${Me.Name}","BileBurn Spore"]
		wait 20
	}
	press Tab
	face "${Named}"
	call PKey MOVEFORWARD 2
	wait 20
	if (${Target.IsAggro})
	{
		OgreBotAPI:UseItem["${Me.Name}","BileBurn Spore"]
		wait 20
	}
	face "${Named}"
	target "${Named}"
	OgreBotAPI:Resume["${Me.Name}"]
	wait 40
	oc !c -joustout ${Me.Name}
	eq2execute merc backoff
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	echo must kill "${Named}"
	wait 150
	eq2execute merc ranged
	do
	{
		wait 150
		call IsPresent "${Named}"
	}
	while (${Return})
	OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
	oc !c -letsgo ${Me.Name}
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step009()
{	
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -119 129 -256 ${speed}
	
	OgreBotAPI:Special["${Me.Name}"]
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	Me.Inventory["foul-smelling rune"]:Use
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call check_quest "Legacy of Power: Realm of the Plaguebringer"
	if (${Return})
	{
		call CheckQuestStep 2
		if (!${Return})
		{
			do
			{
				call ActivateVerb "foul-smelling rune" -119 129 -256 "Gather"
				call CheckQuestStep 2
			}
			while (!${Return})
		}
	}
	call ActivateVerb "zone_to_valor" -176 129 -270 "Coliseum of Valor" TRUE
	OgreBotAPI:Special["${Me.Name}"]
}

atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	;echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
    if (${Message.Find["begins to overheat"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -40 0 0
	}
	if (${Message.Find["begins to overheat"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -40 0 0
	}
}

atom HandleAllEvents(string Message)
{
	;echo Catch Event ${Message}
	if (${Message.Find["stumbled into a giant latcher"]} > 0)
	{
		echo "Shit!"
		target "pusling leaker"
	}
	if (${Message.Find["Puslings leak out from the giant"]} > 0)
	{
		echo "Shit!!"
		oc !c -CampSpot ${Me.Name}
		oc !c -joustin ${Me.Name}
		target "pusling leaker"
	}
	if (${Message.Find["a giant latcher latches onto you"]} > 0)
	{
		echo "Shit!!!"
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -100 0 0
	}
	if (${Message.Find["The giant latcher recedes back into"]} > 0)
	{
		echo "Pfew!!!!"
		oc !c -letsgo ${Me.Name}
	}
	if (${Message.Find["Planar static increases"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 0 0 -40
	}
	if (${Message.Find["power is even more potent"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 0 0 40
	}
	if (${Message.Find["has killed you"]} > 0 || ${Message.Find["you have died"]} > 0)
	{
		echo "I am dead"
		if ${Script["livedierepeat"](exists)}
			endscript livedierepeat
		run livedierepeat
	}
}
