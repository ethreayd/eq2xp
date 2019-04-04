#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool Detected
variable(script) bool Opened
variable(script) bool KeyOn


function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=7
	oc !c -letsgo ${Me.Name}
	if (!${Script["livedierepeat"](exists)})
		run EQ2Ethreayd/livedierepeat ${NoShiny}
	if ${Script["autopop"](exists)}
		Script["autopop"]:Pause
	 
	if (${setspeed}==0)
	{
		switch ${Me.Archetype}
		{
			case fighter
			{
				echo fighter
				speed:Set[3]
				FightDistance:Set[15]
			}
			break
			case priest
			{
				echo priest
				speed:Set[3]
				FightDistance:Set[15]
			}
			break
			case mage
			{
				echo mage
				speed:Set[1]
				FightDistance:Set[30]
			}
			break
			case scout
			{
				echo scout
				speed:Set[1]
				FightDistance:Set[15]
			}
			break
			default
			{
				echo unknown
				speed:Set[1]
				FightDistance:Set[30]
			}
			break
		}
	}
	else
		speed:Set[${setspeed}]
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 50 ${speed} 
	
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Plane of Innovation: Masks of the Marvelous [Solo]"
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_ActorStanceChange]:AttachAtom[StanceChange]

	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_moveinfront","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	if (${stepstart}==0)
	{
		call IsPresent "Ancient Clockwork Prototype" 500
		if (!${Return})
		{
			stepstart:Set[2]
			call IsPresent "The Glitched Guardian 10101" 500
			if (!${Return})
			{
				call DMove 109 -10 142 3
				call DMove 116 3 3 3
				stepstart:Set[4]
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
	call DMove -59 -10 133 ${speed} ${FightDistance}
}

function step001()
{
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	Ob_AutoTarget:AddActor["Clockwork Prototype XXIV",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Clockwork Prototype XXVII",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Ancient Clockwork Prototype",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	
	call DMove -52 3 6 ${speed} ${FightDistance}
	call DMove -36 3 -65 ${speed} ${FightDistance}
	do
	{
		eq2execute summon
		call CountItem "Ancient Clockwork Hand"
	}
	while (${Return}<1)
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
}	

function step002()
{
	eq2execute merc resume

	call StopHunt
	Ob_AutoTarget:AddActor["Clockwork Scrounger XVII",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove -58 3 11 ${speed} ${FightDistance}
	call DMove -41 -10 137 ${speed} ${FightDistance}
	call DMove 109 -10 142 ${speed} ${FightDistance}
	call DMove 116 3 3 ${speed} ${FightDistance}
	call DMove 78 3 -42 ${speed} ${FightDistance}
	call DMove 43 3 -63 ${speed} ${FightDistance}
	wait 100
	call DMove 33 4 -27 3
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	wait 100
	call CheckCombat ${FightDistance}
	do
	{
		wait 10
		call IsPresent "Clockwork Scrounger XVII"
	}
	while (${Return})
	eq2execute summon
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step003()
{
	variable int Counter=0
	eq2execute merc resume
	
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 71 3 -81 1 ${FightDistance}
	call AutoPassDoor "Junkyard West Door 01" 69 4 -101
	call DMove 48 4 -93 ${speed} ${FightDistance}
	call DMove 60 4 -127 1 ${FightDistance}
	call AutoPassDoor "Junkyard West Door 03" 70 4 -130
	call DMove 92 3 -119 ${speed} ${FightDistance}
	call DMove 95 3 -164 ${speed} ${FightDistance}
	
	eq2execute merc resume
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	oc !c -CampSpot ${Me.Name}
	Ob_AutoTarget:AddActor["prodding gearlet",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["The Glitched Guardian 10101",0,TRUE,FALSE]
	
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 100 0 0
	wait 100
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	do
	{
		wait 10
		call IsPresent "The Glitched Guardian 10101"
	}
	while (${Return})
	oc !c -letsgo ${Me.Name}
	do
	{
		eq2execute summon
		call CountItem "Electro-Charged Clockwork Hand"
		wait 10
		Counter:Inc
	}
	while (${Return}<1 && ${Counter}<5)
	eq2execute summon
	eq2execute merc resume
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 85 3 -128 3 ${FightDistance}
	call DMove 68 4 -127 1 ${FightDistance}
	wait 20
	call AutoPassDoor "Junkyard West Door 03" 51 4 -129
	call DMove 48 4 -93 3 ${FightDistance}
	call DMove 58 4 -96 2 ${FightDistance}
	call DMove 69 4 -101 2 ${FightDistance}
	call DMove 70 4 -90 1 ${FightDistance}
	wait 20
	call AutoPassDoor "Junkyard West Door 01" 70 4 -78
	wait 20
	call DMove 111 3 -30 ${speed} ${FightDistance}
	call DMove 135 3 -44 ${speed} ${FightDistance}
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step004()
{
	eq2execute merc resume
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	wait 50
	call CheckCombat ${FightDistance}
	
	do
	{
		call PetitPas 135 3 -44 3
		call OpenChargedDoor
		call PetitPas 153 3 -62 3
	}	
	while (${Me.Loc.X}<140)
	
	call IsPresent "an erratic clockwork"
	if (${Return} && !${Opened})
	{
		do
		{
			target "an erratic clockwork"
			ExecuteQueued
			call MoveCloseTo "an erratic clockwork"
			wait 20
			ogre qh
			wait 50
			Actor[name,"an erratic clockwork"]:DoubleClick
			wait 300
			ogre end qh
			call IsPresent "an erratic clockwork"
		}
		while (${Return} && !${Opened})
	}
	call StopHunt
	eq2execute summon
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	wait 100
	call DMove 153 3 -62 3 ${FightDistance}
	call DMove 177 4 -66 2 ${FightDistance}
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call DMove 201 -3 -67 1 ${FightDistance}
	Detected:Set[FALSE]
	call WaitByPass "Security Sweeper" -30 -80
	call 2DNav 237 -69
	
	call Follow2D "Security Sweeper" 237 -13 -215 30 TRUE
	if (!${Detected})
	{
		call DMove 237 -13 -219 2 30 TRUE TRUE
	}
	if (!${Detected})
	{
		call DMove 220 -8 -218 2 30 TRUE TRUE
	}
	if (!${Detected})
	{
		call DMove 173 10 -219 3 30 TRUE TRUE
	}
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
	
function step005()
{	
	eq2execute merc resume
	
	if (${Detected})
	{
		do
		{
			wait 300
			call DMove 10 -10 151 3
			call DMove 103 -7 148 3
			call DMove 128 -5 74 3
			call DMove 96 4 24 3
			call DMove 132 3 -40 3
			call DMove 153 3 -62 3 ${FightDistance}
			call DMove 177 4 -66 2 ${FightDistance}
			call DMove 201 -3 -67 1 ${FightDistance}
			Detected:Set[FALSE]
			call WaitByPass "Security Sweeper" -30 -80
			call 2DNav 237 -69
			call Follow2D "Security Sweeper" 237 -13 -215 30 TRUE
			if (!${Detected})
			{
				call DMove 237 -13 -219 2 30 TRUE TRUE
			}
			if (!${Detected})
			{
				call DMove 220 -8 -218 2 30 TRUE TRUE
			}
			if (!${Detected})
			{
				call DMove 173 10 -219 3 30 TRUE TRUE
			}
		}
		while (${Detected})
	}
	eq2execute merc backoff
	eq2execute pet backoff
	oc !c -CampSpot ${Me.Name} 
	eq2execute gsay Set up for Glitched Cell Keeper
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -40 0 0
	Ob_AutoTarget:AddActor["Glitched Cell Keeper",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	do
	{
		wait 300
		eq2execute merc backoff
		eq2execute pet backoff
		call IsPresent "Glitched Cell Keeper"
	}
	while (${Return})
	oc !c -letsgo ${Me.Name}
	eq2execute summon
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute merc ranged
}
	
function step006()
{	
	eq2execute merc resume	
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 125 10 -219 ${speed} ${FightDistance}
	call DMove 118 10 -220 1
	call AutoPassDoor "Junkyard West Door 04" 101 10 -219
	call DMove 82 10 -210 3 ${FightDistance}
	call Converse "Meldrath the Marvelous" 32
	wait 100
	ogre qh
	call Converse "Meldrath the Marvelous" 16
	wait 100
	ogre end qh
	wait 20
	call DMove 91 10 -235 1 ${FightDistance}
	call AutoPassDoor "Junkyard West Door 05" 91 10 -247
	
	call DMove 87 3 -265 ${speed} ${FightDistance}
	call DMove 44 3 -272 ${speed} ${FightDistance}
	call DMove -27 3 -278 ${speed} ${FightDistance}
	call DMove -59 17 -282 1 ${FightDistance}
	call DMove -72 12 -279 1 ${FightDistance}
	call DMove -97 13 -279 1 ${FightDistance}
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
}	
	
function step007()
{	
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call DMove -112 11 -278 1
	Ob_AutoTarget:AddActor["Gearclaw the Collector",0,TRUE,FALSE]
	call DMove -135 8 -278 1
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","TRUE"]
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	call TanknSpank "Gearclaw the Collector"
	
	eq2execute summon
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	call StopHunt
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call DMove -145 10 -251 3
	call ActivateVerb "zone_to_valor" -145 10 -251 "Return to the Entrance" TRUE
	wait 100
	if (${Zone.Name.Equal["Plane of Innovation: Masks of the Marvelous [Solo]"]})
		call ActivateVerb "zone_to_valor" -145 10 -251 "Colisseum of Valor" TRUE
	wait 100
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
	do
	{
		wait 200
		if (${Zone.Name.Equal["Plane of Innovation: Masks of the Marvelous [Solo]"]})
		{
			call DMove -145 10 -251 1
			OgreBotAPI:Special["${Me.Name}"]
		}
	}
	while (${Zone.Name.Equal["Plane of Innovation: Masks of the Marvelous [Solo]"]})
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
	if ${Script["autopop"](exists)}
		Script["autopop"]:Resume
}

function OpenChargedDoor()
{
	variable string PrimaryWeapon
	echo open door with charged hand
	PrimaryWeapon:Set["${Me.Equipment[Primary]}"]
	Me.Inventory["Electro-Charged Clockwork Hand"]:Equip
	wait 20
	call OpenDoor "door_hand_lock"
	wait 20
	call CheckCombat ${FightDistance}
	Me.Inventory["${PrimaryWeapon}"]:Equip
}	
	
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	;echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
    if (${Message.Find["begins to overheat"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -40 0 0
		eq2execute merc backoff
	
	}
	if (${Message.Find["engaging hostile entities"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 40 0 0
		target "The Glitched Guardian 10101"
		eq2execute merc ranged
	}
	if (${Message.Find["BREACH!!! ALERT"]} > 0)
	{
		Detected:Set[TRUE]
		echo "Detected in tunnel - restarting"
	}
	if (${Message.Find["Access granted"]} > 0 || ${Message.Find["Tracking Meldrath"]} > 0 )
	{
		Opened:Set[TRUE]
		echo "Tunnel is now open"
	}
	
	if (${Message.Find["need to turn his key"]} > 0)
	{
		KeyOn:Set[TRUE]
		do
		{
			press MOVEFORWARD
			OgreBotAPI:ApplyVerbForWho["${Me.Name}","${Speaker}","Turn Key"]
		}
		while (${KeyOn})
	}
	
	if (${Message.Find["Collector is energized"]} > 0)
	{
		KeyOn:Set[FALSE]
	}
	if (${Message.Find["Interference of work"]} > 0)
	{
		eq2execute merc backoff
		eq2execute pet backoff
	}
}
 
atom HandleAllEvents(string Message)
{
	;echo Catch Event ${Message}
    if (${Message.Find["have the Electro-Charged"]} > 0)
	{
		echo "Electro-Charged hand swap needed"
		QueueCommand call OpenChargedDoor
	}
	if (${Message.Find["to repair himself"]} > 0)
	{
		eq2execute merc ranged
	}
}
atom StanceChange(string ActorID, string ActorName, string ActorType, string OldStance, string NewStance, string TargetID, string Distance, string IsInGroup, string IsInRaid)
{
    if (${NewStance.Equal["DEAD"]})
	{
		echo "I am dead"
		
	}
}